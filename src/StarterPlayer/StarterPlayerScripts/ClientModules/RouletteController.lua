local RouletteController = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local KillerHudController = require(Players.LocalPlayer.PlayerScripts.ClientModules.KillerHudController)
local CameraController = require(Players.LocalPlayer.PlayerScripts.ClientModules.CameraController)

local screen
local listFrame

local ITEM_HEIGHT = 50
local SPINS = 5

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
	-- Resultado baseado no atributo
	local isKiller = player:GetAttribute("IS_KILLER") == true
	local FINAL_TEXT = isKiller and "Killer" or "Victim"

	-- Limpa antes
	listFrame:ClearAllChildren()
	listFrame.Position = UDim2.new(0, 0, 0, 0)

	-- Itens fake para rolagem
	local items = { "Victim", "Killer" }

	for i = 1, (#items * SPINS) do
		local index = ((i - 1) % #items) + 1

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, ITEM_HEIGHT)
		label.Position = UDim2.new(0, 0, 0, (i - 1) * ITEM_HEIGHT)
		label.BackgroundTransparency = 1
		label.TextScaled = true
		label.Text = items[index]
		label.Parent = listFrame
	end

	listFrame.Size = UDim2.new(1, 0, 0, ITEM_HEIGHT * #items * SPINS)

	-- Calcula parada
	local resultIndex = table.find(items, FINAL_TEXT)
	local stopIndex = (SPINS - 1) * #items + (resultIndex - 1)
	local stopPosition = -(stopIndex * ITEM_HEIGHT)

	-- Tween
	local tweenInfo = TweenInfo.new(2.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	local tween = TweenService:Create(listFrame, tweenInfo, { Position = UDim2.new(0, 0, 0, stopPosition) })

	tween:Play()

	-- mostra só o item final
	tween.Completed:Once(function()
		listFrame:ClearAllChildren()
		listFrame.Size = UDim2.new(1, 0, 0, ITEM_HEIGHT)
		listFrame.Position = UDim2.new(0, 0, 0, 0)

		local finalLabel = Instance.new("TextLabel")
		finalLabel.Size = UDim2.new(1, 0, 1, 0)
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
