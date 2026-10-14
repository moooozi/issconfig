function IssConfigColor(const RGB: String): DWORD;
var
  Value: Integer;
begin
  Value := StrToInt('$' + RGB);
  Result := ((Value and $FF0000) shr 16) or (Value and $00FF00) or
    ((Value and $0000FF) shl 16);
end;

{ Paint the existing buttons; Inno retains navigation, keyboard and click handling.
  Colors come from the public configuration. Native high-contrast controls are retained. }

type
  { Inno Setup 6 runs a 32-bit installer, including on x64 Windows. }
  IssConfigNativeInt = Longint;
  IssConfigTButtonPaint = record
    DC: IssConfigNativeInt;
    Erase: BOOL;
    Rect: TRect;
    Restore: BOOL;
    IncUpdate: BOOL;
    Reserved: array[0..31] of Byte;
  end;
  IssConfigTButtonMouseTrack = record
    Size: DWORD;
    Flags: DWORD;
    Window: HWND;
    HoverTime: DWORD;
  end;
  IssConfigTScrollbarInfo = record
    Size: DWORD;
    Rect: TRect;
    LineButton, ThumbTop, ThumbBottom, Reserved: Integer;
    State: array[0..5] of DWORD;
  end;
  IssConfigTScrollbarPoint = record
    X, Y: Integer;
  end;

function IssConfigSetWindowSubclass(Window: HWND; Callback, ID, Data: IssConfigNativeInt): BOOL;
  external 'SetWindowSubclass@comctl32.dll stdcall';
function IssConfigRemoveWindowSubclass(Window: HWND; Callback, ID: IssConfigNativeInt): BOOL;
  external 'RemoveWindowSubclass@comctl32.dll stdcall';
function IssConfigDefSubclassProc(Window: HWND; Msg: UINT; WParam, LParam: IssConfigNativeInt): IssConfigNativeInt;
  external 'DefSubclassProc@comctl32.dll stdcall';
function IssConfigBeginPaint(Window: HWND; var Paint: IssConfigTButtonPaint): IssConfigNativeInt;
  external 'BeginPaint@user32.dll stdcall';
function IssConfigEndPaint(Window: HWND; const Paint: IssConfigTButtonPaint): BOOL;
  external 'EndPaint@user32.dll stdcall';
function IssConfigGetClientRect(Window: HWND; var Rect: TRect): BOOL;
  external 'GetClientRect@user32.dll stdcall';
function IssConfigFillRect(DC: IssConfigNativeInt; const Rect: TRect; Brush: IssConfigNativeInt): Integer;
  external 'FillRect@user32.dll stdcall';
function IssConfigDrawText(DC: IssConfigNativeInt; Text: String; Length: Integer;
  var Rect: TRect; Flags: UINT): Integer;
  external 'DrawTextW@user32.dll stdcall';
function IssConfigGetFocus: HWND;
  external 'GetFocus@user32.dll stdcall';
function IssConfigNativeSetFocus(Window: HWND): HWND;
  external 'SetFocus@user32.dll stdcall';
function IssConfigTrackMouseEvent(var Track: IssConfigTButtonMouseTrack): BOOL;
  external 'TrackMouseEvent@user32.dll stdcall';
function IssConfigInvalidateRect(Window: HWND; Rect: IssConfigNativeInt; Erase: BOOL): BOOL;
  external 'InvalidateRect@user32.dll stdcall';
function IssConfigCreateSolidBrush(Color: DWORD): IssConfigNativeInt;
  external 'CreateSolidBrush@gdi32.dll stdcall';
function IssConfigCreatePen(Style, Width: Integer; Color: DWORD): IssConfigNativeInt;
  external 'CreatePen@gdi32.dll stdcall';
function IssConfigSelectObject(DC, ObjectHandle: IssConfigNativeInt): IssConfigNativeInt;
  external 'SelectObject@gdi32.dll stdcall';
function IssConfigDeleteObject(ObjectHandle: IssConfigNativeInt): BOOL;
  external 'DeleteObject@gdi32.dll stdcall';
function IssConfigSetTextColor(DC: IssConfigNativeInt; Color: DWORD): DWORD;
  external 'SetTextColor@gdi32.dll stdcall';
function IssConfigSetBkMode(DC: IssConfigNativeInt; Mode: Integer): Integer;
  external 'SetBkMode@gdi32.dll stdcall';
function IssConfigRoundRect(DC: IssConfigNativeInt; Left, Top, Right, Bottom, EllipseWidth,
  EllipseHeight: Integer): BOOL;
  external 'RoundRect@gdi32.dll stdcall';
function IssConfigCreateCompatibleDC(DC: IssConfigNativeInt): IssConfigNativeInt;
  external 'CreateCompatibleDC@gdi32.dll stdcall';
function IssConfigCreateCompatibleBitmap(DC: IssConfigNativeInt; Width, Height: Integer): IssConfigNativeInt;
  external 'CreateCompatibleBitmap@gdi32.dll stdcall';
function IssConfigDeleteDC(DC: IssConfigNativeInt): BOOL;
  external 'DeleteDC@gdi32.dll stdcall';
function IssConfigSetStretchBltMode(DC: IssConfigNativeInt; Mode: Integer): Integer;
  external 'SetStretchBltMode@gdi32.dll stdcall';
function IssConfigSetBrushOrgEx(DC: IssConfigNativeInt; X, Y: Integer; PreviousPoint: IssConfigNativeInt): BOOL;
  external 'SetBrushOrgEx@gdi32.dll stdcall';
function IssConfigStretchBlt(Dest: IssConfigNativeInt; X, Y, Width, Height: Integer;
  Source: IssConfigNativeInt; SourceX, SourceY, SourceWidth, SourceHeight: Integer;
  Operation: DWORD): BOOL;
  external 'StretchBlt@gdi32.dll stdcall';
function IssConfigDwmSetWindowAttribute(Window: HWND; Attribute: DWORD;
  var Value: DWORD; Size: DWORD): Longint;
  external 'DwmSetWindowAttribute@dwmapi.dll stdcall';
function IssConfigNativeWindowText(Window: HWND; Buffer: String; Count: Integer): Integer;
  external 'GetWindowTextW@user32.dll stdcall';
function IssConfigNativeClassName(Window: HWND; Buffer: String; Count: Integer): Integer;
  external 'GetClassNameW@user32.dll stdcall';
function IssConfigNativeWindowStyle(Window: HWND; Index: Integer): Longint;
  external 'GetWindowLongW@user32.dll stdcall';
function IssConfigNativeSetWindowStyle(Window: HWND; Index, Value: Longint): Longint;
  external 'SetWindowLongW@user32.dll stdcall';
function IssConfigNativeSetWindowPos(Window: HWND; After: IssConfigNativeInt; X, Y, Width,
  Height: Integer; Flags: UINT): BOOL;
  external 'SetWindowPos@user32.dll stdcall';
function IssConfigIsWindowEnabled(Window: HWND): BOOL;
  external 'IsWindowEnabled@user32.dll stdcall';
function IssConfigIsWindow(Window: HWND): BOOL;
  external 'IsWindow@user32.dll stdcall';
function IssConfigGetAncestor(Window: HWND; Flags: UINT): HWND;
  external 'GetAncestor@user32.dll stdcall';
function IssConfigNativeParent(Window: HWND): HWND;
  external 'GetParent@user32.dll stdcall';
function IssConfigEnumChildWindows(Window: HWND; Callback, Data: IssConfigNativeInt): BOOL;
  external 'EnumChildWindows@user32.dll stdcall';
function IssConfigEnumThreadWindows(Thread: DWORD; Callback, Data: IssConfigNativeInt): BOOL;
  external 'EnumThreadWindows@user32.dll stdcall';
function IssConfigNativeProcessID: DWORD;
  external 'GetCurrentProcessId@kernel32.dll stdcall';
function IssConfigNativeThreadID: DWORD;
  external 'GetCurrentThreadId@kernel32.dll stdcall';
function IssConfigSetWinEventHook(MinEvent, MaxEvent: DWORD; Module, Callback: IssConfigNativeInt;
  ProcessID, ThreadID, Flags: DWORD): IssConfigNativeInt;
  external 'SetWinEventHook@user32.dll stdcall';
function IssConfigUnhookWinEvent(Hook: IssConfigNativeInt): BOOL;
  external 'UnhookWinEvent@user32.dll stdcall';
function IssConfigNativeScrollbarInfo(Window: HWND; ObjectID: Longint;
  var Info: IssConfigTScrollbarInfo): BOOL;
  external 'GetScrollBarInfo@user32.dll stdcall';
function IssConfigNativeWindowRect(Window: HWND; var Rect: TRect): BOOL;
  external 'GetWindowRect@user32.dll stdcall';
function IssConfigNativeWindowDC(Window: HWND): IssConfigNativeInt;
  external 'GetWindowDC@user32.dll stdcall';
function IssConfigNativeReleaseDC(Window: HWND; DC: IssConfigNativeInt): Integer;
  external 'ReleaseDC@user32.dll stdcall';
function IssConfigNativeCursorPosition(var Point: IssConfigTScrollbarPoint): BOOL;
  external 'GetCursorPos@user32.dll stdcall';
function IssConfigNativeViewportOrigin(DC: IssConfigNativeInt; X, Y: Integer;
  var Previous: IssConfigTScrollbarPoint): BOOL;
  external 'SetViewportOrgEx@gdi32.dll stdcall';

var
  IssConfigStyledButtons: array[0..3] of TNewButton;
  IssConfigButtonCallback: IssConfigNativeInt;
  IssConfigHoveredButton: HWND;
  IssConfigDialogHook, IssConfigDialogCallback, IssConfigDialogChildCallback, IssConfigRemoveCallback,
    IssConfigRemoveThreadCallback: IssConfigNativeInt;
  IssConfigThemeBackground, IssConfigThemeSurface, IssConfigThemeText, IssConfigThemeBorder, IssConfigThemeButton,
    IssConfigThemeHover, IssConfigThemePressed, IssConfigThemeDisabled, IssConfigThemeMuted: DWORD;
  IssConfigPathPanel: TPanel;
  IssConfigPathCallback: IssConfigNativeInt;

function IssConfigWindowCaption(Window: HWND): String;
var
  Count: Integer;
begin
  Result := StringOfChar(#0, 1024);
  Count := IssConfigNativeWindowText(Window, Result, Length(Result));
  SetLength(Result, Count);
end;

procedure IssConfigDrawSmoothShape(DC: IssConfigNativeInt; const Rect: TRect;
  Fill, Edge: DWORD; CornerDiameter: Integer; Backdrop: DWORD);
var
  BufferDC, Bitmap, OldBitmap, Brush, Pen, OldBrush, OldPen, BackgroundBrush: IssConfigNativeInt;
  Bounds: TRect;
  Scale, OldMode: Integer;
begin
  { Supersample only the shape; text stays at native resolution for ClearType. }
  Scale := 4;
  BufferDC := IssConfigCreateCompatibleDC(DC);
  Bitmap := 0;
  if BufferDC <> 0 then
    Bitmap := IssConfigCreateCompatibleBitmap(DC, Rect.Right * Scale, Rect.Bottom * Scale);
  if (BufferDC = 0) or (Bitmap = 0) then begin
    if BufferDC <> 0 then IssConfigDeleteDC(BufferDC);
    BufferDC := DC;
    Scale := 1;
  end;
  OldBitmap := 0;
  if Bitmap <> 0 then OldBitmap := IssConfigSelectObject(BufferDC, Bitmap);
  Bounds.Left := 0;
  Bounds.Top := 0;
  Bounds.Right := Rect.Right * Scale;
  Bounds.Bottom := Rect.Bottom * Scale;
  BackgroundBrush := IssConfigCreateSolidBrush(Backdrop);
  IssConfigFillRect(BufferDC, Bounds, BackgroundBrush);
  IssConfigDeleteObject(BackgroundBrush);
  Brush := IssConfigCreateSolidBrush(Fill);
  Pen := IssConfigCreatePen(0, Scale, Edge);
  OldBrush := IssConfigSelectObject(BufferDC, Brush);
  OldPen := IssConfigSelectObject(BufferDC, Pen);
  try
    IssConfigRoundRect(BufferDC, Scale, Scale, Bounds.Right - Scale, Bounds.Bottom - Scale,
      CornerDiameter * Scale, CornerDiameter * Scale);
    if Bitmap <> 0 then begin
      OldMode := IssConfigSetStretchBltMode(DC, 4); { HALFTONE: average supersampled pixels. }
      IssConfigSetBrushOrgEx(DC, 0, 0, 0);
      IssConfigStretchBlt(DC, 0, 0, Rect.Right, Rect.Bottom, BufferDC, 0, 0,
        Bounds.Right, Bounds.Bottom, $00CC0020);
      IssConfigSetStretchBltMode(DC, OldMode);
    end;
  finally
    IssConfigSelectObject(BufferDC, OldPen);
    IssConfigSelectObject(BufferDC, OldBrush);
    IssConfigDeleteObject(Pen);
    IssConfigDeleteObject(Brush);
    if Bitmap <> 0 then begin
      IssConfigSelectObject(BufferDC, OldBitmap);
      IssConfigDeleteObject(Bitmap);
      IssConfigDeleteDC(BufferDC);
    end;
  end;
end;

procedure IssConfigPaintTreeScrollbars(Window: HWND);
var
  Info: IssConfigTScrollbarInfo;
  Bounds, Bar, Thumb: TRect;
  Cursor, Previous, Ignored: IssConfigTScrollbarPoint;
  ClassName: String;
  Count, ObjectID, ThumbLength, Thickness, X, Y, Background: Integer;
  DC, Brush: IssConfigNativeInt;
  Fill: DWORD;
  Vertical: Boolean;
begin
  ClassName := StringOfChar(#0, 128);
  Count := IssConfigNativeClassName(Window, ClassName, 128);
  SetLength(ClassName, Count);
  if CompareText(ClassName, 'TFolderTreeView') <> 0 then Exit;
  Info.Size := SizeOf(Info);
  if Info.Size <> 60 then Exit;
  IssConfigNativeWindowRect(Window, Bounds);
  IssConfigNativeCursorPosition(Cursor);
  Background := SendMessage(Window, $111F, 0, 0); { TVM_GETBKCOLOR }
  if Background < 0 then Background := IssConfigThemeSurface;
  DC := IssConfigNativeWindowDC(Window);
  if DC = 0 then Exit;
  try
    for ObjectID := -6 to -5 do begin
      if IssConfigNativeScrollbarInfo(Window, ObjectID, Info) then begin
        if (Info.State[0] and $18000) = 0 then begin
          Bar.Left := Info.Rect.Left - Bounds.Left;
          Bar.Top := Info.Rect.Top - Bounds.Top;
          Bar.Right := Info.Rect.Right - Bounds.Left;
          Bar.Bottom := Info.Rect.Bottom - Bounds.Top;
          Brush := IssConfigCreateSolidBrush(Background);
          IssConfigFillRect(DC, Bar, Brush);
          IssConfigDeleteObject(Brush);
          ThumbLength := Info.ThumbBottom - Info.ThumbTop;
          if ThumbLength > 0 then begin
            Vertical := ObjectID = -5;
            Thickness := ScaleX(6);
            if Vertical then begin
              if Thickness > Bar.Right - Bar.Left then Thickness := Bar.Right - Bar.Left;
              X := Bar.Left + (Bar.Right - Bar.Left - Thickness) div 2;
              Y := Bar.Top + Info.ThumbTop;
              Thumb.Right := Thickness;
              Thumb.Bottom := ThumbLength;
            end else begin
              if Thickness > Bar.Bottom - Bar.Top then Thickness := Bar.Bottom - Bar.Top;
              X := Bar.Left + Info.ThumbTop;
              Y := Bar.Top + (Bar.Bottom - Bar.Top - Thickness) div 2;
              Thumb.Right := ThumbLength;
              Thumb.Bottom := Thickness;
            end;
            Thumb.Left := 0;
            Thumb.Top := 0;
            Fill := IssConfigThemeBorder;
            if not IsDarkInstallMode then Fill := IssConfigColor('{#IssConfigLightScrollbar}');
            if (Cursor.X >= Info.Rect.Left) and (Cursor.X < Info.Rect.Right) and
               (Cursor.Y >= Info.Rect.Top) and (Cursor.Y < Info.Rect.Bottom) then begin
              Fill := IssConfigThemeHover;
              if not IsDarkInstallMode then Fill := IssConfigColor('{#IssConfigLightScrollbarHover}');
            end;
            if (Info.State[3] and 8) <> 0 then Fill := IssConfigThemeMuted;
            IssConfigNativeViewportOrigin(DC, X, Y, Previous);
            try
              IssConfigDrawSmoothShape(DC, Thumb, Fill, Fill, Thickness - 2, Background);
            finally
              IssConfigNativeViewportOrigin(DC, Previous.X, Previous.Y, Ignored);
            end;
          end;
        end;
      end;
    end;
  finally
    IssConfigNativeReleaseDC(Window, DC);
  end;
end;

procedure IssConfigPaintButton(Window: HWND; Primary: Boolean);
var
  Paint: IssConfigTButtonPaint;
  Rect: TRect;
  DC, OldFont: IssConfigNativeInt;
  Fill, TextColor, Edge: DWORD;
  Pressed: Boolean;
  Caption: String;
  Flags: UINT;
begin
  DC := IssConfigBeginPaint(Window, Paint);
  try
    IssConfigGetClientRect(Window, Rect);
    Pressed := (SendMessage(Window, $00F2, 0, 0) and 4) <> 0;
    TextColor := IssConfigThemeText;
    if not IssConfigIsWindowEnabled(Window) then begin
      Fill := IssConfigThemeDisabled;
      TextColor := IssConfigThemeMuted;
    end else if Primary then begin
      TextColor := IssConfigColor('{#IssConfigAccentText}');
      if Pressed then Fill := IssConfigColor('{#IssConfigAccentPressed}')
      else if IssConfigHoveredButton = Window then Fill := IssConfigColor('{#IssConfigAccentHover}')
      else Fill := IssConfigColor('{#IssConfigAccent}');
    end else begin
      if Pressed then Fill := IssConfigThemePressed
      else if IssConfigHoveredButton = Window then Fill := IssConfigThemeHover
      else Fill := IssConfigThemeButton;
    end;
    Edge := Fill;
    if (IssConfigGetFocus = Window) and ((SendMessage(Window, $0129, 0, 0) and 1) = 0) then
      Edge := IssConfigThemeText;
    IssConfigDrawSmoothShape(DC, Rect, Fill, Edge, Rect.Bottom - 2, IssConfigThemeBackground);
    OldFont := IssConfigSelectObject(DC, SendMessage(Window, $0031, 0, 0));
    try
      IssConfigSetBkMode(DC, 1);
      IssConfigSetTextColor(DC, TextColor);
      Flags := 1 or 4 or 32;
      if (SendMessage(Window, $0129, 0, 0) and 2) <> 0 then
        Flags := Flags or $100000;
      if (IssConfigNativeWindowStyle(Window, -20) and $2000) <> 0 then
        Flags := Flags or $20000;
      Caption := IssConfigWindowCaption(Window);
      IssConfigDrawText(DC, Caption, -1, Rect, Flags);
    finally
      IssConfigSelectObject(DC, OldFont);
    end;
  finally
    IssConfigEndPaint(Window, Paint);
  end;
end;

function IssConfigButtonProc(Window: HWND; Msg: UINT;
  WParam, LParam, ID, Data: IssConfigNativeInt): IssConfigNativeInt;
var
  Track: IssConfigTButtonMouseTrack;
begin
  if (Msg = $000F) and (Data >= 0) then begin
    IssConfigPaintButton(Window, Data <> 0);
    Result := 0;
    Exit;
  end;
  if Msg = $0200 then begin
    IssConfigHoveredButton := Window;
    Track.Size := SizeOf(Track);
    Track.Flags := 2;
    Track.Window := Window;
    Track.HoverTime := 0;
    IssConfigTrackMouseEvent(Track);
  end else if (Msg = $02A3) and (IssConfigHoveredButton = Window) then
    IssConfigHoveredButton := 0;
  if Msg = $0082 then
    IssConfigRemoveWindowSubclass(Window, IssConfigButtonCallback, ID);
  Result := IssConfigDefSubclassProc(Window, Msg, WParam, LParam);
  if (Data = -1) and ((Msg = $0085) or (Msg = $00A0) or (Msg = $00A1) or
     (Msg = $00A2) or (Msg = $02A2) or
     (Msg = $0114) or (Msg = $0115) or (Msg = $020A) or
     (Msg = $0005) or (Msg = $000F)) then
    IssConfigPaintTreeScrollbars(Window);
  if (Data = -1) and ((Msg = $0007) or (Msg = $0008)) then
    IssConfigInvalidateRect(IssConfigNativeParent(Window), 0, False);
  if (Msg = $0200) or (Msg = $02A3) or (Msg = $0201) or
     (Msg = $0202) or (Msg = $0007) or (Msg = $0008) or
     (Msg = $000A) or (Msg = $00F3) or (Msg = $0128) then
    IssConfigInvalidateRect(Window, 0, False);
end;

function IssConfigPathProc(Window: HWND; Msg: UINT;
  WParam, LParam, ID, Data: IssConfigNativeInt): IssConfigNativeInt;
var
  Paint: IssConfigTButtonPaint;
  Rect: TRect;
  DC: IssConfigNativeInt;
  Edge: DWORD;
  Fill: DWORD;
  ClassName: String;
  Count, TreeColor: Integer;
begin
  if Msg = $000F then begin
    DC := IssConfigBeginPaint(Window, Paint);
    try
      IssConfigGetClientRect(Window, Rect);
      Edge := IssConfigThemeBorder;
      if IssConfigGetFocus = Data then Edge := IssConfigColor('{#IssConfigAccent}');
      Fill := IssConfigThemeSurface;
      ClassName := StringOfChar(#0, 128);
      Count := IssConfigNativeClassName(Data, ClassName, Length(ClassName));
      SetLength(ClassName, Count);
      if CompareText(ClassName, 'TFolderTreeView') = 0 then begin
        { Inno controls the tree palette; match its actual background to avoid seams. }
        TreeColor := SendMessage(Data, $111F, 0, 0); { TVM_GETBKCOLOR }
        if TreeColor >= 0 then Fill := TreeColor;
      end;
      IssConfigDrawSmoothShape(DC, Rect, Fill, Edge, ScaleY(24), IssConfigThemeBackground);
    finally
      IssConfigEndPaint(Window, Paint);
    end;
    Result := 0;
    Exit;
  end;
  if Msg = $0201 then IssConfigNativeSetFocus(Data);
  if Msg = $0082 then IssConfigRemoveWindowSubclass(Window, IssConfigPathCallback, ID);
  Result := IssConfigDefSubclassProc(Window, Msg, WParam, LParam);
end;

function IssConfigWrapControl(Control: TWinControl; Owner: TComponent;
  Height: Integer; IsEdit: Boolean): TPanel;
var
  FontMeasure: TBitmap;
  TextHeight: Integer;
  Edit: TNewEdit;
begin
  Result := nil;
  if IssConfigButtonCallback = 0 then Exit;
  Result := TPanel.Create(Owner);
  Result.Parent := Control.Parent;
  Result.TabOrder := Control.TabOrder;
  Result.Anchors := [akLeft, akTop, akRight];
  if not IsEdit then Result.Anchors := Result.Anchors + [akBottom];
  Result.SetBounds(Control.Left, Control.Top, Control.Width, Height);
  Result.StyleElements := [];
  Result.BevelOuter := bvNone;
  Result.Color := IssConfigThemeBackground;
  Result.TabStop := False;
  Control.Parent := Result;
  if IsEdit then begin
    Edit := TNewEdit(Control);
    Edit.BorderStyle := bsNone;
    Edit.StyleElements := [];
    Edit.Color := IssConfigThemeSurface;
    Edit.Font.Color := IssConfigThemeText;
    { Center the actual text line rather than the edit's default padded height. }
    FontMeasure := TBitmap.Create;
    try
      FontMeasure.Canvas.Font.Assign(Edit.Font);
      TextHeight := FontMeasure.Canvas.TextHeight('Ag');
    finally
      FontMeasure.Free;
    end;
    Edit.AutoSize := False;
    Edit.SetBounds(ScaleX(14), (Height - TextHeight) div 2,
      Result.Width - ScaleX(28), TextHeight);
  end else begin
    Control.StyleElements := Control.StyleElements - [seBorder];
    { Remove the native recessed edge too; seBorder only affects VCL styling. }
    IssConfigNativeSetWindowStyle(Control.Handle, -20,
      IssConfigNativeWindowStyle(Control.Handle, -20) and not $200); { WS_EX_CLIENTEDGE }
    IssConfigNativeSetWindowStyle(Control.Handle, -16,
      IssConfigNativeWindowStyle(Control.Handle, -16) and not $00800000); { WS_BORDER }
    IssConfigNativeSetWindowPos(Control.Handle, 0, 0, 0, 0, 0, $37); { SWP_FRAMECHANGED }
    Control.SetBounds(ScaleX(12), ScaleY(12),
      Result.Width - ScaleX(24), Height - ScaleY(24));
    TFolderTreeView(Control).Anchors := [akLeft, akTop, akRight, akBottom];
    SendMessage(Control.Handle, $111D, 0, IssConfigThemeSurface); { TVM_SETBKCOLOR }
    SendMessage(Control.Handle, $111E, 0, IssConfigThemeText); { TVM_SETTEXTCOLOR }
    SendMessage(Control.Handle, $111B, ScaleY(24), 0); { TVM_SETITEMHEIGHT }
    SendMessage(Control.Handle, $1107, ScaleX(18), 0); { TVM_SETINDENT }
  end;
  if IssConfigPathCallback = 0 then IssConfigPathCallback := CreateCallback(@IssConfigPathProc);
  IssConfigSetWindowSubclass(Result.Handle, IssConfigPathCallback, 1, Control.Handle);
  IssConfigSetWindowSubclass(Control.Handle, IssConfigButtonCallback, 1, -1);
end;

procedure IssConfigInitializePathField;
begin
  IssConfigPathPanel := IssConfigWrapControl(WizardForm.DirEdit, WizardForm, ScaleY({#IssConfigPathHeight}), True);
end;

function IssConfigStyleDialogButton(Window: HWND; Data: IssConfigNativeInt): BOOL;
var
  ClassName: String;
  Count, ButtonKind: Integer;
  Style, Primary: Longint;
begin
  Result := True;
  if not IssConfigIsWindow(Window) then Exit;
  ClassName := StringOfChar(#0, 128);
  Count := IssConfigNativeClassName(Window, ClassName, Length(ClassName));
  SetLength(ClassName, Count);
  ClassName := Uppercase(ClassName);
  if (ClassName <> 'BUTTON') and (ClassName <> 'TNEWBUTTON') and
     (ClassName <> 'TBUTTON') then Exit;
  Style := IssConfigNativeWindowStyle(Window, -16);
  ButtonKind := Style and $F;
  { Leave checkboxes, radio buttons, image buttons and command links intact. }
  if (ButtonKind > 1) or ((Style and $C0) <> 0) or
     (IssConfigWindowCaption(Window) = '') then Exit;
  Primary := 0;
  if (ButtonKind = 1) or (Window = IssConfigStyledButtons[0].Handle) then Primary := 1;
  if IssConfigSetWindowSubclass(Window, IssConfigButtonCallback, 1, Primary) then
    IssConfigInvalidateRect(Window, 0, False)
  else
    Log('Unable to apply issconfig button styling; native styling retained.');
end;

procedure IssConfigDialogShown(Hook: IssConfigNativeInt; Event: DWORD; Window: HWND;
  ObjectID, ChildID: Longint; ThreadID, Time: DWORD);
var
  CaptionColor: DWORD;
begin
  if (ObjectID <> 0) or (ChildID <> 0) then Exit;
  if not IssConfigIsWindow(Window) then Exit;
  { Hook is restricted to this installer's process AND UI thread. }
  IssConfigStyleDialogButton(Window, 0);
  IssConfigEnumChildWindows(Window, IssConfigDialogChildCallback, 0);
  if IssConfigGetAncestor(Window, 2) = Window then begin
    CaptionColor := IssConfigThemeBackground;
    IssConfigDwmSetWindowAttribute(Window, 35, CaptionColor, SizeOf(CaptionColor));
    CaptionColor := IssConfigThemeText;
    IssConfigDwmSetWindowAttribute(Window, 36, CaptionColor, SizeOf(CaptionColor));
  end;
end;

function IssConfigRemoveButtonTheme(Window: HWND; Data: IssConfigNativeInt): BOOL;
begin
  IssConfigRemoveWindowSubclass(Window, IssConfigButtonCallback, 1);
  if IssConfigPathCallback <> 0 then IssConfigRemoveWindowSubclass(Window, IssConfigPathCallback, 1);
  Result := True;
end;

function IssConfigRemoveDialogTheme(Window: HWND; Data: IssConfigNativeInt): BOOL;
begin
  IssConfigEnumChildWindows(Window, IssConfigRemoveCallback, 0);
  Result := True;
end;

procedure IssConfigShutdownTheme;
begin
  if IssConfigDialogHook <> 0 then begin
    IssConfigUnhookWinEvent(IssConfigDialogHook);
    IssConfigDialogHook := 0;
  end;
  if IssConfigButtonCallback <> 0 then begin
    IssConfigRemoveCallback := CreateCallback(@IssConfigRemoveButtonTheme);
    IssConfigRemoveThreadCallback := CreateCallback(@IssConfigRemoveDialogTheme);
    IssConfigEnumThreadWindows(IssConfigNativeThreadID, IssConfigRemoveThreadCallback, 0);
  end;
end;

procedure IssConfigInitializeTheme;
var
  I, Difference: Integer;
  CaptionColor: DWORD;
  Paint: IssConfigTButtonPaint;
  Track: IssConfigTButtonMouseTrack;
begin
  if HighContrastActive then Exit;
  if IsDarkInstallMode then begin
    IssConfigThemeBackground := IssConfigColor('{#IssConfigDarkBackground}');
    IssConfigThemeSurface := IssConfigColor('{#IssConfigDarkSurface}');
    IssConfigThemeText := IssConfigColor('{#IssConfigDarkText}');
    IssConfigThemeBorder := IssConfigColor('{#IssConfigDarkBorder}');
    IssConfigThemeButton := IssConfigColor('{#IssConfigDarkButton}');
    IssConfigThemeHover := IssConfigColor('{#IssConfigDarkHover}');
    IssConfigThemePressed := IssConfigColor('{#IssConfigDarkPressed}');
    IssConfigThemeDisabled := IssConfigColor('{#IssConfigDarkDisabled}');
    IssConfigThemeMuted := IssConfigColor('{#IssConfigDarkMuted}');
  end else begin
    IssConfigThemeBackground := IssConfigColor('{#IssConfigLightBackground}');
    IssConfigThemeSurface := IssConfigColor('{#IssConfigLightSurface}');
    IssConfigThemeText := IssConfigColor('{#IssConfigLightText}');
    IssConfigThemeBorder := IssConfigColor('{#IssConfigLightBorder}');
    IssConfigThemeButton := IssConfigColor('{#IssConfigLightButton}');
    IssConfigThemeHover := IssConfigColor('{#IssConfigLightHover}');
    IssConfigThemePressed := IssConfigColor('{#IssConfigLightPressed}');
    IssConfigThemeDisabled := IssConfigColor('{#IssConfigLightDisabled}');
    IssConfigThemeMuted := IssConfigColor('{#IssConfigLightMuted}');
  end;
  { Use the Windows frame rather than the VCL style's fixed gray frame.
    Windows 11 supports an exact caption color; older Windows keeps its native frame. }
  CaptionColor := IssConfigThemeBackground;
  if IssConfigDwmSetWindowAttribute(WizardForm.Handle, 35, CaptionColor, SizeOf(CaptionColor)) <> 0 then
    Log('Custom caption color unavailable; native Windows title bar retained.');
  CaptionColor := IssConfigThemeText;
  IssConfigDwmSetWindowAttribute(WizardForm.Handle, 36, CaptionColor, SizeOf(CaptionColor));
  { Validate Win32 record layout before installing callbacks. }
  if (SizeOf(Paint) <> 64) or (SizeOf(Track) <> 16) then begin
    Log('Unexpected Win32 structure layout; native button styling retained.');
    Exit;
  end;
  IssConfigStyledButtons[0] := WizardForm.NextButton;
  IssConfigStyledButtons[1] := WizardForm.BackButton;
  IssConfigStyledButtons[2] := WizardForm.CancelButton;
  IssConfigStyledButtons[3] := WizardForm.DirBrowseButton;
  IssConfigButtonCallback := CreateCallback(@IssConfigButtonProc);
  for I := 0 to 3 do begin
    Difference := ScaleY({#IssConfigButtonHeight}) - IssConfigStyledButtons[I].Height;
    IssConfigStyledButtons[I].Top := IssConfigStyledButtons[I].Top - Difference;
    IssConfigStyledButtons[I].Height := ScaleY({#IssConfigButtonHeight});
    IssConfigStyleDialogButton(IssConfigStyledButtons[I].Handle, 0);
  end;
  IssConfigDialogChildCallback := CreateCallback(@IssConfigStyleDialogButton);
  IssConfigDialogCallback := CreateCallback(@IssConfigDialogShown);
  { EVENT_OBJECT_SHOW, WINEVENT_OUTOFCONTEXT: callbacks run on this UI thread. }
  IssConfigDialogHook := IssConfigSetWinEventHook($8002, $8002, 0, IssConfigDialogCallback,
    IssConfigNativeProcessID, IssConfigNativeThreadID, 0);
  if IssConfigDialogHook = 0 then
    Log('Unable to style installer dialogs; their native buttons are retained.');
end;
