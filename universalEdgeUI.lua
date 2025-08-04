-- Roblox All-In-One Player Script
-- Features:
-- WalkSpeed & JumpPower loop
-- Character copy by username (full details)
-- Player invisibility toggle
-- Anti-damage from all sources
-- Slow falling
-- Tween flying for mobile
-- Tween teleport to location or player username (dropdown with refresh)
-- Save & teleport to saved locations (dropdown)
-- Walk on air (invisible platform underneath)
-- Mobile-friendly draggable, minimizable UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local gui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
gui.Name = "AllInOnePlayerGui"
gui.ResetOnSpawn = false

local UIS = UserInputService

-- === UI Setup ===
local function createMainFrame()
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 320, 0, 420)
    frame.Position = UDim2.new(0.5, -160, 0.5, -210)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Active = true
    frame.Draggable = false -- We'll handle dragging manually for mobile support

    local uicorner = Instance.new("UICorner", frame)
    uicorner.CornerRadius = UDim.new(0, 8)

    -- Title bar
    local titleBar = Instance.new("Frame", frame)
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Text = "All-In-One Player Script"
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center

    local btnMinimize = Instance.new("TextButton", titleBar)
    btnMinimize.Text = "-"
    btnMinimize.Size = UDim2.new(0, 30, 1, 0)
    btnMinimize.Position = UDim2.new(1, -60, 0, 0)
    btnMinimize.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btnMinimize.TextColor3 = Color3.fromRGB(220, 220, 220)
    btnMinimize.Font = Enum.Font.SourceSansBold
    btnMinimize.TextSize = 18

    local btnClose = Instance.new("TextButton", titleBar)
    btnClose.Text = "X"
    btnClose.Size = UDim2.new(0, 30, 1, 0)
    btnClose.Position = UDim2.new(1, -30, 0, 0)
    btnClose.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
    btnClose.TextColor3 = Color3.fromRGB(220, 220, 220)
    btnClose.Font = Enum.Font.SourceSansBold
    btnClose.TextSize = 18

    return frame, btnMinimize, btnClose
end

local function createLabel(parent, text)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    return label
end

local function createTextbox(parent, placeholder)
    local textbox = Instance.new("TextBox", parent)
    textbox.Size = UDim2.new(1, -20, 0, 25)
    textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textbox.TextColor3 = Color3.fromRGB(220, 220, 220)
    textbox.Font = Enum.Font.SourceSans
    textbox.TextSize = 14
    textbox.PlaceholderText = placeholder or ""
    textbox.ClearTextOnFocus = false
    textbox.Text = ""
    local uicorner = Instance.new("UICorner", textbox)
    uicorner.CornerRadius = UDim.new(0, 6)
    return textbox
end

local function createButton(parent, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = text
    local uicorner = Instance.new("UICorner", btn)
    uicorner.CornerRadius = UDim.new(0, 6)
    return btn
end

local function createDropdown(parent)
    local dropdownFrame = Instance.new("Frame", parent)
    dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    local uicorner = Instance.new("UICorner", dropdownFrame)
    uicorner.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", dropdownFrame)
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = "Select..."

    local arrow = Instance.new("TextLabel", dropdownFrame)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.TextColor3 = Color3.fromRGB(220, 220, 220)
    arrow.Font = Enum.Font.SourceSansBold
    arrow.TextSize = 18
    arrow.Text = "▼"

    local optionsFrame = Instance.new("ScrollingFrame", dropdownFrame)
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 0)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    optionsFrame.ScrollBarThickness = 6

    optionsFrame.MuiCorner = Instance.new("UICorner", optionsFrame)
    optionsFrame.MuiCorner.CornerRadius = UDim.new(0, 6)

    return {
        Frame = dropdownFrame,
        Label = label,
        Arrow = arrow,
        OptionsFrame = optionsFrame,
        IsOpen = false,
        Options = {},
        Selected = nil,
    }
end

local function addDropdownOption(dropdown, optionText)
    local option = Instance.new("TextButton", dropdown.OptionsFrame)
    option.Size = UDim2.new(1, 0, 0, 25)
    option.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    option.TextColor3 = Color3.fromRGB(220, 220, 220)
    option.Font = Enum.Font.SourceSans
    option.TextSize = 14
    option.Text = optionText
    option.AutoButtonColor = true

    option.MouseEnter:Connect(function()
        option.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    option.MouseLeave:Connect(function()
        option.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    end)

    option.MouseButton1Click:Connect(function()
        dropdown.Label.Text = optionText
        dropdown.Selected = optionText
        dropdown.OptionsFrame.Visible = false
        dropdown.IsOpen = false
    end)

    table.insert(dropdown.Options, option)
    dropdown.OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, #dropdown.Options * 25)
    dropdown.OptionsFrame.Size = UDim2.new(1, 0, 0, math.min(#dropdown.Options * 25, 150))
end

local function toggleDropdown(dropdown)
    if dropdown.IsOpen then
        dropdown.OptionsFrame.Visible = false
        dropdown.IsOpen = false
    else
        dropdown.OptionsFrame.Visible = true
        dropdown.IsOpen = true
    end
end

-- === Main UI ===
local mainFrame, btnMinimize, btnClose = createMainFrame()
mainFrame.Parent = gui

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1

-- WalkSpeed & JumpPower
local lblSpeed = createLabel(contentFrame, "WalkSpeed:")
lblSpeed.Position = UDim2.new(0, 10, 0, 10)
local txtSpeed = createTextbox(contentFrame, "16 (default)")
txtSpeed.Position = UDim2.new(0, 10, 0, 30)
txtSpeed.Text = "16"

local lblJump = createLabel(contentFrame, "JumpPower:")
lblJump.Position = UDim2.new(0, 10, 0, 60)
local txtJump = createTextbox(contentFrame, "50 (default)")
txtJump.Position = UDim2.new(0, 10, 0, 80)
txtJump.Text = "50"

-- Copy Character by Username
local lblCopy = createLabel(contentFrame, "Copy Character (username):")
lblCopy.Position = UDim2.new(0, 10, 0, 110)
local txtCopy = createTextbox(contentFrame, "Enter username")
txtCopy.Position = UDim2.new(0, 10, 0, 130)
local btnCopy = createButton(contentFrame, "Copy Character")
btnCopy.Position = UDim2.new(0, 10, 0, 160)

-- Invisibility toggle
local btnInvisible = createButton(contentFrame, "Toggle Invisibility")
btnInvisible.Position = UDim2.new(0, 10, 0, 200)

-- Slow falling toggle
local btnSlowFall = createButton(contentFrame, "Toggle Slow Falling")
btnSlowFall.Position = UDim2.new(0, 10, 0, 240)

-- Tween Fly toggle
local btnFly = createButton(contentFrame, "Toggle Tween Fly")
btnFly.Position = UDim2.new(0, 10, 0, 280)

-- Dropdown to teleport to location
local lblTeleportLoc = createLabel(contentFrame, "Teleport to Saved Location:")
lblTeleportLoc.Position = UDim2.new(0, 10, 0, 320)
local dropdownLocations = createDropdown(contentFrame)
dropdownLocations.Frame.Position = UDim2.new(0, 10, 0, 340)

local btnTeleportToLoc = createButton(contentFrame, "Teleport to Location")
btnTeleportToLoc.Position = UDim2.new(0, 10, 0, 390)

-- Save current location button
local btnSaveLocation = createButton(contentFrame, "Save Current Location")
btnSaveLocation.Position = UDim2.new(0, 160, 0, 390)

-- Dropdown to teleport to player username
local lblTeleportPlayer = createLabel(contentFrame, "Teleport to Player Username:")
lblTeleportPlayer.Position = UDim2.new(0, 10, 0, 430)
local dropdownPlayers = createDropdown(contentFrame)
dropdownPlayers.Frame.Position = UDim2.new(0, 10, 0, 450)

local btnRefreshPlayers = createButton(contentFrame, "Refresh Players")
btnRefreshPlayers.Position = UDim2.new(0, 10, 0, 490)

local btnTeleportToPlayer = createButton(contentFrame, "Teleport to Player")
btnTeleportToPlayer.Position = UDim2.new(0, 160, 0, 490)

-- Invisible platform for walking on air
local btnToggleWalkOnAir = createButton(contentFrame, "Toggle Walk On Air")
btnToggleWalkOnAir.Position = UDim2.new(0, 10, 0, 530)

-- Keep content frame height dynamic
contentFrame.Size = UDim2.new(1, 0, 1, -30)

-- === Dragging for mobile & desktop ===
do
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    mainFrame.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Minimize / Maximize
btnMinimize.MouseButton1Click:Connect(function()
    if contentFrame.Visible then
        contentFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 320, 0, 30)
    else
        contentFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 320, 0, 420)
    end
end)

-- Close button
btnClose.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Dropdown toggles
dropdownLocations.Frame.MouseButton1Click:Connect(function()
    toggleDropdown(dropdownLocations)
end)
dropdownPlayers.Frame.MouseButton1Click:Connect(function()
    toggleDropdown(dropdownPlayers)
end)

-- === Variables & States ===
local savedLocations = {}

local invisibilityOn = false
local slowFallOn = false
local flyOn = false
local walkOnAirOn = false

local flySpeed = 50
local tweenFlyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

-- === Functions ===

-- Loop for setting WalkSpeed and JumpPower
RunService.Heartbeat:Connect(function()
    local character = localPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local wSpeed = tonumber(txtSpeed.Text)
        if wSpeed and wSpeed > 0 then
            humanoid.WalkSpeed = wSpeed
        end

        local jPower = tonumber(txtJump.Text)
        if jPower and jPower > 0 then
            humanoid.JumpPower = jPower
        end
    end
end)

-- Copy character function
local function copyCharacterFromUsername(username)
    local targetPlayer = Players:FindFirstChild(username)
    if not targetPlayer then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower() == username:lower() then
                targetPlayer = p
                break
            end
        end
    end
    if not targetPlayer or not targetPlayer.Character then
        warn("Player or character not found: " .. username)
        return
    end

    local sourceChar = targetPlayer.Character
    local destChar = localPlayer.Character
    if not destChar then return end

    -- Clear existing character parts except HumanoidRootPart and Humanoid
    for _, obj in pairs(destChar:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" and obj.Name ~= "Head" then
            obj:Destroy()
        elseif obj:IsA("Accessory") or obj:IsA("CharacterMesh") or obj:IsA("Tool") then
            obj:Destroy()
        end
    end

    -- Copy body parts mesh and details
    local function cloneDescendant(srcParent, dstParent)
        for _, child in pairs(srcParent:GetChildren()) do
            if child:IsA("BasePart") then
                local clone = child:Clone()
                clone.Parent = dstParent
                clone.Transparency = child.Transparency
                clone.Material = child.Material
                clone.Color = child.Color
            elseif child:IsA("Decal") or child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                local clone = child:Clone()
                clone.Parent = dstParent
            elseif child:IsA("Accessory") then
                local clone = child:Clone()
                clone.Parent = dstParent
           
