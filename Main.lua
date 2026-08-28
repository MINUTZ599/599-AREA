-- 599 AREA V8.1 | Main bootstrap by MINUTZ
local BASE = "https://raw.githubusercontent.com/yudamaulanakece-lab/599-AREA/main/Parts/"
local parts = {}

for i = 1, 7 do
    local url = BASE .. "part_" .. i .. ".lua"
    local ok, source = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        error("[599 AREA] Failed to download source part " .. i .. ": " .. tostring(source))
    end

    parts[#parts + 1] = source
end

local source = table.concat(parts)
local fn, compileError = loadstring(source)

if not fn then
    error("[599 AREA] Failed to compile Main source: " .. tostring(compileError))
end

return fn()
