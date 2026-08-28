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

	local movementBox = panel(p,UDim2.fromOffset(350,380),UDim2.fromOffset(0,150),6)
	text(movementBox,"⚡  MOVEMENT",UDim2.new(1,-20,0,30),UDim2.fromOffset(14,10),16,C.ORANGE,true).ZIndex = 7

	local movementSummary = text(
		movementBox,
		"Speed\nInfinite Jump\nFly\nHigh Jump\n\nOpen the MOVEMENT tab to control sliders and toggles.",
		UDim2.new(1,-28,1,-62),
		UDim2.fromOffset(14,50),
		12,C.WHITE,false
	)
	movementSummary.TextYAlignment = Enum.TextYAlignment.Top
	movementSummary.ZIndex = 7

	local keyBox = panel(p,UDim2.fromOffset(304,380),UDim2.fromOffset(366,150),6)
	text(keyBox,"⌨  KEYBINDS",UDim2.new(1,-20,0,30),UDim2.fromOffset(14,10),16,C.ORANGE,true).ZIndex = 7
	local kt = text(
		keyBox,
		"RightShift    Hide / Show GUI\n\nF              Fly Toggle\n\nN             NoClip Toggle\n\nG             GodMode Toggle\n\nV             Stop Spectate\n\nC             Freecam Toggle",
		UDim2.new(1,-28,1,-58),
		UDim2.fromOffset(14,52),
		11,C.WHITE,false
	)
	kt.TextYAlignment = Enum.TextYAlignment.Top
	kt.ZIndex = 7

	local serverBox = panel(p,UDim2.fromOffset(280,380),UDim2.fromOffset(686,150),6)
	text(serverBox,"🌐  SERVER INFO",UDim2.new(1,-20,0,30),UDim2.fromOffset(14,10),16,C.ORANGE,true).ZIndex = 7
	local serverInfo = text(serverBox,"PLAYERS\n--\n\nSERVER UPTIME\n--\n\nPLACE ID\n--\n\nJOB ID\n--",UDim2.new(1,-28,1,-70),UDim2.fromOffset(14,52),11,C.WHITE,false)
	serverInfo.TextYAlignment = Enum.TextYAlignment.Top
	serverInfo.TextWrapped = true
	serverInfo.ZIndex = 7

	local studioBadge = text(serverBox,RunService:IsStudio() and "⬢  You are in Studio" or "⬢  Live Server",UDim2.new(1,-28,0,26),UDim2.new(0,14,1,-38),10,RunService:IsStudio() and C.PURPLE or C.GREEN,true)
	studioBadge.ZIndex = 7
	local scriptStartedAt = os.clock()

	RunService.RenderStepped:Connect(function()
		if humanoid then
			healthInfo.Text = math.floor(humanoid.Health).." / "..math.floor(humanoid.MaxHealth)
		end
		if rootPart and humanoid then
			dashInfo.Text = "Speed "..math.floor(humanoid.WalkSpeed).."   Jump "..math.floor(humanoid.JumpPower)
				.."\nPosition "..math.floor(rootPart.Position.X)..", "..math.floor(rootPart.Position.Y)..", "..math.floor(rootPart.Position.Z)
		end
		local elapsed = math.max(0, math.floor(os.clock() - scriptStartedAt))
		local hh = math.floor(elapsed / 3600)
		local mm = math.floor((elapsed % 3600) / 60)
		local ss = elapsed % 60
		local job = game.JobId ~= "" and game.JobId or "STUDIO"
		if #job > 16 then job = string.sub(job,1,16).."..." end
		serverInfo.Text = string.format(
			"PLAYERS\n%d / %d\n\nSERVER UPTIME\n%02d:%02d:%02d\n\nPLACE ID\n%s\n\nJOB ID\n%s",
			#Players:GetPlayers(), Players.MaxPlayers, hh, mm, ss, tostring(game.PlaceId), job
		)
	end)
end

--========================================================
-- MOVEMENT
--========================================================

local speedToggle, infiniteToggle, flyToggle, highJumpToggle

do
	local p = pages.MOVEMENT
	pageTitle(p,"⚡","MOVEMENT",C.ORANGE)

	speedToggle = toggleCard(p,"SPEED","Increase your walk speed",UDim2.fromOffset(0,42))
	sliderCard(p,"SPEED VALUE",UDim2.fromOffset(0,118),16,150,speedValue,function(v)
		speedValue = v
		if state.speed and humanoid then humanoid.WalkSpeed = v end
	end)

	infiniteToggle = toggleCard(p,"INFINITE JUMP","Jump without limits",UDim2.fromOffset(0,216))
	flyToggle = toggleCard(p,"FLY [ F ]","Fly anywhere you want",UDim2.fromOffset(0,292))
	sliderCard(p,"FLY SPEED",UDim2.fromOffset(0,368),10,200,flySpeed,function(v)
		flySpeed = v
	end)

	highJumpToggle = toggleCard(p,"HIGH JUMP","Jump higher than normal",UDim2.fromOffset(490,42))
	sliderCard(p,"JUMP POWER",UDim2.fromOffset(490,118),50,200,jumpValue,function(v)
		jumpValue = v
		if state.highjump and humanoid then humanoid.JumpPower = v end
	end)

	local tip = panel(p,UDim2.fromOffset(455,170),UDim2.fromOffset(490,216),6)
	text(tip,"CONTROLS",UDim2.new(1,-24,0,28),UDim2.fromOffset(14,10),14,C.ORANGE,true).ZIndex = 7
	local tt = text(tip,"Fly movement:\nW A S D = direction\nSpace = up\nLeftCtrl = down\nF = Fly toggle",UDim2.new(1,-28,1,-48),UDim2.fromOffset(14,45),11,C.WHITE,false)
	tt.TextYAlignment = Enum.TextYAlignment.Top
	tt.ZIndex = 7
end

--========================================================
