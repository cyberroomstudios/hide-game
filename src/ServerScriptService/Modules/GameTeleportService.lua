local GameTeleportService = {}

-- Init Bridg Net
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("TeleportService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

function GameTeleportService:Init() end

function GameTeleportService:TeleportAllPlayersToHouse()
	for _, player in Players:GetPlayers() do
		pcall(function()
			bridge:Fire(player, {
				[actionIdentifier] = "TeleportToHouse",
			})
		end)
	end
end

function GameTeleportService:TeleportWinnersToLobby(winnerPlayer: Player)
	bridge:Fire(winnerPlayer, {
		[actionIdentifier] = "TeleportToLobby",
	})
end

return GameTeleportService
