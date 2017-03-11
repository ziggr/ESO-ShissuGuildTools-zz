-- File: ContextMenu.lua
-- Zuletzt geändert: 09. Januar 2016

-- LOCALS
local SGT_Context = {}

-- Original ZOS Code
local ZOS_ShowPlayerContextMenu = CHAT_SYSTEM.ShowPlayerContextMenu
local ZOS_MailInboxRow_OnMouseUp = ZO_MailInboxRow_OnMouseUp

-- FUNCTIONS
-- KONTEXTMENÜ: Chat
function ShissuGT.Context.Chat()
  CHAT_SYSTEM.ShowPlayerContextMenu = function(self, displayName, rawName)
    ZOS_ShowPlayerContextMenu(self, displayName, rawName)
  
    if ShissuGT.Settings.ContextMenu.SendMail or ShissuGT.Settings.ContextMenu.Invite then SGT_Context.Head() end
    
    if ShissuGT.Settings.ContextMenu.SendMail then   
      AddMenuItem(ShissuGT.Color[5] .. ShissuGT.i18n.Setting.NewMail, function() SCENE_MANAGER:Show('mailSend') ZO_MailSendToField:SetText(displayName) end)       
    end
    
    if ShissuGT.Settings.ContextMenu.Invite then SGT_Context.Guilds(displayName) end  
    if ZO_Menu_GetNumMenuItems() > 0 then ShowMenu() end
  end
end

-- KONTEXTMENÜ: E-Mail Fenster (Empfangen)
function ShissuGT.Context.MailOnMouseUp(control, button)
  ClearMenu()
  ZOS_MailInboxRow_OnMouseUp(control)

  if (button ~= 2) then return end
  if (ShissuGT.Settings.ContextMenu.MailInvite or ShissuGT.Settings.ContextMenu.Mail) then SGT_Context.Head(0) end
 
  if ShissuGT.Settings.ContextMenu.Mail then        
    AddMenuItem(ShissuGT.Color[5] .. ShissuGT.i18n.Setting.NewMail, function() SCENE_MANAGER:Show('mailSend') ZO_MailSendToField:SetText(GetMailSender(control.dataEntry.data.mailId)) end)         
    AddMenuItem(ShissuGT.Color[5] .. ShissuGT.i18n.Context.Answer, function() 
      SCENE_MANAGER:Show('mailSend') 
      ZO_MailSendToField:SetText(GetMailSender(control.dataEntry.data.mailId)) 
      ZO_MailSendSubjectField:SetText("AW: " .. control.dataEntry.data.subject) 
    end) 
        
    AddMenuItem(ShissuGT.Color[5] .. ShissuGT.i18n.Context.Forward, function() 
      SCENE_MANAGER:Show('mailSend') 
      ZO_MailSendSubjectField:SetText("WG: " .. control.dataEntry.data.subject) 
      ZO_MailSendBodyField:SetText(ZO_MailInboxMessageBody:GetText()) 
    end)    
    
    AddMenuItem(ShissuGT.Color[5] .. ShissuGT.i18n.Context.Del, function() 
      DeleteMail(control.dataEntry.data.mailId, control.dataEntry.data.confirmedDelete)
      MAIL_INBOX:RefreshData()
    end)    
  end
  
  if ShissuGT.Settings.ContextMenu.MailInvite then SGT_Context.Guilds(GetMailSender(control.dataEntry.data.mailId)) end 
  ShowMenu()
end

-- KONTEXTMENÜ: Gildenroster
-- Original ZOS Code + SGT Code: esoui\ingame\guild\keyboard\guildroster_keyboard.lua
-- Original Version Date: 01.09.2015
function ShissuGT.Context.GuildRosterRow_OnMouseUp(self, control, button, upInside)
  if (button ~= MOUSE_BUTTON_INDEX_RIGHT and not upInside) then return end
  
  ClearMenu()

  local data = ZO_ScrollList_GetData(control)
  
  if data then
    local guildId = GUILD_ROSTER_MANAGER:GetGuildId()
    local guildName = GUILD_ROSTER_MANAGER:GetGuildName()
    local guildAlliance = GUILD_ROSTER_MANAGER:GetGuildAlliance()
    
    local dataIndex = data.index
    local playerIndex = GetPlayerGuildMemberIndex(guildId)        
    local masterList = GUILD_ROSTER_MANAGER:GetMasterList()
    local playerData = masterList[playerIndex]
    local playerHasHigherRank = playerData.rankIndex < data.rankIndex
    local playerIsGuildmaster = IsGuildRankGuildMaster(guildId, playerData.rankIndex)
    
    if(DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_PROMOTE)) then
      if(data.rankIndex > 1) then                
        if(playerData.rankIndex < (data.rankIndex - 1)) then
          AddMenuItem(GetString(SI_GUILD_PROMOTE), function() GuildPromote(guildId, data.displayName); PlaySound(SOUNDS.GUILD_ROSTER_PROMOTE) end)
        elseif(playerIsGuildmaster) then
          AddMenuItem(GetString(SI_GUILD_PROMOTE), function()
            local allianceIcon = zo_iconFormat(GetAllianceBannerIcon(guildAlliance), 17, 17)
            local rankName = GetFinalGuildRankName(guildId, 2)
            ZO_Dialogs_ShowDialog("PROMOTE_TO_GUILDMASTER", {guildId = guildId, displayName = data.displayName}, { mainTextParams = { data.displayName, allianceIcon, guildName,  rankName}})  
          end)
        end
      end
    end
    
    if(DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_DEMOTE)) then
      if(data.rankIndex < GetNumGuildRanks(guildId)) then
        if(playerHasHigherRank) then
          AddMenuItem(GetString(SI_GUILD_DEMOTE), function()
            GuildDemote(guildId, data.displayName)
            PlaySound(SOUNDS.GUILD_ROSTER_DEMOTE)
          end)
        end
      end            
    end
    
    if(DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_REMOVE)) then
      if(playerHasHigherRank and playerIndex ~= dataIndex) then
        local allianceIcon = zo_iconFormat(GetAllianceBannerIcon(guildAlliance), 17, 17)
        AddMenuItem(GetString(SI_GUILD_REMOVE), function()
          ZO_Dialogs_ShowDialog("GUILD_REMOVE_MEMBER", {guildId = guildId,  displayName = data.displayName}, { mainTextParams = { data.displayName, allianceIcon, guildName }})                                                                
        end)
      end
    end
    
    if(DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_NOTE_EDIT)) then
      AddMenuItem(GetString(SI_SOCIAL_MENU_EDIT_NOTE),    function()
        ZO_Dialogs_ShowDialog("EDIT_NOTE", {displayName = data.displayName, note = data.note, changedCallback = GUILD_ROSTER_MANAGER:GetNoteEditedFunction()})
      end)
    end
    
    if(dataIndex == playerIndex) then
      ZO_AddLeaveGuildMenuItem(guildId)
    else
      if(data.hasCharacter and data.online) then
        AddMenuItem(GetString(SI_SOCIAL_LIST_SEND_MESSAGE), function() StartChatInput("", CHAT_CHANNEL_WHISPER, data.displayName) end)
        
        if(data.alliance == GetUnitAlliance("player")) then
          AddMenuItem(GetString(SI_SOCIAL_MENU_INVITE), function() 
            local NOT_SENT_FROM_CHAT = false
            local DISPLAY_INVITED_MESSAGE = true
            TryGroupInviteByName(data.displayName, NOT_SENT_FROM_CHAT, DISPLAY_INVITED_MESSAGE) 
          end)
          
          AddMenuItem(GetString(SI_SOCIAL_MENU_JUMP_TO_PLAYER), function() JumpToGuildMember(data.displayName) end)
        end
      end
      
      AddMenuItem(GetString(SI_SOCIAL_MENU_SEND_MAIL), function() MAIL_SEND:ComposeMailTo(data.displayName) end)
      
      if(not IsFriend(data.displayName)) then
        AddMenuItem(GetString(SI_SOCIAL_MENU_ADD_FRIEND), function() ZO_Dialogs_ShowDialog("REQUEST_FRIEND", {name = data.displayName}) end)
      end
    end        

    if ShissuGT.Settings.ContextMenu.Guild then SGT_Context.Head(1, self:ShowMenu(control)) end
    if ShissuGT.Settings.RosterNote then SGT_Context.PersNote(data) end
    if ShissuGT.Settings.ContextMenu.Guild then SGT_Context.Guilds(data.displayName) end
    
    -- Charakternamen löschen
    AddMenuItem(ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.Context.ContextResetChar), function(self) 
      zo_callLater(function()
        ShissuGT.Lib.ShowDialog("Reset?", ShissuGT.Lib.ReplaceCharacter(string.gsub(ShissuGT.i18n.SlashCommand.RemoveChar1N, "<<1>>", data.displayName)), function(dialog) ShissuGT.RemoveChar(data.displayName) end, {accName = data.displayName})
      end, 50)
    end)
    
    self:ShowMenu(control)
  end
end

-- SGT Überschrift
function SGT_Context.Head(previous)
  if (not previous) then previous = 1 end
  local func = function() end

  if (previous == 1) then AddMenuItem(" ", func, nil, "$(CHAT_FONT)|1|shadow") end
  AddMenuItem(ShissuGT.ColoredName, func, nil, "$(ANTIQUE_FONT)|16")
  AddMenuItem(" ", func, nil, "$(CHAT_FONT)|1|shadow")
end

-- Persönliche Notizen
function SGT_Context.PersNote(data)
  if ShissuGT.Roster.Note == false then return end
  
  AddMenuItem(ShissuGT.Color[5] .. ShissuGT.i18n.Context.PersNote, function(self) 
  
  if data.SGTNote == nil then data.SGTNote = "" end
  
  zo_callLater(function()
    ZO_Dialogs_ShowDialog("EDIT_NOTE", {displayName = data.displayName, note = data.SGTNote, changedCallback = ShissuGT.Roster.PersonalNoteChange})
    end, 50)
  end)
end

-- In die Gilde einladen
function SGT_Context.Guilds(displayName)     
  for i = 1, GetNumGuilds() do
    local GuildId = GetGuildId(i)
        
    if DoesPlayerHaveGuildPermission(GuildId, GUILD_PERMISSION_INVITE) then
      local GuildName = GetGuildName(GuildId)
      
      AddMenuItem(string.gsub(ShissuGT.i18n.InviteC, "%%1", GuildName), function() 
        GuildInvite(GuildId, displayName) 
              
        -- Willkommennachricht in den Chat posten, wenn gewünscht
        if ShissuGT.Settings.ContextMenu.InviteMessage["Active"..GuildId] then 
          ShissuGT.MemberInfo.InviteMessage(displayName, GuildId)
        end
      end)
    end 
  end
end