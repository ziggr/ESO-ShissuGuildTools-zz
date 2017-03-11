-- File: EN.lua
-- Zuletzt geändert: 09. Januar 2016

ShissuGT.i18n = {
  ["InviteC"] = ShissuGT.Color[5] .. "Invite into " .. ShissuGT.Color[6] .. "%1",
  ["MoTD_CHANGED"] = ShissuGT.Color[7] .. "(Change) ",
  ["Invite"] = ShissuGT.Color[1] .. "joined",
  ["Leave"] = ShissuGT.Color[3] .. "leave",  
  ["MemberInSight"] = "Players in the guild?",
  ["Alliance"] = GetString(SI_LEADERBOARDS_HEADER_ALLIANCE),
  ["ChatButton"] = ShissuGT.Color[6] .. "Left mousebutton" ..  ShissuGT.Color[5] .." - Notebook\n"..  ShissuGT.Color[6] .. "Right mousebutton".. ShissuGT.Color[5].. " - Free Teleport",
  ["ToolTipHTML"] = "HTML Fontcolor \n\n e.g. for black color #000000 \n replace xxxxxx with 000000",
  ["Disabled"] = "Disabled",
  ["RollChatde"] = " hat bei einem Zufallswurf (1-MAX) die Zahl: RND erwürfelt.",
  ["RollChatfr"] = " roule le nombre RND dans un jet aléatoire de 1-MAX",
  ["RollChaten"] = " rolls the number RND in a random throw of 1-MAX", 
  ["RestTime"] = "Left Time",
}

ShissuGT.i18n.Notebook = {
  ["Title"] = "Notenbook",   
  ["MessagesLength"] = "E-Mail: ",  
  ["ChatLength"] = "Chat: ",
  ["All"] = "- all",   
  ["FriendList"] = ShissuGT.Color[2] .. " - |r" .. "friends list",   
  ["PageTitle"] = "Page ",  
  ["ChatCommand"] = "Chat Command /sgt n:"..ShissuGT.Color[6],
  ["SlashCommand"] = "Chat Command",     
  ["MailTitle"] = "Lists",
  ["MailChoiceL"] ="Choice: ",
  ["MailOfflineSince"] = "Offline",
  ["MailDays"] = " Days",
  ["MailERR_FAIL_BLANK_MAIL"] = "Message Blank" ,      
  ["MailDoneL"] ="DONE!",
  ["MailKick"] = "Messageskick", -- NEU,
  ["MailOn"] = "ON",
  ["MailOff"] = "OFF",  
  ["MailGuild"] = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY),
  ["MailRank"] = GetString(SI_STAT_GAMEPAD_RANK_LABEL),
  ["MailSend"] = GetString(SI_MAIL_SEND_SEND),  
  ["MailProgress"] ="Please wait...",
  ["ProgressKickTitle"] ="Remove player",
  ["ProgressTitle"] = "Send E-Mail",
  ["ProgressAbort"] = "Canceled",
  ["List"] = "List",
  ["Choice"] = "Selection",
  ["ToolTipToogle"] = "Notebook",
  ["ToolTipNew"] = "New Note",
  ["ToolTipDelete"] = "Delete Note",
  ["ToolTipChat"] =  ShissuGT.Color[6] .. "Left mousebutton" ..  ShissuGT.Color[5] .." - Send Note to the Chat\n"..  ShissuGT.Color[6] .. "Right mousebutton".. ShissuGT.Color[5].. " - Save Note",
  ["ToolTipUndo"] = "Undo Changes",  
  ["ToolTipRed"] = "Red font",
  ["ToolTipYellow"] = "Yellow font",
  ["ToolTipGreen"] = "Green font",
  ["ToolTipBlue"] = "blue font",
  ["ToolTipWhite"] = "white font",
  ["ToolTipHTML"] = "HTML fontcolor \n\n e.g. for #000000 \n/h000000Hallo/c",
  ["ToolTipEMail"] = "Send email to selection",
  ["ToolTipEMailList"] = "Send e-mail to players in the list",
  ["ToolTipKick"] = "Select from the guild kick (possibly with e-mail)",
  ["ToolTipKickList"] = "Players in the list from the guild kick (possibly with e-mail)",
  ["ToolTipEMaikKick"] = "Send e-mail when kicking players",
  ["ToolTipName"] = "Click with the " .. ShissuGT.Color[6] .. "right mousebutton" .. ShissuGT.Color[5] .." on a name to avoid this player",
  ["ToolTipOnline"] = "Online, BRB, AFK",
  ["ToolTipOffline"] = "Offline",  
  ["ToolTipAbort"] = ShissuGT.Color[6] .. "Window " .. ShissuGT.Lib.ReplaceCharacter("shutdown") .. ShissuGT.Color[5] .. "\nBy closing the sending / kicking is canceled.",
  ["ToolTipContin"] = "If the shipment for any reason " .. ShissuGT.Color[6] .. "not progress".. ShissuGT.Color[5] .. ", please click on this button. The current receiver is ignored.",
  ["Disabled"] = "The Notebook is in your settings ",
  ["ConfirmNoteDelete"] = "Do you want to delete the note?",
  ["ConfirmEmailKick"]  = "If the player in the list, or your selection are removed from the guild? Players that you remove, will receive an e -mail from you.",

  ["Protocol"] = "Log",
  ["ProtocolTT"] = "Displays the players who have a full mailbox, or ignore you.",
  ["ProtocolIgnore"] = "Ignored",
  ["ProtocolFull"] = "Mailbox full",
  ["ProtocolIgnoreTT"] = "The player ignores you, or you ignore the player!",
  ["Subject"] = "Subject",
  ["Progress"] = "Progress",
  
  ["ListAddRemove"] = ShissuGT.Color[6] .. "Left mousebutton" ..  ShissuGT.Color[5] .." - New List\n"..  ShissuGT.Color[6] .. "Right mousebutton".. ShissuGT.Color[5].. " - Remove List",
  ["ListPlayerAdd"] = "Add Player", 
  ["ListPlayerRemove"] = "Remove Player",
  ["ListPlayerBuildGroup"] = "Invite all Player in Group",
}

ShissuGT.i18n.History = {
  ["Gold"] = "Toogle " .. ShissuGT.Color[6] .. "Gold ".. ShissuGT.Color[5] .. "Records",
  ["Item"] = "Toogle " .. ShissuGT.Color[6] .. "Items " .. ShissuGT.Color[5] .. "Records",
  ["Choice"] = "Number of "..ShissuGT.Color[6] .. "selected" .. ShissuGT.Color[5] .." entries in list",
  ["Filter"] = "Search for " .. ShissuGT.Color[6] .. "xyz " .. ShissuGT.Color[5] .. "in the records: name, items, prices.",
  ["FilterBox"] = GetString(SI_HELP_FILTER_BY),
  ["Choice2"] = "Choice",
  ["OnOff"] = "Show / Hide",

  ["Trader"] = "since trader",
  ["AllPage"] = "open all pages",
  ["AllPageInfo"] = "Open all pages in the guild records.\n\n" .. ShissuGT.Color[2] .. "WARNING" .. ShissuGT.Color[5] .. ": Opening the SALES can take a long time!",
  ["GoldAdded"] = "Paid:",
  ["GoldRemoved"] = "Withdrawed:",
  ["ItemAdded"] = "Stored:",
  ["ItemRemoved"] = "Taken:",
  ["Sells"] = "Sells", 
  ["Intern"] = "Intern:",
  ["Sales"] = "Sales:",
  ["Tax"] = "Tax:", 
  ["Member"] = "Member since",
  
  ["Total"] = "Total",
  ["Last"] = "Last",
  ["thisWeek"] = "This Week",
  ["lastWeek"] = "Last Week",
  ["before"] = "vor",
  ["scanner1"] = "The Guild history of ",
  ["scanner2"] = "are being read. Please wait...",  
}

ShissuGT.i18n.Roster = {
  ["Online"] = ShissuGT.Color[6] .. "Online ".. ShissuGT.Color[5] .. "Player [Online, AFK, BRB] toogle",
  ["Offline"] = ShissuGT.Color[6] .. "Offline " .. ShissuGT.Color[5] .. "Player toogle",
  ["Choice"] = "Number & percentage share of "..ShissuGT.Color[6] .. "selected" .. ShissuGT.Color[5] .." Player in list",
  ["Aldmeri"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE1),"^"), -- "Aldmeri Dominion"
  ["Ebonheart"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE2),"^"), --"Ebenherz-Pakt"
  ["Daggerfall"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE3),"^"), --"Dolchsturz Bündnis"  
  ["Character"] = "CHARACTER",
}

ShissuGT.i18n.Setting = {
  ["ContextMenu"] = ShissuGT.Color[6].. "Context menu",
  ["InviteMessage"] = "Welcome message in the chat?",
  ["InviteMessageDesc"] = ShissuGT.Color[6] .. "%1" .. ShissuGT.Color[5] .. " = Player name \n\n ".. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .." = Release holder for various random messages \n\n e.g. welcome".. ShissuGT.Color[6] .."%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Welcome by us, " .. ShissuGT.Color[6] ..  "%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Hi " .. ShissuGT.Color[6] .. "%1",
  ["GuildInfo"] = ShissuGT.Color[6].. "Guild information|r",
  ["GuildInfoInvite"] = "Players in the field of view in guild",
  ["Guild"] = "Guildwindow",
  ["General"] = GetString(SI_KEYBINDINGS_CATEGORY_GENERAL),
  ["Notif"] = GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS),
  ["Roster"] = "Filter: " .. GetString(SI_GUILDRANKS2),
  ["History"] = "Filter: " .. GetString(SI_GUILD_HISTORY_ACTIVITY_LOG),
  ["NewMail"] = GetString(SI_SOCIAL_MENU_SEND_MAIL),
  ["Invite"] = GetString(SI_NOTIFICATIONTYPE2),
  ["MoTD"] = GetString(SI_GUILD_MOTD_HEADER), 
  ["Status"] = GetString(SI_FRIENDS_LIST_PANEL_TOOLTIP_STATUS),
  ["PInvite"] = GetString(SI_GUILDEVENTTYPE7),
  ["PRemove"] = GetString(SI_GUILDEVENTTYPE8),
  ["PDay"] = GetString(SI_GUILD_MOTD_HEADER),
  ["MailDeleteNotif"] = ShissuGT.Lib.ReplaceCharacter("E-Mail Deleted"),
  ["CAutoSwitch"] = "Automatic Chatchannel",
  ["CAutoChat"] =  "Automatic message",
  ["CAutoChatDesc"] =  ShissuGT.Lib.ReplaceCharacter("The notebook must be enabled for this feature. Put in your notebook to any note corresponding auto post to keywords."),
  ["Whisper"] = GetString(SI_SOCIAL_LIST_PANEL_WHISPER),
  ["Group"] = GetString(SI_SOCIAL_MENU_GROUP),    
  ["PlayerStatus"] = ShissuGT.Color[6].. GetString(SI_FRIENDS_LIST_PANEL_TOOLTIP_STATUS),
  ["PlayerStatusChat"] = "Player status changes via chat command",
  ["AutoAFK"] = "Automatically AFK",    
  ["AutoAFKMin"] = "Automatically AFK after xx minutes",  
  ["InviteE"] = "(other) Player",
  ["InviteC"] = "Contextmenue",
  ["GuildColor"] = "colored Notes, MoTD, ...",
  ["ChatAlliance"] = "Emphasize alliances color",
  ["ChatLevel"] = "Levelinfo in guild chat",
}

ShissuGT.i18n.Context = {
  ["Del"] = "Delete",
  ["Forward"] = "Forward",
  ["Answer"] = "Answer",
  ["ContextResetChar"] = "Reset Characternames",  
  ["PersNote"] = "Edit personal note",
}

ShissuGT.i18n.Bindings = {
  ["Notebook"] = "Toogle Notebook",  
  ["Helm"] = "Toogle Helm",  
  ["Reload"] = "Reload UI",    
  ["Teleport"] = "Free Random Teleport",   
}

ShissuGT.i18n.Teleport = {
  ["Random"] = "Random Teleport",  
  ["New"] = "To Refresh",  
  ["Title"] = "Teleporter (Free)",    
  ["Disabled"] = "The Teleporter is in your settings ",
}

ShissuGT.i18n.SlashCommand = {  
  ["RemoveChar1"] = "Player: << 1 >> has been reset in the character database.",
  ["RemoveChar2"] = "It was with the account name no player: <<1>> found.",
  ["RemoveChar3"] = "The character database has been completely reset.",
  ["RemoveChar1N"] = "If the player: 1<<1>> are really back in the character database (RESET)?",
  ["RemoveChar4"] = "Reset Character Database?",
    
  ["Help"] = " Chat commands:\n\n" ..
   "<<1>>/sgt<<2>>" .. "                       - A list of all chat commands\n"  ..
   "<<1>>/sgt note<<2>>" .. "             - Open notepad\n" ..
   "<<1>>/sgt n:X<<2>>" .. "                - Publish Note X from the notebook\n" ..
   "<<1>>/sgt tele<<2>>" .. "               - Open guild teleporters\n" ..
   "<<1>>/sgt char reset<<2>>" .. "      - Resets the character database\n" ..
   "<<1>>/sgt char X<<2>>" .. "               - Reset Characterdatabase of the player X\n" ..
   "<<1>>/roll X, /dice X<<2>>" .. "    - Dice a random number between 1 - X\n" ..
   "<<1>>/ginv X Y<<2>>" .. "               - Invite players Y in guild X (1-5)\n" ..
   "<<1>>/teleport X" ..   "                - Teleports to Player X" .. 
   "<<1>>/on, /online<<2>>" .. "         - Changes the player status to ONLINE\n" ..
   "<<1>>/dnd, /brb<<2>>" .. "            - Changes the player status to BRB\n" ..
   "<<1>>/AFK<<2>>" .. "                      - Changes the player status to AFK\n" ..
   "<<1>>/off, /offline<<2>>" .. "        - Changes the player status to OFFLINE\n" .. 
   "<<1>>/rl<<2>>" .. "                           - Reload UI\n",  
}

ShissuGT.i18n.Color = {
  ["Standard1"] = "Standard color 1",
  ["Standard2"] = "Standard color 2",
  ["Standard3"] = "Standard color 3",
  ["Standard4"] = "Standard color 4",
  ["White"] = "White Color",
  ["ANY"] = "Choose a color",
}

ShissuGT.i18n.Settings = {
  [1] = {
    Head = "Guild General Functions",
     
    Section1 = GetString(SI_KEYBINDINGS_CATEGORY_GENERAL),
    Notebook = "Notebook",
    NotebookEMail = "Notebook: E-mail features",
    Teleporter = "Teleporter",

    Section2 = "Notifications / Notices",
    EMailDel = "Note: Delete E-Mail",
         
    Section3 = "Guild Window",
    KioskTimer = "Guild Trader Countdown",
    History = "Guild Records : Filter",
    Roster = "Guild Roster",
    Color = "Colored notes, MotD, ...",
     
    Section4 = "Chat",
    ChatInGuild = "Player in Guild?",
    ChatTime = "Time in Chat",
    ChatAutoSwitchGroup = "Group: Automatic Chatchannel",
    ChatAutoChatGroup = "Group: Auto messages",
    ChatAutoSwitchWhisper = "@Whisper : Automatic Chatchannel",
    ChatWhisperGuildInfo = "@Whisper: Auto messages",
    ChatGuildName = "Chat: Guildname",
    ChatWhisperSound = "Whisper: Sound",
         
    Section5 = "Shortcut menu",
    ContextMenuChatInvite = "Chat: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuChatEMail = "Chat: " .. GetString(SI_SOCIAL_MENU_SEND_MAIL),
    ContextMenuEMail = "E-Mail: Reply, Forward",
    ContextMenuEMailInvite = "E-Mail: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuGuild = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY) .. ": " .. GetString(SI_NOTIFICATIONTYPE2),
    
    Section6 = "Player Status",
    PlayerStatusChat = "Player Status: Chat commands",
    PlayerStatusAFK = "Automatic AFK",
    PlayerStatusAFKMin = "Automatic AFK after XX minutes",    
  },
  [2] = {
    Head = "Guild Specific Functions",
     
    -- Mitglieder
    Section1 = GetString(SI_GAMEPAD_GUILD_RANK_PERMISSIONS_MEMBERS),
    MemberStatus = "Playerstatus (Online, AFK, BRB, DND)",
    MemberAdd = "Player has join the guild",
    MemberRemove = "Player has left the guild",
    MemberInSight = "Guild member in the field of view",
    
    -- Benachrichtigungen
    Section2 = GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS),
    NotificationMoTD = GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS) .. ": " .. GetString(SI_GUILD_MOTD_HEADER),
    Section3 = "Chat",
    ChatCharacter = "Chat: Charaktername@Accountname",
    ChatLevel = "Chat: Level",
    ChatAlliance = "Chat: " .. GetString(SI_GAMEPAD_WORLD_MAP_TOOLTIP_ALLIANCE_OWNER),
    ChatLead = "Chat: Highlight guild leader and officer",
    ChatLead2 = "",
    ChatAutoSwitch = "Chat: Automatic Chatchannel",
    ChatAutoChat = "Chat: Auto messages",
    ChatAutoWelcome = "Chat: Welcome Message",
    ChatAutoWelcome2 = "Chat: Welcome Message, other players",
    ChatAutoDescription = ShissuGT.Color[5] .. "Welcome Message\n" .. ShissuGT.Color[6] .. "%1" .. ShissuGT.Color[5] .. " = Playername\n" .. ShissuGT.Color[2] .. "%2" .. ShissuGT.Color[5] .. " = Guildname\n" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .." = Separating retainer for different random news",
    ChatAutoExample = "\ne.g. Welcome " .. ShissuGT.Color[6] .."%1" .. ShissuGT.Color[5] .. " in " .. ShissuGT.Color[2] .. "%2" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Hi " .. ShissuGT.Color[6] ..  "%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Meow Meow " .. ShissuGT.Color[6] .. "%1",
  },
  [3] = {
    Head = "Colors",
     
    Section1 = "Standard color",
    Standard1 = ShissuGT.i18n.Color.Standard1,
    Standard2 = ShissuGT.i18n.Color.Standard2,
    Standard3 = ShissuGT.i18n.Color.Standard3,
    Standard4 = ShissuGT.i18n.Color.Standard4,
     
    Section2 = "Chat",
    Time = "Time",
    Character = "Charaktername",
  },
  [4] = {
    Head = "Other options", 
    MemberInSightLock = "Guild member in field of view: window position",
    MemberInSightMore = "Guild member in field of view: Advanced",
    MemberData = "Delete Member Data, when leaving",
    RosterNote = "Roster: Personal Notes, Guild across",
    TimeZone = "time zone (UTC+X)",
    GuildData = "Delete all Guild Data, when leaving",
  },
}

ShissuGT.i18n.SettingsToolTip = {
  [1] = {
    -- Section1: Allgemein
    Notebook = "Enable / Disable notebook",
    NotebookEMail = "Notebook: Email-Functions (Enable / Disable)",
    Teleporter = "Enable / Disable teleporter",
    
    -- Section2: Benachrichtigungen
    EMailDel = "Enable/disable the confirmation dialog: E-mail to delete ?",

    -- Section3: Gildenfenster
    KioskTimer = "Hides in the guild window, the time to acquire the next Guild Trader.",
    History = "Enables / Disables the modified Guild records.",
    Roster = "Enables / Disables the modified Guild Roster",
    RosterNote = "Enables / Disables the personal notes in the guild roster",
    Color = "Enables / Disables colored notes, MotD , ... in the guild window",
     
    -- Section4: Chat
    ChatInGuild = "Hides additional the guild name of a player in chat, if it is located in one of your Guild.",
    ChatTime = "Shows the time in chat.\n\nExample:\n [16:12:13] [Zone] [Shissu]: Hallo",
    ChatAutoSwitchGroup = "The chat will automatically enter the group chat, if what is written.",
    ChatAutoSwitchWhisper = "The chat will automatically enter the @whisper chat, if what is written.",
    ChatAutoChatGroup = "The chat will automatically enter the group chat, and prepares a corresponding message from the notebook, if it finds the corresponding keyword.",
    ChatWhisperGuildInfo = "If the player is seated in one of your guild, the additional information is displayed.",
    ChatGuildName = "Chat: Show the guildname in the chat. \n\nExample:\n [16:12:13] [Gebiet] [Tamrizon] [Shissu@Shissu]: Hallo",
         
    -- Section5: Kontextmenü
    ContextMenuChatInvite = "Chat: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuChatEMail = "Chat: " .. GetString(SI_SOCIAL_MENU_SEND_MAIL),
    ContextMenuEMail = "E-Mail: Reply, Forward",
    ContextMenuEMailInvite = "E-Mail: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuGuild = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY) .. ": " .. GetString(SI_NOTIFICATIONTYPE2),
     
    -- Section6: Spielerstatus
    PlayerStatusChat = "Enabled to change the chat commands to the player status (see /sgt)",
    PlayerStatusAFK = "Changes the player status automatically after x minutes to AFK, if nothing is done.",
    PlayerStatusAFKMin = "Automatic AFK after xx minutes",        
  },
  [2] = {
    -- Section1: Mitglieder
    MemberStatus = "Show the player status in the Chatbox (Online, AFK, BRB, DND).\n\Example:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "Online",
    MemberAdd = "Displays in the chatbox the info on when a player has joined the guild.\n\nExample:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "invited",
    MemberRemove = "Displays in the chatbox the info on when a player has leaved the guild.\n\nExample:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "leaved",
    MemberInSight = "Shows you if a player is in your field of vision in your guild.",
    
    -- Section2: Benachrichtigungen
    NotificationMoTD = "Enables / Disables the notification: Message of the Day",
     
    -- Section3: Chat
    ChatCharacter = "Show additional the charactername in chat.\n\nExample:\n [16:12:13] [Gebiet] [Shissu@Shissu]: Hallo",
    ChatLevel = "Show additional the level of a guildmember in chat",
    ChatLead = "Chat: highlight guild leader and officer",
    ChatLead2 = "Chat: Guild Leaders & officers from Rank",
    ChatAlliance = "Displays the fraction of the guild member in a guild chat, with a colored character names and @ sign.",
    ChatAutoChat = "The chat will automatically enter the group chat, and prepares a corresponding message from the notebook, if it finds the corresponding keyword.",
    ChatAutoSwitch = "The chat will automatically enter the guild chat if what is written.",
    ChatAutoWelcome = "If you invite a player into the guild , the relevant text of your choice in the chatbox is prepared.",
    ChatAutoWelcome2 = "If someone invites a player to the guild, the relevant text of your choice in the chatbox is prepared.",
  },
  [3] = {
    -- Section1: Standarfarben
    Standard1 = "Standard color 1 in Notebook & Guild Window",
    Standard2 = "Standard color 2 in Notebook & Guild Window",
    Standard3 = "Standard color 3 in Notebook & Guild Window",
    Standard4 = "Standard color 4 in Notebook & Guild Window",
     
    -- Section2: Chat
    Time = "The color of time in chat ([xx:xx:xx])",
    Level = "The color of the level information in chat ([V14])",
    Character = "The color of charactername in chat",
  },
  [4] = {
    MemberInSightLock = "Change the position of the window 'Guild member in the field of view' .",
    MemberInSightMore = "Show Additional information about the guild member in the field of view: Allianz, Level, character names, etc ...",
    MemberData = "Remove all information of a player when he is not represented more in any of your guild.",  
    RosterNote = "The personal notes to an account are made available across guild.",  
    TimeZone = "TimeZone Setting (UTC+X) for all Time Functions",
    GuildData = "Delete all Guild Data, when leaving a guild.",
  },
}

ShissuGT.i18n.Feedback = {
  [1] = "I get your e-mail only if you play on the EU-server!",
  [2] = "I hope that's Shissu Guild Tools (SGT) will help you further! Feedback is always important. Therefore, your feedback is always welcome. If you want to send me some feedback, then write a small ingame note as an email, with or without a donation. Your donation helps my group based ESO-time, as well as the organization of my own guild to reduce. Finally, I can focus on other features and new add-ons for ESO.",
}

ShissuGT.i18n.Sounds = {
  [SOUNDS.NONE] = "OFF",
  [SOUNDS.EMPEROR_DEPOSED_ALDMERI] = "AVA 1",
  [SOUNDS.AVA_GATE_CLOSED] = "AVA 2",
  [SOUNDS.NEW_NOTIFICATION] = "Notification",
  [SOUNDS.CHAMPION_POINTS_COMMITTED] =  "Championspoint 1",
  [SOUNDS.CHAMPION_ZOOM_IN] =  "Championspoint 2",
  [SOUNDS.CHAMPION_ZOOM_OUT] =  "Championspoint 3",
  [SOUNDS.CHAMPION_STAR_MOUSEOVER] =  "Championspoint 4",
  [SOUNDS.CHAMPION_CYCLED_TO_MAGE] =  "Championspoint 5",
  [SOUNDS.BLACKSMITH_EXTRACTED_BOOSTER] =  "Crafting 1",
  [SOUNDS.ENCHANTING_ASPECT_RUNE_REMOVED] =  "Crafting 2",
  [SOUNDS.SMITHING_OPENED] =  "Crafting 3",
  [SOUNDS.GUILD_ROSTER_REMOVED] =  "Guild 1",
  [SOUNDS.GUILD_ROSTER_ADDED] =  "Guild 2",
  [SOUNDS.GUILD_WINDOW_OPEN] =  "Guild 3",
  [SOUNDS.GROUP_DISBAND] = "Group",
  [SOUNDS.DEFAULT_CLICK] = "Click 1",
  [SOUNDS.EDIT_CLICK] = "Click 2",
  [SOUNDS.STABLE_FEED_STAMINA] = "Misc 1",
  [SOUNDS.QUICKSLOT_SET] = "Quickslot",
  [SOUNDS.MARKET_CROWNS_SPENT] = "Shop",
}