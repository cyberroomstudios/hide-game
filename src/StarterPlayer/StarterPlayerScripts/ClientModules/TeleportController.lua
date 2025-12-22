local TeleportController = {}

-- Init Bridg Net
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("TeleportService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net
local Players = game:GetService("Players")
local player = Players.LocalPlayer

function TeleportController:Init() end

function TeleportController:InitBridgeListener()
	bridge:Connect(function(response)
		if response[actionIdentifier] == "TeleportToStartGame" then
			TeleportController:ToStartGame()
		end
	end)
end

function TeleportController:ToLobbySpawn()
	local lobbySpawnCFrame = player:GetAttribute("LOBBY_SPAWN")

	local character = player.Character
	if lobbySpawnCFrame and character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = lobbySpawnCFrame
	end
end

function TeleportController:ToStartGame()
	local lobbySpawnCFrame = player:GetAttribute("START_GAME_SPAWN")

	local character = player.Character
	if lobbySpawnCFrame and character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = lobbySpawnCFrame
	end
end

return TeleportController
