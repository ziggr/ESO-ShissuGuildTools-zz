-- File: SettingsDefault.lua
-- Zuletzt geändert: 29. November 2015

ShissuGT.SettingsDefault = {
  TimeInChat = true,
  Roster=true,
  RosterNote=true,
  RosterNoteAll=true,
  WhisperChat = true,
  WhisperSound = SOUNDS.CHAMPION_POINTS_COMMITTED,
  GuildNameChat = true,
  KioskTimer = true,
  History=true,
  ClearGuildData=true,
  ClearMemberData=true,
  GuildColor = true,
  MailDelNotification = false,
  PlayerStatusChat = true,
  AutoAFK = false,
  AutoAFKTimer = 5,
  UTC = 2,

  ContextMenu = {
    SendMail = true,
    Invite = true,
    Mail = true,
    MailInvite = true,
    Guild = true,
    InviteMessage = {
      Active1 = true,
      ActiveE1 = true,
      Active2 = true,
      ActiveE3 = true,
      Active3 = true,
      ActiveE4 = true,
      Active4 = true,
      ActiveE4 = true,
      Active5 = true,
      ActiveE5 = true,
      Guild1 = "Willkommen %1",
      Guild2 = "Willkommen %1",
      Guild3 = "Willkommen %1",
      Guild4 = "Willkommen %1",
      Guild5 = "Willkommen %1",
    }
  },
  
  Chat = {
    AutoChat = {
      Group = true,
      Tell = true,
      Guild1 = false,
      Guild2 = false,
      Guild3 = false,
      Guild4 = false,
      Guild5 = false  
    },
    AutoSwitch = {
      Group = true,
      Tell = true,
      Guild1 = true,
      Guild2 = true,
      Guild3 = true,
      Guild4 = true,
      Guild5 = true,
    },
  },

  Teleport = {
    Enabled = true,
    offsetX = 200,
    offsetY = 200,
    point = CENTER,
    relativePoint = CENTER,
  },

  Notebook = {
    Enabled = true,
    EMail = true,
    offsetX = 100,
    offsetY = 150,
    point = CENTER,
    relativePoint = CENTER,
    Splash = { 
      offsetX = 100,
      offsetY = 150,
      point = CENTER,
      relativePoint = CENTER,
    },
    Protocol = {
      offsetX = 100,
      offsetY = 150,
      point = CENTER,
      relativePoint = CENTER,    
    },
   },

   MemberInSight = {
      Enabled = true,
      More = true, 
      offsetX = 150,
      offsetY = 150,
      point = CENTER,
      relativePoint = CENTER,
   },
   
   mailList = {
    ["Liste"] = { "@Test1", "@LöschMich", },
   },

  Color = {
    [1] = {
      [4] = 0.8568835855,
      [1] = 1,
      [2] = 0.5058823824,
      [3] = 0.4549019635,
    },
    [2] = {
      [4] = 1,
      [1] = 0.2705882490,
      [2] = 0.5725490451,
      [3] = 1,
    },
    [3] = {
      [4] = 1,
      [1] = 0.2784313858,
      [2] = 1,
      [3] = 0.7568627596,
    },
    [4] = {
      [4] = 1,
      [1] = 0.9921568632,
      [2] = 1,
      [3] = 0.7490196228,
    }, 
    Time =  {
      [4] = 0.8568835855,
      [1] = 0.9019607902,
      [2] = 0.9254902005,
      [3] = 1,
    },
    Character =  {
      [4] = 1,
      [1] = 1,
      [2] = 1,
      [3] = 1,
    },
  },

  Guild1 = {
    MemberStatus = true,
    AddStatus = true,
    RemoveStatus = true,
    GuildMotD = true,
    MemberInSight = true,
    Character = true,
    Alliance = true,
    Level = true,
    ChatLead = true,
    LeadRank = 1,
  },
  
  Guild2 = {
    MemberStatus = false,
    AddStatus = true,
    RemoveStatus = true,
    GuildMotD = true,
    MemberInSight = true,
    Character = true,
    Alliance = true,
    Level = true,
    ChatLead = true,
    LeadRank = 1,
  },
  
  Guild3 = {
    MemberStatus = false,
    AddStatus = true,
    RemoveStatus = true,
    GuildMotD = true,
    MemberInSight = true,
    Character = true,
    Alliance = true,
    Level = true,
    ChatLead = true,
    LeadRank = 1,
  },
  
  Guild4 = {
    MemberStatus = false,
    AddStatus = true,
    RemoveStatus = true,
    GuildMotD = true,
    MemberInSight = true,
    Character = true,
    Alliance = true,
    Level = true,
    ChatLead = true,
    LeadRank = 1,
  },
  
  Guild5 = {
    MemberStatus = false,
    AddStatus = true,
    RemoveStatus = true,
    GuildMotD = true,
    MemberInSight = true,
    Character = true,
    Alliance = true,
    Level = true,
    ChatLead = true,
    LeadRank = 1,
  },
}
