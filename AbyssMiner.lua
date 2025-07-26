--================================================================--
--      SKRIP VERSI FINAL LENGKAP (RAYFIELD) - OLEH PARTNER CODING     --
--================================================================--

-- Notifikasi Progres Pemuatan
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "1% - Memulai eksekusi...", Duration = 2 }) end)
local startTime = tick()
task.wait(1)

-- Pemuatan Library yang Aman
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Script Error", Text = "Gagal memuat Rayfield. Periksa konsol (F9).", Duration = 10 })
    warn("Rayfield Gagal Dimuat! Error: " .. tostring(Rayfield))
    return
end

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "10% - Library UI berhasil dimuat.", Duration = 2 }) end)

-- Variabel Global & Services
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variabel Status Fitur
local instantMineEnabled, antiFallDamageEnabled, flyEnabled, autoSellEnabled, gameplayPausedBypassEnabled, wallStickEnabled = false, false, false, false, false, false
local walkspeedValue, jumpPowerValue, flySpeed = 16, 50, 50
local floatPlatform, platformConnection, platformY = nil, nil, 0
local originalToolStats, lastKnownTool = {}, nil
local bringWeld, attachWeld = nil, nil
local ghostCharacter, lastGhostPosition = nil, nil
local isFlyingUp, isFlyingDown = false, false
local originalStreamingEnabled = workspace.StreamingEnabled

-- Buat Jendela Utama
local Window = Rayfield:CreateWindow({
    Name = "Abyss Miner Menu",
    LoadingTitle = "Memuat Abyss Miner Menu...",
    LoadingSubtitle = "oleh Partner Coding",
    Theme = "Default",
    ToggleUIKeybind = Enum.KeyCode.RightShift,
    ConfigurationSaving = { Enabled = false }
})
local uiElements = {}
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "25% - Jendela utama dibuat.", Duration = 2 }) end)

--================================================================--
--                        FUNGSI-FUNGSI UTAMA                       --
--================================================================--
local flying = false; local bodyVelocity, bodyGyro
local function startFly() local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") or flying then return end; local rootPart = char.HumanoidRootPart; bodyGyro = Instance.new("BodyGyro", rootPart); bodyGyro.P = 9e4; bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro.CFrame = rootPart.CFrame; bodyVelocity = Instance.new("BodyVelocity", rootPart); bodyVelocity.Velocity = Vector3.new(0, 0, 0); bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9); flying = true end
local function stopFly() if bodyGyro then bodyGyro:Destroy() end; if bodyVelocity then bodyVelocity:Destroy() end; flying = false end
local function restoreToolStats() if lastKnownTool and originalToolStats[lastKnownTool] then local tool = lastKnownTool; local stats = originalToolStats[lastKnownTool]; pcall(function() if stats.Speed and tool:FindFirstChild("Speed") then tool.Speed.Value = stats.Speed end end); originalToolStats[lastKnownTool] = nil end end

RunService.Heartbeat:Connect(function()
    local char = Player.Character; if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid"); if not humanoid then return end
    if humanoid.WalkSpeed ~= walkspeedValue then humanoid.WalkSpeed = walkspeedValue end
    if humanoid.JumpPower ~= jumpPowerValue then humanoid.JumpPower = jumpPowerValue end

    if flying and bodyVelocity and bodyGyro then
        local camera = workspace.CurrentCamera; local velocity = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = (camera.CFrame.LookVector * flySpeed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = (camera.CFrame.LookVector * -flySpeed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = (camera.CFrame.RightVector * -flySpeed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = (camera.CFrame.RightVector * flySpeed) end
        if isFlyingUp then velocity = Vector3.new(0, flySpeed, 0) end
        if isFlyingDown then velocity = Vector3.new(0, -flySpeed, 0) end
        bodyVelocity.Velocity = velocity; bodyGyro.CFrame = camera.CFrame
    end
    
    if wallStickEnabled and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        local ray = Ray.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.CFrame.lookVector * 5); local hit, pos = workspace:FindPartOnRay(ray, char)
        humanoid.PlatformStand = hit and true or false
    elseif not wallStickEnabled and humanoid.PlatformStand then
        humanoid.PlatformStand = false
    end

    if instantMineEnabled then local tool = char:FindFirstChildOfClass("Tool"); if tool and tool ~= lastKnownTool then restoreToolStats(); lastKnownTool = tool end; if tool then if not originalToolStats[tool] then originalToolStats[tool] = { Speed = tool:FindFirstChild("Speed") and tool.Speed.Value } end; pcall(function() local speed = tool:FindFirstChild("Speed"); if speed then speed.Value = 0 end end) else restoreToolStats(); lastKnownTool = nil end end
    if gameplayPausedBypassEnabled and Player.GameplayPaused then
        if not ghostCharacter then ghostCharacter = Player.Character:Clone(); ghostCharacter.Parent = workspace; for _, part in ipairs(ghostCharacter:GetDescendants()) do if part:IsA("BasePart") then part.Transparency = 0.7; part.CanCollide = false end end; workspace.CurrentCamera.CameraSubject = ghostCharacter.Humanoid; lastGhostPosition = ghostCharacter:GetPrimaryPartCFrame() end
        if ghostCharacter then lastGhostPosition = ghostCharacter:GetPrimaryPartCFrame() end
    elseif ghostCharacter and not Player.GameplayPaused then
        if lastGhostPosition then Player.Character:SetPrimaryPartCFrame(lastGhostPosition) end
        ghostCharacter:Destroy(); ghostCharacter = nil; workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
    end
end)

--================================================================--
--                         UI TABS & ELEMENTS                       --
--================================================================--
local TabMain = Window:CreateTab("Main", "pickaxe")
local SectionMain = TabMain:CreateSection("Fitur Utama")
local TabPlayer = Window:CreateTab("Player", "user")
local SectionPlayer = TabPlayer:CreateSection("Pengaturan Player")
local TabSell = Window:CreateTab("Sell", "dollar-sign")
local SectionSell = TabSell:CreateSection("Fitur Jual")
local TabRankUp = Window:CreateTab("Rank Up", "award")
local SectionRank = TabRankUp:CreateSection("Pengaturan Rank")
local TabStorage = Window:CreateTab("Storage", "archive")
local SectionBackpack = TabStorage:CreateSection("Backpack")
local SectionStorage = TabStorage:CreateSection("Storage")
local TabTeleport = Window:CreateTab("Teleportasi", "map-pin")
local SectionTeleport = TabTeleport:CreateSection("Teleportasi Pemain")

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "50% - Semua Tab & Section dibuat.", Duration = 2 }) end)

SectionMain:CreateToggle({ Name = "Instant Mine (Speed Only)", CurrentValue = false, Callback = function(state) instantMineEnabled = state; if not state then restoreToolStats() end end })
SectionMain:CreateToggle({ Name = "Bypass Gameplay Paused", CurrentValue = false, Callback = function(state)
    gameplayPausedBypassEnabled = state
    if state then pcall(function() local networkPauseScript = CoreGui:FindFirstChild("RobloxGui", true) and CoreGui.RobloxGui:FindFirstChild("CoreScripts/NetworkPause"); if networkPauseScript then networkPauseScript:Destroy() end end); workspace.StreamingEnabled = false;
    else workspace.StreamingEnabled = originalStreamingEnabled; if ghostCharacter then ghostCharacter:Destroy(); ghostCharacter = nil; workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid end end
end})
SectionMain:CreateButton({ Name = "Buka/Tutup Konsol", Callback = function() pcall(function() require(CoreGui.RobloxGui.Modules.DevConsoleMaster):Toggle() end) end})

SectionPlayer:CreateSlider({ Name = "Walkspeed", Range = {16, 100}, Increment = 1, Suffix = " speed", CurrentValue = 16, Callback = function(value) walkspeedValue = value end, })
SectionPlayer:CreateSlider({ Name = "Jump Power", Range = {50, 100}, Increment = 1, Suffix = " power", CurrentValue = 50, Callback = function(value) jumpPowerValue = value end, })
SectionPlayer:CreateSlider({ Name = "Kecepatan Terbang", Range = {10, 200}, Increment = 5, Suffix = " speed", CurrentValue = 50, Callback = function(value) flySpeed = value end, })
SectionPlayer:CreateToggle({ Name = "Anti Fall Damage", CurrentValue = false, Callback = function(state) antiFallDamageEnabled = state end, })
SectionPlayer:CreateToggle({
    Name = "Float Platform", CurrentValue = false,
    Callback = function(state)
        floatPlatformEnabled = state; local char = Player.Character
        if state and char and char:FindFirstChild("HumanoidRootPart") then if floatPlatform then floatPlatform:Destroy() end; local rootPart = char.HumanoidRootPart; platformY = rootPart.Position.Y - 4; floatPlatform = Instance.new("Part", workspace); floatPlatform.Anchored = true; floatPlatform.CanCollide = true; floatPlatform.Size = Vector3.new(15, 1, 15); floatPlatform.Transparency = 1; floatPlatform.Name = "MyFloatPlatform"; platformConnection = game:GetService("RunService").Heartbeat:Connect(function() if floatPlatform and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then local currentRoot = Player.Character.HumanoidRootPart; floatPlatform.Position = Vector3.new(currentRoot.Position.X, platformY, currentRoot.Position.Z) else if platformConnection then platformConnection:Disconnect() end; if floatPlatform then floatPlatform:Destroy() end end end)
        else if platformConnection then platformConnection:Disconnect(); platformConnection = nil end; if floatPlatform then floatPlatform:Destroy(); floatPlatform = nil end end
    end,
})
SectionPlayer:CreateToggle({ Name = "Tempel di Dinding", CurrentValue = false, Callback = function(state) wallStickEnabled = state; if not state and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then Player.Character.Humanoid.PlatformStand = false end end})
SectionPlayer:CreateToggle({ Name = "Toggle Fly", CurrentValue = false, Callback = function(state) flyEnabled = state; if state then startFly() else stopFly() end end, })
local flyUpButton = SectionPlayer:CreateButton({ Name = "Naik (Tahan)"}); flyUpButton.Interact:GetPropertyChangedSignal("MouseButton1Down"):Connect(function() isFlyingUp = flyUpButton.Interact.MouseButton1Down end)
local flyDownButton = SectionPlayer:CreateButton({ Name = "Turun (Tahan)"}); flyDownButton.Interact:GetPropertyChangedSignal("MouseButton1Down"):Connect(function() isFlyingDown = flyDownButton.Interact.MouseButton1Down end)

SectionSell:CreateToggle({ Name = "Auto Sell (15 detik)", CurrentValue = false, Callback = function(state) 
    autoSellEnabled = state; if autoSellEnabled then task.spawn(function() while autoSellEnabled do pcall(function() local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true); local char = Player.Character; if npc and char and char:FindFirstChild("HumanoidRootPart") then local distance = (npc:GetPrimaryPartCFrame().Position - char.PrimaryPart.Position).Magnitude; if distance < 100 then local tool = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool"); if tool then game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool) end end end end); task.wait(15) end end) end 
end })
SectionSell:CreateButton({ Name = "Jual Item di Tangan", Callback = function() pcall(function() local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true); if npc then game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellSingleone"):FireServer(npc, npc.HumanoidRootPart:WaitForChild("Dialogue")) end end) end})
SectionSell:CreateButton({ Name = "Jual Semua (Jarak Jauh)", Callback = function() local char = Player.Character; if not (char and char:FindFirstChild("HumanoidRootPart")) then return end; local rootPart = char.HumanoidRootPart; local originalCFrame = rootPart.CFrame; local npc = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Rei ' The professer", true) and workspace.Map["Layer 1"].Npcs["Rei ' The professer"]:FindFirstChild("Rei", true); local tool = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool"); if not (npc and tool) then return end; pcall(function() rootPart.CFrame = npc:GetPrimaryPartCFrame() * CFrame.new(0, 0, 5); task.wait(0.1); game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("SellAllInventory"):FireServer(npc, tool); task.wait(0.1); rootPart.CFrame = originalCFrame end) end})

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "75% - Fitur-fitur utama selesai dimuat.", Duration = 2 }) end)

local RankInfoParagraph = SectionRank:CreateParagraph({Title = "Informasi Rank", Content = "Klik 'Tampilkan Info' untuk memuat data."})
SectionRank:CreateButton({
    Name = "Tampilkan/Perbarui Info Rank",
    Callback = function()
        local karl = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("Layer 1", true) and workspace.Map["Layer 1"]:FindFirstChild("Npcs", true) and workspace.Map["Layer 1"].Npcs:FindFirstChild("Karl"); if not karl then return end
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("RankUpGui"):FireServer(karl, karl.HumanoidRootPart:WaitForChild("Dialogue"))
        task.wait(0.7)
        local rankMenu = Player.PlayerGui:FindFirstChild("MainGui", true) and Player.PlayerGui.MainGui:FindFirstChild("RankMenu")
        if rankMenu and rankMenu:FindFirstChild("BG") then local bg = rankMenu.BG; local currentRank = bg:FindFirstChild("namerank") and bg.namerank.Text or "[?]"; local nextRank = bg:FindFirstChild("namenextrank") and bg.namenextrank.Text or "[?]"; local reqs = "Syarat: [Tidak Ditemukan]"; for _,v in ipairs(bg:GetDescendants()) do if v:IsA("TextLabel") and string.find(v.Text:lower(), "required:") then reqs = v.Text; break end end; RankInfoParagraph:Set({Title = "Informasi Rank", Content = string.format("Rank Saat Ini: %s\nRank Selanjutnya: %s\n\n%s", currentRank, nextRank, reqs)}); rankMenu.Enabled = false
        else RankInfoParagraph:Set({Title = "Informasi Rank", Content = "Gagal menemukan GUI Rank Up."}) end
    end
})
local rankUpDebounce = false
SectionRank:CreateButton({ Name = "Rank Up", Callback = function() if rankUpDebounce then return end; rankUpDebounce = true; pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):WaitForChild("RankUP"):FireServer() end); task.wait(1); rankUpDebounce = false end})

local selectedBackpackItems, selectedStorageItems = {}, {}
local backpackFrame = SectionBackpack:CreateFrame({ Name = "BackpackFrame" }) -- Placeholder, Rayfield tidak punya frame custom
local storageFrame = SectionStorage:CreateFrame({ Name = "StorageFrame" })
local function refreshStorageUI()
    -- Fungsi ini memerlukan library UI yang mendukung pembuatan elemen dinamis di dalam frame.
    -- Karena keterbatasan Rayfield, implementasi daftar toggle dinamis tidak memungkinkan.
    -- Sebagai gantinya, kita bisa menggunakan dropdown.
end
SectionBackpack:CreateButton({ Name = "Pindahkan SEMUA Mineral ke Storage", Callback = function()
    local toolBlacklist = {["Main Tool"]=true, ["Equipment"]=true, ["Collection Book"]=true, ["Whistle"]=true}; local itemsToMove = {}; for _, item in ipairs(Player.Backpack:GetChildren()) do if item:IsA("Tool") and not toolBlacklist[item.Name] then table.insert(itemsToMove, item) end end
    for _, item in ipairs(itemsToMove) do pcall(function() game:GetService("ReplicatedStorage").RemoteEvent.Storage:FireServer(false, item) end); task.wait() end
end})
local StorageDropdown
local function refreshStorageDropdown()
    local storageItems = {}; local storageFolder = Player:FindFirstChild("HiddenStats", true) and Player.HiddenStats:FindFirstChild("Storage")
    if storageFolder then for _, item in ipairs(storageFolder:GetChildren()) do table.insert(storageItems, item.Name) end end
    if StorageDropdown then StorageDropdown:Refresh(storageItems) end
end
StorageDropdown = SectionStorage:CreateDropdown({Name = "Ambil Item dari Storage", Options = {}, MultipleOptions = true, Callback = function(options) selectedStorageItems = options end})
refreshStorageDropdown()
SectionStorage:CreateButton({Name = "Ambil Item Terpilih", Callback = function()
    local storageFolder = Player:FindFirstChild("HiddenStats", true) and Player.HiddenStats:FindFirstChild("Storage"); if not storageFolder then return end
    for _, itemName in ipairs(selectedStorageItems) do local item = storageFolder:FindFirstChild(itemName); if item then pcall(function() game:GetService("ReplicatedStorage").RemoteEvent.Storage:FireServer(true, item) end); task.wait() end end
    task.wait(0.5); refreshStorageDropdown()
end})
SectionStorage:CreateButton({ Name = "Refresh Daftar Storage", Callback = refreshStorageDropdown })

local PlayerDropdown; local function refreshPlayerList() local playerNames = {}; for _, p in ipairs(game:GetService("Players"):GetPlayers()) do if p ~= Player then table.insert(playerNames, p.Name) end end; if PlayerDropdown then PlayerDropdown:Refresh(playerNames) end end
PlayerDropdown = SectionTeleport:CreateDropdown({ Name = "Pilih Pemain", Options = {}, MultipleOptions = false, Callback = function(option) end })
refreshPlayerList(); game:GetService("Players").PlayerAdded:Connect(refreshPlayerList); game:GetService("Players").PlayerRemoving:Connect(refreshPlayerList)
SectionTeleport:CreateButton({ Name = "Refresh Daftar Pemain", Callback = refreshPlayerList })
SectionTeleport:CreateButton({ Name = "Goto Pemain Terpilih", Callback = function()
    local myChar = Player.Character; local friendName = PlayerDropdown.CurrentOption[1]; if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end
    if not friendName then return end; local friendPlayer = game:GetService("Players"):FindFirstChild(friendName); if not (friendPlayer and friendPlayer.Character and friendPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end
    pcall(function() myChar.HumanoidRootPart.CFrame = friendPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 5) end)
end})
SectionTeleport:CreateButton({ Name = "Pindahkan Teman ke Saya", Callback = function()
    local myChar = Player.Character; local friendName = PlayerDropdown.CurrentOption[1]; if not (myChar and myChar.PrimaryPart) then return end
    if not friendName then return end; local friendPlayer = game:GetService("Players"):FindFirstChild(friendName); if not (friendPlayer and friendPlayer.Character and friendPlayer.Character.PrimaryPart) then return end
    pcall(function() friendPlayer.Character:SetPrimaryPartCFrame(myChar.PrimaryPart.CFrame) end)
end })
SectionTeleport:CreateToggle({ Name = "Bawa Pemain Terpilih", CurrentValue = false, Callback = function(state)
    local myChar = Player.Character; local friendName = PlayerDropdown.CurrentOption[1]; if not friendName then return end
    local friendPlayer = game:GetService("Players"):FindFirstChild(friendName); if not (myChar and myChar:FindFirstChild("HumanoidRootPart") and friendPlayer and friendPlayer.Character and friendPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end
    if state then if bringWeld then bringWeld:Destroy() end; bringWeld = Instance.new("WeldConstraint"); bringWeld.Part0 = myChar.HumanoidRootPart; bringWeld.Part1 = friendPlayer.Character.HumanoidRootPart; bringWeld.Parent = myChar.HumanoidRootPart
    else if bringWeld then local friendChar = friendPlayer.Character; bringWeld:Destroy(); bringWeld = nil; friendChar:SetPrimaryPartCFrame(myChar:GetPrimaryPartCFrame() * CFrame.new(5, 0, 0)) end end
end})
SectionTeleport:CreateToggle({ Name = "Tempel di Kepala Teman", CurrentValue = false, Callback = function(state)
    local myChar = Player.Character; local friendName = PlayerDropdown.CurrentOption[1]; if not friendName then return end
    local friendPlayer = game:GetService("Players"):FindFirstChild(friendName); if not (myChar and myChar:FindFirstChild("HumanoidRootPart") and friendPlayer and friendPlayer.Character and friendPlayer.Character:FindFirstChild("Head")) then return end
    if state then if attachWeld then attachWeld:Destroy() end; attachWeld = Instance.new("WeldConstraint"); attachWeld.Part0 = myChar.HumanoidRootPart; attachWeld.Part1 = friendPlayer.Character.Head; attachWeld.Parent = myChar.HumanoidRootPart
    else if attachWeld then attachWeld:Destroy(); attachWeld = nil; myChar:SetPrimaryPartCFrame(friendPlayer.Character:GetPrimaryPartCFrame() * CFrame.new(5, 0, 0)) end end
end})

pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Memuat Skrip...", Text = "90% - Finalisasi...", Duration = 2 }) end)

local endTime = tick()
local duration = string.format("%.3f", endTime - startTime)
pcall(function() 
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Selesai!", Text = "100% - Skrip berhasil dimuat dalam " .. duration .. " detik.", Duration = 8
    })
end)