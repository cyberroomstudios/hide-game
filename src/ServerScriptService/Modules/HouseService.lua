local HouseService = {}

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Resources = ReplicatedStorage:WaitForChild("Resources")
local hiddenAttachment = Resources:WaitForChild("HiddenAttachment")
local hiddenPoints = workspace:WaitForChild("HiddenPoints")

local UtilService = require(ServerScriptService.Modules.UtilService)

function HouseService:Init() end

function HouseService:GetPartRoom(roomNumber: number)
	local floors = UtilService:WaitForDescendants(workspace, "Map", "House", "floors")

	for _, floor in floors:GetChildren() do
		if floor:GetAttribute("ROOM_NUMBER") and tonumber(floor:GetAttribute("ROOM_NUMBER")) == roomNumber then
			return floor.PrimaryPart
		end
	end
end

-- Retorna todos os jogadores de um determinado comodo
function HouseService:GetAllPlayersFromRoom(roomNumber: number)
	local playersInside = {}

	for _, player in Players:GetPlayers() do
		if player:GetAttribute("IN_HOUSE") then
			if player:GetAttribute("ROOM_NUMBER") and player:GetAttribute("ROOM_NUMBER") == roomNumber then
				table.insert(playersInside, player)
			end
		end
	end

	return playersInside
end

-- Verifica qual comodo um determinado jogador está
function HouseService:GetRoomFromPlayer(player: Player)
	if not player:GetAttribute("IN_HOUSE") then
		return nil
	end

	local character = player.Character
	if not character then
		return nil
	end

	local floors = UtilService:WaitForDescendants(workspace, "Map", "House", "floors")

	-- Bounding box do personagem
	local charCFrame, charSize = character:GetBoundingBox()
	local charHalf = charSize / 2

	for _, floor in floors:GetChildren() do
		local roomNumber = floor:GetAttribute("ROOM_NUMBER")
		local root = floor.PrimaryPart

		if roomNumber and root then
			local floorHalf = root.Size / 2

			-- posição do character no espaço local da sala
			local relative = root.CFrame:PointToObjectSpace(charCFrame.Position)

			-- ignora Y (plano)
			local intersects =
				math.abs(relative.X) <= (floorHalf.X + charHalf.X) and
				math.abs(relative.Z) <= (floorHalf.Z + charHalf.Z)

			if intersects then
				return roomNumber
			end
		end
	end

	return nil
end

-- Define o comodo de todos os jogadores
function HouseService:SetRoomFromPlayers()
	for _, player in Players:GetPlayers() do
		if player:GetAttribute("IN_HOUSE") and not player:GetAttribute("IS_KILLER") then
			-- Obtem em qual comodo o jogador está
			local roomNumber = HouseService:GetRoomFromPlayer(player)

			--  TODO se o jogador não estiver em nenhum comodo, leva ele pra um comodo aleatorio
			if not roomNumber then
				local randomRoomNumber = math.random(1, #hiddenPoints:GetChildren())
				roomNumber = randomRoomNumber
			end

			player:SetAttribute("ROOM_NUMBER", roomNumber)
		end
	end
end

-- Mostra o jogador como escondido
function HouseService:ShowHiddenPlayers(player: Player)
	for _ , point in pairs(hiddenPoints:GetChildren()) do
		local attachment = hiddenAttachment:Clone()
		attachment.Parent = point
		local imageTemplate = attachment:FindFirstChild("ImageTemplate", true)
		local frame = attachment:FindFirstChild("Frame", true)

		local playersInside = HouseService:GetAllPlayersFromRoom(tonumber(point.Name))

		for x = 1 , #playersInside do
			imageTemplate:Clone().Parent = frame
		end
	end
end


return HouseService
