-- 599 AREA V8.1 - MINUTZ TRACER EDITION
-- Main bootstrap: joins source chunks and executes them in order.

local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/Source/"
local source = table.create(17)

for i = 0, 16 do
    local path = string.format("chunk_%02d.lua", i)
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. path)
    end)

    if not ok then
        error("[599 AREA] Failed to download " .. path .. ": " .. tostring(data))
    end

    source[#source + 1] = data
end

local fullSource = table.concat(source)
local fn, compileError = loadstring(fullSource)

if not fn then
    error("[599 AREA] Failed to compile Main source: " .. tostring(compileError))
end

return fn()
