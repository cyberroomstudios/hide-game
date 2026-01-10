local DataController = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Replion = require(Packages.Replion)
local ReplionClient = Replion.Client
local PlayerData = ReplionClient:WaitReplion("PlayerData")

function DataController:Init()
    PlayerData:OnChange("money", function(newMoney)
        print("Seu dinheiro agora é: " .. newMoney)
    end)
end

return DataController