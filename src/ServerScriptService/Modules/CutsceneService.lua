local CutsceneService = {}

-- Init Bridg Net
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("CutsceneService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

function CutsceneService:Init() end


function CutsceneService:PlayAnimation(killer: Player, roomName: string)
    warn("Playing cutscene animation for killer: " .. killer.Name .. " in room: " .. roomName)
	for _ , player in pairs(Players:GetPlayers()) do
        if player:GetAttribute("IN_HOUSE") then
            bridge:Fire(player, {
                [actionIdentifier] = "PlayCutscene",
                data = {
                    Killer = killer,
                    RoomName = roomName,
                }
            })
        end
    end
end

return CutsceneService
