	rootPart.AssemblyLinearVelocity = Vector3.zero
	rootPart.AssemblyAngularVelocity = Vector3.zero
	rootPart.Anchored = true

	-- Blok input movement agar kontrol Roblox tidak ikut menerima WASD.
	ContextActionService:BindActionAtPriority(
		FREECAM_ACTION,
		sinkCharacterControls,
		false,
		Enum.ContextActionPriority.High.Value + 100,
		Enum.PlayerActions.CharacterForward,
		Enum.PlayerActions.CharacterBackward,
		Enum.PlayerActions.CharacterLeft,
		Enum.PlayerActions.CharacterRight,
		Enum.PlayerActions.CharacterJump
	)
end

local function restoreCharacterAfterFreecam()
	ContextActionService:UnbindAction(FREECAM_ACTION)

	if humanoid then
		humanoid.WalkSpeed = freecamSaved.WalkSpeed or (state.speed and speedValue or DEFAULT_SPEED)
		humanoid.JumpPower = freecamSaved.JumpPower or (state.highjump and jumpValue or DEFAULT_JUMP)

		if freecamSaved.AutoRotate ~= nil then
			humanoid.AutoRotate = freecamSaved.AutoRotate
		else
			humanoid.AutoRotate = true
		end
	end

	if rootPart then
		if freecamSaved.RootAnchored ~= nil then
			rootPart.Anchored = freecamSaved.RootAnchored
		else
			rootPart.Anchored = false
		end

		rootPart.AssemblyLinearVelocity = Vector3.zero
		rootPart.AssemblyAngularVelocity = Vector3.zero
	end
end

local function stopFreecam()
	if freecamConn then
		freecamConn:Disconnect()
		freecamConn = nil
	end

	restoreCharacterAfterFreecam()

	local cam = workspace.CurrentCamera
	if cam then
		if freecamSavedFov then
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
