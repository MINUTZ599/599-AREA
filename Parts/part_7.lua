		end)
		statusText.Text = "FPS: "..fps.."\nPING: "..ping.." ms\nTIME: "..os.date("%H:%M:%S")
	end
end)

--========================================================
-- BACKGROUND LOAD CHECK
--========================================================

task.spawn(function()
	local ok = pcall(function()
		ContentProvider:PreloadAsync({bg})
	end)

	task.wait(0.4)

	if not ok or not bg.IsLoaded then
		notify("Background gagal dimuat: cek Asset ID / permission")
	else
		notify("599 AREA V8.1 MINUTZ loaded")
	end
end)

selectPage("DASHBOARD")
print("599 AREA V8.1 MINUTZ LOADED")
