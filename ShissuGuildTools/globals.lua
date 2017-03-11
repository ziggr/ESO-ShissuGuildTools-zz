-- Shissu GuildTools GLOBALS
----------------------------
-- File: globals.lua
-- Version: v1.0.4
-- Last Update: 30.10.2016
-- Written by Christian Flory (@Shissu) - esoui@flory.one

-- Released under terms in license accompanying this file.
-- Distribution without license is prohibited!

local _globals = {}
_globals.name = "SGT"

_globals["color"] = {
  default = {1, 1, 1, 1},
  blue = "|cAFD3FF",
  white = "|ceeeeee",
  green = "|c77ff7a",
  red = "|cff7d77",
  yellow = "|cf1ff77",
  gray = "|cd5d1d1",
  orange = "|cff3300",
}

_globals["ZOS"] = {
  ["History"] = GUILD_HISTORY_GENERAL,
  ["Joined"] = GUILD_EVENT_GUILD_JOIN,
  ["Bank"] = GUILD_HISTORY_BANK,
  ["GoldAdded"] = GUILD_EVENT_BANKGOLD_ADDED,
  ["GoldRemoved"] = GUILD_EVENT_BANKGOLD_REMOVED,
  ["ItemAdded"] = GUILD_EVENT_BANKITEM_ADDED,
  ["ItemRemoved"] = GUILD_EVENT_BANKITEM_REMOVED,
}

-- Dialogbox
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
      text = "OK",
      requiresTextInput = true,
      callback = function(dialog) end,
    },
    [2] = { text = SI_DIALOG_CANCEL, }
  }
}

Shissu_SuiteManager._globals = _globals
