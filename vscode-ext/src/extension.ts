import * as vscode from "vscode";

/**
 * Starter-Skelett einer abap2UI5-App, das per Command in den aktiven
 * Editor eingefügt wird.
 */
const APP_TEMPLATE = `CLASS zcl_my_app DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_my_app IMPLEMENTATION.
  METHOD z2ui5_if_app~main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->label( 'Hello abap2UI5' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
`;

export function activate(context: vscode.ExtensionContext): void {
  const newApp = vscode.commands.registerCommand(
    "abap2ui5-demokit.newApp",
    async () => {
      const editor = vscode.window.activeTextEditor;
      if (!editor) {
        vscode.window.showWarningMessage(
          "Bitte zuerst eine (ABAP-)Datei öffnen, in die die Vorlage eingefügt werden soll."
        );
        return;
      }
      await editor.edit((editBuilder) => {
        editBuilder.insert(editor.selection.active, APP_TEMPLATE);
      });
      vscode.window.showInformationMessage("abap2UI5 App-Vorlage eingefügt.");
    }
  );

  const openDemokit = vscode.commands.registerCommand(
    "abap2ui5-demokit.openDemokit",
    async () => {
      await vscode.env.openExternal(
        vscode.Uri.parse("https://github.com/abap2UI5/abap2UI5")
      );
    }
  );

  context.subscriptions.push(newApp, openDemokit);
}

export function deactivate(): void {
  // nichts aufzuräumen
}
