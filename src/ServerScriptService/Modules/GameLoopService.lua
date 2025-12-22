local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local GameTeleportService = require(ServerScriptService.Modules.GameTeleportService)
local PlayerDataHandler = require(ServerScriptService.Modules.PlayerDataHandler)
local VictoryOrDefeatService = require(ServerScriptService.Modules.VictoryOrDefeatService)

local GameLoopService = {}

function GameLoopService:Init()
	GameLoopService:Start()
end

function GameLoopService:Start()
	task.spawn(function()
		while true do
			-- Loop

			-- WORKSPACE STATES
			-- 1° WAIT_INIT_GAME
			-- 2° DRAWING_THE_KILLER
			-- 3° PLAYERS_HIDING
			-- 4° KILLER_IN_PROGRESS
			-- 5° RETURNING_WINNERS

			-- 1º Aguarda um tempo para inicializar o Round ()
			GameLoopService:WaitInitGame()

			-- 2º Sorteia um jogador para ser o Matador e mostra para os jogadores
			GameLoopService:DrawKiller()

			-- 3° Teleporta todos os jogadores para a cada e manda se esconder
			GameLoopService:StartHideStep()

			-- 4° Inicializa o Killer
			GameLoopService:StartKillerStep()

			-- 5° Leva todos os jogadores Vencedores de Volta ao Lobby
			GameLoopService:GiveWin()
		end
	end)
end

function GameLoopService:WaitInitGame()
	workspace:SetAttribute("GAME_STEP", "WAIT_INIT_GAME")

	for i = 5, 0, -1 do
		workspace:SetAttribute("TIME_FOR_INIT_GAME", i)
		task.wait(1)
	end
end

function GameLoopService:DrawKiller()
	-- TODO Adicionar Lógica de sortear o matador
	workspace:SetAttribute("GAME_STEP", "DRAWING_THE_KILLER")

	task.wait(3)
end

function GameLoopService:StartHideStep()
	GameTeleportService:TeleportAllPlayersToHouse()
	workspace:SetAttribute("GAME_STEP", "PLAYERS_HIDING")

	for i = 10, 1, -1 do
		workspace:SetAttribute("TIME_FOR_HIDE", i)
		task.wait(1)
	end
end

function GameLoopService:ShowInit() end

function GameLoopService:StartKillerStep()
	workspace:SetAttribute("GAME_STEP", "KILLER_IN_PROGRESS")
	task.wait(10)
end

function GameLoopService:GiveWin()
	workspace:SetAttribute("GAME_STEP", "RETURNING_WINNERS")

	for _, player in Players:GetPlayers() do
		pcall(function()
			-- Da a Vitoria pro jogador
			VictoryOrDefeatService:GiveVictimWin(player)

			-- Manda o jogador de volta ao Lobby
			GameTeleportService:TeleportWinnersToLobby(player)
		end)
	end
end

return GameLoopService
