object FormSetting: TFormSetting
  Left = 230
  Top = 130
  Width = 377
  Height = 231
  Caption = 'Setting'
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
  object Label1: TLabel
    Left = 232
    Top = 8
    Width = 47
    Height = 13
    Caption = 'Fajr Angle'
  end
  object Label2: TLabel
    Left = 304
    Top = 8
    Width = 50
    Height = 13
    Caption = 'Isha Angle'
  end
  object Label3: TLabel
    Left = 232
    Top = 32
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '18'
  end
  object Label4: TLabel
    Left = 232
    Top = 56
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '18'
  end
  object Label5: TLabel
    Left = 232
    Top = 80
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '15'
  end
  object Label6: TLabel
    Left = 232
    Top = 104
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '19.5'
  end
  object Label7: TLabel
    Left = 232
    Top = 128
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '20'
  end
  object Label8: TLabel
    Left = 304
    Top = 32
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '17'
  end
  object Label9: TLabel
    Left = 304
    Top = 56
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '18'
  end
  object Label10: TLabel
    Left = 304
    Top = 80
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '15'
  end
  object Label11: TLabel
    Left = 304
    Top = 104
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '17.5'
  end
  object Label12: TLabel
    Left = 304
    Top = 128
    Width = 49
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '18'
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 32
    Width = 137
    Height = 17
    Caption = 'Muslim World League'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 56
    Width = 209
    Height = 17
    Caption = 'University Of Islamic Sciences, Karachi'
    TabOrder = 1
  end
  object RadioButton3: TRadioButton
    Left = 8
    Top = 80
    Width = 113
    Height = 17
    Caption = 'North America'
    TabOrder = 2
  end
  object RadioButton4: TRadioButton
    Left = 8
    Top = 104
    Width = 201
    Height = 17
    Caption = 'Egyptian General Authority of Survey'
    TabOrder = 3
  end
  object RadioButton5: TRadioButton
    Left = 8
    Top = 128
    Width = 113
    Height = 17
    Caption = 'Indonesian'
    TabOrder = 4
  end
  object Button1: TButton
    Left = 232
    Top = 160
    Width = 121
    Height = 25
    Caption = 'OK'
    TabOrder = 5
    OnClick = Button1Click
  end
end
