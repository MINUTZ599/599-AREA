	vt.TextWrapped = true
	vt.TextYAlignment = Enum.TextYAlignment.Top
	vt.ZIndex = 7

	local style = panel(p,UDim2.fromOffset(455,250),UDim2.fromOffset(490,238),6)
	text(style,"599 CAMERA SYSTEM",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),15,C.ORANGE,true).ZIndex = 7
	local st = text(style,"Designed for smooth cinematic shots in your own experience.\n\nAdjust Speed, FOV and Sensitivity above.\n\nTip: hold LeftShift for fast travel, then release it for precise framing.",UDim2.new(1,-28,1,-56),UDim2.fromOffset(14,52),11,C.WHITE,false)
	st.TextWrapped = true
	st.TextYAlignment = Enum.TextYAlignment.Top
	st.ZIndex = 7
end

--========================================================
-- WORLD
--========================================================

local dayBtn, nightBtn

do
	local p = pages.WORLD
	pageTitle(p,"🌐","WORLD",C.BLUE)

	sliderCard(p,"LOCAL GRAVITY",UDim2.fromOffset(0,42),0,500,math.floor(DEFAULT_GRAVITY),function(v)
		workspace.Gravity = v
	end)

	dayBtn = actionButton(p,"☀  SET DAY",UDim2.fromOffset(0,150),UDim2.fromOffset(220,50),C.ORANGE2)
	nightBtn = actionButton(p,"☾  SET NIGHT",UDim2.fromOffset(238,150),UDim2.fromOffset(220,50),C.BLUE)

	local wi = panel(p,UDim2.fromOffset(455,210),UDim2.fromOffset(490,42),6)
	text(wi,"WORLD CONTROLS",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),15,C.BLUE,true).ZIndex = 7
	local wit = text(wi,"Gravity, time and fullbright are intended as local testing controls for your own place.",UDim2.new(1,-28,1,-56),UDim2.fromOffset(14,50),11,C.WHITE,false)
	wit.TextWrapped = true
	wit.TextYAlignment = Enum.TextYAlignment.Top
	wit.ZIndex = 7
end

--========================================================
-- SETTINGS
--========================================================

local resetAllBtn

do
	local p = pages.SETTINGS
	pageTitle(p,"⚙","SETTINGS",C.BLUE)

	resetAllBtn = actionButton(p,"↻  RESET ALL",UDim2.fromOffset(0,42),UDim2.fromOffset(455,52),C.BLUE)
	local notifToggle = toggleCard(p,"NOTIFICATIONS","Show 599 AREA popup notifications",UDim2.fromOffset(0,104),UDim2.fromOffset(455,64))
	notificationsEnabled = true
	setToggle(notifToggle,true)
	notifToggle.MouseButton1Click:Connect(function() notificationsEnabled = not notificationsEnabled; setToggle(notifToggle,notificationsEnabled) end)
	sliderCard(p,"UI SCALE %",UDim2.fromOffset(0,180),60,120,100,function(v) uiScale.Scale = v/100 end,UDim2.fromOffset(455,86))

	local bgBox = panel(p,UDim2.fromOffset(455,250),UDim2.fromOffset(490,42),6)
	text(bgBox,"BACKGROUND",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),15,C.ORANGE,true).ZIndex = 7

	local function bgButton(labelText,y,trans)
		local b = actionButton(bgBox,labelText,UDim2.fromOffset(14,y),UDim2.new(1,-28,0,42),C.ORANGE)
		b.MouseButton1Click:Connect(function()
			bg.ImageTransparency = trans
			notify("Background "..labelText)
		end)
	end

	bgButton("STRONG",52,0.05)
	bgButton("MEDIUM",102,0.18)
	bgButton("SOFT",152,0.35)

	local credits = panel(p,UDim2.fromOffset(455,250),UDim2.fromOffset(0,282),6)
	text(credits,"★  599 AREA  •  BY MINUTZ",UDim2.new(1,-24,0,32),UDim2.fromOffset(14,12),16,C.ORANGE,true).ZIndex = 7
	local ct = text(credits,"STAY LEGENDARY.\n\nDOMINATE THE GAME.\n\nRightShift = Hide / Show GUI",UDim2.new(1,-28,1,-60),UDim2.fromOffset(14,54),12,C.WHITE,false)
	ct.TextYAlignment = Enum.TextYAlignment.Top
	ct.ZIndex = 7

	local assetBox = panel(p,UDim2.fromOffset(455,170),UDim2.fromOffset(490,310),6)
	text(assetBox,"BACKGROUND ASSET",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),14,C.ORANGE,true).ZIndex = 7
	local aid = text(assetBox,BACKGROUND_IMAGE,UDim2.new(1,-28,0,26),UDim2.fromOffset(14,52),10,C.MUTED,false)
	aid.TextWrapped = true
	aid.ZIndex = 7
