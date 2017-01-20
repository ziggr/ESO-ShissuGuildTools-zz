-- File: SettingsMenu.lua
-- Zuletzt geändert: 29. November 2015

local SGT_Settings = {}

function SGT_Settings.SetEnabled(value,var)
  if value == true then 
    if ShissuGT[var].Active then ShissuGT[var].Toogle()
    else ShissuGT[var].Initialize() end
  else ShissuGT[var].Toogle() end
end

function SGT_Settings.GetRanks(guildId)
  local rankList = {}
  
  for i = 1, GetNumGuildRanks(guildId)  do
    local rankName = GetGuildRankCustomName(guildId, i)
    table.insert(rankList, rankName)
  end
  
  return rankList
end

function SGT_Settings.GetSound()
  local soundStrings = {}

  for key, value in pairs(ShissuGT.i18n.Sounds) do
    table.insert(soundStrings, value)
  end
  
  table.sort(soundStrings)

  return soundStrings
end

function ShissuGT.CreateSettingsMenu()
  local i18n = ShissuGT.i18n.Settings
  local i18n_tt = ShissuGT.i18n.SettingsToolTip
  local blue = ShissuGT.Color[6]
  local white = ShissuGT.Color[5]
  local LAM = LibStub("LibAddonMenu-2.0")
  
  local panelData = {
    type    = "panel",
    name    = zo_iconFormat("/esoui/art/characterwindow/gamepad/gp_charactersheet_magickaicon.dds",24,24) .. ShissuGT.ColoredName,    
    author  = "|c779cffShissu",
    version = ShissuGT.Version,
    slashCommand = "/sgt setting",
    registerForRefresh = true,
  }

  local controlData = {
    -- Gildenübergreifende Funktionen
    ---------------------------------
    [1] = {
      type = "button",
      name = "Feedback",
      func = function() 
        local server = GetCVar("LastRealm")
        
        if string.find(server, "EU") then 
          SGT_Feedback:SetHidden(false)
        else d("sry only on eu-server") end
      end,
      width = "full",
    },    
    [2] = {
      type = "header",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].Head),
    }, 
    -- Allgemein
    [3] = {
      type = "description",
      text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[1].Section1),
      width = "full", 
    },
    [4] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].Notebook),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].Notebook),
      getFunc = function() return ShissuGT.Settings.Notebook.Enabled end,
      setFunc = function(value)
        ShissuGT.Settings.Notebook.Enabled = value
        
        if value == true then 
         ZO_ChatWindowOptions:SetAnchor(TOPRIGHT, ZO_ChatWindow , TOPRIGHT, -50, 6 )
         SGT_ZO_ToogleButton:SetHidden(false)
         if ShissuGT.Notebook.Active == 0 then ShissuGT.Notebook.Initialize() end
        else     
          SGT_Notebook:SetHidden(true)      
          ZO_ChatWindowOptions:SetAnchor(TOPRIGHT, ZO_ChatWindow , TOPRIGHT, -10, 6 )
          SGT_ZO_ToogleButton:SetHidden(true)
        end
      end
    },    
    [5] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].NotebookEMail),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].NotebookEMail),     
      getFunc = function() return ShissuGT.Settings.Notebook.EMail end,
      setFunc = function(value)
        ShissuGT.Settings.Notebook.EMail = value
        
        if value == true and ShissuGT.Notebook.MailActive == 0 then
          ShissuGT.Notebook.Initialize()
        elseif value == false then
          SGT_Notebook_MessagesRecipient:SetHidden(true)
        end
      end
    }, 
    [6] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].Teleporter),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].Teleporter),
      getFunc = function() return ShissuGT.Settings.Teleport.Enabled end,
      setFunc = function(value)   
        if value == true then ShissuGT.Teleport.Initialize() end
      end
    }, 
    
    -- Benachrichtigungen / Hinweise
    [7] = {
      type = "description",
      text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[1].Section2),     
      width = "full", 
    },    
    [8] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].EMailDel),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].EMailDel),
      getFunc = function() return ShissuGT.Settings.MailDelNotification end,
      setFunc = function(value) 
        ShissuGT.Settings.MailDelNotification = value   
        if value==false then MAIL_INBOX.Delete = ShissuGT.Misc.DisabledMailDeleteNotification end
      end      
    }, 
            
    -- Gildenfenster
    [9] = {
      type = "description",
      text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[1].Section3),     
      width = "full", 
    },
    [10] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].KioskTimer),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].KioskTimer),
      getFunc = function() return ShissuGT.Settings.KioskTimer end,
      setFunc = function(value)    
        ShissuGT.Settings.KioskTimer = value
        
        if value == true then
          ShissuGT.Misc.KioskTimer()
        else
          EVENT_MANAGER:UnregisterForUpdate("ShissuGT_KioskTimer")
          SGT_HomeTimer:SetHidden(true)
        end
      end
    },        
    [11] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].History),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].History),
      getFunc = function() return ShissuGT.Settings.History end,
      setFunc = function(value)    
        ShissuGT.Settings.History = value
        SGT_Settings.SetEnabled(value,"History")
      end
    },    
    [12] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter( i18n[1].Roster),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].Roster),
      getFunc = function() return ShissuGT.Settings.Roster end,
      setFunc = function(value)    
        ShissuGT.Settings.Roster = value
        SGT_Settings.SetEnabled(value,"Roster")
      end
    }, 
    [13] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].Color),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].Color),
      getFunc = function() return ShissuGT.Settings.GuildColor end,
      setFunc = function(value)    
        ShissuGT.Settings.GuildColor = value
        SGT_Settings.SetEnabled(value,"GuildColor")
      end
    }, 
    
    -- Chat
    [14] = {
      type = "description",
      text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[1].Section4),     
      width = "full", 
    },
    [15] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ChatTime),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ChatTime),
      getFunc = function() return ShissuGT.Settings.TimeInChat end,
      setFunc = function(value) -- !!
        ShissuGT.Settings.TimeInChat = value   
        --ZO_ChatSystem_AddEventHandler(EVENT_CHAT_MESSAGE_CHANNEL, ShissuGT.Chat.CHAT_MESSAGE_CHANNEL)
      end
    }, 
    [16] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ChatGuildName),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ChatGuildName),
      getFunc = function() return ShissuGT.Settings.GuildNameChat end,
      setFunc = function(value) -- !!
        ShissuGT.Settings.GuildNameChat = value   
        --ZO_ChatSystem_AddEventHandler(EVENT_CHAT_MESSAGE_CHANNEL, ShissuGT.Chat.CHAT_MESSAGE_CHANNEL)
      end
    },
    [17] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ChatAutoSwitchGroup),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ChatAutoSwitchGroup),
      getFunc = function() return ShissuGT.Settings.Chat.AutoSwitch.Group end,
      setFunc = function(value) ShissuGT.Settings.Chat.AutoSwitch.Group = value end,
    }, 
    [18] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ChatAutoChatGroup),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ChatAutoChatGroup),
      getFunc = function() return ShissuGT.Settings.Chat.AutoChat.Group end,
      setFunc = function(value) ShissuGT.Settings.Chat.AutoChat.Group = value end,
    }, 
    [19] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ChatAutoSwitchWhisper),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ChatAutoSwitchWhisper),
      getFunc = function() return ShissuGT.Settings.Chat.AutoSwitch.Tell end,
      setFunc = function(value) ShissuGT.Settings.Chat.AutoSwitch.Tell = value end,
    }, 
    [20] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ChatWhisperGuildInfo),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ChatWhisperGuildInfo),
      getFunc = function() return ShissuGT.Settings.Chat.WhisperChat end,
      setFunc = function(value) ShissuGT.Settings.Chat.WhisperChat = value end,
    }, 
    [21] = {
      type = "dropdown",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ChatWhisperSound),
      choices = SGT_Settings.GetSound(),
      getFunc = function() return ShissuGT.i18n.Sounds[ShissuGT.Settings.WhisperSound] end,
      setFunc = function(value) 
        for key ,text in pairs(ShissuGT.i18n.Sounds) do
          if text == value then
            ShissuGT.Settings.WhisperSound = key
            PlaySound(key)
          end
        end 
      end,
     },        
             
    -- Kontextmenü
    [22] = {
      type = "description",
      text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[1].Section5),     
      width = "full", 
    },
    [23] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ContextMenuChatInvite),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ContextMenuChatInvite),
      getFunc = function() return ShissuGT.Settings.ContextMenu.Invite end,
      setFunc = function(value) ShissuGT.Settings.ContextMenu.Invite = value end
    },   
    [24] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ContextMenuChatEMail),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ContextMenuChatEMail),
      getFunc = function() return ShissuGT.Settings.ContextMenu.SendMail end,
      setFunc = function(value) ShissuGT.Settings.ContextMenu.SendMail = value end
    },        
    [25] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ContextMenuEMail), 
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ContextMenuEMail),
      getFunc = function() return ShissuGT.Settings.ContextMenu.Mail end,
      setFunc = function(value) ShissuGT.Settings.ContextMenu.Mail = value end
    },    
    [26] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ContextMenuEMailInvite),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ContextMenuEMailInvite),
      getFunc = function() return ShissuGT.Settings.ContextMenu.MailInvite end,
      setFunc = function(value) ShissuGT.Settings.ContextMenu.MailInvite = value end
    }, 
    [27] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].ContextMenuGuild),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].ContextMenuGuild),
      getFunc = function() return ShissuGT.Settings.ContextMenu.Guild end,
      setFunc = function(value) ShissuGT.Settings.ContextMenu.Guild = value end
    },    
    
    -- Spielerstatus
    [28] = {
      type = "description",
      text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[1].Section6),     
      width = "full", 
    },
    [29] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].PlayerStatusChat),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].PlayerStatusChat),
      getFunc = function() return ShissuGT.Settings.PlayerStatusChat end,
      setFunc = function(value) ShissuGT.Settings.PlayerStatusChat = value end    
    }, 
    [30] = {
      type = "checkbox",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].PlayerStatusAFK),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].PlayerStatusAFK),
      getFunc = function() return false end,
      setFunc = function(value)
        ShissuGT.Settings.AutoAFK = value 
      
        if value == true then    
          EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_PLAYER_STATUS_CHANGED, ShissuGT.Misc.EVENT_PLAYER_STATUS_CHANGED)
          EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_NEW_MOVEMENT_IN_UI_MODE, ShissuGT.Misc.EVENT_UI_MOVEMENT)
          EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_RETICLE_HIDDEN_UPDATE, ShissuGT.Misc.EVENT_UI_MOVEMENT)
        else
          EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_PLAYER_STATUS_CHANGED)
          EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_NEW_MOVEMENT_IN_UI_MODE)
          EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_RETICLE_HIDDEN_UPDATE)    
          EVENT_MANAGER:UnregisterForUpdate("ShissuGT_AutoAFK")    
        end    
      end,
    },     
    [31] = {
      type = "slider",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[1].PlayerStatusAFKMin),
      tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[1].PlayerStatusAFKMin),
      min = 5,
      max = 30,
      step = 5,
      getFunc = function() return ShissuGT.Settings.AutoAFKTimer end,
      setFunc = function(value) ShissuGT.Settings.AutoAFKTimer = value end,  
    },
                 
    -- Gildenspezifische Funktionen
    -------------------------------
    [32] = {
      type = "header",
      name = ShissuGT.Lib.ReplaceCharacter(i18n[2].Head),
    },
  }    
  
  -- Gildenspezifische Funktionen
  for i=1,GetNumGuilds() do
    local guildName = GetGuildName(i);

    table.insert(controlData, { 
      type = "submenu",
      name = guildName,
      controls = { 
        -- Mitglieder
        [1] = {
          type = "description",
          text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[2].Section1),     
          width = "full", 
        },
        [2] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].MemberStatus),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].MemberStatus),
          getFunc = function() return ShissuGT.Settings["Guild"..i].MemberStatus end,
          setFunc = function(value)
            ShissuGT.Settings["Guild"..i].MemberStatus = value
                  
            ShissuGT.Lib.TurnOffUnnecessaryEvents()
            if value == true then EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, ShissuGT.MemberInfo.GUILD_MEMBER_PLAYER_STATUS_CHANGED) end
          end, 
        }, 
        [3] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].MemberAdd),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].MemberAdd),
          getFunc = function() return ShissuGT.Settings["Guild"..i].AddStatus end,
          setFunc = function(value) 
            ShissuGT.Settings["Guild"..i].AddStatus = value
        
            ShissuGT.Lib.TurnOffUnnecessaryEvents()
            if value == true then EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_GUILD_MEMBER_ADDED, ShissuGT.MemberInfo.GUILD_MEMBER_ADDED) end
          end,
        }, 
        [4] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].MemberRemove),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].MemberRemove),
          getFunc = function() return ShissuGT.Settings["Guild"..i].RemoveStatus end,
          setFunc = function(value) 
            ShissuGT.Settings["Guild"..i].RemoveStatus = value
                  
            ShissuGT.Lib.TurnOffUnnecessaryEvents()
            if value == true then EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_GUILD_MEMBER_REMOVED, ShissuGT.MemberInfo.GUILD_MEMBER_REMOVED) end
          end, 
        }, 
        [5] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].MemberInSight),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].MemberInSight),
          getFunc = function() return ShissuGT.Settings["Guild"..i].MemberInSight end,
          setFunc = function(value) 
            ShissuGT.Settings["Guild"..i].MemberInSight = value
            ShissuGT.Lib.TurnOffUnnecessaryEvents()
            SGT_MemberInSight:SetHidden(true)      
            
            if value == true then EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_RETICLE_TARGET_CHANGED, ShissuGT.MemberInfo.RETICLE_TARGET_CHANGED) end
          end, 
        }, 
        
        -- Benachrichtigungen
        [6] = {
          type = "description",
          text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[2].Section2),     
          width = "full", 
        },
        [7] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].NotificationMoTD),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].NotificationMoTD),
          getFunc = function() return ShissuGT.Settings["Guild"..i].GuildMotD end,
          setFunc = function(value) ShissuGT.Settings["Guild"..i].GuildMotD = value end,
        }, 

        -- Chat
        [8] = {
          type = "description",
          text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[2].Section3),     
          width = "full", 
        },
        [9] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatCharacter),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].ChatCharacter),
          getFunc = function() return ShissuGT.Settings["Guild"..i].Character end,
          setFunc = function(value) ShissuGT.Settings["Guild"..i].Character = value end, 
        }, 
        [10] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatLevel),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].ChatLevel),
          getFunc = function() return ShissuGT.Settings["Guild"..i].Level end,
          setFunc = function(value) ShissuGT.Settings["Guild"..i].Level = value end, 
        }, 
        [11] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatAlliance),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].ChatAlliance),
          getFunc = function() return ShissuGT.Settings["Guild"..i].Alliance end,
          setFunc = function(value) ShissuGT.Settings["Guild"..i].Alliance = value end, 
        }, 
        [12] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatLead),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].ChatLead),
          getFunc = function() return ShissuGT.Settings["Guild"..i].ChatLead end,
          setFunc = function(value) ShissuGT.Settings["Guild"..i].ChatLead = value end, 
        }, 
        [13] = {
          type = "dropdown",
          name = "",
          choices = SGT_Settings.GetRanks(i),
          getFunc = function() 
            if ShissuGT.Settings["Guild"..i].LeadRank then return ShissuGT.Settings["Guild"..i].LeadRank end
            return SGT_Settings.GetRanks(i)[1] 
          end,
          setFunc = function(value) ShissuGT.Settings["Guild"..i].LeadRank = value end,
        },         
        [14] = {
          type = "checkbox",                                                         
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatAutoSwitch),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].ChatAutoSwitch),
          getFunc = function() return ShissuGT.Settings.Chat.AutoSwitch["Guild" ..i] end,
          setFunc = function(value) ShissuGT.Settings.Chat.AutoSwitch["Guild" ..i] = value end,
        }, 
        [15] = {
          type = "checkbox",                                                         
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatAutoChat),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].ChatAutoChat),
          getFunc = function() return ShissuGT.Settings.Chat.AutoChat["Guild" ..i] end,
          setFunc = function(value) ShissuGT.Settings.Chat.AutoChat["Guild" ..i] = value end,
        }, 
        [16] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatAutoWelcome),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].ChatAutoWelcome),
          getFunc = function() return ShissuGT.Settings.ContextMenu.InviteMessage["Active"..i] end,
          setFunc = function(value) ShissuGT.Settings.ContextMenu.InviteMessage["Active"..i] = value end,
        }, 
        [17] = {
          type = "checkbox",
          name = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatAutoWelcome2),
          tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[2].ChatAutoWelcome2),
          getFunc = function() return ShissuGT.Settings.ContextMenu.InviteMessage["ActiveE"..i] end,
          setFunc = function(value) ShissuGT.Settings.ContextMenu.InviteMessage["ActiveE"..i] = value end,
        }, 
        [18] = {
          type = "description",
          text = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatAutoDescription),       
          width = "half", 
        },
        [19] = {
          type = "editbox",
          getFunc = function() return ShissuGT.Settings.ContextMenu.InviteMessage["Guild"..i] end,
          setFunc = function(text) ShissuGT.Settings.ContextMenu.InviteMessage["Guild"..i] = text end,
          isMultiline = true,
          width = "half",
        },
        [20] = {
          type = "description",
          text = ShissuGT.Lib.ReplaceCharacter(i18n[2].ChatAutoExample),       
          width = "full", 
        },
      }
    });
  end  

  -- Farben
  ---------
  table.insert(controlData, { 
    type = "header",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[3].Head), 
  })
  -- Standardfarben
  table.insert(controlData, { 
    type = "description",
    text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[3].Section1),
  })  
  table.insert(controlData, { 
    type = "colorpicker",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[3].Standard1),
    getFunc = function() return ShissuGT.Settings.Color[1][1], ShissuGT.Settings.Color[1][2], ShissuGT.Settings.Color[1][3], ShissuGT.Settings.Color[1][4] end,
    setFunc = function(r,g,b,a) ShissuGT.Settings.Color[1] = {r,g,b,a} end,
  })
  table.insert(controlData, { 
    type = "colorpicker",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[3].Standard2),
    getFunc = function() return ShissuGT.Settings.Color[2][1], ShissuGT.Settings.Color[2][2], ShissuGT.Settings.Color[2][3], ShissuGT.Settings.Color[2][4] end,
    setFunc = function(r,g,b,a) ShissuGT.Settings.Color[2] = {r,g,b,a} end,
  })  
  table.insert(controlData, { 
    type = "colorpicker",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[3].Standard3),
    getFunc = function() return ShissuGT.Settings.Color[3][1], ShissuGT.Settings.Color[3][2], ShissuGT.Settings.Color[3][3], ShissuGT.Settings.Color[3][4] end,
    setFunc = function(r,g,b,a) ShissuGT.Settings.Color[3] = {r,g,b,a} end,
  })  
  table.insert(controlData, { 
    type = "colorpicker",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[3].Standard4),
    getFunc = function() return ShissuGT.Settings.Color[4][1], ShissuGT.Settings.Color[4][2], ShissuGT.Settings.Color[4][3], ShissuGT.Settings.Color[4][4] end,
    setFunc = function(r,g,b,a) ShissuGT.Settings.Color[4] = {r,g,b,a} end,
  })  
  -- Chat
  table.insert(controlData, { 
    type = "description",
    text = blue .. ShissuGT.Lib.ReplaceCharacter(i18n[3].Section2),
  })  
  table.insert(controlData, { 
    type = "colorpicker",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[3].Time),
    tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[3].Time),    
    getFunc = function() return ShissuGT.Settings.Color.Time[1], ShissuGT.Settings.Color.Time[2], ShissuGT.Settings.Color.Time[3], ShissuGT.Settings.Color.Time[4] end,
    setFunc = function(r,g,b,a) ShissuGT.Settings.Color.Time = {r,g,b,a} end,
  })  
  table.insert(controlData, { 
    type = "colorpicker",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[3].Character),
    tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[3].Character),    
    getFunc = function() return ShissuGT.Settings.Color.Character[1], ShissuGT.Settings.Color.Character[2], ShissuGT.Settings.Color.Character[3], ShissuGT.Settings.Color.Character[4] end,
    setFunc = function(r,g,b,a) ShissuGT.Settings.Color.Character = {r,g,b,a} end,
  })
     
  -- Sonstige Optionen
  --------------------
  table.insert(controlData, { 
    type = "header",
    name = i18n[4].Head, 
  })
  table.insert(controlData, { 
    type = "checkbox",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[4].MemberInSightLock),
    tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[4].MemberInSightLock),
    getFunc = function() return ShissuGT.Settings.MemberInSight.Lock end,
    setFunc = function(value)
      if value == true then 
        SGT_MemberInSight:SetHidden(false)
        ZO_Tooltips_ShowTextTooltip(SGT_MemberInSight, TOPRIGHT, "|c779cff Shissu's|r\n|ceeeeee Guild Tools")
      else 
        SGT_MemberInSight:SetHidden(true) 
        ZO_Tooltips_HideTextTooltip()
      end
    end
  })
  table.insert(controlData, { 
    type = "checkbox",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[4].MemberInSightMore),
    tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[4].MemberInSightMore),
    getFunc = function() return ShissuGT.Settings.MemberInSight.More end,
    setFunc = function(value) ShissuGT.Settings.MemberInSight.More = value end
  })
  table.insert(controlData, { 
    type = "checkbox",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[4].MemberData),
    tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[4].MemberData),
    getFunc = function() return ShissuGT.Settings.ClearMemberData end,
    setFunc = function(value) ShissuGT.Settings.ClearMemberData = value end,
  })
  table.insert(controlData, { 
    type = "checkbox",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[4].GuildData),
    tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[4].GuildData),
    getFunc = function() return ShissuGT.Settings.ClearGuildData end,
    setFunc = function(value) ShissuGT.Settings.ClearGuildData = value end,
  })
  table.insert(controlData, { 
    type = "checkbox",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[4].RosterNote),
    tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[4].RosterNote),
    getFunc = function() return ShissuGT.Settings.RosterNoteAll end,
    setFunc = function(value) ShissuGT.Settings.RosterNoteAll = value end,
  })  
  table.insert(controlData, { 
    type = "dropdown",
    name = ShissuGT.Lib.ReplaceCharacter(i18n[4].TimeZone),
    tooltip = white .. ShissuGT.Lib.ReplaceCharacter(i18n_tt[4].TimeZone),
    choices = {-12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
    getFunc = function() return ShissuGT.Settings.UTC end,
    setFunc = function(value) ShissuGT.Settings.UTC = value end,
  })  

  ShissuGT.Panel = LAM:RegisterAddonPanel(ShissuGT.Name, panelData)
  ShissuGT.SettingsControls = LAM:RegisterOptionControls(ShissuGT.Name, controlData)
end                  