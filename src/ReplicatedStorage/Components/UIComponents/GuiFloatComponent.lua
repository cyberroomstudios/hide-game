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
local GuiFloatComponent = Component.new({
	Tag = "GuiFloat",
	Ancestors = {
		PlayerGui,
		workspace,
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
function GuiFloatComponent:Construct()
	self.Trove = Trove.new()
	if self.Instance and self.Instance.Parent then
		self.Trove:AttachToInstance(self.Instance)
	end
end

--[[
    Start is called when the component is started.
    At this point in time, it is safe to grab other components also bound to the same instance.
]]
function GuiFloatComponent:Start()
	local instance = self.Instance
	local amplitude = 10 -- quanto o botão se move (em pixels)
	local duracao = 0.6 -- tempo para subir/ descer (em segundos)
	local basePos = instance.Position
	local posCima = UDim2.new(basePos.X.Scale, basePos.X.Offset, basePos.Y.Scale, basePos.Y.Offset - amplitude)
	local posBaixo = UDim2.new(basePos.X.Scale, basePos.X.Offset, basePos.Y.Scale, basePos.Y.Offset + amplitude)
	local tweenInfo = TweenInfo.new(duracao, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	task.spawn(function()
		while true do
			local t1 = TweenService:Create(instance, tweenInfo, { Position = posCima })
			t1:Play()
			t1.Completed:Wait()

			local t2 = TweenService:Create(instance, tweenInfo, { Position = posBaixo })
			t2:Play()
			t2.Completed:Wait()
		end
	end)
end

--[[
    Stop is called when the component is stopped.
    This is called when the bound instance is removed from the whitelisted ancestors or when the tag is removed from the instance.
]]
function GuiFloatComponent:Stop()
	self.Trove:Destroy()
end

return GuiFloatComponent
