local BotService = {}
local PhysicsService = game:GetService("PhysicsService")

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local GamePathFindingService = require(ServerScriptService.Modules.GamePathFindingService)

local COLLIDE_GROUP_NAME = "PLAYER_OR_NPC"
local MIN_USER_ID = 1
local MAX_USER_ID = 20000
local MAX_TRIES = 10

function BotService:Init() end

-- Pega as informações de um jogador aleatorio
local function getRandomHumanoidDescription()
	for _ = 1, MAX_TRIES do
		local randomUserId = math.random(MIN_USER_ID, MAX_USER_ID)

		local success, humanoidDescription = pcall(function()
			return Players:GetHumanoidDescriptionFromUserId(randomUserId)
		end)

		if success and humanoidDescription then
			return humanoidDescription, randomUserId
		end
	end

	return nil, nil
end

local function setNpcCollisionGroup(npcModel)
	local function apply(part)
		if part:IsA("BasePart") then
			part.CanCollide = true
			part.CollisionGroup = "NPC"
		end
	end

	-- Aplica nas partes atuais
	for _, obj in npcModel:GetDescendants() do
		apply(obj)
	end

	-- Aplica em partes que entrarem depois (acessórios, etc)
	npcModel.DescendantAdded:Connect(apply)
end

-- Cria um NPC e leva pro Spawn
local function createNpcFromRandomRobloxUser(spawnCFrame: CFrame)
	local humanoidDescription, userId = getRandomHumanoidDescription()
	if not humanoidDescription then
		warn("Humanoid Description Not Found")
		return
	end

	local username
	local success, nameResult = pcall(function()
		return Players:GetNameFromUserIdAsync(userId)
	end)
	username = success and nameResult or ("User_" .. userId)

	local npc = Players:CreateHumanoidModelFromDescription(humanoidDescription, Enum.HumanoidRigType.R15)

	npc.Name = username .. "_NPC"

	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	humanoid.DisplayName = username
	humanoid.Health = humanoid.MaxHealth
	humanoid.BreakJointsOnDeath = false

	local root = npc:FindFirstChild("HumanoidRootPart")
	if root then
		root.Anchored = false
		root.CFrame = spawnCFrame
	end

	npc.Parent = workspace.Bots
	setNpcCollisionGroup(npc)
	return npc
end

-- Cria bots dentro de casa
function BotService:SpawnInHouse(amount: number)
	task.spawn(function()
		-- Pega um Spawn Aleatorio
		local botsSpawn = workspace:WaitForChild("Map"):WaitForChild("House"):WaitForChild("BotsSpawn")
		local spawns = botsSpawn:GetChildren()

		for i = 1, amount do
			task.spawn(function()
				local randomSpawn = spawns[i]

				if randomSpawn then
					-- Cria o Bot
					local bot = createNpcFromRandomRobloxUser(randomSpawn.CFrame)

					if bot then
						task.wait(0.5)
						-- Leva o bot para um Comodo
						BotService:MoveBot(bot)
					end
				end
			end)
		end
	end)
end

function BotService:MoveBot(bot: Model)
	local hiddenPoints = workspace:WaitForChild("HiddenPoints")
	local randomRoomNumber = math.random(1, #hiddenPoints:GetChildren())
	bot:SetAttribute("ROOM_NUMBER", randomRoomNumber)
	GamePathFindingService:MoveToTarget(bot, hiddenPoints[randomRoomNumber])
end
return BotService
