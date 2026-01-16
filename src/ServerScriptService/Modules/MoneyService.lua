local MoneyService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Replion = require(Packages.Replion)
local ReplionServer = Replion.Server


function MoneyService:Init()
    
end

function MoneyService:GiveMoney(player: Player, amount : number)
    local PlayerData = ReplionServer:WaitReplionFor(player, "PlayerData", 10)
    if PlayerData then
        PlayerData:Increase("money", amount)
    end
end

function MoneyService:TakeMoney(player: Player, amount : number)
    local PlayerData = ReplionServer:WaitReplionFor(player, "PlayerData", 10)
    if PlayerData then
        PlayerData:Increase("money", -amount)
    end
end

function MoneyService:SetMoney(player: Player, amount : number)
    local PlayerData = ReplionServer:WaitReplionFor(player, "PlayerData", 10)
    if PlayerData then
        PlayerData:Set("money", amount)
    end
end

function MoneyService:GetMoney(player: Player) : number?
    local PlayerData = ReplionServer:WaitReplionFor(player, "PlayerData", 10)
    if PlayerData then
        return PlayerData:Get("money")
    end
    return nil
end

return MoneyService