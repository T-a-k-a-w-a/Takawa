--[[ 
  Roblox GUI Panel Script
  By: GitHub Copilot Chat Assistant
  Fitur: Panel kanan atas, minimize/restore, ON/OFF, slider & info
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- ==== VARIABEL FITUR ====
local config = {
    speedOn = true,
    walkSpeed = 18,
    regenOn = true,
    instantKillOn = true,
    hitboxRange = 15,
    antiAfkOn = true,
    fakeNameOn = true,
    fakeName = ""
}

-- ==== PANEL GUI MAIN ====
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "TakwPanel"
ScreenGui.ResetOnSpawn = false

local panel = Instance.new("Frame", ScreenGui)
panel.Size = UDim2.new(0, 340, 0, 330)
panel.Position = UDim2.new(1, -350, 0, 40)
panel.BackgroundColor3 = Color3.fromRGB(30,30,30)
panel.BorderSizePixel = 0
panel.Visible = true

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 38)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50,50,70)
title.Text = "Takw Panel Script"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold

local minimize = Instance.new("TextButton", panel)
minimize.Size = UDim2.new(0, 36, 0, 36)
minimize.Position = UDim2.new(1, -38, 0, 2)
minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
minimize.Text = "-"
minimize.TextSize = 24
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold

local minimizedPanel = Instance.new("TextButton", ScreenGui)
minimizedPanel.Size = UDim2.new(0, 40, 0, 40)
minimizedPanel.Position = UDim2.new(1, -60, 0, 40)
minimizedPanel.BackgroundColor3 = Color3.fromRGB(50,50,50)
minimizedPanel.Text = "☰"
minimizedPanel.TextColor3 = Color3.new(1,1,1)
minimizedPanel.TextSize = 28
minimizedPanel.Visible = false

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    minimizedPanel.Visible = true
end)
minimizedPanel.MouseButton1Click:Connect(function()
    panel.Visible = true
    minimizedPanel.Visible = false
end)

-- ==== FUNGSI UI UTILITY ====
local function createLabel(text, y)
    local l = Instance.new("TextLabel", panel)
    l.Size = UDim2.new(1, -24, 0, 22)
    l.Position = UDim2.new(0, 12, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200,200,200)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    l.TextSize = 16
    return l
end

local function createToggle(text, y, state, callback)
    local t = Instance.new("TextButton", panel)
    t.Size = UDim2.new(0, 120, 0, 26)
    t.Position = UDim2.new(0, 200, 0, y)
    t.BackgroundColor3 = state and Color3.fromRGB(60,180,60) or Color3.fromRGB(180,60,60)
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.Text = text .. (state and " ON" or " OFF")
    t.TextSize = 15
    t.Font = Enum.Font.GothamSemibold
    t.AutoButtonColor = true
    t.MouseButton1Click:Connect(function()
        state = not state
        t.Text = text .. (state and " ON" or " OFF")
        t.BackgroundColor3 = state and Color3.fromRGB(60,180,60) or Color3.fromRGB(180,60,60)
        callback(state)
    end)
    return t
end

local function createSlider(text, y, min, max, val, callback)
    local frame = Instance.new("Frame", panel)
    frame.Size = UDim2.new(1, -24, 0, 32)
    frame.Position = UDim2.new(0, 12, 0, y)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text..": "..val
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("TextButton", frame)
    slider.Size = UDim2.new(0.5, -10, 0, 24)
    slider.Position = UDim2.new(0.5, 10, 0, 4)
    slider.BackgroundColor3 = Color3.fromRGB(40,120,160)
    slider.Text = tostring(val)
    slider.TextColor3 = Color3.new(1,1,1)
    slider.Font = Enum.Font.Gotham
    slider.TextSize = 15

    slider.MouseButton1Click:Connect(function()
        local input = tonumber(game:GetService("StarterGui"):PromptInput("Masukkan nilai "..text.." ("..min.."-"..max..")", slider.Text))
        if input and input >= min and input <= max then
            slider.Text = tostring(input)
            label.Text = text..": "..input
            callback(input)
        end
    end)
    return frame
end

-- ==== UI & FITUR ====
local ypos = 46
createLabel("Speed Walk", ypos)
local speedToggle = createToggle("Speed", ypos, config.speedOn, function(state) config.speedOn = state end)
local speedSlider = createSlider("Speed", ypos+26, 8, 50, config.walkSpeed, function(val) config.walkSpeed = val end)
ypos = ypos + 58

createLabel("Regen HP", ypos)
local regenToggle = createToggle("Regen", ypos, config.regenOn, function(state) config.regenOn = state end)
ypos = ypos + 32

createLabel("Instant Kill", ypos)
local instantKillToggle = createToggle("InstKill", ypos, config.instantKillOn, function(state) config.instantKillOn = state end)
local hitboxSlider = createSlider("Range", ypos+26, 1, 15, config.hitboxRange, function(val) config.hitboxRange = val end)
ypos = ypos + 58

createLabel("Menyerang Segala Arah: Selalu Aktif", ypos)
ypos = ypos + 28

createLabel("Anti AFK", ypos)
local afkToggle = createToggle("AntiAFK", ypos, config.antiAfkOn, function(state) config.antiAfkOn = state end)
ypos = ypos + 32

createLabel("Protect Pads (Fake Name):", ypos)
local fakeNameBox = Instance.new("TextBox", panel)
fakeNameBox.Size = UDim2.new(0, 120, 0, 26)
fakeNameBox.Position = UDim2.new(0, 200, 0, ypos)
fakeNameBox.BackgroundColor3 = Color3.fromRGB(60,60,100)
fakeNameBox.TextColor3 = Color3.fromRGB(255,255,255)
fakeNameBox.Text = config.fakeName
fakeNameBox.PlaceholderText = "isi nama aesthetic"
fakeNameBox.TextSize = 14
fakeNameBox.Font = Enum.Font.Gotham
fakeNameBox.FocusLost:Connect(function()
    config.fakeName = fakeNameBox.Text
end)
ypos = ypos + 32

createLabel("Game Info:", ypos)
local infoLabel = Instance.new("TextLabel", panel)
infoLabel.Size = UDim2.new(1, -24, 0, 32)
infoLabel.Position = UDim2.new(0, 12, 0, ypos + 20)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(180,220,255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Text = ""

-- ==== UPDATE INFO GAME ====
spawn(function()
    while true do
        wait(1)
        local placeId = tostring(game.PlaceId)
        local gameId = tostring(game.GameId)
        infoLabel.Text = "Game: "..game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
            .."\nPlaceId: "..placeId.." | GameId: "..gameId
    end
end)

-- ==== ANTI AFK ====
spawn(function()
    while true do
        wait(10)
        if config.antiAfkOn then
            local vu = game:service'VirtualUser'
            vu:Button2Down(Vector2.new(0,0),Workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),Workspace.CurrentCamera.CFrame)
        end
    end
end)

-- ==== PROTECT FAKE NAME (VISUAL ONLY) ====
spawn(function()
    while true do
        wait(2)
        if config.fakeNameOn and config.fakeName ~= "" then
            pcall(function()
                LocalPlayer.DisplayName = config.fakeName
            end)
        end
    end
end)

-- ==== SPEED & REGEN ====
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local h = char:FindFirstChildOfClass("Humanoid")
        if config.speedOn then
            h.WalkSpeed = config.walkSpeed
        else
            h.WalkSpeed = 16
        end
        if config.regenOn and h.Health < 99 then
            h.Health = 99
        end
    end
end)

-- ==== AUTO ATTACK LOOP ====
spawn(function()
    while true do
        wait(0.05)
        if not LocalPlayer.Character then continue end
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local range = config.hitboxRange
        if tool and tool:FindFirstChild("Handle") and config.instantKillOn then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and LocalPlayer:DistanceFromCharacter(part.Position) <= range then
                    local parent = part.Parent
                    if parent and parent ~= LocalPlayer.Character then
                        local humanoid = parent:FindFirstChildWhichIsA("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            tool:Activate()
                            firetouchinterest(tool.Handle, part, 0)
                            firetouchinterest(tool.Handle, part, 1)
                            humanoid.Health = 0
                        end
                    end
                end
            end
        end
    end
end)

-- ==== DRAGGABLE PANEL ====
do
    local dragToggle, dragInput, dragStart, startPos
    local function updateInput(input)
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + delta.X,
                                  panel.Position.Y.Scale, panel.Position.Y.Offset + delta.Y)
    end
    panel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    panel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end