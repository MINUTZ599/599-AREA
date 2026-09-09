-- 599 AREA V9 PREVIEW LOADER
local ok,src=pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client.lua?v=4")
end)
if not ok then
    warn("[599 V9 PREVIEW] HTTP ERROR: "..tostring(src))
    return
end
local fn,err=loadstring(src)
if not fn then
    warn("[599 V9 PREVIEW] COMPILE ERROR: "..tostring(err))
    return
end
local rok,re=xpcall(fn,function(e) return tostring(e) end)
if not rok then
    warn("[599 V9 PREVIEW] RUNTIME ERROR: "..tostring(re))
end
