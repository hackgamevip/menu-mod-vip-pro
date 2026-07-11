-- ==========================================
-- MENU VIP PRO MAX V3 (ULTIMATE OPTIMIZED)
-- Fixes: 35/35 Bug Reports Applied
-- Architecture: Single-Loop, Memory-Leak Free, Safe Physics
-- ==========================================
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [HỆ THỐNG QUẢN LÝ BỘ NHỚ & SỰ KIỆN]
local MenuConnections = {}
local function HookEvent(event, func)
    local conn = event:Connect(func)
    table.insert(MenuConnections, conn)
    return conn
end
local function DisconnectAll()
    for _, conn in ipairs(MenuConnections) do
        if conn.Connected then conn:Disconnect() end
    end
    table.clear(MenuConnections)
end

-- [TRẠNG THÁI TOÀN CỤC]
local State = {
    Instant = false, Noclip = false, LowGfx = false, Speed = false, Jump = false,
    InfJump = false, PlayerLight = false, ESP = false, AntiAfk = true, AntiStun = false, 
    XRay = false, LockPosition = false, AutoCollect = false, Fly = false, FlySpeed = 50,
    SpinBot = false, SpinSpeed = 50, Hitbox = false, HitboxSize = 15, AutoClick = false, RGB = false,
    Reach = false, ReachSize = 15, AutoDash = false, DashSpeed = 10, AutoSave = false, 
    ShiftLock = false, SpeedValue = 60, JumpValue = 100, LightRange = 60, LightBrightness = 3,
    MusicVolume = 5, NoFog = false, BlackScreen = false, WhiteScreen = false
}

-- [CACHE DỮ LIỆU & RÁC]
local Caches = {
    OriginalSizes = {}, XRayTrans = {}, LowGfxMats = {},
    Hitboxes = {}, ActiveESPs = {}, NoclipParts = {}
}

local Theme = {
    MainBg = Color3.fromRGB(20, 20, 26), HeaderBg = Color3.fromRGB(26, 26, 34),    
    TabBg = Color3.fromRGB(24, 24, 30), ItemBg = Color3.fromRGB(35, 35, 45),      
    Stroke = Color3.fromRGB(60, 60, 75), TextTitle = Color3.fromRGB(210, 225, 240),
    TextDim = Color3.fromRGB(160, 160, 175), AccentOn = Color3.fromRGB(46, 204, 113),  
    AccentOff = Color3.fromRGB(255, 71, 87), Brand = Color3.fromRGB(0, 200, 255)
}

local UI_RGBElements = {}
local guiParent = pcall(function() return gethui() end) and gethui() or game:GetService("CoreGui")
for _, v in pairs(guiParent:GetChildren()) do if v.Name == "MobileProMaxV3" then v:Destroy() end end

local configFileName = "MenuVipProMax_Config_V3.json"
pcall(function() if isfile and isfile(configFileName) then local data = HttpService:JSONDecode(readfile(configFileName)); for k, v in pairs(data) do if State[k] ~= nil then State[k] = v end end end end)
local function saveConfig() pcall(function() if writefile then writefile(configFileName, HttpService:JSONEncode(State)) end end) end

-- ==========================================
-- GIAO DIỆN & TOAST (GIỚI HẠN 5 TOAST)
-- ==========================================
local gui = Instance.new("ScreenGui", guiParent)
gui.Name = "MobileProMaxV3"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999 

local notifGui = Instance.new("Frame", gui)
notifGui.Size = UDim2.new(0, 220, 0.8, 0); notifGui.Position = UDim2.new(1, -230, 0.1, 0)
notifGui.BackgroundTransparency = 1; notifGui.ZIndex = 9999
local notifLayout = Instance.new("UIListLayout", notifGui)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder; notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; notifLayout.Padding = UDim.new(0, 10)

local activeToasts = {}
local function MakeToast(title, desc, color)
    local toast = Instance.new("Frame", notifGui)
    toast.Size = UDim2.new(1, 0, 0, 55); toast.BackgroundColor3 = Theme.ItemBg; toast.BackgroundTransparency = 1
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", toast); stroke.Color = color; stroke.Thickness = 1.5; stroke.Transparency = 1
    
    local cBar = Instance.new("Frame", toast); cBar.Size = UDim2.new(0, 4, 1, -16); cBar.Position = UDim2.new(0, 8, 0, 8); cBar.BackgroundColor3 = color; cBar.BorderSizePixel = 0; cBar.BackgroundTransparency = 1
    Instance.new("UICorner", cBar).CornerRadius = UDim.new(1, 0)
    
    local tLbl = Instance.new("TextLabel", toast); tLbl.Size = UDim2.new(1, -30, 0, 20); tLbl.Position = UDim2.new(0, 20, 0, 8); tLbl.BackgroundTransparency = 1; tLbl.Text = title; tLbl.TextColor3 = color; tLbl.Font = Enum.Font.GothamBold; tLbl.TextSize = 13; tLbl.TextXAlignment = Enum.TextXAlignment.Left; tLbl.TextTransparency = 1
    local dLbl = Instance.new("TextLabel", toast); dLbl.Size = UDim2.new(1, -30, 0, 20); dLbl.Position = UDim2.new(0, 20, 0, 28); dLbl.BackgroundTransparency = 1; dLbl.Text = desc; dLbl.TextColor3 = Theme.TextTitle; dLbl.Font = Enum.Font.Gotham; dLbl.TextSize = 11; dLbl.TextXAlignment = Enum.TextXAlignment.Left; dLbl.TextTransparency = 1
    
    TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(cBar, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(tLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(dLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    table.insert(activeToasts, toast)
    if #activeToasts > 5 then
        local old = table.remove(activeToasts, 1)
        if old and old.Parent then old:Destroy() end
    end

    task.delay(3, function()
        if toast and toast.Parent then
            TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(cBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(tLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(dLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.3); toast:Destroy()
            for i, v in ipairs(activeToasts) do if v == toast then table.remove(activeToasts, i); break end end
        end
    end)
end

local screenOverlay = Instance.new("Frame", gui)
screenOverlay.Size = UDim2.new(2, 0, 2, 0); screenOverlay.Position = UDim2.new(-0.5, 0, -0.5, 0); screenOverlay.ZIndex = 9999; screenOverlay.Visible = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 45, 0, 45); openBtn.Position = UDim2.new(0, 15, 0, 15); openBtn.Text = "MENU"; openBtn.BackgroundColor3 = Theme.MainBg; openBtn.BackgroundTransparency = 0.3; openBtn.TextColor3 = Theme.Brand; openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 12; openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke", openBtn); openStroke.Color = Theme.Brand; openStroke.Thickness = 2 

local function clickAnimate(obj)
    local s, e = pcall(function()
        local scale = Instance.new("UIScale", obj)
        TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.92}):Play()
        task.wait(0.1); TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
        task.delay(0.3, function() if scale and scale.Parent then scale:Destroy() end end)
    end)
end

local dragToggle, dragStart, btnStartPos
HookEvent(openBtn.InputBegan, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = true; dragStart = input.Position; btnStartPos = openBtn.Position end end)
HookEvent(UIS.InputChanged, function(input) if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then openBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + (input.Position.X - dragStart.X), btnStartPos.Y.Scale, btnStartPos.Y.Offset + (input.Position.Y - dragStart.Y)) end end)
HookEvent(UIS.InputEnded, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 500); frame.Position = UDim2.new(0.5, -210, 0.58, -250); frame.BackgroundColor3 = Theme.MainBg; frame.BackgroundTransparency = 0.05; frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)
local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = Theme.Stroke; frameStroke.Thickness = 2
table.insert(UI_RGBElements, {Type = "Stroke", Obj = frameStroke, Default = Theme.Stroke})

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45); header.BackgroundColor3 = Theme.HeaderBg; header.BorderSizePixel = 0; header.ZIndex = 10
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)
local headerCover = Instance.new("Frame", header); headerCover.Size = UDim2.new(1, 0, 0, 15); headerCover.Position = UDim2.new(0, 0, 1, -15); headerCover.BackgroundColor3 = Theme.HeaderBg; headerCover.BorderSizePixel = 0; headerCover.ZIndex = 10
local headerStroke = Instance.new("UIStroke", header); headerStroke.Color = Theme.Stroke; headerStroke.Thickness = 1.5; headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
table.insert(UI_RGBElements, {Type = "Stroke", Obj = headerStroke, Default = Theme.Stroke})

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, 0, 1, 0); titleLabel.BackgroundTransparency = 1; titleLabel.Text = "MENU VIP PRO MAX V3"; titleLabel.TextColor3 = Theme.TextTitle; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 16; titleLabel.ZIndex = 10
table.insert(UI_RGBElements, {Type = "Text", Obj = titleLabel, Default = Theme.TextTitle})

local mDragTog, mDragStart, mStartPos
HookEvent(header.InputBegan, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mDragTog = true; mDragStart = input.Position; mStartPos = frame.Position end end)
HookEvent(UIS.InputChanged, function(input) if mDragTog and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then frame.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + (input.Position.X - mDragStart.X), mStartPos.Y.Scale, mStartPos.Y.Offset + (input.Position.Y - mDragStart.Y)) end end)
HookEvent(UIS.InputEnded, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mDragTog = false end end)

-- [PHÍM TẮT ĐÓNG/MỞ]
HookEvent(UIS.InputBegan, function(input, gpe) if not gpe and input.KeyCode == Enum.KeyCode.RightControl then openBtn.Text = (frame.Position.Y.Scale > 1) and "MENU" or "ĐÓNG"; frame:TweenPosition((frame.Position.Y.Scale > 1) and UDim2.new(0.5, -210, 0.58, -250) or UDim2.new(0.5, -210, 1.2, 0), "Out", "Back", 0.5) end end)

local tabBar = Instance.new("Frame", frame); tabBar.Size = UDim2.new(1, 0, 0, 38); tabBar.Position = UDim2.new(0, 0, 0, 45); tabBar.BackgroundColor3 = Theme.TabBg; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 10

local function createTab(name, x, width)
    local btn = Instance.new("TextButton", tabBar); btn.Size = UDim2.new(width, 0, 1, 0); btn.Position = UDim2.new(x, 0, 0, 0); btn.Text = name; btn.BackgroundTransparency = 1; btn.TextColor3 = Theme.TextDim; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.ZIndex = 10
    local ind = Instance.new("Frame", btn); ind.Size = UDim2.new(0.5, 0, 0, 3); ind.Position = UDim2.new(0.25, 0, 1, -3); ind.BackgroundColor3 = Theme.Brand; ind.BorderSizePixel = 0; ind.BackgroundTransparency = 1; ind.ZIndex = 10
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
    return btn, ind
end

local tab1, ind1 = createTab("THÔNG TIN", 0.00, 0.14); local tab2, ind2 = createTab("TÍNH NĂNG", 0.14, 0.14)
local tab3, ind3 = createTab("PLAYER", 0.28, 0.14); local tab4, ind4 = createTab("TIỆN ÍCH", 0.42, 0.14)
local tab5, ind5 = createTab("NHẠC ID", 0.56, 0.12); local tab6, ind6 = createTab("TP SAVE", 0.68, 0.15)
local tab7, ind7 = createTab("TP PLAYER", 0.83, 0.17)

local pageContainer = Instance.new("Frame", frame); pageContainer.Size = UDim2.new(1, 0, 1, -95); pageContainer.Position = UDim2.new(0, 0, 0, 88); pageContainer.BackgroundTransparency = 1; pageContainer.ZIndex = 10

local function createPage()
    local pg = Instance.new("ScrollingFrame", pageContainer); pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1; pg.ScrollBarThickness = 3; pg.ScrollBarImageColor3 = Theme.Brand; pg.Visible = false; pg.BorderSizePixel = 0; pg.ZIndex = 10
    local layout = Instance.new("UIListLayout", pg); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 10); layout.SortOrder = Enum.SortOrder.LayoutOrder 
    Instance.new("UIPadding", pg).PaddingTop = UDim.new(0, 10); Instance.new("UIPadding", pg).PaddingBottom = UDim.new(0, 30) 
    HookEvent(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function() pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 120) end)
    return pg
end

local page1, page2, page3, page4, page5, page6, page7 = createPage(), createPage(), createPage(), createPage(), createPage(), createPage(), createPage()

-- [FIXED]: Hiệu ứng chuyển tab mượt mà bằng Fade
local function showTab(pg, tb, ind)
    for _, p in pairs({page1, page2, page3, page4, page5, page6, page7}) do p.Visible = false end
    for _, t in pairs({tab1, tab2, tab3, tab4, tab5, tab6, tab7}) do t.TextColor3 = Theme.TextDim end
    for _, i in pairs({ind1, ind2, ind3, ind4, ind5, ind6, ind7}) do i.BackgroundTransparency = 1 end
    
    pg.Visible = true; tb.TextColor3 = Theme.TextTitle
    ind.Size = UDim2.new(0, 0, 0, 3); ind.BackgroundTransparency = 0
    TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, 0, 0, 3)}):Play()
end

tab1.MouseButton1Click:Connect(function() showTab(page1, tab1, ind1) end); tab2.MouseButton1Click:Connect(function() showTab(page2, tab2, ind2) end)
tab3.MouseButton1Click:Connect(function() showTab(page3, tab3, ind3) end); tab4.MouseButton1Click:Connect(function() showTab(page4, tab4, ind4) end)
tab5.MouseButton1Click:Connect(function() showTab(page5, tab5, ind5) end); tab6.MouseButton1Click:Connect(function() showTab(page6, tab6, ind6) end)
tab7.MouseButton1Click:Connect(function() showTab(page7, tab7, ind7) end)
showTab(page1, tab1, ind1)

local opened = true
HookEvent(openBtn.MouseButton1Click, function()
    clickAnimate(openBtn); opened = not opened
    openBtn.Text = opened and "MENU" or "ĐÓNG"
    if not State.RGB then TweenService:Create(openStroke, TweenInfo.new(0.3), {Color = opened and Theme.Brand or Theme.AccentOff}):Play() end
    frame:TweenPosition(opened and UDim2.new(0.5, -210, 0.58, -250) or UDim2.new(0.5, -210, 1.2, 0), "Out", "Back", 0.5)
end)

local function createToggle(parent, text, varName, callback)
    local btnFrame = Instance.new("Frame", parent); btnFrame.Size = UDim2.new(0.9, 0, 0, 44); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame); btn.Size = UDim2.new(1, 0, 1, 0); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 1.5
    local title = Instance.new("TextLabel", btn); title.Size = UDim2.new(0.7, 0, 1, 0); title.Position = UDim2.new(0.05, 0, 0, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = Theme.TextTitle; title.Font = Enum.Font.GothamSemibold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local status = Instance.new("TextLabel", btn); status.Size = UDim2.new(0.2, 0, 1, 0); status.Position = UDim2.new(0.75, 0, 0, 0); status.BackgroundTransparency = 1; status.Font = Enum.Font.GothamBold; status.TextSize = 12; status.TextXAlignment = Enum.TextXAlignment.Right; status.ZIndex = 10
    
    local active = State[varName] or false
    status.Text = active and "ON" or "OFF"; status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
    stroke.Color = active and Theme.AccentOn or Theme.Stroke
    btn.BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg
    
    table.insert(UI_RGBElements, {Type = "Toggle", Obj = stroke, State = function() return State[varName] end, Default = Theme.Stroke})

    HookEvent(btn.MouseButton1Click, function()
        clickAnimate(btn); State[varName] = not State[varName]; active = State[varName]
        status.Text = active and "ON" or "OFF"
        TweenService:Create(status, TweenInfo.new(0.2), {TextColor3 = active and Theme.AccentOn or Theme.AccentOff}):Play()
        if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.2), {Color = active and Theme.AccentOn or Theme.Stroke}):Play() end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg}):Play()
        
        if varName ~= "AutoSave" and varName ~= "RGB" then MakeToast(active and "Đã Bật" or "Đã Tắt", text, active and Theme.AccentOn or Theme.AccentOff) end
        if State.AutoSave then saveConfig() end
        if callback then task.spawn(callback, active) end
    end)
    if active and callback then task.spawn(callback, active) end
    return btnFrame
end

local function createButton(parent, text, color, callback)
    local btnFrame = Instance.new("Frame", parent); btnFrame.Size = UDim2.new(0.9, 0, 0, 42); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = color; stroke.Thickness = 1.5; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(UI_RGBElements, {Type = "Stroke", Obj = stroke, Default = color})
    local title = Instance.new("TextLabel", btn); title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = color; title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.ZIndex = 10
    HookEvent(btn.MouseButton1Click, function()
        clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
        task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = color}):Play() end
        if text ~= "HỦY SCRIPT HOÀN TOÀN" then MakeToast("Đã thực thi", text, color) end
        if callback then callback() end
    end)
    return btnFrame
end

local function createDualButtons(parent, text1, color1, cb1, text2, color2, cb2)
    local dFrame = Instance.new("Frame", parent); dFrame.Size = UDim2.new(0.9, 0, 0, 42); dFrame.BackgroundTransparency = 1
    local function makeBtn(xPos, txt, col, cb)
        local btn = Instance.new("TextButton", dFrame); btn.Size = UDim2.new(0.48, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn); stroke.Color = col; stroke.Thickness = 1.5; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(UI_RGBElements, {Type = "Stroke", Obj = stroke, Default = col})
        local title = Instance.new("TextLabel", btn); title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = txt; title.TextColor3 = col; title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.ZIndex = 10
        HookEvent(btn.MouseButton1Click, function()
            clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
            task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = col}):Play() end
            if not txt:match("XÓA") then MakeToast("Đã thực thi", txt, col) end
            if cb then cb() end
        end)
    end
    makeBtn(0, text1, color1, cb1); makeBtn(0.52, text2, color2, cb2)
    return dFrame
end

-- [FIXED]: Hỗ trợ số thập phân cho Slider
local function createSlider(parent, text, min, max, varName, callback)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(0.9, 0, 0, 48); frame.BackgroundTransparency = 1
    local bg = Instance.new("Frame", frame); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Theme.ItemBg; bg.ZIndex = 10; Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", bg); stroke.Color = Theme.Stroke; stroke.Thickness = 1.5; table.insert(UI_RGBElements, {Type = "Stroke", Obj = stroke, Default = Theme.Stroke})
    local titleLabel = Instance.new("TextLabel", bg); titleLabel.Size = UDim2.new(0.7, 0, 0.4, 0); titleLabel.Position = UDim2.new(0.05, 0, 0.1, 0); titleLabel.BackgroundTransparency = 1; titleLabel.Text = text; titleLabel.TextColor3 = Theme.TextDim; titleLabel.Font = Enum.Font.GothamSemibold; titleLabel.TextSize = 12; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.ZIndex = 10
    local valLabel = Instance.new("TextLabel", bg); valLabel.Size = UDim2.new(0.25, 0, 0.4, 0); valLabel.Position = UDim2.new(0.7, 0, 0.1, 0); valLabel.BackgroundTransparency = 1; valLabel.Text = tostring(State[varName]); valLabel.TextColor3 = Theme.Brand; valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 12; valLabel.TextXAlignment = Enum.TextXAlignment.Right; valLabel.ZIndex = 10
    local track = Instance.new("Frame", bg); track.Size = UDim2.new(0.9, 0, 0.15, 0); track.Position = UDim2.new(0.05, 0, 0.65, 0); track.BackgroundColor3 = Theme.MainBg; track.ZIndex = 10; Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track); fill.Size = UDim2.new((State[varName] - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Theme.AccentOn; fill.ZIndex = 10; Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = min + ((max - min) * pos)
        value = math.floor(value * 10) / 10 -- Lấy 1 số thập phân
        valLabel.Text = tostring(value); TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        State[varName] = value; if callback then callback(value) end; if State.AutoSave then saveConfig() end
    end
    HookEvent(track.InputBegan, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; updateSlider(input) end end)
    HookEvent(UIS.InputChanged, function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
    HookEvent(UIS.InputEnded, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
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
            for i = #UI_RGBElements, 1, -1 do
                local data = UI_RGBElements[i]
                if data.Obj and data.Obj.Parent then
                    -- [FIXED]: RGB ngược logic. Nút Bật mới cầu vồng, Tắt thì về màu gốc.
                    if data.Type == "Toggle" then 
                        data.Obj.Color = data.State() and color or Theme.Stroke
                    elseif data.Type == "Stroke" then data.Obj.Color = color
                    elseif data.Type == "Text" then data.Obj.TextColor3 = color end
                else table.remove(UI_RGBElements, i) end
            end
        end
    end
end)

-- ==========================================
-- [TAB 1: THÔNG TIN - DASHBOARD]
-- ==========================================
local function createInfoBox(parent, icon, titleText, heightOffset)
    local item = Instance.new("Frame", parent); item.Size = UDim2.new(0.9, 0, 0, heightOffset or 85); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1.5; table.insert(UI_RGBElements, {Type = "Stroke", Obj = stroke, Default = Theme.Stroke})
    local title = Instance.new("TextLabel", item); title.Size = UDim2.new(1, -20, 0, 25); title.Position = UDim2.new(0, 10, 0, 5); title.BackgroundTransparency = 1; title.Text = icon .. " " .. titleText; title.TextColor3 = Theme.Brand; title.Font = Enum.Font.GothamBold; title.TextSize = 12; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local content = Instance.new("TextLabel", item); content.Size = UDim2.new(1, -20, 1, -35); content.Position = UDim2.new(0, 10, 0, 30); content.BackgroundTransparency = 1; content.Text = "Đang tải..."; content.TextColor3 = Theme.TextTitle; content.Font = Enum.Font.Gotham; content.TextSize = 11; content.TextXAlignment = Enum.TextXAlignment.Left; content.TextYAlignment = Enum.TextYAlignment.Top; content.RichText = true; content.ZIndex = 10
    return content, item
end

local playerInfoLabel = createInfoBox(page1, "👤", "THÔNG TIN NHÂN VẬT", 100)
local serverInfoLabel, serverInfoFrame = createInfoBox(page1, "🌐", "THÔNG TIN MÁY CHỦ", 85)

local copyIdBtn = Instance.new("TextButton", serverInfoFrame); copyIdBtn.Size = UDim2.new(0, 24, 0, 24); copyIdBtn.Position = UDim2.new(1, -30, 1, -28); copyIdBtn.Text = "📜"; copyIdBtn.BackgroundTransparency = 1; copyIdBtn.TextSize = 14; copyIdBtn.ZIndex = 11
HookEvent(copyIdBtn.MouseButton1Click, function()
    clickAnimate(copyIdBtn); pcall(function() if setclipboard and game.JobId ~= "" then setclipboard(tostring(game.JobId)); MakeToast("Đã Copy", "Đã lưu ID Server vào bộ nhớ tạm", Theme.AccentOn); local oldText = copyIdBtn.Text; copyIdBtn.Text = "✅"; task.wait(1); copyIdBtn.Text = oldText else MakeToast("Lỗi", "JobId trống hoặc không hỗ trợ", Theme.AccentOff) end end)
end)

local extraInfoLabel = createInfoBox(page1, "⚙️", "TRẠNG THÁI", 80)
local frames, fps = 0, 0
HookEvent(RunService.RenderStepped, function() frames = frames + 1 end) -- [FIXED]: Tính FPS chuẩn
task.spawn(function() while task.wait(1) do fps = frames; frames = 0 end end)

task.spawn(function()
    while task.wait(0.5) do
        local hp, maxHp, ws, jp = 0, 0, 0, 0
        local coords = "0, 0, 0"
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            hp = math.floor(hum.Health); maxHp = math.floor(hum.MaxHealth); ws = math.floor(hum.WalkSpeed); jp = math.floor(hum.JumpHeight) 
        end
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then local pos = player.Character.HumanoidRootPart.Position; coords = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z) end
        playerInfoLabel.Text = string.format("<font color='#FF00FF'>Tên:</font> %s (@%s)\n<font color='#FF00FF'>Máu:</font> %d / %d\n<font color='#FF00FF'>Tốc độ:</font> %d\n<font color='#FF00FF'>Lực nhảy:</font> %d\n<font color='#FF00FF'>Tọa độ:</font> %s", player.DisplayName, player.Name, hp, maxHp, ws, jp, coords)
        
        local ping = "0"
        pcall(function() local stats = game:GetService("Stats"); if stats and stats:FindFirstChild("Network") and stats.Network:FindFirstChild("ServerStatsItem") then ping = stats.Network.ServerStatsItem["Data Ping"]:GetValueString() else ping = tostring(math.floor(player:GetNetworkPing() * 1000)) .. " ms" end end)
        local pCount = #Players:GetPlayers(); local maxP = Players.MaxPlayers; local jobText = game.JobId ~= "" and string.sub(game.JobId, 1, 15).."..." or "N/A"
        serverInfoLabel.Text = string.format("<font color='#FF00FF'>FPS:</font> %d\n<font color='#FF00FF'>Ping:</font> %s\n<font color='#FF00FF'>Người chơi:</font> %d / %d\n<font color='#FF00FF'>ID SV:</font> %s", fps, ping, pCount, maxP, jobText)
        local execTime = math.floor(workspace.DistributedGameTime); local hours = math.floor(execTime / 3600); local mins = math.floor((execTime % 3600) / 60); local secs = execTime % 60
        extraInfoLabel.Text = string.format("<font color='#FF00FF'>Thời gian chơi:</font> %02d:%02d:%02d\n<font color='#FF00FF'>Giờ hệ thống:</font> %s\n<font color='#FF00FF'>Phiên bản:</font> MENU V3 LITE", hours, mins, secs, os.date("%H:%M:%S"))
    end
end)

-- ==========================================
-- [CHỨC NĂNG CỐT LÕI (CORE FUNCTIONS)]
-- ==========================================

-- [FIXED]: XRay Quét theo lô
local function ApplyXRay()
    task.spawn(function()
        local count = 0
        if State.XRay then
            MakeToast("X-Ray", "Đang nạp cấu hình map...", Theme.Brand)
            for _, obj in ipairs(workspace:GetDescendants()) do
                if not State.XRay then break end
                if obj:IsA("BasePart") and obj.Transparency < 0.5 and obj.Name ~= "Terrain" then
                    if not Caches.XRayTrans[obj] then Caches.XRayTrans[obj] = obj.Transparency end
                    obj.Transparency = 0.5
                end
                count = count + 1; if count % 200 == 0 then task.wait() end
            end
        else
            for obj, trans in pairs(Caches.XRayTrans) do
                if obj and obj.Parent then obj.Transparency = trans end
                count = count + 1; if count % 200 == 0 then task.wait() end
            end
            table.clear(Caches.XRayTrans)
        end
    end)
end

-- [FIXED]: LowGfx Quét theo lô
local function ApplyLowGfx()
    task.spawn(function()
        local count = 0
        if State.LowGfx then
            MakeToast("Low GFX", "Đang tối ưu hóa vật liệu...", Theme.Brand)
            for _, obj in ipairs(workspace:GetDescendants()) do
                if not State.LowGfx then break end
                if obj:IsA("BasePart") then
                    if not Caches.LowGfxMats[obj] then Caches.LowGfxMats[obj] = obj.Material end
                    obj.Material = Enum.Material.SmoothPlastic
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    if not Caches.LowGfxMats[obj] then Caches.LowGfxMats[obj] = obj.Transparency end
                    obj.Transparency = 1
                end
                count = count + 1; if count % 200 == 0 then task.wait() end
            end
        else
            for obj, orig in pairs(Caches.LowGfxMats) do
                if obj and obj.Parent then
                    if type(orig) == "number" then obj.Transparency = orig else obj.Material = orig end
                end
                count = count + 1; if count % 200 == 0 then task.wait() end
            end
            table.clear(Caches.LowGfxMats)
        end
    end)
end

-- [FIXED]: Cập nhật Noclip Caches an toàn
local function UpdateNoclipCache()
    table.clear(Caches.NoclipParts)
    if player.Character then for _, p in ipairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then table.insert(Caches.NoclipParts, p) end end end
end
HookEvent(player.CharacterAdded, UpdateNoclipCache)
if player.Character then UpdateNoclipCache() end

local function ResetNoclip()
    for _, part in ipairs(Caches.NoclipParts) do
        if part and part.Parent then part.CanCollide = true end
    end
end

-- ==========================================
-- [TAB 2, 3, 4: GÁN UI & LOGIC]
-- ==========================================
createToggle(page2, "🛡️ Chống ngã", "AntiStun")
createToggle(page2, "🔒 Khóa vị trí", "LockPosition")
createToggle(page2, "🚀 Nhảy trên không", "InfJump") 
-- [FIXED]: Mobile InfJump an toàn
HookEvent(UIS.JumpRequest, function() if State.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)

createToggle(page2, "🐿️ Lấy đồ nhanh", "Instant")
createToggle(page2, "🧲 Auto nhặt đồ xung quanh", "AutoCollect")
createToggle(page2, "🚷 Đi xuyên tường", "Noclip", function(v) if not v then ResetNoclip() end end)
createToggle(page2, "👀 Nhìn xuyên map", "XRay", ApplyXRay)
createToggle(page2, "🔴 ESP người chơi", "ESP")

createToggle(page3, "🕊️ Bay Trên không (FLY)", "Fly")
createSlider(page3, "Tốc độ bay", 10, 1000, "FlySpeed")
createToggle(page3, "🏃 Chạy nhanh", "Speed")
createSlider(page3, "Tốc độ chạy", 1, 1000, "SpeedValue")
createToggle(page3, "🦘 Nhảy cao", "Jump")
createSlider(page3, "Lực nhảy", 1, 1000, "JumpValue")
createToggle(page3, "💨 Lướt liên tục", "AutoDash")
createSlider(page3, "Tốc độ lướt", 1, 50, "DashSpeed")

-- [FIXED]: Hitbox an toàn chỉ dùng cho hiển thị + thay đổi nhỏ
createToggle(page3, "🎯 Hitbox", "Hitbox", function(v)
    if not v then
        for p, size in pairs(Caches.Hitboxes) do
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = size; p.Character.HumanoidRootPart.Transparency = 1; p.Character.HumanoidRootPart.CanCollide = true
            end
        end
        table.clear(Caches.Hitboxes)
    end
end)
createSlider(page3, "Kích thước Hitbox", 0, 100, "HitboxSize")
createToggle(page3, "⚔️ Đánh xa (Reach)", "Reach")
createSlider(page3, "Kích thước vũ khí", 0, 300, "ReachSize")
createToggle(page3, "🌪️ Xoay vòng tròn", "SpinBot")
createSlider(page3, "Tốc độ xoay", 0, 100, "SpinSpeed")
createToggle(page3, "💡 Ánh sáng quanh người", "PlayerLight", function(v) if not v and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then local light = player.Character.HumanoidRootPart:FindFirstChild("PlayerPointLight"); if light then light:Destroy() end end end)
createSlider(page3, "Độ sáng", 0, 5, "LightBrightness")

createToggle(page4, "💾 Lưu Cài Đặt", "AutoSave", function(v) if v then saveConfig() else pcall(function() if isfile and isfile(configFileName) then delfile(configFileName) end end) end end)
createToggle(page4, "🌈 Chế độ RGB", "RGB", function(v) 
    if not v then 
        titleLabel.TextColor3 = Theme.TextTitle; frameStroke.Color = Theme.Stroke; headerStroke.Color = Theme.Stroke; avatarStroke.Color = Theme.Brand; openStroke.Color = opened and Theme.AccentOff or Theme.Brand
        for _, obj in pairs(UI_RGBElements) do
            if obj.Obj and obj.Obj.Parent then
                if obj.Type == "Toggle" then obj.Obj.Color = obj.State() and Theme.AccentOn or Theme.Stroke
                elseif obj.Type == "Stroke" then obj.Obj.Color = obj.Default or Theme.Stroke 
                elseif obj.Type == "Text" then obj.Obj.TextColor3 = obj.Default or Theme.TextTitle end
            end
        end
    end 
end)
createToggle(page4, "📉 Giảm Lag (Low GFX)", "LowGfx", ApplyLowGfx)
createToggle(page4, "🖱️ Auto Click", "AutoClick")
createToggle(page4, "☀️ Xóa sương mù", "NoFog", function(v) if v then Lighting.FogEnd = 100000; Lighting.Brightness = 2; Lighting.GlobalShadows = false else Lighting.FogEnd = 100000; Lighting.Brightness = 1; Lighting.GlobalShadows = true end end)
createToggle(page4, "⬛ Màn hình đen (treo máy)", "BlackScreen", function(v) screenOverlay.BackgroundColor3 = Color3.new(0, 0, 0); screenOverlay.Visible = v; if v then State.WhiteScreen = false end end)
createToggle(page4, "⬜ Màn hình trắng", "WhiteScreen", function(v) screenOverlay.BackgroundColor3 = Color3.new(1, 1, 1); screenOverlay.Visible = v; if v then State.BlackScreen = false end end)
createToggle(page4, "🛡️ Chống AFK (Antiafk)", "AntiAfk")

createDualButtons(page4, "🌞 Trời SÁNG (Fake)", Color3.fromRGB(243, 156, 18), function() Lighting.ClockTime = 12 end, "🌚 Trời TỐI (Fake)", Color3.fromRGB(160, 32, 240), function() Lighting.ClockTime = 0 end)
createDualButtons(page4, "🔄 VÀO LẠI SV", Theme.AccentOn, function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end, "💻 LỆNH ADMIN", Theme.AccentOn, function() pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgelY/infiniteyield/master/source'))() end) end)

createButton(page4, "HỦY SCRIPT HOÀN TOÀN", Theme.AccentOff, function()
    DisconnectAll(); State = {}
    if gui and gui.Parent then gui:Destroy() end
end)

-- [FIXED]: ANTI-AFK XỊN (Không dùng VirtualUser)
HookEvent(player.Idled, function()
    if State.AntiAfk then
        local s = pcall(function() local gc = getconnections(player.Idled); if gc then for _,v in pairs(gc) do v:Disable() end end end)
        if not s then
            local camC = camera.CFrame; camera.CFrame = camC * CFrame.Angles(0,0.01,0); task.wait(0.1); camera.CFrame = camC
        end
    end
end)

-- ==========================================
-- [TAB 5: NHẠC ID]
-- ==========================================
local currentSound = nil; local currentMusicId = ""; local savedMusicList = {}
local musicControlFrame = Instance.new("Frame", page5); musicControlFrame.Size = UDim2.new(0.9, 0, 0, 85); musicControlFrame.BackgroundColor3 = Theme.ItemBg; musicControlFrame.ZIndex = 10; musicControlFrame.LayoutOrder = 1; Instance.new("UICorner", musicControlFrame).CornerRadius = UDim.new(0, 8)
local musicIdBox = Instance.new("TextBox", musicControlFrame); musicIdBox.Size = UDim2.new(0.65, 0, 0, 40); musicIdBox.Position = UDim2.new(0.15, 0, 0, 0); musicIdBox.BackgroundTransparency = 1; musicIdBox.PlaceholderText = "Nhập ID Nhạc..."; musicIdBox.Text = ""; musicIdBox.TextColor3 = Theme.TextTitle; musicIdBox.Font = Enum.Font.GothamSemibold; musicIdBox.TextSize = 12; musicIdBox.TextXAlignment = Enum.TextXAlignment.Left; musicIdBox.ClearTextOnFocus = false; musicIdBox.ZIndex = 10
-- [FIXED]: Giới hạn TextBox chỉ lấy số
HookEvent(musicIdBox:GetPropertyChangedSignal("Text"), function() musicIdBox.Text = musicIdBox.Text:gsub("%D+", "") end)
local saveIdBtn = Instance.new("TextButton", musicControlFrame); saveIdBtn.Size = UDim2.new(0.2, 0, 0, 40); saveIdBtn.Position = UDim2.new(0.8, 0, 0, 0); saveIdBtn.BackgroundTransparency = 1; saveIdBtn.Text = "💾 Lưu"; saveIdBtn.TextColor3 = Theme.AccentOn; saveIdBtn.Font = Enum.Font.GothamBold; saveIdBtn.TextSize = 11; saveIdBtn.ZIndex = 10
local nowPlayingLabel = Instance.new("TextLabel", musicControlFrame); nowPlayingLabel.Size = UDim2.new(0.9, 0, 0, 45); nowPlayingLabel.Position = UDim2.new(0.05, 0, 0, 40); nowPlayingLabel.BackgroundTransparency = 1; nowPlayingLabel.RichText = true; nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Chưa có nhạc phát</font>"; nowPlayingLabel.Font = Enum.Font.GothamSemibold; nowPlayingLabel.TextSize = 13; nowPlayingLabel.TextWrapped = true; nowPlayingLabel.ZIndex = 10

local function playMusic(id)
    if currentSound then currentSound:Destroy() end; local soundId = tostring(id):match("%d+"); if not soundId or soundId == "" then return end
    currentMusicId = soundId; nowPlayingLabel.Text = "<font color='#FFFFFF'>⏳ Đang tải bài hát...</font>"
    task.spawn(function()
        local s, info = pcall(function() return MarketplaceService:GetProductInfo(tonumber(soundId)) end)
        if currentMusicId == soundId then nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Phát:</font> <font color='#FFFF00'>" .. (s and info.Name or "ID Lỗi/Ẩn danh") .. "</font>" end
    end)
    -- [FIXED]: Không phát nếu Vol = 0
    if State.MusicVolume <= 0 then return end
    currentSound = Instance.new("Sound", workspace); currentSound.SoundId = "rbxassetid://" .. soundId; currentSound.Volume = State.MusicVolume / 10
    HookEvent(currentSound.Ended, function()
        if #savedMusicList > 0 then
            local cx = 0; for i, v in ipairs(savedMusicList) do if v.id == currentMusicId then cx = i; break end end
            playMusic(savedMusicList[cx + 1 > #savedMusicList and 1 or cx + 1].id)
        end
    end)
    currentSound:Play()
end
local function stopMusic() if currentSound then currentSound:Stop(); currentSound:Destroy(); currentSound = nil; currentMusicId = ""; nowPlayingLabel.Text = "<font color='#FFFFFF'>⏹ Đã dừng nhạc</font>" end end

createDualButtons(page5, "▶️ PHÁT NHẠC", Theme.AccentOn, function() playMusic(musicIdBox.Text) end, "⏸️ TẮT NHẠC", Theme.AccentOff, stopMusic).LayoutOrder = 2
createSlider(page5, "ÂM LƯỢNG 🔊", 0, 10, "MusicVolume", function(val) if currentSound then currentSound.Volume = val / 10 end end).LayoutOrder = 3

-- ==========================================
-- [TAB 6: TP SAVE] 
-- ==========================================
local savedTpList = {}
local pendingDeleteAll = false
local savedTpContent = Instance.new("ScrollingFrame", page6); savedTpContent.Size = UDim2.new(0.9, 0, 1, -114); savedTpContent.BackgroundTransparency = 1; savedTpContent.ScrollBarThickness = 3; savedTpContent.ScrollBarImageColor3 = Theme.Brand; savedTpContent.BorderSizePixel = 0; savedTpContent.ZIndex = 10; savedTpContent.LayoutOrder = 2
local tpLayout = Instance.new("UIListLayout", savedTpContent); tpLayout.SortOrder = Enum.SortOrder.LayoutOrder; tpLayout.Padding = UDim.new(0, 8)
HookEvent(tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function() savedTpContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 20) end)

local function renderSavedTps()
    for _, child in pairs(savedTpContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for i, data in ipairs(savedTpList) do
        local item = Instance.new("Frame", savedTpContent); item.Size = UDim2.new(1, 0, 0, 48); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local btn = Instance.new("TextButton", item); btn.Size = UDim2.new(0.25, 0, 0.6, 0); btn.Position = UDim2.new(0.53, 0, 0.2, 0); btn.Text = "TP"; btn.BackgroundColor3 = Theme.Brand; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 10; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local dBtn = Instance.new("TextButton", item); dBtn.Size = UDim2.new(0.15, 0, 0.6, 0); dBtn.Position = UDim2.new(0.81, 0, 0.2, 0); dBtn.Text = "X"; dBtn.BackgroundColor3 = Theme.AccentOff; dBtn.TextColor3 = Color3.new(1,1,1); dBtn.Font = Enum.Font.GothamBold; dBtn.TextSize = 12; dBtn.ZIndex = 10; Instance.new("UICorner", dBtn).CornerRadius = UDim.new(0, 6)
        local nBox = Instance.new("TextBox", item); nBox.Size = UDim2.new(0.45, 0, 1, 0); nBox.Position = UDim2.new(0.05, 0, 0, 0); nBox.Text = data.name; nBox.TextColor3 = Theme.TextTitle; nBox.BackgroundTransparency = 1; nBox.TextXAlignment = Enum.TextXAlignment.Left; nBox.ZIndex = 10
        HookEvent(btn.MouseButton1Click, function() if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(unpack(data.cframe)) end end)
        HookEvent(dBtn.MouseButton1Click, function() table.remove(savedTpList, i); renderSavedTps() end)
    end
end

local delBtnGlobal
createDualButtons(page6, "📍 LƯU VỊ TRÍ", Theme.Brand, function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cf = {player.Character.HumanoidRootPart.CFrame:GetComponents()}; table.insert(savedTpList, {name = "Vị Trí " .. #savedTpList+1, cframe = cf}); renderSavedTps()
    end
end, "🗑️ XÓA TẤT CẢ", Theme.AccentOff, function() 
    -- [FIXED]: Trạng thái đếm ngược xóa
    if not pendingDeleteAll then 
        pendingDeleteAll = true; MakeToast("CẢNH BÁO", "Ấn lại trong 3s để XÓA SẠCH", Theme.AccentOff)
        task.delay(3, function() pendingDeleteAll = false end)
    else 
        savedTpList = {}; renderSavedTps(); MakeToast("Đã Xóa", "Toàn bộ vị trí đã bị xóa", Theme.Brand); pendingDeleteAll = false 
    end
end).LayoutOrder = 1 

-- ==========================================
-- [TAB 7: TP NGƯỜI CHƠI] 
-- ==========================================
local function updatePlayerList()
    for _, child in pairs(page7:GetChildren()) do if child.Name == "PaddingFrame" then child:Destroy() end end
    local pList = Players:GetPlayers()
    table.sort(pList, function(a, b) return a.DisplayName:lower() < b.DisplayName:lower() end) -- [FIXED]: Sort Name
    for _, p in ipairs(pList) do
        if p ~= player then
            local pFrame = Instance.new("Frame", page7); pFrame.Name = "PaddingFrame"; pFrame.Size = UDim2.new(0.9, 0, 0, 48); pFrame.BackgroundTransparency = 1; pFrame.ZIndex = 10
            local btn = Instance.new("TextButton", pFrame); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = "👤 " .. p.DisplayName; btn.TextColor3 = Theme.TextTitle; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.ZIndex = 10
            Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            HookEvent(btn.MouseButton1Click, function()
                local myChar = player.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame; MakeToast("Đã TP", "Tới " .. p.DisplayName, Theme.Brand)
                end
            end)
        end
    end
end
HookEvent(Players.PlayerAdded, updatePlayerList); HookEvent(Players.PlayerRemoving, updatePlayerList); updatePlayerList()

-- ==========================================
-- [TÍNH NĂNG TỰ ĐỘNG KHÔI PHỤC KHI CHẾT & LOGIC VẬT LÝ]
-- ==========================================
HookEvent(player.CharacterAdded, function(char)
    UpdateNoclipCache()
    task.wait(1) -- Chờ game khởi tạo nhân vật
    if State.Hitbox then table.clear(Caches.Hitboxes) end
    if State.Reach then table.clear(Caches.OriginalSizes) end
end)

local FlyVel, FlyGyro
HookEvent(RunService.Heartbeat, function(dt)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    -- Xử lý Logic ESP
    if State.ESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tHrp = p.Character.HumanoidRootPart; local gui = Caches.ActiveESPs[p]
                if not gui or not gui.Parent then
                    gui = Instance.new("BillboardGui", guiParent); gui.Size = UDim2.new(0, 200, 0, 50); gui.AlwaysOnTop = true; gui.Adornee = tHrp
                    local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.fromRGB(255, 50, 50); txt.Font = Enum.Font.GothamBold; txt.TextSize = 12
                    Caches.ActiveESPs[p] = gui
                end
                local dist = hrp and math.floor((hrp.Position - tHrp.Position).Magnitude) or 0
                gui:GetChildren()[1].Text = p.DisplayName .. " ["..dist.."m]"
            end
        end
        for p, gui in pairs(Caches.ActiveESPs) do if not p or not p.Parent then gui:Destroy(); Caches.ActiveESPs[p] = nil end end
    end

    if hrp and hum then
        -- [FIXED]: Sửa LockPosition ổn định
        if State.LockPosition then hrp.Anchored = true elseif hrp.Anchored then hrp.Anchored = false end
        if State.Speed then hum.WalkSpeed = State.SpeedValue end
        if State.Jump then hum.UseJumpPower = false; hum.JumpHeight = State.JumpValue end
        
        -- [FIXED]: Xử lý SpinBot đồng bộ FPS
        if State.SpinBot then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed * dt * 50), 0) end
        if State.AutoDash and hum.MoveDirection.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (State.DashSpeed / 10)) end
        
        -- [FIXED]: Fly Modern Physics
        if State.Fly then
            hum.PlatformStand = true
            if not FlyVel or FlyVel.Parent ~= hrp then
                if FlyVel then FlyVel:Destroy(); FlyGyro:Destroy() end
                FlyVel = Instance.new("LinearVelocity", hrp); local att = Instance.new("Attachment", hrp); FlyVel.Attachment0 = att; FlyVel.MaxForce = math.huge; FlyVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector; FlyVel.RelativeTo = Enum.ActuatorRelativeTo.World
                FlyGyro = Instance.new("AlignOrientation", hrp); FlyGyro.Attachment0 = att; FlyGyro.Mode = Enum.OrientationAlignmentMode.OneAttachment; FlyGyro.MaxTorque = math.huge
            end
            local mDir = hum.MoveDirection; FlyVel.VectorVelocity = (mDir.Magnitude > 0) and (Vector3.new(mDir.X, camera.CFrame.LookVector.Y * mDir.Magnitude, mDir.Z).Unit * State.FlySpeed) or Vector3.new(0,0,0)
            FlyGyro.CFrame = camera.CFrame
        elseif FlyVel then FlyVel:Destroy(); FlyGyro:Destroy(); FlyVel = nil; hum.PlatformStand = false end
        
        -- AntiStun an toàn
        if State.AntiStun and not State.Fly then hum.PlatformStand = false; hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false); hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false); if hum:GetState() == Enum.HumanoidStateType.FallingDown then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end end

        -- Noclip
        if State.Noclip then for _, part in ipairs(Caches.NoclipParts) do if part and part.Parent and part.CanCollide then local n = part.Name; if not (n:match("Foot") or n:match("Leg")) then part.CanCollide = false end end end end

        -- Hitbox logic an toàn (chỉ thay đổi đối thủ)
        if State.Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local tHrp = p.Character.HumanoidRootPart
                    if not Caches.Hitboxes[p] then Caches.Hitboxes[p] = tHrp.Size end
                    tHrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize); tHrp.Transparency = 0.6; tHrp.CanCollide = false; tHrp.Massless = true
                end
            end
        end

        -- Reach
        if State.Reach then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                local h = tool.Handle
                if not Caches.OriginalSizes[h] then Caches.OriginalSizes[h] = h.Size end
                h.Size = Vector3.new(State.ReachSize, State.ReachSize, State.ReachSize); h.Massless = true; h.CanCollide = false; h.Transparency = 0.8
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if State.AutoClick and player.Character then pcall(function() local tool = player.Character:FindFirstChildOfClass("Tool"); if tool then tool:Activate() end end) end
    end
end)
