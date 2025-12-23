local KillerHudController = {}

-- Init Bridg Net
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("KillerService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

local Players = game:GetService("Players")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)

local screen

function KillerHudController:Init()
	KillerHudController:CreateReferences()
	KillerHudController:InitButtonListerns()
end

function KillerHudController:CreateReferences()
	screen = UIReferences:GetReference("KILLER_HUD")
end

function KillerHudController:Open(data)
	screen.Visible = true
end

function KillerHudController:Close()
	screen.Visible = false
end

function KillerHudController:GetScreen()
	return screen
end

function KillerHudController:InitButtonListerns()
	local buttons = screen:WaitForChild("Buttons")

	for _, value in buttons:GetChildren() do
		if value:IsA("TextButton") then
			value.MouseButton1Click:Connect(function()
				local roomNumber = value:GetAttribute("ROOM_NUMBER")

				local result = bridge:InvokeServerAsync({
					[actionIdentifier] = "GoToRoom",
					data = {
						RoomNumber = roomNumber,
					},
				})
			end)
		end
	end
end

return KillerHudController
