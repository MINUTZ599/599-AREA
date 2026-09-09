-- 599 AREA V9 PREVIEW banner patch v12
-- Replaces ONLY the Anime Dice hero/banner image.

local Players = game:GetService("Players")
local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
local gui = pg:WaitForChild("AREA599_V9_PREVIEW", 10)
if not gui then return end

local customAsset = getcustomasset or getsynasset
if type(writefile) ~= "function" or type(customAsset) ~= "function" then
    warn("[599 V9 BANNER] writefile/getcustomasset unsupported")
    return
end

local ok, data = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/ProfileImage_v11.b64?v=12")
end)
if not ok or type(data) ~= "string" or #data < 100 then return end

local function b64decode(s)
    local alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    s=string.gsub(s,'[^'..alphabet..'=]','')
    return (s:gsub('.',function(x)
        if x=='=' then return '' end
        local r,f='',(alphabet:find(x,1,true)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(x)
        if #x~=8 then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local bytes = b64decode(data)
local fileName = "599area_v9_banner.jpg"
local wrote = pcall(function() writefile(fileName, bytes) end)
if not wrote then return end
local assetOk, assetId = pcall(function() return customAsset(fileName) end)
if not assetOk or not assetId then return end

-- Find the large ImageLabel used by the Anime Dice hero banner.
local target
for _, obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("ImageLabel") then
        local sx = obj.Size.X.Offset
        local sy = obj.Size.Y.Offset
        if sx >= 300 and sy >= 90 and sy <= 160 then
            target = obj
            break
        end
    end
end

if target then
    target.Image = assetId
    target.ImageTransparency = 0
    target.ScaleType = Enum.ScaleType.Crop
end
