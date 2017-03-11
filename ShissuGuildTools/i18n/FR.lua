-- File: FR.lua
-- Zuletzt geändert: 18. Januar 2016

ShissuGT.i18n = {
  ["InviteC"] = ShissuGT.Color[5] .. "Inviter dans " .. ShissuGT.Color[6] .. "%1",
  ["MoTD_CHANGED"] = ShissuGT.Color[7] .. "(changement) ",
  ["Invite"] = ShissuGT.Color[1] .. ShissuGT.Lib.ReplaceCharacter("relié"),
  ["Leave"] = ShissuGT.Color[3] .. "laisser",  
  ["MemberInSight"] = "Les joueurs de la guilde?",
  ["Alliance"] = GetString(SI_LEADERBOARDS_HEADER_ALLIANCE),
  ["ChatButton"] = ShissuGT.Color[6] .. "bouton gauche" ..  ShissuGT.Color[5] .." - Carnet\n"..  ShissuGT.Color[6] .. "mousebutton droit".. ShissuGT.Color[5].. " - Teleport gratuit",
  ["ToolTipHTML"] = "HTML Fontcolor \n\n par exemple pour la couleur noire #000000 \n remplacer xxxxxx avec 000000",
  ["Disabled"] = ShissuGT.Lib.ReplaceCharacter("handicapé"),
  ["RollChatde"] = " hat bei einem Zufallswurf (1-MAX) die Zahl: RND erwürfelt.",
  ["RollChatfr"] = " roule le nombre RND dans un jet aléatoire de 1-MAX",
  ["RollChaten"] = " rolls the number RND in a random throw of 1-MAX", 
  ["RestTime"] = "Temps",
}

ShissuGT.i18n.Notebook = {
  ["Title"] = "Carnet",   
  ["MessagesLength"] = "E-Mail: ",  
  ["ChatLength"] = "Chat: ",
  ["All"] = "- tous",   
  ["FriendList"] = ShissuGT.Color[2] .. " - |r" .. "liste d'amis",   
  ["PageTitle"] = "Page ",  
  ["ChatCommand"] = "Commande chat /sgt n:"..ShissuGT.Color[6],
  ["SlashCommand"] = "Commande chat",     
  ["MailTitle"] = "Lists",
  ["MailChoiceL"] ="Choix: ",
  ["MailOfflineSince"] = "Offline",
  ["MailDays"] = ShissuGT.Lib.ReplaceCharacter(" journées"),
  ["MailERR_FAIL_BLANK_MAIL"] = "Message vide" ,      
  ["MailDoneL"] ="DONE!",
  ["MailKick"] = "Messageskick", -- NEU,
  ["MailOn"] = "ON",
  ["MailOff"] = "OFF",  
  ["MailGuild"] = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY),
  ["MailRank"] = GetString(SI_STAT_GAMEPAD_RANK_LABEL),
  ["MailSend"] = GetString(SI_MAIL_SEND_SEND),  
  ["MailProgress"] ="Se il vous plaît attendre...",
  ["ProgressKickTitle"] ="Retirez un joueur",
  ["ProgressTitle"] = "Envoyer E-Mail",
  ["ProgressAbort"] = ShissuGT.Lib.ReplaceCharacter("Annulé"),
  ["List"] = "Liste",
  ["Choice"] = ShissuGT.Lib.ReplaceCharacter("Sélection"),
  ["ToolTipToogle"] = "Carnet",
  ["ToolTipNew"] = "Nouvelle note",
  ["ToolTipDelete"] = "Supprimer note",
  ["ToolTipUndo"] = "Undo Changes", 
  ["ToolTipChat"] =  ShissuGT.Color[6] .. "Bouton gauche" ..  ShissuGT.Color[5] .." - Envoyer une note à la discussion\n"..  ShissuGT.Color[6] .. "Bouton droit".. ShissuGT.Color[5].. " - Sauvegarder Remarque",
  ["ToolTipRed"] = "Rouge font",
  ["ToolTipYellow"] = "Jaune font",
  ["ToolTipGreen"] = "Vert font",
  ["ToolTipBlue"] = "Bleu font",
  ["ToolTipWhite"] = "Blanc font",
  ["ToolTipHTML"] = "HTML fontcolor \n\n par exemple pour #000000 \n/h000000bonjour/c",
  ["ToolTipEMail"] = ShissuGT.Lib.ReplaceCharacter("Envoyer un email à la sélection"),
  ["ToolTipEMailList"] = "Envoyer un e-mail aux joueurs dans la liste",
  ["ToolTipKick"] = ShissuGT.Lib.ReplaceCharacter("Choisissez parmi le coup de la guilde (éventuellement avec e-mail)"),
  ["ToolTipKickList"] = ShissuGT.Lib.ReplaceCharacter("Les joueurs de la liste dès le coup de la guilde (éventuellement avec e-mail)"),
  ["ToolTipEMaikKick"] = "Envoyer un e-mail quand de coups de pied joueurs",
  ["ToolTipName"] = "Cliquer avec le " .. ShissuGT.Color[6] .. "mousebutton droit" .. ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(" sur un nom pour éviter ce joueur"),
  ["ToolTipOnline"] = "Online, BRB, AFK",
  ["ToolTipOffline"] = "Offline",  
  ["ToolTipAbort"] = ShissuGT.Color[6] .. ShissuGT.Lib.ReplaceCharacter("Fenêtre ") .. ShissuGT.Lib.ReplaceCharacter("fermer") .. ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter("\nEn fermant l'envoi / coups de pied est annulé."),
  ["ToolTipContin"] = "Si l'envoi pour une raison quelconque " .. ShissuGT.Color[6] .. ShissuGT.Lib.ReplaceCharacter("pas de progrès").. ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(", se il vous plaît cliquer sur ce bouton. Le récepteur de courant est ignoré."),
  ["Disabled"] = ShissuGT.Lib.ReplaceCharacter("Le portable est dans vos paramètres "),
  ["ConfirmNoteDelete"] = "Voulez-vous supprimer la note?",
  ["ConfirmEmailKick"]  = "Si le joueur dans la liste , ou de votre sélection est supprimé de la guilde? Les joueurs que vous supprimez, recevront un email de votre part.",

  ["Protocol"] = "Log",
  ["ProtocolTT"] = "Affiche les joueurs qui ont une boite aux lettres pleine, ou vous ignorez.",
  ["ProtocolIgnore"] = "Ignore",
  ["ProtocolFull"] = "Mailbox complet",
  ["ProtocolIgnoreTT"] = "Le joueur vous ignore, ou vous ignorez le lecteur!",
  ["Subject"] = "Sujet",
  ["Progress"] = "Progres",
  
  ["ListAddRemove"] = ShissuGT.Color[6] .. "Gauche" ..  ShissuGT.Color[5] .." - nouvelle liste\n"..  ShissuGT.Color[6] .. "Droit".. ShissuGT.Color[5].. " - Retirer Liste",
  ["ListPlayerAdd"] = "Ajouter le joueur", 
  ["ListPlayerRemove"] = "Retirez un joueur",
  ["ListPlayerBuildGroup"] = "Inviter tous les joueurs dans le groupe",
}

ShissuGT.i18n.History = {
  ["Gold"] = "Toogle " .. ShissuGT.Color[6] .. "Gold ".. ShissuGT.Color[5] .. "Archives",
  ["Item"] = "Toogle " .. ShissuGT.Color[6] .. "Items " .. ShissuGT.Color[5] .. "Archives",
  ["Choice"] = "Nombre de "..ShissuGT.Color[6] ..  ShissuGT.Lib.ReplaceCharacter("sélectionné") .. ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(" entrées dans la liste"),
  ["Filter"] = "Rechercher " .. ShissuGT.Color[6] .. "xyz " .. ShissuGT.Color[5] .. "dans les enregistrements: nom, articles, prix.",
  ["FilterBox"] = GetString(SI_HELP_FILTER_BY),
  ["Choice2"] = "Choix",
  ["OnOff"] = ShissuGT.Lib.ReplaceCharacter("Afficher / Masquer "),

  ["Trader"] = "Depuis Guilde Merchant",
  ["AllPage"] = "tous les Sites",
  ["AllPageInfo"] = "Ouvrez toutes les pages dans les dossiers de la guilde. \n\n" .. ShissuGT.Color[2] .. "ATTENTION" .. ShissuGT.Color[5] .. ": Ouverture des ventes peut prendre un certain temps!",
  ["GoldAdded"] = "Paid:",
  ["GoldRemoved"] = "Décaissé:",
  ["ItemAdded"] = "Paid:",
  ["ItemRemoved"] = "Décaissé:",
  ["Sells"] = "Ventes", 
  ["Intern"] = "Intern:",
  ["Sales"] = "Chiffre d'affaires:",
  ["Tax"] = "Impôts:",
  ["Member"] = "Membre depuis",

  ["Total"] = "Le total",
  ["Last"] = "Dernier",
  ["thisWeek"] = "Cette semaine",
  ["lastWeek"] = "semaine ancienne",
  ["before"] = "avant",
  ["scanner1"] = "L'histoire de la Guilde",
  ["scanner2"] = "sont en cours de lecture. S'il vous plait patienter",  
}

ShissuGT.i18n.Roster = {
  ["Online"] = ShissuGT.Color[6] .. "Online ".. ShissuGT.Color[5] .. "joueur [Online, AFK, BRB] toogle",
  ["Offline"] = ShissuGT.Color[6] .. "Offline " .. ShissuGT.Color[5] .. "joueur toogle",
  ["Choice"] = "Nombre et pourcentage de parts "..ShissuGT.Color[6] .. ShissuGT.Lib.ReplaceCharacter("sélectionné") .. ShissuGT.Color[5] .." Joueur dans la liste",
  ["Aldmeri"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE1),"^"), -- "Aldmeri Dominion"
  ["Ebonheart"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE2),"^"), --"Ebenherz-Pakt"
  ["Daggerfall"] = ShissuGT.Lib.CutStringAtLetter(GetString(SI_ALLIANCE3),"^"), --"Dolchsturz Bündnis"    
  ["Character"] = "CHARACTER",
}

ShissuGT.i18n.Setting = {
  ["ContextMenu"] = ShissuGT.Color[6].. "Context menu",
  ["InviteMessage"] = "Welcome message in the chat?",
  ["InviteMessageDesc"] = ShissuGT.Color[6] .. "%1" .. ShissuGT.Color[5] .. " = Playername \n\n ".. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(" = Porte de sortie pour diverses aléatoire messages \ n\ne.g. bienvenue ").. ShissuGT.Color[6] .."%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "hehehe " .. ShissuGT.Color[6] ..  "%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Hi " .. ShissuGT.Color[6] .. "%1",
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
  ["MailDeleteNotif"] = ShissuGT.Lib.ReplaceCharacter("E-Mail Effacer"),
  ["CAutoSwitch"] = "Automatic Chatchannel",
  ["CAutoChat"] =  "Automatic message",
  ["CAutoChatDesc"] =  ShissuGT.Lib.ReplaceCharacter("The notebook must be enabled for this feature. Put in your notebook to any note corresponding auto post to keywords."),
  ["Whisper"] = GetString(SI_SOCIAL_LIST_PANEL_WHISPER),
  ["Group"] = GetString(SI_SOCIAL_MENU_GROUP),  
  ["PlayerStatus"] = ShissuGT.Color[6].. GetString(SI_FRIENDS_LIST_PANEL_TOOLTIP_STATUS),
  ["PlayerStatusChat"] = "Les changements de statut du joueur via le chat commande",
  ["AutoAFK"] = "Automatiquement AFK",    
  ["AutoAFKMin"] = ShissuGT.Lib.ReplaceCharacter("Automatiquement AFK après xx minutes"),
  ["InviteE"] = "(autre) Joueur",
  ["InviteC"] = "Contextmenue",
  ["GuildColor"] = "Colored Infos & Remarques",
  ["ChatAlliance"] = "Mettre l'accent sur la couleur des alliances",
  ["ChatLevel"] = ShissuGT.Lib.ReplaceCharacter("Les données de niveau en discussion de guilde"),
}

ShissuGT.i18n.Context = {
  ["Del"] = "Effacer",
  ["Forward"] = "Avant",
  ["Answer"] = ShissuGT.Lib.ReplaceCharacter("Réponse"),
  ["PersNote"] = "Modifier note personnelle",
  ["ContextResetChar"] = "Reset Characternames",  
    
}

ShissuGT.i18n.Bindings = {
  ["Notebook"] = "Toogle Carnet",  
  ["Helm"] = "Toogle Casque",  
  ["Reload"] = "Reload UI",    
  ["Teleport"] = ShissuGT.Lib.ReplaceCharacter("Gratuit Teleport aléatoire"),   
}

ShissuGT.i18n.Teleport = {
  ["Random"] = ShissuGT.Lib.ReplaceCharacter("Aléatoire Teleport"),  
  ["New"] = "Actualiser",  
  ["Title"] = ShissuGT.Lib.ReplaceCharacter("Téléporteur (gratuit)"),    
  ["Disabled"] = ShissuGT.Lib.ReplaceCharacter("Le téléporteur est dans vos paramètres "),
}

ShissuGT.i18n.SlashCommand = {  
  ["RemoveChar1"] = "Joueurs: <<1>> a été réinitialisé à la base de données de caractère.",
  ["RemoveChar2"] = "Il était avec le nom de compte pas de lecteur: <<1>> trouvé.",
  ["RemoveChar3"] = "La base de données de caractère a été complètement réinitialiser.",
  ["RemoveChar1N"] = "Si le joueur: <<1>> sont vraiment de retour dans la base de données de caractères (RESET)?",
  ["RemoveChar4"] = "Reset Character Database?",
  
  ["Help"] = " commandes de chat:\n\n" ..
   "<<1>>/sgt<<2>>" .. "                       - Une liste de toutes les commandes de chat\n"  ..
   "<<1>>/sgt note<<2>>" .. "             - Ouvrez le Bloc-notes\n" ..
   "<<1>>/sgt n:X<<2>>" .. "                - Remarque X de l'ordinateur portable publier\n" ..
   "<<1>>/sgt tele<<2>>" .. "               - Ouvrez téléporteurs de guilde\n" ..
   "<<1>>/sgt char reset<<2>>" .. "      - Remet la base de données de caractère.\n" ..
   "<<1>>/sgt char X<<2>>" .. "               - Définit les caractères du joueur X dos.\n" ..
   "<<1>>/roll X, /dice X<<2>>" .. "    - Couper un nombre aléatoire entre 1 - X\n" ..
   "<<1>>/ginv X Y<<2>>" .. "               - Inviter caractère Y en guilde X (1-5)\n" ..
   "<<1>>/teleport X" ..   "                - Teleports to Player X" .. 
   "<<1>>/on, /online<<2>>" .. "         - Modifie le statut de joueur à ONLINE\n" ..
   "<<1>>/dnd, /brb<<2>>" .. "            - Modifie le statut de joueur à BRB\n" ..
   "<<1>>/AFK<<2>>" .. "                      - Modifie le statut de joueur à AFK\n" ..
   "<<1>>/off, /offline<<2>>" .. "        - Modifie le statut de joueur à OFFLINE\n" .. 
   "<<1>>/rl<<2>>" .. "                           - Reload UI\n",  
}

ShissuGT.i18n.Color = {
  ["Standard1"] = "Couleur standard 1",
  ["Standard2"] = "Couleur standard 2",
  ["Standard3"] = "Couleur standard 3",
  ["Standard4"] = "Couleur standard 4",
  ["White"] = "Couleur blanche",
  ["ANY"] = "Choisissez une couleur",
}

ShissuGT.i18n.Settings = {
  [1] = {
    Head = "Fonctions Guilde générales",
     
    Section1 = GetString(SI_KEYBINDINGS_CATEGORY_GENERAL),
    Notebook = "Carnet",
    NotebookEMail = "Carnet: E-mail",
    Teleporter = "Teleporter",

    Section2 = "Alertes / Avis",
    EMailDel = "Remarque : Supprimer E -Mail",

    Section3 = "Fenêtre de guilde",
    KioskTimer = "Guilde Trader Compte à rebours",
    History = "Guild Records: Filtre",
    Roster = "Guild Roster",
    Color = "Colored note, Motd, ...",
     
    Section4 = "Chat",
    ChatInGuild = "Joueur dans Guild?",
    ChatTime = "Temps dans le chat",
    ChatAutoSwitchGroup = "Groupe: Automatique Chatchannel",
    ChatAutoChatGroup = "Groupe: messages automatiques",
    ChatAutoSwitchWhisper = "@chuchotement: Automatique Chatchannel",
    ChatWhisperGuildInfo = "@chuchotement: messages automatique",
    ChatGuildName = "Chat: Guildname",
    ChatWhisperSound = "Chuchotemen: Sound",
        
    Section5 = "Shortcut menu",
    ContextMenuChatInvite = "Chat: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuChatEMail = "Chat: " .. GetString(SI_SOCIAL_MENU_SEND_MAIL),
    ContextMenuEMail = "E-Mail: Répondre, Transférer",
    ContextMenuEMailInvite = "E-Mail: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuGuild = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY) .. ": " .. GetString(SI_NOTIFICATIONTYPE2),

    Section6 = "Player Status",
    PlayerStatusChat = "Player Status: Chat commands",
    PlayerStatusAFK = "Automatique AFK",
    PlayerStatusAFKMin = "Automatique AFK après XX minutes",    
  },
  [2] = {
    Head = "Guild Fonctions spécifiques",
     
    -- Mitglieder
    Section1 = GetString(SI_GAMEPAD_GUILD_RANK_PERMISSIONS_MEMBERS),
    MemberStatus = "Player Status (Online, AFK, BRB, DND)",
    MemberAdd = "Player est la guilde",
    MemberRemove = "Le joueur a quitté la guilde",
    MemberInSight = "Membre de la Guilde dans le champ de vision",
    
    -- Benachrichtigungen
    Section2 = GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS),
    NotificationMoTD = GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS) .. ": " .. GetString(SI_GUILD_MOTD_HEADER),
    Section3 = "Chat",
    ChatCharacter = "Chat: Charaktername@Accountname",
    ChatLevel = "Chat: Level",
    ChatAlliance = "Chat: " .. GetString(SI_GAMEPAD_WORLD_MAP_TOOLTIP_ALLIANCE_OWNER),
    ChatLead = "Chat: Dirigeants et officiers Highlight guilde",
    ChatLead2 = "",
    ChatAutoSwitch = "Chat: Automatic Chatchannel",
    ChatAutoChat = "Chat: Auto messages",
    ChatAutoWelcome = "Chat: Message de bienvenue",
    ChatAutoWelcome2 = "Chat: Message de bienvenue, d'autres joueurs",
    ChatAutoDescription = ShissuGT.Color[5] .. "Message de bienvenue\n" .. ShissuGT.Color[6] .. "%1" .. ShissuGT.Color[5] .. " = Playername\n" .. ShissuGT.Color[2] .. "%2" .. ShissuGT.Color[5] .. " = Guildname\n" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .." = Retenue de séparation pour différentes nouvelles aléatoire",
    ChatAutoExample = "\ne.g. Welcome " .. ShissuGT.Color[6] .."%1" .. ShissuGT.Color[5] .. " in " .. ShissuGT.Color[2] .. "%2" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Hi " .. ShissuGT.Color[6] ..  "%1" .. ShissuGT.Color[1] .. "||||||" .. ShissuGT.Color[5] .. "Meow Meow " .. ShissuGT.Color[6] .. "%1",
  },
  [3] = {
    Head = "Couleurs",
     
    Section1 = "Couleur standard",
    Standard1 = ShissuGT.i18n.Color.Standard1,
    Standard2 = ShissuGT.i18n.Color.Standard2,
    Standard3 = ShissuGT.i18n.Color.Standard3,
    Standard4 = ShissuGT.i18n.Color.Standard4,
     
    Section2 = "Chat",
    Time = "Time",
    Character = "Charaktername",
  },
  [4] = {
    Head = "Autres options", 
    MemberInSightLock = "Membre de la Guilde dans le champ de vue: position de la fenêtre",
    MemberInSightMore = "Membre de la Guilde dans le champ de vue: avancée",
    MemberData = "Supprimer les données membres, lors de la sortie",
    RosterNote = "Alignement: Notes personnelles , Guilde travers",
    TimeZone = "fuseau horaire (UTC+X)",
    GuildData = "Supprimer toutes les données Guilde, au moment de quitter",
  },
}

ShissuGT.i18n.SettingsToolTip = {
  [1] = {
    -- Section1: Allgemein
    Notebook = "Activer / Désactiver cahier",
    NotebookEMail = "Cahier: Email-Functions (Activer / Désactiver )",
    Teleporter = "Activer / Désactiver teleporter",
    
    -- Section2: Benachrichtigungen
    EMailDel = "Activer / désactiver la boîte de dialogue de confirmation : E-mail à supprimer ?",

    -- Section3: Gildenfenster
    KioskTimer = "Cache dans la fenêtre de guilde, le temps d'acquérir la prochaine Trader Guilde.",
    History = "Active / désactive les enregistrements Guild modifiés.",
    Roster = "Active / désactive la Guilde Roster modifiée",
    RosterNote = "Active / désactive les notes personnelles dans le tableau de guilde",
    Color = "Active / désactive notes colorées, Motd , ... dans la fenêtre Guilde",
     
    -- Section4: Chat
    ChatInGuild = "Masque supplémentaire nom La Guilde d'un joueur dans le chat , si elle est située dans l'un de votre Guilde.",
    ChatTime = "Indique le temps dans le chat.\n\nexemple:\n [16:12:13] [Zone] [Shissu]: Hallo",
    ChatAutoSwitchGroup = "Le chat entrera automatiquement le chat en groupe, si ce qui est écrit.",
    ChatAutoSwitchWhisper = "Le chat entrera automatiquement The Whisper discuter, si ce qui est écrit.",
    ChatAutoChatGroup = "Le chat entrera automatiquement le chat en groupe, et prépare un message correspondant de l'ordinateur portable , si elle trouve le mot-clé correspondant .",
    ChatWhisperGuildInfo = "Si le joueur est assis dans l'un de votre Guilde , les informations complémentaires sont affichées.",
    ChatGuildName = "Chat: Afficher la Nom de la guilde dans le chat. \n\nexemple:\n [16:12:13] [Gebiet] [Tamrizon] [Shissu@Shissu]: Hallo",
         
    -- Section5: Kontextmenü
    ContextMenuChatInvite = "Chat: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuChatEMail = "Chat: " .. GetString(SI_SOCIAL_MENU_SEND_MAIL),
    ContextMenuEMail = "E-Mail: Répondre, Transférer",
    ContextMenuEMailInvite = "E-Mail: " .. GetString(SI_NOTIFICATIONTYPE2),
    ContextMenuGuild = GetString(SI_QUEST_JOURNAL_GUILD_CATEGORY) .. ": " .. GetString(SI_NOTIFICATIONTYPE2),
     
    -- Section6: Spielerstatus
    PlayerStatusChat = "Enabled pour changer les commandes de chat au statut de joueur (lac /sgt)",
    PlayerStatusAFK = "Change le statut de joueur automatiquement après X minutes à AFK, si on ne fait rien.",
    PlayerStatusAFKMin = "AFK automatique après xx minutes",        
  },
  [2] = {
    -- Section1: Mitglieder
    MemberStatus = "Afficher le statut de joueur dans la chatbox (Online, AFK, BRB, DND).\n\exemple:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "Online",
    MemberAdd = "Affiche dans la chatbox l'info sur Quand un joueur a rejoint la guilde.\n\nexemple:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "invited",
    MemberRemove = "Affiche dans la chatbox l'info sur Quand un joueur a à feuilles de la guilde.\n\nexemple:\n [16:12:13] ".. ShissuGT.Color[6] .. "Legacy of Heaven: " .. ShissuGT.Color[5] .. "Shissu@Shissu - ".. ShissuGT.Color[1] .. "leaved",
    MemberInSight = "Vous indique si un joueur est dans votre champ de vision de votre guilde.",
    
    -- Section2: Benachrichtigungen
    NotificationMoTD = "Active / désactive la notification: Message de la Journée",
     
    -- Section3: Chat
    ChatCharacter = "Afficher le nom du personnage supplémentaire dans le chat.\n\nexemple:\n [16:12:13] [Gebiet] [Shissu@Shissu]: Hallo",
    ChatLevel = "Montrer le niveau supplémentaire d'un membre de la guilde dans le chat",
    ChatLead = "Chat: Mettez en surbrillance chef de guilde et agent",
    ChatLead2 = "Chat: Guild Leaders & agents de Rang",
    ChatAlliance = "Affiche la fraction du membre de la Guilde dans un chat de guilde, avec les noms des personnages colorés et signe @.",
    ChatAutoChat = "Le chat entrera automatiquement le chat en groupe, et prépare un message correspondant de l'ordinateur portable, si elle trouve le mot-clé correspondant.",
    ChatAutoSwitch = "Le chat entrera automatiquement le chat de guilde si ce qui est écrit.",
    ChatAutoWelcome = "Si vous invitez un joueur dans la guilde, le texte pertinent de votre choix dans le chat est prêt.",
    ChatAutoWelcome2 = "Si quelqu'un invite à un joueur de la guilde  le texte pertinent de votre choix dans le chat est prêt.",
  },
  [3] = {
    -- Section1: Standarfarben
    Standard1 = "Couleur standard 1 Notebook & fenêtre de guilde",
    Standard2 = "Couleur standard 2 Notebook & fenêtre de guilde",
    Standard3 = "Couleur standard 3 Notebook & fenêtre de guilde",
    Standard4 = "Couleur standard 4 Notebook & fenêtre de guilde",
     
    -- Section2: Chat
    Time = "La couleur du temps dans le chat ([xx:xx:xx])",
    Level = "La couleur de l' information à l'échelle dans le chat ([V14])",
    Character = "The color of charactername in chat",    
  },
  [4] = {
    MemberInSightLock = "Changez la position de la fenêtre 'de membre de la Guilde dans le champ de vision'.",
    MemberInSightMore = "Afficher des informations supplémentaires sur le membre de la guilde dans le champ de vision: Allianz , Level , noms de personnages , etc. ...",
    MemberData = "Retirer toutes les informations d'un joueur quand il est pas dans une des plus Représenté votre guilde.",  
    RosterNote = "Les notes personnelles à un compte sont mis à disposition à travers Guilde.",  
    TimeZone = "Réglage du fuseau horaire (UTX+X) pour toutes les fonctions de temps",
    GuildData = "Supprimer toutes les données Guilde, au moment de quitter une guilde.",
  },
}

ShissuGT.i18n.Feedback = {
  [1] = "Je reçois votre e -mail uniquement si vous jouez sur le serveur de EUROPE!",
  [2] = "Je espère que ce Shissu's Guild Tools (SGT) veut vous aider plus loin! La rétroaction est toujours important . Par conséquent, vos commentaires sont toujours les bienvenus. Si vous voulez me faire parvenir des commentaires, puis d'écrire une petite note ingame comme un email, avec ou sans un don. Votre don aide mon groupe basé ESO- temps, ainsi que l'organisation de ma propre guilde pour réduire. Enfin je peux me concentrer sur d'autres fonctionnalités et de nouveaux add-ons pour l'ESO.",
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
  [SOUNDS.GUILD_ROSTER_REMOVED] =  "Guilde 1",
  [SOUNDS.GUILD_ROSTER_ADDED] =  "Guilde 2",
  [SOUNDS.GUILD_WINDOW_OPEN] =  "Guilde 3",
  [SOUNDS.GROUP_DISBAND] = "Groupe",
  [SOUNDS.DEFAULT_CLICK] = "Cliquez 1",
  [SOUNDS.EDIT_CLICK] = "Cliquez 2",
  [SOUNDS.STABLE_FEED_STAMINA] = "Misc 1",
  [SOUNDS.QUICKSLOT_SET] = "Quickslot",
  [SOUNDS.MARKET_CROWNS_SPENT] = "Shop",
}