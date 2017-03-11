-- File: History.lua
-- Zuletzt geändert: 18. Januar 2016

ShissuGT.History.kioskSecsSinceEvent = 0

ShissuGT.ZO = {
  History = GUILD_HISTORY,
  GuildEvent = {},
}

-- LOCALS
local SGT_History = {}

SGT_History.Category = nil

SGT_History.UI = {}
SGT_History.Filter = {
  Gold = true,
  Item = true,
  Kiosk = false,
}

function ShissuGT.History.Toogle()
  SGT_History.Filter = {
    Gold = true,
    Item = true,
    Kiosk = false,
  }
  
  if ShissuGT.Settings.History == true then SGT_History.Toogle(false)       
  else SGT_History.Toogle(true) end  
  
  ShissuGT.ZO.History:RefreshFilters()  
end

function SGT_History.Toogle(bool)
  local SGT = SGT_History.UI
  
  SGT.SearchLabel:SetHidden(bool)                                                                         
  SGT.FilterLabel:SetHidden(bool)    
  SGT.Gold:SetHidden(bool)    
  SGT.Item:SetHidden(bool)    
  SGT.ChoiceLabel:SetHidden(bool)  
  SGT.MemberChoice:SetHidden(bool)    
  SGT.SearchBoxBackDrop:SetHidden(bool)         
  SGT.SearchBox:SetHidden(bool)       
  
  SGT_History.SalesToogle(bool) 
  SGT_History.BankToogle(bool) 
  SGT_History.OptionToogle(bool)
end

function SGT_History.BankToogle(bool)
  if SGT_History.UI.goldAdded == nil then return false end

  SGT_History.UI.goldAdded:SetHidden(bool)
  SGT_History.UI.goldAddedLabel:SetHidden(bool)
  SGT_History.UI.goldAddedCount:SetHidden(bool)
  SGT_History.UI.goldRemoved:SetHidden(bool)
  SGT_History.UI.goldRemovedLabel:SetHidden(bool)  
  SGT_History.UI.ItemLabel:SetHidden(bool)
  SGT_History.UI.itemAddedLabel:SetHidden(bool)
  SGT_History.UI.itemAdded:SetHidden(bool)
  SGT_History.UI.itemRemovedLabel:SetHidden(bool)
  SGT_History.UI.itemRemoved:SetHidden(bool)
  SGT_History.UI.goldLabel:SetHidden(bool)
end

function SGT_History.SalesToogle(bool)
  if SGT_History.UI.salesIntern == nil then return false end

  SGT_History.UI.salesIntern:SetHidden(bool)
  SGT_History.UI.turnover:SetHidden(bool)
  SGT_History.UI.tax:SetHidden(bool)
  SGT_History.UI.salesInternLabel:SetHidden(bool)
  SGT_History.UI.turnoverLabel:SetHidden(bool)
  SGT_History.UI.taxLabel:SetHidden(bool)
  SGT_History.UI.salesLabel:SetHidden(bool)
end

function SGT_History.OptionToogle(bool)
  if SGT_History.UI.optionLabel == nil then return false end
  
  SGT_History.UI.optionLabel:SetHidden(bool)
  SGT_History.UI.optionKiosk:SetHidden(bool)
end

function SGT_History.FilterScrollList(self)
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  local playerSearch = string.lower(SGT_History.UI.SearchBox:GetText())
  local filterCount = 0
  local guildId = GUILD_SELECTOR.guildId
  local goldAdded = 0
  local goldAddedCount = 0
  local goldRemoved = 0    
  local itemAdded = 0
  local itemRemoved = 0
  local salesInternCount = 0     
  local turnover = 0 
  local tax = 0     
  local kioskCheckBox = false
  
  local currentTime = GetTimeStamp()
  local lastKioskTime = currentTime + ShissuGT.Lib.GetNextKioskTime() - (7* 86400)

  ZO_ClearNumericallyIndexedTable(scrollData)
  
  -- Controls nur verstecken, falls vorhanden
  SGT_History.BankToogle(true)
  SGT_History.SalesToogle(true)
  
  if SGT_History.UI.optionLabel ~= nil then kioskCheckBox = ZO_CheckButton_IsChecked(SGT_History.UI.optionKiosk) end
    
  for i = 1, #self.masterList do
    local data = self.masterList[i]
    
    if data.eventType ~= SGT_History.Category then
      SGT_History.Category = data.eventType 
    end
    
    -- ACCOUNTLINK
    if data.param1 ~= nil and not string.find(data.param1, "|H1") then
      data.param1 = string.format("|H1:display:%s|h%s|h", data.param1, data.param1)
    end

    -- Filter
    if(self.selectedSubcategory == nil or self.selectedSubcategory == data.subcategoryId) then
      if (not ShissuGT.Lib.IsStringEmpty(data.param1) and string.find(string.lower(data.param1), playerSearch, 1)) or 
        (not ShissuGT.Lib.IsStringEmpty(data.param2) and string.find(string.lower(data.param2), playerSearch, 1)) or
        (not ShissuGT.Lib.IsStringEmpty(data.param3) and string.find(string.lower(data.param3), playerSearch, 1)) or
        (not ShissuGT.Lib.IsStringEmpty(data.param4) and string.find(string.lower(data.param4), playerSearch, 1)) then         
                
        -- BANK
        if (not ShissuGT.Lib.IsStringEmpty(data.param2)) then
          if data.eventType == GUILD_EVENT_BANKGOLD_ADDED then 
          
            if lastKioskTime ~= 0 and kioskCheckBox then
              if currentTime - data.secsSinceEvent >= lastKioskTime then
                goldAdded = goldAdded + data.param2
                goldAddedCount = goldAddedCount + 1
              end
            else
              goldAdded = goldAdded + data.param2
              goldAddedCount = goldAddedCount + 1
            end
          end
          
          if data.eventType == GUILD_EVENT_BANKGOLD_REMOVED then 
            if lastKioskTime ~= 0 and kioskCheckBox then
              if currentTime - data.secsSinceEvent >= lastKioskTime then goldRemoved = goldRemoved + data.param2 end
            else goldRemoved = goldRemoved + data.param2 end      
          end
        end
        
        -- VERKAUF
        -- Accountname: data.param2, Steuern: data.param6, Gold durch Verkauf: data.param5      
        if data.eventType == GUILD_EVENT_ITEM_SOLD then
          if (not ShissuGT.Lib.IsStringEmpty(data.param1)) then
            for y=1, GetNumGuildMembers(guildId), 1 do
              local accInfo = {GetGuildMemberInfo(guildId, y)}
        
              if accInfo[1] == data.param2 then
                if lastKioskTime ~= 0 and kioskCheckBox then
                  if currentTime - data.secsSinceEvent >= lastKioskTime then salesInternCount = salesInternCount + 1 end
                else salesInternCount = salesInternCount + 1 end
                break 
              end
            end   
          end
              
          if lastKioskTime ~= 0 and kioskCheckBox then
            if currentTime - data.secsSinceEvent >= lastKioskTime then
              if (not ShissuGT.Lib.IsStringEmpty(data.param5)) then turnover = turnover + data.param5 end
              if (not ShissuGT.Lib.IsStringEmpty(data.param6)) then tax = tax + data.param6 end
            end
          else
            if (not ShissuGT.Lib.IsStringEmpty(data.param5)) then turnover = turnover + data.param5 end
            if (not ShissuGT.Lib.IsStringEmpty(data.param6)) then tax = tax + data.param6 end
          end            
        end     
                
        if (data.eventType == GUILD_EVENT_BANKITEM_ADDED) then
          if currentTime - data.secsSinceEvent >= lastKioskTime then itemAdded = itemAdded + 1
          else itemAdded = itemAdded + 1 end
        end       
        
        if (data.eventType == GUILD_EVENT_BANKITEM_REMOVED) then
          if currentTime - data.secsSinceEvent >= lastKioskTime then itemRemoved = itemRemoved + 1
          else itemRemoved = itemRemoved + 1 end
        end       

        -- FILTER Buttons
        if (SGT_History.Filter.Gold == false and (data.eventType == GUILD_EVENT_BANKGOLD_ADDED or
          data.eventType == GUILD_EVENT_BANKGOLD_ADDED or
          data.eventType == GUILD_EVENT_BANKGOLD_GUILD_STORE_TAX or
          data.eventType == GUILD_EVENT_BANKGOLD_KIOSK_BID or
          data.eventType == GUILD_EVENT_BANKGOLD_KIOSK_BID_REFUND or
          data.eventType == GUILD_EVENT_BANKGOLD_PURCHASE_HERALDRY or
          data.eventType == GUILD_EVENT_BANKGOLD_REMOVED)) then       
        elseif (SGT_History.Filter.Item == false and (data.eventType == GUILD_EVENT_BANKITEM_ADDED or
          data.eventType == GUILD_EVENT_BANKITEM_REMOVED)) then  
        else
          table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
          filterCount = filterCount + 1
        end    
      end
      
    end 
  end
    
  SGT_History.UI.MemberChoice:SetText( ShissuGT.Color[6] .. filterCount .. ShissuGT.Color[5] .. "/" .. #self.masterList) 
  
  -- Kategorie: Bank  
  if goldAdded > 0 or itemAdded > 0 then
    if SGT_History.UI.goldAdded == nil then SGT_History.BankControls() end
    
    SGT_History.UI.goldAdded:SetText(ShissuGT.Color[5] .. goldAdded .. ShissuGT.WhiteGold)
    SGT_History.UI.goldAddedCount:SetText("(".. ShissuGT.Color[6] ..  goldAddedCount .. ShissuGT.Color[5] .. " Spieler)")
    SGT_History.UI.goldRemoved:SetText(ShissuGT.Color[5] .. goldRemoved .. ShissuGT.WhiteGold)
    
    SGT_History.UI.itemAdded:SetText(ShissuGT.Color[5] .. itemAdded)
    SGT_History.UI.itemRemoved:SetText(ShissuGT.Color[5] .. itemRemoved)    
    
    SGT_History.BankToogle(false)
  end

  -- Kategorie: Verkauf
  if salesInternCount > 0 or tax > 0 or turnover >0 then
    if SGT_History.UI.salesIntern == nil then SGT_History.SalesControls() end
    
    SGT_History.UI.salesIntern:SetText(ShissuGT.Color[5] .. ShissuGT.Lib.Round(salesInternCount/#self.masterList*100) .. ShissuGT.Color[6] .. "%" )
    SGT_History.UI.turnover:SetText(ShissuGT.Color[5] .. turnover .. ShissuGT.WhiteGold)
    SGT_History.UI.tax:SetText(ShissuGT.Color[5] .. tax .. ShissuGT.WhiteGold) 
    SGT_History.SalesToogle(false)
  end   
end               

function SGT_History.EditBox()
  SGT_History.UI.SearchBoxBackDrop = CreateControlFromVirtual("SGT_History_SearchBoxBackground", ZO_GuildHistory, "ZO_EditBackdrop")
  SGT_History.UI.SearchBoxBackDrop:SetDimensions(200, 25)
  SGT_History.UI.SearchBoxBackDrop:SetAnchor(TOPLEFT, ZO_GuildHistory, TOPLEFT, 400, 30)

  SGT_History.UI.SearchBox = CreateControlFromVirtual("SGT_History_SearchBox", SGT_History.UI.SearchBoxBackDrop, "ZO_DefaultEditForBackdrop")
  SGT_History.UI.SearchBox:SetHandler("OnTextChanged", function()
  ShissuGT.ZO.History:RefreshFilters()
  end)
end

function SGT_History.CreateButton(name, var, offsetX, offsetY) 
  local button = CreateControlFromVirtual(name, ZO_GuildHistory, "ZO_CheckButton")
  button:SetAnchor(TOPLEFT, ZO_GuildHistory, TOPLEFT, offsetX, offsetY)
  
  ShissuGT.Lib.CheckBox(button, var)
  
  ZO_CheckButton_SetToggleFunction(button, function(control, checked)
    SGT_History.Filter[var] = checked
    ShissuGT.ZO.History:RefreshFilters()
  end)
  
  ShissuGT.Lib.SetToolTip(button, "History", var)
  ShissuGT.Lib.HideToolTip(button)
  
  return button
end

function SGT_History.BankControls()
  -- GOLD
  SGT_History.UI.goldLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryGoldLabel", ZO_GuildHistoryCategories, ShissuGT.Color[5] .. "GOLD", nil, {30, 250}, nil, nil, "ZoFontGameBold")
  
  -- Einzahlung
  SGT_History.UI.goldAddedLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryGoldAddedLabel", SGT_HistoryGoldLabel, ShissuGT.i18n.History.GoldAdded, nil, {-100, 30})
  SGT_History.UI.goldAdded = ShissuGT.Lib.CreateLabel("SGT_HistoryGoldAdded", SGT_HistoryGoldAddedLabel)
  SGT_History.UI.goldAddedCount = ShissuGT.Lib.CreateLabel("SGT_HistoryGoldAddedCount", SGT_HistoryGoldAdded, nil, nil, {-100, 30})

  -- Auszahlung
  SGT_History.UI.goldRemovedLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryGoldRemovedLabel", SGT_HistoryGoldAddedLabel, ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.History.GoldRemoved), nil, {-100, 60})
  SGT_History.UI.goldRemoved = ShissuGT.Lib.CreateLabel("SGT_HistoryGoldRemoved", SGT_HistoryGoldRemovedLabel)
  
  -- ITEMS
  SGT_History.UI.ItemLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryItemLabel", SGT_HistoryGoldRemovedLabel, ShissuGT.Color[5] .. "ITEMS", nil, {-100, 30}, nil, nil, "ZoFontGameBold")
  
  -- Eingelagert
  SGT_History.UI.itemAddedLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryItemAddedLabel", SGT_HistoryItemLabel, ShissuGT.i18n.History.ItemAdded, nil, {-100, 30})
  SGT_History.UI.itemAdded = ShissuGT.Lib.CreateLabel("SGT_HistoryItemAdded", SGT_HistoryItemAddedLabel)
  
  -- Entnommen
  SGT_History.UI.itemRemovedLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryItemRemovedLabel", SGT_HistoryItemAddedLabel, ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.History.ItemRemoved), nil, {-100, 30})
  SGT_History.UI.itemRemoved = ShissuGT.Lib.CreateLabel("SGT_HistoryItemRemoved", SGT_HistoryItemRemovedLabel)
end

function SGT_History.SalesControls()
  -- VERKÄUFE
  SGT_History.UI.salesLabel = ShissuGT.Lib.CreateLabel("SGT_HistorySalesLabel", ZO_GuildHistoryCategories, ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.History.Sells), nil, {30, 250}, nil, nil, "ZoFontGameBold")
  
  -- Intern 
  SGT_History.UI.salesInternLabel = ShissuGT.Lib.CreateLabel("SGT_HistorySalesInternLabel", SGT_HistorySalesLabel, ShissuGT.i18n.History.Intern, nil, {-100, 30})
  SGT_History.UI.salesIntern = ShissuGT.Lib.CreateLabel("SGT_SalesIntern", SGT_HistorySalesInternLabel)
  
  -- Umsatz
  SGT_History.UI.turnoverLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryTurnoverLabel", SGT_HistorySalesInternLabel, ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.History.Sales), nil, {-100, 30})
  SGT_History.UI.turnover = ShissuGT.Lib.CreateLabel("SGT_HistoryTurnover", SGT_HistoryTurnoverLabel)

  -- Steuern
  SGT_History.UI.taxLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryTaxLabel", SGT_HistoryTurnoverLabel, ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.History.Tax), nil, {-100, 30})
  SGT_History.UI.tax = ShissuGT.Lib.CreateLabel("SGT_HistoryTax", SGT_HistoryTaxLabel)
end

SGT_History.AllPages = false

function SGT_History.OptionControls()
  -- seit Gildenhändler
  SGT_History.UI.optionLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryOptionLabel", ZO_GuildHistoryCategories, "OPTIONEN", nil, {30, 470}, nil, nil, "ZoFontGameBold")
  SGT_History.UI.optionKiosk = CreateControlFromVirtual("SGT_HistoryOptionKiosk", SGT_HistoryOptionLabel, "ZO_CheckButton")
  SGT_History.UI.optionKiosk:SetAnchor(LEFT, SGT_HistoryOptionKioskLabel, LEFT, 0, 30)
  SGT_History.UI.optionKiosk:SetHidden(false)
  ZO_CheckButton_SetLabelText(SGT_History.UI.optionKiosk, ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.History.Trader))
  ZO_CheckButton_SetToggleFunction(SGT_History.UI.optionKiosk, function() ShissuGT.ZO.History:RefreshFilters() end)   
  
  -- Alles Öffnen
  SGT_History.UI.optionAllPages = CreateControlFromVirtual("SGT_HistoryAllPages", SGT_HistoryOptionKiosk, "ZO_CheckButton")
  SGT_History.UI.optionAllPages:SetAnchor(LEFT, SGT_HistoryOptionKiosk, LEFT, -0, 30)
  SGT_History.UI.optionAllPages:SetHidden(false)
  ZO_CheckButton_SetLabelText(SGT_History.UI.optionAllPages, ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.History.AllPage))
  
  SGT_History.UI.optionAllPages:SetHandler("OnMouseEnter", function(self) ShissuGT.Lib.ToolTip(self, ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.History.AllPageInfo)) end)
  SGT_History.UI.optionAllPages:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)
  
  ZO_CheckButton_SetToggleFunction(SGT_History.UI.optionAllPages, function() 
    if SGT_History.AllPages == false then 
      ShissuGT.Misc.OpenAllPages() 
      SGT_History.AllPages = true
    else
      EVENT_MANAGER:UnregisterForUpdate("ShissuGT_HistoryPage") 
      SGT_History.AllPages = false
    end
  end)    
  
  SGT_HistoryOptionLabel:SetHidden(false)
end

function ShissuGT.History.Initialize()
  local CL = ShissuGT.Lib.CreateZOButton
  ShissuGT.History.Active = true
  ShissuGT.ZO.History.FilterScrollList = SGT_History.FilterScrollList
  
  SGT_History.EditBox()
  SGT_History.UI.SearchLabel = ShissuGT.Lib.CreateLabel("SGT_HistorySearchLabel", SGT_History_SearchBoxBackground, ShissuGT.i18n.History.FilterBox, nil, {0, -20}, false, LEFT)
 
  -- FILTER
  SGT_History.UI.FilterLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryFilterLabel", SGT_HistorySearchLabel, ShissuGT.i18n.History.OnOff, {150, 30}, {135, 0}, false)
  SGT_History.UI.Gold = SGT_History.CreateButton("SGT_History_Gold","Gold", 640, 35)
  SGT_History.UI.Item = SGT_History.CreateButton("SGT_History_Item","Item", 700, 35)  
  SGT_History.UI.ChoiceLabel = ShissuGT.Lib.CreateLabel("SGT_HistoryChoiceLabel", SGT_HistoryFilterLabel, ShissuGT.i18n.History.Choice2, {150, 30}, {8, 0}, false)
  SGT_History.UI.MemberChoice = CL("SGT_History_MemberChoice","/", 150, 750, 30, ZO_GuildHistory)    
  
  ShissuGT.Lib.SetToolTip(SGT_History.UI.SearchBox, "History", "Filter")
  ShissuGT.Lib.HideToolTip(SGT_History.UI.SearchBox)
  ShissuGT.Lib.SetToolTip(SGT_History.UI.MemberChoice, "History", "Choice")
  ShissuGT.Lib.HideToolTip(SGT_History.UI.MemberChoice)    
  
  SGT_History.OptionControls()   
end

function ShissuGT.Misc.OpenAllPages()
  EVENT_MANAGER:UnregisterForUpdate("ShissuGT_HistoryPage") 
  
  EVENT_MANAGER:RegisterForUpdate("ShissuGT_HistoryPage", 1500, function()
    local count = table.getn(GUILD_HISTORY.masterList)
    ShissuGT.ZO.History:RequestOlder()
    
    zo_callLater(function()  
      local count2 = table.getn(GUILD_HISTORY.masterList)
    
      if (count == count2) then
        EVENT_MANAGER:UnregisterForUpdate("ShissuGT_HistoryPage")  
      end
  end, 500); 
  end)
end