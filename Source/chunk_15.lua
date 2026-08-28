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
