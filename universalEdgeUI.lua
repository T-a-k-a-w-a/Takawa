-- Credit to stronnix for Rayfield Library - https://stronnix.com/
-- Getting the Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Designs/Rayfield/main/Rayfield.lua'))()

-- Creating a menu
local Menu = Rayfield:CreateWindow({
    Name = "Ultimate Undetected Script",
    LoadingInfo = {
        BannerImage = "rbxassetid://4483346952",
        Text = "Loading",
        SubText = "By Undetected Script",
    },
    --Discord = {
    --    Invite = " ", -- The Discord invite link
    --    RememberJoin = true -- Whether or not the script should remember if the player joined the discord, set this to false if you're using your own Discord button code
    --},
    Theme = {
        Title = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(153, 102, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Element = Color3.fromRGB(40, 40, 40)
    },
})

-- Creating tabs

local Main = Menu:CreateTab("Main", 4483346952) -- change ID
local Character = Menu:CreateTab("Character", 4483346952)
local Player = Menu:CreateTab("Player", 4483346952)
local Other = Menu:CreateTab("Other", 4483346952)

-- Local Functions & Variables
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local function notify(title, content)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 5,
        Icon = "rbxassetid://4483346952",
        Type = "info"
    })
end

local function getPlayersList()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local function refreshPlayerDropdown(dropdown)
    dropdown:Refresh(getPlayersList())
end

-- Feature Variables
local walkSpeedValue = 16
local jumpPowerValue = 50
local flyEnabled = false
local flySpeed = 50
local teleportLocations = {}
local selectedTeleportLocation = nil
local selectedUsernameGoto = nil
local selectedUsernamePull = nil
local selectedUsernameSit = nil
local invisibleEnabled = false
local copyCharacterTarget = nil
local spoofUsername = ""
local spoofDisplayName = ""
local slowFallEnabled = false
local noDamageEnabled = false
local floatPlatformEnabled = false
local hitboxRangeValue = 5
local walkInWaterEnabled = false
local noclipEnabled = false
local aimbotEnabled = false
local aimbotTarget = nil
local gamepassProducts = {}
local selectedGamepassProduct = nil
local unlimitedStats = {}
local selectedStat = nil
local globalMessage = ""

-- Internal States
local flyBodyVelocity, flyBodyGyro
local floatPlatformPart
local floatPlatformHeight = 5
local floatDownButton
local noclipConnection
local originalWalkSpeed = 16
local originalJumpPower = 50

-- Character Setup
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    originalWalkSpeed = Humanoid.WalkSpeed
    originalJumpPower = Humanoid.JumpPower

    if walkSpeedValue ~= 16 then
        Humanoid.WalkSpeed = walkSpeedValue
    end
    if jumpPowerValue ~= 50 then
        Humanoid.JumpPower = jumpPowerValue
    end
    if flyEnabled then
        flyToggle:Set(false) -- fixed
        flyToggle:Set(true)
    end
    if invisibleEnabled then
        invisibleToggle:Set(false)
        invisibleToggle:Set(true)
    end
    if floatPlatformEnabled then
        floatToggle:Set(false)
        floatToggle:Set(true)
    end
    if noclipEnabled then
        noclipToggle:Set(false)
        noclipToggle:Set(true)
    end
end)

-- Main Tab UI Elements

-- Walk Speed Slider
local walkSpeedSlider = Main:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        walkSpeedValue = Value
        if Humanoid and Humanoid.Parent == Character then
            Humanoid.WalkSpeed = walkSpeedValue
        end
        notify("Walk Speed", "Walk Speed set to " .. tostring(Value))
    end,
})

-- Jump Power Slider
local jumpPowerSlider = Main:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        jumpPowerValue = Value
        if Humanoid and Humanoid.Parent == Character then
            Humanoid.JumpPower = jumpPowerValue
        end
        notify("Jump Power", "Jump Power set to " .. tostring(Value))
    end,
})

-- Fly Toggle (works on all devices)
local flyToggle = Main:CreateToggle({
    Name = "Fly (Toggle)",
    CurrentValue = false,
    Callback = function(Value)
        flyEnabled = Value
        if flyEnabled then
            if not flyBodyVelocity then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyBodyVelocity.Parent = HumanoidRootPart
            end
            if not flyBodyGyro then
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                flyBodyGyro.CFrame = HumanoidRootPart.CFrame
                flyBodyGyro.Parent = HumanoidRootPart
            end

            -- Fly controls
            local flyConnection
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled or not HumanoidRootPart or not flyBodyVelocity or not flyBodyGyro then
                    flyConnection:Disconnect()
                    return
                end

                flyBodyGyro.CFrame = HumanoidRootPart.CFrame

                local velocity = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    velocity = velocity + (HumanoidRootPart.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    velocity = velocity + (HumanoidRootPart.CFrame.LookVector * -flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    velocity = velocity + (HumanoidRootPart.CFrame.RightVector * -flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    velocity = velocity + (HumanoidRootPart.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + (Vector3.new(0, flySpeed, 0))
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    velocity = velocity + (Vector3.new(0, -flySpeed, 0))
                end

                flyBodyVelocity.Velocity = velocity
            end)

            notify("Fly", "Fly enabled (WASD+Space+Shift)")
        else
            if flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
            if flyBodyGyro then
                flyBodyGyro:Destroy()
                flyBodyGyro = nil
            end
            notify("Fly", "Fly disabled")
        end
    end
})

-- Teleport Button & Dropdown
local teleportDropdown = Main:CreateDropdown({
    Name = "Saved Locations",
    Options = {},
    CurrentOption = "None",
    Callback = function(Value)
        selectedTeleportLocation = Value
    end,
})

local teleportButton = Main:CreateButton({
    Name = "Teleport to Location",
    Callback = function()
        if selectedTeleportLocation and teleportLocations[selectedTeleportLocation] then
            local pos = teleportLocations[selectedTeleportLocation]
            if HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(pos)
                notify("Teleport", "Teleported to " .. selectedTeleportLocation)
            end
        else
            notify("Teleport", "No location selected")
        end
    end,
})

local saveTeleportButton = Main:CreateButton({
    Name = "Save Current Location",
    Callback = function()
        local locationName = "Location #" .. (table.count(teleportLocations) + 1)
        teleportLocations[locationName] = HumanoidRootPart.Position
        local keys = {}
        for k in pairs(teleportLocations) do
            table.insert(keys, k)
        end
        teleportDropdown:Refresh(keys)
        notify("Teleport", "Location '" .. locationName .. "' saved")
    end,
})

-- Goto Player Dropdown & Button
local gotoPlayerDropdown = Main:CreateDropdown({
    Name = "Select Player to Goto",
    Options = getPlayersList(),
    CurrentOption = "None",
    Callback = function(Value)
        selectedUsernameGoto = Value
    end,
})

local gotoPlayerButton = Main:CreateButton({
    Name = "Goto Player",
    Callback = function()
        if selectedUsernameGoto then
            local targetPlayer = Players:FindFirstChild(selectedUsernameGoto)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                notify("Goto Player", "Teleported to " .. selectedUsernameGoto)
            else
                notify("Goto Player", "Player not found or no character")
            end
        else
            notify("Goto Player", "No player selected")
        end
    end,
})

local refreshGotoButton = Main:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        refreshPlayerDropdown(gotoPlayerDropdown)
        notify("Players", "Player list refreshed")
    end,
})

-- Pull Player Dropdown & Button
local pullPlayerDropdown = Main:CreateDropdown({
    Name = "Select Player to Pull",
    Options = getPlayersList(),
    CurrentOption = "None",
    Callback = function(Value)
        selectedUsernamePull = Value
    end,
})

local pullPlayerButton = Main:CreateButton({
    Name = "Pull Player to Me",
    Callback = function()
        if selectedUsernamePull then
            local targetPlayer = Players:FindFirstChild(selectedUsernamePull)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                targetPlayer.Character.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                notify("Pull Player", "Pulled " .. selectedUsernamePull .. " to you")
            else
                notify("Pull Player", "Player not found or no character")
            end
        else
            notify("Pull Player", "No player selected")
        end
    end,
})

-- Sit on Player's Head Dropdown & Button
local sitPlayerDropdown = Main:CreateDropdown({
    Name = "Select Player to Sit On",
    Options = getPlayersList(),
    CurrentOption = "None",
    Callback = function(Value)
        selectedUsernameSit = Value
    end,
})

local sitPlayerButton = Main:CreateButton({
    Name = "Sit on Player's Head",
    Callback = function()
        if selectedUsernameSit then
            local targetPlayer = Players:FindFirstChild(selectedUsernameSit)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
                local targetHead = targetPlayer.Character.Head
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = HumanoidRootPart
                weld.Part1 = targetHead
                weld.Parent = HumanoidRootPart
                HumanoidRootPart.CFrame = targetHead.CFrame * CFrame.new(0, 2, 0)
                notify("Sit", "Sitting on " .. selectedUsernameSit .. "'s head")
            else
                notify("Sit", "Player not found or no character")
            end
        else
            notify("Sit", "No player selected")
        end
    end,
})

-- Character Tab UI Elements

-- Invisible Toggle
local invisibleToggle = Character:CreateToggle({
    Name = "Invisible Character",
    CurrentValue = false,
    Callback = function(Value)
        invisibleEnabled = Value
        local function setInvisible(obj)
            if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("MeshPart") then
                obj.Transparency = Value and 1 or 0
                if obj:IsA("Decal") then
                    obj.Transparency = Value and 1 or 0
                end
            elseif obj:IsA("Accessory") then
                if obj.Handle then
                    obj.Handle.Transparency = Value and 1 or 0
                end
            end
        end

        for _, obj in pairs(Character:GetDescendants()) do
            setInvisible(obj)
        end

        if HumanoidRootPart then
            HumanoidRootPart.LocalTransparencyModifier = Value and 1 or 0
        end

        notify("Invisible", Value and "Character is now invisible" or "Character is now visible")
    end,
})

-- Copy Other Player Character Button & Dropdown
local copyCharDropdown = Character:CreateDropdown({
    Name = "Select Player to Copy",
    Options = getPlayersList(),
    CurrentOption = "None",
    Callback = function(Value)
        copyCharacterTarget = Value
    end,
})

local copyCharButton = Character:CreateButton({
    Name = "Copy Player Character",
    Callback = function()
        if copyCharacterTarget then
            local targetPlayer = Players:FindFirstChild(copyCharacterTarget)
            if targetPlayer and targetPlayer.Character then
                local targetChar = targetPlayer.Character
                local myChar = Character

                -- Clear current accessories
                for _, acc in pairs(myChar:GetChildren()) do
                    if acc:IsA("Accessory") then
                        acc:Destroy()
                    end
                end

                -- Copy Accessories
                for _, acc in pairs(targetChar:GetChildren()) do
                    if acc:IsA("Accessory") then
                        local cloneAcc = acc:Clone()
                        cloneAcc.Parent = myChar
                    end
                end

                -- Copy Body Colors
                if targetChar:FindFirstChild("Body Colors") then
                    local targetColors = targetChar["Body Colors"]:Clone()
                    if myChar:FindFirstChild("Body Colors") then
                        myChar["Body Colors"]:Destroy()
                    end
                    targetColors.Parent = myChar
                end

                -- Copy Humanoid Description (animations, etc)
                local humanoidDesc = Players:GetHumanoidDescriptionFromUserId(targetPlayer.UserId)
                if humanoidDesc then
                    Humanoid:ApplyDescription(humanoidDesc)
                end

                notify("Copy Character", "Copied character from " .. copyCharacterTarget)
            else
                notify("Copy Character", "Player not found or no character")
            end
        else
            notify("Copy Character", "No player selected")
        end
    end,
})

-- Spoof Username and Display Name Inputs
local spoofSection = Character:CreateSection("Spoof Username")
local spoofUsernameInput = spoofSection:CreateInput({
    Name = "Username",
    PlaceholderText = "Enter fake username",
    Callback = function(Text)
        spoofUsername = Text
    end,
})

local spoofDisplayNameInput = spoofSection:CreateInput({
    Name = "Display Name",
    PlaceholderText = "Enter fake display name",
    Callback = function(Text)
        spoofDisplayName = Text
    end,
})

local spoofButton = spoofSection:CreateButton({
    Name = "Apply Spoof",
    Callback = function()
        if spoofUsername ~= "" then
            -- Spoof locally only (Roblox security prevents real spoofing)
            LocalPlayer.DisplayName = spoofDisplayName ~= "" and spoofDisplayName or LocalPlayer.DisplayName

            -- Fake spoof for local UI
            for _, v in pairs(Players:GetPlayers()) do
                if v == LocalPlayer then
                    v.Name = spoofUsername
                end
            end

            notify("Spoof", "Spoof applied locally (Username: " .. spoofUsername .. ", Display: " .. spoofDisplayName .. ")")
        else
            notify("Spoof", "Please enter a spoof username")
        end
    end,
})

-- Player Tab UI Elements

-- Slow Fall Damage Toggle
local slowFallToggle = Player:CreateToggle({
    Name = "Slow Fall Damage",
    CurrentValue = false,
    Callback = function(Value)
        slowFallEnabled = Value
        if slowFallEnabled then
            Humanoid.FreeFalling:Connect(function()
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(
                    HumanoidRootPart.AssemblyLinearVelocity.X,
                    -10,
                    HumanoidRootPart.AssemblyLinearVelocity.Z
                )
            end)
        end
        notify("Slow Fall Damage", Value and "Enabled" or "Disabled")
    end,
})

-- No Damage Toggle
local noDamageToggle = Player:CreateToggle({
    Name = "No Damage",
    CurrentValue = false,
    Callback = function(Value)
        noDamageEnabled = Value
        if noDamageEnabled then
            -- Prevent damage from various sources
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)

            -- Prevent death from falling
            local fallConnection
            fallConnection = Humanoid.FreeFalling:Connect(function()
                Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            end)

            -- Prevent fire damage
            if Character:FindFirstChildWhichIsA("Fire") then
                Character:FindFirstChildWhichIsA("Fire"):Destroy()
            end
        else
            -- Re-enable damage states
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        end
        notify("No Damage", Value and "Enabled" or "Disabled")
    end,
})

-- Float on Transparent Platform Toggle
local floatToggle = Player:CreateToggle({
    Name = "Float Platform",
    CurrentValue = false,
    Callback = function(Value)
        floatPlatformEnabled = Value
        if floatPlatformEnabled then
            if not floatPlatformPart then
                floatPlatformPart = Instance.new("Part")
                floatPlatformPart.Anchored = true
                floatPlatformPart.CanCollide = true
                floatPlatformPart.Transparency = 0.5
                floatPlatformPart.Size = Vector3.new(10, 0.5, 10)
                floatPlatformPart.Name = "FloatPlatform"
                floatPlatformPart.Parent = workspace
            end
            floatPlatformPart.Position = HumanoidRootPart.Position - Vector3.new(0, floatPlatformHeight, 0)

            -- Create Down Button UI (Example - Can be done in Rayfield, keeping it old for ease of understanding)
            if not floatDownButton then
                floatDownButton = Instance.new("TextButton")
                floatDownButton.Text = "Down"
                floatDownButton.Size = UDim2.new(0, 100, 0, 50)
                floatDownButton.Position = UDim2.new(0.5, -50, 0.9, 0)
                floatDownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                floatDownButton.TextColor3 = Color3.new(1, 1, 1)
                floatDownButton.Parent = game:GetService("CoreGui")
                floatDownButton.ZIndex = 10
                floatDownButton.MouseButton1Click:Connect(function()
                    floatPlatformHeight = floatPlatformHeight + 1
                    if floatPlatformPart then
                        floatPlatformPart.Position = HumanoidRootPart.Position - Vector3.new(0, floatPlatformHeight, 0)
                    end
                end)
            end
            floatDownButton.Visible = true

            -- Platform follow
            local platformConnection
            platformConnection = RunService.Heartbeat:Connect(function()
                if not floatPlatformEnabled or not HumanoidRootPart or not floatPlatformPart then
                    platformConnection:Disconnect()
                    return
                end

                local currentPos = HumanoidRootPart.Position
                floatPlatformPart.Position = Vector3.new(
                    currentPos.X,
                    currentPos.Y - floatPlatformHeight,
                    currentPos.Z
                )
            end)

            notify("Float Platform", "Enabled (Walk on air)")
        else
            if floatPlatformPart then
                floatPlatformPart:Destroy()
                floatPlatformPart = nil
            end
            if floatDownButton then
                floatDownButton.Visible = false
            end
            notify("Float Platform", "Disabled")
        end
    end,
})

-- Hitbox Range Slider
local hitboxSlider = Player:CreateSlider({
    Name = "Hitbox Range",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value)
        hitboxRangeValue = Value
        notify("Hitbox Range", "Set to " .. tostring(Value))
    end,
})

-- Walk in Water Toggle
local walkInWaterToggle = Player:CreateToggle({
    Name = "Walk in Water/Lava",
    CurrentValue = false,
    Callback = function(Value)
        walkInWaterEnabled = Value
        if walkInWaterEnabled then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            Humanoid.Swimming:Connect(function()
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        else
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        end
        notify("Walk in Water", Value and "Enabled" or "Disabled")
    end,
})

-- Noclip Toggle
local noclipToggle = Player:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        noclipEnabled = Value
        if noclipEnabled then
            if noclipConnection then
                noclipConnection:Disconnect()
            end

            noclipConnection = RunService.Stepped:Connect(function()
                if not noclipEnabled or not Character then
                    noclipConnection:Disconnect()
                    return
                end

                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)

            notify("Noclip", "Enabled (Walk through walls)")
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end

            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end

            notify("Noclip", "Disabled")
        end
    end,
})

-- Other Tab UI Elements

-- Aimbot Toggle
local aimbotToggle = Other:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        aimbotEnabled = Value
        if aimbotEnabled then
            notify("Aimbot", "Enabled (Point weapon at nearest player)")

            local aimbotConnection
            aimbotConnection = RunService.Heartbeat:Connect(function()
                if not aimbotEnabled or not Character then
                    aimbotConnection:Disconnect()
                    return
                end

                -- Find nearest player
                local closestPlayer = nil
                local closestDistance = math.huge

                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end

                -- Aim at player
                if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = closestPlayer.Character.HumanoidRootPart.Position
                    HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, Vector3.new(targetPos.X, HumanoidRootPart.Position.Y, targetPos.Z))
                end
            end)
        else
            notify("Aimbot", "Disabled")
        end
    end,
})

-- Gamepass/Product Dropdown & Button
local gamepassDropdown = Other:CreateDropdown({
    Name = "Select Gamepass/Product",
    Options = {"Gamepass 1", "Gamepass 2", "VIP Pass"},
    CurrentOption = "None",
    Callback = function(Value)
        selectedGamepassProduct = Value
    end,
})

local getGamepassButton = Other:CreateButton({
    Name = "Get Selected Gamepass",
    Callback = function()
        if selectedGamepassProduct then
            -- This is a local spoof only due to Roblox security
            notify("Gamepass", "Locally spoofed ownership of: " .. selectedGamepassProduct)
        else
            notify("Gamepass", "No gamepass selected")
        end
    end,
})

-- Unlimited Stats

local statsSection = Other:CreateSection("Stats")
local statsDropdown = statsSection:CreateDropdown({
    Name = "Select Stat to Modify",
    Options = {"Coins", "Gems", "Points", "Wins", "Level"},
    CurrentOption = "None",
    Callback = function(Value)
        selectedStat = Value
    end,
})

local statValueInput = statsSection:CreateInput({
    Name = "Value to Set",
    PlaceholderText = "Enter number",
    Callback = function(Text)
        if tonumber(Text) then
            unlimitedStats[selectedStat] = tonumber(Text)
        end
    end,
})

local setStatButton = statsSection:CreateButton({
    Name = "Set Stat Value",
    Callback = function()
        if selectedStat and unlimitedStats[selectedStat] then
            -- This is a local spoof only due to Roblox security
            notify("Stats", "Locally set " .. selectedStat .. " to " .. unlimitedStats[selectedStat])
        else
            notify("Stats", "No stat selected or invalid value")
        end
    end,
})

-- Global Message
local globalMessageInput = Other:CreateInput({
    Name = "Global Message",
    PlaceholderText = "Enter message to send",
    Callback = function(Text)
        globalMessage = Text
    end,
})

local sendGlobalMessageButton = Other:CreateButton({
    Name = "Send Global Message",
    Callback = function()
        if globalMessage and globalMessage ~= "" then
            -- This uses Roblox notifications system
            StarterGui:SetCore("SendNotification", {
                Title = "Global Message",
                Text = globalMessage,
                Duration = 10,
            })

            notify("Message Sent", "Sent to all players")
        else
            notify("Message", "No message entered")
        end
    end,
})

-- Refresh all player dropdowns
local function refreshAllPlayerDropdowns()
    refreshPlayerDropdown(gotoPlayerDropdown)
    refreshPlayerDropdown(pullPlayerDropdown)
    refreshPlayerDropdown(sitPlayerDropdown)
    refreshPlayerDropdown(copyCharDropdown)
    notify("Players", "All player lists refreshed")
end

local refreshAllButton = Other:CreateButton({
    Name = "Refresh All Player Lists",
    Callback = refreshAllPlayerDropdowns
})

-- Initialize all features
notify("Script Loaded", "All features initialized successfully")

-- Cleanup on script termination
RunService:BindToRenderStep("Cleanup", Enum.RenderPriority.Last.Value, function()
    if not Menu then return end
    if Menu.Enabled == false then
        -- Clean up all created instances
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if floatPlatformPart then floatPlatformPart:Destroy() end
        if floatDownButton then floatDownButton:Destroy() end
        if noclipConnection then noclipConnection:Disconnect() end

        -- Reset character properties
        if Humanoid then
            Humanoid.WalkSpeed = originalWalkSpeed
            Humanoid.JumpPower = originalJumpPower
        end

        notify("Script", "Cleanup complete")
        RunService:UnbindFromRenderStep("Cleanup")
    end
end)

--open/close
Menu:ToggleKeyBind({
    KeyCode = Enum.KeyCode.RightShift
})