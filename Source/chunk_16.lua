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
		notify("599 AREA V8.1 MINUTZ loaded")
	end
end)

selectPage("DASHBOARD")
print("599 AREA V8.1 MINUTZ LOADED")
