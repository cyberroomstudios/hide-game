local DeveloperProducts = {}

export type DeveloperProduct = {
	Name: string,
	Id: number,
}

DeveloperProducts.ENUM = {
	BE_THE_KILLER = {
		Name = "BE_THE_KILLER",
		Id = 3488492985,
	},
}

function DeveloperProducts:GetEnum(name: string): DeveloperProduct
	return self.ENUM[name]
end

return DeveloperProducts
