object FormAbout: TFormAbout
  Left = 228
  Top = 161
  BorderStyle = bsSingle
  Caption = 'About'
  ClientHeight = 129
  ClientWidth = 257
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
    Left = 8
    Top = 8
    Width = 241
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'Astronomical Islamic Solution'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 241
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = #169' 2014'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 241
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'by: Adwi Arifin (adwiarifin@gmail.com)'
    Layout = tlCenter
  end
  object Button1: TButton
    Left = 91
    Top = 96
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
end
