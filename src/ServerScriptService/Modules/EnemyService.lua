local replicatedStorage = game:GetService("ReplicatedStorage")

local EnemyService = {}


function EnemyService:SpawnEnemy()
    local killer = replicatedStorage:FindFirstChild("Enemy"):Clone()
    killer.Parent = workspace
    task.spawn(function()
        while killer.Parent do
            killer.Humanoid:MoveTo(workspace.PlayerSpawn.Position + Vector3.new(math.random(-10,10),0,math.random(-10,10)))
            task.wait(1)
        end
    end)
end

function EnemyService:Init()
    print("Enemy Service Initialized")
    self:SpawnEnemy()
end


return EnemyService