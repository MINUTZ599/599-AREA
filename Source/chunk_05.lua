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
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return f
end

local function actionButton(parent,labelText,pos,size,color)
	local b = Instance.new("TextButton")
	b.Size = size or UDim2.fromOffset(220,48)
	b.Position = pos
	b.BackgroundColor3 = C.PANEL2
	b.Text = labelText
	b.TextColor3 = color or C.ORANGE
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.AutoButtonColor = false
	b.ZIndex = 7
	b.Parent = parent
	round(b,8)
	outline(b,color or C.ORANGE,0.35,1)
	return b
end

--========================================================
-- DASHBOARD (mendekati foto referensi)
--========================================================

do
	local p = pages.DASHBOARD
	pageTitle(p,"▦","DASHBOARD",C.ORANGE)

	local c1 = panel(p,UDim2.fromOffset(300,92),UDim2.fromOffset(0,42),6)
	text(c1,"👤  USERNAME",UDim2.new(1,-20,0,24),UDim2.fromOffset(14,10),11,C.PURPLE,true).ZIndex = 7
	text(c1,lp.DisplayName.."\n@"..lp.Name,UDim2.new(1,-20,0,46),UDim2.fromOffset(14,36),11,C.WHITE,false).ZIndex = 7

	local c2 = panel(p,UDim2.fromOffset(300,92),UDim2.fromOffset(318,42),6)
	text(c2,"♥  HEALTH",UDim2.new(1,-20,0,24),UDim2.fromOffset(14,10),11,C.GREEN,true).ZIndex = 7
	local healthInfo = text(c2,"-- / --",UDim2.new(1,-20,0,30),UDim2.fromOffset(14,42),14,C.WHITE,true)
	healthInfo.ZIndex = 7

	local c3 = panel(p,UDim2.fromOffset(330,92),UDim2.fromOffset(636,42),6)
	text(c3,"⚡  STATUS",UDim2.new(1,-20,0,24),UDim2.fromOffset(14,10),11,C.ORANGE,true).ZIndex = 7
	local dashInfo = text(c3,"Speed --   Jump --\nPosition --",UDim2.new(1,-20,0,48),UDim2.fromOffset(14,36),11,C.WHITE,false)
	dashInfo.ZIndex = 7

