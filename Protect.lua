--[[ 
 ██████╗ ██████╗ ███████╗ ██████╗ ████████╗███████╗ ██████╗██╗  ██╗
██╔════╝██╔═══██╗██╔════╝██╔═══██╗╚══██╔══╝██╔════╝██╔════╝██║ ██╔╝
██║     ██║   ██║█████╗  ██║   ██║   ██║   █████╗  ██║     █████╔╝ 
██║     ██║   ██║██╔══╝  ██║   ██║   ██║   ██╔══╝  ██║     ██╔═██╗ 
╚██████╗╚██████╔╝██║     ╚██████╔╝   ██║   ███████╗╚██████╗██║  ██╗
 ╚═════╝ ╚═════╝ ╚═╝      ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝
   >> PROTECT v3.2 Enhanced | By Takawa <<
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

--[[ ✅ 1. Basic Anti-Kick ]]
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if self == player and (method == "Kick" or method == "kick") then
        warn("[PROTECT] Blocked Kick Attempt:", debug.traceback())
        return nil
    end
    return oldNamecall(self, ...)
end)

--[[ 🔒 2. Lock HumanoidStateType ]]
task.spawn(function()
    while task.wait(0.5) do
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        end
    end
end)

--[[ 🚫 3. Anti Crasher ]]
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum.WalkSpeed > 1000 or hum.JumpPower > 500 or hum.Health <= 0 then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.Health = 100
            warn("[PROTECT] Detected and Prevented Crasher Attempt")
        end
    end
end)

--[[ 🛡️ 4. Anti Delete Character ]]
player.CharacterRemoving:Connect(function(char)
    warn("[PROTECT] Prevented Character Deletion")
    player.Character = char
end)

--[[ 🕵️‍♂️ 5. Anti CoreGui Disable ]]
if gethui then
    local function protectGui()
        for _, obj in pairs(CoreGui:GetChildren()) do
            if obj:IsA("ScreenGui") and not obj.Enabled then
                obj.Enabled = true
                warn("[PROTECT] Re-enabled GUI:", obj.Name)
            end
        end
    end

    RunService.RenderStepped:Connect(protectGui)
end

--[[ 🌀 6. Auto-Reload Protection (URL cadangan) ]]
local backupURL = "https://raw.githubusercontent.com/T-a-k-a-w-a/Takawa/refs/heads/main/Protect.lua"

game.DescendantRemoving:Connect(function(obj)
    if obj:IsA("LocalScript") and obj.Name:lower():find("protect") then
        warn("[🌀 Reloading Protection from YOUR GitHub Backup URL]")
        loadstring(game:HttpGet(backupURL))()
    end
end)

--[[ ✅ 7. Anti-Property Override (WalkSpeed, JumpPower, Health) ]]
local function protectProperty(hum, prop, limit)
    local old = hum[prop]
    hum:GetPropertyChangedSignal(prop):Connect(function()
        if hum[prop] ~= old then
            warn("[PROTECT] Blocked Change to", prop, ":", hum[prop])
            hum[prop] = old
        end
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                protectProperty(hum, "WalkSpeed", 16)
                protectProperty(hum, "JumpPower", 50)
                protectProperty(hum, "Health", 100)
            end
        end
    end
end)

--[[ 🔃 8. Respawn Auto-Reapply Protection ]]
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    warn("[PROTECT] Character Respawned. Reapplying Protection...")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        hum.Health = 100
    end
end)

--[[ ✅ 9. Anti-Humanoid Replacement ]]
player.CharacterAdded:Connect(function(char)
    char.ChildRemoved:Connect(function(obj)
        if obj:IsA("Humanoid") then
            warn("[PROTECT] Prevented Humanoid Deletion")
            local newHum = Instance.new("Humanoid")
            newHum.Parent = char
        end
    end)
end)

--[[ ☑️ 10. Info ]]
warn("[PROTECT v3.2 Enhanced] ✅ Active and Monitoring")
