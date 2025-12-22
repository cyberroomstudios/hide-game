local Players = game:GetService("Players")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)

local UIManager = {}

local labels = {}
local gameInProgressTextLabel

function UIManager:Init() end

function UIManager:CreateReferences()
	gameInProgressTextLabel = UIReferences:GetReference("GAME_IN_PROGRESS")
end

function UIManager:OpenLabel(labelName: string) end

return UIManager
