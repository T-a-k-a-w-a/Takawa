--================================================================--
--                 SKRIP DIBUAT OLEH PARTNER CODING                 --
--================================================================--

-- Muat Library Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variabel Global untuk Fitur
local autoSellEnabled = false
local flyEnabled = false
local flySpeed = 50 
local locations = {}
local locationFileName = "Rayfield_Locations.json"
local locationFolderPath = "Download/" -- Menggunakan folder Download

-- Buat Jendela Utama
local Window = Rayfield:CreateWindow({
   Name = "Project Script Menu",
   LoadingTitle = "Memuat Antarmuka...",
   LoadingSubtitle = "oleh Partner Coding",
   Theme = "Default",
   Icon = "rbxassetid://4483362458",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "MyProjectConfig"
   },
})

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--

-- Fungsi untuk menyimpan lokasi
local function saveLocationsToFile()
    if writefile then
        local success, err = pcall(function()
            local json = game:GetService("HttpService"):JSONEncode(locations)
            writefile(locationFolderPath .. locationFileName, json)
        end)
        if not success then
            Rayfield:Notify({Title = "Gagal Menyimpan", Content = "Tidak dapat menulis ke folder Download."})
        end
    else
        Rayfield:Notify({Title = "Peringatan", Content = "Fungsi 'writefile' tidak tersedia."})
    end
end

-- Fungsi untuk memuat lokasi
local function loadLocationsFromFile()
    if isfile and readfile and isfolder then
        if not isfolder(locationFolderPath) then
            makefolder(locationFolderPath) -- Buat folder jika belum ada
        end

        if isfile(locationFolderPath .. locationFileName) then
            local success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName))
            end)
            if success and type(data) == "table" then
                locations = data
            end
        end
    else
        Rayfield:Notify({Title = "Peringatan", Content = "Fungsi file system tidak tersedia."})
    end
end

-- Fungsi Fly
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
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

game:GetService("RunService").RenderStepped:Connect(function()
    if flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = Player.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        
        local velocity = Vector3.new(0, 0, 0)
        
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            velocity = camera.CFrame.LookVector * flySpeed
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            velocity = -camera.CFrame.LookVector * flySpeed
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            velocity = -camera.CFrame.RightVector * flySpeed
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            velocity = camera.CFrame.RightVector * flySpeed
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.E) then
            velocity = Vector3.new(0, flySpeed, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Q) then
            velocity = Vector3.new(0, -flySpeed, 0)
        end
        
        bodyVelocity.Velocity = velocity
        bodyGyro.CFrame = camera.CFrame
    end
end)


--================================================================--
--                         TAB: FITUR UTAMA                         --
--================================================================--
local TabUtama = Window:CreateTab("Main", "rbxassetid://4483362748")

local SectionPlayer = TabUtama:CreateSection("Pengaturan Player")

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

TabUtama:CreateSlider({
	Name = "Pickaxe Damage",
	Range = {1, 5000}, -- Angka 1 adalah placeholder, akan diupdate
	Increment = 10,
	Suffix = " dmg",
	CurrentValue = 10,
	Flag = "PickaxeDamageSlider",
	Callback = function(Value)
        local function updatePickaxe(tool)
            if tool and tool:IsA("Tool") and tool:FindFirstChild("Power") then
                tool.Power.Value = Value
            end
        end

        -- Cek di karakter (yang sedang dipakai)
        if Player.Character then
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            updatePickaxe(tool)
        end
        -- Cek di backpack
        if Player.Backpack then
            for _, tool in ipairs(Player.Backpack:GetChildren()) do
                updatePickaxe(tool)
            end
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
						Rayfield:Notify({Title = "Auto Sell", Content = "Semua item berhasil dijual!"})
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
		if Value then
			startFly()
			Rayfield:Notify({Title = "Fly", Content = "Terbang diaktifkan. Gunakan W/A/S/D/E/Q."})
		else
			stopFly()
			Rayfield:Notify({Title = "Fly", Content = "Terbang dinonaktifkan."})
		end
	end,
})


--================================================================--
--                           TAB: TELEPORT                          --
--================================================================--
local TabTeleport = Window:CreateTab("Teleport", "rbxassetid://4483362458")
local SectionLokasi = TabTeleport:CreateSection("Simpan & Teleportasi Lokasi")

local LokasiDropdown

local function updateDropdownOptions()
    local options = {}
    for i = 1, #locations do
        table.insert(options, "Lokasi " .. i)
    end
    if LokasiDropdown then
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
            Rayfield:Notify({Title = "Lokasi Disimpan", Content = "Lokasi #" .. #locations .. " berhasil disimpan."})
        else
            Rayfield:Notify({Title = "Gagal", Content = "Karakter tidak ditemukan."})
        end
   end,
})

LokasiDropdown = TabTeleport:CreateDropdown({
	Name = "Pilih Lokasi",
	Options = {},
	CurrentOption = {},
	MultipleOptions = false,
	Flag = "LocationDropdown",
	Callback = function(Options)
		-- Callback tidak perlu melakukan apa-apa saat dipilih
	end,
})

TabTeleport:CreateButton({
   Name = "Teleport ke Lokasi Terpilih",
   Callback = function()
        if #LokasiDropdown.CurrentOption > 0 and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local selectedOption = LokasiDropdown.CurrentOption[1]
            local index = tonumber(string.match(selectedOption, "%d+"))
            
            if index and locations[index] then
                local loc = locations[index]
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(loc.x, loc.y + 5, loc.z) -- Tambah 5 di Y agar tidak stuck
                Rayfield:Notify({Title = "Teleport", Content = "Berhasil teleport ke " .. selectedOption})
            else
                Rayfield:Notify({Title = "Gagal", Content = "Lokasi tidak valid."})
            end
        else
            Rayfield:Notify({Title = "Gagal", Content = "Pilih lokasi atau karakter tidak ditemukan."})
        end
   end,
})


local SectionTeman = TabTeleport:CreateSection("Teleportasi Teman")

local NamaTemanInput = TabTeleport:CreateInput({
	Name = "Username Teman",
	PlaceholderText = "Masukkan nama teman...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		-- Tidak perlu callback di sini
	end,
})

TabTeleport:CreateButton({
   Name = "Pindahkan Teman ke Saya",
   Callback = function()
        local myChar = Player.Character
        local friendName = NamaTemanInput.CurrentValue
        
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({Title = "Gagal", Content = "Karakter-mu tidak ditemukan."})
            return
        end
        
        if not friendName or friendName == "" then
            Rayfield:Notify({Title = "Gagal", Content = "Masukkan nama teman terlebih dahulu."})
            return
        end

        local friendPlayer = game:GetService("Players"):FindFirstChild(friendName)
        if not friendPlayer then
            Rayfield:Notify({Title = "Gagal", Content = "Player '" .. friendName .. "' tidak ditemukan."})
            return
        end

        local friendChar = friendPlayer.Character
        if not friendChar or not friendChar:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({Title = "Gagal", Content = "Karakter teman '" .. friendName .. "' tidak ditemukan."})
            return
        end

        -- Mencoba teleportasi (membutuhkan izin khusus)
        pcall(function()
            friendChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Berhasil", Content = friendName .. " telah dipindahkan ke posisimu."})
        end)
   end,
})

--================================================================--
--                   INISIALISASI SAAT SKRIP MULAI                  --
--================================================================--
loadLocationsFromFile()
updateDropdownOptions()
Rayfield:LoadConfiguration() -- Memuat konfigurasi yang disimpan Rayfield