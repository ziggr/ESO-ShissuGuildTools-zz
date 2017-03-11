-- Shissu GuildTools LanguageFile
---------------------------------
-- File: EN.lua
-- Version: v1.3.0
-- Last Update: 05.03.2017
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
ZO_CreateStringId("Shissu_yourText", "YOURTEXT")
ZO_CreateStringId("Shissu_mail", GetString(SI_CUSTOMERSERVICESUBMITFEEDBACKSUBCATEGORIES209))
ZO_CreateStringId("Shissu_add", "Add")
ZO_CreateStringId("Shissu_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))
ZO_CreateStringId("Shissu_rank", GetString(SI_STAT_GAMEPAD_RANK_LABEL))
ZO_CreateStringId("Shissu_info", GetString(SI_SCOREBOARD_HELPER_TAB_TOOLTIP))
ZO_CreateStringId("Shissu_addInfo", "Additional Information")

-- Main
ZO_CreateStringId("ShissuModule_module", "Modules / Functions")
ZO_CreateStringId("ShissuModule_moduleInfo", "If you want to accelerate SGT, you can deactivate individual modules and functions according to your needs.")
ZO_CreateStringId("ShissuModule_moduleInfo2", "Switching the individual modules off and on requires a reloading of the interface (/ reloadui).")

ZO_CreateStringId("ShissuModule_rightMouse", "Right mousekey")
ZO_CreateStringId("ShissuModule_leftMouse", "Left mousekey")
ZO_CreateStringId("ShissuModule_middleMouse", "Middle mousekey")

-- Modules
----------

-- Module: ShissuWelcomeInvite
ZO_CreateStringId("ShissuWelcomeInvite", "Welcome message")
ZO_CreateStringId("ShissuWelcomeDesc1", "You can use the following placeholders to create welcome messages")
ZO_CreateStringId("ShissuWelcomeDesc2", "Name of the player")
ZO_CreateStringId("ShissuWelcomeDesc3", "Name of the guild")
ZO_CreateStringId("ShissuWelcomeDesc4", "Separation of different greetings (The coincidence decides)")

-- Modul: ShissuTeleporter
ZO_CreateStringId("ShissuTeleporter", "Teleporter")
ZO_CreateStringId("ShissuTeleporter_tele", "Teleport")
ZO_CreateStringId("ShissuTeleporter_rnd", "Random")
ZO_CreateStringId("ShissuTeleporter_refresh", "To update")
ZO_CreateStringId("ShissuTeleporter_grp", "Group leader")
ZO_CreateStringId("ShissuTeleporter_house", "Home dwelling")
ZO_CreateStringId("ShissuTeleporter_legends1", "Legend")
ZO_CreateStringId("ShissuTeleporter_legends2", "Friends")
ZO_CreateStringId("ShissuTeleporter_legends3", "Group players")

-- Modul: ShissuNotifications
ZO_CreateStringId("ShissuNotifications", GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS))
ZO_CreateStringId("ShissuNotifications_info", "Note")
ZO_CreateStringId("ShissuNotifications_mail", "Delete email / message")
ZO_CreateStringId("ShissuNotifications_inSight", "Guild member in sight field?")
ZO_CreateStringId("ShissuNotifications_friend", "Friend Status [online, afk, brb/dnd, offline]")
ZO_CreateStringId("ShissuNotifications_motD", GetString(SI_GUILD_MOTD_HEADER))
ZO_CreateStringId("ShissuNotifications_background", GetString(SI_GUILD_BACKGROUND_INFO_HEADER))
ZO_CreateStringId("ShissuNotifications_rank", "Ranking lists")
ZO_CreateStringId("ShissuNotifications_guild", GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_GUILD_MEMBERS))
ZO_CreateStringId("ShissuNotifications_background2", "from")
ZO_CreateStringId("ShissuNotifications_background3", "was changed")

-- Modul: ShissuHistory
ZO_CreateStringId("ShissuHistory", "Guild: " .. GetString(SI_WINDOW_TITLE_GUILD_HISTORY))
ZO_CreateStringId("ShissuHistory_filter", "Filter")
ZO_CreateStringId("ShissuHistory_status", "Show / Hide")
ZO_CreateStringId("ShissuHistory_choice", "Selection")
ZO_CreateStringId("ShissuHistory_goldAdded", "Paid")
ZO_CreateStringId("ShissuHistory_goldRemoved", "Paid out")
ZO_CreateStringId("ShissuHistory_itemAdded", "Stored")
ZO_CreateStringId("ShissuHistory_itemRemoved", "Taken from")
ZO_CreateStringId("ShissuHistory_tax", "3,5% Tax")
ZO_CreateStringId("ShissuHistory_sales", "Sales")
ZO_CreateStringId("ShissuHistory_turnover", "Sales")
ZO_CreateStringId("ShissuHistory_extern", "External")
ZO_CreateStringId("ShissuHistory_trader", "since trader")
ZO_CreateStringId("ShissuHistory_pages", "open all pages")
ZO_CreateStringId("ShissuHistory_player", GetString(SI_PLAYER_MENU_PLAYER))
ZO_CreateStringId("ShissuHistory_set1", "Bank: Deposits and withdrawals (Gold + items)")
ZO_CreateStringId("ShissuHistory_set2", "Sales: sales, non-guild members (external), 3.5% stake")
ZO_CreateStringId("ShissuHistory_opt", "OPTIONS")
ZO_CreateStringId("ShissuHistory_last", "last week")

-- Modul: ShissuColor
ZO_CreateStringId("ShissuColor_title", "To dye")
ZO_CreateStringId("ShissuColor_std", "Standard color")
ZO_CreateStringId("ShissuColor_desc1", "The following 5 colors are the standard colors used in various modules & functions")

-- Modul: AutoAFK
ZO_CreateStringId("ShissuAutoAFK", "AutoAFK")
ZO_CreateStringId("ShissuAFK_reminder", "Reminder")
ZO_CreateStringId("ShissuAFK_infoOffline", "You are currently offline!")
ZO_CreateStringId("ShissuAFK_autoOnline", "Automatic switching from offline to online!")
ZO_CreateStringId("ShissuAFK_reminderOffline", "Reminder: Offline?")
ZO_CreateStringId("ShissuAFK_minute", "after X minutes")

-- Modul: ShissuContextMenu
ZO_CreateStringId("ShissuContextMenu", "Context menu")
ZO_CreateStringId("ShissuContextMenu_mail", GetString(SI_SOCIAL_MENU_MAIL))
ZO_CreateStringId("ShissuContextMenu_invite", GetString(SI_NOTIFICATIONTYPE2))
ZO_CreateStringId("ShissuContextMenu_inviteC", "|ceeeeeeGuInvite to Guild: |cAFD3FF%1")
ZO_CreateStringId("ShissuContextMenu_answer", "Reply, Forward")
ZO_CreateStringId("ShissuContextMenu_newMail", "New message")
ZO_CreateStringId("ShissuContextMenu_forward", "Forward")
ZO_CreateStringId("ShissuContextMenu_answer2", "Reply")
ZO_CreateStringId("ShissuContextMenu_del", "Erase")
ZO_CreateStringId("ShissuContextmenu_note", "Personal notes")

-- Modul: ShissuMemberStatus
ZO_CreateStringId("ShissuMemberStatus", "Guild members status")
ZO_CreateStringId("ShissuContextMenu_memberStatus", "Player status (Online/BRB/AFK/Offline)")
ZO_CreateStringId("ShissuContextMenu_added", "to join")
ZO_CreateStringId("ShissuContextMenu_removed", "left / kicked")

-- Modul: ShissuGuildHome
ZO_CreateStringId("ShissuGuildHome", "Guild: " .. GetString(SI_WINDOW_TITLE_GUILD_HOME))
ZO_CreateStringId("ShissuGuildHome_kiosk", "Time to the next trader offer")
ZO_CreateStringId("ShissuGuildHome_textures", "Textures")
ZO_CreateStringId("ShissuGuildHome_rest", "New trader in")
ZO_CreateStringId("ShissuGuildHome_c", "Standard color")
ZO_CreateStringId("ShissuGuildHome_leftTime", "Remaining time")
ZO_CreateStringId("ShissuGuildHome_color", GetString(SI_GUILD_HERALDRY_COLOR))

-- Modul: ShissuNotebook
ZO_CreateStringId("ShissuNotebook", "Notebook")
ZO_CreateStringId("ShissuNotebook_slash", "Chat command:")
ZO_CreateStringId("ShissuNotebook_noSlash", "No matching text found (see Notebook)")
ZO_CreateStringId("ShissuNotebook_ttDelete", "Delete the note")
ZO_CreateStringId("ShissuNotebook_ttNew", "New note")
ZO_CreateStringId("ShissuNotebook_ttUndo", "Undo changes")
ZO_CreateStringId("ShissuNotebook_ttSendTo", _color.blue .. "Left mousekey" ..  _color.white .." - Write in chat\n"..  _color.blue .. "Middle mousekey" ..  _color.white .." - As an E-Mail(post)\n" ..  _color.blue.. "Right mousekey".. _color.white .. " - To save a note")

-- Modul: ShissuNotebookMail
ZO_CreateStringId("ShissuNotebookMail", "Notebook Mailer")
ZO_CreateStringId("ShissuNotebookMail_title", "Mail recipient")
ZO_CreateStringId("ShissuNotebookMail_choice", "Selection")
ZO_CreateStringId("ShissuNotebookMail_mailKick", "Mailkick")
ZO_CreateStringId("ShissuNotebookMail_mailOn", "ON")
ZO_CreateStringId("ShissuNotebookMail_mailOff", "OFF")
ZO_CreateStringId("ShissuNotebookMail_list", "List")
ZO_CreateStringId("ShissuNotebookMail_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))
ZO_CreateStringId("ShissuNotebookMail_offlineSince", "Offline")
ZO_CreateStringId("ShissuNotebookMail_all", "- All")
ZO_CreateStringId("ShissuNotebookMail_days", "Days")
ZO_CreateStringId("ShissuNotebookMail_send", GetString(SI_MAIL_SEND_SEND))
ZO_CreateStringId("ShissuNotebookMail_progressKickTitle", "Remove player")
ZO_CreateStringId("ShissuNotebookMail_progressTitle", "Send e-mail")
ZO_CreateStringId("ShissuNotebookMail_progressAbort", "Canceled")
ZO_CreateStringId("ShissuNotebookMail_mailProgress", "Please wait...")
ZO_CreateStringId("ShissuNotebookMail_doneL", "DONE!")
ZO_CreateStringId("ShissuNotebookMail_all2", "All")
ZO_CreateStringId("ShissuNotebookMail_listAddRemove", _color.blue .. "Left mousekey" ..  _color.white .." - Add list\n"..  _color.blue .. "Right Mousekey".. _color.white .. " - Delete list")
ZO_CreateStringId("ShissuNotebookMail_listPlayerAdd", "Add player")
ZO_CreateStringId("ShissuNotebookMail_listPlayerRemove", "Delete player")
ZO_CreateStringId("ShissuNotebookMail_listPlayerBuildGroup", "Invite players to group")
ZO_CreateStringId("ShissuNotebookMail_online", "Online, BRB, AFK")
ZO_CreateStringId("ShissuNotebookMail_ttEMail", "Send e-mail to selection")
ZO_CreateStringId("ShissuNotebookMail_ttEMailList", "Send e-mail to player in the list")
ZO_CreateStringId("ShissuNotebookMail_ttEMailKick", "Send an e-mail when the player is kicked")
ZO_CreateStringId("ShissuNotebookMail_ttKick", "Select from the guild (possibly with e-mail)")
ZO_CreateStringId("ShissuNotebookMail_ttKickList", "Players in the list from the guild kicken (if necessary with e-mail)")
ZO_CreateStringId("ShissuNotebookMail_protocolIgnoreTT", "The player ignores you, or you ignore the player!")
ZO_CreateStringId("ShissuNotebookMail_ttContin", "If the shipping for some reason " .. _color.blue .. "do not proceed".. _color.white .. ", then click on this button. The current recipient is called i.d.F. ignored.")
ZO_CreateStringId("ShissuNotebookMail_protocolTT", "Shows the players who have a full mailbox or ignore you.")
ZO_CreateStringId("ShissuNotebookMail_newList", "New list")
ZO_CreateStringId("ShissuNotebookMail_listName", "Listname?")
ZO_CreateStringId("ShissuNotebookMail_invite", "Invite players")
ZO_CreateStringId("ShissuNotebookMail_confirmKick", "Do you want to remove the players in the list, or your selection from the guild? Players who remove them will receive an email from you.")
ZO_CreateStringId("ShissuNotebookMail_splashSubject", "Subject")
ZO_CreateStringId("ShissuNotebookMail_splashProgress", "Progress")
ZO_CreateStringId("ShissuNotebookMail_protocolIgnore", "Ignored")
ZO_CreateStringId("ShissuNotebookMail_protocolFull", "Postbox full")
ZO_CreateStringId("ShissuNotebookMail_protocol", "Email protocol")
ZO_CreateStringId("ShissuNotebookMail_mailAbort", _color.blue .. "Close the window" .. _color.white .. "\nClosing completes sending / kicking.")
ZO_CreateStringId("ShissuNotebookMail_newMail", GetString(SI_SOCIAL_MENU_SEND_MAIL))
ZO_CreateStringId("ShissuNotebookMail_ERR_FAIL_BLANK_MAIL", "Message incomplete")

-- Modul: ShissuRoster
ZO_CreateStringId("ShissuRoster", "Guild: Members")
ZO_CreateStringId("ShissuRoster_char", GetString(SI_BINDING_NAME_TOGGLE_CHARACTER))
ZO_CreateStringId("ShissuRoster_goldDeposit", "Gold deposit")
ZO_CreateStringId("ShissuRoster_goldDeposit2", "Gold Deposits")
ZO_CreateStringId("ShissuRoster_goldDeposit3", "Gold deposit")
ZO_CreateStringId("ShissuRoster_member", "Member since")
ZO_CreateStringId("ShissuRoster_thisWeek", "Current Week")
ZO_CreateStringId("ShissuRoster_lastWeek", "last week")
ZO_CreateStringId("ShissuRoster_today", "today")
ZO_CreateStringId("ShissuRoster_yesterday", "yesterday")
ZO_CreateStringId("ShissuRoster_sinceKiosk", "since trader")
ZO_CreateStringId("ShissuRoster_last", "last")
ZO_CreateStringId("ShissuRoster_total", "total")
ZO_CreateStringId("ShissuRoster_sum", "Total")
ZO_CreateStringId("ShissuRoster_colAdd", "Show additional columns")
ZO_CreateStringId("ShissuRoster_colAdd2", "After a change you have to reloaded the interface.")
ZO_CreateStringId("ShissuRoster_colChar", "Column: Character")
ZO_CreateStringId("ShissuRoster_colGold", "Column: Gold deposits")
ZO_CreateStringId("ShissuRoster_colNote", "Column: Personal Notes")
ZO_CreateStringId("ShissuRoster_noData", "No Data")

-- Modul: Scanner
ZO_CreateStringId("ShissuScanner", "Guild: History Scan")
ZO_CreateStringId("ShissuScanner_scan1", "The guild records of")
ZO_CreateStringId("ShissuScanner_scan2", "are currently being read. Please wait...")

-- Modul: Chat
ZO_CreateStringId("ShissuChat", "Chat")
ZO_CreateStringId("ShissuChat_auto", "Automatic change")
ZO_CreateStringId("ShissuChat_date", "Show date")
ZO_CreateStringId("ShissuChat_time", "Show time")
ZO_CreateStringId("ShissuChat_sound", "Acoustic Sound (Whispers)")
ZO_CreateStringId("ShissuChat_guilds", "Gildenzugehörigkeit")
ZO_CreateStringId("ShissuChat_rang", GetString(SI_GAMEPAD_GUILD_ROSTER_RANK_HEADER))
ZO_CreateStringId("ShissuChat_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))
ZO_CreateStringId("ShissuChat_lvl", "Level")
ZO_CreateStringId("ShissuChat_char", "Character names")
ZO_CreateStringId("ShissuChat_whisper", GetString(SI_CHAT_PLAYER_CONTEXT_WHISPER))
ZO_CreateStringId("ShissuChat_party", GetString(SI_CHAT_CHANNEL_NAME_PARTY))
ZO_CreateStringId("ShissuChat_guildchan", GetString(SI_CHAT_OPTIONS_GUILD_CHANNELS))
ZO_CreateStringId("ShissuChat_charAcc1", "Account")
ZO_CreateStringId("ShissuChat_charAcc2", "Character")
ZO_CreateStringId("ShissuChat_charAcc3", "Account + Character")
ZO_CreateStringId("ShissuChat_guildInfo", "Guild Information")
ZO_CreateStringId("ShissuChat_guildWhich", "On which guilds should the information be based?")
ZO_CreateStringId("ShissuChat_guildNames1", "Names")
ZO_CreateStringId("ShissuChat_guildNames2", "How should your guilds be in chat?")

-- Modul: Marks
ZO_CreateStringId("ShissuMarks", "Markings")
ZO_CreateStringId("ShissuMarks_title", "Monster (NPC) & Player Markers")
ZO_CreateStringId("ShissuMarks_misc", "Misc")
ZO_CreateStringId("ShissuMarks_kick", "Auto Kick")
ZO_CreateStringId("ShissuMarks_heal", "Heal")
ZO_CreateStringId("ShissuMarks_observe", "Observe")
ZO_CreateStringId("ShissuMarks_all", "All What You See")
ZO_CreateStringId("ShissuMarks_confirmDel", "Delete list?")
ZO_CreateStringId("ShissuMarks_confirmDel2", "Are you sure you want to delete the list content?")
ZO_CreateStringId("ShissuMarks_add", "Monster (NPC) / Player")
ZO_CreateStringId("ShissuMarks_add2", "What is the name of the monster / player?")
ZO_CreateStringId("ShissuMarks_add3", "Monster / player in group")
ZO_CreateStringId("ShissuMarks_add4", "added")
ZO_CreateStringId("ShissuMarks_add5", "Monster / Player already exists in group")
ZO_CreateStringId("ShissuMarks_leftMouse", "Add")
ZO_CreateStringId("ShissuMarks_rightMouse", "Complete list completely")
ZO_CreateStringId("ShissuMarks_middleMouse", "Guilds check")
ZO_CreateStringId("ShissuMarks_observeInfo", "Players in the list: Watch are highlighted in the chat")
ZO_CreateStringId("ShissuMarks_observeInfo2", "- When logging in")
ZO_CreateStringId("ShissuMarks_observeInfo3", "- When entering the guild")
ZO_CreateStringId("ShissuMarks_observeInfo4", "- When leaving the guild")
ZO_CreateStringId("ShissuMarks_autoKick", "Automatic kicks")
ZO_CreateStringId("ShissuMarks_autoKickInfo", "Players in the list: AutoKick are directly kicked:")
ZO_CreateStringId("ShissuMarks_autoKickInfo2", "- When logging in")
ZO_CreateStringId("ShissuMarks_autoKickInfo3", "- When entering the guild")
ZO_CreateStringId("ShissuMarks_found", "is in the guilds.")
ZO_CreateStringId("ShissuMarks_found2", "The player was kicked (if rights exist).")
ZO_CreateStringId("ShissuMarks_rightItem", "Remove player / monster")
ZO_CreateStringId("ShissuMarks_rightItem2", "Right-click on name")
