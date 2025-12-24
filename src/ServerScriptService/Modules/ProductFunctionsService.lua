local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ProductFunctionsServices = {}
local DeveloperProducts = require(ReplicatedStorage.Enums.DeveloperProducts)
local QueueOfKillerPaidService = require(ServerScriptService.Modules.QueueOfKillerPaidService)

ProductFunctionsServices[DeveloperProducts:GetEnum("BE_THE_KILLER").Id] = function(receipt, player)
	QueueOfKillerPaidService:Add(player)
	return true
end

return ProductFunctionsServices
