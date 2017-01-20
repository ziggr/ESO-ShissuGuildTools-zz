-- File: GuildColor.lua
-- Zuletzt geändert: 04. August 2015

local SGT_GuildColor = {}

function ShissuGT.GuildColor.Toogle()  
  if ShissuGT.Settings.GuildColor == true then SGT_GuildColor.Toogle(false)       
  else SGT_GuildColor.Toogle(true) end  
end

function SGT_GuildColor.Toogle(bool)
  local SGT = SGT_GuildColor
  
  SGT.DescriptionStandard1:SetHidden(bool)                                                                         
  SGT.DescriptionStandard2:SetHidden(bool)    
  SGT.DescriptionStandard3:SetHidden(bool) 
  SGT.DescriptionStandard4:SetHidden(bool)    
  SGT.DescriptionANY:SetHidden(bool)  
  SGT.MotDStandard1:SetHidden(bool)    
  SGT.MotDStandard2:SetHidden(bool)  
  SGT.MotDStandard3:SetHidden(bool)  
  SGT.MotDStandard4:SetHidden(bool)         
  SGT.MotDANY:SetHidden(bool)   
  SGT.NoteStandard1:SetHidden(bool)    
  SGT.NoteStandard2:SetHidden(bool)  
  SGT.NoteStandard3:SetHidden(bool)  
  SGT.NoteStandard4:SetHidden(bool)         
  SGT.NoteANY:SetHidden(bool)               
end

function SGT_GuildColor.CreateZOButton(name, text, width, offsetX, offsetY, anchor, control)
  local button = CreateControlFromVirtual(name, anchor, "ZO_DefaultTextButton")
  local editbox = ZO_EditNoteDialogNoteEdit
  local buttonlabel = "SGT_GuildColor_Note"
    
  button:SetText(text)
  button:SetAnchor(TOPLEFT, anchor, TOPLEFT, offsetX, offsetY)
  button:SetWidth(width)
  
  if control == 0 then
    editbox = ZO_GuildHomeInfoDescriptionSavingEdit
    buttonlabel = "SGT_GuildColor_Description"
  elseif control == 1 then
    editbox = ZO_GuildHomeInfoMotDSavingEdit
    buttonlabel = "SGT_GuildColor_MotD"  
  end
  
  button:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
  button:SetHandler("OnMouseEnter", function() 
    local colorString =  string.gsub(button:GetName(), buttonlabel, "") 
    
    ShissuGT.Lib.ToolTip(button, ShissuGT.i18n.Color[colorString]) 
  end)

  button:SetHandler("OnClicked", function()    
    local cache = editbox:GetText()   
    local colorString =  string.gsub(button:GetName(), buttonlabel , "")

    if colorString == "ANY" then
      EVENT_MANAGER:RegisterForUpdate("ShissuGT_COLORPICKER", 100, function()   
        if (ShissuGT.Lib.HexColor ~= nil) then 
          editbox:SetText(cache .. "|c" .. ShissuGT.Lib.HexColor .. "YOURTEXT|r")    
          ShissuGT.Lib.HexColor = nil
          EVENT_MANAGER:UnregisterForUpdate("ShissuGT_COLORPICKER")  
        end
      end)

      ShissuGT.Lib.ColorPicker()    
    else
      editbox:SetText(cache .. ShissuGT.userColor[tonumber(colorString)] .. "YOURTEXT|r")    
    end
  end)
   
  return button
end

function SGT_GuildColor.SetColor(number)
  if ShissuGT.Settings.Color[number] then
    ShissuGT.userColor[number] = "|c" .. ShissuGT.Lib.RGBtoHex(ShissuGT.Settings.Color[number][1], ShissuGT.Settings.Color[number][2], ShissuGT.Settings.Color[number][3])
  end    
end

function ShissuGT.GuildColor.Initialize()
  local CL = SGT_GuildColor.CreateZOButton
  local white = ShissuGT.Color[5]
  
  ShissuGT.GuildColor.Active = true
  
  -- Erstellen der neuen UI-Elemente
  SGT_GuildColor.DescriptionStandard1 = CL("SGT_GuildColor_Description1", white .. "[ " .. ShissuGT.userColor[1] .. "1" .. white .. " ]", 50, 100, -35, ZO_GuildHomeInfoDescriptionSavingEdit, 0)
  SGT_GuildColor.DescriptionStandard2 = CL("SGT_GuildColor_Description2", white .. "[ " .. ShissuGT.userColor[2] .. "2" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Description1, 0)
  SGT_GuildColor.DescriptionStandard3 = CL("SGT_GuildColor_Description3", white .. "[ " .. ShissuGT.userColor[3] .. "3" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Description2, 0)
  SGT_GuildColor.DescriptionStandard4 = CL("SGT_GuildColor_Description4", white .. "[ " .. ShissuGT.userColor[4] .. "4" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Description3, 0)
  SGT_GuildColor.DescriptionANY = CL("SGT_GuildColor_DescriptionANY", white .. "[ ANY ]", 80, 40, 0, SGT_GuildColor_Description4, 0)

  SGT_GuildColor.MotDStandard1 = CL("SGT_GuildColor_MotD1", white .. "[ " .. ShissuGT.userColor[1] .. "1" .. white .. " ]", 50, 200, -35, ZO_GuildHomeInfoMotDSavingEdit, 1)
  SGT_GuildColor.MotDStandard2 = CL("SGT_GuildColor_MotD2", white .. "[ " .. ShissuGT.userColor[2] .. "2" .. white .. " ]", 50, 40, 0, SGT_GuildColor_MotD1, 1)
  SGT_GuildColor.MotDStandard3 = CL("SGT_GuildColor_MotD3", white .. "[ " .. ShissuGT.userColor[3] .. "3" .. white .. " ]", 50, 40, 0, SGT_GuildColor_MotD2, 1)
  SGT_GuildColor.MotDStandard4 = CL("SGT_GuildColor_MotD4", white .. "[ " .. ShissuGT.userColor[4] .. "4" .. white .. " ]", 50, 40, 0, SGT_GuildColor_MotD3, 1)
  SGT_GuildColor.MotDANY = CL("SGT_GuildColor_MotDANY", white .. "[ ANY ]", 80, 40, 0, SGT_GuildColor_MotD4, 1)

  ZO_EditNoteDialogNote:SetAnchor (3, ZO_EditNoteDialogDisplayName, 3, 0, 60)
  SGT_GuildColor.NoteStandard1 = CL("SGT_GuildColor_Note1", white .. "[ " .. ShissuGT.userColor[1] .. "1" .. white .. " ]", 50, 50, 30, ZO_EditNoteDialogDisplayName, 2)
  SGT_GuildColor.NoteStandard2 = CL("SGT_GuildColor_Note2", white .. "[ " .. ShissuGT.userColor[2] .. "2" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Note1, 2)
  SGT_GuildColor.NoteStandard3 = CL("SGT_GuildColor_Note3", white .. "[ " .. ShissuGT.userColor[3] .. "3" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Note2, 2)
  SGT_GuildColor.NoteStandard4 = CL("SGT_GuildColor_Note4", white .. "[ " .. ShissuGT.userColor[4] .. "4" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Note3, 2)
  SGT_GuildColor.NoteANY = CL("SGT_GuildColor_NoteANY", white .. "[ ANY ]", 80, 40, 0, SGT_GuildColor_Note4, 2)  
  
  -- Mausclicks in den EditBoxen (MotD, Rest Standard) erlauben
  GUILD_HOME.motd.editBackdrop:SetDrawLayer(1)
end