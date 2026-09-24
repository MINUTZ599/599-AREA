-- 599 AREA - Ride A Pet - HIGLIGHT EGG isolated module
-- Keeps highlight implementation outside RideAPet_v42.lua to avoid its local-register ceiling.
return function(ctx)
    local WS=ctx.WS
    local RunService=ctx.RunService
    local button=ctx.Button
    local UIS=game:GetService("UserInputService")
    local state={Enabled=false,Active={}}
    local renderedConnection=nil
    local workspaceConnection=nil


    local function removeAll()
        for h in pairs(state.Active) do
            if h and h.Parent then h:Destroy() end
            state.Active[h]=nil
        end
        local folder=WS:FindFirstChild("RenderedEggs")
        if folder then
            for _,egg in ipairs(folder:GetChildren()) do
                local h=egg:FindFirstChild("599_EGG_HIGHLIGHT")
                if h then h:Destroy() end
            end
        end
    end

    local function refresh()
        if not state.Enabled then return end
        local folder=WS:FindFirstChild("RenderedEggs")
        if not folder then return end
        for _,egg in ipairs(folder:GetChildren()) do
            local h=egg:FindFirstChild("599_EGG_HIGHLIGHT")
            if not h then
                h=Instance.new("Highlight")
                h.Name="599_EGG_HIGHLIGHT"
                h.Adornee=egg
                h.FillColor=Color3.fromRGB(190,0,255)
                h.OutlineColor=Color3.fromRGB(255,80,255)
                h.FillTransparency=.1
                h.OutlineTransparency=0
                h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent=egg
            end
            state.Active[h]=true
        end
    end

    local function hookRenderedFolder(folder)
        if renderedConnection then renderedConnection:Disconnect(); renderedConnection=nil end
        if not folder then return end
        renderedConnection=folder.ChildAdded:Connect(function(egg)
            if not state.Enabled then return end
            task.defer(function()
                if state.Enabled and egg.Parent==folder then
                    local h=egg:FindFirstChild("599_EGG_HIGHLIGHT")
                    if not h then
                        h=Instance.new("Highlight")
                        h.Name="599_EGG_HIGHLIGHT"
                        h.Adornee=egg
                        h.FillColor=Color3.fromRGB(190,0,255)
                        h.OutlineColor=Color3.fromRGB(255,80,255)
                        h.FillTransparency=.1
                        h.OutlineTransparency=0
                        h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent=egg
                    end
                    state.Active[h]=true
                end
            end)
        end)
    end

    hookRenderedFolder(WS:FindFirstChild("RenderedEggs"))
    workspaceConnection=WS.ChildAdded:Connect(function(child)
        if child.Name=="RenderedEggs" then
            hookRenderedFolder(child)
            if state.Enabled then task.defer(refresh) end
        end
    end)

    local function setEnabled(on)
        state.Enabled=on==true
        button.Text=state.Enabled and "ON" or "OFF"
        button.BackgroundColor3=state.Enabled and Color3.fromRGB(125,65,230) or Color3.fromRGB(48,46,59)
        if state.Enabled then refresh() else removeAll() end
    end

    button.MouseButton1Click:Connect(function() setEnabled(not state.Enabled) end)
    UIS.InputBegan:Connect(function(input,processed)
        if processed or UIS:GetFocusedTextBox() then return end
        if input.KeyCode==Enum.KeyCode.H then setEnabled(not state.Enabled) end
    end)

    task.spawn(function()
        while button.Parent do
            if state.Enabled then refresh() end
            task.wait(.4)
        end
        removeAll()
        if renderedConnection then renderedConnection:Disconnect() end
        if workspaceConnection then workspaceConnection:Disconnect() end
    end)

    RunService.RenderStepped:Connect(function()
        if not state.Enabled then return end
        local t=.05+.30*((math.sin(tick()*3)+1)/2)
        for h in pairs(state.Active) do
            if h and h.Parent then
                h.FillTransparency=t
                h.OutlineTransparency=0
            else
                state.Active[h]=nil
            end
        end
    end)
end
