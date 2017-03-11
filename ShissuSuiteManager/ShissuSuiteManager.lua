local _addon = {}

_addon.Name = "ShissuSuiteManager"
_addon.formattedName	= "|cAFD3FFShissu's|r|ceeeeee SuiteManager"
_addon.Version = "1.4.0"

_addon._lib = {}
_addon._addons = {}
_addon._commands = {}
_addon._settings = {}
_addon._init = {}
_addon._i18n = {}
_addon._bindings = {}

_addon.SettingMenu = {}

-- diverse Chatausgaben
function _addon._lib.sendToChat(formattedName, info1, info2)
  local chatMessage = formattedName

  if info1[1] ~= nil then chatMessage = chatMessage .. info1[2] .. " " .. info1[1] end
  if info2 ~= nil then chatMessage = chatMessage .. " " .. info2 end

  d(_addon._lib.ReplaceCharacter(chatMessage))
end

function _addon._lib.i18nC(_i18n)
  local _i18n = _i18n

  for k,v in pairs(_i18n) do
    _i18n[k] = _addon._lib.replaceCharacter(_i18n[k])
  end

  return _i18n
end


-- String an String teilen, und die einzelnen Teile wieder in ein Array packen
function _addon._lib.splitToArray (search, text)
  if (text=='') then return false end

  local pos,arr = 0,{}

  for st,sp in function() return string.find(search,text,pos,true) end do
    table.insert(arr, string.sub(search,pos,st-1))
    pos = sp + 1
  end

  table.insert(arr,string.sub(search,pos))

  return arr
end

-- Einstellungen; Panelinformationen
function _addon._lib.setPanel(standardName, formattedName, ver)
  local panel = {
    type    = "panel",
    displayName  = formattedName,
    name    = standardName,
    version = ver,
  }

  return panel
end

-- Sonderzeichen ersetzen
function _addon._lib.ReplaceCharacter(text)
  local specialCharacter = {
    ["à"] = "\195\160",  ["ò"] = "\195\178",  ["è"] = "\195\168",  ["ì"] = "\195\172",  ["ù"] = "\195\185",
    ["á"] = "\195\161",  ["ó"] = "\195\179",  ["é"] = "\195\169",  ["í"] = "\195\173",  ["ú"] = "\195\186",
    ["â"] = "\195\162",  ["ô"] = "\195\180",  ["ê"] = "\195\170",  ["î"] = "\195\174",  ["û"] = "\195\187",
    ["ã"] = "\195\163",  ["õ"] = "\195\181",  ["ë"] = "\195\171",  ["ï"] = "\195\175",  ["ü"] = "\195\188",
    ["ä"] = "\195\164",  ["ö"] = "\195\182",
    ["Ä"] = "\195\132",  ["Ö"] = "\195\150",                                            ["Ü"] = "\195\156",

    ["ß"] = "\195\159",
  }

  for char, newChar in pairs(specialCharacter) do
    text = string.gsub(text, char, newChar)
  end

  return text;
end

-- Unerwünschte Zeichen abschneiden
function _addon._lib.cutStringAtLetter(text, letter)
  if text ~= nil then
    local pos = string.find(text, letter, nil, true)

    if pos then text = string.sub (text, 1, pos-1) end
  end

  return text;
end

function _addon._lib.getString(var)
  return zo_strformat(GetString(var))
end


-- Feedback Send
function _addon._lib.feedback(gold, subject)
  Shissu_Feedback:SetHidden(true)
  SCENE_MANAGER:Show('mailSend')
  ZO_MailSendToField:SetText("@Shissu")
  ZO_MailSendBodyField:SetText(_addon._lib.getString(SGT_Feedback3))
  ZO_MailSendSubjectField:SetText(subject)
  QueueMoneyAttachment(gold)
  ZO_MailSendBodyField:TakeFocus()
end

-- Chatbefehle registrieren
function _addon._lib.registerCommand(text, func)
  if text == nil then return end
  if func == nil then return end

  SLASH_COMMANDS["/" .. text] = func
end

-- klassisches CASE mehr oder weniger... :-)
function _addon._lib.switch(n, ...)
  for _, v in ipairs {...} do
    if v[1] == n or v[1] == nil then
      return v[2]()
    end
  end
end

function _addon._lib.case(n,f)
  return {n, f}
end

function _addon._lib.default(f)
  return {nil, f}
end

-- AddOn/Modul Loader
function _addon.InitializedAddon(addOnName)
  if addOnName == nil then return false end

  if _addon._init[addOnName] ~= nil then
    _addon._init[addOnName]()

    zo_callLater(function()
      -- Einstellungen
      if _addon._settings[addOnName] ~= nil then
        Shissu_SuiteManager_SettingMenu.RegisterAddonPanel(addOnName, _addon._settings[addOnName].panel, _addon._settings[addOnName].controls)
      end

      -- Chat Commands
      if _addon._commands[addOnName] ~= nil then
        for i = 1, #_addon._commands[addOnName] do
          local command  = _addon._commands[addOnName][i][1]
          local func  = _addon._commands[addOnName][i][2]

          _addon._lib.registerCommand(command, func)
        end
      end
    end, 1500);
  end
end

-- Helm ein-&/ausblenden
function _addon.helmToogle()
  local cacheSetting = GetSetting( SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_HIDE_HELM )
  SetSetting(SETTING_TYPE_IN_WORLD, IN_WORLD_UI_SETTING_HIDE_HELM, 1 - cacheSetting)
end

-- On-/Offline
function _addon.offlineToogle()
  local offline = PLAYER_STATUS_OFFLINE
  local online = PLAYER_STATUS_ONLINE

  local current = GetPlayerStatus()

  if ( current == offline) then
    SelectPlayerStatus(online)
  elseif ( current == online) then
    SelectPlayerStatus(offline)
  end
end

function _addon.reload()
  SLASH_COMMANDS["/reloadui"]()
end

-- Initialize Event
function _addon.EVENT_ADD_ON_LOADED (eventCode, addOnName)
  if addOnName ~= _addon.Name then return end

  -- Event entfernen um Ressourcen zu sparen
  EVENT_MANAGER:UnregisterForEvent(_addon.Name, EVENT_ADD_ON_LOADED)

  zo_callLater(function()
    _addon._lib.sendToChat(_addon.formattedName, {_addon.Version, ""})

    -- Register Base Commands
    _addon._lib.registerCommand("rl", function() SLASH_COMMANDS["/reloadui"]() end)
    _addon._lib.registerCommand("on",  function() SelectPlayerStatus(PLAYER_STATUS_ONLINE) end)
    _addon._lib.registerCommand("off", function() SelectPlayerStatus(PLAYER_STATUS_OFFLINE) end)
    _addon._lib.registerCommand("brb", function() SelectPlayerStatus(PLAYER_STATUS_DO_NOT_DISTURB) end)
    _addon._lib.registerCommand("dnd", function() SelectPlayerStatus(PLAYER_STATUS_DO_NOT_DISTURB) end)
    _addon._lib.registerCommand("afk", function() SelectPlayerStatus(PLAYER_STATUS_AWAY) end)

    -- Misc Commands
    _addon._lib.registerCommand("helm", _addon.helmToogle)

    -- Bindings
    _addon._bindings.helmToogle = _addon.helmToogle
    _addon._bindings.offlineToogle = _addon.offlineToogle
    _addon._bindings.reload = _addon.reload

    -- Feedback Language
    Shissu_Feedback_Note:SetText(_addon._lib.getString(SGT_Feedback1) .. _addon._lib.getString(SGT_Feedback2))

    -- Standard Module
    Shissu_SuiteManager.InitializedAddon("ShissuLanguageChanger")
    Shissu_SuiteManager.InitializedAddon("ShissuStandardCommands")

  end, 1500);
end

Shissu_SuiteManager = _addon
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_ADD_ON_LOADED, _addon.EVENT_ADD_ON_LOADED)
