; Visual-only action page. No installation, registration or service changes.
#include "../issconfig.iss"

[Setup]
AppName=Example Actions
AppVersion=1.0.0
DefaultDirName={tmp}\issconfig-action-example
PrivilegesRequired=lowest
Uninstallable=no
CreateUninstallRegKey=no
OutputDir=output
OutputBaseFilename=example-actions-setup

DisableWelcomePage=yes
DisableDirPage=yes
DisableReadyPage=yes
DisableFinishedPage=yes

[Code]
#define ISSCONFIG_CODE
#include "../issconfig.iss"

procedure PreviewAction(Sender: TObject);
begin
  MsgBox('Preview only: ' + TNewButton(Sender).Caption, mbInformation, MB_OK);
end;

procedure InitializeWizard;
var
  Page: TWizardPage;
begin
  IssConfigInitialize;
  Page := IssConfigCreateActionPage(wpWelcome, 'Example Notes is already installed',
    'Choose what you would like to do with your installation.');
  IssConfigAddPageAction(Page, 'Uninstall', @PreviewAction, False);
  IssConfigAddPageAction(Page, 'Reinstall', @PreviewAction, False);
  IssConfigAddPageAction(Page, 'Launch', @PreviewAction, True);
end;

procedure CurPageChanged(PageID: Integer);
begin
  IssConfigPageChanged(PageID);
end;

procedure DeinitializeSetup;
begin
  IssConfigShutdown;
end;
