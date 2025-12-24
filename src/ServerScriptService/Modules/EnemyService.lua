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
local VictoryOrDefeatService = require(ServerScriptService.Modules.VictoryOrDefeatService)

-- Variável para ativar/desativar visualização do path
local SHOW_PATH_DEBUG = false

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

local function visualizeWaypoint(position, index)
	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(1, 1, 1)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.BrickColor = BrickColor.new("Lime green")
	part.Material = Enum.Material.Neon
	part.Transparency = 0.5
	part.Parent = workspace.Waypoints
end

local function moveToTarget(enemy, targetPoint)
	local targetPosition = targetPoint.Position
	local humanoid = enemy:FindFirstChild("Humanoid")
	local rootPart = enemy:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then
		return
	end

	-- Criar caminho
	local path = PathfindingService:CreatePath({
		AgentRadius = 3,
		AgentHeight = 6,
		AgentCanJump = false,
	})
	path:ComputeAsync(rootPart.Position, targetPosition)

	-- Se o caminho foi calculado com sucesso
	if path.Status == Enum.PathStatus.Success then
		local waypoints = path:GetWaypoints()

		-- Visualizar waypoints se ativado
		if SHOW_PATH_DEBUG then
			workspace.Waypoints:ClearAllChildren()
			for i, waypoint in waypoints do
				visualizeWaypoint(waypoint.Position, i)
			end
		end

		-- Seguir cada waypoint
		for _, waypoint in waypoints do
			humanoid:MoveTo(waypoint.Position)
			humanoid.MoveToFinished:Wait()
		end
		targetPoint.Color = Color3.fromRGB(255, 0, 0)
		targetPoint.Parent = killedPoints

		for _ , imageLabel in pairs(targetPoint:GetDescendants()) do
			if imageLabel:IsA("ImageLabel") then
				if imageLabel.Name == "ImageTemplate" then
					imageLabel.ImageColor3 = Color3.fromRGB(85, 85, 85)
				end
				if imageLabel.Name == "Dead" then
					imageLabel.Visible = true
				end
			end
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
		moveToTarget(killer, targetPoint)
		killer:SetAttribute("State", "Idle")
		task.wait(1)
		killer:SetAttribute("State", "Attack")
		task.wait(1)
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
