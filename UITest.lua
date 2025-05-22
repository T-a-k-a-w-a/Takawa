-- Fisch Utility Panel - All Logic & UI in One File
-- by Copilot Chat Assistant

-- Clean up jika sudah ada
pcall(function()
    local pgui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if pgui and pgui:FindFirstChild("FischPanel") then
        pgui.FischPanel:Destroy()
    end
end)

local plr = game.Players.LocalPlayer
local pgui = plr:WaitForChild("PlayerGui")
local Panel = Instance.new("ScreenGui")
Panel.Name = "FischPanel"
Panel.ResetOnSpawn = false
Panel.IgnoreGuiInset = true
Panel.Parent = pgui

-- Panel Transparan
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 440, 0, 350)
Main.Position = UDim2.new(0.08, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(24,30,45)
Main.BackgroundTransparency = 0.19
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0
Main.Parent = Panel
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Main.ClipsDescendants = true

-- TopBar (judul, minimize, close)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(41, 120, 255)
TopBar.BackgroundTransparency = 0.10
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Fisch Utility Panel"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.BackgroundTransparency = 0.1
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.AutoButtonColor = true
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -74, 0, 4)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
MinBtn.BackgroundTransparency = 0.13
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.AutoButtonColor = true
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 7)

-- Tab Bar
local TabBar = Instance.new("Frame", Main)
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 34)
TabBar.Position = UDim2.new(0, 0, 0, 38)
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0

local tabNames = {"Proteksi", "Spoof Data", "Movement", "Lainnya"}
local Tabs, TabFrames, CurrentTab = {}, {}, nil

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 105, 1, -8)
    btn.Position = UDim2.new(0, 16 + (i-1)*112, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(45, 55, 80)
    btn.BackgroundTransparency = 0.13
    btn.TextColor3 = Color3.fromRGB(200,220,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Text = name
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Tabs[name] = btn
end
for i, name in ipairs(tabNames) do
    local frame = Instance.new("ScrollingFrame", Main)
    frame.Name = "Tab_"..name
    frame.Position = UDim2.new(0, 0, 0, 72)
    frame.Size = UDim2.new(1, 0, 1, -76)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 8
    frame.CanvasSize = UDim2.new(0, 840, 0, 900)
    frame.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    frame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    frame.AutomaticCanvasSize = Enum.AutomaticSize.XY
    frame.Visible = false
    frame.ClipsDescendants = true
    local uil = Instance.new("UIListLayout", frame)
    uil.Padding = UDim.new(0, 9)
    uil.SortOrder = Enum.SortOrder.LayoutOrder
    uil.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabFrames[name] = frame
end
function SetTab(name)
    for n, btn in pairs(Tabs) do
        btn.BackgroundColor3 = (n == name) and Color3.fromRGB(41, 120, 255) or Color3.fromRGB(45, 55, 80)
        btn.TextColor3 = (n == name) and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,220,255)
    end
    for n, frame in pairs(TabFrames) do
        frame.Visible = (n == name)
    end
    CurrentTab = name
end
for n, btn in pairs(Tabs) do
    btn.MouseButton1Click:Connect(function() SetTab(n) end)
end
SetTab(tabNames[1])

-- UI Utility
function MakeLabel(tab, txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 24)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = 15
    l.TextWrapped = true
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(200,215,255)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = TabFrames[tab]
end
function MakeButton(tab, txt, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 180, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(41, 120, 255)
    b.BackgroundTransparency = 0.14
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.Text = txt
    b.TextWrapped = true
    b.AutoButtonColor = true
    b.Parent = TabFrames[tab]
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseButton1Click:Connect(callback)
    return b
end
function MakeBox(tab, txt, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 290, 0, 32)
    f.BackgroundTransparency = 1
    f.Parent = TabFrames[tab]
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(0.49,0,1,0)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.Gotham
    t.TextSize = 14
    t.TextColor3 = Color3.fromRGB(255,220,180)
    t.TextWrapped = true
    t.Text = txt
    t.TextXAlignment = Enum.TextXAlignment.Left
    local box = Instance.new("TextBox", f)
    box.Size = UDim2.new(0.41,0,1,0)
    box.Position = UDim2.new(0.49,0,0,0)
    box.BackgroundColor3 = Color3.fromRGB(60,60,90)
    box.BackgroundTransparency = 0.20
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.TextSize = 14
    box.Font = Enum.Font.Gotham
    box.PlaceholderText = txt
    box.Text = default or ""
    box.TextWrapped = false
    box.ClipsDescendants = true
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    local applyBtn = Instance.new("TextButton", f)
    applyBtn.Size = UDim2.new(0, 44, 0, 28)
    applyBtn.Position = UDim2.new(1, 10, 0, 2)
    applyBtn.BackgroundColor3 = Color3.fromRGB(41, 120, 255)
    applyBtn.BackgroundTransparency = 0.15
    applyBtn.Text = "OK"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 13
    applyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    applyBtn.AutoButtonColor = true
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6)
    applyBtn.MouseButton1Click:Connect(function()
        callback(box.Text)
    end)
    return box
end
function MakeToggle(tab, txt, state, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 180, 0, 32)
    f.BackgroundTransparency = 1
    f.Parent = TabFrames[tab]
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(0.62,0,1,0)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.Gotham
    t.TextSize = 14
    t.TextColor3 = Color3.fromRGB(220,220,255)
    t.Text = txt
    t.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.34,0,1,0)
    btn.Position = UDim2.new(0.66,0,0,0)
    btn.BackgroundColor3 = state and Color3.fromRGB(41,190,90) or Color3.fromRGB(60,60,90)
    btn.BackgroundTransparency = 0.19
    btn.Text = state and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(41,190,90) or Color3.fromRGB(60,60,90)
        callback(state)
    end)
    callback(state)
    return btn
end

-- State
local spoofName, spoofUser, spoofLvl, spoofMoney, spoofStreak = plr.DisplayName, plr.Name, 1, 0, 0
local noclip, float, invis = false, false, false

-- LOGIC
local function spoofStreakFunc(streak)
    spoofStreak = streak
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:lower():find("streak") then
            v.Text = "Streak: "..tostring(spoofStreak)
        end
    end
end
local function setInvisibleAll(state)
    invis = state
    -- Character
    if plr.Character then
        for _,v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = state and 1 or 0
                if v:FindFirstChildOfClass("Decal") then v:FindFirstChildOfClass("Decal").Transparency = state and 1 or 0 end
            elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
                v.Handle.Transparency = state and 1 or 0
            elseif v:IsA("TextLabel") or v:IsA("BillboardGui") then
                v.Visible = not state
            end
        end
    end
    -- Rod, Bobber, Line, Tag, Label, etc di Workspace
    for _,v in pairs(workspace:GetDescendants()) do
        local n = v.Name:lower()
        if n:find("rod") or n:find("bobber") or n:find("line") or n:find("string") or n:find("fishing") or n:find("tag") or n:find("label") or n:find("level") or n:find("streak") or n:find("passive") then
            if v:IsA("BasePart") then
                v.Transparency = state and 1 or 0
            elseif v:IsA("TextLabel") or v:IsA("BillboardGui") then
                v.Visible = not state
            end
        end
    end
end
local function spoofNameFunc(nama, user)
    spoofName = (nama and nama~="") and nama or plr.DisplayName
    spoofUser = (user and user~="") and user or plr.Name
    for _,v in pairs(game:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextBox")) and v.Text then
            v.Text = v.Text:gsub(plr.DisplayName, spoofName):gsub(plr.Name, spoofUser)
        end
    end
end
local function hideStreak()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:lower():find("streak") then
            v.Visible = false
        end
    end
end
game:GetService("RunService").Stepped:Connect(function()
    if noclip and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        for _,v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if float and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,20,0)
    end
end)
local function spoofLevelMoney(level, money)
    spoofLvl = tonumber(level) or spoofLvl
    spoofMoney = tonumber(money) or spoofMoney
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("TextLabel") then
            if v.Text:lower():find("level") then v.Text = "Level: "..spoofLvl end
            if v.Text:lower():find("money") or v.Text:lower():find("cash") or v.Text:lower():find("uang") then
                v.Text = "Money: "..spoofMoney
            end
        end
    end
end
-- Anti Chat & Spoof Nama di Chat
local ikan_keywords = {"legendary","mythic","exotic","mutasi","mutation","catfish","whiptail","trout","salmon","bass","shark","fish","ikan"}
local function containsIkanPesan(teks)
    local t = teks:lower()
    for _,w in ipairs(ikan_keywords) do
        if t:find(w) then return true end
    end
    return false
end
local function blockFishingChat()
    for _,obj in ipairs(getgc(true)) do
        if type(obj) == "function" and islclosure(obj) then
            local info = debug.getinfo(obj)
            if info.name and (info.name:lower():find("chat") or info.name:lower():find("system") or info.name:lower():find("announce") or info.name:lower():find("catch")) then
                hookfunction(obj, function(...)
                    local args = {...}
                    for i,v in ipairs(args) do
                        if type(v)=="string" and (v:find(plr.Name) or v:find(plr.DisplayName) or containsIkanPesan(v)) then
                            return -- block
                        end
                        if type(v)=="string" and (v:find(plr.Name) or v:find(plr.DisplayName)) then
                            args[i] = v:gsub(plr.Name, spoofName):gsub(plr.DisplayName, spoofName)
                        end
                    end
                    return obj(unpack(args))
                end)
            end
        end
    end
    -- Hook RemoteEvent/RemoteFunction
    for _,r in pairs(game:GetDescendants()) do
        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
            local old
            if r:IsA("RemoteEvent") then
                old = r.FireServer
                r.FireServer = function(self, ...)
                    local args = {...}
                    for i,v in ipairs(args) do
                        if type(v)=="string" and (v:find(plr.Name) or v:find(plr.DisplayName) or containsIkanPesan(v)) then
                            return -- block
                        end
                        if type(v)=="string" and (v:find(plr.Name) or v:find(plr.DisplayName)) then
                            args[i] = v:gsub(plr.Name, spoofName):gsub(plr.DisplayName, spoofName)
                        end
                    end
                    return old(self, unpack(args))
                end
            elseif r:IsA("RemoteFunction") then
                old = r.InvokeServer
                r.InvokeServer = function(self, ...)
                    local args = {...}
                    for i,v in ipairs(args) do
                        if type(v)=="string" and (v:find(plr.Name) or v:find(plr.DisplayName) or containsIkanPesan(v)) then
                            return -- block
                        end
                        if type(v)=="string" and (v:find(plr.Name) or v:find(plr.DisplayName)) then
                            args[i] = v:gsub(plr.Name, spoofName):gsub(plr.DisplayName, spoofName)
                        end
                    end
                    return old(self, unpack(args))
                end
            end
        end
    end
end
local MOD_LIST = {"mod","staff","admin","manager","dev","owner"}
local function checkStaff(p)
    local n = p.Name:lower()
    local d = (p.DisplayName and p.DisplayName:lower()) or ""
    for _,w in ipairs(MOD_LIST) do
        if n:find(w) or d:find(w) then return true end
    end
    return false
end
local function notifyStaff(name)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "!! STAFF/MODERATOR ALERT !!",
        Text = name.." MASUK SERVER!\nSembunyi atau keluar sekarang!",
        Duration = 9
    })
end
game.Players.PlayerAdded:Connect(function(p)
    if checkStaff(p) then
        notifyStaff(p.DisplayName or p.Name)
    end
end)
for _,p in ipairs(game.Players:GetPlayers()) do
    if p ~= plr and checkStaff(p) then
        notifyStaff(p.DisplayName or p.Name)
    end
end

-- Build Tab UI
MakeLabel("Proteksi", "Fitur perlindungan chat & anti staff")
MakeToggle("Proteksi", "Anti Chat Nama/Ikan", false, blockFishingChat)
MakeButton("Proteksi", "Hide Streak", hideStreak)
MakeToggle("Proteksi", "Invisible (all)", false, setInvisibleAll)

MakeLabel("Spoof Data", "Spoof data nama/username/level/uang/streak")
MakeBox("Spoof Data", "Spoof Nama", plr.DisplayName, function(txt) spoofNameFunc(txt, spoofUser) end)
MakeBox("Spoof Data", "Spoof Username", plr.Name, function(txt) spoofNameFunc(spoofName, txt) end)
MakeBox("Spoof Data", "Spoof Level", "1", function(txt) spoofLevelMoney(txt, spoofMoney) end)
MakeBox("Spoof Data", "Spoof Uang", "0", function(txt) spoofLevelMoney(spoofLvl, txt) end)
MakeBox("Spoof Data", "Spoof Streak", "0", function(txt) spoofStreakFunc(txt) end)

MakeLabel("Movement", "Fitur movement & physic")
MakeToggle("Movement", "NoClip", false, function(state) noclip = state end)
MakeToggle("Movement", "Float (Terbang)", false, function(state) float = state end)

MakeLabel("Lainnya", "Deteksi Staff/Moderator berjalan otomatis")
MakeLabel("Lainnya", "Panel by Copilot Chat Assistant")

-- Minimize/Unminimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,t in pairs(TabFrames) do t.Visible = not minimized and (CurrentTab == t.Name:sub(5)) end
    TabBar.Visible = not minimized
    Main.Size = minimized and UDim2.new(0, 180, 0, 54) or UDim2.new(0, 440, 0, 350)
end)
CloseBtn.MouseButton1Click:Connect(function()
    Panel.Enabled = false
end)
-- Hotkey toggle (misal: "~" di keyboard)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Tilde or input.KeyCode == Enum.KeyCode.BackQuote then
        Panel.Enabled = not Panel.Enabled
    end
end)