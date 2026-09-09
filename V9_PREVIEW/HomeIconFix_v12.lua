-- 599 AREA V9 PREVIEW Home icon restore v12
local Players = game:GetService("Players")
local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
local gui = pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local customAsset = getcustomasset or getsynasset
if type(writefile) ~= "function" or type(customAsset) ~= "function" then return end

local function b64decode(data)
    local alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data=string.gsub(data,'[^'..alphabet..'=]','')
    return (data:gsub('.',function(x)
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

local ok,src=pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconAssets_v10.lua?v=12")
end)
if not ok then return end
local fn=loadstring(src)
if not fn then return end
local assets=fn()
if type(assets)~="table" or type(assets.home)~="string" then return end

local fileName="599_v9_icon_home_v12.png"
local wrote=pcall(function() writefile(fileName,b64decode(assets.home)) end)
if not wrote then return end
local a,assetId=pcall(function() return customAsset(fileName) end)
if not a or not assetId then return end

for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("TextButton") then
        local isHome=false
        local oldTextIcon=nil
        local custom=nil
        for _,child in ipairs(obj:GetChildren()) do
            if child:IsA("TextLabel") and child.Text=="Home" then isHome=true end
            if child:IsA("TextLabel") and child.Position.X.Offset<=16 then oldTextIcon=child end
            if child:IsA("ImageLabel") and child.Name=="CustomIcon" then custom=child end
        end
        if isHome then
            if custom then
                custom.Image=assetId
                custom.ImageTransparency=0
                custom.Visible=true
            else
                local icon=Instance.new("ImageLabel")
                icon.Name="CustomIcon"
                icon.Position=oldTextIcon and oldTextIcon.Position or UDim2.fromOffset(8,5)
                icon.Size=oldTextIcon and oldTextIcon.Size or UDim2.fromOffset(34,34)
                icon.BackgroundColor3=oldTextIcon and oldTextIcon.BackgroundColor3 or Color3.fromRGB(25,19,42)
                icon.BackgroundTransparency=oldTextIcon and oldTextIcon.BackgroundTransparency or 0
                icon.BorderSizePixel=0
                icon.Image=assetId
                icon.ScaleType=Enum.ScaleType.Fit
                icon.Parent=obj
                local c=Instance.new("UICorner")
                c.CornerRadius=UDim.new(0,9)
                c.Parent=icon
            end
            if oldTextIcon then oldTextIcon.Visible=false end
            break
        end
    end
end
