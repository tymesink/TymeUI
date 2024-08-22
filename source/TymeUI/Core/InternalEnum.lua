local TYMEUI, F, I, E = unpack(TymeUI)

I.Enum = {}

-- IDs for layouts
I.Enum.Layouts = F.Enum { "Default" }

-- Used for F.String.Color functions
I.Enum.Colors = F.Enum {
  "TYMEUI", -- AddOnColor
  "ELVUI", -- ElvUI Default Blue color
  "ELVUI_VALUE", -- Dynamic ElvUI Value Color
  "CLASS", -- Dynamic Class Color
  "GOOD", -- Bright Green
  "ERROR", -- Bright Red
  "INSTALLER_WARNING", -- Contrast Red
  "WARNING", -- Yelloish color
  "WHITE",
  "SILVER",
  "GOLD",
  "LEGENDARY",
  "EPIC",
  "RARE",
  "BETA",
}

-- Used for gradient theme
I.Enum.GradientMode = {
  Direction = F.Enum { "LEFT", "RIGHT" },
  Mode = F.Enum { "HORIZONTAL", "VERTICAL" },
  Color = F.Enum { "SHIFT", "NORMAL" },
}
