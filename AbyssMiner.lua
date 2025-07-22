--================================================================--
--      SKRIP VERSI DEFINITIF (SHAMAN UI + FLOAT) - OLEH PARTNER CODING     --
--================================================================--

-- Muat Library Shaman UI
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/Libraries/main/Shaman/Library.lua'))()

-- Variabel Global
local Player = game:GetService("Players").LocalPlayer
local locations = {}
local locationFileName = "Shaman_Locations.json"
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
local Window = Library:Window({
    Text = "Abyss Miner Menu (Stabil)"
})

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

    -- Perbaikan Bug Walkspeed
    if walkspeedValue and humanoid.WalkSpeed ~= walkspeedValue then
        humanoid.WalkSpeed = walkspeedValue
    end

    -- Logika untuk Fly
    if flying and char:FindFirstChild("HumanoidRootPart") then
        local rootPart = char.HumanoidRootPart; local camera = workspace.CurrentCamera; local velocity = Vector3.new(0, 0, 0); local keybinds = game:GetService("UserInputService"); if keybinds:IsKeyDown(Enum.KeyCode.W) then velocity = camera.CFrame.LookVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.S) then velocity = -camera.CFrame.LookVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.A) then velocity = -camera.CFrame.RightVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.D) then velocity = camera.CFrame.RightVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.E) then velocity = Vector3.new(0, flySpeed, 0) end; if keybinds:IsKeyDown(Enum.KeyCode.Q) then velocity = Vector3.new(0, -flySpeed, 0) end; bodyVelocity.Velocity = velocity; bodyGyro.CFrame = camera.CFrame
    end

    -- Logika untuk Instant Mine
    if instantMineEnabled then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool ~= lastKnownTool then restoreToolStats(); lastKnownTool = tool end
        if tool then
            if not originalToolStats[tool] then originalToolStats[tool] = { Speed = tool:FindFirstChild("Speed") and tool.Speed.Value } end
            pcall(function() local speed = tool:FindFirstChild("Speed"); if speed then speed.Value = 0 end end)
        else
            restoreToolStats(); lastKnownTool = nil
        end
    end
end)

-- Fungsi Anti Fall Damage
local function onStateChanged(humanoid, old, new) if new == Enum.HumanoidStateType.Landed and antiFallDamageEnabled then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Swimming) end) end end
Player.CharacterAdded:Connect(function(char) 
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(function(old, new) onStateChanged(humanoid, old, new) end)
    
    -- Auto Re-Apply Settings on Respawn
    task.wait(2)
    pcall(function()
        local uiElements = Window.UIElements or {} -- Asumsi elemen disimpan di sini oleh library
        if instantMineEnabled and uiElements.InstantMine then uiElements.InstantMine:Set(true) end
        if autoSellEnabled and uiElements.AutoSell then uiElements.AutoSell:Set(true) end
        if antiFallDamageEnabled and uiElements.AntiFall then uiElements.AntiFall:Set(true) end
        if floatPlatformEnabled and uiElements.FloatPlatform then uiElements.FloatPlatform:Set(true) end
        if flyEnabled and uiElements.Fly then uiElements.Fly:Set(true) end
        if uiElements.Walkspeed then uiElements.Walkspeed:Set(walkspeedValue) end
    end)
end)

-- Fungsi file system lokasi
local function saveLocationsToFile() if writefile then pcall(function() if not isfolder(locationFolderPath) then makefolder(locationFolderPath) end; writefile(locationFolderPath .. locationFileName, game:GetService("HttpService"):JSONEncode(locations)) end) end
local function loadLocationsFromFile() if isfile and readfile and isfolder(locationFolderPath) then if isfile(locationFolderPath .. locationFileName) then local s, d = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName)) end); if s and type(d) == "table" then locations = d end end end

--================================================================--
--                         UI TABS & SECTIONS                       --
--================================================================--
local TabUtama = Window:Tab({ Text = "Main" })
local SectionFarm = TabUtama:Section({ Text = "Otomatisasi Farm" })
local SectionPlayer = TabUtama:Section({ Text = "Pengaturan Player", Side = "Right" })

local TabTeleport = Window:Tab({ Text = "Teleportasi" })
local SectionLokasi = TabTeleport:Section({ Text = "Simpan & Teleportasi Lokasi" })
local SectionTeman = TabTeleport:Section({ Text = "Teleportasi Teman", Side = "Right" })

--================================================================--
--                         ELEMENTS                               --
--================================================================--
local uiElements = {}
uiElements.InstantMine = SectionFarm:Toggle({ Text = "Instant Mine (Speed Only)", Default = false, Tooltip = "Aktifkan, lalu tahan klik untuk mining super cepat.", Callback = function(Value) instantMineEnabled = Value; if not Value then restoreToolStats() end end, })
uiElements.AutoSell = SectionFarm:Toggle({ Text = "Auto Sell (15 detik)", Default = false, Callback = function(Value) autoSellEnabled = Value; if autoSellEnabled then task.spawn(function() while autoSellEnabled do pcall(function() local args = { workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"), workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"):WaitForChild("HumanoidRootPart"):WaitForChild("Dialogue") }; game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(unpack(args)) end); task.wait(15) end end) end end, })
uiElements.Walkspeed = SectionPlayer:Slider({ Text = "Walkspeed", Default = 16, Minimum = 16, Maximum = 100, Callback = function(Value) walkspeedValue = Value end })
uiElements.AntiFall = SectionPlayer:Toggle({ Text = "Anti Fall Damage", Default = false, Tooltip = "Mencegah damage saat jatuh.", Callback = function(Value) antiFallDamageEnabled = Value end, })

-- !-- FITUR BARU: FLOAT PLATFORM --!
uiElements.FloatPlatform = SectionPlayer:Toggle({
    Text = "Float Platform",
    Default = false,
    Tooltip = "Berjalan di udara pada ketinggian yang sama.",
    Callback = function(state)
        floatPlatformEnabled = state
        local char = Player.Character
        
        if state and char and char:FindFirstChild("HumanoidRootPart") then
            if floatPlatform then floatPlatform:Destroy() end -- Hapus jika sudah ada
            
            local rootPart = char.HumanoidRootPart
            platformY = rootPart.Position.Y - 4 -- Kunci ketinggian platform
            
            floatPlatform = Instance.new("Part", workspace)
            floatPlatform.Anchored = true
            floatPlatform.CanCollide = true
            floatPlatform.Size = Vector3.new(15, 1, 15)
            floatPlatform.Transparency = 1
            floatPlatform.Name = "MyFloatPlatform"
            
            platformConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if floatPlatform and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local currentRoot = Player.Character.HumanoidRootPart
                    floatPlatform.Position = Vector3.new(currentRoot.Position.X, platformY, currentRoot.Position.Z)
                else
                    if platformConnection then platformConnection:Disconnect() end
                    if floatPlatform then floatPlatform:Destroy() end
                end
            end)
        else
            if platformConnection then
                platformConnection:Disconnect()
                platformConnection = nil
            end
            if floatPlatform then
                floatPlatform:Destroy()
                floatPlatform = nil
            end
        end
    end,
})

uiElements.Fly = SectionPlayer:Toggle({ Text = "Toggle Fly", Default = false, Tooltip = "Gunakan W/A/S/D/E/Q untuk terbang.", Callback = function(Value) flyEnabled = Value; if Value then startFly() else stopFly() end end, })
uiElements.FlySpeed = SectionPlayer:Slider({ Text = "Kecepatan Terbang", Default = 50, Minimum = 10, Maximum = 200, Callback = function(Value) flySpeed = Value end })

local LocationDropdown
local function updateLocationsDropdown() local options = {}; for i = 1, #locations do table.insert(options, "Lokasi " .. i) end; if LocationDropdown then LocationDropdown:Refresh({ List = options }) end end
SectionLokasi:Button({ Text = "Simpan Lokasi Saat Ini", Callback = function() if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local pos = Player.Character.HumanoidRootPart.Position; table.insert(locations, {Name = "Lokasi " .. #locations + 1, Pos = {x = pos.X, y = pos.Y, z = pos.Z}}); saveLocationsToFile(); updateLocationsDropdown() end end, })
loadLocationsFromFile(); local dropdownOptions = {}; for i = 1, #locations do table.insert(dropdownOptions, locations[i].Name) end
LocationDropdown = SectionLokasi:Dropdown({ Text = "Pilih Lokasi", List = dropdownOptions, Callback = function(Option) end, })
SectionLokasi:Button({ Text = "Teleport ke Lokasi Terpilih", Callback = function() if LocationDropdown.Value and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local selectedName = LocationDropdown.Value; local selectedLocData; for _, locData in ipairs(locations) do if locData.Name == selectedName then selectedLocData = locData; break end end; if selectedLocData then Player.Character.HumanoidRootPart.CFrame = CFrame.new(selectedLocData.Pos.x, selectedLocData.Pos.y + 5, selectedLocData.Pos.z) end end end, })
local NamaTemanInput = SectionTeman:Input({ Placeholder = "Masukkan nama teman...", Flag = "FriendNameInput" })
SectionTeman:Button({ Text = "Pindahkan Teman ke Saya", Callback = function() local myChar = Player.Character; local friendName = Library.Flags.FriendNameInput; if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end; if not (friendName and friendName ~= "") then return end; local friendPlayer = game:GetService("Players"):FindFirstChild(friendName); if not friendPlayer then return end; local friendChar = friendPlayer.Character; if not (friendChar and friendChar:FindFirstChild("HumanoidRootPart")) then return end; pcall(function() friendChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame end) end, })

-- INISIALISASI
TabUtama:Select()