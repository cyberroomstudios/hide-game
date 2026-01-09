local MoneyService = {}
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerDataHandler = require(ServerScriptService.Modules.PlayerDataHandler)

function MoneyService:Init()
    
end

function MoneyService:GiveMoney(player: Player, amount : number)
    -- TODO EXEMPLOS
    
    -- Obtem um valor do banco
    local money = PlayerDataHandler:Get(player, "money")

    -- Atualiza um valor no banco
    PlayerDataHandler:Update(player, "money", function(current)
        return current + amount
    end)

    -- Sobreescreve um valor no banco
    PlayerDataHandler:Set(player, "money", 0)
end

return MoneyService