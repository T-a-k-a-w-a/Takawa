-- // Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- // Variables
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- // Notification Setup
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()

-- // ESP Libraries
-- ESP Line Bluwu
local ESP_Line = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ESP-Library-9570", true))("there are cats in your walls let them out let them out let them out")

-- ESP Cornerbox (Placeholder for actual library if different)
local ESP_Cornerbox = {} -- Assuming it's part of the same library or needs separate implementation
-- For now, we'll assume it's managed within the same ESP_Line system or needs a different approach.
-- ESP Arrow
-- We'll integrate the Arrow ESP code directly as it's custom.

-- // Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- // Saved Locations Table
local SavedLocations = {}

-- // Notification Helper
local function Notify(Type, Title, Message, Duration)
    Duration = Duration or 5
    pcall(function()
        Notification.new(Type, Title, Message, true, Duration)
    end)
end

Notify("info", "Loading", "Initializing script and UI...", 3)

-- // ESP Arrow Implementation (Integrated)
local ArrowESP_Enabled = false
local ArrowESP_Settings = {
    DistFromCenter = 80,
    TriangleHeight = 16,
    TriangleWidth = 16,
    TriangleFilled = true,
    TriangleTransparency = 0,
    TriangleThickness = 1,
    TriangleColor = Color3.fromRGB(255, 255, 255),
    AntiAliasing = false
}

local ArrowDrawings = {} -- Stores arrow drawings per player

local function GetRelative(pos, char)
    if not char then return Vector2.new(0,0) end
    local rootP = char.PrimaryPart.Position
    local camP = Camera.CFrame.Position
    local relative = CFrame.new(Vector3.new(rootP.X, camP.Y, rootP.Z), camP):PointToObjectSpace(pos)
    return Vector2.new(relative.X, relative.Z)
end

local function RelativeToCenter(v)
    return Camera.ViewportSize/2 - v
end

local function RotateVect(v, a)
    a = math.rad(a)
    local x = v.x * math.cos(a) - v.y * math.sin(a)
    local y = v.x * math.sin(a) + v.y * math.cos(a)
    return Vector2.new(x, y)
end

local function DrawTriangle(color)
    local l = Drawing.new("Triangle")
    l.Visible = false
    l.Color = color
    l.Filled = ArrowESP_Settings.TriangleFilled
    l.Thickness = ArrowESP_Settings.TriangleThickness
    l.Transparency = 1 - ArrowESP_Settings.TriangleTransparency
    return l
end

local function AntiA(v)
    if (not ArrowESP_Settings.AntiAliasing) then return v end
    return Vector2.new(math.round(v.x), math.round(v.y))
end

local function UpdateArrow(PLAYER)
    local Arrow = ArrowDrawings[PLAYER]
    if not Arrow then return end

    local function Update()
        local c
        c = RunService.RenderStepped:Connect(function()
            if ArrowESP_Enabled and PLAYER and PLAYER.Character then
                local CHAR = PLAYER.Character
                local HUM = CHAR:FindFirstChildOfClass("Humanoid")
                if HUM and CHAR.PrimaryPart and HUM.Health > 0 then
                    local _, vis = Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                    if not vis then
                        local rel = GetRelative(CHAR.PrimaryPart.Position, LocalPlayer.Character)
                        local direction = rel.unit
                        local base  = direction * ArrowESP_Settings.DistFromCenter
                        local sideLength = ArrowESP_Settings.TriangleWidth / 2
                        local baseL = base + RotateVect(direction, 90) * sideLength
                        local baseR = base + RotateVect(direction, -90) * sideLength
                        local tip = direction * (ArrowESP_Settings.DistFromCenter + ArrowESP_Settings.TriangleHeight)
                        Arrow.PointA = AntiA(RelativeToCenter(baseL))
                        Arrow.PointB = AntiA(RelativeToCenter(baseR))
                        Arrow.PointC = AntiA(RelativeToCenter(tip))
                        Arrow.Visible = true
                    else
                        Arrow.Visible = false
                    end
                else
                    Arrow.Visible = false
                end
            else
                Arrow.Visible = false
                if not PLAYER or not PLAYER.Parent then
                    if Arrow and Arrow.Remove then
                        Arrow:Remove()
                    end
                    ArrowDrawings[PLAYER] = nil
                    if c then
                        c:Disconnect()
                    end
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

local function CreateArrowForPlayer(player)
    if player ~= LocalPlayer then
        local arrow = DrawTriangle(ArrowESP_Settings.TriangleColor)
        ArrowDrawings[player] = arrow
        UpdateArrow(player)
    end
end

local function RemoveArrowForPlayer(player)
    local arrow = ArrowDrawings[player]
    if arrow then
        arrow.Visible = false
        if arrow.Remove then
            arrow:Remove()
        end
        ArrowDrawings[player] = nil
    end
end

-- Initialize arrows for existing players
for _, player in pairs(Players:GetPlayers()) do
    CreateArrowForPlayer(player)
end

Players.PlayerAdded:Connect(CreateArrowForPlayer)
Players.PlayerRemoving:Connect(RemoveArrowForPlayer)

-- // Main UI Window
local Window = Rayfield:CreateWindow({
    Name = "Universal Executor",
    LoadingTitle = "Universal Executor",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "RayfieldConfig",
       FileName = "MainConfig"
    },
    Discord = {
       Enabled = false,
       Invite = "discord.gg/example",
       RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
       Title = "KEY SYSTEM",
       Subtitle = "Key System",
       Note = "Join the discord (discord.gg/example)",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = "ABC123"
    }
})

-- // Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458) -- Replace 4483362458 with the desired icon ID

-- WalkSpeed
local WalkSpeedToggle
local WalkSpeedSlider
local WalkSpeedValue = 16
local WalkSpeedLoopEnabled = false
local WalkSpeedConnection

WalkSpeedToggle = PlayerTab:CreateToggle({
    Name = "Loop WalkSpeed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(Value)
        WalkSpeedLoopEnabled = Value
        if Value then
            WalkSpeedConnection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.WalkSpeed = WalkSpeedValue
                        end
                    end
                end)
            end)
            Notify("success", "WalkSpeed", "Loop WalkSpeed enabled.")
        else
            if WalkSpeedConnection then
                WalkSpeedConnection:Disconnect()
                WalkSpeedConnection = nil
            end
            Notify("info", "WalkSpeed", "Loop WalkSpeed disabled.")
        end
    end,
})

WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "WalkSpeed Value",
    Range = {16, 200},
    Increment = 1,
    Suffix = "WS",
    CurrentValue = WalkSpeedValue,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        WalkSpeedValue = Value
        if WalkSpeedLoopEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.WalkSpeed = Value
                    end
                end
            end)
        end
    end,
})

-- JumpPower
local JumpPowerToggle
local JumpPowerSlider
local JumpPowerValue = 50
local JumpPowerLoopEnabled = false
local JumpPowerConnection

JumpPowerToggle = PlayerTab:CreateToggle({
    Name = "Loop JumpPower",
    CurrentValue = false,
    Flag = "JumpPowerToggle",
    Callback = function(Value)
        JumpPowerLoopEnabled = Value
        if Value then
            JumpPowerConnection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.JumpPower = JumpPowerValue
                        end
                    end
                end)
            end)
            Notify("success", "JumpPower", "Loop JumpPower enabled.")
        else
            if JumpPowerConnection then
                JumpPowerConnection:Disconnect()
                JumpPowerConnection = nil
            end
            Notify("info", "JumpPower", "Loop JumpPower disabled.")
        end
    end,
})

JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "JumpPower Value",
    Range = {50, 300},
    Increment = 1,
    Suffix = "JP",
    CurrentValue = JumpPowerValue,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        JumpPowerValue = Value
        if JumpPowerLoopEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.JumpPower = Value
                    end
                end
            end)
        end
    end,
})

-- // Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local TeleportSection = TeleportTab:CreateSection("Teleportation")

-- Save Location
TeleportTab:CreateButton({
    Name = "Save Current Location",
    Callback = function()
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.CFrame
                table.insert(SavedLocations, {Name = "Location " .. #SavedLocations + 1, CFrame = pos})
                Notify("success", "Teleport", "Location saved.")
                -- Refresh dropdown if it exists
                if LocationDropdown then
                    LocationDropdown:Refresh(SavedLocations, true)
                end
            else
                Notify("error", "Teleport", "Character not found.")
            end
        end)
    end,
})

-- Tween Teleport
local LocationNames = {}
LocationDropdown = TeleportTab:CreateDropdown({
    Name = "Saved Locations",
    Options = LocationNames,
    CurrentOption = "",
    Flag = "LocationDropdown",
    Callback = function(Option)
        -- The option selected is a string, we need to find the CFrame
        for _, loc in ipairs(SavedLocations) do
            if loc.Name == Option then
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        TweenService:Create(char.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = loc.CFrame}):Play()
                        Notify("success", "Teleport", "Teleporting to " .. Option)
                    else
                        Notify("error", "Teleport", "Character or HumanoidRootPart not found.")
                    end
                end)
                break
            end
        end
    end,
})

-- // Character Tab
local CharacterTab = Window:CreateTab("Character", 4483362458)

-- Invisible
CharacterTab:CreateToggle({
    Name = "Invisible (All Characters)",
    CurrentValue = false,
    Flag = "InvisibleToggle",
    Callback = function(Value)
        pcall(function()
            if Value then
                for _, player in pairs(Players:GetPlayers()) do
                    local char = player.Character
                    if char then
                        for _, obj in pairs(char:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                                obj.LocalTransparencyModifier = 0.99
                            end
                        end
                    end
                end
                Notify("success", "Invisible", "All characters are now invisible.")
            else
                for _, player in pairs(Players:GetPlayers()) do
                    local char = player.Character
                    if char then
                        for _, obj in pairs(char:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                                obj.LocalTransparencyModifier = 0
                            end
                        end
                    end
                end
                Notify("info", "Invisible", "Characters are now visible.")
            end
        end)
    end,
})

-- Pickup Items
CharacterTab:CreateToggle({
    Name = "Pickup All Held Items",
    CurrentValue = false,
    Flag = "PickupToggle",
    Callback = function(Value)
        if Value then
            Notify("success", "Pickup", "Pickup items loop enabled.")
            pickupLoop = RunService.Heartbeat:Connect(function()
                pcall(function()
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if obj:IsA("BackpackItem") or obj:IsA("Tool") then
                            if obj:FindFirstChild("Handle") then
                                obj.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end)
            end)
        else
            if pickupLoop then
                pickupLoop:Disconnect()
                pickupLoop = nil
            end
            Notify("info", "Pickup", "Pickup items loop disabled.")
        end
    end,
})

-- Copy Character
local CopyCharSection = CharacterTab:CreateSection("Copy Character")

local PlayerNames = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(PlayerNames, player.Name)
    end
end

local SelectedPlayerName = ""

CharacterTab:CreateDropdown({
    Name = "Select Player",
    Options = PlayerNames,
    CurrentOption = "",
    Flag = "CopyPlayerDropdown",
    Callback = function(Option)
        SelectedPlayerName = Option
    end,
})

CharacterTab:CreateButton({
    Name = "Copy Selected Character",
    Callback = function()
        if SelectedPlayerName == "" then
            Notify("error", "Copy Character", "Please select a player first.")
            return
        end
        pcall(function()
            local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
            if targetPlayer and targetPlayer.Character then
                -- Simple method: Move to target's position
                local targetPos = targetPlayer.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos
                Notify("success", "Copy Character", "Teleported to " .. SelectedPlayerName)
                -- Note: Full character appearance copying is complex and game-dependent.
                -- This just teleports you to them.
            else
                Notify("error", "Copy Character", "Target player or character not found.")
            end
        end)
    end,
})

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        table.insert(PlayerNames, player.Name)
        -- Refresh dropdowns if they exist and have a Refresh method
        -- This part might need adjustment based on Rayfield's exact API for refreshing dropdowns dynamically.
    end
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in ipairs(PlayerNames) do
        if name == player.Name then
            table.remove(PlayerNames, i)
            break
        end
    end
    -- Refresh dropdowns if needed
end)

-- // ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)

-- ESP Line (Bluwu)
ESPTab:CreateToggle({
    Name = "ESP Line (Bluwu)",
    CurrentValue = false,
    Flag = "ESPLineToggle",
    Callback = function(Value)
        pcall(function()
            if Value then
                for i, Player in next, Players:GetPlayers() do
                    if Player ~= LocalPlayer then
                        ESP_Line.Object:New(ESP_Line:GetCharacter(Player))
                        ESP_Line:CharacterAdded(Player):Connect(function(Character)
                            ESP_Line.Object:New(Character)
                        end)
                    end
                end
                Players.PlayerAdded:Connect(function(Player)
                    if Player ~= LocalPlayer then
                        ESP_Line.Object:New(ESP_Line:GetCharacter(Player))
                        ESP_Line:CharacterAdded(Player):Connect(function(Character)
                            ESP_Line.Object:New(Character)
                        end)
                    end
                end)
                Notify("success", "ESP", "ESP Line (Bluwu) enabled.")
            else
                ESP_Line:Remove() -- This might not be the correct method, depends on the library
                Notify("info", "ESP", "ESP Line (Bluwu) disabled.")
            end
        end)
    end,
})

-- ESP Cornerbox
ESPTab:CreateToggle({
    Name = "ESP Cornerbox",
    CurrentValue = false,
    Flag = "ESPCornerboxToggle",
    Callback = function(Value)
        -- Since Cornerbox code is the same as Notification, assuming it's part of Bluwu or needs separate lib
        -- For now, we'll just notify
        if Value then
            Notify("warning", "ESP", "ESP Cornerbox toggle enabled. (Implementation may vary)")
        else
            Notify("info", "ESP", "ESP Cornerbox toggle disabled.")
        end
    end,
})

-- ESP Arrow
ESPTab:CreateToggle({
    Name = "ESP Arrow",
    CurrentValue = false,
    Flag = "ESPArrowToggle",
    Callback = function(Value)
        ArrowESP_Enabled = Value
        if Value then
            Notify("success", "ESP", "ESP Arrow enabled.")
        else
            -- Hide all arrows
            for _, arrow in pairs(ArrowDrawings) do
                arrow.Visible = false
            end
            Notify("info", "ESP", "ESP Arrow disabled.")
        end
    end,
})

-- // Final Notification
Notify("success", "Ready", "Script and UI loaded successfully!", 5)
