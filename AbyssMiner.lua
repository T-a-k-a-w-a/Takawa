--================================================================--
--      SKRIP VERSI FINAL (WINDUI + SEMUA FITUR) - OLEH PARTNER CODING     --
--================================================================--

-- !-- PERBAIKAN: Menggunakan Pemuatan Library yang Aman (Safe Loading) --!
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Error",
        Text = "Gagal memuat WindUI Library. Periksa koneksi atau coba jalankan ulang skrip.",
        Duration = 10
    })
    warn("WindUI Gagal Dimuat! Error: " .. tostring(WindUI))
    return -- Menghentikan sisa skrip
end

-- Variabel Global
local Player = game:GetService("Players").LocalPlayer
local locations = {}
local locationFileName = "WindUI_Locations.json"
local locationFolderPath = "/storage/emulated/0/RonixExploit/workspace/"
local originalToolStats = {}
local lastKnownTool = nil

-- Variabel Status Fitur
local instantMineEnabled, antiFallDamageEnabled, flyEnabled, autoSellEnabled = false, false, false, false
local walkspeedValue = 16
local flySpeed = 50 
local floatPlatformEnabled = false
local floatPlatform = nil
local platformConnection = nil
local platformY = 0

-- Buat Jendela Utama
local Window = WindUI:CreateWindow({
    Title = "Abyss Miner Menu",
    Author = "Partner Coding",
    Folder = "AbyssMinerWindUI",
    Size = UDim2.fromOffset(580, 480),
    Theme = "Dark",
    User = { Enabled = true },
    ToggleKey = Enum.KeyCode.RightShift
})

-- Variabel untuk menyimpan referensi ke elemen UI
local uiElements = {}

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--

-- Fungsi Fly
local flying = false; local bodyVelocity, bodyGyro
local function startFly() local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") or flying then return end; local rootPart = char.HumanoidRootPart; bodyGyro = Instance.new("BodyGyro", rootPart); bodyGyro.P = 9e4; bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro.CFrame = rootPart.CFrame; bodyVelocity = Instance.new("BodyVelocity", rootPart); bodyVelocity.Velocity = Vector3.new(0, 0, 0); bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9); flying = true end
local function stopFly() if bodyGyro then bodyGyro:Destroy() end; if bodyVelocity then bodyVelocity:Destroy() end; flying = false end

-- Fungsi untuk mengembalikan statistik tool
local function restoreToolStats() if lastKnownTool and originalToolStats[lastKnownTool] then local tool = lastKnownTool; local stats = originalToolStats[lastKnownTool]; pcall(function() if stats.Speed and tool:FindFirstChild("Speed") then tool.Speed.Value = stats.Speed end end); originalToolStats[lastKnownTool] = nil end end

-- Loop utama untuk fitur yang berjalan terus menerus
game:GetService("RunService").Heartbeat:Connect(function()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if walkspeedValue and humanoid.WalkSpeed ~= walkspeedValue then humanoid.WalkSpeed = walkspeedValue end
    if flying and char:FindFirstChild("HumanoidRootPart") then local rootPart = char.HumanoidRootPart; local camera = workspace.CurrentCamera; local velocity = Vector3.new(0, 0, 0); local keybinds = game:GetService("UserInputService"); if keybinds:IsKeyDown(Enum.KeyCode.W) then velocity = camera.CFrame.LookVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.S) then velocity = -camera.CFrame.LookVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.A) then velocity = -camera.CFrame.RightVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.D) then velocity = camera.CFrame.RightVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.E) then velocity = Vector3.new(0, flySpeed, 0) end; if keybinds:IsKeyDown(Enum.KeyCode.Q) then velocity = Vector3.new(0, -flySpeed, 0) end; bodyVelocity.Velocity = velocity; bodyGyro.CFrame = camera.CFrame end
    if instantMineEnabled then local tool = char:FindFirstChildOfClass("Tool"); if tool and tool ~= lastKnownTool then restoreToolStats(); lastKnownTool = tool end; if tool then if not originalToolStats[tool] then originalToolStats[tool] = { Speed = tool:FindFirstChild("Speed") and tool.Speed.Value } end; pcall(function() local speed = tool:FindFirstChild("Speed"); if speed then speed.Value = 0 end end) else restoreToolStats(); lastKnownTool = nil end end
end)

-- Fungsi Anti Fall Damage & Auto-Respawn
local function onStateChanged(humanoid, old, new) if new == Enum.HumanoidStateType.Landed and antiFallDamageEnabled then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Swimming) end) end end
Player.CharacterAdded:Connect(function(char) 
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(function(old, new) onStateChanged(humanoid, old, new) end)
    
    task.wait(2)
    pcall(function()
        if uiElements.InstantMine and instantMineEnabled then uiElements.InstantMine:Set(true) end
        if uiElements.AutoSell and autoSellEnabled then uiElements.AutoSell:Set(true) end
        if uiElements.AntiFall and antiFallDamageEnabled then uiElements.AntiFall:Set(true) end
        if uiElements.FloatPlatform and floatPlatformEnabled then uiElements.FloatPlatform:Set(true) end
        if uiElements.Fly and flyEnabled then uiElements.Fly:Set(true) end
        if uiElements.Walkspeed then uiElements.Walkspeed:Set(walkspeedValue) end
        WindUI:Notify({Title="Pengaturan Dimuat", Content="Pengaturanmu telah dimuat ulang setelah respawn."})
    end)
end)

-- Fungsi file system lokasi
local function saveLocationsToFile() if writefile then pcall(function() if not isfolder(locationFolderPath) then makefolder(locationFolderPath) end; writefile(locationFolderPath .. locationFileName, game:GetService("HttpService"):JSONEncode(locations)) end) end
local function loadLocationsFromFile() if isfile and readfile and isfolder(locationFolderPath) then if isfile(locationFolderPath .. locationFileName) then local s, d = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName)) end); if s and type(d) == "table" then locations = d end end end

--================================================================--
--                         UI SECTIONS & TABS                       --
--================================================================--
local SectionUtama = Window:Section({ Title = "Fitur Utama" })
local TabMain = SectionUtama:Tab({ Title = "Main", Icon = "pickaxe" })
local TabPlayer = SectionUtama:Tab({ Title = "Player", Icon = "user" })
local SectionNavigasi = Window:Section({ Title = "Navigasi" })
local TabTeleport = SectionNavigasi:Tab({ Title = "Teleportasi", Icon = "map-pin" })
Window:SelectTab(1)

--================================================================--
--                         ELEMENTS                               --
--================================================================--
uiElements.InstantMine = TabMain:Toggle({ Name = "Instant Mine (Speed Only)", Desc = "Aktifkan, lalu tahan klik untuk mining super cepat.", Default = false, Callback = function(state) instantMineEnabled = state; if not state then restoreToolStats() end end })
uiElements.AutoSell = TabMain:Toggle({ Name = "Auto Sell (15 detik)", Desc = "Menjual semua item di inventory setiap 15 detik.", Default = false, Callback = function(state) autoSellEnabled = state; if autoSellEnabled then task.spawn(function() while autoSellEnabled do pcall(function() local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true); local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool"); if npc and tool then game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool) end end); task.wait(15) end end) end end })
uiElements.Walkspeed = TabPlayer:Slider({ Name = "Walkspeed", Value = { Min = 16, Max = 100, Default = 16 }, Step = 1, Suffix = " speed", Callback = function(value) walkspeedValue = value end })
uiElements.FlySpeed = TabPlayer:Slider({ Name = "Kecepatan Terbang", Desc = "Kecepatan tinggi (>50) dapat menyebabkan kick.", Value = { Min = 10, Max = 200, Default = 50 }, Step = 5, Suffix = " speed", Callback = function(value) flySpeed = value end })
uiElements.AntiFall = TabPlayer:Toggle({ Name = "Anti Fall Damage", Desc = "Mencegah damage saat jatuh dari ketinggian.", Default = false, Callback = function(state) antiFallDamageEnabled = state end })
uiElements.FloatPlatform = TabPlayer:Toggle({ Name = "Float Platform", Desc = "Berjalan di udara pada ketinggian yang sama.", Default = false, Callback = function(state)
    floatPlatformEnabled = state; local char = Player.Character
    if state and char and char:FindFirstChild("HumanoidRootPart") then
        if floatPlatform then floatPlatform:Destroy() end; local rootPart = char.HumanoidRootPart; platformY = rootPart.Position.Y - 4
        floatPlatform = Instance.new("Part", workspace); floatPlatform.Anchored = true; floatPlatform.CanCollide = true; floatPlatform.Size = Vector3.new(15, 1, 15); floatPlatform.Transparency = 1; floatPlatform.Name = "MyFloatPlatform"
        platformConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if floatPlatform and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local currentRoot = Player.Character.HumanoidRootPart; floatPlatform.Position = Vector3.new(currentRoot.Position.X, platformY, currentRoot.Position.Z)
            else if platformConnection then platformConnection:Disconnect() end; if floatPlatform then floatPlatform:Destroy() end end
        end)
    else
        if platformConnection then platformConnection:Disconnect(); platformConnection = nil end
        if floatPlatform then floatPlatform:Destroy(); floatPlatform = nil end
    end
end })
uiElements.Fly = TabPlayer:Toggle({ Name = "Toggle Fly", Desc = "Gunakan W/A/S/D/E/Q untuk terbang.", Default = false, Callback = function(state) flyEnabled = state; if state then startFly() else stopFly() end end })
local LocationDropdown; local function updateLocationsDropdown() local options = {}; for i, locData in ipairs(locations) do table.insert(options, locData.Name) end; if LocationDropdown then LocationDropdown:Refresh(options) end end
TabTeleport:Button({ Name = "Simpan Lokasi Saat Ini", Callback = function()
    Window:Dialog({
        Title = "Nama Lokasi", Content = "Masukkan nama untuk lokasi ini:", Buttons = {{ Title = "Batal" }},
        Input = { Placeholder = "Contoh: Base", Callback = function(text)
            if text and text ~= "" and Player.Character and Player.Character.PrimaryPart then
                local pos = Player.Character.PrimaryPart.Position
                table.insert(locations, {Name = text, Pos = {x = pos.X, y = pos.Y, z = pos.Z}})
                saveLocationsToFile(); updateLocationsDropdown()
                WindUI:Notify({Title="Lokasi Disimpan", Content= text .. " berhasil disimpan."})
            end
        end }
    })
end })
loadLocationsFromFile(); local dropdownOptions = {}; for i, locData in ipairs(locations) do table.insert(dropdownOptions, locData.Name) end
LocationDropdown = TabTeleport:Dropdown({ Name = "Pilih Lokasi", Values = dropdownOptions, Value = dropdownOptions[1] or nil, Callback = function(value) end })
TabTeleport:Button({ Name = "Set Spawn di Lokasi Terpilih", Callback = function()
    local selectedName = LocationDropdown.Value; local selectedLocData
    for _, locData in ipairs(locations) do if locData.Name == selectedName then selectedLocData = locData; break end end
    if selectedLocData then
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SetSpawnPoint"):FireServer(Vector3.new(selectedLocData.Pos.x, selectedLocData.Pos.y, selectedLocData.Pos.z))
            WindUI:Notify({Title="Spawn Point Diatur", Content="Spawn diatur di " .. selectedName .. "."})
        end)
    else WindUI:Notify({Title="Gagal", Content="Pilih lokasi yang valid terlebih dahulu."}) end
end })
TabTeleport:Button({ Name = "RESET KARAKTER (TELEPORT)", Desc = "Gunakan ini setelah 'Set Spawn'.", Callback = function() if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.Health = 0 end end })
TabTeleport:Divider()
local FriendNameInput = TabTeleport:Input({ Name = "Username Teman", Placeholder = "Masukkan nama...", Value = "" })
TabTeleport:Button({ Name = "Pindahkan Teman ke Saya", Callback = function()
    local myChar = Player.Character; local friendName = FriendNameInput.Value
    if not (myChar and myChar.PrimaryPart) then WindUI:Notify({Title="Gagal", Content="Karaktermu tidak ditemukan."}); return end
    if not (friendName and friendName ~= "") then WindUI:Notify({Title="Gagal", Content="Masukkan nama teman."}); return end
    local friendPlayer = game:GetService("Players"):FindFirstChild(friendName)
    if not (friendPlayer and friendPlayer.Character and friendPlayer.Character.PrimaryPart) then WindUI:Notify({Title="Gagal", Content="Player '" .. friendName .. "' tidak ditemukan."}); return end
    pcall(function() friendPlayer.Character:SetPrimaryPartCFrame(myChar.PrimaryPart.CFrame); WindUI:Notify({Title="Berhasil", Content=friendName .. " telah dipindahkan."}) end)
end })