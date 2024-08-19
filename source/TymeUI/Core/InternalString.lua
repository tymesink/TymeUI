local TYMEUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Strings = {}

I.Strings.Colors = {
  [I.Enum.Colors.TYMEUI] = "18a8ff", -- #18a8ff
  [I.Enum.Colors.ELVUI] = "1784d1", -- #1784d1
  [I.Enum.Colors.ERROR] = "ef5350", -- #ef5350
  [I.Enum.Colors.GOOD] = "66bb6a", -- #66bb6a
  [I.Enum.Colors.WARNING] = "f5b041", -- #f5b041
  [I.Enum.Colors.WHITE] = "ffffff", -- #ffffff
  [I.Enum.Colors.SILVER] = "a3a3a3", -- #a3a3a3
  [I.Enum.Colors.GOLD] = "cfc517", -- ##cfc517
  [I.Enum.Colors.LEGENDARY] = "ff8000", -- #ff8000
  [I.Enum.Colors.EPIC] = "a335ee", -- #a335ee
  [I.Enum.Colors.RARE] = "0070dd", -- #0070dd
  [I.Enum.Colors.BETA] = "1eff00", -- #1eff00
}

I.Strings.Branding = {
  Title = "|cffffffffToxi|r|cff" .. I.Strings.Colors[I.Enum.Colors.TYMEUI] .. "UI|r",

  ColorHex = I.Strings.Colors[I.Enum.Colors.TYMEUI],
  ColorRGB = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TYMEUI]),
  ColorRGBA = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TYMEUI] .. "ff"),

  Links = {
    Website = "https://foo.com",
    Discord = "https://discord.gg/foo",
    WAGuide = "https://foo.com",
    Youtube = "https://www.youtube.com/foo",
    Github = "https://github.com/foo",
  },
}

I.Strings.LayoutConfigs = {
  [I.Enum.Layouts.Default] = "1 39 0 0 0 4 4 UIParent 0.0 -388.7 -1 ##$$%/&''%)$+$,$ 0 1 0 4 4 UIParent 0.0 -432.2 -1 ##$$%/&''%(#,$ 0 2 0 7 7 UIParent -140.1 68.3 -1 ##$%%/&&'%(#,$ 0 3 0 7 7 UIParent 141.0 68.7 -1 ##$%%/&&'%(#,$ 0 4 1 2 0 MultiBarRight -5.0 0.0 -1 #$$$%/&&'%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&('%(#,$ 0 6 1 1 7 MultiBar5 0.0 0.0 -1 ##$$%/&('%(#,$ 0 7 0 5 5 UIParent -11.1 -36.5 -1 #$$$%/&''%(#,$ 0 10 0 7 7 UIParent -458.5 228.3 -1 ##$$&('% 0 11 0 7 7 UIParent 10.9 236.6 -1 ##$$&('%,# 0 12 0 4 4 UIParent 0.0 -18.8 -1 ##$$&('% 1 -1 0 7 7 UIParent 7.5 289.2 -1 #($#%# 2 -1 0 2 2 UIParent 0.0 -23.6 -1 ##$#%( 3 0 1 8 7 UIParent -300.0 250.0 -1 $#3# 3 1 0 7 7 UIParent 396.8 245.0 -1 %#3# 3 2 0 7 7 UIParent 398.5 116.2 -1 %#&$3# 3 3 0 0 0 UIParent 0.0 -357.3 -1 '#($)#-#.#/#1$3# 3 4 0 0 0 UIParent 0.0 -356.8 -1 ,%-#.#/#0#1#2( 3 5 0 2 2 UIParent -1908.2 -47.2 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4& 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 0 4 4 UIParent 3.4 -137.8 -1 # 5 -1 0 7 7 UIParent -419.2 76.1 -1 # 6 0 0 5 3 MinimapCluster -4.0 57.9 -1 ##$#%#&0(()( 6 1 0 4 4 UIParent -385.7 -220.7 -1 ##$$%$'+(')( 7 -1 0 1 1 UIParent 0.8 -72.3 -1 # 8 -1 0 6 6 UIParent 38.3 42.5 -1 #'$<%$&V 9 -1 0 7 7 UIParent -498.0 229.8 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 1 1 UIParent -466.0 -8.8 -1 # 12 -1 0 5 5 UIParent -59.5 0.8 -1 #;$#%# 13 -1 0 7 7 UIParent 458.3 0.0 -1 ##$#%%&- 14 -1 0 7 7 UIParent 407.4 0.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 1 MainStatusTrackingBarContainer 0.0 0.0 -1 # 16 -1 0 6 6 UIParent 489.4 254.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 0 0 0 UIParent 232.0 -47.7 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ##",
}