-- 599 AREA V9 banner framing v16
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

target.Image=NEW_IMAGE
target.ImageTransparency=0
-- Reset ImageRect: Roblox asset IDs are not guaranteed to use source-pixel dimensions.
target.ImageRectOffset=Vector2.new(0,0)
target.ImageRectSize=Vector2.new(0,0)
-- Show the complete uploaded artwork instead of center-cropping it.
target.ScaleType=Enum.ScaleType.Fit
