-- 599 AREA V9 - HEADER LOGO ONLY v22
-- Changes ONLY the top-left 599 badge. No layout/tab/profile/function edits.
local Players=game:GetService("Players")
local gui=Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local root=gui:FindFirstChild("Root")
if not root then return end
local sidebar=root:FindFirstChildWhichIsA("Frame")
if not sidebar then return end

-- Find original 44x44 logo box near top-left.
local logoBox
for _,o in ipairs(sidebar:GetChildren()) do
    if o:IsA("Frame") and o.Position.X.Offset==15 and o.Position.Y.Offset==15 and o.Size.X.Offset==44 and o.Size.Y.Offset==44 then
        logoBox=o break
    end
end
if not logoBox then return end

-- Remove only old "599" text inside the badge.
for _,o in ipairs(logoBox:GetChildren()) do
    if o:IsA("TextLabel") and o.Text=="599" then o:Destroy() end
end

logoBox.BackgroundColor3=Color3.fromRGB(25,13,44)

local icon=Instance.new("Frame")
icon.Name="DollarNetworkIcon"
icon.Size=UDim2.fromScale(1,1)
icon.BackgroundTransparency=1
icon.Parent=logoBox

local purple=Color3.fromRGB(210,82,255)
local purple2=Color3.fromRGB(157,55,255)

local ring=Instance.new("Frame")
ring.AnchorPoint=Vector2.new(.5,.5)
ring.Position=UDim2.fromScale(.5,.5)
ring.Size=UDim2.fromOffset(25,25)
ring.BackgroundTransparency=1
ring.Parent=icon
Instance.new("UICorner",ring).CornerRadius=UDim.new(1,0)
local stroke=Instance.new("UIStroke",ring)
stroke.Color=purple
stroke.Thickness=2.2

local dollar=Instance.new("TextLabel")
dollar.AnchorPoint=Vector2.new(.5,.5)
dollar.Position=UDim2.fromScale(.5,.5)
dollar.Size=UDim2.fromOffset(22,28)
dollar.BackgroundTransparency=1
dollar.Text="$"
dollar.TextColor3=purple
dollar.Font=Enum.Font.GothamBlack
dollar.TextSize=20
dollar.Parent=icon

local center=Vector2.new(22,22)
local nodes={{22,3},{22,41},{3,22},{41,22},{8,8},{36,8},{8,36},{36,36}}
for i,p in ipairs(nodes) do
    local x,y=p[1],p[2]
    local dx,dy=x-center.X,y-center.Y
    local len=math.sqrt(dx*dx+dy*dy)
    local line=Instance.new("Frame")
    line.AnchorPoint=Vector2.new(0,.5)
    line.Position=UDim2.fromOffset(center.X,center.Y)
    line.Size=UDim2.fromOffset(math.max(1,len-13),2)
    line.Rotation=math.deg(math.atan2(dy,dx))
    line.BackgroundColor3=purple2
    line.BorderSizePixel=0
    line.Parent=icon
    Instance.new("UICorner",line).CornerRadius=UDim.new(1,0)

    local dot=Instance.new("Frame")
    dot.AnchorPoint=Vector2.new(.5,.5)
    dot.Position=UDim2.fromOffset(x,y)
    dot.Size=UDim2.fromOffset(6,6)
    dot.BackgroundColor3=(i%2==0) and purple2 or purple
    dot.BorderSizePixel=0
    dot.Parent=icon
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
end
