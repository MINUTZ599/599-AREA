-- 599 AREA V9 PREVIEW v26 - PLAYER TRACKER BRIDGE
-- Replaces the V25 placeholder with a real Neon Glow tracker toggle.
local Players=game:GetService("Players")
local RS=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local page=gui:FindFirstChild("VISUALS",true)
if not page then return end
local holder=page:FindFirstChild("V25_VISUALS")
if not holder then return end

local PURPLE=Color3.fromRGB(138,61,255)
local PURPLE2=Color3.fromRGB(191,100,255)
local WHITE=Color3.fromRGB(245,243,255)
local MUTED=Color3.fromRGB(146,140,170)
local CARD=Color3.fromRGB(14,14,27)
local trackerOn=false

for _,d in ipairs(holder:GetDescendants()) do
    if d:IsA("TextLabel") and d.Text=="PLAYER TRACKER" then
        local p=d.Parent
        if p then p:Destroy() end
        break
    end
end

local f=Instance.new("Frame")
f.Name="V26_PLAYER_TRACKER"
f.Size=UDim2.new(.5,-26,0,70)
f.Position=UDim2.new(.5,6,0,450)
f.BackgroundColor3=CARD
f.BorderSizePixel=0
f.Parent=holder
Instance.new("UICorner",f).CornerRadius=UDim.new(0,11)
local fs=Instance.new("UIStroke",f);fs.Color=Color3.fromRGB(68,48,102);fs.Transparency=.35

local t=Instance.new("TextLabel");t.Position=UDim2.fromOffset(14,10);t.Size=UDim2.new(1,-110,0,20);t.BackgroundTransparency=1;t.Text="PLAYER TRACKER";t.TextColor3=WHITE;t.Font=Enum.Font.GothamBold;t.TextSize=11;t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=f
local d=Instance.new("TextLabel");d.Position=UDim2.fromOffset(14,34);d.Size=UDim2.new(1,-110,0,18);d.BackgroundTransparency=1;d.Text="Track target selected in PLAYER";d.TextColor3=MUTED;d.Font=Enum.Font.Gotham;d.TextSize=8;d.TextXAlignment=Enum.TextXAlignment.Left;d.Parent=f
local sw=Instance.new("TextButton");sw.Size=UDim2.fromOffset(72,32);sw.Position=UDim2.new(1,-88,.5,-16);sw.BackgroundColor3=Color3.fromRGB(15,15,29);sw.Text="";sw.AutoButtonColor=false;sw.Parent=f;Instance.new("UICorner",sw).CornerRadius=UDim.new(1,0)
local ss=Instance.new("UIStroke",sw);ss.Color=Color3.fromRGB(80,75,110);ss.Thickness=1.3
local knob=Instance.new("Frame");knob.Size=UDim2.fromOffset(24,24);knob.Position=UDim2.fromOffset(4,4);knob.BackgroundColor3=Color3.fromRGB(150,150,178);knob.BorderSizePixel=0;knob.Parent=sw;Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

local trackerHighlight=nil
local trackerBillboard=nil
local trackerLine=nil
local overlay=pg:FindFirstChild("AREA599_V25_VISUAL_OVERLAY")
if overlay then
    trackerLine=Instance.new("Frame")
    trackerLine.AnchorPoint=Vector2.new(.5,.5)
    trackerLine.BackgroundColor3=PURPLE2
    trackerLine.BorderSizePixel=0
    trackerLine.Visible=false
    trackerLine.ZIndex=60
    trackerLine.Parent=overlay
end

local function clearTargetVisuals()
    if trackerHighlight then trackerHighlight:Destroy();trackerHighlight=nil end
    if trackerBillboard then trackerBillboard:Destroy();trackerBillboard=nil end
    if trackerLine then trackerLine.Visible=false end
end
local function render(v)
    trackerOn=v
    TweenService:Create(knob,TweenInfo.new(.16),{Position=v and UDim2.fromOffset(44,4) or UDim2.fromOffset(4,4),BackgroundColor3=v and Color3.fromRGB(250,240,255) or Color3.fromRGB(150,150,178)}):Play()
    TweenService:Create(sw,TweenInfo.new(.16),{BackgroundColor3=v and Color3.fromRGB(89,26,173) or Color3.fromRGB(15,15,29)}):Play()
    ss.Color=v and PURPLE2 or Color3.fromRGB(80,75,110)
    ss.Thickness=v and 2 or 1.3
    if not v then clearTargetVisuals() end
end
sw.MouseButton1Click:Connect(function() render(not trackerOn) end)

local lastTarget=nil
local function drawLine(line,a,b)
    if not line then return end
    local dx,dy=b.X-a.X,b.Y-a.Y
    local len=math.sqrt(dx*dx+dy*dy)
    if len<1 then line.Visible=false return end
    line.Size=UDim2.fromOffset(len,2)
    line.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2)
    line.Rotation=math.deg(math.atan2(dy,dx))
    line.Visible=true
end

RS.RenderStepped:Connect(function()
    if not trackerOn then return end
    local target=_G.AREA599_SELECTED_PLAYER
    if target~=lastTarget then
        clearTargetVisuals()
        lastTarget=target
    end
    local ch=target and target.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    local hum=ch and ch:FindFirstChildOfClass("Humanoid")
    if not ch or not root or not hum or hum.Health<=0 then
        clearTargetVisuals()
        return
    end
    if not trackerHighlight or trackerHighlight.Parent~=ch then
        if trackerHighlight then trackerHighlight:Destroy() end
        trackerHighlight=Instance.new("Highlight")
        trackerHighlight.Name="_599V26TrackerHighlight"
        trackerHighlight.FillColor=PURPLE
        trackerHighlight.FillTransparency=.35
        trackerHighlight.OutlineColor=PURPLE2
        trackerHighlight.OutlineTransparency=0
        trackerHighlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        trackerHighlight.Parent=ch
    end
    local head=ch:FindFirstChild("Head") or root
    if not trackerBillboard or trackerBillboard.Parent~=head then
        if trackerBillboard then trackerBillboard:Destroy() end
        trackerBillboard=Instance.new("BillboardGui")
        trackerBillboard.Name="_599V26TrackerBillboard"
        trackerBillboard.Size=UDim2.fromOffset(220,42)
        trackerBillboard.StudsOffset=Vector3.new(0,3.4,0)
        trackerBillboard.AlwaysOnTop=true
        trackerBillboard.Parent=head
        local tx=Instance.new("TextLabel");tx.Name="TrackerText";tx.Size=UDim2.fromScale(1,1);tx.BackgroundTransparency=1;tx.TextColor3=PURPLE2;tx.TextStrokeTransparency=.25;tx.Font=Enum.Font.GothamBold;tx.TextSize=13;tx.Parent=trackerBillboard
    end
    local myr=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local dist=myr and math.floor((root.Position-myr.Position).Magnitude) or 0
    local tx=trackerBillboard:FindFirstChild("TrackerText")
    if tx then tx.Text="TRACKING  "..target.DisplayName.."  ["..dist.."m]" end
    local cam=workspace.CurrentCamera
    if cam and trackerLine then
        local pt,on=cam:WorldToViewportPoint(root.Position)
        if on and pt.Z>0 then
            drawLine(trackerLine,Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y-18),Vector2.new(pt.X,pt.Y))
        else trackerLine.Visible=false end
    end
end)
