local CameraService = {}

-- Init Bridg Net
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("CameraService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

function CameraService:Init() end

-- Define a visão do Killer
function CameraService:SetKillerView()
	for _, player in Players:GetPlayers() do
		if player:GetAttribute("IS_KILLER") then
			bridge:Fire(player, {
				[actionIdentifier] = "MoveToHouse",
			})
		end
	end
end

-- Define a visão de top View para todos as vitimas
function CameraService:SetAllVictimsToTopViewHouse()
	for _, player in Players:GetPlayers() do
		if player:GetAttribute("IN_HOUSE") and not player:GetAttribute("IS_KILLER") then
			bridge:Fire(player, {
				[actionIdentifier] = "MoveToHouse",
			})
		end
	end
end

function CameraService:SetAllPlayersToDoorView()
	for _, player in Players:GetPlayers() do
		bridge:Fire(player, {
			[actionIdentifier] = "MoveToDoorView",
		})
	end
end

function CameraService:SetAllPlayerToRoomView(roomNumber: number)
	for _, player in Players:GetPlayers() do
		if player:GetAttribute("IN_HOUSE") then
			bridge:Fire(player, {
				[actionIdentifier] = "MoveToRoomView",
				data = { 
					RoomNumber = roomNumber, 
				}
			})
		end
	end
end

-- Define a visão de top View para todos as vitimas
function CameraService:ResetAllPlayersInHouse()
	for _, player in Players:GetPlayers() do
		if player:GetAttribute("IN_HOUSE") then
			bridge:Fire(player, {
				[actionIdentifier] = "Reset",
			})
		end
	end
end

function CameraService:ResetInHouseFromPlayer(player: Player)
	if player:GetAttribute("IN_HOUSE") then
		bridge:Fire(player, {
			[actionIdentifier] = "Reset",
		})
	end
end

return CameraService
