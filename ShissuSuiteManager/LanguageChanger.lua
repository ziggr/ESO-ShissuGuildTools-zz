-- Shissu Suite Manager
-----------------------
-- File: LanguageChanger.lua
-- Last Update: 02.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _addon = {}
_addon.Name	= "ShissuLanguageChanger"
_addon.Version = "1.0.3"
_addon.core = {}
_addon.formattedName = "|cAFD3FFShissu's|r|ceeeeee Language Changer"
_addon.panel = Shissu_SuiteManager._lib.setPanel("Language Changer", _addon.formattedName, _addon.Version)
_addon.controls = {
  [1] = {
    type = "title",
    name = Shissu_SuiteManager._lib.getString(SGT_Language1),     
  }, 
  [2] = {
    type = "combobox",
    name = Shissu_SuiteManager._lib.getString(SGT_Language2),
    tooltip = Shissu_SuiteManager._lib.getString(SGT_Language3),
    items = {"de", "en", "fr"},
    getFunc = GetCVar("Language.2"),
    setFunc = function(_, value)
      SetCVar("Language.2", value)
      SLASH_COMMANDS["/reloadui"]() 
    end,
  },  
  [3] = {
    type = "title",
    name = "Info",     
  },
  [4] = {
    type = "description",
    text = Shissu_SuiteManager._lib.getString(SGT_Language3),  
  },          
}

function _addon.core.initialized()
  Shissu_SuiteManager._settings[_addon.Name]["controls"][3].getFunc = GetCVar("Language.2")
end

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized    
