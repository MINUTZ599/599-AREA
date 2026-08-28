	searchBox.BackgroundColor3 = C.PANEL2
	searchBox.Text = ""
	searchBox.PlaceholderText = "Search player..."
	searchBox.PlaceholderColor3 = C.MUTED
	searchBox.TextColor3 = C.WHITE
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextSize = 12
	searchBox.ClearTextOnFocus = false
	searchBox.Parent = left
	round(searchBox,8)
	outline(searchBox,C.PURPLE,0.5,1)

	listFrame = Instance.new("ScrollingFrame")
	listFrame.Size = UDim2.new(1,-24,1,-72)
	listFrame.Position = UDim2.fromOffset(12,62)
	listFrame.BackgroundTransparency = 1
	listFrame.BorderSizePixel = 0
	listFrame.ScrollBarThickness = 3
	listFrame.ScrollBarImageColor3 = C.PURPLE
	listFrame.CanvasSize = UDim2.new()
	listFrame.Parent = left

	listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0,5)
	listLayout.Parent = listFrame

	text(right,"PLAYER INFO",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),15,C.PURPLE,true).ZIndex = 7

	selectedAvatar = Instance.new("ImageLabel")
	selectedAvatar.Size = UDim2.fromOffset(94,94)
	selectedAvatar.Position = UDim2.fromOffset(18,58)
	selectedAvatar.BackgroundColor3 = C.PANEL2
	selectedAvatar.BorderSizePixel = 0
	selectedAvatar.Parent = right
	round(selectedAvatar,47)
	outline(selectedAvatar,C.PURPLE,0.2,1)

	selectedName = text(right,"No player selected",UDim2.new(1,-145,0,30),UDim2.fromOffset(132,65),16,C.WHITE,true)
	selectedName.ZIndex = 7
	selectedUser = text(right,"",UDim2.new(1,-145,0,48),UDim2.fromOffset(132,98),10,C.MUTED,false)
	selectedUser.ZIndex = 7

	spectateBtn = actionButton(right,"👁  SPECTATE",UDim2.fromOffset(18,190),UDim2.fromOffset(170,48),C.PURPLE)
	teleportPlayerBtn = actionButton(right,"📍  TELEPORT",UDim2.fromOffset(202,190),UDim2.fromOffset(170,48),C.RED)
	prevPlayerBtn = actionButton(right,"◀  PREV",UDim2.fromOffset(18,248),UDim2.fromOffset(170,42),C.BLUE)
	nextPlayerBtn = actionButton(right,"NEXT  ▶",UDim2.fromOffset(202,248),UDim2.fromOffset(170,42),C.BLUE)
	selectedStatsText = text(right,"HEALTH: --   DIST: --",UDim2.new(1,-36,0,24),UDim2.fromOffset(18,300),10,C.ORANGE,true)
	selectedStatsText.ZIndex = 7

	local pinfo = text(right,
		"Search & inspect players in real time.\n\nPREV / NEXT quickly changes target.\n\nSPECTATE changes only your camera.\n\nTELEPORT moves only your own character.",
		UDim2.new(1,-36,0,160),UDim2.fromOffset(18,336),11,C.WHITE,false)
	pinfo.TextWrapped = true
	pinfo.TextYAlignment = Enum.TextYAlignment.Top
	pinfo.ZIndex = 7

	searchBox:GetPropertyChangedSignal("Text"):Connect(rebuildPlayerList)
	rebuildPlayerList()
end

local function cycleSelected(step)
	local pool = {}
	for _,plr in ipairs(Players:GetPlayers()) do if plr ~= lp then table.insert(pool,plr) end end
	if #pool == 0 then setSelected(nil); return end
	local idx = 0
	for i,plr in ipairs(pool) do if plr == selectedPlayer then idx = i break end end
	idx = ((idx - 1 + step) % #pool) + 1
	setSelected(pool[idx])
end
if prevPlayerBtn then prevPlayerBtn.MouseButton1Click:Connect(function() cycleSelected(-1) end) end
if nextPlayerBtn then nextPlayerBtn.MouseButton1Click:Connect(function() cycleSelected(1) end) end
RunService.RenderStepped:Connect(function()
	if selectedStatsText then
		local ch = selectedPlayer and selectedPlayer.Character
		local th = ch and ch:FindFirstChildOfClass("Humanoid")
		local tr = ch and ch:FindFirstChild("HumanoidRootPart")
		if th and tr and rootPart then
			selectedStatsText.Text = string.format("HEALTH: %d/%d   DIST: %d studs",math.floor(th.Health),math.floor(th.MaxHealth),math.floor((tr.Position-rootPart.Position).Magnitude))
		else selectedStatsText.Text = "HEALTH: --   DIST: --" end
	end
end)

Players.PlayerAdded:Connect(rebuildPlayerList)
Players.PlayerRemoving:Connect(function(p)
	if selectedPlayer == p then setSelected(nil) end
	rebuildPlayerList()
end)

--========================================================
-- VISUALS
--========================================================

local espToggle, tracerToggle, highlightToggle, fullbrightToggle, freecamToggle

do
	local p = pages.VISUALS
	pageTitle(p,"◉","VISUALS",C.BLUE)

	espToggle = toggleCard(p,"PLAYER NAME ESP","Show player names + HP + distance locally",UDim2.fromOffset(0,42))
	tracerToggle = toggleCard(p,"PLAYER LINE / TRACER","Draw local line from screen to each player",UDim2.fromOffset(0,118))
	highlightToggle = toggleCard(p,"PLAYER HIGHLIGHT","Highlight players locally",UDim2.fromOffset(0,194))
	fullbrightToggle = toggleCard(p,"FULLBRIGHT","Improve local visibility",UDim2.fromOffset(0,270))

	local info = panel(p,UDim2.fromOffset(455,250),UDim2.fromOffset(490,42),6)
	text(info,"VISUAL ENGINE",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),15,C.BLUE,true).ZIndex = 7
	local vt = text(info,"ESP, Player Line / Tracer and Highlight are local-only visual tools.\n\nTracer draws an orange line from the bottom-center of your screen to every visible player.\n\nFullbright improves local visibility without changing other players' clients.",UDim2.new(1,-28,1,-56),UDim2.fromOffset(14,52),11,C.WHITE,false)
	vt.TextWrapped = true
	vt.TextYAlignment = Enum.TextYAlignment.Top
	vt.ZIndex = 7
end

--========================================================
-- FREECAM
--========================================================

do
	local p = pages.FREECAM
	pageTitle(p,"📷","FREECAM",C.ORANGE)

	freecamToggle = toggleCard(p,"FREECAM [ C ]","Cinematic free camera; character stays frozen",UDim2.fromOffset(0,42))
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
-- FEATURE LOGIC
--========================================================

local function toggleSpeed()
	state.speed = not state.speed
