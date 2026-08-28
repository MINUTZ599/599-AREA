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

