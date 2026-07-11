-- ==========================================
-- MENU VIP PRO V1.12.5 (MAX SPEED 1000 & FULL UTILITIES)
-- [BẢN TÍCH HỢP GIAO DIỆN GỐC + CORE TỐI ƯU HÓA]
-- ==========================================
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [FIXED]: Khai báo đầy đủ các biến trạng thái để tránh lỗi nil
local State = {
    Instant = false, Noclip = false, LowGfx = false, Speed = false, Jump = false,
    InfJump = false, PlayerLight = false, ESP = false, AntiAfk = true, AntiStun = false, 
    XRay = false, LockPosition = false, AutoCollect = false, Fly = false, FlySpeed = 50,
    SpinBot = false, SpinSpeed = 50, Hitbox = false, HitboxSize = 15, AutoClick = false, RGB = false,
    Reach = false, ReachSize = 15, AutoDash = false, DashSpeed = 10, AutoSave = false, 
    ShiftLock = false, SpeedValue = 60, JumpValue = 120, LightRange = 60, LightBrightness = 3,
    MusicVolume = 5, NoFog = false, BlackScreen = false, WhiteScreen = false
}

-- [BẢNG MÀU CHỦ ĐẠO]
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
local OriginalStats = { Mats = {} }

local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
    if gethui and type(gethui) == "function" then
        local hui = gethui()
        if hui then guiParent = hui end
    elseif game:GetService("CoreGui") then
        guiParent = game:GetService("CoreGui")
    end
end)

for _, v in pairs(guiParent:GetChildren()) do
    if v.Name == "MobileProMax" then v:Destroy() end
end

local configFileName = "MenuVipProMax_Config.json"
pcall(function()
    if isfile and isfile(configFileName) then
        local data = HttpService:JSONDecode(readfile(configFileName))
        for k, v in pairs(data) do if State[k] ~= nil then State[k] = v end end
    end
end)
local function saveConfig()
    pcall(function() if writefile then writefile(configFileName, HttpService:JSONEncode(State)) end end)
end

-- ==========================================
-- GIAO DIỆN CHÍNH & HỆ THỐNG THÔNG BÁO (TOAST)
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "MobileProMax"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999 -- [FIXED]: Tránh che khuất UI hệ thống
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

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
    colorBar.BackgroundColor3 = color; colorBar.BorderSizePixel = 0; Instance.new("UICorner", colorBar).CornerRadius = UDim.new(1, 0)
    colorBar.BackgroundTransparency = 1

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
        task.wait(0.4); toast:Destroy()
    end)
end

-- [FIXED]: ZIndex của Overlay để nó thực sự che màn hình
local screenOverlay = Instance.new("Frame", gui)
screenOverlay.Size = UDim2.new(2, 0, 2, 0); screenOverlay.Position = UDim2.new(-0.5, 0, -0.5, 0)
screenOverlay.BackgroundColor3 = Color3.new(0,0,0); screenOverlay.ZIndex = 9999; screenOverlay.Visible = false

-- NÚT MỞ MENU 
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 45, 0, 45); openBtn.Position = UDim2.new(0, 15, 0, 15)
openBtn.Text = "MENU"; openBtn.BackgroundColor3 = Theme.MainBg; openBtn.BackgroundTransparency = 0.3
openBtn.TextColor3 = Theme.Brand; openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 14; openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = Theme.Brand; openStroke.Thickness = 2 

local function clickAnimate(obj)
    local scale = Instance.new("UIScale", obj)
    TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.92}):Play()
    task.wait(0.1)
    TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
    task.delay(0.3, function() scale:Destroy() end)
end

local btnDragToggle, btnDragStart, btnStartPos
openBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragToggle = true; btnDragStart = input.Position; btnStartPos = openBtn.Position end end)
UIS.InputChanged:Connect(function(input) if btnDragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then openBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + (input.Position.X - btnDragStart.X), btnStartPos.Y.Scale, btnStartPos.Y.Offset + (input.Position.Y - btnDragStart.Y)) end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragToggle = false end end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 500); frame.Position = UDim2.new(0.5, -210, 0.58, -250)
frame.BackgroundColor3 = Theme.MainBg; frame.BackgroundTransparency = 0.05; frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)
local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = Theme.Stroke; frameStroke.Thickness = 2
table.insert(RGBElements, {Type = "Stroke", Obj = frameStroke})

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45); header.BackgroundColor3 = Theme.HeaderBg; header.BackgroundTransparency = 0; header.BorderSizePixel = 0; header.ZIndex = 10
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)
local headerCover = Instance.new("Frame", header) 
headerCover.Size = UDim2.new(1, 0, 0, 15); headerCover.Position = UDim2.new(0, 0, 1, -15); headerCover.BackgroundColor3 = Theme.HeaderBg; headerCover.BorderSizePixel = 0; headerCover.ZIndex = 10
local headerStroke = Instance.new("UIStroke", header); headerStroke.Color = Theme.Stroke; headerStroke.Thickness = 1.5; headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
table.insert(RGBElements, {Type = "Stroke", Obj = headerStroke})

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, 0, 1, 0); titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MENU VIP PRO MAX V2"
titleLabel.TextColor3 = Theme.TextTitle; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 16; titleLabel.ZIndex = 10
table.insert(RGBElements, {Type = "Text", Obj = titleLabel})

local avatarImg = Instance.new("ImageLabel", header)
avatarImg.Size = UDim2.new(0, 40, 0, 40); avatarImg.Position = UDim2.new(0, 10, 0, 8); avatarImg.BackgroundTransparency = 1; avatarImg.ZIndex = 10
pcall(function() avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
local avatarStroke = Instance.new("UIStroke", avatarImg); avatarStroke.Color = Theme.Brand; avatarStroke.Thickness = 1.5; avatarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local dragToggle, dragStart, startPos
header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = true; dragStart = input.Position; startPos = frame.Position end end)
UIS.InputChanged:Connect(function(input) if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y)) end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)

local tabBar = Instance.new("Frame", frame)
tabBar.Size = UDim2.new(1, 0, 0, 38); tabBar.Position = UDim2.new(0, 0, 0, 45)
tabBar.BackgroundColor3 = Theme.TabBg; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 10

local function createTab(name, x, width)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(width, 0, 1, 0); btn.Position = UDim2.new(x, 0, 0, 0)
    btn.Text = name; btn.BackgroundTransparency = 1; btn.TextColor3 = Theme.TextDim
    btn.BorderSizePixel = 0; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.ZIndex = 10 -- [FIXED]: Phóng to chữ
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0.5, 0, 0, 3); indicator.Position = UDim2.new(0.25, 0, 1, -3)
    indicator.BackgroundColor3 = Theme.Brand; indicator.BorderSizePixel = 0; indicator.Visible = false; indicator.ZIndex = 10
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    return btn, indicator
end

local tab1, ind1 = createTab("THÔNG TIN", 0.00, 0.14)
local tab2, ind2 = createTab("TÍNH NĂNG", 0.14, 0.14)
local tab3, ind3 = createTab("PLAYER",    0.28, 0.14)
local tab4, ind4 = createTab("TIỆN ÍCH",  0.42, 0.14)
local tab5, ind5 = createTab("NHẠC ID",   0.56, 0.12) 
local tab6, ind6 = createTab("TP SAVE",   0.68, 0.15)
local tab7, ind7 = createTab("TP PLAYER", 0.83, 0.17)

local pageContainer = Instance.new("Frame", frame)
pageContainer.Size = UDim2.new(1, 0, 1, -95); pageContainer.Position = UDim2.new(0, 0, 0, 88); pageContainer.BackgroundTransparency = 1; pageContainer.ZIndex = 10

local function createPage()
    local pg = Instance.new("ScrollingFrame", pageContainer)
    pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1
    pg.ScrollBarThickness = 3; pg.ScrollBarImageColor3 = Theme.Brand; pg.Visible = false; pg.BorderSizePixel = 0; pg.ZIndex = 10
    local layout = Instance.new("UIListLayout", pg)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 10); layout.SortOrder = Enum.SortOrder.LayoutOrder 
    Instance.new("UIPadding", pg).PaddingTop = UDim.new(0, 10); Instance.new("UIPadding", pg).PaddingBottom = UDim.new(0, 30) 
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 120) end)
    return pg
end

local page1, page2, page3, page4 = createPage(), createPage(), createPage(), createPage()
local page5, page6 = createPage(), createPage()
local page7 = createPage()

local function showTab(pg, tb, ind)
    for _, p in pairs({page1, page2, page3, page4, page5, page6, page7}) do p.Visible = false end
    for _, t in pairs({tab1, tab2, tab3, tab4, tab5, tab6, tab7}) do t.TextColor3 = Theme.TextDim end
    for _, i in pairs({ind1, ind2, ind3, ind4, ind5, ind6, ind7}) do i.Visible = false end
    pg.Visible = true; tb.TextColor3 = Theme.TextTitle; ind.Visible = true
    ind.Size = UDim2.new(0, 0, 0, 3)
    TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, 0, 0, 3)}):Play()
end

tab1.MouseButton1Click:Connect(function() showTab(page1, tab1, ind1) end)
tab2.MouseButton1Click:Connect(function() showTab(page2, tab2, ind2) end)
tab3.MouseButton1Click:Connect(function() showTab(page3, tab3, ind3) end)
tab4.MouseButton1Click:Connect(function() showTab(page4, tab4, ind4) end)
tab5.MouseButton1Click:Connect(function() showTab(page5, tab5, ind5) end)
tab6.MouseButton1Click:Connect(function() showTab(page6, tab6, ind6) end)
tab7.MouseButton1Click:Connect(function() showTab(page7, tab7, ind7) end)
showTab(page1, tab1, ind1)

local opened = true
openBtn.MouseButton1Click:Connect(function()
    clickAnimate(openBtn); opened = not opened
    if not State.RGB then
        openStroke.Color = opened and Theme.AccentOff or Theme.Brand
        TweenService:Create(openStroke, TweenInfo.new(0.3), {Color = opened and Theme.AccentOff or Theme.Brand}):Play()
    end
    frame:TweenPosition(opened and UDim2.new(0.5, -210, 0.58, -250) or UDim2.new(0.5, -210, 1.2, 0), "Out", "Back", 0.5)
end)

local function createToggle(parent, text, varName, callback)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.9, 0, 0, 44); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 1.5
    
    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(0.7, 0, 1, 0); title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = Theme.TextTitle; title.Font = Enum.Font.GothamSemibold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local status = Instance.new("TextLabel", btn)
    status.Size = UDim2.new(0.2, 0, 1, 0); status.Position = UDim2.new(0.75, 0, 0, 0)
    status.BackgroundTransparency = 1; status.Font = Enum.Font.GothamBold; status.TextSize = 12; status.TextXAlignment = Enum.TextXAlignment.Right; status.ZIndex = 10
    
    local active = State[varName] or false
    status.Text = active and "ON" or "OFF"; status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
    stroke.Color = active and Theme.AccentOn or Theme.Stroke
    btn.BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg
    
    table.insert(RGBElements, {Type = "Toggle", Obj = stroke, State = function() return State[varName] end})

    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); State[varName] = not State[varName]; active = State[varName]
        status.Text = active and "ON" or "OFF"
        TweenService:Create(status, TweenInfo.new(0.2), {TextColor3 = active and Theme.AccentOn or Theme.AccentOff}):Play()
        if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.2), {Color = active and Theme.AccentOn or Theme.Stroke}):Play() end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg}):Play()
        
        if varName ~= "AutoSave" then MakeToast(active and "Đã Bật" or "Đã Tắt", text, active and Theme.AccentOn or Theme.AccentOff) end
        if State.AutoSave then saveConfig() end
        if callback then callback(active) end
    end)
    if active and callback then task.spawn(callback, active) end
    return btnFrame
end

local function createButton(parent, text, color, callback)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.9, 0, 0, 42); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = color; stroke.Thickness = 1.5; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RGBElements, {Type = "Stroke", Obj = stroke, DefaultColor = color})
    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = color; title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
        task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = color}):Play() end
        MakeToast("Đã thực thi", text, color)
        if callback then callback() end
    end)
    return btnFrame
end

local function createDualButtons(parent, text1, color1, cb1, text2, color2, cb2)
    local dFrame = Instance.new("Frame", parent)
    dFrame.Size = UDim2.new(0.9, 0, 0, 42); dFrame.BackgroundTransparency = 1
    local function makeBtn(xPos, txt, col, cb)
        local btn = Instance.new("TextButton", dFrame)
        btn.Size = UDim2.new(0.48, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn); stroke.Color = col; stroke.Thickness = 1.5; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(RGBElements, {Type = "Stroke", Obj = stroke, DefaultColor = col})
        local title = Instance.new("TextLabel", btn)
        title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = txt; title.TextColor3 = col; title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.ZIndex = 10
        btn.MouseButton1Click:Connect(function()
            clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
            task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = col}):Play() end
            if txt ~= "🗑️ XÓA TẤT CẢ" then MakeToast("Đã thực thi", txt, col) end
            if cb then cb() end
        end)
    end
    makeBtn(0, text1, color1, cb1); makeBtn(0.52, text2, color2, cb2)
    return dFrame
end

local function createSlider(parent, text, min, max, varName, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.9, 0, 0, 48); frame.BackgroundTransparency = 1
    local bg = Instance.new("Frame", frame); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Theme.ItemBg; bg.ZIndex = 10
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", bg); stroke.Color = Theme.Stroke; stroke.Thickness = 1.5
    table.insert(RGBElements, {Type = "Stroke", Obj = stroke})
    local titleLabel = Instance.new("TextLabel", bg)
    titleLabel.Size = UDim2.new(0.7, 0, 0.4, 0); titleLabel.Position = UDim2.new(0.05, 0, 0.1, 0); titleLabel.BackgroundTransparency = 1; titleLabel.Text = text; titleLabel.TextColor3 = Theme.TextDim; titleLabel.Font = Enum.Font.GothamSemibold; titleLabel.TextSize = 12; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.ZIndex = 10
    local valLabel = Instance.new("TextLabel", bg)
    valLabel.Size = UDim2.new(0.25, 0, 0.4, 0); valLabel.Position = UDim2.new(0.7, 0, 0.1, 0); valLabel.BackgroundTransparency = 1; valLabel.Text = tostring(State[varName]); valLabel.TextColor3 = Theme.Brand; valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 12; valLabel.TextXAlignment = Enum.TextXAlignment.Right; valLabel.ZIndex = 10
    local track = Instance.new("Frame", bg)
    track.Size = UDim2.new(0.9, 0, 0.15, 0); track.Position = UDim2.new(0.05, 0, 0.65, 0); track.BackgroundColor3 = Theme.MainBg; track.ZIndex = 10
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((State[varName] - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Theme.AccentOn; fill.ZIndex = 10
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        valLabel.Text = tostring(value); TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        State[varName] = value
        if callback then callback(value) end
        if State.AutoSave then saveConfig() end
    end
    track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; updateSlider(input) end end)
    UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    if callback then task.spawn(callback, State[varName]) end
    return frame
end

-- ==========================================
-- [LUỒNG TỐI ƯU RGB - FIX LEAK MEMORY]
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        if State.RGB then
            local hue = tick() % 5 / 5; local color = Color3.fromHSV(hue, 1, 1)
            for i = #RGBElements, 1, -1 do
                local data = RGBElements[i]
                if data.Obj and data.Obj.Parent then
                    if data.Type == "Toggle" then data.Obj.Color = data.State() and Theme.AccentOn or color
                    elseif data.Type == "Stroke" then data.Obj.Color = color
                    elseif data.Type == "Text" then data.Obj.TextColor3 = color end
                else
                    table.remove(RGBElements, i)
                end
            end
        end
    end
end)

-- ==========================================
-- [TAB 1: THÔNG TIN - DASHBOARD]
-- ==========================================
local function createInfoBox(parent, icon, titleText, heightOffset)
    local item = Instance.new("Frame", parent)
    item.Size = UDim2.new(0.9, 0, 0, heightOffset or 85); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1.5; table.insert(RGBElements, {Type = "Stroke", Obj = stroke})
    local title = Instance.new("TextLabel", item)
    title.Size = UDim2.new(1, -20, 0, 25); title.Position = UDim2.new(0, 10, 0, 5); title.BackgroundTransparency = 1; title.Text = icon .. " " .. titleText; title.TextColor3 = Theme.Brand; title.Font = Enum.Font.GothamBold; title.TextSize = 12; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local content = Instance.new("TextLabel", item)
    content.Size = UDim2.new(1, -20, 1, -35); content.Position = UDim2.new(0, 10, 0, 30); content.BackgroundTransparency = 1; content.Text = "Đang tải..."; content.TextColor3 = Theme.TextTitle; content.Font = Enum.Font.Gotham; content.TextSize = 11; content.TextXAlignment = Enum.TextXAlignment.Left; content.TextYAlignment = Enum.TextYAlignment.Top; content.RichText = true; content.ZIndex = 10
    return content, item
end

local playerInfoLabel = createInfoBox(page1, "👤", "THÔNG TIN NHÂN VẬT", 100)
local serverInfoLabel, serverInfoFrame = createInfoBox(page1, "🌐", "THÔNG TIN MÁY CHỦ", 85)

local copyIdBtn = Instance.new("TextButton", serverInfoFrame)
copyIdBtn.Size = UDim2.new(0, 24, 0, 24); copyIdBtn.Position = UDim2.new(1, -30, 1, -28); copyIdBtn.Text = "📜"; copyIdBtn.BackgroundTransparency = 1; copyIdBtn.TextSize = 14; copyIdBtn.ZIndex = 11
copyIdBtn.MouseButton1Click:Connect(function()
    clickAnimate(copyIdBtn)
    pcall(function() if setclipboard then setclipboard(tostring(game.JobId)); MakeToast("Đã Copy", "Đã lưu ID Server vào bộ nhớ tạm", Theme.AccentOn); local oldText = copyIdBtn.Text; copyIdBtn.Text = "✅"; task.wait(1); copyIdBtn.Text = oldText end end)
end)

local joinIdFrame = Instance.new("Frame", page1)
joinIdFrame.Size = UDim2.new(0.9, 0, 0, 44); joinIdFrame.BackgroundColor3 = Theme.ItemBg; joinIdFrame.ZIndex = 10
Instance.new("UICorner", joinIdFrame).CornerRadius = UDim.new(0, 8)
local jStroke = Instance.new("UIStroke", joinIdFrame); jStroke.Color = Theme.Stroke; jStroke.Thickness = 1.5; table.insert(RGBElements, {Type = "Stroke", Obj = jStroke})
local idBox = Instance.new("TextBox", joinIdFrame)
idBox.Size = UDim2.new(0.65, 0, 1, 0); idBox.Position = UDim2.new(0.05, 0, 0, 0); idBox.BackgroundTransparency = 1; idBox.PlaceholderText = "Dán ID Server vào đây..."; idBox.Text = ""; idBox.TextColor3 = Theme.Brand; idBox.Font = Enum.Font.Gotham; idBox.TextSize = 11; idBox.TextXAlignment = Enum.TextXAlignment.Left; idBox.ClearTextOnFocus = false; idBox.ZIndex = 10
local joinBtn = Instance.new("TextButton", joinIdFrame)
joinBtn.Size = UDim2.new(0.25, 0, 0.65, 0); joinBtn.Position = UDim2.new(0.72, 0, 0.175, 0); joinBtn.BackgroundColor3 = Theme.AccentOn; joinBtn.Text = "VÀO"; joinBtn.TextColor3 = Color3.new(1, 1, 1); joinBtn.Font = Enum.Font.GothamBold; joinBtn.TextSize = 11; joinBtn.ZIndex = 10
Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 6)
joinBtn.MouseButton1Click:Connect(function() clickAnimate(joinBtn); local targetId = idBox.Text:gsub("%s+", ""); if targetId ~= "" then MakeToast("Đang Join", "Đang chuyển máy chủ...", Theme.AccentOn); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player) end) end end)

local extraInfoLabel = createInfoBox(page1, "⚙️", "TRẠNG THÁI", 80)
local fps = 0; RunService.RenderStepped:Connect(function(dt) fps = math.floor(1/dt) end)

task.spawn(function()
    while task.wait(0.5) do
        local hp, maxHp, ws, jp = 0, 0, 0, 0
        local coords = "0, 0, 0"
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            hp = math.floor(hum.Health); maxHp = math.floor(hum.MaxHealth)
            ws = math.floor(hum.WalkSpeed); jp = math.floor(hum.JumpHeight) -- [FIXED]: Dùng JumpHeight thay vì JumpPower
        end
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            coords = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        end
        playerInfoLabel.Text = string.format("<font color='#FF00FF'>Tên:</font> %s (@%s)\n<font color='#FF00FF'>Máu:</font> %d / %d\n<font color='#FF00FF'>Tốc độ:</font> %d\n<font color='#FF00FF'>Lực nhảy:</font> %d\n<font color='#FF00FF'>Tọa độ:</font> %s", player.DisplayName, player.Name, hp, maxHp, ws, jp, coords)
        
        local ping = "0"
        pcall(function() local stats = game:GetService("Stats"); if stats and stats:FindFirstChild("Network") and stats.Network:FindFirstChild("ServerStatsItem") then ping = stats.Network.ServerStatsItem["Data Ping"]:GetValueString() else ping = tostring(math.floor(player:GetNetworkPing() * 1000)) .. " ms" end end)
        local pCount = #Players:GetPlayers(); local maxP = Players.MaxPlayers; local jobText = game.JobId ~= "" and string.sub(game.JobId, 1, 15).."..." or "N/A"
        serverInfoLabel.Text = string.format("<font color='#FF00FF'>FPS:</font> %d\n<font color='#FF00FF'>Ping:</font> %s\n<font color='#FF00FF'>Người chơi:</font> %d / %d\n<font color='#FF00FF'>ID SV:</font> %s", fps, ping, pCount, maxP, jobText)
        local execTime = math.floor(workspace.DistributedGameTime); local hours = math.floor(execTime / 3600); local mins = math.floor((execTime % 3600) / 60); local secs = execTime % 60
        extraInfoLabel.Text = string.format("<font color='#FF00FF'>Thời gian chơi:</font> %02d:%02d:%02d\n<font color='#FF00FF'>Giờ hệ thống:</font> %s\n<font color='#FF00FF'>Phiên bản:</font> MENU VIP PRO MAX V2", hours, mins, secs, os.date("%H:%M:%S"))
    end
end)

-- ==========================================
-- [TAB 2: TÍNH NĂNG]
-- ==========================================
createToggle(page2, "🛡️ Chống ngã", "AntiStun")
createToggle(page2, "🔒 Khóa vị trí", "LockPosition", function(v) if not v and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.Anchored = false end end)
createToggle(page2, "🚀 Nhảy trên không", "InfJump") 
UIS.JumpRequest:Connect(function() if State.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)
createToggle(page2, "🐿️ Lấy đồ nhanh", "Instant")
createToggle(page2, "🧲 Auto nhặt đồ xung quanh", "AutoCollect")
createToggle(page2, "🚷 Đi xuyên tường", "Noclip")

-- [FIXED]: XRay An Toàn không làm mất Trans gốc
local XRayCache = {}
createToggle(page2, "👀 Nhìn xuyên map", "XRay", function(v) 
    if v then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency < 0.5 and obj.Name ~= "Terrain" then
                XRayCache[obj] = obj.Transparency
                obj.Transparency = 0.5
            end
        end
    else
        for obj, trans in pairs(XRayCache) do
            if obj and obj.Parent then obj.Transparency = trans end
        end
        XRayCache = {}
    end
end)

local function UpdateESP()
    if not State.ESP then
        for p, gui in pairs(ActiveESPs) do if gui then gui:Destroy() end end; ActiveESPs = {}
        for _, p in pairs(Players:GetPlayers()) do if p ~= player and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end end
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            local hrp = p.Character.HumanoidRootPart
            local gui = ActiveESPs[p]
            if not gui or not gui.Parent then
                gui = Instance.new("BillboardGui")
                gui.Size = UDim2.new(0, 200, 0, 50); gui.AlwaysOnTop = true; gui.Adornee = hrp; gui.Parent = guiParent
                local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1
                txt.TextColor3 = Color3.fromRGB(255, 50, 50); txt.TextStrokeTransparency = 0.2; txt.Font = Enum.Font.GothamBold; txt.TextSize = 12
                ActiveESPs[p] = gui
            end
            local dist = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
            gui:GetChildren()[1].Text = p.DisplayName .. " ["..dist.."m]"
        end
    end
    -- Cleanup rác Memory
    for p, gui in pairs(ActiveESPs) do if not p or not p.Parent then gui:Destroy(); ActiveESPs[p] = nil end end
end
createToggle(page2, "🔴 ESP người chơi", "ESP")

-- ==========================================
-- [TAB 3: PLAYER]
-- ==========================================
createToggle(page3, "🕊️ Bay Trên không (FLY)", "Fly")
createSlider(page3, "Tốc độ bay", 10, 1000, "FlySpeed")

local defaultWalkSpeed = 16
createToggle(page3, "🏃 Chạy nhanh", "Speed", function(v) 
    if player.Character and player.Character:FindFirstChild("Humanoid") then 
        if v then defaultWalkSpeed = player.Character.Humanoid.WalkSpeed else player.Character.Humanoid.WalkSpeed = defaultWalkSpeed end
    end 
end)
createSlider(page3, "Tốc độ chạy", 1, 1000, "SpeedValue")

local defaultJumpHeight = 7.2
createToggle(page3, "🦘 Nhảy cao", "Jump", function(v) 
    if player.Character and player.Character:FindFirstChild("Humanoid") then 
        if v then defaultJumpHeight = player.Character.Humanoid.JumpHeight else player.Character.Humanoid.UseJumpPower = false; player.Character.Humanoid.JumpHeight = defaultJumpHeight end
    end 
end)
createSlider(page3, "Lực nhảy", 1, 1000, "JumpValue")

createToggle(page3, "💨 Lướt liên tục", "AutoDash")
createSlider(page3, "Tốc độ lướt", 1, 50, "DashSpeed")

createToggle(page3, "⚔️ Đánh xa", "Reach")
createSlider(page3, "Kích thước vũ khí", 0, 300, "ReachSize")

-- [FIXED]: Hitbox tối ưu hóa
local function ApplyHitbox()
    if State.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if not originalHitboxSizes[p] then originalHitboxSizes[p] = hrp.Size end
                hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                hrp.Transparency = 0.6; hrp.CanCollide = false
            end
        end
    else
        for p, size in pairs(originalHitboxSizes) do
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = size; p.Character.HumanoidRootPart.Transparency = 1; p.Character.HumanoidRootPart.CanCollide = true
            end
        end
        originalHitboxSizes = {}
    end
end
createToggle(page3, "🎯 Hitbox", "Hitbox", ApplyHitbox)
createSlider(page3, "Kích thước Hitbox", 0, 100, "HitboxSize", ApplyHitbox)

createToggle(page3, "🌪️ Xoay vòng tròn", "SpinBot")
createSlider(page3, "Tốc độ xoay", 0, 100, "SpinSpeed")
createToggle(page3, "💡 Ánh sáng quanh người", "PlayerLight", function(v) if not v and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then local light = player.Character.HumanoidRootPart:FindFirstChild("PlayerPointLight"); if light then light:Destroy() end end end)
createSlider(page3, "Phạm vi sáng", 0, 1000, "LightRange")
createSlider(page3, "Độ sáng", 0, 5, "LightBrightness")

-- ==========================================
-- [TAB 4: TIỆN ÍCH]
-- ==========================================
createToggle(page4, "💾 Lưu Cài Đặt", "AutoSave", function(v) 
    if v then saveConfig() else pcall(function() if isfile and isfile(configFileName) then delfile(configFileName) end end) end 
end)

createToggle(page4, "🌈 Chế độ RGB", "RGB", function(v) 
    if not v then 
        titleLabel.TextColor3 = Theme.TextTitle; frameStroke.Color = Theme.Stroke; headerStroke.Color = Theme.Stroke; avatarStroke.Color = Theme.Brand; openStroke.Color = opened and Theme.AccentOff or Theme.Brand
        for _, obj in pairs(RGBElements) do
            if obj.Obj and obj.Obj.Parent then
                if obj.Type == "Toggle" then obj.Obj.Color = obj.State() and Theme.AccentOn or Theme.Stroke
                elseif obj.Type == "Stroke" then obj.Obj.Color = obj.DefaultColor or Theme.Stroke end
            end
        end
    end 
end)

createToggle(page4, "📉 Giảm Lag (Low GFX)", "LowGfx", function(v)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                if v then if not obj:GetAttribute("OldMat") then obj:SetAttribute("OldMat", obj.Material.Name) end; obj.Material = Enum.Material.SmoothPlastic else local old = obj:GetAttribute("OldMat"); if old then obj.Material = Enum.Material[old] end end
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = v and 1 or 0 end
        end
    end)
end)

createToggle(page4, "💫 Mở khóa ShiftLock Mobile", "ShiftLock", function(v) pcall(function() player.DevEnableMouseLock = v end) end)
createToggle(page4, "🖱️ Auto Click", "AutoClick")

task.spawn(function()
    while task.wait(0.05) do
        if State.AutoClick and player.Character then pcall(function() local tool = player.Character:FindFirstChildOfClass("Tool"); if tool then tool:Activate() end end) end
    end
end)

local origFog, origBright, origShadow
createToggle(page4, "☀️ Xóa sương mù", "NoFog", function(v) 
    if v then origFog = Lighting.FogEnd; origBright = Lighting.Brightness; origShadow = Lighting.GlobalShadows; Lighting.FogEnd = 100000; Lighting.Brightness = 2; Lighting.GlobalShadows = false
    else Lighting.FogEnd = origFog or 100000; Lighting.Brightness = origBright or 1; Lighting.GlobalShadows = origShadow end
end)
createToggle(page4, "⬛ Màn hình đen (treo máy)", "BlackScreen", function(v) screenOverlay.BackgroundColor3 = Color3.new(0, 0, 0); screenOverlay.Visible = v end)
createToggle(page4, "⬜ Màn hình trắng", "WhiteScreen", function(v) screenOverlay.BackgroundColor3 = Color3.new(1, 1, 1); screenOverlay.Visible = v end)
createToggle(page4, "🛡️ Chống AFK (Antiafk)", "AntiAfk")

-- [FIXED]: Dùng Roproxy cho ServerHop vì Roblox chặn API gốc
local function hopServer(sortOrder)
    MakeToast("Đang tìm server...", "Vui lòng chờ giây lát", Theme.Brand)
    local api = "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=100"
    local function getServers(cursor) local url = api .. (cursor and "&cursor=" .. cursor or ""); local success, res = pcall(game.HttpGet, game, url); if success then return HttpService:JSONDecode(res) end end
    local nextCursor = nil; local targetServer = nil
    repeat
        local data = getServers(nextCursor); if not data or not data.data then break end
        for _, s in pairs(data.data) do
            if s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
                if sortOrder == "Asc" then if s.playing > 0 then targetServer = s; break end else targetServer = s; break end
            end
        end
        if targetServer then break end; nextCursor = data.nextPageCursor
    until not nextCursor
    if targetServer then TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, player) else MakeToast("Lỗi", "Không tìm thấy Server!", Theme.AccentOff) end
end
local function rejoinServer()
    if #Players:GetPlayers() <= 1 then player:Kick("\nĐang vào lại server..."); task.wait(); TeleportService:Teleport(game.PlaceId, player) else TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end
end

createDualButtons(page4, "🌞 Trời SÁNG (Fake)", Color3.fromRGB(243, 156, 18), function() Lighting.ClockTime = 12 end, "🌚 Trời TỐI (Fake)", Color3.fromRGB(160, 32, 240), function() Lighting.ClockTime = 0 end)
createDualButtons(page4, "🔄 VÀO LẠI SV", Theme.AccentOn, rejoinServer, "🎲 ĐỔI SV NGẪU NHIÊN", Theme.Brand, function() hopServer("Desc") end)
createDualButtons(page4, "📉 ĐỔI SV ÍT NGƯỜI", Color3.fromRGB(52, 152, 219), function() hopServer("Asc") end, "📈 ĐỔI SV NHIỀU NGƯỜI", Color3.fromRGB(231, 76, 60), function() hopServer("Desc") end)

-- [FIXED]: Sửa lỗi syntax game: HttpGet()
createDualButtons(page4, "💻 LỆNH ADMIN", Theme.AccentOn, function() 
    pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgelY/infiniteyield/master/source'))() end) 
end, "📁 TP SAVE V3", Theme.Brand, function() 
    pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/OBen1/fe/main/Tp%20Place%20GUI', true))() end) 
end)

createDualButtons(page4, "🕊️ FLY V1", Theme.Brand, function() 
    pcall(function() loadstring(game:HttpGet('https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f425b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%25202%2520obflucator', true))() end) 
end, "🕊️ FLY V3", Theme.Brand, function() 
    pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-V3-X-132770"))() end) 
end)

-- ==========================================
-- [TAB 5: NHẠC ID] & [TAB 6: TP SAVE] 
-- ==========================================
local currentSound = nil; local currentMusicId = ""; local savedMusicList = {}
local musicControlFrame = Instance.new("Frame", page5); musicControlFrame.Size = UDim2.new(0.9, 0, 0, 85); musicControlFrame.BackgroundColor3 = Theme.ItemBg; musicControlFrame.ZIndex = 10; musicControlFrame.LayoutOrder = 1; Instance.new("UICorner", musicControlFrame).CornerRadius = UDim.new(0, 8)
local mStroke = Instance.new("UIStroke", musicControlFrame); mStroke.Color = Theme.Stroke; mStroke.Thickness = 1.5; table.insert(RGBElements, {Type = "Stroke", Obj = mStroke})
local musicIcon = Instance.new("TextLabel", musicControlFrame); musicIcon.Size = UDim2.new(0.15, 0, 0, 40); musicIcon.BackgroundTransparency = 1; musicIcon.Text = "🎼"; musicIcon.TextSize = 18; musicIcon.ZIndex = 10
local musicIdBox = Instance.new("TextBox", musicControlFrame); musicIdBox.Size = UDim2.new(0.65, 0, 0, 40); musicIdBox.Position = UDim2.new(0.15, 0, 0, 0); musicIdBox.BackgroundTransparency = 1; musicIdBox.PlaceholderText = "Nhập ID Nhạc..."; musicIdBox.Text = ""; musicIdBox.TextColor3 = Theme.TextTitle; musicIdBox.Font = Enum.Font.GothamSemibold; musicIdBox.TextSize = 12; musicIdBox.TextXAlignment = Enum.TextXAlignment.Left; musicIdBox.ClearTextOnFocus = false; musicIdBox.ZIndex = 10
local saveIdBtn = Instance.new("TextButton", musicControlFrame); saveIdBtn.Size = UDim2.new(0.2, 0, 0, 40); saveIdBtn.Position = UDim2.new(0.8, 0, 0, 0); saveIdBtn.BackgroundTransparency = 1; saveIdBtn.Text = "💾 Lưu"; saveIdBtn.TextColor3 = Theme.AccentOn; saveIdBtn.Font = Enum.Font.GothamBold; saveIdBtn.TextSize = 11; saveIdBtn.ZIndex = 10
local divLine = Instance.new("Frame", musicControlFrame); divLine.Size = UDim2.new(0.9, 0, 0, 1); divLine.Position = UDim2.new(0.05, 0, 0, 40); divLine.BackgroundColor3 = Theme.Stroke; divLine.BorderSizePixel = 0; divLine.ZIndex = 10
local nowPlayingLabel = Instance.new("TextLabel", musicControlFrame); nowPlayingLabel.Size = UDim2.new(0.9, 0, 0, 45); nowPlayingLabel.Position = UDim2.new(0.05, 0, 0, 40); nowPlayingLabel.BackgroundTransparency = 1; nowPlayingLabel.RichText = true; nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Chưa có nhạc phát</font>"; nowPlayingLabel.Font = Enum.Font.GothamSemibold; nowPlayingLabel.TextSize = 13; nowPlayingLabel.TextWrapped = true; nowPlayingLabel.ZIndex = 10

local function getSongName(id) local numId = tonumber(id); if not numId then return "ID sai!" end; local s, info = pcall(function() return MarketplaceService:GetProductInfo(numId) end); if s and info then return info.Name else return "Ẩn danh" end end
local function playMusic(id)
    if currentSound then currentSound:Destroy() end; local soundId = tostring(id):match("%d+"); if not soundId or soundId == "" then return end
    currentMusicId = soundId; nowPlayingLabel.Text = "<font color='#FFFFFF'>⏳ Tải...</font>"
    task.spawn(function() local name = getSongName(soundId); if currentMusicId == soundId then nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Phát:</font> <font color='#FFFF00'>" .. name .. "</font>" end end)
    currentSound = Instance.new("Sound"); currentSound.SoundId = "rbxassetid://" .. soundId
    currentSound.Volume = State.MusicVolume / 10 -- [FIXED]: Convert 0-10 sang 0-1
    currentSound.Parent = workspace
    currentSound.Ended:Connect(function()
        if #savedMusicList > 0 then
            local cx = 0; for i, v in ipairs(savedMusicList) do if v.id == currentMusicId then cx = i; break end end
            local nx = cx + 1; if nx > #savedMusicList then nx = 1 end; playMusic(savedMusicList[nx].id)
        end
    end)
    currentSound:Play()
end
local function stopMusic() if currentSound then currentSound:Stop(); currentSound:Destroy(); currentSound = nil; currentMusicId = ""; nowPlayingLabel.Text = "<font color='#FFFFFF'>⏹ Đã dừng nhạc</font>" end end

local playControlFrame = createDualButtons(page5, "▶️ PHÁT NHẠC", Theme.AccentOn, function() playMusic(musicIdBox.Text) end, "⏸️ TẮT NHẠC", Theme.AccentOff, function() stopMusic() end); playControlFrame.LayoutOrder = 2
local volumeFrame = createSlider(page5, "ÂM LƯỢNG 🔊", 0, 10, "MusicVolume", function(val) if currentSound then currentSound.Volume = val / 10 end end); volumeFrame.LayoutOrder = 3
local savedMusicContent = Instance.new("ScrollingFrame", page5); savedMusicContent.Size = UDim2.new(0.9, 0, 1, -265); savedMusicContent.BackgroundTransparency = 1; savedMusicContent.ScrollBarThickness = 3; savedMusicContent.ScrollBarImageColor3 = Theme.Brand; savedMusicContent.BorderSizePixel = 0; savedMusicContent.ZIndex = 10; savedMusicContent.LayoutOrder = 4
local sLayout = Instance.new("UIListLayout", savedMusicContent); sLayout.SortOrder = Enum.SortOrder.LayoutOrder; sLayout.Padding = UDim.new(0, 8)
sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedMusicContent.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 20) end)

local fileName = "MenuVipProMax_SavedMusic.json"
pcall(function() if isfile and isfile(fileName) then local decoded = HttpService:JSONDecode(readfile(fileName)); if type(decoded) == "table" then savedMusicList = decoded end end end)
local function saveMusicData() pcall(function() if writefile then writefile(fileName, HttpService:JSONEncode(savedMusicList)) end end) end
local function renderSavedMusic()
    for _, child in pairs(savedMusicContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for i, data in ipairs(savedMusicList) do
        local item = Instance.new("Frame", savedMusicContent); item.Size = UDim2.new(1, 0, 0, 48); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1.5; table.insert(RGBElements, {Type = "Stroke", Obj = stroke})
        local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.52, 0, 1, 0); nameBox.Position = UDim2.new(0.08, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 11; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
        nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveMusicData() else nameBox.Text = data.name end end)
        local playBtn = Instance.new("TextButton", item); playBtn.Size = UDim2.new(0.18, 0, 0.6, 0); playBtn.Position = UDim2.new(0.62, 0, 0.2, 0); playBtn.Text = "▶️"; playBtn.BackgroundColor3 = Theme.Brand; playBtn.TextColor3 = Color3.new(1,1,1); playBtn.Font = Enum.Font.GothamBold; playBtn.TextSize = 11; playBtn.ZIndex = 10; Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)
        local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.6, 0); delBtn.Position = UDim2.new(0.82, 0, 0.2, 0); delBtn.Text = "❌"; delBtn.BackgroundColor3 = Theme.AccentOff; delBtn.TextColor3 = Color3.new(1,1,1); delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 12; delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        playBtn.MouseButton1Click:Connect(function() clickAnimate(playBtn); musicIdBox.Text = data.id; playMusic(data.id) end)
        delBtn.MouseButton1Click:Connect(function() clickAnimate(delBtn); table.remove(savedMusicList, i); saveMusicData(); renderSavedMusic() end)
    end
end
saveIdBtn.MouseButton1Click:Connect(function() clickAnimate(saveIdBtn); local rawId = musicIdBox.Text:match("%d+"); if rawId and rawId ~= "" then saveIdBtn.Text = "⏳..."; task.spawn(function() local name = getSongName(rawId); table.insert(savedMusicList, {id = rawId, name = name}); saveMusicData(); renderSavedMusic(); saveIdBtn.Text = "💾 Lưu" end) end end)
renderSavedMusic()

local tpFileName = "MenuVipProMax_SavedTPs.json"; local savedTpList = {}; pcall(function() if isfile and isfile(tpFileName) then local decoded = HttpService:JSONDecode(readfile(tpFileName)); if type(decoded) == "table" then savedTpList = decoded end end end)
local function saveTpData() pcall(function() if writefile then local d = {}; for _, v in ipairs(savedTpList) do if not v.isTemp then table.insert(d, v) end end; writefile(tpFileName, HttpService:JSONEncode(d)) end end) end
local pendingDeleteAll = false

local function renderSavedTps()
    -- Forward declaration
end

local tpControlFrame_New = createDualButtons(page6, "📍 LƯU VỊ TRÍ", Theme.Brand, function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart; local cf = {root.CFrame:GetComponents()}; local mx = 0
        for _, v in ipairs(savedTpList) do local num = string.match(v.name, "Lưu Vị Trí (%d+)"); if num then mx = math.max(mx, tonumber(num)) end end
        table.insert(savedTpList, {name = "Lưu Vị Trí " .. (mx + 1), cframe = cf, isTemp = false}); saveTpData(); renderSavedTps()
    end
end, "🗑️ XÓA TẤT CẢ", Theme.AccentOff, function() 
    if not pendingDeleteAll then pendingDeleteAll = true; MakeToast("⚠️ CẢNH BÁO", "Ấn lần nữa để xác nhận xóa sạch!", Theme.AccentOff); task.delay(3, function() pendingDeleteAll = false end)
    else savedTpList = {}; saveTpData(); renderSavedTps(); MakeToast("Thành công", "Đã xóa toàn bộ!", Theme.Brand); pendingDeleteAll = false end
end); tpControlFrame_New.LayoutOrder = 1 

local savedTpContent = Instance.new("ScrollingFrame", page6); savedTpContent.Size = UDim2.new(0.9, 0, 1, -114); savedTpContent.BackgroundTransparency = 1; savedTpContent.ScrollBarThickness = 3; savedTpContent.ScrollBarImageColor3 = Theme.Brand; savedTpContent.BorderSizePixel = 0; savedTpContent.ZIndex = 10; savedTpContent.LayoutOrder = 2
local tpLayout = Instance.new("UIListLayout", savedTpContent); tpLayout.SortOrder = Enum.SortOrder.LayoutOrder; tpLayout.Padding = UDim.new(0, 8)
tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedTpContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 20) end)

function renderSavedTps()
    for _, child in pairs(savedTpContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for i, data in ipairs(savedTpList) do
        local item = Instance.new("Frame", savedTpContent); item.Size = UDim2.new(1, 0, 0, 48); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1.5; table.insert(RGBElements, {Type = "Stroke", Obj = stroke})
        local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.45, 0, 1, 0); nameBox.Position = UDim2.new(0.05, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 12; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
        nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveTpData() else nameBox.Text = data.name end end)
        local tpBtn = Instance.new("TextButton", item); tpBtn.Size = UDim2.new(0.25, 0, 0.6, 0); tpBtn.Position = UDim2.new(0.53, 0, 0.2, 0); tpBtn.Text = "TP"; tpBtn.BackgroundColor3 = Theme.Brand; tpBtn.TextColor3 = Color3.new(1,1,1); tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 11; tpBtn.ZIndex = 10; Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
        local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.6, 0); delBtn.Position = UDim2.new(0.81, 0, 0.2, 0); delBtn.Text = "X"; delBtn.BackgroundColor3 = Theme.AccentOff; delBtn.TextColor3 = Color3.new(1,1,1); delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 12; delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        tpBtn.MouseButton1Click:Connect(function() clickAnimate(tpBtn); if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(unpack(data.cframe)); MakeToast("Dịch chuyển", "Đến " .. data.name, Theme.Brand) end end)
        delBtn.MouseButton1Click:Connect(function() clickAnimate(delBtn); table.remove(savedTpList, i); saveTpData(); renderSavedTps() end)
    end
end
renderSavedTps()

-- ==========================================
-- [TAB 7: TP NGƯỜI CHƠI] 
-- ==========================================
local function updatePlayerList()
    for _, child in pairs(page7:GetChildren()) do if child.Name == "PaddingFrame" then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local pFrame = Instance.new("Frame", page7); pFrame.Name = "PaddingFrame"; pFrame.Size = UDim2.new(0.9, 0, 0, 48); pFrame.BackgroundTransparency = 1; pFrame.ZIndex = 10
            local btn = Instance.new("TextButton", pFrame); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", btn); stroke.Color = Theme.Stroke; stroke.Thickness = 1.5; table.insert(RGBElements, {Type = "Stroke", Obj = stroke})
            local nLabel = Instance.new("TextLabel", btn); nLabel.Size = UDim2.new(0.7, 0, 0.5, 0); nLabel.Position = UDim2.new(0.05, 0, 0.05, 0); nLabel.BackgroundTransparency = 1; nLabel.Text = "👤 " .. p.DisplayName; nLabel.TextColor3 = Theme.TextTitle; nLabel.Font = Enum.Font.GothamSemibold; nLabel.TextSize = 13; nLabel.TextXAlignment = Enum.TextXAlignment.Left; nLabel.ZIndex = 10
            local subLabel = Instance.new("TextLabel", btn); subLabel.Size = UDim2.new(0.7, 0, 0.45, 0); subLabel.Position = UDim2.new(0.05, 0, 0.5, 0); subLabel.BackgroundTransparency = 1; subLabel.Text = "@" .. p.Name; subLabel.TextColor3 = Color3.fromRGB(100, 255, 100); subLabel.Font = Enum.Font.Gotham; subLabel.TextSize = 10; subLabel.TextXAlignment = Enum.TextXAlignment.Left; subLabel.ZIndex = 10
            local targetAvatar = Instance.new("ImageLabel", btn); targetAvatar.Size = UDim2.new(0, 32, 0, 32); targetAvatar.Position = UDim2.new(1, -42, 0.5, -16); targetAvatar.BackgroundTransparency = 1; targetAvatar.ZIndex = 10; Instance.new("UICorner", targetAvatar).CornerRadius = UDim.new(1, 0)
            local targetStroke = Instance.new("UIStroke", targetAvatar); targetStroke.Color = Theme.Stroke; targetStroke.Thickness = 1.5; targetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; table.insert(RGBElements, {Type = "Stroke", Obj = targetStroke})
            task.spawn(function() pcall(function() targetAvatar.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end)
            
            btn.MouseButton1Click:Connect(function()
                clickAnimate(btn); local myChar = player.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local targetCFrame = nil
                    if p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        targetCFrame = hrp and hrp.CFrame or p.Character:GetPivot()
                    end
                    if targetCFrame then 
                        myChar.HumanoidRootPart.CFrame = targetCFrame
                        MakeToast("Dịch Chuyển", "Đến " .. p.DisplayName, Theme.Brand)
                    else MakeToast("Lỗi", "Người chơi bị ẩn map", Theme.AccentOff) end
                end
            end)
        end
    end
end
updatePlayerList(); Players.PlayerAdded:Connect(updatePlayerList); Players.PlayerRemoving:Connect(updatePlayerList)

if UIS.TouchEnabled then
    player.Idled:Connect(function() if State.AntiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)
end

-- ==========================================
-- [CACHE LOGIC & LOOPS AUTO COLLECT TỐI ƯU]
-- ==========================================
local cachedPrompts = {}
task.spawn(function()
    local count = 0
    for _, obj in ipairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then table.insert(cachedPrompts, obj) end; count = count + 1; if count % 1000 == 0 then task.wait() end end
end)
workspace.DescendantAdded:Connect(function(obj) if obj:IsA("ProximityPrompt") then table.insert(cachedPrompts, obj) end end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if State.AutoCollect and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart; local rootPos = root.Position
                for _, prompt in ipairs(cachedPrompts) do
                    if prompt.Parent and prompt.Parent:IsA("BasePart") and prompt.Enabled and (prompt.Parent.Position - rootPos).Magnitude <= 50 then 
                        if fireproximityprompt then fireproximityprompt(prompt) else prompt:InputHoldBegin() task.wait(0.1) prompt:InputHoldEnd() end 
                    end
                end
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                        local part = obj.Handle
                        if (part.Position - rootPos).Magnitude <= 50 then
                            part.CanCollide = false
                            if firetouchinterest then firetouchinterest(root, part, 0); task.wait(0.01); firetouchinterest(root, part, 1) else part.CFrame = root.CFrame end
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- [VÒNG LẶP VẬT LÝ VÀ LOGIC HỢP NHẤT]
-- ==========================================
RunService.Stepped:Connect(function()
    local char = player.Character
    if not char then return end

    -- [FIXED]: NOCLIP an toàn (Không chìm sàn)
    if State.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                local n = part.Name
                if not (n == "LeftFoot" or n == "RightFoot" or n == "LeftLowerLeg" or n == "RightLowerLeg" or n == "Left Leg" or n == "Right Leg") then part.CanCollide = false end
            end
        end
    end

    -- [FIXED]: REACH an toàn
    if State.Reach then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            local handle = tool.Handle
            if not OriginalStats.Mats[handle] then OriginalStats.Mats[handle] = handle.Size end
            handle.Size = Vector3.new(State.ReachSize, State.ReachSize, State.ReachSize)
            handle.Massless = true; handle.CanCollide = false; handle.Transparency = 0.8
        end
    else
        for handle, size in pairs(OriginalStats.Mats) do if handle and handle.Parent then handle.Size = size; handle.Transparency = 0 end end
        OriginalStats.Mats = {}
    end
end)

local FlyVel, FlyGyro
RunService.Heartbeat:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    UpdateESP()

    if root and hum then
        if State.LockPosition then root.Anchored = true else root.Anchored = false end
        if State.Speed then hum.WalkSpeed = State.SpeedValue end
        -- [FIXED]: Chuẩn hóa dùng JumpHeight thay thế JumpPower
        if State.Jump then hum.UseJumpPower = false; hum.JumpHeight = State.JumpValue end
        
        if State.AutoDash and hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * (State.DashSpeed / 10)) end
        if State.SpinBot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0) end
        
        -- [FIXED]: Sửa xung đột AntiStun và Fly
        if State.AntiStun and not State.Fly then 
            hum.PlatformStand = false; hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false); hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(Enum.HumanoidStateType.GettingUp); root.RotVelocity = Vector3.new(0,0,0) end 
        end

        local light = root:FindFirstChild("PlayerPointLight")
        if State.PlayerLight then 
            if not light then light = Instance.new("PointLight", root); light.Name = "PlayerPointLight"; light.Shadows = false end 
            light.Brightness = State.LightBrightness; light.Range = State.LightRange
        else if light then light:Destroy() end end

        -- [FIXED]: Fly mượt chuẩn xác theo Camera
        if State.Fly then
            hum.PlatformStand = true
            if not FlyVel or FlyVel.Parent ~= root then
                if FlyVel then FlyVel:Destroy(); FlyGyro:Destroy() end
                FlyVel = Instance.new("BodyVelocity", root); FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                FlyGyro = Instance.new("BodyGyro", root); FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); FlyGyro.P = 9e4
            end
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local camLook = camera.CFrame.LookVector
                FlyVel.Velocity = Vector3.new(moveDir.X, camLook.Y * moveDir.Magnitude, moveDir.Z).Unit * State.FlySpeed
            else
                FlyVel.Velocity = Vector3.new(0, 0, 0)
            end
            FlyGyro.cframe = camera.CFrame
        else
            if FlyVel then FlyVel:Destroy(); FlyVel = nil end
            if FlyGyro then FlyGyro:Destroy(); FlyGyro = nil end
            hum.PlatformStand = false
        end
    end
end)
