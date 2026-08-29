(p,"FREECAM [ C ]","Cinematic free camera; character stays frozen",UDim2.fromOffset(0,42))
	sliderCard(p,"FREECAM SPEED",UDim2.fromOffset(0,118),10,300,freecamSpeed,function(v)
		freecamSpeed = v
	end)
	sliderCard(p,"FREECAM FOV",UDim2.fromOffset(490,42),40,120,freecamFov,function(v)
		freecamFov = v
		if state.freecam and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = v end
	end)
	sliderCard(p,"MOUSE SENSITIVITY x100",UDim2.fromOffset(490,140),5,80,math.floor(freecamSensitivity*100),function(v)
		freecamSensitivity = v/100
	end)

	local info = panel(p,UDim2.fromOffset(455,250),UDim2.fromOffset(0,238),6)
	text(info,"🎥  CINEMATIC CONTROLS",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),15,C.ORANGE,true).ZIndex = 7
	local vt = text(info,"W A S D  = Move\nQ / E        = Down / Up\nMouse      = Look\nLeftShift  = 3x Boost\nC             = Toggle Freecam\n\nCharacter stays frozen while Freecam is ON.",UDim2.new(1,-28,1,-56),UDim2.fromOffset(14,52),11,C.WHITE,false)
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
	local hint = text(assetBox,"If the image stays blank, make sure the uploaded image is approved and accessible to this experience.",UDim2.new(1,-28,0,70),UDim2.fromOffset(14,84),10,C.WHITE,false)
	hint.TextWrapped = true
	hint.TextYAlignment = Enum.TextYAlignment.Top
	hint.ZIndex = 7
end

--========================================================
-- WALK KNOCKBACK / LAUNCH AURA
--========================================================

local knockbackRemote = ReplicatedStorage:FindFirstChild(KNOCKBACK_REMOTE_NAME)
local knockbackBusy = false

local function setKnockback(on)
	state.knockback = on

	if knockbackToggle then
		setToggle(knockbackToggle,on)
	end

	if on then
		knockbackRemote = ReplicatedStorage:FindFirstChild(KNOCKBACK_REMOTE_NAME)
		if not knockbackRemote or not knockbackRemote:IsA("RemoteEvent") then
			state.knockback = false
			if knockbackToggle then setToggle(knockbackToggle,false) end
			notify("Knockback server module not found")
			return
		end
	end

	notify("Walk Knockback "..(state.knockback and "ON" or "OFF"))
end

if knockbackToggle then
	knockbackToggle.MouseButton1Click:Connect(function()
		setKnockback(not state.knockback)
	end)
end

task.spawn(function()
	while gui.Parent do
		task.wait(knockbackInterval)

		if state.knockback
			and rootPart
			and humanoid
			and humanoid.Health > 0
			and not knockbackBusy then

			knockbackBusy = true

			knockbackRemote = knockbackRemote or ReplicatedStorage:FindFirstChild(KNOCKBACK_REMOTE_NAME)
			if knockbackRemote and knockbackRemote:IsA("RemoteEvent") then
				knockbackRemote:FireServer(knockbackRadius,knockbackPower)
			end

			knockbackBusy = false
		end
	end
end)

--========================================================
-- FEATURE LOGIC
--========================================================

local function toggleSpeed()
	state.speed = not state.speed
	if humanoid then humanoid.WalkSpeed = state.speed and speedValue or DEFAULT_SPEED end
	setToggle(speedToggle,state.speed)
	notify("Speed "..(state.speed and "ON" or "OFF"))
end

local function toggleInfinite()
	state.infinite = not state.infinite
	setToggle(infiniteToggle,state.infinite)
	notify("Infinite Jump "..(state.infinite and "ON" or "OFF"))
end

UIS.JumpRequest:Connect(function()
	if state.infinite and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local function toggleHighJump()
	state.highjump = not state.highjump
	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = state.highjump and jumpValue or DEFAULT_JUMP
	end
	setToggle(highJumpToggle,state.highjump)
	notify("High Jump "..(state.highjump and "ON" or "OFF"))
end

local function stopFly()
	if flyConn then flyConn:Disconnect(); flyConn = nil end
	if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
	if bodyGyro then bodyG