local VictoryOrDefeatService = {}
local ServerScriptService = game:GetService("ServerScriptService")

-- Init Bridg Net
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("VictoryOrDefeatService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

local PlayerDataHandler = require(ServerScriptService.Modules.PlayerDataHandler)
local GameTeleportService = require(ServerScriptService.Modules.GameTeleportService)
local CameraService = require(ServerScriptService.Modules.CameraService)

function VictoryOrDefeatService:Init() end

function VictoryOrDefeatService:GiveVictimWin(player: Player)
	-- Atualiza o DataStore do jogador
	PlayerDataHandler:Update(player, "victimWins", function(current)
		return current + 1
	end)

	-- Exibe que o Jogador Sobreviveu
	bridge:Fire(player, {
		[actionIdentifier] = "GiveVictimWins",
	})
end

function VictoryOrDefeatService:KillPlayer(player: Player)
	-- Atualiza a quantidade de vezes que o jogador morreu
	PlayerDataHandler:Update(player, "victimMurdered", function(current)
		return current + 1
	end)

	-- Reseta a camera e libera os movimentos
	CameraService:ResetInHouseFromPlayer(player)

	-- Manda o jogador de volta ao Lobby
	GameTeleportService:TeleportToLobby(player)

	-- Exibe que o Jogador Morreu
	bridge:Fire(player, {
		[actionIdentifier] = "KillPlayer",
	})
end

return VictoryOrDefeatService
