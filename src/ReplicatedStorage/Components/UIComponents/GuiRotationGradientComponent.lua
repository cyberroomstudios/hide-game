-- ===========================================================================
-- Roblox Services
-- ===========================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- ===========================================================================
-- Dependencies
-- ===========================================================================
local Packages = ReplicatedStorage.Packages
local Component = require(Packages.Component)
local Trove = require(Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ===========================================================================
-- Variables
-- ===========================================================================

-- ===========================================================================
-- Components
-- ===========================================================================
local GuiRotationGradientComponent = Component.new({
    Tag = "RotationGradient",
    Ancestors = {
        PlayerGui,
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
function GuiRotationGradientComponent:Construct()
    
    self.Trove = Trove.new()
    self.Trove:AttachToInstance(self.Instance)
end

--[[
    Start is called when the component is started.
    At this point in time, it is safe to grab other components also bound to the same instance.
]]
function GuiRotationGradientComponent:Start()
    
    local instance = self.Instance
    while true do
        instance.Rotation = instance.Rotation + 1
        task.wait(0.01)
    end
end

--[[
    Stop is called when the component is stopped.
    This is called when the bound instance is removed from the whitelisted ancestors or when the tag is removed from the instance.
]]
function GuiRotationGradientComponent:Stop()
    self.Trove:Destroy()
end

return GuiRotationGradientComponent