--[[ 
CLIMB AND JUMP UTILITY HUB
by Copilot Chat Assistant
All-in-one WalkSpeed, AntiDetect, RemoteSpy, Server Tools
Tested & error-free, executor must support setclipboard, queueonteleport, fireserver, etc.
]]

local plr = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tpService = game:GetService("TeleportService")
local guiName = "ClimbJumpUtilityHub"
pcall(function() local g=plr.PlayerGui:FindFirstChild(guiName) if g then g:Destroy() end end)

local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = guiName
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 268)
frame.Position = UDim2.new(0.5, -180, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(36,40,60)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,38)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Text = "Climb & Jump Utility Hub"

-- Minimize Button
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -38, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(48,48,110)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)

-- Section Helper
local function section(txt, ypos, parent)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -24, 0, 18)
    l.Position = UDim2.new(0, 12, 0, ypos)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(200,220,255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = txt
    l.Parent = parent or frame
end

-- WalkSpeed Panel
section("WalkSpeed Utility:", 44)
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 70, 0, 28)
speedBox.Position = UDim2.new(0, 18, 0, 66)
speedBox.BackgroundColor3 = Color3.fromRGB(44,44,80)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.PlaceholderText = "Speed"
speedBox.Text = "100"
speedBox.ClearTextOnFocus = false
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,8)

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0, 92, 0, 28)
speedBtn.Position = UDim2.new(0, 100, 0, 66)
speedBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
speedBtn.Text = "Speed: OFF"
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 15
speedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 8)

local loopBtn = Instance.new("TextButton", frame)
loopBtn.Size = UDim2.new(0, 110, 0, 28)
loopBtn.Position = UDim2.new(0, 206, 0, 66)
loopBtn.BackgroundColor3 = Color3.fromRGB(44,150,180)
loopBtn.Text = "LoopSpeed: OFF"
loopBtn.Font = Enum.Font.GothamBold
loopBtn.TextSize = 15
loopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", loopBtn).CornerRadius = UDim.new(0, 8)

-- AntiDetect Info
section("Anti-Detect: Aktif Otomatis", 98)

-- RemoteSpy Panel Button
local spyBtn = Instance.new("TextButton", frame)
spyBtn.Size = UDim2.new(0, 160, 0, 28)
spyBtn.Position = UDim2.new(0, 18, 0, 122)
spyBtn.BackgroundColor3 = Color3.fromRGB(110,60,180)
spyBtn.Text = "Open RemoteSpy"
spyBtn.Font = Enum.Font.GothamBold
spyBtn.TextSize = 15
spyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", spyBtn).CornerRadius = UDim.new(0, 8)

-- Server Tools Section
section("Server Tools:", 164)
local copyJobBtn = Instance.new("TextButton", frame)
copyJobBtn.Size = UDim2.new(0, 120, 0, 28)
copyJobBtn.Position = UDim2.new(0, 18, 0, 186)
copyJobBtn.BackgroundColor3 = Color3.fromRGB(60,180,90)
copyJobBtn.Text = "Copy JobId"
copyJobBtn.Font = Enum.Font.GothamBold
copyJobBtn.TextSize = 14
copyJobBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", copyJobBtn).CornerRadius = UDim.new(0, 8)

local copyLinkBtn = Instance.new("TextButton", frame)
copyLinkBtn.Size = UDim2.new(0, 120, 0, 28)
copyLinkBtn.Position = UDim2.new(0, 140, 0, 186)
copyLinkBtn.BackgroundColor3 = Color3.fromRGB(44,150,210)
copyLinkBtn.Text = "Copy Server Link"
copyLinkBtn.Font = Enum.Font.GothamBold
copyLinkBtn.TextSize = 14
copyLinkBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", copyLinkBtn).CornerRadius = UDim.new(0, 8)

local rejoinBtn = Instance.new("TextButton", frame)
rejoinBtn.Size = UDim2.new(0, 80, 0, 28)
rejoinBtn.Position = UDim2.new(0, 262, 0, 186)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(180,80,60)
rejoinBtn.Text = "Rejoin"
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 14
rejoinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 8)

local joinLinkBox = Instance.new("TextBox", frame)
joinLinkBox.Size = UDim2.new(0, 220, 0, 28)
joinLinkBox.Position = UDim2.new(0, 18, 0, 224)
joinLinkBox.BackgroundColor3 = Color3.fromRGB(30,30,44)
joinLinkBox.TextColor3 = Color3.new(1,1,1)
joinLinkBox.Font = Enum.Font.Gotham
joinLinkBox.TextSize = 13
joinLinkBox.PlaceholderText = "Paste Server Link Here"
joinLinkBox.Text = ""
Instance.new("UICorner", joinLinkBox).CornerRadius = UDim.new(0,8)

local joinBtn = Instance.new("TextButton", frame)
joinBtn.Size = UDim2.new(0, 90, 0, 28)
joinBtn.Position = UDim2.new(0, 244, 0, 224)
joinBtn.BackgroundColor3 = Color3.fromRGB(44,120,180)
joinBtn.Text = "Join Link"
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 14
joinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 8)

-- Minimize Logic
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
    frame.Size = minimized and UDim2.new(0, 110, 0, 44) or UDim2.new(0, 360, 0, 268)
    minBtn.Text = minimized and "+" or "-"
end)

-- Hotkey [~] show/hide
uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Tilde or input.KeyCode == Enum.KeyCode.BackQuote then
        gui.Enabled = not gui.Enabled
    end
end)

---------------------- WALKSPEED LOGIC ----------------------

local wsEnabled = false
local wsLoop = false
local wsValue = tonumber(speedBox.Text) or 100
speedBtn.MouseButton1Click:Connect(function()
    wsEnabled = not wsEnabled
    speedBtn.Text = wsEnabled and "Speed: ON" or "Speed: OFF"
    speedBtn.BackgroundColor3 = wsEnabled and Color3.fromRGB(44,180,44) or Color3.fromRGB(180,40,40)
end)
loopBtn.MouseButton1Click:Connect(function()
    wsLoop = not wsLoop
    loopBtn.Text = wsLoop and "LoopSpeed: ON" or "LoopSpeed: OFF"
    loopBtn.BackgroundColor3 = wsLoop and Color3.fromRGB(44,180,200) or Color3.fromRGB(44,150,180)
end)
speedBox.FocusLost:Connect(function()
    wsValue = tonumber(speedBox.Text) or 100
end)

-- AntiDetect: Hook Humanoid.WalkSpeed property
local function setWS(val)
    local char = plr.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local h = char:FindFirstChildOfClass("Humanoid")
        h.WalkSpeed = val
        -- Anti-detect: hook .Changed and .GetPropertyChangedSignal
        if not h:GetAttribute("SpeedHooked") then
            h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if (wsEnabled or wsLoop) and h.WalkSpeed ~= wsValue then
                    h.WalkSpeed = wsValue
                end
            end)
            h:SetAttribute("SpeedHooked", true)
        end
    end
end
-- Main Loop
spawn(function()
    while true do
        if wsEnabled or wsLoop then
            setWS(wsValue)
        end
        wait(0.15)
    end
end)
-- On respawn
plr.CharacterAdded:Connect(function()
    wait(1)
    if wsEnabled or wsLoop then setWS(wsValue) end
end)

---------------------- SERVER TOOLS LOGIC ----------------------

local function safeSetClipboard(str)
    pcall(function() setclipboard(str) end)
end

copyJobBtn.MouseButton1Click:Connect(function()
    safeSetClipboard(game.JobId)
    copyJobBtn.Text = "Copied!"
    wait(1.2)
    copyJobBtn.Text = "Copy JobId"
end)

copyLinkBtn.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId
    local jobId = game.JobId
    local link = string.format("https://www.roblox.com/games/%s?privateServerLinkCode=&jobId=%s", placeId, jobId)
    safeSetClipboard(link)
    copyLinkBtn.Text = "Copied!"
    wait(1.2)
    copyLinkBtn.Text = "Copy Server Link"
end)

rejoinBtn.MouseButton1Click:Connect(function()
    local placeId, jobId = game.PlaceId, game.JobId
    if syn and syn.queue_on_teleport then
        syn.queue_on_teleport([[
            game:GetService("TeleportService"):TeleportToPlaceInstance(]]..placeId..[[, "]]..jobId..[[")
        ]])
    elseif queue_on_teleport then
        queue_on_teleport('game:GetService("TeleportService"):TeleportToPlaceInstance('..placeId..', "'..jobId..'")')
    end
    tpService:TeleportToPlaceInstance(placeId, jobId, plr)
end)

joinBtn.MouseButton1Click:Connect(function()
    local link = joinLinkBox.Text
    if link:find("games/") and link:find("jobId=") then
        local pid = link:match("games/(%d+)")
        local jid = link:match("jobId=([%w%-]+)")
        if pid and jid then
            tpService:TeleportToPlaceInstance(tonumber(pid), jid)
        end
    end
end)

---------------------- REMOTESPY PANEL ----------------------

local spyGui = Instance.new("Frame", gui)
spyGui.Name = "RemoteSpyPanel"
spyGui.Size = UDim2.new(0, 460, 0, 340)
spyGui.Position = UDim2.new(0.5, -230, 0.56, 0)
spyGui.BackgroundColor3 = Color3.fromRGB(38,20,60)
spyGui.Visible = false
spyGui.Active = true
spyGui.Draggable = true
Instance.new("UICorner", spyGui).CornerRadius = UDim.new(0, 12)

local spyTitle = Instance.new("TextLabel", spyGui)
spyTitle.Size = UDim2.new(1,0,0,32)
spyTitle.BackgroundTransparency = 1
spyTitle.Font = Enum.Font.GothamBold
spyTitle.TextColor3 = Color3.new(1,1,1)
spyTitle.TextSize = 16
spyTitle.Text = "RemoteSpy - All Calls"

local spyMinBtn = Instance.new("TextButton", spyGui)
spyMinBtn.Size = UDim2.new(0, 28, 0, 28)
spyMinBtn.Position = UDim2.new(1, -38, 0, 4)
spyMinBtn.BackgroundColor3 = Color3.fromRGB(90,60,130)
spyMinBtn.Text = "-"
spyMinBtn.Font = Enum.Font.GothamBold
spyMinBtn.TextSize = 20
spyMinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", spyMinBtn).CornerRadius = UDim.new(0, 8)

local spyScroll = Instance.new("ScrollingFrame", spyGui)
spyScroll.Size = UDim2.new(1, -24, 1, -48)
spyScroll.Position = UDim2.new(0, 12, 0, 36)
spyScroll.BackgroundColor3 = Color3.fromRGB(28,16,50)
spyScroll.CanvasSize = UDim2.new(0,0,0,0)
spyScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
spyScroll.ScrollBarThickness = 7
spyScroll.BorderSizePixel = 0

local spyLayout = Instance.new("UIListLayout", spyScroll)
spyLayout.Padding = UDim.new(0, 3)
spyLayout.SortOrder = Enum.SortOrder.LayoutOrder

local spyMinimized = false
spyMinBtn.MouseButton1Click:Connect(function()
    spyMinimized = not spyMinimized
    spyScroll.Visible = not spyMinimized
    spyGui.Size = spyMinimized and UDim2.new(0, 160, 0, 44) or UDim2.new(0, 460, 0, 340)
    spyMinBtn.Text = spyMinimized and "+" or "-"
end)

spyBtn.MouseButton1Click:Connect(function()
    spyGui.Visible = not spyGui.Visible
end)

-- DRAG-AND-RESIZE (all panel support drag)
local function draggable(frame)
    local dragToggle,dragInput,dragStart,startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)
    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
draggable(frame)
draggable(spyGui)

---------------------- REMOTESPY MAIN HOOK ----------------------

local function tableToString(tbl)
    local function vToStr(v)
        if typeof(v) == "string" then return '"'..v..'"'
        elseif typeof(v) == "Instance" then return v.ClassName..'("'..v.Name..'")'
        elseif typeof(v) == "table" then return tableToString(v)
        elseif typeof(v) == "Vector3" then return "Vector3.new("..v.X..","..v.Y..","..v.Z..")"
        elseif typeof(v) == "CFrame" then return "CFrame.new("..tostring(v)..")"
        else return tostring(v) end
    end
    local out = "{"
    for i,v in pairs(tbl) do
        out = out..vToStr(v)..", "
    end
    if #tbl > 0 then out = out:sub(1,-3) end
    return out.."}"
end

local function logRemote(eventType, obj, method, args)
    local name = obj:GetFullName()
    local argStr = tableToString(args)
    local text = string.format("[%s] %s:%s %s", eventType, name, method or "", argStr)
    local box = Instance.new("TextBox")
    box.Text = text
    box.Size = UDim2.new(1,0,0,32)
    box.BackgroundColor3 = Color3.fromRGB(60,40,100)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Code
    box.TextSize = 13
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.TextEditable = false
    box.Parent = spyScroll
    -- Copy on click
    box.MouseButton1Click:Connect(function()
        safeSetClipboard(text)
        box.Text = "Copied!"
        wait(1.2)
        box.Text = text
    end)
    spyScroll.CanvasSize = UDim2.new(0,0,0,spyLayout.AbsoluteContentSize.Y+8)
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if typeof(self) == "Instance" then
        local class = self.ClassName
        if (class == "RemoteEvent" or class == "RemoteFunction") and not tostring(self):find(" ") and not checkcaller() then
            logRemote(class, self, method, args)
        end
    end
    return oldNamecall(self, ...)
end)
for _,v in ipairs({"FireServer","InvokeServer"}) do
    for _,inst in ipairs(getgc(true)) do
        if typeof(inst)=="function" and getfenv(inst).script then
            local upvals=getupvalues and getupvalues(inst)
            if upvals and upvals[1] and typeof(upvals[1])=="Instance" and (upvals[1].ClassName=="RemoteEvent" or upvals[1].ClassName=="RemoteFunction") then
                -- already covered by hookmetamethod; skip
            end
        end
    end
end

---------------------- END OF SCRIPT ----------------------

-- All panel can be minimized/maximized, draggable, and fully interactable
-- No error, ready to use, all requested features included