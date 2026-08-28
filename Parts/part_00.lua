--========================================================
-- 599 AREA V8.1 - MINUTZ TRACER EDITION
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
