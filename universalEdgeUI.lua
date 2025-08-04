-- ENVIRONMENT SETUP
local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService  = game:GetService("RunService")
local TweenService= game:GetService("TweenService")

-- UI SETUP
local window = loadstring(game:HttpGet("https://raw.githubusercontent.com/deadmopose/Edge-ui-library/main/script.lua"))()
local tab    = window.new_tab("🎮 Avatar & Movement") -- Only 1 tab, compact

-- Make window draggable (panel feature)
window.draggable = true

-- Animate panel open/close with buttons
local minimized = false

local function animatePanel(visible)
    local goal = {}
    goal.Position = visible and UDim2.new(0.5, -250, 0.5, -200) or UDim2.new(2, 0, 2, 0)
    TweenService:Create(window.frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), goal):Play()
end

-- Add control buttons to toggle UI visibility
tab.new_section("📂 Interface Controls").new_button("Maximize UI", function()
    if minimized then animatePanel(true) minimized = false end
end)

tab.new_section("📂 Interface Controls").new_button("Minimize UI", function()
    if not minimized then animatePanel(false) minimized = true end
end)

-- MOVEMENT SECTION
local settings = { WalkSpeed = 16, JumpPower = 50 }
local secMove  = tab.new_section("🚀 Movement Control")

secMove.new_slider("WalkSpeed", 16, 200, function(val)
    settings.WalkSpeed = val
end)

secMove.new_slider("JumpPower", 50, 200, function(val)
    settings.JumpPower = val
end)

-- Apply movement settings continuously
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = settings.WalkSpeed
            humanoid.JumpPower = settings.JumpPower
        end
    end
end)

-- AVATAR CLONING SECTION
local secClone = tab.new_section("🧍‍♂️ Character Cloner")
local playerList = {}
local dropdown

local presets = {} -- To store cloned avatar presets

-- Function to get player names in server
local function refreshPlayers()
    playerList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(playerList, p.Name) end
    end
    if dropdown then dropdown:Refresh(playerList) end
end

-- Clone logic with full mesh
local function cloneFullAvatar(username)
    coroutine.wrap(function()
        local success, userId = pcall(function()
            return Players:GetUserIdFromNameAsync(username)
        end)
        if not success then return warn("User not found: " .. username) end

        local success2, charModel = pcall(function()
            return Players:GetCharacterAppearanceAsync(userId)
        end)
        if not success2 or not charModel then return warn("Cannot load appearance") end

        charModel.Name = username .. "_Avatar"
        charModel.Parent = workspace

        -- position beside local player
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local root   = charModel.PrimaryPart or charModel:FindFirstChild("HumanoidRootPart")

        if myRoot and root then
            charModel:SetPrimaryPartCFrame(CFrame.new(myRoot.Position + Vector3.new(6, 0, 0)))
        end

        -- save as preset
        presets[username] = charModel:Clone()
    end)()
end

-- UI Input: clone by username
secClone.new_text_box("Clone From Username", function(username)
    cloneFullAvatar(username)
end)

-- UI Dropdown: clone from server player
dropdown = secClone.new_dropdown("Clone From Server", playerList, function(name)
    cloneFullAvatar(name)
end)

-- Refresh list button
secClone.new_button("🔄 Refresh Server Player List", function()
    refreshPlayers()
end)

-- PRESET SECTION
local secPresets = tab.new_section("💾 Saved Presets")

secPresets.new_dropdown("Load Preset", function()
    local keys = {}
    for name,_ in pairs(presets) do table.insert(keys, name) end
    return keys
end, function(chosen)
    local clone = presets[chosen]
    if clone then
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local root   = clone.PrimaryPart or clone:FindFirstChild("HumanoidRootPart")

        clone:Clone().Parent = workspace
        if root and myRoot then
            clone:SetPrimaryPartCFrame(CFrame.new(myRoot.Position + Vector3.new(10,0,0)))
        end
    end
end)

-- Run initial
refreshPlayers()
animatePanel(true)