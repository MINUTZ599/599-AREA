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
