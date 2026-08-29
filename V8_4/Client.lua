-- 599 AREA V8.4 | Direct Loader
local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V8_4/Client/"
local chunks = table.create(10)

local function fetchChunk(path)
    local lastErr
    for attempt = 1, 3 do
        local ok, data = pcall(function()
            return game:HttpGet(BASE .. path .. "?v=84&attempt=" .. attempt)
        end)
        if ok and type(data) == "string" and #data > 0 then
            return data
        end
        lastErr = data
        task.wait(0.15)
    end
    error("[599 AREA V8.4] Failed to download " .. path .. ": " .. tostring(lastErr))
end

for i = 0, 9 do
    local path = string.format("chunk_%02d.lua", i)
    chunks[#chunks + 1] = fetchChunk(path)
end

-- IMPORTANT: no separator. The chunk files are byte-perfect slices of the full V8.4 source.
local source = table.concat(chunks)
local fn, compileError = loadstring(source)
if not fn then
    error("[599 AREA V8.4] Compile error: " .. tostring(compileError))
end

local ok, runtimeError = pcall(fn)
if not ok then
    error("[599 AREA V8.4] Runtime error: " .. tostring(runtimeError))
end
