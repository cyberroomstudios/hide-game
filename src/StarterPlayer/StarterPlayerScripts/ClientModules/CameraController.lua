local CameraController = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ClientUtil = require(Players.LocalPlayer.PlayerScripts.ClientModules.ClientUtil)
local camera = workspace.CurrentCamera

-- Init Bridg Net
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("CameraService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

function CameraController:Init()
	CameraController:InitBridgeListener()
end

function CameraController:InitBridgeListener()
	bridge:Connect(function(response)
		if response[actionIdentifier] == "MoveToHouse" then
			CameraController:MoveToHouse()
		end

        if response[actionIdentifier] == "Reset" then
			CameraController:Reset()
		end
	end)
end

-- Reseta a camera do jogador para o padrão
function CameraController:Reset()
	camera.CameraType = Enum.CameraType.Custom
	CameraController:UnlockMovement()
end

-- Leva a camera do jogador para a visão de cima da casa
function CameraController:MoveToHouse()
	CameraController:LockMovement()
	local cameraAttachment = ClientUtil:WaitForDescendants(workspace, "Map", "Cameras", "HouseTopView")
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = cameraAttachment.WorldCFrame
end

function CameraController:LockMovement()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.AutoRotate = false
end

function CameraController:UnlockMovement()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.AutoRotate = true
end

return CameraController
