-- DIJAMIN PANEL MUNCUL, SUPPORT ANDROID DAN PC
pcall(function()
    if game.CoreGui:FindFirstChild("MobileSpy") then game.CoreGui.MobileSpy:Destroy() end
    if game.Players.LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("MobileSpy") then
        game.Players.LocalPlayer.PlayerGui.MobileSpy:Destroy()
    end
end)

local function safeAttach(gui)
    local player = game.Players.LocalPlayer
    local pg = player:FindFirstChild("PlayerGui")
    local cg = game:FindFirstChildOfClass("CoreGui")
    if pg then
        gui.Parent = pg
    elseif cg then
        gui.Parent = cg
    else
        gui.Parent = player
    end
end

local SimpleSpy = Instance.new("ScreenGui")
SimpleSpy.Name = "MobileSpy"
SimpleSpy.ResetOnSpawn = false
SimpleSpy.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeAttach(SimpleSpy)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.14
MainFrame.BorderSizePixel = 0
MainFrame.Parent = SimpleSpy
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,14)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1,0,0,38)
Header.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

local HeaderLabel = Instance.new("TextLabel", Header)
HeaderLabel.Size = UDim2.new(1,0,1,0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "SimpleSpy Mobile"
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextColor3 = Color3.fromRGB(255,255,255)
HeaderLabel.TextSize = 20

local ToggleButton = Instance.new("TextButton", Header)
ToggleButton.Size = UDim2.new(0,38,0,38)
ToggleButton.Position = UDim2.new(1,-38,0,0)
ToggleButton.Text = "–"
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 90, 190)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 24
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0,10)

local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Name = "Logs"
ScrollFrame.Size = UDim2.new(1,-16,1,-46)
ScrollFrame.Position = UDim2.new(0,8,0,44)
ScrollFrame.CanvasSize = UDim2.new(0,0,1,0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.BackgroundColor3 = Color3.fromRGB(38,38,38)
ScrollFrame.BackgroundTransparency = 0.15
ScrollFrame.BorderSizePixel = 0
local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0,3)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Dummy log agar panel pasti muncul
local LogLabel = Instance.new("TextLabel", ScrollFrame)
LogLabel.Size = UDim2.new(1,0,0,30)
LogLabel.Position = UDim2.new(0,0,0,0)
LogLabel.BackgroundTransparency = 1
LogLabel.TextColor3 = Color3.fromRGB(255,255,255)
LogLabel.Text = "Panel SimpleSpy Mobile Muncul!"
LogLabel.Font = Enum.Font.Gotham
LogLabel.TextSize = 15
LogLabel.TextXAlignment = Enum.TextXAlignment.Left