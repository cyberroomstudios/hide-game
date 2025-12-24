local RouletteController = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local KillerHudController = require(Players.LocalPlayer.PlayerScripts.ClientModules.KillerHudController)
local CameraController = require(Players.LocalPlayer.PlayerScripts.ClientModules.CameraController)

local screen
local listFrame
local scrollingFrame
local template
local layout

local victimTextLabel
local killerTextLabel

local SPINS = 4
local ITEM_SCALE_Y = 0.25

function RouletteController:Init()
	RouletteController:CreateReferences()
end

function RouletteController:CreateReferences()
	screen = UIReferences:GetReference("ROULETTE_SCREEN")
	scrollingFrame = UIReferences:GetReference("SCROLLING_FRAME_ROULETTE")
	template = scrollingFrame:WaitForChild("ItemTemplate")
	layout = scrollingFrame:WaitForChild("UIListLayout")
	victimTextLabel = screen.YouAreAVictim
	killerTextLabel = screen.YouAreAKiller
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

local ITEMS = { "Victim", "Killer" }
local REPEAT_COUNT = 25
local SPIN_TIME = 2.5

local function clearAll()
	for _, v in scrollingFrame:GetChildren() do
		if v:IsA("TextLabel") and v ~= template then
			v:Destroy()
		end
	end
end

local function createItem(text)
	local label = template:Clone()
	label.Visible = true
	label.Text = text
	label.Parent = scrollingFrame
	return label
end

local function showFinalResult(resultText)
	clearAll()

	scrollingFrame.CanvasPosition = Vector2.zero
	scrollingFrame.ScrollingEnabled = false

	local label = createItem(resultText)

	-- Centraliza visualmente
	label.TextColor3 = Color3.new(85 / 255, 255 / 255, 0 / 255)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(0.5, 0.5)
	label.Size = UDim2.fromScale(0.9, 0.6)
end

local function spin(finalResult)
	scrollingFrame.Visible = true
	victimTextLabel.Visible = false
	killerTextLabel.Visible = false

	scrollingFrame.ScrollingEnabled = true
	clearAll()

	local finalLabel

	for i = 1, REPEAT_COUNT do
		createItem(ITEMS[math.random(#ITEMS)])
	end

	finalLabel = createItem(finalResult)

	RunService.Heartbeat:Wait()
	RunService.Heartbeat:Wait()

	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)

	scrollingFrame.CanvasPosition = Vector2.zero

	local windowCenter = scrollingFrame.AbsoluteWindowSize.Y / 2
	local labelCenter = finalLabel.AbsolutePosition.Y
		- scrollingFrame.AbsolutePosition.Y
		+ finalLabel.AbsoluteSize.Y / 2

	local targetY = labelCenter - windowCenter

	local tween = TweenService:Create(
		scrollingFrame,
		TweenInfo.new(SPIN_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ CanvasPosition = Vector2.new(0, targetY) }
	)

	tween:Play()

	tween.Completed:Once(function()
		scrollingFrame.Visible = false
		if finalResult == "killer" then
			killerTextLabel.Visible = true
			task.wait(2)
			CameraController:MoveToHouse()
			killerTextLabel.Visible = false
		end

		if finalResult == "Victim" then
			victimTextLabel.Visible = true
			task.wait(2)
		victimTextLabel.Visible = false
		end
	end)
end

function RouletteController:Start()
	local isKiller = player:GetAttribute("IS_KILLER") == true
	local finalResult = isKiller and "Killer" or "Victim"

	spin(finalResult)
end

return RouletteController
