local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)

local UIManager = {}

local labels = {}
local screens = {}
local loadedModules = false

function UIManager:Init()
	UIManager:CreateReferences()
	UIManager:InitAttributeListener()
end

function UIManager:CreateReferences()
	labels["WAIT_START_GAME"] = UIReferences:GetReference("WAIT_START_GAME")
	labels["HIDE_MESSAGE"] = UIReferences:GetReference("HIDE_MESSAGE")
	labels["KILLER_IN_PROGRESS"] = UIReferences:GetReference("KILLER_IN_PROGRESS")
end

function UIManager:LoadModules()
	if not loadedModules then
		loadedModules = true
		local clientModules = Players.LocalPlayer.PlayerScripts.ClientModules
		local RouletteController = require(clientModules.RouletteController)

		screens = {
			["ROULETTE"] = RouletteController,
		}
	end
end

function UIManager:Open(screenName: string)
	UIManager:LoadModules()
	for _, screen in screens do
		screen:Close()
	end

	for _, value in labels do
		value.Visible = false
	end

	screens[screenName]:Open()
end

function UIManager:Close(screenName: string)
	if screenName and screens[screenName] then
		screens[screenName]:Close()
	end
end

function UIManager:OpenLabel(labelName: string)
	for _, value in labels do
		value.Visible = false
	end

	for _, screen in screens do
		screen:Close()
	end

	labels[labelName].Visible = true
end

function UIManager:ShowWaitInitGame()
	UIManager:OpenLabel("WAIT_START_GAME")
	task.spawn(function()
		while workspace:GetAttribute("GAME_STEP") == "WAIT_INIT_GAME" do
			labels["WAIT_START_GAME"].Text = "The Game Will Start In " .. workspace:GetAttribute("TIME_FOR_INIT_GAME")
			task.wait()
		end
	end)
end

function UIManager:ShowHideMessage()
	UIManager:OpenLabel("HIDE_MESSAGE")
	task.spawn(function()
		while workspace:GetAttribute("GAME_STEP") == "PLAYERS_HIDING" do
			local leftTime = workspace:GetAttribute("TIME_FOR_HIDE") or 10
			labels["HIDE_MESSAGE"].Text = "Hide! (" .. tostring(leftTime) .. ")"
			task.wait()
		end
	end)
end

function UIManager:ShowKillerInProgressMessage()
	UIManager:OpenLabel("KILLER_IN_PROGRESS")
end

function UIManager:InitAttributeListener()
	workspace:GetAttributeChangedSignal("GAME_STEP"):Connect(function()
		UIManager:VerifyGameStep()
	end)
end

function UIManager:VerifyGameStep()
	local gameStep = workspace:GetAttribute("GAME_STEP")
	print(gameStep)
	if gameStep == "WAIT_INIT_GAME" then
		UIManager:ShowWaitInitGame()
	end

	if gameStep == "DRAWING_THE_KILLER" then
		UIManager:Open("ROULETTE")
	end

	if gameStep == "PLAYERS_HIDING" then
		UIManager:ShowHideMessage()
	end

	if gameStep == "KILLER_IN_PROGRESS" then
		UIManager:ShowKillerInProgressMessage()
	end
end
return UIManager
