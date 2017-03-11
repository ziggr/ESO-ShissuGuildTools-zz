-- File: Misc.lua
-- Zuletzt geändert: 19. Juni 2015

-- Helm ein-&/ausblenden
function ShissuGT.Misc.HelmToogle()
  local cacheSetting = GetSetting( SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_HIDE_HELM )
  SetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_HIDE_HELM, 1 - cacheSetting)
end

-- Interface neuladen
function ShissuGT.Misc.ReloadUI()
  SLASH_COMMANDS["/reloadui"]()
end

-- Chat Button - Notizblock, Teleport
function ShissuGT.Misc.ChatButton(button)
  if button == 1 then ShissuGT.Notebook.Toggle()
  elseif button == 2 then ShissuGT.Teleport.Toggle() end
end

-- Spielerstatus Wechsel, zuvor allerdings überprüfen ob der Spieler nicht schon diesen Status hat.
function ShissuGT.Misc.TogglePlayerStatus(status)
  local newStatus = GetPlayerStatus() == status and PLAYER_STATUS_ONLINE or status  
  SelectPlayerStatus(newStatus)
  
  return true
end

local SGT_AutoAFK = PLAYER_STATUS_ONLINE
local SGT_AutoAFKEnabled = 0

-- AutoAFK: Spielerstatus -> AFK -> Online/BRB ||||| Bewegungen in der UI
function ShissuGT.Misc.EVENT_UI_MOVEMENT()
  if ShissuGT.Settings.AutoAFK and GetPlayerStatus() == PLAYER_STATUS_AWAY and SGT_AutoAFKEnabled == 1 then  
    EVENT_MANAGER:UnregisterForUpdate("ShissuGT_AutoAFK")
    SelectPlayerStatus(SGT_AutoAFK)
    SGT_AutoAFKEnabled = 0
  end
end

-- AutoAFK: Spielerstatus -> AFK -> Online/BRB
function ShissuGT.Misc.EVENT_PLAYER_STATUS_CHANGED(eventCode, oldStatus, newStatus)
  SGT_AutoAFK = oldStatus

  if SGT_AutoAFK == PLAYER_STATUS_OFFLINE then SGT_AutoAFK = PLAYER_STATUS_ONLINE end
    
  if ShissuGT.Settings.AutoAFK then  
    if newStatus == PLAYER_STATUS_AWAY then        
      EVENT_MANAGER:RegisterForUpdate("ShissuGT_AutoAFK", 500, function()
        if IsPlayerMoving() and GetPlayerStatus() == PLAYER_STATUS_AWAY then
          EVENT_MANAGER:UnregisterForUpdate("ShissuGT_AutoAFK")
          
          if SGT_AutoAFKEnabled == 1 then 
            SelectPlayerStatus(SGT_AutoAFK)  
            SGT_AutoAFKEnabled = 0
          end
        end         
      end)
    end
    
    if newStatus == PLAYER_STATUS_ONLINE  or newStatus == PLAYER_STATUS_DO_NOT_DISTURB then
      EVENT_MANAGER:RegisterForUpdate("ShissuGT_AutoAFK", 1 * 60 * 1000 , function()
        if not IsPlayerMoving() and (GetPlayerStatus() == PLAYER_STATUS_ONLINE or GetPlayerStatus() == PLAYER_STATUS_DO_NOT_DISTURB) then
          EVENT_MANAGER:UnregisterForUpdate("ShissuGT_AutoAFK")
          SelectPlayerStatus(PLAYER_STATUS_AWAY)
          SGT_AutoAFKEnabled = 1
        end         
      end)
    end
  end     
end

ShissuGT.AutoAFK = {}

function ShissuGT.AutoAFK.Initialize()
  EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_PLAYER_STATUS_CHANGED, ShissuGT.Misc.EVENT_PLAYER_STATUS_CHANGED)
  EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_NEW_MOVEMENT_IN_UI_MODE, ShissuGT.Misc.EVENT_UI_MOVEMENT)
  EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_RETICLE_HIDDEN_UPDATE, ShissuGT.Misc.EVENT_UI_MOVEMENT)
end

