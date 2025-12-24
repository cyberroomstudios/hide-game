local HudController = {}
local Players = game:GetService("Players")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local DeveloperProductController = require(Players.LocalPlayer.PlayerScripts.ClientModules.DeveloperProductController)

local beTheKillerButton

function HudController:Init()
	HudController:CreateReferences()
	HudController:InitButtonListerns()
end

function HudController:CreateReferences()
	beTheKillerButton = UIReferences:GetReference("BE_THE_KILLER_BUTTON")
end
function HudController:InitButtonListerns()
	beTheKillerButton.MouseButton1Click:Connect(function()
		DeveloperProductController:OpenPaymentRequestScreen("BE_THE_KILLER")
	end)
end

return HudController
