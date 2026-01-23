local GameLoopService = {}

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local GameTeleportService = require(ServerScriptService.Modules.GameTeleportService)
local PlayerDataHandler = require(ServerScriptService.Modules.PlayerDataHandler)
local VictoryOrDefeatService = require(ServerScriptService.Modules.VictoryOrDefeatService)
local EnemyService = require(ServerScriptService.Modules.EnemyService)
local HouseService = require(ServerScriptService.Modules.HouseService)
local CameraService = require(ServerScriptService.Modules.CameraService)
local BotService = require(ServerScriptService.Modules.BotService)
local KillerChanceService = require(ServerScriptService.Modules.KillerChanceService)

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

	for i = 15, 0, -1 do
		workspace:SetAttribute("TIME_FOR_INIT_GAME", i)
		task.wait(1)
	end
end

function GameLoopService:DrawKiller()
	local players = Players:GetPlayers()

	-- Limpa todos os Jogadores
	for _, player in players do
		player:SetAttribute("IS_KILLER", false)
	end

	local killer = KillerChanceService:DrawPlayerByChanceFake()

	-- Define o Killer e reseta a chance dele pra próxima rodada
	if killer then
		killer:SetAttribute("IS_KILLER", true)
		KillerChanceService:ResetChance(killer)
	end

	-- Incrementa a chance dos demais jogadores
	for _, player in players do
		if killer and killer == player then
			continue
		end
		KillerChanceService:IncrementChance(player)
	end

	workspace:SetAttribute("GAME_STEP", "DRAWING_THE_KILLER")
	task.wait(7)
end

function GameLoopService:StartHideStep()
	-- Cria todos os bots
	BotService:SpawnInHouse(10)

	-- Muda a Visão do Killer para cima da casa
	--CameraService:SetKillerView()

	-- Teleporta o Killer para o Spawn Killer
	--GameTeleportService:TeleportKillerToSpawn()

	-- Pega todo mundo pra dentro de casa
	GameTeleportService:TeleportAllPlayersToHouse()
	workspace:SetAttribute("GAME_STEP", "PLAYERS_HIDING")

	for i = 10, 1, -1 do
		workspace:SetAttribute("TIME_FOR_HIDE", i)
		task.wait(1)
	end

	-- Define o comodo de todos os jogadores
	HouseService:SetRoomFromPlayers()

	-- Muda a Visão de todos as vitimas
	CameraService:SetAllVictimsToTopViewHouse()
end

function GameLoopService:StartKillerStep()
	workspace:SetAttribute("GAME_STEP", "KILLER_IN_PROGRESS")
	EnemyService:StartKiller()
	
end

function GameLoopService:GiveWin()
	workspace:SetAttribute("GAME_STEP", "RETURNING_WINNERS")

	-- Reseta a visão de todos os jogadores na casa
	CameraService:ResetAllPlayersInHouse()

	for _, player in Players:GetPlayers() do
		pcall(function()
			-- Verifica se o jogador ainda está dentro de casa
			if player:GetAttribute("IN_HOUSE") then
				-- Manda o jogador de volta ao Lobby
				GameTeleportService:TeleportToLobby(player)

				-- Da a Vitoria pro jogador
				VictoryOrDefeatService:GiveVictimWin(player)
			end
		end)
	end
end

return GameLoopService
