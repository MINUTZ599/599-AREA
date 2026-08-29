-- 599 AREA V8.5 - STABLE UNIQUE LOADER
local Players=game:GetService("Players")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")

local function status(msg,bad)
    local g=pg:FindFirstChild("AREA599_V85_DIAGNOSTIC")
    if not g then
        g=Instance.new("ScreenGui")
        g.Name="AREA599_V85_DIAGNOSTIC"
        g.ResetOnSpawn=false
        g.IgnoreGuiInset=true
        g.Parent=pg
        local t=Instance.new("TextLabel")
        t.Name="Status"
        t.AnchorPoint=Vector2.new(.5,0)
        t.Position=UDim2.new(.5,0,0,16)
        t.Size=UDim2.fromOffset(760,70)
        t.BackgroundColor3=Color3.fromRGB(12,12,12)
        t.BackgroundTransparency=.08
        t.Font=Enum.Font.GothamBold
        t.TextSize=16
        t.TextWrapped=true
        t.ZIndex=999999
        t.Parent=g
        local c=Instance.new("UICorner")
        c.CornerRadius=UDim.new(0,10)
        c.Parent=t
    end
    local t=g:FindFirstChild("Status")
    t.TextColor3=bad and Color3.fromRGB(255,80,80) or Color3.fromRGB(255,145,0)
    t.Text="599 AREA V8.5 | "..msg
end

local function fail(s)
    status(s,true)
    warn("[599 V8.5] "..s)
end

status("loading V8.4 base...",false)

local base="https://raw.githubusercontent.com/MINUTZ599/599-AREA/417965fea92cf2b472a48edea27f19de8b0e67b2/V8_4/Client/"
local c={}
for i=0,9 do
    local ok,s=pcall(function()
        return game:HttpGet(base..string.format("chunk_%02d.lua",i))
    end)
    if not ok or type(s)~="string" or #s==0 then
        return fail("BASE HTTP ERROR at chunk_"..string.format("%02d",i))
    end
    if i<9 then s=s:gsub("[\r\n]+$","") end
    if i==1 then s=s:gsub("^%s*=%s*","",1) end
    c[#c+1]=s
end

local fn,err=loadstring(table.concat(c))
if not fn then return fail("BASE COMPILE ERROR: "..tostring(err)) end
local ok,runerr=xpcall(fn,function(e) return tostring(e) end)
if not ok then return fail("BASE RUNTIME ERROR: "..tostring(runerr)) end

status("loading integrated Visuals addon...",false)
local ok2,addon=pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/d49c32a6c4a02410f1f8fdaf4309b8840f43f106/V8_5/Addon.lua")
end)
if not ok2 or type(addon)~="string" or #addon==0 then
    return fail("ADDON HTTP ERROR: "..tostring(addon))
end

local af,ae=loadstring(addon)
if not af then return fail("ADDON COMPILE ERROR: "..tostring(ae)) end
local ok3,re=xpcall(af,function(e) return tostring(e) end)
if not ok3 then return fail("ADDON RUNTIME ERROR: "..tostring(re)) end

status("loading Air Walk...",false)
local ok4,airwalk=pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/0c91e6a598281fa21c73aa20530fa52a4a5301ee/V8_5/AirWalk.lua")
end)
if not ok4 or type(airwalk)~="string" or #airwalk==0 then
    return fail("AIR WALK HTTP ERROR: "..tostring(airwalk))
end

local wf,we=loadstring(airwalk)
if not wf then return fail("AIR WALK COMPILE ERROR: "..tostring(we)) end
local ok5,wre=xpcall(wf,function(e) return tostring(e) end)
if not ok5 then return fail("AIR WALK RUNTIME ERROR: "..tostring(wre)) end

status("loaded successfully",false)
task.delay(2,function()
    local g=pg:FindFirstChild("AREA599_V85_DIAGNOSTIC")
    if g then g:Destroy() end
end)
