-- ULTIMATE ROBLOX ACCOUNT PROTECTION SCRIPT v4.0
-- © Takawa, Enhanced by Copilot Chat Assistant

if not game:IsLoaded() then game.Loaded:Wait() end

-- Notifikasi awal
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "PROTECT",
        Text = "Ultimate Protection v4 Aktif",
        Duration = 8
    })
end)

local Players, HttpService = game:GetService("Players"), game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Spoof Data Device & Akun
getgenv().spoofData = {
    IP = "192.168.43." .. tostring(math.random(2, 254)),
    HWID = HttpService:GenerateGUID(false),
    Username = "武田" .. tostring(math.random(1000,9999)),
    UserId = math.random(1000000,9999999),
    AccountAge = math.random(366, 1000),
    SSID = "Tokyo_WiFi_" .. tostring(math.random(1000,9999)),
    BSSID = "00:24:D7:" .. tostring(math.random(10,99)) .. ":" .. tostring(math.random(10,99)) .. ":" .. tostring(math.random(10,99))
}

-- Spoof fungsi penting
pcall(function()
    hookfunction(getrenv().print, newcclosure(function(...) return end))
    hookfunction(getrenv().warn, newcclosure(function(...) return end))
    hookfunction(getrenv().require, newcclosure(function(...) return {} end))
    hookfunction(getrenv().getfenv, newcclosure(function() return {} end))
    hookfunction(getrenv().getgenv, newcclosure(function() return {} end))
    hookfunction(getrenv().setfenv, newcclosure(function() end))
end)

-- Anti-Kick & Anti-Ban universal
for _, service in pairs(getnilinstances()) do
    if pcall(function() return service.Kick end) then
        hookfunction(service.Kick, newcclosure(function() return end))
    end
end

local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Anti Kick
    if method == "Kick" then return end

    -- Bypass Remote
    if method == "FireServer" or method == "InvokeServer" then
        local remote = tostring(self)
        if remote:lower():match("log") or remote:lower():match("ban") or remote:lower():match("alt") then
            return wait(math.huge)
        end
    end

    return oldNamecall(self, unpack(args))
end)

-- Anti Alt Account Detection
pcall(function()
    if LocalPlayer.AccountAge < 100 then
        LocalPlayer.AccountAge = math.random(365, 999)
    end
end)

-- Spoofing UserId
pcall(function()
    LocalPlayer.UserId = spoofData.UserId
    LocalPlayer.Name = spoofData.Username
end)

-- Chat Logger Protection
local oldHook
oldHook = hookfunction(getrenv().hookfunction or function() end, function(target, func)
    if tostring(target):lower():match("chathook") or tostring(target):lower():match("logger") then
        return function(...) return end
    end
    return oldHook(target, func)
end)

-- Auto Cleaner Log (anti console spy)
local function clearLogs()
    pcall(function()
        rconsoleclear()
        for i = 1, 10 do print("\n\n\n") end
    end)
end

-- Obfuscasi Karakter
pcall(function()
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.5
                part.Name = HttpService:GenerateGUID(false):sub(1, 8)
            end
        end
    end
end)

-- Bypass cheat detection (fly, walkspeed, dll)
local function spoofHumanoidValues()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.WalkSpeed = 16
    hum.JumpPower = 50
    hum:SetAttribute("AntiCheat", false)
end

spoofHumanoidValues()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    spoofHumanoidValues()
end)

-- Anti Deteksi Shared / getgenv
getgenv = function() return setmetatable({}, {__index = function() return nil end}) end
shared = setmetatable({}, {__index = function() return nil end})

-- Log protection berjalan terus
task.spawn(function()
    while task.wait(5) do
        clearLogs()
    end
end)

-- Backup Otomatis ke GitHub user jika terhubung (tidak error jika offline)
pcall(function()
    local backup = game:HttpGet("https://raw.githubusercontent.com/T-a-k-a-w-a/Takawa/refs/heads/main/Protect.lua")
    if not backup or #backup < 100 then
        writefile("ProtectBackup.lua", "-- BACKUP OTOMATIS\n\n" .. original_script)
    end
end)
