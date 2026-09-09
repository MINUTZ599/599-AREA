-- 599 AREA V9 PREVIEW - Mini Control Dock v23
-- ONLY changes minimize behavior/appearance. Leaves approved V22 UI untouched.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local gui = pg:WaitForChild("AREA599_V9_PREVIEW", 10)
if not gui then return end

local root = gui:FindFirstChild("Root")
if not root or not root:IsA("Frame") then return end

-- Find the existing top minimize button (the '-' button), but do not modify it.
local oldMin
for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("TextButton") and obj.Text == "-" and obj.AbsoluteSize.X >= 30 and obj.AbsoluteSize.X <= 45 then
        oldMin = obj
        break
    end
end
if not oldMin then return end

-- Transparent overlay captures minimize clicks so the old minimize code never fires.
local intercept = Instance.new("TextButton")
intercept.Name = "V23_MinimizeIntercept"
intercept.Size = oldMin.Size
intercept.Position = oldMin.Position
intercept.AnchorPoint = oldMin.AnchorPoint
intercept.BackgroundTransparency = 1
intercept.Text = ""
intercept.AutoButtonColor = false
intercept.ZIndex = oldMin.ZIndex + 20
intercept.Parent = oldMin.Parent

-- Mini control dock.
local dock = Instance.new("Frame")
dock.Name = "V23_MiniControlDock"
dock.AnchorPoint = Vector2.new(0.5,0)
dock.Position = UDim2.new(0.5,0,0,34)
dock.Size = UDim2.fromOffset(330,64)
dock.BackgroundColor3 = Color3.fromRGB(7,7,14)
dock.BorderSizePixel = 0
dock.Visible = false
dock.Active = true
dock.ZIndex = 500
dock.Parent = gui
Instance.new("UICorner",dock).CornerRadius = UDim.new(0,14)
local stroke = Instance.new("UIStroke",dock)
stroke.Color = Color3.fromRGB(170,72,255)
stroke.Thickness = 1.5
stroke.Transparency = 0.05

local glow = Instance.new("Frame")
glow.Size = UDim2.new(1,-18,0,2)
glow.Position = UDim2.new(0,9,1,-4)
glow.BackgroundColor3 = Color3.fromRGB(150,55,255)
glow.BorderSizePixel = 0
glow.ZIndex = 501
glow.Parent = dock
Instance.new("UICorner",glow).CornerRadius = UDim.new(1,0)

-- Reuse the already-loaded V22 top-left custom logo asset if available.
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.fromOffset(46,46)
logo.Position = UDim2.fromOffset(10,9)
logo.BackgroundColor3 = Color3.fromRGB(28,14,48)
logo.BorderSizePixel = 0
logo.ScaleType = Enum.ScaleType.Fit
logo.ZIndex = 502
logo.Parent = dock
Instance.new("UICorner",logo).CornerRadius = UDim.new(0,11)

for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("ImageLabel") and obj ~= logo and obj.AbsoluteSize.X >= 34 and obj.AbsoluteSize.X <= 55 and obj.AbsoluteSize.Y >= 34 and obj.AbsoluteSize.Y <= 55 then
        local p = obj.Parent
        if p and p:IsA("GuiObject") and p.AbsolutePosition.X < root.AbsolutePosition.X + 80 and p.AbsolutePosition.Y < root.AbsolutePosition.Y + 90 then
            if obj.Image and obj.Image ~= "" then
                logo.Image = obj.Image
                break
            end
        end
    end
end

local divider = Instance.new("Frame")
divider.Size = UDim2.fromOffset(1,36)
divider.Position = UDim2.fromOffset(65,14)
divider.BackgroundColor3 = Color3.fromRGB(77,56,103)
divider.BorderSizePixel = 0
divider.ZIndex = 502
divider.Parent = dock

local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(78,10)
title.Size = UDim2.fromOffset(120,24)
title.BackgroundTransparency = 1
title.Text = "599 AREA"
title.TextColor3 = Color3.fromRGB(250,248,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 502
title.Parent = dock

local sub = Instance.new("TextLabel")
sub.Position = UDim2.fromOffset(78,33)
sub.Size = UDim2.fromOffset(120,16)
sub.BackgroundTransparency = 1
sub.Text = "V9  •  MINIMIZED"
sub.TextColor3 = Color3.fromRGB(186,113,255)
sub.Font = Enum.Font.GothamSemibold
sub.TextSize = 8
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.ZIndex = 502
sub.Parent = dock

local function makeBtn(x,text,accent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(38,38)
    b.Position = UDim2.fromOffset(x,13)
    b.BackgroundColor3 = accent or Color3.fromRGB(20,17,31)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(250,247,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.AutoButtonColor = false
    b.ZIndex = 503
    b.Parent = dock
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
    local s = Instance.new("UIStroke",b)
    s.Color = Color3.fromRGB(112,67,160)
    s.Transparency = 0.45
    return b
end

local restore = makeBtn(204,"□")
local hide = makeBtn(246,"−")
local close = makeBtn(288,"×",Color3.fromRGB(47,14,25))

-- Tiny orb used by the dock's Hide control.
local orb = Instance.new("ImageButton")
orb.Name = "V23_HiddenOrb"
orb.AnchorPoint = Vector2.new(0.5,0)
orb.Position = UDim2.new(0.5,0,0,34)
orb.Size = UDim2.fromOffset(54,54)
orb.BackgroundColor3 = Color3.fromRGB(16,9,27)
orb.BorderSizePixel = 0
orb.Image = logo.Image
orb.ScaleType = Enum.ScaleType.Fit
orb.Visible = false
orb.Active = true
orb.ZIndex = 510
orb.Parent = gui
Instance.new("UICorner",orb).CornerRadius = UDim.new(1,0)
local os = Instance.new("UIStroke",orb)
os.Color = Color3.fromRGB(170,72,255)
os.Thickness = 1.6

local function smoothDrag(handle,target)
    local dragging = false
    local startInput, startPos, dragInput
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - startInput
            local desired = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            TweenService:Create(target,TweenInfo.new(0.08,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=desired}):Play()
        end
    end)
end
smoothDrag(dock,dock)
smoothDrag(orb,orb)

local function showDock()
    root.Visible = false
    orb.Visible = false
    dock.Visible = true
    dock.Size = UDim2.fromOffset(300,56)
    dock.BackgroundTransparency = 0.08
    TweenService:Create(dock,TweenInfo.new(0.16,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{
        Size = UDim2.fromOffset(330,64),
        BackgroundTransparency = 0
    }):Play()
end

local function restoreUI()
    dock.Visible = false
    orb.Visible = false
    root.Visible = true
end

intercept.MouseButton1Click:Connect(showDock)
restore.MouseButton1Click:Connect(restoreUI)

hide.MouseButton1Click:Connect(function()
    dock.Visible = false
    orb.Image = logo.Image
    orb.Visible = true
end)

orb.MouseButton1Click:Connect(function()
    orb.Visible = false
    dock.Visible = true
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
