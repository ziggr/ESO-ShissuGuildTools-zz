-- Shissu Suite Manager
-----------------------
-- File: FR.lua
-- Last Update: 27.10.2016
-- Written by Christian Flory (@Shissu) - esoui@flory.one

-- Released under terms in license accompanying this file.
-- Distribution without license is prohibited!

Shissu_SuiteManager = Shissu_SuiteManager or {}
Shissu_SuiteManager._i18n = Shissu_SuiteManager._i18n or {}
             
-- Feedback
ZO_CreateStringId("SGT_Feedback1", "I hope you are enjoying the AddOn..  Your feedback is always welcome, so please drop me a note with or without a donation.  Your donation will help me focus my non adventuring ESO time on more features.")
ZO_CreateStringId("SGT_Feedback2", "")
ZO_CreateStringId("SGT_Feedback3", "INFO!!! I get your e-mail only if you play on the EU-server!")
        
-- Bindings
ZO_CreateStringId("SI_BINDING_NAME_SGT_helmToogle", "Toogle Helm")
ZO_CreateStringId("SI_BINDING_NAME_SGT_offlineToogle", "Toogle Playerstatus On-/Offline")
ZO_CreateStringId("SI_BINDING_NAME_SGT_reload", "Reload UI")

-- Modul: Language
ZO_CreateStringId("SGT_Language1", "TESO Language")
ZO_CreateStringId("SGT_Language2", "Language")
ZO_CreateStringId("SGT_Language3", "Changes the language of Elder Scrolls Online to selected language without the game restart. |cFF747FCaution|r: The interface is reloaded.")

-- Modul: Standard
ZO_CreateStringId("SGT_Standard1", "Standard Befehle")
ZO_CreateStringId("SGT_Standard2", "|cAFD3FF/rl|r - RELOADUI\n\n" .. 
    "|cAFD3FF/helm|r - Toogle helm \n\n" .. 
    "|cAFD3FF/on|r - Player status " .. EsoStrings[SI_PLAYERSTATUS1] .. "\n\n" .. 
    "|cAFD3FF/off|r - Player status " .. EsoStrings[SI_PLAYERSTATUS4] .. "\n\n" ..
    "|cAFD3FF/brb|r - Player status " .. EsoStrings[SI_PLAYERSTATUS3] .. "\n\n" ..
    "|cAFD3FF/dnd|r - Player status " .. EsoStrings[SI_PLAYERSTATUS3] .. "\n\n" ..
    "|cAFD3FF/afk|r - Player status " .. EsoStrings[SI_PLAYERSTATUS2])