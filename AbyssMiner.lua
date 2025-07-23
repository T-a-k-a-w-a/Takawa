--================================================================--
--      SKRIP VERSI FINAL (RAYFIELD + FIX) - OLEH PARTNER CODING     --
--================================================================--

-- Pemuatan Library yang Aman (Safe Loading)
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Error", Text = "Gagal memuat Rayfield Library. Periksa konsol (F9) untuk detail.", Duration = 15
    })
    warn("Rayfield Library Gagal Dimuat! Periksa koneksi internet atau coba jalankan ulang skrip. Error: " .. tostring(Rayfield))
    return -- Menghentikan sisa skrip
end

-- Variabel Global
local Player = game:GetService("Players").LocalPlayer
local locations = {}
local locationFileName = "Rayfield_Locations.json"
local locationFolderPath = "Rayfield/" 
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
local Window = Rayfield:CreateWindow({
   Name = "Abyss Miner Menu (Rayfield)",
   LoadingTitle = "Memuat Abyss Miner Menu...",
   LoadingSubtitle = "oleh Partner Coding",
   Theme = "Ocean",
   ToggleUIKeybind = Enum.KeyCode.RightShift,
   ConfigurationSaving = {
      Enabled = true,
      FileName = "AbyssMinerRayfieldConfig"
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
        -- !-- PERBAIKAN: Baris LoadConfiguration() dihapus dari sini untuk mencegah konflik --!
        -- Memuat ulang status dari variabel, bukan dari file
        if uiElements.InstantMine then instantMineEnabled = uiElements.InstantMine.CurrentValue; uiElements.InstantMine:Set(instantMineEnabled) end
        if uiElements.AutoSell then autoSellEnabled = uiElements.AutoSell.CurrentValue; uiElements.AutoSell:Set(autoSellEnabled) end
        if uiElements.AntiFall then antiFallDamageEnabled = uiElements.AntiFall.CurrentValue; uiElements.AntiFall:Set(antiFallDamageEnabled) end
        if uiElements.FloatPlatform then floatPlatformEnabled = uiElements.FloatPlatform.CurrentValue; uiElements.FloatPlatform:Set(floatPlatformEnabled) end
        if uiElements.Fly then flyEnabled = uiElements.Fly.CurrentValue; uiElements.Fly:Set(flyEnabled) end
        if uiElements.Walkspeed then walkspeedValue = uiElements.Walkspeed.CurrentValue; uiElements.Walkspeed:Set(walkspeedValue) end
        Rayfield:Notify({Title="Pengaturan Dimuat", Content="Pengaturanmu telah dimuat ulang setelah respawn.", Image = "loader-circle"})
    end)
end)

--================================================================--
--                         UI TABS & SECTIONS                       --
--================================================================--
local TabUtama = Window:CreateTab("Main", "layout-template")
local SectionFarm = TabUtama:CreateSection("Otomatisasi Farm")
local SectionPlayer = TabUtama:CreateSection("Pengaturan Player")

local TabTeleport = Window:CreateTab("Teleportasi", "map-pin")
local SectionTeman = TabTeleport:CreateSection("Teleportasi Teman")

--================================================================--
--                         ELEMENTS                               --
--================================================================--
uiElements.InstantMine = SectionFarm:CreateToggle({ Name = "Instant Mine (Speed Only)", CurrentValue = false, Flag = "InstantMine", Callback = function(state) instantMineEnabled = state; if not state then restoreToolStats() end end, })
uiElements.AutoSell = SectionFarm:CreateToggle({ Name = "Auto Sell (15 detik)", CurrentValue = false, Flag = "AutoSell", Callback = function(state) autoSellEnabled = state; if autoSellEnabled then task.spawn(function() while autoSellEnabled do pcall(function() local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true); local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool"); if npc and tool then game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool) end end); task.wait(15) end end) end end, })
uiElements.Walkspeed = SectionPlayer:CreateSlider({ Name = "Walkspeed", Range = {16, 100}, Increment = 1, Suffix = " speed", CurrentValue = 16, Flag = "Walkspeed", Callback = function(value) walkspeedValue = value end, })
uiElements.AntiFall = SectionPlayer:CreateToggle({ Name = "Anti Fall Damage", CurrentValue = false, Flag = "AntiFall", Callback = function(state) antiFallDamageEnabled = state end, })
uiElements.FloatPlatform = SectionPlayer:CreateToggle({
    Name = "Float Platform", CurrentValue = false, Flag = "FloatPlatform",
    Callback = function(state)
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
    end,
})
uiElements.Fly = SectionPlayer:CreateToggle({ Name = "Toggle Fly", CurrentValue = false, Flag = "Fly", Callback = function(state) flyEnabled = state; if state then startFly() else stopFly() end end, })
uiElements.FlySpeed = SectionPlayer:CreateSlider({ Name = "Kecepatan Terbang", Range = {10, 200}, Increment = 5, Suffix = " speed", CurrentValue = 50, Flag = "FlySpeed", Callback = function(value) flySpeed = value end, })
uiElements.FriendName = SectionTeman:CreateInput({ Name = "Username Teman", PlaceholderText = "Masukkan nama teman...", Flag = "FriendName" })
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

-- Hapus fitur simpan lokasi via Json
-- Semua elemen dan fungsi terkait telah dihapus

-- Terakhir, muat konfigurasi yang tersimpan
Rayfield:LoadConfiguration()