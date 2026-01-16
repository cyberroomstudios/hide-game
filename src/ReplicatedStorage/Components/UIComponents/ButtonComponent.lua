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

local MainGui = PlayerGui:WaitForChild("MainGui")
local Middle = MainGui:WaitForChild("Middle")
local Windows = Middle:WaitForChild("Windows")

local SFX = SoundService:WaitForChild("SFX")
local ClickSound = SFX:WaitForChild("ButtonClick")
local HoverSound = SFX:WaitForChild("ButtonHover")

-- ===========================================================================
-- Components
-- ===========================================================================
local ButtonComponent = Component.new({
	Tag = "WindowButton",
	Ancestors = {
		PlayerGui,
	},
	Extensions = {},
})

local function closeAllWindows()
	for _, window in pairs(Windows:GetChildren()) do
		if window:IsA("Frame") then
			window.Visible = false
		end
	end
end

local function toggleWindow(windowName: string)
	local window = Windows:FindFirstChild(windowName)
	if window and window:IsA("Frame") and window.Visible then
		window.Visible = false
		return
	end
	closeAllWindows()
	if window and window:IsA("Frame") then
		window.Visible = true
	end
end


function ButtonComponent:Construct()
	self.Trove = Trove.new()
	self.Trove:AttachToInstance(self.Instance)

end

--[[
    Start is called when the component is started.
    At this point in time, it is safe to grab other components also bound to the same instance.
]]
function ButtonComponent:Start()

	local button = self.Instance


	button.MouseButton1Click:Connect(function()
		ClickSound:Play()
		toggleWindow(button.Name)
	end)

	button.MouseEnter:Connect(function()
		HoverSound:Play()
	end)
end

--[[
    Stop is called when the component is stopped.
    This is called when the bound instance is removed from the whitelisted ancestors or when the tag is removed from the instance.
]]
function ButtonComponent:Stop()
	self.Trove:Destroy()
end



return ButtonComponent