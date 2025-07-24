--================================================================--
--      SKRIP VERSI FINAL LENGKAP (WINDUI) - OLEH PARTNER CODING     --
--================================================================--

-- !-- FITUR BARU: Notifikasi Progres Pemuatan --!
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "1% - Memulai eksekusi...", Duration = 2 }) end)
local startTime = tick()

task.wait(1)

-- Pemuatan Library yang Aman (Safe Loading)
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Error", Text = "Gagal memuat WindUI Library. Periksa konsol (F9) untuk detail.", Duration = 10
    })
    warn("WindUI Gagal Dimuat! Error: " .. tostring(WindUI))
    return
end

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "10% - Library UI berhasil dimuat.", Duration = 2 }) end)

-- Variabel Global
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variabel Status Fitur
local instantMineEnabled, antiFallDamageEnabled, flyEnabled, autoSellEnabled, autoRankUpEnabled = false, false, false, false, false
local walkspeedValue = 16
local flySpeed = 50 
local floatPlatformEnabled = false
local floatPlatform, platformConnection, platformY = nil, nil, 0
local originalToolStats, lastKnownTool = {}, nil
local bringWeld, attachWeld = nil, nil
local selectedBackpackItems, selectedStorageItems = {}, {}
local originalStreamingEnabled = workspace.StreamingEnabled

-- Buat Jendela Utama
local screenSize = workspace.CurrentCamera.ViewportSize
local windowWidth = math.min(screenSize.X * 0.9, 580)
local windowHeight = math.min(screenSize.Y * 0.8, 520)
local Window = WindUI:CreateWindow({
    Title = "Abyss Miner Menu", Author = "Partner Coding", Folder = "AbyssMinerWindUI_Final",
    Size = UDim2.fromOffset(windowWidth, windowHeight), Theme = "Dark", User = { Enabled = true }, ToggleKey = Enum.KeyCode.RightShift
})
local uiElements = {}
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "25% - Jendela utama dibuat.", Duration = 2 }) end)

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--
local flying = false; local bodyVelocity, bodyGyro; local originalMouseBehavior
local function startFly() local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") or flying then return end; local rootPart = char.HumanoidRootPart; bodyGyro = Instance.new("BodyGyro", rootPart); bodyGyro.P = 9e4; bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro.CFrame = rootPart.CFrame; bodyVelocity = Instance.new("BodyVelocity", rootPart); bodyVelocity.Velocity = Vector3.new(0, 0, 0); bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9); flying = true; Player.DevEnableMouseLock = true; originalMouseBehavior = UserInputService.MouseBehavior; UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter end
local function stopFly() if bodyGyro then bodyGyro:Destroy() end; if bodyVelocity then bodyVelocity:Destroy() end; flying = false; Player.DevEnableMouseLock = false; if originalMouseBehavior then UserInputService.MouseBehavior = originalMouseBehavior end end
local function findPlayerByUsername(name) local targetName = name:lower(); if not targetName or targetName == "" then return nil end; for _, player in ipairs(game:GetService("Players"):GetPlayers()) do if string.find(player.Name:lower(), targetName, 1, true) then return player end end; return nil end
local function restoreToolStats() if lastKnownTool and originalToolStats[lastKnownTool] then local tool = lastKnownTool; local stats = originalToolStats[lastKnownTool]; pcall(function() if stats.Speed and tool:FindFirstChild("Speed") then tool.Speed.Value = stats.Speed end end); originalToolStats[lastKnownTool] = nil end end

RunService.Heartbeat:Connect(function()
    local char = Player.Character; if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid"); if not humanoid then return end
    if walkspeedValue and humanoid.WalkSpeed ~= walkspeedValue then humanoid.WalkSpeed = walkspeedValue end
    if flying and char:FindFirstChild("HumanoidRootPart") then
        local rootPart = char.HumanoidRootPart; local camera = workspace.CurrentCamera; local moveDirection = humanoid.MoveDirection; local flyVelocity = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit * flySpeed
        if uiElements.FlyUp and uiElements.FlyUp.Button.MouseButton1Down then flyVelocity = flyVelocity + Vector3.new(0, flySpeed, 0) end
        if uiElements.FlyDown and uiElements.FlyDown.Button.MouseButton1Down then flyVelocity = flyVelocity - Vector3.new(0, flySpeed, 0) end
        bodyVelocity.Velocity = flyVelocity; bodyGyro.CFrame = camera.CFrame
    end
    if instantMineEnabled then local tool = char:FindFirstChildOfClass("Tool"); if tool and tool ~= lastKnownTool then restoreToolStats(); lastKnownTool = tool end; if tool then if not originalToolStats[tool] then originalToolStats[tool] = { Speed = tool:FindFirstChild("Speed") and tool.Speed.Value } end; pcall(function() local speed = tool:FindFirstChild("Speed"); if speed then speed.Value = 0 end end) else restoreToolStats(); lastKnownTool = nil end end
    local rootPart = char:FindFirstChild("HumanoidRootPart"); if not rootPart then return end;
    if antiFallDamageEnabled then
        local isFalling = false; local startFallY = 0; local fallDamageThreshold = 40
        if humanoid.FloorMaterial == Enum.Material.Air and rootPart.Velocity.Y < -30 then
            if not isFalling then isFalling = true; startFallY = rootPart.Position.Y end
        else
            if isFalling then isFalling = false; local fallDistance = startFallY - rootPart.Position.Y; if fallDistance > fallDamageThreshold then humanoid.Health = humanoid.MaxHealth end end
        end
    end
end)

--================================================================--
--                         UI TABS & ELEMENTS                       --
--================================================================--
local TabMain = Window:Tab({ Title = "Main", Icon = "pickaxe" })
local TabPlayer = Window:Tab({ Title = "Player", Icon = "user" })
local TabRankUp = Window:Tab({ Title = "Rank Up", Icon = "award" })
local TabStorage = Window:Tab({ Title = "Storage", Icon = "archive" })
local TabTeleport = Window:Tab({ Title = "Teleportasi", Icon = "map-pin" })
local TabAdvanced = Window:Tab({ Title = "Advanced", Icon = "shield" })
Window:SelectTab(1)

uiElements.InstantMine = TabMain:Toggle({ Title = "Instant Mine (Speed Only)", Desc = "Aktifkan, lalu tahan klik untuk mining super cepat.", Default = false, Callback = function(state) instantMineEnabled = state; if not state then restoreToolStats() end end })
uiElements.AutoSell = TabMain:Toggle({ Title = "Auto Sell (15 detik)", Desc = "Otomatis menjual jika dekat dengan NPC.", Default = false, Callback = function(state) 
    autoSellEnabled = state
    if autoSellEnabled then
        task.spawn(function()
            while autoSellEnabled do
                pcall(function()
                    local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true)
                    local char = Player.Character
                    if npc and char and char:FindFirstChild("HumanoidRootPart") then
                        local distance = (npc:GetPrimaryPartCFrame().Position - char.PrimaryPart.Position).Magnitude
                        if distance < 100 then local tool = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool"); if tool then game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool) end end
                    end
                end)
                task.wait(15)
            end
        end)
    end
end })
uiElements.SellSingle = TabMain:Button({ Title = "Jual Item di Tangan", Desc = "Menjual item yang sedang dipegang (harus dekat NPC).", Callback = function() 
    pcall(function() 
        local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true)
        if npc then game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellSingleone"):FireServer(npc, npc.HumanoidRootPart:WaitForChild("Dialogue")) end 
    end) 
end})
TabMain:Button({ Title = "Jual Semua (Jarak Jauh)", Desc = "Menggunakan metode teleport cepat untuk menjual dari mana saja.", Callback = function()
    local char = Player.Character; if not (char and char:FindFirstChild("HumanoidRootPart")) then WindUI:Notify({Title="Gagal", Content="Karakter tidak ditemukan."}); return end
    local rootPart = char.HumanoidRootPart; local originalCFrame = rootPart.CFrame
    local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true)
    local tool = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
    if not (npc and tool) then WindUI:Notify({Title="Gagal", Content="NPC atau Tool tidak ditemukan."}); return end
    pcall(function() rootPart.CFrame = npc:GetPrimaryPartCFrame() * CFrame.new(0, 0, 5); task.wait(0.1); game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool); task.wait(0.1); rootPart.CFrame = originalCFrame; WindUI:Notify({Title="Berhasil", Content="Semua item berhasil dijual dari jarak jauh!"}) end)
end})
TabMain:Button({ Title = "Buka/Tutup Konsol (F9)", Desc = "Membuka konsol developer untuk debugging.", Callback = function() pcall(function() local devConsole = CoreGui:FindFirstChild("DevConsole"); if devConsole then devConsole.Enabled = not devConsole.Enabled end end) end})
uiElements.BypassPause = TabMain:Toggle({ Title = "Bypass Gameplay Paused", Desc = "Mencegah layar 'Gameplay Paused' muncul saat teleport/terbang.", Default = false, Callback = function(state)
    if state then
        pcall(function() local networkPauseScript = CoreGui:FindFirstChild("RobloxGui", true) and CoreGui.RobloxGui:FindFirstChild("CoreScripts/NetworkPause"); if networkPauseScript then networkPauseScript:Destroy() end end)
        workspace.StreamingEnabled = false
        WindUI:Notify({Title="Bypass", Content="Bypass Gameplay Paused: AKTIF"})
    else
        workspace.StreamingEnabled = originalStreamingEnabled
        WindUI:Notify({Title="Bypass", Content="Bypass Gameplay Paused: NONAKTIF"})
    end
end})

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "50% - Fitur Main selesai dimuat.", Duration = 2 }) end)

uiElements.Walkspeed = TabPlayer:Slider({ Title = "Walkspeed", Value = { Min = 16, Max = 100, Default = 16 }, Step = 1, Suffix = " speed", Callback = function(value) walkspeedValue = value end })
uiElements.FlySpeed = TabPlayer:Slider({ Title = "Kecepatan Terbang", Desc = "Kecepatan tinggi (>50) dapat menyebabkan kick.", Value = { Min = 10, Max = 200, Default = 50 }, Step = 5, Suffix = " speed", Callback = function(value) flySpeed = value end })
uiElements.AntiFall = TabPlayer:Toggle({ Title = "Anti Fall Damage", Desc = "Mencegah damage saat jatuh.", Default = false, Callback = function(state) antiFallDamageEnabled = state end })
uiElements.FloatPlatform = TabPlayer:Toggle({ Title = "Float Platform", Desc = "Berjalan di udara pada ketinggian yang sama.", Default = false, Callback = function(state)
    floatPlatformEnabled = state; local char = Player.Character
    if state and char and char:FindFirstChild("HumanoidRootPart") then if floatPlatform then floatPlatform:Destroy() end; local rootPart = char.HumanoidRootPart; platformY = rootPart.Position.Y - 4; floatPlatform = Instance.new("Part", workspace); floatPlatform.Anchored = true; floatPlatform.CanCollide = true; floatPlatform.Size = Vector3.new(15, 1, 15); floatPlatform.Transparency = 1; floatPlatform.Name = "MyFloatPlatform"; platformConnection = game:GetService("RunService").Heartbeat:Connect(function() if floatPlatform and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local currentRoot = Player.Character.HumanoidRootPart; floatPlatform.Position = Vector3.new(currentRoot.Position.X, platformY, currentRoot.Position.Z) else if platformConnection then platformConnection:Disconnect() end; if floatPlatform then floatPlatform:Destroy() end end end)
    else if platformConnection then platformConnection:Disconnect(); platformConnection = nil end; if floatPlatform then floatPlatform:Destroy(); floatPlatform = nil end end
end })
uiElements.Fly = TabPlayer:Toggle({ Title = "Toggle Fly", Desc = "Otomatis shift-lock. Gunakan joystick untuk arah.", Default = false, Callback = function(state) flyEnabled = state; if state then startFly() else stopFly() end end })
uiElements.FlyUp = TabPlayer:Button({ Title = "Naik (Tahan)", Desc = "Tahan untuk terbang ke atas." })
uiElements.FlyDown = TabPlayer:Button({ Title = "Turun (Tahan)", Desc = "Tahan untuk terbang ke bawah." })

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "75% - Fitur Player selesai dimuat.", Duration = 2 }) end)

local RankInfoParagraph = TabRankUp:Paragraph({ Title = "Informasi Rank", Desc = "Klik 'Tampilkan Info Rank' untuk memuat data terbaru." })
TabRankUp:Button({
    Title = "Tampilkan/Perbarui Info Rank", Desc = "Membaca data dari GUI asli. Pastikan di layer yang sama dengan NPC Karl.",
    Callback = function()
        local karl = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Karl"); if not karl then return end
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("RankUpGui"):FireServer(karl, karl.HumanoidRootPart:WaitForChild("Dialogue"))
        task.wait(0.7)
        local rankMenu = Player.PlayerGui:FindFirstChild("MainGui", true) and Player.PlayerGui.MainGui:FindFirstChild("RankMenu")
        if rankMenu and rankMenu:FindFirstChild("BG") then local bg = rankMenu.BG; local currentRank = bg:FindFirstChild("namerank") and bg.namerank.Text or "[Tidak Ditemukan]"; local nextRank = bg:FindFirstChild("namenextrank") and bg.namenextrank.Text or "[Tidak Ditemukan]"; local reqs = "Syarat Mineral: [Tidak Ditemukan]"; for _,v in ipairs(bg:GetDescendants()) do if v:IsA("TextLabel") and string.find(v.Text:lower(), "required:") then reqs = v.Text; break end end; RankInfoParagraph:SetDesc(string.format("Rank Saat Ini: %s\nRank Selanjutnya: %s\n\n%s", currentRank, nextRank, reqs)); rankMenu.Enabled = false
        else RankInfoParagraph:SetDesc("Gagal menemukan GUI Rank Up. Coba buka manual sekali.") end
    end
})
local rankUpDebounce = false
TabRankUp:Button({ Title = "Rank Up", Desc = "Mencoba untuk menaikkan rank jika item sudah cukup.", Callback = function() if rankUpDebounce then WindUI:Notify({Title="Cooldown", Content="Harap tunggu sebentar.", Icon="hourglass"}); return end; rankUpDebounce = true; pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("RankUP"):FireServer() end); WindUI:Notify({ Title = "Rank Up", Content = "Permintaan Rank Up telah dikirim!", Icon = "arrow-up-circle" }); task.wait(1); rankUpDebounce = false end})
uiElements.AutoRankUp = TabRankUp:Toggle({ Title = "Auto Rank Up", Desc = "(Fitur dalam pengembangan)", Default = false, Callback = function(state) autoRankUpEnabled = state; end })

local backpackFrame = TabStorage:Paragraph({Title = "Backpack", Desc = ""})
local storageFrame = TabStorage:Paragraph({Title = "Storage", Desc = ""})
local function refreshStorageUI()
    for _, child in ipairs(backpackFrame.Container:GetChildren()) do if child.Name == "ItemToggle" then child:Destroy() end end
    for _, child in ipairs(storageFrame.Container:GetChildren()) do if child.Name == "ItemToggle" then child:Destroy() end end
    selectedBackpackItems, selectedStorageItems = {}, {}
    for _, item in ipairs(Player.Backpack:GetChildren()) do local itemToggle = TabStorage:Toggle({ Title = item.Name, Parent = backpackFrame.Container, Default = false, Callback = function(state) selectedBackpackItems[item] = state end }); itemToggle.ToggleFrame.Name = "ItemToggle" end
    local storageFolder = Player:FindFirstChild("HiddenStats", true) and Player.HiddenStats:FindFirstChild("Storage"); if storageFolder then for _, item in ipairs(storageFolder:GetChildren()) do local itemToggle = TabStorage:Toggle({ Title = item.Name, Parent = storageFrame.Container, Default = false, Callback = function(state) selectedStorageItems[item] = state end }); itemToggle.ToggleFrame.Name = "ItemToggle" end end
end
TabStorage:Button({ Title = "Pindahkan SEMUA Mineral ke Storage", Desc="Memindahkan semua mineral (bukan tool utama) ke storage.", Callback = function()
    local toolBlacklist = {["Main Tool"]=true, ["Equipment"]=true, ["Collection Book"]=true, ["Whistle"]=true}; local itemsToMove = {}; for _, item in ipairs(Player.Backpack:GetChildren()) do if item:IsA("Tool") and not toolBlacklist[item.Name] then table.insert(itemsToMove, item) end end
    for _, item in ipairs(itemsToMove) do pcall(function() game:GetService("ReplicatedStorage").RemoteEvent.Storage:FireServer(false, item) end); task.wait() end
    WindUI:Notify({Title="Storage", Content="Semua mineral telah dipindahkan."}); task.wait(0.5); refreshStorageUI()
end})
TabStorage:Button({ Title = "Ambil Item Terpilih dari Storage", Desc="Ambil item yang dipilih dari storage ke backpack.", Callback = function()
    local storageFolder = Player:FindFirstChild("HiddenStats", true) and Player.HiddenStats:FindFirstChild("Storage"); if not storageFolder then return end
    local itemsToTake = {}; for item, state in pairs(selectedStorageItems) do if state then table.insert(itemsToTake, item) end end
    if #itemsToTake == 0 then WindUI:Notify({Title="Storage", Content="Tidak ada item yang dipilih."}); return end
    for _, item in ipairs(itemsToTake) do if item.Parent == storageFolder then pcall(function() game:GetService("ReplicatedStorage").RemoteEvent.Storage:FireServer(true, item) end); task.wait() end end
    task.wait(0.5); refreshStorageUI()
end})
TabStorage:Button({ Title = "Refresh Daftar", Desc = "Memuat ulang daftar item.", Callback = refreshStorageUI })

local PlayerDropdown; local function refreshPlayerList() local playerNames = {}; for _, p in ipairs(game:GetService("Players"):GetPlayers()) do if p ~= Player then table.insert(playerNames, p.Name) end end; if PlayerDropdown then PlayerDropdown:Refresh(playerNames) else PlayerDropdown = TabTeleport:Dropdown({ Title = "Pilih Pemain (Username)", Values = playerNames, Value = nil }) end end
refreshPla