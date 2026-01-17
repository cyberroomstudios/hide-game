local PlayerController = {}

function PlayerController:Init() end

function PlayerController:LockMovement()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
end

function PlayerController:UnLockMovement()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
end

return PlayerController
