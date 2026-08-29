yro:Destroy(); bodyGyro = nil end
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
		if part and part.Parent then part.CanCollide = canCollide end
	end
	table.clear(noclipOriginal)
end

local function toggleNoclip()
	state.noclip = not state.noclip
	if state.noclip then startNoclip() else stopNoclip() end
	setToggle(noclipToggle,state.noclip)
	notify("NoClip "..(state.noclip and "ON" or "OFF"))
end

local function stopGod()
	if godConn then godConn:Disconnect(); godConn = nil end
	if humanoid then
		humanoid.MaxHealth = 100
		if humanoid.Health > 100 then humanoid.Health = 100 end
	end
end

local function startGod()
	if not humanoid then return end
	if godConn then godConn:Disconnect() end
	humanoid.MaxHealth = 1000000
	humanoid.Health = humanoid.MaxHealth
	godConn = humanoid.HealthChanged:Connect(function()
		if state.god and humanoid and humanoid.Health > 0 then
			humanoid.Health = humanoid.MaxHealth
		end
	end)
end

local function toggleGod()
	state.god = not state.god
	if state.god then startGod() else stopGod() end
	setToggle(godToggle,state.god)
	notify("GodMode Test "..(state.god and "ON" or "OFF"))
end

speedToggle.MouseButton1Click:Connect(toggleSpeed)
infiniteToggle.MouseButton1Click:Connect(toggleInfinite)
flyToggle.MouseButton1Click:Connect(toggleFly)
highJumpToggle.MouseButton1Click:Connect(toggleHighJump)
noclipToggle.MouseButton1Click:Connect(toggleNoclip)
godToggle.MouseButton1Click:Connect(toggleGod)

saveBtn.MouseButton1Click:Connect(function()
	if rootPart then
		savedPosition = rootPart.CFrame
		notify("Position saved")
	end
end)

tpSavedBtn.MouseButton1Click:Connect(function()
	if rootPart and savedPosition then
		rootPart.CFrame = savedPosition + Vector3.new(0,3,0)
		notify("Teleported to saved position")
	else
		notify("No saved position")
	end
end)

sitBtn.MouseButton1Click:Connect(function()
	if humanoid then humanoid.Sit = not humanoid.Sit end
end)

resetCharBtn.MouseButton1Click:Connect(function()
	if humanoid then humanoid.Health = 0 end
end)

--========================================================
-- PLAYER ACTIONS
--========================================================

local function stopSpectate()
	state.spectating = false
	local cam = workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Custom
	if humanoid then cam.CameraSubject = humanoid end
	notify("Spectate stopped")
end

spectateBtn.MouseButton1Click:Connect(function()
	if not selectedPlayer or not selectedPlayer.Character then
		notify("Select a player first")
		return
	end
	local h = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then
		workspace.CurrentCamera.CameraSubject = h
		state.spectating = true
		notify("Spectating "..selectedPlayer.Name)
	end
end)

teleportPlayerBtn.MouseButton1Click:Connect(function()
	if not selectedPlayer or not selectedPlayer.Character or not rootPart then
		notify("Select a player first")
		return
	end
	local tr = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
	if tr then
		rootPart.CFrame = tr.CFrame * CFrame.new(0,0,4)
		notify("Teleported to "..selectedPlayer.Name)
	end
end)

--========================================================
-- FREECAM V2
-- Character benar-benar diam saat camera bergerak.
--========================================================

local FREECAM_ACTION = "599_FREECAM_BLOCK_CHARACTER"

local function sinkCharacterControls()
	return Enum.ContextActionResult.Sink
end

local function freezeCharacterForFreecam()
	if not humanoid or not rootPart then return end

	freecamSaved.WalkSpeed = humanoid.WalkSpeed
	freecamSaved.JumpPower = humanoid.JumpPower
	freecamSaved.AutoRotate = humanoid.AutoRotate
	freecamSaved.RootAnchored = rootPart.Anchored

	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.AutoRotate = false

	-- Anchored memastikan karakter tidak ikut bergeser sama sekali.
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
		if freecamS