local Players       = game:GetService("Players")
local LocalPlayer   = Players.LocalPlayer
local RunService    = game:GetService("RunService")

-- Load Edge UI Window
local window = loadstring(game:HttpGet("https://raw.githubusercontent.com/deadmopose/Edge-ui-library/main/script.lua"))()
local tab    = window.new_tab("Movement & Avatar")

-- Section for Movement Sliders
local secMovement = tab.new_section("Movement Controls")

local settings = {
    WalkSpeed = 16,
    JumpPower = 50,
}

secMovement.new_slider("WalkSpeed", 16, 300, function(value)
    settings.WalkSpeed = value
end)

secMovement.new_slider("JumpPower", 50, 200, function(value)
    settings.JumpPower = value
end)

-- Apply settings continuously
local function applyMovement()
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
end

if LocalPlayer.Character then
    applyMovement()
end
LocalPlayer.CharacterAdded:Connect(applyMovement)

-- Section for Cloning Characters
local secClone = tab.new_section("Clone Character")

-- Dropdown player list
local currentList = {}
local dropdown

local function refreshDropdown()
    currentList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(currentList, plr.Name)
        end
    end
    dropdown:Refresh(currentList)
end

dropdown = secClone.new_dropdown("Clone From Server Player", currentList, function(name)
    cloneAvatar(name)
end)

-- Button to refresh player list
secClone.new_button("Refresh Player List", function()
    refreshDropdown()
end)

-- Input to clone from any Roblox username
secClone.new_text_box("Clone From Username", function(username)
    cloneAvatar(username)
end)

-- Clone implementation
function cloneAvatar(username)
    coroutine.wrap(function()
        local success, userId = pcall(function()
            return Players:GetUserIdFromNameAsync(username)
        end)

        if not success then
            warn("Gagal mengambil userId untuk: " .. username)
            return
        end

        local ok, avatarModel = pcall(function()
            return Players:GetCharacterAppearanceAsync(userId)
        end)

        if not ok or not avatarModel then
            warn("Gagal memuat karakter untuk userId: " .. tostring(userId))
            return
        end

        avatarModel.Name = username .. "_Clone"
        avatarModel.Parent = workspace

        local root = avatarModel:FindFirstChild("HumanoidRootPart") or avatarModel.PrimaryPart
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if root and myRoot then
            avatarModel:SetPrimaryPartCFrame(
                CFrame.new(myRoot.Position + Vector3.new(8, 0, 0), myRoot.Position)
            )
        end
    end)()
end

-- Inisialisasi dropdown awal
refreshDropdown()