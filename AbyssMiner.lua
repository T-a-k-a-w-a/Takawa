--================================================================--
--      SKRIP VERSI FINAL (WINDUI + NOTIFIKASI PROGRES) - OLEH PARTNER CODING     --
--================================================================--

-- Langkah 1: Notifikasi Progres Awal
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Memuat Skrip...",
    Text = "1% - Skrip sedang dieksekusi.",
    Duration = 2
})
local startTime = tick() -- Mulai hitung waktu

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

WindUI:Notify({ Title = "Memuat...", Content = "10% - Library UI berhasil dimuat.", Icon = "loader-circle", Duration = 2 })

-- Variabel Global
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variabel Status Fitur
local instantMineEnabled, antiFallDamageEnabled, flyEnabled, autoSellEnabled = false, false, false, false
local walkspeedValue = 16
local flySpeed = 50 
local floatPlatformEnabled = false
local floatPlatform, platformConnection, platformY = nil, nil, 0
local originalToolStats, lastKnownTool = {}, nil
local selectedBackpackItems, selectedStorageItems = {}, {}

-- Buat Jendela Utama
local screenSize = workspace.CurrentCamera.ViewportSize
local windowWidth = math.min(screenSize.X * 0.9, 580)
local windowHeight = math.min(screenSize.Y * 0.8, 520)
local Window = WindUI:CreateWindow({
    Title = "Abyss Miner Menu", Author = "Partner Coding", Folder = "AbyssMinerWindUI_v15",
    Size = UDim2.fromOffset(windowWidth, windowHeight), Theme = "Dark", User = { Enabled = true }, ToggleKey = Enum.KeyCode.RightShift
})
local uiElements = {}

WindUI:Notify({ Title = "Memuat...", Content = "25% - Jendela utama dibuat.", Icon = "loader-circle", Duration = 2 })

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--
local flying = false; local bodyVelocity, bodyGyro; local originalMouseBehavior
local function startFly() local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") or flying then return end; local rootPart = char.HumanoidRootPart; bodyGyro = Instance.new("BodyGyro", rootPart); bodyGyro.P = 9e4; bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro.CFrame = rootPart.CFrame; bodyVelocity = Instance.new("BodyVelocity", rootPart); bodyVelocity.Velocity = Vector3.new(0, 0, 0); bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9); flying = true; Player.DevEnableMouseLock = true; originalMouseBehavior = UserInputService.MouseBehavior; UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter end
local function stopFly() if bodyGyro then bodyGyro:Destroy() end; if bodyVelocity then bodyVelocity:Destroy() end; flying = false; Player.DevEnableMouseLock = false; if originalMouseBehavior then UserInputService.MouseBehavior = originalMouseBehavior end end
local function findPlayer(name) local targetName = name:lower(); for _, player in ipairs(game:GetService("Players"):GetPlayers()) do if string.find(player.Name:lower(), targetName, 1, true) or string.find(player.DisplayName:lower(), targetName, 1, true) then return player end end; return nil end
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

Player.CharacterAdded:Connect(function(char) 
    local humanoid = char:WaitForChild("Humanoid"); humanoid.StateChanged:Connect(function(old, new) if new == Enum.HumanoidStateType.Landed and antiFallDamageEnabled then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Swimming) end) end end)
    task.wait(2)
    pcall(function()
        if instantMineEnabled and uiElements.InstantMine then uiElements.InstantMine:Set(true) end
        if autoSellEnabled and uiElements.AutoSell then uiElements.AutoSell:Set(true) end
        if antiFallDamageEnabled and uiElements.AntiFall then uiElements.AntiFall:Set(true) end
        if floatPlatformEnabled and uiElements.FloatPlatform then uiElements.FloatPlatform:Set(true) end
        if flyEnabled and uiElements.Fly then uiElements.Fly:Set(true) end
        if uiElements.Walkspeed then uiElements.Walkspeed:Set(walkspeedValue) end
    end)
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
uiElements.AutoSell = TabMain:Toggle({ Title = "Auto Sell (15 detik)", Desc = "Menjual semua item di inventory setiap 15 detik.", Default = false, Callback = function(state) autoSellEnabled = state; if autoSellEnabled then task.spawn(function() while autoSellEnabled do pcall(function() local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true); local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool"); if npc and tool then game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool) end end); task.wait(15) end end) end end })

WindUI:Notify({ Title = "Memuat...", Content = "50% - Fitur Main selesai dimuat.", Icon = "loader-circle", Duration = 2 })

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

WindUI:Notify({ Title = "Memuat...", Content = "75% - Fitur Player selesai dimuat.", Icon = "loader-circle", Duration = 2 })

local RankInfoParagraph = TabRankUp:Paragraph({ Title = "Informasi Rank", Desc = "Klik 'Tampilkan Info Rank' untuk memuat data terbaru." })
TabRankUp:Button({
    Title = "Tampilkan/Perbarui Info Rank", Desc = "Membaca data dari GUI asli dan menampilkannya di sini.",
    Callback = function()
        local karl = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Karl"); if not karl then return end
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("RankUpGui"):FireServer(karl, karl.HumanoidRootPart:WaitForChild("Dialogue"))
        task.wait(0.7)
        local rankMenu = Player.PlayerGui:FindFirstChild("MainGui", true) and Player.PlayerGui.MainGui:FindFirstChild("RankMenu")
        if rankMenu and rankMenu:FindFirstChild("BG") then
            local bg = rankMenu.BG
            local currentRank = bg:FindFirstChild("namerank") and bg.namerank.Text or "[Tidak Ditemukan]"
            local nextRank = bg:FindFirstChild("namenextrank") and bg.namenextrank.Text or "[Tidak Ditemukan]"
            local reqs = "Syarat Mineral: Tidak ditemukan"
            for _,v in ipairs(bg:GetDescendants()) do if v:IsA("TextLabel") and string.find(v.Text:lower(), "required:") then reqs = v.Text; break end end
            RankInfoParagraph:SetDesc(string.format("Rank Saat Ini: %s\nRank Selanjutnya: %s\n\n%s", currentRank, nextRank, reqs))
            rankMenu.Enabled = false
        else RankInfoParagraph:SetDesc("Gagal menemukan GUI Rank Up. Coba buka manual sekali.") end
    end
})
local rankUpDebounce = false
TabRankUp:Button({ Title = "Rank Up", Desc = "Mencoba untuk menaikkan rank jika item sudah cukup.", Callback = function() if rankUpDebounce then WindUI:Notify({Title="Cooldown", Content="Harap tunggu sebentar.", Icon="hourglass"}); return end; rankUpDebounce = true; pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("RankUP"):FireServer() end); WindUI:Notify({ Title = "Rank Up", Content = "Permintaan Rank Up telah dikirim!", Icon = "arrow-up-circle" }); task.wait(1); rankUpDebounce = false end})
local backpackFrame = TabStorage:Paragraph({Title = "Backpack", Desc = "Pilih item untuk dipindahkan."})
local storageFrame = TabStorage:Paragraph({Title = "Storage", Desc = "Pilih item untuk diambil."})
local function refreshStorageUI()
    for _, child in ipairs(backpackFrame.Container:GetChildren()) do if child.Name == "ItemToggle" then child:Destroy() end end
    for _, child in ipairs(storageFrame.Container:GetChildren()) do if child.Name == "ItemToggle" then child:Destroy() end end
    selectedBackpackItems, selectedStorageItems = {}, {}
    for _, item in ipairs(Player.Backpack:GetChildren()) do
        local itemToggle = TabStorage:Toggle({ Title = item.Name, Parent = backpackFrame.Container, Default = false, Callback = function(state) selectedBackpackItems[item] = state end }); itemToggle.ToggleFrame.Name = "ItemToggle"
    end
    local storageFolder = Player:FindFirstChild("HiddenStats", true) and Player.HiddenStats:FindFirstChild("Storage")
    if storageFolder then for _, item in ipairs(storageFolder:GetChildren()) do
        local itemToggle = TabStorage:Toggle({ Title = item.Name, Parent = storageFrame.Container, Default = false, Callback = function(state) selectedStorageItems[item] = state end }); itemToggle.ToggleFrame.Name = "ItemToggle"
    end end
end
TabStorage:Button({ Title = "Pindahkan SEMUA ke Storage", Desc="Memindahkan semua mineral (bukan tool utama) ke storage.", Callback = function()
    local toolBlacklist = {["Main Tool"]=true, ["Equipment"]=true, ["Collection Book"]=true, ["Whistle"]=true}
    for _, item in ipairs(Player.Backpack:GetChildren()) do
        if item:IsA("Tool") and not toolBlacklist[item.Name] then pcall(function() game:GetService("ReplicatedStorage").RemoteEvent.Storage:FireServer(false, item) end); task.wait() end
    end
    WindUI:Notify({Title="Storage", Content="Semua mineral telah dipindahkan."}); task.wait(0.5); refreshStorageUI()
end})
TabStorage:Button({ Title = "Ambil Item Terpilih", Desc="Ambil item yang dipilih dari storage ke backpack.", Callback = function()
    local storageFolder = Player:FindFirstChild("HiddenStats", true) and Player.HiddenStats:FindFirstChild("Storage")
    if not storageFolder then return end
    for item, state in pairs(selectedStorageItems) do
        if state then pcall(function() game:GetService("ReplicatedStorage").RemoteEvent.Storage:FireServer(true, item) end); task.wait() end
    end
    task.wait(0.5); refreshStorageUI()
end})
TabStorage:Button({ Title = "Refresh Daftar", Desc = "Memuat ulang daftar item.", Callback = refreshStorageUI })
local PlayerDropdown; local function refreshPlayerList() local playerNames = {}; for _, p in ipairs(game:GetService("Players"):GetPlayers()) do if p ~= Player then table.insert(playerNames, p.Name) end end; if PlayerDropdown then PlayerDropdown:Refresh(playerNames) else PlayerDropdown = TabTeleport:Dropdown({ Title = "Pilih Pemain (Username)", Values = playerNames, Value = nil }) end end
refreshPlayerList()
TabTeleport:Button({ Title = "Refresh Daftar Pemain", Callback = refreshPlayerList })
TabTeleport:Button({ Title = "Pindahkan Teman ke Saya", Callback = function()
    local myChar = Player.Character; local friendName = PlayerDropdown.Value
    if not (myChar and myChar.PrimaryPart) then WindUI:Notify({Title="Gagal", Content="Karaktermu tidak ditemukan."}); return end
    if not friendName then WindUI:Notify({Title="Gagal", Content="Pilih pemain dari daftar."}); return end
    local friendPlayer = game:GetService("Players"):FindFirstChild(friendName)
    if not (friendPlayer and friendPlayer.Character and friendPlayer.Character.PrimaryPart) then WindUI:Notify({Title="Gagal", Content="Player '" .. friendName .. "' tidak ditemukan."}); return end
    pcall(function() friendPlayer.Character:SetPrimaryPartCFrame(myChar.PrimaryPart.CFrame); WindUI:Notify({Title="Berhasil", Content=friendName .. " telah dipindahkan."}) end)
end })
TabAdvanced:Paragraph({ Title = "Bypass Anti-Cheat", Desc = "Sistem bypass ini akan memodifikasi fungsi inti game." })
TabAdvanced:Button({
    Title = "Activate Anti-Cheat Bypass", Desc = "Mengaktifkan sistem anti-kick dan spoofing yang aman.",
    Callback = function()
        local success, err = pcall(function()
            local mt = getrawmetatable(game); local oldIndex = mt.__index; setreadonly(mt, false)
            mt.__index = newcclosure(function(self, key)
                if typeof(self) == "Instance" and self.ClassName == "Humanoid" and key == "PlatformStand" then return false end
                if typeof(self) == "Instance" and self.ClassName == "HumanoidRootPart" and (key == "AssemblyLinearVelocity" or key == "Velocity") then return Vector3.new(0, -50, 0) end
                return oldIndex(self, key)
            end)
            setreadonly(mt, true)
        end)
        if success then WindUI:Notify({ Title = "Bypass Diaktifkan", Content = "Sistem bypass aman berhasil diaktifkan.", Icon = "shield-check" })
        else WindUI:Notify({ Title = "Bypass Gagal", Content = "Gagal mengaktifkan bypass.", Icon = "shield-x" }); warn("Bypass Gagal: ", err) end
    end
})

WindUI:Notify({ Title = "Memuat...", Content = "90% - Hampir selesai, finalisasi...", Icon = "loader-circle", Duration = 2 })
refreshStorageUI()

local endTime = tick()
local duration = string.format("%.3f", endTime - startTime)
WindUI:Notify({
    Title = "Selesai!",
    Content = "100% - Skrip berhasil dimuat dalam " .. duration .. " detik.",
    Icon = "check-circle",
    Duration = 7
})