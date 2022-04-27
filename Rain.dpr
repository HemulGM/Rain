program Rain;

uses
  System.StartUpCopy,
  FMX.Forms,
  Winapi.Windows,
  FMX.Platform.Win,
  Unit1 in 'Unit1.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  ShowWindow(ApplicationHWND, SW_HIDE);
  Application.Run;
end.
