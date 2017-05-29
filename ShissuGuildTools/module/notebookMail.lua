-- Shissu GuildTools Module File
--------------------------------
-- File: notebookMail.lua
-- Version: v2.2.7
-- Last Update: 18.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local green = _globals["color"]["green"]
local yellow = _globals["color"]["yellow"]
local red = _globals["color"]["red"]
local orange = _globals["color"]["orange"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString
local setDefaultColor = _SGT.setDefaultColor
local checkBoxLabel = _SGT.checkBoxLabel
local createScrollContainer = _SGT.createScrollContainer
local showDialog = _SGT.showDialog
local createCloseButton = _SGT.createCloseButton
local getWindowPosition = _SGT.getWindowPosition
local saveWindowPosition = _SGT.saveWindowPosition

local _addon = {}
_addon.Name	= "ShissuNotebookMail"
_addon.Version = "2.2.7"
_addon.core = {}
_addon.fN = _SGT["title"]("Notebook Mailer")
_addon.friends = "--|r " .. white .. getString(Shissu_friend)

_addon.settings = {
  ["position_1"] = {},
  ["position_2"] = {},
}

local _mail = {}
_mail.cache = {}
_mail.dropDownGuilds = nil
_mail.dropDownRanks = nil
_mail.offlineSince = 0
_mail.currentGuild = 1
_mail.currentRank = 0
_mail.guildList = {}
_mail.currentList = {}
_mail.scrollItem = 1
_mail.indexPool = nil
_mail.list = nil
_mail.protocolFullIndexPool = nil
_mail.protocolIgnoreIndexPool = nil
_mail.isSend = false
_mail.isOpen = false
_mail.kick = nil
_mail.all = nil
_mail.clickChoice = nil
_mail.clickIndex = nil
_mail.recipientName = ""
_mail.gold = 0
_mail.goldDate = nil
_mail.inviteDate = nil
_mail.memberSince = 0
_mail.gold = 0
_mail.goldSince = 0

-- local _checkBox = {}

local _direction = {
  ["offlineSince"] = true,
  ["memberSince"] = true,
  ["gold"] = true,
}


_mail.Item = {
  Full = 1,
  Ignore = 1,
}

_mail.customList = nil

_mail.ProtocolList = {
  Full = nil,
  Ignore = nil,
}

_mail.emailError = {
   full = {},
   ignore = {},
}

function _mail.removeIndexButton(control)
  control:SetHidden(true)
  control = nil
end

function _mail.getGuildNote(memberId)
  local memberVar = {GetGuildMemberInfo(_mail.currentGuild, memberId)}

  if memberVar then
    return memberVar[2]
  end

  return false
end

function _mail.createIndexButton(indexPool)
  local control = ZO_ObjectPool_CreateControl("SGT_Notebook_MailIndex", indexPool, _mail.list.scrollChild)
  local anchorBtn = _mail.scrollItem == 1 and _mail.list.scrollChild or indexPool:AcquireObject(_mail.scrollItem-1)

  control:SetAnchor(TOPLEFT, anchorBtn, _mail.scrollItem == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(140)
  control:SetHandler("OnMouseUp", function(self, button)
    if button == 2 then
      if _mail.guildList[self.index][2] == false then
        _mail.guildList[self.index] = {self.name, true}
        control:SetText(red .. self.name)
      elseif _mail.guildList[self.index][2] == true then
        _mail.guildList[self.index] = {self.name, false}
        control:SetText(white .. self.name)
      else
        _mail.guildList[self.index] = {self.name, true}
        control:SetText(red .. self.name)
      end
    else
      SGT_Notebook_MessagesRecipient_Choice2:SetText(self.name)
      _mail.clickChoice = self.name
      _mail.clickIndex = self.index
    end
  end)

  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)
  control:SetHandler("OnMouseEnter", function(self)
    if _mail.getGuildNote(self.id) and _mail.getGuildNote(self.id) ~= "" then
      ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, white .. _mail.getGuildNote(self.id))
    end
  end)

  _mail.scrollItem = _mail.scrollItem  + 1

  return control
end

function _mail.manuellMailList()
  SGT_Notebook_MessagesRecipient_Add:SetHidden(false)
  SGT_Notebook_MessagesRecipient_Delete:SetHidden(false)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHidden(false)
end

function _mail.autoMailList()
  SGT_Notebook_MessagesRecipient_Add:SetHidden(true)
  SGT_Notebook_MessagesRecipient_Delete:SetHidden(true)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHidden(true)
end

function _addon.core.getFriendsList()
  local searchTerm = SGT_Notebook_MessagesRecipient_FilterText:GetText()  or ""
  local numFriends = GetNumFriends()
  local availableNames = {}

  for i = 1, numFriends do
    local displayName, _ = GetFriendInfo(i)

    if (searchTerm == "" or string.find(displayName, searchTerm)) then
      table.insert(availableNames, { displayName, false} )
    end
  end

  return availableNames
end

function _addon.core.getHistoryInfo(guildName, name)
  local history = shissuGT["History"]
  local historyData = {}
  local member = true
  local gold = true

  if history then
    if history[guildName] then
      if history[guildName][name] then
        local timeJoined = history[guildName][name].timeJoined
        local day = 0

        if (timeJoined == nil) then
          -- Was passiert, wenn Spieler schon so lange in der Gilde ist, das keine Aufzeichnungen existieren?
          -- Aufzeichnungen existieren ~ etwa 10 Monate zurück, max
          day = 40 * 7 * 86400
        else
          timeJoined = GetTimeStamp() - timeJoined
          day = math.floor(timeJoined / 86400)
        end

        if ((day >= _mail.memberSince) == false and _direction["memberSince"]) or ((day <= _mail.memberSince) == false and _direction["memberSince"] == false) then
          member = false
        else
          member = true
        end

        local lastGold = history[guildName][name][GUILD_EVENT_BANKGOLD_ADDED].last
        local timeLast = history[guildName][name][GUILD_EVENT_BANKGOLD_ADDED].timeLast

       -- if (name == "@Aerydir") then
       --   d(name .. " - " .. lastGold .. " - " .. timeLast .. " - " .. _mail.gold)
        --end

        if (lastGold and timeLast) then
          if (((lastGold >= _mail.gold) == false) and _direction["gold"]) or (((lastGold <= _mail.gold) == false) and (_direction["gold"] == false)) then
            gold = false
          end

          if _mail.goldSince > 0 then
            timeLast = GetTimeStamp() - timeLast
            timeLast = math.floor(timeLast / 86400)

            if (timeLast >= _mail.goldSince) then
              gold = false
            end
          end
        end
      end
    end
  end

  table.insert(historyData, member)
  table.insert(historyData, gold)

  return historyData
end

function _addon.core.getGuildList()
  local numMembers = GetNumGuildMembers(_mail.currentGuild)
  local availableNames = {}
  local sortedMembers = {}
  local sortedData = {}
  local searchTerm = SGT_Notebook_MessagesRecipient_FilterText:GetText()  or ""

  for i = 1, numMembers do
    local memberVar = {GetGuildMemberInfo(_mail.currentGuild, i)}
    table.insert(sortedMembers, i, memberVar[1] .. "**shissu" ..i)
  end

  table.sort(sortedMembers)

  for i = 1, numMembers do
    local length = string.len(sortedMembers[i])
    local number = string.sub(sortedMembers[i], string.find(sortedMembers[i], "**shissu"), length)

    number = string.gsub(number, "**shissu", "")
    number = string.gsub(number, " ", "")
    number = tonumber(number)

    local memberVar = {GetGuildMemberInfo(_mail.currentGuild, number)}

    sortedData[i] = {}
    sortedData[i].name = memberVar[1]
    sortedData[i].id = number
  end

  for i = 1, #sortedData do
    local memberVar = {GetGuildMemberInfo(_mail.currentGuild, sortedData[i].id)}
    local charVar = {GetGuildMemberCharacterInfo(_mail.currentGuild, sortedData[i].id)}
    local memberOfflineSince = math.floor(memberVar[5] / 86400)

    local guildName = GetGuildName(_mail.currentGuild)

    if _mail.currentRank == 0 and memberOfflineSince >= _mail.offlineSince
      or memberVar[3] == _mail.currentRank and memberOfflineSince >= _mail.offlineSince then
      if (searchTerm == "" or string.find(sortedData[i].name, searchTerm) or string.find(memberVar[2], searchTerm)) then

        local historyData = _addon.core.getHistoryInfo(guildName, sortedData[i].name)

        if historyData[1] == true and historyData[2] == true then
          table.insert(availableNames, { sortedData[i].name, false, sortedData[i].id} )
        end
      end
    end
  end

  return availableNames
end

-- Liste füllen
function _mail.fillScrollList()
  local searchTerm = SGT_Notebook_MessagesRecipient_FilterText:GetText()  or ""
  local done = 0

  _mail.guildList = {}

  -- Freunde
  if _mail.currentDropText == yellow .. "--|r " .. white .. getString(Shissu_friend) and done == 0 then
    _mail.autoMailList()
    _mail.guildList = _addon.core.getFriendsList()

    done = 1
  end

  -- Eigene Liste
  for listName, listContent in pairs(_mail.customList) do
    --d(ShissuGT.Color[6] .. "--|r " .. ShissuGT.Color[5] .. listName .. "         -    " .. _mail.currentDropText)
    if blue .. "--|r " .. white .. listName == _mail.currentDropText and done == 0 then
      _mail.manuellMailList()

      _mail.currentList = listName
      numMembers = #_mail.customList[listName]
      local availableNames = {}

      for i = 1, numMembers do
        local displayName, _ = _mail.customList[listName][i]
        table.insert(_mail.guildList, {_mail.customList[listName][i], false})
      end

      done = 1
    end
  end

  -- Gilde
  if done == 0 then
    _mail.autoMailList()
    _mail.guildList = _addon.core.getGuildList()
  end

  local numMembers = #_mail.guildList

  for i = 1, numMembers do
    local control = _mail.indexPool:AcquireObject(i)

    control.name = _mail.guildList[i][1]
    control.id = i
    control.index = i
    control:SetText(white .. _mail.guildList[i][1])

    if _mail.guildList[i][3] then
      control.memberId = _mail.guildList[i][3]
    end

    control:SetHidden(false)
  end

  local activePages = _mail.indexPool:GetActiveObjectCount()
  if activePages > numMembers then
    for i = numMembers+1, activePages do _mail.indexPool:ReleaseObject(i) end
  end
end

function _mail.ProtocolFillScrollList()
  local numFull = #_mail.emailError.full
  local numIgnore = #_mail.emailError.ignore

  for i = 1, numFull do
    local control = _mail.protocolFullIndexPool:AcquireObject(i)
    control:SetText(white .. _mail.emailError.full[i])
    control:SetHidden(false)
  end

  local activePages = _mail.protocolFullIndexPool:GetActiveObjectCount()
  if activePages > numFull then
    for i = numFull+1, activePages do _mail.protocolFullIndexPool:ReleaseObject(i) end
  end

  for i = 1, numIgnore do
    local control = _mail.protocolIgnoreIndexPool:AcquireObject(i)
    control:SetText(white .. _mail.emailError.ignore[i])
    control:SetHidden(false)
  end

  local activePages = _mail.protocolIgnoreIndexPool:GetActiveObjectCount()
  if activePages > numIgnore then
    for i = numIgnore+1, activePages do _mail.protocolIgnoreIndexPool:ReleaseObject(i) end
  end
end


function _mail.GetOfflineDays(offlineString)
  local stringStart = blue
  local endString = white .. " " .. getString(ShissuNotebookMail_days)
  local days = "0"

  if string.len(offlineString) > 3 then
    days = string.gsub(string.gsub(offlineString, stringStart, ""), endString, "")
    days = tonumber(days)
  else
    days = tonumber(offlineString)
  end

  return days
end

function _mail.checkBox(control, var)
  ZO_CheckButton_SetToggleFunction(control, function(control, checked)
    _mail.RecipientChoice[var] = checked
    _mail.fillScrollList()
  end)
end

function _mail.mailButtons(all, kick)
  local sleepTime = 1600
  local guildId = _mail.currentGuild
  local recipient = {}
  local i = 1
  local waitCount = 0

  -- aktueller Titel (Betreff) + Text zwischenspeichern, damit aktiv weitergearbeitet werden kann im Notizbuch
  _mail.cache.title = SGT_Notebook_NoteTitleText:GetText()
  _mail.cache.text = SGT_Notebook_NoteText:GetText() -- .. "\n\nSent via |c779cffShissu's|r GuildTools 3"

  if all == 1 then
    for i = 1, #_mail.guildList do
      if _mail.guildList[i][2] == false then
        table.insert(recipient, _mail.guildList[i][1])
      end
    end
  else
    table.insert(recipient, SGT_Notebook_MessagesRecipient_Choice2:GetText())
  end

  if all == 3 and kick == 3 then
    all = _mail.all
    kick = _mail.kick
  else
    _mail.kick = all
    _mail.all = kick
  end

  _mail.isSend = true
  if _mail.isOpen == false then RequestOpenMailbox() end

  SGT_Notebook_MessagesRecipient_Choice:SetText(getString(ShissuNotebookMail_send))

  -- Splash Screen Text
  SGT_Notebook_Splash_Subject:SetText(_mail.cache.title)

  if kick == 1 and not kick == 3  then
  elseif not kick == 3 then
    SGT_Notebook_Splash_Title:SetText(getString(ShissuNotebookMail_progressTitle))
  end

  SGT_Notebook_Splash:SetHidden(false)
  SGT_Notebook:SetHidden(true)

  EVENT_MANAGER:RegisterForUpdate("SGT_EVENT_EMAIL", sleepTime, function()
    if  kick == 0 then
      if _mail.emailIsOpen == false then RequestOpenMailbox() end

      if recipient[i] ~= nil then
        if _mail.emailIsOpen == true and _mail.isSend == true then
          _mail.recipientName = recipient[i]
          SGT_Notebook_Splash_Recipient:SetText(blue.. recipient[i])

          if waitCount == 0 then
            SGT_Notebook_Splash_Waiting:SetText(red .. getString(ShissuNotebookMail_mailProgress))
            waitCount = 1
          else
            SGT_Notebook_Splash_Waiting:SetText(white .. getString(ShissuNotebookMail_mailProgress))
            waitCount = 0
          end

          QueueMoneyAttachment(0)
          SendMail(recipient[i], _mail.cache.title, _mail.cache.text)

          i = i + 1
          _mail.isSend = false
        end
      end
    else
      if kick == 1 then
        SGT_Notebook_Splash_Recipient:SetText(blue.. recipient[i])
      end
      i = i + 1
    end

    -- Splash Screen
    if i == #_mail.guildList+1 or all == 0 then
      SGT_Notebook_MessagesRecipient_Choice:SetText(blue .. getString(ShissuNotebookMail_doneL))
      SGT_Notebook_Splash_Progress:SetText(green .. getString(ShissuNotebookMail_doneL))
      SGT_Notebook_Splash_Waiting:SetText("")

      EVENT_MANAGER:UnregisterForUpdate("SGT_EVENT_EMAIL")
      _mail.ProtocolFillScrollList()
    else
      SGT_Notebook_MessagesRecipient_Choice:SetText(blue .. i .. "/" .. white .. #recipient)
      SGT_Notebook_Splash_Progress:SetText(blue .. i .. "/" .. white .. #recipient)
    end
  end)
end

_mail.currentDropText = ""

-- Ränge
function _mail.rankSelected(_, statusText, choiceNumber)
  for rankId = 1, GetNumGuildRanks(_mail.currentGuild) do

    d(string.find(statusText, GetFinalGuildRankName(_mail.currentGuild, rankId)))

    if (string.find(statusText, GetFinalGuildRankName(_mail.currentGuild, rankId))) then
      SGT_Notebook_MessagesRecipient_Choice2:SetText(orange .. statusText)
      _mail.currentRank = rankId
      break
    else
      _mail.currentRank = 0
    end
  end

  _mail.fillScrollList()
end

function _mail.optionSelected(_, statusText, choiceNumber)
  _mail.currentDropText = statusText

  for guildId = 1, GetNumGuilds() do
    if GetGuildName(guildId) == statusText then
      SGT_Notebook_MessagesRecipient_Choice:SetText(red .. statusText)
      _mail.currentGuild = guildId

      _mail.dropDownRanks:ClearItems()
      _mail.dropDownRanks:AddItem(_mail.dropDownRanks:CreateItemEntry(yellow .. "-- " .. white .. getString(ShissuNotebookMail_all2), _mail.rankSelected))

      for rankId = 1, GetNumGuildRanks(guildId) do
        _mail.dropDownRanks:AddItem(_mail.dropDownRanks:CreateItemEntry(GetFinalGuildRankName(guildId, rankId), _mail.rankSelected))
      end

      break
    end
  end

  _mail.fillScrollList()
end

function _mail.mailAbort()
  EVENT_MANAGER:UnregisterForUpdate("SGT_EVENT_EMAIL")
  SGT_Notebook_MessagesRecipient_Choice:SetText(red .. getString(ShissuNotebookMail_doneL))

  SGT_Notebook_Splash:SetHidden(true)
end

function _mail.mailContinue()
   _mail.mailButtons(3, 3)
end

function _mail.mailProtocol()
  if SGT_MailProtocol:IsHidden() then
    SGT_MailProtocol:SetHidden(false)
    _mail.ProtocolFillScrollList()
  else
    SGT_MailProtocol:SetHidden(true)
  end
end

function _mail.addPlayerToList(self, button)
  if button ~= 1 then return end
    ESO_Dialogs["SGT_EDIT"].title = {text = getString(ShissuNotebookMail_listPlayerAdd),}
    ESO_Dialogs["SGT_EDIT"].mainText = {text = "Name?",}
    ESO_Dialogs["SGT_EDIT"].buttons[1].callback = function(dialog)
      local playerName = dialog:GetNamedChild("EditBox"):GetText()

      if playerName ~= nil or playerName ~= "" or playerName ~= " " then
        local guildSign = string.sub(playerName,1,1)
        local guildId = string.sub(playerName,2,2)

        if guildSign == "%" then
          guildId = GetGuildId(guildId)

          if guildId ~= 0 then
            for memberId=1, GetNumGuildMembers(guildId), 1 do
              local memberInfo = { GetGuildMemberInfo(guildId, memberId) }
              local found = 0

              for nameId = 1, #_mail.customList[_mail.currentList] do
                if _mail.customList[_mail.currentList][nameId] == memberInfo[1] then
                  found = 1
                end
              end

              if found == 0 then
                table.insert(_mail.customList[_mail.currentList], memberInfo[1])
              end

            end
          end
        else
          table.insert(_mail.customList[_mail.currentList], playerName)
        end

        _mail.fillScrollList()
      end
    end

    ZO_Dialogs_ShowDialog("SGT_EDIT")
end

function _mail.deletePlayerfromList(self, button)
  if button ~= 1 then return end

  local numPlayer = #_mail.customList[_mail.currentList]

  for i = 1, numPlayer do
    --d(_mail.customList[_mail.currentList][i] .. "       -  "  .. _mail.clickChoice)

    if _mail.customList[_mail.currentList][i] == _mail.clickChoice then
      --d("del")
      _mail.customList[_mail.currentList][i] = nil
      _mail.fillScrollList()
      return
    end
  end
end

function _mail.buildGroupWithList()
  for i = 1, #_mail.guildList do
    if _mail.guildList[i][2] == false then
      d(blue .. getString(ShissuNotebookMail_invite) .." - " .. white .. _mail.guildList[i][1])
      GroupInviteByName(_mail.guildList[i][1])
    end
  end
end

function _mail.buildMailList()
  _mail.dropDownGuilds:ClearItems()
  _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(yellow .. "--|r " .. white .. getString(Shissu_friend), _mail.optionSelected))

  for listName, listContent in pairs(_mail.customList) do
    if listContent ~= nil then
      _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(blue .. "--|r " .. white .. listName, _mail.optionSelected))
    end
  end

  for guildId = 1, GetNumGuilds() do
    _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(GetGuildName(guildId), _mail.optionSelected))
  end
end

function _mail.protocolCreateIndexButton(indexPool)
  local var = "Full"

  if indexPool == _mail.protocolIgnoreIndexPool then var = "Ignore" end

  local control = ZO_ObjectPool_CreateControl("SGT_Notebook_MailProtocol" .. var .. "Index", indexPool, _mail.ProtocolList[var].scrollChild)
  local anchorBtn = _mail.Item[var] == 1 and _mail.ProtocolList[var].scrollChild or indexPool:AcquireObject(_mail.Item[var]-1)

  control:SetAnchor(TOPLEFT, anchorBtn, _mail.Item[var] == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(140)

  _mail.Item[var] = _mail.Item[var] + 1

  return control
end

function _addon.core.newList(self, button)
  if button == 1 then
    local listName = nil

    ESO_Dialogs["SGT_EDIT"].title = {text = getString(ShissuNotebookMail_newList),}
    ESO_Dialogs["SGT_EDIT"].mainText = {text = getString(ShissuNotebookMail_listName),}
    ESO_Dialogs["SGT_EDIT"].buttons[1].callback = function(dialog)
      listName = dialog:GetNamedChild("EditBox"):GetText()

      if listName ~= nil or listName ~= "" or listName ~= " " then
        _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(blue .. "--|r " .. white .. listName, _mail.optionSelected))
        if _mail.customList[listName] == nil then _mail.customList[listName] = {} end
      end
    end

    ZO_Dialogs_ShowDialog("SGT_EDIT")
  else
    _mail.customList[_mail.currentList] = nil
    _mail.buildMailList()
  end
end

function _addon.core.mail()
  _SGT.createFlatWindow(
    "SGT_Notebook_MessagesRecipient",
    SGT_Notebook_MessagesRecipient,
    {385, 480},
    nil,
    getString(ShissuNotebookMail_title)
  )

  _SGT.createBackdropBackground("SGT_Notebook_MessagesRecipient_Filter", SGT_Notebook_MessagesRecipient_Filter, {140, 30})

  _mail.indexPool = ZO_ObjectPool:New(_mail.createIndexButton, _mail.removeIndexButton)
  _mail.list = createScrollContainer("SGT_Notebook_EMailList", 145, SGT_Notebook_MessagesRecipient, SGT_Notebook_MessagesRecipient_Line6, 10, 10, -10)

  _mail.button1 = _SGT.createFlatButton("SGT_Notebook_NewSendListButton", SGT_Notebook_MessagesRecipient, {180, -20}, {90, 30}, white .. getString(ShissuNotebookMail_choice), BOTTOMLEFT)
  _mail.button2 = _SGT.createFlatButton("SGT_Notebook_NewSendChoiceButton", SGT_Notebook_NewSendListButton, {100, 0}, {90, 30}, white .. getString(ShissuNotebookMail_list), TOPRIGHT)

  SGT_Notebook_MessagesRecipient_FilterText:SetHandler("OnTextChanged", _mail.fillScrollList)

  SGT_Notebook_MessagesRecipient_FilterLabel:SetText(blue .. getString(ShissuNotebookMail_Filter))
  SGT_Notebook_MessagesRecipient_SendLabel:SetText(yellow .. getString(ShissuNotebookMail_Send))

  SGT_Notebook_MessagesRecipient_RanksLabel:SetText(getString(Shissu_rank))

  -- Benutzerdefinierte Listen
  SGT_Notebook_MessagesRecipient_Add:SetHandler("OnMouseEnter", function(self) _addon.core.toolTip(self, ShissuNotebookMail_listPlayerAdd) end)
  SGT_Notebook_MessagesRecipient_Delete:SetHandler("OnMouseEnter", function(self) _addon.core.toolTip(self, ShissuNotebookMail_listPlayerRemove) end)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHandler("OnMouseEnter", function(self) _addon.core.toolTip(self, ShissuNotebookMail_listPlayerBuildGroup) end)
  SGT_Notebook_MessagesRecipient_NewList:SetHandler("OnMouseEnter", function(self) _addon.core.toolTip(self, ShissuNotebookMail_listAddRemove) end)
  SGT_Notebook_MessagesRecipient_NewList:SetHandler("OnMouseUp", _addon.core.newList)
  SGT_Notebook_MessagesRecipient_Add:SetHandler("OnMouseUp", _mail.addPlayerToList)
  SGT_Notebook_MessagesRecipient_Delete:SetHandler("OnMouseUp", _mail.deletePlayerfromList)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHandler("OnMouseUp", _mail.buildGroupWithList)

  SGT_MailProtocol_Ignore:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_protocolIgnoreTT) end)

  SGT_Notebook_NewSendListButton:SetHandler("OnMouseUp", function() _mail.mailButtons(0,0) end)
  SGT_Notebook_NewSendChoiceButton:SetHandler("OnMouseUp", function() _mail.mailButtons(1,0) end)

  -- DropDown Menü "Rank" befüllen
  SGT_Notebook_MessagesRecipient_Ranks:GetNamedChild("Dropdown"):SetWidth(140)
  SGT_Notebook_MessagesRecipient_Ranks:SetWidth(140)

  _mail.dropDownRanks  = SGT_Notebook_MessagesRecipient_Ranks.dropdown
  _mail.dropDownRanks:SetSortsItems(false)
  _mail.dropDownRanks:AddItem(_mail.dropDownRanks:CreateItemEntry(yellow .. "-- " .. white .. getString(ShissuNotebookMail_all2), _mail.rankSelected))

  for rankId = 1, GetNumGuildRanks(_mail.currentGuild) do
    _mail.dropDownRanks:AddItem(_mail.dropDownRanks:CreateItemEntry(white .. GetFinalGuildRankName(_mail.currentGuild, rankId), _mail.rankSelected))
  end

  _mail.dropDownRanks:SetSelectedItem(yellow .. "-- " .. white .. getString(ShissuNotebookMail_all2))

  -- DropDown Menü "Gilde" befüllen
  SGT_Notebook_MessagesRecipient_Guilds:GetNamedChild("Dropdown"):SetWidth(120)
  SGT_Notebook_MessagesRecipient_Guilds:SetWidth(120)

  _mail.dropDownGuilds = SGT_Notebook_MessagesRecipient_Guilds.dropdown
  _mail.dropDownGuilds:SetSortsItems(false)
  _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(yellow .. _addon.friends, _mail.optionSelected))

  for guildId = 1, GetNumGuilds() do
    _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(white .. GetGuildName(guildId), _mail.optionSelected))
  end

  if (GetNumGuilds() > 0 ) then
    _mail.dropDownGuilds:SetSelectedItem(GetGuildName(1))
    SGT_Notebook_MessagesRecipient_Choice:SetText(red .. GetGuildName(1))
  end

    -- EmpfängerListe
  -- ScrollContainer + UI
  _mail.buildMailList()

  _mail.selected = WINDOW_MANAGER:CreateControl(nil, _mail.list.scrollChild, CT_TEXTURE)
  _mail.selected:SetTexture("EsoUI\\Art\\Buttons\\generic_highlight.dds")
  setDefaultColor(_mail.selected)
  _mail.selected:SetHidden(true)
  _mail.fillScrollList()

  _SGT.createFlatWindow(
    "SGT_Notebook_Splash",
    SGT_Notebook_Splash,
    {430, 120},
    _mail.mailAbort,
    getString(ShissuNotebookMail_progressTitle)
  )

  SGT_Notebook_Splash_Version:SetText(_addon.fN .. " " .. _addon.Version)
  SGT_Notebook_Splash_SubjectLabel:SetText(getString(ShissuNotebookMail_splashSubject) .. ":")
  SGT_Notebook_Splash_ProgressLabel:SetText(getString(ShissuNotebookMail_splashProgress) .. ":")

  SGT_Notebook_Splash_Continue:SetHandler("OnClicked", _mail.mailContinue)
  SGT_Notebook_Splash_Protocol:SetHandler("OnClicked", _mail.mailProtocol)
  SGT_Notebook_Splash_Continue:SetHandler("OnMouseEnter", function(self) _addon.core.toolTip(self, ShissuNotebookMail_ttContin) end)
  SGT_Notebook_Splash_Protocol:SetHandler("OnMouseEnter", function(self) _addon.core.toolTip(self, ShissuNotebookMail_protocolTT) end)

  _SGT.createFlatWindow(
    "SGT_MailProtocol",
    SGT_MailProtocol,
    {360, 400},
    function() SGT_MailProtocol:SetHidden(true) end,
    getString(ShissuNotebookMail_protocol)
  )

  SGT_MailProtocol_Full:SetText(getString(ShissuNotebookMail_protocolFull))
  SGT_MailProtocol_Ignore:SetText(getString(ShissuNotebookMail_protocolIgnore))
  SGT_MailProtocol_Version:SetText(_addon.fN .. " " .. _addon.Version)

  _mail.divider2 = _SGT.createLine("Divider", {400, 1}, "SGT_MailProtocol", SGT_MailProtocol,  TOPLEFT, 170, 50, {BOTTOMLEFT, 170, -20}, {0.49019607901573, 0.74117648601532, 1}, true)
  _mail.protocolFullIndexPool = ZO_ObjectPool:New(_mail.protocolCreateIndexButton, _mail.removeIndexButton)
  _mail.ProtocolList.Full = createScrollContainer("SGT_Notebook_FullList", 145, SGT_MailProtocol, SGT_MailProtocol_Line, 10, 40, -10)
  _mail.protocolIgnoreIndexPool = ZO_ObjectPool:New(_mail.protocolCreateIndexButton, _mail.removeIndexButton)
  _mail.ProtocolList.Ignore = createScrollContainer("SGT_Notebook_IgnoreList", 145, SGT_MailProtocol, SGT_MailProtocol_Line, 175, 40, -10)
end

function _addon.core.toolTip(control, text)
  ZO_Tooltips_ShowTextTooltip(control, TOPRIGHT, white .. getString(text))
end

function _addon.core.getGuildNote(memberId)
  local memberVar = { GetGuildMemberInfo(_ui.currentGuild, memberId) }

  if memberVar then
    return memberVar[2]
  end

  return false
end

-- Initialisierung
function _addon.core.initialized()
  shissuGT.mailList = shissuGT.mailList or {}
  _mail.customList = shissuGT.mailList

  if (_addon.settings["position_1"] == nil) then
    _addon.settings["position_1"] = {}
  end

  if (_addon.settings["position_2"] == nil) then
    _addon.settings["position_2"] = {}
  end

  saveWindowPosition(SGT_MailProtocol, _addon.settings["position_1"])
  getWindowPosition(SGT_MailProtocol, _addon.settings["position_1"])

  saveWindowPosition(SGT_Notebook_Splash, _addon.settings["position_2"])
  getWindowPosition(SGT_Notebook_Splash, _addon.settings["position_2"])

  zo_callLater(_addon.core.mail, 5000)
end

-- EVENT FUNCTIONS
function _mail.EVENT_MAIL_SEND_SUCCESS()
  _mail.recipientName = ""
  _mail.isSend = true
end

function _mail.EVENT_MAIL_SEND_FAILED(event, reason)
  local CN = _addon.fN .. ": " .. getString(ShissuNotebookMail_newMail) .. " - " .. orange
  local CT = orange.. " - "

  _mail.isSend = true

  if reason == MAIL_SEND_RESULT_FAIL_INVALID_NAME or reason == MAIL_SEND_RESULT_RECIPIENT_NOT_FOUND then d(CN .. GetString(SI_SENDMAILRESULT2).. CT .. _mail.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_BLANK_MAIL then d(CN.. getString(ShissuNotebookMail_ERR_FAIL_BLANK_MAIL))
  elseif reason == MAIL_SEND_RESULT_NOT_ENOUGH_MONEY then d(CN.. GetString(SI_SENDMAILRESULT5))
  elseif reason == MAIL_SEND_RESULT_FAIL_MAILBOX_FULL then
    d(CN.. GetString(SI_SENDMAILRESULT3).. CT .. _mail.recipientName)
    table.insert(_mail.emailError.full, _mail.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_IGNORED then
    d(CN.. GetString(SI_SENDMAILRESULT4).. CT .. _mail.recipientName)
    table.insert(_mail.emailError.ignore, _mail.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_DB_ERROR or reason == MAIL_SEND_RESULT_FAIL_IN_PROGRESS then d(CN.. GetString(SI_SENDMAILRESULT1))
  end
end

function _mail.EVENT_MAIL_CLOSE_MAILBOX()
  _mail.emailIsOpen = false
end

function _mail.EVENT_MAIL_OPEN_MAILBOX()
  _mail.emailIsOpen = true
end

-- EVENTS
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_MAIL_CLOSE_MAILBOX, _mail.EVENT_MAIL_CLOSE_MAILBOX)
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_MAIL_SEND_FAILED, _mail.EVENT_MAIL_SEND_FAILED)
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_MAIL_SEND_SUCCESS, _mail.EVENT_MAIL_SEND_SUCCESS)
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_MAIL_OPEN_MAILBOX, _mail.EVENT_MAIL_OPEN_MAILBOX)

Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized
