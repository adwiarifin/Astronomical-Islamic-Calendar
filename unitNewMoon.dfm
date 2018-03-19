object FormNewMoon: TFormNewMoon
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'New Moon Calculator'
  ClientHeight = 209
  ClientWidth = 329
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
  object cbTahun: TComboBox
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'Tahun'
    OnChange = cbTahunChange
  end
  object llBulan: TListBox
    Left = 8
    Top = 32
    Width = 121
    Height = 169
    ItemHeight = 13
    Items.Strings = (
      'Muharram'
      'Shafar'
      'Rabi'#39'ul Awwal'
      'Rabi'#39'ul Akhir'
      'Jumadil Awwal'
      'Jumadil Akhir'
      'Rajab'
      'Sya'#39'ban'
      'Ramadhan'
      'Syawwal'
      'Dzulqa'#39'dah'
      'Dzulhijjah')
    TabOrder = 1
    OnClick = llBulanClick
  end
  object mmConsole: TMemo
    Left = 136
    Top = 8
    Width = 185
    Height = 193
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
