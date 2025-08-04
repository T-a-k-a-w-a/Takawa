local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local WalkSpeedValue = 16
local JumpPowerValue = 50
local FlySpeed = 50
local SlowFallSpeed = 10
local InvisibleHeldCharacter = nil
local InvisibleAll = false

-- Store saved locations
local SavedLocations = {}

-- Cache for copied characters
local CopiedCharacters = {}

-- Utility Functions
local function setInvisible(character, invisible)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            if invisible then
                if not part:FindFirstChild("WindUI_Invisible") then
                    local inv = Instance.new("BoolValue")
                    inv.Name = "WindUI_Invisible"
                    inv.Parent = part
                    part.Transparency = 1
                    if part:IsA("Decal") then
                        part.Transparency = 1
                    end
                end
            else
                local inv = part:FindFirstChild("WindUI_Invisible")
                if inv then
                    part.Transparency = 0
                    inv:Destroy()
                end
            end
        elseif part:IsA("Accessory") then
            if part.Handle then
                if invisible then
                    part.Handle.Transparency = 1
                else
                    part.Handle.Transparency = 0
                end
            end
        end
    end
end

local function copyCharacterFromUsername(username)
    local targetPlayer = Players:FindFirstChild(username)
    if not targetPlayer or not targetPlayer.Character then
        WindUI:Notify({
            Title = "Error",
            Content = "Player not found or character not loaded.",
            Duration = 5,
            Icon = "alert-circle",
            Variant = "Primary"
        })
        return
    end

    local targetChar = targetPlayer.Character
    -- Clear old copied if exists
    if CopiedCharacters[username] and CopiedCharacters[username].Parent then
        CopiedCharacters[username]:Destroy()
    end

    local clone = Instance.new("Model")
    clone.Name = username .. "_Copy"
    clone.Parent = workspace

    -- Copy all parts and accessories with details
    for _, obj in ipairs(targetChar:GetChildren()) do
        if obj:IsA("BasePart") or obj:IsA("Accessory") or obj:IsA("MeshPart") or obj:IsA("CharacterMesh") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
            local c = obj:Clone()
            c.Parent = clone
        elseif obj:IsA("Humanoid") then
            local hum = obj:Clone()
            hum.Parent = clone
        elseif obj:IsA("AnimationController") then
            local animCtrl = obj:Clone()
            animCtrl.Parent = clone
        elseif obj:IsA("Tool") then
            local tool = obj:Clone()
            tool.Parent = clone
        end
    end

    -- Copy Shirt, Pants, BodyColors, etc.
    local shirts = targetChar:GetChildren()
    for _, obj in ipairs(shirts) do
        if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("BodyColors") then
            local c = obj:Clone()
            c.Parent = clone
        end
    end

    -- Position clone at our character's position but invisible and non-collidable
    clone.PrimaryPart = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChildWhichIsA("BasePart")
    if clone.PrimaryPart then
        clone:SetPrimaryPartCFrame(Character.HumanoidRootPart.CFrame)
    end

    -- Make clone non-collidable and invisible if needed
    for _, part in ipairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    CopiedCharacters[username] = clone

    WindUI:Notify({
        Title = "Copied",
        Content = "Copied character of " .. username,
        Duration = 5,
        Icon = "check",
        Variant = "Primary"
    })

    return clone
end

-- Player Loop Walkspeed & Jumppower
local function updateHumanoidSpeedJump()
    if Humanoid then
        Humanoid.WalkSpeed = WalkSpeedValue
        Humanoid.JumpPower = JumpPowerValue
    end
end

-- Slow when falling
RunService.Heartbeat:Connect(function()
    if Humanoid and Humanoid.FloorMaterial == Enum.Material.Air then
        local velY = RootPart.Velocity.Y
        if velY < -1 then
            Humanoid.WalkSpeed = math.max(WalkSpeedValue * 0.4, SlowFallSpeed)
        else
            Humanoid.WalkSpeed = WalkSpeedValue
        end
    else
        Humanoid.WalkSpeed = WalkSpeedValue
    end
end)

-- Player Antidamage (simple)
-- Hook Humanoid.HealthChanged to prevent damage
if Humanoid then
    Humanoid.HealthChanged:Connect(function()
        if Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
end

-- Invisible All characters except held one
local function updateInvisibleAll()
    if InvisibleAll then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr ~= LocalPlayer then
                setInvisible(plr.Character, true)
            end
        end
        if InvisibleHeldCharacter and InvisibleHeldCharacter.Parent then
            setInvisible(InvisibleHeldCharacter, true)
        end
        setInvisible(Character, true)
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr ~= LocalPlayer then
                setInvisible(plr.Character, false)
            end
        end
        if InvisibleHeldCharacter and InvisibleHeldCharacter.Parent then
            setInvisible(InvisibleHeldCharacter, false)
        end
        setInvisible(Character, false)
    end
end

-- Tween Fly for Mobile Devices
local Flying = false
local FlyDirection = Vector3.new(0,0,0)
local FlyVelocity = 0

local function startFly()
    if Flying then return end
    Flying = true
    FlyVelocity = FlySpeed
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "WindUI_FlyVelocity"
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = RootPart

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not Flying or not RootPart or not bodyVelocity then
            if connection then connection:Disconnect() end
            if bodyVelocity then bodyVelocity:Destroy() end
            return
        end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0,1,0)
        end
        moveDir = moveDir.Unit * FlyVelocity
        if moveDir ~= moveDir then -- NaN check
            moveDir = Vector3.new(0,0,0)
        end
        bodyVelocity.Velocity = moveDir
    end)
end

local function stopFly()
    Flying = false
    local bv = RootPart:FindFirstChild("WindUI_FlyVelocity")
    if bv then bv:Destroy() end
end

-- Tween teleport function
local function tweenTeleport(targetCFrame)
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
end

-- Tween teleport to position from dropdown
local function teleportToPosition(pos)
    if typeof(pos) == "Vector3" then
        tweenTeleport(CFrame.new(pos))
    elseif typeof(pos) == "CFrame" then
        tweenTeleport(pos)
    end
end

-- Tween teleport to username from dropdown
local function teleportToPlayer(username)
    local target = Players:FindFirstChild(username)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        tweenTeleport(target.Character.HumanoidRootPart.CFrame)
    else
        WindUI:Notify({
            Title = "Error",
            Content = "Player not found or not loaded.",
            Duration = 5,
            Icon = "alert-circle",
            Variant = "Primary"
        })
    end
end

-- Save current location in list
local function saveCurrentLocation(name)
    if name and name ~= "" then
        SavedLocations[name] = RootPart.Position
        WindUI:Notify({
            Title = "Saved",
            Content = "Location '"..name.."' saved.",
            Duration = 4,
            Icon = "check",
            Variant = "Primary"
        })
    end
end

-- On top of platform invisible, walk anywhere (no clip)
local NoClipEnabled = false

local function toggleNoClip(enabled)
    NoClipEnabled = enabled
    if NoClipEnabled then
        RunService.Stepped:Connect(function()
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end)
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Create UI with WindUI
local Window = WindUI:CreateWindow({
    Title = "All Game Script UI",
    Icon = "bird",
    IconThemed = true,
    Author = "Roblox Script Generator AI",
    Folder = "AllGameScriptUI",
    Size = UDim2.fromOffset(600, 500),
    Transparent = true,
    Theme = "Dark",
})

local Tabs = {}

Tabs.Main = Window:Section({
    Title = "Main Controls",
    Opened = true,
})

Tabs.Copy = Window:Section({
    Title = "Copy Character",
    Opened = true,
})

Tabs.Teleport = Window:Section({
    Title = "Teleport",
    Opened = true,
})

Tabs.Settings = Window:Section({
    Title = "Settings",
    Opened = true,
})

-- Walkspeed slider
local walkSpeedSlider = Tabs.Main:Slider({
    Title = "WalkSpeed",
    Value = {
        Min = 8,
        Max = 150,
        Default = WalkSpeedValue,
    },
    Callback = function(value)
        WalkSpeedValue = value
        updateHumanoidSpeedJump()
    end,
})

-- JumpPower slider
local jumpPowerSlider = Tabs.Main:Slider({
    Title = "JumpPower",
    Value = {
        Min = 20,
        Max = 200,
        Default = JumpPowerValue,
    },
    Callback = function(value)
        JumpPowerValue = value
        updateHumanoidSpeedJump()
    end,
})

-- Anti-damage toggle
local antiDamageToggle = Tabs.Main:Toggle({
    Title = "Anti Damage",
    Value = true,
    Callback = function(state)
        if state then
            if Humanoid then
                Humanoid.HealthChanged:Connect(function()
                    if Humanoid.Health < Humanoid.MaxHealth then
                        Humanoid.Health = Humanoid.MaxHealth
                    end
                end)
            end
        end
    end,
})

-- Invisible all toggle
local invisibleAllToggle = Tabs.Settings:Toggle({
    Title = "Invisible All Characters",
    Value = false,
    Callback = function(state)
        InvisibleAll = state
        updateInvisibleAll()
    end,
})

-- Copy character by username input + button
local usernameInput = ""
local copyDropdown = Tabs.Copy:Input({
    Title = "Username to Copy",
    Placeholder = "Enter username",
    Callback = function(input)
        usernameInput = input
    end,
})

Tabs.Copy:Button({
    Title = "Copy Character",
    Callback = function()
        if usernameInput ~= "" then
            copyCharacterFromUsername(usernameInput)
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a username.",
                Duration = 3,
                Icon = "alert-circle",
                Variant = "Primary"
            })
        end
    end,
})

-- Dropdown of players for teleport
local function getPlayerUsernames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(list, p.Name)
    end
    return list
end

local teleportPlayerDropdown = Tabs.Teleport:Dropdown({
    Title = "Teleport to Player",
    Values = getPlayerUsernames(),
    Callback = function(name)
        teleportToPlayer(name)
    end,
})

Players.PlayerAdded:Connect(function(plr)
    teleportPlayerDropdown:Refresh(getPlayerUsernames())
end)
Players.PlayerRemoving:Connect(function(plr)
    teleportPlayerDropdown:Refresh(getPlayerUsernames())
end)

-- Saved Locations dropdown + teleport button + save current location input
local savedLocationName = ""
local savedLocationDropdown = Tabs.Teleport:Dropdown({
    Title = "Saved Locations",
    Values = {},
    Callback = function(name)
        if SavedLocations[name] then
            teleportToPosition(SavedLocations[name])
        end
    end,
})

Tabs.Teleport:Input({
    Title = "Save Current Location As",
    Placeholder = "Enter name",
    Callback = function(name)
        savedLocationName = name
    end,
})

Tabs.Teleport:Button({
    Title = "Save Current Location",
    Callback = function()
        if savedLocationName ~= "" then
            saveCurrentLocation(savedLocationName)
            savedLocationDropdown:Refresh(table.getKeys(SavedLocations))
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a name to save location.",
                Duration = 3,
                Icon = "alert-circle",
                Variant = "Primary"
            })
        end
    end,
})

-- Fly toggle for mobile
local flyToggle = Tabs.Settings:Toggle({
    Title = "Toggle Fly (Mobile)",
    Value = false,
    Callback = function(state)
        if state then
            startFly()
        else
            stopFly()
        end
    end,
})

-- NoClip toggle
local noclipToggle = Tabs.Settings:Toggle({
    Title = "Toggle NoClip",
    Value = false,
    Callback = function(state)
        toggleNoClip(state)
    end,
})

-- Update Humanoid speed and jump on start
updateHumanoidSpeedJump()

-- Initial invisible update
updateInvisibleAll()

return Window
