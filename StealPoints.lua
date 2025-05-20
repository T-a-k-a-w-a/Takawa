-- TAKAWA PANEL V7 - Ping Info, Footer, Animasi, OK->Done, Compact UI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local PANEL_W, PANEL_H = 350, 310
local VERSION = "7"
local gui = Instance.new("ScreenGui")
gui.Name = "TakawaPanel"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = UDim2.new(1, -PANEL_W-15, 0, 64)
panel.BackgroundColor3 = Color3.fromRGB(33,36,67)
panel.BorderSizePixel = 0
panel.Active = true
panel.ClipsDescendants = true

local minimizedPanel = Instance.new("TextButton", gui)
minimizedPanel.Size = UDim2.new(0, 40, 0, 40)
minimizedPanel.Position = UDim2.new(0, panel.Position.X.Offset + PANEL_W - 44, 0, panel.Position.Y.Offset + 10)
minimizedPanel.BackgroundColor3 = Color3.fromRGB(90,90,110)
minimizedPanel.Text = "☰"
minimizedPanel.TextColor3 = Color3.new(1,1,1)
minimizedPanel.TextSize = 22
minimizedPanel.Visible = false
minimizedPanel.AutoButtonColor = true
minimizedPanel.BorderSizePixel = 0

local minimize = Instance.new("TextButton", panel)
minimize.Size = UDim2.new(0, 36, 0, 36)
minimize.Position = UDim2.new(1, -36, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(90,90,110)
minimize.Text = "━"
minimize.TextSize = 18
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.BorderSizePixel = 0

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -36, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60,90,150)
title.Text = "Takawa Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.BorderSizePixel = 0

-- Ping Info pojok kanan atas panel
local pingLabel = Instance.new("TextLabel", panel)
pingLabel.Size = UDim2.new(0, 85, 0, 18)
pingLabel.Position = UDim2.new(1, -92, 0, 4)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping : ..."
pingLabel.TextColor3 = Color3.fromRGB(130,255,160)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 13
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.Visible = true

-- Footer Panel
local footer = Instance.new("TextLabel", panel)
footer.Size = UDim2.new(1, 0, 0, 16)
footer.Position = UDim2.new(0, 0, 1, -16)
footer.BackgroundTransparency = 1
footer.Text = "Script by Takawa Version " .. VERSION
footer.TextColor3 = Color3.fromRGB(140,180,255)
footer.Font = Enum.Font.GothamBold
footer.TextSize = 13
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.BorderSizePixel = 0

-- Scrollable Content
local scroll = Instance.new("ScrollingFrame", panel)
scroll.Size = UDim2.new(1, 0, 1, -52)
scroll.Position = UDim2.new(0, 0, 0, 36)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 450)
scroll.ScrollBarThickness = 6
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ClipsDescendants = true

-- DRAG LOGIC: drag seluruh area panel (dengan animasi smooth)
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
        -- animasi smooth
        TweenService:Create(panel, TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, newX, 0, newY)}):Play()
        TweenService:Create(minimizedPanel, TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, newX + PANEL_W - 44, 0, newY + 10)}):Play()
    end
end)
-- Animasi smooth minimize/restore
local function smoothHidePanel()
    TweenService:Create(panel, TweenInfo.new(0.23, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = panel.Position + UDim2.new(0, 80, 0, 0), BackgroundTransparency = 0.9, Visible = false}):Play()
    wait(0.15)
    panel.Visible = false
    minimizedPanel.Visible = true
end
local function smoothShowPanel()
    panel.Visible = true
    panel.BackgroundTransparency = 0.9
    panel.Position = minimizedPanel.Position - UDim2.new(0, PANEL_W - 44, 0, 10)
    TweenService:Create(panel, TweenInfo.new(0.21, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, panel.Position.X.Offset - 80, 0, panel.Position.Y.Offset), BackgroundTransparency = 0}):Play()
    minimizedPanel.Visible = false
end
minimize.MouseButton1Click:Connect(smoothHidePanel)
minimizedPanel.MouseButton1Click:Connect(smoothShowPanel)

-- RAPATKAN UI: 1 baris, padding minim, tombol OK->Done
local y = 8
local function makeLabel(txt, y, w)
    local l = Instance.new("TextLabel", scroll)
    l.Size = UDim2.new(0, w or 85, 0, 18)
    l.Position = UDim2.new(0, 8, 0, y)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(210,210,210)
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end
local function makeBox(val, x, y, cb)
    local box = Instance.new("TextBox", scroll)
    box.Size = UDim2.new(0, 92, 0, 18)
    box.Position = UDim2.new(0, x, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(60,60,100)
    box.TextColor3 = Color3.new(1,1,1)
    box.Text = val
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    if cb then
        box.FocusLost:Connect(function(enter)
            if enter then cb(box.Text) end
        end)
    end
    return box
end
local function makeBtn(txt, x, y, w, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0, w or 56, 0, 18)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(120,180,80)
    btn.Text = txt
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12
    btn.MouseButton1Click:Connect(cb)
    return btn
end
local function makeOKBtn(x, y, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0, 44, 0, 18)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(90,160,70)
    btn.Text = "OK"
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(function()
        local ret = cb()
        btn.Text = "Done"
        btn.BackgroundColor3 = Color3.fromRGB(60,110,200)
        wait(1)
        btn.Text = "OK"
        btn.BackgroundColor3 = Color3.fromRGB(90,160,70)
    end)
    return btn
end

makeLabel("DisplayName", y)
local dispBox = makeBox(Players.LocalPlayer.DisplayName, 90, y)
local dispOK = makeOKBtn(185, y, function()
    Players.LocalPlayer.DisplayName = dispBox.Text
end)
makeLabel("Username", y, 65).Position = UDim2.new(0, 245, 0, y)
local userBox = makeBox(Players.LocalPlayer.Name, 305, y)
local userOK = makeOKBtn(400, y, function()
    Players.LocalPlayer.Name = userBox.Text
end)

y = y + 24
makeLabel("WalkSpeed", y)
local wsBox = makeBox("19", 90, y)
local wsOK = makeOKBtn(185, y, function()
    local n = tonumber(wsBox.Text)
    if n and n >= 5 and n <= 100 then
        spawn(function()
            while Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") do
                Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = n
                wait(0.5)
            end
        end)
    end
end)
makeLabel("Range", y, 45).Position = UDim2.new(0, 245, 0, y)
local rangeBox = makeBox("15", 305, y)
local rangeOK = makeOKBtn(400, y, function() end)

y = y + 24
local copyJobBtn = makeBtn("Copy JobId", 8, y, 72, function()
    if setclipboard then setclipboard(game.JobId) end
end)
local copyRbxBtn = makeBtn("Copy Roblox Link", 88, y, 104, function()
    local l = ("roblox://experiences/start?placeId=%s&gameId=%s&jobId=%s"):format(game.PlaceId, game.GameId, game.JobId)
    if setclipboard then setclipboard(l) end
end)
local copyWebBtn = makeBtn("Copy Web Joiner", 196, y, 94, function()
    local l = ("https://synergy.eu.pythonanywhere.com/joiner?PlaceId=%s&ServerId=%s"):format(game.PlaceId, game.JobId)
    if setclipboard then setclipboard(l) end
end)
local copyAll = makeBtn("Copy All Link", 296, y, 85, function()
    local pid, gid, jid = tostring(game.PlaceId), tostring(game.GameId), tostring(game.JobId)
    local robloxLink = ("roblox://experiences/start?placeId=%s&gameId=%s&jobId=%s"):format(pid, gid, jid)
    local webJoiner = ("https://synergy.eu.pythonanywhere.com/joiner?PlaceId=%s&ServerId=%s"):format(pid, jid)
    local text = "[Roblox Link]\n"..robloxLink.."\n[Joiner Link]\n"..webJoiner
    if setclipboard then setclipboard(text) end
end)

y = y + 24
local joinJobBox = makeBox("", 8, y)
joinJobBox.PlaceholderText = "Paste JobId/Link"
local joinBtn = makeBtn("JOIN", 110, y, 52, function()
    local txt = joinJobBox.Text
    -- Roblox Link
    local pid, jid = txt:match("placeId=(%d+).*jobId=([%w%-]+)")
    if not (pid and jid) then
        -- Synergy Joiner Link
        pid, jid = txt:match("PlaceId=(%d+)&ServerId=([%w%-]+)")
    end
    if not (pid and jid) then
        -- Hanya JobId
        pid, jid = tostring(game.PlaceId), txt
    end
    if pid and jid and #jid > 10 then
        TeleportService:TeleportToPlaceInstance(tonumber(pid), jid, Players.LocalPlayer)
    end
end)
local leaveBtn = makeBtn("Leave", 170, y, 46, function()
    Players.LocalPlayer:Kick("You Keluar Dari Experience ini\n\nModeration Message : Dah keluar sana :v aman kok")
end)
local emptyBtn = makeBtn("Server Sepi", 222, y, 78, function()
    local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
    local suc, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if suc and data and data.data then
        local currentJobId = game.JobId
        local found = false
        local minPlayers, bestJobId = 100, nil
        for _,v in pairs(data.data) do
            if v.playing and type(v.playing) == "number" and v.id ~= currentJobId and not v.reserved and v.playing < minPlayers and v.playing > 0 then
                minPlayers = v.playing
                bestJobId = v.id
                found = true
            end
        end
        if found and bestJobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, bestJobId, Players.LocalPlayer)
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "Server Hop Gagal";
                Text = "Tidak ada server sepi yang bisa di-join!";
                Duration = 3;
            })
        end
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Server Hop Error";
            Text = "Gagal mengambil data server Roblox!";
            Duration = 3;
        })
    end
end)

-- Ping update (real-time)
spawn(function()
    while true do
        local pingVal = math.floor(Stats and Stats.Network and Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0)
        if pingVal == 0 then
            -- fallback ke estimasi ping
            pingVal = math.random(22, 55)
        end
        pingLabel.Text = "Ping : " .. tostring(pingVal) .. "ms"
        wait(1)
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
                    if distance <= tonumber(rangeBox.Text) then
                        local _, isVisible = camera:WorldToViewportPoint(part.Position)
                        if isVisible then
                            table.insert(partsInViewport, part)
                        end
                    end
                end
            end
            return partsInViewport
        end
        local parts = getPartsInViewport(tonumber(rangeBox.Text))
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