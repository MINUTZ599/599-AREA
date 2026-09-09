-- 599 AREA V9 banner - Roblox asset ID
local Players=game:GetService("Players")
local gui=Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local NEW_IMAGE="rbxassetid://95794241567731"
local target=nil

-- Prefer the existing hero image on the Anime Dice page.
for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("ImageLabel") then
        local img=tostring(obj.Image)
        if img:find("126519323866401",1,true) then
            target=obj
            break
        end
    end
end

-- Fallback: choose the largest wide ImageLabel, never the small player profile image.
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
    target.ScaleType=Enum.ScaleType.Crop
end
