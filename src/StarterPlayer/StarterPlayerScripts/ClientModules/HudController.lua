local HudController = {}
local Players = game:GetService("Players")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local DeveloperProductController = require(Players.LocalPlayer.PlayerScripts.ClientModules.DeveloperProductController)


function HudController:Init()
	HudController:CreateReferences()
	HudController:InitButtonListerns()
end

function HudController:CreateReferences()
end

function HudController:InitButtonListerns()

end

function HudController:HideDefaultHud()
	
end

function HudController:ShowDefaultHud()

end
return HudController
