local DrawKillerService = {}
local Players = game:GetService("Players")

-- Quantidade Máxima de Jogadores no servidor
local TARGET_AMOUNT = 10

-- Limite para sortear um Id
local MAX_RANDOM_USER_ID = 2_000_000_000

function DrawKillerService:Init() end

function DrawKillerService:GetUserThumbnail(userId)
	local success, content = pcall(function()
		return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
	end)

	if success and content and content ~= "" then
		return content
	end

	return nil
end

function DrawKillerService:GetPlayersAndKiller()
	local allPlayers = {}
	local usedIds = {}

	-- Todos os Jogadores do servidor
	for _, player in ipairs(Players:GetPlayers()) do
		local image = DrawKillerService:GetUserThumbnail(player.UserId)
		if image then
			table.insert(allPlayers, {
				UserId = player.UserId,
				Image = image,
			})
			usedIds[player.UserId] = true
		end
	end

	-- Caso não tenha jogadores suficiente completa com usuários aleatórios
	while #allPlayers < TARGET_AMOUNT do
		local randomUserId = math.random(1, MAX_RANDOM_USER_ID)

		if not usedIds[randomUserId] then
			local image = DrawKillerService:GetUserThumbnai(randomUserId)
			if image then
				table.insert(allPlayers, {
					UserId = randomUserId,
					Image = image,
				})
				usedIds[randomUserId] = true
			end
		end

		task.wait()
	end

	-- Define Killer aleatoriamente da lista
	local killerIndex = math.random(1, #allPlayers)
	local killer = allPlayers[killerIndex]

	return {
		Killer = killer,
		AllPlayers = allPlayers,
	}
end

return DrawKillerService
