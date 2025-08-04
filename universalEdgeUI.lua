debugX = true

local Players       = game:GetService("Players")
local LocalPlayer   = Players.LocalPlayer
local RunService    = game:GetService("RunService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0,
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled    = true,
      FolderName = nil,
      FileName   = "Big Hub"
   },
   Discord = {
      Enabled        = false,
      Invite         = "noinvitelink",
      RememberJoins  = true
   },
   KeySystem = false,
   KeySettings = {
      Title            = "Untitled",
      Subtitle         = "Key System",
      Note             = "No method of obtaining the key is provided",
      FileName         = "Key",
      SaveKey          = true,
      GrabKeyFromSite  = false,
      Key              = {"Hello"}
   }
})

-- keep track of current walk/jump settings
local settings = {
   WalkSpeed  = 16,
   JumpPower  = 50,
}

-- updates humanoid properties whenever character/spawn changes
local function applyMovementSettings(humanoid)
   humanoid.WalkSpeed = settings.WalkSpeed
   humanoid.JumpPower = settings.JumpPower
end

local function onCharacterAdded(char)
   local humanoid = char:WaitForChild("Humanoid", 5)
   if humanoid then
      applyMovementSettings(humanoid)
      -- ensure settings persist if something resets them
      RunService.Heartbeat:Connect(function()
         if humanoid and humanoid.Parent then
            humanoid.WalkSpeed = settings.WalkSpeed
            humanoid.JumpPower = settings.JumpPower
         end
      end)
   end
end

-- bind character added for existing & future spawns
if LocalPlayer.Character then
   onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- ---------------------------------------------------
-- MOVEMENT CONTROLS SECTION
-- ---------------------------------------------------
local tabMovement = Window:CreateTab("Movement Controls", 4483362458)
local secMove     = tabMovement:CreateSection("Walk & Jump Settings")

secMove:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   Suffix = "",
   CurrentValue = settings.WalkSpeed,
   Flag = "WalkSpeedSlider",
   Callback = function(value)
      settings.WalkSpeed = value
   end,
})

secMove:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 1,
   Suffix = "",
   CurrentValue = settings.JumpPower,
   Flag = "JumpPowerSlider",
   Callback = function(value)
      settings.JumpPower = value
   end,
})

-- ---------------------------------------------------
-- CHARACTER COPIER SECTION
-- ---------------------------------------------------
local tabCopy = Window:CreateTab("Character Copier", 4483362458)
local secCopy = tabCopy:CreateSection("Clone Avatars")

-- dropdown to pick from players in your server
local playerDropdown
local function refreshPlayerList()
   local opts = {}
   for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LocalPlayer then
         table.insert(opts, plr.Name)
      end
   end
   playerDropdown:Refresh(opts)
end

playerDropdown = secCopy:CreateDropdown({
   Name = "Select Server Player",
   Options = {},
   CurrentOption = "",
   Multi = false,
   Flag = "PlayerDropdown",
   Callback = function(name)
      cloneAvatar(name)
   end,
})

-- button to refresh the dropdown list
secCopy:CreateButton({
   Name = "Refresh Player List",
   Callback = refreshPlayerList,
})

-- textbox to clone any Roblox username (in or out of server)
secCopy:CreateInput({
   Name = "Username to Copy",
   PlaceholderText = "Type exact Roblox username",
   RemoveTextAfterFocusLost = true,
   Callback = function(txt)
      cloneAvatar(txt)
   end,
})

-- cloneAvatar implementation using GetCharacterAppearanceAsync
function cloneAvatar(username)
   coroutine.wrap(function()
      local success, userId = pcall(function()
         return Players:GetUserIdFromNameAsync(username)
      end)
      if not success then
         warn("Unable to get userId for '" .. username .. "'")
         return
      end

      -- fetch a fresh character model from Roblox API
      local ok, model = pcall(function()
         return Players:GetCharacterAppearanceAsync(userId)
      end)
      if not ok or not model then
         warn("Failed to load avatar for userId " .. tostring(userId))
         return
      end

      -- position clone next to your character
      model.Name   = username .. "_Clone"
      model.Parent = workspace

      local rootPart = model:FindFirstChild("HumanoidRootPart") 
                      or model.PrimaryPart
      local myRoot   = LocalPlayer.Character and
                       LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                       or workspace

      if rootPart and myRoot then
         model:SetPrimaryPartCFrame(
            CFrame.new(
               myRoot.Position + Vector3.new(8, 0, 0),
               myRoot.Position
            )
         )
      end
   end)()
end

-- initialize
refreshPlayerList()
Rayfield:LoadConfiguration()