{ Generic custom pages with wizard-aligned footer actions. Application handlers
  own every action; the library owns only placement, focus and appearance. }
type
  IssConfigPageAction = record
    PageID: Integer;
    Button: TNewButton;
    Primary: Boolean;
  end;

var
  IssConfigPageActions: array of IssConfigPageAction;
  IssConfigActionNavigationHidden: Boolean;
  IssConfigActionBackVisible, IssConfigActionNextVisible, IssConfigActionCancelVisible: Boolean;

function IssConfigCreateActionPage(AfterID: Integer; const Heading, Description: String): TWizardPage;
begin
  Result := CreateCustomPage(AfterID, Heading, Description);
end;

function IssConfigAddPageAction(Page: TWizardPage; const Caption: String;
  Handler: TNotifyEvent; Primary: Boolean): TNewButton;
var
  Index: Integer;
  Measure: TBitmap;
  Width: Integer;
begin
  Index := GetArrayLength(IssConfigPageActions);
  SetArrayLength(IssConfigPageActions, Index + 1);
  Result := TNewButton.Create(WizardForm);
  Result.Parent := WizardForm;
  Result.Caption := Caption;
  Result.OnClick := Handler;
  Result.Default := Primary;
  if Primary then Result.TabOrder := 0;
  Result.Anchors := [akRight, akBottom];
  Result.Visible := False;
  Measure := TBitmap.Create;
  try
    Measure.Canvas.Font.Assign(Result.Font);
    Width := Measure.Canvas.TextWidth(Caption) + ScaleX(32);
  finally
    Measure.Free;
  end;
  if Width < WizardForm.CancelButton.Width then Width := WizardForm.CancelButton.Width;
  Result.SetBounds(0, WizardForm.CancelButton.Top, Width, WizardForm.CancelButton.Height);
  IssConfigPageActions[Index].PageID := Page.ID;
  IssConfigPageActions[Index].Button := Result;
  IssConfigPageActions[Index].Primary := Primary;
end;

procedure IssConfigUpdateActionPage(PageID: Integer);
var
  Index, Right, Gap: Integer;
  Active: Boolean;
  Button, PrimaryButton: TNewButton;
begin
  if IssConfigActionNavigationHidden then begin
    WizardForm.BackButton.Visible := IssConfigActionBackVisible;
    WizardForm.NextButton.Visible := IssConfigActionNextVisible;
    WizardForm.CancelButton.Visible := IssConfigActionCancelVisible;
    IssConfigActionNavigationHidden := False;
  end;
  Active := False;
  PrimaryButton := nil;
  Right := WizardForm.CancelButton.Left + WizardForm.CancelButton.Width;
  Gap := WizardForm.CancelButton.Left - WizardForm.NextButton.Left - WizardForm.NextButton.Width;
  if Gap < ScaleX(8) then Gap := ScaleX(8);
  for Index := GetArrayLength(IssConfigPageActions) - 1 downto 0 do begin
    Button := IssConfigPageActions[Index].Button;
    Button.Visible := IssConfigPageActions[Index].PageID = PageID;
    if Button.Visible then begin
      Active := True;
      Button.SetBounds(Right - Button.Width, WizardForm.CancelButton.Top,
        Button.Width, WizardForm.CancelButton.Height);
      Right := Button.Left - Gap;
      Button.Default := IssConfigPageActions[Index].Primary;
      if Button.Default then PrimaryButton := Button;
    end;
  end;
  if not Active then Exit;
  IssConfigActionBackVisible := WizardForm.BackButton.Visible;
  IssConfigActionNextVisible := WizardForm.NextButton.Visible;
  IssConfigActionCancelVisible := WizardForm.CancelButton.Visible;
  IssConfigActionNavigationHidden := True;
  WizardForm.BackButton.Visible := False;
  WizardForm.NextButton.Visible := False;
  WizardForm.CancelButton.Visible := False;
  if PrimaryButton <> nil then
    if PrimaryButton.CanFocus then WizardForm.ActiveControl := PrimaryButton;
  if not HighContrastActive and (IssConfigButtonCallback <> 0) then
    for Index := 0 to GetArrayLength(IssConfigPageActions) - 1 do
      if IssConfigPageActions[Index].PageID = PageID then
        IssConfigStyleDialogButton(IssConfigPageActions[Index].Button.Handle, 0);
end;
