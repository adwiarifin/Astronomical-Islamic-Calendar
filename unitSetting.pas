unit unitSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormSetting = class(TForm)
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSetting: TFormSetting;

implementation

uses unitMain;

{$R *.dfm}

procedure TFormSetting.Button1Click(Sender: TObject);
begin
  if (RadioButton1.Checked) Then
  begin
    FormMain.kfajr := 18;
    FormMain.kisha := 17;
  end;
  if (RadioButton2.Checked) Then
  begin
    FormMain.kfajr := 18;
    FormMain.kisha := 18;
  end;
  if (RadioButton3.Checked) Then
  begin
    FormMain.kfajr := 15;
    FormMain.kisha := 15;
  end;
  if (RadioButton4.Checked) Then
  begin
    FormMain.kfajr := 19.5;
    FormMain.kisha := 17.5;
  end;
  if (RadioButton5.Checked) Then
  begin
    FormMain.kfajr := 20;
    FormMain.kisha := 18;
  end;
  FormMain.Calculate;
  Close;
end;

end.
