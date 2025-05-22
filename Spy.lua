-- SimpleSpy Advanced UI Layout (Multi-Panel, Android Friendly)
-- Part 1: Panel, TopBar, Sidebar, MainPanel, Notes, Tooltip

-- Clean up
pcall(function()
    if game.CoreGui:FindFirstChild("SimpleSpyAdv") then game.CoreGui.SimpleSpyAdv:Destroy() end
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("SimpleSpyAdv") then game.Players.LocalPlayer.PlayerGui.SimpleSpyAdv:Destroy() end
end)

local function safeAttach(gui)
    local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    local cg = game:FindFirstChildOfClass("CoreGui")
    if pg then gui.Parent = pg
    elseif cg then gui.Parent = cg
    else gui.Parent = game.Players.LocalPlayer end
end

local SimpleSpy = Instance.new("ScreenGui")
SimpleSpy.Name = "SimpleSpyAdv"
SimpleSpy.ResetOnSpawn = false
safeAttach(SimpleSpy)

local Main = Instance.new("Frame", SimpleSpy)
Main.Name = "Main"
Main.Size = UDim2.new(0, 620, 0, 350)
Main.Position = UDim2.new(0.5, -310, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(36,36,38)
Main.BackgroundTransparency = 0
Main.BorderSizePixel = 0
Main.Draggable = true
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

-- TopBar
local TopBar = Instance.new("Frame", Main)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1,0,0,30)
TopBar.BackgroundColor3 = Color3.fromRGB(41, 120, 255)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "SimpleSpy Advanced"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 20

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0,28,0,28)
CloseBtn.Position = UDim2.new(1,-30,0,1)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.new(0.8,0.2,0.2)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,7)
CloseBtn.MouseButton1Click:Connect(function() SimpleSpy:Destroy() end)

local MiniBtn = Instance.new("TextButton", TopBar)
MiniBtn.Name = "Minimize"
MiniBtn.Size = UDim2.new(0,28,0,28)
MiniBtn.Position = UDim2.new(1,-60,0,1)
MiniBtn.Text = "–"
MiniBtn.BackgroundColor3 = Color3.new(0.2,0.6,0.9)
MiniBtn.TextColor3 = Color3.new(1,1,1)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 18
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0,7)
-- Minimize logic (lanjut di part 2)

-- Sidebar kiri (Log List)
local LeftPanel = Instance.new("Frame", Main)
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0,140,1,-32)
LeftPanel.Position = UDim2.new(0,0,0,32)
LeftPanel.BackgroundColor3 = Color3.fromRGB(53, 52, 55)
LeftPanel.BorderSizePixel = 0
Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0,8)

-- LogList
local LogList = Instance.new("ScrollingFrame", LeftPanel)
LogList.Name = "LogList"
LogList.Size = UDim2.new(1,0,1,-10)
LogList.Position = UDim2.new(0,0,0,8)
LogList.CanvasSize = UDim2.new(0,0,0,0)
LogList.ScrollBarThickness = 4
LogList.BackgroundTransparency = 1
LogList.BorderSizePixel = 0

local UILogList = Instance.new("UIListLayout", LogList)
UILogList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UILogList.SortOrder = Enum.SortOrder.LayoutOrder

-- Panel kanan (code box & detail)
local RightPanel = Instance.new("Frame", Main)
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(1,-140,1,-32)
RightPanel.Position = UDim2.new(0,140,0,32)
RightPanel.BackgroundColor3 = Color3.fromRGB(37, 36, 38)
RightPanel.BorderSizePixel = 0
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0,8)

-- Code box
local CodeBox = Instance.new("TextBox", RightPanel)
CodeBox.Name = "CodeBox"
CodeBox.Size = UDim2.new(1,0,0.32,0)
CodeBox.Position = UDim2.new(0,0,0,0)
CodeBox.Text = "-- Remote details akan muncul di sini"
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.BackgroundColor3 = Color3.fromRGB(21,19,21)
CodeBox.TextColor3 = Color3.fromRGB(255,255,255)
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 15
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true
CodeBox.TextWrapped = true

-- Tombol aksi bawah code box (akan lanjut di part 2)
-- Notes Tab
local NotesTab = Instance.new("ScrollingFrame", Main)
NotesTab.Name = "NotesTab"
NotesTab.Size = UDim2.new(1,0,0.27,0)
NotesTab.Position = UDim2.new(0,0,1,-84)
NotesTab.CanvasSize = UDim2.new(0,0,1,0)
NotesTab.ScrollBarThickness = 4
NotesTab.BackgroundColor3 = Color3.fromRGB(48,48,64)
NotesTab.BackgroundTransparency = 0.15
NotesTab.BorderSizePixel = 0
NotesTab.Visible = false
local UINotes = Instance.new("UIListLayout", NotesTab)
UINotes.HorizontalAlignment = Enum.HorizontalAlignment.Center
UINotes.SortOrder = Enum.SortOrder.LayoutOrder

-- Tooltip
local Tooltip = Instance.new("Frame", SimpleSpy)
Tooltip.Visible = false
Tooltip.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Tooltip.BackgroundTransparency = 0.1
Tooltip.BorderColor3 = Color3.new(1, 1, 1)
Tooltip.Size = UDim2.new(0, 200, 0, 50)
Tooltip.ZIndex = 10
local TooltipLabel = Instance.new("TextLabel", Tooltip)
TooltipLabel.BackgroundTransparency = 1
TooltipLabel.Size = UDim2.new(1,-4,1,-4)
TooltipLabel.Position = UDim2.new(0,2,0,2)
TooltipLabel.Font = Enum.Font.Gotham
TooltipLabel.TextColor3 = Color3.new(1,1,1)
TooltipLabel.TextSize = 14
TooltipLabel.TextWrapped = true
TooltipLabel.TextXAlignment = Enum.TextXAlignment.Left
TooltipLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Tab logic, minimize, dsb akan dilanjutkan di part 2
-- Part 2: Log List, Select, Highlight, Search Bar

-- === SEARCH BAR ===
local SearchBar = Instance.new("TextBox", TopBar)
SearchBar.Name = "SearchBar"
SearchBar.Size = UDim2.new(0, 200, 1, 0)
SearchBar.Position = UDim2.new(0, 220, 0, 0)
SearchBar.Text = ""
SearchBar.PlaceholderText = "Cari remote..."
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 14
SearchBar.BackgroundColor3 = Color3.fromRGB(220,220,255)
SearchBar.TextColor3 = Color3.fromRGB(36,36,38)
SearchBar.ClearTextOnFocus = false
SearchBar.Visible = true

-- === LOG STATE ===
local logs = {}        -- semua remote logs
local logButtons = {}  -- button di panel kiri, untuk highlight
local logSelected = nil

-- === ADD LOG TO SIDEBAR ===
function addLogSidebar(logdata)
    -- logdata = {text, remote, args, code}
    local btn = Instance.new("TextButton", LogList)
    btn.Size = UDim2.new(1,-10,0,28)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,90)
    btn.TextColor3 = Color3.fromRGB(255,255,220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = logdata.text
    btn.AutoButtonColor = false

    -- Highlight on select
    btn.MouseButton1Click:Connect(function()
        if logSelected then
            logSelected.BackgroundColor3 = Color3.fromRGB(60,60,90)
        end
        logSelected = btn
        btn.BackgroundColor3 = Color3.fromRGB(41,120,255)
        -- Tampilkan detail di code box dan tombol aksi (isi logic di Part 3)
        if CodeBox then
            CodeBox.Text = logdata.code or "-- Tidak ada code"
            CodeBox.TextColor3 = Color3.fromRGB(255,255,255)
        end
        -- Simpan remote ke state untuk tombol aksi
        SimpleSpy.SelectedLog = logdata
    end)
    -- Hover
    btn.MouseEnter:Connect(function()
        if btn ~= logSelected then btn.BackgroundColor3 = Color3.fromRGB(80,120,160) end
    end)
    btn.MouseLeave:Connect(function()
        if btn ~= logSelected then btn.BackgroundColor3 = Color3.fromRGB(60,60,90) end
    end)
    table.insert(logButtons, btn)
    -- Scroll otomatis ke bawah
    LogList.CanvasSize = UDim2.new(0,0,0,#logButtons*30+10)
end

-- === FILTER BY SEARCHBAR ===
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local query = SearchBar.Text:lower()
    for i,btn in ipairs(logButtons) do
        if logs[i] and (logs[i].text:lower():find(query) or (logs[i].remote and tostring(logs[i].remote):lower():find(query))) then
            btn.Visible = true
        else
            btn.Visible = false
        end
    end
end)

-- === CLEAR LOGS ===
function clearLogs()
    for _,btn in ipairs(logButtons) do
        btn:Destroy()
    end
    logButtons = {}
    logs = {}
    LogList.CanvasSize = UDim2.new(0,0,0,0)
    if CodeBox then CodeBox.Text = "-- Remote details akan muncul di sini" end
end