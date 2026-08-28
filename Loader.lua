-- 599 AREA | Official Loader by MINUTZ
local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/"
local ok, source = pcall(function()
    return game:HttpGet(BASE .. "Main.lua")
end)

if not ok then
    error("[599 AREA] Failed to download Main.lua: " .. tostring(source))
end

local fn, compileError = loadstring(source)
if not fn then
    error("[599 AREA] Failed to compile Main.lua: " .. tostring(compileError))
end

return fn()
