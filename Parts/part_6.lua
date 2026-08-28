		if UIS:IsKeyDown(Enum.KeyCode.E) then move += Vector3.new(0,1,0) end

		local boost = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 3 or 1
		local currentSpeed = freecamSpeed * boost

		local worldMove =
			rotation.RightVector * move.X
			+ Vector3.new(0,1,0) * move.Y
			+ rotation.LookVector * (-move.Z)

		if worldMove.Magnitude > 0 then
			worldMove = worldMove.Unit
			cameraPosition += worldMove * currentSpeed * dt
		end

		activeCam.CFrame = CFrame.new(cameraPosition) * rotation

		if rootPart then
			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero
		end
	end)
end

local function toggleFreecam()
	state.freecam = not state.freecam

	if state.freecam then
		if state.spectating then
			state.spectating = false
		end
		startFreecam()
	else
		stopFreecam()
	end

	if freecamToggle then
		setToggle(freecamToggle,state.freecam)
	end

	notify("Freecam "..(state.freecam and "ON" or "OFF").." | Speed "..tostring(freecamSpeed))
end

if freecamToggle then
	freecamToggle.MouseButton1Click:Connect(toggleFreecam)
end

--========================================================
-- LOCAL VISUALS
--========================================================

local function clearVisuals()
	for _,v in ipairs(espFolder:GetChildren()) do v:Destroy() end
	for _,v in ipairs(tracerFolder:GetChildren()) do v:Destroy() end
	for _,p in ipairs(Players:GetPlayers()) do
		if p.Character then
			local h = p.Character:FindFirstChild("_599Highlight")
			if h then h:Destroy() end
		end
	end
end

local function refreshVisuals()
	clearVisuals()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= lp and p.Character then
			if state.esp then
				local head = p.Character:FindFirstChild("Head")
				if head then
					local bb = Instance.new("BillboardGui")
					bb.Name = "_599ESP"
					bb.Size = UDim2.fromOffset(180,34)
					bb.StudsOffset = Vector3.new(0,2.8,0)
					bb.AlwaysOnTop = true
					bb.Adornee = head
					bb:SetAttribute("TargetUserId",p.UserId)
					bb.Parent = espFolder

					local l = Instance.new("TextLabel")
					l.Size = UDim2.fromScale(1,1)
					l.BackgroundTransparency = 1
					l.Text = p.DisplayName.."  @"..p.Name.." | loading..."
					l.TextColor3 = C.ORANGE
					l.TextStrokeTransparency = 0.2
					l.Font = Enum.Font.GothamBold
					l.TextSize = 11
					l.Parent = bb
				end
			end

			if state.highlight then
				local hl = Instance.new("Highlight")
				hl.Name = "_599Highlight"
				hl.FillColor = C.ORANGE
				hl.FillTransparency = 0.72
				hl.OutlineColor = C.ORANGE2
				hl.OutlineTransparency = 0
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Adornee = p.Character
				hl.Parent = p.Character
			end
		end
	end
end

local function getTracerLine(userId)
	local name = "Tracer_"..tostring(userId)
	local line = tracerFolder:FindFirstChild(name)
	if not line then
		line = Instance.new("Frame")
		line.Name = name
		line.AnchorPoint = Vector2.new(0.5,0.5)
		line.BorderSizePixel = 0
		line.BackgroundColor3 = C.ORANGE
		line.BackgroundTransparency = 0.08
		line.ZIndex = 95
		line.Parent = tracerFolder

		local grad = Instance.new("UIGradient")
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,Color3.fromRGB(255,190,55)),
			ColorSequenceKeypoint.new(1,C.ORANGE),
		})
		grad.Parent = line
	end
	return line
end

RunService.RenderStepped:Connect(function()
	if not state.tracer then
		for _,v in ipairs(tracerFolder:GetChildren()) do
			if v:IsA("Frame") then v.Visible = false end
		end
		return
	end

	local cam = workspace.CurrentCamera
	if not cam then return end
	local vp = cam.ViewportSize
	local origin = Vector2.new(vp.X/2, vp.Y-34)
	local alive = {}

	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character then
			local target = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if target and hum and hum.Health > 0 then
				local screenPos, onScreen = cam:WorldToViewportPoint(target.Position)
				local line = getTracerLine(plr.UserId)
				alive[line.Name] = true
				if onScreen and screenPos.Z > 0 then
					local dest = Vector2.new(screenPos.X,screenPos.Y)
					local delta = dest-origin
					local dist = delta.Magnitude
					line.Size = UDim2.fromOffset(dist,2)
					line.Position = UDim2.fromOffset((origin.X+dest.X)/2,(origin.Y+dest.Y)/2)
					line.Rotation = math.deg(math.atan2(delta.Y,delta.X))
					line.Visible = true
				else
					line.Visible = false
				end
			end
		end
	end

	for _,v in ipairs(tracerFolder:GetChildren()) do
		if v:IsA("Frame") and not alive[v.Name] then v:Destroy() end
	end
end)

RunService.RenderStepped:Connect(function()
	if not state.esp then return end
	for _,bb in ipairs(espFolder:GetChildren()) do
		if bb:IsA("BillboardGui") then
			local uid = bb:GetAttribute("TargetUserId")
			local plr = uid and Players:GetPlayerByUserId(uid)
			local lbl = bb:FindFirstChildOfClass("TextLabel")
			local ch = plr and plr.Character
			local h = ch and ch:FindFirstChildOfClass("Humanoid")
			local r = ch and ch:FindFirstChild("HumanoidRootPart")
			if lbl and plr and h and r and rootPart then
				lbl.Text = string.format("%s  @%s | %d HP | %d studs",plr.DisplayName,plr.Name,math.floor(h.Health),math.floor((r.Position-rootPart.Position).Magnitude))
			end
		end
	end
end)

espToggle.MouseButton1Click:Connect(function()
	state.esp = not state.esp
	setToggle(espToggle,state.esp)
	refreshVisuals()
end)

tracerToggle.MouseButton1Click:Connect(function()
	state.tracer = not state.tracer
	setToggle(tracerToggle,state.tracer)
	if not state.tracer then
		for _,v in ipairs(tracerFolder:GetChildren()) do v:Destroy() end
	end
	notify("Player Line / Tracer "..(state.tracer and "ON" or "OFF"))
end)

highlightToggle.MouseButton1Click:Connect(function()
	state.highlight = not state.highlight
	setToggle(highlightToggle,state.highlight)
	refreshVisuals()
end)

fullbrightToggle.MouseButton1Click:Connect(function()
	state.fullbright = not state.fullbright
	setToggle(fullbrightToggle,state.fullbright)

	if state.fullbright then
		Lighting.Brightness = 3
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.Ambient = Color3.fromRGB(180,180,180)
		Lighting.OutdoorAmbient = Color3.fromRGB(180,180,180)
	else
		for k,v in pairs(oldLighting) do Lighting[k] = v end
	end
end)

Players.PlayerAdded:Connect(function() task.wait(0.5); refreshVisuals() end)
Players.PlayerRemoving:Connect(function() task.wait(); refreshVisuals() end)

dayBtn.MouseButton1Click:Connect(function()
	Lighting.ClockTime = 12
	notify("Local time: day")
end)

nightBtn.MouseButton1Click:Connect(function()
	Lighting.ClockTime = 0
	notify("Local time: night")
end)

local function resetAll()
	state.speed = false
	state.infinite = false
	state.fly = false
	state.noclip = false
	state.highjump = false
	state.god = false
	state.esp = false
	state.tracer = false
	state.highlight = false
	state.fullbright = false
	state.freecam = false

	stopFly()
	stopNoclip()
	stopGod()
	stopFreecam()
	clearVisuals()

	if humanoid then
		humanoid.WalkSpeed = DEFAULT_SPEED
		humanoid.JumpPower = DEFAULT_JUMP
		humanoid.PlatformStand = false
	end

	workspace.Gravity = DEFAULT_GRAVITY
	for k,v in pairs(oldLighting) do Lighting[k] = v end

	setToggle(speedToggle,false)
	setToggle(infiniteToggle,false)
	setToggle(flyToggle,false)
	setToggle(highJumpToggle,false)
	setToggle(noclipToggle,false)
	setToggle(godToggle,false)
	setToggle(espToggle,false)
	setToggle(tracerToggle,false)
	setToggle(highlightToggle,false)
	setToggle(fullbrightToggle,false)
	if freecamToggle then setToggle(freecamToggle,false) end

	if state.spectating then stopSpectate() end
	notify("All features reset")
end

resetAllBtn.MouseButton1Click:Connect(resetAll)

--========================================================
-- MINIMIZE + DRAG
--========================================================

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(62,62)
mini.Position = UDim2.new(0,18,0.5,-31)
mini.BackgroundColor3 = C.PANEL2
mini.Text = "599"
mini.TextColor3 = C.ORANGE
mini.Font = Enum.Font.GothamBlack
mini.TextSize = 18
mini.Visible = false
mini.ZIndex = 100
mini.Parent = gui
round(mini,31)
outline(mini,C.ORANGE,0,2)

local function hideGUI()
	viewport.Visible = false
	mini.Visible = true
end

local function showGUI()
	viewport.Visible = true
	mini.Visible = false
end

minBtn.MouseButton1Click:Connect(hideGUI)
mini.MouseButton1Click:Connect(showGUI)

local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = viewport.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		viewport.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + d.X,startPos.Y.Scale,startPos.Y.Offset + d.Y)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

--========================================================
-- KEYBINDS
--========================================================

UIS.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.KeyCode == KEY_GUI then
		if viewport.Visible then hideGUI() else showGUI() end
	elseif input.KeyCode == KEY_FLY then
		toggleFly()
	elseif input.KeyCode == KEY_NOCLIP then
		toggleNoclip()
	elseif input.KeyCode == KEY_GOD then
		toggleGod()
	elseif input.KeyCode == KEY_SPECTATE and state.spectating then
		stopSpectate()
	elseif input.KeyCode == KEY_FREECAM then
		toggleFreecam()
	end
end)

--========================================================
-- FPS / PING / TIME
--========================================================

local frames, elapsed, fps = 0,0,0
RunService.RenderStepped:Connect(function(dt)
	frames += 1
	elapsed += dt
	if elapsed >= 1 then
		fps = frames
		frames = 0
		elapsed = 0
	end
end)

task.spawn(function()
	while gui.Parent do
		task.wait(0.5)
		local ping = 0
		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
