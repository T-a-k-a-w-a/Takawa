--================================================================--
--         SKRIP DIPERBARUI OLEH PARTNER CODING (V5 - FINAL)        --
--================================================================--

-- Muat Library Arrayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Variabel Global untuk Fitur
local autoSellEnabled = false
local instantMineEnabled = false
local flyEnabled = false
local flySpeed = 50 
local locations = {}
local locationFileName = "Rayfield_Locations.json"
local locationFolderPath = "Download/"

-- Variabel untuk menyimpan statistik asli tool
local originalToolStats = {}
local lastKnownTool = nil

-- Buat Jendela Utama
local Window = Rayfield:CreateWindow({
   Name = "Abyss Miner Menu by Partner Coding",
   LoadingTitle = "Memuat Antarmuka...",
   LoadingSubtitle = "oleh Partner Coding",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "MyProjectConfig_Arrayfield"
   },
})

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--

local Player = game:GetService("Players").LocalPlayer

-- Fungsi untuk Mengembalikan Statistik Tool ke Aslinya
local function restoreToolStats()
    if lastKnownTool and originalToolStats[lastKnownTool] then
        local tool = lastKnownTool
        local stats = originalToolStats[lastKnownTool]
        
        pcall(function()
            if stats.Power and tool:FindFirstChild("Power") then tool.Power.Value = stats.Power end
            if stats.Speed and tool:FindFirstChild("Speed") then tool.Speed.Value = stats.Speed end
            if stats.Cooldown and tool:FindFirstChild("CoolDown") then tool.CoolDown.Value = stats.Cooldown end
        end)
        
        originalToolStats[lastKnownTool] = nil -- Hapus data yang sudah dikembalikan
    end
end

-- Fungsi Fly
local flying = false
local bodyVelocity, bodyGyro

local function startFly()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
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

-- Loop utama untuk fitur yang berjalan terus menerus
game:GetService("RunService").Heartbeat:Connect(function()
    -- Logika untuk Fly
    if flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = Player.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local velocity = Vector3.new(0, 0, 0)
        local keybinds = game:GetService("UserInputService")
        if keybinds:IsKeyDown(Enum.KeyCode.W) then velocity = camera.CFrame.LookVector * flySpeed end
        if keybinds:IsKeyDown(Enum.KeyCode.S) then velocity = -camera.CFrame.LookVector * flySpeed end
        if keybinds:IsKeyDown(Enum.KeyCode.A) then velocity = -camera.CFrame.RightVector * flySpeed end
        if keybinds:IsKeyDown(Enum.KeyCode.D) then velocity = camera.CFrame.RightVector * flySpeed end
        if keybinds:IsKeyDown(Enum.KeyCode.E) then velocity = Vector3.new(0, flySpeed, 0) end
        if keybinds:IsKeyDown(Enum.KeyCode.Q) then velocity = Vector3.new(0, -flySpeed, 0) end
        bodyVelocity.Velocity = velocity
        bodyGyro.CFrame = camera.CFrame
    end

    -- Logika untuk Instant Mine
    if instantMineEnabled then
        local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
        
        if tool and tool ~= lastKnownTool then
            restoreToolStats() -- Kembalikan tool lama jika ganti tool
            lastKnownTool = tool
        end

        if tool then
            -- Langkah 1: Simpan statistik asli jika belum ada
            if not originalToolStats[tool] then
                originalToolStats[tool] = {
                    Power = tool:FindFirstChild("Power") and tool.Power.Value,
                    Speed = tool:FindFirstChild("Speed") and tool.Speed.Value,
                    Cooldown = tool:FindFirstChild("CoolDown") and tool.CoolDown.Value
                }
            end
            
            -- Langkah 2: Ubah statistik
            pcall(function()
                local power = tool:FindFirstChild("Power")
                local speed = tool:FindFirstChild("Speed")
                local cooldown = tool:FindFirstChild("CoolDown")
                if power then power.Value = 10 end
                if speed then speed.Value = 0.0 end
                if cooldown then cooldown.Value = 1 end
            end)
        else
            restoreToolStats() -- Kembalikan jika tidak memegang tool
            lastKnownTool = nil
        end
    end
end)

--================================================================--
--                         TAB: FITUR UTAMA                         --
--================================================================--
local TabUtama = Window:CreateTab("Main", 4483362748)
local SectionFarm = TabUtama:CreateSection("Otomatisasi Farm", false)

TabUtama:CreateToggle({
	Name = "Instant Mine",
	CurrentValue = false,
	Flag = "InstantMineToggle",
	Info = "Saat ON, statistik kapak diubah. Saat OFF, kembali normal.",
	Callback = function(Value)
		instantMineEnabled = Value
		if not Value then
			-- Langkah 3: Kembalikan statistik saat toggle dimatikan
			restoreToolStats()
		end
	end,
})

-- Sisa skrip tetap sama
local SectionPlayer = TabUtama:CreateSection("Pengaturan Player", false)
TabUtama:CreateSlider({ Name = "Walkspeed", Range = {16, 100}, Increment = 1, Suffix = " speed", CurrentValue = 16, Flag = "WalkspeedSlider", Callback = function(Value) if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = Value end end, })
TabUtama:CreateToggle({ Name = "Auto Sell (15 detik)", CurrentValue = false, Flag = "AutoSellToggle", Callback = function(Value) autoSellEnabled = Value; if autoSellEnabled then task.spawn(function() while autoSellEnabled do pcall(function() local args = { workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"), workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"):WaitForChild("HumanoidRootPart"):WaitForChild("Dialogue") }; game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(unpack(args)) end); task.wait(15) end end) end end, })
TabUtama:CreateToggle({ Name = "Toggle Fly", CurrentValue = false, Flag = "FlyToggle", Callback = function(Value) if Value then startFly() else stopFly() end end, })
local TabTeleport = Window:CreateTab("Teleport", 4483362458)
local SectionLokasi = TabTeleport:CreateSection("Simpan & Teleportasi Lokasi", false)
local LokasiDropdown
local function updateDropdownOptions() local options = {}; for i = 1, #locations do table.insert(options, "Lokasi " .. i) end; if LokasiDropdown and LokasiDropdown.Refresh then LokasiDropdown:Refresh(options) end end
TabTeleport:CreateButton({ Name = "Simpan Lokasi Saat Ini", Callback = function() if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local pos = Player.Character.HumanoidRootPart.Position; table.insert(locations, {x = pos.X, y = pos.Y, z = pos.Z}); saveLocationsToFile(); updateDropdownOptions() end end, })
LokasiDropdown = TabTeleport:CreateDropdown({ Name = "Pilih Lokasi", Options = {}, CurrentOption = "", MultiSelection = false, Flag = "LocationDropdown", Callback = function(Option) end, })
TabTeleport:CreateButton({ Name = "Teleport ke Lokasi Terpilih", Callback = function() if LokasiDropdown.CurrentOption ~= "" and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local selectedOption = LokasiDropdown.CurrentOption; local index = tonumber(string.match(selectedOption, "%d+")); if index and locations[index] then local loc = locations[index]; Player.Character.HumanoidRootPart.CFrame = CFrame.new(loc.x, loc.y + 5, loc.z) end end end, })
local SectionTeman = TabTeleport:CreateSection("Teleportasi Teman", false)
local NamaTemanInput = TabTeleport:CreateInput({ Name = "Username Teman", PlaceholderText = "Masukkan nama teman...", RemoveTextAfterFocusLost = false, Callback = function(Text) end, })
TabTeleport:CreateButton({ Name = "Pindahkan Teman ke Saya", Callback = function() local myChar = Player.Character; local friendName = NamaTemanInput.CurrentValue; if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end; if not (friendName and friendName ~= "") then return end; local friendPlayer = game:GetService("Players"):FindFirstChild(friendName); if not friendPlayer then return end; local friendChar = friendPlayer.Character; if not (friendChar and friendChar:FindFirstChild("HumanoidRootPart")) then return end; pcall(function() friendChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame end) end, })
local function loadLocationsFromFile() if isfile and readfile and isfolder then if not isfolder(locationFolderPath) then makefolder(locationFolderPath) end; if isfile(locationFolderPath .. locationFileName) then local success, data = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName)) end); if success and type(data) == "table" then locations = data end end end end
loadLocationsFromFile()
updateDropdownOptions()