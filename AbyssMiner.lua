--================================================================--
--      SKRIP VERSI FINAL (RAYFIELD + SEMUA FITUR) - OLEH PARTNER CODING     --
--================================================================--

-- Muat Library Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variabel Global
local Player = game:GetService("Players").LocalPlayer
local locations = {}
local locationFileName = "Rayfield_Locations.json"
local locationFolderPath = "Rayfield/" -- Folder khusus untuk Rayfield
local originalToolStats = {}
local lastKnownTool = nil

-- Variabel Status Fitur
local instantMineEnabled, antiFallDamageEnabled, flyEnabled, autoSellEnabled = false, false, false, false
local walkspeedValue = 16
local flySpeed = 50 

-- Buat Jendela Utama
local Window = Rayfield:CreateWindow({
   Name = "Abyss Miner Menu FINAL",
   LoadingTitle = "Memuat Abyss Miner Menu...",
   LoadingSubtitle = "oleh Partner Coding",
   Theme = "Ocean", -- Menggunakan tema Ocean sesuai permintaan
   ToggleUIKeybind = Enum.KeyCode.RightShift,
   ConfigurationSaving = {
      Enabled = true,
      FileName = "AbyssMinerConfig"
   }
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
    
    -- Auto Re-Apply Settings
    task.wait(2)
    pcall(function()
        if uiElements.InstantMine and instantMineEnabled then uiElements.InstantMine:Set(true) end
        if uiElements.AutoSell and autoSellEnabled then uiElements.AutoSell:Set(true) end
        if uiElements.AntiFall and antiFallDamageEnabled then uiElements.AntiFall:Set(true) end
        if uiElements.Fly and flyEnabled then uiElements.Fly:Set(true) end
        if uiElements.Walkspeed then uiElements.Walkspeed:Set(walkspeedValue) end
        Rayfield:Notify({Title="Pengaturan Dimuat", Content="Pengaturanmu telah dimuat ulang setelah respawn.", Image = "loader-circle"})
    end)
end)

-- Fungsi file system lokasi
local function saveLocationsToFile() if writefile then pcall(function() if not isfolder(locationFolderPath) then makefolder(locationFolderPath) end; writefile(locationFolderPath .. locationFileName, game:GetService("HttpService"):JSONEncode(locations)) end) end
local function loadLocationsFromFile() if isfile and readfile and isfolder(locationFolderPath) then if isfile(locationFolderPath .. locationFileName) then local s, d = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName)) end); if s and type(d) == "table" then locations = d end end end

--================================================================--
--                         UI TABS & SECTIONS                       --
--================================================================--
local TabUtama = Window:CreateTab("Main", "pickaxe")
local SectionFarm = TabUtama:CreateSection("Otomatisasi Farm")
local SectionPlayer = TabUtama:CreateSection("Pengaturan Player")

local TabTeleport = Window:CreateTab("Teleportasi", "map-pin")
local SectionLokasi = TabTeleport:CreateSection("Simpan & Teleportasi Lokasi")
local SectionTeman = TabTeleport:CreateSection("Teleportasi Teman")

--================================================================--
--                         ELEMENTS: TAB MAIN                       --
--================================================================--
uiElements.InstantMine = SectionFarm:CreateToggle({
   Name = "Instant Mine (Speed Only)",
   CurrentValue = false,
   Flag = "InstantMine",
   Callback = function(state)
        instantMineEnabled = state
        if not state then restoreToolStats() end
   end,
})

uiElements.AutoSell = SectionFarm:CreateToggle({
   Name = "Auto Sell (15 detik)",
   CurrentValue = false,
   Flag = "AutoSell",
   Callback = function(state)
        autoSellEnabled = state
        if autoSellEnabled then
            task.spawn(function()
                while autoSellEnabled do
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
   end,
})

--================================================================--
--                        ELEMENTS: TAB PLAYER                      --
--================================================================--
uiElements.Walkspeed = SectionPlayer:CreateSlider({
   Name = "Walkspeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = " speed",
   CurrentValue = 16,
   Flag = "Walkspeed",
   Callback = function(value)
        walkspeedValue = value
   end,
})

uiElements.FlySpeed = SectionPlayer:CreateSlider({
   Name = "Kecepatan Terbang",
   Range = {10, 200},
   Increment = 5,
   Suffix = " speed",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(value)
        flySpeed = value
   end,
})

uiElements.AntiFall = SectionPlayer:CreateToggle({
   Name = "Anti Fall Damage",
   CurrentValue = false,
   Flag = "AntiFall",
   Callback = function(state)
        antiFallDamageEnabled = state
   end,
})

uiElements.Fly = SectionPlayer:CreateToggle({
   Name = "Toggle Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(state)
        flyEnabled = state
        if state then startFly() else stopFly() end
   end,
})

--================================================================--
--                       ELEMENTS: TAB TELEPORT                     --
--================================================================--
local LocationDropdown
local function updateLocationsDropdown()
    local options = {}
    for i, locData in ipairs(locations) do table.insert(options, locData.Name) end
    if LocationDropdown then
        LocationDropdown:Refresh(options)
    end
end

SectionLokasi:CreateButton({
   Name = "Simpan Lokasi Saat Ini",
   Callback = function()
       -- Di Rayfield, dialog tidak ada, jadi kita gunakan Input untuk nama
       SectionLokasi:CreateInput({
           Name = "Nama Lokasi",
           PlaceholderText = "Contoh: Base",
           RemoveTextAfterFocusLost = true,
           Callback = function(text)
               if text and text ~= "" and Player.Character and Player.Character.PrimaryPart then
                   local pos = Player.Character.PrimaryPart.Position
                   table.insert(locations, {Name = text, Pos = {x = pos.X, y = pos.Y, z = pos.Z}})
                   saveLocationsToFile()
                   updateLocationsDropdown()
                   Rayfield:Notify({Title="Lokasi Disimpan", Content= text .. " berhasil disimpan.", Image = "save"})
               end
           end
       })
   end,
})

loadLocationsFromFile()
local dropdownOptions = {}
for i, locData in ipairs(locations) do table.insert(dropdownOptions, locData.Name) end

LocationDropdown = SectionLokasi:CreateDropdown({
   Name = "Pilih Lokasi",
   Options = dropdownOptions,
   CurrentOption = dropdownOptions[1] and {dropdownOptions[1]} or {},
   MultipleOptions = false,
   Flag = "LocationDropdown",
   Callback = function(option) end,
})

SectionLokasi:CreateButton({
   Name = "Set Spawn di Lokasi Terpilih",
   Callback = function()
        if #LocationDropdown.CurrentOption > 0 then
            local selectedName = LocationDropdown.CurrentOption[1]
            local selectedLocData
            for _, locData in ipairs(locations) do if locData.Name == selectedName then selectedLocData = locData; break end end
            
            if selectedLocData then
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SetSpawnPoint"):FireServer(Vector3.new(selectedLocData.Pos.x, selectedLocData.Pos.y, selectedLocData.Pos.z))
                    Rayfield:Notify({Title="Spawn Point Diatur", Content="Spawn diatur di " .. selectedName, Image = "map-pin"})
                end)
            else Rayfield:Notify({Title="Gagal", Content="Pilih lokasi yang valid.", Image = "alert-triangle"}) end
        end
   end,
})

SectionLokasi:CreateButton({
   Name = "RESET KARAKTER (TELEPORT)",
   Callback = function() if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.Health = 0 end end
})

uiElements.FriendName = SectionTeman:CreateInput({
   Name = "Username Teman",
   PlaceholderText = "Masukkan nama teman...",
   Flag = "FriendName",
   Callback = function(text) end
})

SectionTeman:CreateButton({
   Name = "Pindahkan Teman ke Saya",
   Callback = function()
        local myChar = Player.Character; local friendName = uiElements.FriendName.CurrentValue
        if not (myChar and myChar.PrimaryPart) then Rayfield:Notify({Title="Gagal", Content="Karaktermu tidak ditemukan.", Image = "alert-triangle"}); return end
        if not (friendName and friendName ~= "") then Rayfield:Notify({Title="Gagal", Content="Masukkan nama teman.", Image = "alert-triangle"}); return end
        local friendPlayer = game:GetService("Players"):FindFirstChild(friendName)
        if not (friendPlayer and friendPlayer.Character and friendPlayer.Character.PrimaryPart) then Rayfield:Notify({Title="Gagal", Content="Player '" .. friendName .. "' tidak ditemukan.", Image = "alert-triangle"}); return end
        pcall(function() friendPlayer.Character:SetPrimaryPartCFrame(myChar.PrimaryPart.CFrame); Rayfield:Notify({Title="Berhasil", Content=friendName .. " telah dipindahkan.", Image = "user-check"}) end)
   end,
})

-- Terakhir, muat konfigurasi yang tersimpan
Rayfield:LoadConfiguration()