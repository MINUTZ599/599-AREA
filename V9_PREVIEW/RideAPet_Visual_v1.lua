-- 599 AREA - RIDE A PET VISUAL V1
-- Isolated addon to avoid RideAPet_v42 local-register pressure.
local E=getgenv and getgenv() or _G
E._599_RAP_VISUAL_INSTALL=function(page,toggleRow,status)
    if E._599_RAP_VISUAL_INSTALLED then return end
    E._599_RAP_VISUAL_INSTALLED=true
    local Players=game:GetService("Players")
    local WS=game:GetService("Workspace")
    local UIS=game:GetService("UserInputService")
    local LP=Players.LocalPlayer
    local S={petOn=false,petScale=1,petOriginal={},treeOn=false,treeParts={},treeCon=nil}

    local title=Instance.new("TextLabel")
    title.Position=UDim2.fromOffset(18,14); title.Size=UDim2.new(1,-36,0,25)
    title.BackgroundTransparency=1; title.Font=Enum.Font.GothamBold; title.Text="VISUAL"; title.TextSize=15
    title.TextColor3=Color3.fromRGB(190,57,255); title.TextXAlignment=Enum.TextXAlignment.Left; title.Parent=page

    local function myPet(m)
        return m:IsA("Model") and m:GetAttribute("PetKey")~=nil and m:GetAttribute("PetName")~=nil
            and tonumber(m:GetAttribute("OwnerUserId"))==LP.UserId and m:FindFirstChild("RootPart")~=nil
    end
    local function pets()
        local t={}; local plots=WS:FindFirstChild("Plots"); if not plots then return t end
        for _,o in ipairs(plots:GetDescendants()) do
            if o.Name=="Pets" then for _,m in ipairs(o:GetChildren()) do if myPet(m) then t[#t+1]=m end end end
        end
        return t
    end
    local function applyPets()
        if not S.petOn then return end
        for _,p in ipairs(pets()) do
            if S.petOriginal[p]==nil then local ok,v=pcall(function() return p:GetScale() end); if ok then S.petOriginal[p]=v end end
            local base=S.petOriginal[p]; if base then pcall(function() p:ScaleTo(base*S.petScale) end) end
        end
    end
    local function restorePets()
        for p,v in pairs(S.petOriginal) do if p and p.Parent then pcall(function() p:ScaleTo(v) end) end end
    end

    local petToggle=toggleRow(page,48,"Scale Pet")
    petToggle.MouseButton1Click:Connect(function()
        S.petOn=not S.petOn; petToggle.Text=S.petOn and "ON" or "OFF"
        petToggle.BackgroundColor3=S.petOn and Color3.fromRGB(159,37,238) or Color3.fromRGB(48,46,59)
        if S.petOn then applyPets() else restorePets() end
        if status then status.Text=S.petOn and "STATUS: SCALE PET ON" or "STATUS: SCALE PET OFF" end
    end)

    local card=Instance.new("Frame"); card.Position=UDim2.fromOffset(16,108); card.Size=UDim2.new(1,-32,0,105)
    card.BackgroundColor3=Color3.fromRGB(19,19,30); card.BorderSizePixel=0; card.Parent=page
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,10)
    local value=Instance.new("TextLabel"); value.Position=UDim2.fromOffset(14,10); value.Size=UDim2.new(1,-28,0,24)
    value.BackgroundTransparency=1; value.Font=Enum.Font.GothamSemibold; value.Text="PET SIZE : 1.00x"; value.TextSize=11
    value.TextColor3=Color3.fromRGB(242,240,247); value.TextXAlignment=Enum.TextXAlignment.Left; value.Parent=card
    local bar=Instance.new("Frame"); bar.Position=UDim2.fromOffset(14,57); bar.Size=UDim2.new(1,-28,0,8)
    bar.BackgroundColor3=Color3.fromRGB(48,46,59); bar.BorderSizePixel=0; bar.Parent=card; Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame"); fill.BackgroundColor3=Color3.fromRGB(159,37,238); fill.BorderSizePixel=0; fill.Parent=bar; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("TextButton"); knob.Size=UDim2.fromOffset(18,18); knob.AnchorPoint=Vector2.new(.5,.5); knob.BackgroundColor3=Color3.fromRGB(230,220,240)
    knob.BorderSizePixel=0; knob.Text=""; knob.Parent=bar; Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local dragging=false
    local function setPct(p)
        p=math.clamp(p,0,1); S.petScale=math.floor((.2+4.8*p)*100+.5)/100
        fill.Size=UDim2.fromScale(p,1); knob.Position=UDim2.new(p,0,.5,0); value.Text=string.format("PET SIZE : %.2fx",S.petScale)
        applyPets()
    end
    setPct((1-.2)/4.8)
    local function fromX(x) if bar.AbsoluteSize.X>0 then setPct((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X) end end
    bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; fromX(i.Position.X) end end)
    knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true end end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then fromX(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)

    local words={"tree","trees","pohon","trunk","foliage"}
    local function treeName(n) n=string.lower(n); for _,w in ipairs(words) do if string.find(n,w,1,true) then return true end end return false end
    local function isTree(o) local p=o; for _=1,7 do if not p or p==WS then break end; if treeName(p.Name) then return true end; p=p.Parent end return false end
    local function charPart(p) local m=p:FindFirstAncestorOfClass("Model"); if not m then return false end; for _,pl in ipairs(Players:GetPlayers()) do if pl.Character==m then return true end end return false end
    local function hidePart(p)
        if not S.treeOn or not p:IsA("BasePart") or S.treeParts[p]~=nil or charPart(p) or not isTree(p) then return end
        S.treeParts[p]=p.LocalTransparencyModifier; p.LocalTransparencyModifier=1
    end
    local function hideAll() for _,o in ipairs(WS:GetDescendants()) do if o:IsA("BasePart") then hidePart(o) end end end
    local function showAll()
        if S.treeCon then S.treeCon:Disconnect(); S.treeCon=nil end
        for p,v in pairs(S.treeParts) do if p and p.Parent then pcall(function() p.LocalTransparencyModifier=v end) end end
        S.treeParts={}
    end
    local treeToggle=toggleRow(page,232,"Delete Tree")
    treeToggle.MouseButton1Click:Connect(function()
        S.treeOn=not S.treeOn; treeToggle.Text=S.treeOn and "ON" or "OFF"
        treeToggle.BackgroundColor3=S.treeOn and Color3.fromRGB(159,37,238) or Color3.fromRGB(48,46,59)
        if S.treeOn then
            hideAll()
            S.treeCon=WS.DescendantAdded:Connect(function(o)
                if not S.treeOn then return end
                task.defer(function()
                    if not S.treeOn or not o or not o.Parent then return end
                    if o:IsA("BasePart") then hidePart(o) end
                    if treeName(o.Name) then for _,d in ipairs(o:GetDescendants()) do if d:IsA("BasePart") then hidePart(d) end end end
                end)
            end)
        else showAll() end
        if status then status.Text=S.treeOn and "STATUS: DELETE TREE ON" or "STATUS: DELETE TREE OFF" end
    end)

    WS.DescendantAdded:Connect(function(o)
        if S.petOn and o:IsA("Model") then task.defer(function() if S.petOn and o.Parent and myPet(o) then applyPets() end end) end
    end)
end
