local HouseController = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ClientUtil = require(Players.LocalPlayer.PlayerScripts.ClientModules.ClientUtil)

local buttons = {}

function HouseController:Init() end

function HouseController:Configure()
	buttons["bedroom1"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "bedroom1")
	buttons["bedroom2"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "bedroom2")
	buttons["closet1"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "closet1")
	buttons["closet2"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "closet2")
	buttons["kitchen"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "kitchen")
	buttons["laundry"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "laundry")
	buttons["livingRoom"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "livingRoom")
	buttons["storage"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "storage")
	buttons["bathroom2"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "bathroom2")
	buttons["bathroom1"] = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI", "bathroom1")

	print("Configurado")
end

return HouseController
