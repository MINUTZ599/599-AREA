local Players=game:GetService("Players")
local gui=Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local customAsset=getcustomasset or getsynasset
if type(customAsset)~="function" then return end
local ok,asset=pcall(function() return customAsset("599area_v9_banner.jpg") end)
if not ok or not asset then return end
for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("ImageLabel") and tostring(obj.Image):find("126519323866401",1,true) then
        obj.Image=asset
        obj.ImageTransparency=0
        obj.ScaleType=Enum.ScaleType.Crop
        obj.Visible=true
        break
    end
end
