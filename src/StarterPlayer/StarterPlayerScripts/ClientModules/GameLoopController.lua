local GameLoopController = {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local HudController = require(Players.LocalPlayer.PlayerScripts.ClientModules.HudController)
local TeleportController = require(Players.LocalPlayer.PlayerScripts.ClientModules.TeleportController)
local CameraController = require(Players.LocalPlayer.PlayerScripts.ClientModules.CameraController)
local PlayerController = require(Players.LocalPlayer.PlayerScripts.ClientModules.PlayerController)
local HouseController = require(Players.LocalPlayer.PlayerScripts.ClientModules.HouseController)

local labels = {}
local screens = {}

local loadedModules = false
local player = Players.LocalPlayer

function GameLoopController:Init()
	GameLoopController:CreateReferences()
	GameLoopController:InitAttributeListener()
end

function GameLoopController:CreateReferences()
	labels["WAIT_START_GAME"] = UIReferences:GetReference("WAIT_START_GAME")
	labels["HIDE_MESSAGE"] = UIReferences:GetReference("HIDE_MESSAGE")

	labels["KILLER_IN_PROGRESS"] = UIReferences:GetReference("KILLER_IN_PROGRESS")
end

function GameLoopController:LoadModules()
	if not loadedModules then
		loadedModules = true
		local clientModules = Players.LocalPlayer.PlayerScripts.ClientModules
		local RouletteController = require(clientModules.RouletteController)

		screens = {
			["ROULETTE"] = RouletteController,
		}
	end
end

function GameLoopController:Open(screenName: string)
	GameLoopController:LoadModules()
	for _, screen in screens do
		screen:Close()
	end

	for _, value in labels do
		value.Visible = false
	end

	screens[screenName]:Open()
end

function GameLoopController:Close(screenName: string)
	if screenName and screens[screenName] then
		screens[screenName]:Close()
	end
end

function GameLoopController:OpenLabel(labelName: string)
	for _, value in labels do
		value.Visible = false
	end

	for _, screen in screens do
		screen:Close()
	end

	labels[labelName].Visible = true
end

function GameLoopController:CloseAllLabels()
	for _, value in labels do
		value.Visible = false
	end
end

function GameLoopController:ShowWaitInitGame()
	GameLoopController:OpenLabel("WAIT_START_GAME")
	task.spawn(function()
		while workspace:GetAttribute("GAME_STEP") == "WAIT_INIT_GAME" do
			labels["WAIT_START_GAME"].Text = "The Game Will Start In " .. workspace:GetAttribute("TIME_FOR_INIT_GAME")
			task.wait()
		end
	end)
end

function GameLoopController:ShowHideMessage()
	GameLoopController:OpenLabel("HIDE_MESSAGE")
	task.spawn(function()
		local hideLabel = labels["HIDE_MESSAGE"]

		while workspace:GetAttribute("GAME_STEP") == "PLAYERS_HIDING" do
			local leftTime = workspace:GetAttribute("TIME_FOR_HIDE") or 10
			local isKiller = player:GetAttribute("IS_KILLER")

			hideLabel.Text = isKiller and ("Waiting for the players to hide! (" .. leftTime .. ")")
				or ("Hide! (" .. leftTime .. ")")

			task.wait(1)
		end
	end)
end

function GameLoopController:ShowHideMessageWhenKiller()
	GameLoopController:OpenLabel("HIDE_MESSAGE")
	task.spawn(function()
		local hideLabel = labels["HIDE_MESSAGE"]

		while workspace:GetAttribute("GAME_STEP") == "PLAYERS_HIDING" do
			local leftTime = workspace:GetAttribute("TIME_FOR_HIDE") or 10
			local isKiller = player:GetAttribute("IS_KILLER")

			hideLabel.Text = isKiller and ("Waiting for the players to hide! (" .. leftTime .. ")")
				or ("Hide! (" .. leftTime .. ")")

			task.wait(1)
		end
	end)
end

function GameLoopController:ShowKillerInProgressMessage()
	GameLoopController:OpenLabel("KILLER_IN_PROGRESS")
end

function GameLoopController:InitAttributeListener()
	workspace:GetAttributeChangedSignal("GAME_STEP"):Connect(function()
		GameLoopController:VerifyGameStep()
	end)
end

function GameLoopController:VerifyGameStep()
	local gameStep = workspace:GetAttribute("GAME_STEP")

	if gameStep == "WAIT_INIT_GAME" then
		HudController:ShowDefaultHud()

		GameLoopController:ShowWaitInitGame()
	end

	if gameStep == "DRAWING_THE_KILLER" then
		GameLoopController:Open("ROULETTE")
	end

	if gameStep == "PLAYERS_HIDING" then
		-- Se for o killer:
		-- 1° Tem que teleportar ele para fora da casa
		-- 2° Muda a visão dele para o topo da casa
		-- 3° Bloqueia os movimentos
		-- 4º Ativa os botões da casa

		if player:GetAttribute("IS_KILLER") then
			TeleportController:ToKillerSpawn()
			CameraController:MoveToHouse()
			PlayerController:LockMovement()
			HouseController:ShowRoomUI()
		end

		GameLoopController:ShowHideMessage()
	end

	if gameStep == "KILLER_IN_PROGRESS" then
		HudController:HideDefaultHud()

		if player:GetAttribute("IS_KILLER") then
			GameLoopController:CloseAllLabels()
		else
			GameLoopController:ShowKillerInProgressMessage()
		end
	end
end

return GameLoopController
