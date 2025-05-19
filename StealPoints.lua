local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")

-- === CONFIG SAVE/LOAD ===
local configFile = "TakawaConfig.json"
local config = {
    speedOn = true,
    walkSpeed = 19,
    instantKillOn = true,
    hitboxRange = 15,
    fakeName = "",
    fakeUser = "",
}
local function saveConfig()
    if writefile then
        pcall(function()
            writefile(configFile, HttpService:JSONEncode(config))
        end)
    end
end
local function loadConfig()
    if readfile and isfile and isfile(configFile) then
        local s, data = pcall(function() return HttpService:JSONDecode(readfile(configFile)) end)
        if s and data then
            for k,v in pairs(data) do config[k]=v end
        end
    end
end
loadConfig()

-- === PANEL GUI ===
local PANEL_W, PANEL_H = 288, 365
local gui = Instance.new("ScreenGui")
gui.Name = "TakawaPanelV3"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = UDim2.new(1, -PANEL_W-10, 0, 40)
panel.BackgroundColor3 = Color3.fromRGB(33,36,67)
panel.BorderSizePixel = 0
panel.Active = true

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 38)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60,90,150)
title.Text = "Takawa Panel v3"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local minimize = Instance.new("TextButton", panel)
minimize.Size = UDim2.new(0, 32, 0, 32)
minimize.Position = UDim2.new(1, -40, 0, 3)
minimize.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
minimize.Text = "━"
minimize.TextSize = 20
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold

local minimizedPanel = Instance.new("TextButton", gui)
minimizedPanel.Size = UDim2.new(0, 36, 0, 36)
minimizedPanel.Position = UDim2.new(1, -44, 0, 42)
minimizedPanel.BackgroundColor3 = Color3.fromRGB(90,90,110)
minimizedPanel.Text = "☰"
minimizedPanel.TextColor3 = Color3.new(1,1,1)
minimizedPanel.TextSize = 22
minimizedPanel.Visible = false

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    minimizedPanel.Visible = true
end)
minimizedPanel.MouseButton1Click:Connect(function()
    panel.Visible = true
    minimizedPanel.Visible = false
end)

-- === DRAGGABLE (judul/ujung panel) ===
do
    local UIS = game:GetService("UserInputService")
    local drag, dragInput, dragStart, startPos
    local function beginDrag(input)
        drag = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then drag = false end
        end)
    end
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then beginDrag(input) end
    end)
    panel.InputBegan:Connect(function(input)
        if input.Position.X >= panel.AbsolutePosition.X+panel.AbsoluteSize.X-36 or input.Position.Y <= panel.AbsolutePosition.Y+38 then
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then beginDrag(input) end
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local screenX = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 800
            local screenY = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 600
            local delta = input.Position - dragStart
            local newX = math.clamp(startPos.X.Offset + delta.X, 0, screenX - PANEL_W)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, screenY - PANEL_H)
            panel.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end)
end

-- === FUNGSI UI ===
local function SectionLabel(txt, y)
    local s = Instance.new("TextLabel", panel)
    s.Size = UDim2.new(1, -16, 0, 22)
    s.Position = UDim2.new(0, 8, 0, y)
    s.BackgroundTransparency = 1
    s.Text = txt
    s.TextColor3 = Color3.fromRGB(170,210,250)
    s.Font = Enum.Font.GothamBold
    s.TextSize = 17
    s.TextXAlignment = Enum.TextXAlignment.Left
    return s
end
local function SubLabel(txt, y)
    local s = Instance.new("TextLabel", panel)
    s.Size = UDim2.new(1, -28, 0, 18)
    s.Position = UDim2.new(0, 16, 0, y)
    s.BackgroundTransparency = 1
    s.Text = txt
    s.TextColor3 = Color3.fromRGB(210,210,210)
    s.Font = Enum.Font.Gotham
    s.TextSize = 14
    s.TextXAlignment = Enum.TextXAlignment.Left
    return s
end
local function SmallSpace(y)
    local l = Instance.new("Frame", panel)
    l.Size = UDim2.new(1, -16, 0, 2)
    l.Position = UDim2.new(0, 8, 0, y)
    l.BackgroundColor3 = Color3.fromRGB(90,90,120)
    l.BorderSizePixel = 0
    return l
end

local function Toggle(txt, y, val, cb)
    local t = Instance.new("TextButton", panel)
    t.Size = UDim2.new(0, 112, 0, 26)
    t.Position = UDim2.new(0, 24, 0, y)
    t.Text = val and txt.." ON" or txt.." OFF"
    t.BackgroundColor3 = val and Color3.fromRGB(60,180,80) or Color3.fromRGB(180,80,80)
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.MouseButton1Click:Connect(function()
        val = not val
        t.Text = val and txt.." ON" or txt.." OFF"
        t.BackgroundColor3 = val and Color3.fromRGB(60,180,80) or Color3.fromRGB(180,80,80)
        cb(val)
        saveConfig()
    end)
    return t
end

local function InputWithOk(txt, y, val, cb)
    local l = Instance.new("TextLabel", panel)
    l.Size = UDim2.new(0, 80, 0, 22)
    l.Position = UDim2.new(0, 24, 0, y)
    l.BackgroundTransparency = 1
    l.Text = txt..":"
    l.TextColor3 = Color3.fromRGB(210,210,210)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", panel)
    box.Size = UDim2.new(0, 75, 0, 22)
    box.Position = UDim2.new(0, 100, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(50,140,180)
    box.Text = tostring(val)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false

    local ok = Instance.new("TextButton", panel)
    ok.Size = UDim2.new(0, 30, 0, 22)
    ok.Position = UDim2.new(0, 182, 0, y)
    ok.BackgroundColor3 = Color3.fromRGB(120,180,80)
    ok.Text = "OK"
    ok.Font = Enum.Font.GothamBold
    ok.TextColor3 = Color3.fromRGB(255,255,255)
    ok.TextSize = 13

    local check = Instance.new("TextLabel", panel)
    check.Size = UDim2.new(0, 18, 0, 22)
    check.Position = UDim2.new(0, 218, 0, y)
    check.BackgroundTransparency = 1
    check.Text = ""
    check.TextColor3 = Color3.fromRGB(100,220,100)
    check.Font = Enum.Font.GothamBold
    check.TextSize = 18

    return box, ok, check
end

local y = 46
SectionLabel("Movement", y)
local toggleSpeed = Toggle("Speed", y+26, config.speedOn, function(v) config.speedOn = v end)
local wsBox, wsOk, wsCheck = InputWithOk("WalkSpeed", y+60, config.walkSpeed, function(v) config.walkSpeed=v end)
wsOk.MouseButton1Click:Connect(function()
    local v = tonumber(wsBox.Text)
    if v and v >= 5 and v <= 100 then
        config.walkSpeed = v
        wsCheck.Text = "✔"
        saveConfig()
        wait(1.1) wsCheck.Text = ""
    else
        wsCheck.Text = ""
        wsBox.Text = tostring(config.walkSpeed)
    end
end)
SmallSpace(y+90)

y = y+100
SectionLabel("Combat", y)
local toggleKill = Toggle("Kill", y+26, config.instantKillOn, function(v) config.instantKillOn = v end)
local rangeBox, rangeOk, rangeCheck = InputWithOk("Range", y+60, config.hitboxRange, function(v) config.hitboxRange=v end)
rangeOk.MouseButton1Click:Connect(function()
    local v = tonumber(rangeBox.Text)
    if v and v >= 1 and v <= 25 then
        config.hitboxRange = v
        rangeCheck.Text = "✔"
        saveConfig()
        wait(1.1) rangeCheck.Text = ""
    else
        rangeCheck.Text = ""
        rangeBox.Text = tostring(config.hitboxRange)
    end
end)
SmallSpace(y+90)

y = y+100
SectionLabel("Identity", y)
SubLabel("Ganti hanya visual di device-mu!", y+22)
local fakeNameBox, fakeNameOK, fakeNameCheck = InputWithOk("DisplayName", y+46, config.fakeName, function(v) config.fakeName=v end)
fakeNameOK.MouseButton1Click:Connect(function()
    config.fakeName = fakeNameBox.Text
    fakeNameCheck.Text = "✔"
    saveConfig()
    wait(1.1) fakeNameCheck.Text = ""
end)
local fakeUserBox, fakeUserOK, fakeUserCheck = InputWithOk("Username", y+76, config.fakeUser, function(v) config.fakeUser=v end)
fakeUserOK.MouseButton1Click:Connect(function()
    config.fakeUser = fakeUserBox.Text
    fakeUserCheck.Text = "✔"
    saveConfig()
    wait(1.1) fakeUserCheck.Text = ""
end)
SmallSpace(y+106)

y = y+120
SectionLabel("Config", y)
local saveBtn = Instance.new("TextButton", panel)
saveBtn.Size = UDim2.new(0, 100, 0, 22)
saveBtn.Position = UDim2.new(0, 24, 0, y+26)
saveBtn.BackgroundColor3 = Color3.fromRGB(80,140,220)
saveBtn.Text = "Save Config"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.TextSize = 14
saveBtn.MouseButton1Click:Connect(function()
    saveConfig()
    saveBtn.Text = "Saved!"
    wait(1.2)
    saveBtn.Text = "Save Config"
end)

-- === Spoof Visual (fake name/user)
spawn(function()
    while true do
        wait(1)
        if config.fakeName ~= "" then
            pcall(function() LocalPlayer.DisplayName = config.fakeName end)
        end
        if config.fakeUser ~= "" then
            pcall(function() LocalPlayer.Name = config.fakeUser end)
        end
    end
end)

-- === Proteksi Points Saat Mati ===
spawn(function()
    while true do
        wait(0.1)
        local char = LocalPlayer.Character
        if char and LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Points") then
            local pointsObj = LocalPlayer.leaderstats.Points
            local lastVal = pointsObj.Value
            pointsObj:GetPropertyChangedSignal("Value"):Connect(function()
                if char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health == 0 and pointsObj.Value < lastVal then
                    pointsObj.Value = lastVal
                else
                    lastVal = pointsObj.Value
                end
            end)
        end
        wait(4)
    end
end)

-- === SPEED ===
game:GetService("RunService").Stepped:Connect(function()
    local char = LocalPlayer.Character
    if config.speedOn and char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = config.walkSpeed
    end
end)

-- === INSTANT KILL (FAST) ===
local function getPartsInViewport(maxDistance)
    local partsInViewport = {}
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local distance = LocalPlayer:DistanceFromCharacter(part.Position)
            if distance <= maxDistance then
                local _, isVisible = camera:WorldToViewportPoint(part.Position)
                if isVisible then
                    table.insert(partsInViewport, part)
                end
            end
        end
    end
    return partsInViewport
end

spawn(function()
    while true do 
        wait(0.033)
        if not config.instantKillOn then continue end
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local parts = getPartsInViewport(config.hitboxRange)
        if tool and tool:FindFirstChild("Handle") then
            for _, part in ipairs(parts) do
                if part and part.Parent and part.Parent ~= LocalPlayer.Character and part.Parent:FindFirstChildWhichIsA("Humanoid") and part.Parent:FindFirstChildWhichIsA("Humanoid").Health > 0 then
                    tool:Activate()
                    firetouchinterest(tool.Handle,part,0)
                    firetouchinterest(tool.Handle,part,1)
                end
            end
        end
    end
end)