-- Fisch Utility Panel - Full All-In-One by Copilot Chat Assistant

-- CLEANUP
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

-- === UI BASE ===
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 460, 0, 370)
Main.Position = UDim2.new(0.08, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(24,30,45)
Main.BackgroundTransparency = 0.22
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0
Main.Parent = Panel
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Main.ClipsDescendants = true

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(41, 120, 255)
TopBar.BackgroundTransparency = 0.11
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

local tabNames = {"Proteksi", "Spoof Data", "Movement", "Lainnya", "Remote Finder"}
local Tabs, TabFrames, CurrentTab = {}, {}, nil

local TabBar = Instance.new("Frame", Main)
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 34)
TabBar.Position = UDim2.new(0, 0, 0, 38)
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 105, 1, -8)
    btn.Position = UDim2.new(0, 15 + (i-1)*112, 0, 4)
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
    frame.CanvasSize = UDim2.new(0, 1000, 0, 1100)
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
    b.Size = UDim2.new(0, 200, 0, 32)
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
    f.Size = UDim2.new(0, 320, 0, 32)
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
    f.Size = UDim2.new(0, 200, 0, 32)
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

-- === STATE & LOGIC ===
local spoofName, spoofUser, spoofLvl, spoofMoney, spoofStreak = plr.DisplayName, plr.Name, 1, 0, 0
local noclip, float, invis = false, false, false

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
    for _,v in pairs(workspace:GetDescendants()) do
        local n = v.Name:lower()
        if n:find("rod") or n:find("bobber") or n:find("line") or n:find("string") or n:find("fishing") or n:find("tag") or n:find("label") or n:find("level") or n:find("streak") or n:find("passive") then
            if v:IsA("BasePart") then v.Transparency = state and 1 or 0
            elseif v:IsA("TextLabel") or v:IsA("BillboardGui") then v.Visible = not state end
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

-- ---[ ANTI CHAT SYSTEM + REMOTE SCANNER ]---
local ikan_keywords = {"legendary","mythic","exotic","mutasi","mutation","catfish","whiptail","trout","salmon","bass","shark","fish","ikan"}
local function containsIkanPesan(teks)
    local t = teks:lower()
    for _,w in ipairs(ikan_keywords) do
        if t:find(w) then return true end
    end
    return false
end
local function blockFishingChat()
    local TextChatService = game:GetService("TextChatService")
    for _,channel in pairs(TextChatService.TextChannels:GetChildren()) do
        if channel:IsA("TextChannel") then
            local old = channel.DisplaySystemMessage
            channel.DisplaySystemMessage = function(self, msg)
                if containsIkanPesan(msg) or msg:find(plr.Name) or msg:find(plr.DisplayName) or msg:find(spoofName) then return end
                return old(self, msg)
            end
        end
    end
    TextChatService.TextChannels.ChildAdded:Connect(function(channel)
        if channel:IsA("TextChannel") then
            local old = channel.DisplaySystemMessage
            channel.DisplaySystemMessage = function(self, msg)
                if containsIkanPesan(msg) or msg:find(plr.Name) or msg:find(plr.DisplayName) or msg:find(spoofName) then return end
                return old(self, msg)
            end
        end
    end)
    local StarterGui = game:GetService("StarterGui")
    local oldSetCore = StarterGui.SetCore
    StarterGui.SetCore = function(self, method, data)
        if method == "ChatMakeSystemMessage" and data and data.Text and (containsIkanPesan(data.Text) or data.Text:find(plr.Name) or data.Text:find(plr.DisplayName) or data.Text:find(spoofName)) then
            return
        end
        return oldSetCore(self, method, data)
    end
    for _,child in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            if child.OnClientEvent then
                child.OnClientEvent:Connect(function(...)
                    local args = {...}
                    for _,v in ipairs(args) do
                        if type(v)=="string" and (containsIkanPesan(v) or v:find(plr.Name) or v:find(plr.DisplayName) or v:find(spoofName)) then
                            return
                        end
                    end
                end)
            end
        end
    end
end

-- ---[ REMOTE FINDER TAB ]---
local remoteLogTab = TabFrames["Remote Finder"]
MakeLabel("Remote Finder", "RemoteEvent/RemoteFunction yang mengandung chat ditemukan:")
local remoteList = Instance.new("TextLabel", remoteLogTab)
remoteList.Size = UDim2.new(1, -20, 0, 350)
remoteList.BackgroundTransparency = 1
remoteList.TextXAlignment = Enum.TextXAlignment.Left
remoteList.TextYAlignment = Enum.TextYAlignment.Top
remoteList.TextColor3 = Color3.fromRGB(255,255,200)
remoteList.Font = Enum.Font.Gotham
remoteList.TextSize = 15
remoteList.Text = "Scanning..."
remoteList.TextWrapped = true
remoteList.TextTruncate = Enum.TextTruncate.AtEnd

spawn(function()
    local found = {}
    local function scanRemotes()
        found = {}
        for _,obj in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if (
                obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")
            ) and (
                obj.Name:lower():find("chat") or obj.Name:lower():find("announ") or obj.Name:lower():find("system") or obj.Name:lower():find("fish") or obj.Name:lower():find("rod") or obj.Name:lower():find("mutasi") or obj.Name:lower():find("luck") or obj.Name:lower():find("resil")
            ) then
                table.insert(found, obj:GetFullName().. " ["..obj.ClassName.."]")
            end
        end
        if #found == 0 then
            remoteList.Text = "Tidak ditemukan RemoteEvent/Function chat/rod.\nCoba cek manual di ReplicatedStorage."
        else
            remoteList.Text = "Ditemukan:\n"..table.concat(found, "\n")
        end
    end
    scanRemotes()
    while wait(5) do scanRemotes() end
end)

-- ---[ HIJACK MUTASI & FISH RESULT & KRAKEN ROD STAT ]---
function hijackMutasiAndFishing()
    for _,obj in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
        -- Mutasi Rod Kraken
        if obj:IsA("RemoteEvent") and (obj.Name:lower():find("mutasi") or obj.Name:lower():find("evolve") or obj.Name:lower():find("rod")) then
            local oldFire = obj.FireServer
            obj.FireServer = function(self, rodName, ...)
                if tostring(rodName):lower():find("kraken") then
                    return oldFire(self, rodName, "Tentacle Surge", ...)
                end
                return oldFire(self, rodName, ...)
            end
        end
        -- Fishing Result Legendary
        if obj:IsA("RemoteEvent") and (obj.Name:lower():find("fish") or obj.Name:lower():find("catch")) then
            local oldFire = obj.FireServer
            obj.FireServer = function(self, ...)
                local args = {...}
                for i=2,3 do
                    if typeof(args[i])=="string" and args[i]:lower():find("legendary") == nil then
                        args[i] = "Legendary"
                    end
                end
                return oldFire(self, unpack(args))
            end
        end
    end
    -- Kraken Rod Stat Visual
    for _,item in pairs(game:GetDescendants()) do
        if item:IsA("TextLabel") and item.Text and item.Text:lower():find("kraken rod") then
            local parent = item.Parent
            for _,v in pairs(parent:GetDescendants()) do
                if v:IsA("TextLabel") and v.Text:lower():find("luck") then
                    v.Text = "Luck: 600%"
                elseif v:IsA("TextLabel") and v.Text:lower():find("resilience") then
                    v.Text = "Resilience: 100%"
                end
            end
        end
    end
end
-- Auto stat visual update (Kraken Rod)
game.DescendantAdded:Connect(function(d)
    if d:IsA("TextLabel") and d.Text and d.Text:lower():find("kraken rod") then
        local parent = d.Parent
        for _,v in pairs(parent:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text:lower():find("luck") then
                v.Text = "Luck: 600%"
            elseif v:IsA("TextLabel") and v.Text:lower():find("resilience") then
                v.Text = "Resilience: 100%"
            end
        end
    end
end)

-- ---[ ANTI KICK ALL-IN-ONE ]---
local oldKick = nil
if plr.Kick then
    oldKick = plr.Kick
    plr.Kick = function(...) return end
end
local mt = getrawmetatable(game)
if setreadonly then pcall(setreadonly, mt, false) end
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod and getnamecallmethod() or ""
    if (method == "Kick" or tostring(method):lower():find("kick")) and self == plr then
        return -- block
    end
    return oldNamecall(self, ...)
end)
-- Block Destroy/Remove Character
if plr.Character then
    plr.Character.Destroy = function() end
    plr.Character.Remove = function() end
end

-- ---[ STAFF ALERT ]---
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

-- === FINAL: BUILD UI ===
MakeLabel("Proteksi", "Anti chat hasil pancing, anti staff, anti kick")
MakeToggle("Proteksi", "Anti Chat System", false, blockFishingChat)
MakeButton("Proteksi", "Hide Streak", hideStreak)
MakeToggle("Proteksi", "Invisible (all)", false, setInvisibleAll)

MakeLabel("Spoof Data", "Spoof nama/username/level/uang/streak")
MakeBox("Spoof Data", "Spoof Nama", plr.DisplayName, function(txt) spoofNameFunc(txt, spoofUser) end)
MakeBox("Spoof Data", "Spoof Username", plr.Name, function(txt) spoofNameFunc(spoofName, txt) end)
MakeBox("Spoof Data", "Spoof Level", "1", function(txt) spoofLevelMoney(txt, spoofMoney) end)
MakeBox("Spoof Data", "Spoof Uang", "0", function(txt) spoofLevelMoney(spoofLvl, txt) end)
MakeBox("Spoof Data", "Spoof Streak", "0", function(txt) spoofStreakFunc(txt) end)

MakeLabel("Movement", "Noclip, terbang, dsb")
MakeToggle("Movement", "NoClip", false, function(state) noclip = state end)
MakeToggle("Movement", "Float (Terbang)", false, function(state) float = state end)

MakeLabel("Lainnya", "Deteksi Staff/Moderator otomatis. Kraken Rod Mutasi & Legendary & Stat patch.")
MakeButton("Lainnya", "Aktifkan Mutasi Kraken 100% Tentacle Surge + Legendary + Stat Patch", hijackMutasiAndFishing)
MakeLabel("Lainnya", "Panel by Copilot Chat Assistant")

-- Minimize/Unminimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,t in pairs(TabFrames) do t.Visible = not minimized and (CurrentTab == t.Name:sub(5)) end
    TabBar.Visible = not minimized
    Main.Size = minimized and UDim2.new(0, 180, 0, 54) or UDim2.new(0, 460, 0, 370)
end)
CloseBtn.MouseButton1Click:Connect(function()
    Panel.Enabled = false
end)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Tilde or input.KeyCode == Enum.KeyCode.BackQuote then
        Panel.Enabled = not Panel.Enabled
    end
end)

-- Aktifkan auto anti-chat, anti-kick, stat patch, mutasi patch, remote finder
blockFishingChat()
hijackMutasiAndFishing()

-- Biar Kraken Rod stat patch selalu up to date
spawn(function()
    while true do
        pcall(function()
            for _,item in pairs(game:GetDescendants()) do
                if item:IsA("TextLabel") and item.Text and item.Text:lower():find("kraken rod") then
                    local parent = item.Parent
                    for _,v in pairs(parent:GetDescendants()) do
                        if v:IsA("TextLabel") and v.Text:lower():find("luck") then
                            v.Text = "Luck: 600%"
                        elseif v:IsA("TextLabel") and v.Text:lower():find("resilience") then
                            v.Text = "Resilience: 100%"
                        end
                    end
                end
            end
        end)
        wait(3)
    end
end)