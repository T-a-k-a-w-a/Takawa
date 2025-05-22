-- SimpleSpy Mobile Edition
-- By EXCEPTIONAL
-- Optimized for Android touch controls

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

-- UI Configuration
local SimpleSpy = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local ScrollFrame = Instance.new("ScrollingFrame")
local LogTemplate = Instance.new("Frame")
local ControlPanel = Instance.new("Frame")
local NotesPanel = Instance.new("Frame")

-- Mobile Optimizations
local TOUCH_THRESHOLD = 0.3 -- Seconds for long press
local BUTTON_SIZE = UDim2.new(0.2, 0, 0.06, 0)
local PANEL_POSITION = UDim2.new(0.05, 0, 0.15, 0)

-- Configuration
local config = {
    autoBlock = false,
    excludeList = {},
    blockList = {},
    maxLogs = 150,
    minimized = false,
    notesVisible = false
}

-- Touch Handling
local touchStartTime = 0
local touchPosition = Vector2.new()
local activeTouch = nil

-- UI Setup
do
    SimpleSpy.Name = "MobileSpy"
    SimpleSpy.ResetOnSpawn = false
    SimpleSpy.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SimpleSpy.Parent = game.CoreGui

    -- Main Frame
    MainFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
    MainFrame.Position = PANEL_POSITION
    MainFrame.AnchorPoint = Vector2.new(0, 0)
    MainFrame.BackgroundTransparency = 0.8
    -- ... (Lanjutan setup UI)
end

-- Touch Event Handlers
local function handleTouchInput(input, processed)
    if not processed and input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputState == Enum.UserInputState.Begin then
            touchStartTime = os.clock()
            touchPosition = input.Position
            activeTouch = input
        elseif input.UserInputState == Enum.UserInputState.End then
            if os.clock() - touchStartTime >= TOUCH_THRESHOLD then
                -- Long press handler
                showContextMenu(touchPosition)
            else
                -- Single tap handler
                handleShortTap(touchPosition)
            end
            activeTouch = nil
        end
    end
end

-- Mobile-optimized Controls
local function createMobileButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = BUTTON_SIZE
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    local function handleTap()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
        callback()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end
    
    btn.Activated:Connect(handleTap)
    return btn
end

-- Panel Control System
local function togglePanel()
    config.minimized = not config.minimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
    
    if config.minimized then
        TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0.15, 0, 0.1, 0)}):Play()
        ToggleButton.Text = "↑"
    else
        TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0.9, 0, 0.7, 0)}):Play()
        ToggleButton.Text = "↓"
    end
end

-- Context Menu for Mobile
local function showContextMenu(position)
    local contextFrame = Instance.new("Frame")
    contextFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
    contextFrame.Position = UDim2.new(
        position.X.Offset/SimpleSpy.AbsoluteSize.X,
        0,
        position.Y.Offset/SimpleSpy.AbsoluteSize.Y,
        0
    )
    
    local options = {
        "Copy Code",
        "Copy Remote",
        "Block Remote",
        "Add Note",
        "Decompile"
    }
    
    -- Add buttons for each option
    for i, option in ipairs(options) do
        local btn = createMobileButton(option, function()
            -- Handle option selection
            handleContextAction(option)
            contextFrame:Destroy()
        end)
        btn.Position = UDim2.new(0, 0, (i-1)*0.2, 0)
        btn.Parent = contextFrame
    end
    
    contextFrame.Parent = SimpleSpy
end

-- Dragging System for Mobile
local function setupDragging()
    local dragInput
    local dragging
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Notes System with Swipe Gesture
local function setupNotesSwipes()
    local notesStartPos
    
    NotesPanel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            notesStartPos = input.Position
        end
    end)
    
    NotesPanel.InputEnded:Connect(function(input)
        if notesStartPos and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - notesStartPos
            if delta.Y > 50 then
                -- Swipe down to close
                toggleNotes(false)
            end
        end
    end)
end

-- Initialization
local function init()
    setupUI()
    hookRemotes()
    setupDragging()
    setupNotesSwipes()
    
    -- Control Buttons
    local buttons = {
        {"Clear Logs", clearLogs},
        {"Auto Block", toggleAutoBlock},
        {"Notes", function() toggleNotes(true) end},
        {"Settings", showSettings}
    }
    
    for i, btnData in ipairs(buttons) do
        local btn = createMobileButton(btnData[1], btnData[2])
        btn.Position = UDim2.new((i-1)*0.25, 0, 0.9, 0)
        btn.Parent = ControlPanel
    end
end

-- Start the system
init()
