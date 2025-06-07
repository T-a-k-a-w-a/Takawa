-- ⚙️ Variabel Global
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- 🎮 UI Dasar
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateCheats"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 1000)
MainFrame.Position = UDim2.new(0.75, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- 📱 Header UI
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Header.Text = "Ultimate Cheats v3.0"
Header.Font = Enum.Font.GothamBold
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Parent = MainFrame

-- 🗑️ Tombol Minimize
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.Parent = Header

-- 📝 Spoof Username
local SpoofFrame = Instance.new("Frame")
SpoofFrame.Size = UDim2.new(1, 0, 0, 80)
SpoofFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpoofFrame.Parent = MainFrame

local SpoofLabel = Instance.new("TextLabel")
SpoofLabel.Size = UDim2.new(1, 0, 0, 20)
SpoofLabel.Text = "Spoof Username"
SpoofLabel.Font = Enum.Font.GothamBold
SpoofLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpoofLabel.Parent = SpoofFrame

local SpoofInput = Instance.new("TextBox")
SpoofInput.Size = UDim2.new(1, -10, 0, 30)
SpoofInput.Position = UDim2.new(0, 5, 0, 25)
SpoofInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpoofInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpoofInput.PlaceholderText = "Masukkan Nama Baru"
SpoofInput.Parent = SpoofFrame

local SpoofButton = Instance.new("TextButton")
SpoofButton.Size = UDim2.new(1, -10, 0, 20)
SpoofButton.Position = UDim2.new(0, 5, 0, 60)
SpoofButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SpoofButton.Text = "Ganti Nama"
SpoofButton.Font = Enum.Font.GothamBold
SpoofButton.TextColor3 = Color3.fromRGB(0, 0, 0)
SpoofButton.Parent = SpoofFrame

SpoofButton.MouseButton1Click:Connect(function()
    local newName = SpoofInput.Text
    if newName ~= "" then
        SpoofButton.Text = "Sudah Di Ganti"
        LocalPlayer.DisplayName = newName
        LocalPlayer.Name = newName
    end
end)

-- 📋 Copy JobID/Link
local CopyFrame = Instance.new("Frame")
CopyFrame.Size = UDim2.new(1, 0, 0, 100)
CopyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyFrame.Parent = MainFrame

local CopyJobID = Instance.new("TextButton")
CopyJobID.Size = UDim2.new(1, -10, 0, 20)
CopyJobID.Position = UDim2.new(0, 5, 0, 5)
CopyJobID.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CopyJobID.Text = "Copy JobID"
CopyJobID.Font = Enum.Font.GothamBold
CopyJobID.TextColor3 = Color3.fromRGB(0, 0, 0)
CopyJobID.Parent = CopyFrame

CopyJobID.MouseButton1Click:Connect(function()
    setclipboard(game.JobId)
    CopyJobID.Text = "Copied!"
    wait(2)
    CopyJobID.Text = "Copy JobID"
end)

local CopyLink = Instance.new("TextButton")
CopyLink.Size = UDim2.new(1, -10, 0, 20)
CopyLink.Position = UDim2.new(0, 5, 0, 30)
CopyLink.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CopyLink.Text = "Copy Link Server"
CopyLink.Font = Enum.Font.GothamBold
CopyLink.TextColor3 = Color3.fromRGB(0, 0, 0)
CopyLink.Parent = CopyFrame

CopyLink.MouseButton1Click:Connect(function()
    local link = "https://www.roblox.com/games/"  .. game.PlaceId .. "?privateServerLinkCode=" .. game.JobId
    setclipboard(link)
    CopyLink.Text = "Copied!"
    wait(2)
    CopyLink.Text = "Copy Link Server"
end)

-- 🚪 Join via JobID/Link
local JoinFrame = Instance.new("Frame")
JoinFrame.Size = UDim2.new(1, 0, 0, 80)
JoinFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JoinFrame.Parent = MainFrame

local JoinInput = Instance.new("TextBox")
JoinInput.Size = UDim2.new(1, -10, 0, 30)
JoinInput.Position = UDim2.new(0, 5, 0, 5)
JoinInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JoinInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinInput.PlaceholderText = "Paste JobID/Link"
JoinInput.Parent = JoinFrame

local JoinButton = Instance.new("TextButton")
JoinButton.Size = UDim2.new(1, -10, 0, 20)
JoinButton.Position = UDim2.new(0, 5, 0, 40)
JoinButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
JoinButton.Text = "Join Server"
JoinButton.Font = Enum.Font.GothamBold
JoinButton.TextColor3 = Color3.fromRGB(0, 0, 0)
JoinButton.Parent = JoinFrame

JoinButton.MouseButton1Click:Connect(function()
    local input = JoinInput.Text
    if string.match(input, "https://www.roblox.com/games/%d+")  then
        local placeId = string.match(input, "%d+")
        TeleportService:Teleport(placeId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(tonumber(input), game.JobId, LocalPlayer)
    end
end)

-- 🚶 WalkSpeed
local WalkSpeedFrame = Instance.new("Frame")
WalkSpeedFrame.Size = UDim2.new(1, 0, 0, 120)
WalkSpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
WalkSpeedFrame.Parent = MainFrame

local WalkSpeedSlider = Instance.new("TextBox")
WalkSpeedSlider.Size = UDim2.new(1, -10, 0, 20)
WalkSpeedSlider.Position = UDim2.new(0, 5, 0, 25)
WalkSpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WalkSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedSlider.PlaceholderText = "WalkSpeed (Default: 16)"
WalkSpeedSlider.Parent = WalkSpeedFrame

local SetSpeedButton = Instance.new("TextButton")
SetSpeedButton.Size = UDim2.new(1, -10, 0, 20)
SetSpeedButton.Position = UDim2.new(0, 5, 0, 50)
SetSpeedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SetSpeedButton.Text = "Set Speed"
SetSpeedButton.Font = Enum.Font.GothamBold
SetSpeedButton.TextColor3 = Color3.fromRGB(0, 0, 0)
SetSpeedButton.Parent = WalkSpeedFrame

SetSpeedButton.MouseButton1Click:Connect(function()
    local speed = tonumber(WalkSpeedSlider.Text)
    if speed then
        Humanoid.WalkSpeed = speed
    end
end)

-- 🔁 X2 Speed
local X2Button = Instance.new("TextButton")
X2Button.Size = UDim2.new(0.4, 0, 0, 20)
X2Button.Position = UDim2.new(0, 5, 0, 75)
X2Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
X2Button.Text = "X2 Speed"
X2Button.Font = Enum.Font.GothamBold
X2Button.TextColor3 = Color3.fromRGB(0, 0, 0)
X2Button.Parent = WalkSpeedFrame

X2Button.MouseButton1Click:Connect(function()
    Humanoid.WalkSpeed = Humanoid.WalkSpeed * 2
end)

-- 🔒 Lock WalkSpeed
local LockSpeed = false
local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.new(0.5, 0, 0, 20)
LockButton.Position = UDim2.new(0.5, 5, 0, 75)
LockButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
LockButton.Text = "Lock Speed: OFF"
LockButton.Font = Enum.Font.GothamBold
LockButton.TextColor3 = Color3.fromRGB(0, 0, 0)
LockButton.Parent = WalkSpeedFrame

LockButton.MouseButton1Click:Connect(function()
    LockSpeed = not LockSpeed
    LockButton.Text = "Lock Speed: " .. (LockSpeed and "ON" or "OFF")
end)

RunService.Stepped:Connect(function()
    if LockSpeed then
        Humanoid.WalkSpeed = Humanoid.WalkSpeed
    end
end)

-- ✈️ Fly Mode
local Flying = false
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(1, -10, 0, 20)
FlyButton.Position = UDim2.new(0, 5, 0, 100)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FlyButton.Text = "Aktifkan Terbang"
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FlyButton.Parent = WalkSpeedFrame

FlyButton.MouseButton1Click:Connect(function()
    Flying = not Flying
    FlyButton.Text = Flying and "Nonaktifkan Terbang" or "Aktifkan Terbang"
    if Flying then
        local BodyGyro = Instance.new("BodyGyro")
        local BodyVelocity = Instance.new("BodyVelocity")
        BodyGyro.P = 9e4
        BodyGyro.D = 1e3
        BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Velocity = Vector3.new()
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.Parent = Character.HumanoidRootPart
        BodyVelocity.Parent = Character.HumanoidRootPart
        RunService.Stepped:Connect(function()
            if Flying then
                BodyGyro.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(0), 0)
                BodyVelocity.Velocity = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    Character.HumanoidRootPart.Anchored = false
                    BodyVelocity.Velocity = Vector3.new(0, 100, 0)
                end
            else
                BodyGyro:Destroy()
                BodyVelocity:Destroy()
            end
        end)
    end
end)

-- 🧲 ESP Player
local ESPEnabled = false
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -10, 0, 20)
ESPButton.Position = UDim2.new(0, 5, 0, 125)
ESPButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ESPButton.Text = "ESP Player: OFF"
ESPButton.Font = Enum.Font.GothamBold
ESPButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ESPButton.Parent = WalkSpeedFrame

ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPButton.Text = "ESP Player: " .. (ESPEnabled and "ON" or "OFF")
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            pcall(function()
                local Billboard = Instance.new("BillboardGui")
                Billboard.Name = "ESP"
                Billboard.AlwaysOnTop = true
                Billboard.Size = UDim2.new(0, 200, 0, 50)
                Billboard.Adornee = Player.Character:FindFirstChild("HumanoidRootPart")
                local Text = Instance.new("TextLabel")
                Text.Size = UDim2.new(1, 0, 1, 0)
                Text.Text = Player.Name
                Text.TextColor3 = Color3.fromRGB(255, 0, 0)
                Text.Font = Enum.Font.GothamBold
                Text.BackgroundTransparency = 1
                Text.Parent = Billboard
                Billboard.Parent = Workspace.CurrentCamera
            end)
        end
    end
end)

-- 🚪 Server Hop
local ServerHopButton = Instance.new("TextButton")
ServerHopButton.Size = UDim2.new(1, -10, 0, 20)
ServerHopButton.Position = UDim2.new(0, 5, 0, 150)
ServerHopButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ServerHopButton.Text = "Pindah Server"
ServerHopButton.Font = Enum.Font.GothamBold
ServerHopButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ServerHopButton.Parent = WalkSpeedFrame

ServerHopButton.MouseButton1Click:Connect(function()
    local Servers = TeleportService:GetSortedGameInstancesAsync(tonumber(game.PlaceId))
    for _, Server in pairs(Servers) do
        if Server.playing ~= LocalPlayer.Name then
            TeleportService:TeleportToPlaceInstance(tonumber(game.PlaceId), Server.id, LocalPlayer)
            break
        end
    end
end)

-- 🧱 Anti Noclip
local AntiNoclip = false
local AntiNoclipButton = Instance.new("TextButton")
AntiNoclipButton.Size = UDim2.new(1, -10, 0, 20)
AntiNoclipButton.Position = UDim2.new(0, 5, 0, 175)
AntiNoclipButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AntiNoclipButton.Text = "Anti Noclip: OFF"
AntiNoclipButton.Font = Enum.Font.GothamBold
AntiNoclipButton.TextColor3 = Color3.fromRGB(0, 0, 0)
AntiNoclipButton.Parent = WalkSpeedFrame

AntiNoclipButton.MouseButton1Click:Connect(function()
    AntiNoclip = not AntiNoclip
    AntiNoclipButton.Text = "Anti Noclip: " .. (AntiNoclip and "ON" or "OFF")
    while AntiNoclip do
        wait()
        for _, Part in pairs(Workspace:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.Anchored = false
                Part:GetPropertyChangedSignal("Anchored"):Wait()
            end
        end
    end
end)

-- 📱 Fungsi Minimize UI
MinimizeButton.MouseButton1Click:Connect(function()
    for _, Child in pairs(MainFrame:GetChildren()) do
        if Child:IsA("Frame") then
            Child.Visible = not Child.Visible
        end
    end
    MinimizeButton.Text = Child.Visible and "-" or "+"
end)

-- 🖱️ Fungsi Drag UI
local dragging, dragInput, dragStart, startPosition
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)