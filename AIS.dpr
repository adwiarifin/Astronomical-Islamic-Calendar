program AIS;

uses
  Forms,
  unitMain in 'unitMain.pas' {FormMain},
  unitAbout in 'unitAbout.pas' {FormAbout},
  unitSetting in 'unitSetting.pas' {FormSetting},
  unitMonthSetting in 'unitMonthSetting.pas' {FormMonthSelect},
  unitMonthlySchedule in 'unitMonthlySchedule.pas' {FormMonthlySchedule},
  unitNewMoon in 'unitNewMoon.pas' {FormNewMoon},
  unitConvertJD in 'unitConvertJD.pas' {FormConvertJD};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormSetting, FormSetting);
  Application.CreateForm(TFormMonthSelect, FormMonthSelect);
  Application.CreateForm(TFormMonthlySchedule, FormMonthlySchedule);
  Application.CreateForm(TFormNewMoon, FormNewMoon);
  Application.CreateForm(TFormConvertJD, FormConvertJD);
  Application.Run;
end.
