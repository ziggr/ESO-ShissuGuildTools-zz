-- File: Bindings.lua
-- Zuletzt geändert: 19. Januar 2016

-- GLOBALS
ShissuGT = {}
ShissuGT.Name = "ShissuGuildTools"
ShissuGT.Version= "2.6.0.3"
ShissuGT.Loaded = true

ShissuGT.Settings = {}
ShissuGT.Lib = {}
ShissuGT.Misc = {}
ShissuGT.GuildInfo = {}
ShissuGT.MemberInfo = {}
ShissuGT.Context = {}
ShissuGT.Notifications = {}
ShissuGT.Chat = {}

ShissuGT.Color = { 
  "|c77ff7a", -- 1, Grün
  "|cf1ff77", -- 2, Gelb
  "|cff7d77", -- 3, Rot
  "|cd5d1d1", -- 4. Grau I [Offline]
  "|ceeeeee", -- 5, Weiß
  "|c779cff", -- 6, Blau
  "|cff3300", -- 7
  "|c2f2f2f", -- 8
  "|c6f6f6f", -- 9
}

ShissuGT.userColor = {
  [1] = "|cff7d77", -- Rot
  [2] = "|cf1ff77", -- Gelb
  [3] = "|c77ff7a", -- Grün
  [4] = "|c779cff", -- Blau
  W = "|ceeeeee" -- Weiß
}

ShissuGT.ColoredName = ShissuGT.Color[6] .. "Shissu's" .. ShissuGT.Color[5] .. " Guild Tools"
ShissuGT.Notebook = {}
ShissuGT.Notebook.Active = 0
ShissuGT.Notebook.MailActive = 0
ShissuGT.Roster = {} 
ShissuGT.Roster.Active = false
ShissuGT.Roster.PlayerName = ""
ShissuGT.Roster.GuildID = 1
ShissuGT.Roster.Note = false
ShissuGT.History = {} 
ShissuGT.History.Active = false
ShissuGT.Teleport = {}
ShissuGT.GuildColor = {}
ShissuGT.GuildColor.Active = false
ShissuGT.WhiteGold = zo_iconFormat("/esoui/art/guild/guild_tradinghouseaccess.dds",24,24)

-- ZOS Objects
ShissuGT.ZOS = {
  History = GUILD_HISTORY_GENERAL,
  Joined = GUILD_EVENT_GUILD_JOIN,
  Bank = GUILD_HISTORY_BANK,
  GoldAdded = GUILD_EVENT_BANKGOLD_ADDED,
  GoldRemoved = GUILD_EVENT_BANKGOLD_REMOVED,
  ItemAdded = GUILD_EVENT_BANKITEM_ADDED,
  ItemRemoved = GUILD_EVENT_BANKITEM_REMOVED,
}                             

-- Dialogs
ESO_Dialogs["SGT_DIALOG"] = {
  title = { text = "TITEL", },
  mainText = { text = "TEXT", },
  buttons = {
    [1] = {
      text = SI_DIALOG_REMOVE,
      callback = function(dialog) end, },
    [2] = { text = SI_DIALOG_CANCEL, }
  }                                       
}

ESO_Dialogs["SGT_EDIT"] = {
  title = { text = "TITEL", },
  mainText = { text = "TEXT", },
  editBox = { 
    defaultText = "Liste",
  },
  buttons = {
    [1] = {
      text = "Hinzufügen",
      requiresTextInput = true,
      callback = function(dialog) end,
    },
    [2] = { text = SI_DIALOG_CANCEL, }
  }                                       
}