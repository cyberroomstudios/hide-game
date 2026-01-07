local PlayerService = {}

local Players = game:GetService("Players")

function PlayerService:Init()
    PlayerService:Start()
end

function PlayerService:Start()

    local function setCollisionGroup(character)
        for _, part in pairs (character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CollisionGroup = "Players"
            end
        end
        character.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then
                part.CollisionGroup = "Players"
            end
        end)
    end

    local function onCharacterAdded(character)
        setCollisionGroup(character)
    end



    local function onPlayerAdded(player)
        player.CharacterAdded:Connect(onCharacterAdded)
        local character = player.Character or player.CharacterAdded:Wait()
        onCharacterAdded(character)
    end


    Players.PlayerRemoving:Connect(function(player)
        print("Player left: " .. player.Name)
    end)

    Players.PlayerAdded:Connect(onPlayerAdded)
    for _ , player in pairs (Players:GetPlayers()) do
        onPlayerAdded(player)
    end
end

return PlayerService