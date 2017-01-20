-- File: Member.lua
-- Zuletzt geändert: 15. August 2015

-- LOCALS
local SGT = {}

-- FUNCTIONS
-- Gildenroster aktualisieren, falls modifizierter an ist
function SGT.RefreshGuildRoster()
  if ShissuGT.Settings.Roster then ShissuGT.Roster.RefreshFilters() end
end

-- Charaktername ausgeben, falls Char in den Gilden ist
function SGT.GetCharName(AccName)
  local charName = ""
  if ShissuGT.Lib.CheckVars("Character") then
    for i=1,GetNumGuilds() do
      for y=1, GetNumGuildMembers(i), 1 do
        if ShissuGT.Settings["Guild"..i].Character then            
          local charInfo = {GetGuildMemberCharacterInfo(i, y)}
          local memberInfo = {GetGuildMemberInfo(i, y)}
          
          if memberInfo[1] == AccName then 
            charName = ShissuGT.Lib.CutStringAtLetter(charInfo[2], '^')
            return charName
          end
        else break end
      end
    end
  end
  
  return charName  
end

-- Textnachricht in den Chat, wenn neuer Spieler invitet wird
function ShissuGT.MemberInfo.InviteMessage(playerName, GuildId)
  local ChatMessage
  local ChatMessageArray = ShissuGT.Lib.SplitToArray(ShissuGT.Settings.ContextMenu.InviteMessage["Guild"..GuildId], "|||")
                       
  if not ChatMessageArray == false then
    local CurrentText = CHAT_SYSTEM.textEntry:GetText()
    if string.len(CurrentText) < 1 then
      local rnd = math.random(table.getn(ChatMessageArray)) 
      ChatMessage = string.gsub(ChatMessageArray[rnd], "%%1", playerName)
      
      ShissuGT.Lib.TextToChat("/g" .. GuildId .. " " .. ChatMessage)
    end
  end
end

-- Ist der Charakter mehr als 1x vorhanden?
function SGT.InAnyGuild(accName)
  if accName == nil then return false end
  local found = 0

  for i=1,GetNumGuilds() do
    for y=1, GetNumGuildMembers(i), 1 do
      local accInfo = {GetGuildMemberInfo(i, y)}
      
      if accInfo[1] == accName then found = found +1 break end 
      if found > 1 then return true end               
      if found == GetNumGuilds() then return true end  
    end
  end
  
  if found > 1 then return true end
  return false 
end

-- Gespeicherte AccDaten löschen
function SGT.Remove(accName, guildId)
  guildId = tonumber(guildId)
  
  -- Persönliche Notizen
  if shissuGT.PersonalNote[guildId] ~= nil then  
    if shissuGT.PersonalNote[guildId][accName] ~= nil then 
      if ShissuGT.Settings.ClearMemberData then
        shissuGT.PersonalNote[guildId][accName] = nil
      end
    end
  end
  
  -- Charakternamen
  if shissuGT.MemberChars[accName] ~= nil and (not SGT.InAnyGuild(accName)) then
    if ShissuGT.Settings.ClearMemberData then
      shissuGT.MemberChars[accName] = nil
    end
  end
end

-- EVENTS
-- Gildenmitglied Status
function ShissuGT.MemberInfo.GUILD_MEMBER_PLAYER_STATUS_CHANGED(eventCode, GuildId, AccName, oldStatus, newStatus)  
  function SGT.ToChat(GuildId, AccName, newStatus)
    local color = ShissuGT.Color
       
    if newStatus == 4 then ShissuGT.ToChat(ShissuGT.Lib.ChatText(GuildId, AccName, color[newStatus].."Offline|r"))
    elseif newStatus == 3 then ShissuGT.ToChat(ShissuGT.Lib.ChatText(GuildId, AccName, color[newStatus].."BRB|r"))         
    elseif newStatus == 2 then ShissuGT.ToChat(ShissuGT.Lib.ChatText(GuildId, AccName, color[newStatus].."AFK|r"))
    elseif newStatus == 1 then ShissuGT.ToChat(ShissuGT.Lib.ChatText(GuildId, AccName, color[newStatus].."Online|r")) end
  end                                      

  if ShissuGT.Lib.CheckSingleVar(GuildId,"MemberStatus") == true then SGT.ToChat(GuildId, SGT.GetCharName(AccName) .. AccName, newStatus) end
  SGT.RefreshGuildRoster()
end

-- Neues Gildenmitglied?
function ShissuGT.MemberInfo.GUILD_MEMBER_ADDED(eventCode, guildId, accName)
  if ShissuGT.Lib.CheckSingleVar(guildId,"AddStatus") == true then ShissuGT.ToChat(ShissuGT.Lib.ChatText(guildId, SGT.GetCharName(accName) .. accName, ShissuGT.i18n.Invite)) end  
  if ShissuGT.Settings.ContextMenu.InviteMessage["ActiveE"..guildId] then ShissuGT.MemberInfo.InviteMessage(accName, guildId) end
   
  SGT.RefreshGuildRoster()
end

-- Gildenmitglied hat die Gilde verlassen? (wurde gekickt?)
function ShissuGT.MemberInfo.GUILD_MEMBER_REMOVED(eventCode, guildId, accName)
  if ShissuGT.Lib.CheckSingleVar(guildId,"RemoveStatus") == true then ShissuGT.ToChat(ShissuGT.Lib.ChatText(guildId, SGT.GetCharName(accName) .. accName, ShissuGT.i18n.Leave)) end 
  
  SGT.Remove(accName, guildId)
  SGT.RefreshGuildRoster()
end

-- Gildenmitglied in Sichtfeld?
function ShissuGT.MemberInfo.RETICLE_TARGET_CHANGED(eventCode,Name)
  local target = GetUnitName('reticleover')
  local color = ShissuGT.Color
  
  ZO_Tooltips_HideTextTooltip()
  
  if target ~= "" and ShissuGT.Lib.CheckVars("MemberInSight") then
    for i=1,GetNumGuilds() do
      if ShissuGT.Lib.CheckSingleVar(i, "MemberInSight") then
        for y=1, GetNumGuildMembers(i), 1 do
          local charInfo = {GetGuildMemberCharacterInfo(i, y)}
          if charInfo[2] == GetRawUnitName('reticleover') then
            local name = GetGuildMemberInfo(i,y)
            local text = ""
            local text2 = ""
           
            if ShissuGT.Settings["Guild"..i].Character then name = ShissuGT.Lib.CutStringAtLetter(charInfo[2], "^") .. GetGuildMemberInfo(i,y) end
            
            if ShissuGT.Settings.MemberInSight.More then
              text = ShissuGT.Lib.GetCharInfoIcon(charInfo[4], text, true)
              text = ShissuGT.Lib.GetCharInfoIcon(charInfo[5], text)

              if charInfo[7] == 0 then
                text2 = ShissuGT.Color[5] .. " (".. ShissuGT.Color[6] .. "LvL " .. ShissuGT.Color[5] .. charInfo[6] .. ")"
              else
                text2 = ShissuGT.Color[5] .. " (".. ShissuGT.Color[6] .. "VR " .. ShissuGT.Color[5] .. charInfo[7] .. ")"
              end
            end
            
            text = text .. name .. text2
            ZO_Tooltips_ShowTextTooltip(SGT_MemberInSight, TOPRIGHT, color[6] .. text .. "|r\n" ..color[5] .. GetGuildName(i) )       
            return true
          end
        end
      end
    end
  end
end