-- File: Notifications.lua
-- Zuletzt geändert: 29. November 2015

-- DELETE_MAIL Dialog deaktivieren
-- Original ZOS LUA Code + Modifikation: esoui\ingame\mail\keyboard\mailinbox_keyboard.lua
-- Original Version Date: 01.09.2015
function ShissuGT.Misc.DisabledMailDeleteNotification(self)
  if self.mailId then
    if self:IsMailDeletable() then
      local numAttachments, attachedMoney = GetMailAttachmentInfo(self.mailId)
      
      if numAttachments > 0 and attachedMoney > 0 then
        ZO_Dialogs_ShowDialog("DELETE_MAIL_ATTACHMENTS_AND_MONEY", self.mailId)
      elseif numAttachments > 0 then
        ZO_Dialogs_ShowDialog("DELETE_MAIL_ATTACHMENTS", self.mailId)
      elseif attachedMoney > 0 then
        ZO_Dialogs_ShowDialog("DELETE_MAIL_MONEY", self.mailId)
      else
        if ShissuGT.Settings.MailDelNotification == true then
          ZO_Dialogs_ShowDialog("DELETE_MAIL", {callback = function(...) self:ConfirmDelete(...) end, mailId = self.mailId})
        else
          self:ConfirmDelete(self.mailId) 
        end
      end
    end
  end  
end

-- GuildMoTD deaktivieren
-- Original ZOS LUA Code + Modifikation: notifications_common.lua
-- Original Version Date: 01.09.2015
function ZO_GuildMotDProvider:BuildNotificationList()
  local notif = ZO_SavedVars:NewAccountWide("shissuGT", 1, nil, ShissuGT.SettingsDefault, nil)

  if self.sv then
    ZO_ClearNumericallyIndexedTable(self.list)

    for i = 1, GetNumGuilds() do
      if notif ["Guild"..i].GuildMotD then 
        local guildId = GetGuildId(i)
        local guildName = GetGuildName(guildId)
        local savedMotDHash = self.sv[guildName]
        local currentMotD = GetGuildMotD(guildId)
        local currentMotDHash = HashString(currentMotD)

        if savedMotDHash == nil then
          self.sv[guildName] = currentMotDHash
        elseif savedMotDHash ~= currentMotDHash then
          local guildAlliance = GetGuildAlliance(guildId)
          local message = self:CreateMessage(guildAlliance, guildName)
          table.insert(self.list,
          {
            dataType = NOTIFICATIONS_ALERT_DATA,
            notificationType = NOTIFICATION_TYPE_GUILD_MOTD,
            note = currentMotD,
            message = message,
            guildId = guildId,
            shortDisplayText = guildName,
          })           
        end
      end
    end    
  end
end