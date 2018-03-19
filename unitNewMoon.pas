unit unitNewMoon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormNewMoon = class(TForm)
    cbTahun: TComboBox;
    llBulan: TListBox;
    mmConsole: TMemo;
    procedure FormShow(Sender: TObject);
    procedure llBulanClick(Sender: TObject);
    procedure cbTahunChange(Sender: TObject);
  private
    { Private declarations }
    procedure calculate;
    function PhaseMoon(k0: integer; n: byte): real;
    function PlanetCorrection(k,T: real): real;
    function NewMoonCorrection(E,M,M1,F,O: real): real;
    function FullMoonCorrection(E,M,M1,F,O: real): real;
    function FirstQuarterMoonCorrection(E,M,M1,F,O: real): real;
    function LastQuarterMoonCorrection(E,M,M1,F,O: real): real;
    function Delta(T: real): real;
    function RealMod (x, y : extended) : extended;
    function FormatDateTime(jd: real): String;
  public
    { Public declarations }
  end;

var
  FormNewMoon: TFormNewMoon;

implementation

uses unitMain, Math;

{$R *.dfm}

procedure TFormNewMoon.calculate;
var
  y,m,k0: integer;
  p1,p2,p3,p4: real;
begin
  // get input
  y := StrToInt(cbTahun.Text);
  m := llBulan.ItemIndex + 1;
  // pre-processing
  k0 := 12*y+m-17050;
  mmConsole.Lines.Clear;
  mmConsole.Lines.BeginUpdate;
  mmConsole.Lines.Add('=== starting calculate ===');
  mmConsole.Lines.Add('y: '+IntToStr(y));
  mmConsole.Lines.Add('m: '+IntToStr(m));
  mmConsole.Lines.Add('k0: '+IntToStr(k0));
  // solving
  p1 := PhaseMoon(k0, 1);
  p2 := PhaseMoon(k0, 2);
  p3 := PhaseMoon(k0, 3);
  p4 := PhaseMoon(k0, 4);
  // end
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('=== calculate end ===');
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('=== Result ===');
  mmConsole.Lines.Add('New Moon: '+FormatDateTime(p1));
  mmConsole.Lines.Add('First Quarter: '+FormatDateTime(p2));
  mmConsole.Lines.Add('Full Moon: '+FormatDateTime(p3));
  mmConsole.Lines.Add('Last Quarter: '+FormatDateTime(p4));
  mmConsole.Lines.EndUpdate;
end;

function TFormNewMoon.PhaseMoon(k0: integer; n: byte): real;
var
  k,T,E,M,M1,F,O,JDE,JDEC,kp,kf,D,JD: real;
begin
  // determine k
  k := 0;
  case n of
    1: k := k0 + 0.00;
    2: k := k0 + 0.25;
    3: k := k0 + 0.50;
    4: k := k0 + 0.75;
  end;
  // calculate dependent var
  T   := k / 1236.85;
  E   := 1-0.002516*T-0.0000074*T*T;
  M   :=   2.5534+ 29.10535669*k-0.0000218*T*T+0.00000011*T*T*T;
  M1  := 201.5643+385.81693528*k+0.0107438*T*T+0.00001239*T*T*T-0.000000058*T*T*T*T;
  F   := 160.7108+390.67050274*k-0.0016341*T*T-0.00000227*T*T*T+0.000000011*T*T*T*T;
  O   := 124.7746-  1.5637558 *k+0.0020691*T*T+0.00000215*T*T*T;
  // recalculate and show in radian
  M   := DegToRad(RealMod(M,360.0));
  M1  := DegToRad(RealMod(M1,360.0));
  F   := DegToRad(RealMod(F,360.0));
  O   := DegToRad(RealMod(O,360.0));
  // hitung faktor koreksi
  kp  := PlanetCorrection(k,T);
  kf  := 0;
  case n of
    1: kf := NewMoonCorrection(E,M,M1,F,O);
    2: kf := FirstQuarterMoonCorrection(E,M,M1,F,O);
    3: kf := FullMoonCorrection(E,M,M1,F,O);
    4: kf := LastQuarterMoonCorrection(E,M,M1,F,O);
  end;
  // get date
  JDE  := 2451550.09765+29.530588853*k+0.0001337*T*T-0.00000015*T*T*T+0.00000000073*T*T*T*T;
  JDEC := JDE + kp + kf;
  D    := Delta(T); // menit
  D    := D / 86400; // hari
  JD   := JDEC - D;

  // debug
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('---- mode '+IntToStr(n)+' ----');
  mmConsole.Lines.Add('k: '+FloatToStr(k));
  mmConsole.Lines.Add('T: '+FloatToStr(T));
  mmConsole.Lines.Add('E: '+FloatToStr(E));
  mmConsole.Lines.Add('M: '+FloatToStr(M));
  mmConsole.Lines.Add('kp: '+FloatToStr(kp));
  mmConsole.Lines.Add('kf: '+FloatToStr(kf));
  mmConsole.Lines.Add('JDE: '+FloatToStr(JDE));
  mmConsole.Lines.Add('JDEC: '+FloatToStr(JDEC));
  mmConsole.Lines.Add('Delta T: '+FloatToStr(D));
  mmConsole.Lines.Add('JD: '+FloatToStr(JD));

  Result := JD;
end;

function TFormNewMoon.PlanetCorrection(k,T: real): real;
var
  A,B: array[1..14] of real;
  i: integer;
  s: real;
begin
  A[1]  := DegToRad(299.77+0.107408*k);
  A[2]  := DegToRad(251.88+0.016321*k);
  A[3]  := DegToRad(251.83+26.651886*k);
  A[4]  := DegToRad(349.42+36.412478*k);
  A[5]  := DegToRad(84.66+18.206239*k);
  A[6]  := DegToRad(141.74+53.303771*k);
  A[7]  := DegToRad(207.14+2.453732*k);
  A[8]  := DegToRad(154.84+7.30686*k);
  A[9]  := DegToRad(34.52+27.261239*k);
  A[10] := DegToRad(207.19+0.121824*k);
  A[11] := DegToRad(291.34+1.844379*k);
  A[12] := DegToRad(161.72+24.198154*k);
  A[13] := DegToRad(239.56+25.513099*k);
  A[14] := DegToRad(331.55+3.592518*k);

  B[1] := 325;
  B[2] := 165;
  B[3] := 164;
  B[4] := 126;
  B[5] := 110;
  B[6] := 62;
  B[7] := 60;
  B[8] := 56;
  B[9] := 47;
  B[10] := 42;
  B[11] := 40;
  B[12] := 37;
  B[13] := 35;
  B[14] := 23;

  s := 0;
  for i := 1 to 14 do
    s := s + B[i] * Sin(A[i]);

  Result := s / 1000000;
end;

function TFormNewMoon.NewMoonCorrection(E,M,M1,F,O: real): real;
begin
  Result :=   (-40720    *SIN(M1)
               +17241*E  *SIN(M)
               + 1608    *SIN(2*M1)
               + 1039    *SIN(2*F)
               +  739*E  *SIN(M1-M)
               -  514*E  *SIN(M1+M)
               +  208*E*E*SIN(2*M)
               -  111    *SIN(M1-2*F)
               -   57    *SIN(M1+2*F)
               +   56*E  *SIN(2*M1+M)
               -   42    *SIN(3*M1)
               +   42*E  *SIN(M+2*F)
               +   38*E  *SIN(M-2*F)
               -   24*E  *SIN(2*M1-M)
               -   17    *SIN(O)
               -    7    *SIN(M1+2*M)
               +    4    *SIN(2*(M1-F))
               +    4    *SIN(3*M)
               +    3    *SIN(M1+M-2*F)
               +    3    *SIN(2*(M1+F))
               -    3    *SIN(M1+M+2*F)
               +    3    *SIN(M1-M+2*F)
               -    2    *SIN(M1-M-2*F)
               -    2    *SIN(3*M1+M)
               +    2    *SIN(4*M1)
              )/100000;
end;

function TFormNewMoon.FullMoonCorrection(E,M,M1,F,O: real): real;
begin
  // uyee
  Result := (-40614    *SIN(M1)
             +17302*E  *SIN(M)
             + 1614    *SIN(2*M1)
             + 1043    *SIN(2*F)
             +  734*E  *SIN(M1-M)
             -  515*E  *SIN(M1+M)
             +  209*E*E*SIN(2*M)
             -  111    *SIN(M1-2*F)
             -   57    *SIN(M1+2*F)
             +   56*E  *SIN(2*M1+M)
             -   42    *SIN(3*M1)
             +   42*E  *SIN(M+2*F)
             +   38*E  *SIN(M-2*F)
             -   24*E  *SIN(2*M1-M)
             -   17    *SIN(O)
             -    7    *SIN(M1+2*M)
             +    4    *SIN(2*(M1-F))
             +    4    *SIN(3*M)
             +    3    *SIN(M1+M-2*F)
             +    3    *SIN(2*(M1+F))
             -    3    *SIN(M1+M+2*F)
             +    3    *SIN(M1-M+2*F)
             -    2    *SIN(M1-M-2*F)
             -    2    *SIN(3*M1+M)
             +    2    *SIN(4*M1)
            )/100000;
end;

function TFormNewMoon.FirstQuarterMoonCorrection(E,M,M1,F,O: real): real;
begin
  // uyee
  Result := (-62801    *SIN(M1)
             +17172*E  *SIN(M)
             +  862    *SIN(2*M1)
             +  804    *SIN(2*F)
             +  454*E  *SIN(M1-M)
             - 1183*E  *SIN(M1+M)
             +  204*E*E*SIN(2*M)
             -  180    *SIN(M1-2*F)
             -   70    *SIN(M1+2*F)
             +   27*E  *SIN(2*M1+M)
             -   40    *SIN(3*M1)
             +   32*E  *SIN(M+2*F)
             +   32*E  *SIN(M-2*F)
             -   34*E  *SIN(2*M1-M)
             -   28*E*E*SIN(M1+2*M)
             -   17    *SIN(O)
             +    2    *SIN(2*(M1-F))
             +    3    *SIN(3*M)
             +    3    *SIN(M1+M-2*F)
             +    4    *SIN(2*(M1+F))
             -    4    *SIN(M1+M+2*F)
             +    2    *SIN(M1-M+2*F)
             -    5    *SIN(M1-M-2*F)
             -    2    *SIN(3*M1+M)
             +    4    *SIN(M1-2*M)

             + 306
             - 38 *E*COS(M)
             + 26   *COS(M1)
             - 2    *COS(M1-M)
             + 2    *COS(M1+M)
             + 2    *COS(2*F)
            )/100000;
end;

function TFormNewMoon.LastQuarterMoonCorrection(E,M,M1,F,O: real): real;
begin
  // uyee
  Result := (-62801    *SIN(M1)
             +17172*E  *SIN(M)
             +  862    *SIN(2*M1)
             +  804    *SIN(2*F)
             +  454*E  *SIN(M1-M)
             - 1183*E  *SIN(M1+M)
             +  204*E*E*SIN(2*M)
             -  180    *SIN(M1-2*F)
             -   70    *SIN(M1+2*F)
             +   27*E  *SIN(2*M1+M)
             -   40    *SIN(3*M1)
             +   32*E  *SIN(M+2*F)
             +   32*E  *SIN(M-2*F)
             -   34*E  *SIN(2*M1-M)
             -   28*E*E*SIN(M1+2*M)
             -   17    *SIN(O)
             +    2    *SIN(2*(M1-F))
             +    3    *SIN(3*M)
             +    3    *SIN(M1+M-2*F)
             +    4    *SIN(2*(M1+F))
             -    4    *SIN(M1+M+2*F)
             +    2    *SIN(M1-M+2*F)
             -    5    *SIN(M1-M-2*F)
             -    2    *SIN(3*M1+M)
             +    4    *SIN(M1-2*M)

             - ( 306
                - 38*E*COS(M)
                + 26  *COS(M1)
                - 2   *COS(M1 - M)
                + 2   *COS(M1 + M)
                + 2   *COS(2*F)
               )
            )/100000;
end;

function TFormNewMoon.Delta(T: real): real;
var
  T2,dt: real;
begin
  T2 := 2000+100*T;
  dt := 0;
  if(T2>2150) then
    dt := -20 + 32*((T2 - 1820)/100)*((T2 - 1820)/100)
  else if(T2>2050) then
    dt := -20 + 32*((T2 - 1820)/100)*((T2 - 1820)/100) - 0.5628*(2150 - T2)
  else if(T2>2005) then
    dt := 62.92 + 0.32217*(T2-2000) + 0.005589*(T2-2000)*(T2-2000);
  Result := dt;
end;

function TFormNewMoon.RealMod (x, y : extended) : extended;
begin
  Result := x - y * Trunc(x/y);
end;

function TFormNewMoon.FormatDateTime(jd: real): String;
var
  jdt: real;
  tgl,bln,thn: word;
  sd,sm,sy,sw,st: string;
begin
  // format date and time
  FormMain.JDToMasehi(jd,tgl,bln,thn);
  if(tgl < 10) then
    sd := '0' + IntToStr(tgl)
  else
    sd := IntToStr(tgl);
  if(bln < 10) then
    sm := '0' + IntToStr(bln)
  else
    sm := IntToStr(bln);
  sy  := IntToStr(thn);
  st  := sd+'/'+sm+'/'+sy;
  jdt := 12+(jd - FormMain.MasehiToJD(tgl,bln,thn))*24;
  sw  := FormMain.FormatTime(jdt,true);

  Result := st +' '+ sw; 
end;

procedure TFormNewMoon.FormShow(Sender: TObject);
var
  jd: real;
  i,d,m,y: word;
begin
  // ambil tahun sekarang
  DecodeDate(Date,y,m,d);
  jd := FormMain.MasehiToJD(d,m,y);
  FormMain.JDToHijri(jd,d,m,y);

  // generate tahun T-10 -> T+10
  cbTahun.Items.Clear;
  for i := y-10 to y+10 do
  begin
    cbTahun.Items.Add(IntToStr(i));
  end;
  cbTahun.ItemIndex := 10;
  llBulan.ItemIndex := 0;
  calculate;
end;

procedure TFormNewMoon.llBulanClick(Sender: TObject);
begin
  calculate;
end;

procedure TFormNewMoon.cbTahunChange(Sender: TObject);
begin
  calculate;
end;

end.
