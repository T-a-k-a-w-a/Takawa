-- SimpleSpy Mobile Panel - Dijamin Muncul Android/PC
pcall(function()
    if game.CoreGui:FindFirstChild("MobileSpy") then game.CoreGui.MobileSpy:Destroy() end
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MobileSpy") then game.Players.LocalPlayer.PlayerGui.MobileSpy:Destroy() end
end)

local function safeAttach(gui)
    local cg = game:FindFirstChildOfClass("CoreGui")
    local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if cg and pcall(function() gui.Parent = cg end) and gui.Parent == cg then
        return cg
    elseif pg and pcall(function() gui.Parent = pg end) and gui.Parent == pg then
        return pg
    else
        gui.Parent = game.Players.LocalPlayer
        return game.Players.LocalPlayer
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

-- Dummy log untuk bukti panel muncul
local LogLabel = Instance.new("TextLabel", ScrollFrame)
LogLabel.Size = UDim2.new(1,0,0,30)
LogLabel.Position = UDim2.new(0,0,0,0)
LogLabel.BackgroundTransparency = 1
LogLabel.TextColor3 = Color3.fromRGB(255,255,255)
LogLabel.Text = "Panel SimpleSpy Mobile Muncul!"
LogLabel.Font = Enum.Font.Gotham
LogLabel.TextSize = 15
LogLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize
local minimized = false
ToggleButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local t = game:GetService("TweenService")
    if minimized then
        t:Create(MainFrame, TweenInfo.new(0.22), {Size = UDim2.new(0.19,0,0.09,0)}):Play()
        ToggleButton.Text = "↑"
        ScrollFrame.Visible = false
    else
        t:Create(MainFrame, TweenInfo.new(0.22), {Size = UDim2.new(0.9,0,0.7,0)}):Play()
        ToggleButton.Text = "–"
        ScrollFrame.Visible = true
    end
end)

-- Drag Clamp (tidak keluar layar)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local s = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, s.X - MainFrame.AbsoluteSize.X)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, s.Y - MainFrame.AbsoluteSize.Y)
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end)