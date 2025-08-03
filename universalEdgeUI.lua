--[[ 
Script Lengkap Integrasi Fitur Multi + Edge UI Library
]]

-- 1. Setup Warna dan UI Library
getgenv().color_schemes = {
	custom = {
		dark_color = Color3.fromRGB(0, 78, 152),
		dark_hover_color = Color3.fromRGB(0, 65, 125),
		background_color = Color3.fromRGB(235, 235, 235),
		section_background_color = Color3.fromRGB(192, 192, 192),
		misc_elements_color = Color3.fromRGB(235, 235, 235),
		elements_color = Color3.fromRGB(58, 110, 165),
		elements_hover_color = Color3.fromRGB(49, 94, 139),
		enabled_color = Color3.fromRGB(255, 103, 0),
		enabled_hover_color = Color3.fromRGB(221, 88, 0),
		scroll_bar_color = Color3.fromRGB(0, 0, 0)
	}
}
getgenv().color_scheme = getgenv().color_schemes.custom

local window = loadstring(game:HttpGet("https://raw.githubusercontent.com/deadmopose/Edge-ui-library/main/script.lua"))()
local tabMain = window.new_tab("Main")
local tabESP = window.new_tab("ESP Features")
local tabLoc = window.new_tab("Location / Teleport")

local sectionFeatures = tabMain.new_section("Features")
local sectionESP = tabESP.new_section("ESP Settings")
local sectionLoc = tabLoc.new_section("Location Management")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Fungsi pembantu mengambil Humanoid dan HRP
local function getHumanoid()
	return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
	return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- ======================
-- 2. ESP Cornerbox Setup (dari attachment)
-- ======================
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Box_Thickness = 2,
    Team_Check = false,
    Team_Color = false,
    Autothickness = true
}
local Camera = Workspace.CurrentCamera

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

local espLibraries = {}
local espConnections = {}
local espEnabled = false

local function createESPForPlayer(plr)
	if plr == LocalPlayer then return end
	local Library = {
		TL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
		TL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
		TR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
		TR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
		BL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
		BL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
		BR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
		BR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
	}
	
	espLibraries[plr] = Library
	
	local oripart = Instance.new("Part")
	oripart.Parent = Workspace
	oripart.Transparency = 1
	oripart.CanCollide = false
	oripart.Size = Vector3.new(1,1,1)
	oripart.Position = Vector3.new(0,0,0)
	
	espConnections[plr] = RS.RenderStepped:Connect(function()
		local char = plr.Character
		if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
			local Hum = char
			local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)
			if vis then
				oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y*1.5, Hum.HumanoidRootPart.Size.Z)
				oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
				local SizeX = oripart.Size.X
				local SizeY = oripart.Size.Y
				local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
				local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
				local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
				local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

				if Settings.Team_Check then
					if plr.TeamColor == LocalPlayer.TeamColor then
						Colorize(Library, Color3.fromRGB(0, 255, 0))
					else
						Colorize(Library, Color3.fromRGB(255, 0, 0))
					end
				end

				if Settings.Team_Color then
					Colorize(Library, plr.TeamColor.Color)
				end
				
				local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).Magnitude
				local offset = math.clamp(1/ratio*750, 2, 300)

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

				if Settings.Autothickness then
					local distance = (plr.Character.HumanoidRootPart.Position - oripart.Position).Magnitude
					local value = math.clamp(1/distance*100, 1, 4) --0.1 min thickness, 6 max
					for _, x in pairs(Library) do
						x.Thickness = value
					end
				else 
					for _, x in pairs(Library) do
						x.Thickness = Settings.Box_Thickness
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
					oripart:Destroy()
				end
				espConnections[plr]:Disconnect()
			end
		end
	end)
end

local function removeESPForPlayer(plr)
	if espLibraries[plr] then
		for _, line in pairs(espLibraries[plr]) do
			line:Remove()
		end
		espLibraries[plr] = nil
	end
	if espConnections[plr] then
		espConnections[plr]:Disconnect()
		espConnections[plr] = nil
	end
end

sectionESP.new_toggle("ESP Cornerbox", function(state)
	espEnabled = state
	if espEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				createESPForPlayer(plr)
			end
		end
	else
		for plr, _ in pairs(espLibraries) do
			removeESPForPlayer(plr)
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	if espEnabled and plr ~= LocalPlayer then
		createESPForPlayer(plr)
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if espEnabled then
		removeESPForPlayer(plr)
	end
end)

-- ============================
-- 3. WalkSpeed & JumpPower Loop agar tidak reset game
-- ============================
local walkSpeedEnabled = false
local jumpPowerEnabled = false
local desiredWalkSpeed = 16
local desiredJumpPower = 50

sectionFeatures.new_slider("WalkSpeed", 16, 500, function(speed)
	desiredWalkSpeed = speed
	walkSpeedEnabled = true
end)

sectionFeatures.new_slider("JumpPower", 50, 200, function(power)
	desiredJumpPower = power
	jumpPowerEnabled = true
end)

sectionFeatures.new_button("Reset WS/JP", function()
	walkSpeedEnabled = false
	jumpPowerEnabled = false
	local hum = getHumanoid()
	if hum then
		hum.WalkSpeed = 16
		hum.JumpPower = 50
	end
end)

RS.RenderStepped:Connect(function()
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

-- ===================
-- 4. Save & Teleport Location
-- ===================
local savedLocations = {}

sectionLoc.new_text_box("Nama Lokasi", function(text)
	getgenv().last_save_name = text
end)

sectionLoc.new_button("Save Current Location", function()
	local hrp = getHRP()
	if hrp and getgenv().last_save_name and #getgenv().last_save_name > 0 then
		savedLocations[getgenv().last_save_name] = hrp.CFrame
		print("[Location Saved]: " .. getgenv().last_save_name)
	end
end)

local function getSavedLocationsNames()
	local tbl = {}
	for k, _ in pairs(savedLocations) do
		table.insert(tbl, k)
	end
	return tbl
end

sectionLoc.new_dropdown("Saved Locations", getSavedLocationsNames, function(locationName)
	getgenv().selected_location = locationName
end)

sectionLoc.new_button("Tween Teleport ke Selected", function()
	local destName = getgenv().selected_location
	local hrp = getHRP()
	if destName and savedLocations[destName] and hrp then
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad)
		local tween = TweenService:Create(hrp, tweenInfo, {CFrame = savedLocations[destName]})
		tween:Play()
		print("[Teleported to]: " .. destName)
	end
end)

-- ==============================
-- 5. Clone Character by Username
-- ==============================
sectionFeatures.new_text_box("Username untuk Clone", function(text)
	getgenv().clone_user = text
end)

sectionFeatures.new_button("Copy/Clone Character", function()
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
		print("Character cloned from: "..getgenv().clone_user)
	else
		print("User atau Character tidak ditemukan")
	end
end)

-- ===================
-- 6. Invisible Character (Tool Method)
-- ===================
sectionFeatures.new_button("Invisible (Tool Method)", function()
	local back = LocalPlayer.Backpack
	local char = LocalPlayer.Character
	if back and #back:GetChildren() > 0 and char then
		local tool = back:GetChildren()[1]
		tool.Parent = char
		wait(0.1)
		if tool:FindFirstChild("Handle") then
			tool.Handle:Destroy()
			print("Character is now invisible (tool handle destroyed)")
		end
	else
		print("No tool available in Backpack to make invisible")
	end
end)

-- ===================
-- 7. Slow Fall Feature
-- ===================
local slowfall_enabled = false
sectionFeatures.new_toggle("Slow Fall", function(state)
	slowfall_enabled = state
end)

RS.RenderStepped:Connect(function()
	if slowfall_enabled then
		local hum = getHumanoid()
		if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
			hum.JumpPower = 25
		elseif hum then
			hum.JumpPower = 50
		end
	end
end)

-- =======================
-- 8. No Fall Damage / Anti Damage
-- =======================
local anti_fall = false
sectionFeatures.new_toggle("No Fall Damage", function(state)
	anti_fall = state
end)

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

-- ==========================
-- 9. Anti Loading Gameplay
-- ==========================
local anti_loading_enabled = false
local last_walking_pos = nil
local last_humanoid_walkspeed = 16

sectionFeatures.new_toggle("Anti Loading Gameplay", function(state)
	anti_loading_enabled = state
	if state then
		local hum = getHumanoid()
		if hum then last_humanoid_walkspeed = hum.WalkSpeed end
	end
end)

local function isLoadingScreen()
	for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
		if gui:IsA("ScreenGui") and gui.Name:lower():find("load") then
			if gui.Enabled ~= false then return true end
		end
	end
	return false
end

RS.RenderStepped:Connect(function()
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

-- ==========================
-- Praktik Terbaik & Catatan
-- ==========================
-- Gunakan local untuk scope variabel dan memori efisien
-- Event connection managed dengan baik untuk mencegah memory leaks
-- Modularisasi UI memakai section/tab dari Edge UI Library
-- Print/log untuk debugging minimal

print("Script lengkap dengan semua fitur + Edge UI Library siap dijalankan!")
