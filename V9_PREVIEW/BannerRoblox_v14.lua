-- 599 AREA V9 banner - Roblox asset ID v15
-- Only adjusts the Anime Dice banner image framing.
local Players=game:GetService("Players")
local gui=Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local NEW_IMAGE="rbxassetid://95794241567731"
local target=nil

for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("ImageLabel") then
        local img=tostring(obj.Image)
        if img:find("126519323866401",1,true) or img:find("95794241567731",1,true) then
            if obj.AbsoluteSize.X >= 250 and obj.AbsoluteSize.Y >= 70 then
                target=obj
                break
            end
        end
    end
end

if not target then
    local bestArea=0
    for _,obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("ImageLabel") then
            local w=obj.AbsoluteSize.X
            local h=obj.AbsoluteSize.Y
            if w>=250 and h>=70 and w>h*2 then
                local area=w*h
                if area>bestArea then
                    bestArea=area
                    target=obj
                end
            end
        end
    end
end

if target then
    target.Image=NEW_IMAGE
    target.ImageTransparency=0

    -- Source artwork is square. Crop a higher horizontal strip so both faces
    -- and upper bodies stay visible instead of Roblox centering on the legs.
    target.ImageRectOffset=Vector2.new(0,120)
    target.ImageRectSize=Vector2.new(1536,500)
    target.ScaleType=Enum.ScaleType.Stretch
end
