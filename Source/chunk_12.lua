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
