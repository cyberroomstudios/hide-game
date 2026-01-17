local HouseController = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ClientUtil = require(Players.LocalPlayer.PlayerScripts.ClientModules.ClientUtil)
local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)

local ORIGINAL_TRANSPARENCY = 0.85

local buttons = {}
local rooms = {}

local waitForPlayersHideTextLabel
function HouseController:Init()
	HouseController:CreateReferences()
	HouseController:ConfigureButtonListeners()
	HouseController:HideRoomUI()
end

function HouseController:CreateReferences()
	buttons["bedroom1"] = UIReferences:GetReference("HOUSE_BUTTON_BEDROOM1")
	buttons["bedroom2"] = UIReferences:GetReference("HOUSE_BUTTON_BEDROOM2")
	buttons["bathroom1"] = UIReferences:GetReference("HOUSE_BUTTON_BATHROOM1")
	buttons["bathroom2"] = UIReferences:GetReference("HOUSE_BUTTON_BATHROOM2")
	buttons["closet1"] = UIReferences:GetReference("HOUSE_BUTTON_CLOSET1")
	buttons["closet2"] = UIReferences:GetReference("HOUSE_BUTTON_CLOSET2")
	buttons["kitchen"] = UIReferences:GetReference("HOUSE_BUTTON_KITCHEN")
	buttons["laundry"] = UIReferences:GetReference("HOUSE_BUTTON_LAUNDRY")
	buttons["livingRoom"] = UIReferences:GetReference("HOUSE_BUTTON_LIVING_ROOM")
	buttons["storage"] = UIReferences:GetReference("HOUSE_BUTTON_STORAGE")

	local roomUI = ClientUtil:WaitForDescendants(workspace, "Map", "House", "RoomUI")
	rooms["bedroom1"] = ClientUtil:WaitForDescendants(roomUI, "bedroom1")
	rooms["bedroom2"] = ClientUtil:WaitForDescendants(roomUI, "bedroom2")
	rooms["bathroom1"] = ClientUtil:WaitForDescendants(roomUI, "bathroom1")
	rooms["bathroom2"] = ClientUtil:WaitForDescendants(roomUI, "bathroom2")
	rooms["closet1"] = ClientUtil:WaitForDescendants(roomUI, "closet1")
	rooms["closet2"] = ClientUtil:WaitForDescendants(roomUI, "closet2")
	rooms["kitchen"] = ClientUtil:WaitForDescendants(roomUI, "kitchen")
	rooms["laundry"] = ClientUtil:WaitForDescendants(roomUI, "laundry")
	rooms["livingRoom"] = ClientUtil:WaitForDescendants(roomUI, "livingRoom")
	rooms["storage"] = ClientUtil:WaitForDescendants(roomUI, "storage")

	waitForPlayersHideTextLabel = UIReferences:GetReference("WAIT_FOR_THE_PLAYERS_TO_HIDE")
end

function HouseController:ConfigureButtonListeners()
	for name, button in pairs(buttons) do
		button.MouseButton1Click:Connect(function()
			if workspace:GetAttribute("GAME_STEP") ~= "KILLER_IN_PROGRESS" then
				waitForPlayersHideTextLabel.Visible = true
				task.delay(1, function()
					waitForPlayersHideTextLabel.Visible = false
				end)
				return
			end
			rooms[name].Color = ClientUtil:Color3(255, 0, 0)
		end)
	end
end

function HouseController:HideRoomUI()
	for name, room in rooms do
		room.Transparency = 1
		local surfaceGUI = ClientUtil:WaitForDescendants(room, "Part", "SurfaceGui")
		surfaceGUI.Enabled = false
	end
end

function HouseController:ShowRoomUI()
	for name, room in rooms do
		room.Transparency = ORIGINAL_TRANSPARENCY
		local surfaceGUI = ClientUtil:WaitForDescendants(room, "Part", "SurfaceGui")
		surfaceGUI.Enabled = true
	end
end

return HouseController
