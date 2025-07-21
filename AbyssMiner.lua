--================================================================--
--         SKRIP DIPERBARUI OLEH PARTNER CODING (V4)                --
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

-- Fungsi untuk menyimpan lokasi
local function saveLocationsToFile()
    if writefile then
        pcall(function()
            local json = game:GetService("HttpService"):JSONEncode(locations)
            writefile(locationFolderPath .. locationFileName, json)
        end)
    end
end

-- Fungsi untuk memuat lokasi
local function loadLocationsFromFile()
    if isfile and readfile and isfolder then
        if not isfolder(locationFolderPath) then makefolder(locationFolderPath) end
        if isfile(locationFolderPath .. locationFileName) then
            local success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName))
            end)
            if success and type(data) == "table" then
                locations = data
            end
        end
    end
end

-- Fungsi Fly
local Player = game:GetService("Players").LocalPlayer
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

-- Loop utama untuk fitur yang berjalan terus menerus (Fly dan Instant Mine)
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
        local char = Player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                -- Cari properti dan paksa nilainya dengan nilai yang sudah disesuaikan
                local power = tool:FindFirstChild("Power")
                local speed = tool:FindFirstChild("Speed")
                local cooldown = tool:FindFirstChild("CoolDown")

                if power then power.Value = 1000 end   -- Diubah ke 1000
                if speed then speed.Value = 0.3 end   -- Diubah ke 0.3
                if cooldown then cooldown.Value = 1 end -- Diubah ke 1
            end
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
	Info = "Aktifkan, lalu tahan klik untuk mining lebih cepat dan kuat.",
	Callback = function(Value)
		instantMineEnabled = Value
	end,
})

local SectionPlayer = TabUtama:CreateSection("Pengaturan Player", false)

TabUtama:CreateSlider({
	Name = "Walkspeed",
	Range = {16, 100},
	Increment = 1,
	Suffix = " speed",
	CurrentValue = 16,
	Flag = "WalkspeedSlider",
	Callback = function(Value)
		if Player.Character and Player.Character:FindFirstChild("Humanoid") then
			Player.Character.Humanoid.WalkSpeed = Value
		end
	end,
})

TabUtama:CreateToggle({
	Name = "Auto Sell (15 detik)",
	CurrentValue = false,
	Flag = "AutoSellToggle",
	Callback = function(Value)
		autoSellEnabled = Value
		if autoSellEnabled then
			task.spawn(function()
				while autoSellEnabled do
					pcall(function()
						local args = {
							workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"),
							workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"):WaitForChild("HumanoidRootPart"):WaitForChild("Dialogue")
						}
						game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(unpack(args))
					end)
					task.wait(15)
				end
			end)
		end
	end,
})

TabUtama:CreateToggle({
	Name = "Toggle Fly",
	CurrentValue = false,
	Flag = "FlyToggle",
	Callback = function(Value)
		if Value then startFly() else stopFly() end
	end,
})


--================================================================--
--                           TAB: TELEPORT                          --
--================================================================--
local TabTeleport = Window:CreateTab("Teleport", 4483362458)
local SectionLokasi = TabTeleport:CreateSection("Simpan & Teleportasi Lokasi", false)

local LokasiDropdown

local function updateDropdownOptions()
    local options = {}
    for i = 1, #locations do
        table.insert(options, "Lokasi " .. i)
    end
    if LokasiDropdown and LokasiDropdown.Refresh then
        LokasiDropdown:Refresh(options)
    end
end

TabTeleport:CreateButton({
   Name = "Simpan Lokasi Saat Ini",
   Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = Player.Character.HumanoidRootPart.Position
            table.insert(locations, {x = pos.X, y = pos.Y, z = pos.Z})
            saveLocationsToFile()
            updateDropdownOptions()
        end
   end,
})

LokasiDropdown = TabTeleport:CreateDropdown({
	Name = "Pilih Lokasi",
	Options = {},
	CurrentOption = "",
	MultiSelection = false,
	Flag = "LocationDropdown",
	Callback = function(Option)
	end,
})

TabTeleport:CreateButton({
   Name = "Teleport ke Lokasi Terpilih",
   Callback = function()
        if LokasiDropdown.CurrentOption ~= "" and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local selectedOption = LokasiDropdown.CurrentOption
            local index = tonumber(string.match(selectedOption, "%d+"))
            if index and locations[index] then
                local loc = locations[index]
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(loc.x, loc.y + 5, loc.z)
            end
        end
   end,
})


local SectionTeman = TabTeleport:CreateSection("Teleportasi Teman", false)

local NamaTemanInput = TabTeleport:CreateInput({
	Name = "Username Teman",
	PlaceholderText = "Masukkan nama teman...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
	end,
})

TabTeleport:CreateButton({
   Name = "Pindahkan Teman ke Saya",
   Callback = function()
        local myChar = Player.Character
        local friendName = NamaTemanInput.CurrentValue
        if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end
        if not (friendName and friendName ~= "") then return end
        local friendPlayer = game:GetService("Players"):FindFirstChild(friendName)
        if not friendPlayer then return end
        local friendChar = friendPlayer.Character
        if not (friendChar and friendChar:FindFirstChild("HumanoidRootPart")) then return end
        pcall(function()
            friendChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame
        end)
   end,
})

--================================================================--
--                   INISIALISASI SAAT SKRIP MULAI                  --
--================================================================--
loadLocationsFromFile()
updateDropdownOptions()