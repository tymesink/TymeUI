local TYMEUI, F, I, E = unpack(TymeUI)

I.Constants = {}

I.Constants.AddonName = "TymeUI"
I.Constants.AddonProfileKey = TYMEUI.AddOnName..'-'..E.mynameRealm
I.Constants.ADDON_NAME_COLOR = "|cff0062ffTyme|r|cff0DEB11UI|r";

I.Constants.layout = {
	UIScale = 0.64,
	fontSize = 12,
	font = 'PT Sans Narrow',
	fontStyle = 'OUTLINE',
	bordercolor = { r = 0, g = 0, b = 0 },
	backdropcolor = { r = 0.1, g = 0.1, b = 0.1 },
	backdropfadecolor = { r = .06, g = .06, b = .06, a = 0.8 },
	valuecolor = { r = 0.09, g = 0.52, b = 0.82 },
  	LayoutConfigs = {
    	Default = "1 39 0 0 0 4 4 UIParent 0.0 -388.7 -1 ##$$%/&''%)$+$,$ 0 1 0 4 4 UIParent 0.0 -432.2 -1 ##$$%/&''%(#,$ 0 2 0 7 7 UIParent -140.1 68.3 -1 ##$%%/&&'%(#,$ 0 3 0 7 7 UIParent 141.0 68.7 -1 ##$%%/&&'%(#,$ 0 4 1 2 0 MultiBarRight -5.0 0.0 -1 #$$$%/&&'%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&('%(#,$ 0 6 1 1 7 MultiBar5 0.0 0.0 -1 ##$$%/&('%(#,$ 0 7 0 5 5 UIParent -11.1 -36.5 -1 #$$$%/&''%(#,$ 0 10 0 7 7 UIParent -458.5 228.3 -1 ##$$&('% 0 11 0 7 7 UIParent 10.9 236.6 -1 ##$$&('%,# 0 12 0 4 4 UIParent 0.0 -18.8 -1 ##$$&('% 1 -1 0 7 7 UIParent 7.5 289.2 -1 #($#%# 2 -1 0 2 2 UIParent 0.0 -23.6 -1 ##$#%( 3 0 1 8 7 UIParent -300.0 250.0 -1 $#3# 3 1 0 7 7 UIParent 396.8 245.0 -1 %#3# 3 2 0 7 7 UIParent 398.5 116.2 -1 %#&$3# 3 3 0 0 0 UIParent 0.0 -357.3 -1 '#($)#-#.#/#1$3# 3 4 0 0 0 UIParent 0.0 -356.8 -1 ,%-#.#/#0#1#2( 3 5 0 2 2 UIParent -1908.2 -47.2 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4& 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 0 4 4 UIParent 3.4 -137.8 -1 # 5 -1 0 7 7 UIParent -419.2 76.1 -1 # 6 0 0 5 3 MinimapCluster -4.0 57.9 -1 ##$#%#&0(()( 6 1 0 4 4 UIParent -385.7 -220.7 -1 ##$$%$'+(')( 7 -1 0 1 1 UIParent 0.8 -72.3 -1 # 8 -1 0 6 6 UIParent 38.3 42.5 -1 #'$<%$&V 9 -1 0 7 7 UIParent -498.0 229.8 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 1 1 UIParent -466.0 -8.8 -1 # 12 -1 0 5 5 UIParent -59.5 0.8 -1 #;$#%# 13 -1 0 7 7 UIParent 458.3 0.0 -1 ##$#%%&- 14 -1 0 7 7 UIParent 407.4 0.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 1 MainStatusTrackingBarContainer 0.0 0.0 -1 # 16 -1 0 6 6 UIParent 489.4 254.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 0 0 0 UIParent 232.0 -47.7 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ##",
  	}
}

---============================================================================
-- Colors
---============================================================================
I.Constants.ColorsRGB = {
	["red"] = {143, 10, 13},
	["blue"] = {10, 12, 150},
	["cyan"] = {16, 211, 255},
	["teal"] = {0, 150, 89},
	["green"] = {20, 150, 10},
	["grassgreen"] = {50,150,50},
	["darkgreen"] = {5,107,0},
	["yellow"] = {255, 255, 0},
	["white"] = {255, 255, 255},
	["black"] = {0, 0, 0}
}

I.Constants.ColorHex = {
	["orange"] = "|cFFFF8000",
	["purple"] = "|cFFA335EE",
	["brightblue"] = "|cFF0070DE",
	["brightgreen"] = "|cFF0DEB11",
	["yellow"] = "|cFFFFFF00",
	["white"] = "|cFFFFFFFF",
	["close"] = "|r"
}

---============================================================================
-- DEFAULT MEDIA
---============================================================================
I.Constants.Sounds = {
	['Alert'] ='Popup.ogg',
	['CashRegister'] = 'CashRegister.mp3',
	['Choo'] = 'choo.mp3',
	['Dirty'] = 'dirty.mp3',
	['Doublehit'] = 'doublehit.mp3',
	['Dullhit'] = 'dullhit.mp3',
	['Gasp'] = 'gasp.mp3',
	['Heart'] = 'heart.mp3',
	['Himetal'] = 'himetal.mp3',
	['Hit'] = 'hit.mp3',
	['Kachink'] = 'kachink.mp3',
	['Link'] = 'link.mp3',
	['Pop1'] = 'pop1.mp3',
	['Pop2'] = 'pop2.mp3',
	['Shaker'] = 'shaker.mp3',
	['Switchy'] = 'switchy.mp3',
	['Text1'] = 'text1.mp3',
	['Text2'] = 'text2.mp3'
}

I.Constants.Fonts = {
	['ActionMan.ttf'] = {'Action Man'},
	['ContinuumMedium.ttf'] = {'Continuum Medium'},
	['DieDieDie.ttf'] = {'Die Die Die!'},
	['PTSansNarrow.ttf'] = { 'PT Sans Narrow', nil, westAndRU },
	['Expressway.ttf'] = { true, nil, westAndRU },
	['Homespun.ttf'] = { true, nil, westAndRU },
	['Invisible.ttf'] = {}
}