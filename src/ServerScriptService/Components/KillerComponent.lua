-- ===========================================================================
-- Roblox Services
-- ===========================================================================
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
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
local hiddenPoints = workspace:WaitForChild("HiddenPoints")

-- Variável para ativar/desativar visualização do path
local SHOW_PATH_DEBUG = true


-- ===========================================================================
-- Components
-- ===========================================================================
local KillerComponent = Component.new({
	Tag = "Killer",
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


local function visualizeWaypoint(position, index)
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.BrickColor = BrickColor.new("Lime green")
    part.Material = Enum.Material.Neon
    part.Transparency = 0.5
    part.Parent = workspace.Waypoints
    
end

local function moveToTarget(enemy, targetPosition)
    local humanoid = enemy:FindFirstChild("Humanoid")
    local rootPart = enemy:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Criar caminho
    local path = PathfindingService:CreatePath({
        AgentRadius = 3,
        AgentHeight = 6,
        AgentCanJump = false})
    path:ComputeAsync(rootPart.Position, targetPosition)
    
    -- Se o caminho foi calculado com sucesso
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        
        -- Visualizar waypoints se ativado
        if SHOW_PATH_DEBUG then
            workspace.Waypoints:ClearAllChildren()
            for i, waypoint in waypoints do
                visualizeWaypoint(waypoint.Position, i)
            end
        end
        
        -- Seguir cada waypoint
        for _, waypoint in waypoints do
            humanoid:MoveTo(waypoint.Position)
            humanoid.MoveToFinished:Wait()
        end
    end
end


function KillerComponent:LoadAnimations()
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

function KillerComponent:PlayAnimation(stateName)
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
function KillerComponent:Construct()
	self.Trove = Trove.new()
	self.Trove:AttachToInstance(self.Instance)

end

--[[
    Start is called when the component is started.
    At this point in time, it is safe to grab other components also bound to the same instance.
]]
function KillerComponent:Start()
	local instance = self.Instance
	instance:SetAttribute("State", "Idle")
	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")

	if not humanoid or not humanoidRootPart then
		warn("Monster requires a Humanoid and HumanoidRootPart:", instance.Name)
		return
	end

	self.Humanoid = humanoid
	self.HumanoidRootPart = humanoidRootPart

	-- Carrega as animações
	self:LoadAnimations()

	-- Loop de atualização para detectar e perseguir players
	self.Trove:Add(task.spawn(function()

        while instance.Parent do
            local randomPoint = hiddenPoints:GetChildren()[math.random(1, #hiddenPoints:GetChildren())]
            local targetPosition = randomPoint.Position 
            
            moveToTarget(instance, targetPosition)
            
            
        end
	end))

	self.Trove:Add(instance:GetAttributeChangedSignal("State"):Connect(function()
		local state = instance:GetAttribute("State")
		self:PlayAnimation(state)
	end))

	self:PlayAnimation("Idle")
end

--[[
    Stop is called when the component is stopped.
    This is called when the bound instance is removed from the whitelisted ancestors or when the tag is removed from the instance.
]]
function KillerComponent:Stop()
	self.Trove:Destroy()
end

return KillerComponent
