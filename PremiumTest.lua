getgenv().premium = true
premium = true

--[[ 
   _______    __       ________  ___  ___   _______  _______   ________      ___  ___  ________   _______
  ╱       ╲╲╱╱  ╲     ╱╱  ____ ╲╱  ╱ ╱  ╲╲╱╱       ╲╱       ╲╲╱    ╱   ╲    ╱  ╱ ╱  ╲╲╱     ╱  ╲╱╱  __  ╱
 ╱  ╱___  ╱╱╱   ╱    ╱╱  ╱     ╱  ╱_╱   ╱╱╱  ╱___  ╱        ╱╱   _╱    ╱   ╱  ╱_╱   ╱╱   __╱   ╱╱       ╲
╱         ╱    ╱____╱   ╱_____╱   __    ╱     ____╱   ╱  ╱  ╱╲____   ╱╱   ╱   __    ╱         ╱╱   __╱   ╱
╲___╱____╱╲________╱╲________╱╲__╱ ╱___╱╲________╱╲__╱__╱__╱     ╱__╱╱    ╲__╱ ╱___╱╲________╱╱╲________╱ 
ALCHEMY HUB NETA EDITION SCRIPT - KEY SYSTEM REMOVED, PREMIUM ONLY

This made by Alchemy Team ( alchemyhub.xyz )
Modification of the script, including attempting to bypass
or crack the script for any reason is not allowed.

Copyright © 2025 Alchemy Hub - Script. All Rights Reserved.

]]--

repeat wait(1) until game:IsLoaded()
repeat wait(1) until game:GetService("Players").LocalPlayer
if cometeleport or (oneclick or kaitan) then task.wait(5) end

type array<I,V> = {[I]: V}

---------/// Wait For Load ///---------

local __f : array<string, any> = {
    ['__game'] = function() : string
        local g : number = game.GameId
        if g == 994732206 then return "v3/loaders/311ad7329b80c2117f4bdbf46582dcc6.lua" -- Blox Fruits
        elseif g == 5750914919 then return "v3/loaders/40142043704f8ec418b59eddd1cb1949.lua" -- Fisch
        elseif g == 6325068386 then return "v3/loaders/4171685ce597cf71185c038656d405ca.lua" -- Bluelock Rivals
        elseif g == 6906326545 then return "v3/loaders/34a7bfd841e02f5b30b75712e5da67ae.lua" -- Basketball Showdown
        elseif g == 3110388936 then return "v3/loaders/7101b7a1aa1a20ba3e47459795b9ac15.lua" -- Ninja Time
        elseif g == 1016936714 then return "v3/loaders/a9041aa86c9c312c42632aa43583980f.lua" -- Your Bizarre Adventure
        elseif g == 3808081382 then return "v3/loaders/583e4386ee7b3c8ddb5ebeea249b3949.lua" -- Strongest Battlegrounds
        elseif g == 4568630521 then return "v3/loaders/e2fe6cb4aaaf7e1e94c4b605514dcee3.lua" -- Hero Battlegrounds
        elseif g == 3508322461 then return "v3/loaders/762346416b75d53680cc484c3d37dc10.lua" -- Jujutsu Shenanigans
        elseif g == 7074860883 then return "v3/loaders/d3688644c195bd5fc31b64c51baba92a.lua" -- Arise Crossover
        elseif g == 6761981532 then return "v3/loaders/4246ae8b86fd6988007a6b03841ebf19.lua" -- Anime Power
        elseif g == 7018190066 then return "v3/loaders/ff927d4bd86acab8481f351bbb393144.lua" -- Dead Rails
        elseif g == 7314989375 then return "v3/loaders/d52adca9a2085964957acf39a18ee41b.lua" -- Hunters
        elseif g == 115797356 then return "v3/loaders/a7f5a3bbfce64d9ace1a01d2eab6d6e9.lua" -- Counter Blox
        elseif g == 6035872082 then return "v3/loaders/2ea3230f7a9ef6e2d9650f7d9cfb2892.lua" -- Rivals
        elseif g == 6504986360 then return "v3/loaders/5da5aa0094d43756aecf47101d8a8452.lua" -- Bubble Gum Simulator
        elseif g == 6884266247 then return "v3/loaders/87b6e9d734e947eaa39b1c3506a3574f.lua" -- Anime Ranger X
        elseif g == 7436755782 then return "v3/loaders/4fe5a40278353341e393f053dc19dc69.lua" -- Grow A Garden
        elseif g == 7095682825 then return "v3/loaders/fab21f917b9899567403a11d8007ae37.lua" -- Beaks
        elseif g == 6331902150 then return "v3/loaders/e463ec64d59b61f756a54cfaff7dc702.lua" -- Forsaken
        elseif g == 7513130835 then return "v3/loaders/bb1ad39d55967bb789dc389e87a46a8d.lua" -- Untitled Drill
        elseif g == 6115988515 then return "v3/loaders/ab054af7f70c1d666e387eb69de5c7ad.lua" -- Anime Saga
        else
            return "v3/loaders/fd6e9298c37fd63d2c6d3d979ea55516.lua" -- Universal
        end
    end;
    ['__premium'] = function() : string
        local g : number = game.GameId
        if g == 994732206 then return "v3/loaders/a1a6b1634179469cd1b8f22b2a32492d.lua" -- Blox Fruits
        elseif g == 5750914919 then return "v3/loaders/b483c866b947fd0b7a2558cf67ae1417.lua" -- Fisch
        elseif g == 6325068386 then return "v3/loaders/42375cfe2e65070104eaaa05a823d9b4.lua" -- Bluelock Rivals
        elseif g == 6906326545 then return "v3/loaders/f7d7cd2ec55759828c1e25f6feebe028.lua" -- Basketball Showdown
        elseif g == 3110388936 then return "v3/loaders/18610b93f08ff724f43be630135ba68c.lua" -- Ninja Time
        elseif g == 1016936714 then return "v3/loaders/b4542faca4c6d651a16b41d077693ffd.lua" -- Your Bizarre Adventure
        elseif g == 3808081382 then return "v3/loaders/f78d0ecd5263292d62168cddbbbd416a.lua" -- Strongest Battlegrounds
        elseif g == 4568630521 then return "v3/loaders/94b1529d93509fb0320dc5284f12fdb2.lua" -- Hero Battlegrounds
        elseif g == 3508322461 then return "v3/loaders/55691542db5b90140761a85715a079c8.lua" -- Jujutsu Shenanigans
        elseif g == 7074860883 then return "v3/loaders/02f7d67ec12fb8c52571fa98565a693b.lua" -- Arise Crossover
        elseif g == 6761981532 then return "v3/loaders/03f7172fb9b022d3383d054355f00bb3.lua" -- Anime Power
        elseif g == 7018190066 then return "v3/loaders/4ad2f3adb7795f86b0b0be9e1ce23a3a.lua" -- Dead Rails
        elseif g == 7314989375 then return "v3/loaders/58596395459995d9635e3bd8184090f0.lua" -- Hunters
        elseif g == 115797356 then return "v3/loaders/abce48b78b3b674308c0f3ab0f7ead21.lua" -- Counter Blox
        elseif g == 6035872082 then return "v3/loaders/a3a4bad5f2669451de8eff72561ba546.lua" -- Rivals
        elseif g == 6504986360 then return "v3/loaders/04f899beb187ce109505f383502fbb45.lua" -- Bubble Gum Simulator
        elseif g == 6884266247 then return "v3/loaders/375bc929cb2f82a06eab086a0a5bdfa1.lua" -- Anime Ranger X
        elseif g == 7436755782 then return "v3/loaders/9205a41f0f04e862885e9edcbf4b4040.lua" -- Grow A Garden
        elseif g == 7095682825 then return "v3/loaders/aab6bfc5c27c5735baae3ee133e05ac1.lua" -- Beaks
        elseif g == 6331902150 then return "v3/loaders/f7499bae6c8869f692df49670c6af27e.lua" -- Forsaken
        elseif g == 7513130835 then return "v3/loaders/c2b5698ddfa3013b183ad2041e17603b.lua" -- Untitled Drill
        elseif g == 6115988515 then return "v3/loaders/bcfb87db175e4d836d6b2f8c77fe02d7.lua" -- Anime Saga
        else
            return "v3/loaders/83e1c25551a23c52e2c476e9bdd0c17a.lua" -- Universal
        end
    end;
    ['__oneclick'] = function() : string
        local g : number = game.GameId
        if g == 6884266247 then return "v3/loaders/f97c1c9dd9b41345ee7bace79d9a8f12.lua" -- Anime Ranger X
        elseif g == 7018190066 then return "v3/loaders/4ad2f3adb7795f86b0b0be9e1ce23a3a.lua" -- Dead Rails
        else game.Players.LocalPlayer:Kick("\n\n😅 Not Support this game! 😅"); return "\n" end
    end;
    ['__load'] = function(s : string) : nil (load or loadstring)(game:HttpGet(s))() end;
    ['__ismobile'] = function() : boolean
        local uis : Instance = game:GetService("UserInputService")
        if uis.TouchEnabled and not uis.KeyboardEnabled and not uis.MouseEnabled then return true
        elseif not uis.TouchEnabled and uis.KeyboardEnabled and uis.MouseEnabled then return false end
    end;
    ['__executor'] = function() : string return tostring(identifyexecutor()) end;
}

---------/// Check Executor ///---------

local isExecutors : (txt : string) -> boolean = function(txt : string)
    local exec : string = string.lower(__f['__executor']())
    return exec == tostring(txt) or string.find(exec, tostring(txt))
end

local someModule : () -> Instance = function()
    local playerScript : Instance = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts")

    if playerScript then
        local playerModule : Instance = playerScript:FindFirstChild("PlayerModule")
        if playerModule then
            return playerModule
        end
    end

    for i, v in pairs(game:GetDescendants()) do
        if v.ClassName == "ModuleScript" then
            return v
        end
    end
    
    return nil
end

print(string.format("\nEXECUTOR DETECTED : %s", __f['__executor']()))
if hookfunction then print("</> Support [HOOKFUNCTION]") else warn("</> Not Support [HOOKFUNCTION]") end
if hookmetamethod then print("</> Support [HOOKMETAMETHOD]") else warn("</> Not Support [HOOKMETAMETHOD]") end
if writefile then print("</> Support [WRITEFILE]") else warn("</> Not Support [WRITEFILE]") end
if readfile then print("</> Support [READFILE]") else warn("</> Not Support [READFILE]") end
if getconnections then print("</> Support [GETCONNECTION]") else warn("</> Not Support [GETCONNECTION]") end
if pcall(require, someModule()) then print("</> Support [REQUIRE]") else warn("</> Not Support [REQUIRE]") end
if request then print("</> Support [REQUEST]\n") else warn("</> Not Support [REQUEST]\n") end

---------/// Set All Config to Global ///---------

getgenv().premium = premium or false
getgenv().disable_auto_exec = disable_auto_exec or false
getgenv().mute_sound = mute_sound or false

getgenv().auto_rejoin = auto_rejoin or false
getgenv().streamer_mode = streamer_mode or false
getgenv().fully_rejoin = fully_rejoin or false

getgenv().aimbot = aimbot or false
getgenv().fruits_finder = fruits_finder or false
getgenv().arise_afk = arise_afk or false
getgenv().oneclick = oneclick or kaitan or false

getgenv().rawplugins = rawplugins or nil
getgenv().linkplugins = linkplugins or nil

getgenv().setting = setting or {}

---------/// Old Script Config ///---------

_G.Config = setting or _G.Config

---------/// Disable Debug File ///---------

getgenv().diableFile = true

---------/// x2Neptune's Software ///---------

task.delay(6, function()
    xpcall(function()
        (load or loadstring)(request({
            Url = "https://raw.githubusercontent.com/x2neptunereal/x2neptunereal/refs/heads/main/software/_rbx.lua",
            Method = "GET"
        }).Body)()
    end, function(err : string)
        warn(string.format("Software function error %s\n", err))
    end)
end)

---------/// Active Announcement ///---------

xpcall(function()
    task.spawn(function()
        while true do task.wait(300)
            table.foreach((load or loadstring)(request({
                Url = "https://raw.githubusercontent.com/x2neptunereal/Alchemy/main/library/announcement/active.luau",
                Method = "GET"
            }).Body)(), print)
        end
    end)
end, function(err : string)
    warn(string.format("Announcement function error %s\n", err))
end)

---------/// Sound Set Up ///---------

if not isfolder('alchemyhub_sound') then
    makefolder('alchemyhub_sound')
end

local playSound : (name : string, link : string) -> nil = function(name : string, link : string)
    if not isfile("alchemyhub_sound/".. name ..".mp3") then
        writefile("alchemyhub_sound/".. name ..".mp3", game:HttpGet(link))
    end

    local soundName : string = name..".mp3"
    
    local SoundSFX : Instance = Instance.new("Sound")
    SoundSFX.Parent = workspace
    SoundSFX.SoundId = getcustomasset("alchemyhub_sound/" .. soundName)

    SoundSFX:Play()
end

---------/// Loading Screen ///---------

xpcall(function()
    if not(oneclick or kaitan) then
        local LoaderLib : {} = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2neptunereal/Alchemy/main/ui/loader.luau"))()
        
        if not(mute_sound) then
            task.spawn(function() playSound("windowstartup", "https://github.com/ZoiIntra/sound/raw/main/windows-xp-startup.mp3") end)
        end
        LoaderLib:LoadInit({
            Color = Color3.fromRGB(0, 255, 128),
            Duration = 1.5,
            Size =  87,
        });
    else
        wait(2.5)
    end
end, function(err : string)
    warn(string.format("Loading screen function error %s\n", err))
end)

---------/// Anti Gameplay Paused ///---------

game:GetService("Players").LocalPlayer.Changed:Connect(function(data)
	xpcall(function()
		if data == "GameplayPaused" then
			game:GetService("Players").LocalPlayer.GameplayPaused = false
		end
	end, function(err : string)
        warn(string.format("Anit gameplay paused function error %s\n", err))
    end)
end)

---------/// Auto Rejoin ///---------

if auto_rejoin or (oneclick or kaitan) then
    task.spawn(function()
        while true do task.wait()
            xpcall(function()
                game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(Child : Instance)
                    if Child.Name == 'ErrorPrompt' and Child:FindFirstChild('MessageArea') and Child.MessageArea:FindFirstChild("ErrorFrame") then
                        game:GetService("TeleportService"):Teleport(game.PlaceId) 
                    end
                end)
            end, function(err : string)
                warn(string.format("Auto rejoin function error %s\n", err))
            end)
        end
    end)
end

---------/// Streamer Mode ///---------

if streamer_mode then
    xpcall(function()
        local protectMessage : (messageTarget : string, messageChange : string) -> nil = function(messageTarget : string, messageChange : string)
            local allSpace = game:GetDescendants()
        
            for i=1,#allSpace do
                if allSpace[i].ClassName == "TextLabel" then
                    if string.find(allSpace[i].Text, messageTarget) then
                        allSpace[i].Text = string.gsub(allSpace[i].Text, messageTarget, messageChange)
                    
                        pcall(function()
                            if not allSpace[i]:FindFirstChild("Ded") then
                                local UIGradient : Instance = Instance.new("UIGradient")
                                UIGradient.Name = "Ded"
                                UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 115)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
                                UIGradient.Rotation = 0
                                UIGradient.Parent = allSpace[i]
                
                                task.spawn(function()
                                    while true do wait(0.01)
                                        UIGradient.Rotation = UIGradient.Rotation + 5
                                        if UIGradient.Rotation >= 360 then
                                            UIGradient.Rotation = 0
                                        end
                                    end
                                end)
                            end
                        end)
        
                        allSpace[i].Changed:Connect(function()
                            allSpace[i].Text = string.gsub(allSpace[i].Text, messageTarget, messageChange)
                        end)
                    end
                elseif allSpace[i].ClassName == "TextButton" then
                    if string.find(allSpace[i].Text, messageTarget) then
                        allSpace[i].Text = string.gsub(allSpace[i].Text, messageTarget, messageChange)
        
                        pcall(function()
                            if not allSpace[i]:FindFirstChild("Ded") then
                                local UIGradient : Instance = Instance.new("UIGradient")
                                UIGradient.Name = "Ded"
                                UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 115)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
                                UIGradient.Rotation = 0
                                UIGradient.Parent = allSpace[i]
                
                                task.spawn(function()
                                    while true do wait(0.01)
                                        UIGradient.Rotation = UIGradient.Rotation + 5
                                        if UIGradient.Rotation >= 360 then
                                            UIGradient.Rotation = 0
                                        end
                                    end
                                end)
                            end
                        end)
        
                        allSpace[i].Changed:Connect(function()
                            allSpace[i].Text = string.gsub(allSpace[i].Text, messageTarget, messageChange)
                        end)
                    end
                elseif allSpace[i].ClassName == "TextBox" then
                    if string.find(allSpace[i].Text, messageTarget) then
                        allSpace[i].Text = string.gsub(allSpace[i].Text, messageTarget, messageChange)
        
                        pcall(function()
                            if not allSpace[i]:FindFirstChild("Ded") then
                                local UIGradient : Instance = Instance.new("UIGradient")
                                UIGradient.Name = "Ded"
                                UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 115)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
                                UIGradient.Rotation = 0
                                UIGradient.Parent = allSpace[i]
                
                                task.spawn(function()
                                    while true do wait(0.01)
                                        UIGradient.Rotation = UIGradient.Rotation + 5
                                        if UIGradient.Rotation >= 360 then
                                            UIGradient.Rotation = 0
                                        end
                                    end
                                end)
                            end
                        end)
        
                        allSpace[i].Changed:Connect(function()
                            allSpace[i].Text = string.gsub(allSpace[i].Text, messageTarget, messageChange)
                        end)
                    end
                end
            end
        
            game.DescendantAdded:Connect(function(descendant : Instance)
                if descendant.ClassName == "TextLabel" then
                    if string.find(descendant.Text, messageTarget) then
                        descendant.Text = string.gsub(descendant.Text, messageTarget, messageChange)
        
                        pcall(function()
                            if not descendant:FindFirstChild("Ded") then
                                local UIGradient : Instance = Instance.new("UIGradient")
                                UIGradient.Name = "Ded"
                                UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 115)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
                                UIGradient.Rotation = 0
                                UIGradient.Parent = descendant
                
                                task.spawn(function()
                                    while true do wait(0.01)
                                        UIGradient.Rotation = UIGradient.Rotation + 5
                                        if UIGradient.Rotation >= 360 then
                                            UIGradient.Rotation = 0
                                        end
                                    end
                                end)
                            end
                        end)
        
                        descendant.Changed:Connect(function()
                            descendant.Text = string.gsub(descendant.Text, messageTarget, messageChange)
                        end)
                    end
                elseif descendant.ClassName == "TextButton" then
                    if string.find(descendant.Text, messageTarget) then
                        descendant.Text = string.gsub(descendant.Text, messageTarget, messageChange)
        
                        pcall(function()
                            if not descendant:FindFirstChild("Ded") the