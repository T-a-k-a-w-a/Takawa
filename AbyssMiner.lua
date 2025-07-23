--================================================================--
--      ABYSS MINER ENHANCED - OLEH PARTNER CODING               --
--================================================================--

-- Anti Detection & Bypass Setup
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNamecall = mt.__namecall
setreadonly(mt, false)

-- Block Anti-Cheat Detection
local blockedRemotes = {
    "AntiCheat", "AC", "Detection", "BanRemote", "KickRemote", 
    "LogRemote", "ReportRemote", "FlagRemote", "SecurityRemote"
}

local spoofedMethods = {
    "kick", "Kick", "remove", "Remove", "destroy", "Destroy"
}

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Block anti-cheat remotes
    if typeof(self) == "Instance" then
        local name = tostring(self)
        for _, blocked in pairs(blockedRemotes) do
            if string.find(name:lower(), blocked:lower()) then
                return wait(9e9)
            end
        end
        
        -- Spoof dangerous methods
        for _, spoofed in pairs(spoofedMethods) do
            if method:lower() == spoofed:lower() then
                return wait(9e9)
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Spoof Position & Movement Detection
mt.__index = newcclosure(function(self, key)
    if typeof(self) == "Instance" and self.ClassName == "Humanoid" then
        if key == "PlatformStand" then
            return false -- Always return false to prevent fly detection
        end
    end
    
    if typeof(self) == "Instance" and self.ClassName == "HumanoidRootPart" then
        if key == "AssemblyLinearVelocity" or key == "Velocity" then
            -- Spoof velocity to appear normal
            return Vector3.new(0, -50, 0)
        end
    end
    
    return oldIndex(self, key)
end)

setreadonly(mt, true)

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

-- Anti-Detection Variables
local originalCFrame = nil
local smoothMovement = true

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

-- Bypass Function untuk smooth movement
local function smoothTeleport(targetPosition, duration)
    duration = duration or 0.5
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local rootPart = character.HumanoidRootPart
    local startPosition = rootPart.Position
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(rootPart, tweenInfo, {
        Position = targetPosition
    })
    
    tween:Play()
    return tween
end

-- Enhanced Fly System with Anti-Detection
local flying = false
local bodyVelocity, bodyGyro
local flyConnection

local function startFly()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or flying then
        return
    end
    
    local rootPart = char.HumanoidRootPart
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    -- Store original position for spoofing
    originalCFrame = rootPart.CFrame
    
    -- Create invisible body movers
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Parent = rootPart
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Parent = rootPart
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    -- Spoof humanoid state
    if humanoid then
        humanoid.PlatformStand = false -- Keep this false to avoid detection
    end
    
    flying = true
    
    -- Anti-detection: Simulate normal walking animation
    flyConnection = RunService.Heartbeat:Connect(function()
        if humanoid and flying then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end)
end

local function stopFly()
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    flying = false
    originalCFrame = nil
    
    -- Reset humanoid state
    local char = Player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end

-- Enhanced Float Platform
local function createFloatPlatform()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local rootPart = char.HumanoidRootPart
    platformY = rootPart.Position.Y - 4
    
    -- Destroy existing platform
    if floatPlatform then
        floatPlatform:Destroy()
    end
    
    -- Create invisible platform
    floatPlatform = Instance.new("Part")
    floatPlatform.Parent = workspace
    floatPlatform.Anchored = true
    floatPlatform.CanCollide = true
    floatPlatform.Size = Vector3.new(20, 1, 20)
    floatPlatform.Transparency = 1
    floatPlatform.Name = "InvisiblePlatform_" .. math.random(1000, 9999)
    floatPlatform.Material = Enum.Material.Air
    
    -- Platform follow connection
    platformConnection = RunService.Heartbeat:Connect(function()
        if floatPlatform and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local currentRoot = Player.Character.HumanoidRootPart
            local targetPos = Vector3.new(currentRoot.Position.X, platformY, currentRoot.Position.Z)
            floatPlatform.Position = targetPos
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
    end)
end

-- Enhanced Tool Stats Management
local function restoreToolStats()
    if lastKnownTool and originalToolStats[lastKnownTool] then
        local tool = lastKnownTool
        local stats = originalToolStats[lastKnownTool]
        
        pcall(function()
            if stats.Speed and tool:FindFirstChild("Speed") then
                tool.Speed.Value = stats.Speed
            end
        end)
        
        originalToolStats[lastKnownTool] = nil
    end
end

-- Enhanced Auto Sell with Bypass
local function performAutoSell()
    if not autoSellEnabled then return end
    
    pcall(function()
        local character = Player.Character
        if not character then return end
        
        -- Find NPC (multiple possible paths)
        local npc = nil
        local possiblePaths = {
            workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Layer 1") and workspace.Map["Layer 1"]:FindFirstChild("Npcs") and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer") and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei"),
            workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild("Rei"),
            workspace:FindFirstChild("Rei"),
        }
        
        for _, path in pairs(possiblePaths) do
            if path then
                npc = path
                break
            end
        end
        
        local tool = character:FindFirstChildOfClass("Tool")
        
        if npc and tool then
            -- Find sell remote
            local sellRemote = nil
            local possibleRemotes = {
                ReplicatedStorage:FindFirstChild("RemoteEvent") and ReplicatedStorage.RemoteEvent:FindFirstChild("SellAllInventory"),
                ReplicatedStorage:FindFirstChild("SellAllInventory"),
                ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("SellAllInventory"),
            }
            
            for _, remote in pairs(possibleRemotes) do
                if remote then
                    sellRemote = remote
                    break
                end
            end
            
            if sellRemote then
                sellRemote:FireServer(npc, tool)
                
                Rayfield:Notify({
                    Title = "Auto Sell",
                    Content = "Inventory berhasil dijual!",
                    Duration = 2,
                    Image = "dollar-sign"
                })
            end
        end
    end)
end

-- Enhanced Anti Fall Damage with Regeneration
local function setupAntiFallDamage(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Enhanced fall damage prevention
    local function onStateChanged(old, new)
        if antiFallDamageEnabled then
            if new == Enum.HumanoidStateType.Freefall then
                -- Prevent fall damage by changing state
                wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Flying)
                wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            elseif new == Enum.HumanoidStateType.Landed then
                -- Additional protection when landing
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                
                -- Instant regeneration
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end
    end
    
    humanoid.StateChanged:Connect(onStateChanged)
    
    -- Health regeneration boost
    local regenConnection
    regenConnection = RunService.Heartbeat:Connect(function()
        if antiFallDamageEnabled and humanoid and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = math.min(humanoid.Health + 10, humanoid.MaxHealth)
        end
        
        if not character.Parent then
            regenConnection:Disconnect()
        end
    end)
end

--================================================================--
--                         MAIN LOOP                               --
--================================================================--

-- Enhanced Main Loop
RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end

    -- Walkspeed management
    if humanoid.WalkSpeed ~= walkspeedValue then
        humanoid.WalkSpeed = walkspeedValue
    end
    
    -- Enhanced Fly Controls
    if flying and bodyVelocity and bodyGyro then
        local camera = workspace.CurrentCamera
        local velocity = Vector3.new(0, 0, 0)
        
        -- WASD + EQ Controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            velocity = velocity + camera.CFrame.LookVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            velocity = velocity - camera.CFrame.LookVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            velocity = velocity - camera.CFrame.RightVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            velocity = velocity + camera.CFrame.RightVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            velocity = velocity + Vector3.new(0, flySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            velocity = velocity - Vector3.new(0, flySpeed, 0)
        end
        
        -- Apply velocity with anti-detection
        bodyVelocity.Velocity = velocity
        bodyGyro.CFrame = camera.CFrame
        
        -- Spoof normal movement
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
    
    -- Enhanced Instant Mine
    if instantMineEnabled then
        local tool = char:FindFirstChildOfClass("Tool")
        
        if tool and tool ~= lastKnownTool then
            restoreToolStats()
            lastKnownTool = tool
        end
        
        if tool then
            if not originalToolStats[tool] then
                originalToolStats[tool] = {
                    Speed = tool:FindFirstChild("Speed") and tool.Speed.Value or nil
                }
            end
            
            -- Set speed to 0.0 for instant mining
            pcall(function()
                local speed = tool:FindFirstChild("Speed")
                if speed and speed.Value ~= 0 then
                    speed.Value = 0
                end
            end)
        else
            restoreToolStats()
            lastKnownTool = nil
        end
    end
end)

--================================================================--
--                         EVENT HANDLERS                          --
--================================================================--

-- Character spawn handler
Player.CharacterAdded:Connect(function(char)
    wait(1) -- Wait for character to fully load
    
    -- Setup anti fall damage
    setupAntiFallDamage(char)
    
    -- Reset variables
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    bodyVelocity = nil
    bodyGyro = nil
    
    -- Recreate float platform if enabled
    if floatPlatformEnabled then
        wait(2)
        createFloatPlatform()
    end
end)

--================================================================--
--                         AUTO SELL LOOP                          --
--================================================================--

-- Auto Sell Loop
spawn(function()
    while wait(15) do
        if autoSellEnabled then
            performAutoSell()
        end
    end
end)

--================================================================--
--                         UI CREATION                             --
--================================================================--

local TabUtama = Window:CreateTab("Main Features", "settings")
local SectionFarm = TabUtama:CreateSection("🚀 Farming Features")
local SectionPlayer = TabUtama:CreateSection("👤 Player Features")

local TabTeleport = Window:CreateTab("Teleportasi", "map-pin")
local SectionTeman = TabTeleport:CreateSection("👥 Friend Teleport")

local TabAdvanced = Window:CreateTab("Advanced", "shield")
local SectionBypass = TabAdvanced:CreateSection("🛡️ Anti-Detection")

--================================================================--
--                         UI ELEMENTS                             --
--================================================================--

-- Farming Features
SectionFarm:CreateToggle({
    Name = "⚡ Instant Mine (Speed 0.0)",
    CurrentValue = false,
    Callback = function(state)
        instantMineEnabled = state
        if not state then
            restoreToolStats()
        end
        
        Rayfield:Notify({
            Title = "Instant Mine",
            Content = state and "Activated!" or "Deactivated!",
            Duration = 2,
            Image = "pickaxe"
        })
    end,
})

SectionFarm:CreateToggle({
    Name = "💰 Auto Sell (15 seconds)",
    CurrentValue = false,
    Callback = function(state)
        autoSellEnabled = state
        
        Rayfield:Notify({
            Title = "Auto Sell",
            Content = state and "Activated! Selling every 15 seconds" or "Deactivated!",
            Duration = 3,
            Image = "dollar-sign"
        })
    end,
})

-- Player Features
SectionPlayer:CreateSlider({
    Name = "🏃 Walkspeed",
    Range = {16, 100},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 16,
    Callback = function(value)
        walkspeedValue = value
    end,
})

SectionPlayer:CreateToggle({
    Name = "🛡️ Anti Fall Damage + Regen",
    CurrentValue = false,
    Callback = function(state)
        antiFallDamageEnabled = state
        
        Rayfield:Notify({
            Title = "Anti Fall Damage",
            Content = state and "Activated! You're now protected from fall damage with fast regen!" or "Deactivated!",
            Duration = 3,
            Image = "shield"
        })
    end,
})

SectionPlayer:CreateToggle({
    Name = "🟦 Float Platform",
    CurrentValue = false,
    Callback = function(state)
        floatPlatformEnabled = state
        
        if state then
            createFloatPlatform()
            Rayfield:Notify({
                Title = "Float Platform",
                Content = "Activated! Invisible platform created below you!",
                Duration = 3,
                Image = "square"
            })
        else
            if platformConnection then
                platformConnection:Disconnect()
                platformConnection = nil
            end
            if floatPlatform then
                floatPlatform:Destroy()
                floatPlatform = nil
            end
            Rayfield:Notify({
                Title = "Float Platform",
                Content = "Deactivated!",
                Duration = 2,
                Image = "square"
            })
        end
    end,
})

SectionPlayer:CreateToggle({
    Name = "✈️ Enhanced Fly",
    CurrentValue = false,
    Callback = function(state)
        flyEnabled = state
        
        if state then
            startFly()
            Rayfield:Notify({
                Title = "Enhanced Fly",
                Content = "Activated! Use WASD + E/Q to fly. Anti-detection enabled!",
                Duration = 4,
                Image = "plane"
            })
        else
            stopFly()
            Rayfield:Notify({
                Title = "Enhanced Fly",
                Content = "Deactivated!",
                Duration = 2,
                Image = "plane"
            })
        end
    end,
})

SectionPlayer:CreateSlider({
    Name = "🚀 Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = " speed",
    CurrentValue = 50,
    Callback = function(value