local GameLoopService = {}

function GameLoopService:Init()
    
end

function GameLoopService:Start()
    while true do
        workspace:SetAttribute("GAME_STEP", "WAITING_START_GAME")
        task.spawn(5)
    end
end
return GameLoopService