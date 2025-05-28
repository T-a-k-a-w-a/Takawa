-- Panel SpinWheel Hadiah Spesifik (by Copilot Chat Assistant)

local plr = game.Players.LocalPlayer
local guiName = "SpinWheelPanel"
pcall(function() local o=plr.PlayerGui:FindFirstChild(guiName) if o then o:Destroy() end end)
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = guiName
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 330, 0, 220)
frame.Position = UDim2.new(0.5, -165, 0.22, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,30,50)
frame.BackgroundTransparency = 0.12
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 13)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,36)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.Text = "SpinWheel Hack Panel"
title.TextSize = 19

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -38, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(44,44,99)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)

-- Minimize logic
local minimized = false
local childrenHide = {}
for _,c in pairs(frame:GetChildren()) do
    if c ~= minBtn and c ~= title then
        table.insert(childrenHide, c)
    end
end
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,c in ipairs(childrenHide) do c.Visible = not minimized end
    frame.Size = minimized and UDim2.new(0, 110, 0, 44) or UDim2.new(0, 330, 0, 220)
    minBtn.Text = minimized and "+" or "-"
end)

-- HOTKEY [~] untuk show/hide
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Tilde or input.KeyCode == Enum.KeyCode.BackQuote then
        gui.Enabled = not gui.Enabled
    end
end)

local function section(txt, ypos)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-24,0,18)
    l.Position = UDim2.new(0,12,0,ypos)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(200,220,255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = txt
    l.Parent = frame
end

section("Spin Result Hack:", 42)

-- Tombol-tombol hadiah
local btnUGC = Instance.new("TextButton", frame)
btnUGC.Size = UDim2.new(0, 90, 0, 32)
btnUGC.Position = UDim2.new(0, 18, 0, 68)
btnUGC.BackgroundColor3 = Color3.fromRGB(40,130,220)
btnUGC.Text = "100% UGC"
btnUGC.Font = Enum.Font.GothamBold
btnUGC.TextSize = 15
btnUGC.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnUGC).CornerRadius = UDim.new(0, 8)

local btnCarpet = Instance.new("TextButton", frame)
btnCarpet.Size = UDim2.new(0, 90, 0, 32)
btnCarpet.Position = UDim2.new(0, 123, 0, 68)
btnCarpet.BackgroundColor3 = Color3.fromRGB(200,130,60)
btnCarpet.Text = "Karpet Terbang"
btnCarpet.Font = Enum.Font.GothamBold
btnCarpet.TextSize = 15
btnCarpet.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnCarpet).CornerRadius = UDim.new(0, 8)

local btnMoney = Instance.new("TextButton", frame)
btnMoney.Size = UDim2.new(0, 90, 0, 32)
btnMoney.Position = UDim2.new(0, 228, 0, 68)
btnMoney.BackgroundColor3 = Color3.fromRGB(44,200,80)
btnMoney.Text = "10.000 Money"
btnMoney.Font = Enum.Font.GothamBold
btnMoney.TextSize = 15
btnMoney.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnMoney).CornerRadius = UDim.new(0, 8)

-- Auto Spin
section("Auto Spin:", 116)
local autoSpin = false
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0, 110, 0, 32)
autoBtn.Position = UDim2.new(0, 18, 0, 142)
autoBtn.BackgroundColor3 = Color3.fromRGB(200,80,60)
autoBtn.Text = "Auto Spin: OFF"
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 15
autoBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 8)

local dropDownBox = Instance.new("TextBox", frame)
dropDownBox.Size = UDim2.new(0, 84, 0, 32)
dropDownBox.Position = UDim2.new(0, 140, 0, 142)
dropDownBox.BackgroundColor3 = Color3.fromRGB(60,60,90)
dropDownBox.TextColor3 = Color3.new(1,1,1)
dropDownBox.Font = Enum.Font.Gotham
dropDownBox.TextSize = 14
dropDownBox.PlaceholderText = "Nomor Hadiah"
dropDownBox.Text = "5" -- default UGC
Instance.new("UICorner", dropDownBox).CornerRadius = UDim.new(0,8)

section("Keterangan: UGC = 5, Karpet Terbang = 2, Money = 7", 184)

-- REMOTES
local Rep = game:GetService("ReplicatedStorage")
local SpinWheel = Rep:WaitForChild("Remotes"):WaitForChild("SpinWheel")
local SpinComplete = Rep:WaitForChild("Remotes"):WaitForChild("SpinComplete")

btnUGC.MouseButton1Click:Connect(function()
    SpinWheel:FireServer()
    wait(0.23)
    SpinComplete:FireServer(5)
end)
btnCarpet.MouseButton1Click:Connect(function()
    SpinWheel:FireServer()
    wait(0.23)
    SpinComplete:FireServer(2)
end)
btnMoney.MouseButton1Click:Connect(function()
    SpinWheel:FireServer()
    wait(0.23)
    SpinComplete:FireServer(7)
end)

autoBtn.MouseButton1Click:Connect(function()
    autoSpin = not autoSpin
    autoBtn.Text = autoSpin and "Auto Spin: ON" or "Auto Spin: OFF"
    autoBtn.BackgroundColor3 = autoSpin and Color3.fromRGB(40,150,40) or Color3.fromRGB(200,80,60)
end)

spawn(function()
    while true do
        if autoSpin then
            local nomor = tonumber(dropDownBox.Text) or 5
            pcall(function()
                SpinWheel:FireServer()
            end)
            wait(0.22)
            pcall(function()
                SpinComplete:FireServer(nomor)
            end)
            wait(0.5)
        else
            wait(0.2)
        end
    end
end)