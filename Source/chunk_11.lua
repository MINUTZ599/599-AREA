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
		for _,v in ipairs(character:GetDescendants()) do
			if v:IsA("BasePart") then noclipOriginal[v] = v.CanCollide end
		end
	end
	noclipConn = RunService.Stepped:Connect(function()
		if not state.noclip or not character then return end
		for _,v in ipairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				if noclipOriginal[v] == nil then noclipOriginal[v] = v.CanCollide end
				v.CanCollide = false
			end
		end
	end)
end

local function stopNoclip()
	if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
	for part,canCollide in pairs(noclipOriginal) do
