--[[
    +1 JUMP MACE ESCAPE
    YT:@ILOVEKOCMOC
    Version: 2.0.1
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
local ScriptVersion = "2.0.1" -- 12
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
    if command == "kick" then pcall(function() Player:Kick("Кикнут разработчиком") end) -- 102
    elseif command == "kill" then if Player.Character then local h = Player.Character:FindFirstChild("Humanoid") if h then h.Health = 0 end end -- 103
    elseif command == "freeze" then if Player.Character then local h = Player.Character:FindFirstChild("Humanoid") if h then h.WalkSpeed = 0 h.JumpPower = 0 end end -- 104
    elseif command == "unfreeze" then if Player.Character then local h = Player.Character:FindFirstChild("Humanoid") if h then h.WalkSpeed = 16 h.JumpPower = 50 end end -- 105
    elseif command == "heal" then if Player.Character then local h = Player.Character:FindFirstChild("Humanoid") if h then h.Health = h.MaxHealth end end -- 106
    elseif command == "fling" then -- 107
        spawn(function() -- 108
            local flingActive = true -- 109
            task.delay(5, function() flingActive = false end) -- 110
            while flingActive do -- 111
                if Player.Character then -- 112
                    local hrp = Player.Character:FindFirstChild("HumanoidRootPart") -- 113
                    if hrp then -- 114
                        hrp.Velocity = Vector3.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50)) -- 115
                        hrp.RotVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)) -- 116
                    end -- 117
                end -- 118
                task.wait(0.1) -- 119
            end -- 120
        end) -- 121
    end -- 122
end -- 123

remoteEvent.OnClientEvent:Connect(function(command, data) handleCommand(command, data) end) -- 124

spawn(function() -- 125
    local lastTimestamp = 0 -- 126
    while true do -- 127
        pcall(function() -- 128
            local response = cachedHttpGet(BinURL .. "/latest") -- 129
            if response then -- 130
                local data = HttpService:JSONDecode(response) -- 131
                if data.record and data.record.command and data.record.timestamp then -- 132
                    if data.record.timestamp > lastTimestamp then -- 133
                        lastTimestamp = data.record.timestamp -- 134
                        handleCommand(data.record.command, data.record.data) -- 135
                    end -- 136
                end -- 137
            end -- 138
        end) -- 139
        task.wait(1) -- 140
    end -- 141
end) -- 142

-- ====== ЛОГИ ====== -- 143
local updateLogs = { -- 144
    {version = "2.0.1", changes = "Обновлён авто фарм прыжков и переименован в авто фарм прыжков"}, -- 145
    {version = "2.0.0 Release", changes = "Добавлен РАБОЧИЙ браузер, сохранение ключа, кэширование, оптимизация, вкладка Приколы, стабильная версия"}, -- 146
    {version = "1.1.2(Beta)", changes = "Auto Mace attack fix - проверяет ВЕСЬ workspace и игнорирует FirstTarget"}, -- 147
    {version = "hi", changes = "this iam ILOVEKOCMOC"}, -- 148
    {version = "1.1.1(Beta)", changes = "Глобальная синхронизация и панель разраба"}, -- 149
    {version = "1.0.1(Beta)", changes = "Копирование + ютуб ссылка на ключ"} -- 150
} -- 151

-- ====== ТЕКСТЫ ====== -- 152
local texts = { -- 153
    RU = { -- 154
        key_title = "🔐 ВВЕДИТЕ КЛЮЧ", -- 155
        key_label = "Введите ключ:", -- 156
        key_error = "❌ НЕВЕРНЫЙ КЛЮЧ!", -- 157
        key_success = "✅ КЛЮЧ ПРИНЯТ!", -- 158
        get_key = "📺 ПОЛУЧИТЬ КЛЮЧ", -- 159
        version_text = "Версия: " .. ScriptVersion, -- 160
        lang_select = "🌍 ВЫБЕРИТЕ ЯЗЫК:", -- 161
        lang_select_wait = "👇 ВЫБЕРИТЕ ЯЗЫК ЧТОБЫ ПРОДОЛЖИТЬ 👇", -- 162
        lang_ru = "🇷🇺 РУССКИЙ", -- 163
        lang_en = "🇬🇧 АНГЛИЙСКИЙ", -- 164
        menu_title = "🔥 +1 JUMP MACE ESCAPE", -- 165
        tab_money = "💰 Деньги", -- 166
        tab_main = "🏠 Главная", -- 167
        tab_player = "👤 Игрок", -- 168
        tab_creator = "👑 Создатель", -- 169
        tab_logs = "📋 Логи", -- 170
        tab_fun = "🎮 Приколы", -- 171
        btn_wins = "🏆 +1000 ПОБЕД", -- 172
        btn_hell = "💰 +66 HELL МОНЕТ", -- 173
        btn_farm = "🦘 АВТО ФАРМ ПРЫЖКОВ", -- 174
        btn_jump = "🦘 БЕСКОНЕЧНЫЕ ПРЫЖКИ", -- 175
        btn_mace = "🔨 АВТО MACE УДАР", -- 176
        btn_noclip = "👻 НОКЛИП", -- 177
        btn_speed = "⚡ СКОРОСТЬ", -- 178
        btn_jump_power = "🦘 СИЛА ПРЫЖКА", -- 179
        btn_esp = "🎯 ESP ИГРОКОВ", -- 180
        btn_antiafk = "🔄 АНТИ-АФК", -- 181
        btn_mobile_farm = "📱 МОБ. ФАРМ ПРЫЖКОВ", -- 182
        btn_mobile_jump = "📱 МОБ. ПРЫЖКИ", -- 183
        btn_mobile_mace = "📱 МОБ. MACE", -- 184
        btn_mobile_noclip = "📱 МОБ. НОКЛИП", -- 185
        btn_mobile_esp = "📱 МОБ. ESP", -- 186
        btn_mobile_antiafk = "📱 МОБ. АНТИ-АФК", -- 187
        bind_wins = "Бинд: +1000 побед", -- 188
        bind_hell = "Бинд: +66 монет", -- 189
        bind_farm = "Бинд: Фарм прыжков", -- 190
        bind_jump = "Бинд: Прыжки", -- 191
        bind_mace = "Бинд: Mace", -- 192
        bind_noclip = "Бинд: Ноклип", -- 193
        bind_esp = "Бинд: ESP", -- 194
        bind_antiafk = "Бинд: Анти-АФК", -- 195
        btn_close = "🗑️ УНИЧТОЖИТЬ МЕНЮ", -- 196
        btn_browser = "🌐 ROBLOX BROWSER", -- 197
        btn_copy_script = "📋 Скопировать ссылку на скрипт", -- 198
        btn_random_tp = "🎲 Случайный телепорт", -- 199
        btn_rainbow = "🌈 Радужный персонаж", -- 200
        btn_spin = "🌀 Заспинить себя", -- 201
        btn_giant = "🦖 Стать гигантом", -- 202
        btn_tiny = "🐜 Стать крошечным", -- 203
        btn_fly = "🕊️ Режим полёта", -- 204
        btn_bounce = "🏀 Прыгучий режим", -- 205
        speed_value = "Скорость", -- 206
        jump_value = "Сила прыжка", -- 207
        mobile_title = "МОБИЛЬНАЯ КНОПКА", -- 208
        mobile_on = "ВКЛ", -- 209
        mobile_off = "ВЫКЛ", -- 210
        mobile_close = "✕", -- 211
        mobile_farm_title = "🦘 ФАРМ ПРЫЖКОВ", -- 212
        mobile_jump_title = "🦘 ПРЫЖКИ", -- 213
        mobile_mace_title = "🔨 MACE", -- 214
        mobile_noclip_title = "👻 НОКЛИП", -- 215
        mobile_esp_title = "🎯 ESP", -- 216
        mobile_antiafk_title = "🔄 АНТИ-АФК", -- 217
        success_farm_start = "✅ Авто фарм прыжков запущен!", -- 218
        success_farm_stop = "⏸️ Авто фарм прыжков остановлен!", -- 219
        success_jump_start = "✅ Бесконечные прыжки запущены!", -- 220
        success_jump_stop = "⏸️ Бесконечные прыжки остановлены!", -- 221
        success_mace_start = "✅ Авто Mace удар запущен!", -- 222
        success_mace_stop = "⏸️ Авто Mace удар остановлен!", -- 223
        success_noclip_start = "✅ Ноклип включен!", -- 224
        success_noclip_stop = "⏸️ Ноклип выключен!", -- 225
        success_esp_start = "✅ ESP включен!", -- 226
        success_esp_stop = "⏸️ ESP выключен!", -- 227
        success_antiafk_start = "✅ Анти-АФК включен!", -- 228
        success_antiafk_stop = "⏸️ Анти-АФК выключен!", -- 229
        success_return = "✅ Возвращён на исходную позицию!", -- 230
        loaded = "✅ Меню успешно загружено! YT:@ILOVEKOCMOC", -- 231
        error_title = "Ошибка", -- 232
        success_title = "Успех", -- 233
        farm_title = "Авто Фарм Прыжков", -- 234
        jump_title = "Прыжки", -- 235
        mace_title = "Mace Удар", -- 236
        noclip_title = "Ноклип", -- 237
        esp_title = "ESP", -- 238
        antiafk_title = "Анти-АФК", -- 239
        err_target = "❌ FirstTarget не найден!", -- 240
        copy_success = "✅ Ссылка скопирована!", -- 241
        select_language_first = "❌ Сначала выберите язык!", -- 242
        creator_title = "👑 ПАНЕЛЬ РАЗРАБОТЧИКА", -- 243
        creator_key_label = "Введите ключ разработчика:", -- 244
        creator_key_error = "❌ НЕВЕРНЫЙ КЛЮЧ РАЗРАБОТЧИКА!", -- 245
        creator_key_success = "✅ ДОСТУП РАЗРЕШЁН!", -- 246
        creator_global_users = "🌍 Всего запусков: ", -- 247
        creator_dev_warning = "⚠️ ВНИМАНИЕ: Панель разработчика ещё в разработке! Некоторые функции могут не работать!", -- 248
        creator_dev_warning2 = "🔧 Синхронизация может быть нестабильной", -- 249
        creator_kick_global = "👢 Кикнуть всех ГЛОБАЛЬНО", -- 250
        creator_kill_global = "💀 Убить всех ГЛОБАЛЬНО", -- 251
        creator_freeze_global = "🧊 Заморозить всех ГЛОБАЛЬНО", -- 252
        creator_unfreeze_global = "🔥 Разморозить всех ГЛОБАЛЬНО", -- 253
        creator_heal_global = "❤️ Вылечить всех ГЛОБАЛЬНО", -- 254
        creator_fling_global = "🌀 Зафлигать всех ГЛОБАЛЬНО", -- 255
        creator_success_global = "✅ Команда отправлена всем!", -- 256
        browser_search = "🔍 Введите URL...", -- 257
        browser_go = "GO", -- 258
        browser_home = "https://www.roblox.com", -- 259
        browser_loading = "⏳ Загрузка...", -- 260
        browser_error = "❌ Ошибка загрузки", -- 261
        key_loaded = "✅ Ключ загружен автоматически!", -- 262
        key_saved = "✅ Ключ сохранён!" -- 263
    }, -- 264
    EN = { -- 265
        key_title = "🔐 ENTER KEY", -- 266
        key_label = "Enter key:", -- 267
        key_error = "❌ WRONG KEY!", -- 268
        key_success = "✅ KEY ACCEPTED!", -- 269
        get_key = "📺 GET KEY", -- 270
        version_text = "Version: " .. ScriptVersion, -- 271
        lang_select = "🌍 SELECT LANGUAGE:", -- 272
        lang_select_wait = "👇 SELECT LANGUAGE TO CONTINUE 👇", -- 273
        lang_ru = "🇷🇺 RUSSIAN", -- 274
        lang_en = "🇬🇧 ENGLISH", -- 275
        menu_title = "🔥 +1 JUMP MACE ESCAPE", -- 276
        tab_money = "💰 Money", -- 277
        tab_main = "🏠 Main", -- 278
        tab_player = "👤 Player", -- 279
        tab_creator = "👑 Creator", -- 280
        tab_logs = "📋 Logs", -- 281
        tab_fun = "🎮 Fun", -- 282
        btn_wins = "🏆 +1000 WINS", -- 283
        btn_hell = "💰 +66 HELL COINS", -- 284
        btn_farm = "🦘 AUTO FARM JUMP", -- 285
        btn_jump = "🦘 INFINITE JUMPS", -- 286
        btn_mace = "🔨 AUTO MACE HIT", -- 287
        btn_noclip = "👻 NOCLIP", -- 288
        btn_speed = "⚡ SPEED", -- 289
        btn_jump_power = "🦘 JUMP POWER", -- 290
        btn_esp = "🎯 PLAYER ESP", -- 291
        btn_antiafk = "🔄 ANTI-AFK", -- 292
        btn_mobile_farm = "📱 MOB. FARM JUMP", -- 293
        btn_mobile_jump = "📱 MOB. JUMPS", -- 294
        btn_mobile_mace = "📱 MOB. MACE", -- 295
        btn_mobile_noclip = "📱 MOB. NOCLIP", -- 296
        btn_mobile_esp = "📱 MOB. ESP", -- 297
        btn_mobile_antiafk = "📱 MOB. ANTI-AFK", -- 298
        bind_wins = "Bind: +1000 wins", -- 299
        bind_hell = "Bind: +66 coins", -- 300
        bind_farm = "Bind: Farm jump", -- 301
        bind_jump = "Bind: Jumps", -- 302
        bind_mace = "Bind: Mace", -- 303
        bind_noclip = "Bind: Noclip", -- 304
        bind_esp = "Bind: ESP", -- 305
        bind_antiafk = "Bind: Anti-AFK", -- 306
        btn_close = "🗑️ DESTROY MENU", -- 307
        btn_browser = "🌐 ROBLOX BROWSER", -- 308
        btn_copy_script = "📋 Copy script link", -- 309
        btn_random_tp = "🎲 Random teleport", -- 310
        btn_rainbow = "🌈 Rainbow character", -- 311
        btn_spin = "🌀 Spin yourself", -- 312
        btn_giant = "🦖 Become giant", -- 313
        btn_tiny = "🐜 Become tiny", -- 314
        btn_fly = "🕊️ Fly mode", -- 315
        btn_bounce = "🏀 Bounce mode", -- 316
        speed_value = "Speed", -- 317
        jump_value = "Jump Power", -- 318
        mobile_title = "MOBILE BUTTON", -- 319
        mobile_on = "ON", -- 320
        mobile_off = "OFF", -- 321
        mobile_close = "✕", -- 322
        mobile_farm_title = "🦘 FARM JUMP", -- 323
        mobile_jump_title = "🦘 JUMPS", -- 324
        mobile_mace_title = "🔨 MACE", -- 325
        mobile_noclip_title = "👻 NOCLIP", -- 326
        mobile_esp_title = "🎯 ESP", -- 327
        mobile_antiafk_title = "🔄 ANTI-AFK", -- 328
        success_farm_start = "✅ Auto farm jump started!", -- 329
        success_farm_stop = "⏸️ Auto farm jump stopped!", -- 330
        success_jump_start = "✅ Infinite jumps started!", -- 331
        success_jump_stop = "⏸️ Infinite jumps stopped!", -- 332
        success_mace_start = "✅ Auto Mace hit started!", -- 333
        success_mace_stop = "⏸️ Auto Mace hit stopped!", -- 334
        success_noclip_start = "✅ Noclip enabled!", -- 335
        success_noclip_stop = "⏸️ Noclip disabled!", -- 336
        success_esp_start = "✅ ESP enabled!", -- 337
        success_esp_stop = "⏸️ ESP disabled!", -- 338
        success_antiafk_start = "✅ Anti-AFK enabled!", -- 339
        success_antiafk_stop = "⏸️ Anti-AFK disabled!", -- 340
        success_return = "✅ Returned to original position!", -- 341
        loaded = "✅ Menu loaded successfully! YT:@ILOVEKOCMOC", -- 342
        error_title = "Error", -- 343
        success_title = "Success", -- 344
        farm_title = "Auto Farm Jump", -- 345
        jump_title = "Jumps", -- 346
        mace_title = "Mace Hit", -- 347
        noclip_title = "Noclip", -- 348
        esp_title = "ESP", -- 349
        antiafk_title = "Anti-AFK", -- 350
        err_target = "❌ FirstTarget not found!", -- 351
        copy_success = "✅ Link copied!", -- 352
        select_language_first = "❌ Select language first!", -- 353
        creator_title = "👑 CREATOR PANEL", -- 354
        creator_key_label = "Enter creator key:", -- 355
        creator_key_error = "❌ WRONG CREATOR KEY!", -- 356
        creator_key_success = "✅ ACCESS GRANTED!", -- 357
        creator_global_users = "🌍 Total launches: ", -- 358
        creator_dev_warning = "⚠️ WARNING: Creator panel is still in development! Some functions may not work!", -- 359
        creator_dev_warning2 = "🔧 Sync may be unstable", -- 360
        creator_kick_global = "👢 Kick all GLOBAL", -- 361
        creator_kill_global = "💀 Kill all GLOBAL", -- 362
        creator_freeze_global = "🧊 Freeze all GLOBAL", -- 363
        creator_unfreeze_global = "🔥 Unfreeze all GLOBAL", -- 364
        creator_heal_global = "❤️ Heal all GLOBAL", -- 365
        creator_fling_global = "🌀 Fling all GLOBAL", -- 366
        creator_success_global = "✅ Command sent to all!", -- 367
        browser_search = "🔍 Enter URL...", -- 368
        browser_go = "GO", -- 369
        browser_home = "https://www.roblox.com", -- 370
        browser_loading = "⏳ Loading...", -- 371
        browser_error = "❌ Page load error", -- 372
        key_loaded = "✅ Key loaded automatically!", -- 373
        key_saved = "✅ Key saved!" -- 374
    } -- 375
} -- 376

local function getText(key) -- 377
    return texts[language][key] -- 378
end -- 379

local function setTargetTransparency(targetPart, transparency) -- 380
    if not targetPart then return end -- 381
    if targetPart:IsA("Part") then savedTransparency = targetPart.Transparency targetPart.Transparency = transparency end -- 382
    if targetPart:IsA("Model") then -- 383
        for _, child in ipairs(targetPart:GetDescendants()) do -- 384
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then -- 385
                savedTransparency = child.Transparency child.Transparency = transparency -- 386
            end -- 387
        end -- 388
    end -- 389
    if targetPart:IsA("Part") then -- 390
        for _, child in ipairs(targetPart:GetDescendants()) do -- 391
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = transparency end -- 392
        end -- 393
    end -- 394
end -- 395

local function restoreTargetTransparency(targetPart) -- 396
    if not targetPart then return end -- 397
    if targetPart:IsA("Part") then if savedTransparency then targetPart.Transparency = savedTransparency else targetPart.Transparency = 0 end end -- 398
    if targetPart:IsA("Model") then -- 399
        for _, child in ipairs(targetPart:GetDescendants()) do -- 400
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = 0 end -- 401
        end -- 402
    end -- 403
    if targetPart:IsA("Part") then -- 404
        for _, child in ipairs(targetPart:GetDescendants()) do -- 405
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = 0 end -- 406
        end -- 407
    end -- 408
    savedTransparency = nil -- 409
end -- 410

local function createCopyNotification() -- 411
    local Player = Players.LocalPlayer -- 412
    local ScreenGui = Instance.new("ScreenGui") -- 413
    ScreenGui.Name = "Notif_" .. math.random(10000, 99999) -- 414
    ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 415
    ScreenGui.ResetOnSpawn = false ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling ScreenGui.Archivable = false -- 416
    local Notification = Instance.new("Frame") -- 417
    Notification.Name = "N_" .. math.random(10000, 99999) -- 418
    Notification.Size = UDim2.new(0, 250, 0, 40) Notification.Position = UDim2.new(1, 20, 0, 20) -- 419
    Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30) Notification.BorderSizePixel = 0 Notification.Parent = ScreenGui -- 420
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 8) UICorner.Parent = Notification -- 421
    local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(0, 200, 100) UIStroke.Thickness = 2 UIStroke.Parent = Notification -- 422
    local Icon = Instance.new("TextLabel") -- 423
    Icon.Name = "I_" .. math.random(10000, 99999) Icon.Size = UDim2.new(0, 30, 1, 0) Icon.Position = UDim2.new(0, 10, 0, 0) -- 424
    Icon.Text = "📋" Icon.BackgroundTransparency = 1 Icon.Font = Enum.Font.GothamBold Icon.TextSize = 18 Icon.Parent = Notification -- 425
    local Text = Instance.new("TextLabel") -- 426
    Text.Name = "T_" .. math.random(10000, 99999) Text.Size = UDim2.new(1, -50, 1, 0) Text.Position = UDim2.new(0, 45, 0, 0) -- 427
    Text.Text = getText("copy_success") Text.TextColor3 = Color3.fromRGB(255, 255, 255) Text.BackgroundTransparency = 1 -- 428
    Text.Font = Enum.Font.Gotham Text.TextSize = 12 Text.TextXAlignment = Enum.TextXAlignment.Left Text.Parent = Notification -- 429
    local tween1 = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 0, 20)}) -- 430
    tween1:Play() task.wait(5) -- 431
    local tween2 = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)}) -- 432
    tween2:Play() tween2.Completed:Connect(function() ScreenGui:Destroy() end) -- 433
end -- 434

local function createMobileWindow(title, onCallback, offCallback) -- 435
    local Player = Players.LocalPlayer -- 436
    local ScreenGui = Instance.new("ScreenGui") -- 437
    ScreenGui.Name = "MW_" .. math.random(10000, 99999) ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 438
    ScreenGui.ResetOnSpawn = false ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling ScreenGui.Archivable = false -- 439
    local MainFrame = Instance.new("Frame") -- 440
    MainFrame.Name = "F_" .. math.random(10000, 99999) MainFrame.Size = UDim2.new(0, 200, 0, 80) MainFrame.Position = UDim2.new(0.8, -10, 0.5, -40) -- 441
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) MainFrame.BorderSizePixel = 0 MainFrame.Parent = ScreenGui -- 442
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 443
    local TitleLabel = Instance.new("TextLabel") -- 444
    TitleLabel.Name = "T_" .. math.random(10000, 99999) TitleLabel.Size = UDim2.new(1, -30, 0, 25) TitleLabel.Position = UDim2.new(0, 10, 0, 5) -- 445
    TitleLabel.Text = title TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) TitleLabel.BackgroundTransparency = 1 -- 446
    TitleLabel.Font = Enum.Font.GothamBold TitleLabel.TextSize = 14 TitleLabel.Parent = MainFrame -- 447
    local CloseButton = Instance.new("TextButton") -- 448
    CloseButton.Name = "C_" .. math.random(10000, 99999) CloseButton.Size = UDim2.new(0, 20, 0, 20) CloseButton.Position = UDim2.new(1, -25, 0, 3) -- 449
    CloseButton.Text = getText("mobile_close") CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- 450
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) CloseButton.Font = Enum.Font.GothamBold CloseButton.TextSize = 12 CloseButton.Parent = MainFrame -- 451
    local ToggleButton = Instance.new("TextButton") -- 452
    ToggleButton.Name = "TB_" .. math.random(10000, 99999) ToggleButton.Size = UDim2.new(0.8, 0, 0, 35) ToggleButton.Position = UDim2.new(0.1, 0, 0.45, 0) -- 453
    ToggleButton.Text = getText("mobile_off") ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- 454
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) ToggleButton.Font = Enum.Font.GothamBold ToggleButton.TextSize = 14 ToggleButton.Parent = MainFrame -- 455
    local isActive = false -- 456
    ToggleButton.MouseButton1Click:Connect(function() -- 457
        if isActive then -- 458
            isActive = false ToggleButton.Text = getText("mobile_off") ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- 459
            if offCallback then pcall(offCallback) end -- 460
        else -- 461
            isActive = true ToggleButton.Text = getText("mobile_on") ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- 462
            if onCallback then pcall(onCallback) end -- 463
        end -- 464
    end) -- 465
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end) -- 466
    return ScreenGui -- 467
end -- 468

local function createRobloxBrowser() -- 469
    local Player = Players.LocalPlayer -- 470
    local ScreenGui = Instance.new("ScreenGui") -- 471
    ScreenGui.Name = "Browser_" .. math.random(10000, 99999) ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 472
    ScreenGui.ResetOnSpawn = false ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling ScreenGui.Archivable = false -- 473
    local MainFrame = Instance.new("Frame") -- 474
    MainFrame.Name = "BF_" .. math.random(10000, 99999) MainFrame.Size = UDim2.new(0, 500, 0, 300) MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150) -- 475
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) MainFrame.BorderSizePixel = 0 MainFrame.Parent = ScreenGui -- 476
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 477
    local Title = Instance.new("TextLabel") -- 478
    Title.Name = "BT_" .. math.random(10000, 99999) Title.Size = UDim2.new(1, -40, 0, 35) Title.Position = UDim2.new(0, 15, 0, 5) -- 479
    Title.Text = "🌐 ROBLOX BROWSER" Title.TextColor3 = Color3.fromRGB(255, 200, 0) Title.BackgroundTransparency = 1 -- 480
    Title.Font = Enum.Font.GothamBold Title.TextSize = 18 Title.Parent = MainFrame -- 481
    local CloseButton = Instance.new("TextButton") -- 482
    CloseButton.Name = "BC_" .. math.random(10000, 99999) CloseButton.Size = UDim2.new(0, 25, 0, 25) CloseButton.Position = UDim2.new(1, -30, 0, 5) -- 483
    CloseButton.Text = "✕" CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 484
    CloseButton.Font = Enum.Font.GothamBold CloseButton.TextSize = 14 CloseButton.Parent = MainFrame -- 485
    local URLInput = Instance.new("TextBox") -- 486
    URLInput.Name = "URL_" .. math.random(10000, 99999) URLInput.Size = UDim2.new(0.7, 0, 0, 35) URLInput.Position = UDim2.new(0.05, 0, 0.45, 0) -- 487
    URLInput.PlaceholderText = getText("browser_search") URLInput.Text = "" URLInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- 488
    URLInput.TextColor3 = Color3.fromRGB(255, 255, 255) URLInput.Font = Enum.Font.Gotham URLInput.TextSize = 14 URLInput.Parent = MainFrame -- 489
    local GoButton = Instance.new("TextButton") -- 490
    GoButton.Name = "GO_" .. math.random(10000, 99999) GoButton.Size = UDim2.new(0.2, 0, 0, 35) GoButton.Position = UDim2.new(0.78, 0, 0.45, 0) -- 491
    GoButton.Text = getText("browser_go") GoButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) GoButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 492
    GoButton.Font = Enum.Font.GothamBold GoButton.TextSize = 14 GoButton.Parent = MainFrame -- 493
    local sites = { -- 494
        {name = "Roblox", url = "https://www.roblox.com"}, -- 495
        {name = "YouTube", url = "https://www.youtube.com"}, -- 496
        {name = "Google", url = "https://www.google.com"}, -- 497
        {name = "GitHub", url = "https://github.com"}, -- 498
        {name = "Wikipedia", url = "https://www.wikipedia.org"} -- 499
    } -- 500
    local yPos = 0.6 -- 501
    for _, site in ipairs(sites) do -- 502
        local SiteButton = Instance.new("TextButton") -- 503
        SiteButton.Name = "Site_" .. math.random(10000, 99999) SiteButton.Size = UDim2.new(0.4, 0, 0, 30) -- 504
        SiteButton.Position = UDim2.new(0.05, 0, yPos, 0) SiteButton.Text = site.name -- 505
        SiteButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60) SiteButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 506
        SiteButton.Font = Enum.Font.Gotham SiteButton.TextSize = 12 SiteButton.Parent = MainFrame -- 507
        SiteButton.MouseButton1Click:Connect(function() -- 508
            pcall(function() setclipboard(site.url) end) createCopyNotification() -- 509
        end) -- 510
        yPos = yPos + 0.07 -- 511
    end -- 512
    local function openURL(url) -- 513
        if not url:find("https://") and not url:find("http://") then url = "https://" .. url end -- 514
        pcall(function() setclipboard(url) end) createCopyNotification() -- 515
    end -- 516
    GoButton.MouseButton1Click:Connect(function() if URLInput.Text ~= "" then openURL(URLInput.Text) end end) -- 517
    URLInput.FocusLost:Connect(function(enterPressed) if enterPressed and URLInput.Text ~= "" then openURL(URLInput.Text) end end) -- 518
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end) -- 519
end -- 520

local function animateKeySystemIn(MainFrame) -- 521
    MainFrame.Position = UDim2.new(0.5, -200, 1, 100) MainFrame.Visible = true -- 522
    local tween1 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -220)}) -- 523
    local tween2 = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -200)}) -- 524
    tween1:Play() tween1.Completed:Connect(function() tween2:Play() end) -- 525
end -- 526

local function animateKeySystemOut(MainFrame, ScreenGui, callback) -- 527
    local tween1 = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -220)}) -- 528
    local tween2 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -200, 1, 100)}) -- 529
    tween1:Play() tween1.Completed:Connect(function() tween2:Play() tween2.Completed:Connect(function() if callback then callback() end end) end) -- 530
end -- 531

local function createKeySystem() -- 532
    local Player = Players.LocalPlayer -- 533
    local ScreenGui = Instance.new("ScreenGui") -- 534
    ScreenGui.Name = "KS_" .. math.random(10000, 99999) ScreenGui.Parent = Player:WaitForChild("PlayerGui") -- 535
    ScreenGui.ResetOnSpawn = false ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling ScreenGui.Archivable = false -- 536
    local Background = Instance.new("Frame") -- 537
    Background.Name = "BG_" .. math.random(10000, 99999) Background.Size = UDim2.new(1, 0, 1, 0) Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- 538
    Background.BackgroundTransparency = 1 Background.Parent = ScreenGui -- 539
    local MainFrame = Instance.new("Frame") -- 540
    MainFrame.Name = "MF_" .. math.random(10000, 99999) MainFrame.Size = UDim2.new(0, 400, 0, 400) MainFrame.Position = UDim2.new(0.5, -200, 1, 100) -- 541
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) MainFrame.BorderSizePixel = 0 MainFrame.Visible = false MainFrame.Parent = ScreenGui -- 542
    local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 12) UICorner.Parent = MainFrame -- 543
    local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(255, 200, 0) UIStroke.Thickness = 2 UIStroke.Parent = MainFrame -- 544
    local CloseButton = Instance.new("TextButton") -- 545
    CloseButton.Name = "X_" .. math.random(10000, 99999) CloseButton.Size = UDim2.new(0, 25, 0, 25) CloseButton.Position = UDim2.new(1, -30, 0, 5) -- 546
    CloseButton.Text = "✕" CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 547
    CloseButton.Font = Enum.Font.GothamBold CloseButton.TextSize = 14 CloseButton.Parent = MainFrame -- 548
    local VersionLabel = Instance.new("TextLabel") -- 549
    VersionLabel.Name = "V_" .. math.random(10000, 99999) VersionLabel.Size = UDim2.new(1, 0, 0, 25) VersionLabel.Position = UDim2.new(0, 0, 0, 5) -- 550
    VersionLabel.Text = getText("version_text") VersionLabel.TextColor3 = Color3.fromRGB(150, 150, 150) VersionLabel.BackgroundTransparency = 1 -- 551
    VersionLabel.Font = Enum.Font.Gotham VersionLabel.TextSize = 12 VersionLabel.Parent = MainFrame -- 552
    local Title = Instance.new("TextLabel") -- 553
    Title.Name = "T_" .. math.random(10000, 99999) Title.Size = UDim2.new(1, 0, 0, 40) Title.Position = UDim2.new(0, 0, 0, 30) -- 554
    Title.Text = getText("key_title") Title.TextColor3 = Color3.fromRGB(255, 200, 0) Title.BackgroundTransparency = 1 -- 555
    Title.Font = Enum.Font.GothamBold Title.TextSize = 20 Title.Parent = MainFrame -- 556
    local LangTitle = Instance.new("TextLabel") -- 557
    LangTitle.Name = "L_" .. math.random(10000, 99999) LangTitle.Size = UDim2.new(1, 0, 0, 25) LangTitle.Position = UDim2.new(0, 0, 0.7, 0) -- 558
    LangTitle.Text = getText("lang_select_wait") LangTitle.TextColor3 = Color3.fromRGB(255, 200, 0) LangTitle.BackgroundTransparency = 1 -- 559
    LangTitle.Font = Enum.Font.GothamBold LangTitle.TextSize = 14 LangTitle.Parent = MainFrame -- 560
    local KeyInput = Instance.new("TextBox") -- 561
    KeyInput.Name = "K_" .. math.random(10000, 99999) KeyInput.Size = UDim2.new(0.6, 0, 0, 40) KeyInput.Position = UDim2.new(0.2, 0, 0.2, 0) -- 562
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50) KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255) KeyInput.Font = Enum.Font.Gotham -- 563
    KeyInput.TextSize = 18 KeyInput.ClearTextOnFocus = false KeyInput.PlaceholderText = "Выберите язык..." KeyInput.Text = "" KeyInput.Parent = MainFrame -- 564
    KeyInput.Active = false KeyInput.Selectable = false KeyInput.TextEditable = false -- 565
    local savedKey = loadKey() -- 566
    if savedKey then KeyInput.Text = savedKey KeyInput.PlaceholderText = getText("key_loaded") end -- 567
    local ErrorLabel = Instance.new("TextLabel") -- 568
    ErrorLabel.Name = "E_" .. math.random(10000, 99999) ErrorLabel.Size = UDim2.new(0.8, 0, 0, 25) ErrorLabel.Position = UDim2.new(0.1, 0, 0.33, 0) -- 569
    ErrorLabel.Text = "" ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) ErrorLabel.BackgroundTransparency = 1 -- 570
    ErrorLabel.Font = Enum.Font.Gotham ErrorLabel.TextSize = 14 ErrorLabel.Parent = MainFrame -- 571
    local CheckButton = Instance.new("TextButton") -- 572
    CheckButton.Name = "CB_" .. math.random(10000, 99999) CheckButton.Size = UDim2.new(0.4, 0, 0, 40) CheckButton.Position = UDim2.new(0.3, 0, 0.42, 0) -- 573
    CheckButton.Text = "✅ ПРОВЕРИТЬ" CheckButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 574
    CheckButton.Font = Enum.Font.GothamBold CheckButton.TextSize = 14 CheckButton.Parent = MainFrame -- 575
    local GetKeyButton = Instance.new("TextButton") -- 576
    GetKeyButton.Name = "GK_" .. math.random(10000, 99999) GetKeyButton.Size = UDim2.new(0.4, 0, 0, 40) GetKeyButton.Position = UDim2.new(0.3, 0, 0.55, 0) -- 577
    GetKeyButton.Text = getText("get_key") GetKeyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 578
    GetKeyButton.Font = Enum.Font.GothamBold GetKeyButton.TextSize = 14 GetKeyButton.Parent = MainFrame -- 579
    local RUBtn = Instance.new("TextButton") -- 580
    RUBtn.Name = "RU_" .. math.random(10000, 99999) RUBtn.Size = UDim2.new(0.35, 0, 0, 35) RUBtn.Position = UDim2.new(0.1, 0, 0.78, 0) -- 581
    RUBtn.Text = "🇷🇺 РУССКИЙ" RUBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) RUBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- 582
    RUBtn.Font = Enum.Font.GothamBold RUBtn.TextSize = 12 RUBtn.Parent = MainFrame -- 583
    local ENBtn = Instance.new("TextButton") -- 584
    ENBtn.Name = "EN_" .. math.random(10000, 99999) ENBtn.Size = UDim2.new(0.35, 0, 0, 35) ENBtn.Position = UDim2.new(0.55, 0, 0.78, 0) -- 585
    ENBtn.Text = "🇬🇧 ENGLISH" ENBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) ENBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- 586
    ENBtn.Font = Enum.Font.GothamBold ENBtn.TextSize = 12 ENBtn.Parent = MainFrame -- 587
    animateKeySystemIn(MainFrame) -- 588
    TweenService:Create(Background, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play() -- 589
    local blinking = true local blinkLoop -- 590
    blinkLoop = RunService.Heartbeat:Connect(function() -- 591
        if not blinking or languageSelected then if blinkLoop then blinkLoop:Disconnect() end return end -- 592
        local currentTransparency = LangTitle.TextTransparency -- 593
        local targetTransparency = currentTransparency > 0.5 and 0 or 1 -- 594
        TweenService:Create(LangTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = targetTransparency}):Play() -- 595
        task.wait(0.6) -- 596
    end) -- 597
    local function closeKeySystem() blinking = false animateKeySystemOut(MainFrame, ScreenGui, function() ScreenGui:Destroy() end) end -- 598
    CloseButton.MouseButton1Click:Connect(function() closeKeySystem() end) -- 599
    GetKeyButton.MouseButton1Click:Connect(function() pcall(function() setclipboard(KeyURL) end) createCopyNotification() end) -- 600
    local function unlockKeyInput() -- 601
        languageSelected = true blinking = false if blinkLoop then blinkLoop:Disconnect() end -- 602
        KeyInput.Active = true KeyInput.Selectable = true KeyInput.TextEditable = true -- 603
        KeyInput.PlaceholderText = getText("key_label") CheckButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- 604
        TweenService:Create(LangTitle, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play() -- 605
    end -- 606
    CheckButton.MouseButton1Click:Connect(function() -- 607
        if not languageSelected then ErrorLabel.Text = getText("select_language_first") ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) return end -- 608
        if KeyInput.Text == correctKey then -- 609
            ErrorLabel.Text = getText("key_success") ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- 610
            saveKey(KeyInput.Text) incrementScriptCounter() task.wait(0.5) -- 611
            animateKeySystemOut(MainFrame, ScreenGui, function() ScreenGui:Destroy() keyAccepted = true loadMainMenu() end) -- 612
        else ErrorLabel.Text = getText("key_error") ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) end -- 613
    end) -- 614
    KeyInput.FocusLost:Connect(function(enterPressed) -- 615
        if enterPressed and languageSelected then -- 616
            if KeyInput.Text == correctKey then -- 617
                ErrorLabel.Text = getText("key_success") ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- 618
                saveKey(KeyInput.Text) incrementScriptCounter() task.wait(0.5) -- 619
                animateKeySystemOut(MainFrame, ScreenGui, function() ScreenGui:Destroy() keyAccepted = true loadMainMenu() end) -- 620
            else ErrorLabel.Text = getText("key_error") ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0) end -- 621
        end -- 622
    end) -- 623
    RUBtn.MouseButton1Click:Connect(function() -- 624
        language = "RU" unlockKeyInput() -- 625
        Title.Text = getText("key_title") KeyInput.PlaceholderText = getText("key_label") -- 626
        CheckButton.Text = "✅ " .. getText("key_success"):gsub("✅ ", "") GetKeyButton.Text = getText("get_key") -- 627
        RUBtn.Text = getText("lang_ru") ENBtn.Text = getText("lang_en") ErrorLabel.Text = "" -- 628
    end) -- 629
    ENBtn.MouseButton1Click:Connect(function() -- 630
        language = "EN" unlockKeyInput() -- 631
        Title.Text = getText("key_title") KeyInput.PlaceholderText = getText("key_label") -- 632
        CheckButton.Text = "✅ " .. getText("key_success"):gsub("✅ ", "") GetKeyButton.Text = getText("get_key") -- 633
        RUBtn.Text = getText("lang_ru") ENBtn.Text = getText("lang_en") ErrorLabel.Text = "" -- 634
    end) -- 635
end -- 636

function loadMainMenu() -- 637
    local Window = Rayfield:CreateWindow({ -- 638
        Name = getText("menu_title"), LoadingTitle = "+1 JUMP MACE ESCAPE", LoadingSubtitle = "by ILOVEKOCMOC", -- 639
        ConfigurationSaving = {Enabled = true, FolderName = "ILOVEKOCMOC_Configs", FileName = "ILOVEKOCMOC"}, -- 640
        Discord = {Enabled = false, Invite = "", RememberJoins = false}, KeySystem = false -- 641
    }) -- 642

    local Player = Players.LocalPlayer -- 643
    local VirtualUser = game:GetService("VirtualUser") -- 644
    local UserInputService = game:GetService("UserInputService") -- 645
    local screenSize = workspace.CurrentCamera.ViewportSize -- 646
    local centerX = screenSize.X / 2 -- 647
    local centerY = screenSize.Y / 2 -- 648

    local MoneyTab = Window:CreateTab(getText("tab_money"), 4483362458) -- 649
    MoneyTab:CreateSection("💰 " .. (language == "RU" and "Заработок" or "Earnings")) -- 650

    MoneyTab:CreateButton({Name = getText("btn_wins"), Callback = function() -- 651
        local model = workspace:FindFirstChild("GiveWins") -- 652
        if model then local buttonModel = model:FindFirstChild("Button13") -- 653
            if buttonModel then local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 654
                if targetPart then local Character = Player.Character or Player.CharacterAdded:Wait() -- 655
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 656
                    if HumanoidRootPart then HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 1, 0) task.wait(0.1) end -- 657
                    local detector = targetPart:FindFirstChild("ClickDetector") if detector then detector:Fire() end -- 658
                end -- 659
            end -- 660
        end -- 661
    end}) -- 662

    MoneyTab:CreateKeybind({Name = getText("bind_wins"), CurrentKeybind = "Insert", HoldToInteract = false, Flag = "WinsBind", Callback = function() -- 663
        local model = workspace:FindFirstChild("GiveWins") -- 664
        if model then local buttonModel = model:FindFirstChild("Button13") -- 665
            if buttonModel then local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 666
                if targetPart then local Character = Player.Character or Player.CharacterAdded:Wait() -- 667
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 668
                    if HumanoidRootPart then HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 1, 0) task.wait(0.1) end -- 669
                    local detector = targetPart:FindFirstChild("ClickDetector") if detector then detector:Fire() end -- 670
                end -- 671
            end -- 672
        end -- 673
    end}) -- 674

    MoneyTab:CreateButton({Name = getText("btn_hell"), Callback = function() -- 675
        local model = workspace:FindFirstChild("HellGemGivers") -- 676
        if model then local buttonModel = model:FindFirstChild("HellButton3") -- 677
            if buttonModel then local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 678
                if targetPart then local Character = Player.Character or Player.CharacterAdded:Wait() -- 679
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 680
                    if HumanoidRootPart then HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 7, 0) task.wait(0.1) end -- 681
                    local detector = targetPart:FindFirstChild("ClickDetector") if detector then detector:Fire() end -- 682
                end -- 683
            end -- 684
        end -- 685
    end}) -- 686

    MoneyTab:CreateKeybind({Name = getText("bind_hell"), CurrentKeybind = "Home", HoldToInteract = false, Flag = "HellBind", Callback = function() -- 687
        local model = workspace:FindFirstChild("HellGemGivers") -- 688
        if model then local buttonModel = model:FindFirstChild("HellButton3") -- 689
            if buttonModel then local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part") -- 690
                if targetPart then local Character = Player.Character or Player.CharacterAdded:Wait() -- 691
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 692
                    if HumanoidRootPart then HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 7, 0) task.wait(0.1) end -- 693
                    local detector = targetPart:FindFirstChild("ClickDetector") if detector then detector:Fire() end -- 694
                end -- 695
            end -- 696
        end -- 697
    end}) -- 698

    local MainTab = Window:CreateTab(getText("tab_main"), 4483362458) -- 699
    MainTab:CreateSection("⚡ " .. (language == "RU" and "Функции" or "Functions")) -- 700

    local farming = false local farmLoop = nil local posLoop = nil -- 701

    local AutoFarmToggle = MainTab:CreateToggle({Name = getText("btn_farm"), CurrentValue = false, Flag = "AutoFarm", Callback = function(Value) -- 702
        if Value then StartAutoFarm() else StopAutoFarm() end -- 703
    end}) -- 704

    function StartAutoFarm() -- 705
        if farming then return end farming = true -- 706
        local targetPart = workspace:FindFirstChild("FirstTarget") -- 707
        if not targetPart then -- 708
            Rayfield:Notify({Title = getText("error_title"), Content = getText("err_target"), Duration = 6.5, Image = 4483362458}) -- 709
            farming = false return -- 710
        end -- 711
        local Character = Player.Character -- 712
        if Character then local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") if HumanoidRootPart then savedPosition = HumanoidRootPart.CFrame end end -- 713
        savedTargetPosition = targetPart.Position -- 714
        targetPart.Position = Vector3.new(targetPart.Position.X, -50, targetPart.Position.Z) -- 715
        if Character then local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 716
            if HumanoidRootPart then HumanoidRootPart.CFrame = targetPart.CFrame end -- 717 (ИГРОК ВНУТРИ FIRSTTARGET)
        end -- 718
        posLoop = RunService.Heartbeat:Connect(function() -- 719
            if not farming then if posLoop then posLoop:Disconnect() posLoop = nil end return end -- 720
            local Character = Player.Character -- 721
            if Character then local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 722
                if HumanoidRootPart and targetPart and targetPart.Parent then HumanoidRootPart.CFrame = targetPart.CFrame end -- 723 (УДЕРЖИВАЕТ ИГРОКА ВНУТРИ)
            end -- 724
        end) -- 725
        farmLoop = RunService.RenderStepped:Connect(function() -- 726
            if not farming then if farmLoop then farmLoop:Disconnect() farmLoop = nil end return end -- 727
            VirtualUser:ClickButton1(Vector2.new(centerX, centerY)) -- 728
        end) -- 729
        Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_farm_start"), Duration = 6.5, Image = 4483362458}) -- 730
    end -- 731

    function StopAutoFarm() -- 732
        farming = false -- 733
        if farmLoop then farmLoop:Disconnect() farmLoop = nil end -- 734
        if posLoop then posLoop:Disconnect() posLoop = nil end -- 735
        if savedTargetPosition then local targetPart = workspace:FindFirstChild("FirstTarget") if targetPart then targetPart.Position = savedTargetPosition end savedTargetPosition = nil end -- 736
        if savedPosition then local Character = Player.Character if Character then local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") if HumanoidRootPart then HumanoidRootPart.CFrame = savedPosition end end savedPosition = nil -- 737
            Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_return"), Duration = 6.5, Image = 4483362458}) -- 738
        else Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_farm_stop"), Duration = 6.5, Image = 4483362458}) end -- 739
    end -- 740

    MainTab:CreateKeybind({Name = getText("bind_farm"), CurrentKeybind = "F8", HoldToInteract = false, Flag = "FarmBind", Callback = function() -- 741
        if farming then StopAutoFarm() AutoFarmToggle:Set(false) else StartAutoFarm() AutoFarmToggle:Set(true) end -- 742
    end}) -- 743

    MainTab:CreateButton({Name = getText("btn_mobile_farm"), Callback = function() -- 744
        createMobileWindow(getText("mobile_farm_title"), function() StartAutoFarm() end, function() StopAutoFarm() end) -- 745
    end}) -- 746

    local infiniteJumps = false local jumpLoop = nil -- 747

    local InfiniteJumpsToggle = MainTab:CreateToggle({Name = getText("btn_jump"), CurrentValue = false, Flag = "InfiniteJumps", Callback = function(Value) -- 748
        if Value then StartInfiniteJumps() else StopInfiniteJumps() end -- 749
    end}) -- 750

    function StartInfiniteJumps() -- 751
        if infiniteJumps then return end infiniteJumps = true -- 752
        local targetPart = workspace:FindFirstChild("FirstTarget") -- 753
        if not targetPart then Rayfield:Notify({Title = getText("error_title"), Content = getText("err_target"), Duration = 6.5, Image = 4483362458}) infiniteJumps = false return end -- 754
        savedTargetPosition = targetPart.Position setTargetTransparency(targetPart, 1) -- 755
        jumpLoop = RunService.Heartbeat:Connect(function() -- 756
            if not infiniteJumps then if jumpLoop then jumpLoop:Disconnect() jumpLoop = nil end return end -- 757
            local Character = Player.Character -- 758
            if Character and Character:FindFirstChild("HumanoidRootPart") then -- 759
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") -- 760
                if HumanoidRootPart and targetPart and targetPart.Parent then targetPart.Position = HumanoidRootPart.Position end -- 761
            end -- 762
        end) -- 763
        Rayfield:Notify({Title = getText("jump_title"), Content = getText("success_jump_start"), Duration = 6.5, Image = 4483362458}) -- 764
    end -- 765

    function StopInfiniteJumps() -- 766
        infiniteJumps = false if jumpLoop then jumpLoop:Disconnect() jumpLoop = nil end -- 767
        if savedTargetPosition then local targetPart = workspace:FindFirstChild("FirstTarget") -- 768
            if targetPart then targetPart.Position = savedTargetPosition restoreTargetTransparency(targetPart) end savedTargetPosition = nil -- 769
        end -- 770
        Rayfield:Notify({Title = getText("jump_title"), Content = getText("success_jump_stop"), Duration = 6.5, Image = 4483362458}) -- 771
    end -- 772

    MainTab:CreateKeybind({Name = getText("bind_jump"), CurrentKeybind = "F9", HoldToInteract = false, Flag = "JumpBind", Callback = function() -- 773
        if infiniteJumps then StopInfiniteJumps() InfiniteJumpsToggle:Set(false) else StartInfiniteJumps() InfiniteJumpsToggle:Set(true) end -- 774
    end}) -- 775

    MainTab:CreateButton({Name = getText("btn_mobile_jump"), Callback = function() -- 776
        createMobileWindow(getText("mobile_jump_title"), function() StartInfiniteJumps() end, function() StopInfiniteJumps() end) -- 777
    end}) -- 778

    local maceActive = false local maceLoop = nil local maceSpeed = 5 local lastMaceHit = 0 -- 779

    local AutoMaceToggle = MainTab:CreateToggle({Name = getText("btn_mace"), CurrentValue = false, Flag = "AutoMace", Callback = function(Value) -- 780
        if Value then StartAutoMace() else StopAutoMace() end -- 781
    end}) -- 782

    function findMaceTargets() -- 783
        local targets = {} local firstTarget = workspace:FindFirstChild("FirstTarget") -- 784
        for _, descendant in ipairs(workspace:GetDescendants()) do -- 785
            if descendant.Name == "MaceTargetHighlight" then -- 786
                if descendant.Parent then -- 787
                    local isFirstTarget = false local current = descendant.Parent -- 788
                    while current do if current == firstTarget then isFirstTarget = true break end current = current.Parent end -- 789
                    if not isFirstTarget then -- 790
                        local found = false for _, t in ipairs(targets) do if t == descendant.Parent then found = true break end end -- 791
                        if not found then table.insert(targets, descendant.Parent) end -- 792
                    end -- 793
                end -- 794
            end -- 795
        end -- 796
        return targets -- 797
    end -- 798

    function StartAutoMace() -- 799
        if maceActive then return end maceActive = true -- 800
        maceLoop = RunService.Heartbeat:Connect(function() -- 801
            if not maceActive then if maceLoop then maceLoop:Disconnect() maceLoop = nil end return end -- 802
            local currentTime = tick() if currentTime - lastMaceHit < (1 / maceSpeed) then return end -- 803
            local targets = findMaceTargets() -- 804
            if #targets > 0 then VirtualUser:ClickButton1(Vector2.new(centerX, centerY)) lastMaceHit = tick() end -- 805
        end) -- 806
        Rayfield:Notify({Title = getText("mace_title"), Content = getText("success_mace_start"), Duration = 6.5, Image = 4483362458}) -- 807
    end -- 808

    function StopAutoMace() -- 809
        maceActive = false if maceLoop then maceLoop:Disconnect() maceLoop = nil end -- 810
        Rayfield:Notify({Title = getText("mace_title"), Content = getText("success_mace_stop"), Duration = 6.5, Image = 4483362458}) -- 811
    end -- 812

    MainTab:CreateKeybind({Name = getText("bind_mace"), CurrentKeybind = "F10", HoldToInteract = false, Flag = "MaceBind", Callback = function() -- 813
        if maceActive then StopAutoMace() AutoMaceToggle:Set(false) else StartAutoMace() AutoMaceToggle:Set(true) end -- 814
    end}) -- 815

    MainTab:CreateButton({Name = getText("btn_mobile_mace"), Callback = function() -- 816
        createMobileWindow(getText("mobile_mace_title"), function() StartAutoMace() end, function() StopAutoMace() end) -- 817
    end}) -- 818

    local PlayerTab = Window:CreateTab(getText("tab_player"), 4483362458) -- 819
    PlayerTab:CreateSection("👤 " .. (language == "RU" and "Параметры игрока" or "Player Settings")) -- 820

    local noclipActive = false local noclipLoop = nil -- 821

    local NoclipToggle = PlayerTab:CreateToggle({Name = getText("btn_noclip"), CurrentValue = false, Flag = "Noclip", Callback = function(Value) -- 822
        if Value then noclipActive = true -- 823
            noclipLoop = RunService.Stepped:Connect(function() -- 824
                if not noclipActive then if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end return end -- 825
                local Character = Player.Character if Character then for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end -- 826
            end) -- 827
        else noclipActive = false if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end -- 828
            local Character = Player.Character if Character then for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end -- 829
        end -- 830
    end}) -- 831

    PlayerTab:CreateKeybind({Name = getText("bind_noclip"), CurrentKeybind = "F11", HoldToInteract = false, Flag = "NoclipBind", Callback = function() -- 832
        if noclipActive then noclipActive = false NoclipToggle:Set(false) else noclipActive = true NoclipToggle:Set(true) end -- 833
    end}) -- 834

    PlayerTab:CreateButton({Name = getText("btn_mobile_noclip"), Callback = function() -- 835
        createMobileWindow(getText("mobile_noclip_title"), function() noclipActive = true end, function() noclipActive = false end) -- 836
    end}) -- 837

    PlayerTab:CreateSlider({Name = getText("speed_value"), Range = {16, 300}, Increment = 1, Suffix = "Speed", CurrentValue = 16, Flag = "SpeedSlider", Callback = function(Value) -- 838
        local Character = Player.Character if Character then local Humanoid = Character:FindFirstChild("Humanoid") if Humanoid then Humanoid.WalkSpeed = Value end end -- 839
    end}) -- 840

    PlayerTab:CreateSlider({Name = getText("jump_value"), Range = {50, 300}, Increment = 5, Suffix = "Power", CurrentValue = 50, Flag = "JumpPowerSlider", Callback = function(Value) -- 841
        local Character = Player.Character if Character then local Humanoid = Character:FindFirstChild("Humanoid") if Humanoid then Humanoid.JumpPower = Value end end -- 842
    end}) -- 843

    local espActive = false -- 844

    local EspToggle = PlayerTab:CreateToggle({Name = getText("btn_esp"), CurrentValue = false, Flag = "ESP", Callback = function(Value) -- 845
        if Value then espActive = true -- 846
            RunService.Heartbeat:Connect(function() -- 847
                if not espActive then return end -- 848
                for _, otherPlayer in ipairs(Players:GetPlayers()) do -- 849
                    if otherPlayer ~= Player and otherPlayer.Character then -- 850
                        local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight") -- 851
                        if not highlight then highlight = Instance.new("Highlight") highlight.Name = "ESPHighlight" -- 852
                            highlight.FillColor = Color3.fromRGB(255, 0, 0) highlight.OutlineColor = Color3.fromRGB(255, 255, 255) highlight.Parent = otherPlayer.Character -- 853
                        end -- 854
                    end -- 855
                end -- 856
            end) -- 857
        else espActive = false -- 858
            for _, otherPlayer in ipairs(Players:GetPlayers()) do -- 859
                if otherPlayer.Character then local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight") if highlight then highlight:Destroy() end end -- 860
            end -- 861
        end -- 862
    end}) -- 863

    PlayerTab:CreateKeybind({Name = getText("bind_esp"), CurrentKeybind = "F12", HoldToInteract = false, Flag = "EspBind", Callback = function() -- 864
        if espActive then espActive = false EspToggle:Set(false) else espActive = true EspToggle:Set(true) end -- 865
    end}) -- 866

    PlayerTab:CreateButton({Name = getText("btn_mobile_esp"), Callback = function() -- 867
        createMobileWindow(getText("mobile_esp_title"), function() espActive = true end, function() espActive = false end) -- 868
    end}) -- 869

    local antiafkActive = false local antiafkLoop = nil -- 870

    local AntiAfkToggle = PlayerTab:CreateToggle({Name = getText("btn_antiafk"), CurrentValue = false, Flag = "AntiAFK", Callback = function(Value) -- 871
        if Value then antiafkActive = true -- 872
            antiafkLoop = RunService.Heartbeat:Connect(function() -- 873
                if not antiafkActive then if antiafkLoop then antiafkLoop:Disconnect() antiafkLoop = nil end return end -- 874
                VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new(0, 0)) -- 875
            end) -- 876
        else antiafkActive = false if antiafkLoop then antiafkLoop:Disconnect() antiafkLoop = nil end end -- 877
    end}) -- 878

    PlayerTab:CreateKeybind({Name = getText("bind_antiafk"), CurrentKeybind = "Pause", HoldToInteract = false, Flag = "AntiAfkBind", Callback = function() -- 879
        if antiafkActive then antiafkActive = false AntiAfkToggle:Set(false) else antiafkActive = true AntiAfkToggle:Set(true) end -- 880
    end}) -- 881

    PlayerTab:CreateButton({Name = getText("btn_mobile_antiafk"), Callback = function() -- 882
        createMobileWindow(getText("mobile_antiafk_title"), function() antiafkActive = true end, function() antiafkActive = false end) -- 883
    end}) -- 884

    local FunTab = Window:CreateTab(getText("tab_fun"), 4483362458) -- 885
    FunTab:CreateSection("🎮 " .. (language == "RU" and "Развлечения" or "Entertainment")) -- 886

    FunTab:CreateButton({Name = getText("btn_browser"), Callback = function() createRobloxBrowser() end}) -- 887
    FunTab:CreateButton({Name = getText("btn_copy_script"), Callback = function() pcall(function() setclipboard("https://raw.githubusercontent.com/ILOVEKOCMOC/ILOVEKOCMOC-Scripts/refs/heads/main/%2B1%20Jump%20Mace%20Escape.lua") end) createCopyNotification() end}) -- 888
    FunTab:CreateButton({Name = getText("btn_random_tp"), Callback = function() local Character = Player.Character if Character then local hrp = Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame = CFrame.new(math.random(-200, 200), math.random(10, 100), math.random(-200, 200)) end end end}) -- 889
    local rainbowActive = false -- 890
    FunTab:CreateButton({Name = getText("btn_rainbow"), Callback = function() rainbowActive = not rainbowActive spawn(function() while rainbowActive do local Character = Player.Character if Character then for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") then part.Color = Color3.fromHSV(tick() % 1, 1, 1) end end end task.wait(0.05) end end) end}) -- 891
    FunTab:CreateButton({Name = getText("btn_spin"), Callback = function() local Character = Player.Character if Character then local hrp = Character:FindFirstChild("HumanoidRootPart") if hrp then spawn(function() for i = 1, 50 do if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(36), 0) end task.wait(0.05) end end) end end end}) -- 892
    FunTab:CreateButton({Name = getText("btn_giant"), Callback = function() local Character = Player.Character if Character then for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Size = part.Size * 3 end end end end}) -- 893
    FunTab:CreateButton({Name = getText("btn_tiny"), Callback = function() local Character = Player.Character if Character then for _, part in ipairs(Character:GetDescendants()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Size = part.Size / 3 end end end end}) -- 894
    local flyActive = false -- 895
    FunTab:CreateButton({Name = getText("btn_fly"), Callback = function() flyActive = not flyActive spawn(function() while flyActive do local Character = Player.Character if Character then local hrp = Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.Velocity = Vector3.new(0, 50, 0) end end task.wait(0.1) end end) end}) -- 896
    local bounceActive = false -- 897
    FunTab:CreateButton({Name = getText("btn_bounce"), Callback = function() bounceActive = not bounceActive spawn(function() while bounceActive do local Character = Player.Character if Character then local hrp = Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.Velocity = Vector3.new(0, 100, 0) end end task.wait(0.5) end end) end}) -- 898

    local LogsTab = Window:CreateTab(getText("tab_logs"), 4483362458) -- 899
    LogsTab:CreateSection("📋 " .. (language == "RU" and "История обновлений" or "Update History")) -- 900
    for _, log in ipairs(updateLogs) do LogsTab:CreateLabel("🔹 v" .. log.version) LogsTab:CreateParagraph({Title = "Изменения:", Content = log.changes}) end -- 901

    local CreatorTab = Window:CreateTab(getText("tab_creator"), 4483362458) -- 902
    CreatorTab:CreateSection("⚠️ " .. (language == "RU" and "ВНИМАНИЕ" or "WARNING")) -- 903
    CreatorTab:CreateLabel(getText("creator_dev_warning")) -- 904
    CreatorTab:CreateLabel(getText("creator_dev_warning2")) -- 905
    CreatorTab:CreateSection("👑 " .. (language == "RU" and "Доступ разработчика" or "Developer Access")) -- 906

    local creatorAccessGranted = false -- 907
    local CreatorKeyInput = CreatorTab:CreateInput({Name = getText("creator_key_label"), PlaceholderText = "Ключ...", RemoveTextAfterFocusLost = false, Callback = function(Text) -- 908
        if Text == creatorKey then creatorAccessGranted = true Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_key_success"), Duration = 6.5, Image = 4483362458}) loadCreatorPanel() -- 909
        else Rayfield:Notify({Title = getText("error_title"), Content = getText("creator_key_error"), Duration = 6.5, Image = 4483362458}) end -- 910
    end}) -- 911

    function loadCreatorPanel() -- 912
        if not creatorAccessGranted then return end -- 913
        CreatorTab:CreateSection("🌍 " .. (language == "RU" and "Статистика" or "Statistics")) -- 914
        local globalUsersLabel = CreatorTab:CreateLabel(getText("creator_global_users") .. "0") -- 915
        local syncLoop syncLoop = RunService.Heartbeat:Connect(function() -- 916
            if not creatorAccessGranted then if syncLoop then syncLoop:Disconnect() end return end -- 917
            spawn(function() pcall(function() local users = getGlobalScriptUsers() globalUsersLabel:Set(getText("creator_global_users") .. tostring(users)) end) end) task.wait(1) -- 918
        end) -- 919
        CreatorTab:CreateSection("⚡ " .. (language == "RU" and "Глобальные действия" or "Global Actions")) -- 920
        CreatorTab:CreateButton({Name = getText("creator_kick_global"), Callback = function() sendGlobalCommand("kick", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 921
        CreatorTab:CreateButton({Name = getText("creator_kill_global"), Callback = function() sendGlobalCommand("kill", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 922
        CreatorTab:CreateButton({Name = getText("creator_freeze_global"), Callback = function() sendGlobalCommand("freeze", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 923
        CreatorTab:CreateButton({Name = getText("creator_unfreeze_global"), Callback = function() sendGlobalCommand("unfreeze", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 924
        CreatorTab:CreateButton({Name = getText("creator_heal_global"), Callback = function() sendGlobalCommand("heal", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 925
        CreatorTab:CreateButton({Name = getText("creator_fling_global"), Callback = function() sendGlobalCommand("fling", nil) Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458}) end}) -- 926
    end -- 927

    local SettingsTab = Window:CreateTab("⚙️ " .. (language == "RU" and "Настройки" or "Settings"), 4483362458) -- 928
    SettingsTab:CreateButton({Name = getText("btn_close"), Callback = function() -- 929
        StopAutoFarm() StopInfiniteJumps() StopAutoMace() -- 930
        noclipActive = false espActive = false antiafkActive = false -- 931
        rainbowActive = false flyActive = false bounceActive = false -- 932
        if noclipLoop then noclipLoop:Disconnect() end if antiafkLoop then antiafkLoop:Disconnect() end -- 933
        Rayfield:Destroy() -- 934
    end}) -- 935

    Rayfield:Notify({Title = "ILOVEKOCMOC", Content = getText("loaded"), Duration = 6.5, Image = 4483362458}) -- 936
end -- 937

createKeySystem() -- 938

print("✅ +1 JUMP MACE ESCAPE v2.0.1 LOADED") -- 939
