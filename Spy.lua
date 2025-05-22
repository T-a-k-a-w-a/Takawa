-- SimpleSpy Mobile - Full Feature, Android, Anti Lag, All Logic
-- By Copilot Chat Assistant for T-a-k-a-w-a

-- Clear old
pcall(function()
    if game.CoreGui:FindFirstChild("MobileSpy") then game.CoreGui.MobileSpy:Destroy() end
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MobileSpy") then game.Players.LocalPlayer.PlayerGui.MobileSpy:Destroy() end
end)

-- Parent fallback
local function safeAttach(gui)
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

-- State
local notes = {}      -- Catatan hasil copy
local logs = {}       -- Semua log remote
local blacklist = {}  -- Daftar remote yang di-block
local blocklist = {}  -- Daftar remote yang di-auto-block
local exclude = {}    -- Remote yang di-exclude (tidak tampil)
local disableInfo = {}-- Remote yang info-nya disembunyikan

-- UI
local TweenService = game:GetService("TweenService")
local SimpleSpy = Instance.new("ScreenGui")
SimpleSpy.Name = "MobileSpy"
SimpleSpy.ResetOnSpawn = false
SimpleSpy.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeAttach(SimpleSpy)

local panelW, panelH = 0.92, 0.7
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(panelW, 0, panelH, 0)
MainFrame.Position = UDim2.new(0.04,0,0.13,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = SimpleSpy
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,14)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1,0,0,38)
Header.BackgroundColor3 = Color3.fromRGB(41, 120, 255)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)
Header.ZIndex = 2

local HeaderLabel = Instance.new("TextLabel", Header)
HeaderLabel.Size = UDim2.new(1,0,1,0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "SimpleSpy Mobile"
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextColor3 = Color3.fromRGB(255,255,255)
HeaderLabel.TextSize = 20
HeaderLabel.ZIndex = 3

local ToggleButton = Instance.new("TextButton", Header)
ToggleButton.Size = UDim2.new(0,38,0,38)
ToggleButton.Position = UDim2.new(1,-38,0,0)
ToggleButton.Text = "–"
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 90, 190)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 24
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0,10)
ToggleButton.ZIndex = 3

local TabsBar = Instance.new("Frame", MainFrame)
TabsBar.Position = UDim2.new(0,0,0,38)
TabsBar.Size = UDim2.new(1,0,0,36)
TabsBar.BackgroundTransparency = 1
TabsBar.ZIndex = 2

local tabNames = {"Logs","Notes"}
local tabButtons = {}
local currentTab = "Logs"

for i,tab in ipairs(tabNames) do
    local btn = Instance.new("TextButton", TabsBar)
    btn.Size = UDim2.new(0.5,0,1,0)
    btn.Position = UDim2.new((i-1)*0.5,0,0,0)
    btn.Text = tab
    btn.BackgroundColor3 = Color3.fromRGB(24,24,24)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    tabButtons[tab] = btn
end

local function setTab(name)
    currentTab = name
    for t,b in pairs(tabButtons) do
        b.BackgroundColor3 = (t==name) and Color3.fromRGB(41, 120, 255) or Color3.fromRGB(24,24,24)
    end
end
for t,b in pairs(tabButtons) do
    b.MouseButton1Click:Connect(function() setTab(t) end)
end
setTab("Logs")

local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Name = "LogsScroll"
ScrollFrame.Size = UDim2.new(1,-16,1,-98)
ScrollFrame.Position = UDim2.new(0,8,0,82)
ScrollFrame.CanvasSize = UDim2.new(0,0,1,0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.BackgroundColor3 = Color3.fromRGB(36,36,36)
ScrollFrame.BackgroundTransparency = 0.15
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ZIndex = 3
local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0,3)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local NotesFrame = Instance.new("ScrollingFrame", MainFrame)
NotesFrame.Name = "NotesScroll"
NotesFrame.Size = ScrollFrame.Size
NotesFrame.Position = ScrollFrame.Position
NotesFrame.CanvasSize = UDim2.new(0,0,1,0)
NotesFrame.ScrollBarThickness = 6
NotesFrame.BackgroundColor3 = Color3.fromRGB(36,36,36)
NotesFrame.BackgroundTransparency = 0.15
NotesFrame.BorderSizePixel = 0
NotesFrame.ZIndex = 3
NotesFrame.Visible = false
local UIList2 = Instance.new("UIListLayout", NotesFrame)
UIList2.Padding = UDim.new(0,3)
UIList2.SortOrder = Enum.SortOrder.LayoutOrder

setTab = function(tab)
    currentTab = tab
    for t,b in pairs(tabButtons) do
        b.BackgroundColor3 = (t==tab) and Color3.fromRGB(41, 120, 255) or Color3.fromRGB(24,24,24)
    end
    ScrollFrame.Visible = (tab=="Logs")
    NotesFrame.Visible = (tab=="Notes")
end
for t,b in pairs(tabButtons) do
    b.MouseButton1Click:Connect(function() setTab(t) end)
end

-- Notif kanan bawah
local function showNotif(txt)
    local notif = Instance.new("TextLabel", SimpleSpy)
    notif.Text = txt
    notif.Size = UDim2.new(0,220,0,34)
    notif.AnchorPoint = Vector2.new(1,1)
    notif.Position = UDim2.new(1,-22,1,-22)
    notif.BackgroundColor3 = Color3.fromRGB(255,255,255)
    notif.BackgroundTransparency = 0.1
    notif.TextColor3 = Color3.fromRGB(0,110,255)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 16
    notif.ZIndex = 100
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0,9)
    TweenService:Create(notif, TweenInfo.new(0.15), {TextTransparency=0, BackgroundTransparency=0.1}):Play()
    task.spawn(function()
        wait(1.5)
        TweenService:Create(notif, TweenInfo.new(0.32), {TextTransparency=1, BackgroundTransparency=1}):Play()
        wait(0.32)
        notif:Destroy()
    end)
end
showNotif("SimpleSpy Mobile Full Siap!")

-- Minimize
local minimized = false
ToggleButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local t = TweenInfo.new(0.18, Enum.EasingStyle.Quad)
    if minimized then
        TweenService:Create(MainFrame, t, {Size = UDim2.new(0.19,0,0.09,0)}):Play()
        ToggleButton.Text = "↑"
        ScrollFrame.Visible = false
        NotesFrame.Visible = false
        TabsBar.Visible = false
    else
        TweenService:Create(MainFrame, t, {Size = UDim2.new(panelW,0,panelH,0)}):Play == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local s = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, s.X - MainFrame.AbsoluteSize.X)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, s.Y - MainFrame.AbsoluteSize.Y)
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- Utility: Copy to clipboard (Android/PC compatible)
local function copyToClipboard(str)
    if setclipboard then setclipboard(str)
    elseif toclipboard then toclipboard(str)
    end
    showNotif("Disalin!")
end

-- Utility: To string args
local function toStr(val)
    if typeof(val)=="Instance" then return val:GetFullName()
    elseif typeof(val)=="string" then return '"'..val..'"'
    elseif typeof(val)=="table" then
        local str = "{"
        for k,v in pairs(val) do
            str = str..tostring(k)..":"..toStr(v)..","
        end
        return str.."}"
    elseif typeof(val)=="Vector3" then
        return string.format("Vector3.new(%.2f,%.2f,%.2f)", val.X,val.Y,val.Z)
    else return tostring(val) end
end

-- LOGIC: Log, block, exclude, catatan
local function addNote(content)
    table.insert(notes, 1, content)
    local lbl = Instance.new("TextLabel", NotesFrame)
    lbl.Size = UDim2.new(1,0,0,32)
    lbl.Text = content
    lbl.TextColor3 = Color3.fromRGB(255,255,200)
    lbl.BackgroundTransparency = 0.2
    lbl.BackgroundColor3 = Color3.fromRGB(48,48,64)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 10
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0,8)
    NotesFrame.CanvasSize = UDim2.new(0,0,0,#notes*34+10)
end
local function logRemote(tab, remote, data)
    if exclude[remote] then return end
    if blacklist[remote] then return end
    if blocklist[remote] then return end
    local idx = #logs+1
    logs[idx] = {text=tab, remote=remote, args=data}
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.Size = UDim2.new(1,0,0,44)
    f.Parent = ScrollFrame
    f.ZIndex = 3
    local t = Instance.new("TextLabel", f)
    t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.Text = tab
    t.Size = UDim2.new(1,-88,1,0)
    t.Position = UDim2.new(0,0,0,0)
    t.TextColor3 = Color3.fromRGB(255,255,200)
    t.ZIndex = 4

    -- Tombol fitur
    local btns = {
        {"Copy Code", function()
            local code = "--Remote Call:\n"..tab
            copyToClipboard(code)
            addNote(code)
        end},
        {"Copy Remote", function()
            copyToClipboard(remote)
            addNote(remote)
        end},
        {"Get Script", function()
            showNotif("Fitur Get Script! (add-on, bisa diperluas)")
            -- Bisa diisi logic dump/require, jika remote berupa loader
        end},
        {"Run Code", function()
            showNotif("Code dijalankan (dummy)!") -- Custom: run code logic
        end},
        {"Function Info", function()
            showNotif("Info: "..remote)
        end},
        {"Decompile", function()
            showNotif("Decompile (dummy, extend if needed)")
        end},
        {"Block (i)", function()
            blacklist[remote]=true
            showNotif("Remote diblock!")
            f:Destroy()
        end},
        {"Exclude (i)", function()
            exclude[remote]=true
            showNotif("Remote di-exclude!")
            f:Destroy()
        end},
        {"Auto Block", function()
            blocklist[remote]=true
            showNotif("Auto Block ON!")
            f:Destroy()
        end},
        {"Disable info", function()
            disableInfo[remote]=true
            showNotif("Info Disabled!")
        end},
    }
    for i,bt in ipairs(btns) do
        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(0,68,0,22)
        b.Position = UDim2.new(1,(-70)*i,0,0)
        b.Text = bt[1]
        b.BackgroundColor3 = Color3.fromRGB(44,44,44)
        b.TextColor3 = Color3.fromRGB(220,220,255)
        b.Font = Enum.Font.Gotham
        b.TextSize = 12
        b.ZIndex = 5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
        b.MouseButton1Click:Connect(bt[2])
    end
    -- Clear/Exclude/Blocklist/Clear All
    local bclear = Instance.new("TextButton", f)
    bclear.Size = UDim2.new(0,60,0,18)
    bclear.Position = UDim2.new(1,-60,1,-22)
    bclear.Text = "Clear Logs"
    bclear.BackgroundColor3 = Color3.fromRGB(190,60,60)
    bclear.TextColor3 = Color3.fromRGB(255,255,255)
    bclear.Font = Enum.Font.Gotham
    bclear.TextSize = 10
    bclear.ZIndex = 5
    Instance.new("UICorner", bclear).CornerRadius = UDim.new(0,7)
    bclear.MouseButton1Click:Connect(function()
        for _,c in pairs(ScrollFrame:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        logs = {}
        showNotif("Semua log dihapus!")
    end)
    local bex = Instance.new("TextButton", f)
    bex.Size = UDim2.new(0,54,0,18)
    bex.Position = UDim2.new(1,-128,1,-22)
    bex.Text = "Clear Exclude"
    bex.BackgroundColor3 = Color3.fromRGB(100,100,60)
    bex.TextColor3 = Color3.fromRGB(250,250,150)
    bex.Font = Enum.Font.Gotham
    bex.TextSize = 10
    bex.ZIndex = 5
    Instance.new("UICorner", bex).CornerRadius = UDim.new(0,7)
    bex.MouseButton1Click:Connect(function()
        table.clear(exclude)
        showNotif("Exclude List Cleared!")
    end)
    local bblk = Instance.new("TextButton", f)
    bblk.Size = UDim2.new(0,54,0,18)
    bblk.Position = UDim2.new(1,-190,1,-22)
    bblk.Text = "Clear Block"
    bblk.BackgroundColor3 = Color3.fromRGB(100,60,60)
    bblk.TextColor3 = Color3.fromRGB(255,220,220)
    bblk.Font = Enum.Font.Gotham
    bblk.TextSize = 10
    bblk.ZIndex = 5
    Instance.new("UICorner", bblk).CornerRadius = UDim.new(0,7)
    bblk.MouseButton1Click:Connect(function()
        table.clear(blacklist)
        table.clear(blocklist)
        showNotif("Block list cleared!")
    end)
    -- Animasi: masuk dari kanan, fade in
    f.Position = UDim2.new(1,0,0,0)
    t.TextTransparency = 1
    TweenService:Create(f, TweenInfo.new(0.16), {Position=UDim2.new(0,0,0,0)}):Play()
    TweenService:Create(t, TweenInfo.new(0.17), {TextTransparency=0}):Play()
    ScrollFrame.CanvasSize = UDim2.new(0,0,0,#logs*46+10)
end

-- HOOK REMOTE: FireServer/InvokeServer, anti lag (hook hanya jika belum)
local hookedRemotes = {}
local function hookOne(remote)
    if hookedRemotes[remote] then return end
    hookedRemotes[remote]=true
    if remote:IsA("RemoteEvent") then
        local oldFire = remote.FireServer
        remote.FireServer = function(self, ...)
            local tab = "[RemoteEvent] "..self:GetFullName().." :FireServer("..table.concat((function(...)local t={} for i,v in ipairs({...}) do t[i]=toStr(v) end return t end)(...), ", ")..")"
            logRemote(tab, self:GetFullName(), {...})
            return oldFire(self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        local oldInvoke = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            local tab = "[RemoteFunction] "..self:GetFullName().." :InvokeServer("..table.concat((function(...)local t={} for i,v in ipairs({...}) do t[i]=toStr(v) end return t end)(...), ", ")..")"
            logRemote(tab, self:GetFullName(), {...})
            return oldInvoke(self, ...)
        end
    end
end

-- Scan all remotes in ReplicatedStorage/Workspace/StarterGui
local function scanRemotes()
    local function scan(obj)
        for _,v in ipairs(obj:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                hookOne(v)
            end
        end
    end
    scan(game.ReplicatedStorage)
    scan(game.Workspace)
    scan(game.StarterGui)
end
scanRemotes()
game.ReplicatedStorage.DescendantAdded:Connect(function(v) if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then hookOne(v) end end)
game.Workspace.DescendantAdded:Connect(function(v) if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then hookOne(v) end end)

-- Panel Siap
showNotif("SimpleSpy Mobile All Logic Ready!")