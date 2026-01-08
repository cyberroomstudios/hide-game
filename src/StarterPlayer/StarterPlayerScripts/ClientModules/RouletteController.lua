local RouletteController = {}

-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- =========================
-- DEPENDÊNCIAS
-- =========================
local UIReferences = require(Players.LocalPlayer.PlayerScripts.Util.UIReferences)
local CameraController = require(Players.LocalPlayer.PlayerScripts.ClientModules.CameraController)

-- =========================
-- REFERÊNCIAS UI
-- =========================
local rouletteFrame
local viewport
local listFrame
local layout

-- =========================
-- CONFIGURAÇÕES
-- =========================
local LOOP_COUNT = 10
local START_DELAY = 0.03
local END_DELAY = 0.15
local EASING_STYLE = Enum.EasingStyle.Linear

-- =========================
-- ESTADO INTERNO
-- =========================
local originalItems = {}
local ITEM_COUNT = 0
local TOTAL_ITEMS = 0
local ITEM_HEIGHT_PX = 0
local VIEWPORT_HEIGHT_PX = 0
local spinning = false

-- =========================
-- INIT
-- =========================
function RouletteController:Init()
	self:CreateReferences()
	self:Configure()
end

function RouletteController:CreateReferences()
	rouletteFrame = UIReferences:GetReference("ROULETTE_SCREEN")
	viewport = UIReferences:GetReference("ROULETTE_VIEWPORT")
	listFrame = UIReferences:GetReference("ROULETTE_UI_LIST_FRAME")
	layout = UIReferences:GetReference("ROULETTE_UI_LIST_LAYOUT")
end

-- =========================
-- CONFIGURAÇÃO INICIAL
-- =========================
function RouletteController:Configure()
	originalItems = {}

	for _, child in ipairs(listFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			table.insert(originalItems, child)
		end
	end

	table.sort(originalItems, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)

	ITEM_COUNT = #originalItems
	if ITEM_COUNT == 0 then
		warn("RouletteController: nenhum item encontrado")
		return
	end

	-- Aguarda layout calcular
	task.wait()
	task.wait()

	ITEM_HEIGHT_PX = layout.AbsoluteContentSize.Y / ITEM_COUNT
	VIEWPORT_HEIGHT_PX = viewport.AbsoluteSize.Y

	-- Loop fake (duplica itens)
	for i = 1, LOOP_COUNT - 1 do
		for _, item in ipairs(originalItems) do
			local clone = item:Clone()
			clone.LayoutOrder = item.LayoutOrder + (i * ITEM_COUNT)
			clone.Parent = listFrame
		end
	end

	task.wait()
	task.wait()

	TOTAL_ITEMS = ITEM_COUNT * LOOP_COUNT
end

-- =========================
-- TWEEN POR ÍNDICE
-- =========================
local function tweenToIndex(index, duration)
	local yPx = -(index - 1) * ITEM_HEIGHT_PX
	local yScale = yPx / VIEWPORT_HEIGHT_PX

	local tween = TweenService:Create(
		listFrame,
		TweenInfo.new(duration, EASING_STYLE),
		{ Position = UDim2.fromScale(0, yScale) }
	)

	tween:Play()
	tween.Completed:Wait()
end

-- =========================
-- BUSCA ÍNDICE PELO TEXTO
-- =========================
local function getIndexByText(text)
	for i, item in ipairs(originalItems) do
		if item.Text == text then
			return i
		end
	end
	return nil
end

-- =========================
-- SPIN (PARA ÍNDICE FINAL)
-- =========================
function RouletteController:Spin(finalIndex)
	if spinning then
		return
	end
	spinning = true

	listFrame.Position = UDim2.fromScale(0, 0)

	-- várias voltas antes de parar
	local baseSteps = TOTAL_ITEMS - ITEM_COUNT
	local targetStep = baseSteps + finalIndex

	local delayStep = (END_DELAY - START_DELAY) / targetStep
	local currentDelay = START_DELAY

	for i = 1, targetStep do
		tweenToIndex(i, currentDelay)
		currentDelay += delayStep
	end

	spinning = false
end

-- =========================
-- CONTROLE DE TELA
-- =========================
function RouletteController:Open()
	rouletteFrame.Visible = true
	self:Start()
end

function RouletteController:Close()
	rouletteFrame.Visible = false
end

function RouletteController:GetScreen()
	return rouletteFrame
end

-- =========================
-- START
-- =========================
function RouletteController:Start()
	local isKiller = player:GetAttribute("IS_KILLER") == true
	local finalResult = isKiller and "KILLER" or "VICTIM"

	local finalIndex = getIndexByText(finalResult)
	if not finalIndex then
		warn("Resultado não encontrado na roleta:", finalResult)
		return
	end

	self:Spin(finalIndex)
end

return RouletteController
