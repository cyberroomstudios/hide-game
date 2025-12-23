-- ===========================================================================
-- Roblox Services
-- ===========================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
-- ===========================================================================
-- Dependencies
-- ===========================================================================
local Packages = ReplicatedStorage.Packages
local Component = require(Packages.Component)
local Trove = require(Packages.Trove)

print("Door Component Started")
-- ===========================================================================
-- Variables
-- ===========================================================================

local TweenInfoOpen = TweenInfo.new(
    1, -- Tempo de duração
    Enum.EasingStyle.Sine, -- Estilo de easing
    Enum.EasingDirection.Out -- Direção do easing
)

-- ===========================================================================
-- Components
-- ===========================================================================
local DoorComponent = Component.new({
	Tag = "DoorComponent",
	Ancestors = {
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
function DoorComponent:Construct()
	self.Trove = Trove.new()
	self.Trove:AttachToInstance(self.Instance)

end

--[[
    Start is called when the component is started.
    At this point in time, it is safe to grab other components also bound to the same instance.
]]
function DoorComponent:Start()
	local instance = self.Instance
    local hitbox = instance:FindFirstChild("Hitbox")
    local hinge = instance:FindFirstChild("Hinge")
    local tween
    local debounce = false
    if hitbox then
        self.Trove:Add(hitbox.Touched:Connect(function(otherPart)
            local character = otherPart.Parent
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if debounce then return end
                debounce = true
                tween = TweenService:Create(hinge, TweenInfoOpen, {CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(90), 0)})
                tween:Play()
                tween.Completed:Wait()
                task.wait(2) -- Tempo que a porta fica aberta
                tween = TweenService:Create(hinge, TweenInfoOpen, {CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(-90), 0)})
                tween:Play()
                tween.Completed:Wait()
                debounce = false
            end
        end))
    end
end

--[[
    Stop is called when the component is stopped.
    This is called when the bound instance is removed from the whitelisted ancestors or when the tag is removed from the instance.
]]
function DoorComponent:Stop()
	self.Trove:Destroy()
end

return DoorComponent
