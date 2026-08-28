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
	if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
	if humanoid then humanoid.PlatformStand = false end
end

local function startFly()
	if not humanoid or not rootPart then return end
	stopFly()

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
	bodyGyro.P = 10000
	bodyGyro.Parent = rootPart

	humanoid.PlatformStand = true

	flyConn = RunService.RenderStepped:Connect(function()
		if not state.fly or not rootPart or not bodyVelocity or not bodyGyro then return end
		local cam = workspace.CurrentCamera
		if not cam then return end

		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
		if dir.Magnitude > 0 then dir = dir.Unit end

		bodyVelocity.Velocity = dir * flySpeed
		bodyGyro.CFrame = CFrame.lookAt(rootPart.Position,rootPart.Position + cam.CFrame.LookVector)
	end)
end

local function toggleFly()
	state.fly = not state.fly
	if state.fly then startFly() else stopFly() end
	setToggle(flyToggle,state.fly)
	notify("Fly "..(state.fly and "ON" or "OFF"))
end

local function startNoclip()
	if noclipConn then return end
	table.clear(noclipOriginal)
	if character then
