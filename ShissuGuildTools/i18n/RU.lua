-- Shissu GuildTools LanguageFile
---------------------------------
-- File: RU.lua
-- Version: v1.3.0
-- Last Update: 12.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Translated by KiriX

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
ZO_CreateStringId("Shissu_yourText", "ВАШ_ТЕКСТ")
ZO_CreateStringId("Shissu_mail", GetString(SI_CUSTOMERSERVICESUBMITFEEDBACKSUBCATEGORIES209))
ZO_CreateStringId("Shissu_add", "Добавить")
ZO_CreateStringId("Shissu_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))
ZO_CreateStringId("Shissu_rank", GetString(SI_STAT_GAMEPAD_RANK_LABEL))
ZO_CreateStringId("Shissu_info", GetString(SI_SCOREBOARD_HELPER_TAB_TOOLTIP))
ZO_CreateStringId("Shissu_addInfo", "Дополнительная информация")

-- Main
ZO_CreateStringId("ShissuModule_module", "Модули / Функции")
ZO_CreateStringId("ShissuModule_moduleInfo", "Если вы хотите ускорить работу SGT, вы можете отдельно отключить некоторые модули и функции в соответствии с вашими потребностями.")
ZO_CreateStringId("ShissuModule_moduleInfo2", "Выключение и включение отдельных модулей требует презагрузки интерфейса (/reloadui).")

ZO_CreateStringId("ShissuModule_rightMouse", "ПКМ")
ZO_CreateStringId("ShissuModule_leftMouse", "ЛКМ")
ZO_CreateStringId("ShissuModule_middleMouse", "СКМ")

-- Modules
----------
  
-- Module: ShissuWelcomeInvite                                                                                             
ZO_CreateStringId("ShissuWelcomeInvite", "Приветственное сообщение")
ZO_CreateStringId("ShissuWelcomeDesc1", "Вы можете использовать эти заготовки, чтобы создать приветственное сообщение для новых участников")
ZO_CreateStringId("ShissuWelcomeDesc2", "Имя игрока")
ZO_CreateStringId("ShissuWelcomeDesc3", "Название гильдии")
ZO_CreateStringId("ShissuWelcomeDesc4", "Разделитель различных вариантов (Можно несколько)")

-- Modul: ShissuTeleporter
ZO_CreateStringId("ShissuTeleporter", "Телепорт")
ZO_CreateStringId("ShissuTeleporter_tele", "Переместиться")
ZO_CreateStringId("ShissuTeleporter_rnd", "Случайно")
ZO_CreateStringId("ShissuTeleporter_refresh", "Обновить")
ZO_CreateStringId("ShissuTeleporter_grp", "Лидер группы")
ZO_CreateStringId("ShissuTeleporter_house", "Домой")
ZO_CreateStringId("ShissuTeleporter_legends1", "Легенда")
ZO_CreateStringId("ShissuTeleporter_legends2", "Друзья")
ZO_CreateStringId("ShissuTeleporter_legends3", "Члены группы")

-- Modul: ShissuNotifications
ZO_CreateStringId("ShissuNotifications", GetString(SI_BINDING_NAME_TOGGLE_NOTIFICATIONS)) 
ZO_CreateStringId("ShissuNotifications_info", "Заметка")
ZO_CreateStringId("ShissuNotifications_mail", "Удалить письмо/сообщение")
ZO_CreateStringId("ShissuNotifications_inSight", "Согильдейцы в поле зрения?")
ZO_CreateStringId("ShissuNotifications_friend", "Статусы друзей [в сети, афк, не бесп., не в сети]")
ZO_CreateStringId("ShissuNotifications_motD", GetString(SI_GUILD_MOTD_HEADER))
ZO_CreateStringId("ShissuNotifications_background", GetString(SI_GUILD_BACKGROUND_INFO_HEADER))
ZO_CreateStringId("ShissuNotifications_rank", "Список рангов")
ZO_CreateStringId("ShissuNotifications_guild", GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_GUILD_MEMBERS))
ZO_CreateStringId("ShissuNotifications_background2", "от")
ZO_CreateStringId("ShissuNotifications_background3", "был изменён")

-- Modul: ShissuHistory
ZO_CreateStringId("ShissuHistory", "Гильдия: " .. GetString(SI_WINDOW_TITLE_GUILD_HISTORY))
ZO_CreateStringId("ShissuHistory_filter", "Фильтр")
ZO_CreateStringId("ShissuHistory_status", "Показать/Скрыть")
ZO_CreateStringId("ShissuHistory_choice", "Выбрано")
ZO_CreateStringId("ShissuHistory_goldAdded", "Внесено")
ZO_CreateStringId("ShissuHistory_goldRemoved", "Снято")
ZO_CreateStringId("ShissuHistory_itemAdded", "Вложено")
ZO_CreateStringId("ShissuHistory_itemRemoved", "Снято")
ZO_CreateStringId("ShissuHistory_tax", "3,5% налог")
ZO_CreateStringId("ShissuHistory_sales", "Продажи")
ZO_CreateStringId("ShissuHistory_turnover", "На сумму")
ZO_CreateStringId("ShissuHistory_extern", "Торговец")
ZO_CreateStringId("ShissuHistory_trader", "С найма торговца")
ZO_CreateStringId("ShissuHistory_pages", "Все страницы")
ZO_CreateStringId("ShissuHistory_player", GetString(SI_PLAYER_MENU_PLAYER))
ZO_CreateStringId("ShissuHistory_set1", "Банк: Вклады и снятия (Золото + предметы)")
ZO_CreateStringId("ShissuHistory_set2", "Продажи: продажи, через торговца, 3.5% налог")
ZO_CreateStringId("ShissuHistory_opt", "НАСТРОЙКИ")
ZO_CreateStringId("ShissuHistory_last", "Последняя неделя")

-- Modul: ShissuColor
ZO_CreateStringId("ShissuColor_title", "Покраска")
ZO_CreateStringId("ShissuColor_std", "Стандартные цвета")
ZO_CreateStringId("ShissuColor_desc1", "Эти 5 цветов - стандартные цвета, используемые в различных модулях и функциях модфикации")

-- Modul: AutoAFK
ZO_CreateStringId("ShissuAutoAFK", "АвтоАФК")
ZO_CreateStringId("ShissuAFK_reminder", "Напоминание")
ZO_CreateStringId("ShissuAFK_infoOffline", "Вы сейчас не в сети!")
ZO_CreateStringId("ShissuAFK_autoOnline", "Автоматическое переключение с 'не в сети' на 'в сети'!")
ZO_CreateStringId("ShissuAFK_reminderOffline", "Напоминание: Не в сети?")
ZO_CreateStringId("ShissuAFK_minute", "через X минут")

-- Modul: ShissuContextMenu
ZO_CreateStringId("ShissuContextMenu", "Контекстное меню")
ZO_CreateStringId("ShissuContextMenu_mail", GetString(SI_SOCIAL_MENU_MAIL))
ZO_CreateStringId("ShissuContextMenu_invite", GetString(SI_NOTIFICATIONTYPE2))
ZO_CreateStringId("ShissuContextMenu_inviteC", "|ceeeeeeПригласить в: |cAFD3FF%1")
ZO_CreateStringId("ShissuContextMenu_answer", "Ответить, Переслать")
ZO_CreateStringId("ShissuContextMenu_newMail", "Новое письмо")
ZO_CreateStringId("ShissuContextMenu_forward", "Переслать")
ZO_CreateStringId("ShissuContextMenu_answer2", "Ответить")
ZO_CreateStringId("ShissuContextMenu_del", "Очистить")
ZO_CreateStringId("ShissuContextmenu_note", "Личная заметка")

-- Modul: ShissuMemberStatus
ZO_CreateStringId("ShissuMemberStatus", "Статус членов гильдии")
ZO_CreateStringId("ShissuContextMenu_memberStatus", "Статусы игроков (В сети/Не бесп./АФК/Не в сети)")
ZO_CreateStringId("ShissuContextMenu_added", "Присоединиться")
ZO_CreateStringId("ShissuContextMenu_removed", "Покинули / Удалены")
                                                        
-- Modul: ShissuGuildHome
ZO_CreateStringId("ShissuGuildHome", "Гильдия: " .. GetString(SI_WINDOW_TITLE_GUILD_HOME))
ZO_CreateStringId("ShissuGuildHome_kiosk", "Время до следующего найма торговца")
ZO_CreateStringId("ShissuGuildHome_textures", "Текстуры")
ZO_CreateStringId("ShissuGuildHome_rest", "Новый найм торговца через")
ZO_CreateStringId("ShissuGuildHome_c", "Стандартный цвет")
ZO_CreateStringId("ShissuGuildHome_leftTime", "Оставшееся время")
ZO_CreateStringId("ShissuGuildHome_color", GetString(SI_GUILD_HERALDRY_COLOR))

-- Modul: ShissuNotebook
ZO_CreateStringId("ShissuNotebook", "Записки")
ZO_CreateStringId("ShissuNotebook_slash", "Команда чата:")
ZO_CreateStringId("ShissuNotebook_noSlash", "Текст не найден (см. Записки)")
ZO_CreateStringId("ShissuNotebook_ttDelete", "Удалить записку")
ZO_CreateStringId("ShissuNotebook_ttNew", "Новая записка")
ZO_CreateStringId("ShissuNotebook_ttUndo", "Отменить изменения")
ZO_CreateStringId("ShissuNotebook_ttSendTo", _color.blue .. "ЛКМ" ..  _color.white .." - Отправить в чат\n"..  _color.blue .. "СКМ" ..  _color.white .." - Отправить письмом\n" ..  _color.blue.. "ПКМ".. _color.white .. " - Сохранить записку")

-- Modul: ShissuNotebookMail
ZO_CreateStringId("ShissuNotebookMail", "Записка письмом")
ZO_CreateStringId("ShissuNotebookMail_title", "Получатели")
ZO_CreateStringId("ShissuNotebookMail_choice", "Выбраным")
ZO_CreateStringId("ShissuNotebookMail_mailKick", "Исключение письмом")
ZO_CreateStringId("ShissuNotebookMail_mailOn", "ВКЛ")
ZO_CreateStringId("ShissuNotebookMail_mailOff", "ВЫКЛ")
ZO_CreateStringId("ShissuNotebookMail_list", "Списку")
ZO_CreateStringId("ShissuNotebookMail_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))
ZO_CreateStringId("ShissuNotebookMail_offlineSince", "Не в сети")
ZO_CreateStringId("ShissuNotebookMail_all", "- Все")
ZO_CreateStringId("ShissuNotebookMail_days", "Дней")
ZO_CreateStringId("ShissuNotebookMail_send", GetString(SI_MAIL_SEND_SEND))
ZO_CreateStringId("ShissuNotebookMail_progressKickTitle", "Исключение игрока")
ZO_CreateStringId("ShissuNotebookMail_progressDemoteTitle", "Понизить игрока")
ZO_CreateStringId("ShissuNotebookMail_progressTitle", "Отправить письмо")
ZO_CreateStringId("ShissuNotebookMail_progressAbort", "Отменено")
ZO_CreateStringId("ShissuNotebookMail_mailProgress", "Пожалуйста, подождите...")
ZO_CreateStringId("ShissuNotebookMail_doneL", "ГОТОВО!")
ZO_CreateStringId("ShissuNotebookMail_all2", "Все")
ZO_CreateStringId("ShissuNotebookMail_listAddRemove", _color.blue .. "ЛКМ" ..  _color.white .." - Добавить список\n"..  _color.blue .. "ПКМ".. _color.white .. " - Удалить список")
ZO_CreateStringId("ShissuNotebookMail_listPlayerAdd", "Добавить игрока")
ZO_CreateStringId("ShissuNotebookMail_listPlayerRemove", "Удалить игрока")
ZO_CreateStringId("ShissuNotebookMail_listPlayerBuildGroup", "Пригласить в группу")
ZO_CreateStringId("ShissuNotebookMail_online", "В сети, Не бесп., АФК")
ZO_CreateStringId("ShissuNotebookMail_ttEMail", "Отправить письма выбранным")
ZO_CreateStringId("ShissuNotebookMail_ttEMailList", "Отправить письма игрокам в списке")
ZO_CreateStringId("ShissuNotebookMail_ttEMailKick", "Отправить игроку письмо при исключении")
ZO_CreateStringId("ShissuNotebookMail_ttKick", "Выберите из гильдии (возможно с отсылкой письма)")
ZO_CreateStringId("ShissuNotebookMail_ttKickList", "Игроки из списка будут исключены из гильдии (с отсылкой письма, если необходимо)")
ZO_CreateStringId("ShissuNotebookMail_protocolIgnoreTT", "Игрок игнорирует вас или вы игнорируете игрока!")
ZO_CreateStringId("ShissuNotebookMail_ttContin", "Если доставка по каким-либо причинам " .. _color.blue .. "не продвигается".. _color.white .. ", нажмите эту кнопку. Текущий получатель будет помечен как проигнорированный.")
ZO_CreateStringId("ShissuNotebookMail_protocolTT", "Показать игроков, у кого ящик заполнен или кто игнорирует вас.")
ZO_CreateStringId("ShissuNotebookMail_newList", "Новый список")
ZO_CreateStringId("ShissuNotebookMail_listName", "Название списка?")
ZO_CreateStringId("ShissuNotebookMail_invite", "Пригласить игроков")
ZO_CreateStringId("ShissuNotebookMail_confirmKick", "Вы действительно хотите исключить игроков из списка или выбранных вами игроков из гильдии? Исключённые игроки получат письмо от вас.")
ZO_CreateStringId("ShissuNotebookMail_demoteKick", "Вы действительно хотите понизить игроков из списка или выбранных вами игроков из гильдии?")
ZO_CreateStringId("ShissuNotebookMail_splashSubject", "Тема")
ZO_CreateStringId("ShissuNotebookMail_splashProgress", "Прогресс")       
ZO_CreateStringId("ShissuNotebookMail_protocolIgnore", "Игнор")       
ZO_CreateStringId("ShissuNotebookMail_protocolFull", "Ящик заполнен")       
ZO_CreateStringId("ShissuNotebookMail_protocol", "Протокол рассылки")       
ZO_CreateStringId("ShissuNotebookMail_mailAbort", _color.blue .. "Закрыть окно" .. _color.white .. "\nЗакрытие окна завершит рассылку/исключение.")
ZO_CreateStringId("ShissuNotebookMail_newMail", GetString(SI_SOCIAL_MENU_SEND_MAIL))       
ZO_CreateStringId("ShissuNotebookMail_ERR_FAIL_BLANK_MAIL", "Письмо не отправлено")

ZO_CreateStringId("ShissuNotebookMail_Filter", "Фильтр")
ZO_CreateStringId("ShissuNotebookMail_Action", "Действие")
ZO_CreateStringId("ShissuNotebookMail_Send", "Отправить")
ZO_CreateStringId("ShissuNotebookMail_Member", "Участник")
ZO_CreateStringId("ShissuNotebookMail_SinceGold", "за  мин. дней")
ZO_CreateStringId("ShissuNotebookMail_noMail", "Без письма")

ZO_CreateStringId("ShissuNotebookMail_countDays", "Число дней")

-- Modul: ShissuRoster
ZO_CreateStringId("ShissuRoster", "Гильдия: Список")
ZO_CreateStringId("ShissuRoster_char", GetString(SI_BINDING_NAME_TOGGLE_CHARACTER))
ZO_CreateStringId("ShissuRoster_goldDeposit", "Вклад")
ZO_CreateStringId("ShissuRoster_goldDeposit2", "Вклад золота")
ZO_CreateStringId("ShissuRoster_goldDeposit3", "Вклад золота")
ZO_CreateStringId("ShissuRoster_member", "В гильдии:")
ZO_CreateStringId("ShissuRoster_thisWeek", "Текущая неделя")
ZO_CreateStringId("ShissuRoster_lastWeek", "Последняя неделя")
ZO_CreateStringId("ShissuRoster_today", "Сегодня")
ZO_CreateStringId("ShissuRoster_yesterday", "Вчера")
ZO_CreateStringId("ShissuRoster_sinceKiosk", "С найма торговца")
ZO_CreateStringId("ShissuRoster_last", "Последнее")
ZO_CreateStringId("ShissuRoster_total", "Всего")
ZO_CreateStringId("ShissuRoster_sum", "Всего")
ZO_CreateStringId("ShissuRoster_colAdd", "Показать доп.колонки")
ZO_CreateStringId("ShissuRoster_colAdd2", "После этих изменений вам необходимо перезагрузить интерфейс.")
ZO_CreateStringId("ShissuRoster_colChar", "Колонка: Персонаж")
ZO_CreateStringId("ShissuRoster_colGold", "Колонка: Внесено золота")
ZO_CreateStringId("ShissuRoster_colNote", "Колонка: Личная заметка")
ZO_CreateStringId("ShissuRoster_noData", "Нет данных")

-- Modul: Scanner
ZO_CreateStringId("ShissuScanner", "Гильдия: Сканирование истории")
ZO_CreateStringId("ShissuScanner_scan1", "Записи гильдии")
ZO_CreateStringId("ShissuScanner_scan2", "сейчас читаются. Пожалуйста, подождите...")

-- Modul: Chat
ZO_CreateStringId("ShissuChat", "Чат")
ZO_CreateStringId("ShissuChat_auto", "Автоматическое переключение")
ZO_CreateStringId("ShissuChat_date", "Дата")
ZO_CreateStringId("ShissuChat_time", "Время")
ZO_CreateStringId("ShissuChat_sound", "Сигнал (Личное сообщение)")
ZO_CreateStringId("ShissuChat_guilds", "Согильдейцы")
ZO_CreateStringId("ShissuChat_rang", GetString(SI_GAMEPAD_GUILD_ROSTER_RANK_HEADER))
ZO_CreateStringId("ShissuChat_alliance", GetString(SI_LEADERBOARDS_HEADER_ALLIANCE))                                                       
ZO_CreateStringId("ShissuChat_lvl", "Уровень")
ZO_CreateStringId("ShissuChat_char", "Имя персонажа")
ZO_CreateStringId("ShissuChat_whisper", GetString(SI_CHAT_PLAYER_CONTEXT_WHISPER))
ZO_CreateStringId("ShissuChat_party", GetString(SI_CHAT_CHANNEL_NAME_PARTY))
ZO_CreateStringId("ShissuChat_guildchan", GetString(SI_CHAT_OPTIONS_GUILD_CHANNELS))
ZO_CreateStringId("ShissuChat_charAcc1", "Аккаунт")
ZO_CreateStringId("ShissuChat_charAcc2", "Персонаж")
ZO_CreateStringId("ShissuChat_charAcc3", "Аккаунт + Персонаж")
ZO_CreateStringId("ShissuChat_guildInfo", "Информация гильдии")
ZO_CreateStringId("ShissuChat_guildWhich", "Для каких гильдий выводить дополнительную информацию?")
ZO_CreateStringId("ShissuChat_guildNames1", "Названия")
ZO_CreateStringId("ShissuChat_guildNames2", "Как гильдии отображаются в чате?")
     
-- Modul: Marks
ZO_CreateStringId("ShissuMarks", "Отметки")
ZO_CreateStringId("ShissuMarks_title", "Отметки Монстров (NPC) и Игроков")
ZO_CreateStringId("ShissuMarks_misc", "Разное")
ZO_CreateStringId("ShissuMarks_kick", "АвтоКик")
ZO_CreateStringId("ShissuMarks_heal", "Целитель")
ZO_CreateStringId("ShissuMarks_observe", "Наблюдение")
ZO_CreateStringId("ShissuMarks_all", "Всё, что вы видите")
ZO_CreateStringId("ShissuMarks_confirmDel", "Удалить список?")
ZO_CreateStringId("ShissuMarks_confirmDel2", "Вы уверены, что хотите удалить всё содержимое списка?")  
ZO_CreateStringId("ShissuMarks_add", "Монстр (NPC) / Игрок")
ZO_CreateStringId("ShissuMarks_add2", "Какое имя у монстра/игрока?")
ZO_CreateStringId("ShissuMarks_add3", "Монстр / игрок в группе")
ZO_CreateStringId("ShissuMarks_add4", "добавлено")
ZO_CreateStringId("ShissuMarks_add5", "Монстр / игрок уже в группе")
ZO_CreateStringId("ShissuMarks_leftMouse", "Добавить")
ZO_CreateStringId("ShissuMarks_rightMouse", "Полностью очистить список")
ZO_CreateStringId("ShissuMarks_middleMouse", "Проверка гильдий")
ZO_CreateStringId("ShissuMarks_observeInfo", "Игроки в списке: выделяются в чате")
ZO_CreateStringId("ShissuMarks_observeInfo2", "- При входе")
ZO_CreateStringId("ShissuMarks_observeInfo3", "- При вступлении вгильдии")
ZO_CreateStringId("ShissuMarks_observeInfo4", "- При исключении из гильдии")
ZO_CreateStringId("ShissuMarks_autoKick", "Автоматическое исключение")
ZO_CreateStringId("ShissuMarks_autoKickInfo", "Игроки в списке: АвтоКик исключает:")
ZO_CreateStringId("ShissuMarks_autoKickInfo2", "- При входе")
ZO_CreateStringId("ShissuMarks_autoKickInfo3", "- При вступлении вгильдии")
ZO_CreateStringId("ShissuMarks_found", "в гильдии.")
ZO_CreateStringId("ShissuMarks_found2", "Игрок был исключён (если имеются права).")
ZO_CreateStringId("ShissuMarks_rightItem", "Удалить игрока/монстра")
ZO_CreateStringId("ShissuMarks_rightItem2", "ПКМ по имени")           