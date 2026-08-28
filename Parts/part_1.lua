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
	t.TextYAlignment = Enum.TextYAlignment.Center
	t.TextWrapped = false
	t.Parent = parent
	return t
end

local function panel(parent, size, pos, z)
	local f = Instance.new("Frame")
	f.Size = size
	f.Position = pos
	f.BackgroundColor3 = C.PANEL
	f.BackgroundTransparency = 0.08
	f.BorderSizePixel = 0
	f.ZIndex = z or 6
	f.Parent = parent
	round(f,10)
	outline(f,C.STROKE,0.35,1)
	return f
end

local notifBusy = false
local function notify(msg)
	if not notificationsEnabled then return end
	if notifBusy then
		local oldNotif = gui:FindFirstChild("_599Notif")
		if oldNotif then oldNotif:Destroy() end
	end
	notifBusy = true

	local n = Instance.new("Frame")
	n.Name = "_599Notif"
	n.Size = UDim2.fromOffset(300,48)
	n.Position = UDim2.new(1,20,1,-64)
	n.BackgroundColor3 = C.PANEL3
	n.BorderSizePixel = 0
	n.ZIndex = 100
	n.Parent = gui
	round(n,10)
	outline(n,C.ORANGE,0.15,1)

	local nt = text(n,msg,UDim2.new(1,-24,1,0),UDim2.fromOffset(12,0),12,C.WHITE,true)
	nt.ZIndex = 101

	TweenService:Create(n,TweenInfo.new(0.22),{Position=UDim2.new(1,-316,1,-64)}):Play()
	task.delay(1.7,function()
		if not n.Parent then return end
		TweenService:Create(n,TweenInfo.new(0.22),{Position=UDim2.new(1,20,1,-64)}):Play()
		task.wait(0.25)
		if n then n:Destroy() end
		notifBusy = false
	end)
end

--========================================================
-- HEADER
--========================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,150)
header.BackgroundTransparency = 1
header.ZIndex = 4
header.Parent = main

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.fromOffset(74,74)
avatar.Position = UDim2.fromOffset(18,18)
avatar.BackgroundColor3 = C.PANEL2
avatar.BorderSizePixel = 0
avatar.ZIndex = 7
avatar.Parent = header
round(avatar,37)
outline(avatar,C.ORANGE,0,2)

task.spawn(function()
	local ok,img = pcall(function()
		return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
	end)
	if ok then avatar.Image = img end
end)

local brand = text(header,"",UDim2.fromOffset(310,40),UDim2.fromOffset(108,18),30,C.WHITE,true)
brand.RichText = true
brand.Font = Enum.Font.GothamBlack
brand.TextStrokeColor3 = Color3.new(0,0,0)
brand.TextStrokeTransparency = 0.35
brand.Text = '<font color="#F5F5F7">599 </font><font color="#FF6A00">AREA</font>'

local brandAccent = Instance.new("Frame")
brandAccent.Size = UDim2.fromOffset(118,3)
brandAccent.Position = UDim2.fromOffset(108,57)
brandAccent.BackgroundColor3 = C.ORANGE
brandAccent.BorderSizePixel = 0
brandAccent.ZIndex = 7
brandAccent.Parent = header
local bag = Instance.new("UIGradient")
bag.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.ORANGE),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(70,20,0)),
})
bag.Parent = brandAccent

text(header,"@"..lp.Name,UDim2.fromOffset(270,22),UDim2.fromOffset(108,62),12,C.MUTED,false)

local premium = Instance.new("TextLabel")
premium.Size = UDim2.fromOffset(145,25)
premium.Position = UDim2.fromOffset(108,84)
premium.BackgroundColor3 = Color3.fromRGB(39,21,7)
premium.Text = "★ 599 AREA V8 • PREMIUM"
premium.TextColor3 = C.ORANGE2
premium.Font = Enum.Font.GothamBold
premium.TextSize = 10
premium.ZIndex = 7
premium.Parent = header
