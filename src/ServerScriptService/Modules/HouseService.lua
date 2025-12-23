local HouseService = {}

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

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

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return nil
	end

	local floors = UtilService:WaitForDescendants(workspace, "Map", "House", "floors")

	-- Ignora altura (Y)
	local playerPos = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)

	for _, floor in floors:GetChildren() do
		local roomNumber = floor:GetAttribute("ROOM_NUMBER")
		if roomNumber then
			local partPos = Vector3.new(floor.PrimaryPart.Position.X, 0, floor.PrimaryPart.Position.Z)
			local halfSize = Vector3.new(floor.PrimaryPart.Size.X / 2, 0, floor.PrimaryPart.Size.Z / 2)

			local isInside = math.abs(playerPos.X - partPos.X) <= halfSize.X
				and math.abs(playerPos.Z - partPos.Z) <= halfSize.Z

			if isInside then
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
				print("Jogador não está em nenhum comodo")
				continue
			end

			player:SetAttribute("ROOM_NUMBER", roomNumber)
		end
	end
end

return HouseService
