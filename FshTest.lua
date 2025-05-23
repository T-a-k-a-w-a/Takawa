-- Fisch Suite All-in-One (Full UI + Logic, No Split, No Delay Release)
-- GitHub Copilot Chat Assistant - 2025

-- Clean Up Old
pcall(function() 
    if game.CoreGui:FindFirstChild("FischSuitePanel") then game.CoreGui.FischSuitePanel:Destroy() end 
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("FischSuitePanel") then game.Players.LocalPlayer.PlayerGui.FischSuitePanel:Destroy() end
end)

-- Safe Attach GUI
local function safeAttachGui(gui)
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

local FischUI = Instance.new("ScreenGui")
FischUI.Name = "FischSuitePanel"
FischUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FischUI.ResetOnSpawn = false
FischUI.IgnoreGuiInset = true
safeAttachGui(FischUI)

-- Responsive
local function getScreen()
    return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900,600)
end
local function clampPanel()
    local s = getScreen()
    local pw = math.clamp(s.X * 0.92, 250, 400)
    local ph = math.clamp(s.Y * 0.82, 320, 520)
    local px = s.X - pw - 20
    local py = s.Y - ph - 68
    return pw, ph, px, py
end
local panelW, panelH, panelX, panelY = clampPanel()

-- === PANEL ===
local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = UDim2.new(0, panelW, 0, panelH)
Panel.Position = UDim2.new(0, panelX, 0, panelY)
Panel.BackgroundColor3 = Color3.fromRGB(245,245,245)
Panel.BackgroundTransparency = 0.09
Panel.BorderSizePixel = 0
Panel.ClipsDescendants = true
Panel.Parent = FischUI
Panel.ZIndex = 10
Panel.Active = true
Panel.Draggable = true
local UICorner = Instance.new("UICorner", Panel)
UICorner.CornerRadius = UDim.new(0,16)

-- === MINIMIZE BTN ===
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Parent = Panel
MinBtn.Text = "–"
MinBtn.Size = UDim2.new(0,36,0,36)
MinBtn.Position = UDim2.new(1,-44,0,8)
MinBtn.BackgroundColor3 = Color3.fromRGB(235,235,235)
MinBtn.TextColor3 = Color3.fromRGB(80,80,80)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 26
MinBtn.ZIndex = 21
local UCM = Instance.new("UICorner", MinBtn)
UCM.CornerRadius = UDim.new(0,12)

-- === SHOW BTN (RIGHT BOTTOM) ===
local ShowBtn = Instance.new("TextButton")
ShowBtn.Name = "ShowBtn"
ShowBtn.Parent = FischUI
ShowBtn.Text = "Fisch Panel"
ShowBtn.Size = UDim2.new(0,110,0,36)
ShowBtn.AnchorPoint = Vector2.new(1,1)
ShowBtn.Position = UDim2.new(1,-18,1,-16)
ShowBtn.BackgroundColor3 = Color3.fromRGB(80,200,255)
ShowBtn.TextColor3 = Color3.fromRGB(255,255,255)
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.TextSize = 16
ShowBtn.Visible = false
ShowBtn.ZIndex = 99
local ucShow = Instance.new("UICorner",ShowBtn)
ucShow.CornerRadius = UDim.new(0,10)

MinBtn.MouseButton1Click:Connect(function()
    Panel.Visible = false
    ShowBtn.Visible = true
end)
ShowBtn.MouseButton1Click:Connect(function()
    Panel.Visible = true
    ShowBtn.Visible = false
end)

-- === NOTIFIKASI BAWAH KANAN ===
local TweenService = game:GetService("TweenService")
local function showNotif(txt)
    local notif = Instance.new("TextLabel")
    notif.Text = txt
    notif.Size = UDim2.new(0,260,0,38)
    notif.AnchorPoint = Vector2.new(1,1)
    notif.Position = UDim2.new(1,-24,1,-66)
    notif.BackgroundColor3 = Color3.fromRGB(255,255,255)
    notif.BackgroundTransparency = 0.16
    notif.TextColor3 = Color3.fromRGB(0,110,255)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 16
    notif.ClipsDescendants = true
    notif.ZIndex = 99
    notif.Parent = FischUI
    notif.TextStrokeTransparency = 0.82
    notif.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    notif.BorderSizePixel = 0
    notif.Visible = true
    local uc = Instance.new("UICorner", notif)
    uc.CornerRadius = UDim.new(0,12)
    TweenService:Create(notif, TweenInfo.new(0.13), {TextTransparency=0, BackgroundTransparency=0.16}):Play()
    task.spawn(function()
        wait(1.7)
        TweenService:Create(notif, TweenInfo.new(0.35), {TextTransparency=1, BackgroundTransparency=1}):Play()
        wait(0.4)
        notif:Destroy()
    end)
end

-- === UI STATE ===
local state = {
    autoCast = false,
    autoShake = false,
    autoReels = false,
    autoSell = false,
    espPlayer = false,
    spoofName = "",
    spoofUser = "",
}
local running = true

-- === LABEL TITLE ===
local title = Instance.new("TextLabel", Panel)
title.Size = UDim2.new(1,-32,0,36)
title.Position = UDim2.new(0,16,0,8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Fisch Suite"
title.TextColor3 = Color3.fromRGB(30,130,255)
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left

-- === TOGGLES/FITUR (UI + LOGIC SEKALIGUS) ===
local function createToggle(txt, ypos, var, onActive)
    local btn = Instance.new("TextButton", Panel)
    btn.Size = UDim2.new(0,180,0,34)
    btn.Position = UDim2.new(0,24,0,ypos)
    btn.Text = txt.." [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(220,80,80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.MouseButton1Click:Connect(function()
        state[var] = not state[var]
        btn.Text = txt.." ["..(state[var] and "ON" or "OFF").."]"
        btn.BackgroundColor3 = state[var] and Color3.fromRGB(80,220,120) or Color3.fromRGB(220,80,80)
        showNotif(txt.." "..(state[var] and "Aktif" or "Dimatikan"))
        if onActive then onActive(state[var]) end
    end)
    return btn
end

-- === LOGIC LOOP ===
spawn(function()
    while running do
        -- === AUTO CAST ===
        if state.autoCast then
            local rem = game.ReplicatedStorage:FindFirstChild("Cast") or game:GetService("ReplicatedStorage"):FindFirstChild("Cast")
            if rem and rem:IsA("RemoteEvent") then
                rem:FireServer()
                showNotif("Auto Cast!")
            end
            wait(0.7)
        else
            wait(0.1)
        end
        -- === AUTO SHAKE ===
        if state.autoShake then
            local rem = game.ReplicatedStorage:FindFirstChild("Shake") or game:GetService("ReplicatedStorage"):FindFirstChild("Shake")
            if rem and rem:IsA("RemoteEvent") then
                rem:FireServer()
                showNotif("Auto Shake!")
            end
            wait(0.7)
        end
        -- === AUTO REELS ===
        if state.autoReels then
            local rem = game.ReplicatedStorage:FindFirstChild("Reel") or game:GetService("ReplicatedStorage"):FindFirstChild("Reel")
            if rem and rem:IsA("RemoteEvent") then
                rem:FireServer("Bar")
                showNotif("Auto Reels!")
            end
            wait(0.8)
        end
        -- === AUTO SELL ===
        if state.autoSell then
            local rem = game.ReplicatedStorage:FindFirstChild("SellAll") or game:GetService("ReplicatedStorage"):FindFirstChild("SellAll")
            if rem and rem:IsA("RemoteEvent") then
                rem:FireServer()
                showNotif("Auto Sell!")
            end
            wait(2.5)
        end
        -- === ESP Player ===
        if state.espPlayer then
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character and not plr.Character:FindFirstChild("FischESP") then
                    local bb = Instance.new("BillboardGui", plr.Character)
                    bb.Name = "FischESP"
                    bb.Size = UDim2.new(0,120,0,30)
                    bb.Adornee = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChildWhichIsA("BasePart")
                    bb.AlwaysOnTop = true
                    local t = Instance.new("TextLabel", bb)
                    t.Size = UDim2.new(1,0,1,0)
                    t.BackgroundTransparency = 1
                    t.Text = plr.DisplayName
                    t.TextColor3 = Color3.fromRGB(30,130,255)
                    t.TextStrokeTransparency = 0.7
                    t.Font = Enum.Font.GothamBold
                    t.TextScaled = true
                end
            end
        else
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("FischESP") then
                    plr.Character.FischESP:Destroy()
                end
            end
        end
        wait(0.3)
    end
end)

-- === UI BUILDER ===
local ypos = 48
local btnCast = createToggle("Auto Cast", ypos, "autoCast") ypos = ypos+44
local btnShake = createToggle("Auto Shake", ypos, "autoShake") ypos = ypos+44
local btnReels = createToggle("Auto Reels", ypos, "autoReels") ypos = ypos+44
local btnSell = createToggle("Auto Sell", ypos, "autoSell") ypos = ypos+44
local btnESP = createToggle("ESP Player", ypos, "espPlayer") ypos = ypos+44

-- === Teleport Buttons ===
local function createTeleBtn(txt, ypos, pos)
    local btn = Instance.new("TextButton", Panel)
    btn.Size = UDim2.new(0,180,0,34)
    btn.Position = UDim2.new(0,220,0,ypos)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(0,180,255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.MouseButton1Click:Connect(function()
        local char = game.Players.LocalPlayer.Character
        if char then char:MoveTo(pos) showNotif("Teleport ke "..txt) end
    end)
end
createTeleBtn("Mosewood", 48, Vector3.new(120,15,350))
createTeleBtn("Terrapin", 92, Vector3.new(360,17,640))
createTeleBtn("Roslit", 136, Vector3.new(-480,12,-180))

-- === Spoof Name/Username ===
local spoofNameBox = Instance.new("TextBox", Panel)
spoofNameBox.Size = UDim2.new(0,140,0,30)
spoofNameBox.Position = UDim2.new(0,26,0,panelH-70)
spoofNameBox.PlaceholderText = "Spoof Display Name"
spoofNameBox.Font = Enum.Font.Gotham
spoofNameBox.TextSize = 14
spoofNameBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
spoofNameBox.TextColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", spoofNameBox).CornerRadius = UDim.new(0,8)
spoofNameBox.FocusLost:Connect(function()
    state.spoofName = spoofNameBox.Text
    local lp = game.Players.LocalPlayer
    pcall(function() lp.DisplayName = state.spoofName end)
    showNotif("Nama diganti ke "..state.spoofName)
end)

local spoofUserBox = Instance.new("TextBox", Panel)
spoofUserBox.Size = UDim2.new(0,140,0,30)
spoofUserBox.Position = UDim2.new(0,180,0,panelH-70)
spoofUserBox.PlaceholderText = "Spoof Username"
spoofUserBox.Font = Enum.Font.Gotham
spoofUserBox.TextSize = 14
spoofUserBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
spoofUserBox.TextColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", spoofUserBox).CornerRadius = UDim.new(0,8)
spoofUserBox.FocusLost:Connect(function()
    state.spoofUser = spoofUserBox.Text
    local lp = game.Players.LocalPlayer
    pcall(function() lp.Name = state.spoofUser end)
    showNotif("Username diganti ke "..state.spoofUser)
end)

-- === Drag Clamp (panel tidak keluar layar) ===
local dragging, dragInput, dragStart, startPos
Panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Panel.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local s = getScreen()
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, s.X - Panel.AbsoluteSize.X)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, s.Y - Panel.AbsoluteSize.Y)
        Panel.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- === Responsive Resize ===
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        panelW, panelH, panelX, panelY = clampPanel()
        Panel.Size = UDim2.new(0, panelW, 0, panelH)
        Panel.Position = UDim2.new(0, panelX, 0, panelY)
        ShowBtn.Position = UDim2.new(1,-18,1,-16)
        spoofNameBox.Position = UDim2.new(0,26,0,panelH-70)
        spoofUserBox.Position = UDim2.new(0,180,0,panelH-70)
    end)
end

-- === NOTIFIKASI EVENT BOSS (Contoh Spawn) ===
game:GetService("Workspace").ChildAdded:Connect(function(child)
    if tostring(child.Name):lower():find("isonade") then showNotif("Isonade telah Spawn!") end
    if tostring(child.Name):lower():find("depth") or tostring(child.Name):lower():find("serpent") then showNotif("The Depth Serpent telah Spawn!") end
end)

showNotif("Fisch Suite Panel Siap!")

-- === STOP ON UNLOAD ===
FischUI.AncestryChanged:Connect(function(_,par) if not par then running = false end end)
