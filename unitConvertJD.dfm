object FormConvertJD: TFormConvertJD
  Left = 304
  Top = 137
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'JD -> Other'
  ClientHeight = 153
  ClientWidth = 185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbJD: TLabel
    Left = 8
    Top = 8
    Width = 36
    Height = 13
    Caption = 'Nilai JD'
  end
  object edJD: TEdit
    Left = 56
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object gbResult: TGroupBox
    Left = 8
    Top = 40
    Width = 169
    Height = 73
    Caption = 'Hasil'
    TabOrder = 1
    object lbTanggal: TLabel
      Left = 8
      Top = 24
      Width = 39
      Height = 13
      Caption = 'Tanggal'
    end
    object lbWaktu: TLabel
      Left = 8
      Top = 48
      Width = 32
      Height = 13
      Caption = 'Waktu'
    end
    object edTanggal: TLabel
      Left = 96
      Top = 24
      Width = 66
      Height = 13
      Caption = '##/##/####'
    end
    object edWaktu: TLabel
      Left = 96
      Top = 48
      Width = 48
      Height = 13
      Caption = '##:##:##'
    end
  end
  object btnExit: TButton
    Left = 104
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Keluar'
    TabOrder = 2
    OnClick = btnExitClick
  end
  object btnConvert: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Convert'
    TabOrder = 3
    OnClick = btnConvertClick
  end
end
