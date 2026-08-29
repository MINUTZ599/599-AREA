
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
	if state.knockback then setKnockback(false) end
	notify("All features reset")
end

resetAllBtn.MouseButton1Click:Connect(resetAll)

--========================================================
-- MINIMIZE + DRAG
--========================================================

-- Compact futuristic launcher button (replaces old round 599 button)
local mini = Instance.new("TextButton")
mini.Name = "MiniLauncher"
mini.Size = UDim2.fromOffset(150,50)
mini.Position = UDim2.new(0,18,0.5,-25)
mini.BackgroundColor3 = Color3.fromRGB(10,10,13)
mini.AutoButtonColor = false
mini.Active = true
mini.Text = ""
mini.Visible = false
mini.ZIndex = 100
mini.Parent = gui
round(mini,10)
outline(mini,C.ORANGE,0.05,1.5)

-- dark metallic gradient
local miniGradient = Instance.new("UIGradient")
miniGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(28,28,34)),
    ColorSequenceKeypoint.new(0.55,Color3.fromRGB(12,12,16)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(5,5,8)),
})
miniGradient.Rotation = 18
miniGradient.Parent = mini

-- orange left accent rail
local miniRail = Instance.new("Frame")
miniRail.Size = UDim2.fromOffset(4,32)
miniRail.Position = UDim2.new(0,7,0.5,-16)
miniRail.BackgroundColor3 = C.ORANGE
miniRail.BorderSizePixel = 0
miniRail.ZIndex = 102
miniRail.Parent = mini
round(miniRail,2)

local railGlow = Instance.new("UIStroke")
railGlow.Color = C.ORANGE2
railGlow.Thickness = 2
railGlow.Transparency = 0.35
railGlow.Parent = miniRail

-- tiny tech chevrons
local chev = Instance.new("TextLabel")
chev.Size = UDim2.fromOffset(26,18)
chev.Position = UDim2.fromOffset(16,7)
chev.BackgroundTransparency = 1
chev.Text = ">>>"
chev.TextColor3 = C.ORANGE
chev.Font = Enum.Font.GothamBlack
chev.TextSize = 11
chev.TextXAlignment = Enum.TextXAlignment.Left
chev.ZIndex = 103
chev.Parent = mini

local miniTitle = Instance.new("TextLabel")
miniTitle.Size = UDim2.fromOffset(90,24)
miniTitle.Position = UDim2.fromOffset(43,5)
miniTitle.BackgroundTransparency = 1
miniTitle.Text = "599 AREA"
miniTitle.TextColor3 = C.WHITE
miniTitle.Font = Enum.Font.GothamBlack
miniTitle.TextSize = 15
miniTitle.TextXAlignment = Enum.TextXAlignment.Left
miniTitle.ZIndex = 103
miniTitle.Parent = mini

local miniSub = Instance.new("TextLabel")
miniSub.Size = UDim2.fromOffset(96,15)
miniSub.Position = UDim2.fromOffset(43,27)
miniSub.BackgroundTransparency = 1
miniSub.Text = "OPEN PANEL"
miniSub.TextColor3 = C.ORANGE
miniSub.Font = Enum.Font.GothamSemibold
miniSub.TextSize = 9
miniSub.TextXAlignment = Enum.TextXAlignment.Left
miniSub.ZIndex = 103
miniSub.Parent = mini

-- angled orange detail at right edge
local miniEdge = Instance.new("Frame")
miniEdge.Size = UDim2.fromOffset(10,10)
miniEdge.Position = UDim2.new(1,-17,0,8)
miniEdge.BackgroundColor3 = C.ORANGE
miniEdge.BorderSizePixel = 0
miniEdge.Rotation = 45
miniEdge.ZIndex = 103
miniEdge.Parent = mini

-- hover / touch feedback
mini.MouseEnter:Connect(function()
    TweenService:Create(mini,TweenInfo.new(0.14),{
        BackgroundColor3 = Color3.fromRGB(22,16,12),
        Size = UDim2.fromOffset(156,52)
    }):Play()
end)

mini.MouseLeave:Connect(function()
    TweenService:Create(mini,TweenInfo.new(0.14),{
        BackgroundColor3 = Color3.fromRGB(10,10,13),
        Size = UDim2.fromOffset(150,50)
    }):Play()
end)

local function hideGUI()
	viewport.Visible = false
	mini.Visible = true
end

local function showGUI()
	viewport.Visible = true
	mini.Visible = false
end

minBtn.MouseButton1Click:Connect(hideGUI)

-- draggable mini launcher (mouse + touch)
local miniDragging = false
local miniDragStart = nil
local miniStartPos = nil
local miniDidDrag = false
local MINI_DRAG_THRESHOLD = 6

mini.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		miniDragging = true
		miniDidDrag = false
		miniDragStart = input.Position
		miniStartPos = mini.Position
	end
end)

mini.MouseButton1Click:Connect(function()
	-- A drag should only move the launcher, not open the panel.
	if miniDidDrag then
		miniDidDrag = false
		return
	end
	showGUI()
end)

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
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			local d = input.Position - dragStart
			viewport.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + d.X,startPos.Y.Scale,startPos.Y.Offset + d.Y)
		end

		if miniDragging and miniDragStart and miniStartPos then
			local d = input.Position - miniDragStart
			if math.abs(d.X) >= MINI_DRAG_THRESHOLD or math.abs(d.Y) >= MINI_DRAG_THRESHOLD then
				miniDidDrag = true
			end
			mini.Position = UDim2.new(
				miniStartPos.X.Scale, miniStartPos.X.Offset + d.X,
				miniStartPos.Y.Scale, miniStartPos.Y.Offset + d.Y
			)
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.