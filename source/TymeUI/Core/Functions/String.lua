local TYMEUI, F, I, E = unpack(TymeUI)

local COVENANT_COLORS = COVENANT_COLORS
local format = string.format
local gmatch = string.gmatch
local gsub = string.gsub
local strmatch = strmatch
local strtrim = strtrim
local type = type
local tonumber = tonumber
local utf8len = string.utf8len
local utf8lower = string.utf8lower
local utf8sub = string.utf8sub
local utf8upper = string.utf8upper

F.String = {}

function F.String.HexToRGB(hex)
  local r, g, b, a = strmatch(hex, "^#?(%x%x)(%x%x)(%x%x)(%x?%x?)$")
  if not r then return 0, 0, 0, nil end
  return tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255, (a ~= "") and (tonumber(a, 16) / 255) or nil
end

function F.String.HexToRGBA(hex)
  -- Remove the |c prefix
  hex = hex:gsub("|c", "")
    
  local alphaHex = hex:sub(1, 2)
  local redHex = hex:sub(3, 4)
  local greenHex = hex:sub(5, 6)
  local blueHex = hex:sub(7, 8)
  
  local alpha = tonumber(alphaHex, 16) / 255
  local red = tonumber(redHex, 16) / 255
  local green = tonumber(greenHex, 16) / 255
  local blue = tonumber(blueHex, 16) / 255

  return alpha, red, green, blue
end

function F.String.Class(msg, class)
  local finalClass = class or E.myclass

  local color = E:ClassColor(finalClass, true)
  return F.String.Color(msg, F.String.FastRGB(color.r, color.g, color.b))
end

-- Capture the following strings
-- .+%s(.+)$
-- . represents all characters
-- + makes us capture 1 or more repetitions of the previous character/symbol will always match the longest possible part
-- %s represents all space characters
-- $ at the end makes the pattern match to the end of the string
-- Example: "Lightweave Embroidery" captures "Embroidery"
function F.String.GetTheLastWordOfAString(text)
  return strmatch(text, ".+%s(.+)$")
end

-- Capture the following string
-- ^[%s%p]*
-- ^ forces us to start capturing at the start of the string
-- %s represents all space characters
-- %p represents all punctuation characters
-- * matches 0 or more repetitions of the previous character/symbol/pattern
-- [] is a capture group
-- This would capture the start of the string and replace all spaces with nothing (but most likely isn't working)
function F.String.RemoveAllWhitespaceCharacters(text)
  return text:gsub("^[%s%p]*", "")
end

-- Capture the following string
-- %d+
-- %d represents all digits
-- this would capture the longest number chain in a string
function F.String.ContainsNumericalCharacters(text)
  return strmatch(text, "%d+")
end

-- Capture the following string
-- %d+
-- %d represents all digits
-- this would capture the longest number chain in a string
function F.String.RemoveTheLongestNumericalChain(text)
  return text:gsub("%D+", "")
end

function F.String.Abbreviate(text)
  if type(text) ~= "string" or text == "" then return text end

  -- if string has Rune at the start it is almost 100% a DK Rune and needs some different initial logic.
  if strmatch(text, "^Rune") then
    text = F.String.RemoveRuneOfThePrefix(text)
  else
    text = F.String.RemoveEveryOfTheAndEverythingAfter(text)
  end

  local letters = ""
  local lastWord = F.String.GetTheLastWordOfAString(text)
  if not lastWord then return text end

  -- split the string on each space and loop through them
  -- If we have a string that contains numbers we will add them differently to the stringbuilder
  -- If we have an alphabetical word we check if the first letter is Uppercase, if this is the case add it to the resulting string with a . after it
  -- Else we ignore the word
  for word in gmatch(text, ".-%s") do
    local firstLetter = F.String.RemoveAllWhitespaceCharacters(word)

    if not F.String.ContainsNumericalCharacters(firstLetter) then
      firstLetter = utf8sub(firstLetter, 1, 1)
      if firstLetter ~= utf8lower(firstLetter) then
        -- combine letters value with firstletter value, and then add a . and space
        letters = format("%s%s. ", letters, firstLetter)
      end
    else
      firstLetter = F.String.RemoveTheLongestNumericalChain(firstLetter)
      -- combine letters value with firstLetter value and then add a space
      letters = format("%s%s ", letters, firstLetter)
    end
  end

  -- Combine the build string in the loop and the complete last word
  return format("%s%s", letters, lastWord)
end

E.TagFunctions.Abbrev = F.String.Abbreviate

function F.String.Uppercase(text)
  if type(text) ~= "string" then return text end
  return utf8upper(text)
end

function F.String.Lowercase(text)
  if type(text) ~= "string" then return text end
  return utf8lower(text)
end

function F.String.UppercaseFirstLetter(text)
  if type(text) ~= "string" then return text end
  return utf8upper(utf8sub(text, 1, 1)) .. utf8sub(text, 2)
end

function F.String.UppercaseFirstLetterOnly(text)
  if type(text) ~= "string" then return text end
  return utf8upper(utf8sub(text, 1, 1)) .. utf8lower(utf8sub(text, 2))
end

function F.String.LowercaseEnum(text)
  if type(text) ~= "string" then return text end
  return strtrim(text):gsub("_", " "):gsub("(%a)([%w_']*)", function(a, b)
    return F.String.Uppercase(a) .. F.String.Lowercase(b)
  end)
end

function F.String.StripTexture(text)
  if type(text) ~= "string" then return text end
  return gsub(text, "(%s?)(|?)|[TA].-|[ta](%s?)", function(w, x, y)
    if x == "" then return (w ~= "" and w) or (y ~= "" and y) or "" end
  end)
end

function F.String.StripColor(text)
  if type(text) ~= "string" then return text end
  -- Remove |c...|r format
  text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
  -- Remove |cn...: format
  text = text:gsub("|cn.-:(.-)|r", "%1")
  -- Remove any remaining |r
  text = text:gsub("|r", "")
  -- Remove any remaining |
  text = text:gsub("|", "")

  return text
end

function F.String.Strip(text)
  if type(text) ~= "string" then return text end
  return F.String.StripColor(F.String.StripTexture(text))
end

function F.String.Trim(text)
  return strmatch(text, "^%s*(.*%S)") or ""
end
