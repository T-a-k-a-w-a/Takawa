--================================================================--
--        SKRIP DIKONVERSI KE SHAMAN UI OLEH PARTNER CODING         --
--================================================================--

-- Muat Library Shaman UI
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/Libraries/main/Shaman/Library.lua'))()

-- Variabel Global untuk Fitur
local uiElements = {}
local instantMineEnabled = false
local antiFallDamageEnabled = false
local flyEnabled = false
local autoSellEnabled = false
local flySpeed = 50 
local locations = {}
local locationFileName = "Rayfield_Locations.json"
local locationFolderPath = "Download/"
local originalToolStats = {}
local lastKnownTool = nil

-- Buat Jendela Utama (Sintaks Shaman)
local Window = Library:Window({
    Text = "Abyss Miner Menu"
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
            if stats.Speed and tool:FindFirstChild("Speed") then tool.Speed.Value = stats.Speed end
        end)
        originalToolStats[lastKnownTool] = nil
    end
end

-- Fungsi Fly
local flying = false
local bodyVelocity, bodyGyro
local function startFly() local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end; local rootPart = char.HumanoidRootPart; bodyGyro = Instance.new("BodyGyro", rootPart); bodyGyro.P = 9e4; bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro.CFrame = rootPart.CFrame; bodyVelocity = Instance.new("BodyVelocity", rootPart); bodyVelocity.Velocity = Vector3.new(0, 0, 0); bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9); flying = true end
local function stopFly() if bodyGyro then bodyGyro:Destroy() end; if bodyVelocity then bodyVelocity:Destroy() end; flying = false end

-- Loop utama untuk fitur yang berjalan terus menerus
game:GetService("RunService").Heartbeat:Connect(function()
    -- Logika untuk Fly
    if flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = Player.Character.HumanoidRootPart; local camera = workspace.CurrentCamera; local velocity = Vector3.new(0, 0, 0); local keybinds = game:GetService("UserInputService"); if keybinds:IsKeyDown(Enum.KeyCode.W) then velocity = camera.CFrame.LookVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.S) then velocity = -camera.CFrame.LookVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.A) then velocity = -camera.CFrame.RightVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.D) then velocity = camera.CFrame.RightVector * flySpeed end; if keybinds:IsKeyDown(Enum.KeyCode.E) then velocity = Vector3.new(0, flySpeed, 0) end; if keybinds:IsKeyDown(Enum.KeyCode.Q) then velocity = Vector3.new(0, -flySpeed, 0) end; bodyVelocity.Velocity = velocity; bodyGyro.CFrame = camera.CFrame
    end

    -- Logika untuk Instant Mine
    if instantMineEnabled then
        local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
        if tool and tool ~= lastKnownTool then restoreToolStats(); lastKnownTool = tool end
        if tool then
            if not originalToolStats[tool] then
                originalToolStats[tool] = { Speed = tool:FindFirstChild("Speed") and tool.Speed.Value }
            end
            pcall(function()
                local speed = tool:FindFirstChild("Speed")
                if speed then speed.Value = 0 end
            end)
        else
            restoreToolStats(); lastKnownTool = nil
        end
    end
end)

-- Fungsi Anti Fall Damage
local function onStateChanged(old, new) if new == Enum.HumanoidStateType.Landed and antiFallDamageEnabled then pcall(function() Player.Character.Humanoid.Sit = true; task.wait(); Player.Character.Humanoid.Sit = false end) end end
if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.StateChanged:Connect(onStateChanged) end
Player.CharacterAdded:Connect(function(char) local humanoid = char:WaitForChild("Humanoid"); humanoid.StateChanged:Connect(onStateChanged) end)

-- Fungsi Auto Re-Apply Settings on Respawn
local function reapplySettings()
    task.wait(1)
    for _, element in pairs(uiElements) do
        if element.Type == "Toggle" and element.Value then
            element:Set(true)
        elseif element.Type == "Slider" then
            element:Set(element.Value)
        end
    end
end
Player.CharacterAdded:Connect(reapplySettings)

--================================================================--
--                         TAB: FITUR UTAMA                         --
--================================================================--
local TabUtama = Window:Tab({ Text = "Main" })

local SectionFarm = TabUtama:Section({ Text = "Otomatisasi Farm" })
uiElements.InstantMine = SectionFarm:Toggle({
	Text = "Instant Mine (Speed Only)",
	Default = false,
	Tooltip = "Aktifkan, lalu tahan klik untuk mining super cepat.",
	Callback = function(Value)
		instantMineEnabled = Value
		if not Value then restoreToolStats() end
	end,
})
uiElements.AutoSell = SectionFarm:Toggle({ Text = "Auto Sell (15 detik)", Default = false, Callback = function(Value) autoSellEnabled = Value; if autoSellEnabled then task.spawn(function() while autoSellEnabled do pcall(function() local args = { workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"), workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"):WaitForChild("HumanoidRootPart"):WaitForChild("Dialogue") }; game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(unpack(args)) end); task.wait(15) end end) end end, })

local SectionPlayer = TabUtama:Section({ Text = "Pengaturan Player", Side = "Right" }) -- Menggunakan layout kanan
uiElements.Walkspeed = SectionPlayer:Slider({
    Text = "Walkspeed",
    Default = 16,
    Minimum = 16,
    Maximum = 100,
    Callback = function(Value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = Value
        end
    end
})
uiElements.AntiFall = SectionPlayer:Toggle({ Text = "Anti Fall Damage", Default = false, Tooltip = "Mencegah damage saat jatuh.", Callback = function(Value) antiFallDamageEnabled = Value end, })
uiElements.Fly = SectionPlayer:Toggle({ Text = "Toggle Fly", Default = false, Tooltip = "Gunakan W/A/S/D/E/Q untuk terbang.", Callback = function(Value) if Value then startFly() else stopFly() end end, })


--================================================================--
--                           TAB: TELEPORT                          --
--================================================================--
local TabTeleport = Window:Tab({ Text = "Teleport" })
local SectionLokasi = TabTeleport:Section({ Text = "Simpan & Teleportasi Lokasi" })
local LokasiDropdown
local function updateDropdownOptions()
    local options = {}
    for i = 1, #locations do table.insert(options, "Lokasi " .. i) end
    if LokasiDropdown then
        -- !-- FITUR REFRESH DROPDOWN BERFUNGSI DI SHAMAN --!
        LokasiDropdown:Refresh({ List = options })
    end
end
local function saveLocationsToFile() if writefile then pcall(function() local json = game:GetService("HttpService"):JSONEncode(locations); writefile(locationFolderPath .. locationFileName, json) end) end end
local function loadLocationsFromFile() if isfile and readfile and isfolder then if not isfolder(locationFolderPath) then makefolder(locationFolderPath) end; if isfile(locationFolderPath .. locationFileName) then local success, data = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName)) end); if success and type(data) == "table" then locations = data end end end end

SectionLokasi:Button({ Text = "Simpan Lokasi Saat Ini", Callback = function() if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local pos = Player.Character.HumanoidRootPart.Position; table.insert(locations, {x = pos.X, y = pos.Y, z = pos.Z}); saveLocationsToFile(); updateDropdownOptions() end end, })
LokasiDropdown = SectionLokasi:Dropdown({ Text = "Pilih Lokasi", List = {}, Callback = function(Option) end, })
SectionLokasi:Button({ Text = "Teleport ke Lokasi Terpilih", Callback = function() if LokasiDropdown.Value and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local selectedOption = LokasiDropdown.Value; local index = tonumber(string.match(selectedOption, "%d+")); if index and locations[index] then local loc = locations[index]; Player.Character.HumanoidRootPart.CFrame = CFrame.new(loc.x, loc.y + 5, loc.z) end end end, })

local SectionTeman = TabTeleport:Section({ Text = "Teleportasi Teman", Side = "Right" }) -- Menggunakan layout kanan
local NamaTemanInput = SectionTeman:Input({ Placeholder = "Masukkan nama teman...", Flag = "FriendNameInput" })
SectionTeman:Button({ Text = "Pindahkan Teman ke Saya", Callback = function() local myChar = Player.Character; local friendName = Library.Flags.FriendNameInput; if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end; if not (friendName and friendName ~= "") then return end; local friendPlayer = game:GetService("Players"):FindFirstChild(friendName); if not friendPlayer then return end; local friendChar = friendPlayer.Character; if not (friendChar and friendChar:FindFirstChild("HumanoidRootPart")) then return end; pcall(function() friendChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame end) end, })

-- INISIALISASI
loadLocationsFromFile()
updateDropdownOptions()
TabUtama:Select() -- Memilih tab utama sebagai default saat UI terbuka