local HudController = {}
local Players = game:GetService("Players")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local DeveloperProductController = require(Players.LocalPlayer.PlayerScripts.ClientModules.DeveloperProductController)

local beTheKiller

function HudController:Init()
	HudController:CreateReferences()
	HudController:InitButtonListerns()
end

function HudController:CreateReferences()
	beTheKiller = UIReferences:GetReference("BE_THE_KILLER_BUTTON")
end

function HudController:InitButtonListerns()
	beTheKiller.MouseButton1Click:Connect(function()
		DeveloperProductController:OpenPaymentRequestScreen("BE_THE_KILLER")
	end)
end

function HudController:HideDefaultHud() end

function HudController:ShowDefaultHud() end

return HudController
