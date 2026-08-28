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
