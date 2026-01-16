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
		player:SetAttribute("IN_HOUSE", true)

		if player:GetAttribute("IS_KILLER") then
			GameTeleportService:TeleportToKillerSpawn(player)
		else
			GameTeleportService:TeleportToHouse(player)
		end
	end
end

function GameTeleportService:TeleportToHouse(player)
	pcall(function()
		bridge:Fire(player, {
			[actionIdentifier] = "TeleportToHouse",
		})
	end)
end

function GameTeleportService:TeleportToKillerSpawn(player)
	pcall(function()
		bridge:Fire(player, {
			[actionIdentifier] = "TeleporToKillerSpawn",
		})
	end)
end

function GameTeleportService:TeleportToLobby(player: Player)
	player:SetAttribute("IN_HOUSE", false)
	bridge:Fire(player, {
		[actionIdentifier] = "",
	})
end

return GameTeleportService
