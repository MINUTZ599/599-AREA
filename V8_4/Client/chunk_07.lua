avedFov then
			cam.FieldOfView = freecamSavedFov
		end

		cam.CameraType = Enum.CameraType.Custom

		if humanoid then
			cam.CameraSubject = humanoid
		end
	end

	UIS.MouseBehavior = Enum.MouseBehavior.Default
	UIS.MouseIconEnabled = true
end

local function startFreecam()
	local cam = workspace.CurrentCamera
	if not cam or not humanoid or not rootPart then
		notify("Character belum siap")
		state.freecam = false
		if freecamToggle then setToggle(freecamToggle,false) end
		return
	end

	if freecamConn then
		freecamConn:Disconnect()
		freecamConn = nil
	end

	freecamSavedCFrame = cam.CFrame
	freecamSavedFov = cam.FieldOfView

	local look = cam.CFrame.LookVector
	freecamYaw = math.atan2(-look.X, -look.Z)
	freecamPitch = math.asin(math.clamp(look.Y, -1, 1))

	freezeCharacterForFreecam()

	cam.CameraType = Enum.CameraType.Scriptable
	cam.FieldOfView = freecamFov
	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
	UIS.MouseIconEnabled = false

	-- posisi camera berdiri sendiri; tidak lagi mengikuti character.
	local cameraPosition = cam.CFrame.Position

	freecamConn = RunService.RenderStepped:Connect(function(dt)
		if not state.freecam then return end

		local activeCam = workspace.CurrentCamera
		if not activeCam then return end

		local mouseDelta = UIS:GetMouseDelta()
		local sensitivity = freecamSensitivity / 100

		freecamYaw -= mouseDelta.X * sensitivity
		freecamPitch = math.clamp(
			freecamPitch - mouseDelta.Y * sensitivity,
			math.rad(-89),
			math.rad(89)
		)

		local rotation =
			CFrame.Angles(0, freecamYaw, 0)
			* CFrame.Angles(freecamPitch, 0, 0)

		local move = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += Vector3.new(0,0,-1) end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move += Vector3.new(0,0,1) end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move += Vector3.new(-1,0,0) end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += Vector3.new(1,0,0) end
		if UIS:IsKeyDown(Enum.KeyCode.Q) then move += Vector3.new(0,-1,0) end
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

		-- Extra safety: character tetap diam meski script lain mencoba menggerakkannya.
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