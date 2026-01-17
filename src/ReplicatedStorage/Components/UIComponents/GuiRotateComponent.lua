-- ===========================================================================
-- Roblox Services
-- ===========================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ===========================================================================
-- Dependencies
-- ===========================================================================
local Packages = ReplicatedStorage.Packages
local Component = require(Packages.Component)
local Trove = require(Packages.Trove)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 5)
-- ===========================================================================
-- Variables
-- ===========================================================================

-- ===========================================================================
-- Components
-- ===========================================================================
local GuiRotateComponent = Component.new({
	Tag = "GuiRotate",
	Ancestors = {
		PlayerGui, workspace
	},
	Extensions = {},
})

-- ===========================================================================
-- Internal Methods
-- ===========================================================================

-- ===========================================================================
-- Public Methods
-- ===========================================================================

-- ===========================================================================
-- Component Initialization
-- ===========================================================================
--[[
    Construct is called before the component is started.
    It should be used to construct the component instance.
]]
function GuiRotateComponent:Construct()
	self.Trove = Trove.new()
	if self.Instance and self.Instance.Parent then
		self.Trove:AttachToInstance(self.Instance)
	end
end

--[[
    Start is called when the component is started.
    At this point in time, it is safe to grab other components also bound to the same instance.
]]
function GuiRotateComponent:Start()
	local instance = self.Instance
	local speed = instance:GetAttribute("Speed")
	local tweeninfo = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
	local tween = TweenService:Create(instance, tweeninfo, { Rotation = 360 })
	tween:Play()
end

--[[
    Stop is called when the component is stopped.
    This is called when the bound instance is removed from the whitelisted ancestors or when the tag is removed from the instance.
]]
function GuiRotateComponent:Stop()
	self.Trove:Destroy()
end

return GuiRotateComponent
