

-- Create the ScreenGui
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local toggleButton = Instance.new("TextButton")
local minimizeButton = Instance.new("TextButton")
local statusLabel = Instance.new("TextLabel")
local featureToggledOn = false  -- Toggle state for features

-- UI Properties
screenGui.Parent = player:WaitForChild("PlayerGui")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.Parent = screenGui

toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(0.5, -50, 0.5, -25)
toggleButton.Text = "Toggle Features"
toggleButton.Parent = mainFrame

minimizeButton.Size = UDim2.new(0, 50, 0, 30)
minimizeButton.Position = UDim2.new(1, -55, 0, 5)
minimizeButton.Text = "-"
minimizeButton.Parent = mainFrame

statusLabel.Size = UDim2.new(1, 0, 0, 50)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.Text = "Features are OFF"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Parent = mainFrame

-- Function to toggle features
local function toggleFeatures()
    featureToggledOn = not featureToggledOn
    if featureToggledOn then
        statusLabel.Text = "Features are ON"
        -- Implement your features here, remember to handle with care
    else
        statusLabel.Text = "Features are OFF"
        -- Disable features
    end
end

-- Button Events
toggleButton.MouseButton1Click:Connect(toggleFeatures)

minimizeButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        mainFrame.Visible = false
    else
        mainFrame.Visible = true
    end
end)

-- Anti-kick logic placeholder (not recommendable to implement)
local function preventKick()
    -- This is a conceptual placeholder
    -- You cannot truly prevent kicks from the server
end

-- Spoofing username logic placeholder (not recommendable and against ToS)
local function spoofUsername()
    -- This is a conceptual placeholder
    -- Cannot change the username effectively
end

-- Ensure UI is visible
mainFrame.Visible = true
Important Notes:
Violating Terms: The functionalities such as anti-kick and username spoofing typically violate Roblox's terms of service, which can lead to player bans. It is not advisable to implement or share potentially harmful scripts.
Learning Opportunity: The UI and logic are designed to serve as an educational resource about how UIs work in Roblox.
Roblox Community Guidelines: Always be mindful of the community guidelines and create scripts that enhance gameplay without undermining the platform's integrity.
This script should help you understand the structure and approach to building a UI with toggle functionality in Roblox, while emphasizing ethical considerations in scripting.