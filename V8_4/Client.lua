-- 599 AREA V8.4 | Client bootstrap
local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V8_4/Client/"
local chunks = table.create(10)
for i = 0, 9 do
    local path = string.format("chunk_%02d.lua", i)
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. path)
    end)
    if not ok then
        error("[599 AREA V8.4] Failed to download " .. path .. ": " .. tostring(data))
    end
    chunks[#chunks + 1] = data
end
local source = table.concat(chunks)
local fn, err = loadstring(source)
if not fn then
    error("[599 AREA V8.4] Client compile failed: " .. tostring(err))
end
return fn()
