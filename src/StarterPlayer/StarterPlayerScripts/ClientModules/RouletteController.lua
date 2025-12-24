local RouletteController = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local KillerHudController = require(Players.LocalPlayer.PlayerScripts.ClientModules.KillerHudController)
local CameraController = require(Players.LocalPlayer.PlayerScripts.ClientModules.CameraController)

local screen
local listFrame

local SPINS = 4
local ITEM_SCALE_Y = 0.25

function RouletteController:Init()
	RouletteController:CreateReferences()
end

function RouletteController:CreateReferences()
	screen = UIReferences:GetReference("ROULETTE_SCREEN")
	listFrame = UIReferences:GetReference("ROULETTE_LIST_FRAME")
end

function RouletteController:Open(data)
	screen.Visible = true
	RouletteController:Start()
end

function RouletteController:Close()
	screen.Visible = false
end

function RouletteController:GetScreen()
	return screen
end

function RouletteController:Start()
	local isKiller = player:GetAttribute("IS_KILLER") == true
	local FINAL_TEXT = isKiller and "Killer" or "Victim"

	listFrame:ClearAllChildren()
	listFrame.Position = UDim2.fromScale(0, 0)

	local items = { "Victim", "Killer" }
	local totalItems = #items * SPINS

	for i = 1, totalItems do
		local index = ((i - 1) % #items) + 1
		local text = items[index]

		-- FORÇA O ÚLTIMO ITEM A SER O RESULTADO
		if i == totalItems then
			text = FINAL_TEXT
		end

		local label = Instance.new("TextLabel")
		label.FontFace = Font.new("rbxasset://fonts/families/AccanthisADFStd.json")
		label.Size = UDim2.fromScale(1, ITEM_SCALE_Y)
		label.Position = UDim2.fromScale(0, (i - 1) * ITEM_SCALE_Y)
		label.BackgroundTransparency = 1
		label.TextScaled = true
		label.Text = text
		label.Parent = listFrame
	end

	-- altura total da lista
	listFrame.Size = UDim2.fromScale(1, totalItems * ITEM_SCALE_Y)

	-- PARA SEMPRE NO ÚLTIMO ITEM
	local stopScaleY = -((totalItems - 1) * ITEM_SCALE_Y)

	local tween = TweenService:Create(
		listFrame,
		TweenInfo.new(2.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Position = UDim2.fromScale(0, stopScaleY) }
	)

	tween:Play()

	tween.Completed:Once(function()
		listFrame:ClearAllChildren()
		listFrame.Size = UDim2.fromScale(1, 1)
		listFrame.Position = UDim2.fromScale(0, 0)

		local finalLabel = Instance.new("TextLabel")
		finalLabel.FontFace = Font.new("rbxasset://fonts/families/AccanthisADFStd.json")
		finalLabel.Size = UDim2.fromScale(1, 1)
		finalLabel.BackgroundTransparency = 1
		finalLabel.TextScaled = true
		finalLabel.Text = FINAL_TEXT
		finalLabel.Parent = listFrame

		if isKiller then
			CameraController:MoveToHouse()
		end
	end)
end

return RouletteController
