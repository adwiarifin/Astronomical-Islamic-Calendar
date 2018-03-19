object FormMonthSelect: TFormMonthSelect
  Left = 192
  Top = 124
  BorderStyle = bsDialog
  Caption = 'Pilih Bulan'
  ClientHeight = 162
  ClientWidth = 185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbTahun: TLabel
    Left = 8
    Top = 40
    Width = 31
    Height = 13
    Caption = 'Tahun'
  end
  object lbBulan: TLabel
    Left = 8
    Top = 64
    Width = 27
    Height = 13
    Caption = 'Bulan'
  end
  object rbMasehi: TRadioButton
    Left = 8
    Top = 8
    Width = 81
    Height = 17
    Caption = 'Masehi'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = rbMasehiClick
  end
  object rbHijriah: TRadioButton
    Left = 96
    Top = 8
    Width = 81
    Height = 17
    Caption = 'Hijriah'
    TabOrder = 1
    OnClick = rbHijriahClick
  end
  object cbTahun: TComboBox
    Left = 48
    Top = 40
    Width = 129
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object cbBulan: TComboBox
    Left = 48
    Top = 64
    Width = 129
    Height = 21
    ItemHeight = 13
    TabOrder = 3
  end
  object btOK: TButton
    Left = 104
    Top = 128
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = btOKClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 96
    Width = 169
    Height = 17
    TabOrder = 5
    Visible = False
  end
end
