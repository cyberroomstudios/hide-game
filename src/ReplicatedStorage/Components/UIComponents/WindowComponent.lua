-- ===========================================================================
-- Roblox Services
-- ===========================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
-- ===========================================================================
-- Dependencies
-- ===========================================================================
local Packages = ReplicatedStorage.Packages
local Component = require(Packages.Component)
local Trove = require(Packages.Trove)

-- ===========================================================================
-- Variables
-- ===========================================================================
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")


local SFX = SoundService:WaitForChild("SFX")
local ClickSound = SFX:WaitForChild("ButtonClick")
local HoverSound = SFX:WaitForChild("ButtonHover")
local ToggleSound = SFX:WaitForChild("ToggleWindow")

-- ===========================================================================
-- Components
-- ===========================================================================
local WindowComponent = Component.new({
	Tag = "WindowComponent",
	Ancestors = {
		PlayerGui,
	},
	Extensions = {},
})


function WindowComponent:Construct()
	self.Trove = Trove.new()
	self.Trove:AttachToInstance(self.Instance)

end

--[[
    Start is called when the component is started.
    At this point in time, it is safe to grab other components also bound to the same instance.
]]
function WindowComponent:Start()

    local window = self.Instance
    local closeButton = window:FindFirstChild("CloseButton")

    if closeButton and closeButton:IsA("TextButton") then
        closeButton.MouseButton1Click:Connect(function()
            ClickSound:Play()
            window.Visible = false
        end)

        closeButton.MouseEnter:Connect(function()
            HoverSound:Play()
        end)
    end

    window:GetPropertyChangedSignal("Visible"):Connect(function()
        ToggleSound:Play()
    end)
end

--[[
    Stop is called when the component is stopped.
    This is called when the bound instance is removed from the whitelisted ancestors or when the tag is removed from the instance.
]]
function WindowComponent:Stop()
	self.Trove:Destroy()
end



return WindowComponent