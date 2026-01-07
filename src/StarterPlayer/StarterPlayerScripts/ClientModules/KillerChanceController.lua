local KillerChanceController = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)

local killerChanceTextLabel

function KillerChanceController:Init()
	KillerChanceController:CreateReferences()
	KillerChanceController:InitPlayerAttributes()
end

function KillerChanceController:CreateReferences()
	killerChanceTextLabel = UIReferences:GetReference("KILLER_CHANCE")
end

function KillerChanceController:InitPlayerAttributes()
	player:GetAttributeChangedSignal("KILLER_CHANCE"):Connect(function()
		killerChanceTextLabel.Text = "Chance of Being a Killer: " .. player:GetAttribute("KILLER_CHANCE") .. "%"
	end)
end

function KillerChanceController:SetInitialChance()
	killerChanceTextLabel.Text = "Chance of Being a Killer: " .. (player:GetAttribute("KILLER_CHANCE") or 3) .. "%"
end

return KillerChanceController
