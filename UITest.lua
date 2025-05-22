--[[
    Roblox Client-Side Script: Anti Kick and Name Spoofing with UI

    DISCLAIMER:
    - This script runs client-side and has limitations.
    - Anti-Kick is largely ineffective against server-side kicks. It cannot reliable block
      disconnections initiated by the server (admin commands, server anti-cheat, game logic).
      It might potentially block specific client-triggered kicks or intercepted RemoteEvents,
      but this is game-specific and unreliable.
    - Name/DisplayName Spoofing client-side does NOT change your name for other players or the server.
      It only changes what YOU see on your client. The primary use case is modifying local UI
      elements like nametags or potentially influencing specific client-to-server interactions
      if the game's scripts rely on the client's Player.Name (which is uncommon for identity).

    Use this script for educational purposes or understanding client-side possibilities and limitations.
    Do not use this script to violate Roblox Terms of Service or disrupt gameplay.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- State variables
local spoofUsernameEnabled = false
local spoofDisplayNameEnabled = false
local antiKickEnabled = false

-- Spoofed names storage
local desiredUsername = ""
local desiredDisplayName = ""

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")

local UsernameLabel = Instance.new("TextLabel")
local UsernameTextBox = Instance.new("TextBox")
local UsernameToggleButton = Instance.new("TextButton")

local DisplayNameLabel = Instance.new("TextLabel")
local DisplayNameTextBox = Instance.new("TextBox")
local DisplayNameToggleButton = Instance.new("TextButton")

local AntiKickToggleButton = Instance.new("TextButton")

-- UI Setup
ScreenGui.Name = "SpoofAntiKickGUI"
ScreenGui.ResetOnSpawn = false -- Don't reset the UI when character respawns
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150) -- Center of screen
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true -- Make the frame draggable
MainFrame.Parent = ScreenGui

-- Add a UIStroke for better visibility if needed
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(60, 60, 60)
FrameStroke.Thickness = 1
FrameStroke.Parent = MainFrame

TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleLabel.BorderSizePixel = 0
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Spoof & Anti-Kick (Client-Side)"
TitleLabel.Parent = MainFrame

-- Helper function for element positioning
local function calculatePosition(yOffset)
    return UDim2.new(0.05, 0, 0, 40 + yOffset)
end

-- Username Spoofing Section
UsernameLabel.Size = UDim2.new(0.9, 0, 0, 20)
UsernameLabel.Position = calculatePosition(0)
UsernameLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
UsernameLabel.BorderSizePixel = 0
UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameLabel.TextSize = 14
UsernameLabel.Font = Enum.Font.SourceSans
UsernameLabel.Text = "Spoof Username (Local UI Only):"
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.TextInset = UDim2.new(0.05, 0, 0, 0)
UsernameLabel.Parent = MainFrame

UsernameTextBox.Size = UDim2.new(0.6, 0, 0, 25)
UsernameTextBox.Position = calculatePosition(25)
UsernameTextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
UsernameTextBox.BorderSizePixel = 0
UsernameTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameTextBox.TextSize = 14
UsernameTextBox.Font = Enum.Font.SourceSans
UsernameTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
UsernameTextBox.PlaceholderText = "Enter Fake Username"
UsernameTextBox.Text = ""
UsernameTextBox.ClearTextOnFocus = false
UsernameTextBox.Parent = MainFrame

UsernameToggleButton.Size = UDim2.new(0.3, 0, 0, 25)
UsernameToggleButton.Position = UDim2.new(0.65, 0, 0, 40 + 25) -- Position right next to textbox
UsernameToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red (Off)
UsernameToggleButton.BorderSizePixel = 0
UsernameToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameToggleButton.TextSize = 14
UsernameToggleButton.Font = Enum.Font.SourceSansBold
UsernameToggleButton.Text = "OFF"
UsernameToggleButton.Parent = MainFrame

-- Display Name Spoofing Section
DisplayNameLabel.Size = UDim2.new(0.9, 0, 0, 20)
DisplayNameLabel.Position = calculatePosition(70)
DisplayNameLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DisplayNameLabel.BorderSizePixel = 0
DisplayNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayNameLabel.TextSize = 14
DisplayNameLabel.Font = Enum.Font.SourceSans
DisplayNameLabel.Text = "Spoof DisplayName (Local UI Only):"
DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
DisplayNameLabel.TextInset = UDim2.new(0.05, 0, 0, 0)
DisplayNameLabel.Parent = MainFrame

DisplayNameTextBox.Size = UDim2.new(0.6, 0, 0, 25)
DisplayNameTextBox.Position = calculatePosition(95)
DisplayNameTextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DisplayNameTextBox.BorderSizePixel = 0
DisplayNameTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayNameTextBox.TextSize = 14
DisplayNameTextBox.Font = Enum.Font.SourceSans
DisplayNameTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
DisplayNameTextBox.PlaceholderText = "Enter Fake DisplayName"
DisplayNameTextBox.Text = ""
DisplayNameTextBox.ClearTextOnFocus = false
DisplayNameTextBox.Parent = MainFrame

DisplayNameToggleButton.Size = UDim2.new(0.3, 0, 0, 25)
DisplayNameToggleButton.Position = UDim2.new(0.65, 0, 0, 40 + 95) -- Position right next to textbox
DisplayNameToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red (Off)
DisplayNameToggleButton.BorderSizePixel = 0
DisplayNameToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayNameToggleButton.TextSize = 14
DisplayNameToggleButton.Font = Enum.Font.SourceSansBold
DisplayNameToggleButton.Text = "OFF"
DisplayNameToggleButton.Parent = MainFrame

-- Anti-Kick Section
AntiKickToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
AntiKickToggleButton.Position = calculatePosition(140)
AntiKickToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red (Off)
AntiKickToggleButton.BorderSizePixel = 0
AntiKickToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiKickToggleButton.TextSize = 16
AntiKickToggleButton.Font = Enum.Font.SourceSansBold
-- Add the limitations directly in the button text
AntiKickToggleButton.Text = "Anti-Kick OFF (Limited Client Effect)"
AntiKickToggleButton.Parent = MainFrame

-- Logic Functions

-- Function to apply spoofed names
-- This function is conceptual. Actual implementation depends on the game's UI/nametag system.
-- You would typically hook into or modify the game's nametag script here.
local function applySpoofedNames()
    print("Attempting to apply spoofed names...")
    if spoofUsernameEnabled then
        print("Spoofing Username to:", desiredUsername)
        --[[
            Example (Highly Game/UI Specific):
            If the game uses default Roblox nametags (rare in complex games):
            LocalPlayer.DisplayName = desiredUsername -- This only changes it CLIENT-SIDE visually for YOU on the default nametag.
            LocalPlayer.Name = desiredUsername -- This does NOT change the actual server-side name, just your client's view.
                                                -- Could potentially affect some client-side scripts reading this property.

            If the game has custom nametags, you'd need to find that UI element and change its text.
            Example (Conceptual):
            local nametagGui = LocalPlayer.Character:FindFirstChild("Head"):FindFirstChild("NametagBillboardGui") -- Find the nametag UI
            if nametagGui and nametagGui:IsA("BillboardGui") then
                local nameLabel = nametagGui:FindFirstChild("NameLabel") -- Find the text label inside
                if nameLabel and nameLabel:IsA("TextLabel") then
                    nameLabel.Text = desiredUsername -- Change the visible text
                end
            end
            This requires knowing the exact hierarchy and names of the game's nametag UI.
        ]]
        -- For this generic script, we just store the value and print.
        -- The real application needs to modify the game's specific UI elements displaying names.
    else
        print("Spoofing Username is OFF.")
        -- Revert change if needed (again, game/UI specific)
    end

    if spoofDisplayNameEnabled then
        print("Spoofing DisplayName to:", desiredDisplayName)
        --[[
            Similar to username spoofing, this primarily affects local UI.
            Example (Conceptual):
            If the game uses default Roblox DisplayNames (often below Username on nametags):
            LocalPlayer.Display Name = desiredDisplayName -- This only changes it CLIENT-SIDE visually for YOU.
        ]]
        -- For this generic script, we just store the value and print.
    else
         print("Spoofing DisplayName is OFF.")
        -- Revert change if needed (again, game/UI specific)
    end

    if spoofUsernameEnabled or spoofDisplayNameEnabled then
         print("Spoofing states updated. Remember: Client-side spoofing primarily affects YOUR local view.")
    else
         print("Spoofing is completely OFF.")
    end
end

-- Function to enable Anti-Kick logic (limited)
local function enableAntiKick()
    print("Attempting to enable Anti-Kick...")
    warn("Client-side Anti-Kick is highly ineffective against legitimate server kicks!")
    --[[
        Placeholder for actual anti-kick logic.
        Possible (but unreliable and game-specific) client-side methods might involve:
        1. Hooking/Disabling specific RemoteEvents that trigger kicks *client-side*. (Requires Executor API)
        2. Attempting to rejoin immediately after a kick (Risky, often fails).
        3. Blocking specific network packets (Requires Executor API).

        A simple example (unreliable):
        local old_OnMessage = LocalPlayer.OnMessage -- Store original function
        LocalPlayer.OnMessage = function(message, fromServer)
            -- Disclaimer: Kicks are NOT typically sent as messages like this.
            -- This is just a *highly conceptual* example of intercepting *something*.
            if string.find(message:lower(), "kick") then
                print("Attempted to block a message containing 'kick':", message)
                return -- Try to block the