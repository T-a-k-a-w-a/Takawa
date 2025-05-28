-- Universal Obby Panel: Spin Farm, UGC Rate, Speed, NoClip, Anti-Jatuh
-- by Copilot Chat Assistant

local plr = game.Players.LocalPlayer
local guiName = "ObbyPanelUI"
pcall(function() local o=plr.PlayerGui:FindFirstChild(guiName) if o then o:Destroy() end end)

local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = guiName
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 292)
frame.Position = UDim2.new(0.5, -175, 0.13, 0)
frame.BackgroundColor3 = Color3.fromRGB(22,24,35)
frame.BackgroundTransparency = 0.09
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local top = Instance.new("TextLabel", frame)
top.Size = UDim2.new(1,0,0,34)
top.BackgroundTransparency = 1
top.Font = Enum.Font.GothamBold
top.TextColor3 = Color3.new(1,1,1)
top.TextSize = 18
top.Text = "Obby Universal Panel"

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -38, 0, 3)
minBtn.BackgroundColor3 = Color3.fromRGB(44,44,99)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 7)

-- Section helper
local function section(txt, ypos)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -24, 0, 18)
    l.Position = UDim2.new(0, 12, 0, ypos)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(200,220,255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = txt
    l.Parent = frame
end

-- 1. FARM SPIN
section("Auto Farm Spin UGC:", 40)
local spinBtn = Instance.new("TextButton", frame)
spinBtn.Size = UDim2.new(0, 112, 0, 28)
spinBtn.Position = UDim2.new(0, 16, 0, 62)
spinBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
spinBtn.Text = "Spin Farm: OFF"
spinBtn.Font = Enum.Font.GothamBold
spinBtn.TextSize = 15
spinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", spinBtn).CornerRadius = UDim.new(0, 8)

local rateBtn = Instance.new("TextButton", frame)
rateBtn.Size = UDim2.new(0, 112, 0, 28)
rateBtn.Position = UDim2.new(0, 136, 0, 62)
rateBtn.BackgroundColor3 = Color3.fromRGB(44,150,180)
rateBtn.Text = "UGC Rate: OFF"
rateBtn.Font = Enum.Font.GothamBold
rateBtn.TextSize = 15
rateBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", rateBtn).CornerRadius = UDim.new(0, 8)

local fastSpinBtn = Instance.new("TextButton", frame)
fastSpinBtn.Size = UDim2.new(0, 77, 0, 28)
fastSpinBtn.Position = UDim2.new(0, 260, 0, 62)
fastSpinBtn.BackgroundColor3 = Color3.fromRGB(100,180,44)
fastSpinBtn.Text = "Fast OFF"
fastSpinBtn.Font = Enum.Font.GothamBold
fastSpinBtn.TextSize = 15
fastSpinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", fastSpinBtn).CornerRadius = UDim.new(0, 8)

-- 2. SPEED
section("Jalan Cepat (Speed):", 104)
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 90, 0, 28)
speedBox.Position = UDim2.new(0, 16, 0, 126)
speedBox.BackgroundColor3 = Color3.fromRGB(44,44,80)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.PlaceholderText = "WalkSpeed"
speedBox.Text = "65"
speedBox.ClearTextOnFocus = false
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,8)

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0, 110, 0, 28)
speedBtn.Position = UDim2.new(0, 120, 0, 126)
speedBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
speedBtn.Text = "Speed: OFF"
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 15
speedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 8)

-- 3. NOCLIP / RECLIP
section("NoClip / ReClip:", 170)
local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(0, 110, 0, 28)
noclipBtn.Position = UDim2.new(0, 16, 0, 192)
noclipBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
noclipBtn.Text = "NoClip: OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 15
noclipBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 8)

local reclipBtn = Instance.new("TextButton", frame)
reclipBtn.Size = UDim2.new(0, 110, 0, 28)
reclipBtn.Position = UDim2.new(0, 136, 0, 192)
reclipBtn.BackgroundColor3 = Color3.fromRGB(44,150,180)
reclipBtn.Text = "ReClip"
reclipBtn.Font = Enum.Font.GothamBold
reclipBtn.TextSize = 15
reclipBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", reclipBtn).CornerRadius = UDim.new(0, 8)

-- 4. ANTI-JATUH
section("Anti-Jatuh Floating Pad:", 236)
local floatBtn = Instance.new("TextButton", frame)
floatBtn.Size = UDim2.new(0, 110, 0, 28)
floatBtn.Position = UDim2.new(0, 16, 0, 258)
floatBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
floatBtn.Text = "Floating: OFF"
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 15
floatBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 8)

-- MINIMIZE LOGIC
local minimized = false
local childrenHide = {}
for _,c in pairs(frame:GetChildren()) do
    if c ~= minBtn and c ~= top then
        table.insert(childrenHide, c)
    end
end
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,c in ipairs(childrenHide) do c.Visible = not minimized end
    frame.Size = minimized and UDim2.new(0, 120, 0, 44) or UDim2.new(0, 350, 0, 292)
    minBtn.Text = minimized and "+" or "-"
end)

-- HOTKEY [~] untuk show/hide
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Tilde or input.KeyCode == Enum.KeyCode.BackQuote then
        gui.Enabled = not gui.Enabled
    end
end)

------------------------ LOGIC FEATURE ------------------------

-- 1. AUTO SPIN FARM + UGC RATE
local spinFarming, rateUGC, fastSpin = false, false, false

-- === Silakan edit bagian ini sesuai event/function SPIN di game mu ===
-- Contoh: Jika Spin pakai RemoteEvent bernama "Spin", edit nama di bawah.
local spinRemote = nil
for _,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find("spin") then
        spinRemote = v break
    end
end
if not spinRemote then
    for _,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
        if v:IsA("RemoteEvent") then
            spinRemote = v break
        end
    end
end

spinBtn.MouseButton1Click:Connect(function()
    spinFarming = not spinFarming
    spinBtn.Text = spinFarming and "Spin Farm: ON" or "Spin Farm: OFF"
    spinBtn.BackgroundColor3 = spinFarming and Color3.fromRGB(40,150,40) or Color3.fromRGB(180,40,40)
end)
rateBtn.MouseButton1Click:Connect(function()
    rateUGC = not rateUGC
    rateBtn.Text = rateUGC and "UGC Rate: ON" or "UGC Rate: OFF"
    rateBtn.BackgroundColor3 = rateUGC and Color3.fromRGB(40,80,200) or Color3.fromRGB(44,150,180)
end)
fastSpinBtn.MouseButton1Click:Connect(function()
    fastSpin = not fastSpin
    fastSpinBtn.Text = fastSpin and "Fast ON" or "Fast OFF"
    fastSpinBtn.BackgroundColor3 = fastSpin and Color3.fromRGB(80,200,44) or Color3.fromRGB(100,180,44)
end)

spawn(function()
    while true do
        if spinFarming and spinRemote then
            -- Jika butuh argument, edit di sini. Jika tidak, cukup spinRemote:FireServer()
            if rateUGC then
                -- Jika server tidak blok, kita paksa argumen ke "UGC" jika event support
                pcall(function() spinRemote:FireServer("UGC") end)
            else
                pcall(function() spinRemote:FireServer() end)
            end
            wait(fastSpin and 0.10 or 1.2)
        else
            wait(0.5)
        end
    end
end)

-- 2. SPEED
local speedLoop = false
speedBtn.MouseButton1Click:Connect(function()
    speedLoop = not speedLoop
    speedBtn.Text = speedLoop and "Speed: ON" or "Speed: OFF"
    speedBtn.BackgroundColor3 = speedLoop and Color3.fromRGB(40,150,40) or Color3.fromRGB(180,40,40)
end)
spawn(function()
    while true do
        if speedLoop then
            local char = plr.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                local val = tonumber(speedBox.Text) or 65
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
            end
        end
        wait(0.2)
    end
end)

-- 3. NOCLIP/RECLIP
local noclipActive = false
noclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    noclipBtn.Text = noclipActive and "NoClip: ON" or "NoClip: OFF"
    noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(40,150,40) or Color3.fromRGB(180,40,40)
end)
reclipBtn.MouseButton1Click:Connect(function()
    noclipActive = false
    noclipBtn.Text = "NoClip: OFF"
    noclipBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
end)
game:GetService("RunService").Stepped:Connect(function()
    if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
        for _,v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = not noclipActive
            end
        end
    end
end)

-- 4. FLOATING PAD
local pad = nil
local floatingActive = false
floatBtn.MouseButton1Click:Connect(function()
    floatingActive = not floatingActive
    floatBtn.Text = floatingActive and "Floating: ON" or "Floating: OFF"
    floatBtn.BackgroundColor3 = floatingActive and Color3.fromRGB(40,150,40) or Color3.fromRGB(180,40,40)
    if not floatingActive and pad then pcall(function() pad:Destroy() end) pad = nil end
end)
spawn(function()
    while true do
        if floatingActive then
            if not pad or not pad.Parent then
                pad = Instance.new("Part")
                pad.Anchored = true
                pad.CanCollide = true
                pad.Transparency = 0.85
                pad.Size = Vector3.new(6, 0.6, 6)
                pad.Color = Color3.fromRGB(60,255,120)
                pad.Name = "AntiFallPad"
                pad.Material = Enum.Material.ForceField
                pad.Parent = workspace
            end
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                pad.Position = Vector3.new(pos.X, pos.Y-3.1, pos.Z)
            end
        elseif pad then
            pcall(function() pad:Destroy() end)
            pad = nil
        end
        wait(0.1)
    end
end)