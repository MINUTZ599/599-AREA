-- 599 AREA V9 banner framing v18
local Players=game:GetService("Players")
local gui=Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local NEW_IMAGE="rbxassetid://95794241567731"
local target=nil
for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("ImageLabel") then
        local img=tostring(obj.Image)
        if (img:find("126519323866401",1,true) or img:find("95794241567731",1,true)) and obj.AbsoluteSize.X>=250 then
            target=obj
            break
        end
    end
end
if not target then return end

local parent=target.Parent
if parent and parent:IsA("GuiObject") then
    parent.ClipsDescendants=true
end

target.Image=NEW_IMAGE
target.ImageTransparency=0
target.ImageRectOffset=Vector2.new(0,0)
target.ImageRectSize=Vector2.new(0,0)
target.ScaleType=Enum.ScaleType.Fit

-- Manual framing: use a larger square image and clip it inside the hero banner.
-- This keeps both heads visible and gives a medium zoom similar to the reference.
target.AnchorPoint=Vector2.new(1,0)
target.Size=UDim2.fromOffset(360,360)
target.Position=UDim2.new(1,0,0,-58)
