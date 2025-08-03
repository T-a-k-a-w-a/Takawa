--[[
Script Lengkap Multi Fitur + ESP Cornerbox Lengkap Terintegrasi
Dengan Rayfield UI Library (Ukuran UI untuk mobile smartphone 360x640 px)
]]

-- Inisialisasi Library Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mobile Hub Script",
   LoadingTitle = "Mobile Hub Loading",
   LoadingSubtitle = "Powered by Rayfield",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MobileHubConfigs",
      FileName = "MobileConfig"
   },
   Size = UDim2.new(0, 360, 0, 640), -- Ukuran panel 360x640 px untuk mobile screen
   Theme = "Default"
})

-- Buat tab-tab UI
local tabFeatures = Window:CreateTab("Features")
local tabESP = Window:CreateTab("ESP Features")
local tabLocation = Window:CreateTab("Location / Teleport")

-- Services & variabel global
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Fungsi helper: Ambil Humanoid dan HumanoidRootPart
local function getHumanoid()
	return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
	return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

--------------------------
-- Bagian ESP Cornerbox --
--------------------------

-- Settings ESP
local ESPSettings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Box_Thickness = 2,
    Team_Check = false,
    Team_Color = false,
    Autothickness = true
}

-- Fungsi membuat garis drawing baru
local function NewLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Vis(lib, state)
    for _, v in pairs(lib) do
        v.Visible = state
    end
end

local function Colorize(lib, color)
    for _, v in pairs(lib) do
        v.Color = color
    end
end

local function Rainbow(lib, delay)
    coroutine.wrap(function()
        while true do
            for hue = 0, 1, 1/30 do
                Colorize(lib, Color3.fromHSV(hue, 0.6, 1))
                task.wait(delay)
            end
        end
    end)()
end

-- Table menyimpan drawing dan event connections per player
local espLibraries = {}
local espConnections = {}

local espEnabled = false

local function CreateESP(plr)
    repeat task.wait() until plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart")
    
    local Library = {
        TL1 = NewLine(ESPSettings.Box_Color, ESPSettings.Box_Thickness),
        TL2 = NewLine(ESPSettings.Box_Color, ESPSettings.Box_Thickness),

        TR1 = NewLine(ESPSettings.Box_Color, ESPSettings.Box_Thickness),
        TR2 = NewLine(ESPSettings.Box_Color, ESPSettings.Box_Thickness),

        BL1 = NewLine(ESPSettings.Box_Color, ESPSettings.Box_Thickness),
        BL2 = NewLine(ESPSettings.Box_Color, ESPSettings.Box_Thickness),

        BR1 = NewLine(ESPSettings.Box_Color, ESPSettings.Box_Thickness),
        BR2 = NewLine(ESPSettings.Box_Color, ESPSettings.Box_Thickness)
    }
    
    espLibraries[plr] = Library
    Rainbow(Library, 0.15)

    local oripart = Instance.new("Part")
    oripart.Parent = Workspace
    oripart.Transparency = 1
    oripart.CanCollide = false
    oripart.Size = Vector3.new(1, 1, 1)
    oripart.Position = Vector3.new(0, 0, 0)

    espConnections[plr] = RunService.RenderStepped:Connect(function()
        local char = plr.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local Hum = char
            local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)

            if vis then
                oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y * 1.5, Hum.HumanoidRootPart.Size.Z)
                oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
                local SizeX = oripart.Size.X
                local SizeY = oripart.Size.Y
                local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
                local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
                local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
                local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

                if ESPSettings.Team_Check then
                    if plr.TeamColor == LocalPlayer.TeamColor then
                        Colorize(Library, Color3.fromRGB(0, 255, 0))
                    else
                        Colorize(Library, Color3.fromRGB(255, 0, 0))
                    end
                end

                if ESPSettings.Team_Color then
                    Colorize(Library, plr.TeamColor.Color)
                end

                local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).Magnitude
                local offset = math.clamp(1 / ratio * 750, 2, 300)

                Library.TL1.From = Vector2.new(TL.X, TL.Y)
                Library.TL1.To = Vector2.new(TL.X + offset, TL.Y)
                Library.TL2.From = Vector2.new(TL.X, TL.Y)
                Library.TL2.To = Vector2.new(TL.X, TL.Y + offset)

                Library.TR1.From = Vector2.new(TR.X, TR.Y)
                Library.TR1.To = Vector2.new(TR.X - offset, TR.Y)
                Library.TR2.From = Vector2.new(TR.X, TR.Y)
                Library.TR2.To = Vector2.new(TR.X, TR.Y + offset)

                Library.BL1.From = Vector2.new(BL.X, BL.Y)
                Library.BL1.To = Vector2.new(BL.X + offset, BL.Y)
                Library.BL2.From = Vector2.new(BL.X, BL.Y)
                Library.BL2.To = Vector2.new(BL.X, BL.Y - offset)

                Library.BR1.From = Vector2.new(BR.X, BR.Y)
                Library.BR1.To = Vector2.new(BR.X - offset, BR.Y)
                Library.BR2.From = Vector2.new(BR.X, BR.Y)
                Library.BR2.To = Vector2.new(BR.X, BR.Y - offset)

                Vis(Library, true)

                if ESPSettings.Autothickness then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - oripart.Position).Magnitude
                    local value = math.clamp(1 / distance * 100, 1, 4)
                    for _, x in pairs(Library) do
                        x.Thickness = value
                    end
                else
                    for _, x in pairs(Library) do
                        x.Thickness = ESPSettings.Box_Thickness
                    end
                end
            else
                Vis(Library, false)
            end
        else
            Vis(Library, false)
            if not Players:FindFirstChild(plr.Name) then
                for _, v in pairs(Library) do
                    v:Remove()
                end
                oripart:Destroy()
                espConnections[plr]:Disconnect()
                espConnections[plr] = nil
                espLibraries[plr] = nil
            end
        end
    end)
end

local function RemoveESP(plr)
    if espLibraries[plr] then
        for _, v in pairs(espLibraries[plr]) do
            v:Remove()
        end
        espLibraries[plr] = nil
    end
    if espConnections[plr] then
        espConnections[plr]:Disconnect()
        espConnections[plr] = nil
    end
end

-- Toggle ESP di UI
tabESP:CreateToggle({
    Name = "ESP Cornerbox",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(value)
        espEnabled = value
        if espEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    task.spawn(function()
                        CreateESP(plr)
                    end)
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                if espEnabled and plr ~= LocalPlayer then
                    task.spawn(function()
                        CreateESP(plr)
                    end)
                end
            end)
            Players.PlayerRemoving:Connect(function(plr)
                RemoveESP(plr)
            end)
        else
            for plr, _ in pairs(espLibraries) do
                RemoveESP(plr)
            end
        end
    end
})

------------------------
-- WalkSpeed & JumpPower Loop agar tidak reset game
------------------------

local walkSpeedEnabled = false
local jumpPowerEnabled = false
local desiredWalkSpeed = 16
local desiredJumpPower = 50

tabFeatures:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    StartingValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(value)
        desiredWalkSpeed = value
        walkSpeedEnabled = true
    end,
})

tabFeatures:CreateSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    StartingValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(value)
        desiredJumpPower = value
        jumpPowerEnabled = true
    end,
})

tabFeatures:CreateButton({
    Name = "Reset WalkSpeed & JumpPower",
    Callback = function()
        walkSpeedEnabled = false
        jumpPowerEnabled = false
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end,
})

RunService.RenderStepped:Connect(function()
    local hum = getHumanoid()
    if hum then
        if walkSpeedEnabled and hum.WalkSpeed ~= desiredWalkSpeed then
            hum.WalkSpeed = desiredWalkSpeed
        end
        if jumpPowerEnabled and hum.JumpPower ~= desiredJumpPower then
            hum.JumpPower = desiredJumpPower
        end
    end
end)

------------------------
-- Save Location dan Teleport Tween
------------------------
local savedLocations = {}

tabLocation:CreateTextBox({
    Name = "Nama Lokasi",
    PlaceholderText = "Masukan nama lokasi simpan",
    Flag = "LocationName",
    Callback = function(text)
        getgenv().last_save_name = text
    end,
})

tabLocation:CreateButton({
    Name = "Save Current Location",
    Callback = function()
        local hrp = getHRP()
        if hrp and getgenv().last_save_name and #getgenv().last_save_name > 0 then
            savedLocations[getgenv().last_save_name] = hrp.CFrame
            Window:Notify({
                Title = "Lokasi Disimpan",
                Content = "Berhasil menyimpan lokasi: "..getgenv().last_save_name,
                Duration = 4.5
            })
        end
    end,
})

local function getSavedLocationNames()
    local tbl = {}
    for k, _ in pairs(savedLocations) do
        table.insert(tbl, k)
    end
    return tbl
end

tabLocation:CreateDropdown({
    Name = "Saved Locations",
    Options = getSavedLocationNames(),
    Flag = "SavedLocationsDropdown",
    Callback = function(locationName)
        getgenv().selected_location = locationName
    end,
})

tabLocation:CreateButton({
    Name = "Tween Teleport ke Selected",
    Callback = function()
        local destName = getgenv().selected_location
        local hrp = getHRP()
        if destName and savedLocations[destName] and hrp then
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = savedLocations[destName]})
            tween:Play()
            Window:Notify({
                Title = "Teleport Sukses",
                Content = "Berhasil teleport ke: "..destName,
                Duration = 3,
            })
        end
    end,
})

------------------------
-- Clone Character dari username
------------------------
tabFeatures:CreateTextBox({
    Name = "Username untuk Clone",
    PlaceholderText = "Masukan username target",
    Flag = "CloneUsername",
    Callback = function(text)
        getgenv().clone_user = text
    end,
})

tabFeatures:CreateButton({
    Name = "Copy/Clone Character",
    Callback = function()
        local selected = Players:FindFirstChild(getgenv().clone_user)
        local myChar = LocalPlayer.Character
        if selected and selected.Character and myChar then
            for _, obj in pairs(myChar:GetChildren()) do
                if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") then
                    obj:Destroy()
                end
            end
            for _, item in pairs(selected.Character:GetChildren()) do
                if item:IsA("Accessory") then
                    item:Clone().Parent = myChar
                elseif item:IsA("Shirt") or item:IsA("Pants") then
                    item:Clone().Parent = myChar
                end
            end
            Window:Notify({
                Title = "Clone Success",
                Content = "Character cloned dari: "..getgenv().clone_user,
                Duration = 4,
            })
        else
            Window:Notify({
                Title = "Error",
                Content = "User atau character tidak ditemukan.",
                Duration = 3
            })
        end
    end,
})

------------------------
-- Invisible character (tool method)
------------------------
tabFeatures:CreateButton({
    Name = "Invisible (Tool Method)",
    Callback = function()
        local back = LocalPlayer.Backpack
        local char = LocalPlayer.Character
        if back and #back:GetChildren() > 0 and char then
            local tool = back:GetChildren()[1]
            tool.Parent = char
            task.wait(0.1)
            if tool:FindFirstChild("Handle") then
                tool.Handle:Destroy()
                Window:Notify({
                    Title = "Invisible",
                    Content = "Character sekarang invisible (tool handle destroyed)",
                    Duration = 4,
                })
            end
        else
            Window:Notify({
                Title = "Error",
                Content = "Tidak ada tool di Backpack",
                Duration = 3,
            })
        end
    end,
})

------------------------
-- Slow Fall toggle
------------------------
local slowfall_enabled = false

tabFeatures:CreateToggle({
    Name = "Slow Fall",
    CurrentValue = false,
    Flag = "SlowFallToggle",
    Callback = function(state)
        slowfall_enabled = state
    end,
})

RunService.RenderStepped:Connect(function()
    if slowfall_enabled then
        local hum = getHumanoid()
        if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
            hum.JumpPower = 25
        elseif hum then
            hum.JumpPower = 50
        end
    end
end)

------------------------
-- No Fall Damage toggle
------------------------
local anti_fall = false

tabFeatures:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = false,
    Flag = "NoFallDamageToggle",
    Callback = function(state)
        anti_fall = state
    end,
})

if setreadonly and getrawmetatable then
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(self) == "Humanoid" and anti_fall and (method == "TakeDamage" or method == "BreakJoints") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

------------------------
-- Anti Loading Gameplay toggle
------------------------
local anti_loading_enabled = false
local last_walking_pos = nil
local last_humanoid_walkspeed = 16

tabFeatures:CreateToggle({
    Name = "Anti Loading Gameplay",
    CurrentValue = false,
    Flag = "AntiLoadingToggle",
    Callback = function(state)
        anti_loading_enabled = state
        if state then
            local hum = getHumanoid()
            if hum then last_humanoid_walkspeed = hum.WalkSpeed end
        end
    end,
})

local function isLoadingScreen()
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name:lower():find("load") then
            if gui.Enabled ~= false then return true end
        end
    end
    return false
end

RunService.RenderStepped:Connect(function()
    if not anti_loading_enabled then return end

    local hum = getHumanoid()
    local hrp = getHRP()
    if not hum or not hrp then return end

    if isLoadingScreen() then
        if not last_walking_pos or (hrp.Position - last_walking_pos).Magnitude > 1 then
            last_walking_pos = hrp.Position
        end
        hum.WalkSpeed = last_humanoid_walkspeed
        hum.PlatformStand = false
        hum.Sit = false
    else
        if last_walking_pos then
            local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad)
            local tween = TweenService:Create(hrp, tweenInfo, {Position = last_walking_pos})
            tween:Play()
            last_walking_pos = nil
        end
    end
end)

------------------------
-- Loop utama menjaga WalkSpeed dan JumpPower konsisten (tidak di-reset)
------------------------
RunService.RenderStepped:Connect(function()
    local hum = getHumanoid()
    if hum then
        if walkSpeedEnabled and hum.WalkSpeed ~= desiredWalkSpeed then
            hum.WalkSpeed = desiredWalkSpeed
        end
        if jumpPowerEnabled and hum.JumpPower ~= desiredJumpPower then
            hum.JumpPower = desiredJumpPower
        end
    end
end)

print("Semua fitur telah terintegrasi lengkap di Rayfield UI dengan ESP Cornerbox.")
