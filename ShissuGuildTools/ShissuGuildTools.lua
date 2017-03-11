-- --------------------
-- Shissu's Guild Tools
-- --------------------
--
-- Eine Sammmlung von verschienden Tools, um die Arbeit & Organisation in Gilden zu erleichtern.
-- Ich hoffe, dies kann euch ein bisschen weiterhelfen.
--
-- (c) 2014 - Januar 2016 by Shissu
--
-- Zuletzt geändert: 19. Januar 2016

-- LOCALS
local SGT = {}

function ShissuGT.ToChat(text)
  if text == nil then return end
  CHAT_SYSTEM:AddMessage(text)
end

function ShissuGT.Lib.MoveWindow(control, variable, variable2)  
  control:SetHandler("OnReceiveDrag", function(self) self:StartMoving() end)
  control:SetHandler("OnMouseUp", function(self)
    self:StopMovingOrResizing()
    local _, point,_, relativePoint, offsetX, offsetY = self:GetAnchor()
    
    if variable2 ~= nil then
      ShissuGT.Settings[variable][variable2].offsetX = offsetX
      ShissuGT.Settings[variable][variable2].offsetY = offsetY
      ShissuGT.Settings[variable][variable2].point = point
      ShissuGT.Settings[variable][variable2].relativePoint = relativePoint
    else
      ShissuGT.Settings[variable].offsetX = offsetX
      ShissuGT.Settings[variable].offsetY = offsetY
      ShissuGT.Settings[variable].point = point
      ShissuGT.Settings[variable].relativePoint = relativePoint    
    end
  end)
end

function NNNOTE()
  local dddddddd = 0
  
  shissuGT.TAGE = {}
  
  for memberIndex = 1, GetNumGuildMembers(1), 1 do
    local memberInfo = { GetGuildMemberInfo(1, memberIndex) }  
    local HALLO = 0   
    local note = ""

    for guildID=2, GetNumGuilds() do 
      for y=1, GetNumGuildMembers(guildID), 1 do
      
        local memberInfo2 = {GetGuildMemberInfo(guildID, y)}  
  
        if memberInfo[1] == memberInfo2[1] then
          HALLO = 1
          
          note = note .. "   " .. GetGuildName(guildID)
        end
      end  
    end
   
    if HALLO == 1 then 
      dddddddd = dddddddd + 1
      HALLO = 0 
      
      zo_callLater(function()
        
        shissuGT.TAGE[memberInfo[1]] = note

      end, 500)
    
    end
  
  end
  
  d(dddddddd)
end

-- FUNCTIONS
-- Initialize
function SGT.Initialize()
  local SGT_S = ShissuGT.Settings 
  local SGT_C = ShissuGT.Lib.CheckVars
  local SGT_N = ShissuGT.Name
  local ContextMenu = ShissuGT.Settings.ContextMenu
  
  -- User Farben laden
  ShissuGT.Lib.SetUserColor(1)    
  ShissuGT.Lib.SetUserColor(2)
  ShissuGT.Lib.SetUserColor(3)
  ShissuGT.Lib.SetUserColor(4)
  
  SGT_Feedback_Note:SetText(ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.Feedback[2]))
  
  zo_callLater(function()   
    if SGT_C("MemberStatus") then EVENT_MANAGER:RegisterForEvent(SGT_N, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, ShissuGT.MemberInfo.GUILD_MEMBER_PLAYER_STATUS_CHANGED) end   
    if SGT_C("AddStatus") then EVENT_MANAGER:RegisterForEvent(SGT_N, EVENT_GUILD_MEMBER_ADDED, ShissuGT.MemberInfo.GUILD_MEMBER_ADDED) end   
    if SGT_C("RemoveStatus") then EVENT_MANAGER:RegisterForEvent(SGT_N, EVENT_GUILD_MEMBER_REMOVED, ShissuGT.MemberInfo.GUILD_MEMBER_REMOVED) end   
  end, 1000); 

  if SGT_S.KioskTimer == true then ShissuGT.Misc.KioskTimer() end
  
  if (not SGT_S.MailDelNotification) then MAIL_INBOX.Delete = ShissuGT.Misc.DisabledMailDeleteNotification end

  if SGT_C("MemberInSight") then 
    ShissuGT.Lib.MoveWindow(SGT_MemberInSight, "MemberInSight")
    ShissuGT.Lib.SetWindowPos(SGT_MemberInSight, "MemberInSight")

    EVENT_MANAGER:RegisterForEvent(SGT_N, EVENT_RETICLE_TARGET_CHANGED, ShissuGT.MemberInfo.RETICLE_TARGET_CHANGED)
  end


  --shissuGT.SUD = {} for y=1, GetNumGuildMembers(2), 1 do Meow={GetGuildMemberInfo(2, y)} d(table.insert(shissuGT.SUD, Meow[1])) end

  ShissuGT.Chat.Initialize()
    
  SGT.LOADER("Notebook")
  SGT.LOADER("Teleport")
  SGT.LOADER("GuildColor")
  SGT.LOADER("AutoAFK")
  SGT.LOADER("Roster")
  SGT.LOADER("History")

  if (ContextMenu.SendMail or ContextMenu.Invite) then ShissuGT.Context.Chat() end
  if (ContextMenu.MailInvite or ContextMenu.Mail) then ZO_MailInboxRow_OnMouseUp = ShissuGT.Context.MailOnMouseUp end
  if (ContextMenu.Guild) then GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = ShissuGT.Context.GuildRosterRow_OnMouseUp end  
end

function SGT.LOADER(variable)  
  if ShissuGT.Settings[variable] then ShissuGT[variable].Initialize() 
    return
  elseif ShissuGT.Settings[variable] == false then
    return
  end
    
  if ShissuGT.Settings[variable] ~= nil then
    if ShissuGT.Settings[variable].Enabled ~= nil then
      if ShissuGT.Settings[variable].Enabled then ShissuGT[variable].Initialize() end
    end
  end
end

-- EVENTS             
function SGT.LOADED (eventCode, addOnName)  
  if addOnName ~= ShissuGT.Name then return end

  -- Einstellungen laden
  ShissuGT.Settings = ZO_SavedVars:NewAccountWide("shissuGT", 1, nil, ShissuGT.SettingsDefault, nil)
   
  -- 1 Sekunde warten, nach dem Aufbau der UI
  zo_callLater(function()  
    SGT.Initialize()  
    ShissuGT.Loaded = true
    ShissuGT.CreateSettingsMenu()
    ShissuGT.SlashCommand()
    
    ShissuGT.ToChat(ShissuGT.ColoredName.. " v".. ShissuGT.Version)
  end, 1000); 
  
  -- direkt wieder Event entfernen um Ressourcen zu sparen 
  EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_ADD_ON_LOADED, SGT.LOADED)