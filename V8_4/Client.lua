-- 599 AREA V8.4 | PINNED DIRECT LOADER
-- Pinned to the V8.4 fix commit so Xeno/GitHub cache cannot serve the old build.
local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/417965fea92cf2b472a48edea27f19de8b0e67b2/V8_4/Client/"
local chunks = {}

for i = 0, 9 do
    local path = string.format("chunk_%02d.lua", i)
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. path)
    end)
    if not ok then
        error("[599 AREA V8.4] HTTP ERROR " .. path .. ": " .. tostring(data))
    end
    if type(data) ~= "string" or #data == 0 then
        error("[599 AREA V8.4] EMPTY CHUNK " .. path)
    end
    chunks[#chunks + 1] = data
end

local source = table.concat(chunks)
local fn, compileError = loadstring(source)
if not fn then
    error("[599 AREA V8.4] COMPILE ERROR: " .. tostring(compileError))
end

local ok, runtimeError = xpcall(fn, function(err)
    return tostring(err) .. "\n" .. debug.traceback()
end)
if not ok then
    error("[599 AREA V8.4] RUNTIME ERROR: " .. tostring(runtimeError))
end
