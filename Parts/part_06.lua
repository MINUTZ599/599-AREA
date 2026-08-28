-- UTILITY
--========================================================

local noclipToggle, godToggle
local saveBtn, tpSavedBtn, sitBtn, resetCharBtn

do
	local p = pages.UTILITY
	pageTitle(p,"🔧","UTILITY",C.ORANGE)

	noclipToggle = toggleCard(p,"NOCLIP [ N ]","Walk through objects",UDim2.fromOffset(0,42))
	godToggle = toggleCard(p,"GODMODE [ G ]","Local testing protection",UDim2.fromOffset(0,118))

	saveBtn = actionButton(p,"💾  SAVE POSITION",UDim2.fromOffset(0,210),UDim2.fromOffset(225,50),C.ORANGE)
	tpSavedBtn = actionButton(p,"📍  TELEPORT TO SAVED",UDim2.fromOffset(240,210),UDim2.fromOffset(225,50),C.RED)
	sitBtn = actionButton(p,"♿  SIT / UNSIT",UDim2.fromOffset(0,276),UDim2.fromOffset(225,50),C.PURPLE)
	resetCharBtn = actionButton(p,"☠  RESET CHARACTER",UDim2.fromOffset(240,276),UDim2.fromOffset(225,50),C.RED)

	local slots = panel(p,UDim2.fromOffset(455,200),UDim2.fromOffset(0,342),6)
	text(slots,"📌  POSITION SLOTS",UDim2.new(1,-24,0,28),UDim2.fromOffset(14,8),13,C.ORANGE,true).ZIndex = 7
	for i=1,5 do
		local y = 40 + (i-1)*30
		text(slots,"SLOT "..i,UDim2.fromOffset(75,26),UDim2.fromOffset(14,y),10,C.WHITE,true).ZIndex = 7
		local sb = actionButton(slots,"SAVE",UDim2.fromOffset(95,y),UDim2.fromOffset(145,26),C.GREEN)
		local tb = actionButton(slots,"TP",UDim2.fromOffset(250,y),UDim2.fromOffset(145,26),C.ORANGE)
		sb.MouseButton1Click:Connect(function() if rootPart then positionSlots[i]=rootPart.CFrame; notify("Slot "..i.." saved") end end)
		tb.MouseButton1Click:Connect(function() if rootPart and positionSlots[i] then rootPart.CFrame=positionSlots[i]+Vector3.new(0,3,0); notify("Teleported to slot "..i) else notify("Slot "..i.." empty") end end)
	end

	local k = panel(p,UDim2.fromOffset(455,284),UDim2.fromOffset(490,42),6)
	text(k,"UTILITY INFO",UDim2.new(1,-24,0,30),UDim2.fromOffset(14,10),15,C.ORANGE,true).ZIndex = 7
	local it = text(k,
		"• Save Position stores your current local CFrame.\n\n• Teleport To Saved returns your character to it.\n\n• Spectate and Teleport To Player are in PLAYER.\n\n• GodMode here is intended for local testing in your own game.",
		UDim2.new(1,-28,1,-56),UDim2.fromOffset(14,50),11,C.WHITE,false)
	it.TextWrapped = true
	it.TextYAlignment = Enum.TextYAlignment.Top
	it.ZIndex = 7
end

--========================================================
-- PLAYER
--========================================================

local searchBox, listFrame, listLayout
local selectedName, selectedUser, selectedAvatar
local spectateBtn, teleportPlayerBtn, prevPlayerBtn, nextPlayerBtn
local selectedStatsText

local function setSelected(target)
	selectedPlayer = target
	if not target then
		selectedName.Text = "No player selected"
		selectedUser.Text = ""
		selectedAvatar.Image = ""
		return
	end

	selectedName.Text = target.DisplayName
	selectedUser.Text = "@"..target.Name.."  •  UserId "..target.UserId

	task.spawn(function()
		local ok,img = pcall(function()
			return Players:GetUserThumbnailAsync(target.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
		end)
		if ok and selectedPlayer == target then selectedAvatar.Image = img end
	end)
end

local function rebuildPlayerList()
	if not listFrame then return end
	for _,v in ipairs(listFrame:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end

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

