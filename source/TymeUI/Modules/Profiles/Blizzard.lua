local TYMEUI, F, I, E = unpack(TymeUI)
local PF = TYMEUI:GetModule("Profiles")
local next = next
local C_EditMode = C_EditMode
local GetLayouts = C_EditMode.GetLayouts
local ConvertStringToLayoutInfo = C_EditMode.ConvertStringToLayoutInfo;
local SaveLayout = C_EditMode.SaveLayout;


local BuildProfile = function()
  F.Chat('chat', 'Build Blizzard Profile...');

  -- Call the function to get the layouts
  local layouts = GetLayouts()

  -- Check if layouts are returned
  if layouts then
      -- Print the number of layouts
      F.Chat('chat', 'Number of layouts: ' .. #layouts)
      
      -- Iterate through each layout in the table
      for index, layout in ipairs(layouts) do
          -- Print layout details
          F.Chat('chat', 'Index: ' .. index)
          F.Chat('chat', 'Layout ID: ' .. layout.layoutID)
          F.Chat('chat', 'Layout Name: ' .. layout.layoutName)
          -- Add more fields as needed
      end
  else
      F.Chat('chat', 'No layouts found.')
  end
  
end



local function SetDefaultLayoutForCharacter()
  -- Retrieve the default layout string
  local defaultLayoutString = I.Strings.LayoutConfigs[I.Enum.Layouts.Default]
  
  -- Check if the C_EditMode API is available
  if not C_EditMode then
      print("C_EditMode API is not available.")
      return
  end

  if not ConvertStringToLayoutInfo or not C_EditMode.SaveLayout then
    print("C_EditMode.ConvertStringToLayoutInfo API is not available.")
    return
  end

  if not SaveLayout then
    print("C_EditMode.SaveLayout API is not available.")
    return
  end
  
  -- Convert the string to layout info
  local layoutInfo = C_EditMode.ConvertStringToLayoutInfo(defaultLayoutString)
  
  -- Check if the conversion was successful
  if not layoutInfo then
      print("Failed to convert layout string to layout info.")
      return
  end
  
  -- Save the layout for the character
  local layoutName = "Default-Layout-"..F.GetCharName(true)
  local layoutType = Enum.EditModeLayoutType.CharacterSpecific
  --C_EditMode.SaveLayout(layoutInfo, layoutName, layoutType)
  
  print(layoutName.." has been set for the character.")
end

function PF:MergeBlizzardProfile()
    F.Chat('chat', 'Profiles:MergeBlizzardProfile()');
    SetDefaultLayoutForCharacter();
    --DebugEditMode()
    --BuildProfile()
end