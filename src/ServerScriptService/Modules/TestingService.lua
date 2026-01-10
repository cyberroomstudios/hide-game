local GameLoopService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local ReplionServer = require(Packages.Replion).Server


function GameLoopService:Init()
    task.spawn(function()
        while task.wait(1) do
            for _ , player in pairs(game.Players:GetPlayers()) do
                local PlayerReplion = ReplionServer:WaitReplionFor(player, "PlayerData", 10)
                if not PlayerReplion then
                    continue
                end
                PlayerReplion:Increase("money", 10)
            end
        end
    end)
end
return GameLoopService