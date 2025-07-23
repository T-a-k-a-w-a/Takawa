--================================================================--
--      ABYSS MINER ENHANCED (FIXED) - OLEH PARTNER CODING          --
--================================================================--

-- !-- CATATAN: Blok Anti-Detection dipindahkan ke dalam Tombol UI untuk mencegah konflik --!

-- Pemuatan Library yang Aman
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Error", 
        Text = "Gagal memuat Rayfield Library. Periksa koneksi internet.", 
        Duration = 15
    })
    warn("Rayfield Library Gagal Dimuat! Error: " .. tostring(Rayfield))
    return
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Variables
local Player = Players.LocalPlayer
local originalToolStats = {}
local lastKnownTool = nil

-- Feature States
local instantMineEnabled = false
local antiFallDamageEnabled = false
local flyEnabled = false
local autoSellEnabled = false
local walkspeedValue = 16
local flySpeed = 50
local floatPlatformEnabled = false

-- Float Platform Variables
local floatPlatform = nil
local platformConnection = nil
local platformY = 0

-- Buat Jendela Utama
local Window = Rayfield:CreateWindow({
   Name = "Abyss Miner Enhanced",
   LoadingTitle = "Memuat Abyss Miner Enhanced...",
   LoadingSubtitle = "oleh Partner Coding",
   Theme = "Ocean",
   ToggleUIKeybind = Enum.KeyCode.RightShift,
   ConfigurationSaving = {
      Enabled = false,
      FileName = "AbyssMinerEnhanced"
   }
})

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--
-- Fungsi Fly
local flying = false; local bodyVelocity, bodyGyro; local flyConnection
local function startFly() local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") or flying then return end; local rootPart = char.HumanoidRootPart; local humanoid = char:FindFirstChildOfClass("Humanoid"); bodyGyro = Instance.new("BodyGyro", rootPart); bodyGyro.P = 9e4; bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro.CFrame = rootPart.CFrame; bodyVelocity = Instance.new("BodyVelocity", rootPart); bodyVelocity.Velocity = Vector3.new(0, 0, 0); bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9); if humanoid then humanoid.PlatformStand = false end; flying = true; flyConnection = RunService.Heartbeat:Connect(function() if humanoid and flying then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end end) end
local function stopFly() if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end; if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end; if flyConnection then flyConnection:Disconnect(); flyConnection = nil end; flying = false; local char = Player.Character; if char then local humanoid = char:FindFirstChildOfClass("Humanoid"); if humanoid then humanoid.PlatformStand = false; humanoid:ChangeState(Enum.HumanoidStateType.Running) end end end

-- Fungsi Float Platform
local function createFloatPlatform() local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end; local rootPart = char.HumanoidRootPart; platformY = rootPart.Position.Y - 4; if floatPlatform then floatPlatform:Destroy() end; floatPlatform = Instance.new("Part", workspace); floatPlatform.Anchored = true; floatPlatform.CanCollide = true; floatPlatform.Size = Vector3.new(20, 1, 20); floatPlatform.Transparency = 1; floatPlatform.Name = "InvisiblePlatform_" .. math.random(1000, 9999); floatPlatform.Material = Enum.Material.Air; platformConnection = RunService.Heartbeat:Connect(function() if floatPlatform and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local currentRoot = Player.Character.HumanoidRootPart; local targetPos = Vector3.new(currentRoot.Position.X, platformY, currentRoot.Position.Z); floatPlatform.Position = targetPos else if platformConnection then platformConnection:Disconnect(); platformConnection = nil end; if floatPlatform then floatPlatform:Destroy(); floatPlatform = nil end end end) end

-- Fungsi Tool & Auto Sell
local function restoreToolStats() if lastKnownTool and originalToolStats[lastKnownTool] then local tool = lastKnownTool; local stats = originalToolStats[lastKnownTool]; pcall(function() if stats.Speed and tool:FindFirstChild("Speed") then tool.Speed.Value = stats.Speed end end); originalToolStats[lastKnownTool] = nil end end
local function performAutoSell() if not autoSellEnabled then return end; pcall(function() local character = Player.Character; if not character then return end; local npc; for _, path in pairs({workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei")}) do if path then npc = path; break end end; local tool = character:FindFirstChildOfClass("Tool"); if npc and tool then local sellRemote; for _, remote in pairs({ReplicatedStorage:FindFirstChild("RemoteEvent", true) and ReplicatedStorage.RemoteEvent:FindFirstChild("SellAllInventory")}) do if remote then sellRemote = remote; break end end; if sellRemote then sellRemote:FireServer(npc, tool); Rayfield:Notify({Title = "Auto Sell",Content = "Inventory berhasil dijual!",Duration = 2,Image = "dollar-sign"}) end end end) end

-- Fungsi Anti Fall Damage
local function setupAntiFallDamage(character) local humanoid = character:WaitForChild("Humanoid"); local function onStateChanged(old, new) if antiFallDamageEnabled then if new == Enum.HumanoidStateType.Landed then humanoid:ChangeState(Enum.HumanoidStateType.Running); if humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end end end end; humanoid.StateChanged:Connect(onStateChanged); local regenConnection; regenConnection = RunService.Heartbeat:Connect(function() if antiFallDamageEnabled and humanoid and humanoid.Health < humanoid.MaxHealth then humanoid.Health = math.min(humanoid.Health + 10, humanoid.MaxHealth) end; if not character.Parent then regenConnection:Disconnect() end end) end

--================================================================--
--                         MAIN LOOP & EVENTS                       --
--================================================================--
RunService.Heartbeat:Connect(function() local char = Player.Character; if not char then return end; local humanoid = char:FindFirstChildOfClass("Humanoid"); local rootPart = char:FindFirstChild("HumanoidRootPart"); if not humanoid or not rootPart then return end; if humanoid.WalkSpeed ~= walkspeedValue then humanoid.WalkSpeed = walkspeedValue end; if flying and bodyVelocity and bodyGyro then local camera = workspace.CurrentCamera; local velocity = Vector3.new(0, 0, 0); if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + camera.CFrame.LookVector * flySpeed end; if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - camera.CFrame.LookVector * flySpeed end; if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - camera.CFrame.RightVector * flySpeed end; if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + camera.CFrame.RightVector * flySpeed end; if UserInputService:IsKeyDown(Enum.KeyCode.E) then velocity = velocity + Vector3.new(0, flySpeed, 0) end; if UserInputService:IsKeyDown(Enum.KeyCode.Q) then velocity = velocity - Vector3.new(0, flySpeed, 0) end; bodyVelocity.Velocity = velocity; bodyGyro.CFrame = camera.CFrame; humanoid:ChangeState(Enum.HumanoidStateType.Physics) end; if instantMineEnabled then local tool = char:FindFirstChildOfClass("Tool"); if tool and tool ~= lastKnownTool then restoreToolStats(); lastKnownTool = tool end; if tool then if not originalToolStats[tool] then originalToolStats[tool] = { Speed = tool:FindFirstChild("Speed") and tool.Speed.Value or nil } end; pcall(function() local speed = tool:FindFirstChild("Speed"); if speed and speed.Value ~= 0 then speed.Value = 0 end end) else restoreToolStats(); lastKnownTool = nil end end end)
Player.CharacterAdded:Connect(function(char) wait(1); setupAntiFallDamage(char); flying = false; if bodyVelocity then bodyVelocity:Destroy() end; if bodyGyro then bodyGyro:Destroy() end; bodyVelocity = nil; bodyGyro = nil; if floatPlatformEnabled then wait(2); createFloatPlatform() end end)
spawn(function() while wait(15) do if autoSellEnabled then performAutoSell() end end end)

--================================================================--
--                         UI CREATION                              --
--================================================================--
local TabUtama = Window:CreateTab("Main Features", "settings")
local SectionFarm = TabUtama:CreateSection("🚀 Farming Features")
local SectionPlayer = TabUtama:CreateSection("👤 Player Features")
local TabTeleport = Window:CreateTab("Teleportasi", "map-pin")
local SectionTeman = TabTeleport:CreateSection("👥 Friend Teleport")
local TabAdvanced = Window:CreateTab("Advanced", "shield")
local SectionBypass = TabAdvanced:CreateSection("🛡️ Anti-Detection")

--================================================================--
--                         UI ELEMENTS                              --
--================================================================--
SectionFarm:CreateToggle({ Name = "⚡ Instant Mine (Speed 0.0)", CurrentValue = false, Callback = function(state) instantMineEnabled = state; if not state then restoreToolStats() end; Rayfield:Notify({ Title = "Instant Mine", Content = state and "Activated!" or "Deactivated!", Duration = 2, Image = "pickaxe" }) end, })
SectionFarm:CreateToggle({ Name = "💰 Auto Sell (15 seconds)", CurrentValue = false, Callback = function(state) autoSellEnabled = state; Rayfield:Notify({ Title = "Auto Sell", Content = state and "Diaktifkan! Menjual setiap 15 detik" or "Dinonaktifkan!", Duration = 3, Image = "dollar-sign" }) end, })
SectionPlayer:CreateSlider({ Name = "🏃 Walkspeed", Range = {16, 100}, Increment = 1, Suffix = " speed", CurrentValue = 16, Callback = function(value) walkspeedValue = value end, })
SectionPlayer:CreateToggle({ Name = "🛡️ Anti Fall Damage + Regen", CurrentValue = false, Callback = function(state) antiFallDamageEnabled = state; Rayfield:Notify({ Title = "Anti Fall Damage", Content = state and "Aktif! Kamu terlindungi dari damage jatuh." or "Nonaktif!", Duration = 3, Image = "shield" }) end, })
SectionPlayer:CreateToggle({ Name = "🟦 Float Platform", CurrentValue = false, Callback = function(state) floatPlatformEnabled = state; if state then createFloatPlatform(); Rayfield:Notify({ Title = "Float Platform", Content = "Aktif! Platform dibuat di bawahmu.", Duration = 3, Image = "square" }) else if platformConnection then platformConnection:Disconnect(); platformConnection = nil end; if floatPlatform then floatPlatform:Destroy(); floatPlatform = nil end; Rayfield:Notify({ Title = "Float Platform", Content = "Nonaktif!", Duration = 2, Image = "square" }) end end, })
SectionPlayer:CreateToggle({ Name = "✈️ Enhanced Fly", CurrentValue = false, Callback = function(state) flyEnabled = state; if state then startFly(); Rayfield:Notify({ Title = "Enhanced Fly", Content = "Aktif! Gunakan WASD + E/Q.", Duration = 4, Image = "plane" }) else stopFly(); Rayfield:Notify({ Title = "Enhanced Fly", Content = "Nonaktif!", Duration = 2, Image = "plane" }) end end, })
SectionPlayer:CreateSlider({ Name = "🚀 Fly Speed", Range = {10, 200}, Increment = 5, Suffix = " speed", CurrentValue = 50, Callback = function(value) flySpeed = value end, })
local friendNameInput = SectionTeman:CreateInput({ Name = "Friend Username", PlaceholderText = "Enter friend's username...", CurrentValue = "" })
SectionTeman:CreateButton({ Name = "📍 Teleport Friend to Me", Callback = function() local myChar = Player.Character; local friendName = friendNameInput.CurrentValue; if not (myChar and myChar.PrimaryPart) then Rayfield:Notify({ Title = "Error", Content = "Karakter tidak ditemukan!", Duration = 3, Image = "alert-triangle" }); return end; if not (friendName and friendName ~= "") then Rayfield:Notify({ Title = "Error", Content = "Masukkan nama teman!", Duration = 3, Image = "alert-triangle" }); return end; local friendPlayer = Players:FindFirstChild(friendName); if not (friendPlayer and friendPlayer.Character and friendPlayer.Character.PrimaryPart) then Rayfield:Notify({ Title = "Error", Content = "Player '" .. friendName .. "' tidak ditemukan!", Duration = 3, Image = "alert-triangle" }); return end; pcall(function() friendPlayer.Character:SetPrimaryPartCFrame(CFrame.new(myChar.PrimaryPart.Position)); Rayfield:Notify({ Title = "Success", Content = friendName .. " berhasil diteleport!", Duration = 3, Image = "user-check" }) end) end, })
SectionBypass:CreateLabel("🛡️ Anti-Detection Status: STANDBY")
SectionBypass:CreateLabel("Klik tombol di bawah untuk mengaktifkan perlindungan.")
SectionBypass:CreateButton({
    Name = "✅ Activate / Refresh Bypass",
    Callback = function()
        pcall(function()
            -- !-- KODE BYPASS SEKARANG DI SINI --!
            local mt = getrawmetatable(game)
            local oldIndex = mt.__index
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)

            local blockedRemotes = {"AntiCheat", "AC", "Detection", "BanRemote", "KickRemote", "LogRemote", "ReportRemote", "FlagRemote", "SecurityRemote"}
            local spoofedMethods = {"kick", "Kick", "remove", "Remove", "destroy", "Destroy"}

            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if typeof(self) == "Instance" then
                    local name = tostring(self)
                    for _, blocked in pairs(blockedRemotes) do if string.find(name:lower(), blocked:lower()) then return wait(9e9) end end
                    for _, spoofed in pairs(spoofedMethods) do if method:lower() == spoofed:lower() then return wait(9e9) end end
                end
                return oldNamecall(self, ...)
            end)

            mt.__index = newcclosure(function(self, key)
                if typeof(self) == "Instance" and self.ClassName == "Humanoid" and key == "PlatformStand" then
                    return false
                end
                if typeof(self) == "Instance" and self.ClassName == "HumanoidRootPart" and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                    return Vector3.new(0, -50, 0)
                end
                return oldIndex(self, key)
            end)
            setreadonly(mt, true)
        end)
        
        Rayfield:Notify({ Title = "Anti-Detection", Content = "Sistem bypass berhasil diaktifkan!", Duration = 3, Image = "shield" })
    end,
})

-- Notifikasi akhir
Rayfield:Notify({ Title = "Abyss Miner Enhanced", Content = "Semua fitur berhasil dimuat!", Duration = 5, Image = "check-circle" })
print("🚀 Abyss Miner Enhanced loaded successfully!")