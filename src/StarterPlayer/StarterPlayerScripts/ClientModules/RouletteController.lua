local Players = game:GetService("Players")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)

local RouletteController = {}

local screen

function RouletteController:Init()
	RouletteController:CreateReferences()
end

function RouletteController:CreateReferences()
	screen = UIReferences:GetReference("ROULETTE_SCREEN")
end

function RouletteController:Open(data)
	screen.Visible = true
end

function RouletteController:Close()
	screen.Visible = false
end

function RouletteController:GetScreen()
	return screen
end

return RouletteController
