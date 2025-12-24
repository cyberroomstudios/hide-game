local GamePathFindingService = {}

local PathfindingService = game:GetService("PathfindingService")

local killedPoints = workspace:WaitForChild("KilledPoints")

-- Variável para ativar/desativar visualização do path
local SHOW_PATH_DEBUG = false

function GamePathFindingService:Init()
    
end

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

function GamePathFindingService:MoveToTarget(npc, targetPoint)
	local targetPosition = targetPoint.Position
	local humanoid = npc:FindFirstChild("Humanoid")
	local rootPart = npc:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then
		return
	end

	-- Criar caminho
	local path = PathfindingService:CreatePath({
		AgentRadius = 3,
		AgentHeight = 6,
		AgentCanJump = false,
	})
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
		targetPoint.Color = Color3.fromRGB(255, 0, 0)
		targetPoint.Parent = killedPoints

		for _ , imageLabel in pairs(targetPoint:GetDescendants()) do
			if imageLabel:IsA("ImageLabel") then
				if imageLabel.Name == "ImageTemplate" then
					imageLabel.ImageColor3 = Color3.fromRGB(85, 85, 85)
				end
				if imageLabel.Name == "Dead" then
					imageLabel.Visible = true
				end
			end
		end
	end
end


return GamePathFindingService