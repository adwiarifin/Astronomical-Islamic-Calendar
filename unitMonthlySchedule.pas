unit unitMonthlySchedule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormMonthlySchedule = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function getDayMasehi(M: word; Y: word): word;
    function getDayHijri(M: word; Y: word): word;
  public
    { Public declarations }
    lbJadwal: array[1..31,1..7] of TLabel;
    year: word;
    month: word;
    day: word;
    mode: boolean;
    procedure generate; 
  end;

var
  FormMonthlySchedule: TFormMonthlySchedule;

implementation

uses unitMain, unitMonthSetting;

{$R *.dfm}

function TFormMonthlySchedule.getDayMasehi(M: word; Y: word): word;
begin
  getDayMasehi := 0;
  case M of
    1: getDayMasehi := 31;
    2: if (FormMain.LeapMasehi(Y)) then
         getDayMasehi := 29
       else
         getDayMasehi := 28;
    3: getDayMasehi := 31;
    4: getDayMasehi := 30;
    5: getDayMasehi := 31;
    6: getDayMasehi := 30;
    7: getDayMasehi := 31;
    8: getDayMasehi := 31;
    9: getDayMasehi := 30;
    10: getDayMasehi := 31;
    11: getDayMasehi := 30;
    12: getDayMasehi := 31;
  end;
end;

function TFormMonthlySchedule.getDayHijri(M: word; Y: word): word;
begin
  getDayHijri := 0;
  case M of
    1: getDayHijri := 30;
    2: getDayHijri := 29;
    3: getDayHijri := 30;
    4: getDayHijri := 29;
    5: getDayHijri := 30;
    6: getDayHijri := 29;
    7: getDayHijri := 30;
    8: getDayHijri := 29;
    9: getDayHijri := 30;
    10: getDayHijri := 29;
    11: getDayHijri := 30;
    12: if (FormMain.LeapHijri(Y)) then
          getDayHijri := 30
        else
          getDayHijri := 29;
  end;
end;

procedure TFormMonthlySchedule.generate;
var
  i,j: integer;
  jd: real;
  d,m,y: word;
begin
  // get day
  if mode then
  begin
    // jika mode masehi
    day := getDayMasehi(month, year);
    jd := FormMain.MasehiToJD(1,month,year);
  end
  else
  begin
    // jika mode hijriah
    day := getDayHijri(month, year);
    jd := FormMain.HijriToJD(1,month,year);
  end;

  // prepare progress bar
  FormMonthSelect.ProgressBar1.Visible := True;

  // generate dimulai
  for i:=1 to day do
  begin
    FormMonthSelect.ProgressBar1.Position := Trunc(i*FormMonthSelect.ProgressBar1.Max/day);
    FormMain.gjd := jd + (i-1);
    FormMain.calculate;
    lbJadwal[i,2].Caption := FormMain.edShubuh.Caption;
    lbJadwal[i,3].Caption := FormMain.edTerbit.Caption;
    lbJadwal[i,4].Caption := FormMain.edDzuhur.Caption;
    lbJadwal[i,5].Caption := FormMain.edAshar.Caption;
    lbJadwal[i,6].Caption := FormMain.edMaghrib.Caption;
    lbJadwal[i,7].Caption := FormMain.edIsya.Caption;
    for j:=1 to 7 do
      lbJadwal[i,j].Visible := True;
  end;

  // hide unusued label
  if (day < 31) then
  for i:=(day+1) to 31 do
    for j:=1 to 7 do
      lbJadwal[i,j].Visible := False;

  // set desired form height
  ClientHeight := 34 + day * 16;

  // return the calculated value on main
  DecodeDate(FormMain.cal.Date, y, m, d);
  FormMain.gjd := FormMain.MasehiToJD(d, m, y);
  FormMain.calculate;

  // End progress bar
  FormMonthSelect.ProgressBar1.Visible := False;
end;

procedure TFormMonthlySchedule.FormCreate(Sender: TObject);
var
  i,j: integer;
begin
  // initialize day
  for i:=1 to 31 do
  begin
    lbJadwal[i,1] := TLabel.Create(Self);
    lbJadwal[i,1].Parent := Self;
    lbJadwal[i,1].AutoSize := False;
    lbJadwal[i,1].Width := 30;
    lbJadwal[i,1].Height := 13;
    lbJadwal[i,1].Alignment := taCenter;
    lbJadwal[i,1].Layout := tlCenter;
    lbJadwal[i,1].Top := 29 + (i-1) * 16;
    lbJadwal[i,1].Left := 8;
    lbJadwal[i,1].Caption := IntToStr(i);
    lbJadwal[i,1].Visible := True;
  end;
  // initialize schedule
  for i:=1 to 31 do
    for j:=2 to 7 do
    begin
      lbJadwal[i,j] := TLabel.Create(Self);
      lbJadwal[i,j].Parent := Self;
      lbJadwal[i,j].AutoSize := False;
      lbJadwal[i,j].Width := 45;
      lbJadwal[i,j].Height := 13;
      lbJadwal[i,j].Alignment := taCenter;
      lbJadwal[i,j].Layout := tlCenter;
      lbJadwal[i,j].Top := 29 + (i-1) * 16;
      lbJadwal[i,j].Left := 46 + (j-2) * 53;
      lbJadwal[i,j].Caption := '00:00';
      lbJadwal[i,j].Visible := True;
    end;
end;

procedure TFormMonthlySchedule.FormShow(Sender: TObject);
begin
  Left:=(Screen.Width-Width)  div 2;
  Top:=(Screen.Height-Height) div 2;
end;

end.
