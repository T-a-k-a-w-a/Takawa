local players = game:GetService("Players")
local player = players.LocalPlayer
local Range = math.min(getgenv().Range or 15, 15)
local regenPerTick = 2.5 -- 2.5 x 20 = 50 per detik
local regenInterval = 0.05

-- Auto Attack segala arah
function getNearbyParts(maxDistance)
    local parts = {}
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local distance = player:DistanceFromCharacter(part.Position)
            if distance <= maxDistance then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

-- Speed 2x lipat
game:GetService("RunService").Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 18
    end
end)

-- Regen Cepat
spawn(function()
    while true do
        wait(regenInterval)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h.Health < 100 then
                h.Health = math.min(100, h.Health + regenPerTick)
            end
        end
    end
end)

-- Auto Attack
while true do
    wait(0.05)
    if not player.Character then continue end
    local tool = player.Character:FindFirstChildOfClass("Tool")
    local parts = getNearbyParts(Range)
    if tool and tool:FindFirstChild("Handle") then
        for _, part in ipairs(parts) do
            local parent = part.Parent
            if parent and parent ~= player.Character then
                local humanoid = parent:FindFirstChildWhichIsA("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    tool:Activate()
                    firetouchinterest(tool.Handle, part, 0)
                    firetouchinterest(tool.Handle, part, 1)
                end
            end
        end
    end
end
