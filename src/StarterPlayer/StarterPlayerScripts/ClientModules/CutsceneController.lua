local CutsceneController = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ClientUtil = require(Players.LocalPlayer.PlayerScripts.ClientModules.ClientUtil)
local camera = workspace.CurrentCamera

-- Init Bridg Net
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage.Utility
local BridgeNet2 = require(Utility.BridgeNet2)
local bridge = BridgeNet2.ReferenceBridge("CutsceneService")
local actionIdentifier = BridgeNet2.ReferenceIdentifier("action")
local statusIdentifier = BridgeNet2.ReferenceIdentifier("status")
local messageIdentifier = BridgeNet2.ReferenceIdentifier("message")
-- End Bridg Net

local Setups = workspace:WaitForChild("Cutscenes"):WaitForChild("Setups")

local Resources = ReplicatedStorage:WaitForChild("Resources")
local Victim = Resources:WaitForChild("Victim")
local Killer = Resources:WaitForChild("Killer")
local Door = Resources:WaitForChild("Door")

function CutsceneController:Init()
	CutsceneController:InitBridgeListener()
end

function CutsceneController:InitBridgeListener()
	bridge:Connect(function(response)
		if response[actionIdentifier] == "PlayCutscene" then
			CutsceneController:PlayCutscene(response.data.Killer, response.data.RoomName)
		end
	end)
end


-- Leva a camera do jogador para a visão de cima da casa
function CutsceneController:PlayCutscene(killer, roomName)
	local playerRoom = player:GetAttribute("ROOM_NUMBER")
    local playerInRoom = roomName == tostring(playerRoom)
    local setupFolder = Setups:FindFirstChild(roomName)
    if not setupFolder then
        warn("No cutscene setup found for room: " .. roomName)
        return
    end
    if playerInRoom then
        print("Playing cutscene for player in room: " .. roomName)
    else
        print("Player not in the room for cutscene: " .. roomName)
    end
    local clonedVictim = Victim:Clone()
    clonedVictim:SetPrimaryPartCFrame(setupFolder:WaitForChild("Torso").CFrame)
    clonedVictim.PrimaryPart.Anchored = true
    clonedVictim.Parent = workspace

    local clonedKiller = Killer:Clone()
    clonedKiller:SetPrimaryPartCFrame(setupFolder:WaitForChild("Feet").CFrame * CFrame.new(0, 3, 0))
    clonedKiller.PrimaryPart.Anchored = true
    clonedKiller.Parent = workspace

    local clonedDoor = Door:Clone()
    clonedDoor:SetPrimaryPartCFrame(setupFolder:WaitForChild("Door").CFrame)
    clonedDoor.Parent = workspace


    task.wait(7)
    clonedVictim:Destroy()
    clonedKiller:Destroy()
    clonedDoor:Destroy()
end


return CutsceneController
