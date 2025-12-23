local GameLoopService = {}

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
function GameLoopService:Init()
	GameLoopService:Start()
end

function GameLoopService:Start()
	task.spawn(function()
		while true do
			-- Loop

			-- 1º Aguarda um tempo para inicializar o Round
			GameLoopService:WaitInitGame()

			-- 2º Sorteia um jogador para ser o Matador e mostra para os jogadores
			GameLoopService:DrawKiller()

			-- 3° Teleporta todos os jogadores para a cada e manda se esconder
			GameLoopService:StartHideStep()
		end
	end)
end

function GameLoopService:WaitInitGame()
	workspace:SetAttribute("GAME_STEP", "WAIT_INIT_GAME")

	for i = 5, 1, -1 do
		workspace:SetAttribute("TIME_FOR_INIT_GAME", i)
		task.wait(1)
	end

	task.wait(3)
	workspace:SetAttribute("GAME_STEP", "HIDE")

	task.wait(5)
end

function GameLoopService:DrawKiller()
	-- TODO Adicionar Lógica de sortear o matador
	workspace:SetAttribute("GAME_STEP", "DRAWING_THE_KILLER")
end

function GameLoopService:StartHideStep()
	GameLoopService:TeleportAllPlayers()
	workspace:SetAttribute("GAME_STEP", "HIDE")

	for i = 10, 1, -1 do
		workspace:SetAttribute("TIME_FOR_HIDE", i)
		task.wait(1)
	end
end

function GameLoopService:ShowInit() end

function GameLoopService:TeleportAllPlayers()
	for _, player in Players:GetPlayers() do
		pcall(function()
			bridge:Fire(player, {
				[actionIdentifier] = "TeleportToStartGame",
			})
		end)
	end
end

return GameLoopService
