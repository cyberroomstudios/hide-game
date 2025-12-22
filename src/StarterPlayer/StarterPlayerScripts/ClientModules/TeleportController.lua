local TeleportController = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

function TeleportController:ToLobbySpawn()
	local lobbySpawnCFrame = player:GetAttribute("LOBBY_SPAWN")

	local character = player.Character
	if lobbySpawnCFrame and character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = lobbySpawnCFrame
	end
end

return TeleportController
