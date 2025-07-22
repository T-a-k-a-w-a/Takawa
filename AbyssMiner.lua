--================================================================--
--      SKRIP VERSI FINAL (FLUENT UI + PERBAIKAN) - OLEH PARTNER CODING     --
--================================================================--

-- Muat Library Fluent beserta Add-on
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Variabel Global
local Player = game:GetService("Players").LocalPlayer
local locations = {}
local locationFileName = "Fluent_Locations.json"
local locationFolderPath = "Download/" 
local originalToolStats = {}
local lastKnownTool = nil

-- Buat Jendela Utama
local Window = Fluent:CreateWindow({
    Title = "Abyss Miner Menu v8",
    SubTitle = "oleh Partner Coding",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

-- Inisialisasi Add-on
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetFolder("AbyssMinerFluent")
InterfaceManager:SetFolder("AbyssMinerFluent")

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "pickaxe" }),
    Teleport = Window:AddTab({ Title = "Teleportasi", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--
local Options = Fluent.Options

-- Fungsi Fly
local flying = false
local bodyVelocity, bodyGyro
local function startFly()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or flying then return end
    local rootPart = char.HumanoidRootPart
    bodyGyro = Instance.new("BodyGyro", rootPart)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flying = true
end

local function stopFly()
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    flying = false
end

-- Fungsi untuk mengembalikan statistik tool
local function restoreToolStats() if lastKnownTool and originalToolStats[lastKnownTool] then local tool = lastKnownTool; local stats = originalToolStats[lastKnownTool]; pcall(function() if stats.Speed and tool:FindFirstChild("Speed") then tool.Speed.Value = stats.Speed end end); originalToolStats[lastKnownTool] = nil end end

-- Loop utama untuk fitur yang berjalan terus menerus
game:GetService("RunService").Heartbeat:Connect(function()
    if not Player.Character then return end
    
    local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Perbaikan Bug Walkspeed
    if Options.Walkspeed then
        if humanoid.WalkSpeed ~= Options.Walkspeed.Value then
            humanoid.WalkSpeed = Options.Walkspeed.Value
        end
    end

    -- Logika untuk Fly
    if flying and Player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = Player.Character.HumanoidRootPart; local camera = workspace.CurrentCamera; local velocity = Vector3.new(0, 0, 0); local keybinds = game:GetService("UserInputService"); local speed = Options.FlySpeed.Value; if keybinds:IsKeyDown(Enum.KeyCode.W) then velocity = camera.CFrame.LookVector * speed end; if keybinds:IsKeyDown(Enum.KeyCode.S) then velocity = -camera.CFrame.LookVector * speed end; if keybinds:IsKeyDown(Enum.KeyCode.A) then velocity = -camera.CFrame.RightVector * speed end; if keybinds:IsKeyDown(Enum.KeyCode.D) then velocity = camera.CFrame.RightVector * speed end; if keybinds:IsKeyDown(Enum.KeyCode.E) then velocity = Vector3.new(0, speed, 0) end; if keybinds:IsKeyDown(Enum.KeyCode.Q) then velocity = Vector3.new(0, -speed, 0) end; bodyVelocity.Velocity = velocity; bodyGyro.CFrame = camera.CFrame
    end

    -- Logika untuk Instant Mine
    if Options.InstantMine and Options.InstantMine.Value then
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool and tool ~= lastKnownTool then restoreToolStats(); lastKnownTool = tool end
        if tool then
            if not originalToolStats[tool] then originalToolStats[tool] = { Speed = tool:FindFirstChild("Speed") and tool.Speed.Value } end
            pcall(function() local speed = tool:FindFirstChild("Speed"); if speed then speed.Value = 0 end end)
        else
            restoreToolStats(); lastKnownTool = nil
        end
    end
end)

-- !-- PERBAIKAN: Menggunakan metode baru untuk Anti Fall Damage --!
local function onStateChanged(humanoid, old, new) 
    if new == Enum.HumanoidStateType.Landed and Options.AntiFall and Options.AntiFall.Value then
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        end)
    end
end
if Player.Character then
    local humanoid = Player.Character:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(function(old, new) onStateChanged(humanoid, old, new) end)
end
Player.CharacterAdded:Connect(function(char) 
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(function(old, new) onStateChanged(humanoid, old, new) end)
end)

-- Fungsi Auto Re-Apply Settings on Respawn
Player.CharacterAdded:Connect(function()
    task.wait(2)
    pcall(function()
        SaveManager:Load(SaveManager.CurrentConfig)
        Fluent:Notify({Title="Pengaturan Dimuat", Content="Pengaturanmu telah dimuat ulang setelah respawn."})
    end)
end)

-- Fungsi file system lokasi
local function saveLocationsToFile() if writefile then pcall(function() writefile(locationFolderPath .. locationFileName, game:GetService("HttpService"):JSONEncode(locations)) end) end
local function loadLocationsFromFile() if isfile and readfile and isfolder then if not isfolder(locationFolderPath) then makefolder(locationFolderPath) end; if isfile(locationFolderPath .. locationFileName) then local s, d = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName)) end); if s and type(d) == "table" then locations = d end end end

--================================================================--
--                         TAB: FITUR UTAMA                         --
--================================================================--
Tabs.Main:AddParagraph({Title = "Otomatisasi Farm", Content = ""})

Tabs.Main:AddToggle("InstantMine", {Title = "Instant Mine (Speed Only)", Default = false}):OnChanged(function(value)
    if not value then restoreToolStats() end
end)

-- !-- PERBAIKAN: Fitur Auto Sell tidak lagi melakukan teleportasi --!
Tabs.Main:AddToggle("AutoSell", {Title = "Auto Sell (15 detik)", Default = false}):OnChanged(function(value)
    if value then
        task.spawn(function()
            while Options.AutoSell.Value do
                pcall(function()
                    local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true)
                    if npc then
                        local args = { npc, npc.HumanoidRootPart:WaitForChild("Dialogue") }
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(unpack(args))
                    end
                end)
                task.wait(15)
            end
        end)
    end
end)

Tabs.Main:AddParagraph({Title = "Pengaturan Player", Content = ""})
Tabs.Main:AddSlider("Walkspeed", {Title = "Walkspeed", Min = 16, Max = 100, Default = 16, Rounding = 0, Suffix = " speed" })
Tabs.Main:AddSlider("FlySpeed", {Title = "Kecepatan Terbang", Description = "Kecepatan tinggi (>50) dapat menyebabkan kick.", Min = 10, Max = 200, Default = 50, Rounding = 0, Suffix = " speed"})
Tabs.Main:AddToggle("AntiFall", {Title = "Anti Fall Damage", Default = false})
Tabs.Main:AddToggle("FlyToggle", {Title = "Toggle Fly", Default = false}):OnChanged(function(value)
    if value then startFly() else stopFly() end
end)

--================================================================--
--                           TAB: TELEPORT                          --
--================================================================--
Tabs.Teleport:AddParagraph({Title = "Simpan & Teleportasi Lokasi", Content = "Gunakan metode 'Set Spawn & Respawn' untuk menghindari kick."})
local LocationDropdown = Tabs.Teleport:AddDropdown("LocationDropdown", { Title = "Pilih Lokasi", Values = {}, Multi = false })
local function updateLocationsDropdown()
    local options = {}
    for i, locData in ipairs(locations) do table.insert(options, locData.Name) end
    Options.LocationDropdown.Values = options
end
Tabs.Teleport:AddButton({
    Title = "Simpan Lokasi Saat Ini",
    Callback = function()
        Window:Dialog({
            Title = "Nama Lokasi", Content = "Masukkan nama untuk lokasi ini:", Buttons = {{ Title = "Batal" }},
            Input = { Placeholder = "Contoh: Base", Callback = function(text)
                if text and text ~= "" then
                    local pos = Player.Character.HumanoidRootPart.Position
                    table.insert(locations, {Name = text, Pos = {x = pos.X, y = pos.Y, z = pos.Z}})
                    saveLocationsToFile(); updateLocationsDropdown()
                    Fluent:Notify({Title="Lokasi Disimpan", Content= text .. " berhasil disimpan."})
                end
            end
            }
        })
    end
})
Tabs.Teleport:AddButton({
    Title = "Set Spawn di Lokasi Terpilih",
    Callback = function()
        local selectedName = Options.LocationDropdown.Value; local selectedLocData
        for _, locData in ipairs(locations) do if locData.Name == selectedName then selectedLocData = locData; break end end
        if selectedLocData then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SetSpawnPoint"):FireServer(Vector3.new(selectedLocData.Pos.x, selectedLocData.Pos.y, selectedLocData.Pos.z))
                Fluent:Notify({Title="Spawn Point Diatur", Content="Spawn point diatur di " .. selectedName .. ". Reset karakter untuk teleport."})
            end)
        else Fluent:Notify({Title="Gagal", Content="Pilih lokasi yang valid terlebih dahulu."}) end
    end
})
Tabs.Teleport:AddButton({
    Title = "RESET KARAKTER (TELEPORT)", Description = "Gunakan ini setelah 'Set Spawn' untuk berpindah lokasi.",
    Callback = function() if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.Health = 0 end end
})
Tabs.Teleport:AddParagraph({Title = "Teleportasi Teman", Content = ""})
local FriendInput = Tabs.Teleport:AddInput("FriendName", {Title = "Username Teman", Default = "", Placeholder = "Masukkan nama teman..."})
Tabs.Teleport:AddButton({
    Title = "Pindahkan Teman ke Saya",
    Callback = function()
        local myChar = Player.Character; local friendName = Options.FriendName.Value
        if not (myChar and myChar.PrimaryPart) then Fluent:Notify({Title="Gagal", Content="Karaktermu tidak ditemukan."}); return end
        if not (friendName and friendName ~= "") then Fluent:Notify({Title="Gagal", Content="Masukkan nama teman."}); return end
        local friendPlayer = game:GetService("Players"):FindFirstChild(friendName)
        if not (friendPlayer and friendPlayer.Character and friendPlayer.Character.PrimaryPart) then Fluent:Notify({Title="Gagal", Content="Player '" .. friendName .. "' tidak ditemukan di server."}); return end
        pcall(function() friendPlayer.Character:SetPrimaryPartCFrame(myChar.PrimaryPart.CFrame); Fluent:Notify({Title="Berhasil", Content=friendName .. " telah dipindahkan."}) end)
    end
})

--================================================================--
--                      INISIALISASI & SETTINGS                     --
--================================================================--
loadLocationsFromFile(); updateLocationsDropdown()
InterfaceManager:BuildInterfaceSection(Tabs.Settings); SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Fluent:Notify({ Title = "Fluent", Content = "Skrip berhasil dimuat.", Duration = 8 })
SaveManager:LoadAutoloadConfig()