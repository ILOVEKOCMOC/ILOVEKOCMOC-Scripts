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
    {version = "2.0.0 Release", changes = "Добавлен Roblox браузер, сохранение ключа, кэширование, оптимизация, вкладка Приколы, стабильная версия"}, -- 164
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
        browser_search = "🔍 Поиск игр...", -- 275
        browser_search_btn = "Поиск", -- 276
        key_loaded = "✅ Ключ загружен автоматически!", -- 277
        key_saved = "✅ Ключ сохранён!" -- 278
    }, -- 279
    EN = { -- 280
        key_title = "🔐 ENTER KEY", -- 281
        key_label = "Enter key:", -- 282
        key_error = "❌ WRONG KEY!", -- 283
        key_success = "✅ KEY ACCEPTED!", -- 284
        get_key = "📺 GET KEY", -- 285
        version_text = "Version: " .. ScriptVersion, -- 286
        lang_select = "🌍 SELECT LANGUAGE:", -- 287
        lang_select_wait = "👇 SELECT LANGUAGE TO CONTINUE 👇", -- 288
        lang_ru = "🇷🇺 RUSSIAN", -- 289
        lang_en = "🇬🇧 ENGLISH", -- 290
        menu_title = "🔥 +1 JUMP MACE ESCAPE", -- 291
        tab_money = "💰 Money", -- 292
        tab_main = "🏠 Main", -- 293
        tab_player = "👤 Player", -- 294
        tab_creator = "👑 Creator", -- 295
        tab_logs = "📋 Logs", -- 296
        tab_fun = "🎮 Fun", -- 297
        btn_wins = "🏆 +1000 WINS", -- 298
        btn_hell = "💰 +66 HELL COINS", -- 299
        btn_farm = "🦘 AUTO FARM", -- 300
        btn_jump = "🦘 INFINITE JUMPS", -- 301
        btn_mace = "🔨 AUTO MACE HIT", -- 302
        btn_noclip = "👻 NOCLIP", -- 303
        btn_speed = "⚡ SPEED", -- 304
        btn_jump_power = "🦘 JUMP POWER", -- 305
        btn_esp = "🎯 PLAYER ESP", -- 306
        btn_antiafk = "🔄 ANTI-AFK", -- 307
        btn_mobile_farm = "📱 MOB. FARM", -- 308
        btn_mobile_jump = "📱 MOB. JUMPS", -- 309
        btn_mobile_mace = "📱 MOB. MACE", -- 310
        btn_mobile_noclip = "📱 MOB. NOCLIP", -- 311
        btn_mobile_esp = "📱 MOB. ESP", -- 312
        btn_mobile_antiafk = "📱 MOB. ANTI-AFK", -- 313
        bind_wins = "Bind: +1000 wins", -- 314
        bind_hell = "Bind: +66 coins", -- 315
        bind_farm = "Bind: Farm", -- 316
        bind_jump = "Bind: Jumps", -- 317
        bind_mace = "Bind: Mace", -- 318
        bind_noclip = "Bind: Noclip", -- 319
        bind_esp = "Bind: ESP", -- 320
        bind_antiafk = "Bind: Anti-AFK", -- 321
        btn_close = "🗑️ DESTROY MENU", -- 322
        btn_browser = "🌐 ROBLOX BROWSER", -- 323
        btn_copy_script = "📋 Copy script link", -- 324
        btn_random_tp = "🎲 Random teleport", -- 325
        btn_rainbow = "🌈 Rainbow character", -- 326
        btn_spin = "🌀 Spin yourself", -- 327
        btn_giant = "🦖 Become giant", -- 328
        btn_tiny = "🐜 Become tiny", -- 329
        btn_fly = "🕊️ Fly mode", -- 330
        btn_bounce = "🏀 Bounce mode", -- 331
        speed_value = "Speed", -- 332
        jump_value = "Jump Power", -- 333
        mobile_title = "MOBILE BUTTON", -- 334
        mobile_on = "ON", -- 335
        mobile_off = "OFF", -- 336
        mobile_close = "✕", -- 337
        mobile_farm_title = "🦘 FARM", -- 338
        mobile_jump_title = "🦘 JUMPS", -- 339
        mobile_mace_title = "🔨 MACE", -- 340
        mobile_noclip_title = "👻 NOCLIP", -- 341
        mobile_esp_title = "🎯 ESP", -- 342
        mobile_antiafk_title = "🔄 ANTI-AFK", -- 343
        success_farm_start = "✅ Auto farm started!", -- 344
        success_farm_stop = "⏸️ Auto farm stopped!", -- 345
        success_jump_start = "✅ Infinite jumps started!", -- 346
        success_jump_stop = "⏸️ Infinite jumps stopped!", -- 347
        success_mace_start = "✅ Auto Mace hit started!", -- 348
        success_mace_stop = "⏸️ Auto Mace hit stopped!", -- 349
        success_noclip_start = "✅ Noclip enabled!", -- 350
        success_noclip_stop = "⏸️ Noclip disabled!", -- 351
        success_esp_start = "✅ ESP enabled!", -- 352
        success_esp_stop = "⏸️ ESP disabled!", -- 353
        success_antiafk_start = "✅ Anti-AFK enabled!", -- 354
        success_antiafk_stop = "⏸️ Anti-AFK disabled!", -- 355
        success_return = "✅ Returned to original position!", -- 356
        loaded = "✅ Menu loaded successfully! YT:@ILOVEKOCMOC", -- 357
        error_title = "Error", -- 358
        success_title = "Success", -- 359
        farm_title = "Auto Farm", -- 360
        jump_title = "Jumps", -- 361
        mace_title = "Mace Hit", -- 362
        noclip_title = "Noclip", -- 363
        esp_title = "ESP", -- 364
        antiafk_title = "Anti-AFK", -- 365
        err_target = "❌ FirstTarget not found!", -- 366
        copy_success = "✅ Link copied!", -- 367
        select_language_first = "❌ Select language first!", -- 368
        creator_title = "👑 CREATOR PANEL", -- 369
        creator_key_label = "Enter creator key:", -- 370
        creator_key_error = "❌ WRONG CREATOR KEY!", -- 371
        creator_key_success = "✅ ACCESS GRANTED!", -- 372
        creator_global_users = "🌍 Total launches: ", -- 373
        creator_dev_warning = "⚠️ WARNING: Creator panel is still in development! Some functions may not work!", -- 374
        creator_dev_warning2 = "🔧 Sync may be unstable", -- 375
        creator_kick_global = "👢 Kick all GLOBAL", -- 376
        creator_kill_global = "💀 Kill all GLOBAL", -- 377
        creator_freeze_global = "🧊 Freeze all GLOBAL", -- 378
        creator_unfreeze_global = "🔥 Unfreeze all GLOBAL", -- 379
        creator_heal_global = "❤️ Heal all GLOBAL", -- 380
        creator_fling_global = "🌀 Fling all GLOBAL", -- 381
        creator_success_global = "✅ Command sent to all!", -- 382
        browser_search = "🔍 Search games...", -- 383
        browser_search_btn = "Search", -- 384
        key_loaded = "✅ Key loaded automatically!", -- 385
        key_saved = "✅ Key saved!" -- 386
    } -- 387
} -- 388

local function getText(key) -- 389
    return texts[language][key] -- 390
end -- 391

local function setTargetTransparency(targetPart, transparency) -- 392
    if not targetPart then return end -- 393
    if targetPart:IsA("Part") then -- 394
        savedTransparency = targetPart.Transparency -- 395
        targetPart.Transparency = transparency -- 396
    end -- 397
    if targetPart:IsA("Model") then -- 398
        for _, child in ipairs(targetPart:GetDescendants()) do -- 399
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then -- 400
                savedTransparency = child.Transparency -- 401
                child.Transparency = transparency -- 402
            end -- 403
        end -- 404
    end -- 405
    if targetPart:IsA("Part") then -- 406
        for _, child in ipairs(targetPart:GetDescendants()) do -- 407
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then -- 408
                child.Transparency = transparency -- 409
            end -- 410
        end -- 411
    end -- 412
end -- 413

local function restoreTargetTransparency(targetPart) -- 414
    if not targetPart then return end -- 415
    if targetPart:IsA("Part") then -- 416
        if savedTransparency then targetPart.Transparency = savedTransparency else targetPart.Transparency = 0 end -- 417
    end -- 418
    if targetPart:IsA("Model") then -- 419
        for _, child in ipairs(targetPart:GetDescendants()) do -- 420
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = 0 end -- 421
        end -- 422
    end -- 423
    if targetPart:IsA("Part") then -- 424
        for _, child in ipairs(targetPart:GetDescendants()) do -- 425
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = 0 end -- 426
        end -- 427
    end -- 428
    savedTransparency = nil -- 429
end -- 430

local function createCopyNotification() -- 431
    local Player = Players.LocalPlayer -- 432
    local ScreenGui = Instance.new("ScreenGui") -- 433
    ScreenGui.Name = "Notif_" .. math.random(10000, 99999) -- 434
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 435
    ScreenGui.ResetOnSpawn = false -- 436
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 437
    ScreenGui.Archivable = false -- 438
    local Notification = Instance.new("Frame") -- 439
    Notification.Name = "N_" .. math.random(10000, 99999) -- 440
    Notification.Size = UDim2.new(0, 250, 0, 40) -- 441
    Notification.Position = UDim2.new(1, 20, 0, 20) -- 442
    Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- 443
    Notification.BorderSizePixel = 0 -- 444
    Notification.Parent = ScreenGui -- 445
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 8) UICorner.Parent = Notification -- 446
    local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(0, 200, 100) UIStroke.Thickness = 2 UIStroke.Parent = Notification -- 447
    local Icon = Instance.new("TextLabel") -- 448
    Icon.Name = "I_" .. math.random(10000, 99999) -- 449
    Icon.Size = UDim2.new(0, 30, 1, 0) -- 450
    Icon.Position = UDim2.new(0, 10, 0, 0) -- 451
    Icon.Text = "📋" -- 452
    Icon.BackgroundTransparency = 1 -- 453
    Icon.Font = Enum.Font.GothamBold -- 454
    Icon.TextSize = 18 -- 455
    Icon.Parent = Notification -- 456
    local Text = Instance.new("TextLabel") -- 457
    Text.Name = "T_" .. math.random(10000, 99999) -- 458
    Text.Size = UDim2.new(1, -50, 1, 0) -- 459
    Text.Position = UDim2.new(0, 45, 0, 0) -- 460
    Text.Text = getText("copy_success") -- 461
    Text.TextColor3 = Color3.fromRGB(255, 255, 255) -- 462
    Text.BackgroundTransparency = 1 -- 463
    Text.Font = Enum.Font.Gotham -- 464
    Text.TextSize = 12 -- 465
    Text.TextXAlignment = Enum.TextXAlignment.Left -- 466
    Text.Parent = Notification -- 467
    local tween1 = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 0, 20)}) -- 468
    tween1:Play() -- 469
    task.wait(5) -- 470
    local tween2 = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)}) -- 471
    tween2:Play() -- 472
    tween2.Completed:Connect(function() ScreenGui:Destroy() end) -- 473
end -- 474

local function createMobileWindow(title, onCallback, offCallback) -- 475
    local Player = Players.LocalPlayer -- 476
    local ScreenGui = Instance.new("ScreenGui") -- 477
    ScreenGui.Name = "MW_" .. math.random(10000, 99999) -- 478
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 479
    ScreenGui.ResetOnSpawn = false -- 480
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 481
    ScreenGui.Archivable = false -- 482
    local MainFrame = Instance.new("Frame") -- 483
    MainFrame.Name = "F_" .. math.random(10000, 99999) -- 484
    MainFrame.Size = UDim2.new(0, 200, 0, 80) -- 485
    MainFrame.Position = UDim2.new(0.8, -10, 0.5, -40) -- 486
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- 487
    MainFrame.BorderSizePixel = 0 -- 488
    MainFrame.Parent = ScreenGui -- 489
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 490
    local TitleLabel = Instance.new("TextLabel") -- 491
    TitleLabel.Name = "T_" .. math.random(10000, 99999) -- 492
    TitleLabel.Size = UDim2.new(1, -30, 0, 25) -- 493
    TitleLabel.Position = UDim2.new(0, 10, 0, 5) -- 494
    TitleLabel.Text = title -- 495
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 496
    TitleLabel.BackgroundTransparency = 1 -- 497
    TitleLabel.Font = Enum.Font.GothamBold -- 498
    TitleLabel.TextSize = 14 -- 499
    TitleLabel.Parent = MainFrame -- 500
    local CloseButton = Instance.new("TextButton") -- 501
    CloseButton.Name = "C_" .. math.random(10000, 99999) -- 502
    CloseButton.Size = UDim2.new(0, 20, 0, 20) -- 503
    CloseButton.Position = UDim2.new(1, -25, 0, 3) -- 504
    CloseButton.Text = getText("mobile_close") -- 505
    CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- 506
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 507
    CloseButton.Font = Enum.Font.GothamBold -- 508
    CloseButton.TextSize = 12 -- 509
    CloseButton.Parent = MainFrame -- 510
    local ToggleButton = Instance.new("TextButton") -- 511
    ToggleButton.Name = "TB_" .. math.random(10000, 99999) -- 512
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 35) -- 513
    ToggleButton.Position = UDim2.new(0.1, 0, 0.45, 0) -- 514
    ToggleButton.Text = getText("mobile_off") -- 515
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- 516
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 517
    ToggleButton.Font = Enum.Font.GothamBold -- 518
    ToggleButton.TextSize = 14 -- 519
    ToggleButton.Parent = MainFrame -- 520
    local isActive = false -- 521
    ToggleButton.MouseButton1Click:Connect(function() -- 522
        if isActive then -- 523
            isActive = false -- 524
            ToggleButton.Text = getText("mobile_off") -- 525
            ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- 526
            if offCallback then pcall(offCallback) end -- 527
        else -- 528
            isActive = true -- 529
            ToggleButton.Text = getText("mobile_on") -- 530
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- 531
            if onCallback then pcall(onCallback) end -- 532
        end -- 533
    end) -- 534
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end) -- 535
    return ScreenGui -- 536
end -- 537

local function createRobloxBrowser() -- 538
    local Player = Players.LocalPlayer -- 539
    local ScreenGui = Instance.new("ScreenGui") -- 540
    ScreenGui.Name = "Browser_" .. math.random(10000, 99999) -- 541
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 542
    ScreenGui.ResetOnSpawn = false -- 543
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 544
    ScreenGui.Archivable = false -- 545
    local MainFrame = Instance.new("Frame") -- 546
    MainFrame.Name = "BF_" .. math.random(10000, 99999) -- 547
    MainFrame.Size = UDim2.new(0, 500, 0, 400) -- 548
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200) -- 549
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- 550
    MainFrame.BorderSizePixel = 0 -- 551
    MainFrame.Parent = ScreenGui -- 552
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 553
    local Title = Instance.new("TextLabel") -- 554
    Title.Name = "BT_" .. math.random(10000, 99999) -- 555
    Title.Size = UDim2.new(1, -40, 0, 35) -- 556
    Title.Position = UDim2.new(0, 15, 0, 5) -- 557
    Title.Text = "🌐 ROBLOX BROWSER" -- 558
    Title.TextColor3 = Color3.fromRGB(255, 200, 0) -- 559
    Title.BackgroundTransparency = 1 -- 560
    Title.Font = Enum.Font.GothamBold -- 561
    Title.TextSize = 18 -- 562
    Title.Parent = MainFrame -- 563
    local CloseButton = Instance.new("TextButton") -- 564
    CloseButton.Name = "BC_" .. math.random(10000, 99999) -- 565
    CloseButton.Size = UDim2.new(0, 25, 0, 25) -- 566
    CloseButton.Position = UDim2.new(1, -30, 0, 5) -- 567
    CloseButton.Text = "✕" -- 568
    CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- 569
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 570
    CloseButton.Font = Enum.Font.GothamBold -- 571
    CloseButton.TextSize = 14 -- 572
    CloseButton.Parent = MainFrame -- 573
    local SearchBox = Instance.new("TextBox") -- 574
    SearchBox.Name = "BS_" .. math.random(10000, 99999) -- 575
    SearchBox.Size = UDim2.new(0.7, 0, 0, 35) -- 576
    SearchBox.Position = UDim2.new(0.05, 0, 0.12, 0) -- 577
    SearchBox.PlaceholderText = getText("browser_search") -- 578
    SearchBox.Text = "" -- 579
    SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- 580
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255) -- 581
    SearchBox.Font = Enum.Font.Gotham -- 582
    SearchBox.TextSize = 14 -- 583
    SearchBox.Parent = MainFrame -- 584
    local SearchButton = Instance.new("TextButton") -- 585
    SearchButton.Name = "BB_" .. math.random(10000, 99999) -- 586
    SearchButton.Size = UDim2.new(0.2, 0, 0, 35) -- 587
    SearchButton.Position = UDim2.new(0.78, 0, 0.12, 0) -- 588
    SearchButton.Text = getText("browser_search_btn") -- 589
    SearchButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- 590
    SearchButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 591
    SearchButton.Font = Enum.Font.GothamBold -- 592
    SearchButton.TextSize = 14 -- 593
    SearchButton.Parent = MainFrame -- 594
    local ResultsFrame = Instance.new("ScrollingFrame") -- 595
    ResultsFrame.Name = "BR_" .. math.random(10000, 99999) -- 596
    ResultsFrame.Size = UDim2.new(0.9, 0, 0.7, 0) -- 597
    ResultsFrame.Position = UDim2.new(0.05, 0, 0.25, 0) -- 598
    ResultsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40) -- 599
    ResultsFrame.BorderSizePixel = 0 -- 600
    ResultsFrame.Parent = MainFrame -- 601
    ResultsFrame.CanvasSize = UDim2.new(0, 0, 1, 0) -- 602
    ResultsFrame.ScrollBarThickness = 5 -- 603
    local UIListLayout = Instance.new("UIListLayout") -- 604
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder -- 605
    UIListLayout.Padding = UDim.new(0, 5) -- 606
    UIListLayout.Parent = ResultsFrame -- 607
    local popularGames = { -- 608
        {name = "Blox Fruits", id = 2753915549}, -- 609
        {name = "Brookhaven RP", id = 4924922222}, -- 610
        {name = "Murder Mystery 2", id = 142823291}, -- 611
        {name = "Adopt Me!", id = 920587237}, -- 612
        {name = "Pet Simulator X", id = 6284583030}, -- 613
        {name = "Arsenal", id = 286090429}, -- 614
        {name = "Tower of Hell", id = 1962086868}, -- 615
        {name = "Jailbreak", id = 606849621}, -- 616
        {name = "Bee Swarm Simulator", id = 1537690962}, -- 617
        {name = "Doors", id = 6516141723} -- 618
    } -- 619
    local function displayGames(games) -- 620
        for _, child in ipairs(ResultsFrame:GetChildren()) do -- 621
            if child:IsA("TextButton") then child:Destroy() end -- 622
        end -- 623
        for i, game in ipairs(games) do -- 624
            local GameButton = Instance.new("TextButton") -- 625
            GameButton.Name = "Game_" .. i -- 626
            GameButton.Size = UDim2.new(1, 0, 0, 40) -- 627
            GameButton.Text = game.name .. " (ID: " .. game.id .. ")" -- 628
            GameButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60) -- 629
            GameButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 630
            GameButton.Font = Enum.Font.Gotham -- 631
            GameButton.TextSize = 12 -- 632
            GameButton.Parent = ResultsFrame -- 633
            GameButton.MouseButton1Click:Connect(function() -- 634
                pcall(function() setclipboard("https://www.roblox.com/games/" .. game.id) end) -- 635
                createCopyNotification() -- 636
            end) -- 637
        end -- 638
        ResultsFrame.CanvasSize = UDim2.new(0, 0, 0, #games * 45) -- 639
    end -- 640
    displayGames(popularGames) -- 641
    SearchButton.MouseButton1Click:Connect(function() -- 642
        local searchQuery = SearchBox.Text:lower() -- 643
        if searchQuery == "" then -- 644
            displayGames(popularGames) -- 645
            return -- 646
        end -- 647
        local filteredGames = {} -- 648
        for _, game in ipairs(popularGames) do -- 649
            if game.name:lower():find(searchQuery) then -- 650
                table.insert(filteredGames, game) -- 651
            end -- 652
        end -- 653
        displayGames(filteredGames) -- 654
    end) -- 655
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end) -- 656
end -- 657

local function animateKeySystemIn(MainFrame) -- 658
    MainFrame.Position = UDim2.new(0.5, -200, 1, 100) -- 659
    MainFrame.Visible = true -- 660
    local tween1 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -220)}) -- 661
    local tween2 = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -200)}) -- 662
    tween1:Play() -- 663
    tween1.Completed:Connect(function() tween2:Play() end) -- 664
end -- 665

local function animateKeySystemOut(MainFrame, ScreenGui, callback) -- 666
    local tween1 = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -220)}) -- 667
    local tween2 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -200, 1, 100)}) -- 668
    tween1:Play() -- 669
    tween1.Completed:Connect(function() -- 670
        tween2:Play() -- 671
        tween2.Completed:Connect(function() if callback then callback() end end) -- 672
    end) -- 673
end -- 674

local function createKeySystem() -- 675
    local Player = Players.LocalPlayer -- 676
    local ScreenGui = Instance.new("ScreenGui") -- 677
    ScreenGui.Name = "KS_" .. math.random(10000, 99999) -- 678
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 679
    ScreenGui.ResetOnSpawn = false -- 680
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- 681
    ScreenGui.Archivable = false -- 682
    local Background = Instance.new("Frame") -- 683
    Background.Name = "BG_" .. math.random(10000, 99999) -- 684
    Background.Size = UDim2.new(1, 0, 1, 0) -- 685
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- 686
    Background.BackgroundTransparency = 1 -- 687
    Background.Parent = ScreenGui -- 688
    local MainFrame = Instance.new("Frame") -- 689
    MainFrame.Name = "MF_" .. math.random(10000, 99999) -- 690
    MainFrame.Size = UDim2.new(0, 400, 0, 400) -- 691
    MainFrame.Position = UDim2.new(0.5, -200, 1, 100) -- 692
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- 693
    MainFrame.BorderSizePixel = 0 -- 694
    MainFrame.Visible = false -- 695
    MainFrame.Parent = ScreenGui -- 696
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 697
    local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(255, 200, 0) UIStroke.Thickness = 2 UIStroke.Parent = MainFrame -- 698
    local CloseButton = Instance.new("TextButton") -- 699
    CloseButton.Name = "X_" .. math.random(10000, 99999) -- 700
    CloseButton.Size = UDim2.new(0, 25, 0, 25) -- 701
    CloseButton.Position = UDim2.new(1, -30, 0, 5) -- 702
    CloseButton.Text = "✕" -- 703
    CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- 704
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 705
    CloseButton.Font = Enum.Font.GothamBold -- 706
    CloseButton.TextSize = 14 -- 707
    CloseButton.Parent = MainFrame -- 708
    local VersionLabel = Instance.new("TextLabel") -- 709
    VersionLabel.Name = "V_" .. math.random(10000, 99999) -- 710
    VersionLabel.Size = UDim2.new(1, 0, 0, 25) -- 711
    VersionLabel.Position = UDim2.new(0, 0, 0, 5) -- 712
    VersionLabel.Text = getText("version_text") -- 713
    VersionLabel.TextColor3 = Color3.fromRGB(150, 150, 150) -- 714
    VersionLabel.BackgroundTransparency = 1 -- 715
    VersionLabel.Font = Enum.Font.Gotham -- 716
    VersionLabel.TextSize = 12 -- 717
    VersionLabel.Parent = MainFrame -- 718
    local Title = Instance.new("TextLabel") -- 719
    Title.Name = "T_" .. math.random(10000, 99999) -- 720
    Title.Size = UDim2.new(1, 0, 0, 40) -- 721
    Title.Position = UDim2.new(0, 0, 0, 30) -- 722
    Title.Text = getText("key_title") -- 723
    Title.TextColor3 = Color3.fromRGB(255, 200, 0) -- 724
    Title.BackgroundTransparency = 1 -- 725
    Title.Font = Enum.Font.GothamBold -- 726
    Title.TextSize = 20 -- 727
    Title.Parent = MainFrame -- 728
    local LangTitle = Instance.new("TextLabel") -- 729
    LangTitle.Name = "L_" .. math.random(10000, 99999) -- 730
    LangTitle.Size = UDim2.new(1, 0, 0, 25) -- 731
    LangTitle.Position = UDim2.new(0, 0, 0.7, 0) -- 732
    LangTitle.Text = getText("lang_select_wait") -- 733
    LangTitle.TextColor3 = Color3.fromRGB(255, 200, 0) -- 734
    LangTitle.BackgroundTransparency = 1 -- 735
    LangTitle.Font = Enum.Font.GothamBold -- 736
    LangTitle.TextSize = 14 -- 737
    LangTitle.Parent = MainFrame -- 738
    local KeyInput = Instance.new("TextBox") -- 739
    KeyInput.Name = "K_" .. math.random(10000, 99999) -- 740
    KeyInput.Size = UDim2.new(0.6, 0, 0, 40) -- 741
    KeyInput.Position = UDim2.new(0.2, 0, 0.2, 0) -- 742
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- 743
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255) -- 744
    KeyInput.Font = Enum.Font.Gotham -- 745
    KeyInput.TextSize = 18 -- 746
    KeyInput.ClearTextOnFocus = false -- 747
    KeyInput.PlaceholderText = "Выберите язык..." -- 748
    KeyInput.Text = "" -- 749
    KeyInput.Parent = MainFrame -- 750
    KeyInput.Active = false -- 751
    KeyInput.Selectable = false -- 752
    KeyInput.TextEditable = false -- 753
    local savedKey = loadKey() -- 754
    if savedKey then -- 755
        KeyInput.Text = savedKey -- 756
        KeyInput.PlaceholderText = getText("key_loaded") -- 757
    end -- 758
    local ErrorLabel = Instance.new("TextLabel") -- 759
    ErrorLabel.Name = "E_" .. math.random(10000, 99999) -- 760
    ErrorLabel.Size = UDim2.new(0.8, 0, 0, 25) -- 761
    ErrorLabel.Position = UDim2.new(0.1, 0, 0.33, 0) -- 762
    ErrorLabel.Text = "" -- 763
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 764
    ErrorLabel.BackgroundTransparency = 1 -- 765
    ErrorLabel.Font = Enum.Font.Gotham -- 766
    ErrorLabel.TextSize = 14 -- 767
    ErrorLabel.Parent = MainFrame -- 768
    local CheckButton = Instance.new("TextButton") -- 769
    CheckButton.Name = "CB_" .. math.random(10000, 99999) -- 770
    CheckButton.Size = UDim2.new(0.4, 0, 0, 40) -- 771
    CheckButton.Position = UDim2.new(0.3, 0, 0.42, 0) -- 772
    CheckButton.Text = "✅ ПРОВЕРИТЬ" -- 773
    CheckButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- 774
    CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 775
    CheckButton.Font = Enum.Font.GothamBold -- 776
    CheckButton.TextSize = 14 -- 777
    CheckButton.Parent = MainFrame -- 778
    local GetKeyButton = Instance.new("TextButton") -- 779
    GetKeyButton.Name = "GK_" .. math.random(10000, 99999) -- 780
    GetKeyButton.Size = UDim2.new(0.4, 0, 0, 40) -- 781
    GetKeyButton.Position = UDim2.new(0.3, 0, 0.55, 0) -- 782
    GetKeyButton.Text = getText("get_key") -- 783
    GetKeyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 784
    GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 785
    GetKeyButton.Font = Enum.Font.GothamBold -- 786
    GetKeyButton.TextSize = 14 -- 787
    GetKeyButton.Parent = MainFrame -- 788
    local RUBtn = Instance.new("TextButton") -- 789
    RUBtn.Name = "RU_" .. math.random(10000, 99999) -- 790
    RUBtn.Size = UDim2.new(0.35, 0, 0, 35) -- 791
    RUBtn.Position = UDim2.new(0.1, 0, 0.78, 0) -- 792
    RUBtn.Text = "🇷🇺 РУССКИЙ" -- 793
    RUBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- 794
    RUBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- 795
    RUBtn.Font = Enum.Font.GothamBold -- 796
    RUBtn.TextSize = 12 -- 797
    RUBtn.Parent = MainFrame -- 798
    local ENBtn = Instance.new("TextButton") -- 799
    ENBtn.Name = "EN_" .. math.random(10000, 99999) -- 800
    ENBtn.Size = UDim2.new(0.35, 0, 0, 35) -- 801
    ENBtn.Position = UDim2.new(0.55, 0, 0.78, 0) -- 802
    ENBtn.Text = "🇬🇧 ENGLISH" -- 803
    ENBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- 804
    ENBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- 805
    ENBtn.Font = Enum.Font.GothamBold -- 806
    ENBtn.TextSize = 12 -- 807
    ENBtn.Parent = MainFrame -- 808
    animateKeySystemIn(MainFrame) -- 809
    TweenService:Create(Background, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play() -- 810
    local blinking = true -- 811
    local blinkLoop -- 812
    blinkLoop = RunService.Heartbeat:Connect(function() -- 813
        if not blinking or languageSelected then -- 814
            if blinkLoop then blinkLoop:Disconnect() end -- 815
            return -- 816
        end -- 817
        local currentTransparency = LangTitle.TextTransparency -- 818
        local targetTransparency = currentTransparency > 0.5 and 0 or 1 -- 819
        TweenService:Create(LangTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = targetTransparency}):Play() -- 820
        task.wait(0.6) -- 821
    end) -- 822
    local function closeKeySystem() -- 823
        blinking = false -- 824
        animateKeySystemOut(MainFrame, ScreenGui, function() ScreenGui:Destroy() end) -- 825
    end -- 826
    CloseButton.MouseButton1Click:Connect(function() closeKeySystem() end) -- 827
    GetKeyButton.MouseButton1Click:Connect(function() -- 828
        pcall(function() setclipboard(KeyURL) end) -- 829
        createCopyNotification() -- 830
    end) -- 831
    local function unlockKeyInput() -- 832
        languageSelected = true -- 833
        blinking = false -- 834
        if blinkLoop then blinkLoop:Disconnect() end -- 835
        KeyInput.Active = true -- 836
        KeyInput.Selectable = true -- 837
        KeyInput.TextEditable = true -- 838
        KeyInput.PlaceholderText = getText("key_label") -- 839
        CheckButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- 840
        TweenService:Create(LangTitle, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play() -- 841
    end -- 842
    CheckButton.MouseButton1Click:Connect(function() -- 843
        if not languageSelected then -- 844
            ErrorLabel.Text = getText("select_language_first") -- 845
            ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 846
            return -- 847
        end -- 848
        if KeyInput.Text == correctKey then -- 849
            ErrorLabel.Text = getText("key_success") -- 850
            ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- 851
            saveKey(KeyInput.Text) -- 852
            incrementScriptCounter() -- 853
            task.wait(0.5) -- 854
            animateKeySystemOut(MainFrame, ScreenGui, function() -- 855
                ScreenGui:Destroy() -- 856
                keyAccepted = true -- 857
                loadMainMenu() -- 858
            end) -- 859
        else -- 860
            ErrorLabel.Text = getText("key_error") -- 861
            ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 862
        end -- 863
    end) -- 864
    KeyInput.FocusLost:Connect(function(enterPressed) -- 865
        if enterPressed and languageSelected then -- 866
            if KeyInput.Text == correctKey then -- 867
                ErrorLabel.Text = getText("key_success") -- 868
                ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- 869
                saveKey(KeyInput.Text) -- 870
                incrementScriptCounter() -- 871
                task.wait(0.5) -- 872
                animateKeySystemOut(MainFrame, ScreenGui, function() -- 873
                    ScreenGui:Destroy() -- 874
                    keyAccepted = true -- 875
                    loadMainMenu() -- 876
                end) -- 877
            else -- 878
                ErrorLabel.Text = getText("key_error") -- 879
                ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 880
            end -- 881
        end -- 882
    end) -- 883
    RUBtn.MouseButton1Click:Connect(function() -- 884
        language = "RU" -- 885
        unlockKeyInput() -- 886
        Title.Text = getText("key_title") -- 887
        KeyInput.PlaceholderText = getText("key_label") -- 888
        CheckButton.Text = "✅ " .. getText("key_success"):gsub("✅ ", "") -- 889
        GetKeyButton.Text = getText("get_key") -- 890
        RUBtn.Text = getText("lang_ru") -- 891
        ENBtn.Text = getText("lang_en") -- 892
        ErrorLabel.Text = "" -- 893
    end) -- 894
    ENBtn.MouseButton1Click:Connect(function() -- 895
        language = "EN" -- 896
        unlockKeyInput() -- 897
        Title.Text = getText("key_title") -- 898
        KeyInput.PlaceholderText = getText("key_label") -- 899
        CheckButton.Text = "✅ " .. getText("key_success"):gsub("✅ ", "") -- 900
        GetKeyButton.Text = getText("get_key") -- 901
        RUBtn.Text = getText("lang_ru") -- 902
        ENBtn.Text = getText("lang_en") -- 903
        ErrorLabel.Text = "" -- 904
    end) -- 905
end -- 906

function loadMainMenu() -- 907
    local Window = Rayfield:CreateWindow({ -- 908
        Name = getText("menu_title"), -- 909
        LoadingTitle = "+1 JUMP MACE ESCAPE", -- 910
        LoadingSubtitle = "by ILOVEKOCMOC", -- 911
        ConfigurationSaving = {Enabled = true, FolderName = "ILOVEKOCMOC_Configs", FileName = "ILOVEKOCMOC"}, -- 912
        Discord = {Enabled = false, Invite = "", RememberJoins = false}, -- 913
        KeySystem = false -- 914
    }) -- 915

    local Player = Players.LocalPlayer -- 916
    local VirtualUser = game:GetService("VirtualUser") -- 917
    local UserInputService = game:GetService("UserInputService") -- 918
    local screenSize = workspace.CurrentCamera.ViewportSize -- 919
    local centerX = screenSize.X / 2 -- 920
    local centerY = screenSize.Y / 2 -- 921

    local MoneyTab = Window:CreateTab(getText("tab_money"), 4483362458) -- 922
    MoneyTab:CreateSection("💰 " .. (language == "RU" and "Заработок" or "Earnings")) -- 923

    MoneyTab:CreateButton({Name = getText("btn_wins"), Callback = function() -- 924
        local model = workspace:FindFirstChild("GiveWins") -- 925
        if model then -- 926
            local buttonModel = model:FindFirstChild("Button13") -- 927
            if buttonModel then -- 928
                local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 929
                if targetPart then -- 930
                    local Character = Player.Character or Player.CharacterAdded:Wait() -- 931
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 932
                    if HumanoidRootPart then -- 933
                        HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 1, 0) -- 934
                        task.wait(0.1) -- 935
                    end -- 936
                    local detector = targetPart:FindFirstChild("ClickDetector") -- 937
                    if detector then detector:Fire() end -- 938
                end -- 939
            end -- 940
        end -- 941
    end}) -- 942

    MoneyTab:CreateKeybind({Name = getText("bind_wins"), CurrentKeybind = "Insert", HoldToInteract = false, Flag = "WinsBind", Callback = function() -- 943
        local model = workspace:FindFirstChild("GiveWins") -- 944
        if model then -- 945
            local buttonModel = model:FindFirstChild("Button13") -- 946
            if buttonModel then -- 947
                local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 948
                if targetPart then -- 949
                    local Character = Player.Character or Player.CharacterAdded:Wait() -- 950
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 951
                    if HumanoidRootPart then -- 952
                        HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 1, 0) -- 953
                        task.wait(0.1) -- 954
                    end -- 955
                    local detector = targetPart:FindFirstChild("ClickDetector") -- 956
                    if detector then detector:Fire() end -- 957
                end -- 958
            end -- 959
        end -- 960
    end}) -- 961

    MoneyTab:CreateButton({Name = getText("btn_hell"), Callback = function() -- 962
        local model = workspace:FindFirstChild("HellGemGivers") -- 963
        if model then -- 964
            local buttonModel = model:FindFirstChild("HellButton3") -- 965
            if buttonModel then -- 966
                local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 967
                if targetPart then -- 968
                    local Character = Player.Character or Player.CharacterAdded:Wait() -- 969
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 970
                    if HumanoidRootPart then -- 971
                        HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 7, 0) -- 972
                        task.wait(0.1) -- 973
                    end -- 974
                    local detector = targetPart:FindFirstChild("ClickDetector") -- 975
                    if detector then detector:Fire() end -- 976
                end -- 977
            end -- 978
        end -- 979
    end}) -- 980

    MoneyTab:CreateKeybind({Name = getText("bind_hell"), CurrentKeybind = "Home", HoldToInteract = false, Flag = "HellBind", Callback = function() -- 981
        local model = workspace:FindFirstChild("HellGemGivers") -- 982
        if model then -- 983
            local buttonModel = model:FindFirstChild("HellButton3") -- 984
            if buttonModel then -- 985
                local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 986
                if targetPart then -- 987
                    local Character = Player.Character or Player.CharacterAdded:Wait() -- 988
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 989
                    if HumanoidRootPart then -- 990
                        HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 7, 0) -- 991
                        task.wait(0.1) -- 992
                    end -- 993
                    local detector = targetPart:FindFirstChild("ClickDetector") -- 994
                    if detector then detector:Fire() end -- 995
                end -- 996
            end -- 997
        end -- 998
    end}) -- 999

    local MainTab = Window:CreateTab(getText("tab_main"), 4483362458) -- 1000
    MainTab:CreateSection("⚡ " .. (language == "RU" and "Функции" or "Functions")) -- 1001

    local farming = false local farmLoop = nil local posLoop = nil -- 1002

    local AutoFarmToggle = MainTab:CreateToggle({Name = getText("btn_farm"), CurrentValue = false, Flag = "AutoFarm", Callback = function(Value) -- 1003
        if Value then StartAutoFarm() else StopAutoFarm() end -- 1004
    end}) -- 1005

    function StartAutoFarm() -- 1006
        if farming then return end farming = true -- 1007
        local targetPart = workspace:FindFirstChild("FirstTarget") -- 1008
        if not targetPart then -- 1009
            Rayfield:Notify({Title = getText("error_title"), Content = getText("err_target"), Duration = 6.5, Image = 4483362458}) -- 1010
            farming = false return -- 1011
        end -- 1012
        local Character = Player.Character -- 1013
        if Character then -- 1014
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1015
            if HumanoidRootPart then savedPosition = HumanoidRootPart.CFrame end -- 1016
        end -- 1017
        savedTargetPosition = targetPart.Position -- 1018
        targetPart.Position = Vector3.new(targetPart.Position.X, -50, targetPart.Position.Z) -- 1019
        if Character then -- 1020
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1021
            if HumanoidRootPart then -- 1022
                HumanoidRootPart.CFrame = CFrame.new(targetPart.Position.X, -50 + 7, targetPart.Position.Z) -- 1023
            end -- 1024
        end -- 1025
        posLoop = RunService.Heartbeat:Connect(function() -- 1026
            if not farming then if posLoop then posLoop:Disconnect() posLoop = nil end return end -- 1027
            local Character = Player.Character -- 1028
            if Character then -- 1029
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1030
                if HumanoidRootPart and targetPart and targetPart.Parent then -- 1031
                    HumanoidRootPart.CFrame = CFrame.new(targetPart.Position.X, targetPart.Position.Y + 7, targetPart.Position.Z) -- 1032
                end -- 1033
            end -- 1034
        end) -- 1035
        farmLoop = RunService.RenderStepped:Connect(function() -- 1036
            if not farming then if farmLoop then farmLoop:Disconnect() farmLoop = nil end return end -- 1037
            VirtualUser:ClickButton1(Vector2.new(centerX, centerY)) -- 1038
        end) -- 1039
        Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_farm_start"), Duration = 6.5, Image = 4483362458}) -- 1040
    end -- 1041

    function StopAutoFarm() -- 1042
        farming = false -- 1043
        if farmLoop then farmLoop:Disconnect() farmLoop = nil end -- 1044
        if posLoop then posLoop:Disconnect() posLoop = nil end -- 1045
        if savedTargetPosition then -- 1046
            local targetPart = workspace:FindFirstChild("FirstTarget") -- 1047
            if targetPart then targetPart.Position = savedTargetPosition end -- 1048
            savedTargetPosition = nil -- 1049
        end -- 1050
        if savedPosition then -- 1051
            local Character = Player.Character -- 1052
            if Character then -- 1053
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1054
                if HumanoidRootPart then HumanoidRootPart.CFrame = savedPosition end -- 1055
            end -- 1056
            savedPosition = nil -- 1057
            Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_return"), Duration = 6.5, Image = 4483362458}) -- 1058
        else -- 1059
            Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_farm_stop"), Duration = 6.5, Image = 4483362458}) -- 1060
        end -- 1061
    end -- 1062

    MainTab:CreateKeybind({Name = getText("bind_farm"), CurrentKeybind = "F8", HoldToInteract = false, Flag = "FarmBind", Callback = function() -- 1063
        if farming then StopAutoFarm() AutoFarmToggle:Set(false) else StartAutoFarm() AutoFarmToggle:Set(true) end -- 1064
    end}) -- 1065

    MainTab:CreateButton({Name = getText("btn_mobile_farm"), Callback = function() -- 1066
        createMobileWindow(getText("mobile_farm_title"), function() StartAutoFarm() end, function() StopAutoFarm() end) -- 1067
    end}) -- 1068

    local infiniteJumps = false local jumpLoop = nil -- 1069

    local InfiniteJumpsToggle = MainTab:CreateToggle({Name = getText("btn_jump"), CurrentValue = false, Flag = "InfiniteJumps", Callback = function(Value) -- 1070
        if Value then StartInfiniteJumps() else StopInfiniteJumps() end -- 1071
    end}) -- 1072

    function StartInfiniteJumps() -- 1073
        if infiniteJumps then return end infiniteJumps = true -- 1074
        local targetPart = workspace:FindFirstChild("FirstTarget") -- 1075
        if not targetPart then -- 1076
            Rayfield:Notify({Title = getText("error_title"), Content = getText("err_target"), Duration = 6.5, Image = 4483362458}) -- 1077
            infiniteJumps = false return -- 1078
        end -- 1079
        savedTargetPosition = targetPart.Position -- 1080
        setTargetTransparency(targetPart, 1) -- 1081
        jumpLoop = RunService.Heartbeat:Connect(function() -- 1082
            if not infiniteJumps then if jumpLoop then jumpLoop:Disconnect() jumpLoop = nil end return end -- 1083
            local Character = Player.Character -- 1084
            if Character and Character:FindFirstChild("HumanoidRootPart") then -- 1085
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 1086
                if HumanoidRootPart and targetPart and targetPart.Parent then -- 1087
                    targetPart.Position = HumanoidRootPart.Position -- 1088
                end -- 1089
            end -- 1090
        end) -- 1091
        Rayfield:Notify({Title = getText("jump_title"), Content = getText("success_jump_start"), Duration = 6.5, Image = 4483362458}) -- 1092
    end -- 1093

    function StopInfiniteJumps() -- 1094
        infiniteJumps = false -- 1095
        if jumpLoop then jumpLoop:Disconnect() jumpLoop = nil end -- 1096
        if savedTargetPosition then -- 1097
            local targetPart = workspace:FindFirstChild("FirstTarget") -- 1098
            if targetPart then -- 1099
                targetPart.Position = savedTargetPosition -- 1100
                restoreTargetTransparency(targetPart) -- 1101
            end -- 1102
            savedTargetPosition = nil -- 1103
        end -- 1104
        Rayfield:Notify({Title = getText("jump_title"), Content = getText("success_jump_stop"), Duration = 6.5, Image = 4483362458}) -- 1105
    end -- 1106

    MainTab:CreateKeybind({Name = getText("bind_jump"), CurrentKeybind = "F9", HoldToInteract = false, Flag = "JumpBind", Callback = function() -- 1107
        if infiniteJumps then StopInfiniteJumps() InfiniteJumpsToggle:Set(false) else StartInfiniteJumps() InfiniteJumpsToggle:Set(true) end -- 1108
    end}) -- 1109

    MainTab:CreateButton({Name = getText("btn_mobile_jump"), Callback = function() -- 1110
        createMobileWindow(getText("mobile_jump_title"), function() StartInfiniteJumps() end, function() StopInfiniteJumps() end) -- 1111
    end}) -- 1112

    local maceActive = false local maceLoop = nil local maceSpeed = 5 local lastMaceHit = 0 -- 1113

    local AutoMaceToggle = MainTab:CreateToggle({Name = getText("btn_mace"), CurrentValue = false, Flag = "AutoMace", Callback = function(Value) -- 1114
        if Value then StartAutoMace() else StopAutoMace() end -- 1115
    end}) -- 1116

    function findMaceTargets() -- 1117
        local targets = {} -- 1118
        local firstTarget = workspace:FindFirstChild("FirstTarget") -- 1119
        for _, descendant in ipairs(workspace:GetDescendants()) do -- 1120
            if descendant.Name == "MaceTargetHighlight" then -- 1121
                if descendant.Parent then -- 1122
                    local isFirstTarget = false -- 1123
                    local current = descendant.Parent -- 1124
                    while current do -- 1125
                        if current == firstTarget then isFirstTarget = true break end -- 1126
                        current = current.Parent -- 1127
                    end -- 1128
                    if not isFirstTarget then -- 1129
                        local found = false -- 1130
                        for _, t in ipairs(targets) do if t == descendant.Parent then found = true break end end -- 1131
                        if not found then table.insert(targets, descendant.Parent) end -- 1132
                    end -- 1133
                end -- 1134
            end -- 1135
        end -- 1136
        return targets -- 1137
    end -- 1138

    function StartAutoMace() -- 1139
        if maceActive then return end maceActive = true -- 1140
        maceLoop = RunService.Heartbeat:Connect(function() -- 1141
            if not maceActive then if maceLoop then maceLoop:Disconnect() maceLoop = nil end return end -- 1142
            local currentTime = tick() -- 1143
            if currentTime - lastMaceHit < (1 / maceSpeed) then return end -- 1144
            local targets = findMaceTargets() -- 1145
            if #targets > 0 then -- 1146
                VirtualUser:ClickButton1(Vector2.new(centerX, centerY)) -- 1147
                lastMaceHit = tick() -- 1148
            end -- 1149
        end) -- 1150
        Rayfield:Notify({Title = getText("mace_title"), Content = getText("success_mace_start"), Duration = 6.5, Image = 4483362458}) -- 1151
    end -- 1152

    function StopAutoMace() -- 1153
        maceActive = false -- 1154
        if maceLoop then maceLoop:Disconnect() maceLoop = nil end -- 1155
        Rayfield:Notify({Title = getText("mace_title"), Content = getText("success_mace_stop"), Duration = 6.5, Image = 4483362458}) -- 1156
    end -- 1157

    MainTab:CreateKeybind({Name = getText("bind_mace"), CurrentKeybind = "F10", HoldToInteract = false, Flag = "MaceBind", Callback = function() -- 1158
        if maceActive then StopAutoMace() AutoMaceToggle:Set(false) else StartAutoMace() AutoMaceToggle:Set(true) end -- 1159
    end}) -- 1160

    MainTab:CreateButton({Name = getText("btn_mobile_mace"), Callback = function() -- 1161
        createMobileWindow(getText("mobile_mace_title"), function() StartAutoMace() end, function() StopAutoMace() end) -- 1162
    end}) -- 1163

    local PlayerTab = Window:CreateTab(getText("tab_player"), 4483362458) -- 1164
    PlayerTab:CreateSection("👤 " .. (language == "RU" and "Параметры игрока" or "Player Settings")) -- 1165

    local noclipActive = false local noclipLoop = nil -- 1166

    local NoclipToggle = PlayerTab:CreateToggle({Name = getText("btn_noclip"), CurrentValue = false, Flag = "Noclip", Callback = function(Value) -- 1167
        if Value then -- 1168
            noclipActive = true -- 1169
            noclipLoop = RunService.Stepped:Connect(function() -- 1170
                if not noclipActive then if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end return end -- 1171
                local Character = Player.Character -- 1172
                if Character then -- 1173
                    for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end -- 1174
                end -- 1175
            end) -- 1176
        else -- 1177
            noclipActive = false -- 1178
            if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end -- 1179
            local Character = Player.Character -- 1180
            if Character then -- 1181
                for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end -- 1182
            end -- 1183
        end -- 1184
    end}) -- 1185

    PlayerTab:CreateKeybind({Name = getText("bind_noclip"), CurrentKeybind = "F11", HoldToInteract = false, Flag = "NoclipBind", Callback = function() -- 1186
        if noclipActive then noclipActive = false NoclipToggle:Set(false) else noclipActive = true NoclipToggle:Set(true) end -- 1187
    end}) -- 1188

    PlayerTab:CreateButton({Name = getText("btn_mobile_noclip"), Callback = function() -- 1189
        createMobileWindow(getText("mobile_noclip_title"), function() noclipActive = true end, function() noclipActive = false end) -- 1190
    end}) -- 1191

    PlayerTab:CreateSlider({Name = getText("speed_value"), Range = {16, 300}, Increment = 1, Suffix = "Speed", CurrentValue = 16, Flag = "SpeedSlider", Callback = function(Value) -- 1192
        local Character = Player.Character if Character then local Humanoid = Character:FindFirstChild("Humanoid") if Humanoid then Humanoid.WalkSpeed = Value end end -- 1193
    end}) -- 1194

    PlayerTab:CreateSlider({Name = getText("jump_value"), Range = {50, 300}, Increment = 5, Suffix = "Power", CurrentValue = 50, Flag = "JumpPowerSlider", Callback = function(Value) -- 1195
        local Character = Player.Character if Character then local Humanoid = Character:FindFirstChild("Humanoid") if Humanoid then Humanoid.JumpPower = Value end end -- 1196
    end}) -- 1197

    local espActive = false -- 1198

    local EspToggle = PlayerTab:CreateToggle({Name = getText("btn_esp"), CurrentValue = false, Flag = "ESP", Callback = function(Value) -- 1199
        if Value then -- 1200
            espActive = true -- 1201
            RunService.Heartbeat:Connect(function() -- 1202
                if not espActive then return end -- 1203
                for _, otherPlayer in ipairs(Players:GetPlayers()) do -- 1204
                    if otherPlayer ~= Player and otherPlayer.Character then -- 1205
                        local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight") -- 1206
                        if not highlight then -- 1207
                            highlight = Instance.new("Highlight") highlight.Name = "ESPHighlight" -- 1208
                            highlight.FillColor = Color3.fromRGB(255, 0, 0) highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- 1209
                            highlight.Parent = otherPlayer.Character -- 1210
                        end -- 1211
                    end -- 1212
                end -- 1213
            end) -- 1214
        else -- 1215
            espActive = false -- 1216
            for _, otherPlayer in ipairs(Players:GetPlayers()) do -- 1217
                if otherPlayer.Character then local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight") if highlight then highlight:Destroy() end end -- 1218
            end -- 1219
        end -- 1220
    end}) -- 1221

    PlayerTab:CreateKeybind({Name = getText("bind_esp"), CurrentKeybind = "F12", HoldToInteract = false, Flag = "EspBind", Callback = function() -- 1222
        if espActive then espActive = false EspToggle:Set(false) else espActive = true EspToggle:Set(true) end -- 1223
    end}) -- 1224

    PlayerTab:CreateButton({Name = getText("btn_mobile_esp"), Callback = function() -- 1225
        createMobileWindow(getText("mobile_esp_title"), function() espActive = true end, function() espActive = false end) -- 1226
    end}) -- 1227

    local antiafkActive = false local antiafkLoop = nil -- 1228

    local AntiAfkToggle = PlayerTab:CreateToggle({Name = getText("btn_antiafk"), CurrentValue = false, Flag = "AntiAFK", Callback = function(Value) -- 1229
        if Value then -- 1230
            antiafkActive = true -- 1231
            antiafkLoop = RunService.Heartbeat:Connect(function() -- 1232
                if not antiafkActive then if antiafkLoop then antiafkLoop:Disconnect() antiafkLoop = nil end return end -- 1233
                VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new(0, 0)) -- 1234
            end) -- 1235
        else -- 1236
            antiafkActive = false if antiafkLoop then antiafkLoop:Disconnect() antiafkLoop = nil end -- 1237
        end -- 1238
    end}) -- 1239

    PlayerTab:CreateKeybind({Name = getText("bind_antiafk"), CurrentKeybind = "Pause", HoldToInteract = false, Flag = "AntiAfkBind", Callback = function() -- 1240
        if antiafkActive then antiafkActive = false AntiAfkToggle:Set(false) else antiafkActive = true AntiAfkToggle:Set(true) end -- 1241
    end}) -- 1242

    PlayerTab:CreateButton({Name = getText("btn_mobile_antiafk"), Callback = function() -- 1243
        createMobileWindow(getText("mobile_antiafk_title"), function() antiafkActive = true end, function() antiafkActive = false end) -- 1244
    end}) -- 1245

    local FunTab = Window:CreateTab(getText("tab_fun"), 4483362458) -- 1246
    FunTab:CreateSection("🎮 " .. (language == "RU" and "Развлечения" or "Entertainment")) -- 1247

    FunTab:CreateButton({Name = getText("btn_browser"), Callback = function() createRobloxBrowser() end}) -- 1248

    FunTab:CreateButton({Name = getText("btn_copy_script"), Callback = function() -- 1249
        pcall(function() setclipboard("https://raw.githubusercontent.com/ILOVEKOCMOC/ILOVEKOCMOC-Scripts/refs/heads/main/%2B1%20Jump%20Mace%20Escape.lua") end) -- 1250
        createCopyNotification() -- 1251
    end}) -- 1252

    FunTab:CreateButton({Name = getText("btn_random_tp"), Callback = function() -- 1253
        local Character = Player.Character -- 1254
        if Character then -- 1255
            local hrp = Character:FindFirstChild("HumanoidRootPart") -- 1256
            if hrp then hrp.CFrame = CFrame.new(math.random(-200, 200), math.random(10, 100), math.random(-200, 200)) end -- 1257
        end -- 1258
    end}) -- 1259

    local rainbowActive = false -- 1260
    FunTab:CreateButton({Name = getText("btn_rainbow"), Callback = function() -- 1261
        rainbowActive = not rainbowActive -- 1262
        spawn(function() -- 1263
            while rainbowActive do -- 1264
                local Character = Player.Character -- 1265
                if Character then -- 1266
                    for _, part in ipairs(Character:GetDescendants()) do -- 1267
                        if part:IsA("BasePart") then part.Color = Color3.fromHSV(tick() % 1, 1, 1) end -- 1268
                    end -- 1269
                end -- 1270
                task.wait(0.05) -- 1271
            end -- 1272
        end) -- 1273
    end}) -- 1274

    FunTab:CreateButton({Name = getText("btn_spin"), Callback = function() -- 1275
        local Character = Player.Character -- 1276
        if Character then -- 1277
            local hrp = Character:FindFirstChild("HumanoidRootPart") -- 1278
            if hrp then -- 1279
                spawn(function() -- 1280
                    for i = 1, 50 do -- 1281
                        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(36), 0) end -- 1282
                        task.wait(0.05) -- 1283
                    end -- 1284
                end) -- 1285
            end -- 1286
        end -- 1287
    end}) -- 1288

    FunTab:CreateButton({Name = getText("btn_giant"), Callback = function() -- 1289
        local Character = Player.Character -- 1290
        if Character then -- 1291
            for _, part in ipairs(Character:GetDescendants()) do -- 1292
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Size = part.Size * 3 end -- 1293
            end -- 1294
        end -- 1295
    end}) -- 1296

    FunTab:CreateButton({Name = getText("btn_tiny"), Callback = function() -- 1297
        local Character = Player.Character -- 1298
        if Character then -- 1299
            for _, part in ipairs(Character:GetDescendants()) do -- 1300
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Size = part.Size / 3 end -- 1301
            end -- 1302
        end -- 1303
    end}) -- 1304

    local flyActive = false -- 1305
    FunTab:CreateButton({Name = getText("btn_fly"), Callback = function() -- 1306
        flyActive = not flyActive -- 1307
        spawn(function() -- 1308
            while flyActive do -- 1309
                local Character = Player.Character -- 1310
                if Character then -- 1311
                    local hrp = Character:FindFirstChild("HumanoidRootPart") -- 1312
                    if hrp then hrp.Velocity = Vector3.new(0, 50, 0) end -- 1313
                end -- 1314
                task.wait(0.1) -- 1315
            end -- 1316
        end) -- 1317
    end}) -- 1318

    local bounceActive = false -- 1319
    FunTab:CreateButton({Name = getText("btn_bounce"), Callback = function() -- 1320
        bounceActive = not bounceActive -- 1321
        spawn(function() -- 1322
            while bounceActive do -- 1323
                local Character = Player.Character -- 1324
                if Character then -- 1325
                    local hrp = Character:FindFirstChild("HumanoidRootPart") -- 1326
                    if hrp then hrp.Velocity = Vector3.new(0, 100, 0) end -- 1327
                end -- 1328
                task.wait(0.5) -- 1329
            end -- 1330
        end) -- 1331
    end}) -- 1332

    local LogsTab = Window:CreateTab(getText("tab_logs"), 4483362458) -- 1333
    LogsTab:CreateSection("📋 " .. (language == "RU" and "История обновлений" or "Update History")) -- 1334
    for _, log in ipairs(updateLogs) do -- 1335
        LogsTab:CreateLabel("🔹 v" .. log.version) -- 1336
        LogsTab:CreateParagraph({Title = "Изменения:", Content = log.changes}) -- 1337
    end -- 1338

    local CreatorTab = Window:CreateTab(getText("tab_creator"), 4483362458) -- 1339
    CreatorTab:CreateSection("⚠️ " .. (language == "RU" and "ВНИМАНИЕ" or "WARNING")) -- 1340
    CreatorTab:CreateLabel(getText("creator_dev_warning")) -- 1341
    CreatorTab:CreateLabel(getText("creator_dev_warning2")) -- 1342

    CreatorTab:CreateSection("👑 " .. (language == "RU" and "Доступ разработчика" or "Developer Access")) -- 1343

    local creatorAccessGranted = false -- 1344
    local CreatorKeyInput = CreatorTab:CreateInput({Name = getText("creator_key_label"), PlaceholderText = "Ключ...", RemoveTextAfterFocusLost = false, Callback = function(Text) -- 1345
        if Text == creatorKey then -- 1346
            creatorAccessGranted = true -- 1347
            Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_key_success"), Duration = 6.5, Image = 4483362458}) -- 1348
            loadCreatorPanel() -- 1349
        else -- 1350
            Rayfield:Notify({Title = getText("error_title"), Content = getText("creator_key_error"), Duration = 6.5, Image = 4483362458}) -- 1351
        end -- 1352
    end}) -- 1353

    function loadCreatorPanel() -- 1354
        if not creatorAccessGranted then return end -- 1355
        CreatorTab:CreateSection("🌍 " .. (language == "RU" and "Статистика" or "Statistics")) -- 1356
        local globalUsersLabel = CreatorTab:CreateLabel(getText("creator_global_users") .. "0") -- 1357
        local syncLoop -- 1358
        syncLoop = RunService.Heartbeat:Connect(function() -- 1359
            if not creatorAccessGranted then if syncLoop then syncLoop:Disconnect() end return end -- 1360
            spawn(function() pcall(function() local users = getGlobalScriptUsers() globalUsersLabel:Set(getText("creator_global_users") .. tostring(users)) end) end) -- 1361
            task.wait(1) -- 1362
        end) -- 1363
        CreatorTab:CreateSection("⚡ " .. (language == "RU" and "Глобальные действия" or "Global Actions")) -- 1364
        CreatorTab:CreateButton({Name = getText("creator_kick_global"), Callback = function() sendGlobalCommand("kick", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1365
        CreatorTab:CreateButton({Name = getText("creator_kill_global"), Callback = function() sendGlobalCommand("kill", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1366
        CreatorTab:CreateButton({Name = getText("creator_freeze_global"), Callback = function() sendGlobalCommand("freeze", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1367
        CreatorTab:CreateButton({Name = getText("creator_unfreeze_global"), Callback = function() sendGlobalCommand("unfreeze", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1368
        CreatorTab:CreateButton({Name = getText("creator_heal_global"), Callback = function() sendGlobalCommand("heal", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1369
        CreatorTab:CreateButton({Name = getText("creator_fling_global"), Callback = function() sendGlobalCommand("fling", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 1370
    end -- 1371

    local SettingsTab = Window:CreateTab("⚙️ " .. (language == "RU" and "Настройки" or "Settings"), 4483362458) -- 1372
    SettingsTab:CreateButton({Name = getText("btn_close"), Callback = function() -- 1373
        StopAutoFarm() StopInfiniteJumps() StopAutoMace() -- 1374
        noclipActive = false espActive = false antiafkActive = false -- 1375
        rainbowActive = false flyActive = false bounceActive = false -- 1376
        if noclipLoop then noclipLoop:Disconnect() end -- 1377
        if antiafkLoop then antiafkLoop:Disconnect() end -- 1378
        Rayfield:Destroy() -- 1379
    end}) -- 1380

    Rayfield:Notify({Title = "ILOVEKOCMOC", Content = getText("loaded"), Duration = 6.5, Image = 4483362458}) -- 1381
end -- 1382

createKeySystem() -- 1383

print("✅ +1 JUMP MACE ESCAPE v2.0.0 Release LOADED") -- 1384
