import * as vscode from "vscode";
import * as path from "path";

const CONFIG_SECTION = "abap2ui5";
const TEMPLATE_KEY = "launchUrlTemplate";

/** Muss in der Klasse vorkommen, damit F9 die App startet. */
const APP_INTERFACE_RE = /interfaces\s+z2ui5_if_app/i;

/**
 * Panel-View (unten, neben Terminal/Output), der die abap2UI5-App in einem
 * iframe anzeigt. Fällt der iframe (X-Frame-Options / Zertifikat) aus, gibt es
 * einen "Extern öffnen"-Button als Fallback.
 */
class PreviewViewProvider implements vscode.WebviewViewProvider {
  public static readonly viewId = "abap2ui5.preview";

  private view?: vscode.WebviewView;
  private currentUrl?: string;

  resolveWebviewView(view: vscode.WebviewView): void {
    this.view = view;
    view.webview.options = { enableScripts: true };
    view.webview.onDidReceiveMessage((msg) => {
      if (msg?.type === "openExternal" && this.currentUrl) {
        vscode.env.openExternal(vscode.Uri.parse(this.currentUrl));
      }
    });
    this.render();
  }

  /** Zeigt eine URL im Panel an und holt den View in den Vordergrund. */
  async show(url: string): Promise<void> {
    this.currentUrl = url;
    // Öffnet/fokussiert den Panel-View (Command wird automatisch generiert).
    await vscode.commands.executeCommand(`${PreviewViewProvider.viewId}.focus`);
    this.render();
  }

  private render(): void {
    if (!this.view) {
      return;
    }
    this.view.webview.html = this.currentUrl
      ? htmlForUrl(this.currentUrl)
      : placeholderHtml();
  }
}

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function placeholderHtml(): string {
  return `<!DOCTYPE html>
<html lang="de"><head><meta charset="utf-8">
<style>
  body { font-family: var(--vscode-font-family); color: var(--vscode-foreground);
         padding: 12px; }
</style></head>
<body>
  <p>Öffne eine ABAP-Klasse, die <code>z2ui5_if_app</code> implementiert,
     und drücke <b>F9</b>.</p>
</body></html>`;
}

function htmlForUrl(url: string): string {
  const safeUrl = escapeHtml(url);
  return `<!DOCTYPE html>
<html lang="de"><head><meta charset="utf-8">
<meta http-equiv="Content-Security-Policy"
      content="default-src 'none'; frame-src http: https:; style-src 'unsafe-inline'; script-src 'unsafe-inline';">
<style>
  html, body { margin: 0; padding: 0; height: 100%; }
  body { display: flex; flex-direction: column;
         font-family: var(--vscode-font-family); color: var(--vscode-foreground); }
  .bar { display: flex; align-items: center; gap: 8px; padding: 4px 8px;
         border-bottom: 1px solid var(--vscode-panel-border);
         background: var(--vscode-panel-background); font-size: 12px; }
  .bar .url { flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
              opacity: 0.8; }
  .bar button { font: inherit; cursor: pointer;
                color: var(--vscode-button-foreground);
                background: var(--vscode-button-background);
                border: none; padding: 2px 10px; border-radius: 2px; }
  .frame-wrap { flex: 1; position: relative; }
  iframe { border: 0; width: 100%; height: 100%; background: #fff; }
</style></head>
<body>
  <div class="bar">
    <span class="url" title="${safeUrl}">${safeUrl}</span>
    <button onclick="openExt()">Extern öffnen</button>
  </div>
  <div class="frame-wrap">
    <iframe src="${safeUrl}"
            sandbox="allow-forms allow-scripts allow-same-origin allow-popups allow-modals allow-downloads"></iframe>
  </div>
  <script>
    const vscodeApi = acquireVsCodeApi();
    function openExt() { vscodeApi.postMessage({ type: 'openExternal' }); }
  </script>
</body></html>`;
}

/** Ermittelt den globalen Klassennamen (GROSS) aus dem Dokument. */
function resolveClassName(doc: vscode.TextDocument): string {
  const match = doc.getText().match(/class\s+(\S+)\s+definition/i);
  const raw = match
    ? match[1]
    : path
        .basename(doc.fileName)
        .replace(/\.clas\.abap$/i, "")
        .replace(/\.abap$/i, "");
  return raw.toUpperCase();
}

/** Holt die URL-Vorlage aus den Settings oder fragt sie einmalig ab. */
async function ensureTemplate(): Promise<string | undefined> {
  const cfg = vscode.workspace.getConfiguration(CONFIG_SECTION);
  let tpl = cfg.get<string>(TEMPLATE_KEY, "").trim();
  if (tpl) {
    return tpl;
  }
  tpl = (
    (await vscode.window.showInputBox({
      title: "abap2UI5: Launch-URL festlegen",
      prompt: "URL-Vorlage mit {class} als Platzhalter",
      value: "https://host:44300/sap/bc/z2ui5?app_start={class}&sap-client=100",
      ignoreFocusOut: true,
    })) ?? ""
  ).trim();
  if (tpl) {
    await cfg.update(TEMPLATE_KEY, tpl, vscode.ConfigurationTarget.Global);
  }
  return tpl || undefined;
}

async function runApp(provider: PreviewViewProvider): Promise<void> {
  const editor = vscode.window.activeTextEditor;

  // Kein ABAP-Editor oder keine z2ui5-App: normales F9-Verhalten beibehalten.
  if (
    !editor ||
    editor.document.languageId !== "abap" ||
    !APP_INTERFACE_RE.test(editor.document.getText())
  ) {
    await vscode.commands.executeCommand("editor.debug.action.toggleBreakpoint");
    return;
  }

  const className = resolveClassName(editor.document);
  const template = await ensureTemplate();
  if (!template) {
    return;
  }

  const url = template.replace(/\{class\}/gi, encodeURIComponent(className));
  await provider.show(url);
}

export function activate(context: vscode.ExtensionContext): void {
  const provider = new PreviewViewProvider();

  context.subscriptions.push(
    vscode.window.registerWebviewViewProvider(
      PreviewViewProvider.viewId,
      provider
    ),
    vscode.commands.registerCommand("abap2ui5.run", () => runApp(provider)),
    vscode.commands.registerCommand("abap2ui5-demokit.newApp", newApp),
    vscode.commands.registerCommand("abap2ui5-demokit.openDemokit", () =>
      vscode.env.openExternal(
        vscode.Uri.parse("https://github.com/abap2UI5/abap2UI5")
      )
    )
  );
}

const APP_TEMPLATE = `CLASS zcl_my_app DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
ENDCLASS.

CLASS zcl_my_app IMPLEMENTATION.
  METHOD z2ui5_if_app~main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->label( 'Hello abap2UI5' ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
`;

async function newApp(): Promise<void> {
  const editor = vscode.window.activeTextEditor;
  if (!editor) {
    vscode.window.showWarningMessage(
      "Bitte zuerst eine ABAP-Datei öffnen."
    );
    return;
  }
  await editor.edit((b) => b.insert(editor.selection.active, APP_TEMPLATE));
}

export function deactivate(): void {
  // nichts aufzuräumen
}
