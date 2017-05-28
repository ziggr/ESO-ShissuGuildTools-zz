-- Shissu GuildTools LanguageFile
---------------------------------
-- File: DE.lua
-- Version: v1.3.1
-- Last Update: 18.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one

-- Released under terms in license accompanying this file.
-- Distribution without license is prohibited!
 
local _color = {
  blue = "|cAFD3FF",
  white = "|ceeeeee",
}              
            
-- General
ZO_CreateStringId("ShissuGeneral", GetString(SI_HOUSEPERMISSIONOPTIONSCATEGORIES1))
ZO_CreateStringId("Shissu_friend", GetString(SI_MAIN_MENU_CONTACTS))
ZO_CreateStringId("Shissu_guild", GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY)) -- Gilde
ZO_CreateStringId("Shissu_chat", GetString(SI_CHAT_TAB_GENERAL))
ZO_CreateStringId("Shissu_yourText", "DEINTEXT")
ZO_CreateStringId("Shissu_mail", GetString(SI_CUSTOMERSERVICESUBMITFEEDBACKSUBCATEGORIES209))
ZO_CreateStringId("Shissu_add", "Hinzufügen")
ZO_CreateStringId("Shissu_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))
ZO_CreateStringId("Shissu_rank", GetString(SI_STAT_GAMEPAD_RANK_LABEL))
ZO_CreateStringId("Shissu_info", GetString(SI_SCOREBOARD_HELPER_TAB_TOOLTIP))
ZO_CreateStringId("Shissu_addInfo", "Zusätzliche Informationen")

-- Main
ZO_CreateStringId("ShissuModule_module", "Module / Funktionen")
ZO_CreateStringId("ShissuModule_moduleInfo", "Möchten Sie SGT beschleunigen, können Sie je nach ihrem Belieben einzelne Module & Funktionen deaktivieren.")
ZO_CreateStringId("ShissuModule_moduleInfo2", "Das Aus- und Einschalten einzelner Module erfordert ein Neuladen des Interfaces (/reloadui).")

ZO_CreateStringId("ShissuModule_rightMouse", "Rechte Maustaste")
ZO_CreateStringId("ShissuModule_leftMouse", "Linke Maustaste")
ZO_CreateStringId("ShissuModule_middleMouse", "Mittlere Maustaste")

-- Modules
----------
  
-- Module: ShissuWelcomeInvite                                                                                             
ZO_CreateStringId("ShissuWelcomeInvite", "Willkommensnachricht")
ZO_CreateStringId("ShissuWelcomeDesc1", "Zur Gestaltung der Willkommennachrichten können Sie folgende Platzhalter verwenden")
ZO_CreateStringId("ShissuWelcomeDesc2", "Name des Spielers")
ZO_CreateStringId("ShissuWelcomeDesc3", "Name der Gilde")
ZO_CreateStringId("ShissuWelcomeDesc4", "Trennen von verschiedenen Begrüßungen (Der Zufall entscheidet)")

-- Modul: ShissuTeleporter
ZO_CreateStringId("ShissuTeleporter", "Teleporter")
ZO_CreateStringId("ShissuTeleporter_tele", "Teleport")
ZO_CreateStringId("ShissuTeleporter_rnd", "Zufall")
ZO_CreateStringId("ShissuTeleporter_refresh", "Aktualisieren")
ZO_CreateStringId("ShissuTeleporter_grp", "Gruppenführer")
ZO_CreateStringId("ShissuTeleporter_house", "Hauptwohnsitz")
ZO_CreateStringId("ShissuTeleporter_legends1", "Legende")
ZO_CreateStringId("ShissuTeleporter_legends2", "Freunde")
ZO_CreateStringId("ShissuTeleporter_legends3", "Gruppenmitspieler")

-- Modul: ShissuNotifications
ZO_CreateStringId("ShissuNotifications", GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS)) 
ZO_CreateStringId("ShissuNotifications_info", "Hinweis")
ZO_CreateStringId("ShissuNotifications_mail", "EMail / Nachricht löschen")
ZO_CreateStringId("ShissuNotifications_inSight", "Gildenmitglied in Sichtfeld?")
ZO_CreateStringId("ShissuNotifications_friend", "Freund Status [online, afk, brb/dnd, offline]")
ZO_CreateStringId("ShissuNotifications_motD", GetString(SI_GUILD_MOTD_HEADER))
ZO_CreateStringId("ShissuNotifications_background", GetString(SI_GUILD_BACKGROUND_INFO_HEADER))
ZO_CreateStringId("ShissuNotifications_rank", "Ranklisten")
ZO_CreateStringId("ShissuNotifications_guild", GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_GUILD_MEMBERS))
ZO_CreateStringId("ShissuNotifications_background2", "von")
ZO_CreateStringId("ShissuNotifications_background3", "wurde geändert")

-- Modul: ShissuHistory
ZO_CreateStringId("ShissuHistory", "Gilde: " .. GetString(SI_WINDOW_TITLE_GUILD_HISTORY))
ZO_CreateStringId("ShissuHistory_filter", "Filter")
ZO_CreateStringId("ShissuHistory_status", "Ein-/Ausblenden")
ZO_CreateStringId("ShissuHistory_choice", "Auswahl")
ZO_CreateStringId("ShissuHistory_goldAdded", "Eingezahlt")
ZO_CreateStringId("ShissuHistory_goldRemoved", "Ausgezahlt")
ZO_CreateStringId("ShissuHistory_itemAdded", "Eingelagert")
ZO_CreateStringId("ShissuHistory_itemRemoved", "Entnommen")
ZO_CreateStringId("ShissuHistory_turnover", "Umsatz")
ZO_CreateStringId("ShissuHistory_tax", "3,5% Steuern")
ZO_CreateStringId("ShissuHistory_sales", "Verkäufe")
ZO_CreateStringId("ShissuHistory_extern", "Extern")
ZO_CreateStringId("ShissuHistory_trader", "seit Gildenhändler")
ZO_CreateStringId("ShissuHistory_pages", "alle Seiten öffnen")
ZO_CreateStringId("ShissuHistory_player", GetString(SI_PLAYER_MENU_PLAYER))
ZO_CreateStringId("ShissuHistory_set1", "Bank: Ein- und Auszahlungen (Gold + Items)")
ZO_CreateStringId("ShissuHistory_set2", "Verkäufe: Umsatz, Nicht-Gildenmitglieder (Extern), 3,5%-Beteiligung")
ZO_CreateStringId("ShissuHistory_opt", "OPTIONEN")
ZO_CreateStringId("ShissuHistory_last", "letzte Woche")

-- Modul: ShissuColor
ZO_CreateStringId("ShissuColor_title", "Farben")
ZO_CreateStringId("ShissuColor_std", "Standard Farbe")
ZO_CreateStringId("ShissuColor_desc1", "Die folgenden 5 Farben sind die Standardfarben, wie sie in verschiedenen Modulen & Funktionen verwendet werden")

-- Modul: AutoAFK
ZO_CreateStringId("ShissuAutoAFK", "AutoAFK")
ZO_CreateStringId("ShissuAFK_reminder", "Erinnerung")
ZO_CreateStringId("ShissuAFK_infoOffline", "Du bist aktuell für andere Spieler noch Offline!")
ZO_CreateStringId("ShissuAFK_autoOnline", "Automatischen Umschalten von Offline zu Online!")
ZO_CreateStringId("ShissuAFK_reminderOffline", "Erinnerung: Offline?")
ZO_CreateStringId("ShissuAFK_minute", "nach X Minuten")

-- Modul: ShissuContextMenu
ZO_CreateStringId("ShissuContextMenu", "Kontextmenü")
ZO_CreateStringId("ShissuContextMenu_mail", GetString(SI_SOCIAL_MENU_MAIL))
ZO_CreateStringId("ShissuContextMenu_invite", GetString(SI_NOTIFICATIONTYPE2))
ZO_CreateStringId("ShissuContextMenu_inviteC", "|ceeeeeeIn die Gilde |cAFD3FF%1|ceeeeee einladen")
ZO_CreateStringId("ShissuContextMenu_answer", "Antworten, Weiterleiten")
ZO_CreateStringId("ShissuContextMenu_newMail", "Neue Nachricht")
ZO_CreateStringId("ShissuContextMenu_forward", "Weiterleiten")
ZO_CreateStringId("ShissuContextMenu_answer2", "Antworten")
ZO_CreateStringId("ShissuContextMenu_del", "Löschen")
ZO_CreateStringId("ShissuContextmenu_note", "Persönliche Notizen")
ZO_CreateStringId("ShissuContextMenu_forward_prefix", "WG")
ZO_CreateStringId("ShissuContextMenu_answer_prefix", "AW")

-- Modul: ShissuMemberStatus
ZO_CreateStringId("ShissuMemberStatus", "Gildenmitglieder Status")
ZO_CreateStringId("ShissuContextMenu_memberStatus", "Spielerstatus (Online/BRB/AFK/Offline)")
ZO_CreateStringId("ShissuContextMenu_added", "beigetreten")
ZO_CreateStringId("ShissuContextMenu_removed", "verlassen / gekickt")
                                                        
-- Modul: ShissuGuildHome
ZO_CreateStringId("ShissuGuildHome", "Gilde: " .. GetString(SI_WINDOW_TITLE_GUILD_HOME))
ZO_CreateStringId("ShissuGuildHome_kiosk", "Zeit bis zum nächsten Gildenhändlergebot")
ZO_CreateStringId("ShissuGuildHome_textures", "Texturen")
ZO_CreateStringId("ShissuGuildHome_rest", "Neuer Händler in")
ZO_CreateStringId("ShissuGuildHome_c", "Standardfarbe")
ZO_CreateStringId("ShissuGuildHome_leftTime", "Restzeit")
ZO_CreateStringId("ShissuGuildHome_color", GetString(SI_GUILD_HERALDRY_COLOR))

-- Modul: ShissuNotebook
ZO_CreateStringId("ShissuNotebook", "Notizbuch")
ZO_CreateStringId("ShissuNotebook_slash", "Chat Befehl:")
ZO_CreateStringId("ShissuNotebook_noSlash", "Keinen passenden Text gefunden (siehe Notizbuch)")
ZO_CreateStringId("ShissuNotebook_ttDelete", "Notiz löschen")
ZO_CreateStringId("ShissuNotebook_ttNew", "Neue Notiz")
ZO_CreateStringId("ShissuNotebook_ttUndo", "Änderungen Rückgängig machen")
ZO_CreateStringId("ShissuNotebook_ttSendTo", _color.blue .. "Linke Maustaste" ..  _color.white .." - Im Chat posten\n"..  _color.blue .. "Mittlere Maustaste" ..  _color.white .." - Als E-Mail(Post)\n" ..  _color.blue.. "Rechte Maustaste".. _color.white .. " - Notiz abspeichern")

-- Modul: ShissuNotebookMail
ZO_CreateStringId("ShissuNotebookMail", "Notizbuch Mailer")
ZO_CreateStringId("ShissuNotebookMail_title", "Mailempfänger")
ZO_CreateStringId("ShissuNotebookMail_choice", "Auswahl")
ZO_CreateStringId("ShissuNotebookMail_mailKick", "Nachrichtenkick")
ZO_CreateStringId("ShissuNotebookMail_mailOn", "AN")
ZO_CreateStringId("ShissuNotebookMail_mailOff", "AUS")
ZO_CreateStringId("ShissuNotebookMail_list", "Liste")
ZO_CreateStringId("ShissuNotebookMail_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))
ZO_CreateStringId("ShissuNotebookMail_offlineSince", "Offline")
ZO_CreateStringId("ShissuNotebookMail_all", "- Alle")
ZO_CreateStringId("ShissuNotebookMail_days", "Tage")
ZO_CreateStringId("ShissuNotebookMail_send", GetString(SI_MAIL_SEND_SEND))
ZO_CreateStringId("ShissuNotebookMail_progressKickTitle", "Spieler entfernen")
ZO_CreateStringId("ShissuNotebookMail_progressDemoteTitle", "Spieler degradieren")
ZO_CreateStringId("ShissuNotebookMail_progressTitle", "E-Mail senden")
ZO_CreateStringId("ShissuNotebookMail_progressAbort", "Abgebrochen")
ZO_CreateStringId("ShissuNotebookMail_mailProgress", "Bitte warten...")
ZO_CreateStringId("ShissuNotebookMail_doneL", "FERTIG!")
ZO_CreateStringId("ShissuNotebookMail_all2", "Alle")
ZO_CreateStringId("ShissuNotebookMail_listAddRemove", _color.blue .. "Linke Maustaste" ..  _color.white .." - Liste hinzufügen\n"..  _color.blue .. "Rechte Maustaste".. _color.white .. " - Liste löschen")
ZO_CreateStringId("ShissuNotebookMail_listPlayerAdd", "Spieler hinzufügen")
ZO_CreateStringId("ShissuNotebookMail_listPlayerRemove", "Spieler entfernen")
ZO_CreateStringId("ShissuNotebookMail_listPlayerBuildGroup", "Spieler in Gruppe einladen")
ZO_CreateStringId("ShissuNotebookMail_online", "Online, BRB, AFK")
ZO_CreateStringId("ShissuNotebookMail_ttEMail", "E-Mail an Auswahl verschicken")
ZO_CreateStringId("ShissuNotebookMail_ttEMailList", "E-Mail an Spieler in der Liste verschicken")
ZO_CreateStringId("ShissuNotebookMail_ttEMailKick", "E-Mail beim Kicken des/der Spieler verschicken")
ZO_CreateStringId("ShissuNotebookMail_ttKick", "Auswahl aus der Gilde kicken (ggf. mit E-Mail)")
ZO_CreateStringId("ShissuNotebookMail_ttKickList", "Spieler in der Liste aus der Gilde kicken (ggf. mit E-Mail)")
ZO_CreateStringId("ShissuNotebookMail_protocolIgnoreTT", "Der Spieler ignoriert dich, oder du ignorierst den Spieler!")
ZO_CreateStringId("ShissuNotebookMail_ttContin", "Sollte der Versand aus irgendwelchen Gründen " .. _color.blue .. "nicht voranschreiten".. _color.white .. ", dann klicke auf diesem Button. Der aktuelle Empfänger wird i.d.F. ignoriert.")
ZO_CreateStringId("ShissuNotebookMail_protocolTT", "Zeigt die Spieler an, die einen vollen Briefkasten haben, bzw. dich ignorieren.")
ZO_CreateStringId("ShissuNotebookMail_newList", "Neue Liste")
ZO_CreateStringId("ShissuNotebookMail_listName", "Listenname?")
ZO_CreateStringId("ShissuNotebookMail_invite", "Spieler einladen")
ZO_CreateStringId("ShissuNotebookMail_confirmKick", "Sollen die Spieler in der Liste, bzw. Ihre Auswahl aus der Gilde entfernt werden?")
ZO_CreateStringId("ShissuNotebookMail_demoteKick", "Sollen die Spieler in der Liste, bzw. Ihre Auswahl aus der Gilde degradiert werden?")
ZO_CreateStringId("ShissuNotebookMail_splashSubject", "Betreff")
ZO_CreateStringId("ShissuNotebookMail_splashProgress", "Fortschritt")       
ZO_CreateStringId("ShissuNotebookMail_protocolIgnore", "Ignoriert")       
ZO_CreateStringId("ShissuNotebookMail_protocolFull", "Postkasten voll")       
ZO_CreateStringId("ShissuNotebookMail_protocol", "E-Mail Protokoll")       
ZO_CreateStringId("ShissuNotebookMail_mailAbort", _color.blue .. "Fenster schließen" .. _color.white .. "\nDurch das Schließen wird das Versenden/Kicken abgebrochen.")
ZO_CreateStringId("ShissuNotebookMail_newMail", GetString(SI_SOCIAL_MENU_SEND_MAIL))       
ZO_CreateStringId("ShissuNotebookMail_ERR_FAIL_BLANK_MAIL", "Nachricht unvollständig")

ZO_CreateStringId("ShissuNotebookMail_Filter", "Filter")
ZO_CreateStringId("ShissuNotebookMail_Action", "Aktion")
ZO_CreateStringId("ShissuNotebookMail_Send", "Ausführen")
ZO_CreateStringId("ShissuNotebookMail_Member", "Mitglied")
ZO_CreateStringId("ShissuNotebookMail_SinceGold", "vor min. Tage")
ZO_CreateStringId("ShissuNotebookMail_noMail", "Keine Nachricht")

ZO_CreateStringId("ShissuNotebookMail_countDays", "Anzahl der Tage")
 
-- Modul: ShissuRoster
ZO_CreateStringId("ShissuRoster", "Gilde: Mitglieder")
ZO_CreateStringId("ShissuRoster_char", GetString(SI_BINDING_NAME_TOGGLE_CHARACTER))
ZO_CreateStringId("ShissuRoster_goldDeposit", "Einzahlung")
ZO_CreateStringId("ShissuRoster_goldDeposit2", "Einzahlungen")
ZO_CreateStringId("ShissuRoster_goldDeposit3", "Gold eingezahlt")
ZO_CreateStringId("ShissuRoster_member", "Mitglied seit")
ZO_CreateStringId("ShissuRoster_thisWeek", "Diese Woche")
ZO_CreateStringId("ShissuRoster_lastWeek", "Letzte Woche")
ZO_CreateStringId("ShissuRoster_today", "Heute")
ZO_CreateStringId("ShissuRoster_yesterday", "Gestern")
ZO_CreateStringId("ShissuRoster_sinceKiosk", "seit Gildenhändler")
ZO_CreateStringId("ShissuRoster_last", "Zuletzt")
ZO_CreateStringId("ShissuRoster_total", "Gesamt")
ZO_CreateStringId("ShissuRoster_sum", "Summe")     
ZO_CreateStringId("ShissuRoster_colAdd", "Zusätzliche Spalten einblenden")
ZO_CreateStringId("ShissuRoster_colAdd2", "Nach einer Änderung müssen Sie das Interface neulanden.")
ZO_CreateStringId("ShissuRoster_colChar", "Spalte: Charakter")
ZO_CreateStringId("ShissuRoster_colGold", "Spalte: Gold Einzahlungen")
ZO_CreateStringId("ShissuRoster_colNote", "Spalte: Persönliche Notizen")
ZO_CreateStringId("ShissuRoster_noData", "Keine Daten")

-- Modul: Scanner
ZO_CreateStringId("ShissuScanner", "Gilde: Aufzeichnung Scan")
ZO_CreateStringId("ShissuScanner_scan1", "Die Gildenaufzeichnungen von")
ZO_CreateStringId("ShissuScanner_scan2", "werden gerade eingelesen. Bitte warten...")

-- Modul: Chat
ZO_CreateStringId("ShissuChat", "Chat")
ZO_CreateStringId("ShissuChat_auto", "Automatischer Wechsel")
ZO_CreateStringId("ShissuChat_date", "Datum einblenden")
ZO_CreateStringId("ShissuChat_time", "Uhrzeit einblenden")
ZO_CreateStringId("ShissuChat_sound", "Akustischer Signalton (Flüstern)")
ZO_CreateStringId("ShissuChat_guilds", "Gildenzugehörigkeit")
ZO_CreateStringId("ShissuChat_rang", GetString(SI_GAMEPAD_GUILD_ROSTER_RANK_HEADER))
ZO_CreateStringId("ShissuChat_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))                                                 
ZO_CreateStringId("ShissuChat_lvl", "Level")
ZO_CreateStringId("ShissuChat_char", "Charakternamen")
ZO_CreateStringId("ShissuChat_whisper", GetString(SI_CHAT_PLAYER_CONTEXT_WHISPER))
ZO_CreateStringId("ShissuChat_party", GetString(SI_CHAT_CHANNEL_NAME_PARTY))
ZO_CreateStringId("ShissuChat_guildchan", GetString(SI_CHAT_OPTIONS_GUILD_CHANNELS))
ZO_CreateStringId("ShissuChat_charAcc1", "Account")
ZO_CreateStringId("ShissuChat_charAcc2", "Charakter")
ZO_CreateStringId("ShissuChat_charAcc3", "Account + Charakter")
ZO_CreateStringId("ShissuChat_guildInfo", "Gilden Informationen")
ZO_CreateStringId("ShissuChat_guildWhich", "Auf welchen Gilden sollen die Informationen basieren?")
ZO_CreateStringId("ShissuChat_guildNames1", "Gildenbezeichnung")
ZO_CreateStringId("ShissuChat_guildNames2", "Wie sollen Ihre Gilden im Chat lauten?")
                                        
-- Modul: Marks
ZO_CreateStringId("ShissuMarks", "Markierungen")
ZO_CreateStringId("ShissuMarks_title", "Monster (NPC) & Spieler Markierungen")
ZO_CreateStringId("ShissuMarks_misc", "Misc")
ZO_CreateStringId("ShissuMarks_kick", "Auto Kick")
ZO_CreateStringId("ShissuMarks_heal", "Heiler")
ZO_CreateStringId("ShissuMarks_observe", "Beobachten")
ZO_CreateStringId("ShissuMarks_all", "All What You See")
ZO_CreateStringId("ShissuMarks_confirmDel", "Liste löschen?")
ZO_CreateStringId("ShissuMarks_confirmDel2", "Möchten Sie den Listeninhalt wirklick löschen?")  
ZO_CreateStringId("ShissuMarks_add", "Monster (NPC) / Spieler")
ZO_CreateStringId("ShissuMarks_add2", "Wie lautet der Name des Monster bzw. Spielers?")
ZO_CreateStringId("ShissuMarks_add3", "Monster/Spieler in Gruppe")
ZO_CreateStringId("ShissuMarks_add4", "hinzugefügt")
ZO_CreateStringId("ShissuMarks_add5", "Monster/Spieler existiert schon in Gruppe")
ZO_CreateStringId("ShissuMarks_leftMouse", "Hinzufügen")
ZO_CreateStringId("ShissuMarks_rightMouse", "Liste komplett leeren")
ZO_CreateStringId("ShissuMarks_middleMouse", "Gilden überprüfen")
ZO_CreateStringId("ShissuMarks_observeInfo", "Spieler in der Liste: Beobachten werden im Chat hervorgehoben")
ZO_CreateStringId("ShissuMarks_observeInfo2", "- beim einloggen")
ZO_CreateStringId("ShissuMarks_observeInfo3", "- beim eintreten in die Gilde")
ZO_CreateStringId("ShissuMarks_observeInfo4", "- beim verlassen in die Gilde")
ZO_CreateStringId("ShissuMarks_autoKick", "Automatisches Kicken")
ZO_CreateStringId("ShissuMarks_autoKickInfo", "Spieler in der Liste: AutoKick werden direkt gekickt:")
ZO_CreateStringId("ShissuMarks_autoKickInfo2", "- beim einloggen")
ZO_CreateStringId("ShissuMarks_autoKickInfo3", "- beim eintreten in die Gilde")
ZO_CreateStringId("ShissuMarks_found", "ist in den Gilden.")
ZO_CreateStringId("ShissuMarks_found2", "Der Spieler wurde gekickt (falls Rechte vorhanden).")
ZO_CreateStringId("ShissuMarks_rightItem", "Spieler/Monster entfernen")
ZO_CreateStringId("ShissuMarks_rightItem2", "Rechte Maustaste auf Name")    