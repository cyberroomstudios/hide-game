local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataHandler = require(ServerScriptService.Modules.PlayerDataHandler)

return function(context, players)
	for _, player in players do
        PlayerDataHandler:Wipe(player)
    end

	return "Success!"
end
