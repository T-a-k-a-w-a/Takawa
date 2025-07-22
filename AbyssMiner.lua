--================================================================--
--      SKRIP DIKONVERSI KE ROLIBWAITA UI OLEH PARTNER CODING       --
--================================================================--

-- Muat Library Rolibwaita
local rolibwaita = loadstring(game:HttpGet("https://codeberg.org/Blukez/rolibwaita/raw/branch/master/Source.lua"))()

-- Variabel Global untuk Fitur
local uiElements = {}
local instantMineEnabled, antiFallDamageEnabled, flyEnabled, autoSellEnabled = false, false, false, false
local walkspeedValue = 16
local flySpeed = 50 
local locations = {}
local locationFileName = "Rayfield_Locations.json"
local locationFolderPath = "Download/"
local originalToolStats = {}
local lastKnownTool = nil

-- Buat Jendela Utama (Sintaks Rolibwaita)
local Window = rolibwaita:NewWindow({
    Name = "Abyss Miner Menu",
    Keybind = "RightShift", -- Keybind untuk buka/tutup menu
    UseCoreGui = true,
    PrintCredits = false
})

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--

local Player = game:GetService("Players").LocalPlayer

-- Fungsi untuk Mengembalikan Statistik Tool
local function restoreToolStats() if lastKnownTool and originalToolStats[lastKnownTool] then local tool = lastKnownTool; local stats = originalToolStats[lastKnownTool]; pcall(function() if stats.Speed and tool:FindFirstChild("Speed") then tool.Speed.Value = stats.Speed end end); originalToolStats[lastKnownTool] = nil end end

-- Fungsi Fly
local flying = false; local bodyVelocity, bodyGyro
local function startFly() local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end; local rootPart = char.HumanoidRootPart; bodyGyro = Instance.new("BodyGyro", rootPart); bodyGyro.P = 9e4; bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro.CFrame = rootPart.CFrame; bodyVelocity = Instance.new("BodyVelocity", rootPart); bodyVelocity.Velocity = Vector3.new(0, 0, 0); bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9); flying = true end
local function stopFly() if bodyGyro then bodyGyro:Destroy() end; if bodyVelocity then bodyVelocity:Destroy() end; flying = false end

-- Loop utama untuk fitur yang berjalan terus menerus
game:GetService("RunService").Heartbeat:Connect(function()
    local char = Player.Character
    if not char then return end
    
    -- Perbaikan Bug Walkspeed
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed ~= walkspeedValue then
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
local function onStateChanged(old, new) if new == Enum.HumanoidStateType.Landed and antiFallDamageEnabled then pcall(function() Player.Character.Humanoid.Sit = true; task.wait(); Player.Character.Humanoid.Sit = false end) end end
if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.StateChanged:Connect(onStateChanged) end
Player.CharacterAdded:Connect(function(char) local humanoid = char:WaitForChild("Humanoid"); humanoid.StateChanged:Connect(onStateChanged) end)

-- Fungsi Auto Re-Apply Settings on Respawn
local function reapplySettings()
    task.wait(1.5)
    pcall(function()
        if uiElements.InstantMine and instantMineEnabled then uiElements.InstantMine:Edit({ CurrentState = true }) end
        if uiElements.AutoSell and autoSellEnabled then uiElements.AutoSell:Edit({ CurrentState = true }) end
        if uiElements.AntiFall and antiFallDamageEnabled then uiElements.AntiFall:Edit({ CurrentState = true }) end
        if uiElements.Fly and flyEnabled then uiElements.Fly:Edit({ CurrentState = true }) end
        if uiElements.Walkspeed then uiElements.Walkspeed:Edit({ CurrentValue = walkspeedValue }) end
    end)
end
Player.CharacterAdded:Connect(reapplySettings)

--================================================================--
--                         TAB & ELEMEN UI (Rolibwaita)             --
--================================================================--
local TabUtama = Window:NewTab({ Name = "Main" })
local TabTeleport = Window:NewTab({ Name = "Teleport" })

-- Fitur di Tab Utama
local SectionFarm = TabUtama:NewSection({ Name = "Otomatisasi Farm" })
uiElements.InstantMine = SectionFarm:NewToggle({
    Name = "Instant Mine (Speed Only)",
    Description = "Aktifkan, lalu tahan klik untuk mining super cepat.",
    CurrentState = false,
    Callback = function(state)
        instantMineEnabled = state
        if not state then restoreToolStats() end
    end,
})
uiElements.AutoSell = SectionFarm:NewToggle({
    Name = "Auto Sell (15 detik)",
    CurrentState = false,
    Callback = function(state)
        autoSellEnabled = state
        if autoSellEnabled then
            task.spawn(function()
                while autoSellEnabled do
                    pcall(function()
                        local args = { workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"), workspace:WaitForChild("Map"):WaitForChild("Layer 1"):WaitForChild("Npcs"):WaitForChild("Rei ' The professer"):WaitForChild("Rei"):WaitForChild("HumanoidRootPart"):WaitForChild("Dialogue") }
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(unpack(args))
                    end)
                    task.wait(15)
                end
            end)
        end
    end,
})

local SectionPlayer = TabUtama:NewSection({ Name = "Pengaturan Player" })
uiElements.Walkspeed = SectionPlayer:NewSlider({
    Name = "Walkspeed",
    MinMax = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        walkspeedValue = value
    end,
})
uiElements.AntiFall = SectionPlayer:NewToggle({
    Name = "Anti Fall Damage",
    Description = "Mencegah damage saat jatuh dari ketinggian.",
    CurrentState = false,
    Callback = function(state)
        antiFallDamageEnabled = state
    end,
})
uiElements.Fly = SectionPlayer:NewToggle({
    Name = "Toggle Fly",
    Description = "Gunakan W/A/S/D/E/Q untuk terbang.",
    CurrentState = false,
    Callback = function(state)
        flyEnabled = state
        if state then startFly() else stopFly() end
    end,
})

-- Fitur di Tab Teleport
local SectionLokasi = TabTeleport:NewSection({ Name = "Simpan & Teleportasi Lokasi" })
local LokasiDropdown
local function saveLocationsToFile() if writefile then pcall(function() local json = game:GetService("HttpService"):JSONEncode(locations); writefile(locationFolderPath .. locationFileName, json) end) end end
local function loadLocationsFromFile() if isfile and readfile and isfolder then if not isfolder(locationFolderPath) then makefolder(locationFolderPath) end; if isfile(locationFolderPath .. locationFileName) then local success, data = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(locationFolderPath .. locationFileName)) end); if success and type(data) == "table" then locations = data end end end end
local function updateDropdownOptions()
    local options = {}
    for i = 1, #locations do table.insert(options, "Lokasi " .. i) end
    if LokasiDropdown then
        -- !-- FITUR REFRESH DROPDOWN BERFUNGSI DI ROLIBWAITA --!
        LokasiDropdown:Edit({ Choices = options })
    end
end

SectionLokasi:NewButton({
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

local dropdownOptions = {}
loadLocationsFromFile() -- Muat lokasi sebelum membuat dropdown
for i = 1, #locations do table.insert(dropdownOptions, "Lokasi " .. i) end

LokasiDropdown = SectionLokasi:NewDropdown({
    Name = "Pilih Lokasi",
    Choices = dropdownOptions,
    CurrentState = dropdownOptions[1] or "",
    Callback = function(value)
        -- Nilai sudah otomatis diupdate
    end,
})

SectionLokasi:NewButton({
    Name = "Teleport ke Lokasi Terpilih",
    Callback = function()
        local selectedOption = LokasiDropdown.CurrentState -- Akses nilai terbaru dari properti elemen
        if selectedOption and selectedOption ~= "" and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local index = tonumber(string.match(selectedOption, "%d+"))
            if index and locations[index] then
                local loc = locations[index]
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(loc.x, loc.y + 5, loc.z)
            end
        end
    end,
})

local SectionTeman = TabTeleport:NewSection({ Name = "Teleportasi Teman" })
local NamaTemanInput = SectionTeman:NewTextBox({
    Name = "Username Teman",
    PlaceholderText = "Masukkan nama teman...",
    Trigger = "TextChanged",
    Callback = function(value)
        -- Nilai otomatis diupdate oleh elemen
    end,
})
SectionTeman:NewButton({
    Name = "Pindahkan Teman ke Saya",
    Callback = function()
        local myChar = Player.Character
        local friendName = NamaTemanInput.TextBox.Text
        if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end
        if not (friendName and friendName ~= "") then return end
        local friendPlayer = game:GetService("Players"):FindFirstChild(friendName)
        if not friendPlayer then return end
        local friendChar = friendPlayer.Character
        if not (friendChar and friendChar:FindFirstChild("HumanoidRootPart")) then return end
        pcall(function() friendChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame end)
    end,
})