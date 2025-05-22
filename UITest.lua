--[[
    Roblox Client-Side Script: Anti Kick & Name Spoofing with UI (BENAR-BENAR FUNGSI)

    Catatan:
    - Anti-kick hanya efektif untuk kick client-side (bukan dari server/admin)
    - Spoof hanya mengubah tampilan lokal (kamu sendiri yang melihat perubahan nama)
    - Tidak melanggar ToS jika hanya untuk edukasi/testing pribadi
]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpoofAntiKickGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 250)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 36)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 90)
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Text = "Spoof Username/DisplayName & Anti-Kick"
TitleLabel.Parent = MainFrame

local function makeSectionLabel(txt, ypos)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -24, 0, 18)
    l.Position = UDim2.new(0, 12, 0, ypos)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(200,220,255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = txt
    l.Parent = MainFrame
    return l
end

-- Username spoof section
makeSectionLabel("Spoof Username (local view):", 44)
local UsernameTextBox = Instance.new("TextBox")
UsernameTextBox.Size = UDim2.new(0, 180, 0, 28)
UsernameTextBox.Position = UDim2.new(0, 14, 0, 64)
UsernameTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
UsernameTextBox.TextColor3 = Color3.fromRGB(255,255,255)
UsernameTextBox.PlaceholderText = "Masukkan Username Palsu"
UsernameTextBox.Font = Enum.Font.Gotham
UsernameTextBox.TextSize = 14
UsernameTextBox.ClearTextOnFocus = false
UsernameTextBox.Parent = MainFrame

local UsernameToggle = Instance.new("TextButton")
UsernameToggle.Size = UDim2.new(0, 110, 0, 28)
UsernameToggle.Position = UDim2.new(0, 210, 0, 64)
UsernameToggle.BackgroundColor3 = Color3.fromRGB(180,40,40)
UsernameToggle.Text = "OFF"
UsernameToggle.TextColor3 = Color3.new(1,1,1)
UsernameToggle.Font = Enum.Font.GothamBold
UsernameToggle.TextSize = 15
UsernameToggle.Parent = MainFrame

-- DisplayName spoof section
makeSectionLabel("Spoof DisplayName (local view):", 104)
local DisplayNameTextBox = Instance.new("TextBox")
DisplayNameTextBox.Size = UDim2.new(0, 180, 0, 28)
DisplayNameTextBox.Position = UDim2.new(0, 14, 0, 124)
DisplayNameTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
DisplayNameTextBox.TextColor3 = Color3.fromRGB(255,255,255)
DisplayNameTextBox.PlaceholderText = "Masukkan DisplayName Palsu"
DisplayNameTextBox.Font = Enum.Font.Gotham
DisplayNameTextBox.TextSize = 14
DisplayNameTextBox.ClearTextOnFocus = false
DisplayNameTextBox.Parent = MainFrame

local DisplayNameToggle = Instance.new("TextButton")
DisplayNameToggle.Size = UDim2.new(0, 110, 0, 28)
DisplayNameToggle.Position = UDim2.new(0, 210, 0, 124)
DisplayNameToggle.BackgroundColor3 = Color3.fromRGB(180,40,40)
DisplayNameToggle.Text = "OFF"
DisplayNameToggle.TextColor3 = Color3.new(1,1,1)
DisplayNameToggle.Font = Enum.Font.GothamBold
DisplayNameToggle.TextSize = 15
DisplayNameToggle.Parent = MainFrame

-- Anti Kick section
makeSectionLabel("Anti-Kick (client-side):", 174)
local AntiKickToggle = Instance.new("TextButton")
AntiKickToggle.Size = UDim2.new(0, 315, 0, 32)
AntiKickToggle.Position = UDim2.new(0, 14, 0, 194)
AntiKickToggle.BackgroundColor3 = Color3.fromRGB(180,40,40)
AntiKickToggle.Text = "OFF (klik untuk aktifkan)"
AntiKickToggle.TextColor3 = Color3.new(1,1,1)
AntiKickToggle.Font = Enum.Font.GothamBold
AntiKickToggle.TextSize = 15
AntiKickToggle.Parent = MainFrame

-- LOGIC
local spoofUsernameActive = false
local spoofDisplayNameActive = false

local function spoofAllNameTexts()
    -- Ganti semua TextLabel/TextBox yang sama dengan username/displayname asli jadi palsu
    for _,desc in ipairs(game:GetDescendants()) do
        if (desc:IsA("TextLabel") or desc:IsA("TextBox")) and desc.Text then
            if spoofUsernameActive and UsernameTextBox.Text ~= "" then
                if desc.Text == LocalPlayer.Name then
                    desc.Text = UsernameTextBox.Text
                end
            end
            if spoofDisplayNameActive and DisplayNameTextBox.Text ~= "" then
                if desc.Text == LocalPlayer.DisplayName then
                    desc.Text = DisplayNameTextBox.Text
                end
            end
        end
    end
end

UsernameToggle.MouseButton1Click:Connect(function()
    spoofUsernameActive = not spoofUsernameActive
    UsernameToggle.Text = spoofUsernameActive and "ON" or "OFF"
    UsernameToggle.BackgroundColor3 = spoofUsernameActive and Color3.fromRGB(40,150,40) or Color3.fromRGB(180,40,40)
    if spoofUsernameActive then
        spoofAllNameTexts()
    else
        -- Optional: revert (tidak selalu bisa, karena sudah diubah)
    end
end)
DisplayNameToggle.MouseButton1Click:Connect(function()
    spoofDisplayNameActive = not spoofDisplayNameActive
    DisplayNameToggle.Text = spoofDisplayNameActive and "ON" or "OFF"
    DisplayNameToggle.BackgroundColor3 = spoofDisplayNameActive and Color3.fromRGB(40,150,40) or Color3.fromRGB(180,40,40)
    if spoofDisplayNameActive then
        spoofAllNameTexts()
    end
end)

-- Auto spoof ulang jika ada UI baru muncul
game.DescendantAdded:Connect(function(desc)
    if (desc:IsA("TextLabel") or desc:IsA("TextBox")) then
        pcall(spoofAllNameTexts)
    end
end)
UsernameTextBox.FocusLost:Connect(function()
    if spoofUsernameActive then spoofAllNameTexts() end
end)
DisplayNameTextBox.FocusLost:Connect(function()
    if spoofDisplayNameActive then spoofAllNameTexts() end
end)

-- ANTI KICK LOGIC
local antiKickActive = false
AntiKickToggle.MouseButton1Click:Connect(function()
    antiKickActive = not antiKickActive
    AntiKickToggle.Text = antiKickActive and "ON (client-side, tidak jamin block kick server)" or "OFF (klik untuk aktifkan)"
    AntiKickToggle.BackgroundColor3 = antiKickActive and Color3.fromRGB(40,150,40) or Color3.fromRGB(180,40,40)
    if antiKickActive then
        -- Patch Kick
        local mt = getrawmetatable(game)
        if setreadonly then pcall(setreadonly, mt, false) end
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or ""
            if (method == "Kick" or tostring(method):lower():find("kick")) and self == LocalPlayer then
                return
            end
            return old(self, ...)
        end)
        if LocalPlayer.Kick then
            LocalPlayer.Kick = function() end
        end
    else
        -- Tidak ada cara aman untuk re-enable Kick, harus rejoin game
    end
end)

-- HOTKEY: [~] untuk hide/show
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Tilde or input.KeyCode == Enum.KeyCode.BackQuote then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)