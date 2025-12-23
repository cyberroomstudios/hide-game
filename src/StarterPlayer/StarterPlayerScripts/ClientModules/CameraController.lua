local CameraController = {}
local Players = game:GetService("Players")
local ClientUtil = require(Players.LocalPlayer.PlayerScripts.ClientModules.ClientUtil)
local camera = workspace.CurrentCamera

function CameraController:Init() end

-- Reseta a camera do jogador para o padrão
function CameraController:Reset()
	camera.CameraType = Enum.CameraType.Custom
end

-- Leva a camera do jogador para a visão de cima da casa
function CameraController:MoveToHouse()
	local cameraAttachment = ClientUtil:WaitForDescendants(workspace, "Map", "Cameras", "HouseTopView")
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = cameraAttachment.WorldCFrame
end

return CameraController
