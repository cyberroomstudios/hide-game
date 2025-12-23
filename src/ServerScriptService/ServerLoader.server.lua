local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Utility = ReplicatedStorage.Utility
local Loader = require(Utility.Loader)

-- Server Utility
local PlayerDataHandler = require(ServerScriptService.Modules.PlayerDataHandler)

local Middleware = {}

local BridgeNet2 = require(ReplicatedStorage.Utility.BridgeNet2)

local Content = {
	{ "Component", ServerScriptService.Components, "AfterKnit" },
}


PlayerDataHandler:Init()

local function initializerBridge()
	local bridge = BridgeNet2.ReferenceBridge("Level")
end

initializerBridge()

local folder = ServerScriptService.Modules

for _, module in folder:GetChildren() do
	print("Initializing module:", module.Name)
	if module.Name == "PlayerDataHandler" then
		continue
	end

	local file = require(module)

	-- If the module has an Init function, call it
	if file.Init then
		file:Init()
	end
end

Loader(Content, Middleware):andThen(function()
	workspace:SetAttribute("ServerLoaded", true)
end)