-- File: Teleport.lua
-- Zuletzt geändert: 18. Januar 2015

-- LOCALS
local SGT = {}

SGT.scrollItem = 1
SGT.indexPool = nil
SGT.list = nil

SGT.playerSelected = nil
SGT.zoneSelected = nil
SGT.idSelected = nil
SGT.guildIdSelected = nil

SGT.active = false

SGT.ImperialCity = nil
SGT.Cyrodiil = nil
SGT.ColdHarbour = nil
SGT.Craglore = nil

function SGT.AvailableZones()
  local availableZones =  {}
  local availableCount = 1
  local playerLevel = GetPlayerDifficultyLevel()
  local playerZone = ShissuGT.Lib.CutStringAtLetter(GetPlayerLocationName() , "^") 
  
  --for mapId = 1, GetNumMaps(), 1 do
  --  local zoneName = GetMapInfo(mapId)
  --  d(mapId .. " ---- " .. zoneName)
  --end

  for guildId = 1, GetNumGuilds() do
    if #availableZones == GetNumMaps() - 2 then break end
    
    for memberId = 1, GetNumGuildMembers(guildId) do
      local _, _, memberZone, _, memberAlliance = GetGuildMemberCharacterInfo(guildId, memberId)
      local memberName, _, _ , memberStatus = GetGuildMemberInfo(guildId, memberId)
    
      if GetUnitAlliance("player") == memberAlliance and memberStatus ~= PLAYER_STATUS_OFFLINE then
        for mapId = 1, GetNumMaps(), 1 do
          local zoneName = GetMapInfo(mapId)
          local zoneExist = 0
          local zoneInsert = 0
          local playerInZone = 0
          
          zoneName = ShissuGT.Lib.CutStringAtLetter(zoneName, "^")
          memberZone = ShissuGT.Lib.CutStringAtLetter(memberZone, "^")
          
          if playerZone == zoneName then playerInZone = 1 end
          
          -- Auch entfernen, da man nicht hin joinen kann per Teleport
          if zoneName == SGT.ImperialCity then playerInZone = 1 end
          if zoneName == SGT.Cyrodiil then playerInZone = 1 end
          
          -- Spieler in der Zone, dann ignorieren
          if playerInZone ~= 1 then
            -- Zonen die schon existieren ignorieren 
            for i = 1, #availableZones do
              if availableZones[i].zoneName == zoneName then
                zoneExist = 1
                break
              end
            end      
            
            -- Entspricht der Zone, der Spielerschwierigkeit / Hat der Spieler Zugriff auf die Cadwell-Zone
            if zoneExist ~= 1 then      
              for cadwellDiff = 0, GetNumZonesForDifficultyLevel(1) do
                for cadwellZone = 1, GetNumZonesForDifficultyLevel(1) do
                  local cadwellZone = GetCadwellZoneInfo(cadwellDiff, cadwellZone)
                  cadwellZone = ShissuGT.Lib.CutStringAtLetter(cadwellZone, "^")    
         
                  -- 1. Break
                  if playerLevel == 2 then
                    zoneInsert = 1
                  elseif (zoneName == cadwellZone and playerLevel >= cadwellDiff) or SGT.ColdHarbour == zoneName or SGT.Craglore == zoneName then 
                    zoneInsert = 1 
                    break             
                  end
                end  
                    
                -- 2. Break
                if zoneInsert == 1 then break end     
              end
            end
             
          end
          
          -- Zone erfüllt alle Bedingungen
          if zoneName == memberZone and zoneExist ~= 1 and zoneInsert == 1 and playerInZone ~= 1 then
            availableZones[availableCount] = {}       
            availableZones[availableCount].zoneName = ShissuGT.Lib.CutStringAtLetter(zoneName, "^")
            availableZones[availableCount].playerName = memberName
            availableZones[availableCount].id = memberId
            availableZones[availableCount].guildId = guildId
               
            availableCount = availableCount + 1
            break
          end
        end            
      end 
    end

  end
  
  return availableZones
end

-- Fenster ein/ausblenden
function ShissuGT.Teleport.Toggle()
  if ShissuGT.Settings.Teleport.Enabled == true then
    if SGT_Teleport:IsHidden() then 
      SGT_Teleport:SetHidden(false)
      SGT.FillScrollList()
            
      if not SCENE_MANAGER:IsInUIMode() then SCENE_MANAGER:SetInUIMode(true) end
      ShissuGT.Teleport.Initialize()
    else 
      SGT_Teleport:SetHidden(true)
    end
  else
    ShissuGT.ToChat(ShissuGT.ColoredName .. ": " .. ShissuGT.i18n.Teleport.Disabled .. ShissuGT.Color[3] .. ShissuGT.i18n.Disabled)  
  end
end

-- Teleport zu Zone xyz; Wenn nix ausgewählt Randomteleport
function SGT.Teleport()  
  if not ShissuGT.Lib.IsStringEmpty(SGT.playerSelected) then
    local _, _, memberZone = GetGuildMemberCharacterInfo(SGT.guildIdSelected , SGT.idSelected)
    
    memberZone = ShissuGT.Lib.CutStringAtLetter(memberZone, "^")
    
    JumpToGuildMember(SGT.playerSelected)
  else
    SGT.Random()
  end
end

function ShissuGT.Teleport.Random()
  SGT.Random()
end

-- Zufallsteleport zu irgendeinen Gildenmitglied
function SGT.Random()
  local data = SGT.AvailableZones()
  local count = #data
  local rnd = math.random(0, count)  

  JumpToGuildMember(data[rnd].playerName) 
end

-- Einzelne Listen Einträge erstellen
function SGT.createIndexButton(indexPool)
  local control = ZO_ObjectPool_CreateControl("SGT_Teleport_Index", indexPool, SGT.list.scrollChild)
  local anchorBtn = SGT.scrollItem == 1 and SGT.list.scrollChild or indexPool:AcquireObject(SGT.scrollItem-1)
  
  control:SetAnchor(TOPLEFT, anchorBtn, SGT.scrollItem == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(130)
  control:SetHandler("OnClicked", function(self)
    SGT.playerSelected = self.player
    SGT.zoneSelected = self.zone
    SGT.idSelected = self.id
    SGT.guildIdSelected = self.guildId
     
    SGT.selected:SetHidden(false)
    SGT.selected:ClearAnchors()
    SGT.selected:SetAnchorFill(self)        
  end)
  
  control:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, ShissuGT.Color[5] .. self.player) end)
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)  

  SGT.scrollItem = SGT.scrollItem  + 1
  
  return control
end

-- Einzelne Listen Eintrag entfernen (verstecken)
function SGT.removeIndexButton(control)
  control:SetHidden(true)
end

-- Liste füllen
function SGT.FillScrollList()
  local data = SGT.AvailableZones()
  local sortedTitle = {}
  local sortedData = {}

  local numEntrys = #data

  for i = 1, numEntrys do
    table.insert(sortedTitle, i, data[i].zoneName .. "**shissu" .. i)
  end
  
  table.sort(sortedTitle)
  
  for i = 1, numEntrys do
    local length = string.len(sortedTitle[i])
    local number = string.sub(sortedTitle[i], string.find(sortedTitle[i], "**shissu"), length)
    
    number = string.gsub(number, "**shissu", "")
    number = string.gsub(number, " ", "")
    number = tonumber(number)

    sortedData[i] = {}
    sortedData[i].playerName = data[number].playerName
    sortedData[i].zoneName = data[number].zoneName
  end

  for i = 1, numEntrys do
    local control = SGT.indexPool:AcquireObject(i)
    control.player = sortedData[i].playerName
    control.zone = sortedData[i].zoneName
    control:SetText(ShissuGT.Color[5] .. sortedData[i].zoneName)
    control:SetHidden(false)
  end
  
  local activePages = SGT.indexPool:GetActiveObjectCount()
  if activePages > numEntrys then
    for i = numEntrys + 1, activePages do SGT.indexPool:ReleaseObject(i) end
  end  
end

-- Teleporter Initialize Funktion
function ShissuGT.Teleport.Initialize()
  if SGT.active == true then return false end
  
  local save = ShissuGT.Settings.Teleport

  SGT.ImperialCity = ShissuGT.Lib.CutStringAtLetter(GetMapInfo(26), "^")
  SGT.Cyrodiil = ShissuGT.Lib.CutStringAtLetter(GetMapInfo(14), "^")
  SGT.ColdHarbour = ShissuGT.Lib.CutStringAtLetter(GetMapInfo(23), "^")
  SGT.Craglore = ShissuGT.Lib.CutStringAtLetter(GetMapInfo(25), "^")

  -- UI Elemente  
  ShissuGT.Lib.MoveWindow(SGT_Teleport, "Teleport")
  ShissuGT.Lib.SetWindowPos(SGT_Teleport, "Teleport")
  
  ShissuGT.Lib.SetSGTTitle(SGT_Teleport_Title, ShissuGT.i18n.Teleport.Title)
  ShissuGT.Lib.SetVersionUI(SGT_Teleport_Version)
  ShissuGT.Lib.SetStdColor(SGT_Teleport_Line)

  SGT_Teleport_ButtonTeleport:SetText(ShissuGT.Color[5] .. "Teleport") 
  SGT_Teleport_ButtonRandom:SetText(ShissuGT.Color[5] .. ShissuGT.i18n.Teleport.Random)
  SGT_Teleport_ButtonRefresh:SetText(ShissuGT.Color[6] .. ShissuGT.i18n.Teleport.New)
  
  SGT_Teleport_ButtonRandom:SetHandler("OnClicked", function() SGT.Random() end)
  SGT_Teleport_ButtonTeleport:SetHandler("OnClicked", function() SGT.Teleport() end)
  SGT_Teleport_ButtonRefresh:SetHandler("OnClicked", function()
    for i = 1, (SGT.scrollItem+1) do SGT.indexPool:ReleaseObject(i) end
    SGT.scrollItem = 1
    SGT.FillScrollList()
  end)
  
  SGT.closeTeleportButton = ShissuGT.Lib.CreateCloseButton(SGT_Teleport_Close, SGT_Teleport, ShissuGT.Teleport.Toggle)
  SGT.divider3 = ShissuGT.Lib.CreateBlueLine("SGT_Teleport_Divider", SGT_Teleport, SGT_Teleport_Line, 150)
  
  -- Scrollcontainer + UI
  SGT.indexPool = ZO_ObjectPool:New(SGT.createIndexButton, SGT.removeIndexButton)  
  SGT.list = ShissuGT.Lib.CreateUIList("SGT_Teleport_List", 140, SGT_Teleport, SGT_Teleport_Line, 10, 10, -10)
  
  SGT.selected = WINDOW_MANAGER:CreateControl(nil, SGT.list.scrollChild, CT_TEXTURE)
  SGT.selected:SetTexture("EsoUI\\Art\\Buttons\\generic_highlight.dds")
  ShissuGT.Lib.SetStdColor(SGT.selected)
  SGT.selected:SetHidden(true)
  
  --SGT.FillScrollList()
  
  SGT.active = true
end