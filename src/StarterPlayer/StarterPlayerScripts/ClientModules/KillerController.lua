local KillerController = {}
local Players = game:GetService("Players")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local TeleportController = require(Players.LocalPlayer.PlayerScripts.ClientModules.TeleportController)
local CameraController = require(Players.LocalPlayer.PlayerScripts.ClientModules.CameraController)
local PlayerController = require(Players.LocalPlayer.PlayerScripts.ClientModules.PlayerController)
local HouseController = require(Players.LocalPlayer.PlayerScripts.ClientModules.HouseController)

local chooseRoom
local changeCamera = true

function KillerController:Init()
	KillerController:CreateReferences()
	KillerController:InitAttributeListener()
end

function KillerController:CreateReferences()
	chooseRoom = UIReferences:GetReference("CHOOSE_ROOM")
end

function KillerController:ShowChosseRoomTextLabel()
	chooseRoom.Visible = true
end

function KillerController:HIdeChosseRoomTextLabel()
	chooseRoom.Visible = false
end

function KillerController:Start()
	TeleportController:ToKillerSpawn()
	CameraController:MoveToHouse()
	PlayerController:LockMovement()
	HouseController:HideRoomUI()
end

function KillerController:InitAttributeListener()
	workspace:GetAttributeChangedSignal("TIME_TO_CHOOSE_ROOM_BY_KILLER"):Connect(function()
		local timeToChoose = workspace:GetAttribute("TIME_TO_CHOOSE_ROOM_BY_KILLER")

		if timeToChoose == 0 then
			KillerController:HIdeChosseRoomTextLabel()
			changeCamera = false
		else
			if not changeCamera then
				changeCamera = true
				CameraController:MoveToHouse()
			end

			KillerController:ShowChosseRoomTextLabel()
			chooseRoom.Text = "CHOOSE A HOUSE ROOM TO GO TO (" .. timeToChoose .. ")"
		end
	end)
end

return KillerController
