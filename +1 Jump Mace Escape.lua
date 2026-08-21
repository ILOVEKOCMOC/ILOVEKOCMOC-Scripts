--[[
    +1 JUMP MACE ESCAPE
    YT:@ILOVEKOCMOC
    Version: 2.0.0 Release
]] -- 1

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))() -- 2

-- ====== ПЕРЕМЕННЫЕ ====== -- 3
local correctKey = "1337" -- 4
local creatorKey = "ILOVEKOCMOC_DEV" -- 5
local language = "RU" -- 6
local languageSelected = false -- 7
local keyAccepted = false -- 8
local savedPosition = nil -- 9
local savedTargetPosition = nil -- 10
local savedTransparency = nil -- 11
local ScriptVersion = "2.0.0 Release" -- 12
local KeyURL = "https://youtu.be/9Lv6lhK5n6E" -- 13

-- ====== JSONBIN.IO ====== -- 14
local BinID = "6a87f3d8da38895dfefe7981" -- 15
local ApiKey = "$2a$10$dMTaIid803n2yFFFE1etEOyZUpar0U9lX2M31VdUm5ZvaFVgWFWPq" -- 16
local BinURL = "https://api.jsonbin.io/v3/b/" .. BinID -- 17

-- ====== СЕРВИСЫ ====== -- 18
local TweenService = game:GetService("TweenService") -- 19
local RunService = game:GetService("RunService") -- 20
local HttpService = game:GetService("HttpService") -- 21
local Players = game:GetService("Players") -- 22
local ReplicatedStorage = game:GetService("ReplicatedStorage") -- 23

-- ====== КЭШ ====== -- 24
local cacheData = nil -- 25
local cacheTime = 0 -- 26
local CACHE_DURATION = 3 -- 27

-- ====== СОХРАНЕНИЕ КЛЮЧА ====== -- 28
local function saveKey(key) -- 29
    pcall(function() writefile("ILOVEKOCMOC_Key.txt", key) end) -- 30
end -- 31

local function loadKey() -- 32
    local key = nil -- 33
    pcall(function() -- 34
        if isfile("ILOVEKOCMOC_Key.txt") then key = readfile("ILOVEKOCMOC_Key.txt") end -- 35
    end) -- 36
    return key -- 37
end -- 38

-- ====== СИНХРОНИЗАЦИЯ ====== -- 39
local syncFolder = ReplicatedStorage:FindFirstChild("ILOVEKOCMOC_Sync") -- 40
if not syncFolder then -- 41
    syncFolder = Instance.new("Folder") -- 42
    syncFolder.Name = "ILOVEKOCMOC_Sync" -- 43
    syncFolder.Parent = ReplicatedStorage -- 44
end -- 45

local remoteEvent = syncFolder:FindFirstChild("Command") -- 46
if not remoteEvent then -- 47
    remoteEvent = Instance.new("RemoteEvent") -- 48
    remoteEvent.Name = "Command" -- 49
    remoteEvent.Parent = syncFolder -- 50
end -- 51

local function cachedHttpGet(url) -- 52
    local currentTime = os.time() -- 53
    if cacheData and (currentTime - cacheTime) < CACHE_DURATION then return cacheData end -- 54
    local success, result = pcall(function() return game:HttpGet(url) end) -- 55
    if success then cacheData = result cacheTime = currentTime return result end -- 56
    return nil -- 57
end -- 58

local function getGlobalScriptUsers() -- 59
    local total = 0 -- 60
    pcall(function() -- 61
        local response = cachedHttpGet(BinURL .. "/latest") -- 62
        if response then -- 63
            local data = HttpService:JSONDecode(response) -- 64
            if data.record then total = data.record.count or 0 end -- 65
        end -- 66
    end) -- 67
    return total -- 68
end -- 69

local function incrementScriptCounter() -- 70
    pcall(function() -- 71
        local request = syn.request or http_request or request -- 72
        if request then -- 73
            local current = getGlobalScriptUsers() -- 74
            cacheData = nil -- 75
            request({ -- 76
                Url = BinURL, -- 77
                Method = "PUT", -- 78
                Headers = {["Content-Type"] = "application/json", ["X-Master-Key"] = ApiKey}, -- 79
                Body = HttpService:JSONEncode({count = current + 1}) -- 80
            }) -- 81
        end -- 82
    end) -- 83
end -- 84

local function sendGlobalCommand(command, data) -- 85
    pcall(function() remoteEvent:FireServer(command, data) end) -- 86
    pcall(function() -- 87
        local request = syn.request or http_request or request -- 88
        if request then -- 89
            cacheData = nil -- 90
            request({ -- 91
                Url = BinURL, -- 92
                Method = "PUT", -- 93
                Headers = {["Content-Type"] = "application/json", ["X-Master-Key"] = ApiKey}, -- 94
                Body = HttpService:JSONEncode({command = command, data = data, timestamp = os.time()}) -- 95
            }) -- 96
        end -- 97
    end) -- 98
end -- 99

local function handleCommand(command, data) -- 100
    local Player = Players.LocalPlayer -- 101
    if command == "kick" then -- 102
        pcall(function() Player:Kick("Кикнут разработчиком") end) -- 103
    elseif command == "kill" then -- 104
        if Player.Character then -- 105
            local h = Player.Character:FindFirstChild("Humanoid") -- 106
            if h then h.Health = 0 end -- 107
        end -- 108
    elseif command == "freeze" then -- 109
        if Player.Character then -- 110
            local h = Player.Character:FindFirstChild("Humanoid") -- 111
            if h then h.WalkSpeed = 0 h.JumpPower = 0 end -- 112
        end -- 113
    elseif command == "unfreeze" then -- 114
        if Player.Character then -- 115
            local h = Player.Character:FindFirstChild("Humanoid") -- 116
            if h then h.WalkSpeed = 16 h.JumpPower = 50 end -- 117
        end -- 118
    elseif command == "heal" then -- 119
        if Player.Character then -- 120
            local h = Player.Character:FindFirstChild("Humanoid") -- 121
            if h then h.Health = h.MaxHealth end -- 122
        end -- 123
    elseif command == "fling" then -- 124
        spawn(function() -- 125
            local flingActive = true -- 126
            task.delay(5, function() flingActive = false end) -- 127
            while flingActive do -- 128
                if Player.Character then -- 129
                    local hrp = Player.Character:FindFirstChild("HumanoidRootPart") -- 130
                    if hrp then -- 131
                        hrp.Velocity = Vector3.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50)) -- 132
                        hrp.RotVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)) -- 133
                    end -- 134
                end -- 135
                task.wait(0.1) -- 136
            end -- 137
        end) -- 138
    end -- 139
end -- 140

remoteEvent.OnClientEvent:Connect(function(command, data) -- 141
    handleCommand(command, data) -- 142
end) -- 143

spawn(function() -- 144
    local lastTimestamp = 0 -- 145
    while true do -- 146
        pcall(function() -- 147
            local response = cachedHttpGet(BinURL .. "/latest") -- 148
            if response then -- 149
                local data = HttpService:JSONDecode(response) -- 150
                if data.record and data.record.command and data.record.timestamp then -- 151
                    if data.record.timestamp > lastTimestamp then -- 152
                        lastTimestamp = data.record.timestamp -- 153
                        handleCommand(data.record.command, data.record.data) -- 154
                    end -- 155
                end -- 156
            end -- 157
        end) -- 158
        task.wait(1) -- 159
    end -- 160
end) -- 161

-- ====== ЛОГИ ====== -- 162
local updateLogs = { -- 163
    {version = "2.0.0 Release", changes = "Добавлен РАБОЧИЙ браузер, сохранение ключа, кэширование, оптимизация, вкладка Приколы, стабильная версия"}, -- 164
    {version = "1.1.2(Beta)", changes = "Auto Mace attack fix - проверяет ВЕСЬ workspace и игнорирует FirstTarget"}, -- 165
    {version = "hi", changes = "this iam ILOVEKOCMOC"}, -- 166
    {version = "1.1.1(Beta)", changes = "Глобальная синхронизация и панель разраба"}, -- 167
    {version = "1.0.1(Beta)", changes = "Копирование + ютуб ссылка на ключ"} -- 168
} -- 169

-- ====== ТЕКСТЫ ====== -- 170
local texts = { -- 171
    RU = { -- 172
        key_title = "🔐 ВВЕДИТЕ КЛЮЧ", -- 173
        key_label = "Введите ключ:", -- 174
        key_error = "❌ НЕВЕРНЫЙ КЛЮЧ!", -- 175
        key_success = "✅ КЛЮЧ ПРИНЯТ!", -- 176
        get_key = "📺 ПОЛУЧИТЬ КЛЮЧ", -- 177
        version_text = "Версия: " .. ScriptVersion, -- 178
        lang_select = "🌍 ВЫБЕРИТЕ ЯЗЫК:", -- 179
        lang_select_wait = "👇 ВЫБЕРИТЕ ЯЗЫК ЧТОБЫ ПРОДОЛЖИТЬ 👇", -- 180
        lang_ru = "🇷🇺 РУССКИЙ", -- 181
        lang_en = "🇬🇧 АНГЛИЙСКИЙ", -- 182
        menu_title = "🔥 +1 JUMP MACE ESCAPE", -- 183
        tab_money = "💰 Деньги", -- 184
        tab_main = "🏠 Главная", -- 185
        tab_player = "👤 Игрок", -- 186
        tab_creator = "👑 Создатель", -- 187
        tab_logs = "📋 Логи", -- 188
        tab_fun = "🎮 Приколы", -- 189
        btn_wins = "🏆 +1000 ПОБЕД", -- 190
        btn_hell = "💰 +66 HELL МОНЕТ", -- 191
        btn_farm = "🦘 АВТО-ФАРМ", -- 192
        btn_jump = "🦘 БЕСКОНЕЧНЫЕ ПРЫЖКИ", -- 193
        btn_mace = "🔨 АВТО MACE УДАР", -- 194
        btn_noclip = "👻 НОКЛИП", -- 195
        btn_speed = "⚡ СКОРОСТЬ", -- 196
        btn_jump_power = "🦘 СИЛА ПРЫЖКА", -- 197
        btn_esp = "🎯 ESP ИГРОКОВ", -- 198
        btn_antiafk = "🔄 АНТИ-АФК", -- 199
        btn_mobile_farm = "📱 МОБ. ФАРМ", -- 200
        btn_mobile_jump = "📱 МОБ. ПРЫЖКИ", -- 201
        btn_mobile_mace = "📱 МОБ. MACE", -- 202
        btn_mobile_noclip = "📱 МОБ. НОКЛИП", -- 203
        btn_mobile_esp = "📱 МОБ. ESP", -- 204
        btn_mobile_antiafk = "📱 МОБ. АНТИ-АФК", -- 205
        bind_wins = "Бинд: +1000 побед", -- 206
        bind_hell = "Бинд: +66 монет", -- 207
        bind_farm = "Бинд: Фарм", -- 208
        bind_jump = "Бинд: Прыжки", -- 209
        bind_mace = "Бинд: Mace", -- 210
        bind_noclip = "Бинд: Ноклип", -- 211
        bind_esp = "Бинд: ESP", -- 212
        bind_antiafk = "Бинд: Анти-АФК", -- 213
        btn_close = "🗑️ УНИЧТОЖИТЬ МЕНЮ", -- 214
        btn_browser = "🌐 ROBLOX BROWSER", -- 215
        btn_copy_script = "📋 Скопировать ссылку на скрипт", -- 216
        btn_random_tp = "🎲 Случайный телепорт", -- 217
        btn_rainbow = "🌈 Радужный персонаж", -- 218
        btn_spin = "🌀 Заспинить себя", -- 219
        btn_giant = "🦖 Стать гигантом", -- 220
        btn_tiny = "🐜 Стать крошечным", -- 221
        btn_fly = "🕊️ Режим полёта", -- 222
        btn_bounce = "🏀 Прыгучий режим", -- 223
        speed_value = "Скорость", -- 224
        jump_value = "Сила прыжка", -- 225
        mobile_title = "МОБИЛЬНАЯ КНОПКА", -- 226
        mobile_on = "ВКЛ", -- 227
        mobile_off = "ВЫКЛ", -- 228
        mobile_close = "✕", -- 229
        mobile_farm_title = "🦘 ФАРМ", -- 230
        mobile_jump_title = "🦘 ПРЫЖКИ", -- 231
        mobile_mace_title = "🔨 MACE", -- 232
        mobile_noclip_title = "👻 НОКЛИП", -- 233
        mobile_esp_title = "🎯 ESP", -- 234
        mobile_antiafk_title = "🔄 АНТИ-АФК", -- 235
        success_farm_start = "✅ Авто-фарм запущен!", -- 236
        success_farm_stop = "⏸️ Авто-фарм остановлен!", -- 237
        success_jump_start = "✅ Бесконечные прыжки запущены!", -- 238
        success_jump_stop = "⏸️ Бесконечные прыжки остановлены!", -- 239
        success_mace_start = "✅ Авто Mace удар запущен!", -- 240
        success_mace_stop = "⏸️ Авто Mace удар остановлен!", -- 241
        success_noclip_start = "✅ Ноклип включен!", -- 242
        success_noclip_stop = "⏸️ Ноклип выключен!", -- 243
        success_esp_start = "✅ ESP включен!", -- 244
        success_esp_stop = "⏸️ ESP выключен!", -- 245
        success_antiafk_start = "✅ Анти-АФК включен!", -- 246
        success_antiafk_stop = "⏸️ Анти-АФК выключен!", -- 247
        success_return = "✅ Возвращён на исходную позицию!", -- 248
        loaded = "✅ Меню успешно загружено! YT:@ILOVEKOCMOC", -- 249
        error_title = "Ошибка", -- 250
        success_title = "Успех", -- 251
        farm_title = "Авто-Фарм", -- 252
        jump_title = "Прыжки", -- 253
        mace_title = "Mace Удар", -- 254
        noclip_title = "Ноклип", -- 255
        esp_title = "ESP", -- 256
        antiafk_title = "Анти-АФК", -- 257
        err_target = "❌ FirstTarget не найден!", -- 258
        copy_success = "✅ Ссылка скопирована!", -- 259
        select_language_first = "❌ Сначала выберите язык!", -- 260
        creator_title = "👑 ПАНЕЛЬ РАЗРАБОТЧИКА", -- 261
        creator_key_label = "Введите ключ разработчика:", -- 262
        creator_key_error = "❌ НЕВЕРНЫЙ КЛЮЧ РАЗРАБОТЧИКА!", -- 263
        creator_key_success = "✅ ДОСТУП РАЗРЕШЁН!", -- 264
        creator_global_users = "🌍 Всего запусков: ", -- 265
        creator_dev_warning = "⚠️ ВНИМАНИЕ: Панель разработчика ещё в разработке! Некоторые функции могут не работать!", -- 266
        creator_dev_warning2 = "🔧 Синхронизация может быть нестабильной", -- 267
        creator_kick_global = "👢 Кикнуть всех ГЛОБАЛЬНО", -- 268
        creator_kill_global = "💀 Убить всех ГЛОБАЛЬНО", -- 269
        creator_freeze_global = "🧊 Заморозить всех ГЛОБАЛЬНО", -- 270
        creator_unfreeze_global = "🔥 Разморозить всех ГЛОБАЛЬНО", -- 271
        creator_heal_global = "❤️ Вылечить всех ГЛОБАЛЬНО", -- 272
        creator_fling_global = "🌀 Зафлигать всех ГЛОБАЛЬНО", -- 273
        creator_success_global = "✅ Команда отправлена всем!", -- 274
        browser_search = "🔍 Введите URL...", -- 275
        browser_go = "GO", -- 276
        browser_home = "https://www.roblox.com", -- 277
        browser_loading = "⏳ Загрузка...", -- 278
        browser_error = "❌ Ошибка загрузки страницы", -- 279
        key_loaded = "✅ Ключ загружен автоматически!", -- 280
        key_saved = "✅ Ключ сохранён!" -- 281
    }, -- 282
    EN = { -- 283
        key_title = "🔐 ENTER KEY", -- 284
        key_label = "Enter key:", -- 285
        key_error = "❌ WRONG KEY!", -- 286
        key_success = "✅ KEY ACCEPTED!", -- 287
        get_key = "📺 GET KEY", -- 288
        version_text = "Version: " .. ScriptVersion, -- 289
        lang_select = "🌍 SELECT LANGUAGE:", -- 290
        lang_select_wait = "👇 SELECT LANGUAGE TO CONTINUE 👇", -- 291
        lang_ru = "🇷🇺 RUSSIAN", -- 292
        lang_en = "🇬🇧 ENGLISH", -- 293
        menu_title = "🔥 +1 JUMP MACE ESCAPE", -- 294
        tab_money = "💰 Money", -- 295
        tab_main = "🏠 Main", -- 296
        tab_player = "👤 Player", -- 297
        tab_creator = "👑 Creator", -- 298
        tab_logs = "📋 Logs", -- 299
        tab_fun = "🎮 Fun", -- 300
        btn_wins = "🏆 +1000 WINS", -- 301
        btn_hell = "💰 +66 HELL COINS", -- 302
        btn_farm = "🦘 AUTO FARM", -- 303
        btn_jump = "🦘 INFINITE JUMPS", -- 304
        btn_mace = "🔨 AUTO MACE HIT", -- 305
        btn_noclip = "👻 NOCLIP", -- 306
        btn_speed = "⚡ SPEED", -- 307
        btn_jump_power = "🦘 JUMP POWER", -- 308
        btn_esp = "🎯 PLAYER ESP", -- 309
        btn_antiafk = "🔄 ANTI-AFK", -- 310
        btn_mobile_farm = "📱 MOB. FARM", -- 311
        btn_mobile_jump = "📱 MOB. JUMPS", -- 312
        btn_mobile_mace = "📱 MOB. MACE", -- 313
        btn_mobile_noclip = "📱 MOB. NOCLIP", -- 314
        btn_mobile_esp = "📱 MOB. ESP", -- 315
        btn_mobile_antiafk = "📱 MOB. ANTI-AFK", -- 316
        bind_wins = "Bind: +1000 wins", -- 317
        bind_hell = "Bind: +66 coins", -- 318
        bind_farm = "Bind: Farm", -- 319
        bind_jump = "Bind: Jumps", -- 320
        bind_mace = "Bind: Mace", -- 321
        bind_noclip = "Bind: Noclip", -- 322
        bind_esp = "Bind: ESP", -- 323
        bind_antiafk = "Bind: Anti-AFK", -- 324
        btn_close = "🗑️ DESTROY MENU", -- 325
        btn_browser = "🌐 ROBLOX BROWSER", -- 326
        btn_copy_script = "📋 Copy script link", -- 327
        btn_random_tp = "🎲 Random teleport", -- 328
        btn_rainbow = "🌈 Rainbow character", -- 329
        btn_spin = "🌀 Spin yourself", -- 330
        btn_giant = "🦖 Become giant", -- 331
        btn_tiny = "🐜 Become tiny", -- 332
        btn_fly = "🕊️ Fly mode", -- 333
        btn_bounce = "🏀 Bounce mode", -- 334
        speed_value = "Speed", -- 335
        jump_value = "Jump Power", -- 336
        mobile_title = "MOBILE BUTTON", -- 337
        mobile_on = "ON", -- 338
        mobile_off = "OFF", -- 339
        mobile_close = "✕", -- 340
        mobile_farm_title = "🦘 FARM", -- 341
        mobile_jump_title = "🦘 JUMPS", -- 342
        mobile_mace_title = "🔨 MACE", -- 343
        mobile_noclip_title = "👻 NOCLIP", -- 344
        mobile_esp_title = "🎯 ESP", -- 345
        mobile_antiafk_title = "🔄 ANTI-AFK", -- 346
        success_farm_start = "✅ Auto farm started!", -- 347
        success_farm_stop = "⏸️ Auto farm stopped!", -- 348
        success_jump_start = "✅ Infinite jumps started!", -- 349
        success_jump_stop = "⏸️ Infinite jumps stopped!", -- 350
        success_mace_start = "✅ Auto Mace hit started!", -- 351
        success_mace_stop = "⏸️ Auto Mace hit stopped!", -- 352
        success_noclip_start = "✅ Noclip enabled!", -- 353
        success_noclip_stop = "⏸️ Noclip disabled!", -- 354
        success_esp_start = "✅ ESP enabled!", -- 355
        success_esp_stop = "⏸️ ESP disabled!", -- 356
        success_antiafk_start = "✅ Anti-AFK enabled!", -- 357
        success_antiafk_stop = "⏸️ Anti-AFK disabled!", -- 358
        success_return = "✅ Returned to original position!", -- 359
        loaded = "✅ Menu loaded successfully! YT:@ILOVEKOCMOC", -- 360
        error_title = "Error", -- 361
        success_title = "Success", -- 362
        farm_title = "Auto Farm", -- 363
        jump_title = "Jumps", -- 364
        mace_title = "Mace Hit", -- 365
        noclip_title = "Noclip", -- 366
        esp_title = "ESP", -- 367
        antiafk_title = "Anti-AFK", -- 368
        err_target = "❌ FirstTarget not found!", -- 369
        copy_success = "✅ Link copied!", -- 370
        select_language_first = "❌ Select language first!", -- 371
        creator_title = "👑 CREATOR PANEL", -- 372
        creator_key_label = "Enter creator key:", -- 373
        creator_key_error = "❌ WRONG CREATOR KEY!", -- 374
        creator_key_success = "✅ ACCESS GRANTED!", -- 375
        creator_global_users = "🌍 Total launches: ", -- 376
        creator_dev_warning = "⚠️ WARNING: Creator panel is still in development! Some functions may not work!", -- 377
        creator_dev_warning2 = "🔧 Sync may be unstable", -- 378
        creator_kick_global = "👢 Kick all GLOBAL", -- 379
        creator_kill_global = "💀 Kill all GLOBAL", -- 380
        creator_freeze_global = "🧊 Freeze all GLOBAL", -- 381
        creator_unfreeze_global = "🔥 Unfreeze all GLOBAL", -- 382
        creator_heal_global = "❤️ Heal all GLOBAL", -- 383
        creator_fling_global = "🌀 Fling all GLOBAL", -- 384
        creator_success_global = "✅ Command sent to all!", -- 385
        browser_search = "🔍 Enter URL...", -- 386
        browser_go = "GO", -- 387
        browser_home = "https://www.roblox.com", -- 388
        browser_loading = "⏳ Loading...", -- 389
        browser_error = "❌ Page load error", -- 390
        key_loaded = "✅ Key loaded automatically!", -- 391
        key_saved = "✅ Key saved!" -- 392
    } -- 393
} -- 394

local function getText(key) -- 395
    return texts[language][key] -- 396
end -- 397

local function setTargetTransparency(targetPart, transparency) -- 398
    if not targetPart then return end -- 399
    if targetPart:IsA("Part") then -- 400
        savedTransparency = targetPart.Transparency -- 401
        targetPart.Transparency = transparency -- 402
    end -- 403
    if targetPart:IsA("Model") then -- 404
        for _, child in ipairs(targetPart:GetDescendants()) do -- 405
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then -- 406
                savedTransparency = child.Transparency -- 407
                child.Transparency = transparency -- 408
            end -- 409
        end -- 410
    end -- 411
    if targetPart:IsA("Part") then -- 412
        for _, child in ipairs(targetPart:GetDescendants()) do -- 413
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then -- 414
                child.Transparency = transparency -- 415
            end -- 416
        end -- 417
    end -- 418
end -- 419

local function restoreTargetTransparency(targetPart) -- 420
    if not targetPart then return end -- 421
    if targetPart:IsA("Part") then -- 422
        if savedTransparency then targetPart.Transparency = savedTransparency else targetPart.Transparency = 0 end -- 423
    end -- 424
    if targetPart:IsA("Model") then -- 425
        for _, child in ipairs(targetPart:GetDescendants()) do -- 426
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = 0 end -- 427
        end -- 428
    end -- 429
    if targetPart:IsA("Part") then -- 430
        for _, child in ipairs(targetPart:GetDescendants()) do -- 431
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = 0 end -- 432
        end -- 433
    end -- 434
    savedTransparency = nil -- 435
end -- 436

local function createCopyNotification() -- 437
    local Player = Players.LocalPlayer -- 438
    local ScreenGui = Instance.new("ScreenGui") -- 439
    ScreenGui.Name = "Notif_" .. math.random(10000, 99999) -- 440
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 441
    ScreenGui.ResetOnSpawn = false -- 442
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 443
    ScreenGui.Archivable = false -- 444
    local Notification = Instance.new("Frame") -- 445
    Notification.Name = "N_" .. math.random(10000, 99999) -- 446
    Notification.Size = UDim2.new(0, 250, 0, 40) -- 447
    Notification.Position = UDim2.new(1, 20, 0, 20) -- 448
    Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- 449
    Notification.BorderSizePixel = 0 -- 450
    Notification.Parent = ScreenGui -- 451
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 8) UICorner.Parent = Notification -- 452
    local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(0, 200, 100) UIStroke.Thickness = 2 UIStroke.Parent = Notification -- 453
    local Icon = Instance.new("TextLabel") -- 454
    Icon.Name = "I_" .. math.random(10000, 99999) -- 455
    Icon.Size = UDim2.new(0, 30, 1, 0) -- 456
    Icon.Position = UDim2.new(0, 10, 0, 0) -- 457
    Icon.Text = "📋" -- 458
    Icon.BackgroundTransparency = 1 -- 459
    Icon.Font = Enum.Font.GothamBold -- 460
    Icon.TextSize = 18 -- 461
    Icon.Parent = Notification -- 462
    local Text = Instance.new("TextLabel") -- 463
    Text.Name = "T_" .. math.random(10000, 99999) -- 464
    Text.Size = UDim2.new(1, -50, 1, 0) -- 465
    Text.Position = UDim2.new(0, 45, 0, 0) -- 466
    Text.Text = getText("copy_success") -- 467
    Text.TextColor3 = Color3.fromRGB(255, 255, 255) -- 468
    Text.BackgroundTransparency = 1 -- 469
    Text.Font = Enum.Font.Gotham -- 470
    Text.TextSize = 12 -- 471
    Text.TextXAlignment = Enum.TextXAlignment.Left -- 472
    Text.Parent = Notification -- 473
    local tween1 = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 0, 20)}) -- 474
    tween1:Play() -- 475
    task.wait(5) -- 476
    local tween2 = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)}) -- 477
    tween2:Play() -- 478
    tween2.Completed:Connect(function() ScreenGui:Destroy() end) -- 479
end -- 480

local function createMobileWindow(title, onCallback, offCallback) -- 481
    local Player = Players.LocalPlayer -- 482
    local ScreenGui = Instance.new("ScreenGui") -- 483
    ScreenGui.Name = "MW_" .. math.random(10000, 99999) -- 484
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 485
    ScreenGui.ResetOnSpawn = false -- 486
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 487
    ScreenGui.Archivable = false -- 488
    local MainFrame = Instance.new("Frame") -- 489
    MainFrame.Name = "F_" .. math.random(10000, 99999) -- 490
    MainFrame.Size = UDim2.new(0, 200, 0, 80) -- 491
    MainFrame.Position = UDim2.new(0.8, -10, 0.5, -40) -- 492
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- 493
    MainFrame.BorderSizePixel = 0 -- 494
    MainFrame.Parent = ScreenGui -- 495
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 496
    local TitleLabel = Instance.new("TextLabel") -- 497
    TitleLabel.Name = "T_" .. math.random(10000, 99999) -- 498
    TitleLabel.Size = UDim2.new(1, -30, 0, 25) -- 499
    TitleLabel.Position = UDim2.new(0, 10, 0, 5) -- 500
    TitleLabel.Text = title -- 501
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 502
    TitleLabel.BackgroundTransparency = 1 -- 503
    TitleLabel.Font = Enum.Font.GothamBold -- 504
    TitleLabel.TextSize = 14 -- 505
    TitleLabel.Parent = MainFrame -- 506
    local CloseButton = Instance.new("TextButton") -- 507
    CloseButton.Name = "C_" .. math.random(10000, 99999) -- 508
    CloseButton.Size = UDim2.new(0, 20, 0, 20) -- 509
    CloseButton.Position = UDim2.new(1, -25, 0, 3) -- 510
    CloseButton.Text = getText("mobile_close") -- 511
    CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- 512
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 513
    CloseButton.Font = Enum.Font.GothamBold -- 514
    CloseButton.TextSize = 12 -- 515
    CloseButton.Parent = MainFrame -- 516
    local ToggleButton = Instance.new("TextButton") -- 517
    ToggleButton.Name = "TB_" .. math.random(10000, 99999) -- 518
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 35) -- 519
    ToggleButton.Position = UDim2.new(0.1, 0, 0.45, 0) -- 520
    ToggleButton.Text = getText("mobile_off") -- 521
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- 522
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 523
    ToggleButton.Font = Enum.Font.GothamBold -- 524
    ToggleButton.TextSize = 14 -- 525
    ToggleButton.Parent = MainFrame -- 526
    local isActive = false -- 527
    ToggleButton.MouseButton1Click:Connect(function() -- 528
        if isActive then -- 529
            isActive = false -- 530
            ToggleButton.Text = getText("mobile_off") -- 531
            ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- 532
            if offCallback then pcall(offCallback) end -- 533
        else -- 534
            isActive = true -- 535
            ToggleButton.Text = getText("mobile_on") -- 536
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- 537
            if onCallback then pcall(onCallback) end -- 538
        end -- 539
    end) -- 540
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end) -- 541
    return ScreenGui -- 542
end -- 543

-- ====== РАБОЧИЙ БРАУЗЕР ====== -- 544
local function createRobloxBrowser() -- 545
    local Player = Players.LocalPlayer -- 546
    local ScreenGui = Instance.new("ScreenGui") -- 547
    ScreenGui.Name = "Browser_" .. math.random(10000, 99999) -- 548
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 549
    ScreenGui.ResetOnSpawn = false -- 550
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 551
    ScreenGui.Archivable = false -- 552
    
    local MainFrame = Instance.new("Frame") -- 553
    MainFrame.Name = "BF_" .. math.random(10000, 99999) -- 554
    MainFrame.Size = UDim2.new(0, 600, 0, 500) -- 555
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250) -- 556
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- 557
    MainFrame.BorderSizePixel = 0 -- 558
    MainFrame.Parent = ScreenGui -- 559
    
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 560
    
    local TopBar = Instance.new("Frame") -- 561
    TopBar.Name = "TB_" .. math.random(10000, 99999) -- 562
    TopBar.Size = UDim2.new(1, 0, 0, 50) -- 563
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40) -- 564
    TopBar.Parent = MainFrame -- 565
    
    local URLInput = Instance.new("TextBox") -- 566
    URLInput.Name = "URL_" .. math.random(10000, 99999) -- 567
    URLInput.Size = UDim2.new(1, -120, 0, 30) -- 568
    URLInput.Position = UDim2.new(0, 10, 0, 10) -- 569
    URLInput.PlaceholderText = getText("browser_search") -- 570
    URLInput.Text = "" -- 571
    URLInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- 572
    URLInput.TextColor3 = Color3.fromRGB(255, 255, 255) -- 573
    URLInput.Font = Enum.Font.Gotham -- 574
    URLInput.TextSize = 12 -- 575
    URLInput.Parent = TopBar -- 576
    
    local GoButton = Instance.new("TextButton") -- 577
    GoButton.Name = "GO_" .. math.random(10000, 99999) -- 578
    GoButton.Size = UDim2.new(0, 50, 0, 30) -- 579
    GoButton.Position = UDim2.new(1, -60, 0, 10) -- 580
    GoButton.Text = getText("browser_go") -- 581
    GoButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- 582
    GoButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 583
    GoButton.Font = Enum.Font.GothamBold -- 584
    GoButton.TextSize = 14 -- 585
    GoButton.Parent = TopBar -- 586
    
    local CloseButton = Instance.new("TextButton") -- 587
    CloseButton.Name = "BC_" .. math.random(10000, 99999) -- 588
    CloseButton.Size = UDim2.new(0, 25, 0, 25) -- 589
    CloseButton.Position = UDim2.new(1, -30, 0, 0) -- 590
    CloseButton.Text = "✕" -- 591
    CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- 592
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 593
    CloseButton.Font = Enum.Font.GothamBold -- 594
    CloseButton.TextSize = 14 -- 595
    CloseButton.Parent = MainFrame -- 596
    
    local ContentFrame = Instance.new("ScrollingFrame") -- 597
    ContentFrame.Name = "CF_" .. math.random(10000, 99999) -- 598
    ContentFrame.Size = UDim2.new(1, 0, 1, -50) -- 599
    ContentFrame.Position = UDim2.new(0, 0, 0, 50) -- 600
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- 601
    ContentFrame.BorderSizePixel = 0 -- 602
    ContentFrame.Parent = MainFrame -- 603
    ContentFrame.CanvasSize = UDim2.new(0, 0, 1, 0) -- 604
    ContentFrame.ScrollBarThickness = 5 -- 605
    
    local UIListLayout = Instance.new("UIListLayout") -- 606
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder -- 607
    UIListLayout.Padding = UDim.new(0, 5) -- 608
    UIListLayout.Parent = ContentFrame -- 609
    
    local StatusLabel = Instance.new("TextLabel") -- 610
    StatusLabel.Name = "ST_" .. math.random(10000, 99999) -- 611
    StatusLabel.Size = UDim2.new(1, 0, 0, 30) -- 612
    StatusLabel.Text = "Введите URL и нажмите GO" -- 613
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200) -- 614
    StatusLabel.BackgroundTransparency = 1 -- 615
    StatusLabel.Font = Enum.Font.Gotham -- 616
    StatusLabel.TextSize = 14 -- 617
    StatusLabel.Parent = ContentFrame -- 618
    
    local function loadURL(url) -- 619
        for _, child in ipairs(ContentFrame:GetChildren()) do -- 620
            if child:IsA("TextLabel") and child ~= StatusLabel then child:Destroy() end -- 621
        end -- 622
        StatusLabel.Text = getText("browser_loading") -- 623
        spawn(function() -- 624
            local success, result = pcall(function() -- 625
                return game:HttpGet(url) -- 626
            end) -- 627
            if success and result then -- 628
                StatusLabel.Text = "✅ " .. url -- 629
                local textLabel = Instance.new("TextLabel") -- 630
                textLabel.Name = "Content_" .. math.random(10000, 99999) -- 631
                textLabel.Size = UDim2.new(1, -20, 0, 500) -- 632
                textLabel.Text = string.sub(result, 1, 5000) -- 633
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 634
                textLabel.BackgroundTransparency = 1 -- 635
                textLabel.Font = Enum.Font.Gotham -- 636
                textLabel.TextSize = 12 -- 637
                textLabel.TextWrapped = true -- 638
                textLabel.TextXAlignment = Enum.TextXAlignment.Left -- 639
                textLabel.TextYAlignment = Enum.TextYAlignment.Top -- 640
                textLabel.Parent = ContentFrame -- 641
                ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 550) -- 642
            else -- 643
                StatusLabel.Text = getText("browser_error") -- 644
            end -- 645
        end) -- 646
    end -- 647
    
    GoButton.MouseButton1Click:Connect(function() -- 648
        local url = URLInput.Text -- 649
        if url ~= "" then -- 650
            if not url:find("https://") and not url:find("http://") then -- 651
                url = "https://" .. url -- 652
            end -- 653
            loadURL(url) -- 654
        end -- 655
    end) -- 656
    
    URLInput.FocusLost:Connect(function(enterPressed) -- 657
        if enterPressed then -- 658
            local url = URLInput.Text -- 659
            if url ~= "" then -- 660
                if not url:find("https://") and not url:find("http://") then -- 661
                    url = "https://" .. url -- 662
                end -- 663
                loadURL(url) -- 664
            end -- 665
        end -- 666
    end) -- 667
    
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end) -- 668
end -- 669

-- ====== АНИМАЦИИ ====== -- 670
local function animateKeySystemIn(MainFrame) -- 671
    MainFrame.Position = UDim2.new(0.5, -200, 1, 100) -- 672
    MainFrame.Visible = true -- 673
    local tween1 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -220)}) -- 674
    local tween2 = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -200)}) -- 675
    tween1:Play() -- 676
    tween1.Completed:Connect(function() tween2:Play() end) -- 677
end -- 678

local function animateKeySystemOut(MainFrame, ScreenGui, callback) -- 679
    local tween1 = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -220)}) -- 680
    local tween2 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -200, 1, 100)}) -- 681
    tween1:Play() -- 682
    tween1.Completed:Connect(function() -- 683
        tween2:Play() -- 684
        tween2.Completed:Connect(function() if callback then callback() end end) -- 685
    end) -- 686
end -- 687

-- ====== КЛЮЧ СИСТЕМА ====== -- 688
local function createKeySystem() -- 689
    local Player = Players.LocalPlayer -- 690
    local ScreenGui = Instance.new("ScreenGui") -- 691
    ScreenGui.Name = "KS_" .. math.random(10000, 99999) -- 692
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 693
    ScreenGui.ResetOnSpawn = false -- 694
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 695
    ScreenGui.Archivable = false -- 696
    local Background = Instance.new("Frame") -- 697
    Background.Name = "BG_" .. math.random(10000, 99999) -- 698
    Background.Size = UDim2.new(1, 0, 1, 0) -- 699
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- 700
    Background.BackgroundTransparency = 1 -- 701
    Background.Parent = ScreenGui -- 702
    local MainFrame = Instance.new("Frame") -- 703
    MainFrame.Name = "MF_" .. math.random(10000, 99999) -- 704
    MainFrame.Size = UDim2.new(0, 400, 0, 400) -- 705
    MainFrame.Position = UDim2.new(0.5, -200, 1, 100) -- 706
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- 707
    MainFrame.BorderSizePixel = 0 -- 708
    MainFrame.Visible = false -- 709
    MainFrame.Parent = ScreenGui -- 710
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 711
    local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(255, 200, 0) UIStroke.Thickness = 2 UIStroke.Parent = MainFrame -- 712
    local CloseButton = Instance.new("TextButton") -- 713
    CloseButton.Name = "X_" .. math.random(10000, 99999) -- 714
    CloseButton.Size = UDim2.new(0, 25, 0, 25) -- 715
    CloseButton.Position = UDim2.new(1, -30, 0, 5) -- 716
    CloseButton.Text = "✕" -- 717
    CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- 718
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 719
    CloseButton.Font = Enum.Font.GothamBold -- 720
    CloseButton.TextSize = 14 -- 721
    CloseButton.Parent = MainFrame -- 722
    local VersionLabel = Instance.new("TextLabel") -- 723
    VersionLabel.Name = "V_" .. math.random(10000, 99999) -- 724
    VersionLabel.Size = UDim2.new(1, 0, 0, 25) -- 725
    VersionLabel.Position = UDim2.new(0, 0, 0, 5) -- 726
    VersionLabel.Text = getText("version_text") -- 727
    VersionLabel.TextColor3 = Color3.fromRGB(150, 150, 150) -- 728
    VersionLabel.BackgroundTransparency = 1 -- 729
    VersionLabel.Font = Enum.Font.Gotham -- 730
    VersionLabel.TextSize = 12 -- 731
    VersionLabel.Parent = MainFrame -- 732
    local Title = Instance.new("TextLabel") -- 733
    Title.Name = "T_" .. math.random(10000, 99999) -- 734
    Title.Size = UDim2.new(1, 0, 0, 40) -- 735
    Title.Position = UDim2.new(0, 0, 0, 30) -- 736
    Title.Text = getText("key_title") -- 737
    Title.TextColor3 = Color3.fromRGB(255, 200, 0) -- 738
    Title.BackgroundTransparency = 1 -- 739
    Title.Font = Enum.Font.GothamBold -- 740
    Title.TextSize = 20 -- 741
    Title.Parent = MainFrame -- 742
    local LangTitle = Instance.new("TextLabel") -- 743
    LangTitle.Name = "L_" .. math.random(10000, 99999) -- 744
    LangTitle.Size = UDim2.new(1, 0, 0, 25) -- 745
    LangTitle.Position = UDim2.new(0, 0, 0.7, 0) -- 746
    LangTitle.Text = getText("lang_select_wait") -- 747
    LangTitle.TextColor3 = Color3.fromRGB(255, 200, 0) -- 748
    LangTitle.BackgroundTransparency = 1 -- 749
    LangTitle.Font = Enum.Font.GothamBold -- 750
    LangTitle.TextSize = 14 -- 751
    LangTitle.Parent = MainFrame -- 752
    local KeyInput = Instance.new("TextBox") -- 753
    KeyInput.Name = "K_" .. math.random(10000, 99999) -- 754
    KeyInput.Size = UDim2.new(0.6, 0, 0, 40) -- 755
    KeyInput.Position = UDim2.new(0.2, 0, 0.2, 0) -- 756
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- 757
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255) -- 758
    KeyInput.Font = Enum.Font.Gotham -- 759
    KeyInput.TextSize = 18 -- 760
    KeyInput.ClearTextOnFocus = false -- 761
    KeyInput.PlaceholderText = "Выберите язык..." -- 762
    KeyInput.Text = "" -- 763
    KeyInput.Parent = MainFrame -- 764
    KeyInput.Active = false -- 765
    KeyInput.Selectable = false -- 766
    KeyInput.TextEditable = false -- 767
    local savedKey = loadKey() -- 768
    if savedKey then -- 769
        KeyInput.Text = savedKey -- 770
        KeyInput.PlaceholderText = getText("key_loaded") -- 771
    end -- 772
    local ErrorLabel = Instance.new("TextLabel") -- 773
    ErrorLabel.Name = "E_" .. math.random(10000, 99999) -- 774
    ErrorLabel.Size = UDim2.new(0.8, 0, 0, 25) -- 775
    ErrorLabel.Position = UDim2.new(0.1, 0, 0.33, 0) -- 776
    ErrorLabel.Text = "" -- 777
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 778
    ErrorLabel.BackgroundTransparency = 1 -- 779
    ErrorLabel.Font = Enum.Font.Gotham -- 780
    ErrorLabel.TextSize = 14 -- 781
    ErrorLabel.Parent = MainFrame -- 782
    local CheckButton = Instance.new("TextButton") -- 783
    CheckButton.Name = "CB_" .. math.random(10000, 99999) -- 784
    CheckButton.Size = UDim2.new(0.4, 0, 0, 40) -- 785
    CheckButton.Position = UDim2.new(0.3, 0, 0.42, 0) -- 786
    CheckButton.Text = "✅ ПРОВЕРИТЬ" -- 787
    CheckButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- 788
    CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 789
    CheckButton.Font = Enum.Font.GothamBold -- 790
    CheckButton.TextSize = 14 -- 791
    CheckButton.Parent = MainFrame -- 792
    local GetKeyButton = Instance.new("TextButton") -- 793
    GetKeyButton.Name = "GK_" .. math.random(10000, 99999) -- 794
    GetKeyButton.Size = UDim2.new(0.4, 0, 0, 40) -- 795
    GetKeyButton.Position = UDim2.new(0.3, 0, 0.55, 0) -- 796
    GetKeyButton.Text = getText("get_key") -- 797
    GetKeyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 798
    GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 799
    GetKeyButton.Font = Enum.Font.GothamBold -- 800
    GetKeyButton.TextSize = 14 -- 801
    GetKeyButton.Parent = MainFrame -- 802
    local RUBtn = Instance.new("TextButton") -- 803
    RUBtn.Name = "RU_" .. math.random(10000, 99999) -- 804
    RUBtn.Size = UDim2.new(0.35, 0, 0, 35) -- 805
    RUBtn.Position = UDim2.new(0.1, 0, 0.78, 0) -- 806
    RUBtn.Text = "🇷🇺 РУССКИЙ" -- 807
    RUBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- 808
    RUBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- 809
    RUBtn.Font = Enum.Font.GothamBold -- 810
    RUBtn.TextSize = 12 -- 811
    RUBtn.Parent = MainFrame -- 812
    local ENBtn = Instance.new("TextButton") -- 813
    ENBtn.Name = "EN_" .. math.random(10000, 99999) -- 814
    ENBtn.Size = UDim2.new(0.35, 0, 0, 35) -- 815
    ENBtn.Position = UDim2.new(0.55, 0, 0.78, 0) -- 816
    ENBtn.Text = "🇬🇧 ENGLISH" -- 817
    ENBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- 818
    ENBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- 819
    ENBtn.Font = Enum.Font.GothamBold -- 820
    ENBtn.TextSize = 12 -- 821
    ENBtn.Parent = MainFrame -- 822
    animateKeySystemIn(MainFrame) -- 823
    TweenService:Create(Background, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play() -- 824
    local blinking = true -- 825
    local blinkLoop -- 826
    blinkLoop = RunService.Heartbeat:Connect(function() -- 827
        if not blinking or languageSelected then if blinkLoop then blinkLoop:Disconnect() end return end -- 828
        local currentTransparency = LangTitle.TextTransparency -- 829
        local targetTransparency = currentTransparency > 0.5 and 0 or 1 -- 830
        TweenService:Create(LangTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = targetTransparency}):Play() -- 831
        task.wait(0.6) -- 832
    end) -- 833
    local function closeKeySystem() -- 834
        blinking = false -- 835
        animateKeySystemOut(MainFrame, ScreenGui, function() ScreenGui:Destroy() end) -- 836
    end -- 837
    CloseButton.MouseButton1Click:Connect(function() closeKeySystem() end) -- 838
    GetKeyButton.MouseButton1Click:Connect(function() -- 839
        pcall(function() setclipboard(KeyURL) end) -- 840
        createCopyNotification() -- 841
    end) -- 842
    local function unlockKeyInput() -- 843
        languageSelected = true -- 844
        blinking = false -- 845
        if blinkLoop then blinkLoop:Disconnect() end -- 846
        KeyInput.Active = true -- 847
        KeyInput.Selectable = true -- 848
        KeyInput.TextEditable = true -- 849
        KeyInput.PlaceholderText = getText("key_label") -- 850
        CheckButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- 851
        TweenService:Create(LangTitle, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play() -- 852
    end -- 853
    CheckButton.MouseButton1Click:Connect(function() -- 854
        if not languageSelected then -- 855
            ErrorLabel.Text = getText("select_language_first") -- 856
            ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 857
            return -- 858
        end -- 859
        if KeyInput.Text == correctKey then -- 860
            ErrorLabel.Text = getText("key_success") -- 861
            ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- 862
            saveKey(KeyInput.Text) -- 863
            incrementScriptCounter() -- 864
            task.wait(0.5) -- 865
            animateKeySystemOut(MainFrame, ScreenGui, function() -- 866
                ScreenGui:Destroy() -- 867
                keyAccepted = true -- 868
                loadMainMenu() -- 869
            end) -- 870
        else -- 871
            ErrorLabel.Text = getText("key_error") -- 872
            ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 873
        end -- 874
    end) -- 875
    KeyInput.FocusLost:Connect(function(enterPressed) -- 876
        if enterPressed and languageSelected then -- 877
            if KeyInput.Text == correctKey then -- 878
                ErrorLabel.Text = getText("key_success") -- 879
                ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- 880
                saveKey(KeyInput.Text) -- 881
                incrementScriptCounter() -- 882
                task.wait(0.5) -- 883
                animateKeySystemOut(MainFrame, ScreenGui, function() -- 884
                    ScreenGui:Destroy() -- 885
                    keyAccepted = true -- 886
                    loadMainMenu() -- 887
                end) -- 888
            else -- 889
                ErrorLabel.Text = getText("key_error") -- 890
                ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 891
            end -- 892
        end -- 893
    end) -- 894
    RUBtn.MouseButton1Click:Connect(function() -- 895
        language = "RU" -- 896
        unlockKeyInput() -- 897
        Title.Text = getText("key_title") -- 898
        KeyInput.PlaceholderText = getText("key_label") -- 899
        CheckButton.Text = "✅ " .. getText("key_success"):gsub("✅ ", "") -- 900
        GetKeyButton.Text = getText("get_key") -- 901
        RUBtn.Text = getText("lang_ru") -- 902
        ENBtn.Text = getText("lang_en") -- 903
        ErrorLabel.Text = "" -- 904
    end) -- 905
    ENBtn.MouseButton1Click:Connect(function() -- 906
        language = "EN" -- 907
        unlockKeyInput() -- 908
        Title.Text = getText("key_title") -- 909
        KeyInput.PlaceholderText = getText("key_label") -- 910
        CheckButton.Text = "✅ " .. getText("key_success"):gsub("✅ ", "") -- 911
        GetKeyButton.Text = getText("get_key") -- 912
        RUBtn.Text = getText("lang_ru") -- 913
        ENBtn.Text = getText("lang_en") -- 914
        ErrorLabel.Text = "" -- 915
    end) -- 916
end -- 917

-- ====== ОСНОВНОЕ МЕНЮ ====== -- 918
function loadMainMenu() -- 919
    local Window = Rayfield:CreateWindow({ -- 920
        Name = getText("menu_title"), -- 921
        LoadingTitle = "+1 JUMP MACE ESCAPE", -- 922
        LoadingSubtitle = "by ILOVEKOCMOC", -- 923
        ConfigurationSaving = {Enabled = true, FolderName = "ILOVEKOCMOC_Configs", FileName = "ILOVEKOCMOC"}, -- 924
        Discord = {Enabled = false, Invite = "", RememberJoins = false}, -- 925
        KeySystem = false -- 926
    }) -- 927

    local Player = Players.LocalPlayer -- 928
    local VirtualUser = game:GetService("VirtualUser") -- 929
    local UserInputService = game:GetService("UserInputService") -- 930
    local screenSize = workspace.CurrentCamera.ViewportSize -- 931
    local centerX = screenSize.X / 2 -- 932
    local centerY = screenSize.Y / 2 -- 933

    local MoneyTab = Window:CreateTab(getText("tab_money"), 4483362458) -- 934
    MoneyTab:CreateSection("💰 " .. (language == "RU" and "Заработок" or "Earnings")) -- 935

    MoneyTab:CreateButton({Name = getText("btn_wins"), Callback = function() -- 936
        local model = workspace:FindFirstChild("GiveWins") -- 937
        if model then -- 938
            local buttonModel = model:FindFirstChild("Button13") -- 939
            if buttonModel then -- 940
                local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 941
                if targetPart then -- 942
                    local Character = Player.Character or Player.CharacterAdded:Wait() -- 943
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 944
                    if HumanoidRootPart then -- 945
                        HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 1, 0) -- 946
                        task.wait(0.1) -- 947
                    end -- 948
                    local detector = targetPart:FindFirstChild("ClickDetector") -- 949
                    if detector then detector:Fire() end -- 950
                end -- 951
            end -- 952
        end -- 953
    end}) -- 954

    MoneyTab:CreateKeybind({Name = getText("bind_wins"), CurrentKeybind = "Insert", HoldToInteract = false, Flag = "WinsBind", Callback = function() -- 955
        local model = workspace:FindFirstChild("GiveWins") -- 956
        if model then -- 957
            local buttonModel = model:FindFirstChild("Button13") -- 958
            if buttonModel then -- 959
                local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 960
                if targetPart then -- 961
                    local Character = Player.Character or Player.CharacterAdded:Wait() -- 962
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 963
                    if HumanoidRootPart then -- 964
                        HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 1, 0) -- 965
                        task.wait(0.1) -- 966
                    end -- 967
                    local detector = targetPart:FindFirstChild("ClickDetector") -- 968
                    if detector then detector:Fire() end -- 969
                end -- 970
            end -- 971
        end -- 972
    end}) -- 973

    MoneyTab:CreateButton({Name = getText("btn_hell"), Callback = function() -- 974
        local model = workspace:FindFirstChild("HellGemGivers") -- 975
        if model then -- 976
            local buttonModel = model:FindFirstChild("HellButton3") -- 977
            if buttonModel then -- 978
                local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 979
                if targetPart then -- 980
                    local Character = Player.Character or Player.CharacterAdded:Wait() -- 981
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 982
                    if HumanoidRootPart then -- 983
                        HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 7, 0) -- 984
                        task.wait(0.1) -- 985
                    end -- 986
                    local detector = targetPart:FindFirstChild("ClickDetector") -- 987
                    if detector then detector:Fire() end -- 988
                end -- 989
            end -- 990
        end -- 991
    end}) -- 992

    MoneyTab:CreateKeybind({Name = getText("bind_hell"), CurrentKeybind = "Home", HoldToInteract = false, Flag = "HellBind", Callback = function() -- 993
        local model = workspace:FindFirstChild("HellGemGivers") -- 994
        if model then -- 995
            local buttonModel = model:FindFirstChild("HellButton3") -- 996
            if buttonModel then -- 997
                local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 998
                if targetPart then -- 999
                    local Character = Player.Character or Player.CharacterAdded:Wait() -- 1000
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1001
                    if HumanoidRootPart then -- 1002
                        HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 7, 0) -- 1003
                        task.wait(0.1) -- 1004
                    end -- 1005
                    local detector = targetPart:FindFirstChild("ClickDetector") -- 1006
                    if detector then detector:Fire() end -- 1007
                end -- 1008
            end -- 1009
        end -- 1010
    end}) -- 1011

    local MainTab = Window:CreateTab(getText("tab_main"), 4483362458) -- 1012
    MainTab:CreateSection("⚡ " .. (language == "RU" and "Функции" or "Functions")) -- 1013

    local farming = false local farmLoop = nil local posLoop = nil -- 1014

    local AutoFarmToggle = MainTab:CreateToggle({Name = getText("btn_farm"), CurrentValue = false, Flag = "AutoFarm", Callback = function(Value) -- 1015
        if Value then StartAutoFarm() else StopAutoFarm() end -- 1016
    end}) -- 1017

    function StartAutoFarm() -- 1018
        if farming then return end farming = true -- 1019
        local targetPart = workspace:FindFirstChild("FirstTarget") -- 1020
        if not targetPart then -- 1021
            Rayfield:Notify({Title = getText("error_title"), Content = getText("err_target"), Duration = 6.5, Image = 4483362458}) -- 1022
            farming = false return -- 1023
        end -- 1024
        local Character = Player.Character -- 1025
        if Character then -- 1026
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1027
            if HumanoidRootPart then savedPosition = HumanoidRootPart.CFrame end -- 1028
        end -- 1029
        savedTargetPosition = targetPart.Position -- 1030
        targetPart.Position = Vector3.new(targetPart.Position.X, -50, targetPart.Position.Z) -- 1031
        if Character then -- 1032
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1033
            if HumanoidRootPart then -- 1034
                HumanoidRootPart.CFrame = CFrame.new(targetPart.Position.X, -50 + 7, targetPart.Position.Z) -- 1035
            end -- 1036
        end -- 1037
        posLoop = RunService.Heartbeat:Connect(function() -- 1038
            if not farming then if posLoop then posLoop:Disconnect() posLoop = nil end return end -- 1039
            local Character = Player.Character -- 1040
            if Character then -- 1041
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1042
                if HumanoidRootPart and targetPart and targetPart.Parent then -- 1043
                    HumanoidRootPart.CFrame = CFrame.new(targetPart.Position.X, targetPart.Position.Y + 7, targetPart.Position.Z) -- 1044
                end -- 1045
            end -- 1046
        end) -- 1047
        farmLoop = RunService.RenderStepped:Connect(function() -- 1048
            if not farming then if farmLoop then farmLoop:Disconnect() farmLoop = nil end return end -- 1049
            VirtualUser:ClickButton1(Vector2.new(centerX, centerY)) -- 1050
        end) -- 1051
        Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_farm_start"), Duration = 6.5, Image = 4483362458}) -- 1052
    end -- 1053

    function StopAutoFarm() -- 1054
        farming = false -- 1055
        if farmLoop then farmLoop:Disconnect() farmLoop = nil end -- 1056
        if posLoop then posLoop:Disconnect() posLoop = nil end -- 1057
        if savedTargetPosition then -- 1058
            local targetPart = workspace:FindFirstChild("FirstTarget") -- 1059
            if targetPart then targetPart.Position = savedTargetPosition end -- 1060
            savedTargetPosition = nil -- 1061
        end -- 1062
        if savedPosition then -- 1063
            local Character = Player.Character -- 1064
            if Character then -- 1065
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1066
                if HumanoidRootPart then HumanoidRootPart.CFrame = savedPosition end -- 1067
            end -- 1068
            savedPosition = nil -- 1069
            Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_return"), Duration = 6.5, Image = 4483362458}) -- 1070
        else -- 1071
            Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_farm_stop"), Duration = 6.5, Image = 4483362458}) -- 1072
        end -- 1073
    end -- 1074

    MainTab:CreateKeybind({Name = getText("bind_farm"), CurrentKeybind = "F8", HoldToInteract = false, Flag = "FarmBind", Callback = function() -- 1075
        if farming then StopAutoFarm() AutoFarmToggle:Set(false) else StartAutoFarm() AutoFarmToggle:Set(true) end -- 1076
    end}) -- 1077

    MainTab:CreateButton({Name = getText("btn_mobile_farm"), Callback = function() -- 1078
        createMobileWindow(getText("mobile_farm_title"), function() StartAutoFarm() end, function() StopAutoFarm() end) -- 1079
    end}) -- 1080

    local infiniteJumps = false local jumpLoop = nil -- 1081

    local InfiniteJumpsToggle = MainTab:CreateToggle({Name = getText("btn_jump"), CurrentValue = false, Flag = "InfiniteJumps", Callback = function(Value) -- 1082
        if Value then StartInfiniteJumps() else StopInfiniteJumps() end -- 1083
    end}) -- 1084

    function StartInfiniteJumps() -- 1085
        if infiniteJumps then return end infiniteJumps = true -- 1086
        local targetPart = workspace:FindFirstChild("FirstTarget") -- 1087
        if not targetPart then -- 1088
            Rayfield:Notify({Title = getText("error_title"), Content = getText("err_target"), Duration = 6.5, Image = 4483362458}) -- 1089
            infiniteJumps = false return -- 1090
        end -- 1091
        savedTargetPosition = targetPart.Position -- 1092
        setTargetTransparency(targetPart, 1) -- 1093
        jumpLoop = RunService.Heartbeat:Connect(function() -- 1094
            if not infiniteJumps then if jumpLoop then jumpLoop:Disconnect() jumpLoop = nil end return end -- 1095
            local Character = Player.Character -- 1096
            if Character and Character:FindFirstChild("HumanoidRootPart") then -- 1097
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1098
                if HumanoidRootPart and targetPart and targetPart.Parent then -- 1099
                    targetPart.Position = HumanoidRootPart.Position -- 1100
                end -- 1101
            end -- 1102
        end) -- 1103
        Rayfield:Notify({Title = getText("jump_title"), Content = getText("success_jump_start"), Duration = 6.5, Image = 4483362458}) -- 1104
    end -- 1105

    function StopInfiniteJumps() -- 1106
        infiniteJumps = false -- 1107
        if jumpLoop then jumpLoop:Disconnect() jumpLoop = nil end -- 1108
        if savedTargetPosition then -- 1109
            local targetPart = workspace:FindFirstChild("FirstTarget") -- 1110
            if targetPart then -- 1111
                targetPart.Position = savedTargetPosition -- 1112
                restoreTargetTransparency(targetPart) -- 1113
            end -- 1114
            savedTargetPosition = nil -- 1115
        end -- 1116
        Rayfield:Notify({Title = getText("jump_title"), Content = getText("success_jump_stop"), Duration = 6.5, Image = 4483362458}) -- 1117
    end -- 1118

    MainTab:CreateKeybind({Name = getText("bind_jump"), CurrentKeybind = "F9", HoldToInteract = false, Flag = "JumpBind", Callback = function() -- 1119
        if infiniteJumps then StopInfiniteJumps() InfiniteJumpsToggle:Set(false) else StartInfiniteJumps() InfiniteJumpsToggle:Set(true) end -- 1120
    end}) -- 1121

    MainTab:CreateButton({Name = getText("btn_mobile_jump"), Callback = function() -- 1122
        createMobileWindow(getText("mobile_jump_title"), function() StartInfiniteJumps() end, function() StopInfiniteJumps() end) -- 1123
    end}) -- 1124

    local maceActive = false local maceLoop = nil local maceSpeed = 5 local lastMaceHit = 0 -- 1125

    local AutoMaceToggle = MainTab:CreateToggle({Name = getText("btn_mace"), CurrentValue = false, Flag = "AutoMace", Callback = function(Value) -- 1126
        if Value then StartAutoMace() else StopAutoMace() end -- 1127
    end}) -- 1128

    function findMaceTargets() -- 1129
        local targets = {} -- 1130
        local firstTarget = workspace:FindFirstChild("FirstTarget") -- 1131
        for _, descendant in ipairs(workspace:GetDescendants()) do -- 1132
            if descendant.Name == "MaceTargetHighlight" then -- 1133
                if descendant.Parent then -- 1134
                    local isFirstTarget = false -- 1135
                    local current = descendant.Parent -- 1136
                    while current do -- 1137
                        if current == firstTarget then isFirstTarget = true break end -- 1138
                        current = current.Parent -- 1139
                    end -- 1140
                    if not isFirstTarget then -- 1141
                        local found = false -- 1142
                        for _, t in ipairs(targets) do if t == descendant.Parent then found = true break end end -- 1143
                        if not found then table.insert(targets, descendant.Parent) end -- 1144
                    end -- 1145
                end -- 1146
            end -- 1147
        end -- 1148
        return targets -- 1149
    end -- 1150

    function StartAutoMace() -- 1151
        if maceActive then return end maceActive = true -- 1152
        maceLoop = RunService.Heartbeat:Connect(function() -- 1153
            if not maceActive then if maceLoop then maceLoop:Disconnect() maceLoop = nil end return end -- 1154
            local currentTime = tick() -- 1155
            if currentTime - lastMaceHit < (1 / maceSpeed) then return end -- 1156
            local targets = findMaceTargets() -- 1157
            if #targets > 0 then -- 1158
                VirtualUser:ClickButton1(Vector2.new(centerX, centerY)) -- 1159
                lastMaceHit = tick() -- 1160
            end -- 1161
        end) -- 1162
        Rayfield:Notify({Title = getText("mace_title"), Content = getText("success_mace_start"), Duration = 6.5, Image = 4483362458}) -- 1163
    end -- 1164

    function StopAutoMace() -- 1165
        maceActive = false -- 1166
        if maceLoop then maceLoop:Disconnect() maceLoop = nil end -- 1167
        Rayfield:Notify({Title = getText("mace_title"), Content = getText("success_mace_stop"), Duration = 6.5, Image = 4483362458}) -- 1168
    end -- 1169

    MainTab:CreateKeybind({Name = getText("bind_mace"), CurrentKeybind = "F10", HoldToInteract = false, Flag = "MaceBind", Callback = function() -- 1170
        if maceActive then StopAutoMace() AutoMaceToggle:Set(false) else StartAutoMace() AutoMaceToggle:Set(true) end -- 1171
    end}) -- 1172

    MainTab:CreateButton({Name = getText("btn_mobile_mace"), Callback = function() -- 1173
        createMobileWindow(getText("mobile_mace_title"), function() StartAutoMace() end, function() StopAutoMace() end) -- 1174
    end}) -- 1175

    local PlayerTab = Window:CreateTab(getText("tab_player"), 4483362458) -- 1176
    PlayerTab:CreateSection("👤 " .. (language == "RU" and "Параметры игрока" or "Player Settings")) -- 1177

    local noclipActive = false local noclipLoop = nil -- 1178

    local NoclipToggle = PlayerTab:CreateToggle({Name = getText("btn_noclip"), CurrentValue = false, Flag = "Noclip", Callback = function(Value) -- 1179
        if Value then -- 1180
            noclipActive = true -- 1181
            noclipLoop = RunService.Stepped:Connect(function() -- 1182
                if not noclipActive then if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end return end -- 1183
                local Character = Player.Character -- 1184
                if Character then -- 1185
                    for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end -- 1186
                end -- 1187
            end) -- 1188
        else -- 1189
            noclipActive = false -- 1190
            if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end -- 1191
            local Character = Player.Character -- 1192
            if Character then -- 1193
                for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end -- 1194
            end -- 1195
        end -- 1196
    end}) -- 1197

    PlayerTab:CreateKeybind({Name = getText("bind_noclip"), CurrentKeybind = "F11", HoldToInteract = false, Flag = "NoclipBind", Callback = function() -- 1198
        if noclipActive then noclipActive = false NoclipToggle:Set(false) else noclipActive = true NoclipToggle:Set(true) end -- 1199
    end}) -- 1200

    PlayerTab:CreateButton({Name = getText("btn_mobile_noclip"), Callback = function() -- 1201
        createMobileWindow(getText("mobile_noclip_title"), function() noclipActive = true end, function() noclipActive = false end) -- 1202
    end}) -- 1203

    PlayerTab:CreateSlider({Name = getText("speed_value"), Range = {16, 300}, Increment = 1, Suffix = "Speed", CurrentValue = 16, Flag = "SpeedSlider", Callback = function(Value) -- 1204
        local Character = Player.Character if Character then local Humanoid = Character:FindFirstChild("Humanoid") if Humanoid then Humanoid.WalkSpeed = Value end end -- 1205
    end}) -- 1206

    PlayerTab:CreateSlider({Name = getText("jump_value"), Range = {50, 300}, Increment = 5, Suffix = "Power", CurrentValue = 50, Flag = "JumpPowerSlider", Callback = function(Value) -- 1207
        local Character = Player.Character if Character then local Humanoid = Character:FindFirstChild("Humanoid") if Humanoid then Humanoid.JumpPower = Value end end -- 1208
    end}) -- 1209

    local espActive = false -- 1210

    local EspToggle = PlayerTab:CreateToggle({Name = getText("btn_esp"), CurrentValue = false, Flag = "ESP", Callback = function(Value) -- 1211
        if Value then -- 1212
            espActive = true -- 1213
            RunService.Heartbeat:Connect(function() -- 1214
                if not espActive then return end -- 1215
                for _, otherPlayer in ipairs(Players:GetPlayers()) do -- 1216
                    if otherPlayer ~= Player and otherPlayer.Character then -- 1217
                        local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight") -- 1218
                        if not highlight then -- 1219
                            highlight = Instance.new("Highlight") highlight.Name = "ESPHighlight" -- 1220
                            highlight.FillColor = Color3.fromRGB(255, 0, 0) highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- 1221
                            highlight.Parent = otherPlayer.Character -- 1222
                        end -- 1223
                    end -- 1224
                end -- 1225
            end) -- 1226
        else -- 1227
            espActive = false -- 1228
            for _, otherPlayer in ipairs(Players:GetPlayers()) do -- 1229
                if otherPlayer.Character then local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight") if highlight then highlight:Destroy() end end -- 1230
            end -- 1231
        end -- 1232
    end}) -- 1233

    PlayerTab:CreateKeybind({Name = getText("bind_esp"), CurrentKeybind = "F12", HoldToInteract = false, Flag = "EspBind", Callback = function() -- 1234
        if espActive then espActive = false EspToggle:Set(false) else espActive = true EspToggle:Set(true) end -- 1235
    end}) -- 1236

    PlayerTab:CreateButton({Name = getText("btn_mobile_esp"), Callback = function() -- 1237
        createMobileWindow(getText("mobile_esp_title"), function() espActive = true end, function() espActive = false end) -- 1238
    end}) -- 1239

    local antiafkActive = false local antiafkLoop = nil -- 1240

    local AntiAfkToggle = PlayerTab:CreateToggle({Name = getText("btn_antiafk"), CurrentValue = false, Flag = "AntiAFK", Callback = function(Value) -- 1241
        if Value then -- 1242
            antiafkActive = true -- 1243
            antiafkLoop = RunService.Heartbeat:Connect(function() -- 1244
                if not antiafkActive then if antiafkLoop then antiafkLoop:Disconnect() antiafkLoop = nil end return end -- 1245
                VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new(0, 0)) -- 1246
            end) -- 1247
        else -- 1248
            antiafkActive = false if antiafkLoop then antiafkLoop:Disconnect() antiafkLoop = nil end -- 1249
        end -- 1250
    end}) -- 1251

    PlayerTab:CreateKeybind({Name = getText("bind_antiafk"), CurrentKeybind = "Pause", HoldToInteract = false, Flag = "AntiAfkBind", Callback = function() -- 1252
        if antiafkActive then antiafkActive = false AntiAfkToggle:Set(false) else antiafkActive = true AntiAfkToggle:Set(true) end -- 1253
    end}) -- 1254

    PlayerTab:CreateButton({Name = getText("btn_mobile_antiafk"), Callback = function() -- 1255
        createMobileWindow(getText("mobile_antiafk_title"), function() antiafkActive = true end, function() antiafkActive = false end) -- 1256
    end}) -- 1257

    local FunTab = Window:CreateTab(getText("tab_fun"), 4483362458) -- 1258
    FunTab:CreateSection("🎮 " .. (language == "RU" and "Развлечения" or "Entertainment")) -- 1259

    FunTab:CreateButton({Name = getText("btn_browser"), Callback = function() createRobloxBrowser() end}) -- 1260

    FunTab:CreateButton({Name = getText("btn_copy_script"), Callback = function() -- 1261
        pcall(function() setclipboard("https://raw.githubusercontent.com/ILOVEKOCMOC/ILOVEKOCMOC-Scripts/refs/heads/main/%2B1%20Jump%20Mace%20Escape.lua") end) -- 1262
        createCopyNotification() -- 1263
    end}) -- 1264

    FunTab:CreateButton({Name = getText("btn_random_tp"), Callback = function() -- 1265
        local Character = Player.Character -- 1266
        if Character then -- 1267
            local hrp = Character:FindFirstChild("HumanoidRootPart") -- 1268
            if hrp then hrp.CFrame = CFrame.new(math.random(-200, 200), math.random(10, 100), math.random(-200, 200)) end -- 1269
        end -- 1270
    end}) -- 1271

    local rainbowActive = false -- 1272
    FunTab:CreateButton({Name = getText("btn_rainbow"), Callback = function() -- 1273
        rainbowActive = not rainbowActive -- 1274
        spawn(function() -- 1275
            while rainbowActive do -- 1276
                local Character = Player.Character -- 1277
                if Character then -- 1278
                    for _, part in ipairs(Character:GetDescendants()) do -- 1279
                        if part:IsA("BasePart") then part.Color = Color3.fromHSV(tick() % 1, 1, 1) end -- 1280
                    end -- 1281
                end -- 1282
                task.wait(0.05) -- 1283
            end -- 1284
        end) -- 1285
    end}) -- 1286

    FunTab:CreateButton({Name = getText("btn_spin"), Callback = function() -- 1287
        local Character = Player.Character -- 1288
        if Character then -- 1289
            local hrp = Character:FindFirstChild("HumanoidRootPart") -- 1290
            if hrp then -- 1291
                spawn(function() -- 1292
                    for i = 1, 50 do -- 1293
                        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(36), 0) end -- 1294
                        task.wait(0.05) -- 1295
                    end -- 1296
                end) -- 1297
            end -- 1298
        end -- 1299
    end}) -- 1300

    FunTab:CreateButton({Name = getText("btn_giant"), Callback = function() -- 1301
        local Character = Player.Character -- 1302
        if Character then -- 1303
            for _, part in ipairs(Character:GetDescendants()) do -- 1304
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Size = part.Size * 3 end -- 1305
            end -- 1306
        end -- 1307
    end}) -- 1308

    FunTab:CreateButton({Name = getText("btn_tiny"), Callback = function() -- 1309
        local Character = Player.Character -- 1310
        if Character then -- 1311
            for _, part in ipairs(Character:GetDescendants()) do -- 1312
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Size = part.Size / 3 end -- 1313
            end -- 1314
        end -- 1315
    end}) -- 1316

    local flyActive = false -- 1317
    FunTab:CreateButton({Name = getText("btn_fly"), Callback = function() -- 1318
        flyActive = not flyActive -- 1319
        spawn(function() -- 1320
            while flyActive do -- 1321
                local Character = Player.Character -- 1322
                if Character then -- 1323
                    local hrp = Character:FindFirstChild("HumanoidRootPart") -- 1324
                    if hrp then hrp.Velocity = Vector3.new(0, 50, 0) end -- 1325
                end -- 1326
                task.wait(0.1) -- 1327
            end -- 1328
        end) -- 1329
    end}) -- 1330

    local bounceActive = false -- 1331
    FunTab:CreateButton({Name = getText("btn_bounce"), Callback = function() -- 1332
        bounceActive = not bounceActive -- 1333
        spawn(function() -- 1334
            while bounceActive do -- 1335
                local Character = Player.Character -- 1336
                if Character then -- 1337
                    local hrp = Character:FindFirstChild("HumanoidRootPart") -- 1338
                    if hrp then hrp.Velocity = Vector3.new(0, 100, 0) end -- 1339
                end -- 1340
                task.wait(0.5) -- 1341
            end -- 1342
        end) -- 1343
    end}) -- 1344

    local LogsTab = Window:CreateTab(getText("tab_logs"), 4483362458) -- 1345
    LogsTab:CreateSection("📋 " .. (language == "RU" and "История обновлений" or "Update History")) -- 1346
    for _, log in ipairs(updateLogs) do -- 1347
        LogsTab:CreateLabel("🔹 v" .. log.version) -- 1348
        LogsTab:CreateParagraph({Title = "Изменения:", Content = log.changes}) -- 1349
    end -- 1350

    local CreatorTab = Window:CreateTab(getText("tab_creator"), 4483362458) -- 1351
    CreatorTab:CreateSection("⚠️ " .. (language == "RU" and "ВНИМАНИЕ" or "WARNING")) -- 1352
    CreatorTab:CreateLabel(getText("creator_dev_warning")) -- 1353
    CreatorTab:CreateLabel(getText("creator_dev_warning2")) -- 1354

    CreatorTab:CreateSection("👑 " .. (language == "RU" and "Доступ разработчика" or "Developer Access")) -- 1355

    local creatorAccessGranted = false -- 1356
    local CreatorKeyInput = CreatorTab:CreateInput({Name = getText("creator_key_label"), PlaceholderText = "Ключ...", RemoveTextAfterFocusLost = false, Callback = function(Text) -- 1357
        if Text == creatorKey then -- 1358
            creatorAccessGranted = true -- 1359
            Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_key_success"), Duration = 6.5, Image = 4483362458}) -- 1360
            loadCreatorPanel() -- 1361
        else -- 1362
            Rayfield:Notify({Title = getText("error_title"), Content = getText("creator_key_error"), Duration = 6.5, Image = 4483362458}) -- 1363
        end -- 1364
    end}) -- 1365

    function loadCreatorPanel() -- 1366
        if not creatorAccessGranted then return end -- 1367
        CreatorTab:CreateSection("🌍 " .. (language == "RU" and "Статистика" or "Statistics")) -- 1368
        local globalUsersLabel = CreatorTab:CreateLabel(getText("creator_global_users") .. "0") -- 1369
        local syncLoop -- 1370
        syncLoop = RunService.Heartbeat:Connect(function() -- 1371
            if not creatorAccessGranted then if syncLoop then syncLoop:Disconnect() end return end -- 1372
            spawn(function() pcall(function() local users = getGlobalScriptUsers() globalUsersLabel:Set(getText("creator_global_users") .. tostring(users)) end) end) -- 1373
            task.wait(1) -- 1374
        end) -- 1375
        CreatorTab:CreateSection("⚡ " .. (language == "RU" and "Глобальные действия" or "Global Actions")) -- 1376
        CreatorTab:CreateButton({Name = getText("creator_kick_global"), Callback = function() sendGlobalCommand("kick", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1377
        CreatorTab:CreateButton({Name = getText("creator_kill_global"), Callback = function() sendGlobalCommand("kill", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1378
        CreatorTab:CreateButton({Name = getText("creator_freeze_global"), Callback = function() sendGlobalCommand("freeze", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1379
        CreatorTab:CreateButton({Name = getText("creator_unfreeze_global"), Callback = function() sendGlobalCommand("unfreeze", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1380
        CreatorTab:CreateButton({Name = getText("creator_heal_global"), Callback = function() sendGlobalCommand("heal", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1381
        CreatorTab:CreateButton({Name = getText("creator_fling_global"), Callback = function() sendGlobalCommand("fling", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1382
    end -- 1383

    local SettingsTab = Window:CreateTab("⚙️ " .. (language == "RU" and "Настройки" or "Settings"), 4483362458) -- 1384
    SettingsTab:CreateButton({Name = getText("btn_close"), Callback = function() -- 1385
        StopAutoFarm() StopInfiniteJumps() StopAutoMace() -- 1386
        noclipActive = false espActive = false antiafkActive = false -- 1387
        rainbowActive = false flyActive = false bounceActive = false -- 1388
        if noclipLoop then noclipLoop:Disconnect() end -- 1389
        if antiafkLoop then antiafkLoop:Disconnect() end -- 1390
        Rayfield:Destroy() -- 1391
    end}) -- 1392

    Rayfield:Notify({Title = "ILOVEKOCMOC", Content = getText("loaded"), Duration = 6.5, Image = 4483362458}) -- 1393
end -- 1394

createKeySystem() -- 1395

print("✅ +1 JUMP MACE ESCAPE v2.0.0 Release LOADED") -- 1396
