local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Range = math.min(getgenv().Range or 15, 15)
local enabled = true -- Status panel

-- ===== GUI PANEL =====
local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
screenGui.Name = "AutoAttackPanel"
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 140, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 200)
toggleButton.Text = "AutoAttack: ON"
toggleButton.BackgroundColor3 = Color3.fromRGB(40,180,40)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.TextSize = 20

toggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleButton.Text = "AutoAttack: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40,180,40)
    else
        toggleButton.Text = "AutoAttack: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180,40,40)
    end
end)

-- ===== FUNC: Ambil Bagian Musuh Terdekat =====
local function getNearbyParts(maxDistance)
    local parts = {}
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local distance = LocalPlayer:DistanceFromCharacter(part.Position)
            if distance <= maxDistance then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

-- ===== FUNC: Damage Musuh =====
local function damageTarget(humanoid, hitPos, partPos)
    local dist = (hitPos - partPos).Magnitude
    if dist <= 1 then
        humanoid.Health = 0 -- Instant kill
    else
        humanoid.Health = math.max(0, humanoid.Health - 30) -- Partial hit
    end
end

-- ===== SPEED + REGEN =====
game:GetService("RunService").Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.WalkSpeed = 18
        if h.Health < 100 then
            h.Health = math.min(100, h.Health + 2.5) -- 2.5 per tick (0.05s) = 50/detik
        end
    end
end)

-- ===== AUTO ATTACK LOOP =====
spawn(function()
    while true do
        wait(0.05)
        if not enabled then continue end
        if not LocalPlayer.Character then continue end
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local parts = getNearbyParts(Range)
        if tool and tool:FindFirstChild("Handle") then
            for _, part in ipairs(parts) do
                local parent = part.Parent
                if parent and parent ~= LocalPlayer.Character then
                    local humanoid = parent:FindFirstChildWhichIsA("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        tool:Activate()
                        firetouchinterest(tool.Handle, part, 0)
                        firetouchinterest(tool.Handle, part, 1)
                        -- ===== APPLY DAMAGE =====
                        damageTarget(humanoid, tool.Handle.Position, part.Position)
                    end
                end
            end
        end
    end
end)