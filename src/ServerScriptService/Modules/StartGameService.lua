local StartGameService = {}

-- Init Bridg Net
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local UtilService = require(ServerScriptService.Modules.UtilService)
local bridge = BridgeNet2.ReferenceBridge("StartGameService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

local playerInitializer = {}

function StartGameService:Init()
	StartGameService:InitBridgeListener()

	Players.PlayerRemoving:Connect(function(player)
		playerInitializer[player] = nil
	end)
end

function StartGameService:InitBridgeListener()
	bridge.OnServerInvoke = function(player, data)
		if data[actionIdentifier] == "Start" then
			-- Segurança para evitar que seja inicializado mais de uma vez
			if playerInitializer[player] then
				return false
			end
			StartGameService:InitPlayerAttributes(player)
			print("Init")
		end
	end
end

function StartGameService:InitPlayerAttributes(player: Player)
	local lobbySpawn = UtilService:WaitForDescendants(workspace, "Map", "Lobby", "Spawn")
	player:SetAttribute("LOBBY_SPAWN", lobbySpawn.CFrame)

		local lobbyStartGame = UtilService:WaitForDescendants(workspace, "Map", "House", "Spawn")
	player:SetAttribute("START_GAME_SPAWN", lobbyStartGame.CFrame)
end

return StartGameService
