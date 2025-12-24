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

-- ===========================================================================
-- Variables
-- ===========================================================================


-- ===========================================================================
-- Components
-- ===========================================================================
local NPCComponent = Component.new({
	Tag = "NPC",
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


function NPCComponent:LoadAnimations()
	local animator = self.Humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = self.Humanoid
	end
	local animFolder = self.Instance:FindFirstChild("Animations")
	if not animFolder then
		warn("No Animations folder found in Monster:", self.Instance.Name)
		return
	end

	-- Carrega cada animação encontrada
	for _, animObject in ipairs(animFolder:GetChildren()) do
		if animObject:IsA("Animation") then
			local track = animator:LoadAnimation(animObject)
			self.AnimationTracks[animObject.Name] = track
		end
	end
end

function NPCComponent:PlayAnimation(stateName)
	local track = self.AnimationTracks[stateName]

	if not track then
		return
	end

	-- Para a animação atual se existir
	if self.CurrentAnimationTrack and self.CurrentAnimationTrack.IsPlaying then
		self.CurrentAnimationTrack:Stop()
	end

	-- Toca a nova animação
	track:Play()
	self.CurrentAnimationTrack = track
end


-- ===========================================================================
-- Component Initialization
-- ===========================================================================
--[[
    Construct is called before the component is started.
    It should be used to construct the component instance.
]]
function NPCComponent:Construct()
	self.Trove = Trove.new()
	self.Trove:AttachToInstance(self.Instance)

	self.Humanoid = self.Instance:FindFirstChildOfClass("Humanoid")

	-- Animações
	self.AnimationTracks = {}
	self.CurrentAnimationTrack = nil

	
end

--[[
    Start is called when the component is started.
    At this point in time, it is safe to grab other components also bound to the same instance.
]]
function NPCComponent:Start()
	local instance = self.Instance



	-- Carrega as animações
	self:LoadAnimations()


	self.Trove:Add(instance:GetAttributeChangedSignal("State"):Connect(function()
		local state = instance:GetAttribute("State")
		self:PlayAnimation(state)
	end))
	instance:SetAttribute("State", "Idle")
	self:PlayAnimation("Idle")
end

--[[
    Stop is called when the component is stopped.
    This is called when the bound instance is removed from the whitelisted ancestors or when the tag is removed from the instance.
]]
function NPCComponent:Stop()
	self.Trove:Destroy()
end

return NPCComponent
