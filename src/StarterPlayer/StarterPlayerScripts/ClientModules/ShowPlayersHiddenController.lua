local HiddenPlayersController = {}


-- -- Init Bridg Net
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Utility = ReplicatedStorage.Utility
-- local BridgeNet2 = require(Utility.BridgeNet2)
-- local bridge = BridgeNet2.ReferenceBridge("HouseService")
-- local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
-- local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
-- local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- -- End Bridg Net


-- function HiddenPlayersController:Init()
-- 	HiddenPlayersController:InitBridgeListener()
-- end


-- function HiddenPlayersController:HidePlayers()
	
-- end


-- function HiddenPlayersController:InitBridgeListener()
-- 	bridge:Connect(function(response)
-- 		if response[actionIdentifier] == "HidePlayers" then
-- 			HiddenPlayersController:HidePlayers()
-- 		end
-- 	end)
-- end

return HiddenPlayersController