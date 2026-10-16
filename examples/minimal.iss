; Standalone fixture: installs only a text file, with no service or launch actions.
#define IssConfigHeading "Install Example Notes"
#define IssConfigIntroduction "A standalone example of the issconfig visual library."
#ifndef IssConfigFolderSuffix
#define IssConfigFolderSuffix "Example Notes"
#endif
#define IssConfigAccent "A78BFA"
#define IssConfigAccentHover "C4B5FD"
#define IssConfigAccentPressed "8B5CF6"
#define IssConfigLightBackground "FFF8F0"
#define IssConfigDarkBackground "201B2C"
#define IssConfigSupportText "<a id=""help"">About this example</a>"
#include "../issconfig.iss"

[Setup]
AppId=issconfig.example.notes
AppName=Example Notes
AppVersion=1.0.0
DefaultDirName={localappdata}\Example Notes
PrivilegesRequired=lowest
OutputDir=output
OutputBaseFilename=example-notes-setup

#if IssConfigCompact
DisableWelcomePage=yes
DisableDirPage=no
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableFinishedPage=yes
#endif

[Files]
Source: "fixture.txt"; DestDir: "{app}"

[Code]
#define ISSCONFIG_CODE
#include "../issconfig.iss"

procedure ShowExampleHelp(Sender: TObject);
begin
  MsgBox('This example installs only a text file.', mbInformation, MB_OK);
end;

procedure InitializeWizard;
begin
  IssConfigOnSupportLink := @ShowExampleHelp;
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
