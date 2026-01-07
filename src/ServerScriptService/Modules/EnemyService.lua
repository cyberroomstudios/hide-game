local EnemyService = {}
local Players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local hiddenPoints = workspace:WaitForChild("HiddenPoints")
local killedPoints = workspace:WaitForChild("KilledPoints")

local Resources = replicatedStorage:WaitForChild("Resources")
local Killers = Resources:WaitForChild("Killers")

-- Init Bridg Net
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("KillerService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

local HouseService = require(ServerScriptService.Modules.HouseService)
local CameraService = require(ServerScriptService.Modules.CameraService)
local VictoryOrDefeatService = require(ServerScriptService.Modules.VictoryOrDefeatService)
local GamePathFindingService = require(ServerScriptService.Modules.GamePathFindingService)


local selectedRoom = nil

function EnemyService:Init()
	print("Enemy Service Initialized")
	EnemyService:InitBridgeListener()
end

function EnemyService:InitBridgeListener()
	bridge.OnServerInvoke = function(player, data)
		if data[actionIdentifier] == "GoToRoom" then
			local roomNumber = data.data.RoomNumber
			selectedRoom = roomNumber
		end
	end
end




function EnemyService:SpawnEnemy()
	local killer = Killers:GetChildren()[math.random(1, #Killers:GetChildren())]:Clone()
	killer:SetAttribute("State", "Spawned")
	killer.Parent = workspace
	killer.PrimaryPart:SetNetworkOwner(nil)
	local totalHiddenPoints = #hiddenPoints:GetChildren()

	while #hiddenPoints:GetChildren() > math.floor(totalHiddenPoints / 2) do
		selectedRoom = nil

		for x = 1, 5 do
			if selectedRoom then
				break
			end
			task.wait(1)
		end

		local randomPoint

		if selectedRoom then
			randomPoint = hiddenPoints:FindFirstChild(tostring(selectedRoom))
		else
			randomPoint = hiddenPoints:GetChildren()[math.random(1, #hiddenPoints:GetChildren())]
		end

		local targetPoint = randomPoint

		killer:SetAttribute("State", "Walk")
		GamePathFindingService:MoveToTarget(killer, targetPoint)
		
		CameraService:SetAllPlayerToRoomView(targetPoint.Name)
		print("Killer moved to room: " .. targetPoint.Name)
		task.wait(5)
		print("Killer reached the room: " .. targetPoint.Name)
		CameraService:SetAllVictimsToTopViewHouse()

		--killer:SetAttribute("State", "Idle")
		--task.wait(1)
		--killer:SetAttribute("State", "Attack")
		--task.wait(1)
		EnemyService:KillAllPlayersFromRoom(tonumber(randomPoint.Name))
		killer:SetAttribute("State", "Idle")
		task.wait(math.random(1, 3))

		-- Mata todos os jogadores do comodo
	end
	killer:Destroy()
end

function EnemyService:ClearPoints()
	for _, point in pairs(hiddenPoints:GetChildren()) do
		point:ClearAllChildren()
	end
	for _, point in pairs(killedPoints:GetChildren()) do
		point:ClearAllChildren()
	end
end


function EnemyService:StartKiller()
	-- TODO Implementar Lógica de Aguardar os Comandos para levar o Killer para os comados
	for _, point in pairs(killedPoints:GetChildren()) do
		point.Color = Color3.fromRGB(0, 165, 5)
		point.Parent = hiddenPoints
	end
	
	-- Mostra os jogadores como escondidos
	HouseService:ShowHiddenPlayers()
	
	self:SpawnEnemy()
	self:ClearPoints()
end

function EnemyService:KillAllPlayersFromRoom(roomNumber: number)
	-- Obtem todos os jogadores do Room
	local playersFromRoom = HouseService:GetAllPlayersFromRoom(roomNumber)

	for _, player in playersFromRoom do
		VictoryOrDefeatService:KillPlayer(player)
	end
end

return EnemyService
