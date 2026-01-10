local KillerChanceService = {}

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerDataHandler = require(ServerScriptService.Modules.PlayerDataHandler)

local MIN_CHANCE = 3
local MIN_CHANCE_WITH_GAMEPASS = 20
local INCREMENT_CHANCE = 3

function KillerChanceService:Init() end

function KillerChanceService:ResetChance(player: Player)
	KillerChanceService:StartInitialChance(player)
end

function KillerChanceService:IncrementChance(player: Player)
	local oldChance = player:GetAttribute("KILLER_CHANCE") or 3
	player:SetAttribute("KILLER_CHANCE", oldChance + INCREMENT_CHANCE)
end

function KillerChanceService:StartInitialChance(player: Player)
	local hasToBeKillerGamepass = PlayerDataHandler:Get(player, "hasToBeKillerGamepass")
	player:SetAttribute("KILLER_CHANCE", hasToBeKillerGamepass and MIN_CHANCE_WITH_GAMEPASS or MIN_CHANCE)
end

function KillerChanceService:DrawPlayerByChance()
	local players = Players:GetPlayers()

	local totalChance = 0
	local weightedPlayers = {}

	for _, player in ipairs(players) do
		local chance = player:GetAttribute("KILLER_CHANCE") or 0
		if chance > 0 then
			totalChance += chance
			table.insert(weightedPlayers, {
				player = player,
				chance = chance,
			})
		end
	end

	-- Peso neutro: ninguém é killer
	local NONE_WEIGHT = math.max(100 - totalChance, 0)
	local finalTotal = totalChance + NONE_WEIGHT

	if finalTotal <= 0 then
		return nil
	end

	local randomValue = math.random() * finalTotal
	local accumulated = 0

	-- Primeiro: ninguém
	accumulated += NONE_WEIGHT
	if randomValue <= accumulated then
		return nil
	end

	-- Depois: jogadores
	for _, data in ipairs(weightedPlayers) do
		accumulated += data.chance
		if randomValue <= accumulated then
			return data.player
		end
	end

	return nil
end

function KillerChanceService:DrawPlayerByChanceFake()
	local players = Players:GetPlayers()

	for _, player in players do
		return player
	end
end

return KillerChanceService
