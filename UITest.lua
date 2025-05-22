-- WindUI Custom for Fisch (No watermark, key, dll)
-- by Copilot Chat Assistant (for T-a-k-a-w-a)

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/WindUI.lua"))()
local Gui = WindUI:Create("Fisch Premium Scripts", "by T-a-k-a-w-a", 0, false) -- judul panel bebas

local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local run = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local spoofName, spoofUser, spoofLvl, spoofMoney = "", "", 1, 0

-- ========== ANTI CHAT NAMA/IKAN ==========
local function blockFishingChat()
    -- Coba hook peristiwa chat/remote yang broadcast nama/ikan
    local function hookChat()
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and islclosure(v) and not is_synapse_function(v) then
                local info = debug.getinfo(v)
                if info.name and (info.name:lower():find("catch") or info.name:lower():find("fish") or info.name:lower():find("chat")) then
                    hookfunction(v, function(...)
                        -- Blokir chat hasil pancingan
                        return
                    end)
                end
            end
        end
    end
    hookChat()
end

-- ========== SPOOF NAMA / USERNAME =============
local function spoofNameFunc(name, username)
    spoofName = name
    spoofUser = username
    -- Ganti displayName dan Name di UI (jika ada)
    pcall(function()
        plr.DisplayName = name
        plr.Name = username
    end)
    -- Ganti di leaderboard (jika ada)
    for _,v in pairs(Players:GetPlayers()) do
        if v == plr then
            v.DisplayName = name
            v.Name = username
        end
    end
    -- Ganti di UI
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextBox") and v.Text and (v.Text:find(plr.Name) or v.Text:find(plr.DisplayName)) then
            v.Text = v.Text:gsub(plr.Name, name):gsub(plr.DisplayName, name)
        end
    end
end

-- ========== HIDE STREAK ===========
local function hideStreak()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:lower():find("streak") then
            v.Visible = false
        end
    end
end

-- ========== INVISIBLE ===========
local invis = false
local function setInvisible(state)
    invis = state
    for _,v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = state and 1 or 0
            if v:FindFirstChildOfClass("Decal") then
                v:FindFirstChildOfClass("Decal").Transparency = state and 1 or 0
            end
        elseif v:IsA("Accessory") then
            v.Handle.Transparency = state and 1 or 0
        end
    end
end

-- ========== NOCLIP & FLOAT ===========
local noclip, float = false, false
run.Stepped:Connect(function()
    if noclip and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        for _,v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if float and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,20,0)
    end
end)

-- ========== SPOOF LEVEL & UANG ==========
local function spoofLevelMoney(level, money)
    spoofLvl = tonumber(level) or 1
    spoofMoney = tonumber(money) or 0
    -- Coba cari UI level/uang dan ganti
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("TextLabel") then
            if v.Text:lower():find("level") then v.Text = "Level: "..spoofLvl end
            if v.Text:lower():find("money") or v.Text:lower():find("cash") or v.Text:lower():find("uang") then
                v.Text = "Money: "..spoofMoney
            end
        end
    end
end

-- ========== DETEKSI STAFF / MODERATOR ==========
local MOD_LIST = {"mod","staff","admin","manager","dev","owner"}
local function checkStaff(p)
    local isStaff = false
    local lowername = p.Name:lower()
    local lowerdisp = p.DisplayName and p.DisplayName:lower() or ""
    for _,word in ipairs(MOD_LIST) do
        if lowername:find(word) or lowerdisp:find(word) then
            isStaff = true
        end
    end
    return isStaff
end
local function notifyStaff(name)
    StarterGui:SetCore("SendNotification", {
        Title = "!! STAFF/MODERATOR ALERT !!",
        Text = name.." masuk server!\nSegera aktifkan mode aman!",
        Duration = 7
    })
end
Players.PlayerAdded:Connect(function(p)
    if checkStaff(p) then
        notifyStaff(p.DisplayName or p.Name)
    end
end)
-- Cek pemain yang sudah ada
for _,p in ipairs(Players:GetPlayers()) do
    if p ~= plr and checkStaff(p) then
        notifyStaff(p.DisplayName or p.Name)
    end
end

-- ========== WINDUI PANEL ==========

local mainTab = Gui:Tab("Main")
mainTab:Section("Spoof & Proteksi")
mainTab:Toggle("Anti Chat Nama/Ikan", false, function(state)
    if state then blockFishingChat() end
end)
mainTab:Button("Hide Streak", hideStreak)

mainTab:Toggle("Invisible", false, setInvisible)
mainTab:Toggle("NoClip", false, function(state) noclip = state end)
mainTab:Toggle("Float (Terbang)", false, function(state) float = state end)

mainTab:Section("Spoof Data")
mainTab:Box("Spoof Nama", function(txt)
    spoofNameFunc(txt, spoofUser)
end)
mainTab:Box("Spoof Username", function(txt)
    spoofNameFunc(spoofName, txt)
end)
mainTab:Box("Spoof Level", function(txt)
    spoofLevelMoney(txt, spoofMoney)
end)
mainTab:Box("Spoof Uang", function(txt)
    spoofLevelMoney(spoofLvl, txt)
end)

mainTab:Label("Deteksi Staff aktif otomatis")
mainTab:Label("Panel WindUI by Copilot Chat Assistant")