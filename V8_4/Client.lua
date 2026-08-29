-- 599 AREA V8.4 | Stable loader
-- Loads the complete V8.4 source from one raw GitHub file.
local URL = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V8_4/FullClient.lua"
local ok, source = pcall(function()
    return game:HttpGet(URL)
end)
if not ok then
    error("[599 AREA V8.4] Download failed: " .. tostring(source))
end
local fn, err = loadstring(source)
if not fn then
    error("[599 AREA V8.4] Compile failed: " .. tostring(err))
end
return fn()
