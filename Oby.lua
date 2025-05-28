--[[ 
    Roblox Universal Obby Anti-Jatuh Script (Floating & Auto Teleport) 
    by Copilot Chat Assistant
]]

local plr = game:GetService("Players").LocalPlayer
local guiName = "ObbyAntiFallUI"

-- Hapus panel lama
pcall(function() local a=plr.PlayerGui:FindFirstChild(guiName) if a then a:Destroy() end end)

-- Buat UI Panel
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = guiName
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 142)
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(24,30,45)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.Text = "Obby Anti-Jatuh Panel"
title.TextSize = 19
title.TextStrokeTransparency = 0.8

local function makeToggle(txt, ypos, callback)
    local t = Instance.new("TextLabel", frame)
    t.Size = UDim2.new(0.7, -20, 0, 32)
    t.Position = UDim2.new(0, 15, 0, ypos)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.Gotham
    t.TextSize = 15
    t.TextColor3 = Color3.fromRGB(200,220,255)
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = txt

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 66, 0, 30)
    btn.Position = UDim2.new(1, -80, 0, ypos+1)
    btn.BackgroundColor3 = Color3.fromRGB(180,40,40)
    btn.Text = "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 15
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(40,150,40) or Color3.fromRGB(180,40,40)
        callback(state)
    end)
    return btn
end

-- Fitur: Floating Pad
local pad = nil
function setFloating(on)
    if on then
        if not pad or not pad.Parent then
            pad = Instance.new("Part")
            pad.Anchored = true
            pad.CanCollide = true
            pad.Transparency = 0.8
            pad.Size = Vector3.new(6, 0.7, 6)
            pad.Color = Color3.fromRGB(60,255,120)
            pad.Name = "AntiFallPad"
            pad.Parent = workspace
        end
        pad.Transparency = 0.85
        pad.CanCollide = true
        pad.Material = Enum.Material.ForceField
        spawn(function()
            while pad and pad.Parent and wait(0.1) do
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local pos = char.HumanoidRootPart.Position
                    pad.Position = Vector3.new(pos.X, pos.Y - 3.1, pos.Z)
                end
            end
        end)
    else
        if pad then
            pcall(function() pad:Destroy() end)
            pad = nil
        end
    end
end

-- Fitur: Auto Teleport jika jatuh
local autoTP = false
local safePos = nil
function setAutoTP(on)
    autoTP = on
end

-- Update safePos otomatis tiap kali pemain di atas platform solid
game:GetService("RunService").Heartbeat:Connect(function()
    if not autoTP then return end
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        -- Cek apakah benar-benar "di atas platform"
        local ray = Ray.new(pos, Vector3.new(0, -5, 0))
        local hit = workspace:FindPartOnRay(ray, char)
        if hit and hit.CanCollide and hit.Name ~= "AntiFallPad" then
            safePos = pos + Vector3.new(0,2.7,0)
        end
        -- Jika jatuh di bawah Y tertentu, kembalikan ke posisi aman terakhir
        if safePos and pos.Y < (safePos.Y - 18) then
            char.HumanoidRootPart.CFrame = CFrame.new(safePos)
            if char:FindFirstChild("Humanoid") then char.Humanoid:ChangeState(11) end
        end
    end
end)

local t1 = makeToggle("Floating Pad di bawah kaki", 50, setFloating)
local t2 = makeToggle("Auto Teleport (jika jatuh)", 92, setAutoTP)

-- Minimize/Show
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -38, 0, 7)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 90)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.AutoButtonColor = true
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,c in pairs(frame:GetChildren()) do
        if c ~= minBtn and c ~= title then c.Visible = not minimized end
    end
    frame.Size = minimized and UDim2.new(0, 170, 0, 44) or UDim2.new(0, 320, 0, 142)
    minBtn.Text = minimized and "+" or "-"
end)

-- Hotkey [~] untuk show/hide panel
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Tilde or input.KeyCode == Enum.KeyCode.BackQuote then
        gui.Enabled = not gui.Enabled
    end
end)