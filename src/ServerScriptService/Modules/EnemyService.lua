local replicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local hiddenPoints = workspace:WaitForChild("HIddenPoints")

local EnemyService = {}

-- Variável para ativar/desativar visualização do path
local SHOW_PATH_DEBUG = true

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

function EnemyService:SpawnEnemy()
    local killer = replicatedStorage:FindFirstChild("Killer"):Clone()
    killer.Parent = workspace
    killer.PrimaryPart:SetNetworkOwner(nil)
    task.spawn(function()
        while killer.Parent do
            local randomPoint = hiddenPoints:GetChildren()[math.random(1, #hiddenPoints:GetChildren())]
            local targetPosition = randomPoint.Position 
            
            moveToTarget(killer, targetPosition)
            
            
        end
    end)
end

function EnemyService:Init()
    print("Enemy Service Initialized")
    self:SpawnEnemy()
end


return EnemyService