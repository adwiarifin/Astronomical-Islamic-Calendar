unit unitMonthSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormMonthSelect = class(TForm)
    rbMasehi: TRadioButton;
    rbHijriah: TRadioButton;
    lbTahun: TLabel;
    lbBulan: TLabel;
    cbTahun: TComboBox;
    cbBulan: TComboBox;
    btOK: TButton;
    ProgressBar1: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure rbMasehiClick(Sender: TObject);
    procedure rbHijriahClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure generate;
  public
    { Public declarations }
  end;

var
  FormMonthSelect: TFormMonthSelect;

implementation

uses unitMain, unitMonthlySchedule;

{$R *.dfm}

procedure TFormMonthSelect.generate;
var
  y,m,d,i: word;
  jd: real;
begin
  DecodeDate(Date, y, m, d);
  jd := FormMain.MasehiToJD(d,m,y);

  // jika lewat masehi
  if (rbMasehi.Checked) then
  begin
    FormMain.JDToMasehi(jd, d, m, y);
    cbBulan.Items.Clear;
    cbBulan.Items.Add('Januari');
    cbBulan.Items.Add('Februari');
    cbBulan.Items.Add('Maret');
    cbBulan.Items.Add('April');
    cbBulan.Items.Add('Mei');
    cbBulan.Items.Add('Juni');
    cbBulan.Items.Add('Juli');
    cbBulan.Items.Add('Agustus');
    cbBulan.Items.Add('September');
    cbBulan.Items.Add('Oktober');
    cbBulan.Items.Add('November');
    cbBulan.Items.Add('Desember');
    cbBulan.ItemIndex := (m-1);
  end;

  // jika lewat hijriah
  if (rbHijriah.Checked) then
  begin
    FormMain.JDToHijri(jd, d, m, y);
    cbBulan.Items.Clear;
    cbBulan.Items.Add('Muharram');
    cbBulan.Items.Add('Shafar');
    cbBulan.Items.Add('Rabi''ul Awwal');
    cbBulan.Items.Add('Rabi''ul Akhir');
    cbBulan.Items.Add('Jumadil Awwal');
    cbBulan.Items.Add('Jumadil Akhir');
    cbBulan.Items.Add('Rajab');
    cbBulan.Items.Add('Sya''ban');
    cbBulan.Items.Add('Ramadhan');
    cbBulan.Items.Add('Syawwal');
    cbBulan.Items.Add('Dzulqa''dah');
    cbBulan.Items.Add('Dzulhijjah');
    cbBulan.ItemIndex := (m-1);
  end;

  // generate tahun dari tahun sekarang-10
  // hingga tahun sekarang+10
  cbTahun.Items.Clear;
  for i:= y-10 to y+10 do
  begin
    cbTahun.Items.Add(IntToStr(i));
  end;
  cbTahun.ItemIndex := 10;
end;

procedure TFormMonthSelect.FormShow(Sender: TObject);
begin
  generate;
  Left:=(Screen.Width-Width)  div 2;
  Top:=(Screen.Height-Height) div 2;
end;

procedure TFormMonthSelect.rbMasehiClick(Sender: TObject);
begin
  generate;
end;

procedure TFormMonthSelect.rbHijriahClick(Sender: TObject);
begin
  generate;
end;

procedure TFormMonthSelect.btOKClick(Sender: TObject);
begin
  Close;
  FormMonthlySchedule.year := StrToInt(cbTahun.Text);
  FormMonthlySchedule.month := cbBulan.ItemIndex + 1;
  if rbMasehi.Checked then
    FormMonthlySchedule.mode := true
  else if rbHijriah.Checked then
    FormMonthlySchedule.mode := false;
  FormMonthlySchedule.generate;
  FormMonthlySchedule.ShowModal;
end;

end.
