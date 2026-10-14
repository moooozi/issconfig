{ Inno's own folder tree and path editor, in a dialog matching the setup page. }

var
  IssConfigFolderPath: TNewPathEdit;
  IssConfigFolderTree: TFolderTreeView;
  IssConfigFolderOK: TNewButton;

procedure IssConfigFolderTreeChanged(Sender: TObject);
begin
  if IssConfigFolderTree.Directory <> '' then
    IssConfigFolderPath.Text := AddBackslash(IssConfigFolderTree.Directory) + CustomMessage('IssConfigFolderSuffix');
end;

procedure IssConfigFolderPathChanged(Sender: TObject);
begin
  IssConfigFolderOK.Enabled := Trim(IssConfigFolderPath.Text) <> '';
end;

procedure IssConfigBrowseFolder(Sender: TObject);
var
  Dialog: TSetupForm;
  Hint: TNewStaticText;
  CancelButton: TNewButton;
  RoundedPanel: TPanel;
  InitialPath: String;
  ButtonWidth, ButtonHeight, ButtonTop, CancelLeft: Integer;
begin
  { Match Inno's SelectFolderForm design dimensions and automatic sizing.
    CreateCustomForm applies font/DPI scaling itself; do not scale twice. }
  Dialog := CreateCustomForm(349, 337, False, False);
  try
    Dialog.Caption := CustomMessage('IssConfigBrowserTitle');
    Hint := TNewStaticText.Create(Dialog);
    Hint.Parent := Dialog;
    Hint.SetBounds(ScaleX(20), ScaleY(20), Dialog.ClientWidth - ScaleX(40), ScaleY(20));
    Hint.Caption := CustomMessage('IssConfigBrowserHint');

    ButtonWidth := Dialog.CalculateButtonWidth([
      SetupMessage(msgButtonOK), SetupMessage(msgButtonCancel)]);
    ButtonHeight := ScaleY(23);
    ButtonTop := Dialog.ClientHeight - ScaleY(20) - ButtonHeight;
    CancelLeft := Dialog.ClientWidth - ScaleX(20) - ButtonWidth;
    IssConfigFolderOK := TNewButton.Create(Dialog);
    IssConfigFolderOK.Parent := Dialog;
    IssConfigFolderOK.SetBounds(CancelLeft - ScaleX(6) - ButtonWidth, ButtonTop,
      ButtonWidth, ButtonHeight);
    IssConfigFolderOK.Caption := SetupMessage(msgButtonOK);
    IssConfigFolderOK.Default := True;
    IssConfigFolderOK.ModalResult := mrOK;
    IssConfigFolderOK.Anchors := [akRight, akBottom];
    CancelButton := TNewButton.Create(Dialog);
    CancelButton.Parent := Dialog;
    CancelButton.SetBounds(CancelLeft, ButtonTop, ButtonWidth, ButtonHeight);
    CancelButton.Caption := SetupMessage(msgButtonCancel);
    CancelButton.Cancel := True;
    CancelButton.ModalResult := mrCancel;
    CancelButton.Anchors := [akRight, akBottom];

    IssConfigFolderPath := TNewPathEdit.Create(Dialog);
    IssConfigFolderPath.Parent := Dialog;
    IssConfigFolderPath.SetBounds(ScaleX(20), ScaleY(52), Dialog.ClientWidth - ScaleX(40), ScaleY({#IssConfigPathHeight}));
    IssConfigFolderPath.Anchors := [akLeft, akTop, akRight];
    IssConfigFolderPath.Text := WizardForm.DirEdit.Text;
    IssConfigFolderPath.OnChange := @IssConfigFolderPathChanged;
    RoundedPanel := IssConfigWrapControl(IssConfigFolderPath, Dialog, ScaleY({#IssConfigPathHeight}), True);
    if RoundedPanel <> nil then RoundedPanel.TabOrder := 0
    else IssConfigFolderPath.TabOrder := 0;

    IssConfigFolderTree := TFolderTreeView.Create(Dialog);
    IssConfigFolderTree.Parent := Dialog;
    IssConfigFolderTree.SetBounds(ScaleX(20), ScaleY(104), Dialog.ClientWidth - ScaleX(40),
      IssConfigFolderOK.Top - ScaleY(120));
    IssConfigFolderTree.Anchors := [akLeft, akTop, akRight, akBottom];
    RoundedPanel := IssConfigWrapControl(IssConfigFolderTree, Dialog, IssConfigFolderTree.Height, False);
    if RoundedPanel <> nil then RoundedPanel.TabOrder := 1
    else IssConfigFolderTree.TabOrder := 1;
    { Initialize before attaching OnChange, preserving the exact typed path. }
    InitialPath := RemoveBackslashUnlessRoot(IssConfigFolderPath.Text);
    if CustomMessage('IssConfigFolderSuffix') <> '' then
      InitialPath := ExtractFileDir(InitialPath);
    IssConfigFolderTree.ChangeDirectory(InitialPath, True);
    IssConfigFolderTree.OnChange := @IssConfigFolderTreeChanged;
    IssConfigFolderOK.Enabled := Trim(IssConfigFolderPath.Text) <> '';
    IssConfigFolderOK.TabOrder := 2;
    CancelButton.TabOrder := 3;
    IssConfigFolderPath.TabOrder := 0;
    Dialog.ActiveControl := IssConfigFolderTree;
    Dialog.FlipAndCenterIfNeeded(True, WizardForm, False);
    if Dialog.ShowModal = mrOK then
      WizardForm.DirEdit.Text := Trim(IssConfigFolderPath.Text);
  finally
    Dialog.Free;
    IssConfigFolderPath := nil;
    IssConfigFolderTree := nil;
    IssConfigFolderOK := nil;
  end;
end;

procedure IssConfigInitializeFolderBrowser;
begin
  WizardForm.DirBrowseButton.OnClick := @IssConfigBrowseFolder;
end;
