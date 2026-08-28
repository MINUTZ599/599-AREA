round(premium,6)
outline(premium,C.ORANGE,0.25,1)

-- Stylized center logo: layered shadow + glow + gradients
local logoShadow599 = text(header,"599",UDim2.fromOffset(280,66),UDim2.new(0.5,-138,0,1),62,Color3.fromRGB(18,5,0),true)
logoShadow599.Font = Enum.Font.Arcade
logoShadow599.TextXAlignment = Enum.TextXAlignment.Center
logoShadow599.TextStrokeColor3 = Color3.new(0,0,0)
logoShadow599.TextStrokeTransparency = 0
logoShadow599.Rotation = -4

local logo599 = text(header,"599",UDim2.fromOffset(280,66),UDim2.new(0.5,-142,0,-3),62,C.ORANGE,true)
logo599.Font = Enum.Font.Arcade
logo599.TextXAlignment = Enum.TextXAlignment.Center
logo599.TextYAlignment = Enum.TextYAlignment.Center
logo599.TextStrokeColor3 = Color3.fromRGB(75,18,0)
logo599.TextStrokeTransparency = 0
logo599.Rotation = -4
local lg599Gradient = Instance.new("UIGradient")
lg599Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(255,210,70)),
	ColorSequenceKeypoint.new(0.42,Color3.fromRGB(255,110,0)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(175,35,0)),
})
lg599Gradient.Rotation = 90
lg599Gradient.Parent = logo599

local logoGlow = text(header,"599",UDim2.fromOffset(288,70),UDim2.new(0.5,-146,0,-5),64,C.ORANGE,true)
logoGlow.Font = Enum.Font.Arcade
logoGlow.TextXAlignment = Enum.TextXAlignment.Center
logoGlow.TextTransparency = 0.78
logoGlow.TextStrokeColor3 = C.ORANGE
logoGlow.TextStrokeTransparency = 0.72
logoGlow.Rotation = -4
logoGlow.ZIndex = 6

local logoAreaShadow = text(header,"AREA",UDim2.fromOffset(270,48),UDim2.new(0.5,-131,0,55),42,Color3.fromRGB(15,15,15),true)
logoAreaShadow.Font = Enum.Font.SciFi
logoAreaShadow.TextXAlignment = Enum.TextXAlignment.Center
logoAreaShadow.TextStrokeColor3 = Color3.new(0,0,0)
logoAreaShadow.TextStrokeTransparency = 0
logoAreaShadow.Rotation = -2

local logoArea = text(header,"AREA",UDim2.fromOffset(270,48),UDim2.new(0.5,-135,0,51),42,C.WHITE,true)
logoArea.Font = Enum.Font.SciFi
logoArea.TextXAlignment = Enum.TextXAlignment.Center
logoArea.TextYAlignment = Enum.TextYAlignment.Center
logoArea.TextStrokeColor3 = Color3.new(0,0,0)
logoArea.TextStrokeTransparency = 0
logoArea.Rotation = -2
local lgAreaGradient = Instance.new("UIGradient")
lgAreaGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.55,Color3.fromRGB(215,215,215)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(120,120,120)),
})
lgAreaGradient.Rotation = 90
lgAreaGradient.Parent = logoArea

local logoSub = text(header,"V8  •  PREMIUM",UDim2.fromOffset(190,22),UDim2.new(0.5,-95,0,101),14,C.ORANGE2,true)
logoSub.Font = Enum.Font.GothamBlack
logoSub.TextXAlignment = Enum.TextXAlignment.Center
logoSub.TextStrokeColor3 = Color3.new(0,0,0)
logoSub.TextStrokeTransparency = 0.15

local logoLineL = Instance.new("Frame")
logoLineL.Size = UDim2.fromOffset(55,2)
logoLineL.Position = UDim2.new(0.5,-158,0,111)
logoLineL.BackgroundColor3 = C.ORANGE
logoLineL.BorderSizePixel = 0
logoLineL.ZIndex = 7
logoLineL.Rotation = -3
logoLineL.Parent = header
local logoLineR = logoLineL:Clone()
logoLineR.Position = UDim2.new(0.5,103,0,111)
logoLineR.Rotation = 3
logoLineR.Parent = header

-- small claw/slash accents around logo
for i = 1,3 do
	local slash = Instance.new("Frame")
	slash.Size = UDim2.fromOffset(32 - i*4,2)
	slash.Position = UDim2.new(0.5,-154 + i*6,0,80 + i*5)
	slash.BackgroundColor3 = C.ORANGE
	slash.BorderSizePixel = 0
	slash.Rotation = -18
	slash.ZIndex = 7
	slash.Parent = header
end

local statBox = panel(header,UDim2.fromOffset(170,90),UDim2.new(1,-230,0,18),7)
local statusText = text(statBox,"FPS: --\nPING: --\nTIME: --",UDim2.new(1,-20,1,-16),UDim2.fromOffset(12,8),12,C.WHITE,true)
statusText.TextYAlignment = Enum.TextYAlignment.Top

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(42,42)
minBtn.Position = UDim2.new(1,-55,0,20)
minBtn.BackgroundColor3 = C.PANEL3
minBtn.Text = "—"
minBtn.TextColor3 = C.ORANGE
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.ZIndex = 8
minBtn.Parent = header
round(minBtn,9)
outline(minBtn,C.ORANGE,0.15,1)

local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1,-24,0,2)
accentLine.Position = UDim2.fromOffset(12,148)
accentLine.BackgroundColor3 = C.ORANGE
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 5
accentLine.Parent = main

local accentGradient = Instance.new("UIGradient")
accentGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(70,20,0)),
	ColorSequenceKeypoint.new(0.5, C.ORANGE),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70,20,0)),
})
accentGradient.Parent = accentLine

--========================================================
-- FOOTER BRANDING
--========================================================

local footerY = 744
local footerLeft = Instance.new("Frame")
footerLeft.Size = UDim2.fromOffset(360,2)
footerLeft.Position = UDim2.new(0.5,-470,0,footerY+10)
footerLeft.BackgroundColor3 = C.ORANGE
footerLeft.BorderSizePixel = 0
footerLeft.ZIndex = 7
footerLeft.Parent = main

local footerRight = footerLeft:Clone()
footerRight.Position = UDim2.new(0.5,110,0,footerY+10)
footerRight.Parent = main

local footerText = text(main,"◆  BY MINUTZ  ◆",UDim2.fromOffset(220,28),UDim2.new(0.5,-110,0,footerY-3),17,C.ORANGE2,true)
footerText.Font = Enum.Font.GothamBlack
footerText.TextXAlignment = Enum.TextXAlignment.Center
footerText.TextStrokeColor3 = Color3.new(0,0,0)
footerText.TextStrokeTransparency = 0.15
footerText.ZIndex = 8

--========================================================
-- SIDEBAR + CONTENT
--========================================================

local sidebar = panel(main,UDim2.fromOffset(178,552),UDim2.fromOffset(12,174),5)
sidebar.BackgroundTransparency = 0.03

local content = Instance.new("Frame")
content.Size = UDim2.fromOffset(966,552)
content.Position = UDim2.fromOffset(202,174)
content.BackgroundTransparency = 1
content.ZIndex = 5
content.Parent = main

local pages = {}
local tabs = {}
local tabOrder = {
	{"DASHBOARD","▦"},
	{"MOVEMENT","⚡"},
	{"UTILITY","🔧"},
	{"PLAYER","👤"},
	{"VISUALS","◉"},
	{"WORLD","🌐"},
	{"FREECAM","📷"},
	{"SETTINGS","⚙"},
}

for i,item in ipairs(tabOrder) do
	local name, icon = item[1], item[2]
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-18,0,48)
	b.Position = UDim2.fromOffset(9,9 + (i-1)*55)
	b.BackgroundColor3 = C.PANEL2
	b.Text = icon.."   "..name
	b.TextColor3 = C.MUTED
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 12
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.AutoButtonColor = false
	b.ZIndex = 7
	b.Parent = sidebar
	round(b,8)

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0,14)
	pad.Parent = b

	tabs[name] = b

	local p = Instance.new("Frame")
	p.Name = name
	p.Size = UDim2.fromScale(1,1)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.ZIndex = 5
	p.Parent = content
	pages[name] = p
end

local function selectPage(name)
	for n,p in pairs(pages) do p.Visible = n == name end
	for n,b in pairs(tabs) do
		if n == name then
			b.BackgroundColor3 = Color3.fromRGB(63,28,8)
			b.TextColor3 = C.ORANGE
			outline(b,C.ORANGE,0.2,1)
		else
			b.BackgroundColor3 = C.PANEL2
			b.TextColor3 = C.MUTED
			local s = b:FindFirstChildOfClass("UIStroke")
			if s then s:Destroy() end
		end
	end
end

for name,b in pairs(tabs) do
	b.MouseButton1Click:Connect(function()
		selectPage(name)
	end)
end

--========================================================
-- COMPONENT BUILDERS
--========================================================

local function pageTitle(parent, icon, labelText, color)
	local t = text(parent,icon.."  "..labelText,UDim2.new(1,0,0,30),UDim2.fromOffset(4,0),18,color or C.ORANGE,true)
	t.ZIndex = 7
	return t
end

local function toggleCard(parent, title, desc, pos, size)
	local f = panel(parent,size or UDim2.fromOffset(455,64),pos,6)

	local a = text(f,title,UDim2.new(1,-94,0,23),UDim2.fromOffset(15,8),12,C.WHITE,true)
	a.ZIndex = 7
	local d = text(f,desc,UDim2.new(1,-100,0,18),UDim2.fromOffset(15,34),10,C.MUTED,false)
	d.ZIndex = 7

	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(62,30)
	b.Position = UDim2.new(1,-76,0.5,-15)
	b.BackgroundColor3 = Color3.fromRGB(42,42,49)
	b.Text = "OFF"
	b.TextColor3 = C.WHITE
	b.Font = Enum.Font.GothamBold
	b.TextSize = 10
	b.AutoButtonColor = false
	b.ZIndex = 8
	b.Parent = f
	round(b,15)
	return b
end

local function setToggle(b,on)
	b.Text = on and "ON" or "OFF"
	b.BackgroundColor3 = on and C.GREEN or Color3.fromRGB(42,42,49)
end

local function sliderCard(parent,title,pos,minv,maxv,startv,callback,size)
	local f = panel(parent,size or UDim2.fromOffset(455,86),pos,6)
	local ttl = text(f,title,UDim2.new(0.6,0,0,22),UDim2.fromOffset(15,8),11,C.WHITE,true)
	ttl.ZIndex = 7
	local val = text(f,tostring(startv),UDim2.fromOffset(80,22),UDim2.new(1,-95,0,8),12,C.ORANGE,true)
	val.TextXAlignment = Enum.TextXAlignment.Right
	val.ZIndex = 7

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1,-30,0,8)
	bar.Position = UDim2.fromOffset(15,48)
	bar.BackgroundColor3 = Color3.fromRGB(47,47,55)
	bar.BorderSizePixel = 0
	bar.ZIndex = 7
	bar.Parent = f
	round(bar,4)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((startv-minv)/(maxv-minv),0,1,0)
	fill.BackgroundColor3 = C.ORANGE
	fill.BorderSizePixel = 0
	fill.ZIndex = 8
	fill.Parent = bar
	round(fill,4)

	local minT = text(f,tostring(minv),UDim2.fromOffset(50,16),UDim2.fromOffset(15,63),9,C.MUTED,false)
	minT.ZIndex = 7
	local maxT = text(f,tostring(maxv),UDim2.fromOffset(50,16),UDim2.new(1,-65,0,63),9,C.MUTED,false)
	maxT.TextXAlignment = Enum.TextXAlignment.Right
	maxT.ZIndex = 7

	local dragging = false

	local function setFromX(x)
		local w = bar.AbsoluteSize.X
		if w <= 0 then return end
		local pct = math.clamp((x - bar.AbsolutePosition.X)/w,0,1)
		local v = math.floor(minv + (maxv-minv)*pct + 0.5)
		fill.Size = UDim2.new(pct,0,1,0)
		val.Text = tostring(v)
		callback(v)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(input.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			setFromX(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
