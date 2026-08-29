UserInputType.Touch then
		dragging = false
		miniDragging = false
		miniDragStart = nil
		miniStartPos = nil
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
	elseif input.KeyCode == KEY_KNOCKBACK then
		setKnockback(not state.knockback)
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
		end)
		statusText.Text = "FPS: "..fps.."\nPING: "..ping.." ms\nTIME: "..os.date("%H:%M:%S")
	end
end)

--========================================================
-- BACKGROUND LOAD CHECK
--========================================================

task.spawn(function()
	local ok = pcall(function()
		ContentProvider:PreloadAsync({bg})
	end)

	task.wait(0.4)

	if not ok or not bg.IsLoaded then
		notify("Background gagal dimuat: cek Asset ID / permission")
	else
		notify("599 AREA V8.4 MINUTZ loaded")
	end
end)

selectPage("DASHBOARD")
print("599 AREA V8.4 MINUTZ LOADED")
