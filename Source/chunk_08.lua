	local q = string.lower(searchBox.Text or "")

	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= lp then
			local combined = string.lower(p.Name.." "..p.DisplayName)
			if q == "" or string.find(combined,q,1,true) then
				local row = Instance.new("TextButton")
				row.Size = UDim2.new(1,-8,0,48)
				row.BackgroundColor3 = C.PANEL2
				row.Text = p.DisplayName.."   @"..p.Name
				row.TextColor3 = C.WHITE
				row.Font = Enum.Font.GothamSemibold
				row.TextSize = 11
				row.TextXAlignment = Enum.TextXAlignment.Left
				row.AutoButtonColor = false
				row.Parent = listFrame
				round(row,7)
				local pad = Instance.new("UIPadding")
				pad.PaddingLeft = UDim.new(0,12)
				pad.Parent = row
				row.MouseButton1Click:Connect(function() setSelected(p) end)
			end
		end
	end

	task.defer(function()
		listFrame.CanvasSize = UDim2.fromOffset(0,listLayout.AbsoluteContentSize.Y+8)
	end)
end

do
	local p = pages.PLAYER
	pageTitle(p,"👤","PLAYER",C.PURPLE)

	local left = panel(p,UDim2.fromOffset(555,510),UDim2.fromOffset(0,42),6)
	local right = panel(p,UDim2.fromOffset(390,510),UDim2.fromOffset(572,42),6)

	searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(1,-24,0,42)
	searchBox.Position = UDim2.fromOffset(12,12)
	searchBox.BackgroundColor3 = C.PANEL2
	searchBox.Text = ""
	searchBox.PlaceholderText = "Search player..."
	searchBox.PlaceholderColor3 = C.MUTED
	searchBox.TextColor3 = C.WHITE
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextSize = 12
	searchBox.ClearTextOnFocus = false
	searchBox.Parent = left
	round(searchBox,8)
	outline(searchBox,C.PURPLE,0.5,1)

	listFrame = Instance.new("ScrollingFrame")
	listFrame.Size = UDim2.new(1,-24,1,-72)
	listFrame.Position = UDim2.fromOffset(12,62)
	listFrame.BackgroundTransparency = 1
	listFrame.BorderSizePixel = 0
	listFrame.ScrollBarThickness = 3
	listFrame.ScrollBarImageColor3 = C.PURPLE
	listFrame.CanvasSize = UDim2.new()
	listFrame.Parent = left

	listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0,5)
	listLayout.Parent = listFrame

	text(right,"PLAYER INFO",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),15,C.PURPLE,true).ZIndex = 7

	selectedAvatar = Instance.new("ImageLabel")
	selectedAvatar.Size = UDim2.fromOffset(94,94)
	selectedAvatar.Position = UDim2.fromOffset(18,58)
	selectedAvatar.BackgroundColor3 = C.PANEL2
	selectedAvatar.BorderSizePixel = 0
	selectedAvatar.Parent = right
	round(selectedAvatar,47)
	outline(selectedAvatar,C.PURPLE,0.2,1)

	selectedName = text(right,"No player selected",UDim2.new(1,-145,0,30),UDim2.fromOffset(132,65),16,C.WHITE,true)
	selectedName.ZIndex = 7
	selectedUser = text(right,"",UDim2.new(1,-145,0,48),UDim2.fromOffset(132,98),10,C.MUTED,false)
	selectedUser.ZIndex = 7

	spectateBtn = actionButton(right,"👁  SPECTATE",UDim2.fromOffset(18,190),UDim2.fromOffset(170,48),C.PURPLE)
	teleportPlayerBtn = actionButton(right,"📍  TELEPORT",UDim2.fromOffset(202,190),UDim2.fromOffset(170,48),C.RED)
	prevPlayerBtn = actionButton(right,"◀  PREV",UDim2.fromOffset(18,248),UDim2.fromOffset(170,42),C.BLUE)
	nextPlayerBtn = actionButton(right,"NEXT  ▶",UDim2.fromOffset(202,248),UDim2.fromOffset(170,42),C.BLUE)
	selectedStatsText = text(right,"HEALTH: --   DIST: --",UDim2.new(1,-36,0,24),UDim2.fromOffset(18,300),10,C.ORANGE,true)
	selectedStatsText.ZIndex = 7

	local pinfo = text(right,
		"Search & inspect players in real time.\n\nPREV / NEXT quickly changes target.\n\nSPECTATE changes only your camera.\n\nTELEPORT moves only your own character.",
		UDim2.new(1,-36,0,160),UDim2.fromOffset(18,336),11,C.WHITE,false)
	pinfo.TextWrapped = true
	pinfo.TextYAlignment = Enum.TextYAlignment.Top
	pinfo.ZIndex = 7

	searchBox:GetPropertyChangedSignal("Text"):Connect(rebuildPlayerList)
	rebuildPlayerList()
end

