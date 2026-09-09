-- 599 AREA V9 PREVIEW v35 - HOME BANNER EXACT
-- HOME ONLY. Replaces only the V34 HOME hero artwork with the exact supplied banner.
local Players=game:GetService("Players")
local HttpService=game:GetService("HttpService")
local pg=Players.LocalPlayer:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local home=gui:FindFirstChild("HOME",true)
if not home then return end
local scroll=home:FindFirstChild("V34_HOME")
if not scroll then return end

-- Find the hero frame and its existing V34 image.
local hero
local image
for _,c in ipairs(scroll:GetChildren()) do
    if c:IsA("Frame") and c.Position.Y.Offset==0 and c.Size.Y.Offset==188 then
        hero=c
        break
    end
end
if not hero then return end
for _,d in ipairs(hero:GetChildren()) do
    if d:IsA("ImageLabel") then image=d break end
end
if not image then return end

-- Base64 decoder so the exact image can be stored in GitHub and loaded by the executor.
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function b64decode(data)
    data=data:gsub('[^'..b..'=]','')
    return (data:gsub('.',function(x)
        if x=='=' then return '' end
        local r,f='',(b:find(x,1,true)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(x)
        if #x~=8 then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local function resolveAsset()
    local ok,data=pcall(function()
        return game:HttpGet('https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeBanner_v35.b64?raw=35')
    end)
    if not ok or not data or #data<1000 then return nil end
    if type(writefile)~='function' then return nil end
    local bytes=b64decode(data)
    if #bytes<1000 then return nil end
    local path='599_AREA_HOME_V35.jpg'
    pcall(function() writefile(path,bytes) end)
    local fn
    if type(getcustomasset)=='function' then fn=getcustomasset
    elseif type(getsynasset)=='function' then fn=getsynasset end
    if not fn then return nil end
    local ok2,res=pcall(fn,path)
    if ok2 then return res end
    return nil
end

local custom=resolveAsset()
if custom then
    image.Image=custom
else
    warn('[599 V35] custom HOME banner unavailable; keeping V34 fallback image')
    return
end

-- Make the supplied banner itself the full hero. Remove V34 overlay labels/shade only.
for _,c in ipairs(hero:GetChildren()) do
    if c~=image and (c:IsA('TextLabel') or (c:IsA('Frame') and c.BackgroundTransparency<1)) then
        c.Visible=false
    end
end
image.Position=UDim2.fromScale(0,0)
image.Size=UDim2.fromScale(1,1)
image.ImageTransparency=0
image.ScaleType=Enum.ScaleType.Crop
image.ZIndex=1
hero.BackgroundColor3=Color3.fromRGB(7,5,14)

print('[599 V35] exact HOME banner applied')