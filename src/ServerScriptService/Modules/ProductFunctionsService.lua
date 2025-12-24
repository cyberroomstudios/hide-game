local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProductFunctionsServices = {}
local DeveloperProducts = require(ReplicatedStorage.Enums.DeveloperProducts)

ProductFunctionsServices[DeveloperProducts:GetEnum("BE_THE_KILLER").Id] = function(receipt, player)
	print("Comprou")
	return true
end

return ProductFunctionsServices
