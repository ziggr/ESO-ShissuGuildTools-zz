-- Shissu Suite Manager
-----------------------
-- File: DE.lua
-- Last Update: 19.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one

-- Released under terms in license accompanying this file.
-- Distribution without license is prohibited!

Shissu_SuiteManager = Shissu_SuiteManager or {}
Shissu_SuiteManager._i18n = Shissu_SuiteManager._i18n or {}
             
-- Feedback
ZO_CreateStringId("SGT_Feedback1", "Ich hoffe, dass dir mein AddOn hilft! Feedback ist wichtig. Deshalb ist dieses willkommen. Wenn du mir ein Feedback zukommen lassen möchte, dann schreibe mir eine kleine Ingame-Notiz als Post, mit oder ohne eine Spende. Deine Spende hilft mir meine gruppenbasierende ESO-Zeit, sowie auch die Organisation meiner eigenen Gilden zu reduzieren.")
ZO_CreateStringId("SGT_Feedback2", "Letztendlich kann mich so auf auf weitere Features & neue AddOns für ESO konzentrieren.")
ZO_CreateStringId("SGT_Feedback3", "INFO!!! Ich erhalte deine E-Mail nur, wenn du auf dem EU-Server spielst!")
        
-- Bindings
ZO_CreateStringId("SI_BINDING_NAME_SGT_helmToogle", "Helm ein- und ausblenden")
ZO_CreateStringId("SI_BINDING_NAME_SGT_offlineToogle", "Spielerstatus On-/Offline")
ZO_CreateStringId("SI_BINDING_NAME_SGT_reload", "Reload UI")

-- Modul: Language
ZO_CreateStringId("SGT_Language1", "TESO Sprache")
ZO_CreateStringId("SGT_Language2", "Sprache")
ZO_CreateStringId("SGT_Language3", "Ändert die Sprache von Elder Scrolls Online auf die ausgewählte Sprache ohne das Spiel neuzustarten. |cFF747FAchtung|r: Das Interface wird neugeladen.")

-- Modul: Standard
ZO_CreateStringId("SGT_Standard1", "Standard Befehle")

ZO_CreateStringId("SGT_Standard2", "|cAFD3FF/rl|r - RELOADUI\n\n" .. 
    "|cAFD3FF/helm|r - Helm ein-/ausblenden \n\n" ..
    "|cAFD3FF/on|r - Spielerstatus " .. EsoStrings[SI_PLAYERSTATUS1] .. "\n\n" .. 
    "|cAFD3FF/off|r - Spielerstatus " .. EsoStrings[SI_PLAYERSTATUS4] .. "\n\n" ..
    "|cAFD3FF/brb|r - Spielerstatus " .. EsoStrings[SI_PLAYERSTATUS3] .. "\n\n" ..
    "|cAFD3FF/dnd|r - Spielerstatus " .. EsoStrings[SI_PLAYERSTATUS3] .. "\n\n" ..
    "|cAFD3FF/afk|r - Spielerstatus " .. EsoStrings[SI_PLAYERSTATUS2] .. "\n\n" ..
    
    "|cAFD3FFZufallszahl würfeln|r\n" ..
    "Würfelt eine zufällige Zahl zwischen 1 und deiner Wunschzahl. Zusätzlich lässt sich die Sprachausgabe manipulieren." .. "\n\n" .. 
    
    "|cAFD3FF/dice|r [ZAHL] [de,en,fr,ru]" .. "\n\n" .. 
    "|cAFD3FF/roll|r [ZAHL] [de,en,fr,ru]" .. "\n\n")