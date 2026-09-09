-- 599 AREA V9 profile artwork patch
local Players = game:GetService("Players")
local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
local gui = pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local ok,data = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/ProfileImage_v11.b64?v=11")
end)
if not ok or not data or #data < 100 then return end

local function decode64(s)
    if crypt then
        if type(crypt.base64decode)=="function" then
            local a,b=pcall(crypt.base64decode,s); if a then return b end
        end
        if crypt.base64 and type(crypt.base64.decode)=="function" then
            local a,b=pcall(crypt.base64.decode,s); if a then return b end
        end
    end
    if syn and syn.crypt and syn.crypt.base64 and type(syn.crypt.base64.decode)=="function" then
        local a,b=pcall(syn.crypt.base64.decode,s); if a then return b end
    end
    return nil
end

if type(writefile)~="function" or type(getcustomasset)~="function" then return end
local bytes=decode64(data)
if not bytes then return end
local file="599area_v9_profile.jpg"
local wrote=pcall(writefile,file,bytes)
if not wrote then return end
local a,asset=pcall(getcustomasset,file)
if not a or not asset then return end

-- Replace only the old circular player/profile picture in the bottom-left card.
local best=nil
for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("ImageLabel") then
        local sx=obj.Size.X.Offset
        local sy=obj.Size.Y.Offset
        if sx>=30 and sx<=60 and sy>=30 and sy<=60 then
            best=obj
            break
        end
    end
end
if best then
    best.Image=asset
    best.ImageTransparency=0
    best.ScaleType=Enum.ScaleType.Crop
end
