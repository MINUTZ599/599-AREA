-- 599 AREA V8.4 | Stable Loader
-- Tries V8.4 first. If V8.4 cannot compile/run, automatically falls back to the stable 599 AREA Main loader.

local V84_BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V8_4/Client/"
local STABLE_URL = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/Main.lua"

local function download(url)
    local ok, data = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then
        return nil, tostring(data)
    end
    return data
end

local function runSource(source, label)
    local fn, compileError = loadstring(source)
    if not fn then
        return false, label .. " compile error: " .. tostring(compileError)
    end
    local ok, runtimeError = pcall(fn)
    if not ok then
        return false, label .. " runtime error: " .. tostring(runtimeError)
    end
    return true
end

-- V8.4 source
local chunks = {}
local v84DownloadError
for i = 0, 9 do
    local path = string.format("chunk_%02d.lua", i)
    local data, err = download(V84_BASE .. path)
    if not data then
        v84DownloadError = path .. ": " .. tostring(err)
        break
    end
    chunks[#chunks + 1] = data
end

if not v84DownloadError and #chunks == 10 then
    local ok = runSource(table.concat(chunks, "\n"), "V8.4")
    if ok then
        return
    end
end

-- Automatic fallback to the previously working stable build.
local stable, stableDownloadError = download(STABLE_URL)
if not stable then
    error("[599 AREA] V8.4 failed and stable fallback download failed: " .. tostring(stableDownloadError))
end

local ok, err = runSource(stable, "Stable")
if not ok then
    error("[599 AREA] " .. tostring(err))
end
