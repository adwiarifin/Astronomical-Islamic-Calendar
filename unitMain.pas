unit unitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Math, Menus, ImgList;

type
  TFormMain = class(TForm)
    lbKota: TLabel;
    imageArah: TImage;
    listKota: TListBox;
    cal: TMonthCalendar;
    lbArah: TLabel;
    gbJadwal: TGroupBox;
    lbShubuh: TLabel;
    lbTerbit: TLabel;
    lbDzuhur: TLabel;
    lbAshar: TLabel;
    lbMaghrib: TLabel;
    lbIsya: TLabel;
    edShubuh: TLabel;
    edTerbit: TLabel;
    edDzuhur: TLabel;
    edAshar: TLabel;
    edMaghrib: TLabel;
    edIsya: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    About1: TMenuItem;
    View1: TMenuItem;
    Console1: TMenuItem;
    About2: TMenuItem;
    gbConsole: TGroupBox;
    mmConsole: TMemo;
    cbDST: TCheckBox;
    Setting1: TMenuItem;
    MonthlySchedule1: TMenuItem;
    N1: TMenuItem;
    ImageList1: TImageList;
    N2: TMenuItem;
    NewMoon1: TMenuItem;
    JDOther1: TMenuItem;
    procedure listKotaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure calClick(Sender: TObject);
    procedure Console1Click(Sender: TObject);
    procedure cbDSTClick(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure Setting1Click(Sender: TObject);
    procedure MonthlySchedule1Click(Sender: TObject);
    procedure JDOther1Click(Sender: TObject);
    procedure NewMoon1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
    function EquationOfTIme(JD: real): real;
    function TimeTransit(ET: real): real;
    function TimeDzuhur(transit: real): real;
    function TimeAshar(transit: real): real;
    function TimeMaghrib(transit: real): real;
    function TimeIsya(transit: real; SunSet: real; SunRise: real): real;
    function TimeShubuh(transit: real; SunSet: real; SunRise: real): real;
    function TimeRising(transit: real): real;
    function FindDirection(latitude: real; longitude: real): real;
    procedure drawDirection(direction: real);
  public
    { Public declarations }
    gjd: real;
    lat: real;
    lon: real;
    ele: real;
    zon: real;
    del: real;
    dst: integer;
    kfajr: real;
    kisha: real;
    procedure calculate();
    function Delta(JD: real): real;
    function LeapHijri(Y: word): boolean;
    function LeapMasehi(Y: word): boolean;
    function HijriToJD(D: word; M: word; Y: word): real;
    function MasehiToJD(D: word; M: word; Y: word): real;
    function FormatTime(time: real; second: boolean): String;
    procedure JDToHijri(JD: real; var D: word; var M: word; var Y: word);
    procedure JDToMasehi(JD: real; var D: word; var M: word; var Y: word);
  end;

var
  FormMain: TFormMain;

implementation

uses unitAbout, unitSetting, unitMonthSetting, unitConvertJD, unitNewMoon;

{$R *.dfm}

/////////////////// start of built-in function ////////////////////////

function TFormMain.LeapHijri(Y: word): boolean;
var
  d: word;
begin
  d := Y mod 30;
  case d of
    2: LeapHijri := true;
    5: LeapHijri := true;
    7: LeapHijri := true;
    10: LeapHijri := true;
    13: LeapHijri := true;
    16: LeapHijri := true;
    18: LeapHijri := true;
    21: LeapHijri := true;
    24: LeapHijri := true;
    26: LeapHijri := true;
    29: LeapHijri := true;
  else
    LeapHijri := false;
  end;
end;

function TFormMain.LeapMasehi(Y: word): boolean;
var
  b: boolean;
begin
  if (Y mod 400 = 0) then
    b := true
  else if (Y mod 100 = 0) then
    b := false
  else if (Y mod 4 = 0) then
    b := true
  else
    b := false;
  LeapMasehi := b;
end;

function TFormMain.HijriToJD(D: word; M: word; Y: word): real;
var
  ep,epd,epm,td1,td2,tm,ld: integer;
begin
  ep  := Y - 1;
  epd := ep div 30;
  epm := ep mod 30;
  td1 := epd * 10631;
  mmConsole.Lines.Add('Epoch: '+IntToStr(ep));
  mmConsole.Lines.Add('Epoch Div: '+IntToStr(epd));
  mmConsole.Lines.Add('Epoch Mod: '+IntToStr(epm));
  mmConsole.Lines.Add('Tahun 1: '+IntToStr(td1));
  // check kabisat
  ld := 0;
  if (epm >= 29) then ld := 11
  else if (epm >= 26) then ld := 10
  else if (epm >= 24) then ld := 9
  else if (epm >= 21) then ld := 8
  else if (epm >= 18) then ld := 7
  else if (epm >= 16) then ld := 6
  else if (epm >= 13) then ld := 5
  else if (epm >= 10) then ld := 4
  else if (epm >= 7) then ld := 3
  else if (epm >= 5) then ld := 2
  else if (epm >= 2) then ld := 1;
  td2 := epm * 354 + ld;
  mmConsole.Lines.Add('Kabisat: '+IntToStr(ld));
  mmConsole.Lines.Add('Tahun 2: '+IntToStr(td2));
  // hitung hari dalam bulan
  ep := m - 1;
  tm := Ceil(ep * 29.5);
  mmConsole.Lines.Add('Hari Bulan: '+IntToStr(tm));
  mmConsole.Lines.Add('Hari: '+IntToStr(D));
  // hasil JD
  HijriToJD := 1948438.5 + td1 + td2 + tm + D;
end;

function TFormMain.MasehiToJD(D: word; M: word; Y: word): real;
var
  A,B: integer;
  greg: boolean;
  JDG: real;
begin
  // penyesuaian bulan dan tahun
  if(M<=2) then
  begin
    M := M + 12;
    Y := Y - 1;
  end;

  // check gregorian / julian
  if (Y <= 1582) then
  begin
    if (Y = 1582) then
    begin
      if (M < 10) then
        greg := false
      else if (M = 10) then
      begin
        if (D <= 4) then
          greg := false
        else
          greg := true;
      end
      else
        greg := true;
    end
    else
      greg := false;
  end
  else
    greg := true;

  // hitung koreksi kabisat
  if (greg) then
  begin
    A := Y div 100;
    B := 2 + (A div 4) - A;
  end
  else
    B := 0;

  // nilai JD waktu greenwich
  JDG := 1720994.5 + int(365.25 * Y) + int(30.6001 * (M+1)) + B + D + 0.5;
  MasehiToJD := JDG;
end;

procedure TFormMain.JDToMasehi(JD: real; var D: word; var M: word; var Y: word);
var
  Z,A,AA,B,C,E,G: integer;
  JD1,F: real;
begin
  JD1 := JD + 0.5;
  Z   := Trunc(JD1);
  F   := JD1 - Z;
  AA  := 0;
  if (Z < 2299161) then
    A := Z
  else
  begin
    AA := Trunc((Z-1867216.25)/36524.25);
    A  := Z + 1 + AA - Trunc(AA/4);
  end;
  B   := A + 1524;
  C   := Trunc((B-122.1)/365.25);
  E   := Trunc(365.25*C);
  G   := Trunc((B-E)/30.6001);

  // debug
  mmConsole.Lines.Add('JD1: '+FloatToStr(JD1));
  mmConsole.Lines.Add('Z: '+IntToStr(Z));
  mmConsole.Lines.Add('F: '+FloatToStr(F));
  mmConsole.Lines.Add('AA: '+IntToStr(AA));
  mmConsole.Lines.Add('A: '+IntToStr(A));
  mmConsole.Lines.Add('B: '+IntToStr(B));
  mmConsole.Lines.Add('C: '+IntToStr(C));
  mmConsole.Lines.Add('E: '+IntToStr(E));
  mmConsole.Lines.Add('G: '+IntToStr(G));

  // return value
  D := B - E - Trunc(30.6001*G);
  if (G>=14) then
  begin
    M := G - 13;
    Y := C - 4715;
  end
  else
  begin
    M := G - 1;
    Y := C - 4716;
  end;
end;

procedure TFormMain.JDToHijri(JD: real; var D: word; var M: word; var Y: word);
var
  T30M,T30D,TT,TMD,TM: integer;
  A: real;
begin
  A    := JD - 1948438.5;
  T30D := Trunc(A) Div 10631;
  T30M := Trunc(A) Mod 10631;
  mmConsole.Lines.Add('A: '+FloatToStr(A));
  mmConsole.Lines.Add('T30D: '+IntToStr(T30D));
  mmConsole.Lines.Add('T30M: '+IntToStr(T30M));
  TMD  := 0;
  TT   := 0;
  TM   := 0;
  // check tahun
  if (T30M > 10277) then begin TT := 30; TMD := 10277;  end
  else if (T30M > 9922) then begin TT := 29; TMD := 9922;  end
  else if (T30M > 9568) then begin TT := 28; TMD := 9568;  end
  else if (T30M > 9214) then begin TT := 27; TMD := 9214;  end
  else if (T30M > 8859) then begin TT := 26; TMD := 8859;  end
  else if (T30M > 8505) then begin TT := 25; TMD := 8505;  end
  else if (T30M > 8150) then begin TT := 24; TMD := 8150;  end
  else if (T30M > 7796) then begin TT := 23; TMD := 7796;  end
  else if (T30M > 7442) then begin TT := 22; TMD := 7442;  end
  else if (T30M > 7087) then begin TT := 21; TMD := 7087;  end
  else if (T30M > 6733) then begin TT := 20; TMD := 6733;  end
  else if (T30M > 6379) then begin TT := 19; TMD := 6379;  end
  else if (T30M > 6024) then begin TT := 18; TMD := 6024;  end
  else if (T30M > 5670) then begin TT := 17; TMD := 5670;  end
  else if (T30M > 5315) then begin TT := 16; TMD := 5315;  end
  else if (T30M > 4961) then begin TT := 15; TMD := 4961;  end
  else if (T30M > 4607) then begin TT := 14; TMD := 4607;  end
  else if (T30M > 4252) then begin TT := 13; TMD := 4252;  end
  else if (T30M > 3898) then begin TT := 12; TMD := 3898;  end
  else if (T30M > 3544) then begin TT := 11; TMD := 3544;  end
  else if (T30M > 3189) then begin TT := 10; TMD := 3189;  end
  else if (T30M > 2835) then begin TT := 9; TMD := 2835;  end
  else if (T30M > 2481) then begin TT := 8; TMD := 2481;  end
  else if (T30M > 2126) then begin TT := 7; TMD := 2126;  end
  else if (T30M > 1772) then begin TT := 6; TMD := 1772;  end
  else if (T30M > 1417) then begin TT := 5; TMD := 1417;  end
  else if (T30M > 1063) then begin TT := 4; TMD := 1063;  end
  else if (T30M > 709) then begin TT := 3; TMD := 709;  end
  else if (T30M > 354) then begin TT := 2; TMD := 354;  end
  else if (T30M > 0) then begin TT := 1; TMD := 0;  end;
  mmConsole.Lines.Add('TT: '+IntToStr(TT));
  mmConsole.Lines.Add('TMD: '+IntToStr(TMD));
  // check bulan
  TMD := T30M - TMD;
  mmConsole.Lines.Add('TMD (New): '+IntToStr(TMD));
  if (TMD <= 30) then begin TM := 1; TMD := TMD - 0; end
  else if (TMD <= 59) then begin TM := 2; TMD := TMD - 30; end
  else if (TMD <= 89) then begin TM := 3; TMD := TMD - 59; end
  else if (TMD <= 118) then begin TM := 4; TMD := TMD - 89; end
  else if (TMD <= 148) then begin TM := 5; TMD := TMD - 118; end
  else if (TMD <= 177) then begin TM := 6; TMD := TMD - 148; end
  else if (TMD <= 207) then begin TM := 7; TMD := TMD - 177; end
  else if (TMD <= 236) then begin TM := 8; TMD := TMD - 207; end
  else if (TMD <= 266) then begin TM := 9; TMD := TMD - 236; end
  else if (TMD <= 295) then begin TM := 10; TMD := TMD - 266; end
  else if (TMD <= 325) then begin TM := 11; TMD := TMD - 295; end
  else if (TMD <= 355) then begin TM := 12; TMD := TMD - 325; end;
  mmConsole.Lines.Add('TM: '+IntToStr(TM));
  mmConsole.Lines.Add('TMD: '+IntToStr(TMD));
  // hasil
  D := TMD;
  M := TM;
  Y := (T30D * 30) + TT;
end;

function TFormMain.Delta(JD: real): real;
var
  T: real;
begin
  T := 2 * Pi * (JD - 2451545) / 365.25;
  Delta := 0.37877
         + 23.264  * SIN(DegToRad(1 * 57.297 * T - 79.547))
         + 0.3812  * SIN(DegToRad(2 * 57.297 * T - 82.682))
         + 0.17132 * SIN(DegToRad(3 * 57.297 * T - 59.722));
end;

function TFormMain.EquationOfTIme(JD: real): real;
var
  U,L0,EoT: real;
begin
  U  := (JD - 2451545) / 36525;
  L0 := (280.46607 + 36000.7698 * U);
  L0 := DegToRad(L0);
  EoT := -(1789 + 237 * U) * SIN(1 * L0)
         -(7146 -  62 * U) * COS(1 * L0)
         +(9934 -  14 * U) * SIN(2 * L0)
         -(  29 +   5 * U) * COS(2 * L0)
         +(  74 +  10 * U) * SIN(3 * L0)
         +( 320 -   4 * U) * COS(3 * L0)
         -( 212          ) * SIN(4 * L0);
  EquationOfTIme := EoT / 1000;
end;

function TFormMain.TimeTransit(ET: real): real;
var
  T: real;
begin
  T := 12 + zon - (lon / 15) - (ET / 60);
  TimeTransit := T;
  // debug only
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Transit ---');
  mmConsole.Lines.Add('Transit: '+FloatToStr(T));
end;

function TFormMain.TimeDzuhur(transit: real): real;
var
  K: integer;
  T: real;
begin
  K := 2;
  T := transit + (K / 60);
  TimeDzuhur := T;
  // debug only
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Dzuhur ---');
  mmConsole.Lines.Add('Koreksi: '+IntToStr(K));
  mmConsole.Lines.Add('Time: '+FloatToStr(T));
end;

function TFormMain.TimeAshar(transit: real): real;
var
  alt, cha, ha, K, T: real;
begin
  K := 1;
  alt := ArcTan(1/(K + tan(abs(DegToRad(del - lat)))));
  alt := RadToDeg(alt);
  cha := (sin(DegToRad(alt))-sin(DegToRad(lat))*sin(DegToRad(del)))
       / (cos(DegToRad(lat))*cos(DegToRad(del)));
  ha  := ArcCos(cha);
  ha  := RadToDeg(ha);
  T   := transit + ha / 15;
  TimeAshar := T;
  // debug only
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Ashar ---');
  mmConsole.Lines.Add('Faktor Ashar: '+FloatToStr(K));
  mmConsole.Lines.Add('Altitude: '+FloatToStr(alt));
  mmConsole.Lines.Add('Cos(HA): '+FloatToStr(cha));
  mmConsole.Lines.Add('HA: '+FloatToStr(ha));
  mmConsole.Lines.Add('Time: '+FloatToStr(T));
end;

function TFormMain.TimeMaghrib(transit: real): real;
var
  alt, cha, ha, T: real;
begin
  alt := -0.8333 - 0.0347 * sqrt(ele);
  cha := (sin(DegToRad(alt))-sin(DegToRad(lat))*sin(DegToRad(del)))
       / (cos(DegToRad(lat))*cos(DegToRad(del)));
  ha  := ArcCos(cha);
  ha  := RadToDeg(ha);
  T   := transit + ha / 15;
  TimeMaghrib := T;
  // debug only
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Maghrib ---');
  mmConsole.Lines.Add('Altitude: '+FloatToStr(alt));
  mmConsole.Lines.Add('Cos(HA): '+FloatToStr(cha));
  mmConsole.Lines.Add('HA: '+FloatToStr(ha));
  mmConsole.Lines.Add('Time: '+FloatToStr(T));
end;

function TFormMain.TimeIsya(transit: real; SunSet: real; SunRise: real): real;
var
  alt, cha, ha, K, T, N, P: real;
begin
  K := kisha;
  ha := 0; N := 0; P := 0;
  alt := -K;
  cha := (sin(DegToRad(alt))-sin(DegToRad(lat))*sin(DegToRad(del)))
       / (cos(DegToRad(lat))*cos(DegToRad(del)));
  if (Abs(cha) > 1) then
  begin
    N := (SunRise + 24 - SunSet);
    P := N * (K / 60);
    T := SunSet + P;
  end
  else
  begin
    ha  := ArcCos(cha);
    ha  := RadToDeg(ha);
    T   := transit + ha / 15;
  end;
  TimeIsya := T;
  // debug only
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Isya'' ---');
  mmConsole.Lines.Add('Altitude: '+FloatToStr(K));
  mmConsole.Lines.Add('Cos(HA): '+FloatToStr(cha));
  if (Abs(cha) > 1) then
  begin
    mmConsole.Lines.Add('Abnormal Condition');
    mmConsole.Lines.Add('Night: '+FloatToStr(N));
    mmConsole.Lines.Add('Portion: '+FloatToStr(P))
  end
  else
    mmConsole.Lines.Add('HA: '+FloatToStr(ha));
  mmConsole.Lines.Add('Time: '+FloatToStr(T));
end;

function TFormMain.TimeShubuh(transit: real; SunSet: real; SunRise: real): real;
var
  alt, cha, ha, K, T, N, P: real;
begin
  K := kfajr;
  ha := 0; N := 0; P := 0;
  alt := -K;
  cha := (sin(DegToRad(alt))-sin(DegToRad(lat))*sin(DegToRad(del)))
       / (cos(DegToRad(lat))*cos(DegToRad(del)));
  if (Abs(cha) > 1) then
  begin
    N := (SunRise + 24 - SunSet);
    P := N * (K / 60);
    T := SunRise - P;
  end
  else
  begin
    ha  := ArcCos(cha);
    ha  := RadToDeg(ha);
    T   := transit - ha / 15;
  end;
  TimeShubuh := T;
  // debug only
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Shubuh ---');
  mmConsole.Lines.Add('Altitude: '+FloatToStr(K));
  mmConsole.Lines.Add('Cos(HA): '+FloatToStr(cha));
  if (Abs(cha) > 1) then
  begin
    mmConsole.Lines.Add('Abnormal Condition');
    mmConsole.Lines.Add('Night: '+FloatToStr(N));
    mmConsole.Lines.Add('Portion: '+FloatToStr(P))
  end
  else
    mmConsole.Lines.Add('HA: '+FloatToStr(ha));
  mmConsole.Lines.Add('Time: '+FloatToStr(T));
end;

function TFormMain.TimeRising(transit: real): real;
var
  alt, cha, ha, T: real;
begin
  alt := -0.8333 - 0.0347 * sqrt(ele);
  cha := (sin(DegToRad(alt))-sin(DegToRad(lat))*sin(DegToRad(del)))
       / (cos(DegToRad(lat))*cos(DegToRad(del)));
  ha  := ArcCos(cha);
  ha  := RadToDeg(ha);
  T   := transit - ha / 15;
  TimeRising := T;
  // debug only
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Sunrise ---');
  mmConsole.Lines.Add('Altitude: '+FloatToStr(alt));
  mmConsole.Lines.Add('Cos(HA): '+FloatToStr(cha));
  mmConsole.Lines.Add('HA: '+FloatToStr(ha));
  mmConsole.Lines.Add('Time: '+FloatToStr(T));
end;

function TFormMain.FormatTime(time: real; second: boolean): String;
var
  H,M,S: real;
  sh,sm,ss: string;
begin
  H := int(time);
  time := time - H;
  M := int(time * 60);
  time := time - (M/60);
  S := int(time * 3600);
{  if(S > 0) then
    M := M + 1;}
  if(s < 10) then
    ss := '0' + FloatToStr(S)
  else
    ss := FloatToStr(S);
  if(m < 10) then
    sm := '0' + FloatToStr(M)
  else
    sm := FloatToStr(M);
  if(h < 10) then
    sh := '0' + FloatToStr(H)
  else
    sh := FloatToStr(H);

  if second then
    FormatTime := sh + ':' + sm + ':' + ss
  else
    FormatTime := sh + ':' + sm;
end;

function TFormMain.FindDirection(latitude: real; longitude: real): real;
const
  latOrigin = 21.42250833;
  longOrigin = 39.82616111;
var
  db,sdb,cdb,slb,clb,tla,tby,tbx,b: real;
begin
  // perhitungan arah
  db := longOrigin - longitude;
  sdb := sin(DegToRad(db));
  cdb := cos(DegToRad(db));
  slb := sin(DegToRad(latitude));
  clb := cos(DegToRad(latitude));
  tla := tan(DegToRad(latOrigin));
  tby := (sdb);
  tbx := (clb*tla-slb*cdb);
  b   := ArcTan2(tby,tbx);
  b   := RadToDeg(b);
  if(b<0)then b:=b+360;

  FindDirection := b;
end;

procedure TFormMain.drawDirection(direction: real);
var
  x,y: integer;
  t: real;
  img: TBitmap;
  pct: TPicture;
begin
  img := TBitmap.Create;
  ImageList1.GetBitmap(0,img);
  pct := TPicture.Create;   
  pct.Assign(img);
  with imageArah, canvas do
  begin
    t:=0;
    // clear image
    brush.color:=clwhite;
    canvas.rectangle(clientrect);
    // draw line
    brush.Color := clBlack;
    MoveTo(80,80);
    LineTo(80,5);
    while(t<direction)do
    begin
      y := 80-Floor(cos(DegToRad(t))*50);
      x := 80+Floor(sin(DegToRad(t))*50);
      LineTo(x,y);
      t := t + 0.01;
    end;
    y := 80-Floor(cos(DegToRad(t))*75);
    x := 80+Floor(sin(DegToRad(t))*75);
    MoveTo(x,y);
    LineTo(80,80);
    // draw kabah
    Draw(x-5,y-5,pct.Graphic);
    // draw text
    Pen.Color := clBlack;
    Brush.Style := bsClear;
    Font.Size := 12;
    Font.Style := [];
    SetTextAlign( handle, TA_CENTER );
    TextOut(80,80,Format('%.2f°', [direction]));
    SetTextAlign( handle, TA_LEFT );
    Font.Size := 15;
    Font.Style := [fsBold];
    TextOut(85,5,'U');
  end;
end;

procedure TFormMain.calculate;
var
  td,tm,ty: word;
  jd,et,transit,dir,ss,sr,x: real;
begin
  // extract tanggal
  JDToMasehi(gjd,td,tm,ty);
  jd  := gjd - (zon / 24);
  del := Delta(jd);
  et  := EquationOfTIme(jd);

  // ========== debug only ========== //
  mmConsole.Lines.BeginUpdate;
  mmConsole.Lines.Clear;
  mmConsole.Lines.Add('--- Basic Info ---');
  mmConsole.Lines.Add('Latitude: '+FloatToStr(lat));
  mmConsole.Lines.Add('Longitude: '+FloatToStr(lon));
  mmConsole.Lines.Add('Elevation: '+FloatToStr(ele));
  mmConsole.Lines.Add('Time Zone: '+FloatToStr(zon));
  mmConsole.Lines.Add('DST: '+IntToStr(dst));
  mmConsole.Lines.Add('Date: '+IntToStr(td)+'-'+IntToStr(tm)+'-'+IntToStr(ty));
  mmConsole.Lines.Add('JD: '+FloatToStr(jd));
  mmConsole.Lines.Add('Delta: '+FloatToStr(del));
  mmConsole.Lines.Add('ET: '+FloatToStr(et));

  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Decoding JD To Masehi ---');
  JDToMasehi(jd,td,tm,ty);
  mmConsole.Lines.Add('D: '+IntToStr(td));
  mmConsole.Lines.Add('M: '+IntToStr(tm));
  mmConsole.Lines.Add('Y: '+IntToStr(ty));

  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Decoding JD To Hijr ---');
  JDToHijri(jd,td,tm,ty);
  mmConsole.Lines.Add('D: '+IntToStr(td));
  mmConsole.Lines.Add('M: '+IntToStr(tm));
  mmConsole.Lines.Add('Y: '+IntToStr(ty));

  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Checking H2JD ---');
  x := HijriToJD(td,tm,ty);
  mmConsole.Lines.Add('JD(H): '+FloatToStr(x));
  // ========== debug end ========== //

  // hitung waktu sholat
  transit := TimeTransit(et);
  ss := TimeMaghrib(transit);
  sr := TimeRising(transit);
  edDzuhur.Caption  := FormatTime(TimeDzuhur(transit)+dst, true);
  edAshar.Caption   := FormatTime(TimeAshar(transit)+dst, true);
  edMaghrib.Caption := FormatTime(ss+dst, true);
  edTerbit.Caption  := FormatTime(sr+dst, true);
  edIsya.Caption    := FormatTime(TimeIsya(transit, ss, sr)+dst, true);
  edShubuh.Caption  := FormatTime(TimeShubuh(transit, ss, sr)+dst, true);

  // gambar arah kiblat
  dir := FindDirection(lat, lon);
  drawDirection(dir);

  // ========== debug only ========== //
  mmConsole.Lines.Add('');
  mmConsole.Lines.Add('--- Qibla ---');
  mmConsole.Lines.Add('Angle: '+FloatToStr(dir));
  mmConsole.Lines.EndUpdate;
  // ========== debug end ========== //
end;

/////////////////// end of built-in function ////////////////////////

procedure TFormMain.listKotaClick(Sender: TObject);
begin
  // cek kota dan koordinatnya
  case listKota.ItemIndex of
    0: begin
         lat := 39.9040300;
         lon := 116.4075260;
         ele := 52.30;
         zon := 8.0;
       end;
    1: begin
         lat := -34.6037230;
         lon := -58.3815930;
         ele := 29.11;
         zon := -3.0;
       end;
    2: begin
         lat := 28.6353080;
         lon := 77.2249600;
         ele := 214.00;
         zon := 5.5;
       end;
    3: begin
         lat := 23.7099210;
         lon := 90.4071430;
         ele := 22.00;
         zon := 6.0;
       end;
    4: begin
         lat := 23.1291630;
         lon := 113.2644350;
         ele := 18.92;
         zon := 8.0;
       end;
    5: begin
         lat := 41.0052700;
         lon := 28.9769600;
         ele := 37.31;
         zon := 2.0;
       end;
    6: begin
         lat := -6.2087630;
         lon := 106.8455990;
         ele := 9.00;
         zon := 7.0;
       end;
    7: begin
         lat := 30.0444200;
         lon := 31.2357120;
         ele := 26.72;
         zon := 2.0;
       end;
    8: begin
         lat := 22.5726460;
         lon := 88.3638950;
         ele := 13.95;
         zon := 5.5;
       end;
    9: begin
         lat := 24.8614620;
         lon := 67.0099390;
         ele := 9.86;
         zon := 5.0;
       end;
    10: begin
         lat := 6.4411580;
         lon := 3.4179770;
         ele := 6.64;
         zon := 1.0;
       end;
    11: begin
         lat := 51.5085150;
         lon := -0.1254870;
         ele := 25.36;
         zon := 0.0;
       end;
    12: begin
         lat := 34.0522340;
         lon := -118.2436850;
         ele := 86.85;
         zon := -8.0;
       end;
    13: begin
         lat := 14.5995120;
         lon := 120.9842190;
         ele := 8.00;
         zon := 8.0;
       end;
    14: begin
         lat := 19.4326080;
         lon := -99.1332080;
         ele := 2229.73;
         zon := -6.0;
       end;
    15: begin
         lat := 55.7558260;
         lon := 37.6173000;
         ele := 151.78;
         zon := 4.0;
       end;
    16: begin
         lat := 19.0759840;
         lon := 72.8776560;
         ele := 5.46;
         zon := 5.5;
       end;
    17: begin
         lat := 40.7143530;
         lon := -74.0059730;
         ele := 9.78;
         zon := -4.0;
       end;
    18: begin
         lat := 34.6937380;
         lon := 135.5021650;
         ele := 3.66;
         zon := 9.0;
       end;
    19: begin
         lat := -22.9133950;
         lon := -43.2007100;
         ele := 11.09;
         zon := -3.0;
       end;
    20: begin
         lat := -23.5505200;
         lon := -46.6333090;
         ele := 767.49;
         zon := -3.0;
       end;
    21: begin
         lat := 37.5665350;
         lon := 126.9779690;
         ele := 42.04;
         zon := 9.0;
       end;
    22: begin
         lat := 31.2304160;
         lon := 121.4737010;
         ele := 16.17;
         zon := 8.0;
       end;
    23: begin
         lat := 35.6962160;
         lon := 51.4229450;
         ele := 1181.10;
         zon := 4.5;
       end;
    24: begin
         lat := 35.6894870;
         lon := 139.6917060;
         ele := 37.15;
         zon := 9.0;
       end;
  end;
  calculate;
end;

procedure TFormMain.calClick(Sender: TObject);
var
  y,m,d: word;
begin
  DecodeDate(cal.Date, y, m, d);
  gjd := MasehiToJD(d, m, y);
  calculate;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // setting parameter
  kisha := 17;
  kfajr := 18;
  // setting tanggal
  cal.Date := Date;
  calClick(Sender);
  // setting tempat
  listKota.ItemIndex := 6;
  listKotaClick(Sender);
end;

procedure TFormMain.Console1Click(Sender: TObject);
var
  offset: integer;
begin
  if Console1.Checked then
  begin
    offset := gbConsole.Left + gbConsole.Width + 8;
    ClientWidth := offset;
  end
  else
  begin
    offset := gbJadwal.Left + gbJadwal.Width + 8;
    ClientWidth := offset;
  end;
end;

procedure TFormMain.cbDSTClick(Sender: TObject);
begin
  if cbDST.Checked then
    dst := 1
  else
    dst := 0;
  calculate;
end;

procedure TFormMain.About2Click(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TFormMain.Setting1Click(Sender: TObject);
begin
  FormSetting.ShowModal;
end;

procedure TFormMain.MonthlySchedule1Click(Sender: TObject);
begin
  FormMonthSelect.ShowModal;
end;

procedure TFormMain.JDOther1Click(Sender: TObject);
begin
  FormConvertJD.ShowModal;  
end;

procedure TFormMain.NewMoon1Click(Sender: TObject);
begin
  FormNewMoon.ShowModal;
end;

procedure TFormMain.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
