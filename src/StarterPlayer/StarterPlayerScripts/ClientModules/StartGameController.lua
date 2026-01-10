local StartGameController = {}
-- Init Bridg Net
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)

local bridge = BridgeNet2.ReferenceBridge("StartGameService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

local TeleportController = require(Players.LocalPlayer.PlayerScripts.ClientModules.TeleportController)
local GameLoopController = require(Players.LocalPlayer.PlayerScripts.ClientModules.GameLoopController)
local KillerChanceController = require(Players.LocalPlayer.PlayerScripts.ClientModules.KillerChanceController)
local HouseController = require(Players.LocalPlayer.PlayerScripts.ClientModules.HouseController)

local player = Players.LocalPlayer

function StartGameController:Init(data)
	local result = bridge:InvokeServerAsync({
		[actionIdentifier] = "Start",
		data = {},
	})

	KillerChanceController:SetInitialChance()

	TeleportController:ToLobbySpawn()
	GameLoopController:VerifyGameStep()
end

return StartGameController
