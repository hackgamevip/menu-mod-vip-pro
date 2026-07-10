-- ==========================================
-- MENU VIP PRO V1.12.6 ✅ ĐÃ SỬA & TỐI ƯU HOÀN CHỈNH
-- ==========================================
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInput = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- CỜ KHÓA CHỐNG CHẠY CHỒNG TOÀN CỤC
_G.VIPPRO_MAX_RUNNING = _G.VIPPRO_MAX_RUNNING or false
if _G.VIPPRO_MAX_RUNNING then pcall(function() game.CoreGui:FindFirstChild("MobileProMax"):Destroy() end) end
_G.VIPPRO_MAX_RUNNING = true

local State = {
    Instant = false, Noclip = false, LowGfx = false, Speed = false, Jump = false,
    InfJump = false, PlayerLight = false, ESP = false, AntiAfk = true, AntiStun = false, 
    XRay = false, LockPosition = false, AutoCollect = false, Fly = false, FlySpeed = 50,
    SpinBot = false, SpinSpeed = 50, Hitbox = false, HitboxSize = 15, AutoClick = false, RGB = false,
    Reach = false, ReachSize = 15, AutoDash = false, DashSpeed = 10, AutoSave = false, Astral = false,
    ShiftLock = false, SpeedValue = 60, JumpValue = 120, LightRange = 60, LightBrightness = 3,
    MusicVolume = 5, NoFog = false, BlackScreen = false, WhiteScreen = false
}

local Theme = {
    MainBg = Color3.fromRGB(20, 20, 26),      
    HeaderBg = Color3.fromRGB(26, 26, 34),    
    TabBg = Color3.fromRGB(24, 24, 30),       
    ItemBg = Color3.fromRGB(35, 35, 45),      
    Stroke = Color3.fromRGB(60, 60, 75),      
    TextTitle = Color3.fromRGB(210, 225, 240),
    TextDim = Color3.fromRGB(160, 160, 175),  
    AccentOn = Color3.fromRGB(46, 204, 113),  
    AccentOff = Color3.fromRGB(255, 71, 87),  
    Brand = Color3.fromRGB(0, 200, 255)
}

local RGBElements = {}
local ActiveESPs = {} 
local originalHitboxSizes = {}
local originalToolSizes = {}
local xrayMats = {}
local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
    if gethui and type(gethui) == "function" then
        local hui = gethui(); if hui then guiParent = hui end
    elseif game:GetService("CoreGui") then
        guiParent = game:GetService("CoreGui")
    end
end)

for _, v in pairs(guiParent:GetChildren()) do
    if v.Name == "MobileProMax" then pcall(function() v:Destroy() end) end
end

local configFileName = "MenuVipProMax_Config.json"
pcall(function()
    if isfile and isfile(configFileName) then
        local ok, data = pcall(HttpService.JSONDecode, HttpService, readfile(configFileName))
        if ok and type(data) == "table" then
            for k, v in pairs(data) do if State[k] ~= nil then State[k] = v end end
        end
    end
end)
local function saveConfig()
    pcall(function() if writefile then writefile(configFileName, HttpService:JSONEncode(State)) end end)
end

-- ==========================================
-- GIAO DIỆN
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "MobileProMax"; gui.ResetOnSpawn = false; gui.DisplayOrder = 99999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.Parent = guiParent

local notifGui = Instance.new("Frame", gui)
notifGui.Size = UDim2.new(0, 220, 0.8, 0); notifGui.Position = UDim2.new(1, -230, 0.1, 0)
notifGui.BackgroundTransparency = 1; notifGui.ZIndex = 9999
local notifLayout = Instance.new("UIListLayout", notifGui)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder; notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; notifLayout.Padding = UDim.new(0, 10)

local function MakeToast(title, desc, color)
    local toast = Instance.new("Frame", notifGui)
    toast.Size = UDim2.new(1, 0, 0, 55); toast.BackgroundColor3 = Theme.ItemBg
    toast.BackgroundTransparency = 1; Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", toast); stroke.Color = color; stroke.Thickness = 1.5; stroke.Transparency = 1
    local colorBar = Instance.new("Frame", toast)
    colorBar.Size = UDim2.new(0, 4, 1, -16); colorBar.Position = UDim2.new(0, 8, 0, 8)
    colorBar.BackgroundColor3 = color; Instance.new("UICorner", colorBar).CornerRadius = UDim.new(1, 0); colorBar.BackgroundTransparency = 1
    local tLabel = Instance.new("TextLabel", toast)
    tLabel.Size = UDim2.new(1, -30, 0, 20); tLabel.Position = UDim2.new(0, 20, 0, 8)
    tLabel.BackgroundTransparency = 1; tLabel.Text = title; tLabel.TextColor3 = color; tLabel.Font = Enum.Font.GothamBold; tLabel.TextSize = 13; tLabel.TextXAlignment = Enum.TextXAlignment.Left; tLabel.TextTransparency = 1
    local dLabel = Instance.new("TextLabel", toast)
    dLabel.Size = UDim2.new(1, -30, 0, 20); dLabel.Position = UDim2.new(0, 20, 0, 28)
    dLabel.BackgroundTransparency = 1; dLabel.Text = desc; dLabel.TextColor3 = Theme.TextTitle; dLabel.Font = Enum.Font.Gotham; dLabel.TextSize = 11; dLabel.TextXAlignment = Enum.TextXAlignment.Left; dLabel.TextTransparency = 1
    TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(colorBar, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(tLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(dLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    task.delay(2.5, function()
        TweenService:Create(toast, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(colorBar, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(tLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(dLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4); pcall(function() toast:Destroy() end)
    end)
end

local screenOverlay = Instance.new("Frame", gui)
screenOverlay.Size = UDim2.new(2, 0, 2, 0); screenOverlay.Position = UDim2.new(-0.5, 0, -0.5, 0)
screenOverlay.BackgroundColor3 = Color3.new(0,0,0); screenOverlay.ZIndex = 0; screenOverlay.Visible = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 45, 0, 45); openBtn.Position = UDim2.new(0, 15, 0, 15)
openBtn.Text = "🇻🇳"; openBtn.BackgroundColor3 = Theme.MainBg; openBtn.BackgroundTransparency = 0.3
openBtn.TextColor3 = Theme.Brand; openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 22; openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke", openBtn); openStroke.Color = Theme.Brand; openStroke.Thickness = 2

local function clickAnimate(obj)
    local scale = Instance.new("UIScale", obj)
    TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 0.92}):Play()
    task.wait(0.1)
    TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce), {Scale = 1}):Play()
    task.delay(0.3, function() pcall(function() scale:Destroy() end) end)
end

local btnDragToggle, btnDragStart, btnStartPos
openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragToggle = true; btnDragStart = input.Position; btnStartPos = openBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if btnDragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        openBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + (input.Position.X - btnDragStart.X), btnStartPos.Y.Scale, btnStartPos.Y.Offset + (input.Position.Y - btnDragStart.Y))
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragToggle = false end
end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 500); frame.Position = UDim2.new(0.5, -210, 0.58, -250)
frame.BackgroundColor3 = Theme.MainBg; frame.BackgroundTransparency = 0.05; frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)
local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = Theme.Stroke; frameStroke.Thickness = 2
table.insert(RGBElements, {Type = "Frame", Stroke = frameStroke})

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45); header.BackgroundColor3 = Theme.HeaderBg
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)
local headerCover = Instance.new("Frame", header)
headerCover.Size = UDim2.new(1, 0, 0, 15); headerCover.Position = UDim2.new(0, 0, 1, -15); headerCover.BackgroundColor3 = Theme.HeaderBg
local headerStroke = Instance.new("UIStroke", header); headerStroke.Color = Theme.Stroke; headerStroke.Thickness = 1.5
table.insert(RGBElements, {Type = "Header", Stroke = headerStroke})

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, 0, 1, 0); titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MENU VIP PRO MAX"; titleLabel.TextColor3 = Theme.TextTitle; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 16

local avatarImg = Instance.new("ImageLabel", header)
avatarImg.Size = UDim2.new(0, 40, 0, 40); avatarImg.Position = UDim2.new(0, 10, 0, 8); avatarImg.BackgroundTransparency = 1
pcall(function() avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
local avatarStroke = Instance.new("UIStroke", avatarImg); avatarStroke.Color = Theme.Brand; avatarStroke.Thickness = 1.5

local dragToggle, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart = input.Position; startPos = frame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end
end)

local tabBar = Instance.new("Frame", frame)
tabBar.Size = UDim2.new(1, 0, 0, 38); tabBar.Position = UDim2.new(0, 0, 0, 45); tabBar.BackgroundColor3 = Theme.TabBg

local function createTab(name, x, width)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(width, 0, 1, 0); btn.Position = UDim2.new(x, 0, 0, 0)
    btn.Text = name; btn.BackgroundTransparency = 1; btn.TextColor3 = Theme.TextDim
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 8
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0.5, 0, 0, 3); indicator.Position = UDim2.new(0.25, 0, 1, -3)
    indicator.BackgroundColor3 = Theme.Brand; indicator.Visible = false
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    return btn, indicator
end

local tab1,ind1=createTab("THÔNG TIN",0,.14) local tab2,ind2=createTab("TÍNH NĂNG",.14,.14) local tab3,ind3=createTab("PLAYER",.28,.14)
local tab4,ind4=createTab("TIỆN ÍCH",.42,.14) local tab5,ind5=createTab("NHẠC ID",.56,.12) local tab6,ind6=createTab("TP SAVE",.68,.15) local tab7,ind7=createTab("TP PLAYER",.83,.17)

local pageContainer = Instance.new("Frame", frame)
pageContainer.Size = UDim2.new(1, 0, 1, -95); pageContainer.Position = UDim2.new(0, 0, 0, 88); pageContainer.BackgroundTransparency = 1

local function createPage()
    local pg = Instance.new("ScrollingFrame", pageContainer)
    pg.Size = UDim2.new(1,0,1,0); pg.BackgroundTransparency = 1; pg.ScrollBarThickness = 3; pg.ScrollBarImageColor3 = Theme.Brand; pg.Visible = false
    local l = Instance.new("UIListLayout", pg); l.HorizontalAlignment = "Center"; l.Padding = UDim.new(0,10)
    Instance.new("UIPadding", pg).PaddingTop = UDim.new(0,10); Instance.new("UIPadding", pg).PaddingBottom = UDim.new(0,30)
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize = UDim2.new(0,0,0,l.AbsoluteContentSize.Y+120) end)
    return pg
end
local page1,page2,page3,page4,page7 = createPage(),createPage(),createPage(),createPage(),createPage()
local page5 = Instance.new("Frame", pageContainer); page5.Size=UDim2.new(1,0,1,0); page5.BackgroundTransparency=1; page5.Visible=false
local l5 = Instance.new("UIListLayout", page5); l5.HorizontalAlignment="Center"; l5.Padding=UDim.new(0,10); Instance.new("UIPadding",page5).PaddingTop=UDim.new(0,10)
local page6 = Instance.new("Frame", pageContainer); page6.Size=UDim2.new(1,0,1,0); page6.BackgroundTransparency=1; page6.Visible=false
local l6 = Instance.new("UIListLayout", page6); l6.HorizontalAlignment="Center"; l6.Padding=UDim.new(0,10); Instance.new("UIPadding",page6).PaddingTop=UDim.new(0,10)

local function showTab(pg,tb,ind)
    for _,p in {page1,page2,page3,page4,page5,page6,page7} do p.Visible=false end
    for _,t in {tab1,tab2,tab3,tab4,tab5,tab6,tab7} do t.TextColor3=Theme.TextDim end
    for _,i in {ind1,ind2,ind3,ind4,ind5,ind6,ind7} do i.Visible=false end
    pg.Visible=true; tb.TextColor3=Theme.TextTitle; ind.Visible=true
    ind.Size=UDim2.new(0,0,0,3); TweenService:Create(ind,TweenInfo.new(.3),{Size=UDim2.new(.5,0,0,3)}):Play()
end
tab1.MouseButton1Click:Connect(function() showTab(page1,tab1,ind1) end)
tab2.MouseButton1Click:Connect(function() showTab(page2,tab2,ind2) end)
tab3.MouseButton1Click:Connect(function() showTab(page3,tab3,ind3) end)
tab4.MouseButton1Click:Connect(function() showTab(page4,tab4,ind4) end)
tab5.MouseButton1Click:Connect(function() showTab(page5,tab5,ind5) end)
tab6.MouseButton1Click:Connect(function() showTab(page6,tab6,ind6) end)
tab7.MouseButton1Click:Connect(function() showTab(page7,tab7,ind7) end)
showTab(page1,tab1,ind1)

local opened = true
openBtn.MouseButton1Click:Connect(function()
    clickAnimate(openBtn); opened = not opened
    if not State.RGB then TweenService:Create(openStroke,TweenInfo.new(.3),{Color=opened and Theme.AccentOff or Theme.Brand}):Play() end
    frame:TweenPosition(opened and UDim2.new(.5,-210,.58,-250) or UDim2.new(.5,-210,1.2,0),"Out","Back",.5)
end)

-- PHÍM TẮT MỚI
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightShift then openBtn.MouseButton1Click:Fire() end
end)

local function createToggle(parent, text, varName, callback)
    local f = Instance.new("Frame", parent); f.Size=UDim2.new(.9,0,0,44); f.BackgroundTransparency=1
    local btn = Instance.new("TextButton", f); btn.Size=UDim2.new(1,0,1,0); btn.Text=""; btn.AutoButtonColor=false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness=1.5
    local title = Instance.new("TextLabel", btn); title.Size=UDim2.new(.7,0,1,0); title.Position=UDim2.new(.05,0,0,0)
    title.BackgroundTransparency=1; title.Text=text; title.TextColor3=Theme.TextTitle; title.Font=Enum.Font.GothamSemibold; title.TextSize=13; title.TextXAlignment="Left"
    local status = Instance.new("TextLabel", btn); status.Size=UDim2.new(.2,0,1,0); status.Position=UDim2.new(.75,0,0,0)
    status.BackgroundTransparency=1; status.Font=Enum.Font.GothamBold; status.TextSize=12; status.TextXAlignment="Right"
    local active = not not State[varName]
    status.Text = active and "ON" or "OFF"; status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
    stroke.Color = active and Theme.AccentOn or Theme.Stroke; btn.BackgroundColor3 = active and Color3.fromRGB(35,45,40) or Theme.ItemBg
    table.insert(RGBElements,{Type="Toggle",Stroke=stroke,State=function() return State[varName] end})
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); State[varName] = not State[varName]; active=State[varName]
        status.Text=active and "ON" or "OFF"
        TweenService:Create(status,TweenInfo.new(.2),{TextColor3=active and Theme.AccentOn or Theme.AccentOff}):Play()
        if not State.RGB then TweenService:Create(stroke,TweenInfo.new(.2),{Color=active and Theme.AccentOn or Theme.Stroke}):Play() end
        TweenService:Create(btn,TweenInfo.new(.2),{BackgroundColor3=active and Color3.fromRGB(35,45,40) or Theme.ItemBg}):Play()
        if varName~="AutoSave" then
            MakeToast(active and "Đã Bật" or "Đã Tắt", text, active and Theme.AccentOn or Theme.AccentOff)
            if State.AutoSave then saveConfig() end
        end
        if callback then task.spawn(callback,active) end
    end)
    if active and callback then task.spawn(callback,active) end
    return f
end
local function createButton(parent,text,color,cb)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(.9,0,0,42); f.BackgroundTransparency=1
    local b=Instance.new("TextButton",f); b.Size=UDim2.new(1,0,1,0); b.BackgroundColor3=Theme.ItemBg; b.Text=""; b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local s=Instance.new("UIStroke",b); s.Color=color; s.Thickness=1.5; table.insert(RGBElements,{Type="Button",Stroke=s,DefaultColor=color})
    local t=Instance.new("TextLabel",b); t.Size=UDim2.new(1,0,1,0); t.BackgroundTransparency=1; t.Text=text; t.TextColor3=color; t.Font=Enum.Font.GothamBold; t.TextSize=13
    b.MouseButton1Click:Connect(function()
        clickAnimate(b); if not State.RGB then TweenService:Create(s,TweenInfo.new(.15),{Color=Theme.TextTitle}):Play() end
        task.wait(.15); if not State.RGB then TweenService:Create(s,TweenInfo.new(.3),{Color=color}):Play() end
        MakeToast("Đã thực thi",text,color); cb()
    end)
    return f
end
local function createDualButtons(parent,t1,c1,cb1,t2,c2,cb2)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(.9,0,0,42); f.BackgroundTransparency=1
    local function mb(x,txt,col,cb)
        local b=Instance.new("TextButton",f); b.Size=UDim2.new(.48,0,1,0); b.Position=UDim2.new(x,0,0,0); b.BackgroundColor3=Theme.ItemBg; b.AutoButtonColor=false
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
        local s=Instance.new("UIStroke",b); s.Color=col; s.Thickness=1.5; table.insert(RGBElements,{Type="Button",Stroke=s,DefaultColor=col})
        local lb=Instance.new("TextLabel",b); lb.Size=UDim2.new(1,0,1,0); lb.BackgroundTransparency=1; lb.Text=txt; lb.TextColor3=col; lb.Font=Enum.Font.GothamBold; lb.TextSize=11
        b.MouseButton1Click:Connect(function()
            clickAnimate(b); if not State.RGB then TweenService:Create(s,TweenInfo.new(.15),{Color=Theme.TextTitle}):Play() end
            task.wait(.15); if not State.RGB then TweenService:Create(s,TweenInfo.new(.3),{Color=col}):Play() end
            if txt~="🗑️ XÓA TẤT CẢ" then MakeToast("Đã thực thi",txt,col) end; cb()
        end)
    end
    mb(0,t1,c1,cb1); mb(.52,t2,c2,cb2); return f
end
local function createSlider(parent,text,mn,mx,varName,cb)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(.9,0,0,48); f.BackgroundTransparency=1
    local bg=Instance.new("Frame",f); bg.Size=UDim2.new(1,0,1,0); bg.BackgroundColor3=Theme.ItemBg
    Instance.new("UICorner",bg).CornerRadius=UDim.new(0,10)
    local st=Instance.new("UIStroke",bg); st.Color=Theme.Stroke; st.Thickness=1.5; table.insert(RGBElements,{Type="Slider",Stroke=st})
    local tl=Instance.new("TextLabel",bg); tl.Size=UDim2.new(.7,0,.4,0); tl.Position=UDim2.new(.05,0,.1,0); tl.BackgroundTransparency=1; tl.Text=text; tl.TextColor3=Theme.TextDim; tl.Font=Enum.Font.GothamSemibold; tl.TextSize=12; tl.TextXAlignment="Left"
    local vl=Instance.new("TextLabel",bg); vl.Size=UDim2.new(.25,0,.4,0); vl.Position=UDim2.new(.7,0,.1,0); vl.BackgroundTransparency=1; vl.Text=tostring(State[varName]); vl.TextColor3=Theme.Brand; vl.Font=Enum.Font.GothamBold; vl.TextSize=12; vl.TextXAlignment="Right"
    local tr=Instance.new("Frame",bg); tr.Size=UDim2.new(.9,0,.15,0); tr.Position=UDim2.new(.05,0,.65,0); tr.BackgroundColor3=Theme.MainBg
    Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
    local fi=Instance.new("Frame",tr); fi.Size=UDim2.new((State[varName]-mn)/(mx-mn),0,1,0); fi.BackgroundColor3=Theme.AccentOn
    Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)
    local dragging=false
    local function up(i)
        local p=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        local v=math.floor(mn+((mx-mn)*p)); vl.Text=tostring(v)
        TweenService:Create(fi,TweenInfo.new(.1),{Size=UDim2.new(p,0,1,0)}):Play()
        State[varName]=v; if cb then cb(v) end; if State.AutoSave then saveConfig() end
    end
    tr.InputBegan:Connect(function(i) if i.UserInputType.Name:match("MouseButton1|Touch") then dragging=true; up(i) end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType.Name:match("MouseMovement|Touch") then up(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType.Name:match("MouseButton1|Touch") then dragging=false end end)
    if cb then task.spawn(cb,State[varName]) end
    return f
end

-- RGB TỐI ƯU
task.spawn(function()
    while task.wait(.12) do
        if State.RGB then
            local c = Color3.fromHSV(tick()%6/6,1,1)
            titleLabel.TextColor3=c; frameStroke.Color=c; headerStroke.Color=c; avatarStroke.Color=c; openStroke.Color=c
            for _,o in RGBElements do if o.Stroke and o.Stroke.Parent then o.Stroke.Color=c end end
        end
    end
end)

-- TAB 1 THÔNG TIN
local function infoBox(p,ic,txt,h)
    local it=Instance.new("Frame",p); it.Size=UDim2.new(.9,0,0,h or 85); it.BackgroundColor3=Theme.ItemBg
    Instance.new("UICorner",it).CornerRadius=UDim.new(0,8)
    local s=Instance.new("UIStroke",it); s.Color=Theme.Stroke; s.Thickness=1.5; table.insert(RGBElements,{Type="Info",Stroke=s})
    local tl=Instance.new("TextLabel",it); tl.Size=UDim2.new(1,-20,0,25); tl.Position=UDim2.new(0,10,0,5); tl.BackgroundTransparency=1; tl.Text=ic.." "..txt; tl.TextColor3=Theme.Brand; tl.Font=Enum.Font.GothamBold; tl.TextSize=12; tl.TextXAlignment="Left"
    local ct=Instance.new("TextLabel",it); ct.Size=UDim2.new(1,-20,1,-35); ct.Position=UDim2.new(0,10,0,30); ct.BackgroundTransparency=1; ct.Text="Đang tải..."; ct.TextColor3=Theme.TextTitle; ct.Font=Enum.Font.Gotham; ct.TextSize=11; ct.TextXAlignment="Left"; ct.TextYAlignment="Top"; ct.RichText=true
    return ct,it
end
local plbl = infoBox(page1,"👤","THÔNG TIN NHÂN VẬT",100)
local slbl,sfrm = infoBox(page1,"🌐","THÔNG TIN MÁY CHỦ",85)
local cid = Instance.new("TextButton",sfrm); cid.Size=UDim2.new(0,24,0,24); cid.Position=UDim2.new(1,-30,1,-28); cid.BackgroundTransparency=1; cid.Text="📜"; cid.TextSize=14
cid.MouseButton1Click:Connect(function()
    clickAnimate(cid); pcall(function() if setclipboard then setclipboard(game.JobId); MakeToast("Đã Copy","ID Server",Theme.AccentOn) end end)
end)
local jf=Instance.new("Frame",page1); jf.Size=UDim2.new(.9,0,0,44); jf.BackgroundColor3=Theme.ItemBg
Instance.new("UICorner",jf).CornerRadius=UDim.new(0,8)
local js=Instance.new("UIStroke",jf); js.Color=Theme.Stroke; js.Thickness=1.5; table.insert(RGBElements,{Type="Info",Stroke=js})
local idb=Instance.new("TextBox",jf); idb.Size=UDim2.new(.65,0,1,0); idb.Position=UDim2.new(.05,0,0,0); idb.BackgroundTransparency=1; idb.PlaceholderText="Dán ID Server..."; idb.TextColor3=Theme.Brand; idb.Font=Enum.Font.Gotham; idb.TextSize=11; idb.ClearTextOnFocus=false
local jb=Instance.new("TextButton",jf); jb.Size=UDim2.new(.25,0,.65,0); jb.Position=UDim2.new(.72,0,.175,0); jb.BackgroundColor3=Theme.AccentOn; jb.Text="VÀO"; jb.TextColor3=Color3.new(1,1,1); jb.Font=Enum.Font.GothamBold; jb.TextSize=11
Instance.new("UICorner",jb).CornerRadius=UDim.new(0,6)
jb.MouseButton1Click:Connect(function()
    local id=idb.Text:gsub("%s+","")
    if #id>0 then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,id,player) end) end
end)
local elbl = infoBox(page1,"⚙️","TRẠNG THÁI",80)
local fps=0
RunService.RenderStepped:Connect(function(d) fps=math.floor(1/d) end)
task.spawn(function()
    while task.wait(.6) do
        local hp,mx,ws,jp=0,0,0,0 local cr="0,0,0"
        local ch=player.Character local hu=ch and ch:FindFirstChildOfClass("Humanoid")
        if hu then hp=math.floor(hu.Health);mx=math.floor(hu.MaxHealth);ws=math.floor(hu.WalkSpeed);jp=math.floor(hu.JumpPower) end
        local rt=ch and ch:FindFirstChild("HumanoidRootPart")
        if rt then cr=("%.1f, %.1f, %.1f"):format(rt.Position.X,rt.Position.Y,rt.Position.Z) end
        plbl.Text=("<font color='#FF00FF'>Tên:</font> %s\n<font color='#FF00FF'>Máu:</font> %d/%d\n<font color='#FF00FF'>Tốc độ:</font> %d\n<font color='#FF00FF'>Nhảy:</font> %d\n<font color='#FF00FF'>Tọa độ:</font> %s"):format(player.Name,hp,mx,ws,jp,cr)
        local ping=tostring(math.floor(player:GetNetworkPing()*1000)).." ms"
        slbl.Text=("<font color='#FF00FF'>FPS:</font> %d\n<font color='#FF00FF'>Ping:</font> %s\n<font color='#FF00FF'>Người:</font> %d/%d"):format(fps,ping,#Players:GetPlayers(),Players.MaxPlayers)
        local t=math.floor(workspace.DistributedGameTime)
        elbl.Text=("<font color='#FF00FF'>Chơi:</font> %02d:%02d:%02d\n<font color='#FF00FF'>Phiên bản:</font> 1.12.6"):format(t/3600,t%3600/60,t%60)
    end
end)

-- TAB 2 TÍNH NĂNG
createToggle(page2,"🛡️ Chống ngã","AntiStun")
createToggle(page2,"🔒 Khóa vị trí","LockPosition",function(v)
    local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if r then r.Anchored=v end
end)
createToggle(page2,"🚀 Nhảy trên không","InfJump")
UIS.JumpRequest:Connect(function()
    if State.InfJump then
        local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)
createToggle(page2,"🐿️ Lấy đồ nhanh","Instant")
createToggle(page2,"🧲 Auto nhặt đồ","AutoCollect")
createToggle(page2,"🚷 Đi xuyên tường","Noclip",function(v)
    if not v and player.Character then
        for _,p in player.Character:GetDescendants() do if p:IsA("BasePart") then p.CanCollide=true end end
    end
end)
local xrt=0
createToggle(page2,"👀 Nhìn xuyên map","XRay",function(v)
    xrt+=1 local tk=xrt
    task.spawn(function()
        if v then
            for i,o in workspace:GetDescendants() do
                if tk~=xrt then return end
                if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) and o.Name~="Terrain" and o.Transparency<1 then
                    xrayMats[o]=o.Transparency; o.Transparency=.5
                end
                if i%400==0 then task.wait() end
            end
        else
            for o,tr in xrayMats do if o and o.Parent then o.Transparency=tr end end
            table.clear(xrayMats)
        end
    end)
end)
createToggle(page2,"🔴 ESP người chơi","ESP")

-- TAB3 PLAYER
createToggle(page3,"🕊️ Bay","Fly")
createSlider(page3,"Tốc độ bay",10,1000,"FlySpeed")
local defWS=16
createToggle(page3,"🏃 Chạy nhanh","Speed",function(v)
    local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then if v then defWS=h.WalkSpeed else h.WalkSpeed=defWS end end
end)
createSlider(page3,"Tốc độ chạy",1,1000,"SpeedValue")
local defJP=50
createToggle(page3,"🦘 Nhảy cao","Jump",function(v)
    local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then if v then defJP=h.JumpPower else h.JumpPower=defJP end end
end)
createSlider(page3,"Lực nhảy",1,1000,"JumpValue")
createToggle(page3,"💨 Lướt liên tục","AutoDash")
createSlider(page3,"Tốc độ lướt",1,50,"DashSpeed")
createToggle(page3,"⚔️ Đánh xa","Reach")
createSlider(page3,"Kích thước vũ khí",0,300,"ReachSize")
createToggle(page3,"🎯 Hitbox","Hitbox")
createSlider(page3,"Kích thước Hitbox",0,100,"HitboxSize")
createToggle(page3,"🌪️ Xoay vòng","SpinBot")
createSlider(page3,"Tốc độ xoay",0,100,"SpinSpeed")
createToggle(page3,"💡 Ánh sáng","PlayerLight",function(v)
    local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local l=r and r:FindFirstChild("PlayerPointLight")
    if not v and l then l:Destroy() end
end)
createSlider(page3,"Phạm vi sáng",0,1000,"LightRange")
createSlider(page3,"Độ sáng",0,5,"LightBrightness")

-- TAB4 TIỆN ÍCH
createToggle(page4,"💾 Lưu cài tự động","AutoSave",function(v) if v then saveConfig() end end)
createToggle(page4,"🌈 RGB","RGB",function(v)
    if not v then
        titleLabel.TextColor3=Theme.TextTitle; frameStroke.Color=Theme.Stroke; headerStroke.Color=Theme.Stroke; avatarStroke.Color=Theme.Brand; openStroke.Color=opened and Theme.AccentOff or Theme.Brand
        for _,o in RGBElements do
            if o.Stroke and o.Stroke.Parent then
                if o.Type=="Toggle" then o.Stroke.Color=o.State() and Theme.AccentOn or Theme.Stroke
                elseif o.Type=="Button" then o.Stroke.Color=o.DefaultColor
                else o.Stroke.Color=Theme.Stroke end
            end
        end
    end
end)
createToggle(page4,"📉 Giảm Lag LowGfx","LowGfx",function(v)
    task.spawn(function()
        local n=0
        for _,o in workspace:GetDescendants() do
            if o:IsA("BasePart") then
                if v then if not o:GetAttribute("OM") then o:SetAttribute("OM",o.Material.Name) end; o.Material="SmoothPlastic"
                else local om=o:GetAttribute("OM"); if om then pcall(function() o.Material=Enum.Material[om] end) end end
            elseif o:IsA("Decal") or o:IsA("Texture") then o.Transparency=v and 1 or 0 end
            n+=1; if n%500==0 then task.wait() end
        end
    end)
end)
createToggle(page4,"🖱️ Auto Click","AutoClick")
local of,ob,osv
createToggle(page4,"☀️ Xóa sương","NoFog",function(v)
    if v then of=Lighting.FogEnd; ob=Lighting.Brightness; osv=Lighting.GlobalShadows; Lighting.FogEnd=1e5; Lighting.Brightness=2; Lighting.GlobalShadows=false
    else Lighting.FogEnd=of or 1e5; Lighting.Brightness=ob or 1; Lighting.GlobalShadows=osv end
end)
createToggle(page4,"⬛ Màn đen","BlackScreen",function(v) screenOverlay.BackgroundColor3=Color3.new(0,0,0); screenOverlay.Visible=v end)
createToggle(page4,"⬜ Màn trắng","WhiteScreen",function(v) screenOverlay.BackgroundColor3=Color3.new(1,1,1); screenOverlay.Visible=v end)
createToggle(page4,"🛡️ Chống AFK","AntiAfk")
createDualButtons(page4,"🌞 Sáng",Color3.new(1,.6,.07),function() Lighting.ClockTime=12 end,"🌚 Tối",Color3.new(.63,.13,.94),function() Lighting.ClockTime=0 end)
createDualButtons(page4,"🔄 Vào lại",Theme.AccentOn,function() TeleportService:Teleport(game.PlaceId,player) end,"🎲 Đổi SV",Theme.Brand,function()
    pcall(function()
        local d=HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
        for _,s in d.data do if s.playing<s.maxPlayers and s.id~=game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId,s.id,player) return end end
    end)
end)
createDualButtons(page4,"💻 Admin",Theme.AccentOn,function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgelY/infiniteyield/master/source"))() end) end,"📁 TP Save",Theme.Brand,function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/OBen1/fe/main/Tp%20Place%20GUI"))() end) end)
createDualButtons(page4,"🕊️ Fly V1",Theme.Brand,function() pcall(loadstring,game:HttpGet("https://pastefy.app/TOXICU4j/raw")) end,"🕊️ Fly V3",Theme.Brand,function() pcall(loadstring,game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-V3-X-132770")) end)

-- TAB5 NHẠC
local cs,cmid=nil,""
local mcf=Instance.new("Frame",page5); mcf.Size=UDim2.new(.9,0,0,85); mcf.BackgroundColor3=Theme.ItemBg; mcf.LayoutOrder=1; Instance.new("UICorner",mcf).CornerRadius=UDim.new(0,8)
local ms=Instance.new("UIStroke",mcf); ms.Color=Theme.Stroke; ms.Thickness=1.5; table.insert(RGBElements,{Type="Info",Stroke=ms})
local mib=Instance.new("TextBox",mcf); mib.Size=UDim2.new(.65,0,0,40); mib.Position=UDim2.new(.15,0,0,0); mib.BackgroundTransparency=1; mib.PlaceholderText="Nhập ID nhạc..."; mib.TextColor3=Theme.TextTitle; mib.Font=Enum.Font.GothamSemibold; mib.ClearTextOnFocus=false
local sib=Instance.new("TextButton",mcf); sib.Size=UDim2.new(.2,0,0,40); sib.Position=UDim2.new(.8,0,0,0); sib.BackgroundTransparency=1; sib.Text="💾 Lưu"; sib.TextColor3=Theme.AccentOn; sib.Font=Enum.Font.GothamBold
local npl=Instance.new("TextLabel",mcf); npl.Size=UDim2.new(.9,0,0,45); npl.Position=UDim2.new(.05,0,.5,0); npl.BackgroundTransparency=1; npl.RichText=true; npl.Text="🎵 Chưa phát"; npl.Font=Enum.Font.GothamSemibold
local savedMusic={}
local function gsn(id) local o,i=pcall(MarketplaceService.GetProductInfo,MarketplaceService,tonumber(id)); return o and i.Name or "Ẩn danh" end
local function pm(id)
    if cs then cs:Destroy() end
    local sid=tostring(id):match("%d+") if not sid then return end
    cmid=sid; npl.Text="⏳ Tải..."
    task.spawn(function() local n=gsn(sid); if cmid==sid then npl.Text="<font color='#FFFF00'>🎵 "..n.."</font>" end end)
    cs=Instance.new("Sound"); cs.SoundId="rbxassetid://"..sid; cs.Volume=State.MusicVolume; cs.Parent=workspace; cs:Play()
    cs.Ended:Connect(function() if #savedMusic>0 then local nx; for k,v in savedMusic do if v.id==cmid then nx=k+1 end end; pm(savedMusic[nx and nx<=#savedMusic and nx or 1].id) end end)
end
createDualButtons(page5,"▶️ PHÁT",Theme.AccentOn,function() pm(mib.Text) end,"⏹ DỪNG",Theme.AccentOff,function() if cs then cs:Destroy(); cs=nil; npl.Text="⏹ Đã dừng" end end).LayoutOrder=2
createSlider(page5,"Âm lượng",0,10,"MusicVolume",function(v) if cs then cs.Volume=v end end).LayoutOrder=3
local smc=Instance.new("ScrollingFrame",page5); smc.Size=UDim2.new(.9,0,1,-265); smc.BackgroundTransparency=1; smc.ScrollBarThickness=3; smc.ScrollBarImageColor3=Theme.Brand; smc.LayoutOrder=4
local sl2=Instance.new("UIListLayout",smc); sl2.SortOrder="LayoutOrder"; sl2.Padding=UDim.new(0,8)
sl2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() smc.CanvasSize=UDim2.new(0,0,0,sl2.AbsoluteContentSize.Y+20) end)
pcall(function() if isfile and isfile("MVPM_Music.json") then savedMusic=HttpService:JSONDecode(readfile("MVPM_Music.json")) end end)
local function smd() pcall(function() if writefile then writefile("MVPM_Music.json",HttpService:JSONEncode(savedMusic)) end end) end
local function rsm()
    for _,c in smc:GetChildren() do if c:IsA("Frame") then c:Destroy() end end
    for i,d in savedMusic do
        local it=Instance.new("Frame",smc); it.Size=UDim2.new(1,0,0,48); it.BackgroundColor3=Theme.ItemBg; Instance.new("UICorner",it).CornerRadius=UDim.new(0,8)
        local sk=Instance.new("UIStroke",it); sk.Color=Theme.Stroke; sk.Thickness=1.5; table.insert(RGBElements,{Type="Info",Stroke=sk})
        local nb=Instance.new("TextBox",it); nb.Size=UDim2.new(.52,0,1,0); nb.Position=UDim2.new(.08,0,0,0); nb.Text=d.name; nb.TextColor3=Theme.TextTitle; nb.Font=Enum.Font.GothamSemibold; nb.BackgroundTransparency=1; nb.ClearTextOnFocus=false
        nb.FocusLost:Connect(function() if nb.Text~="" then d.name=nb.Text; smd() else nb.Text=d.name end end)
        local pb=Instance.new("TextButton",it); pb.Size=UDim2.new(.18,0,.6,0); pb.Position=UDim2.new(.62,0,.2,0); pb.Text="▶️"; pb.BackgroundColor3=Theme.Brand; pb.TextColor3=Color3.new(1,1,1); Instance.new("UICorner",pb).CornerRadius=UDim.new(0,6)
        local xb=Instance.new("TextButton",it); xb.Size=UDim2.new(.15,0,.6,0); xb.Position=UDim2.new(.82,0,.2,0); xb.Text="❌"; xb.BackgroundColor3=Theme.AccentOff; xb.TextColor3=Color3.new(1,1,1); Instance.new("UICorner",xb).CornerRadius=UDim.new(0,6)
        pb.MouseButton1Click:Connect(function() mib.Text=d.id; pm(d.id) end)
        xb.MouseButton1Click:Connect(function() table.remove(savedMusic,i); smd(); rsm() end)
    end
end
sib.MouseButton1Click:Connect(function()
    local id=mib.Text:match("%d+") if not id then return end
    table.insert(savedMusic,{id=id,name=gsn(id)}); smd(); rsm()
end); rsm()

-- TAB6 TP SAVE
local savedTp={}
pcall(function() if isfile and isfile("MVPM_TP.json") then savedTp=HttpService:JSONDecode(readfile("MVPM_TP.json")) end end)
local function stpd() pcall(function() if writefile then writefile("MVPM_TP.json",HttpService:JSONEncode(savedTp)) end end) end
local pda=false
createDualButtons(page6,"📍 Lưu vị trí",Theme.Brand,function()
    local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if r then table.insert(savedTp,{name="Vị trí "..(#savedTp+1),cf={r.CFrame:GetComponents()}}); stpd(); renderSavedTps() end
end,"🗑️ XÓA HẾT",Theme.AccentOff,function()
    if not pda then pda=true; MakeToast("⚠️ Xác nhận","Ấn lần nữa để xóa hết",Theme.AccentOff); task.delay(3,function() pda=false end)
    else savedTp={}; stpd(); renderSavedTps(); pda=false end
end).LayoutOrder=1
local stc=Instance.new("ScrollingFrame",page6); stc.Size=UDim2.new(.9,0,1,-114); stc.BackgroundTransparency=1; stc.ScrollBarThickness=3; stc.ScrollBarImageColor3=Theme.Brand; stc.LayoutOrder=2
local tl3=Instance.new("UIListLayout",stc); tl3.SortOrder="LayoutOrder"; tl3.Padding=UDim.new(0,8)
tl3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() stc.CanvasSize=UDim2.new(0,0,0,tl3.AbsoluteContentSize.Y+20) end)
function renderSavedTps()
    for _,c in stc:GetChildren() do if c:IsA("Frame") then c:Destroy() end end
    for i,d in savedTp do
        local it=Instance.new("Frame",stc); it.Size=UDim2.new(1,0,0,48); it.BackgroundColor3=Theme.ItemBg; Instance.new("UICorner",it).CornerRadius=UDim.new(0,8)
        local sk=Instance.new("UIStroke",it); sk.Color=Theme.Stroke; sk.Thickness=1.5; table.insert(RGBElements,{Type="Info",Stroke=sk})
        local nb=Instance.new("TextBox",it); nb.Size=UDim2.new(.45,0,1,0); nb.Position=UDim2.new(.05,0,0,0); nb.Text=d.name; nb.TextColor3=Theme.TextTitle; nb.Font=Enum.Font.GothamSemibold; nb.BackgroundTransparency=1; nb.ClearTextOnFocus=false
        nb.FocusLost:Connect(function() if nb.Text~="" then d.name=nb.Text; stpd() else nb.Text=d.name end end)
        local tb=Instance.new("TextButton",it); tb.Size=UDim2.new(.25,0,.6,0); tb.Position=UDim2.new(.53,0,.2,0); tb.Text="TP"; tb.BackgroundColor3=Theme.Brand; tb.TextColor3=Color3.new(1,1,1); Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6)
        local xb=Instance.new("TextButton",it); xb.Size=UDim2.new(.15,0,.6,0); xb.Position=UDim2.new(.81,0,.2,0); xb.Text="X"; xb.BackgroundColor3=Theme.AccentOff; xb.TextColor3=Color3.new(1,1,1); Instance.new("UICorner",xb).CornerRadius=UDim.new(0,6)
        tb.MouseButton1Click:Connect(function() local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if r then r.CFrame=CFrame.new(unpack(d.cf)) end end)
        xb.MouseButton1Click:Connect(function() table.remove(savedTp,i); stpd(); renderSavedTps() end)
    end
end; renderSavedTps()

-- TAB7 TP PLAYER
local function upl()
    for k,o in RGBElements do if not o.Stroke or not o.Stroke.Parent then table.remove(RGBElements,k) end end
    for _,c in page7:GetChildren() do if c.Name=="PF" then c:Destroy() end end
    for _,p in Players:GetPlayers() do
        if p==player then continue end
        local f=Instance.new("Frame",page7); f.Name="PF"; f.Size=UDim2.new(.9,0,0,48); f.BackgroundTransparency=1
        local b=Instance.new("TextButton",f); b.Size=UDim2.new(1,0,1,0); b.BackgroundColor3=Theme.ItemBg; b.AutoButtonColor=false; Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
        local s=Instance.new("UIStroke",b); s.Color=Theme.Stroke; s.Thickness=1.5; table.insert(RGBElements,{Type="Info",Stroke=s})
        local n1=Instance.new("TextLabel",b); n1.Size=UDim2.new(.7,0,.5,0); n1.Position=UDim2.new(.05,0,.05,0); n1.BackgroundTransparency=1; n1.Text="👤 "..p.DisplayName; n1.TextColor3=Theme.TextTitle; n1.Font=Enum.Font.GothamSemibold; n1.TextXAlignment="Left"
        local n2=Instance.new("TextLabel",b); n2.Size=UDim2.new(.7,0,.45,0); n2.Position=UDim2.new(.05,0,.5,0); n2.BackgroundTransparency=1; n2.Text="@"..p.Name; n2.TextColor3=Color3.new(.4,1,.4); n2.Font=Enum.Font.Gotham; n2.TextSize=10; n2.TextXAlignment="Left"
        b.MouseButton1Click:Connect(function()
            local mr=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local tr=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if mr and tr then mr.CFrame=tr.CFrame end
        end)
    end
end
upl(); Players.PlayerAdded:Connect(upl); Players.PlayerRemoving:Connect(upl)

-- ==========================================
-- ✅ HỆ THỐNG CHÍNH ĐÃ SỬA HOÀN TOÀN
-- ==========================================
local cachedPrompts={}
workspace.DescendantAdded:Connect(function(o) if o:IsA("ProximityPrompt") then table.insert(cachedPrompts,o) end end)
for _,o in workspace:GetDescendants() do if o:IsA("ProximityPrompt") then table.insert(cachedPrompts,o) end end
local opm={}
task.spawn(function()
    while task.wait(1) do
        if State.Instant then
            for i=#cachedPrompts,1,-1 do
                local pr=cachedPrompts[i]
                if pr.Parent then
                    if not opm[pr] then opm[pr]={pr.HoldDuration,pr.MaxActivationDistance} end
                    pr.HoldDuration=0; pr.MaxActivationDistance=30
                else table.remove(cachedPrompts,i) end
            end
        else
            for pr,d in opm do if pr and pr.Parent then pr.HoldDuration=d[1]; pr.MaxActivationDistance=d[2] end end; table.clear(opm)
        end
    end
end)
task.spawn(function()
    while task.wait(.5) do
        pcall(function()
            if State.AutoCollect then
                local mr=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not mr then return end
                for _,pr in cachedPrompts do
                    if pr.Enabled and pr.Parent and (pr.Parent.Position-mr.Position).Magnitude<40 then pcall(function() fireproximityprompt(pr) end) end
                end
            end
        end)
    end
end)
task.spawn(function()
    while task.wait(.06) do
        if State.AutoClick then
            pcall(function()
                local t=player.Character and player.Character:FindFirstChildOfClass("Tool")
                if t then t:Activate(); VirtualInput:SendMouseButtonEvent(0,0,0,true,player,0); task.wait(.02); VirtualInput:SendMouseButtonEvent(0,0,0,false,player,0) end
            end)
        end
    end
end)
player.Idled:Connect(function()
    if State.AntiAfk then pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end
end)

-- ✅ FLY MỚI - KHÔNG KẸT
local flyAt,flyLv,flyAo=nil,nil,nil
local function stopFly()
    pcall(function() if flyLv then flyLv:Destroy() end end)
    pcall(function() if flyAo then flyAo:Destroy() end end)
    pcall(function() if flyAt then flyAt:Destroy() end end)
    flyLv,nil; flyAo=nil; flyAt=nil
    local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h and not State.AntiStun then h.PlatformStand=false end
end
local function updateFly()
    if not State.Fly then stopFly(); return end
    pcall(function()
        local ch=player.Character; local rt=ch and ch:FindFirstChild("HumanoidRootPart"); local hu=ch and ch:FindFirstChildOfClass("Humanoid")
        if not rt then return end
        hu.PlatformStand=true
        if not flyAt or flyAt.Parent~=rt then stopFly(); flyAt=Instance.new("Attachment",rt) end
        if not flyLv or flyLv.Parent~=rt then
            flyLv=Instance.new("LinearVelocity",rt); flyLv.Attachment0=flyAt; flyLv.MaxForce=math.huge; flyLv.VelocityConstraintMode="Vector"; flyLv.RelativeTo="World"
        end
        if not flyAo or flyAo.Parent~=rt then
            flyAo=Instance.new("AlignOrientation",rt); flyAo.Attachment0=flyAt; flyAo.MaxTorque=math.huge; flyAo.Mode="OneAttachment"
        end
        flyAo.CFrame=camera.CFrame
        local md=hu.MoveDirection
        if md.Magnitude>0 then
            local lk=camera.CFrame.LookVector
            flyLv.VectorVelocity=Vector3.new(md.X*State.FlySpeed, lk.Y*State.FlySpeed, md.Z*State.FlySpeed)
        else flyLv.VectorVelocity=Vector3.zero end
    end)
end

-- ✅ ESP + HITBOX HOÀN CHỈNH
local function updateEH()
    if State.Hitbox then
        for _,p in Players:GetPlayers() do
            if p==player then continue end
            local hr=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if hr then
                if not originalHitboxSizes[p] then originalHitboxSizes[p]={hr.Size,hr.Transparency,hr.CanCollide} end
                hr.Size=Vector3.one*State.HitboxSize; hr.Transparency=.5; hr.CanCollide=false
            end
        end
    else
        for p,d in originalHitboxSizes do
            local hr=p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if hr then hr.Size=d[1]; hr.Transparency=d[2]; hr.CanCollide=d[3] end
        end; table.clear(originalHitboxSizes)
    end
    if not State.ESP then
        for _,g in ActiveESPs do pcall(function() g:Destroy() end) end; table.clear(ActiveESPs)
        return
    end
    for _,p in Players:GetPlayers() do
        if p==player then continue end
        pcall(function()
            local tc=p.Character; local ep=tc and (tc:FindFirstChild("HumanoidRootPart") or tc.PrimaryPart)
            if ep then
                local bg=ActiveESPs[p]
                if not bg or bg.Adornee~=ep or not bg.Parent then
                    pcall(function() if bg then bg:Destroy() end end)
                    bg=Instance.new("BillboardGui"); bg.Size=UDim2.new(0,200,0,50); bg.StudsOffset=Vector3.new(0,3.5,0); bg.AlwaysOnTop=true; bg.MaxDistance=9e9; bg.Adornee=ep; bg.Parent=guiParent
                    local lb=Instance.new("TextLabel",bg); lb.Size=UDim2.new(1,0,1,0); lb.BackgroundTransparency=1; lb.TextColor3=Color3.new(1,.23,.23); lb.Font=Enum.Font.GothamBold; lb.TextSize=12; lb.RichText=true; lb.TextStrokeTransparency=.2
                    ActiveESPs[p]=bg
                end
                local mr=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                bg.NameLabel=bg:FindFirstChildOfClass("TextLabel")
                bg.NameLabel.Text = mr and ("%s\n<font color='#00FFFF'>[%dm]</font>"):format(p.DisplayName,(mr.Position-ep.Position).Magnitude) or p.DisplayName
            else
                if ActiveESPs[p] then pcall(function() ActiveESPs[p]:Destroy() end); ActiveESPs[p]=nil end
            end
        end)
    end
    for p,g in ActiveESPs do if not p or not p.Parent then pcall(function() g:Destroy() end); ActiveESPs[p]=nil end end
end

-- ✅ VÒNG CHÍNH CHỈ 2 LUỒNG - GIẢM LAG RẤT NHIỀU
RunService.RenderStepped:Connect(function()
    local ch=player.Character; local rt=ch and ch:FindFirstChild("HumanoidRootPart"); local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hu then return end
    if State.LockPosition and rt then rt.Anchored=true elseif rt and not State.LockPosition then rt.Anchored=false end
    if State.Speed then hu.WalkSpeed=State.SpeedValue elseif hu.WalkSpeed~=defWS and not State.Fly then hu.WalkSpeed=defWS end
    if State.Jump then hu.JumpPower=State.JumpValue end
    if State.AutoDash and rt and hu.MoveDirection.Magnitude>0 then rt.CFrame*=CFrame.new(hu.MoveDirection*(State.DashSpeed/10)) end
    if State.AntiStun then
        hu.PlatformStand=false; hu:SetStateEnabled("FallingDown",false); hu:SetStateEnabled("Ragdoll",false)
        if hu:GetState().Name:match("Fall|Ragdoll") then hu:ChangeState("GettingUp") end
    end
    if State.SpinBot and rt then rt.CFrame*=CFrame.Angles(0,math.rad(State.SpinSpeed),0) end
    if rt then
        local lt=rt:FindFirstChild("PlayerPointLight")
        if State.PlayerLight then
            if not lt then lt=Instance.new("PointLight",rt); lt.Name="PlayerPointLight"; lt.Shadows=false end
            lt.Brightness=State.LightBrightness; lt.Range=State.LightRange
        elseif lt then lt:Destroy() end
    end
    if State.Noclip and ch then
        for _,p in ch:GetDescendants() do
            if p:IsA("BasePart") and not p.Name:match("Foot|Leg") then p.CanCollide=false end
        end
    end
    if State.Reach then
        local tl=ch and ch:FindFirstChildOfClass("Tool")
        if tl then
            for _,o in tl:GetDescendants() do
                if o:IsA("BasePart") then
                    if not originalToolSizes[o] then originalToolSizes[o]={o.Size,o.Transparency,o.Massless,o.CanCollide} end
                    o.Size=Vector3.one*State.ReachSize; o.Massless=true; o.CanCollide=false; o.Transparency=.7
                end
            end
        end
    elseif next(originalToolSizes) then
        for o,d in originalToolSizes do if o and o.Parent then o.Size=d[1]; o.Transparency=d[2]; o.Massless=d[3]; o.CanCollide=d[4] end end; table.clear(originalToolSizes)
    end
end)
RunService.Heartbeat:Connect(function()
    updateEH()
    updateFly()
end)

-- TỰ DỌN KHI THOÁT
player.Removing:Connect(function()
    _G.VIPPRO_MAX_RUNNING=false
    stopFly()
    for _,g in ActiveESPs do pcall(function() g:Destroy() end) end
end)
