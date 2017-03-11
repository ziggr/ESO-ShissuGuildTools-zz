-- Shissu Suite Manager
-----------------------
-- File: RU.lua
-- Last Update: 27.10.2016
-- Written by Christian Flory (@Shissu) - esoui@flory.one

-- Released under terms in license accompanying this file.
-- Distribution without license is prohibited!

Shissu_SuiteManager = Shissu_SuiteManager or {}
Shissu_SuiteManager._i18n = Shissu_SuiteManager._i18n or {}

-- Feedback
ZO_CreateStringId("SGT_Feedback1", "Надеюсь, вам нравится эта модификацияюю  Ваши отзывы всегда приветствуются, так что напишите мне пару строчек, с пожертвованием или без.  Ваши пожертвования позволят сосредоточиться и тратить время не на приключения в ESO, а на новые функции и улучшения.")
ZO_CreateStringId("SGT_Feedback2", "")
ZO_CreateStringId("SGT_Feedback3", "ВАЖНО!!! Я получу ваше письмо только если вы играете на EU-сервере (европейском)!")

-- Bindings
ZO_CreateStringId("SI_BINDING_NAME_SGT_helmToogle", "Переключить шлем")
ZO_CreateStringId("SI_BINDING_NAME_SGT_offlineToogle", "Переключить статус В/Не в сети")
ZO_CreateStringId("SI_BINDING_NAME_SGT_reload", "Перезагрузить интерфейс")

-- Modul: Language
ZO_CreateStringId("SGT_Language1", "Язык TESO")
ZO_CreateStringId("SGT_Language2", "Язык")
ZO_CreateStringId("SGT_Language3", "Смена языка Elder Scrolls Online еа выбранный ьез перезапуска игры. |cFF747FВнимание|r: Интерфейс перезагрузится.")

-- Modul: Standard
ZO_CreateStringId("SGT_Standard1", "Стандартные команды")
ZO_CreateStringId("SGT_Standard2", "|cAFD3FF/rl|r - ПЕРЕЗАГРУЗКА ИНТЕРФЕЙСА\n\n" ..
    "|cAFD3FF/helm|r - Переключение шлема \n\n" ..
    "|cAFD3FF/on|r - Статус игрока " .. EsoStrings[SI_PLAYERSTATUS1] .. "\n\n" ..
    "|cAFD3FF/off|r - Статус игрока " .. EsoStrings[SI_PLAYERSTATUS4] .. "\n\n" ..
    "|cAFD3FF/brb|r - Статус игрока " .. EsoStrings[SI_PLAYERSTATUS3] .. "\n\n" ..
    "|cAFD3FF/dnd|r - Статус игрока " .. EsoStrings[SI_PLAYERSTATUS3] .. "\n\n" ..
    "|cAFD3FF/afk|r - Статус игрока " .. EsoStrings[SI_PLAYERSTATUS2])
