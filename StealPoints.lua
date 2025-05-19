local players = game:GetService("Players")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera
local Range = math.min(getgenv().Range or 15, 15) -- Maksimal 15 agar aman anti-cheat

local function getPartsInViewport(maxDistance)
    local partsInViewport = {}
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local distance = player:DistanceFromCharacter(part.Position)
            if distance <= maxDistance then
                local _, isVisible = camera:WorldToViewportPoint(part.Position)
                if isVisible then
                    table.insert(partsInViewport, part)
                end
            end
        end
    end
    return partsInViewport
end

while true do
    wait(0.05) -- 2x lebih cepat dari default wait() (umumnya 0.1 - 0.2)
    if not player.Character then continue end
    local tool = player.Character:FindFirstChildOfClass("Tool")
    local parts = getPartsInViewport(Range)

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
