local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Destroy previous panel if exists
for _,v in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
    if v.Name == "UGCSP_PANEL" then v:Destroy() end
end

local config = {
    speedOn = true,
    walkSpeed = 18,
    regenOn = true,
    instantKillOn = true,
    hitboxRange = 15,
    antiAfkOn = true,
    fakeName = ""
}

-- === GUI Setup ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UGCSP_PANEL"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local PANEL_W, PANEL_H = 320, 440

local panel = Instance.new("Frame", ScreenGui)
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = UDim2.new(1, -PANEL_W-10, 0, 30)
panel.BackgroundColor3 = Color3.fromRGB(30,30,40)
panel.BorderSizePixel = 0
panel.Visible = false -- Start minimized
panel.Active = true
panel.Draggable = false

-- Title bar (drag handle)
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 38)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60,80,120)
title.Text = "UGCSP Script by Takawa"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Active = true

-- Minimize button (on panel)
local minimize = Instance.new("TextButton", panel)
minimize.Size = UDim2.new(0, 34, 0, 34)
minimize.Position = UDim2.new(1, -38, 0, 2)
minimize.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
minimize.Text = "-"
minimize.TextSize = 22
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.ZIndex = 2

-- Minimized panel button (always visible, top right)
local minimizedPanel = Instance.new("TextButton", ScreenGui)
minimizedPanel.Size = UDim2.new(0, 38, 0, 38)
minimizedPanel.Position = UDim2.new(1, -48, 0, 30)
minimizedPanel.BackgroundColor3 = Color3.fromRGB(80,80,90)
minimizedPanel.Text = "☰"
minimizedPanel.TextColor3 = Color3.new(1,1,1)
minimizedPanel.TextSize = 28
minimizedPanel.Visible = true

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    minimizedPanel.Visible = true
end)
minimizedPanel.MouseButton1Click:Connect(function()
    panel.Visible = true
    minimizedPanel.Visible = false
end)

-- === Dragging (judul panel, dengan batas layar) ===
do
    local dragging, dragInput, dragStart, startPos
    local UIS = game:GetService("UserInputService")
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local screenX = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 800
            local screenY = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 600
            local delta = input.Position - dragStart
            local newX = math.clamp(startPos.X.Offset + delta.X, 0, screenX - PANEL_W)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, screenY - PANEL_H)
            panel.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)
end

-- === SCROLLING CONTAINER ===
local scroll = Instance.new("ScrollingFrame", panel)
scroll.Position = UDim2.new(0, 0, 0, 38)
scroll.Size = UDim2.new(1, 0, 1, -38)
scroll.CanvasSize = UDim2.new(0, 0, 0, 700)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ZIndex = 1
scroll.ClipsDescendants = true

scroll.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        game:GetService("ContextActionService"):BindActionAtPriority("UGCSP_CameraBlock", function() return Enum.ContextActionResult.Sink end,
            false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1)
    end
end)
scroll.InputEnded:Connect(function(input)
    game:GetService("ContextActionService"):UnbindAction("UGCSP_CameraBlock")
end)

-- === UI Utility Functions ===
local function createLabel(text, order)
    local l = Instance.new("TextLabel", scroll)
    l.Size = UDim2.new(1, -16, 0, 22)
    l.Position = UDim2.new(0, 8, 0, 12 + order*60)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200,200,200)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    l.TextSize = 16
    l.ZIndex = 2
    return l
end

local function createToggle(text, order, val, cb)
    local t = Instance.new("TextButton", scroll)
    t.Size = UDim2.new(0, 110, 0, 28)
    t.Position = UDim2.new(0, 180, 0, 10 + order*60)
    t.BackgroundColor3 = val and Color3.fromRGB(80,180,80) or Color3.fromRGB(180,80,80)
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.Text = text..(val and " ON" or " OFF")
    t.TextSize = 15
    t.Font = Enum.Font.GothamSemibold
    t.AutoButtonColor = true
    t.ZIndex = 2
    t.MouseButton1Click:Connect(function()
        val = not val
        t.Text = text..(val and " ON" or " OFF")
        t.BackgroundColor3 = val and Color3.fromRGB(80,180,80) or Color3.fromRGB(180,80,80)
        cb(val)
    end)
    return t
end

local function createNumberBoxWithOk(text, order, min, max, val, cb)
    local frame = Instance.new("Frame", scroll)
    frame.Size = UDim2.new(1, -16, 0, 36)
    frame.Position = UDim2.new(0, 8, 0, 34 + order*60)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 2

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.43, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text..": "
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.32, -4, 1, 0)
    box.Position = UDim2.new(0.43, 4, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(50,140,180)
    box.Text = tostring(val)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ZIndex = 2
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Center

    local ok = Instance.new("TextButton", frame)
    ok.Size = UDim2.new(0.23, 0, 1, 0)
    ok.Position = UDim2.new(0.75, 6, 0, 0)
    ok.BackgroundColor3 = Color3.fromRGB(120,180,80)
    ok.Text = "OK"
    ok.Font = Enum.Font.GothamBold
    ok.TextColor3 = Color3.fromRGB(255,255,255)
    ok.TextSize = 14
    ok.ZIndex = 2

    ok.MouseButton1Click:Connect(function()
        local input = tonumber(box.Text)
        if input and input >= min and input <= max then
            box.Text = tostring(input)
            cb(input)
        else
            box.Text = tostring(val)
        end
    end)
    return frame
end

local function createTextBoxWithOk(text, order, val, cb)
    local frame = Instance.new("Frame", scroll)
    frame.Size = UDim2.new(1, -16, 0, 36)
    frame.Position = UDim2.new(0, 8, 0, 34 + order*60)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 2

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.43, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text..": "
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.32, -4, 1, 0)
    box.Position = UDim2.new(0.43, 4, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(60,60,100)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Text = val
    box.PlaceholderText = "Aesthetic name"
    box.TextSize = 14
    box.Font = Enum.Font.Gotham
    box.ZIndex = 2
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Center

    local ok = Instance.new("TextButton", frame)
    ok.Size = UDim2.new(0.23, 0, 1, 0)
    ok.Position = UDim2.new(0.75, 6, 0, 0)
    ok.BackgroundColor3 = Color3.fromRGB(120,180,80)
    ok.Text = "OK"
    ok.Font = Enum.Font.GothamBold
    ok.TextColor3 = Color3.fromRGB(255,255,255)
    ok.TextSize = 14
    ok.ZIndex = 2

    ok.MouseButton1Click:Connect(function()
        cb(box.Text)
    end)
    return frame
end

-- === Panel Content ===
local order = 0
createLabel("Speed Walk", order)
createToggle("Speed", order, config.speedOn, function(v) config.speedOn = v end)
order = order + 1
createNumberBoxWithOk("Speed", order, 8, 50, config.walkSpeed, function(v) config.walkSpeed = v end)
order = order + 1

createLabel("Regen HP", order)
createToggle("Regen", order, config.regenOn, function(v) config.regenOn = v end)
order = order + 1

createLabel("Instant Kill", order)
createToggle("InstKill", order, config.instantKillOn, function(v) config.instantKillOn = v end)
order = order + 1
createNumberBoxWithOk("Range", order, 1, 15, config.hitboxRange, function(v) config.hitboxRange = v end)
order = order + 1

createLabel("Menyerang Segala Arah: Selalu Aktif", order)
order = order + 1

createLabel("Anti AFK", order)
createToggle("AntiAFK", order, config.antiAfkOn, function(v) config.antiAfkOn = v end)
order = order + 1

createTextBoxWithOk("Fake Name (visual)", order, config.fakeName, function(v) config.fakeName = v end)
order = order + 1

createLabel("Game Info:", order)
local infoLabel = Instance.new("TextLabel", scroll)
infoLabel.Size = UDim2.new(1, -16, 0, 34)
infoLabel.Position = UDim2.new(0, 8, 0, 10 + order*60)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(180,220,255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 13
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Text = ""
infoLabel.ZIndex = 2

-- === Update Game Info ===
spawn(function()
    while true do
        wait(1)
        local placeId = tostring(game.PlaceId)
        local gameId = tostring(game.GameId)
        local name = ""
        pcall(function()
            name = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
        end)
        infoLabel.Text = "Game: "..(name ~= "" and name or "<tidak terdeteksi>")..
            "\nPlaceId: "..placeId.." | GameId: "..gameId
    end
end)

-- === Anti AFK ===
spawn(function()
    while true do
        wait(10)
        if config.antiAfkOn then
            local vu = game:service'VirtualUser'
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end
    end
end)

-- === Fake Name (visual only) ===
spawn(function()
    while true do
        wait(2)
        if config.fakeName ~= "" then
            pcall(function()
                LocalPlayer.DisplayName = config.fakeName
            end)
        end
    end
end)

-- === Speed & Regen (regen seperti script awal: 1 detik, HP ke 99 jika kurang) ===
spawn(function()
    while true do
        wait(1)
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
    end
end)

-- === SAFE KILL: Tidak serang diri sendiri, tidak serang yang sudah mati, tidak serang di safe zone ===
local function isSafeZone(target)
    -- Cek tag, attribute, atau folder "SafeZone"
    if target:FindFirstChild("SafeZone") then return true end
    if target:FindFirstChild("safezone") then return true end
    if target:FindFirstChild("IsInSafeZone") then return target.IsInSafeZone.Value end
    -- Bisa tambahkan custom pengecekan sesuai game
    return false
end

local function isEnemy(target)
    if target == LocalPlayer.Character then return false end
    if Players:GetPlayerFromCharacter(target) and Players:GetPlayerFromCharacter(target) == LocalPlayer then return false end
    return true
end

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
                    if parent and isEnemy(parent) then
                        local humanoid = parent:FindFirstChildWhichIsA("Humanoid")
                        if humanoid and humanoid.Health > 0 and not isSafeZone(parent) then
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