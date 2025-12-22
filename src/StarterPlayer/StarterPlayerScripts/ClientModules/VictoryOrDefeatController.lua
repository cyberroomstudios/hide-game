local VictoryOrDefeatController = {}

local Players = game:GetService("Players")

-- Init Bridg Net
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("VictoryOrDefeatService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

local youSurvived
local youDied

function VictoryOrDefeatController:Init()
	VictoryOrDefeatController:CreateReferences()
	VictoryOrDefeatController:InitBridgeListener()
end

function VictoryOrDefeatController:CreateReferences()
	youSurvived = UIReferences:GetReference("YOU_SURVIVED")
	youDied = UIReferences:GetReference("YOU_DIED")
end

function VictoryOrDefeatController:InitBridgeListener()
	bridge:Connect(function(response)
		if response[actionIdentifier] == "GiveVictimWins" then
			youSurvived.Visible = true
			task.delay(2, function()
				youSurvived.Visible = false
			end)
		end

		if response[actionIdentifier] == "KillPlayer" then
			youDied.Visible = true
			task.delay(2, function()
				youDied.Visible = false
			end)
		end
	end)
end

return VictoryOrDefeatController
