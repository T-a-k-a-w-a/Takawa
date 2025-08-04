debugX = true

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
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- WalkSpeed Loop Logic
local walkLoopEnabled = false
local function WalkSpeedLoop()
   while walkLoopEnabled do
      if Humanoid then Humanoid.WalkSpeed = 75 end
      wait(0.2)
   end
end

-- JumpPower Loop Logic
local jumpLoopEnabled = false
local function JumpPowerLoop()
   while jumpLoopEnabled do
      if Humanoid then Humanoid.JumpPower = 100 end
      wait(0.2)
   end
end

-- Copy Character Logic
local function CopyCharacter(name)
   local target = Players:FindFirstChild(name)
   if target and target.Character then
      local clone = target.Character:Clone()
      clone.Parent = workspace
      clone:MoveTo(Character:GetPrimaryPartCFrame().Position + Vector3.new(6, 0, 0))
   end
end

-- UI Setup
local Tab = Window:CreateTab("Tab Example", 4483362458)
local Section = Tab:CreateSection("Section Example")

-- Toggle WalkSpeed
Tab:CreateToggle({
   Name = "Loop WalkSpeed 75",
   CurrentValue = false,
   Callback = function(Value)
      walkLoopEnabled = Value
      if Value then
         coroutine.wrap(WalkSpeedLoop)()
      end
   end,
})

-- Toggle JumpPower
Tab:CreateToggle({
   Name = "Loop JumpPower 100",
   CurrentValue = false,
   Callback = function(Value)
      jumpLoopEnabled = Value
      if Value then
         coroutine.wrap(JumpPowerLoop)()
      end
   end,
})

-- Copy Character Input
Tab:CreateInput({
   Name = "Copy Character",
   PlaceholderText = "Nama Pemain",
   RemoveTextAfterFocusLost = true,
   Callback = function(Text)
      CopyCharacter(Text)
   end,
})

Rayfield:LoadConfiguration()