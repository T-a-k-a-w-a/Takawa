--// Takawa Panel V4: Full draggable, full feature, mobile ready

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local camera = workspace.CurrentCamera

-- CONFIG (in memory)
local config = {
    walkspeed = 19,
    range = 15,
    displayname = LocalPlayer.DisplayName,
    username = LocalPlayer.Name,
}
-- Save/Load config (if supported)
local configFile = "TakawaPanelConfig.json"
local function saveConfig()
    if writefile then
        pcall(function() writefile(configFile, HttpService:JSONEncode(config)) end)
    end
end
local function loadConfig()
    if readfile and isfile and isfile(configFile) then
        local succ, data = pcall(function() return HttpService:JSONDecode(readfile(configFile)) end)
        if succ and data then
            for k,v in pairs(data) do config[k]=v end
        end
    end
end
loadConfig()

-- GUI setup
local PANEL_W, PANEL_H = 340, 470
local gui = Instance.new("ScreenGui")
gui.Name = "TakawaPanel"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = UDim2.new(1, -PANEL_W-18, 0, 60)
panel.BackgroundColor3 = Color3.fromRGB(33,36,67)
panel.BorderSizePixel = 0
panel.Active = true
panel.ClipsDescendants = true

-- Minimized Button (☰) - always follows panel position
local minimizedPanel = Instance.new("TextButton", gui)
minimizedPanel.Size = UDim2.new(0, 40, 0, 40)
minimizedPanel.Position = UDim2.new(0, panel.Position.X.Offset + PANEL_W - 46, 0, panel.Position.Y.Offset + 8)
minimizedPanel.BackgroundColor3 = Color3.fromRGB(90,90,110)
minimizedPanel.Text = "☰"
minimizedPanel.TextColor3 = Color3.new(1,1,1)
minimizedPanel.TextSize = 22
minimizedPanel.Visible = false
minimizedPanel.AutoButtonColor = true
minimizedPanel.BorderSizePixel = 0

-- Title
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -40, 0, 38)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60,90,150)
title.Text = "Takawa Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.BorderSizePixel = 0

-- Minimize button (on panel)
local minimize = Instance.new("TextButton", panel)
minimize.Size = UDim2.new(0, 38, 0, 38)
minimize.Position = UDim2.new(1, -38, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(90,90,110)
minimize.Text = "━"
minimize.TextSize = 20
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.BorderSizePixel = 0

-- Scrollable content
local scroll = Instance.new("ScrollingFrame", panel)
scroll.Size = UDim2.new(1, 0, 1, -38)
scroll.Position = UDim2.new(0, 0, 0, 38)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
scroll.ScrollBarThickness = 7
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ClipsDescendants = true

-- DRAG LOGIC: drag seluruh area panel (bukan hanya judul/tombol)
local UIS = game:GetService("UserInputService")
local drag, dragStart, startPos
panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then drag = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local screenX = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 800
        local screenY = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 600
        local delta = input.Position - dragStart
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, screenX - PANEL_W)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, screenY - PANEL_H)
        panel.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        -- move minimizedPanel to follow panel position always
        minimizedPanel.Position = UDim2.new(0, newX + PANEL_W - 46, 0, newY + 8)
    end
end)

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    minimizedPanel.Visible = true
    minimizedPanel.Position = UDim2.new(0, panel.Position.X.Offset + PANEL_W - 46, 0, panel.Position.Y.Offset + 8)
end)
minimizedPanel.MouseButton1Click:Connect(function()
    panel.Visible = true
    minimizedPanel.Visible = false
end)

-- UI Utility
local function Section(text, y)
    local l = Instance.new("TextLabel", scroll)
    l.Size = UDim2.new(1, -18, 0, 22)
    l.Position = UDim2.new(0, 8, 0, y)
    l.Text = text
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(170,210,250)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 16
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end
local function SubLabel(txt, y)
    local s = Instance.new("TextLabel", scroll)
    s.Size = UDim2.new(1, -28, 0, 16)
    s.Position = UDim2.new(0, 16, 0, y)
    s.BackgroundTransparency = 1
    s.Text = txt
    s.TextColor3 = Color3.fromRGB(210,210,210)
    s.Font = Enum.Font.Gotham
    s.TextSize = 13
    s.TextXAlignment = Enum.TextXAlignment.Left
    return s
end
local function InputWithOK(txt, y, val, cb)
    local label = Instance.new("TextLabel", scroll)
    label.Size = UDim2.new(0, 95, 0, 20)
    label.Position = UDim2.new(0, 12, 0, y)
    label.BackgroundTransparency = 1
    label.Text = txt..":"
    label.TextColor3 = Color3.fromRGB(210,210,210)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", scroll)
    box.Size = UDim2.new(0, 110, 0, 20)
    box.Position = UDim2.new(0, 98, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(60,60,100)
    box.TextColor3 = Color3.new(1,1,1)
    box.Text = val
    box.PlaceholderText = ""
    box.TextSize = 13
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false

    local ok = Instance.new("TextButton", scroll)
    ok.Size = UDim2.new(0, 28, 0, 20)
    ok.Position = UDim2.new(0, 212, 0, y)
    ok.BackgroundColor3 = Color3.fromRGB(120,180,80)
    ok.Text = "OK"
    ok.Font = Enum.Font.GothamBold
    ok.TextColor3 = Color3.fromRGB(255,255,255)
    ok.TextSize = 12

    local check = Instance.new("TextLabel", scroll)
    check.Size = UDim2.new(0, 18, 0, 20)
    check.Position = UDim2.new(0, 242, 0, y)
    check.BackgroundTransparency = 1
    check.Text = ""
    check.TextColor3 = Color3.fromRGB(100,220,100)
    check.Font = Enum.Font.GothamBold
    check.TextSize = 16

    ok.MouseButton1Click:Connect(function()
        cb(box.Text)
        check.Text = "✔"
        saveConfig()
        wait(1.1)
        check.Text = ""
    end)
    return box
end

-- Panel Layout & Functionality
local y = 12
Section("Identity", y)
SubLabel("Hanya visual device-mu", y+18)
local fakeNameBox = InputWithOK("DisplayName", y+34, config.displayname, function(v) config.displayname = v; LocalPlayer.DisplayName = v end)
local fakeUserBox = InputWithOK("Username", y+60, config.username, function(v) config.username = v; LocalPlayer.Name = v end)

y = y + 95
Section("Movement", y)
local wsBox = InputWithOK("WalkSpeed", y+22, tostring(config.walkspeed), function(v)
    local num = tonumber(v)
    if num and num >= 5 and num <= 100 then config.walkspeed = num end
end)
game:GetService("RunService").Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = config.walkspeed
    end
end)

y = y + 54
Section("Combat", y)
local rangeBox = InputWithOK("Range", y+22, tostring(config.range), function(v)
    local num = tonumber(v)
    if num and num >= 1 and num <= 25 then config.range = num end
end)
-- AutoAttack Fast
spawn(function()
    while true do 
        wait(0.033)
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
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
        local parts = getPartsInViewport(config.range)
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

y = y + 54
Section("Server Tools", y)
local copyJob = Instance.new("TextButton", scroll)
copyJob.Size = UDim2.new(0, 120, 0, 22)
copyJob.Position = UDim2.new(0, 12, 0, y+24)
copyJob.BackgroundColor3 = Color3.fromRGB(70,140,210)
copyJob.Text = "Copy JobId"
copyJob.Font = Enum.Font.Gotham
copyJob.TextColor3 = Color3.new(1,1,1)
copyJob.TextSize = 14
local copyJobCheck = Instance.new("TextLabel", scroll)
copyJobCheck.Size = UDim2.new(0, 19, 0, 22)
copyJobCheck.Position = UDim2.new(0, 136, 0, y+24)
copyJobCheck.BackgroundTransparency = 1
copyJobCheck.Text = ""
copyJobCheck.TextColor3 = Color3.fromRGB(100,220,100)
copyJobCheck.Font = Enum.Font.GothamBold
copyJobCheck.TextSize = 16
copyJob.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        copyJobCheck.Text = "✔"
        wait(1)
        copyJobCheck.Text = ""
    end
end)

local joinJobBox = Instance.new("TextBox", scroll)
joinJobBox.Size = UDim2.new(0, 100, 0, 22)
joinJobBox.Position = UDim2.new(0, 160, 0, y+24)
joinJobBox.BackgroundColor3 = Color3.fromRGB(60,60,100)
joinJobBox.TextColor3 = Color3.new(1,1,1)
joinJobBox.PlaceholderText = "Paste JobId"
joinJobBox.TextSize = 13
joinJobBox.Font = Enum.Font.Gotham
joinJobBox.ClearTextOnFocus = false
local joinJobBtn = Instance.new("TextButton", scroll)
joinJobBtn.Size = UDim2.new(0, 42, 0, 22)
joinJobBtn.Position = UDim2.new(0, 264, 0, y+24)
joinJobBtn.BackgroundColor3 = Color3.fromRGB(120,180,80)
joinJobBtn.Text = "JOIN"
joinJobBtn.Font = Enum.Font.GothamBold
joinJobBtn.TextColor3 = Color3.fromRGB(255,255,255)
joinJobBtn.TextSize = 13
joinJobBtn.MouseButton1Click:Connect(function()
    local jobid = joinJobBox.Text
    if #jobid > 10 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobid, LocalPlayer)
    end
end)

-- Copy Roblox Join Link
local copyRbxLink = Instance.new("TextButton", scroll)
copyRbxLink.Size = UDim2.new(0, 148, 0, 22)
copyRbxLink.Position = UDim2.new(0, 12, 0, y+52)
copyRbxLink.BackgroundColor3 = Color3.fromRGB(100,120,210)
copyRbxLink.Text = "Copy Roblox Join Link"
copyRbxLink.Font = Enum.Font.Gotham
copyRbxLink.TextColor3 = Color3.new(1,1,1)
copyRbxLink.TextSize = 14
local copyRbxLinkCheck = Instance.new("TextLabel", scroll)
copyRbxLinkCheck.Size = UDim2.new(0, 19, 0, 22)
copyRbxLinkCheck.Position = UDim2.new(0, 164, 0, y+52)
copyRbxLinkCheck.BackgroundTransparency = 1
copyRbxLinkCheck.Text = ""
copyRbxLinkCheck.TextColor3 = Color3.fromRGB(100,220,100)
copyRbxLinkCheck.Font = Enum.Font.GothamBold
copyRbxLinkCheck.TextSize = 16
copyRbxLink.MouseButton1Click:Connect(function()
    local placeId = tostring(game.PlaceId)
    local gameId = tostring(game.GameId)
    local jobId = tostring(game.JobId)
    local robloxJoinLink = ("roblox://experiences/start?placeId=%s&gameId=%s&jobId=%s"):format(placeId, gameId, jobId)
    if setclipboard then
        setclipboard(robloxJoinLink)
        copyRbxLinkCheck.Text = "✔"
        wait(1)
        copyRbxLinkCheck.Text = ""
    end
end)

-- Copy Synergy Joiner Link
local copyWebLink = Instance.new("TextButton", scroll)
copyWebLink.Size = UDim2.new(0, 148, 0, 22)
copyWebLink.Position = UDim2.new(0, 12, 0, y+80)
copyWebLink.BackgroundColor3 = Color3.fromRGB(110, 165, 180)
copyWebLink.Text = "Copy Web Joiner Link"
copyWebLink.Font = Enum.Font.Gotham
copyWebLink.TextColor3 = Color3.new(1,1,1)
copyWebLink.TextSize = 14
local copyWebLinkCheck = Instance.new("TextLabel", scroll)
copyWebLinkCheck.Size = UDim2.new(0, 19, 0, 22)
copyWebLinkCheck.Position = UDim2.new(0, 164, 0, y+80)
copyWebLinkCheck.BackgroundTransparency = 1
copyWebLinkCheck.Text = ""
copyWebLinkCheck.TextColor3 = Color3.fromRGB(100,220,100)
copyWebLinkCheck.Font = Enum.Font.GothamBold
copyWebLinkCheck.TextSize = 16
copyWebLink.MouseButton1Click:Connect(function()
    local placeId = tostring(game.PlaceId)
    local jobId = tostring(game.JobId)
    local webJoinerLink = ("https://synergy.eu.pythonanywhere.com/joiner?PlaceId=%s&ServerId=%s"):format(placeId, jobId)
    if setclipboard then
        setclipboard(webJoinerLink)
        copyWebLinkCheck.Text = "✔"
        wait(1)
        copyWebLinkCheck.Text = ""
    end
end)

-- Copy all join links
local copyAllLink = Instance.new("TextButton", scroll)
copyAllLink.Size = UDim2.new(0, 200, 0, 22)
copyAllLink.Position = UDim2.new(0, 12, 0, y+108)
copyAllLink.BackgroundColor3 = Color3.fromRGB(120,160,220)
copyAllLink.Text = "Copy All Server Join Link"
copyAllLink.Font = Enum.Font.GothamBold
copyAllLink.TextColor3 = Color3.new(1,1,1)
copyAllLink.TextSize = 14
copyAllLink.MouseButton1Click:Connect(function()
    local placeId = tostring(game.PlaceId)
    local gameId = tostring(game.GameId)
    local jobId = tostring(game.JobId)
    local robloxJoinLink = ("roblox://experiences/start?placeId=%s&gameId=%s&jobId=%s"):format(placeId, gameId, jobId)
    local webJoinerLink = ("https://synergy.eu.pythonanywhere.com/joiner?PlaceId=%s&ServerId=%s"):format(placeId, jobId)
    local text = "Roblox Join Link (copy-paste ke address bar browser):\n" .. robloxJoinLink .. "\n\n"
        .. "Synergy Joiner Link (untuk web joiner):\n" .. webJoinerLink
    if setclipboard then
        setclipboard(text)
        copyAllLink.Text = "Copied!"
        wait(1.5)
        copyAllLink.Text = "Copy All Server Join Link"
    end
end)

-- Leave game button
local leaveBtn = Instance.new("TextButton", scroll)
leaveBtn.Size = UDim2.new(0, 94, 0, 22)
leaveBtn.Position = UDim2.new(0, 160, 0, y+52)
leaveBtn.BackgroundColor3 = Color3.fromRGB(210,80,80)
leaveBtn.Text = "Leave"
leaveBtn.Font = Enum.Font.GothamBold
leaveBtn.TextColor3 = Color3.new(1,1,1)
leaveBtn.TextSize = 15
leaveBtn.MouseButton1Click:Connect(function()
    Players.LocalPlayer:Kick("Left by Takawa Panel")
end)

-- Pindah ke server paling sepi
local emptyBtn = Instance.new("TextButton", scroll)
emptyBtn.Size = UDim2.new(0, 210, 0, 24)
emptyBtn.Position = UDim2.new(0, 12, 0, y+136)
emptyBtn.BackgroundColor3 = Color3.fromRGB(80,160,210)
emptyBtn.Text = "Pindah Ke Server Paling Sepi"
emptyBtn.Font = Enum.Font.GothamBold
emptyBtn.TextColor3 = Color3.new(1,1,1)
emptyBtn.TextSize = 14
emptyBtn.MouseButton1Click:Connect(function()
    local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
    local minPlayers, bestJobId = 100, nil
    local suc, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if suc and res and res.data then
        for _,v in pairs(res.data) do
            if v.playing < minPlayers and v.id ~= game.JobId and v.playing > 0 then
                minPlayers = v.playing
                bestJobId = v.id
            end
        end
    end
    if bestJobId then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, bestJobId, Players.LocalPlayer)
    end
end)

-- Proteksi Points Saat Mati
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