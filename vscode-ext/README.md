# abap2UI5 Demokit Helper (VS Code Extension)

Eine kleine VS-Code-Extension mit Snippets und Befehlen rund um abap2UI5.
Gedacht zum **privaten Teilen** (du + Freunde) – ganz **ohne Marketplace**.

## Features

- **F9 startet die App** – Steht der Cursor in einer ABAP-Klasse, die
  `z2ui5_if_app` implementiert, öffnet **F9** die App **unten im Panel**
  (neben Terminal/Output) in einem eingebetteten Browser.
  Ist die Klasse *keine* z2ui5-App, verhält sich F9 wie gewohnt
  (Breakpoint umschalten).
- **Command "abap2UI5: Neue App-Vorlage einfügen"** – App-Klassen-Skelett.
- **Command "abap2UI5: Demokit im Browser öffnen"** – öffnet das abap2UI5-Repo.
- **Snippets** (in ABAP-Dateien): `z2ui5app`, `z2ui5button`.

Befehle findest du über die Command Palette (`Ctrl/Cmd + Shift + P`).

## Einrichtung der Launch-URL

Beim ersten F9 wirst du nach der Launch-URL gefragt. `{class}` ist der
Platzhalter für den Klassennamen, z. B.:

```
https://host:44300/sap/bc/z2ui5?app_start={class}&sap-client=100
```

Die URL wird gespeichert und lässt sich jederzeit ändern:
Settings → `abap2ui5.launchUrlTemplate` (oder in `settings.json`).

> **Wichtig – Einbettung im Panel:** VS Code lädt die Seite per `<iframe>`.
> Sendet dein SAP-Server `X-Frame-Options` / CSP `frame-ancestors` (häufig),
> oder ist das Zertifikat nicht vertrauenswürdig, bleibt der eingebettete
> Bereich leer. Dafür gibt es oben im Panel den Button **"Extern öffnen"**,
> der die App im normalen Browser startet.

---

## Entwickeln

```bash
cd vscode-ext
npm install
npm run compile      # baut dist/extension.js mit esbuild
```

In VS Code den Ordner `vscode-ext` öffnen und **F5** drücken → es startet ein
zweites VS-Code-Fenster (Extension Development Host) mit geladener Extension.

Während der Entwicklung praktisch: `npm run watch` (baut bei jeder Änderung neu).

---

## Als `.vsix` paketieren (zum Verteilen)

```bash
cd vscode-ext
npm install
npm run vsix         # ruft "vsce package --allow-missing-repository" auf
```

Ergebnis: eine Datei wie `abap2ui5-demokit-0.0.1.vsix`. Diese Datei kannst du
per Mail/Cloud/USB an deine Freunde weitergeben. **Kein Marketplace nötig.**

> `vsce` ist als devDependency enthalten; `npm run vsix` nutzt die lokale Version.
> Alternativ global: `npm install -g @vscode/vsce` und dann `vsce package`.

---

## Installieren (für dich & Freunde)

Aus der `.vsix`-Datei – zwei Wege:

**Über die Oberfläche:**
1. Extensions-Panel öffnen (`Ctrl/Cmd + Shift + X`)
2. Oben auf das `…`-Menü → **Install from VSIX…**
3. Die `.vsix`-Datei auswählen

**Über das Terminal:**
```bash
code --install-extension abap2ui5-demokit-0.0.1.vsix
```

**Update** = neue `.vsix` mit höherer Versionsnummer (`version` in `package.json`
hochzählen) bauen und erneut installieren.

---

## Deinstallieren

Extensions-Panel → Extension suchen → **Uninstall**. Oder:

```bash
code --uninstall-extension abap2ui5-local.abap2ui5-demokit
```
