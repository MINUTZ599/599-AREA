-- 599 AREA V8.5 - STABLE UNIQUE LOADER
local Players=game:GetService("Players")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local function status(msg,bad)
 local g=pg:FindFirstChild("AREA599_V85_DIAGNOSTIC")
 if not g then g=Instance.new("ScreenGui");g.Name="AREA599_V85_DIAGNOSTIC";g.ResetOnSpawn=false;g.IgnoreGuiInset=true;g.Parent=pg;local t=Instance.new("TextLabel");t.Name="Status";t.AnchorPoint=Vector2.new(.5,0);t.Position=UDim2.new(.5,0,0,16);t.Size=UDim2.fromOffset(760,70);t.BackgroundColor3=Color3.fromRGB(12,12,12);t.BackgroundTransparency=.08;t.Font=Enum.Font.GothamBold;t.TextSize=16;t.TextWrapped=true;t.ZIndex=999999;t.Parent=g;local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,10);c.Parent=t end
 local t=g:FindFirstChild("Status");t.TextColor3=bad and Color3.fromRGB(255,80,80) or Color3.fromRGB(255,145,0);t.Text="599 AREA V8.5 | "..msg
end
local function fail(s)status(s,true);warn("[599 V8.5] "..s)end
local function loadAddon(label,url,prefix)
 status("loading "..label.."...",false)
 local ok,src=pcall(function()return game:HttpGet(url)end);if not ok or type(src)~="string" or #src==0 then return false,fail(prefix.." HTTP ERROR: "..tostring(src))end
 local fn,err=loadstring(src);if not fn then return false,fail(prefix.." COMPILE ERROR: "..tostring(err))end
 local rok,re=xpcall(fn,function(e)return tostring(e)end);if not rok then return false,fail(prefix.." RUNTIME ERROR: "..tostring(re))end
 return true
end
status("loading V8.4 base...",false)
local base="https://raw.githubusercontent.com/MINUTZ599/599-AREA/417965fea92cf2b472a48edea27f19de8b0e67b2/V8_4/Client/";local c={}
for i=0,9 do local ok,s=pcall(function()return game:HttpGet(base..string.format("chunk_%02d.lua",i))end);if not ok or type(s)~="string" or #s==0 then return fail("BASE HTTP ERROR at chunk_"..string.format("%02d",i))end;if i<9 then s=s:gsub("[\r\n]+$","")end;if i==1 then s=s:gsub("^%s*=%s*","",1)end;c[#c+1]=s end
local fn,err=loadstring(table.concat(c));if not fn then return fail("BASE COMPILE ERROR: "..tostring(err))end;local ok,runerr=xpcall(fn,function(e)return tostring(e)end);if not ok then return fail("BASE RUNTIME ERROR: "..tostring(runerr))end
if not loadAddon("integrated Visuals addon","https://raw.githubusercontent.com/MINUTZ599/599-AREA/d49c32a6c4a02410f1f8fdaf4309b8840f43f106/V8_5/Addon.lua","ADDON") then return end
if not loadAddon("Air Walk + Height Control","https://raw.githubusercontent.com/MINUTZ599/599-AREA/89e564071765913da32b12c727b5cc8990fa6882/V8_5/AirWalk.lua","AIR WALK") then return end
if not loadAddon("World Skybox Manager","https://raw.githubusercontent.com/MINUTZ599/599-AREA/5c98d8a3e0ead5d1ab25da63d4ec9a0c4ecc7831/V8_5/SkyboxWorld.lua","SKYBOX") then return end
status("loaded successfully",false);task.delay(2,function()local g=pg:FindFirstChild("AREA599_V85_DIAGNOSTIC");if g then g:Destroy()end end)
