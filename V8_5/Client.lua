--========================================================
-- 599 AREA V8.5 - MINUTZ TRACKER EDITION
-- V8.4 stable base + Click TP + Waypoints + Tracker+ + ESP+
--========================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local playerGui = lp and lp:WaitForChild("PlayerGui")

local diagGui, diagLabel
local function showStatus(msg, isError)
    pcall(function()
        if not playerGui then return end
        if not diagGui then
            diagGui = Instance.new("ScreenGui")
            diagGui.Name = "AREA599_V85_DIAGNOSTIC"
            diagGui.ResetOnSpawn = false
            diagGui.IgnoreGuiInset = true
            diagGui.Parent = playerGui

            diagLabel = Instance.new("TextLabel")
            diagLabel.AnchorPoint = Vector2.new(0.5,0)
            diagLabel.Position = UDim2.new(0.5,0,0,16)
            diagLabel.Size = UDim2.fromOffset(760,70)
            diagLabel.BackgroundColor3 = Color3.fromRGB(12,12,12)
            diagLabel.BackgroundTransparency = 0.08
            diagLabel.BorderSizePixel = 0
            diagLabel.Font = Enum.Font.GothamBold
            diagLabel.TextSize = 16
            diagLabel.TextWrapped = true
            diagLabel.TextColor3 = Color3.fromRGB(255,145,0)
            diagLabel.ZIndex = 999999
            diagLabel.Parent = diagGui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,10)
            corner.Parent = diagLabel
        end
        diagLabel.TextColor3 = isError and Color3.fromRGB(255,80,80) or Color3.fromRGB(255,145,0)
        diagLabel.Text = "599 AREA V8.5 | " .. tostring(msg)
    end)
end

local function fail(msg)
    showStatus(msg, true)
    warn("[599 AREA V8.5] " .. tostring(msg))
    return nil
end

showStatus("loading V8.4 stable base...", false)

local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/417965fea92cf2b472a48edea27f19de8b0e67b2/V8_4/Client/"
local chunks = {}

for i = 0, 9 do
    local path = string.format("chunk_%02d.lua", i)
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. path)
    end)
    if not ok then return fail("HTTP ERROR " .. path .. ": " .. tostring(data)) end
    if type(data) ~= "string" or #data == 0 then return fail("EMPTY CHUNK " .. path) end

    if i < 9 then
        data = data:gsub("[\r\n]+$", "")
    end
    if i == 1 then
        data = data:gsub("^%s*=%s*", "", 1)
    end
    chunks[#chunks + 1] = data
end

local source = table.concat(chunks)

local ADDON = [==[

--========================================================
-- V8.5 TRACKER EDITION ADDON
--========================================================

do
    local mouse = lp:GetMouse()
    local v85ClickTP = false
    local v85Waypoints = {}
    local v85Esp = {
        box = false,
        skeleton = false,
        health = false,
        name = false,
    }

    -- Add a ninth tab without changing the original V8.4 layout.
    local tab = Instance.new("TextButton")
    tab.Name = "TRACKER+_TAB"
    tab.Size = UDim2.new(1,-18,0,48)
    tab.Position = UDim2.fromOffset(9,449)
    tab.BackgroundColor3 = C.PANEL2
    tab.Text = "◎   TRACKER+"
    tab.TextColor3 = C.MUTED
    tab.Font = Enum.Font.GothamSemibold
    tab.TextSize = 12
    tab.TextXAlignment = Enum.TextXAlignment.Left
    tab.AutoButtonColor = false
    tab.ZIndex = 7
    tab.Parent = sidebar
    round(tab,8)
    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingLeft = UDim.new(0,14)
    tabPad.Parent = tab

    local trackerPage = Instance.new("Frame")
    trackerPage.Name = "TRACKER+"
    trackerPage.Size = UDim2.fromScale(1,1)
    trackerPage.BackgroundTransparency = 1
    trackerPage.Visible = false
    trackerPage.ZIndex = 5
    trackerPage.Parent = content

    tabs["TRACKER+"] = tab
    pages["TRACKER+"] = trackerPage
    tab.MouseButton1Click:Connect(function()
        selectPage("TRACKER+")
    end)

    pageTitle(trackerPage,"◎","TRACKER+",C.ORANGE)

    --====================================================
    -- CLICK TELEPORT
    --====================================================
    local clickTpToggle = toggleCard(
        trackerPage,
        "CLICK TELEPORT [ T ]",
        "Click a point in the world to move your character there",
        UDim2.fromOffset(0,42)
    )

    local function setClickTP(on)
        v85ClickTP = on
        setToggle(clickTpToggle,on)
        notify(on and "Click Teleport ON" or "Click Teleport OFF")
    end

    clickTpToggle.MouseButton1Click:Connect(function()
        setClickTP(not v85ClickTP)
    end)

    UIS.InputBegan:Connect(function(input,gpe)
        if UIS:GetFocusedTextBox() then return end
        if input.KeyCode == Enum.KeyCode.T then
            setClickTP(not v85ClickTP)
            return
        end
        if gpe or not v85ClickTP then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if rootPart and humanoid and humanoid.Health > 0 and mouse.Target then
                local hit = mouse.Hit.Position
                local _,yaw,_ = rootPart.CFrame:ToOrientation()
                rootPart.CFrame = CFrame.new(hit + Vector3.new(0,3,0)) * CFrame.Angles(0,yaw,0)
            end
        end
    end)

    --====================================================
    -- PLAYER TRACKER+
    --====================================================
    local trackerPanel = panel(trackerPage,UDim2.fromOffset(455,154),UDim2.fromOffset(0,118),6)
    text(trackerPanel,"🎯  PLAYER TRACKER+",UDim2.new(1,-24,0,26),UDim2.fromOffset(14,10),13,C.ORANGE,true).ZIndex = 7
    local trackerName = text(trackerPanel,"TARGET: No player selected",UDim2.new(1,-28,0,24),UDim2.fromOffset(14,44),11,C.WHITE,true)
    trackerName.ZIndex = 7
    local trackerStats = text(trackerPanel,"HP: --   DIST: --\nPOS: --\nSTATUS: --",UDim2.new(1,-28,0,72),UDim2.fromOffset(14,72),10,C.MUTED,false)
    trackerStats.TextYAlignment = Enum.TextYAlignment.Top
    trackerStats.ZIndex = 7

    --====================================================
    -- WAYPOINT MANAGER
    --====================================================
    local waypointPanel = panel(trackerPage,UDim2.fromOffset(455,260),UDim2.fromOffset(0,286),6)
    text(waypointPanel,"📍  WAYPOINT MANAGER",UDim2.new(1,-24,0,26),UDim2.fromOffset(14,10),13,C.ORANGE,true).ZIndex = 7

    for i = 1,5 do
        local y = 42 + (i-1)*40
        local slotText = text(waypointPanel,"WP "..i.."  EMPTY",UDim2.fromOffset(150,30),UDim2.fromOffset(14,y),10,C.MUTED,true)
        slotText.ZIndex = 7
        local save = actionButton(waypointPanel,"SAVE",UDim2.fromOffset(180,y),UDim2.fromOffset(115,30),C.GREEN)
        local tp = actionButton(waypointPanel,"TP",UDim2.fromOffset(307,y),UDim2.fromOffset(115,30),C.ORANGE)

        save.MouseButton1Click:Connect(function()
            if rootPart then
                v85Waypoints[i] = rootPart.CFrame
                local p = rootPart.Position
                slotText.Text = string.format("WP %d  %d,%d,%d",i,p.X,p.Y,p.Z)
                slotText.TextColor3 = C.WHITE
                notify("Waypoint "..i.." saved")
            end
        end)

        tp.MouseButton1Click:Connect(function()
            local cf = v85Waypoints[i]
            if rootPart and cf then
                rootPart.CFrame = cf + Vector3.new(0,3,0)
                notify("Teleported to waypoint "..i)
            else
                notify("Waypoint "..i.." empty")
            end
        end)
    end

    --====================================================
    -- ESP+ UI
    --====================================================
    local boxToggle = toggleCard(trackerPage,"BOX ESP","2D box around visible players",UDim2.fromOffset(490,42))
    local skeletonToggle = toggleCard(trackerPage,"SKELETON ESP","Draw local character skeleton",UDim2.fromOffset(490,118))
    local healthToggle = toggleCard(trackerPage,"HEALTH BAR","Show target health beside box",UDim2.fromOffset(490,194))
    local nameToggle = toggleCard(trackerPage,"NAME + DISTANCE","Show name and distance above player",UDim2.fromOffset(490,270))

    local info = panel(trackerPage,UDim2.fromOffset(455,198),UDim2.fromOffset(490,346),6)
    text(info,"V8.5 VISUAL ENGINE",UDim2.new(1,-24,0,28),UDim2.fromOffset(14,10),13,C.ORANGE,true).ZIndex = 7
    local infoText = text(info,
        "ESP+ is rendered locally with Roblox GUI objects.\n\nPLAYER TRACKER+ follows the player currently selected in the PLAYER tab.\n\nT toggles Click Teleport. Waypoints remain stored for this session.",
        UDim2.new(1,-28,1,-52),UDim2.fromOffset(14,48),10,C.WHITE,false)
    infoText.TextWrapped = true
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.ZIndex = 7

    local function hookToggle(button,key,label)
        button.MouseButton1Click:Connect(function()
            v85Esp[key] = not v85Esp[key]
            setToggle(button,v85Esp[key])
            notify(label..(v85Esp[key] and " ON" or " OFF"))
        end)
    end
    hookToggle(boxToggle,"box","Box ESP")
    hookToggle(skeletonToggle,"skeleton","Skeleton ESP")
    hookToggle(healthToggle,"health","Health Bar")
    hookToggle(nameToggle,"name","Name + Distance")

    --====================================================
    -- ESP+ RENDERER
    --====================================================
    local oldOverlay = lp.PlayerGui:FindFirstChild("AREA599_V85_ESP")
    if oldOverlay then oldOverlay:Destroy() end

    local overlay = Instance.new("ScreenGui")
    overlay.Name = "AREA599_V85_ESP"
    overlay.ResetOnSpawn = false
    overlay.IgnoreGuiInset = true
    overlay.DisplayOrder = 9998
    overlay.Parent = lp.PlayerGui

    local visuals = {}

    local skeletonPairs = {
        {"Head","UpperTorso"},{"Head","Torso"},
        {"UpperTorso","LowerTorso"},{"Torso","HumanoidRootPart"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
        {"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"},
    }

    local function newLine()
        local f = Instance.new("Frame")
        f.AnchorPoint = Vector2.new(0.5,0.5)
        f.BackgroundColor3 = C.ORANGE2
        f.BorderSizePixel = 0
        f.Visible = false
        f.ZIndex = 40
        f.Parent = overlay
        return f
    end

    local function createVisual(plr)
        if visuals[plr] then return visuals[plr] end

        local box = Instance.new("Frame")
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 0
        box.Visible = false
        box.ZIndex = 35
        box.Parent = overlay
        local stroke = Instance.new("UIStroke")
        stroke.Color = C.ORANGE
        stroke.Thickness = 1.5
        stroke.Parent = box

        local name = Instance.new("TextLabel")
        name.AnchorPoint = Vector2.new(0.5,1)
        name.BackgroundTransparency = 1
        name.TextColor3 = C.WHITE
        name.TextStrokeColor3 = Color3.new(0,0,0)
        name.TextStrokeTransparency = 0.2
        name.Font = Enum.Font.GothamBold
        name.TextSize = 12
        name.TextXAlignment = Enum.TextXAlignment.Center
        name.Visible = false
        name.ZIndex = 42
        name.Parent = overlay

        local hpBack = Instance.new("Frame")
        hpBack.BackgroundColor3 = Color3.fromRGB(30,30,34)
        hpBack.BorderSizePixel = 0
        hpBack.Visible = false
        hpBack.ZIndex = 36
        hpBack.Parent = overlay

        local hpFill = Instance.new("Frame")
        hpFill.AnchorPoint = Vector2.new(0,1)
        hpFill.Position = UDim2.fromScale(0,1)
        hpFill.Size = UDim2.fromScale(1,1)
        hpFill.BackgroundColor3 = C.GREEN
        hpFill.BorderSizePixel = 0
        hpFill.ZIndex = 37
        hpFill.Parent = hpBack

        local lines = {}
        for i = 1,#skeletonPairs do
            lines[i] = newLine()
        end

        local v = {box=box,name=name,hpBack=hpBack,hpFill=hpFill,lines=lines}
        visuals[plr] = v
        return v
    end

    local function hideVisual(v)
        v.box.Visible = false
        v.name.Visible = false
        v.hpBack.Visible = false
        for _,line in ipairs(v.lines) do line.Visible = false end
    end

    local function destroyVisual(plr)
        local v = visuals[plr]
        if not v then return end
        pcall(function() v.box:Destroy() end)
        pcall(function() v.name:Destroy() end)
        pcall(function() v.hpBack:Destroy() end)
        for _,line in ipairs(v.lines) do pcall(function() line:Destroy() end) end
        visuals[plr] = nil
    end

    local function drawLine(frame,a,b)
        local dx,dy = b.X-a.X,b.Y-a.Y
        local len = math.sqrt(dx*dx + dy*dy)
        if len < 1 then frame.Visible = false return end
        frame.Size = UDim2.fromOffset(len,2)
        frame.Position = UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2)
        frame.Rotation = math.deg(math.atan2(dy,dx))
        frame.Visible = true
    end

    local function screenBounds(char)
        local ok,cf,size = pcall(function()
            local c,s = char:GetBoundingBox()
            return c,s
        end)
        if not ok or not cf or not size then return nil end

        local minX,minY = math.huge,math.huge
        local maxX,maxY = -math.huge,-math.huge
        local any = false
        for x = -1,1,2 do
            for y = -1,1,2 do
                for z = -1,1,2 do
                    local world = (cf * CFrame.new(size.X*x/2,size.Y*y/2,size.Z*z/2)).Position
                    local p,on = camera:WorldToViewportPoint(world)
                    if p.Z > 0 then
                        any = true
                        minX = math.min(minX,p.X); maxX = math.max(maxX,p.X)
                        minY = math.min(minY,p.Y); maxY = math.max(maxY,p.Y)
                    end
                end
            end
        end
        if not any then return nil end
        return minX,minY,maxX,maxY
    end

    Players.PlayerRemoving:Connect(destroyVisual)

    RunService.RenderStepped:Connect(function()
        -- Tracker text follows the selection from the original PLAYER tab.
        local target = selectedPlayer
        local tch = target and target.Character
        local th = tch and tch:FindFirstChildOfClass("Humanoid")
        local tr = tch and tch:FindFirstChild("HumanoidRootPart")
        if target then
            trackerName.Text = "TARGET: "..target.DisplayName.."  @"..target.Name
            if th and tr and rootPart then
                local dist = (tr.Position-rootPart.Position).Magnitude
                trackerStats.Text = string.format(
                    "HP: %d/%d   DIST: %d studs\nPOS: %d, %d, %d\nSTATUS: %s",
                    math.floor(th.Health),math.floor(th.MaxHealth),math.floor(dist),
                    math.floor(tr.Position.X),math.floor(tr.Position.Y),math.floor(tr.Position.Z),
                    th.Health > 0 and "ALIVE" or "DEAD"
                )
            else
                trackerStats.Text = "HP: --   DIST: --\nPOS: --\nSTATUS: CHARACTER NOT READY"
            end
        else
            trackerName.Text = "TARGET: No player selected"
            trackerStats.Text = "HP: --   DIST: --\nPOS: --\nSTATUS: --"
        end

        local espActive = v85Esp.box or v85Esp.skeleton or v85Esp.health or v85Esp.name
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp then
                local v = createVisual(plr)
                local ch = plr.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if not espActive or not ch or not hum or not hrp or hum.Health <= 0 then
                    hideVisual(v)
                else
                    local rootScreen,onScreen = camera:WorldToViewportPoint(hrp.Position)
                    if not onScreen or rootScreen.Z <= 0 then
                        hideVisual(v)
                    else
                        local minX,minY,maxX,maxY = screenBounds(ch)
                        if minX then
                            local w = math.max(18,maxX-minX)
                            local h = math.max(30,maxY-minY)
                            v.box.Position = UDim2.fromOffset(minX,minY)
                            v.box.Size = UDim2.fromOffset(w,h)
                            v.box.Visible = v85Esp.box

                            local dist = rootPart and math.floor((hrp.Position-rootPart.Position).Magnitude) or 0
                            v.name.Text = plr.DisplayName.."  ["..dist.."m]"
                            v.name.Position = UDim2.fromOffset((minX+maxX)/2,minY-4)
                            v.name.Size = UDim2.fromOffset(math.max(120,w+60),20)
                            v.name.Visible = v85Esp.name

                            v.hpBack.Position = UDim2.fromOffset(minX-7,minY)
                            v.hpBack.Size = UDim2.fromOffset(4,h)
                            local hpPct = math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
                            v.hpFill.Size = UDim2.new(1,0,hpPct,0)
                            v.hpBack.Visible = v85Esp.health
                        else
                            v.box.Visible = false
                            v.name.Visible = false
                            v.hpBack.Visible = false
                        end

                        if v85Esp.skeleton then
                            for i,pair in ipairs(skeletonPairs) do
                                local a = ch:FindFirstChild(pair[1])
                                local b = ch:FindFirstChild(pair[2])
                                if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
                                    local pa,ona = camera:WorldToViewportPoint(a.Position)
                                    local pb,onb = camera:WorldToViewportPoint(b.Position)
                                    if ona and onb and pa.Z > 0 and pb.Z > 0 then
                                        drawLine(v.lines[i],Vector2.new(pa.X,pa.Y),Vector2.new(pb.X,pb.Y))
                                    else
                                        v.lines[i].Visible = false
                                    end
                                else
                                    v.lines[i].Visible = false
                                end
                            end
                        else
                            for _,line in ipairs(v.lines) do line.Visible = false end
                        end
                    end
                end
            end
        end
    end)
end

]==]

source = source .. ADDON

showStatus("compiling V8.5...", false)
local fn, compileError = loadstring(source)
if not fn then return fail("COMPILE ERROR: " .. tostring(compileError)) end

showStatus("starting TRACKER EDITION...", false)
local ok, runtimeError = xpcall(fn, function(err)
    local tb = ""
    pcall(function() tb = debug.traceback() end)
    return tostring(err) .. (tb ~= "" and ("\n" .. tb) or "")
end)
if not ok then return fail("RUNTIME ERROR: " .. tostring(runtimeError)) end

showStatus("V8.5 loaded successfully", false)
task.delay(2, function()
    pcall(function() if diagGui then diagGui:Destroy() end end)
end)
