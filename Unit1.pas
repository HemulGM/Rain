unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Ani, FMX.Trayicon.Win, FMX.Menus;

type
  TDrop = class(TRectangle)
  public
    Splash: TCircle;
    constructor Create(AOwner: TComponent); override;
    procedure ResizeCircle;
  end;

  TFormMain = class(TForm)
    Layout1: TLayout;
    FloatAnimation1: TFloatAnimation;
    TrayIcon: TFMXTrayIcon;
    PopupMenuTray: TPopupMenu;
    MenuItemOnTop: TMenuItem;
    MenuItemClose: TMenuItem;
    procedure Layout1Resize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItemCloseClick(Sender: TObject);
    procedure MenuItemOnTopClick(Sender: TObject);
    procedure PopupMenuTrayPopup(Sender: TObject);
  private
    procedure MoveElements;
    procedure RandomRect(Rect: TDrop);
    { Private declarations }
  public    { Public declarations }
  end;

var
  FormMain: TFormMain;


implementation

uses
  System.Threading;

{$R *.fmx}

procedure TFormMain.RandomRect(Rect: TDrop);
begin
  with Rect do
  begin
    Width := Random(4) + 2;
    Height := Random(100) + 180;
    var Clr: TAlphaColor;
    case Random(3) of
      0:
        Clr := $FF32eee6;
      1:
        Clr := $FFd4090c;
      2:
        Clr := $FF30e72e;
    else
      Clr := $FF30e72e;
    end;
    Fill.Gradient.Points.Clear;
    with TGradientPoint(Fill.Gradient.Points.Add) do
    begin
      var Cl := TAlphaColorRec.Create(Clr);
      Cl.A := 0;
      Color := Cl.Color;
      Offset := 0.12;
    end;
    with TGradientPoint(Fill.Gradient.Points.Add) do
    begin
      Color := Clr;
      Offset := 1;
    end;
    ResizeCircle;
  end;
end;

procedure TFormMain.MenuItemCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuItemOnTopClick(Sender: TObject);
begin
  if FormStyle = TFormStyle.StayOnTop then
    FormStyle := TFormStyle.Normal
  else
    FormStyle := TFormStyle.StayOnTop;
end;

procedure TFormMain.MoveElements;
begin
  for var Control in Layout1 do
    with TDrop(Control) do
    begin
      if Position.Y > Layout1.Height then
      begin
        RandomRect(TDrop(Control));
        Position.Y := -Random(40) - Height;
        Position.X := Random(Round(Layout1.Width - 4));
      end
      else
        Position.Y := Position.Y + Layout1.TagFloat + Tag;
      if Position.Y > Layout1.Height - Height then
      begin
        Splash.Position.Y := Height - (Position.Y + Height - Layout1.Height) - 10;
        Splash.Visible := True;
      end;
    end;
end;

procedure TFormMain.PopupMenuTrayPopup(Sender: TObject);
begin
  MenuItemOnTop.IsChecked := FormStyle = TFormStyle.StayOnTop;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  TTask.Run(
    procedure
    begin
      while not Application.Terminated do
      begin
        TThread.Synchronize(nil, MoveElements);
        Sleep(10);
      end;
    end);
end;

procedure TFormMain.Layout1Resize(Sender: TObject);
begin
  var Count := Round(Layout1.Width / 15);
  while Layout1.ControlsCount < Count do
  begin
    var Rect := TDrop.Create(Layout1);
    Rect.Parent := Layout1;
    Rect.XRadius := 2;
    Rect.YRadius := 2;
    Rect.Stroke.Kind := TBrushKind.None;
    Rect.Fill.Kind := TBrushKind.Gradient;
    Rect.Tag := Random(40) + 15;
    Rect.HitTest := False;
    with Rect do
    begin
      RandomRect(Rect);
      Position.Y := Random(Round(Layout1.Height)) - Height;
      Position.X := Random(Round(Layout1.Width - 4));
    end;
  end;
  while Layout1.ControlsCount > Count do
    Layout1.Controls[0].Free;
end;

{ TDrop }

constructor TDrop.Create(AOwner: TComponent);
begin
  inherited;
  Splash := TCircle.Create(Self);
  Splash.Size.Size := TSizeF.Create(10, 10);
  Splash.Parent := Self;
  Splash.Stroke.Kind := TBrushKind.None;
  Splash.HitTest := False;
end;

procedure TDrop.ResizeCircle;
begin
  Splash.Position.Point := TPointF.Create(Size.Width / 2 - Splash.Width / 2, Size.Height - Splash.Height / 2);
  Splash.Fill.Color := Self.Fill.Gradient.Points.Points[Self.Fill.Gradient.Points.Count - 1].Color;
  Splash.Visible := False;
end;

end.

