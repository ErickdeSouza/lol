pcall(function()
	local IsDevelopmentBranch, NotificationTime = false, 30
	local Branch = IsDevelopmentBranch and "development" or "main"
	local Source = "https://raw.githubusercontent.com/ErickdeSouza/lol/" .. Branch .. "/"
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local PlayerService = game:GetService("Players")
	local LocalPlayer = PlayerService.LocalPlayer
	local Tortoiseshell = getupvalue(require(ReplicatedStorage.TS), 1)
	local Characters = getupvalue(Tortoiseshell.Characters.GetCharacter, 1)
	
	
	local function GetPlayerBody(Player)
	    local Character = Characters[Player]
	
	    if not Character then return end
	    if Character.Parent == nil then return end
	    return Character, Character:FindFirstChild("Body")
	end
	
	RunService.RenderStepped:Connect(function()
	    local char, Body = GetPlayerBody(LocalPlayer)
	    if not char or not Body then return end
	
	    local sprint = char.State.Sprinting.Server.Value
	    local slide = char.State.Sliding.Server.Value
	    local aiming = char.State.Aiming.Server.Value
	
	    if not sprint and not slide and not aiming then
	        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, nil)
	    end
	end)
	
	UserInputService.InputEnded:Connect(function(input, gp)
		if input.KeyCode == Enum.KeyCode.W then
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, nil)
		end
	end)
	
	repeat task.wait() until game.IsLoaded
	repeat task.wait() until game.GameId ~= 0
	
	pcall(function()
	    if Parvus and Parvus.Loaded then
	        Parvus.Utilities.UI:Push({
	            Title = "Parvus Hub",
	            Description = "Script already running!",
	            Duration = 5
	        }) return
	    end
	end)
	--[[if Parvus and (Parvus.Game and not Parvus.Loaded) then
	    Parvus.Utilities.UI:Push({
	        Title = "Parvus Hub",
	        Description = "Something went wrong!",
	        Duration = 5
	    }) return
	end]]
	
	local PlayerService = game:GetService("Players")
	repeat task.wait() until PlayerService.LocalPlayer
	local LocalPlayer = PlayerService.LocalPlayer
	
	local IsLocal = false
	--local ClearTeleportQueue = clear_teleport_queue
	local QueueOnTeleport = queue_on_teleport
	
	local function GetFile(File)
	    return IsLocal and readfile("Parvus/" .. File)
	    or game:HttpGet(("%s%s"):format(Parvus.Source, File))
	end
	
	local function LoadScript(Script)
	    return loadstring(GetFile(Script .. ".lua"), Script)()
	end
	
	local function GetGameInfo()
	    for Id, Info in pairs(Parvus.Games) do
	        if tostring(game.GameId) == Id then
	            return Info
	        end
	    end
	
	    return Parvus.Games.Universal
	end
	
	getgenv().Parvus = {
	    Source = "https://raw.githubusercontent.com/ErickdeSouza/lol/" .. Branch .. "/",
	
	    Games = {
	        ["Universal" ] = { Name = "Universal",                  Script = "Universal"  },
	        ["1168263273"] = { Name = "Bad Business",               Script = "Games/BB"   },
	        ["3360073263"] = { Name = "Bad Business PTR",           Script = "Games/BB"   },
	        ["1586272220"] = { Name = "Steel Titans",               Script = "Games/ST"   },
	        ["807930589" ] = { Name = "The Wild West",              Script = "Games/TWW"  },
	        ["580765040" ] = { Name = "RAGDOLL UNIVERSE",           Script = "Games/RU"   },
	        ["187796008" ] = { Name = "Those Who Remain",           Script = "Games/TWR"  },
	        ["358276974" ] = { Name = "Apocalypse Rising 2",        Script = "Games/AR2"  },
	        ["3495983524"] = { Name = "Apocalypse Rising 2 Dev.",   Script = "Games/AR2"  },
	        ["1054526971"] = { Name = "Blackhawk Rescue Mission 5", Script = "Games/BRM5" }
	    }
	}
	
	
	
	Parvus.Utilities = LoadScript("Utilities/Main")
	Parvus.Utilities.UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ErickdeSouza/lol/refs/heads/main/Utilities/UI.lua", "UI"))()
	Parvus.Utilities.Physics = LoadScript("Utilities/Physics")
	Parvus.Utilities.Drawing = LoadScript("Utilities/Drawing")
	
	Parvus.Cursor = GetFile("Utilities/ArrowCursor.png")
	Parvus.Loadstring = GetFile("Utilities/Loadstring")
	Parvus.Loadstring = Parvus.Loadstring:format(
	    Parvus.Source, Branch, NotificationTime, tostring(IsLocal)
	)
	
	LocalPlayer.OnTeleport:Connect(function(State)
	    if State == Enum.TeleportState.InProgress then
	        --ClearTeleportQueue()
	        QueueOnTeleport(Parvus.Loadstring)
	    end
	end)
	
	Parvus.Game = GetGameInfo()
	LoadScript(Parvus.Game.Script)
	Parvus.Loaded = true
	
	Parvus.Utilities.UI:Push({
	    Title = "Parvus Hub",
	    Description = Parvus.Game.Name .. " loaded!\n\nThis script is open sourced\nIf you have paid for this script\nOr had to go thru ads\nYou have been scammed.",
	    Duration = NotificationTime
	})
end)
