--========================================================
-- 599 AREA V8.4 - MINUTZ KNOCKBACK EDITION
-- LocalScript -> StarterPlayer > StarterPlayerScripts
-- Untuk game Roblox milikmu sendiri / testing di Studio.
--========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local ContentProvider = game:GetService("ContentProvider")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

--========================================================
-- CONFIG
--========================================================

local BACKGROUND_IMAGE = "rbxassetid://126519323866401" -- background 599 AREA

local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50
local DEFAULT_GRAVITY = workspace.Gravity

local speedValue = 75
local flySpeed = 100
local jumpValue = 120

local KEY_GUI = Enum.KeyCode.RightShift
local KEY_FLY = Enum.KeyCode.F
local KEY_NOCLIP = Enum.KeyCode.N
local KEY_GOD = Enum.KeyCode.G
local KEY_SPECTATE = Enum.KeyCode.V
local KEY_FREECAM = Enum.KeyCode.C
local KEY_KNOCKBACK = Enum.KeyCode.K

local KNOCKBACK_REMOTE_NAME = "599KnockbackRequest"
local knockbackRadius = 10
local knockbackPower = 85
local knockbackInterval = 0.22

--========================================================
-- COLORS
--========================================================

local C = {
	BG = Color3.fromRGB(7,7,9),
	PANEL = Color3.fromRGB(11,11,14),
	PANEL2 = Color3.fromRGB(16,16,20),
	PANEL3 = Color3.fromRGB(22,22,27),
	ORANGE = Color3.fromRGB(255,92,0),
	ORANGE2 = Color3.fromRGB(255,145,35),
	RED = Color3.fromRGB(235,55,65),
	GREEN = Color3.fromRGB(48,185,87),
	PURPLE = Color3.fromRGB(166,83,255),
	BLUE = Color3.fromRGB(63,145,255),
	WHITE = Color3.fromRGB(245,245,247),
	MUTED = Color3.fromRGB(155,155,168),
	STROKE = Color3.fromRGB(111,51,15),
}

--========================================================
-- CHARACTER / STATE
--========================================================

local character, humanoid, rootPart

local state = {
	speed = false,
	infinite = false,
	fly = false,
	noclip = false,
	highjump = false,
	god = false,
	esp = false,
	tracer = false,
	highlight = false,
	fullbright = false,
	spectating = false,
	freecam = false,
	knockback = false,
}

local selectedPlayer = nil
local savedPosition = nil

local flyConn, noclipConn, godConn, freecamConn
local bodyVelocity, bodyGyro

local freecamSavedCFrame
local freecamSavedFov
local freecamYaw = 0
local freecamPitch = 0
local freecamSpeed = 80
local freecamFov = 75
local freecamSensitivity = 0.22
local notificationsEnabled = true
local positionSlots = {}
local noclipOriginal = {}

-- character state saved while freecam is active
local freecamSaved = {
	WalkSpeed = nil,
	JumpPower = nil,
	AutoRotate = nil,
	RootAnchored = nil,
}

local oldLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
}

local espFolder = Instance.new("Folder")
espFolder.Name = "_599LocalVisuals"

local function bindCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	rootPart = char:WaitForChild("HumanoidRootPart")
	humanoid.UseJumpPower = true
	humanoid.WalkSpeed = state.speed and speedValue or DEFAULT_SPEED
	humanoid.JumpPower = state.highjump and jumpValue or DEFAULT_JUMP
end

if lp.Character then
	bindCharacter(lp.Character)
end

lp.CharacterAdded:Connect(function(char)
	if state.freecam then
		state.freecam = false
		ContextActionService:UnbindAction("599_FREECAM_BLOCK_CHARACTER")
	end

	task.wait(0.35)
	bindCharacter(char)
	state.fly = false

	if flyConn then flyConn:Disconnect(); flyConn = nil end
	if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
end)

--========================================================
-- ROOT GUI
--========================================================

local old = lp:WaitForChild("PlayerGui"):FindFirstChild("AREA599_V8")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AREA599_V8"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = lp.PlayerGui

espFolder.Parent = gui

local tracerFolder = Instance.new("Folder")
tracerFolder.Name = "_599TracerLines"
tracerFolder.Parent = gui

local viewport = Instance.new("Frame")
viewport.Name = "Viewport"
viewport.AnchorPoint = Vector2.new(0.5,0.5)
viewport.Position = UDim2.fromScale(0.5,0.5)
viewport.Size = UDim2.fromOffset(1180,780)
viewport.BackgroundTransparency = 1
viewport.Parent = gui

local uiScale = Instance.new("UIScale")
uiScale.Parent = viewport

local function updateScale()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local s = cam.ViewportSize
	local fit = math.min((s.X - 24) / 1180, (s.Y - 24) / 780, 1)
	uiScale.Scale = math.max(fit, 0.5)
end

updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

local main = Instance.new("Frame")
main.Size = UDim2.fromScale(1,1)
main.BackgroundColor3 = C.BG
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = viewport

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0,16)
mc.Parent = main

local ms = Instance.new("UIStroke")
ms.Color = C.ORANGE
ms.Thickness = 1.3
ms.Transparency = 0.2
ms.Parent = main

--========================================================
-- BACKGROUND - dibuat jauh lebih terlihat
--========================================================

local bg = Instance.new("ImageLabel")
bg.Name = "Background599"
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundTransparency = 1
bg.Image = BACKGROUND_IMAGE
bg.ImageTransparency = 0.05
bg.ScaleType = Enum.ScaleType.Crop
bg.ZIndex = 0
bg.Parent = main

local shade = Instance.new("Frame")
shade.Size = UDim2.fromScale(1,1)
shade.BackgroundColor3 = Color3.new(0,0,0)
shade.BackgroundTransparency = 0.64
shade.BorderSizePixel = 0
shade.ZIndex = 1
shade.Parent = main

local topFade = Instance.new("Frame")
topFade.Size = UDim2.new(1,0,0,175)
topFade.BackgroundColor3 = Color3.new(0,0,0)
topFade.BackgroundTransparency = 0.56
topFade.BorderSizePixel = 0
topFade.ZIndex = 2
topFade.Parent = main

--========================================================
-- HELPERS
--========================================================

local function round(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,r or 8)
	c.Parent = obj
	return c
end

local function outline(obj, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or C.STROKE
	s.Transparency = transparency == nil and 0.45 or transparency
	s.Thickness = thickness or 1
	s.Parent = obj
	return s
end

local function text(parent, value, size, pos, fontSize, color, bold)
	local t = Instance.new("TextLabel")
	t.Size = size
	t.Position = pos
	t.BackgroundTransparency = 1
	t.Text = value
	t.TextColor3 = color or C.WHITE
	t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
	t.TextSize = fontSize or 13
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextYAlignment = 