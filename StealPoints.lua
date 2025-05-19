local players = game:GetService("Players")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

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
    wait()
local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
local parts = getPartsInViewport(Range)

if tool and tool:FindFirstChild("Handle") then
for _, part in ipairs(parts) do
if part and part.Parent and part.Parent ~= game.Players.localPlayer.Character and part.Parent:FindFirstChildWhichIsA("Humanoid") and part.Parent:FindFirstChildWhichIsA("Humanoid").Health > 0 then
                        tool:Activate()
                        firetouchinterest(tool.Handle,part,0)
                        firetouchinterest(tool.Handle,part,1)
end
end
end
end
