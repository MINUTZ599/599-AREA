-- 599 AREA | V8.4 COMPATIBLE STABLE LOADER
-- Uses the same proven loading path as the working build.

local URL = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/Main.lua"

local ok, source = pcall(function()
    return game:HttpGet(URL)
end)

if not ok then
    error("[599 AREA] Failed to download Main.lua: " .. tostring(source))
end

local fn, compileError = loadstring(source)
if not fn then
    error("[599 AREA] Failed to compile Main.lua: " .. tostring(compileError))
end

return fn()
