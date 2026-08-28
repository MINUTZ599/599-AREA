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
