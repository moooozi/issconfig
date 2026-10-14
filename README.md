# issconfig

Version 0.1.0. A source library for Inno Setup installer appearance: light/dark
colors, rounded native controls, styled confirmation buttons, an optional compact
destination page and an optional folder browser. Tested with Inno Setup 6.7.3.

This directory is self-contained and can become a separate Git repository.
Consumers can vendor a tagged release; compilation needs no network fetch or
installed plugin. `issconfig.iss` is the only public include. Files under
`internal/` are implementation details.

## Integration

Define overrides before the first include, then include the same public file in
two places: the configuration pass before `[Setup]`, and the code pass inside
`[Code]` with `ISSCONFIG_CODE` defined. Include paths are relative to the consuming
script; internal paths resolve relative to the library.

```iss
#define IssConfigHeading "Install My App"
#define IssConfigIntroduction "Choose where to install My App."
#define IssConfigFolderSuffix "My App"
#include "issconfig/issconfig.iss"

[Setup]
; The consumer supplies normal Inno metadata, payload and installation policy.
AppName=My App
AppVersion=1.0.0
DefaultDirName={autopf}\My App
WizardStyle=modern dynamic hidebevels
WizardBackColor=#{#IssConfigLightBackground}
WizardBackColorDynamicDark=#{#IssConfigDarkBackground}
WizardImageBackColor=#{#IssConfigLightBackground}
WizardImageBackColorDynamicDark=#{#IssConfigDarkBackground}
DisableWelcomePage=yes
DisableDirPage=no
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableFinishedPage=yes

[Code]
#define ISSCONFIG_CODE
#include "issconfig/issconfig.iss"

procedure InitializeWizard;
begin
  IssConfigInitialize;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  IssConfigPageChanged(CurPageID);
end;

procedure DeinitializeSetup;
begin
  IssConfigShutdown;
end;
```

Merge these calls into existing event handlers. Initialization must happen once,
before application-specific positioning; shutdown removes native hooks and
subclasses. The library does not declare Inno event handlers. All library types,
functions and globals have the `IssConfig` prefix; `ISSCONFIG_*` macros are reserved.

## Configuration

All overrides are optional. Colors are six-digit RGB strings without `#`, such
as `"00B9E8"`; the library converts them to Windows COLORREF values internally.

| Defines | Defaults / purpose |
| --- | --- |
| `IssConfigDarkBackground/Surface/Text/Border` | `171717`, `252525`, `F5F5F5`, `404040` |
| `IssConfigLightBackground/Surface/Text/Border` | `F5F5F5`, `FFFFFF`, `171717`, `D4D4D4` |
| `IssConfigDarkButton/Hover/Pressed/Disabled/Muted` | `383838`, `484848`, `303030`, `303030`, `777777` |
| `IssConfigLightButton/Hover/Pressed/Disabled/Muted` | `E5E5E5`, `D4D4D4`, `C5C5C5`, `ECECEC`, `909090` |
| `IssConfigAccent/AccentHover/AccentPressed/AccentText` | `00B9E8`, `65D8F4`, `009DC5`, `000000` |
| `IssConfigLightScrollbar/LightScrollbarHover` | `AAAAAA`, `909090`; dark scrollbars use the dark button colors |
| `IssConfigCompact` | `1`: compact destination-page layout; `0`: keep the standard wizard layout |
| `IssConfigFolderBrowser` | `1`: custom Browse dialog; `0`: keep Inno's original browser |
| `IssConfigHeightPercent` | `70`: compact wizard height as a percentage of its initial height |
| `IssConfigMargin/HeaderHeight` | `24`, `88`: compact header margin and minimum height; grows to fit wrapped text |
| `IssConfigPathHeight/ButtonHeight` | `36`, `32`: path container and wizard button heights |
| `IssConfigHeading/Introduction` | Destination-page heading and description |
| `IssConfigFolderLabel` | `Installation folder` |
| `IssConfigBrowserTitle/BrowserHint` | Folder-dialog title and guidance |
| `IssConfigFolderSuffix` | Empty: selected directory itself; otherwise append this subfolder |
| `IssConfigSupportText` | Empty: optional link-label markup |

Dimensions use Inno's scaling functions. Header labels are measured after page
captions are assigned, and the header grows to fit wrapped headings and descriptions.
The compact preset requires a visible
destination page and the page-disable directives shown above; these directives
remain consumer-owned. Turning the preset off does not change installer navigation.

Text defaults are emitted as `IssConfig*` `[CustomMessages]` entries. For translated
installers, supply language-specific entries with those same keys in the consumer's
`[CustomMessages]` section. Use doubled quotes in preprocessor strings containing
link markup, as demonstrated in `examples/minimal.iss`.

For a support link, supply `IssConfigSupportText` and assign
`IssConfigOnSupportLink := @YourHandler` before initialization. `YourHandler` has
the signature `procedure YourHandler(Sender: TObject)`. The compact layout hides
the link when no handler is assigned. URL selection and browser launching belong
to the consumer. Standard layout consumers can use the lower-level
`IssConfigWrapControl` helper to style their own controls; custom page placement
and link controls remain their responsibility.

## Ownership and behavior

The library owns visual drawing, layout and dialog mechanics. The consumer owns
app identity, version, icon/image files and their `[Setup]` directives, privileges,
architectures, directories, files, shortcuts, navigation policy, service lifecycle,
migration, error reporting, signing and publishing. Native field validation and
scrolling are retained. Folder-tree selection appends the configured suffix;
typed paths are accepted as entered. Cancel preserves the destination field.

High-contrast mode keeps native controls. Unsupported title-bar coloring or
subclass setup falls back to native styling. Dialog hooks are restricted to the
setup process and UI thread. Palette changes preserve Windows' light/dark mode
selection; there is no separate theme switch.

## Validation and versioning

```powershell
& 'C:\Program Files (x86)\Inno Setup 6\ISCC.exe' examples/minimal.iss
python test_compile.py
```

Run from this directory. `ISCC` can point to another compiler path for the test.
Tests copy only this directory into a temporary location and compile several
configurations. They never execute setup or uninstall. The example installs only
a text file if you choose to run it manually.

Compile checks do not verify appearance or accessibility. Before a release,
inspect light/dark and high-contrast modes, 100/150/200% DPI, keyboard focus and
navigation, confirmation dialogs, scrolling and Browse cancellation on Windows.

Use `VERSION` and immutable `vX.Y.Z` tags when publishing. Keep public defines,
message keys and lifecycle routines compatible within a major version; internal
includes may change. Choose a distribution license before publishing this library.
