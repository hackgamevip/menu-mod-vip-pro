-- ==========================================
-- MENU VIP PRO V1.13.7 (FIXED COMPLETE SCRIPT)
-- ==========================================
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Vim = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

local State = {
    Instant = false, Noclip = false, LowGfx = false, Speed = false, Jump = false,
    InfJump = false, PlayerLight = false, ESP = false, AntiAfk = true, AntiStun = false, 
    XRay = false, LockPosition = false, AutoCollect = false, Fly = false, FlySpeed = 50,
    SpinBot = false, SpinSpeed = 50, Hitbox = false, HitboxSize = 15, AutoClick = false, RGB = false,
    Reach = false, ReachSize = 15, AutoDash = false, DashSpeed = 10, AutoSave = false, Astral = false,
    ShiftLock = false, SpeedValue = 60, JumpValue = 120, LightRange = 60, LightBrightness = 3,
    MusicVolume = 5, LightColorIdx = 1, NoFog = false,
    FpsCapValue = 60, Disable3D = false, AfkModeScreen = false, RemoveTextures = false,
    HidePlayers = false, OptimizeTerrain = false, NoShadows = false,
    DisableParticles = false, DisablePostEffects = false, HidePetsAccessories = false, AutoClearRAM = false,
    AutoSkillDelay = 1, 
    AutoSkillZ = false, AutoSkillX = false, AutoSkillC = false, AutoSkillV = false, AutoSkillE = false, AutoSkillF = false,
    AutoSkill1 = false, AutoSkill2 = false, AutoSkill3 = false, AutoSkill4 = false, AutoSkill5 = false, AutoSkill6 = false,
    TpPositionIdx = 1, TpDistance = 4,
    AirWalk = false
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

local PlayerLightColors = {
    {Name = "Trắng", Value = Color3.fromRGB(255, 255, 255)},
    {Name = "Đỏ", Value = Color3.fromRGB(255, 0, 0)},
    {Name = "Cam", Value = Color3.fromRGB(255, 128, 0)},
    {Name = "Vàng", Value = Color3.fromRGB(255, 255, 0)},
    {Name = "Xanh lá", Value = Color3.fromRGB(0, 255, 0)},
    {Name = "Xanh lơ", Value = Color3.fromRGB(0, 255, 255)},
    {Name = "Xanh dương", Value = Color3.fromRGB(0, 0, 255)},
    {Name = "Tím", Value = Color3.fromRGB(128, 0, 255)},
    {Name = "Hồng", Value = Color3.fromRGB(255, 105, 180)}
}

local TpPositions = {
    {
        Name = "Sau lưng",
        IsHorizontal = false,
        GetOffset = function(d) return CFrame.new(0, 0, d) end
    },
    {
        Name = "Trước mặt",
        IsHorizontal = false,
        GetOffset = function(d) return CFrame.new(0, 0, -d) * CFrame.Angles(0, math.pi, 0) end
    },
    {
        Name = "Trên đầu",
        IsHorizontal = true,
        GetOffset = function(d) return CFrame.new(0, d, 0) * CFrame.Angles(math.rad(-90), 0, 0) end
    },
    {
        Name = "Dưới chân",
        IsHorizontal = true,
        GetOffset = function(d) return CFrame.new(0, -d, 0) * CFrame.Angles(math.rad(90), 0, 0) end
    }
}

local RGBElements = {}
local ActiveESPs = {} 
local originalHitboxSizes = {}
local originalToolSizes = {}
local cachedPrompts = {}
local xrayMats = {}
local OriginalGFX = {} 
local Tab9Toggles = {}

local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
    if gethui and type(gethui) == "function" then
        local hui = gethui()
        if hui then guiParent = hui end
    elseif game:GetService("CoreGui") then
        guiParent = game:GetService("CoreGui")
    end
end)

pcall(function()
    for _, v in pairs(guiParent:GetChildren()) do
        if v.Name == "MenuVipProMax" then v:Destroy() end
    end
end)

local configFileName = "MenuVipProMax"
pcall(function()
    if isfile and isfile(configFileName) then
        local data = HttpService:JSONDecode(readfile(configFileName))
        for k, v in pairs(data) do if State[k] ~= nil then State[k] = v end end
    end
end)
if not TpPositions[State.TpPositionIdx] then State.TpPositionIdx = 1 end
if not PlayerLightColors[State.LightColorIdx] then State.LightColorIdx = 1 end

local function saveConfig()
    pcall(function() if writefile then writefile(configFileName, HttpService:JSONEncode(State)) end end)
end

-- ==========================================
-- GIAO DIỆN CHÍNH & THÔNG BÁO (COMPACT)
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "MenuVipProMax"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

local notifGui = Instance.new("Frame", gui)
notifGui.Size = UDim2.new(0, 190, 0.8, 0); notifGui.Position = UDim2.new(1, -200, 0.1, 0)
notifGui.BackgroundTransparency = 1; notifGui.ZIndex = 9999
local notifLayout = Instance.new("UIListLayout", notifGui)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder; notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; notifLayout.Padding = UDim.new(0, 6)

local function MakeToast(title, desc, color)
    local toast = Instance.new("Frame", notifGui)
    toast.Size = UDim2.new(1, 0, 0, 44); toast.BackgroundColor3 = Theme.ItemBg
    toast.BackgroundTransparency = 1; Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", toast); stroke.Color = color; stroke.Thickness = 1.2; stroke.Transparency = 1
    
    local colorBar = Instance.new("Frame", toast)
    colorBar.Size = UDim2.new(0, 3, 1, -12); colorBar.Position = UDim2.new(0, 6, 0, 6)
    colorBar.BackgroundColor3 = color; colorBar.BorderSizePixel = 0; Instance.new("UICorner", colorBar).CornerRadius = UDim.new(1, 0)
    colorBar.BackgroundTransparency = 1

    local tLabel = Instance.new("TextLabel", toast)
    tLabel.Size = UDim2.new(1, -24, 0, 16); tLabel.Position = UDim2.new(0, 16, 0, 5)
    tLabel.BackgroundTransparency = 1; tLabel.Text = title; tLabel.TextColor3 = color; tLabel.Font = Enum.Font.GothamBold; tLabel.TextSize = 11; tLabel.TextXAlignment = Enum.TextXAlignment.Left; tLabel.TextTransparency = 1
    
    local dLabel = Instance.new("TextLabel", toast)
    dLabel.Size = UDim2.new(1, -24, 0, 16); dLabel.Position = UDim2.new(0, 16, 0, 22)
    dLabel.BackgroundTransparency = 1; dLabel.Text = desc; dLabel.TextColor3 = Theme.TextTitle; dLabel.Font = Enum.Font.Gotham; dLabel.TextSize = 10; dLabel.TextXAlignment = Enum.TextXAlignment.Left; dLabel.TextTransparency = 1
    
    TweenService:Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(colorBar, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(tLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(dLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.delay(2.2, function()
        TweenService:Create(toast, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(colorBar, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(tLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(dLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4); toast:Destroy()
    end)
end

local screenOverlay = Instance.new("Frame", gui)
screenOverlay.Size = UDim2.new(2, 0, 2, 0); screenOverlay.Position = UDim2.new(-0.5, 0, -0.5, 0)
screenOverlay.BackgroundColor3 = Color3.new(0,0,0); screenOverlay.ZIndex = 0; screenOverlay.Visible = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 40, 0, 40); openBtn.Position = UDim2.new(0, 15, 0.25, 0)
openBtn.Text = "🇻🇳"; openBtn.BackgroundColor3 = Theme.MainBg; openBtn.BackgroundTransparency = 0.25
openBtn.TextColor3 = Theme.Brand; openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 19; openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = Theme.Brand; openStroke.Thickness = 1.8; openStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 

local function clickAnimate(obj)
    local scale = Instance.new("UIScale", obj)
    TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.92}):Play()
    task.wait(0.1)
    TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
    task.delay(0.3, function() scale:Destroy() end)
end

local btnDragToggle, btnDragStart, btnStartPos
openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragToggle = true; btnDragStart = input.Position; btnStartPos = openBtn.Position end
end)
UIS.InputChanged:Connect(function(input)
    if btnDragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        openBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + (input.Position.X - btnDragStart.X), btnStartPos.Y.Scale, btnStartPos.Y.Offset + (input.Position.Y - btnDragStart.Y))
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragToggle = false end end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 305)
frame.Position = UDim2.new(0.5, -175, 0.5, -152)
frame.BackgroundColor3 = Theme.MainBg; frame.BackgroundTransparency = 0.05; frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = Theme.Stroke; frameStroke.Thickness = 1.8
table.insert(RGBElements, {Type = "Frame", Stroke = frameStroke})

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 32); header.BackgroundColor3 = Theme.HeaderBg; header.BackgroundTransparency = 0; header.BorderSizePixel = 0; header.ZIndex = 10
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)
local headerCover = Instance.new("Frame", header) 
headerCover.Size = UDim2.new(1, 0, 0, 10); headerCover.Position = UDim2.new(0, 0, 1, -10); headerCover.BackgroundColor3 = Theme.HeaderBg; headerCover.BorderSizePixel = 0; headerCover.ZIndex = 10
local headerStroke = Instance.new("UIStroke", header); headerStroke.Color = Theme.Stroke; headerStroke.Thickness = 1.2; headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
table.insert(RGBElements, {Type = "Header", Stroke = headerStroke})

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, 0, 1, 0); titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MENU VIP PRO MAX"
titleLabel.TextColor3 = Theme.TextTitle; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 13; titleLabel.ZIndex = 10

local avatarImg = Instance.new("ImageLabel", header)
avatarImg.Size = UDim2.new(0, 22, 0, 22); avatarImg.Position = UDim2.new(0, 10, 0.5, -11); avatarImg.BackgroundTransparency = 1; avatarImg.ZIndex = 10
pcall(function() avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
local avatarStroke = Instance.new("UIStroke", avatarImg); avatarStroke.Color = Theme.Brand; avatarStroke.Thickness = 1.2; avatarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local dragToggle, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = true; dragStart = input.Position; startPos = frame.Position end
end)
UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)

-- SCROLLING TAB BAR
local tabBar = Instance.new("ScrollingFrame", frame)
tabBar.Size = UDim2.new(1, 0, 0, 28); tabBar.Position = UDim2.new(0, 0, 0, 32)
tabBar.BackgroundColor3 = Theme.TabBg; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 10
tabBar.ScrollBarThickness = 0; tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.ClipsDescendants = true

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0)
end)

local function createTab(name, width)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0, width, 1, 0)
    btn.Text = name; btn.BackgroundTransparency = 1; btn.TextColor3 = Theme.TextDim
    btn.BorderSizePixel = 0; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8; btn.ZIndex = 10
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0.5, 0, 0, 2); indicator.Position = UDim2.new(0.25, 0, 1, -2)
    indicator.BackgroundColor3 = Theme.Brand; indicator.BorderSizePixel = 0; indicator.Visible = false; indicator.ZIndex = 10
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    return btn, indicator
end

local tab1, ind1 = createTab("THÔNG TIN", 65)
local tab2, ind2 = createTab("TÍNH NĂNG", 65)
local tab3, ind3 = createTab("PLAYER",    55)
local tab4, ind4 = createTab("TIỆN ÍCH",  58)
local tab5, ind5 = createTab("NHẠC ID",   55) 
local tab6, ind6 = createTab("TP SAVE",   58)
local tab7, ind7 = createTab("TP PLAYER", 65)
local tab8, ind8 = createTab("AUTO SKILL", 68) 
local tab9, ind9 = createTab("CẤU HÌNH",  65)

local pageContainer = Instance.new("Frame", frame)
pageContainer.Size = UDim2.new(1, 0, 1, -62); pageContainer.Position = UDim2.new(0, 0, 0, 61); pageContainer.BackgroundTransparency = 1; pageContainer.ZIndex = 10

local function createPage()
    local pg = Instance.new("ScrollingFrame", pageContainer)
    pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1
    pg.ScrollBarThickness = 4; pg.ScrollBarImageColor3 = Theme.Brand; pg.Visible = false; pg.BorderSizePixel = 0; pg.ZIndex = 10
    local layout = Instance.new("UIListLayout", pg)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 6); layout.SortOrder = Enum.SortOrder.LayoutOrder 
    local pad = Instance.new("UIPadding", pg)
    pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 16) 
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30) end)
    return pg
end

local page1, page2, page3, page4, page8, page9 = createPage(), createPage(), createPage(), createPage(), createPage(), createPage()

local page5 = Instance.new("Frame", pageContainer)
page5.Size = UDim2.new(1, 0, 1, 0); page5.BackgroundTransparency = 1; page5.Visible = false; page5.ZIndex = 10
local l5 = Instance.new("UIListLayout", page5); l5.HorizontalAlignment = Enum.HorizontalAlignment.Center; l5.Padding = UDim.new(0, 6); l5.SortOrder = Enum.SortOrder.LayoutOrder; Instance.new("UIPadding", page5).PaddingTop = UDim.new(0, 6)

local page6 = Instance.new("Frame", pageContainer)
page6.Size = UDim2.new(1, 0, 1, 0); page6.BackgroundTransparency = 1; page6.Visible = false; page6.ZIndex = 10
local l6 = Instance.new("UIListLayout", page6); l6.HorizontalAlignment = Enum.HorizontalAlignment.Center; l6.Padding = UDim.new(0, 6); l6.SortOrder = Enum.SortOrder.LayoutOrder; Instance.new("UIPadding", page6).PaddingTop = UDim.new(0, 6)

local page7 = Instance.new("Frame", pageContainer)
page7.Size = UDim2.new(1, 0, 1, 0); page7.BackgroundTransparency = 1; page7.Visible = false; page7.ZIndex = 10
local l7 = Instance.new("UIListLayout", page7); l7.HorizontalAlignment = Enum.HorizontalAlignment.Center; l7.Padding = UDim.new(0, 5); l7.SortOrder = Enum.SortOrder.LayoutOrder
local pad7 = Instance.new("UIPadding", page7); pad7.PaddingTop = UDim.new(0, 5)

local function showTab(pg, tb, ind)
    for _, p in pairs({page1, page2, page3, page4, page5, page6, page7, page8, page9}) do p.Visible = false end
    for _, t in pairs({tab1, tab2, tab3, tab4, tab5, tab6, tab7, tab8, tab9}) do t.TextColor3 = Theme.TextDim end
    for _, i in pairs({ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8, ind9}) do i.Visible = false end
    pg.Visible = true; tb.TextColor3 = Theme.TextTitle; ind.Visible = true
    ind.Size = UDim2.new(0, 0, 0, 2)
    TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, 0, 0, 2)}):Play()
end

tab1.MouseButton1Click:Connect(function() showTab(page1, tab1, ind1) end)
tab2.MouseButton1Click:Connect(function() showTab(page2, tab2, ind2) end)
tab3.MouseButton1Click:Connect(function() showTab(page3, tab3, ind3) end)
tab4.MouseButton1Click:Connect(function() showTab(page4, tab4, ind4) end)
tab5.MouseButton1Click:Connect(function() showTab(page5, tab5, ind5) end)
tab6.MouseButton1Click:Connect(function() showTab(page6, tab6, ind6) end)
tab7.MouseButton1Click:Connect(function() showTab(page7, tab7, ind7) end)
tab8.MouseButton1Click:Connect(function() showTab(page8, tab8, ind8) end)
tab9.MouseButton1Click:Connect(function() showTab(page9, tab9, ind9) end)
showTab(page1, tab1, ind1)

local opened = true
openBtn.MouseButton1Click:Connect(function()
    clickAnimate(openBtn); opened = not opened
    if not State.RGB then
        openStroke.Color = opened and Theme.AccentOff or Theme.Brand
        TweenService:Create(openStroke, TweenInfo.new(0.3), {Color = opened and Theme.AccentOff or Theme.Brand}):Play()
    end
    frame:TweenPosition(opened and UDim2.new(0.5, -175, 0.5, -152) or UDim2.new(0.5, -175, 1.2, 0), "Out", "Back", 0.45)
end)

local function getUniversalRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("Torso") 
        or char:FindFirstChild("UpperTorso") 
        or char:FindFirstChild("Head")
        or char.PrimaryPart 
        or char:FindFirstChildWhichIsA("BasePart")
end

local function getCharacterCFrame(char)
    if not char then return nil end
    local root = getUniversalRoot(char)
    if root then return root.CFrame end
    if char:IsA("Model") then
        local ok, cf = pcall(function() return char:GetPivot() end)
        if ok and cf then return cf end
    end
    return nil
end

local function createDivider(parent, text)
    local dFrame = Instance.new("Frame", parent)
    dFrame.Size = UDim2.new(0.92, 0, 0, 15)
    dFrame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", dFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "─── " .. text .. " ───"
    label.TextColor3 = Theme.Brand
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    return dFrame
end

local function createCycleBtn(parent, prefix, options, stateVar)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.92, 0, 0, 32); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = Theme.Brand; stroke.Thickness = 1.2; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = Theme.Brand})
    
    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.TextColor3 = Theme.Brand; title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.ZIndex = 10
    
    local function updateText()
        local item = options[State[stateVar]] or options[1]
        title.Text = prefix .. " " .. item.Name
    end
    updateText()
    
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn)
        State[stateVar] = State[stateVar] + 1
        if State[stateVar] > #options then State[stateVar] = 1 end
        updateText()
        if State.AutoSave then saveConfig() end
    end)
    return btnFrame
end

local function createToggle(parent, text, varName, callback)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.92, 0, 0, 34); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 1.2
    
    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(0.74, 0, 1, 0); title.Position = UDim2.new(0.04, 0, 0, 0)
    title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = Theme.TextTitle; title.Font = Enum.Font.GothamSemibold; title.TextSize = 11.5; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local status = Instance.new("TextLabel", btn)
    status.Size = UDim2.new(0.18, 0, 1, 0); status.Position = UDim2.new(0.78, 0, 0, 0)
    status.BackgroundTransparency = 1; status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Right; status.ZIndex = 10
    
    local active = State[varName] or false
    status.Text = active and "ON" or "OFF"; status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
    stroke.Color = active and Theme.AccentOn or Theme.Stroke
    btn.BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg
    
    table.insert(RGBElements, {Type = "Toggle", Stroke = stroke, State = function() return State[varName] end})

    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); State[varName] = not State[varName]; active = State[varName]
        status.Text = active and "ON" or "OFF"
        TweenService:Create(status, TweenInfo.new(0.2), {TextColor3 = active and Theme.AccentOn or Theme.AccentOff}):Play()
        if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.2), {Color = active and Theme.AccentOn or Theme.Stroke}):Play() end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg}):Play()
        if varName ~= "AutoSave" then if active then MakeToast("Đã Bật", text, Theme.AccentOn) else MakeToast("Đã Tắt", text, Theme.AccentOff) end; if State.AutoSave then saveConfig() end end
        if callback then callback(active) end
    end)
    if active and callback then task.spawn(callback, active) end
    return btnFrame
end

local function createTab9Toggle(parent, text, varName, callback)
    local frameItem = createToggle(parent, text, varName, callback)
    local btn = frameItem:FindFirstChildOfClass("TextButton")
    Tab9Toggles[varName] = function(targetState)
        if State[varName] ~= targetState then
            State[varName] = targetState
            if btn then
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                for _, lbl in ipairs(btn:GetChildren()) do
                    if lbl:IsA("TextLabel") and (lbl.Text == "ON" or lbl.Text == "OFF") then
                        lbl.Text = targetState and "ON" or "OFF"
                        TweenService:Create(lbl, TweenInfo.new(0.2), {TextColor3 = targetState and Theme.AccentOn or Theme.AccentOff}):Play()
                    end
                end
                if stroke and not State.RGB then
                    TweenService:Create(stroke, TweenInfo.new(0.2), {Color = targetState and Theme.AccentOn or Theme.Stroke}):Play()
                end
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetState and Color3.fromRGB(35, 45, 40) or Theme.ItemBg}):Play()
            end
            if callback then task.spawn(callback, targetState) end
        end
    end
    return frameItem
end

local function createButton(parent, text, color, callback)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.92, 0, 0, 32); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = color; stroke.Thickness = 1.2; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = color})
    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = color; title.Font = Enum.Font.GothamBold; title.TextSize = 11.5; title.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
        task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = color}):Play() end
        MakeToast("Đã thực thi", text, color); callback()
    end)
    return btnFrame
end

local function createDualButtons(parent, text1, color1, cb1, text2, color2, cb2)
    local dFrame = Instance.new("Frame", parent)
    dFrame.Size = UDim2.new(0.92, 0, 0, 32); dFrame.BackgroundTransparency = 1
    local function makeBtn(xPos, txt, col, cb)
        local btn = Instance.new("TextButton", dFrame)
        btn.Size = UDim2.new(0.485, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn); stroke.Color = col; stroke.Thickness = 1.2; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = col})
        local title = Instance.new("TextLabel", btn)
        title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = txt; title.TextColor3 = col; title.Font = Enum.Font.GothamBold; title.TextSize = 10; title.ZIndex = 10
        btn.MouseButton1Click:Connect(function()
            clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
            task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = col}):Play() end
            if txt ~= "🗑️ XÓA TẤT CẢ" then MakeToast("Đã thực thi", txt, col) end; cb()
        end)
    end
    makeBtn(0, text1, color1, cb1); makeBtn(0.515, text2, color2, cb2)
    return dFrame
end

local function createSlider(parent, text, min, max, varName, callback)
    local sFrame = Instance.new("Frame", parent)
    sFrame.Size = UDim2.new(0.92, 0, 0, 38); sFrame.BackgroundTransparency = 1
    local bg = Instance.new("Frame", sFrame); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Theme.ItemBg; bg.ZIndex = 10
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", bg); stroke.Color = Theme.Stroke; stroke.Thickness = 1.2
    table.insert(RGBElements, {Type = "Slider", Stroke = stroke})
    local titleLabel = Instance.new("TextLabel", bg)
    titleLabel.Size = UDim2.new(0.7, 0, 0.45, 0); titleLabel.Position = UDim2.new(0.04, 0, 0.08, 0); titleLabel.BackgroundTransparency = 1; titleLabel.Text = text; titleLabel.TextColor3 = Theme.TextDim; titleLabel.Font = Enum.Font.GothamSemibold; titleLabel.TextSize = 11; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.ZIndex = 10
    local valLabel = Instance.new("TextLabel", bg)
    valLabel.Size = UDim2.new(0.25, 0, 0.45, 0); valLabel.Position = UDim2.new(0.71, 0, 0.08, 0); valLabel.BackgroundTransparency = 1; valLabel.Text = tostring(State[varName]); valLabel.TextColor3 = Theme.Brand; valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 11; valLabel.TextXAlignment = Enum.TextXAlignment.Right; valLabel.ZIndex = 10
    local track = Instance.new("Frame", bg)
    track.Size = UDim2.new(0.92, 0, 0.18, 0); track.Position = UDim2.new(0.04, 0, 0.64, 0); track.BackgroundColor3 = Theme.MainBg; track.ZIndex = 10
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(math.clamp((State[varName] - min) / (max - min), 0, 1), 0, 1, 0); fill.BackgroundColor3 = Theme.AccentOn; fill.ZIndex = 10
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        valLabel.Text = tostring(value); TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        State[varName] = value; if callback then callback(value) end; if State.AutoSave then saveConfig() end
    end
    track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; updateSlider(input) end end)
    UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    if callback then task.spawn(callback, State[varName]) end
    return sFrame
end

task.spawn(function()
    while task.wait(0.05) do
        if State.RGB then
            local hue = tick() % 5 / 5; local color = Color3.fromHSV(hue, 1, 1)
            titleLabel.TextColor3 = color; frameStroke.Color = color; headerStroke.Color = color; avatarStroke.Color = color; openStroke.Color = color
            for _, obj in pairs(RGBElements) do if obj.Stroke and obj.Stroke.Parent then obj.Stroke.Color = color end end
        end
    end
end)

-- ==========================================
-- [TAB 1: THÔNG TIN]
-- ==========================================
local function createInfoBox(parent, icon, titleText, heightOffset)
    local item = Instance.new("Frame", parent)
    item.Size = UDim2.new(0.92, 0, 0, heightOffset or 90); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1.2; table.insert(RGBElements, {Type = "Info", Stroke = stroke})
    local title = Instance.new("TextLabel", item)
    title.Size = UDim2.new(1, -16, 0, 20); title.Position = UDim2.new(0, 8, 0, 4); title.BackgroundTransparency = 1; title.Text = icon .. " " .. titleText; title.TextColor3 = Theme.Brand; title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local content = Instance.new("TextLabel", item)
    content.Size = UDim2.new(1, -16, 1, -26); content.Position = UDim2.new(0, 8, 0, 24); content.BackgroundTransparency = 1; content.Text = "Đang tải..."; content.TextColor3 = Theme.TextTitle; content.Font = Enum.Font.Gotham; content.TextSize = 10.5; content.TextXAlignment = Enum.TextXAlignment.Left; content.TextYAlignment = Enum.TextYAlignment.Top; content.RichText = true; content.ZIndex = 10
    return content, item
end

local playerInfoLabel = createInfoBox(page1, "👤", "THÔNG TIN NHÂN VẬT", 104)
local serverInfoLabel, serverInfoFrame = createInfoBox(page1, "🌐", "THÔNG TIN MÁY CHỦ", 90)

local copyIdBtn = Instance.new("TextButton", serverInfoFrame)
copyIdBtn.Size = UDim2.new(0, 22, 0, 22); copyIdBtn.Position = UDim2.new(1, -26, 1, -24); copyIdBtn.Text = "📜"; copyIdBtn.BackgroundTransparency = 1; copyIdBtn.TextSize = 13; copyIdBtn.ZIndex = 11
copyIdBtn.MouseButton1Click:Connect(function()
    clickAnimate(copyIdBtn)
    pcall(function() if setclipboard then setclipboard(tostring(game.JobId)); MakeToast("Đã Copy", "Đã lưu ID Server vào bộ nhớ tạm", Theme.AccentOn); local oldText = copyIdBtn.Text; copyIdBtn.Text = "✅"; task.wait(1); copyIdBtn.Text = oldText end end)
end)

local joinIdFrame = Instance.new("Frame", page1)
joinIdFrame.Size = UDim2.new(0.92, 0, 0, 34); joinIdFrame.BackgroundColor3 = Theme.ItemBg; joinIdFrame.ZIndex = 10
Instance.new("UICorner", joinIdFrame).CornerRadius = UDim.new(0, 8)
local jStroke = Instance.new("UIStroke", joinIdFrame); jStroke.Color = Theme.Stroke; jStroke.Thickness = 1.2; table.insert(RGBElements, {Type = "Info", Stroke = jStroke})
local idBox = Instance.new("TextBox", joinIdFrame)
idBox.Size = UDim2.new(0.65, 0, 1, 0); idBox.Position = UDim2.new(0.04, 0, 0, 0); idBox.BackgroundTransparency = 1; idBox.PlaceholderText = "Dán ID Server vào đây..."; idBox.Text = ""; idBox.TextColor3 = Theme.Brand; idBox.Font = Enum.Font.Gotham; idBox.TextSize = 10.5; idBox.TextXAlignment = Enum.TextXAlignment.Left; idBox.ClearTextOnFocus = false; idBox.ZIndex = 10
local joinBtn = Instance.new("TextButton", joinIdFrame)
joinBtn.Size = UDim2.new(0.25, 0, 0.7, 0); joinBtn.Position = UDim2.new(0.72, 0, 0.15, 0); joinBtn.BackgroundColor3 = Theme.AccentOn; joinBtn.Text = "VÀO"; joinBtn.TextColor3 = Color3.new(1, 1, 1); joinBtn.Font = Enum.Font.GothamBold; joinBtn.TextSize = 10.5; joinBtn.ZIndex = 10
Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 6)
joinBtn.MouseButton1Click:Connect(function() clickAnimate(joinBtn); local targetId = idBox.Text:gsub("%s+", ""); if targetId ~= "" then MakeToast("Đang Join", "Đang chuyển máy chủ...", Theme.AccentOn); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player) end) end end)

local extraInfoLabel = createInfoBox(page1, "⚙️", "TRẠNG THÁI", 78)
local fps = 0; RunService.RenderStepped:Connect(function(dt) fps = math.floor(1/dt) end)

task.spawn(function()
    while task.wait(0.5) do
        local hp, maxHp, ws, jp = 0, 0, 0, 0; local coords = "0, 0, 0"
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid; hp = math.floor(hum.Health); maxHp = math.floor(hum.MaxHealth); ws = math.floor(hum.WalkSpeed); jp = math.floor(hum.JumpPower)
        end
        if player.Character then
            local root = getUniversalRoot(player.Character)
            if root then local pos = root.Position; coords = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z) end
        end
        playerInfoLabel.Text = string.format(
            "<font color='#FF00FF'>Tên:</font> %s (@%s)\n<font color='#FF00FF'>Máu:</font> %d / %d\n<font color='#FF00FF'>Tốc độ:</font> %d\n<font color='#FF00FF'>Lực nhảy:</font> %d\n<font color='#FF00FF'>Tọa độ:</font> %s",
            player.DisplayName, player.Name, hp, maxHp, ws, jp, coords
        )
        local ping = "0"
        pcall(function() local stats = game:GetService("Stats"); if stats and stats:FindFirstChild("Network") and stats.Network:FindFirstChild("ServerStatsItem") then ping = stats.Network.ServerStatsItem["Data Ping"]:GetValueString() else ping = tostring(math.floor(player:GetNetworkPing() * 1000)) .. " ms" end end)
        local pCount = #Players:GetPlayers(); local maxP = Players.MaxPlayers; local jobText = game.JobId ~= "" and string.sub(game.JobId, 1, 14).."..." or "N/A"
        serverInfoLabel.Text = string.format(
            "<font color='#FF00FF'>FPS:</font> %d\n<font color='#FF00FF'>Ping:</font> %s\n<font color='#FF00FF'>Người chơi:</font> %d / %d\n<font color='#FF00FF'>ID SV:</font> %s",
            fps, ping, pCount, maxP, jobText
        )
        local execTime = math.floor(workspace.DistributedGameTime); local hours = math.floor(execTime / 3600); local mins = math.floor((execTime % 3600) / 60); local secs = execTime % 60
        extraInfoLabel.Text = string.format(
            "<font color='#FF00FF'>Thời gian chơi:</font> %02d:%02d:%02d\n<font color='#FF00FF'>Giờ hệ thống:</font> %s\n<font color='#FF00FF'>Phiên bản:</font> VIP PRO MAX V1.13.7",
            hours, mins, secs, os.date("%H:%M:%S")
        )
    end
end)

-- ==========================================
-- [TAB 2: TÍNH NĂNG]
-- ==========================================
createToggle(page2, "🛡️ Chống ngã & Chống văng xa", "AntiStun")
createToggle(page2, "🔒 Khóa vị trí", "LockPosition", function(v) if not v and player.Character then local r = getUniversalRoot(player.Character); if r then r.Anchored = false end end end)
createToggle(page2, "🚀 Nhảy trên không", "InfJump") 
UIS.JumpRequest:Connect(function() if State.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)
createToggle(page2, "🐿️ Lấy đồ nhanh", "Instant")
createToggle(page2, "🧲 Auto nhặt đồ xung quanh", "AutoCollect")

createToggle(page2, "🚷 Đi xuyên tường", "Noclip", function(v) 
    if not v and player.Character then 
        pcall(function() 
            local hrp = getUniversalRoot(player.Character)
            if hrp then 
                hrp.AssemblyLinearVelocity = Vector3.zero 
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            for _, part in ipairs(player.Character:GetDescendants()) do 
                if part:IsA("BasePart") then part.CanCollide = true end 
            end 
        end)
    end 
end)

local xrayTick = 0
createToggle(page2, "👀 Nhìn xuyên map (xray)", "XRay", function(v) 
    xrayTick = xrayTick + 1; local currentTick = xrayTick
    task.spawn(function()
        if v then
            for i, obj in ipairs(workspace:GetDescendants()) do
                if currentTick ~= xrayTick then return end 
                if obj:IsA("BasePart") and (not player.Character or not obj:IsDescendantOf(player.Character)) and obj.Name ~= "Terrain" and obj.Transparency < 1 then
                    if not xrayMats[obj] then xrayMats[obj] = obj.Transparency end; obj.Transparency = 0.5
                end
                if i % 300 == 0 then task.wait() end 
            end
        else
            local count = 0
            for obj, origTrans in pairs(xrayMats) do
                if currentTick ~= xrayTick then return end
                if obj and obj.Parent then obj.Transparency = origTrans end
                count = count + 1; if count % 300 == 0 then task.wait() end
            end
            if currentTick == xrayTick then xrayMats = {} end
        end
    end)
end)
createToggle(page2, "🔴 ESP người chơi", "ESP")

createDivider(page2, "TÍNH NĂNG MỞ RỘNG")

local airWalkPart = nil
local airWalkConn = nil
local airWalkY = nil

local function getFootOffset(char)
    local root = getUniversalRoot(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root and hum then
        if hum.RigType == Enum.HumanoidRigType.R15 then
            return hum.HipHeight + (root.Size.Y * 0.5) + 0.35
        else
            return 3.0 + (root.Size.Y * 0.5) + 0.35
        end
    end
    return 3.6
end

createToggle(page2, "☁️ Đi bộ trên không (Air Walk)", "AirWalk", function(v)
    if v then
        if airWalkPart then airWalkPart:Destroy() end
        airWalkPart = Instance.new("Part")
        airWalkPart.Name = "VipAirWalk"
        airWalkPart.Size = Vector3.new(12, 0.5, 12)
        airWalkPart.Anchored = true
        airWalkPart.CanCollide = true
        airWalkPart.Transparency = 0.45
        airWalkPart.Material = Enum.Material.Neon
        airWalkPart.Color = Theme.Brand
        airWalkPart.Parent = workspace

        local char = player.Character
        local root = getUniversalRoot(char)
        if root then
            airWalkY = root.Position.Y - getFootOffset(char)
            airWalkPart.CFrame = CFrame.new(root.Position.X, airWalkY, root.Position.Z)
        end

        if airWalkConn then airWalkConn:Disconnect() end
        airWalkConn = RunService.Heartbeat:Connect(function()
            local c = player.Character
            local r = getUniversalRoot(c)
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if r and h and airWalkPart then
                local offset = getFootOffset(c)
                if airWalkY == nil then
                    airWalkY = r.Position.Y - offset
                end
                if h.Jump and (r.Position.Y - offset) > airWalkY + 0.5 then
                    airWalkY = r.Position.Y - offset
                end
                airWalkPart.CFrame = CFrame.new(r.Position.X, airWalkY, r.Position.Z)
            end
        end)
    else
        if airWalkConn then airWalkConn:Disconnect(); airWalkConn = nil end
        if airWalkPart then airWalkPart:Destroy(); airWalkPart = nil end
        airWalkY = nil
    end
end)

createButton(page2, "🪄 GẬY CLICK TP", Theme.Brand, function()
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    if backpack:FindFirstChild("⚡ Click TP") or (player.Character and player.Character:FindFirstChild("⚡ Click TP")) then
        MakeToast("Thông báo", "Bạn đã có Gậy Click TP trong túi!", Theme.Brand)
        return
    end
    local tool = Instance.new("Tool")
    tool.Name = "⚡ Click TP"
    tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        if mouse and mouse.Hit and player.Character then
            local root = getUniversalRoot(player.Character)
            if root then
                root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3.5, 0))
                if State.AirWalk then
                    airWalkY = root.Position.Y - getFootOffset(player.Character)
                end
            end
        end
    end)
    tool.Parent = backpack
end)

createDualButtons(
    page2,
    "🔭 MỞ KHÓA ZOOM CAM",
    Color3.fromRGB(255, 180, 50),
    function()
        pcall(function()
            player.CameraMaxZoomDistance = 10000
            player.CameraMinZoomDistance = 0.5
            player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            workspace.CurrentCamera.FieldOfView = 105
        end)
    end,
    "👥 TẠO PHÂN THÂN",
    Color3.fromRGB(180, 100, 255),
    function()
        local char = player.Character
        if char then
            char.Archivable = true
            local clone = char:Clone()
            clone.Name = player.Name .. "_Clone"
            for _, v in ipairs(clone:GetDescendants()) do
                if v:IsA("LuaSourceContainer") then v:Destroy() end
            end
            clone.Parent = workspace
            local cRoot = getUniversalRoot(clone)
            if cRoot then cRoot.Anchored = true end
        end
    end
)

-- ==========================================
-- [TAB 3: PLAYER]
-- ==========================================
createToggle(page3, "🕊️ bay trên bầu trời", "Fly", function(v)
    local char = player.Character
    if char then
        local root = getUniversalRoot(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if v then
            if root and not root:FindFirstChild("FlyBodyVelocity") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "FlyBodyVelocity"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.zero
                bv.Parent = root
                
                local bg = Instance.new("BodyGyro")
                bg.Name = "FlyBodyGyro"
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.P = 10000
                bg.D = 100
                bg.Parent = root
            end
        else
            if root and root:FindFirstChild("FlyBodyVelocity") then root.FlyBodyVelocity:Destroy() end
            if root and root:FindFirstChild("FlyBodyGyro") then root.FlyBodyGyro:Destroy() end
            if hum then hum.PlatformStand = false end
        end
    end
end)
createSlider(page3, "Tốc độ bay", 10, 1000, "FlySpeed")

local defaultWalkSpeed = 16
createToggle(page3, "🏃 Chạy nhanh", "Speed", function(v)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if v then
            if hum.WalkSpeed ~= State.SpeedValue then
                defaultWalkSpeed = hum.WalkSpeed
            end
            hum.WalkSpeed = State.SpeedValue
        else
            hum.WalkSpeed = defaultWalkSpeed
        end
    end
end)
createSlider(page3, "Tốc độ chạy", 1, 1000, "SpeedValue", function(val)
    if State.Speed and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end)

local defaultJumpPower = 50
createToggle(page3, "🦘 Nhảy cao", "Jump", function(v) 
    if player.Character and player.Character:FindFirstChild("Humanoid") then 
        if v then defaultJumpPower = player.Character.Humanoid.JumpPower else player.Character.Humanoid.UseJumpPower = true; player.Character.Humanoid.JumpPower = defaultJumpPower end
    end 
end)
createSlider(page3, "Lực nhảy", 1, 1000, "JumpValue")

createToggle(page3, "💨 Lướt liên tục", "AutoDash")
createSlider(page3, "Tốc độ lướt", 1, 50, "DashSpeed")

createToggle(page3, "⚔️ Đánh xa", "Reach")
createSlider(page3, "Kích thước vũ khí", 0, 300, "ReachSize")
createToggle(page3, "🎯 Hitbox", "Hitbox")
createSlider(page3, "Kích thước Hitbox", 0, 100, "HitboxSize")
createToggle(page3, "🌪️ Xoay vòng tròn", "SpinBot")
createSlider(page3, "Tốc độ xoay", 0, 100, "SpinSpeed")
createToggle(page3, "💡 Ánh sáng quanh người", "PlayerLight", function(v) if not v and player.Character then local root = getUniversalRoot(player.Character); if root then local light = root:FindFirstChild("PlayerPointLight"); if light then light:Destroy() end end end end)
createSlider(page3, "Phạm vi sáng (Max 60)", 0, 60, "LightRange")
createSlider(page3, "Độ sáng", 0, 5, "LightBrightness")
createCycleBtn(page3, "🎨 Đổi màu:", PlayerLightColors, "LightColorIdx")

-- ==========================================
-- [TAB 4: TIỆN ÍCH]
-- ==========================================
createToggle(page4, "💾 Lưu Cài Đặt", "AutoSave", function(v) 
    if v then saveConfig(); MakeToast("Đã Bật", "Đã lưu cấu hình hiện tại!", Theme.AccentOn)
    else pcall(function() if isfile and isfile(configFileName) then delfile(configFileName) end end); MakeToast("Đã Tắt", "Đã xóa cấu hình cũ!", Theme.AccentOff) end 
end)
createToggle(page4, "🌈 Chế độ RGB", "RGB", function(v) 
    if not v then 
        titleLabel.TextColor3 = Theme.TextTitle; frameStroke.Color = Theme.Stroke; headerStroke.Color = Theme.Stroke; avatarStroke.Color = Theme.Brand; openStroke.Color = opened and Theme.AccentOff or Theme.Brand
        for _, obj in pairs(RGBElements) do
            if obj.Stroke and obj.Stroke.Parent then
                if obj.Type == "Toggle" then obj.Stroke.Color = obj.State() and Theme.AccentOn or Theme.Stroke
                elseif obj.Type == "Button" then obj.Stroke.Color = obj.DefaultColor
                elseif obj.Type == "Slider" or obj.Type == "Info" or obj.Type == "Container" then obj.Stroke.Color = Theme.Stroke end
            end
        end
    end 
end)

createToggle(page4, "💫 Mở khóa ShiftLock Mobile", "ShiftLock", function(v) pcall(function() player.DevEnableMouseLock = v end) end)
createToggle(page4, "🖱️ Auto Click", "AutoClick")
task.spawn(function()
    while task.wait(0.1) do 
        if State.AutoClick and player.Character then pcall(function() local tool = player.Character:FindFirstChildOfClass("Tool"); if tool then tool:Activate() end end) end
    end
end)

createToggle(page4, "🛡️ Chống AFK (Antiafk)", "AntiAfk")

player.Idled:Connect(function() 
    if State.AntiAfk then 
        pcall(function() 
            VirtualUser:CaptureController()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.5)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end) 
    end 
end)

local function hopServer(sortOrder)
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=100"
    local function getServers(cursor) 
        local url = api .. (cursor and "&cursor=" .. cursor or "")
        local success, res = pcall(function() return game:HttpGet(url) end) 
        if success then return HttpService:JSONDecode(res) end 
    end
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
    if targetServer then TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, player) end
end
local function rejoinServer()
    if #Players:GetPlayers() <= 1 then player:Kick("\nĐang vào lại server..."); task.wait(); TeleportService:Teleport(game.PlaceId, player) else TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end
end

createDualButtons(
    page4,
    "☀️ TRỜI SÁNG",
    Color3.fromRGB(255, 200, 50),
    function()
        pcall(function()
            Lighting.ClockTime = 12
            Lighting.Brightness = 2
        end)
    end,
    "🌙 TRỜI TỐI",
    Color3.fromRGB(130, 140, 255),
    function()
        pcall(function()
            Lighting.ClockTime = 0
            Lighting.Brightness = 1
        end)
    end
)

createDualButtons(page4, "🔄 VÀO LẠI SV", Theme.AccentOn, rejoinServer, "🎲 ĐỔI SV NGẪU NHIÊN", Theme.Brand, function() hopServer("Desc") end)
createDualButtons(page4, "📉 ĐỔI SV ÍT NGƯỜI", Color3.fromRGB(52, 152, 219), function() hopServer("Asc") end, "📈 ĐỔI SV NHIỀU NGƯỜI", Color3.fromRGB(231, 76, 60), function() hopServer("Desc") end)

createDualButtons(
    page4,
    "💻 LỆNH ADMIN",
    Theme.AccentOn,
    function()
        pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end)
    end,
    "📁 TP SAVE",
    Theme.Brand,
    function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip13/refs/heads/main/menu-save.lua"))()
        end)
    end
)

createDualButtons(
    page4,
    "🕊️ FLY V1",
    Theme.Brand,
    function()
        pcall(function()
            loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
        end)
    end,
    "🕊️ FLY V2",
    Theme.Brand,
    function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        end)
    end
)

createDualButtons(
    page4,
    "🕊️ FLY V3",
    Theme.Brand,
    function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip/refs/heads/main/menu-fly.lua"))()
        end)
    end,
    "🎯 TP PLAYS (người chơi)",
    Theme.AccentOn,
    function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/hack.lua/refs/heads/main/menu-tp-play.lua"))()
        end)
    end
)

-- ==========================================
-- [TAB 5: NHẠC ID] & [TAB 6: TP SAVE] 
-- ==========================================
local currentSound = nil; local currentMusicId = ""; local savedMusicList = {}
local musicControlFrame = Instance.new("Frame", page5); musicControlFrame.Size = UDim2.new(0.92, 0, 0, 62); musicControlFrame.BackgroundColor3 = Theme.ItemBg; musicControlFrame.ZIndex = 10; musicControlFrame.LayoutOrder = 1; Instance.new("UICorner", musicControlFrame).CornerRadius = UDim.new(0, 8)
local mStroke = Instance.new("UIStroke", musicControlFrame); mStroke.Color = Theme.Stroke; mStroke.Thickness = 1.2; table.insert(RGBElements, {Type = "Info", Stroke = mStroke})
local musicIcon = Instance.new("TextLabel", musicControlFrame); musicIcon.Size = UDim2.new(0.12, 0, 0, 30); musicIcon.BackgroundTransparency = 1; musicIcon.Text = "🎼"; musicIcon.TextSize = 15; musicIcon.ZIndex = 10
local musicIdBox = Instance.new("TextBox", musicControlFrame); musicIdBox.Size = UDim2.new(0.66, 0, 0, 30); musicIdBox.Position = UDim2.new(0.12, 0, 0, 0); musicIdBox.BackgroundTransparency = 1; musicIdBox.PlaceholderText = "Nhập ID Nhạc..."; musicIdBox.Text = ""; musicIdBox.TextColor3 = Theme.TextTitle; musicIdBox.Font = Enum.Font.GothamSemibold; musicIdBox.TextSize = 11; musicIdBox.TextXAlignment = Enum.TextXAlignment.Left; musicIdBox.ClearTextOnFocus = false; musicIdBox.ZIndex = 10
local saveIdBtn = Instance.new("TextButton", musicControlFrame); saveIdBtn.Size = UDim2.new(0.22, 0, 0, 30); saveIdBtn.Position = UDim2.new(0.78, 0, 0, 0); saveIdBtn.BackgroundTransparency = 1; saveIdBtn.Text = "💾 Lưu"; saveIdBtn.TextColor3 = Theme.AccentOn; saveIdBtn.Font = Enum.Font.GothamBold; saveIdBtn.TextSize = 10.5; saveIdBtn.ZIndex = 10
local divLine = Instance.new("Frame", musicControlFrame); divLine.Size = UDim2.new(0.92, 0, 0, 1); divLine.Position = UDim2.new(0.04, 0, 0, 30); divLine.BackgroundColor3 = Theme.Stroke; divLine.BorderSizePixel = 0; divLine.ZIndex = 10
local nowPlayingLabel = Instance.new("TextLabel", musicControlFrame); nowPlayingLabel.Size = UDim2.new(0.92, 0, 0, 30); nowPlayingLabel.Position = UDim2.new(0.04, 0, 0, 31); nowPlayingLabel.BackgroundTransparency = 1; nowPlayingLabel.RichText = true; nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Chưa có nhạc phát</font>"; nowPlayingLabel.Font = Enum.Font.GothamSemibold; nowPlayingLabel.TextSize = 11; nowPlayingLabel.TextWrapped = true; nowPlayingLabel.ZIndex = 10

local function getSongName(id) local numId = tonumber(id); if not numId then return "ID sai!" end; local s, info = pcall(function() return MarketplaceService:GetProductInfo(numId) end); if s and info then return info.Name else return "Ẩn danh" end end
local function playMusic(id)
    if currentSound then currentSound:Destroy() end; local soundId = tostring(id):match("%d+"); if not soundId or soundId == "" then return end
    currentMusicId = soundId; nowPlayingLabel.Text = "<font color='#FFFFFF'>⏳ Tải...</font>"
    task.spawn(function() local name = getSongName(soundId); if currentMusicId == soundId then nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Phát:</font> <font color='#FFFF00'>" .. name .. "</font>" end end)
    currentSound = Instance.new("Sound"); currentSound.SoundId = "rbxassetid://" .. soundId; currentSound.Volume = State.MusicVolume; currentSound.Parent = workspace
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
local volumeFrame = createSlider(page5, "ÂM LƯỢNG 🔊", 0, 10, "MusicVolume", function(val) if currentSound then currentSound.Volume = val end end); volumeFrame.LayoutOrder = 3
local savedMusicContent = Instance.new("ScrollingFrame", page5); savedMusicContent.Size = UDim2.new(0.92, 0, 1, -155); savedMusicContent.BackgroundTransparency = 1; savedMusicContent.ScrollBarThickness = 4; savedMusicContent.ScrollBarImageColor3 = Theme.Brand; savedMusicContent.BorderSizePixel = 0; savedMusicContent.ZIndex = 10; savedMusicContent.LayoutOrder = 4
local sLayout = Instance.new("UIListLayout", savedMusicContent); sLayout.SortOrder = Enum.SortOrder.LayoutOrder; sLayout.Padding = UDim.new(0, 5)
sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedMusicContent.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 12) end)

local fileName = "MenuVipProMax_SavedMusic.json"
pcall(function() if isfile and isfile(fileName) then local decoded = HttpService:JSONDecode(readfile(fileName)); if type(decoded) == "table" then savedMusicList = decoded end end end)
local function saveMusicData() pcall(function() if writefile then writefile(fileName, HttpService:JSONEncode(savedMusicList)) end end) end
local function renderSavedMusic()
    for _, child in pairs(savedMusicContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for i, data in ipairs(savedMusicList) do
        local item = Instance.new("Frame", savedMusicContent); item.Size = UDim2.new(1, -6, 0, 36); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1.2; table.insert(RGBElements, {Type = "Info", Stroke = stroke})
        local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.54, 0, 1, 0); nameBox.Position = UDim2.new(0.05, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 10.5; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
        nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveMusicData() else nameBox.Text = data.name end end)
        local playBtn = Instance.new("TextButton", item); playBtn.Size = UDim2.new(0.18, 0, 0.65, 0); playBtn.Position = UDim2.new(0.62, 0, 0.175, 0); playBtn.Text = "▶️"; playBtn.BackgroundColor3 = Theme.Brand; playBtn.TextColor3 = Color3.new(1,1,1); playBtn.Font = Enum.Font.GothamBold; playBtn.TextSize = 10; playBtn.ZIndex = 10; Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)
        local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.65, 0); delBtn.Position = UDim2.new(0.82, 0, 0.175, 0); delBtn.Text = "❌"; delBtn.BackgroundColor3 = Theme.AccentOff; delBtn.TextColor3 = Color3.new(1,1,1); delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 10; delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        playBtn.MouseButton1Click:Connect(function() clickAnimate(playBtn); musicIdBox.Text = data.id; playMusic(data.id) end)
        delBtn.MouseButton1Click:Connect(function() clickAnimate(delBtn); table.remove(savedMusicList, i); saveMusicData(); renderSavedMusic() end)
    end
end
saveIdBtn.MouseButton1Click:Connect(function() clickAnimate(saveIdBtn); local rawId = musicIdBox.Text:match("%d+"); if rawId and rawId ~= "" then saveIdBtn.Text = "⏳..."; task.spawn(function() local name = getSongName(rawId); table.insert(savedMusicList, {id = rawId, name = name}); saveMusicData(); renderSavedMusic(); saveIdBtn.Text = "💾 Lưu" end) end end)
renderSavedMusic()

local tpFileName = "MenuVipProMax_SavedTPs.json"; local savedTpList = {}; pcall(function() if isfile and isfile(tpFileName) then local decoded = HttpService:JSONDecode(readfile(tpFileName)); if type(decoded) == "table" then savedTpList = decoded end end end)
local function saveTpData() pcall(function() if writefile then local d = {}; for _, v in ipairs(savedTpList) do if not v.isTemp then table.insert(d, v) end end; writefile(tpFileName, HttpService:JSONEncode(d)) end end) end
local pendingDeleteAll = false
local renderSavedTps

local tpControlFrame_New = createDualButtons(page6, "📍 LƯU VỊ TRÍ", Theme.Brand, function()
    if player.Character then
        local root = getUniversalRoot(player.Character)
        if root then
            local cf = {root.CFrame:GetComponents()}; local mx = 0
            for _, v in ipairs(savedTpList) do local num = string.match(v.name, "Lưu Vị Trí (%d+)"); if num then mx = math.max(mx, tonumber(num)) end end
            table.insert(savedTpList, {name = "Lưu Vị Trí " .. (mx + 1), cframe = cf, isTemp = false}); saveTpData(); renderSavedTps()
        end
    end
end, "🗑️ XÓA TẤT CẢ", Theme.AccentOff, function() 
    if not pendingDeleteAll then pendingDeleteAll = true; MakeToast("⚠️ CẢNH BÁO", "Ấn lần nữa để xác nhận xóa sạch!", Theme.AccentOff); task.delay(3, function() pendingDeleteAll = false end)
    else savedTpList = {}; saveTpData(); renderSavedTps(); MakeToast("Thành công", "Đã xóa toàn bộ!", Theme.Brand); pendingDeleteAll = false end
end); tpControlFrame_New.LayoutOrder = 1 

local savedTpContent = Instance.new("ScrollingFrame", page6); savedTpContent.Size = UDim2.new(0.92, 0, 1, -48); savedTpContent.BackgroundTransparency = 1; savedTpContent.ScrollBarThickness = 4; savedTpContent.ScrollBarImageColor3 = Theme.Brand; savedTpContent.BorderSizePixel = 0; savedTpContent.ZIndex = 10; savedTpContent.LayoutOrder = 2
local tpLayout = Instance.new("UIListLayout", savedTpContent); tpLayout.SortOrder = Enum.SortOrder.LayoutOrder; tpLayout.Padding = UDim.new(0, 5)
tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedTpContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 12) end)

renderSavedTps = function()
    for _, child in pairs(savedTpContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for i, data in ipairs(savedTpList) do
        local item = Instance.new("Frame", savedTpContent); item.Size = UDim2.new(1, -6, 0, 36); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1.2; table.insert(RGBElements, {Type = "Info", Stroke = stroke})
        local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.48, 0, 1, 0); nameBox.Position = UDim2.new(0.04, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 11; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
        nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveTpData() else nameBox.Text = data.name end end)
        local tpBtn = Instance.new("TextButton", item); tpBtn.Size = UDim2.new(0.24, 0, 0.65, 0); tpBtn.Position = UDim2.new(0.54, 0, 0.175, 0); tpBtn.Text = "TP"; tpBtn.BackgroundColor3 = Theme.Brand; tpBtn.TextColor3 = Color3.new(1,1,1); tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 10.5; tpBtn.ZIndex = 10; Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
        local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.65, 0); delBtn.Position = UDim2.new(0.81, 0, 0.175, 0); delBtn.Text = "X"; delBtn.BackgroundColor3 = Theme.AccentOff; delBtn.TextColor3 = Color3.new(1,1,1); delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 11; delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        tpBtn.MouseButton1Click:Connect(function() clickAnimate(tpBtn); if player.Character then local r = getUniversalRoot(player.Character); if r then r.CFrame = CFrame.new(unpack(data.cframe)); MakeToast("Dịch chuyển", "Đến " .. data.name, Theme.Brand) end end end)
        delBtn.MouseButton1Click:Connect(function() clickAnimate(delBtn); table.remove(savedTpList, i); saveTpData(); renderSavedTps() end)
    end
end
renderSavedTps()

-- ==========================================
-- [TAB 7: TP NGƯỜI CHƠI]
-- ==========================================
local targetTpPlayer = nil
local autoTpPlayerEnabled = false
local spectatePlayerEnabled = false
local wasHorizontalTp = false
local spectateProxyPart = nil
local lastSpectateStreamTick = 0

local function restoreNormalPosture()
    local myChar = player.Character
    if not myChar then return end
    local myRoot = getUniversalRoot(myChar)
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if myHum and not State.Fly and not State.AntiStun then
        myHum.PlatformStand = false
    end
    if myRoot then
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
        local pos = myRoot.Position
        local look = myRoot.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0.001 then
            myRoot.CFrame = CFrame.lookAt(pos, pos + flatLook.Unit)
        else
            myRoot.CFrame = CFrame.new(pos)
        end
    end
    if not State.Noclip then
        for _, part in ipairs(myChar:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    wasHorizontalTp = false
end

local tpControlCard = Instance.new("Frame", page7)
tpControlCard.Size = UDim2.new(0.94, 0, 0, 86)
tpControlCard.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
tpControlCard.LayoutOrder = 1
tpControlCard.ZIndex = 10
Instance.new("UICorner", tpControlCard).CornerRadius = UDim.new(0, 8)
local tpCardStroke = Instance.new("UIStroke", tpControlCard)
tpCardStroke.Color = Theme.Brand
tpCardStroke.Thickness = 1.4
table.insert(RGBElements, {Type = "Button", Stroke = tpCardStroke, DefaultColor = Theme.Brand})

local targetHeaderRow = Instance.new("Frame", tpControlCard)
targetHeaderRow.Size = UDim2.new(1, -12, 0, 26)
targetHeaderRow.Position = UDim2.new(0, 6, 0, 4)
targetHeaderRow.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
targetHeaderRow.ZIndex = 10
Instance.new("UICorner", targetHeaderRow).CornerRadius = UDim.new(0, 6)

local selectedAvatarImg = Instance.new("ImageLabel", targetHeaderRow)
selectedAvatarImg.Size = UDim2.new(0, 20, 0, 20)
selectedAvatarImg.Position = UDim2.new(0, 5, 0.5, -10)
selectedAvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
selectedAvatarImg.Image = "rbxassetid://0"
selectedAvatarImg.ZIndex = 10
Instance.new("UICorner", selectedAvatarImg).CornerRadius = UDim.new(1, 0)
local selAvaStroke = Instance.new("UIStroke", selectedAvatarImg)
selAvaStroke.Color = Theme.Brand
selAvaStroke.Thickness = 1

local targetStatusLabel = Instance.new("TextLabel", targetHeaderRow)
targetStatusLabel.Size = UDim2.new(1, -112, 1, 0)
targetStatusLabel.Position = UDim2.new(0, 30, 0, 0)
targetStatusLabel.BackgroundTransparency = 1
targetStatusLabel.RichText = true
targetStatusLabel.Text = "🎯 <font color='#FF6B81'>Chưa chọn mục tiêu</font>"
targetStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetStatusLabel.Font = Enum.Font.GothamBold
targetStatusLabel.TextSize = 11
targetStatusLabel.TextTruncate = Enum.TextTruncate.AtEnd
targetStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
targetStatusLabel.ZIndex = 10

local spectateBtn = Instance.new("TextButton", targetHeaderRow)
spectateBtn.Size = UDim2.new(0, 76, 0, 20)
spectateBtn.Position = UDim2.new(1, -80, 0.5, -10)
spectateBtn.BackgroundColor3 = Color3.fromRGB(55, 35, 45)
spectateBtn.Text = "👁️ XEM [TẮT]"
spectateBtn.TextColor3 = Theme.AccentOff
spectateBtn.Font = Enum.Font.GothamBold
spectateBtn.TextSize = 9.5
spectateBtn.AutoButtonColor = false
spectateBtn.ZIndex = 10
Instance.new("UICorner", spectateBtn).CornerRadius = UDim.new(0, 5)
local spectateStroke = Instance.new("UIStroke", spectateBtn)
spectateStroke.Color = Theme.AccentOff
spectateStroke.Thickness = 1
spectateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local tpPosBtn = Instance.new("TextButton", tpControlCard)
tpPosBtn.Size = UDim2.new(1, -12, 0, 24)
tpPosBtn.Position = UDim2.new(0, 6, 0, 33)
tpPosBtn.BackgroundColor3 = Color3.fromRGB(0, 105, 155)
tpPosBtn.Text = ""
tpPosBtn.AutoButtonColor = false
tpPosBtn.ZIndex = 10
Instance.new("UICorner", tpPosBtn).CornerRadius = UDim.new(0, 6)
local tpPosStroke = Instance.new("UIStroke", tpPosBtn)
tpPosStroke.Color = Color3.fromRGB(80, 220, 255)
tpPosStroke.Thickness = 1.2
tpPosStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local tpPosLabel = Instance.new("TextLabel", tpPosBtn)
tpPosLabel.Size = UDim2.new(1, 0, 1, 0)
tpPosLabel.BackgroundTransparency = 1
tpPosLabel.RichText = true
tpPosLabel.TextColor3 = Color3.new(1, 1, 1)
tpPosLabel.Font = Enum.Font.GothamBlack
tpPosLabel.TextSize = 11
tpPosLabel.ZIndex = 10

local function updateTpPosText()
    local item = TpPositions[State.TpPositionIdx] or TpPositions[1]
    tpPosLabel.Text = "📍 VỊ TRÍ TP: <font color='#FFFF55'>" .. string.upper(item.Name) .. "</font>"
end
updateTpPosText()

tpPosBtn.MouseButton1Click:Connect(function()
    clickAnimate(tpPosBtn)
    State.TpPositionIdx = State.TpPositionIdx + 1
    if State.TpPositionIdx > #TpPositions then State.TpPositionIdx = 1 end
    updateTpPosText()
    local currentMode = TpPositions[State.TpPositionIdx] or TpPositions[1]
    if not currentMode.IsHorizontal and wasHorizontalTp then
        restoreNormalPosture()
    end
    if State.AutoSave then saveConfig() end
end)

local tpDistContainer = Instance.new("Frame", tpControlCard)
tpDistContainer.Size = UDim2.new(1, -12, 0, 24)
tpDistContainer.Position = UDim2.new(0, 6, 0, 59)
tpDistContainer.BackgroundTransparency = 1
tpDistContainer.ZIndex = 10

local tpDistTitle = Instance.new("TextLabel", tpDistContainer)
tpDistTitle.Size = UDim2.new(0.7, 0, 0, 12)
tpDistTitle.Position = UDim2.new(0, 2, 0, 0)
tpDistTitle.BackgroundTransparency = 1
tpDistTitle.Text = "📏 Khoảng cách đứng (Studs):"
tpDistTitle.TextColor3 = Color3.fromRGB(240, 245, 255)
tpDistTitle.Font = Enum.Font.GothamBold
tpDistTitle.TextSize = 10.5
tpDistTitle.TextXAlignment = Enum.TextXAlignment.Left
tpDistTitle.ZIndex = 10

local tpDistValLabel = Instance.new("TextLabel", tpDistContainer)
tpDistValLabel.Size = UDim2.new(0.3, -4, 0, 12)
tpDistValLabel.Position = UDim2.new(0.7, 0, 0, 0)
tpDistValLabel.BackgroundTransparency = 1
tpDistValLabel.Text = tostring(State.TpDistance) .. " m"
tpDistValLabel.TextColor3 = Color3.fromRGB(255, 235, 60)
tpDistValLabel.Font = Enum.Font.GothamBlack
tpDistValLabel.TextSize = 11
tpDistValLabel.TextXAlignment = Enum.TextXAlignment.Right
tpDistValLabel.ZIndex = 10

local tpDistTrack = Instance.new("Frame", tpDistContainer)
tpDistTrack.Size = UDim2.new(1, -4, 0, 7)
tpDistTrack.Position = UDim2.new(0, 2, 0, 15)
tpDistTrack.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
tpDistTrack.ZIndex = 10
Instance.new("UICorner", tpDistTrack).CornerRadius = UDim.new(1, 0)
local tpDistTrackStroke = Instance.new("UIStroke", tpDistTrack)
tpDistTrackStroke.Color = Color3.fromRGB(70, 80, 100)
tpDistTrackStroke.Thickness = 1

local tpDistFill = Instance.new("Frame", tpDistTrack)
tpDistFill.Size = UDim2.new(math.clamp((State.TpDistance - 1) / 24, 0, 1), 0, 1, 0)
tpDistFill.BackgroundColor3 = Theme.AccentOn
tpDistFill.ZIndex = 10
Instance.new("UICorner", tpDistFill).CornerRadius = UDim.new(1, 0)

local draggingTpDist = false
local function updateTpDistSlider(input)
    local pos = math.clamp((input.Position.X - tpDistTrack.AbsolutePosition.X) / tpDistTrack.AbsoluteSize.X, 0, 1)
    local value = math.floor(1 + (24 * pos))
    tpDistValLabel.Text = tostring(value) .. " m"
    TweenService:Create(tpDistFill, TweenInfo.new(0.08), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
    State.TpDistance = value
    if State.AutoSave then saveConfig() end
end
tpDistTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingTpDist = true
        updateTpDistSlider(input)
    end
end)
UIS.InputChanged:Connect(function(input)
    if draggingTpDist and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateTpDistSlider(input)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingTpDist = false
    end
end)

local function updateTargetLabel()
    if targetTpPlayer then
        targetStatusLabel.Text = string.format("🎯 <font color='#2ECC71'>%s</font> <font color='#FFD700'>(@%s)</font>", targetTpPlayer.DisplayName, targetTpPlayer.Name)
        selAvaStroke.Color = Theme.AccentOn
        task.spawn(function()
            pcall(function()
                selectedAvatarImg.Image = Players:GetUserThumbnailAsync(targetTpPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
        end)
    else
        targetStatusLabel.Text = "🎯 <font color='#FF6B81'>Chưa chọn mục tiêu</font>"
        selAvaStroke.Color = Theme.AccentOff
        selectedAvatarImg.Image = "rbxassetid://0"
    end
end

local lastStreamRequest = 0
local function teleportToSelectedPlayer(isManualClick)
    if not targetTpPlayer or not targetTpPlayer.Character then return false end
    local targetCF = getCharacterCFrame(targetTpPlayer.Character)
    local targetHum = targetTpPlayer.Character:FindFirstChildOfClass("Humanoid")
    
    local myChar = player.Character
    if not myChar then return false end
    local myRoot = getUniversalRoot(myChar)
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    
    if targetCF and myRoot and (not targetHum or targetHum.Health > 0) and (not myHum or myHum.Health > 0) then
        local mode = TpPositions[State.TpPositionIdx] or TpPositions[1]
        local targetPos = targetCF.Position
        local dist = (myRoot.Position - targetPos).Magnitude

        if (dist > 250 or not getUniversalRoot(targetTpPlayer.Character)) and (tick() - lastStreamRequest > 0.6) then
            lastStreamRequest = tick()
            task.spawn(function()
                pcall(function()
                    player:RequestStreamAroundAsync(targetPos, 3)
                end)
            end)
        end

        local _, targetYaw, _ = targetCF:ToEulerAnglesYXZ()
        local baseCFrame = CFrame.new(targetPos) * CFrame.Angles(0, targetYaw, 0)
        local finalCFrame = baseCFrame * mode.GetOffset(State.TpDistance)
        
        if mode.IsHorizontal then
            if myHum then myHum.PlatformStand = true end
            wasHorizontalTp = true
            for _, part in ipairs(myChar:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        elseif wasHorizontalTp then
            restoreNormalPosture()
        end
        
        myRoot.CFrame = finalCFrame
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero

        if isManualClick and dist > 500 then
            task.spawn(function()
                for _ = 1, 6 do
                    task.wait(0.1)
                    if not targetTpPlayer or not targetTpPlayer.Character then break end
                    local updatedCF = getCharacterCFrame(targetTpPlayer.Character)
                    local curRoot = getUniversalRoot(player.Character)
                    if updatedCF and curRoot then
                        local _, yaw, _ = updatedCF:ToEulerAnglesYXZ()
                        local bCF = CFrame.new(updatedCF.Position) * CFrame.Angles(0, yaw, 0)
                        curRoot.CFrame = bCF * mode.GetOffset(State.TpDistance)
                        curRoot.AssemblyLinearVelocity = Vector3.zero
                    end
                end
            end)
        end
        return true
    end
    return false
end

local function resetCameraSubject()
    pcall(function()
        if spectateProxyPart then
            spectateProxyPart:Destroy()
            spectateProxyPart = nil
        end
        player.ReplicationFocus = nil
        local cam = workspace.CurrentCamera
        if cam and player.Character then
            local myHum = player.Character:FindFirstChildOfClass("Humanoid")
            if myHum then
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = myHum
            end
        end
    end)
end

local tpActionRow = Instance.new("Frame", page7)
tpActionRow.Size = UDim2.new(0.94, 0, 0, 28)
tpActionRow.BackgroundTransparency = 1
tpActionRow.LayoutOrder = 2

local tpOnceBtn = Instance.new("TextButton", tpActionRow)
tpOnceBtn.Size = UDim2.new(0.485, 0, 1, 0)
tpOnceBtn.Position = UDim2.new(0, 0, 0, 0)
tpOnceBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 65)
tpOnceBtn.Text = "⚡ TP 1 LẦN"
tpOnceBtn.TextColor3 = Theme.Brand
tpOnceBtn.Font = Enum.Font.GothamBlack
tpOnceBtn.TextSize = 11
tpOnceBtn.AutoButtonColor = false
tpOnceBtn.ZIndex = 10
Instance.new("UICorner", tpOnceBtn).CornerRadius = UDim.new(0, 6)
local tpOnceStroke = Instance.new("UIStroke", tpOnceBtn)
tpOnceStroke.Color = Theme.Brand
tpOnceStroke.Thickness = 1.2
tpOnceStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
table.insert(RGBElements, {Type = "Button", Stroke = tpOnceStroke, DefaultColor = Theme.Brand})

local autoTpBtn = Instance.new("TextButton", tpActionRow)
autoTpBtn.Size = UDim2.new(0.485, 0, 1, 0)
autoTpBtn.Position = UDim2.new(0.515, 0, 0, 0)
autoTpBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 38)
autoTpBtn.Text = "🔁 AUTO TP [TẮT]"
autoTpBtn.TextColor3 = Theme.AccentOff
autoTpBtn.Font = Enum.Font.GothamBlack
autoTpBtn.TextSize = 11
autoTpBtn.AutoButtonColor = false
autoTpBtn.ZIndex = 10
Instance.new("UICorner", autoTpBtn).CornerRadius = UDim.new(0, 6)
local autoTpStroke = Instance.new("UIStroke", autoTpBtn)
autoTpStroke.Color = Theme.AccentOff
autoTpStroke.Thickness = 1.2
autoTpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
table.insert(RGBElements, {Type = "Toggle", Stroke = autoTpStroke, State = function() return autoTpPlayerEnabled end})

local function updateAutoTpBtnUI()
    autoTpBtn.Text = autoTpPlayerEnabled and "🔁 AUTO TP [BẬT]" or "🔁 AUTO TP [TẮT]"
    autoTpBtn.TextColor3 = autoTpPlayerEnabled and Theme.AccentOn or Theme.AccentOff
    autoTpBtn.BackgroundColor3 = autoTpPlayerEnabled and Color3.fromRGB(30, 55, 40) or Color3.fromRGB(50, 30, 38)
    if not State.RGB then
        autoTpStroke.Color = autoTpPlayerEnabled and Theme.AccentOn or Theme.AccentOff
    end
end

local function updateSpectateBtnUI()
    spectateBtn.Text = spectatePlayerEnabled and "👁️ XEM [BẬT]" or "👁️ XEM [TẮT]"
    spectateBtn.TextColor3 = spectatePlayerEnabled and Theme.AccentOn or Theme.AccentOff
    spectateBtn.BackgroundColor3 = spectatePlayerEnabled and Color3.fromRGB(30, 55, 40) or Color3.fromRGB(55, 35, 45)
    spectateStroke.Color = spectatePlayerEnabled and Theme.AccentOn or Theme.AccentOff
end

tpOnceBtn.MouseButton1Click:Connect(function()
    clickAnimate(tpOnceBtn)
    if not targetTpPlayer then
        MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người chơi ở danh sách dưới!", Theme.AccentOff)
        return
    end
    if teleportToSelectedPlayer(true) then
        local modeName = (TpPositions[State.TpPositionIdx] or TpPositions[1]).Name
        MakeToast("Dịch Chuyển", "Đến " .. targetTpPlayer.DisplayName .. " (" .. modeName .. ")", Theme.Brand)
    else
        MakeToast("Lỗi", "Người chơi chưa tải nhân vật hoặc đã chết!", Theme.AccentOff)
    end
end)

autoTpBtn.MouseButton1Click:Connect(function()
    clickAnimate(autoTpBtn)
    if not targetTpPlayer then
        MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người chơi ở danh sách dưới!", Theme.AccentOff)
        return
    end
    autoTpPlayerEnabled = not autoTpPlayerEnabled
    updateAutoTpBtnUI()
    if autoTpPlayerEnabled then
        MakeToast("Đã Bật Auto TP", "Đang bám theo " .. targetTpPlayer.DisplayName, Theme.AccentOn)
    else
        restoreNormalPosture()
        MakeToast("Đã Tắt Auto TP", "Đã dừng bám theo mục tiêu", Theme.AccentOff)
    end
end)

spectateBtn.MouseButton1Click:Connect(function()
    clickAnimate(spectateBtn)
    if not targetTpPlayer then
        MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người chơi ở danh sách dưới!", Theme.AccentOff)
        return
    end
    spectatePlayerEnabled = not spectatePlayerEnabled
    updateSpectateBtnUI()
    if spectatePlayerEnabled then
        MakeToast("Đã Bật Spectate", "Đang xem góc nhìn của " .. targetTpPlayer.DisplayName, Theme.AccentOn)
    else
        resetCameraSubject()
        MakeToast("Đã Tắt Spectate", "Đã trả góc nhìn về nhân vật của bạn", Theme.AccentOff)
    end
end)

local playerListContainer = Instance.new("Frame", page7)
playerListContainer.Size = UDim2.new(0.94, 0, 1, -132)
playerListContainer.BackgroundColor3 = Color3.fromRGB(24, 25, 34)
playerListContainer.LayoutOrder = 3
playerListContainer.ZIndex = 10
Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 8)
local listContainerStroke = Instance.new("UIStroke", playerListContainer)
listContainerStroke.Color = Theme.Stroke
listContainerStroke.Thickness = 1.2
table.insert(RGBElements, {Type = "Info", Stroke = listContainerStroke})

local playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
playerListScroll.Size = UDim2.new(1, -6, 1, -8)
playerListScroll.Position = UDim2.new(0, 3, 0, 4)
playerListScroll.BackgroundTransparency = 1
playerListScroll.BorderSizePixel = 0
playerListScroll.ScrollBarThickness = 5
playerListScroll.ScrollBarImageColor3 = Theme.Brand
playerListScroll.ScrollingDirection = Enum.ScrollingDirection.Y
playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerListScroll.ZIndex = 10

local playerScrollLayout = Instance.new("UIListLayout", playerListScroll)
playerScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerScrollLayout.Padding = UDim.new(0, 4)

local playerScrollPad = Instance.new("UIPadding", playerListScroll)
playerScrollPad.PaddingTop = UDim.new(0, 2)
playerScrollPad.PaddingBottom = UDim.new(0, 6)
playerScrollPad.PaddingRight = UDim.new(0, 6)

local function updatePlayerList()
    local cleanRGB = {}; for _, obj in ipairs(RGBElements) do if obj.Stroke and obj.Stroke.Parent then table.insert(cleanRGB, obj) end end; RGBElements = cleanRGB
    for _, child in pairs(playerListScroll:GetChildren()) do
        if child.Name == "PaddingFrame" then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local isSelected = (targetTpPlayer == p)
            local pFrame = Instance.new("Frame", playerListScroll)
            pFrame.Name = "PaddingFrame"
            pFrame.Size = UDim2.new(1, -2, 0, 34)
            pFrame.BackgroundTransparency = 1
            pFrame.ZIndex = 10
            
            local btn = Instance.new("TextButton", pFrame)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundColor3 = isSelected and Color3.fromRGB(30, 60, 42) or Theme.ItemBg
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 10
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = isSelected and Theme.AccentOn or Theme.Stroke
            stroke.Thickness = 1.2
            table.insert(RGBElements, {Type = "Info", Stroke = stroke})
            
            local nLabel = Instance.new("TextLabel", btn)
            nLabel.Size = UDim2.new(0.76, 0, 0.52, 0)
            nLabel.Position = UDim2.new(0.04, 0, 0.04, 0)
            nLabel.BackgroundTransparency = 1
            nLabel.Text = (isSelected and "✅ " or "👤 ") .. p.DisplayName
            nLabel.TextColor3 = isSelected and Theme.AccentOn or Theme.TextTitle
            nLabel.Font = Enum.Font.GothamBold
            nLabel.TextSize = 11.5
            nLabel.TextXAlignment = Enum.TextXAlignment.Left
            nLabel.ZIndex = 10
            
            local subLabel = Instance.new("TextLabel", btn)
            subLabel.Size = UDim2.new(0.76, 0, 0.44, 0)
            subLabel.Position = UDim2.new(0.04, 0, 0.52, 0)
            subLabel.BackgroundTransparency = 1
            subLabel.Text = "@" .. p.Name
            subLabel.TextColor3 = Color3.fromRGB(100, 255, 130)
            subLabel.Font = Enum.Font.GothamSemibold
            subLabel.TextSize = 9.5
            subLabel.TextXAlignment = Enum.TextXAlignment.Left
            subLabel.ZIndex = 10
            
            local targetAvatar = Instance.new("ImageLabel", btn)
            targetAvatar.Size = UDim2.new(0, 24, 0, 24)
            targetAvatar.Position = UDim2.new(1, -30, 0.5, -12)
            targetAvatar.BackgroundTransparency = 1
            targetAvatar.ZIndex = 10
            Instance.new("UICorner", targetAvatar).CornerRadius = UDim.new(1, 0)
            
            local targetStroke = Instance.new("UIStroke", targetAvatar)
            targetStroke.Color = isSelected and Theme.AccentOn or Theme.Stroke
            targetStroke.Thickness = 1.2
            targetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(RGBElements, {Type = "Info", Stroke = targetStroke})
            
            task.spawn(function()
                pcall(function()
                    targetAvatar.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                end)
            end)
            
            btn.MouseButton1Click:Connect(function()
                clickAnimate(btn)
                targetTpPlayer = p
                updateTargetLabel()
                updatePlayerList()
                MakeToast("Đã chọn mục tiêu", p.DisplayName .. " (@" .. p.Name .. ")", Theme.AccentOn)
            end)
        end
    end
end
updatePlayerList()

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == targetTpPlayer then
        targetTpPlayer = nil
        if autoTpPlayerEnabled then
            autoTpPlayerEnabled = false
            restoreNormalPosture()
        end
        if spectatePlayerEnabled then
            spectatePlayerEnabled = false
            resetCameraSubject()
            updateSpectateBtnUI()
        end
        updateTargetLabel()
        updateAutoTpBtnUI()
        MakeToast("Mục tiêu đã thoát", leavingPlayer.DisplayName .. " đã rời khỏi server!", Theme.AccentOff)
    end
    updatePlayerList()
end)

-- ==========================================
-- [TAB 8: AUTO SKILL]
-- ==========================================
createDivider(page8, "KỸ NĂNG PHÍM CHỮ")
createToggle(page8, "Tự động kích hoạt Phím [Z]", "AutoSkillZ")
createToggle(page8, "Tự động kích hoạt Phím [X]", "AutoSkillX")
createToggle(page8, "Tự động kích hoạt Phím [C]", "AutoSkillC")
createToggle(page8, "Tự động kích hoạt Phím [V]", "AutoSkillV")
createToggle(page8, "Tự động kích hoạt Phím [E]", "AutoSkillE")
createToggle(page8, "Tự động kích hoạt Phím [F]", "AutoSkillF")

createDivider(page8, "KỸ NĂNG PHÍM SỐ")
createToggle(page8, "Tự động kích hoạt Phím [1]", "AutoSkill1")
createToggle(page8, "Tự động kích hoạt Phím [2]", "AutoSkill2")
createToggle(page8, "Tự động kích hoạt Phím [3]", "AutoSkill3")
createToggle(page8, "Tự động kích hoạt Phím [4]", "AutoSkill4")
createToggle(page8, "Tự động kích hoạt Phím [5]", "AutoSkill5")
createToggle(page8, "Tự động kích hoạt Phím [6]", "AutoSkill6")

task.spawn(function()
    while task.wait(0.5) do 
        local keysToPress = {}
        if State.AutoSkillZ then table.insert(keysToPress, Enum.KeyCode.Z) end
        if State.AutoSkillX then table.insert(keysToPress, Enum.KeyCode.X) end
        if State.AutoSkillC then table.insert(keysToPress, Enum.KeyCode.C) end
        if State.AutoSkillV then table.insert(keysToPress, Enum.KeyCode.V) end
        if State.AutoSkillE then table.insert(keysToPress, Enum.KeyCode.E) end
        if State.AutoSkillF then table.insert(keysToPress, Enum.KeyCode.F) end
        
        if State.AutoSkill1 then table.insert(keysToPress, Enum.KeyCode.One) end
        if State.AutoSkill2 then table.insert(keysToPress, Enum.KeyCode.Two) end
        if State.AutoSkill3 then table.insert(keysToPress, Enum.KeyCode.Three) end
        if State.AutoSkill4 then table.insert(keysToPress, Enum.KeyCode.Four) end
        if State.AutoSkill5 then table.insert(keysToPress, Enum.KeyCode.Five) end
        if State.AutoSkill6 then table.insert(keysToPress, Enum.KeyCode.Six) end
        
        if #keysToPress > 0 then
            for _, keyEnum in ipairs(keysToPress) do
                task.spawn(function()
                    pcall(function()
                        Vim:SendKeyEvent(true, keyEnum, false, game)
                        task.wait(0.02) 
                        Vim:SendKeyEvent(false, keyEnum, false, game)
                    end)
                end)
                task.wait(0.05) 
            end
        end
    end
end)

            

-- ==========================================
-- [TAB 9: CẤU HÌNH (ĐÃ FIX LỖI 200 BIẾN LOCAL LÀM MẤT MENU)]
-- ==========================================
;(function()
    local Stats = game:GetService("Stats")

    if State.DisableParticles == nil then State.DisableParticles = false end
    if State.DisablePostEffects == nil then State.DisablePostEffects = false end
    if State.HidePetsAccessories == nil then State.HidePetsAccessories = false end
    if State.AutoClearRAM == nil then State.AutoClearRAM = false end

    local Cache = {
        Particles = {},
        PostEffects = {},
        Shadows = {},
        Players = {},
        Pets = {},
        Toggles = {},
        PartCount = 0,
        Tickets = {LowGfx = 0, Particle = 0, Pet = 0, Player = 0, Shadow = 0}
    }

    local function createTab9Toggle(parent, text, varName, callback)
        local frameItem = createToggle(parent, text, varName, callback)
        local btn = frameItem:FindFirstChildOfClass("TextButton")
        Cache.Toggles[varName] = function(targetState)
            if State[varName] ~= targetState then
                State[varName] = targetState
                if btn then
                    local stroke = btn:FindFirstChildOfClass("UIStroke")
                    for _, lbl in ipairs(btn:GetChildren()) do
                        if lbl:IsA("TextLabel") and (lbl.Text == "ON" or lbl.Text == "OFF") then
                            lbl.Text = targetState and "ON" or "OFF"
                            TweenService:Create(lbl, TweenInfo.new(0.2), {TextColor3 = targetState and Theme.AccentOn or Theme.AccentOff}):Play()
                        end
                    end
                    if stroke and not State.RGB then
                        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = targetState and Theme.AccentOn or Theme.Stroke}):Play()
                    end
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetState and Color3.fromRGB(35, 45, 40) or Theme.ItemBg}):Play()
                end
                if callback then task.spawn(callback, targetState) end
            end
        end
        return frameItem
    end

    -- 1. BẢNG ĐO THÔNG SỐ THỜI GIAN THỰC (LIVE MONITOR)
    local liveMonitorCard = Instance.new("Frame", page9)
    liveMonitorCard.Size = UDim2.new(0.92, 0, 0, 52)
    liveMonitorCard.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
    liveMonitorCard.ZIndex = 10
    Instance.new("UICorner", liveMonitorCard).CornerRadius = UDim.new(0, 8)
    local monitorStroke = Instance.new("UIStroke", liveMonitorCard)
    monitorStroke.Color = Theme.Brand
    monitorStroke.Thickness = 1.3
    table.insert(RGBElements, {Type = "Button", Stroke = monitorStroke, DefaultColor = Theme.Brand})

    local monitorTitle = Instance.new("TextLabel", liveMonitorCard)
    monitorTitle.Size = UDim2.new(1, -16, 0, 16)
    monitorTitle.Position = UDim2.new(0, 8, 0, 4)
    monitorTitle.BackgroundTransparency = 1
    monitorTitle.Text = "📊 THÔNG SỐ HIỆU NĂNG THỜI GIAN THỰC (LIVE MONITOR)"
    monitorTitle.TextColor3 = Theme.Brand
    monitorTitle.Font = Enum.Font.GothamBlack
    monitorTitle.TextSize = 9.5
    monitorTitle.TextXAlignment = Enum.TextXAlignment.Left
    monitorTitle.ZIndex = 10

    local monitorStatsLabel = Instance.new("TextLabel", liveMonitorCard)
    monitorStatsLabel.Size = UDim2.new(1, -16, 0, 28)
    monitorStatsLabel.Position = UDim2.new(0, 8, 0, 21)
    monitorStatsLabel.BackgroundTransparency = 1
    monitorStatsLabel.RichText = true
    monitorStatsLabel.Text = "Đang đo thông số..."
    monitorStatsLabel.TextColor3 = Theme.TextTitle
    monitorStatsLabel.Font = Enum.Font.GothamSemibold
    monitorStatsLabel.TextSize = 10.5
    monitorStatsLabel.TextXAlignment = Enum.TextXAlignment.Left
    monitorStatsLabel.TextYAlignment = Enum.TextYAlignment.Top
    monitorStatsLabel.ZIndex = 10

    task.spawn(function()
        for i, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then Cache.PartCount = Cache.PartCount + 1 end
            if i % 500 == 0 then task.wait() end
        end
    end)
    workspace.DescendantAdded:Connect(function(v)
        if v:IsA("BasePart") then Cache.PartCount = Cache.PartCount + 1 end
    end)
    workspace.DescendantRemoving:Connect(function(v)
        if v:IsA("BasePart") then Cache.PartCount = math.max(0, Cache.PartCount - 1) end
    end)

    task.spawn(function()
        while task.wait(0.8) do
            if page9.Visible then
                local pingStr = "0 ms"
                local ramMB = 0
                pcall(function()
                    if Stats and Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem") then
                        local rawPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                        local numPing = rawPing and rawPing:match("%d+")
                        pingStr = (numPing or tostring(math.floor(player:GetNetworkPing() * 1000))) .. " ms"
                    else
                        pingStr = tostring(math.floor(player:GetNetworkPing() * 1000)) .. " ms"
                    end
                end)
                pcall(function() ramMB = math.floor(Stats:GetTotalMemoryUsageMb()) end)
                if ramMB == 0 then
                    pcall(function() ramMB = math.floor(collectgarbage("count") / 1024) end)
                end
                local fpsColor = fps >= 45 and "#2ECC71" or (fps >= 25 and "#F1C40F" or "#FF4757")
                monitorStatsLabel.Text = string.format(
                    "⚡ FPS: <font color='%s'>%d</font>   |   🌐 Ping: <font color='#00E5FF'>%s</font>\n🧠 RAM: <font color='#FF9F43'>%d MB</font>   |   🧱 Vật thể (Parts): <font color='#A29BFE'>%d</font>",
                    fpsColor, fps, pingStr, ramMB, Cache.PartCount
                )
            end
        end
    end)

    -- 2. CƠ CHẾ XỬ LÝ PHÂN LUỒNG (ANTI-FREEZE) & TỰ ĐỘNG BẮT HIỆU ỨNG MỚI
    local function isPlayerCharDescendant(obj)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and obj:IsDescendantOf(p.Character) then
                return true, p
            end
        end
        return false, nil
    end

    local function isPetOrAccessory(obj)
        if obj:FindFirstAncestorWhichIsA("Tool") then return false end
        if obj:IsA("Accessory") or obj:IsA("Hat") or obj:FindFirstAncestorWhichIsA("Accessory") or obj:FindFirstAncestorWhichIsA("Hat") then
            return true
        end
        local isChar, _ = isPlayerCharDescendant(obj)
        if isChar then return false end

        local parent = obj.Parent
        while parent and parent ~= workspace and parent ~= game do
            local pName = string.lower(parent.Name)
            if pName ~= string.lower(player.Name .. "_clone") then
                if pName:find("pet") or pName:find("summon") or pName:find("minion") or pName:find("companion") or pName:find("stand") or pName:find("aura") or pName:find("wing") then
                    return true
                end
            end
            parent = parent.Parent
        end
        return false
    end

    local function applyObjectOptimizations(obj)
        if not obj or not obj.Parent then return end
        if obj.Name == "VipAirWalk" or obj.Name == "VipSpectateProxy" or string.find(obj.Name, "^ESPAnchor_") then return end

        if State.LowGfx then
            if obj:IsA("BasePart") and obj.Material ~= Enum.Material.SmoothPlastic then
                if not OriginalGFX[obj] then OriginalGFX[obj] = {} end
                if OriginalGFX[obj].Material == nil then OriginalGFX[obj].Material = obj.Material end
                obj.Material = Enum.Material.SmoothPlastic
            elseif (obj:IsA("Decal") or obj:IsA("Texture")) and obj.Transparency < 1 then
                local isChar, _ = isPlayerCharDescendant(obj)
                if not isChar then
                    if not OriginalGFX[obj] then OriginalGFX[obj] = {} end
                    if OriginalGFX[obj].Transparency == nil then OriginalGFX[obj].Transparency = obj.Transparency end
                    obj.Transparency = 1
                end
            end
        end

        if State.LowGfx or State.DisableParticles then
            if obj:IsA("Explosion") then
                obj.Visible = false
            elseif (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles")) and obj.Enabled then
                if Cache.Particles[obj] == nil then Cache.Particles[obj] = obj.Enabled end
                obj.Enabled = false
            end
        end

        if State.NoShadows and obj:IsA("BasePart") and obj.CastShadow then
            if Cache.Shadows[obj] == nil then Cache.Shadows[obj] = obj.CastShadow end
            obj.CastShadow = false
        end

        if State.HidePlayers and (obj:IsA("BasePart") or obj:IsA("Decal")) then
            local isChar, ownerPlayer = isPlayerCharDescendant(obj)
            if isChar and ownerPlayer ~= player and obj.Transparency < 1 then
                if Cache.Players[obj] == nil then Cache.Players[obj] = obj.Transparency end
                obj.Transparency = 1
            end
        end

        if State.HidePetsAccessories then
            if (obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("MeshPart")) and isPetOrAccessory(obj) then
                if obj.Transparency < 1 then
                    if Cache.Pets[obj] == nil then Cache.Pets[obj] = obj.Transparency end
                    obj.Transparency = 1
                end
            elseif (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")) and isPetOrAccessory(obj) then
                if obj.Enabled then
                    if Cache.Pets[obj] == nil then Cache.Pets[obj] = obj.Enabled end
                    obj.Enabled = false
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        if State.LowGfx or State.DisableParticles or State.NoShadows or State.HidePlayers or State.HidePetsAccessories then
            task.defer(function()
                pcall(applyObjectOptimizations, obj)
            end)
        end
    end)

    local function restoreParticlesIfBothOff(ticketCheckFn)
        if State.LowGfx or State.DisableParticles then return end
        task.spawn(function()
            local count = 0
            for obj, enabledVal in pairs(Cache.Particles) do
                if ticketCheckFn and not ticketCheckFn() then return end
                pcall(function()
                    if obj and obj.Parent then obj.Enabled = enabledVal end
                end)
                count = count + 1
                if count % 350 == 0 then task.wait() end
            end
            if not State.LowGfx and not State.DisableParticles then
                Cache.Particles = {}
            end
        end)
    end

    local function cleanDebrisAndRAM(silent)
        local count = 0
        task.spawn(function()
            local descendants = workspace:GetDescendants()
            for i, obj in ipairs(descendants) do
                if i % 400 == 0 then task.wait() end
                pcall(function()
                    if obj and obj.Parent and obj.Name ~= "VipAirWalk" and obj.Name ~= "VipSpectateProxy" and not string.find(obj.Name, "^ESPAnchor_") then
                        if (not player.Character or not obj:IsDescendantOf(player.Character)) and (not obj.Parent:FindFirstChild("Humanoid")) then
                            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or (obj:IsA("Decal") and obj.Name == "Blood") then
                                obj:Destroy()
                                count = count + 1
                            elseif obj:IsA("BasePart") and not obj.Anchored and obj.CanCollide == false and obj.Size.Magnitude < 5 and not isPetOrAccessory(obj) then
                                obj:Destroy()
                                count = count + 1
                            end
                        end
                    end
                end)
            end
            pcall(function() collectgarbage("collect") end)
            if not silent then
                MakeToast("Dọn Rác & RAM", "Đã dọn " .. count .. " rác & giải phóng bộ nhớ đệm!", Theme.Brand)
            end
        end)
    end

    -- 3. CÁC NÚT ĐIỀU KHIỂN TRONG TAB CẤU HÌNH
    createDivider(page9, "TỐI ƯU HIỆU SUẤT TỐI ĐA")

    createButton(page9, "🥔 SIÊU KHOAI TÂY (1-Click Ultra Boost)", Color3.fromRGB(255, 195, 18), function()
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        local boostKeys = {"LowGfx", "DisableParticles", "DisablePostEffects", "NoFog", "NoShadows", "OptimizeTerrain", "HidePetsAccessories"}
        for _, key in ipairs(boostKeys) do
            if Cache.Toggles[key] then Cache.Toggles[key](true) end
        end
        if State.AutoSave then saveConfig() end
        cleanDebrisAndRAM(true)
        MakeToast("🥔 Siêu Khoai Tây", "Đã bật toàn bộ cấu hình giảm lag mạnh nhất!", Theme.AccentOn)
    end)

    createSlider(page9, "Giới hạn FPS (Chống nóng máy)", 10, 120, "FpsCapValue", function(val)
        pcall(function() setfpscap(val) end)
    end)

    createTab9Toggle(page9, "Tắt Render 3D (Màn trắng + Giảm CPU)", "Disable3D", function(v)
        pcall(function() RunService:Set3dRenderingEnabled(not v) end)
        if v then
            screenOverlay.BackgroundColor3 = Color3.new(1, 1, 1) 
            screenOverlay.Visible = true
        else
            if not State.AfkModeScreen then screenOverlay.Visible = false end
        end
    end)

    createTab9Toggle(page9, "Chế độ AFK Ngủ (Màn đen + 10 FPS)", "AfkModeScreen", function(v)
        if v then
            pcall(function() setfpscap(10) end)
            screenOverlay.BackgroundColor3 = Color3.new(0, 0, 0) 
            screenOverlay.Visible = true
            pcall(function() RunService:Set3dRenderingEnabled(false) end)
        else
            pcall(function() setfpscap(State.FpsCapValue) end)
            if not State.Disable3D then 
                screenOverlay.Visible = false 
                pcall(function() RunService:Set3dRenderingEnabled(true) end)
            else
                screenOverlay.BackgroundColor3 = Color3.new(1, 1, 1) 
            end
        end
    end)

    createDivider(page9, "CÁC CHỨC NĂNG HỦY DIỆT ĐỒ HỌA")

    createTab9Toggle(page9, "📉 Giảm Lag (Xóa toàn bộ hiệu ứng)", "LowGfx", function(v)
        Cache.Tickets.LowGfx = Cache.Tickets.LowGfx + 1
        local myTicket = Cache.Tickets.LowGfx
        if v then
            Lighting.GlobalShadows = false
            task.spawn(function()
                local list = workspace:GetDescendants()
                for i, obj in ipairs(list) do
                    if myTicket ~= Cache.Tickets.LowGfx then return end
                    pcall(applyObjectOptimizations, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            Lighting.GlobalShadows = true
            task.spawn(function()
                local count = 0
                for obj, props in pairs(OriginalGFX) do
                    if myTicket ~= Cache.Tickets.LowGfx then return end
                    pcall(function()
                        if obj and obj.Parent then
                            for k, val in pairs(props) do obj[k] = val end
                        end
                    end)
                    count = count + 1
                    if count % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.LowGfx then OriginalGFX = {} end
            end)
            restoreParticlesIfBothOff(function() return myTicket == Cache.Tickets.LowGfx end)
        end
    end)

    createTab9Toggle(page9, "💥 Tắt hiệu ứng chiêu thức & Hạt", "DisableParticles", function(v)
        Cache.Tickets.Particle = Cache.Tickets.Particle + 1
        local myTicket = Cache.Tickets.Particle
        if v then
            task.spawn(function()
                local list = workspace:GetDescendants()
                for i, obj in ipairs(list) do
                    if myTicket ~= Cache.Tickets.Particle then return end
                    pcall(applyObjectOptimizations, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            restoreParticlesIfBothOff(function() return myTicket == Cache.Tickets.Particle end)
        end
    end)

    local function handlePostEffect(eff, disable)
        if eff:IsA("PostEffect") or eff:IsA("BloomEffect") or eff:IsA("BlurEffect") or eff:IsA("ColorCorrectionEffect") or eff:IsA("DepthOfFieldEffect") or eff:IsA("SunRaysEffect") then
            if disable then
                if Cache.PostEffects[eff] == nil then Cache.PostEffects[eff] = eff.Enabled end
                eff.Enabled = false
            else
                if Cache.PostEffects[eff] ~= nil then
                    eff.Enabled = Cache.PostEffects[eff]
                end
            end
        end
    end

    Lighting.DescendantAdded:Connect(function(eff)
        if State.DisablePostEffects then task.defer(function() pcall(handlePostEffect, eff, true) end) end
    end)

    createTab9Toggle(page9, "✨ Xóa hiệu ứng hậu kỳ (Post-Effects)", "DisablePostEffects", function(v)
        pcall(function()
            for _, eff in ipairs(Lighting:GetDescendants()) do handlePostEffect(eff, v) end
            if workspace.CurrentCamera then
                for _, eff in ipairs(workspace.CurrentCamera:GetDescendants()) do handlePostEffect(eff, v) end
            end
            if not v then Cache.PostEffects = {} end
        end)
    end)

    createTab9Toggle(page9, "☀️ Xóa sương mù (Ép tắt 100%)", "NoFog", function(v)
        if not v then
            Lighting.FogEnd = 100000 
            Lighting.FogStart = 0
        end
    end)

    task.spawn(function()
        while task.wait(0.25) do
            if State.NoFog then
                Lighting.FogEnd = 100000
                Lighting.FogStart = 0
                local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
                if atmo then
                    atmo.Density = 0
                    atmo.Offset = 0
                end
            end
        end
    end)

    createTab9Toggle(page9, "🐾 Ẩn Pet, Quái phụ & Phụ kiện", "HidePetsAccessories", function(v)
        Cache.Tickets.Pet = Cache.Tickets.Pet + 1
        local myTicket = Cache.Tickets.Pet
        if v then
            task.spawn(function()
                local list = workspace:GetDescendants()
                for i, obj in ipairs(list) do
                    if myTicket ~= Cache.Tickets.Pet then return end
                    pcall(applyObjectOptimizations, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            task.spawn(function()
                local count = 0
                for obj, origVal in pairs(Cache.Pets) do
                    if myTicket ~= Cache.Tickets.Pet then return end
                    pcall(function()
                        if obj and obj.Parent then
                            if typeof(origVal) == "boolean" then obj.Enabled = origVal else obj.Transparency = origVal end
                        end
                    end)
                    count = count + 1
                    if count % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.Pet then Cache.Pets = {} end
            end)
        end
    end)

    createTab9Toggle(page9, "👻 Ẩn tất cả người chơi khác", "HidePlayers", function(v)
        Cache.Tickets.Player = Cache.Tickets.Player + 1
        local myTicket = Cache.Tickets.Player
        if v then
            task.spawn(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if myTicket ~= Cache.Tickets.Player then return end
                    if p ~= player and p.Character then
                        for _, obj in ipairs(p.Character:GetDescendants()) do
                            pcall(applyObjectOptimizations, obj)
                        end
                    end
                    task.wait()
                end
            end)
        else
            task.spawn(function()
                local count = 0
                for obj, trans in pairs(Cache.Players) do
                    if myTicket ~= Cache.Tickets.Player then return end
                    pcall(function() if obj and obj.Parent then obj.Transparency = trans end end)
                    count = count + 1
                    if count % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.Player then Cache.Players = {} end
            end)
        end
    end)

    createTab9Toggle(page9, "🌊 Tối ưu Địa hình & Nước", "OptimizeTerrain", function(v)
        pcall(function()
            if v then
                workspace.Terrain.WaterWaveSize = 0
                workspace.Terrain.WaterWaveSpeed = 0
                workspace.Terrain.WaterReflectance = 0
                workspace.Terrain.WaterTransparency = 1
            else
                workspace.Terrain.WaterWaveSize = 0.15
                workspace.Terrain.WaterWaveSpeed = 10
                workspace.Terrain.WaterReflectance = 1
                workspace.Terrain.WaterTransparency = 0.3
            end
        end)
    end)

    createTab9Toggle(page9, "🌑 Tắt đổ bóng vật thể (No Shadows)", "NoShadows", function(v)
        Cache.Tickets.Shadow = Cache.Tickets.Shadow + 1
        local myTicket = Cache.Tickets.Shadow
        if v then
            task.spawn(function()
                local list = workspace:GetDescendants()
                for i, obj in ipairs(list) do
                    if myTicket ~= Cache.Tickets.Shadow then return end
                    pcall(applyObjectOptimizations, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            task.spawn(function()
                local count = 0
                for obj, origShadow in pairs(Cache.Shadows) do
                    if myTicket ~= Cache.Tickets.Shadow then return end
                    pcall(function() if obj and obj.Parent then obj.CastShadow = origShadow end end)
                    count = count + 1
                    if count % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.Shadow then Cache.Shadows = {} end
            end)
        end
    end)

    createTab9Toggle(page9, "🔄 Tự động dọn rác & Giải phóng RAM (30s)", "AutoClearRAM")
    task.spawn(function()
        while task.wait(30) do
            if State.AutoClearRAM then
                cleanDebrisAndRAM(true)
            end
        end
    end)

    createButton(page9, "🧹 Dọn rác bản đồ & Giải phóng RAM ngay", Theme.AccentOff, function()
        cleanDebrisAndRAM(false)
    end)
end)()



-- ==========================================
-- [HỆ THỐNG AUTO COLLECT & PROXIMITY]
-- ==========================================
task.spawn(function()
    for _, obj in ipairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then table.insert(cachedPrompts, obj) end end
end)
workspace.DescendantAdded:Connect(function(obj) if obj:IsA("ProximityPrompt") then table.insert(cachedPrompts, obj) end end)

local originalPrompts = {}
task.spawn(function()
    while task.wait(1) do
        if State.Instant then
            for i = #cachedPrompts, 1, -1 do
                local prompt = cachedPrompts[i]
                if prompt.Parent then
                    if not originalPrompts[prompt] then originalPrompts[prompt] = { HoldDuration = prompt.HoldDuration, MaxActivationDistance = prompt.MaxActivationDistance } end
                    prompt.HoldDuration = 0; prompt.MaxActivationDistance = 25 
                else table.remove(cachedPrompts, i) end
            end
        else
            if next(originalPrompts) then
                for prompt, data in pairs(originalPrompts) do if prompt and prompt.Parent then prompt.HoldDuration = data.HoldDuration; prompt.MaxActivationDistance = data.MaxActivationDistance end end
                originalPrompts = {}
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if State.AutoCollect and player.Character then
                local root = getUniversalRoot(player.Character)
                if root then
                    local rootPos = root.Position
                    for _, prompt in ipairs(cachedPrompts) do
                        if prompt.Parent and prompt.Parent:IsA("BasePart") and prompt.Enabled and (prompt.Parent.Position - rootPos).Magnitude <= 50 then if fireproximityprompt then fireproximityprompt(prompt) end end
                    end
                    local overlapParams = OverlapParams.new(); overlapParams.FilterDescendantsInstances = {player.Character}; overlapParams.FilterType = Enum.RaycastFilterType.Exclude
                    local partsNearby = workspace:GetPartBoundsInRadius(rootPos, 50, overlapParams)
                    for _, part in ipairs(partsNearby) do
                        if part.Name == "Handle" and part.Parent and part.Parent:IsA("Tool") then
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
-- [ESP GỌN ĐẸP (KHÔNG HỘP ĐỎ) + XUYÊN STREAMING]
-- ==========================================
local function clearSingleESP(p)
    if ActiveESPs[p] then
        if ActiveESPs[p].Billboard then ActiveESPs[p].Billboard:Destroy() end
        if ActiveESPs[p].Highlight then ActiveESPs[p].Highlight:Destroy() end
        if ActiveESPs[p].Anchor then ActiveESPs[p].Anchor:Destroy() end
        ActiveESPs[p] = nil
    end
end

local function updateESP_Hitbox()
    if State.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = getUniversalRoot(p.Character)
                if hrp then
                    if not originalHitboxSizes[p] then originalHitboxSizes[p] = hrp.Size end
                    hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                    hrp.Transparency = 0.5
                    hrp.CanCollide = false
                    hrp.Massless = true
                end
            end
        end
    else
        if next(originalHitboxSizes) then
            for p, size in pairs(originalHitboxSizes) do 
                if p and p.Character then 
                    local hrp = getUniversalRoot(p.Character)
                    if hrp then 
                        hrp.Size = size
                        hrp.Transparency = 1 
                        hrp.Massless = false 
                    end 
                end 
            end
            originalHitboxSizes = {}
        end
    end

    if not State.ESP then
        for p, _ in pairs(ActiveESPs) do
            clearSingleESP(p)
        end
        return
    end

    local myRoot = getUniversalRoot(player.Character)
    local myPos = myRoot and myRoot.Position or (workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            pcall(function()
                local tChar = p.Character
                if not tChar then
                    clearSingleESP(p)
                    return
                end

                local espPart = getUniversalRoot(tChar)
                local targetCF = getCharacterCFrame(tChar)
                if not targetCF then
                    clearSingleESP(p)
                    return
                end
                local targetPos = targetCF.Position

                if not ActiveESPs[p] then ActiveESPs[p] = {} end
                local data = ActiveESPs[p]

                if not espPart then
                    if not data.Anchor or not data.Anchor.Parent then
                        local anchor = Instance.new("Part")
                        anchor.Name = "ESPAnchor_" .. p.Name
                        anchor.Size = Vector3.new(1, 1, 1)
                        anchor.Transparency = 1
                        anchor.Anchored = true
                        anchor.CanCollide = false
                        anchor.CanQuery = false
                        anchor.CanTouch = false
                        anchor.Parent = workspace
                        data.Anchor = anchor
                    end
                    data.Anchor.Position = targetPos
                    espPart = data.Anchor
                elseif data.Anchor then
                    data.Anchor:Destroy()
                    data.Anchor = nil
                end

                if not data.Billboard or not data.Billboard.Parent then
                    local bgui = Instance.new("BillboardGui")
                    bgui.Name = "MobileESP_" .. p.Name
                    bgui.Size = UDim2.new(0, 200, 0, 50)
                    bgui.StudsOffset = Vector3.new(0, 3.5, 0)
                    bgui.AlwaysOnTop = true
                    bgui.MaxDistance = math.huge
                    bgui.LightInfluence = 0
                    bgui.Parent = guiParent

                    local tLabel = Instance.new("TextLabel", bgui)
                    tLabel.Name = "NameLabel"
                    tLabel.Size = UDim2.new(1, 0, 1, 0)
                    tLabel.BackgroundTransparency = 1
                    tLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
                    tLabel.TextStrokeTransparency = 0.15
                    tLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    tLabel.Font = Enum.Font.GothamBold
                    tLabel.TextSize = 12
                    tLabel.RichText = true
                    data.Billboard = bgui
                end
                data.Billboard.Adornee = espPart

                if not data.Highlight or not data.Highlight.Parent then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESPHighlight_" .. p.Name
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillColor = Color3.fromRGB(255, 60, 60)
                    hl.FillTransparency = 0.65
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.OutlineTransparency = 0.1
                    hl.Parent = guiParent
                    data.Highlight = hl
                end
                data.Highlight.Adornee = tChar

                if myPos then
                    local dist = math.floor((myPos - targetPos).Magnitude)
                    data.Billboard.NameLabel.Text = p.DisplayName .. '\n<font color="#00FFFF">[' .. dist .. 'm]</font>'
                else
                    data.Billboard.NameLabel.Text = p.DisplayName
                end
            end)
        end
    end
    
    for p, _ in pairs(ActiveESPs) do
        if not Players:FindFirstChild(p.Name) then 
            clearSingleESP(p)
        end
    end
end

task.spawn(function()
    while task.wait(0.1) do
        updateESP_Hitbox()
    end
end)

-- ==========================================
-- VÒNG LẶP VẬT LÝ & CHUYỂN ĐỘNG
-- ==========================================
RunService.Stepped:Connect(function()
    local char = player.Character
    if char and (State.Noclip or (autoTpPlayerEnabled and wasHorizontalTp)) then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    if autoTpPlayerEnabled and targetTpPlayer then
        teleportToSelectedPlayer(false)
    end

    if spectatePlayerEnabled and targetTpPlayer and targetTpPlayer.Character then
        local cam = workspace.CurrentCamera
        local tChar = targetTpPlayer.Character
        local targetHum = tChar:FindFirstChildOfClass("Humanoid")
        local targetRoot = getUniversalRoot(tChar)
        local targetCF = getCharacterCFrame(tChar)

        if cam and targetCF then
            if targetRoot and targetHum then
                pcall(function() player.ReplicationFocus = targetRoot end)
                if cam.CameraSubject ~= targetHum then
                    cam.CameraSubject = targetHum
                end
            else
                if not spectateProxyPart or not spectateProxyPart.Parent then
                    spectateProxyPart = Instance.new("Part")
                    spectateProxyPart.Name = "VipSpectateProxy"
                    spectateProxyPart.Size = Vector3.new(1, 1, 1)
                    spectateProxyPart.Transparency = 1
                    spectateProxyPart.Anchored = true
                    spectateProxyPart.CanCollide = false
                    spectateProxyPart.CanQuery = false
                    spectateProxyPart.CanTouch = false
                    spectateProxyPart.Parent = workspace
                end
                spectateProxyPart.CFrame = targetCF
                pcall(function() player.ReplicationFocus = spectateProxyPart end)
                if cam.CameraSubject ~= spectateProxyPart then
                    cam.CameraSubject = spectateProxyPart
                end
                if tick() - lastSpectateStreamTick > 0.5 then
                    lastSpectateStreamTick = tick()
                    local streamPos = targetCF.Position
                    task.spawn(function()
                        pcall(function()
                            player:RequestStreamAroundAsync(streamPos, 3)
                        end)
                    end)
                end
            end
        end
    end
    
    local char = player.Character
    if not char then return end
    local root = getUniversalRoot(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if hum and root then
        if State.LockPosition then root.Anchored = true end
        
        if State.Jump then hum.UseJumpPower = true; hum.JumpPower = State.JumpValue end

        if not State.Fly and not autoTpPlayerEnabled then
            if State.Speed then
                hum.WalkSpeed = State.SpeedValue
                if hum.MoveDirection.Magnitude > 0 then
                    local curVel = root.AssemblyLinearVelocity
                    local targetVel = hum.MoveDirection * State.SpeedValue
                    root.AssemblyLinearVelocity = Vector3.new(targetVel.X, curVel.Y, targetVel.Z)
                end
            end

            if State.AutoDash and hum.MoveDirection.Magnitude > 0 then
                local dashSpeedStuds = State.DashSpeed * 8
                local curVel = root.AssemblyLinearVelocity
                local dashVel = hum.MoveDirection * dashSpeedStuds
                root.AssemblyLinearVelocity = Vector3.new(dashVel.X, curVel.Y, dashVel.Z)
            end
        end

        if State.SpinBot then 
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0) 
        end
        
        if State.Noclip and hum.MoveDirection.Magnitude == 0 then
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
        end
        
        if State.Fly then
            hum.PlatformStand = true
            local bv = root:FindFirstChild("FlyBodyVelocity")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "FlyBodyVelocity"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.zero
                bv.Parent = root
            end
            
            local bg = root:FindFirstChild("FlyBodyGyro")
            if not bg then
                bg = Instance.new("BodyGyro")
                bg.Name = "FlyBodyGyro"
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.P = 10000
                bg.D = 100
                bg.Parent = root
            end
            
            local cam = workspace.CurrentCamera
            bg.CFrame = cam.CFrame
            
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local camLook = cam.CFrame.LookVector
                local camRight = cam.CFrame.RightVector
                
                local flatLook = Vector3.new(camLook.X, 0, camLook.Z)
                local flatRight = Vector3.new(camRight.X, 0, camRight.Z)
                
                local forwardUnit = flatLook.Magnitude > 0.001 and flatLook.Unit or Vector3.zero
                local rightUnit = flatRight.Magnitude > 0.001 and flatRight.Unit or Vector3.zero
                
                local dotForward = moveDir:Dot(forwardUnit)
                local dotRight = moveDir:Dot(rightUnit)
                
                local flyDir = (camLook * dotForward) + (rightUnit * dotRight)
                
                if flyDir.Magnitude > 0.001 then
                    bv.Velocity = flyDir.Unit * State.FlySpeed
                else
                    bv.Velocity = Vector3.zero
                end
            else
                bv.Velocity = Vector3.zero
            end
        else
            if root:FindFirstChild("FlyBodyVelocity") then root.FlyBodyVelocity:Destroy() end
            if root:FindFirstChild("FlyBodyGyro") then root.FlyBodyGyro:Destroy() end
            if not State.AntiStun and not (autoTpPlayerEnabled and wasHorizontalTp) then
                hum.PlatformStand = false
            end
        end

        if State.AntiStun then 
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            
            local currentState = hum:GetState()
            if currentState == Enum.HumanoidStateType.FallingDown or currentState == Enum.HumanoidStateType.Ragdoll then 
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            
            if not State.Speed and not State.AutoDash then
                local currentVel = root.AssemblyLinearVelocity
                local horizontalVel = Vector3.new(currentVel.X, 0, currentVel.Z)
                if horizontalVel.Magnitude > 75 then
                    root.AssemblyLinearVelocity = Vector3.new(0, currentVel.Y, 0) 
                end
            end
        end

        local light = root:FindFirstChild("PlayerPointLight")
        if State.PlayerLight then 
            if not light then light = Instance.new("PointLight", root); light.Name = "PlayerPointLight"; light.Shadows = false end 
            light.Brightness = State.LightBrightness; light.Range = State.LightRange
            light.Color = PlayerLightColors[State.LightColorIdx].Value
        else 
            if light then light:Destroy() end 
        end
    end
    
    if State.Reach then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                if not originalToolSizes[tool] then originalToolSizes[tool] = handle.Size end
                handle.Size = Vector3.new(State.ReachSize, State.ReachSize, State.ReachSize)
                handle.Massless = true
                handle.CanCollide = false
                handle.Transparency = 0.8
            end
        end
    else
        if next(originalToolSizes) then
            for t, origSize in pairs(originalToolSizes) do
                if t and t.Parent and t:FindFirstChild("Handle") then
                    t.Handle.Size = origSize
                    t.Handle.Massless = false
                    t.Handle.Transparency = 0
                end
            end
            originalToolSizes = {}
        end
    end
end)

-- ==========================================
-- [GÓI NÂNG CẤP MỞ RỘNG: SIMULATOR BOOST + TIỆN ÍCH + TÌM KIẾM TP]
-- ==========================================
;(function()
    local GuiService = game:GetService("GuiService")
    local SoundService = game:GetService("SoundService")

    -- Tự động khởi tạo & đọc dữ liệu lưu của các tính năng mới
    local NewStates = {
        HidePopups = false,
        MuteSFX = false,
        DisableAnims = false,
        DarkMap = false,
        MiniHUD = false,
        AutoReconnect = true,
        MagnetOrbs = false
    }
    for k, v in pairs(NewStates) do
        if State[k] == nil then State[k] = v end
    end
    pcall(function()
        if isfile and isfile(configFileName) then
            local data = HttpService:JSONDecode(readfile(configFileName))
            for k, _ in pairs(NewStates) do
                if data[k] ~= nil then State[k] = data[k] end
            end
        end
    end)

    local ExtCache = {
        Popups = {},
        Sounds = {},
        Anims = {},
        DarkParts = {},
        LightingOrig = nil,
        Tickets = {Popup = 0, Sound = 0, Anim = 0, Dark = 0}
    }

    -- ==========================================
    -- 1. THÊM THANH TÌM KIẾM NHANH VÀO TAB 7 (TP PLAYER)
    -- ==========================================
    pcall(function()
        if playerListContainer and playerListScroll then
            local searchBar = Instance.new("Frame", playerListContainer)
            searchBar.Size = UDim2.new(1, -8, 0, 24)
            searchBar.Position = UDim2.new(0, 4, 0, 4)
            searchBar.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
            searchBar.ZIndex = 11
            Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 6)
            local sStroke = Instance.new("UIStroke", searchBar)
            sStroke.Color = Theme.Brand
            sStroke.Thickness = 1
            table.insert(RGBElements, {Type = "Button", Stroke = sStroke, DefaultColor = Theme.Brand})

            local searchBox = Instance.new("TextBox", searchBar)
            searchBox.Size = UDim2.new(1, -16, 1, 0)
            searchBox.Position = UDim2.new(0, 8, 0, 0)
            searchBox.BackgroundTransparency = 1
            searchBox.PlaceholderText = "🔍 Nhập tên hoặc @username để lọc nhanh..."
            searchBox.PlaceholderColor3 = Theme.TextDim
            searchBox.Text = ""
            searchBox.TextColor3 = Theme.TextTitle
            searchBox.Font = Enum.Font.GothamSemibold
            searchBox.TextSize = 10
            searchBox.TextXAlignment = Enum.TextXAlignment.Left
            searchBox.ClearTextOnFocus = false
            searchBox.ZIndex = 11

            playerListScroll.Size = UDim2.new(1, -6, 1, -34)
            playerListScroll.Position = UDim2.new(0, 3, 0, 30)

            local function filterPlayerCards()
                local keyword = string.lower(searchBox.Text:gsub("^%s*(.-)%s*$", "%1"))
                for _, item in ipairs(playerListScroll:GetChildren()) do
                    if item.Name == "PaddingFrame" then
                        if keyword == "" then
                            item.Visible = true
                        else
                            local matched = false
                            for _, desc in ipairs(item:GetDescendants()) do
                                if desc:IsA("TextLabel") and string.find(string.lower(desc.Text), keyword, 1, true) then
                                    matched = true
                                    break
                                end
                            end
                            item.Visible = matched
                        end
                    end
                end
            end

            searchBox:GetPropertyChangedSignal("Text"):Connect(filterPlayerCards)
            playerListScroll.ChildAdded:Connect(function()
                task.defer(filterPlayerCards)
            end)
        end
    end)

    -- ==========================================
    -- 2. THÊM 4 TÍNH NĂNG SIMULATOR VÀO TAB 9 (CẤU HÌNH)
    -- ==========================================
    createDivider(page9, "TỐI ƯU CHUYÊN SÂU SIMULATOR")

    -- [A] Ẩn chữ bay & Popup (+Tiền / +Sức mạnh / Damage)
    local function processPopupObj(obj)
        if not State.HidePopups or not obj or not obj.Parent then return end
        if obj:IsA("BillboardGui") and not string.find(obj.Name, "^MobileESP_") then
            if obj.Enabled then
                if ExtCache.Popups[obj] == nil then ExtCache.Popups[obj] = obj.Enabled end
                obj.Enabled = false
            end
        elseif obj:IsA("TextLabel") and obj:IsDescendantOf(player:FindFirstChild("PlayerGui")) and not obj:IsDescendantOf(gui) then
            local txt = obj.Text or ""
            if string.find(txt, "^%+[%d%.]+") or string.find(string.lower(obj.Name), "popup") or string.find(string.lower(obj.Name), "damage") then
                if obj.Visible then
                    if ExtCache.Popups[obj] == nil then ExtCache.Popups[obj] = obj.Visible end
                    obj.Visible = false
                end
            end
        end
    end

    createToggle(page9, "🚫 Ẩn chữ bay & Popup (+Chỉ số/Damage)", "HidePopups", function(v)
        ExtCache.Tickets.Popup = ExtCache.Tickets.Popup + 1
        local myTicket = ExtCache.Tickets.Popup
        if v then
            task.spawn(function()
                for i, obj in ipairs(workspace:GetDescendants()) do
                    if myTicket ~= ExtCache.Tickets.Popup then return end
                    pcall(processPopupObj, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            task.spawn(function()
                local c = 0
                for obj, orig in pairs(ExtCache.Popups) do
                    if myTicket ~= ExtCache.Tickets.Popup then return end
                    pcall(function()
                        if obj and obj.Parent then
                            if obj:IsA("BillboardGui") then obj.Enabled = orig else obj.Visible = orig end
                        end
                    end)
                    c = c + 1
                    if c % 350 == 0 then task.wait() end
                end
                if myTicket == ExtCache.Tickets.Popup then ExtCache.Popups = {} end
            end)
        end
    end)

    -- [B] Tắt toàn bộ tiếng động Game (Mute SFX - Giữ lại nhạc Tab 5)
    local function processSoundObj(obj)
        if not State.MuteSFX or not obj or not obj.Parent then return end
        if obj:IsA("Sound") and obj ~= currentSound then
            if obj.Volume > 0 then
                if ExtCache.Sounds[obj] == nil then ExtCache.Sounds[obj] = obj.Volume end
                obj.Volume = 0
            end
        end
    end

    createToggle(page9, "🔇 Tắt tiếng động Game (Giữ nhạc Menu)", "MuteSFX", function(v)
        ExtCache.Tickets.Sound = ExtCache.Tickets.Sound + 1
        local myTicket = ExtCache.Tickets.Sound
        if v then
            task.spawn(function()
                for _, container in ipairs({workspace, SoundService, player:FindFirstChild("PlayerGui")}) do
                    if container then
                        for i, obj in ipairs(container:GetDescendants()) do
                            if myTicket ~= ExtCache.Tickets.Sound then return end
                            pcall(processSoundObj, obj)
                            if i % 350 == 0 then task.wait() end
                        end
                    end
                end
            end)
        else
            task.spawn(function()
                local c = 0
                for s, vol in pairs(ExtCache.Sounds) do
                    if myTicket ~= ExtCache.Tickets.Sound then return end
                    pcall(function() if s and s.Parent then s.Volume = vol end end)
                    c = c + 1
                    if c % 350 == 0 then task.wait() end
                end
                if myTicket == ExtCache.Tickets.Sound then ExtCache.Sounds = {} end
            end)
        end
    end)

    -- [C] Tắt hoạt ảnh Nhân vật & Quái (Disable Animations)
    local function stopAnimator(obj)
        if not State.DisableAnims or not obj or not obj.Parent then return end
        if obj:IsA("Animator") then
            for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop(0) end)
            end
        elseif obj:IsA("BaseScript") and obj.Name == "Animate" then
            if obj.Disabled == false then
                ExtCache.Anims[obj] = false
                obj.Disabled = true
            end
        end
    end

    createToggle(page9, "🎭 Tắt hoạt ảnh Nhân vật & Quái (Giảm CPU)", "DisableAnims", function(v)
        ExtCache.Tickets.Anim = ExtCache.Tickets.Anim + 1
        local myTicket = ExtCache.Tickets.Anim
        if v then
            task.spawn(function()
                for i, obj in ipairs(workspace:GetDescendants()) do
                    if myTicket ~= ExtCache.Tickets.Anim then return end
                    pcall(stopAnimator, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            for scr, state in pairs(ExtCache.Anims) do
                pcall(function() if scr and scr.Parent then scr.Disabled = state end end)
            end
            ExtCache.Anims = {}
        end
    end)

    -- [D] Chế độ Bản đồ Tối Dịu Mắt (Dark Flat Map)
    local darkColor = Color3.fromRGB(38, 40, 48)
    local function processDarkPart(obj)
        if not State.DarkMap or not obj or not obj.Parent then return end
        if obj:IsA("BasePart") and obj.Name ~= "VipAirWalk" and obj.Name ~= "VipSpectateProxy" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and obj:IsDescendantOf(p.Character) then return end
            end
            if obj.Color ~= darkColor then
                if ExtCache.DarkParts[obj] == nil then ExtCache.DarkParts[obj] = obj.Color end
                obj.Color = darkColor
            end
        end
    end

    createToggle(page9, "🌑 Bản đồ Tối Dịu Mắt (Chống chói & Nhẹ máy)", "DarkMap", function(v)
        ExtCache.Tickets.Dark = ExtCache.Tickets.Dark + 1
        local myTicket = ExtCache.Tickets.Dark
        if v then
            pcall(function()
                if not ExtCache.LightingOrig then
                    ExtCache.LightingOrig = {
                        Brightness = Lighting.Brightness,
                        OutdoorAmbient = Lighting.OutdoorAmbient,
                        Ambient = Lighting.Ambient
                    }
                end
                Lighting.Brightness = 0.8
                Lighting.OutdoorAmbient = Color3.fromRGB(65, 70, 85)
                Lighting.Ambient = Color3.fromRGB(50, 55, 68)
            end)
            task.spawn(function()
                for i, obj in ipairs(workspace:GetDescendants()) do
                    if myTicket ~= ExtCache.Tickets.Dark then return end
                    pcall(processDarkPart, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            pcall(function()
                if ExtCache.LightingOrig then
                    Lighting.Brightness = ExtCache.LightingOrig.Brightness
                    Lighting.OutdoorAmbient = ExtCache.LightingOrig.OutdoorAmbient
                    Lighting.Ambient = ExtCache.LightingOrig.Ambient
                    ExtCache.LightingOrig = nil
                end
            end)
            task.spawn(function()
                local c = 0
                for part, col in pairs(ExtCache.DarkParts) do
                    if myTicket ~= ExtCache.Tickets.Dark then return end
                    pcall(function() if part and part.Parent then part.Color = col end end)
                    c = c + 1
                    if c % 350 == 0 then task.wait() end
                end
                if myTicket == ExtCache.Tickets.Dark then ExtCache.DarkParts = {} end
            end)
        end
    end)

    -- Tự động bắt các Object/Popup/Âm thanh mới sinh ra
    workspace.DescendantAdded:Connect(function(obj)
        if State.HidePopups or State.MuteSFX or State.DisableAnims or State.DarkMap then
            task.defer(function()
                pcall(processPopupObj, obj)
                pcall(processSoundObj, obj)
                pcall(stopAnimator, obj)
                pcall(processDarkPart, obj)
            end)
        end
    end)
    pcall(function()
        player:WaitForChild("PlayerGui").DescendantAdded:Connect(function(obj)
            if State.HidePopups or State.MuteSFX then
                task.defer(function()
                    pcall(processPopupObj, obj)
                    pcall(processSoundObj, obj)
                end)
            end
        end)
    end)

    -- ==========================================
    -- 3. THÊM 3 TIỆN ÍCH TREO MÁY VÀO TAB 4 (TIỆN ÍCH)
    -- ==========================================
    createDivider(page4, "TIỆN ÍCH TREO MÁY & HỖ TRỢ")

    -- [E] Đồng hồ FPS & Ping Mini ngoài màn hình
    local miniHudFrame = Instance.new("Frame", gui)
    miniHudFrame.Size = UDim2.new(0, 128, 0, 26)
    miniHudFrame.Position = UDim2.new(0, 62, 0.25, 7)
    miniHudFrame.BackgroundColor3 = Theme.MainBg
    miniHudFrame.BackgroundTransparency = 0.15
    miniHudFrame.Visible = State.MiniHUD
    miniHudFrame.ZIndex = 10
    Instance.new("UICorner", miniHudFrame).CornerRadius = UDim.new(1, 0)
    local hudStroke = Instance.new("UIStroke", miniHudFrame)
    hudStroke.Color = Theme.Brand
    hudStroke.Thickness = 1.4
    table.insert(RGBElements, {Type = "Button", Stroke = hudStroke, DefaultColor = Theme.Brand})

    local hudLabel = Instance.new("TextLabel", miniHudFrame)
    hudLabel.Size = UDim2.new(1, 0, 1, 0)
    hudLabel.BackgroundTransparency = 1
    hudLabel.RichText = true
    hudLabel.Text = "⚡ 60 FPS | 🌐 0 ms"
    hudLabel.TextColor3 = Theme.TextTitle
    hudLabel.Font = Enum.Font.GothamBold
    hudLabel.TextSize = 10
    hudLabel.ZIndex = 10

    local hudDrag, hudStart, hudPos
    miniHudFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            hudDrag = true; hudStart = inp.Position; hudPos = miniHudFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if hudDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            miniHudFrame.Position = UDim2.new(hudPos.X.Scale, hudPos.X.Offset + (inp.Position.X - hudStart.X), hudPos.Y.Scale, hudPos.Y.Offset + (inp.Position.Y - hudStart.Y))
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then hudDrag = false end
    end)

    createToggle(page4, "📟 Đồng hồ FPS & Ping Mini ngoài màn hình", "MiniHUD", function(v)
        miniHudFrame.Visible = v
    end)

    task.spawn(function()
        local Stats = game:GetService("Stats")
        while task.wait(0.6) do
            if State.MiniHUD and miniHudFrame.Visible then
                local pingNum = 0
                pcall(function()
                    if Stats and Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem") then
                        local raw = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                        pingNum = tonumber(raw and raw:match("%d+")) or math.floor(player:GetNetworkPing() * 1000)
                    else
                        pingNum = math.floor(player:GetNetworkPing() * 1000)
                    end
                end)
                local fCol = fps >= 45 and "#2ECC71" or (fps >= 25 and "#F1C40F" or "#FF4757")
                hudLabel.Text = string.format("⚡ <font color='%s'>%d FPS</font> | 🌐 <font color='#00E5FF'>%d ms</font>", fCol, fps, pingNum)
            end
        end
    end)

    -- [F] Tự động vào lại khi mất kết nối (Auto Reconnect)
    createToggle(page4, "🔌 Tự động vào lại khi văng game (Reconnect)", "AutoReconnect")

    local function triggerReconnect()
        if State.AutoReconnect then
            MakeToast("🔌 Auto Reconnect", "Phát hiện mất kết nối! Đang vào lại...", Theme.Brand)
            task.wait(2)
            pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
        end
    end
    pcall(function()
        GuiService.ErrorMessageChanged:Connect(function(msg)
            if msg and msg ~= "" then triggerReconnect() end
        end)
    end)

    -- [G] Hút Tiền, Ngọc & Vật phẩm rơi (Magnet Orbs/Coins)
    createToggle(page4, "🧲 Hút Tiền, Ngọc & Vật phẩm rơi (Magnet)", "MagnetOrbs")

    local magnetKeywords = {"coin", "gem", "orb", "diamond", "cash", "money", "yen", "token", "drop", "star", "crystal", "gold", "silver", "emerald"}
    local function isMagnetItem(part)
        if not part:IsA("BasePart") or part.Anchored and part.Size.Magnitude > 8 then return false end
        local name = string.lower(part.Name)
        local pName = part.Parent and string.lower(part.Parent.Name) or ""
        for _, kw in ipairs(magnetKeywords) do
            if string.find(name, kw, 1, true) or string.find(pName, kw, 1, true) then
                return true
            end
        end
        return false
    end

    task.spawn(function()
        while task.wait(0.35) do
            if State.MagnetOrbs and player.Character then
                pcall(function()
                    local root = getUniversalRoot(player.Character)
                    if not root then return end
                    local overlap = OverlapParams.new()
                    overlap.FilterDescendantsInstances = {player.Character}
                    overlap.FilterType = Enum.RaycastFilterType.Exclude
                    local nearby = workspace:GetPartBoundsInRadius(root.Position, 85, overlap)
                    for _, part in ipairs(nearby) do
                        if isMagnetItem(part) then
                            part.CanCollide = false
                            if firetouchinterest then
                                firetouchinterest(root, part, 0)
                                firetouchinterest(root, part, 1)
                            end
                            part.CFrame = root.CFrame
                        end
                    end
                end)
            end
        end
    end)
end)()


-- ==========================================
-- [GÓI NÂNG CẤP TAB 1: THÔNG TIN DASHBOARD PRO]
-- ==========================================
;(function()
    if not page1 then return end

    -- Dọn sạch giao diện Tab 1 cũ để thay bằng Dashboard mới
    for _, child in ipairs(page1:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local gameName = "Đang tải tên game..."
    task.spawn(function()
        pcall(function()
            local info = MarketplaceService:GetProductInfo(game.PlaceId)
            if info and info.Name then gameName = info.Name end
        end)
    end)

    local execName = "Roblox Client"
    pcall(function()
        if identifyexecutor then
            execName = tostring(identifyexecutor())
        elseif getexecutorname then
            execName = tostring(getexecutorname())
        end
    end)

    local function makeCard(titleIcon, titleText, height, order)
        local card = Instance.new("Frame", page1)
        card.Size = UDim2.new(0.92, 0, 0, height)
        card.BackgroundColor3 = Theme.ItemBg
        card.LayoutOrder = order
        card.ZIndex = 10
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Theme.Stroke
        stroke.Thickness = 1.2
        table.insert(RGBElements, {Type = "Info", Stroke = stroke})

        local headerTitle = Instance.new("TextLabel", card)
        headerTitle.Size = UDim2.new(1, -16, 0, 20)
        headerTitle.Position = UDim2.new(0, 10, 0, 4)
        headerTitle.BackgroundTransparency = 1
        headerTitle.Text = titleIcon .. " " .. titleText
        headerTitle.TextColor3 = Theme.Brand
        headerTitle.Font = Enum.Font.GothamBlack
        headerTitle.TextSize = 11
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        headerTitle.ZIndex = 10

        local line = Instance.new("Frame", card)
        line.Size = UDim2.new(1, -20, 0, 1)
        line.Position = UDim2.new(0, 10, 0, 24)
        line.BackgroundColor3 = Theme.Stroke
        line.BorderSizePixel = 0
        line.ZIndex = 10

        local body = Instance.new("TextLabel", card)
        body.Size = UDim2.new(1, -20, 1, -30)
        body.Position = UDim2.new(0, 10, 0, 28)
        body.BackgroundTransparency = 1
        body.RichText = true
        body.Text = "Đang tải..."
        body.TextColor3 = Theme.TextTitle
        body.Font = Enum.Font.GothamSemibold
        body.TextSize = 10.5
        body.LineHeight = 1.22
        body.TextXAlignment = Enum.TextXAlignment.Left
        body.TextYAlignment = Enum.TextYAlignment.Top
        body.ZIndex = 10

        return card, body
    end

    -- 1. THẺ NHÂN VẬT (CÓ THANH MÁU + NÚT COPY TỌA ĐỘ)
    local charCard, charBody = makeCard("👤", "THÔNG TIN NHÂN VẬT", 122, 1)

    local copyCoordBtn = Instance.new("TextButton", charCard)
    copyCoordBtn.Size = UDim2.new(0, 78, 0, 18)
    copyCoordBtn.Position = UDim2.new(1, -86, 0, 4)
    copyCoordBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 65)
    copyCoordBtn.Text = "📍 Copy Tọa Độ"
    copyCoordBtn.TextColor3 = Theme.Brand
    copyCoordBtn.Font = Enum.Font.GothamBold
    copyCoordBtn.TextSize = 9
    copyCoordBtn.ZIndex = 11
    Instance.new("UICorner", copyCoordBtn).CornerRadius = UDim.new(0, 5)
    local ccStroke = Instance.new("UIStroke", copyCoordBtn)
    ccStroke.Color = Theme.Brand
    ccStroke.Thickness = 1

    copyCoordBtn.MouseButton1Click:Connect(function()
        clickAnimate(copyCoordBtn)
        pcall(function()
            local root = getUniversalRoot(player.Character)
            if root and setclipboard then
                local p = root.Position
                local str = string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z)
                setclipboard(str)
                MakeToast("Đã Copy Tọa Độ", str, Theme.AccentOn)
            end
        end)
    end)

    local hpBarBg = Instance.new("Frame", charCard)
    hpBarBg.Size = UDim2.new(1, -20, 0, 6)
    hpBarBg.Position = UDim2.new(0, 10, 1, -11)
    hpBarBg.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    hpBarBg.BorderSizePixel = 0
    hpBarBg.ZIndex = 11
    Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(1, 0)

    local hpBarFill = Instance.new("Frame", hpBarBg)
    hpBarFill.Size = UDim2.new(1, 0, 1, 0)
    hpBarFill.BackgroundColor3 = Theme.AccentOn
    hpBarFill.BorderSizePixel = 0
    hpBarFill.ZIndex = 11
    Instance.new("UICorner", hpBarFill).CornerRadius = UDim.new(1, 0)

    -- 2. THẺ MÁY CHỦ (LỌC SẠCH PING + TÊN GAME + COPY ID)
    local svCard, svBody = makeCard("🌐", "THÔNG TIN MÁY CHỦ", 108, 2)

    local copyJobBtn = Instance.new("TextButton", svCard)
    copyJobBtn.Size = UDim2.new(0, 68, 0, 18)
    copyJobBtn.Position = UDim2.new(1, -76, 0, 4)
    copyJobBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 40)
    copyJobBtn.Text = "📜 Copy ID"
    copyJobBtn.TextColor3 = Theme.AccentOn
    copyJobBtn.Font = Enum.Font.GothamBold
    copyJobBtn.TextSize = 9
    copyJobBtn.ZIndex = 11
    Instance.new("UICorner", copyJobBtn).CornerRadius = UDim.new(0, 5)
    local cjStroke = Instance.new("UIStroke", copyJobBtn)
    cjStroke.Color = Theme.AccentOn
    cjStroke.Thickness = 1

    copyJobBtn.MouseButton1Click:Connect(function()
        clickAnimate(copyJobBtn)
        pcall(function()
            if setclipboard then
                setclipboard(tostring(game.JobId))
                MakeToast("Đã Copy JobId", "Đã lưu ID máy chủ vào bộ nhớ tạm!", Theme.AccentOn)
            end
        end)
    end)

    -- 3. KHUNG NHẬP ID SERVER (CÓ NÚT XÓA NHANH + VÀO)
    local joinFrame = Instance.new("Frame", page1)
    joinFrame.Size = UDim2.new(0.92, 0, 0, 34)
    joinFrame.BackgroundColor3 = Theme.ItemBg
    joinFrame.LayoutOrder = 3
    joinFrame.ZIndex = 10
    Instance.new("UICorner", joinFrame).CornerRadius = UDim.new(0, 8)
    local jfStroke = Instance.new("UIStroke", joinFrame)
    jfStroke.Color = Theme.Stroke
    jfStroke.Thickness = 1.2
    table.insert(RGBElements, {Type = "Info", Stroke = jfStroke})

    local jobInput = Instance.new("TextBox", joinFrame)
    jobInput.Size = UDim2.new(0.56, 0, 1, 0)
    jobInput.Position = UDim2.new(0.03, 0, 0, 0)
    jobInput.BackgroundTransparency = 1
    jobInput.PlaceholderText = "🔍 Dán ID Server cần vào..."
    jobInput.PlaceholderColor3 = Theme.TextDim
    jobInput.Text = ""
    jobInput.TextColor3 = Theme.Brand
    jobInput.Font = Enum.Font.GothamSemibold
    jobInput.TextSize = 10
    jobInput.TextXAlignment = Enum.TextXAlignment.Left
    jobInput.ClearTextOnFocus = false
    jobInput.ZIndex = 10

    local clearPasteBtn = Instance.new("TextButton", joinFrame)
    clearPasteBtn.Size = UDim2.new(0.16, 0, 0.72, 0)
    clearPasteBtn.Position = UDim2.new(0.60, 0, 0.14, 0)
    clearPasteBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    clearPasteBtn.Text = "XÓA"
    clearPasteBtn.TextColor3 = Theme.TextTitle
    clearPasteBtn.Font = Enum.Font.GothamBold
    clearPasteBtn.TextSize = 9.5
    clearPasteBtn.ZIndex = 10
    Instance.new("UICorner", clearPasteBtn).CornerRadius = UDim.new(0, 6)

    clearPasteBtn.MouseButton1Click:Connect(function()
        clickAnimate(clearPasteBtn)
        jobInput.Text = ""
    end)

    local goJoinBtn = Instance.new("TextButton", joinFrame)
    goJoinBtn.Size = UDim2.new(0.20, 0, 0.72, 0)
    goJoinBtn.Position = UDim2.new(0.78, 0, 0.14, 0)
    goJoinBtn.BackgroundColor3 = Theme.AccentOn
    goJoinBtn.Text = "VÀO"
    goJoinBtn.TextColor3 = Color3.new(1, 1, 1)
    goJoinBtn.Font = Enum.Font.GothamBlack
    goJoinBtn.TextSize = 10
    goJoinBtn.ZIndex = 10
    Instance.new("UICorner", goJoinBtn).CornerRadius = UDim.new(0, 6)

    goJoinBtn.MouseButton1Click:Connect(function()
        clickAnimate(goJoinBtn)
        local targetId = jobInput.Text:gsub("%s+", "")
        if targetId ~= "" then
            MakeToast("Đang Chuyển Server", "Đang kết nối tới JobId...", Theme.AccentOn)
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player) end)
        else
            MakeToast("⚠️ Trống ID", "Hãy dán JobId máy chủ vào ô trước!", Theme.AccentOff)
        end
    end)

    -- 4. THẺ TRẠNG THÁI & HỆ THỐNG (EXECUTOR + ĐẾM TÍNH NĂNG BẬT + RESET NHANH)
    local sysCard, sysBody = makeCard("⚙️", "TRẠNG THÁI & HỆ THỐNG", 96, 4)

    local resetCharBtn = Instance.new("TextButton", sysCard)
    resetCharBtn.Size = UDim2.new(0, 78, 0, 18)
    resetCharBtn.Position = UDim2.new(1, -86, 0, 4)
    resetCharBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 38)
    resetCharBtn.Text = "🔄 Reset NV"
    resetCharBtn.TextColor3 = Theme.AccentOff
    resetCharBtn.Font = Enum.Font.GothamBold
    resetCharBtn.TextSize = 9
    resetCharBtn.ZIndex = 11
    Instance.new("UICorner", resetCharBtn).CornerRadius = UDim.new(0, 5)
    local rcStroke = Instance.new("UIStroke", resetCharBtn)
    rcStroke.Color = Theme.AccentOff
    rcStroke.Thickness = 1

    resetCharBtn.MouseButton1Click:Connect(function()
        clickAnimate(resetCharBtn)
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
                MakeToast("Đã Reset", "Đang hồi sinh lại nhân vật...", Theme.AccentOff)
            end
        end)
    end)

    -- VÒNG LẶP CẬP NHẬT THÔNG TIN SẮC NÉT
    task.spawn(function()
        local Stats = game:GetService("Stats")
        while task.wait(0.5) do
            if page1.Visible then
                -- Cập nhật Nhân vật
                local hp, maxHp, ws, jp = 0, 100, 0, 0
                local coords = "0.0, 0.0, 0.0"
                if player.Character then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hp = math.floor(hum.Health)
                        maxHp = math.max(1, math.floor(hum.MaxHealth))
                        ws = math.floor(hum.WalkSpeed)
                        jp = math.floor(hum.JumpPower)
                    end
                    local root = getUniversalRoot(player.Character)
                    if root then
                        local pos = root.Position
                        coords = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
                    end
                end

                local hpRatio = math.clamp(hp / maxHp, 0, 1)
                local hpHex = hpRatio > 0.5 and "#2ECC71" or (hpRatio > 0.25 and "#F1C40F" or "#FF4757")
                TweenService:Create(hpBarFill, TweenInfo.new(0.25), {
                    Size = UDim2.new(hpRatio, 0, 1, 0),
                    BackgroundColor3 = Color3.fromHex(hpHex)
                }):Play()

                charBody.Text = string.format(
                    "<font color='#00E5FF'>• Tên:</font> %s <font color='#A4B0BE'>(@%s)</font>\n" ..
                    "<font color='#00E5FF'>• ID / Tuổi:</font> %d <font color='#FFD700'>(%d ngày)</font>\n" ..
                    "<font color='#00E5FF'>• Máu (HP):</font> <font color='%s'>%d / %d (%d%%)</font>\n" ..
                    "<font color='#00E5FF'>• Tốc chạy:</font> <font color='#2ECC71'>%d</font>   |   <font color='#00E5FF'>Nhảy:</font> <font color='#2ECC71'>%d</font>\n" ..
                    "<font color='#00E5FF'>• Tọa độ:</font> <font color='#FFD700'>%s</font>",
                    player.DisplayName, player.Name,
                    player.UserId, player.AccountAge,
                    hpHex, hp, maxHp, math.floor(hpRatio * 100),
                    ws, jp,
                    coords
                )

                -- Cập nhật Máy chủ (Làm sạch chuỗi Ping)
                local pingNum = 0
                pcall(function()
                    if Stats and Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem") then
                        local raw = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                        pingNum = tonumber(raw and raw:match("%d+")) or math.floor(player:GetNetworkPing() * 1000)
                    else
                        pingNum = math.floor(player:GetNetworkPing() * 1000)
                    end
                end)
                local fpsHex = fps >= 45 and "#2ECC71" or (fps >= 25 and "#F1C40F" or "#FF4757")
                local pingHex = pingNum <= 100 and "#2ECC71" or (pingNum <= 200 and "#F1C40F" or "#FF4757")
                local shortJob = game.JobId ~= "" and (string.sub(game.JobId, 1, 18) .. "...") or "Private/Studio"

                svBody.Text = string.format(
                    "<font color='#00E5FF'>• Tựa game:</font> <font color='#FFD700'>%s</font>\n" ..
                    "<font color='#00E5FF'>• FPS:</font> <font color='%s'>%d</font>   |   <font color='#00E5FF'>Ping:</font> <font color='%s'>%d ms</font>\n" ..
                    "<font color='#00E5FF'>• Người chơi:</font> %d / %d   |   <font color='#00E5FF'>PlaceId:</font> %d\n" ..
                    "<font color='#00E5FF'>• ID Server:</font> <font color='#A4B0BE'>%s</font>",
                    string.sub(gameName, 1, 26),
                    fpsHex, fps, pingHex, pingNum,
                    #Players:GetPlayers(), Players.MaxPlayers, game.PlaceId,
                    shortJob
                )

                -- Cập nhật Trạng thái & Hệ thống
                local activeCount = 0
                for _, v in pairs(State) do
                    if v == true then activeCount = activeCount + 1 end
                end
                local execTime = math.floor(workspace.DistributedGameTime)
                local h = math.floor(execTime / 3600)
                local m = math.floor((execTime % 3600) / 60)
                local s = execTime % 60

                sysBody.Text = string.format(
                    "<font color='#00E5FF'>• Executor:</font> <font color='#2ECC71'>%s</font>   |   <font color='#00E5FF'>Đang bật:</font> <font color='#FFD700'>%d tính năng</font>\n" ..
                    "<font color='#00E5FF'>• Treo máy:</font> %02d:%02d:%02d   |   <font color='#00E5FF'>Giờ:</font> %s\n" ..
                    "<font color='#00E5FF'>• Phiên bản:</font> <font color='#FF9F43'>VIP PRO MAX V1.13.8</font>",
                    execName, activeCount,
                    h, m, s, os.date("%H:%M:%S")
                )
            end
        end
    end)
end)()
