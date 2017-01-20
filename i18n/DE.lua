-- File: DE.lua
-- Zuletzt geändert: 18. Januar 2016

ShissuGT.i18n = {
  ["InviteC"] = ShissuGT.Color[5] .. "In die Gilde " .. ShissuGT.Color[6] .. "%1" .. ShissuGT.Color[5] .. " einladen",
  ["MoTD_CHANGED"] = ShissuGT.Color[7] .. ShissuGT.Lib.ReplaceCharacter("(Änderung) "),
  ["Invite"] = ShissuGT.Color[1] .. "beigetreten",
  ["Leave"] = ShissuGT.Color[3] .. "verlassen",  
  ["MemberInSight"] = "Spieler in Gilde?",
  ["Alliance"] = GetString(SI_LEADERBOARDS_HEADER_ALLIANCE),
  ["ChatButton"] = ShissuGT.Color[6] .. "Linke Maustaste" ..  ShissuGT.Color[5] .." - Notizbuch\n"..  ShissuGT.Color[6] .. "Rechte Maustaste".. ShissuGT.Color[5].. " - Kostenloser Teleport",
  ["ToolTipHTML"] = "HTML Schriftfarbe \n\n z.B. für #000000 \n xxxxxx durch 000000 ersetzen",
  ["Disabled"] = "deaktiviert",
  ["RollChatde"] = " hat bei einem Zufallswurf (1-MAX) die Zahl: RND erwürfelt.",
  ["RollChatfr"] = " roule le nombre RND dans un jet aléatoire de 1-MAX",
  ["RollChaten"] = " rolls the number RND in a random throw of 1-MAX", 
  ["RestTime"] = "Restzeit",
}

ShissuGT.i18n.Notebook = {
  ["Title"] = "Notizblock",   
  ["MessagesLength"] = "E-Mail: ",  
  ["ChatLength"] = "Chat: ",
  ["All"] = "- Alle",   
  ["FriendList"] = ShissuGT.Color[2] .. " - |r" .. "Freundesliste",   
  ["PageTitle"] = "Seite ",  
  ["ChatCommand"] = "Chat Befehl /sgt n:"..ShissuGT.Color[6],
  ["SlashCommand"] = "Chat Befehl",     
  ["MailTitle"] = "Liste",
  ["MailChoiceL"] ="Auswahl: ",
  ["MailOfflineSince"] = "Offline",
  ["MailDays"] = " Tage",
  ["MailERR_FAIL_BLANK_MAIL"] = ShissuGT.Lib.ReplaceCharacter("Nachricht unvollständig") ,      
  ["MailDoneL"] ="FERTIG!",
  ["MailKick"] = "Nachrichtenkick", -- NEU,
  ["MailOn"] = "AN",
  ["MailOff"] = "AUS",   
  ["MailGuild"] = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY),
  ["MailRank"] = GetString(SI_STAT_GAMEPAD_RANK_LABEL),
  ["MailSend"] = GetString(SI_MAIL_SEND_SEND),
  ["MailProgress"] ="Bitte warten...",
  ["ProgressKickTitle"] ="Spieler entfernen",
  ["ProgressTitle"] = "E-Mail senden",
  ["ProgressAbort"] = "Abgebrochen", 
  ["List"] = "Liste",
  ["Choice"] = "Auswahl",
  ["ToolTipToogle"] = "Notizbuch",
  ["ToolTipNew"] = "Neue Notiz",
  ["ToolTipDelete"] = ShissuGT.Lib.ReplaceCharacter("Notiz löschen"),
  ["ToolTipChat"] =  ShissuGT.Color[6] .. "Linke Maustaste" ..  ShissuGT.Color[5] .." - Notiz in den Chat posten\n"..  ShissuGT.Color[6] .. "Rechte Maustaste".. ShissuGT.Color[5].. " - Notiz abspeichern",
  ["ToolTipUndo"] = "Änderungen Rückgängig machen",
  ["ToolTipRed"] = "Standardfarbe 1",
  ["ToolTipYellow"] = "Standardfarbe 2",
  ["ToolTipGreen"] = "Standardfarbe 3",
  ["ToolTipBlue"] = "Standardfarbe 4",
  ["ToolTipWhite"] = "Weiße Schrift",
  ["ToolTipHTML"] = "Farbe direkt auswählen",
  ["ToolTipEMail"] = "E-Mail an Auswahl verschicken",
  ["ToolTipEMailList"] = "E-Mail an Spieler in der Liste verschicken",
  ["ToolTipKick"] = "Auswahl aus der Gilde kicken (ggf. mit E-Mail)",
  ["ToolTipKickList"] = "Spieler in der Liste aus der Gilde kicken (ggf. mit E-Mail)",
  ["ToolTipEMaikKick"] = "E-Mail beim Kicken des/der Spieler verschicken",
  ["ToolTipName"] = "Klicke mit der " .. ShissuGT.Color[6] .. "rechten Maustaste" .. ShissuGT.Color[5] .." auf einen Namen, um diesen Spieler " .. ShissuGT.Lib.ReplaceCharacter("auszuschließen"),
  ["ToolTipOnline"] = "Online, BRB, AFK",
  ["ToolTipOffline"] = "Offline",  
  ["ToolTipAbort"] = ShissuGT.Color[6] .. "Fenster " .. ShissuGT.Lib.ReplaceCharacter("schließen") .. ShissuGT.Color[5] .. "\nDurch das " .. ShissuGT.Lib.ReplaceCharacter("Schließen") .. " wird das Versenden/Kicken abgebrochen.",
  ["ToolTipContin"] = "Sollte der Versand aus irgendwelchen " .. ShissuGT.Lib.ReplaceCharacter("Gründen ") .. ShissuGT.Color[6] .. "nicht voranschreiten".. ShissuGT.Color[5] .. ", dann klicke auf diesem Button. Der aktuelle " .. ShissuGT.Lib.ReplaceCharacter("Empfänger") .. " wird i.d.F. ignoriert.",
  ["Disabled"] = "Du hast das Notizbuch in deinen Einstellungen ",
  ["ConfirmNoteDelete"] = "Möchten Sie die Notiz wirklich löschen?",
  ["ConfirmEmailKick"]  = "Sollen die Spieler in der Liste, bzw. Ihre Auswahl aus der Gilde entfernt werden? Spieler die sie entfernen, erhalten eine E-Mail von Ihnen.",
 
  ["Protocol"] = "Protokoll",
  ["ProtocolTT"] = "Zeigt die Spieler an, die einen vollen Briefkasten haben, bzw. dich ignorieren.",
  ["ProtocolIgnore"] = "Ignoriert",
  ["ProtocolFull"] = "Postkasten voll",
  ["ProtocolIgnoreTT"] = "Der Spieler ignoriert dich, oder du ignorierst den Spieler!",
  ["Subject"] = "Betreff",
  ["Progress"] = "Fortschritt",
  
  ["ListAddRemove"] = ShissuGT.Color[6] .. "Linke Maustaste" ..  ShissuGT.Color[5] .." - Liste hinzufügen\n"..  ShissuGT.Color[6] .. "Rechte Maustaste".. ShissuGT.Color[5].. " - Liste löschen",
  ["ListPlayerAdd"] = "Spieler hinzufügen", 
  ["ListPlayerRemove"] = "Spieler entfernen",
  ["ListPlayerBuildGroup"] = "Spieler in Gruppe einladen", 
}

ShissuGT.i18n.History = {
  ["Gold"] = ShissuGT.Color[6] .. "Gold ".. ShissuGT.Color[5] .. "Aufzeichnungen ein-/ausblenden",
  ["Item"] = ShissuGT.Color[6] .. "Items " .. ShissuGT.Color[5] .. "Aufzeichnungen ein-/ausblenden",
  ["Choice"] = "Anzahl der "..ShissuGT.Color[6] .. "ausgewählten" .. ShissuGT.Color[5] .." Einträge in der Liste",
  ["Filter"] = "Suche nach " .. ShissuGT.Color[6] .. "xyz " .. ShissuGT.Color[5] .. "in den Aufzeichnungen: Name, Gegenstände, Preise.",
  ["FilterBox"] = GetString(SI_HELP_FILTER_BY),
  ["Choice2"] = "Auswahl",
  ["OnOff"] = "Ein-/Ausblenden",

  ["Trader"] = "seit Gildenhändler",
  ["AllPage"] = "alle Seiten öffnen",
  ["AllPageInfo"] = "Alle Seiten in der Gildenaufzeichnungen öffnen. \n\n" .. ShissuGT.Color[2] .. "ACHTUNG" .. ShissuGT.Color[5] .. ": Das Öffnen der VERKÄUFE kann sehr lange dauern!",
  ["GoldAdded"] = "Eingezahlt:",
  ["GoldRemoved"] = "Ausgezahlt:",
  ["ItemAdded"] = "Eingelagert:",
  ["ItemRemoved"] = "Entnommen:",
  ["Sells"] = "Verkäufe", 
  ["Intern"] = "Intern:",
  ["Sales"] = "Umsatz:",
  ["Tax"] = "Steuern:",
  ["Member"] = "Mitglied seit",
  
  ["Total"] = "Total",
  ["Last"] = "Zuletzt",
  ["thisWeek"] = "Diese Woche",
  ["lastWeek"] = "Letzte Woche",
  ["before"] = "vor",
  ["scanner1"] = "Die Gildenaufzeichnungen von",
  ["scanner2"] = "werden gerade eingelesen. Bitte warten...",  
}

ShissuGT.i18n.Roster = {
  ["Online"] = ShissuGT.Color[6] .. "Online ".. ShissuGT.Color[5] .. "Spieler [Online, AFK, BRB] ein-/ausblenden",
  ["Offline"] = ShissuGT.Color[6] .. "Offline " .. ShissuGT.Color[5] .. "Spieler ein-/ausblenden",
  ["Choice"] = "Anzahl & Prozentualler Anteil der "..ShissuGT.Color[6] .. "ausgewählten" .. ShissuGT.Color[5] .." Spieler in der Liste",
  ["Aldmeri"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE1),"^"), -- "Aldmeri Dominion"
  ["Ebonheart"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE2),"^"), --"Ebenherz-Pakt"
  ["Daggerfall"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE3),"^"), --"Dolchsturz Bündnis"
  ["Character"] = "CHARAKTER",
}

ShissuGT.i18n.Setting = {
  ["ContextMenu"] = ShissuGT.Color[6].. ShissuGT.Lib.ReplaceCharacter("Kontextmenü"),
  ["InviteMessage"] = "Willkommennachricht im Chat?", 
  ["InviteMessageDesc"] = ShissuGT.Color[6] .. "%1" .. ShissuGT.Color[5] .. " = Spielername \n\n ".. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .." = Trennhalter für verschiedene Zufalls-Nachrichten \n\nz.B. Willkommen ".. ShissuGT.Color[6] .."%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Willkommen bei uns " .. ShissuGT.Color[6] ..  "%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Hi " .. ShissuGT.Color[6] .. "%1",
  ["GuildInfo"] = ShissuGT.Color[6].. "Gildeninformation|r",
  ["GuildInfoInvite"] = "Spieler in Gilde einblenden",
  ["Guild"] = "Gildenfenster",
  ["General"] = GetString(SI_KEYBINDINGS_CATEGORY_GENERAL),
  ["Notif"] = GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS),
  ["Roster"] = ShissuGT.Color[6] .. "Filter: " .. ShissuGT.Color[5] .. GetString(SI_GUILDRANKS2),
  ["History"] = ShissuGT.Color[6] ..  "Filter: " .. ShissuGT.Color[5] .. GetString(SI_GUILD_HISTORY_ACTIVITY_LOG),
  ["NewMail"] = GetString(SI_SOCIAL_MENU_SEND_MAIL),
  ["Invite"] = GetString(SI_NOTIFICATIONTYPE2),
  ["MoTD"] = GetString(SI_GUILD_MOTD_HEADER),   
  ["Status"] = GetString(SI_FRIENDS_LIST_PANEL_TOOLTIP_STATUS),
  ["PInvite"] = GetString(SI_GUILDEVENTTYPE7),
  ["PRemove"] = GetString(SI_GUILDEVENTTYPE8),    
  ["PDay"] = GetString(SI_GUILD_MOTD_HEADER),
  ["MailDeleteNotif"] = ShissuGT.Lib.ReplaceCharacter("E-Mail löschen"),
  ["CAutoSwitch"] = "Automatischer Chatwechsel",
  ["CAutoChat"] =  "Automatische Nachrichten",
  ["CAutoChatDesc"] =  ShissuGT.Lib.ReplaceCharacter("Das Notizbuch muss für diese Funktion aktiviert sein. Lege im Notizbuch zu einer beliebigen Notiz entsprechende AutoPost Keywords an."),
  ["Whisper"] = GetString(SI_SOCIAL_LIST_PANEL_WHISPER),
  ["Group"] = GetString(SI_SOCIAL_MENU_GROUP),
  ["PlayerStatus"] = ShissuGT.Color[6].. GetString(SI_FRIENDS_LIST_PANEL_TOOLTIP_STATUS),
  ["PlayerStatusChat"] = "Spielerstatuswechsel per Chatbefehl",
  ["AutoAFK"] = "Automatisch AFK",
  ["AutoAFKMin"] = "Automatisch AFK nach xx Minuten",
  ["InviteE"] = "(anderer) Spieler",
  ["InviteC"] = "Kontextmenü",
  ["GuildColor"] = "farbige Notizen, MoTD, ...",
  ["ChatAlliance"] = "Allianzen farbig hervorheben",
  ["ChatLevel"] = "Levelangaben im Gildenchat",
}

ShissuGT.i18n.Context = {
  ["Del"] = ShissuGT.Lib.ReplaceCharacter("Löschen"),
  ["Forward"] = "Weiterleiten",
  ["Answer"] = "Antworten",
  ["PersNote"] = ShissuGT.Lib.ReplaceCharacter("Persönliche Notiz bearbeiten"),
  ["ContextResetChar"] = "Charakternamen zurücksetzen",     
}

ShissuGT.i18n.Bindings = {
  ["Notebook"] = "Notizbuch ein-/ausblenden",  
  ["Helm"] = "Helm ein-/ausblenden",  
  ["Reload"] = "Reload UI",    
  ["Teleport"] = "Kostenloser Zufallsteleport",   
}

ShissuGT.i18n.Teleport = {
  ["Random"] = "Zufallsteleport",  
  ["New"] = "Aktualisieren",  
  ["Title"] = "Teleporter (kostenlos)",    
  ["Disabled"] = "Du hast das Teleporter in deinen Einstellungen ",
}

ShissuGT.i18n.SlashCommand = {  
  ["RemoveChar1"] = "Spieler: <<1>> wurde in der Charakterdatenbank zurückgesetzt.",
  ["RemoveChar2"] = "Es wurde kein Spieler mit dem Accountname: <<1>> gefunden.",
  ["RemoveChar3"] = "Die Charakterdatenbank wurde vollständig zurückgesetzt.",
  ["RemoveChar1N"] = "Soll der Spieler: <<1>> wirklich in der Charakterdatenbank zurückgesetzt werden (RESET)?",
  ["RemoveChar4"] = "Sollen alle Charaktere aus der Datenbank gelöscht werden?",
  
  ["Help"] = " Chatbefehle:\n\n" ..
   "<<1>>/sgt<<2>>" .. "                       - Auflistung aller Chatbefehle\n"  ..
   "<<1>>/sgt note<<2>>" .. "             - Notizblock öffnen\n" ..
   "<<1>>/sgt n:X<<2>>" .. "                - Notiz X aus dem Notizbuch publizieren\n" ..
   "<<1>>/sgt tele<<2>>" .. "               - Gildenteleporter öffnen\n" ..
   "<<1>>/sgt char reset<<2>>" .. "      - Setzt die Charakterdatenbank zurück.\n" ..
   "<<1>>/sgt char X<<2>>" .. "               - Setzt die Charaktere des Spieler X zurück.\n" ..
   "<<1>>/roll X, /dice X<<2>>" .. "    - Würfeln einer Zufallszahl zwischen 1 - X\n" ..
   "<<1>>/ginv X Y<<2>>" .. "               - Spieler Y in Gilde X (1-5) einladen\n" ..
   "<<1>>/teleport X" ..   "                - Zu Spieler X teleportieren" .. 
   "<<1>>/on, /online<<2>>" .. "         - Ändert den Spielerstatus auf ONLINE\n" ..
   "<<1>>/dnd, /brb<<2>>" .. "            - Ändert den Spielerstatus auf BESCHÄFTIGT\n" ..
   "<<1>>/AFK<<2>>" .. "                      - Ändert den Spielerstatus auf ABWESEND\n" ..
   "<<1>>/off, /offline<<2>>" .. "        - Ändert den Spielerstatus auf OFFLINE\n" .. 
   "<<1>>/rl<<2>>" .. "                           - Reload UI\n",  
}

ShissuGT.i18n.Color = {
  ["Standard1"] = "Standardfarbe 1",
  ["Standard2"] = "Standardfarbe 2",
  ["Standard3"] = "Standardfarbe 3",
  ["Standard4"] = "Standardfarbe 4",
  ["White"] = "Weiße Schrift",
  ["ANY"] = "Farbe auswählen",
}

ShissuGT.i18n.Settings = {
  [1] = {
    Head = "Gildenübergreifende Funktionen",
     
    Section1 = GetString(SI_KEYBINDINGS_CATEGORY_GENERAL),
    Notebook = "Notizbuch",
    NotebookEMail = "Notizbuch: E-Mail Funktionen",
    Teleporter = "Teleporter",

    Section2 = "Benachrichtigungen / Hinweise",
    EMailDel = "Hinweis: E-Mail löschen",
         
    Section3 = "Gildenfenster",
    KioskTimer = "Gildenhändler Countdown",
    History = "Gildenaufzeichnungen: Filter",
    Roster = "Gildenroster",
    Color = "Farbige Notizen, MotD, ...",
     
    Section4 = "Chat",
    ChatInGuild = "Spieler in Gilde?",
    ChatTime = "Uhrzeit im Chat",
    ChatAutoSwitchGroup = "Gruppe: Automatisches Wechseln",
    ChatAutoChatGroup = "Gruppe: Automatische Nachrichten",
    ChatAutoSwitchWhisper = "@Flüstern: Automatisches Wechseln",
    ChatWhisperGuildInfo = "@Flüstern: Gildeninformation",
    ChatGuildName = "Chat: Gildenname",
    ChatWhisperSound = "Flüstern: Sound",
     
    Section5 = "Kontextmenü",
    ContextMenuChatInvite = "Chat: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuChatEMail = "Chat: " .. GetString(SI_SOCIAL_MENU_SEND_MAIL),
    ContextMenuEMail = "E-Mail: Antworten, Weiterleiten",
    ContextMenuEMailInvite = "E-Mail: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuGuild = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY) .. ": " .. GetString(SI_NOTIFICATIONTYPE2),
     
    Section6 = "Spielerstatus",
    PlayerStatusChat = "Spielerstatus Chatbefehle",
    PlayerStatusAFK = "Automatisches AFK",
    PlayerStatusAFKMin = "Automatisch AFK nach xx Minuten",    
  },
  [2] = {
    Head = "Gildenspezifische Funktionen",
    
    -- Mitglieder
    Section1 = GetString(SI_GAMEPAD_GUILD_RANK_PERMISSIONS_MEMBERS),
    MemberStatus = "Spielerstatus (Online, AFK, BRB, DND)",
    MemberAdd = "Spieler ist der Gilde beigetreten",
    MemberRemove = "Spieler hat die Gilde verlassen",
    MemberInSight = "Gildenmitglied in Sichtfeld",
    
    -- Benachrichtigungen
    Section2 = GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS),
    NotificationMoTD = GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS) .. ": " .. GetString(SI_GUILD_MOTD_HEADER),
    Section3 = "Chat",
    ChatCharacter = "Chat: Charaktername@Accountname",
    ChatLevel = "Chat: Level",
    ChatAlliance = "Chat: " .. GetString(SI_GAMEPAD_WORLD_MAP_TOOLTIP_ALLIANCE_OWNER),
    ChatLead = "Chat: Gildenleiter & Offiziere hervorheben",
    ChatLead2 = "",
    ChatAutoSwitch = "Chat: Automatisches Wechseln",
    ChatAutoChat = "Chat: Automatiche Nachrichten",
    ChatAutoWelcome = "Chat: Willkommensnachricht",
    ChatAutoWelcome2 = "Chat: Willkommensnachricht, anderer Spieler",
    ChatAutoDescription = ShissuGT.Color[5] .. "Willkommensnachricht\n" .. ShissuGT.Color[6] .. "%1" .. ShissuGT.Color[5] .. " = Spielername\n" .. ShissuGT.Color[2] .. "%2" .. ShissuGT.Color[5] .. " = Gildenname\n" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .." = Trennhalter für verschiedene Zufalls-Nachrichten",
    ChatAutoExample = "\nz.B. Willkommen " .. ShissuGT.Color[6] .."%1" .. ShissuGT.Color[5] .. " in " .. ShissuGT.Color[2] .. "%2" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Willkommen bei uns " .. ShissuGT.Color[6] ..  "%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Hi " .. ShissuGT.Color[6] .. "%1",
  },
  [3] = {
    Head = "Farben",
     
    Section1 = "Standardfarben",
    Standard1 = ShissuGT.i18n.Color.Standard1,
    Standard2 = ShissuGT.i18n.Color.Standard2,
    Standard3 = ShissuGT.i18n.Color.Standard3,
    Standard4 = ShissuGT.i18n.Color.Standard4,
     
    Section2 = "Chat",
    Time = "Uhrzeit",
    Character = "Charaktername",
  },
  [4] = {
    Head = "Sonstige Optionen", 
    MemberInSightLock = "Gildenmitglied in Sichtfeld: Fensterposition",
    MemberInSightMore = "Gildenmitglied in Sichtfeld: Erweitert",
    MemberData = "MemberData löschen, beim Ausschluß",
    RosterNote = "Roster: Persönliche Notizen, gildenübergreifend",
    TimeZone = "Zeitzone (UTX+X)",
    GuildData = "GuildData löschen, beim Verlassen",
  },
}

ShissuGT.i18n.SettingsToolTip = {
  [1] = {
    -- Section1: Allgemein
    Notebook = "Notizbuch aktivieren/deaktivieren",
    NotebookEMail = "Notizbuch: E-Mail Funktionen aktivieren/deaktiviern",
    Teleporter = "Teleporter aktivieren/deaktivieren",
    
    -- Section2: Benachrichtigungen
    EMailDel = "Aktiviert/Deaktiviert den Bestätigungsdialog: E-Mail wirklich löschen?",
    
    -- Section3: Gildenfenster
    KioskTimer = "Blendet im Gildenfenster die Zeit bis zum Erwerb des nächsten Gildenhändler ein.",
    History = "Aktiviert/Deaktiviert die modifizierten Gildenaufzeichnungen",
    Roster = "Aktiviert/Deaktiviert den modifizierten Gildenroster",
    RosterNote = "Aktiviert/Deaktiviert die persönlichen Notizen im Gildenroster.",
    Color = "Aktiviert/Deaktiviert Farbige Notizen, MotD, ... im Gildenfenster",
     
    -- Section4: Chat
    ChatInGuild = "Blendet zusätzlich den Gildennamen eines Spieler im Chat ein, wenn sich dieser in einer deiner Gilden befindet.",
    ChatTime = "Blendet die Uhrzeit im Chat ein.\n\nBeispiel:\n [16:12:13] [Gebiet] [Shissu]: Hallo",
    ChatAutoSwitchGroup = "Der Chat wechselt automatisch in den Gruppenchat, wenn was geschrieben wird.",
    ChatAutoSwitchWhisper = "Der Chat wechselt automatisch in den Flüsterchat, wenn dich ein @Spieler anschreibt.",
    ChatAutoChatGroup = "Der Chat wechselt automatisch in den Gruppenchat, und bereitet eine entsprechende Nachricht aus dem Notizbuch vor, wenn er das entsprechende Stichwort findet.",
    ChatWhisperGuildInfo = "Wenn der Spieler sich in eine deiner Gilden befindet, werden die zusätzliche Informationen angezeigt.",
    ChatGuildName = "Chat: Blendet den Gildennamen im Chat mit ein. \n\nBeispiel:\n [16:12:13] [Gebiet] [Tamrizon] [Shissu@Shissu]: Hallo",
             
    -- Section5: Kontextmenü
    ContextMenuChatInvite = "Chat: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuChatEMail = "Chat: " .. GetString(SI_SOCIAL_MENU_SEND_MAIL),
    ContextMenuEMail = "E-Mail: Antworten, Weiterleiten",
    ContextMenuEMailInvite = "E-Mail: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuGuild = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY) .. ": " .. GetString(SI_NOTIFICATIONTYPE2),
     
    -- Section6: Spielerstatus
    PlayerStatusChat = "Aktiviert die Chatbefehle um den Spielerstatus zu ändern (siehe /sgt)",
    PlayerStatusAFK = "Ändert den Spielerstatus automatisch nach x-Minuten auf AFK, wenn nix getan wird.",
    PlayerStatusAFKMin = "Automatisch AFK nach xx Minuten",        
  },
  [2] = {
    -- Section1: Mitglieder
    MemberStatus = "Blendet den Spielerstatus (Online, AFK, BRB, DND) in der Chatbox ein.\n\nBeispiel:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "Online",
    MemberAdd = "Blendet im Chat die Info ein, wenn ein Spieler der Gilde beigetreten ist.\n\nBeispiel:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "beigetreten",
    MemberRemove = "Blendet im Chat die Info ein, wenn ein Spieler der Gilde verlassen hat.\n\nBeispiel:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "verlassen",
    MemberInSight = "Zeigt dir an, ob ein Spieler in deinem Sichtfeld in deiner Gilde ist.",
    
    -- Section2: Benachrichtigungen
    NotificationMoTD = "Aktiviert/Deaktiviert die Benachrichtigung: Nachricht des Tages",
     
    -- Section3: Chat
    ChatCharacter = "Blendet zusätzlich den Charakternamen im Chat ein.\n\nBeispiel:\n [16:12:13] [Gebiet] [Shissu@Shissu]: Hallo",
    ChatLevel = "Blendet das Level des Gildenmitglieds im Gildenchat ein.",
    ChatLead = "Chat: Gildenleiter & Offizier hervorheben",
    ChatLead2 = "Chat: Gildenleiter & Offizier ab Rank",
    ChatAlliance = "Blendet die Fraktion des Gildenmitglieds im Gildenchat ein, indem sich das @ entsprechend einfärbt.",
    ChatAutoChat = "Der Chat wechselt automatisch in den Gruppenchat, und bereitet eine entsprechende Nachricht aus dem Notizbuch vor, wenn er das entsprechende Stichwort findet.",
    ChatAutoSwitch = "Der Chat wechselt automatisch in den Gildenchat, wenn was geschrieben wird.",
    ChatAutoWelcome = "Wenn du einen Spieler in der Gilde einlädst, wird der entsprechende Text deiner Wahl in der Chatbox vorbereitet.",
    ChatAutoWelcome2 = "Wenn jemand einen Spieler in der Gilde einlädt, wird der entsprechende Text deiner Wahl in der Chatbox vorbereitet.",
  },
  [3] = {
    Head = "Farben",
     
    Section1 = "Standardfarben",
    Standard1 = ShissuGT.i18n.Color.Standard1,
    Standard2 = ShissuGT.i18n.Color.Standard2,
    Standard3 = ShissuGT.i18n.Color.Standard3,
    Standard4 = ShissuGT.i18n.Color.Standard4,
     
    Section2 = "Chat",
    Time = "Uhrzeit",
    Character = "Charaktername",
  },
  [4] = {
    Head = "Sonstige Optionen", 
    MemberInSightLock = "Gildenmitglied in Sichtfeld: Fensterposition",
    MemberInSightMore = "Gildenmitglied in Sichtfeld: Erweitert",
    MemberData = "MemberData löschen, beim Ausschluß",
    RosterNote = "Roster: Persönliche Notizen, gildenübergreifend",
    TimeZone = "Zeitzone (UTX+X)",
    GuildData = "GuildData löschen, beim Verlassen",
  },
}

ShissuGT.i18n.Feedback = {
  [1] = "Ich erhalte deine E-Mail nur, wenn du auf dem EU-Server spielst!",
  [2] = "Ich hoffe, dass Shissu's Guild Tools (SGT) dir weiter hilft! Feedback ist immer wichtig. Deshalb ist dein Feedback immer willkommen. Wenn du mir ein Feedback zukommen lassen möchte, dann schreibe mir eine kleine Ingame-Notiz als E-Mail, mit oder ohne eine Spende.  Deine Spende hilft mir meine gruppenbasierende ESO-Zeit, sowie auch die Organisation meiner eigenen Gilden zu reduzieren. Letztendlich kann mich so auf auf weitere Features & neue AddOns für ESO konzentrieren.",
}

ShissuGT.i18n.Sounds = {
  [SOUNDS.NONE] = "AUS",
  [SOUNDS.EMPEROR_DEPOSED_ALDMERI] = "AVA 1",
  [SOUNDS.AVA_GATE_CLOSED] = "AVA 2",
  [SOUNDS.NEW_NOTIFICATION] = "Benachrichtigung",
  [SOUNDS.CHAMPION_POINTS_COMMITTED] =  "Championspunkte 1",
  [SOUNDS.CHAMPION_ZOOM_IN] =  "Championspunkte 2",
  [SOUNDS.CHAMPION_ZOOM_OUT] =  "Championspunkte 3",
  [SOUNDS.CHAMPION_STAR_MOUSEOVER] =  "Championspunkte 4",
  [SOUNDS.CHAMPION_CYCLED_TO_MAGE] =  "Championspunkte 5",
  [SOUNDS.BLACKSMITH_EXTRACTED_BOOSTER] =  "Crafting 1",
  [SOUNDS.ENCHANTING_ASPECT_RUNE_REMOVED] =  "Crafting 2",
  [SOUNDS.SMITHING_OPENED] =  "Crafting 3",
  [SOUNDS.GUILD_ROSTER_REMOVED] =  "Gilde 1",
  [SOUNDS.GUILD_ROSTER_ADDED] =  "Gilde 2",
  [SOUNDS.GUILD_WINDOW_OPEN] =  "Gilde 3",
  [SOUNDS.GROUP_DISBAND] = "Gruppe",
  [SOUNDS.DEFAULT_CLICK] = "Klick 1",
  [SOUNDS.EDIT_CLICK] = "Klick 2",
  [SOUNDS.STABLE_FEED_STAMINA] = "Misc 1",
  [SOUNDS.QUICKSLOT_SET] = "Quickslot",
  [SOUNDS.MARKET_CROWNS_SPENT] = "Shop",
}