unit unitConvertJD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormConvertJD = class(TForm)
    lbJD: TLabel;
    edJD: TEdit;
    gbResult: TGroupBox;
    lbTanggal: TLabel;
    lbWaktu: TLabel;
    btnExit: TButton;
    btnConvert: TButton;
    edTanggal: TLabel;
    edWaktu: TLabel;
    procedure btnConvertClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConvertJD: TFormConvertJD;

implementation

uses unitMain;

{$R *.dfm}

procedure TFormConvertJD.btnConvertClick(Sender: TObject);
var
  jde,jd,dt: real;
  d,m,y: word;
  sd,sm,sy: string;
begin
  jde := StrToFloat(edJD.Text);
  FormMain.JDToMasehi(jde,d,m,y);
  // 0 in front of single digit
  if(d < 10) then
    sd := '0' + IntToStr(d)
  else
    sd := IntToStr(d);
  if(m < 10) then
    sm := '0' + IntToStr(m)
  else
    sm := IntToStr(m);
  sy := IntToStr(y);
  // end of single digit

  edTanggal.Caption := sd+'/'+sm+'/'+sy;
  jd := 12+(jde - FormMain.MasehiToJD(d,m,y))*24;
  dt := FormMain.Delta(jd);
  //jd := jd - (dt/3600);
  //ShowMessage(FloatToStr(FormMain.MasehiToJD(d,m,y)));
  edWaktu.Caption := FormMain.FormatTime(jd,true);
end;

procedure TFormConvertJD.btnExitClick(Sender: TObject);
begin
  Close;
end;

end.
