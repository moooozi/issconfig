{ A single setup page, using Inno's destination controls and validation. }

var
  IssConfigDiskSpaceNote: TNewStaticText;
  IssConfigOnSupportLink: TNotifyEvent;

procedure IssConfigSupportLinkClicked(Sender: TObject; const Link: String; LinkType: TSysLinkType);
begin
  if IssConfigOnSupportLink <> nil then IssConfigOnSupportLink(Sender);
end;

procedure IssConfigInitializeLayout;
var
  HeaderDifference, Margin, TextWidth, PathLeft, PathTop, PathHeight: Integer;
  SupportLink: TNewLinkLabel;
begin
  WizardForm.Height := WizardForm.Height * {#IssConfigHeightPercent} div 100;
  Margin := ScaleX({#IssConfigMargin});
  HeaderDifference := ScaleY({#IssConfigHeaderHeight}) - WizardForm.MainPanel.Height;
  WizardForm.MainPanel.Height := WizardForm.MainPanel.Height + HeaderDifference;
  WizardForm.InnerNotebook.Top := WizardForm.InnerNotebook.Top + HeaderDifference;
  WizardForm.InnerNotebook.Height := WizardForm.InnerNotebook.Height - HeaderDifference;

  WizardForm.WizardSmallBitmapImage.SetBounds(
    WizardForm.MainPanel.Width - Margin - ScaleX(48), ScaleY(20), ScaleX(48), ScaleY(48));
  TextWidth := WizardForm.WizardSmallBitmapImage.Left - Margin - ScaleX(16);
  WizardForm.PageNameLabel.SetBounds(Margin, ScaleY(18), TextWidth, ScaleY(34));
  WizardForm.PageNameLabel.Font.Size := 22;
  WizardForm.PageNameLabel.Font.Style := [fsBold];
  WizardForm.PageDescriptionLabel.SetBounds(Margin, ScaleY(60), TextWidth, ScaleY(24));
  WizardForm.PageDescriptionLabel.WordWrap := True;

  WizardForm.SelectDirBitmapImage.Visible := False;
  WizardForm.SelectDirBrowseLabel.Visible := False;
  WizardForm.SelectDirLabel.Left := WizardForm.DirEdit.Left;
  WizardForm.SelectDirLabel.Top := ScaleY(12);
  WizardForm.SelectDirLabel.Caption := CustomMessage('IssConfigFolderLabel');
  WizardForm.SelectDirLabel.Font.Style := [fsBold];
  WizardForm.SelectDirLabel.AdjustHeight;
  WizardForm.DirEdit.Top := WizardForm.SelectDirLabel.Top +
    WizardForm.SelectDirLabel.Height + ScaleY(12);
  PathLeft := WizardForm.DirEdit.Left;
  PathTop := WizardForm.DirEdit.Top;
  IssConfigInitializePathField;
  PathHeight := WizardForm.DirEdit.Height;
  if IssConfigPathPanel <> nil then PathHeight := IssConfigPathPanel.Height;
  WizardForm.DirBrowseButton.Top := PathTop +
    (PathHeight - WizardForm.DirBrowseButton.Height) div 2;

  SupportLink := TNewLinkLabel.Create(WizardForm);
  SupportLink.Parent := WizardForm.SelectDirLabel.Parent;
  SupportLink.AutoSize := False;
  SupportLink.SetBounds(PathLeft, PathTop + PathHeight + ScaleY(20),
    WizardForm.SelectDirBrowseLabel.Width, ScaleY(40));
  SupportLink.Caption := CustomMessage('IssConfigSupportText');
  SupportLink.UseVisualStyle := HighContrastActive;
  SupportLink.OnLinkClick := @IssConfigSupportLinkClicked;
  SupportLink.AdjustHeight;
  SupportLink.Visible := (IssConfigOnSupportLink <> nil) and
    (CustomMessage('IssConfigSupportText') <> '');

  { Keep Inno's calculated space requirement, but place it beside the actions. }
  IssConfigDiskSpaceNote := TNewStaticText(WizardForm.FindComponent('FDiskSpaceLabel'));
  if IssConfigDiskSpaceNote <> nil then begin
    IssConfigDiskSpaceNote.Parent := WizardForm;
    IssConfigDiskSpaceNote.Anchors := [akLeft, akBottom];
    IssConfigDiskSpaceNote.SetBounds(WizardForm.InnerNotebook.Left + PathLeft,
      WizardForm.CancelButton.Top +
        (WizardForm.CancelButton.Height - IssConfigDiskSpaceNote.Height) div 2,
      WizardForm.NextButton.Left - WizardForm.InnerNotebook.Left - PathLeft - ScaleX(16),
      IssConfigDiskSpaceNote.Height);
  end;
end;

procedure IssConfigUpdatePage(CurPageID: Integer);
begin
  if IssConfigDiskSpaceNote <> nil then IssConfigDiskSpaceNote.Visible := CurPageID = wpSelectDir;
  if CurPageID = wpSelectDir then begin
    WizardForm.PageNameLabel.Caption := CustomMessage('IssConfigHeading');
    WizardForm.PageDescriptionLabel.Caption :=
      CustomMessage('IssConfigIntroduction');
    WizardForm.NextButton.Caption := SetupMessage(msgButtonInstall);
  end;
end;
