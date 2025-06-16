local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "M E A W",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Welcome To M E A W",
   LoadingSubtitle = "Made by Cat",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local PlayerTab = Window:CreateTab("Player", 4483362458) -- Title, Image

local Slider = PlayerTab:CreateSlider({
   Name = "Slider Example",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Example",
   CurrentValue = 10,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- The function that takes place when the slider changes
   -- The variable (Value) is a number which correlates to the value the slider is currently at
   end,
})

local Button = PlayerTab:CreateButton({
   Name = "Button Example",
   Callback = function()
   -- The function that takes place when the button is pressed
   end,
})

local Toggle = PlayerTab:CreateToggle({
   Name = "Toggle Example",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- The function that takes place when the toggle is pressed
   -- The variable (Value) is a boolean on whether the toggle is true or false
   end,
})

local Input = PlayerTab:CreateInput({
   Name = "Input Example",
   CurrentValue = "",
   PlaceholderText = "Input Placeholder",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
   -- The function that takes place when the input is changed
   -- The variable (Text) is a string for the value in the text box
   end,
})

local Dropdown = PlayerTab:CreateDropdown({
   Name = "Dropdown Example",
   Options = {"Option 1","Option 2"},
   CurrentOption = {"Option 1"},
   MultipleOptions = false,
   Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
   -- The function that takes place when the selected option is changed
   -- The variable (Options) is a table of strings for the current selected options
   end,
})

Rayfield:Notify({
   Title = "Notification Title",
   Content = "Notification Content",
   Duration = 6.5,
   Image = 4483362458,
})

local Section = PlayerTab:CreateSection("Section Example")

Section:Set("Section Example") -- Updating a Section

local Divider = PlayerTab:CreateDivider()

Divider:Set(false) -- Updating a Divider Whether the divider's visibility is to be set to true or false.

Rayfield:SetVisibility(false) -- Settings the Visibility

Rayfield:IsVisible() -- Getting the Visibility 

Rayfield:Destroy() -- Destroying the Interface 

-- Available Theme --
Theme Name - ThemeIdentifier

Default - Default
Amber Glow - AmberGlow
Amethyst - Amethyst
Bloom - Bloom
Dark Blue - DarkBlue
Green - Green
Light - Light
Ocean - Ocean
Serenity - Serenity

Button:Set("Button Example") -- Updating a Button

Toggle:Set(false) -- Updating a Toggle

Slider:Set(10) -- The new slider integer value

Input:Set("New Text") -- The new input text value

Dropdown:Refresh({"New Option 1","New Option 2"}) -- The new list of options

Dropdown:Set({"Option 2"}) -- "Option 2" will now be selected

local Label = Tab:CreateLabel("Label Example", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme

Label:Set("Label Example", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme

local Paragraph = Tab:CreateParagraph({Title = "Paragraph Example", Content = "Paragraph Example"})

Paragraph:Set({Title = "Paragraph Example", Content = "Paragraph Example"})

