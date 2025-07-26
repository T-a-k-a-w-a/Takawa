--================================================================--
--      SKRIP VERSI FINAL LENGKAP + GODMODE - OLEH PARTNER CODING  --
--================================================================--

-- Pemuatan Library yang Aman
local success, MacLib = pcall(function()
    return loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
end)

if not success or not MacLib then
    game:GetService("StarterGui"):SetCore("SendNotification", { 
        Title = "Script Error", 
        Text = "Gagal memuat MacLib. Periksa konsol (F9).", 
        Duration = 10 
    })
    warn("MacLib Gagal Dimuat! Error: " .. tostring(MacLib))
    return
end

-- Variabel Global - Services
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variabel Status Fitur
local instantMineEnabled = false
local antiFallDamageEnabled = false
local flyEnabled = false
local autoSellEnabled = false
local gameplayPausedBypassEnabled = false
local wallStickEnabled = false
local godmodeEnabled = false

-- Variabel Konfigurasi
local walkspeedValue = 16
local jumpPowerValue = 50
local flySpeed = 50

-- Variabel Float Platform
local floatPlatform = nil
local platformConnection = nil
local platformY = 0
local floatPlatformEnabled = false

-- Variabel Tool Stats
local originalToolStats = {}
local lastKnownTool = nil

-- Variabel Teleport/Bring
local bringWeld = nil
local attachWeld = nil

-- Variabel Gameplay Bypass
local ghostCharacter = nil
local lastGhostPosition = nil
local originalStreamingEnabled = workspace.StreamingEnabled

-- Variabel Fly
local flying = false
local isFlyingUp = false
local isFlyingDown = false
local bodyVelocity = nil
local bodyGyro = nil

-- Variabel Godmode
local healthConnection = nil
local originalHealth = 100
local godmodeIndicatorGui = nil

-- UI Sizing - Responsif untuk semua device
local screenSize = workspace.CurrentCamera.ViewportSize
local windowWidth = math.min(screenSize.X * 0.9, 868)
local windowHeight = math.min(screenSize.Y * 0.8, 650)

--================================================================--
--                        FUNGSI-FUNGSI GODMODE                    --
--================================================================--

local function createGodmodeIndicator()
    -- Hapus indicator lama jika ada
    if godmodeIndicatorGui then
        godmodeIndicatorGui:Destroy()
    end
    
    godmodeIndicatorGui = Instance.new("ScreenGui")
    godmodeIndicatorGui.Name = "GodmodeIndicator"
    godmodeIndicatorGui.Parent = CoreGui
    godmodeIndicatorGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = godmodeIndicatorGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🛡️ GODMODE AKTIF"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    -- Update visibility
    spawn(function()
        while godmodeIndicatorGui and godmodeIndicatorGui.Parent do
            frame.Visible = godmodeEnabled
            wait(0.1)
        end
    end)
end

local function enableGodmode()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Simpan health asli
    originalHealth = humanoid.MaxHealth
    
    -- Set health ke maksimum
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Monitor health secara terus menerus
    if healthConnection then
        healthConnection:Disconnect()
    end
    
    healthConnection = humanoid.HealthChanged:Connect(function(health)
        if godmodeEnabled and health < math.huge then
            humanoid.Health = math.huge
        end
    end)
    
    -- Proteksi tambahan
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if godmodeEnabled and humanoid.Health < math.huge then
            humanoid.Health = math.huge
        end
    end)
    
    print("🛡️ Godmode AKTIF - Tidak akan menerima damage apapun!")
end

local function disableGodmode()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Kembalikan health normal
    humanoid.MaxHealth = originalHealth
    humanoid.Health = originalHealth
    
    -- Disconnect health monitoring
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
    
    print("🚫 Godmode NONAKTIF - Health kembali normal")
end

--================================================================--
--                        FUNGSI-FUNGSI FLY                        --
--================================================================--

local function startFly()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or flying then 
        return 
    end
    
    local rootPart = char.HumanoidRootPart
    
    bodyGyro = Instance.new("BodyGyro", rootPart)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    
    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    flying = true
    print("✈️ Fly Mode AKTIF")
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
    flying = false
    print("🚫 Fly Mode NONAKTIF")
end

--================================================================--
--                        FUNGSI TOOL STATS                        --
--================================================================--

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

--================================================================--
--                    MAIN HEARTBEAT LOOP                          --
--================================================================--

RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Update Walkspeed dan JumpPower
    if humanoid.WalkSpeed ~= walkspeedValue then
        humanoid.WalkSpeed = walkspeedValue
    end
    if humanoid.JumpPower ~= jumpPowerValue then
        humanoid.JumpPower = jumpPowerValue
    end
    
    -- Fly Controls
    if flying and bodyVelocity and bodyGyro then
        local camera = workspace.CurrentCamera
        local velocity = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            velocity = velocity + (camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            velocity = velocity + (camera.CFrame.LookVector * -flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            velocity = velocity + (camera.CFrame.RightVector * -flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            velocity = velocity + (camera.CFrame.RightVector * flySpeed)
        end
        if isFlyingUp then
            velocity = velocity + Vector3.new(0, flySpeed, 0)
        end
        if isFlyingDown then
            velocity = velocity + Vector3.new(0, -flySpeed, 0)
        end
        
        bodyVelocity.Velocity = velocity
        bodyGyro.CFrame = camera.CFrame
    end
    
    -- Wall Stick
    if wallStickEnabled and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local ray = Ray.new(rootPart.Position, rootPart.CFrame.lookVector * 5)
            local hit, pos = workspace:FindPartOnRay(ray, char)
            humanoid.PlatformStand = hit and true or false
        end
    elseif not wallStickEnabled and humanoid.PlatformStand then
        humanoid.PlatformStand = false
    end
    
    -- Anti Fall Damage dan Godmode Protection
    if (antiFallDamageEnabled or godmodeEnabled) then
        -- Cegah fall damage
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        -- Godmode protection
        if godmodeEnabled then
            if humanoid.Health < math.huge then
                humanoid.Health = math.huge
            end
            if humanoid.MaxHealth < math.huge then
                humanoid.MaxHealth = math.huge
            end
        end
    end
    
    -- Instant Mine
    if instantMineEnabled then
        local tool = char:FindFirstChildOfClass("Tool")
        
        if tool and tool ~= lastKnownTool then
            restoreToolStats()
            lastKnownTool = tool
        end
        
        if tool then
            if not originalToolStats[tool] then
                originalToolStats[tool] = {
                    Speed = tool:FindFirstChild("Speed") and tool.Speed.Value
                }
            end
            
            pcall(function()
                local speed = tool:FindFirstChild("Speed")
                if speed then
                    speed.Value = 0
                end
            end)
        else
            restoreToolStats()
            lastKnownTool = nil
        end
    end
    
    -- Gameplay Paused Bypass
    if gameplayPausedBypassEnabled and Player.GameplayPaused then
        if not ghostCharacter then
            ghostCharacter = Player.Character:Clone()
            ghostCharacter.Parent = workspace
            
            for _, part in ipairs(ghostCharacter:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.7
                    part.CanCollide = false
                end
            end
            
            workspace.CurrentCamera.CameraSubject = ghostCharacter.Humanoid
            lastGhostPosition = ghostCharacter:GetPrimaryPartCFrame()
        end
        
        if ghostCharacter then
            lastGhostPosition = ghostCharacter:GetPrimaryPartCFrame()
        end
    elseif ghostCharacter and not Player.GameplayPaused then
        if lastGhostPosition then
            Player.Character:SetPrimaryPartCFrame(lastGhostPosition)
        end
        
        ghostCharacter:Destroy()
        ghostCharacter = nil
        workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
    end
end)

--================================================================--
--                        CHARACTER RESPAWN                        --
--================================================================--

Player.CharacterAdded:Connect(function(char)
    -- Re-enable godmode setelah respawn
    if godmodeEnabled then
        char:WaitForChild("Humanoid")
        wait(1) -- Delay untuk memastikan character fully loaded
        enableGodmode()
    end
end)

--================================================================--
--                         BUAT UI WINDOW                          --
--================================================================--

local Window = MacLib:Window({
    Title = "Abyss Miner Menu + Godmode",
    Subtitle = "oleh Partner Coding - Enhanced Version",
    Size = UDim2.fromOffset(windowWidth, windowHeight),
    DragStyle = 2,
    Keybind = Enum.KeyCode.RightShift
})

--================================================================--
--                         SETUP TABS                              --
--================================================================--

local TabGroup = Window:TabGroup()
local TabMain = TabGroup:Tab({ Name = "Main" })
local TabPlayer = TabGroup:Tab({ Name = "Player" })
local TabSell = TabGroup:Tab({ Name = "Sell" })
local TabRankUp = TabGroup:Tab({ Name = "Rank Up" })
local TabStorage = TabGroup:Tab({ Name = "Storage" })
local TabTeleport = TabGroup:Tab({ Name = "Teleportasi" })

-- Setup Sections
local SectionMain = TabMain:Section({ Side = "Left" })
local SectionPlayer = TabPlayer:Section({ Side = "Left" })
local SectionSell = TabSell:Section({ Side = "Left" })
local SectionRank = TabRankUp:Section({ Side = "Left" })
local SectionStorageBackpack = TabStorage:Section({ Side = "Left" })
local SectionStorageStorage = TabStorage:Section({ Side = "Right" })
local SectionTeleport = TabTeleport:Section({ Side = "Left" })

--================================================================--
--                         TAB MAIN                                --
--================================================================--

SectionMain:Toggle({ 
    Name = "Instant Mine (Speed Only)", 
    Default = false, 
    Callback = function(state) 
        instantMineEnabled = state
        if not state then
            restoreToolStats()
        end
    end 
})

SectionMain:Toggle({ 
    Name = "Bypass Gameplay Paused", 
    Default = false, 
    Callback = function(state)
        gameplayPausedBypassEnabled = state
        
        if state then
            pcall(function()
                local networkPauseScript = CoreGui:FindFirstChild("RobloxGui", true) and 
                                         CoreGui.RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
                if networkPauseScript then
                    networkPauseScript:Destroy()
                end
            end)
            workspace.StreamingEnabled = false
        else
            workspace.StreamingEnabled = originalStreamingEnabled
            if ghostCharacter then
                ghostCharacter:Destroy()
                ghostCharacter = nil
                workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
            end
        end
    end
})

SectionMain:Button({ 
    Name = "Buka/Tutup Konsol", 
    Callback = function() 
        pcall(function() 
            require(CoreGui.RobloxGui.Modules.DevConsoleMaster):Toggle() 
        end) 
    end
})

--================================================================--
--                         TAB PLAYER                              --
--================================================================--

SectionPlayer:Slider({ 
    Name = "Walkspeed", 
    Default = 16, 
    Minimum = 16, 
    Maximum = 100, 
    Precision = 0, 
    Callback = function(value) 
        walkspeedValue = value 
    end 
})

SectionPlayer:Slider({ 
    Name = "Jump Power", 
    Default = 50, 
    Minimum = 50, 
    Maximum = 100, 
    Precision = 0, 
    Callback = function(value) 
        jumpPowerValue = value 
    end 
})

SectionPlayer:Slider({ 
    Name = "Kecepatan Terbang", 
    Default = 50, 
    Minimum = 10, 
    Maximum = 200, 
    Precision = 0, 
    Callback = function(value) 
        flySpeed = value 
    end 
})

-- GODMODE TOGGLE - FITUR UTAMA
SectionPlayer:Toggle({ 
    Name = "🛡️ Godmode (No Death/Damage)", 
    Default = false, 
    Callback = function(state) 
        godmodeEnabled = state
        if state then
            enableGodmode()
        else
            disableGodmode()
        end
    end 
})

SectionPlayer:Toggle({ 
    Name = "Anti Fall Damage", 
    Default = false, 
    Callback = function(state) 
        antiFallDamageEnabled = state 
    end 
})

SectionPlayer:Toggle({
    Name = "Float Platform", 
    Default = false,
    Callback = function(state)
        floatPlatformEnabled = state
        local char = Player.Character
        
        if state and char and char:FindFirstChild("HumanoidRootPart") then
            if floatPlatform then
                floatPlatform:Destroy()
            end
            
            local rootPart = char.HumanoidRootPart
            platformY = rootPart.Position.Y - 4
            
            floatPlatform = Instance.new("Part", workspace)
            floatPlatform.Anchored = true
            floatPlatform.CanCollide = true
            floatPlatform.Size = Vector3.new(15, 1, 15)
            floatPlatform.Transparency = 1
            floatPlatform.Name = "MyFloatPlatform"
            
            platformConnection = RunService.Heartbeat:Connect(function()
                if floatPlatform and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local currentRoot = Player.Character.HumanoidRootPart
                    floatPlatform.Position = Vector3.new(currentRoot.Position.X, platformY, currentRoot.Position.Z)
                else
                    if platformConnection then
                        platformConnection:Disconnect()
                    end
                    if floatPlatform then
                        floatPlatform:Destroy()
                    end
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

SectionPlayer:Toggle({ 
    Name = "Tempel di Dinding", 
    Default = false, 
    Callback = function(state) 
        wallStickEnabled = state
        if not state and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.PlatformStand = false
        end
    end
})

SectionPlayer:Toggle({ 
    Name = "Toggle Fly", 
    Default = false, 
    Callback = function(state) 
        flyEnabled = state
        if state then
            startFly()
        else
            stopFly()
        end
    end 
})

-- Fly Control Buttons
local flyUpButton = SectionPlayer:Button({ Name = "Naik (Tahan)" })
flyUpButton.onChanged(function() 
    isFlyingUp = flyUpButton.State 
end)

local flyDownButton = SectionPlayer:Button({ Name = "Turun (Tahan)" })
flyDownButton.onChanged(function() 
    isFlyingDown = flyDownButton.State 
end)

--================================================================--
--                         TAB SELL                                --
--================================================================--

SectionSell:Toggle({ 
    Name = "Auto Sell (15 detik)", 
    Default = false, 
    Callback = function(state) 
        autoSellEnabled = state
        
        if autoSellEnabled then
            task.spawn(function()
                while autoSellEnabled do
                    pcall(function()
                        local npc = workspace:FindFirstChild("Map", true) and 
                                  workspace.Map:FindFirstChild("Layer 1", true) and 
                                  workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and 
                                  workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and 
                                  workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true)
                        
                        local char = Player.Character
                        if npc and char and char:FindFirstChild("HumanoidRootPart") then
                            local distance = (npc:GetPrimaryPartCFrame().Position - char.PrimaryPart.Position).Magnitude
                            if distance < 100 then
                                local tool = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
                                if tool then
                                    ReplicatedStorage:WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool)
                                end
                            end
                        end
                    end)
                    task.wait(15)
                end
            end)
        end
    end 
})

SectionSell:Button({ 
    Name = "Jual Item di Tangan", 
    Callback = function() 
        pcall(function()
            local npc = workspace:FindFirstChild("Map", true) and 
                      workspace.Map:FindFirstChild("Layer 1", true) and 
                      workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and 
                      workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and 
                      workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true)
            
            if npc then
                ReplicatedStorage:WaitForChild("RemoteEvent"):WaitForChild("SellSingleone"):FireServer(npc, npc.HumanoidRootPart:WaitForChild("Dialogue"))
            end
        end)
    end
})

SectionSell:Button({ 
    Name = "Jual Semua (Jarak Jauh)", 
    Callback = function() 
        local char = Player.Character
        if not (char and char:FindFirstChild("HumanoidRootPart")) then 
            return 
        end
        
        local rootPart = char.HumanoidRootPart
        local originalCFrame = rootPart.CFrame
        
        local npc = workspace:FindFirstChild("Map", true) and 
                  workspace.Map:FindFirstChild("Layer 1", true) and 
                  workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and 
                  workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and 
                  workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true)
        
        local tool = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
        
        if not (npc and tool) then 
            return 
        end
        
        pcall(function()
            rootPart.CFrame = npc:GetPrimaryPartCFrame() * CFrame.new(0, 0, 5)
            task.wait(0.1)
            ReplicatedStorage:WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool)
            task.wait(0.1)
            rootPart.CFrame = originalCFrame
        end)
    end
})

--================================================================--
--                         TAB RANK UP                             --
--================================================================--

local RankInfoParagraph = SectionRank:Paragraph({ 
    Header = "Informasi Rank", 
    Body = "Klik 'Tampilkan Info' untuk memuat data." 
})

SectionRank:Button({
    Name = "Tampilkan/Perbarui Info Rank",
    Callback = function()
        local karl = workspace:FindFirstChild("Map", true) and 
                   workspace.Map:FindFirstChild("Layer 1", true) and 
                   workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and 
                   workspace.Map["Layer 1"].Npcs:FindFirstChild("Karl")
        
        if not karl then 
            return 
        end
        
        ReplicatedStorage:WaitForChild("RemoteEvent"):WaitForChild("RankUpGui"):FireServer(karl, karl.HumanoidRootPart:WaitForChild("Dialogue"))
        task.wait(0.7)
        
        local rankMenu = Player.PlayerGui:FindFirstChild("MainGui", true) and Player.PlayerGui.MainGui:FindFirstChild("RankMenu")
        if rankMenu and rankMenu:FindFirstChild("BG") then
            local bg = rankMenu.BG
            local currentRank = bg:FindFirstChild("namerank") and bg.namerank.Text or "[?]"
            local nextRank = bg:FindFirstChild("namenextrank") and bg.namenextrank.Text or "[?]"
            local reqs = "Syarat: [Tidak Ditemukan]"
            
            for _, v in ipairs(bg:GetDescendant