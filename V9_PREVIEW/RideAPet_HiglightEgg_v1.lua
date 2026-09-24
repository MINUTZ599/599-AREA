-- 599 AREA - Ride A Pet - HIGLIGHT EGG
-- Restored to the original lightweight mechanism.
-- IMPORTANT: isolated module only; no other Ride A Pet feature is modified.
return function(ctx)
    local WS=ctx.WS
    local RunService=ctx.RunService
    local button=ctx.Button
    local UIS=game:GetService("UserInputService")

    local state={Enabled=false,Active={}}
    local renderedConnection=nil
    local workspaceConnection=nil
    local pulseConnection=nil

    local function destroyHighlight(egg)
        if not egg then return end
        local h=egg:FindFirstChild("599_EGG_HIGHLIGHT")
        if h then
            state.Active[h]=nil
            h:Destroy()
        end
    end

    local function addHighlight(egg)
        if not state.Enabled or not egg or not egg.Parent then return end

        local h=egg:FindFirstChild("599_EGG_HIGHLIGHT")
        if not h then
            h=Instance.new("Highlight")
            h.Name="599_EGG_HIGHLIGHT"
            h.Adornee=egg
            h.FillColor=Color3.fromRGB(190,0,255)
            h.OutlineColor=Color3.fromRGB(255,80,255)
            h.FillTransparency=0.10
            h.OutlineTransparency=0
            h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent=egg
        end
        state.Active[h]=true
    end

    local function removeAll()
        for h in pairs(state.Active) do
            if h and h.Parent then h:Destroy() end
        end
        table.clear(state.Active)

        local folder=WS:FindFirstChild("RenderedEggs")
        if folder then
            for _,egg in ipairs(folder:GetChildren()) do
                destroyHighlight(egg)
            end
        end
    end

    local function applyExisting()
        if not state.Enabled then return end
        local folder=WS:FindFirstChild("RenderedEggs")
        if not folder then return end
        for _,egg in ipairs(folder:GetChildren()) do
            addHighlight(egg)
        end
    end

    local function hookRenderedFolder(folder)
        if renderedConnection then
            renderedConnection:Disconnect()
            renderedConnection=nil
        end
        if not folder then return end

        renderedConnection=folder.ChildAdded:Connect(function(egg)
            if state.Enabled then
                task.defer(function()
                    if state.Enabled and egg.Parent==folder then
                        addHighlight(egg)
                    end
                end)
            end
        end)
    end

    local function setEnabled(on)
        state.Enabled=on==true
        button.Text=state.Enabled and "ON" or "OFF"
        button.BackgroundColor3=state.Enabled
            and Color3.fromRGB(125,65,230)
            or Color3.fromRGB(48,46,59)

        if state.Enabled then
            hookRenderedFolder(WS:FindFirstChild("RenderedEggs"))
            applyExisting()
        else
            removeAll()
        end
    end

    hookRenderedFolder(WS:FindFirstChild("RenderedEggs"))

    workspaceConnection=WS.ChildAdded:Connect(function(child)
        if child.Name=="RenderedEggs" then
            hookRenderedFolder(child)
            if state.Enabled then
                task.defer(applyExisting)
            end
        end
    end)

    button.MouseButton1Click:Connect(function()
        setEnabled(not state.Enabled)
    end)

    UIS.InputBegan:Connect(function(input,processed)
        if processed or UIS:GetFocusedTextBox() then return end
        if input.KeyCode==Enum.KeyCode.H then
            setEnabled(not state.Enabled)
        end
    end)

    -- Original neon-purple pulse. Only existing Highlight instances are
    -- animated; no repeated full-world scan is performed every frame.
    pulseConnection=RunService.RenderStepped:Connect(function()
        if not state.Enabled then return end
        local t=0.05+0.30*((math.sin(tick()*3)+1)/2)
        for h in pairs(state.Active) do
            if h and h.Parent then
                h.FillTransparency=t
                h.OutlineTransparency=0
            else
                state.Active[h]=nil
            end
        end
    end)

    button.Destroying:Connect(function()
        state.Enabled=false
        removeAll()
        if renderedConnection then renderedConnection:Disconnect() end
        if workspaceConnection then workspaceConnection:Disconnect() end
        if pulseConnection then pulseConnection:Disconnect() end
    end)
end
