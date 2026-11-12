-- ==========================================
-- MENU VIP PRO MAX V1.13.3 (FULL EXPANDED 1800+ LINES)
-- ==========================================
repeat
    task.wait()
until game:IsLoaded()

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

local player = Players.LocalPlayer
while not player do
    task.wait()
    player = Players.LocalPlayer
end

local State = {
    Instant = false,
    Noclip = false,
    LowGfx = false,
    Speed = false,
    Jump = false,
    InfJump = false,
    PlayerLight = false,
    ESP = false,
    AntiAfk = true,
    AntiStun = false,
    XRay = false,
    LockPosition = false,
    AutoCollect = false,
    Fly = false,
    FlySpeed = 50,
    SpinBot = false,
    SpinSpeed = 50,
    Hitbox = false,
    HitboxSize = 15,
    AutoClick = false,
    RGB = false,
    Reach = false,
    ReachSize = 15,
    AutoDash = false,
    DashSpeed = 10,
    AutoSave = false,
    Astral = false,
    ShiftLock = false,
    SpeedValue = 60,
    JumpValue = 120,
    LightRange = 60,
    LightBrightness = 3,
    MusicVolume = 5,
    LightColorIdx = 1,
    NoFog = false,
    FpsCapValue = 60,
    Disable3D = false,
    AfkModeScreen = false,
    RemoveTextures = false,
    HidePlayers = false,
    OptimizeTerrain = false,
    NoShadows = false,
    AutoSkillDelay = 1,
    AutoSkillZ = false,
    AutoSkillX = false,
    AutoSkillC = false,
    AutoSkillV = false,
    AutoSkillE = false,
    AutoSkillF = false,
    AutoSkill1 = false,
    AutoSkill2 = false,
    AutoSkill3 = false,
    AutoSkill4 = false,
    AutoSkill5 = false,
    AutoSkill6 = false,
    TpPositionIdx = 1,
    TpDistance = 4
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
    {
        Name = "Trắng",
        Value = Color3.fromRGB(255, 255, 255)
    },
    {
        Name = "Đỏ",
        Value = Color3.fromRGB(255, 0, 0)
    },
    {
        Name = "Cam",
        Value = Color3.fromRGB(255, 128, 0)
    },
    {
        Name = "Vàng",
        Value = Color3.fromRGB(255, 255, 0)
    },
    {
        Name = "Xanh lá",
        Value = Color3.fromRGB(0, 255, 0)
    },
    {
        Name = "Xanh lơ",
        Value = Color3.fromRGB(0, 255, 255)
    },
    {
        Name = "Xanh dương",
        Value = Color3.fromRGB(0, 0, 255)
    },
    {
        Name = "Tím",
        Value = Color3.fromRGB(128, 0, 255)
    },
    {
        Name = "Hồng",
        Value = Color3.fromRGB(255, 105, 180)
    }
}

-- Cấu hình vị trí TP: Trên đầu & Dưới chân xoay nhân vật nằm ngang hướng về mục tiêu
local TpPositions = {
    {
        Name = "Sau lưng",
        IsHorizontal = false,
        GetOffset = function(d)
            return CFrame.new(0, 0, d)
        end
    },
    {
        Name = "Trước mặt",
        IsHorizontal = false,
        GetOffset = function(d)
            return CFrame.new(0, 0, -d) * CFrame.Angles(0, math.pi, 0)
        end
    },
    {
        Name = "Trên đầu",
        IsHorizontal = true,
        GetOffset = function(d)
            return CFrame.new(0, d, 0) * CFrame.Angles(math.rad(-90), 0, 0)
        end
    },
    {
        Name = "Dưới chân",
        IsHorizontal = true,
        GetOffset = function(d)
            return CFrame.new(0, -d, 0) * CFrame.Angles(math.rad(90), 0, 0)
        end
    }
}

local RGBElements = {}
local ActiveESPs = {}
local originalHitboxSizes = {}
local originalToolSizes = {}
local cachedPrompts = {}
local xrayMats = {}
local OriginalGFX = {}

local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
    if gethui and type(gethui) == "function" then
        local hui = gethui()
        if hui then
            guiParent = hui
        end
    elseif game:GetService("CoreGui") then
        guiParent = game:GetService("CoreGui")
    end
end)

for _, v in pairs(guiParent:GetChildren()) do
    if v.Name == "MenuVipProMax" or v.Name == "MobileProMax" then
        v:Destroy()
    end
end

local configFileName = "MenuVipProMax_Config.json"
pcall(function()
    if isfile and isfile(configFileName) then
        local raw = readfile(configFileName)
        local data = HttpService:JSONDecode(raw)
        if type(data) == "table" then
            for k, v in pairs(data) do
                if State[k] ~= nil and type(State[k]) == type(v) then
                    State[k] = v
                end
            end
        end
    end
end)

if not TpPositions[State.TpPositionIdx] then
    State.TpPositionIdx = 1
end

if not PlayerLightColors[State.LightColorIdx] then
    State.LightColorIdx = 1
end

local function saveConfig()
    pcall(function()
        if writefile then
            writefile(configFileName, HttpService:JSONEncode(State))
        end
    end)
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

local notifGui = Instance.new("Frame")
notifGui.Size = UDim2.new(0, 190, 0.8, 0)
notifGui.Position = UDim2.new(1, -200, 0.1, 0)
notifGui.BackgroundTransparency = 1
notifGui.ZIndex = 9999
notifGui.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 6)
notifLayout.Parent = notifGui

local function MakeToast(title, desc, color)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 44)
    toast.BackgroundColor3 = Theme.ItemBg
    toast.BackgroundTransparency = 1
    toast.Parent = notifGui

    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 8)
    toastCorner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1.2
    stroke.Transparency = 1
    stroke.Parent = toast

    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 3, 1, -12)
    colorBar.Position = UDim2.new(0, 6, 0, 6)
    colorBar.BackgroundColor3 = color
    colorBar.BorderSizePixel = 0
    colorBar.BackgroundTransparency = 1
    colorBar.Parent = toast

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = colorBar

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -24, 0, 16)
    tLabel.Position = UDim2.new(0, 16, 0, 5)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = title
    tLabel.TextColor3 = color
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 11
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.TextTransparency = 1
    tLabel.Parent = toast

    local dLabel = Instance.new("TextLabel")
    dLabel.Size = UDim2.new(1, -24, 0, 16)
    dLabel.Position = UDim2.new(0, 16, 0, 22)
    dLabel.BackgroundTransparency = 1
    dLabel.Text = desc
    dLabel.TextColor3 = Theme.TextTitle
    dLabel.Font = Enum.Font.Gotham
    dLabel.TextSize = 10
    dLabel.TextXAlignment = Enum.TextXAlignment.Left
    dLabel.TextTransparency = 1
    dLabel.Parent = toast

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
        task.wait(0.4)
        toast:Destroy()
    end)
end

local screenOverlay = Instance.new("Frame")
screenOverlay.Size = UDim2.new(2, 0, 2, 0)
screenOverlay.Position = UDim2.new(-0.5, 0, -0.5, 0)
screenOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
screenOverlay.ZIndex = 0
screenOverlay.Visible = false
screenOverlay.Parent = gui

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 15, 0.25, 0)
openBtn.Text = "🇻🇳"
openBtn.BackgroundColor3 = Theme.MainBg
openBtn.BackgroundTransparency = 0.25
openBtn.TextColor3 = Theme.Brand
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 19
openBtn.ZIndex = 10
openBtn.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn

local openStroke = Instance.new("UIStroke")
openStroke.Color = Theme.Brand
openStroke.Thickness = 1.8
openStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
openStroke.Parent = openBtn

local function clickAnimate(obj)
    local scale = Instance.new("UIScale")
    scale.Parent = obj
    TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.92}):Play()
    task.wait(0.1)
    TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
    task.delay(0.3, function()
        if scale and scale.Parent then
            scale:Destroy()
        end
    end)
end

local btnDragToggle = false
local btnDragStart = nil
local btnStartPos = nil

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragToggle = true
        btnDragStart = input.Position
        btnStartPos = openBtn.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if btnDragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        openBtn.Position = UDim2.new(
            btnStartPos.X.Scale,
            btnStartPos.X.Offset + (input.Position.X - btnDragStart.X),
            btnStartPos.Y.Scale,
            btnStartPos.Y.Offset + (input.Position.Y - btnDragStart.Y)
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragToggle = false
    end
end)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 305)
frame.Position = UDim2.new(0.5, -175, 0.5, -152)
frame.BackgroundColor3 = Theme.MainBg
frame.BackgroundTransparency = 0.05
frame.ZIndex = 10
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Theme.Stroke
frameStroke.Thickness = 1.8
frameStroke.Parent = frame
table.insert(RGBElements, {Type = "Frame", Stroke = frameStroke})

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 32)
header.BackgroundColor3 = Theme.HeaderBg
header.BackgroundTransparency = 0
header.BorderSizePixel = 0
header.ZIndex = 10
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0, 10)
headerCover.Position = UDim2.new(0, 0, 1, -10)
headerCover.BackgroundColor3 = Theme.HeaderBg
headerCover.BorderSizePixel = 0
headerCover.ZIndex = 10
headerCover.Parent = header

local headerStroke = Instance.new("UIStroke")
headerStroke.Color = Theme.Stroke
headerStroke.Thickness = 1.2
headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
headerStroke.Parent = header
table.insert(RGBElements, {Type = "Header", Stroke = headerStroke})

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MENU VIP PRO MAX"
titleLabel.TextColor3 = Theme.TextTitle
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 13
titleLabel.ZIndex = 10
titleLabel.Parent = header

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 22, 0, 22)
avatarImg.Position = UDim2.new(0, 10, 0.5, -11)
avatarImg.BackgroundTransparency = 1
avatarImg.ZIndex = 10
avatarImg.Parent = header

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImg

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Theme.Brand
avatarStroke.Thickness = 1.2
avatarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
avatarStroke.Parent = avatarImg

task.spawn(function()
    pcall(function()
        avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
end)

local dragToggle = false
local dragStart = nil
local startPos = nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + (input.Position.X - dragStart.X),
            startPos.Y.Scale,
            startPos.Y.Offset + (input.Position.Y - dragStart.Y)
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
    end
end)

-- SCROLLING TAB BAR
local tabBar = Instance.new("ScrollingFrame")
tabBar.Size = UDim2.new(1, 0, 0, 28)
tabBar.Position = UDim2.new(0, 0, 0, 32)
tabBar.BackgroundColor3 = Theme.TabBg
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 10
tabBar.ScrollBarThickness = 0
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.ClipsDescendants = true
tabBar.Parent = frame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabBar

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0)
end)

local function createTab(name, width)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 1, 0)
    btn.Text = name
    btn.BackgroundTransparency = 1
    btn.TextColor3 = Theme.TextDim
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 8
    btn.ZIndex = 10
    btn.Parent = tabBar

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0.5, 0, 0, 2)
    indicator.Position = UDim2.new(0.25, 0, 1, -2)
    indicator.BackgroundColor3 = Theme.Brand
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 10
    indicator.Parent = btn

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator

    return btn, indicator
end

local tab1, ind1 = createTab("THÔNG TIN", 65)
local tab2, ind2 = createTab("TÍNH NĂNG", 65)
local tab3, ind3 = createTab("PLAYER", 55)
local tab4, ind4 = createTab("TIỆN ÍCH", 58)
local tab5, ind5 = createTab("NHẠC ID", 55)
local tab6, ind6 = createTab("TP SAVE", 58)
local tab7, ind7 = createTab("TP PLAYER", 65)
local tab8, ind8 = createTab("AUTO SKILL", 68)
local tab9, ind9 = createTab("CẤU HÌNH", 65)

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1, 0, 1, -62)
pageContainer.Position = UDim2.new(0, 0, 0, 61)
pageContainer.BackgroundTransparency = 1
pageContainer.ZIndex = 10
pageContainer.Parent = frame

local function createPage()
    local pg = Instance.new("ScrollingFrame")
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.ScrollBarThickness = 4
    pg.ScrollBarImageColor3 = Theme.Brand
    pg.Visible = false
    pg.BorderSizePixel = 0
    pg.ZIndex = 10
    pg.Parent = pageContainer

    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = pg

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 16)
    pad.Parent = pg

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
    end)

    return pg
end

local page1 = createPage()
local page2 = createPage()
local page3 = createPage()
local page4 = createPage()
local page8 = createPage()
local page9 = createPage()

local page5 = Instance.new("Frame")
page5.Size = UDim2.new(1, 0, 1, 0)
page5.BackgroundTransparency = 1
page5.Visible = false
page5.ZIndex = 10
page5.Parent = pageContainer

local l5 = Instance.new("UIListLayout")
l5.HorizontalAlignment = Enum.HorizontalAlignment.Center
l5.Padding = UDim.new(0, 6)
l5.SortOrder = Enum.SortOrder.LayoutOrder
l5.Parent = page5

local pad5 = Instance.new("UIPadding")
pad5.PaddingTop = UDim.new(0, 6)
pad5.Parent = page5

local page6 = Instance.new("Frame")
page6.Size = UDim2.new(1, 0, 1, 0)
page6.BackgroundTransparency = 1
page6.Visible = false
page6.ZIndex = 10
page6.Parent = pageContainer

local l6 = Instance.new("UIListLayout")
l6.HorizontalAlignment = Enum.HorizontalAlignment.Center
l6.Padding = UDim.new(0, 6)
l6.SortOrder = Enum.SortOrder.LayoutOrder
l6.Parent = page6

local pad6 = Instance.new("UIPadding")
pad6.PaddingTop = UDim.new(0, 6)
pad6.Parent = page6

local page7 = Instance.new("Frame")
page7.Size = UDim2.new(1, 0, 1, 0)
page7.BackgroundTransparency = 1
page7.Visible = false
page7.ZIndex = 10
page7.Parent = pageContainer

local l7 = Instance.new("UIListLayout")
l7.HorizontalAlignment = Enum.HorizontalAlignment.Center
l7.Padding = UDim.new(0, 5)
l7.SortOrder = Enum.SortOrder.LayoutOrder
l7.Parent = page7

local pad7 = Instance.new("UIPadding")
pad7.PaddingTop = UDim.new(0, 5)
pad7.Parent = page7

local function showTab(pg, tb, ind)
    for _, p in pairs({page1, page2, page3, page4, page5, page6, page7, page8, page9}) do
        p.Visible = false
    end
    for _, t in pairs({tab1, tab2, tab3, tab4, tab5, tab6, tab7, tab8, tab9}) do
        t.TextColor3 = Theme.TextDim
    end
    for _, i in pairs({ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8, ind9}) do
        i.Visible = false
    end
    pg.Visible = true
    tb.TextColor3 = Theme.TextTitle
    ind.Visible = true
    ind.Size = UDim2.new(0, 0, 0, 2)
    TweenService:Create(ind, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, 0, 0, 2)}):Play()
end

tab1.MouseButton1Click:Connect(function()
    showTab(page1, tab1, ind1)
end)
tab2.MouseButton1Click:Connect(function()
    showTab(page2, tab2, ind2)
end)
tab3.MouseButton1Click:Connect(function()
    showTab(page3, tab3, ind3)
end)
tab4.MouseButton1Click:Connect(function()
    showTab(page4, tab4, ind4)
end)
tab5.MouseButton1Click:Connect(function()
    showTab(page5, tab5, ind5)
end)
tab6.MouseButton1Click:Connect(function()
    showTab(page6, tab6, ind6)
end)
tab7.MouseButton1Click:Connect(function()
    showTab(page7, tab7, ind7)
end)
tab8.MouseButton1Click:Connect(function()
    showTab(page8, tab8, ind8)
end)
tab9.MouseButton1Click:Connect(function()
    showTab(page9, tab9, ind9)
end)

showTab(page1, tab1, ind1)

local opened = true
openBtn.MouseButton1Click:Connect(function()
    clickAnimate(openBtn)
    opened = not opened
    if not State.RGB then
        openStroke.Color = opened and Theme.AccentOff or Theme.Brand
        TweenService:Create(openStroke, TweenInfo.new(0.3), {Color = opened and Theme.AccentOff or Theme.Brand}):Play()
    end
    frame:TweenPosition(
        opened and UDim2.new(0.5, -175, 0.5, -152) or UDim2.new(0.5, -175, 1.2, 0),
        "Out",
        "Back",
        0.45
    )
end)

local function getUniversalRoot(char)
    if not char then
        return nil
    end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
        or char.PrimaryPart
        or char:FindFirstChildWhichIsA("BasePart")
end

local function createDivider(parent, text)
    local dFrame = Instance.new("Frame")
    dFrame.Size = UDim2.new(0.92, 0, 0, 15)
    dFrame.BackgroundTransparency = 1
    dFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "─── " .. text .. " ───"
    label.TextColor3 = Theme.Brand
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.Parent = dFrame

    return dFrame
end

local function createCycleBtn(parent, prefix, options, stateVar)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0.92, 0, 0, 32)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = Theme.ItemBg
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 10
    btn.Parent = btnFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Brand
    stroke.Thickness = 1.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = Theme.Brand})

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Theme.Brand
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.ZIndex = 10
    title.Parent = btn

    local function updateText()
        local item = options[State[stateVar]] or options[1]
        title.Text = prefix .. " < " .. item.Name .. " >"
    end
    updateText()

    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn)
        State[stateVar] = State[stateVar] + 1
        if State[stateVar] > #options then
            State[stateVar] = 1
        end
        updateText()
        if State.AutoSave then
            saveConfig()
        end
    end)

    return btnFrame
end

local function createToggle(parent, text, varName, callback)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0.92, 0, 0, 34)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 10
    btn.Parent = btnFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.2
    stroke.Parent = btn

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.74, 0, 1, 0)
    title.Position = UDim2.new(0.04, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Theme.TextTitle
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 11.5
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 10
    title.Parent = btn

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.18, 0, 1, 0)
    status.Position = UDim2.new(0.78, 0, 0, 0)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.GothamBold
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Right
    status.ZIndex = 10
    status.Parent = btn

    local active = State[varName] or false
    status.Text = active and "ON" or "OFF"
    status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
    stroke.Color = active and Theme.AccentOn or Theme.Stroke
    btn.BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg

    table.insert(RGBElements, {
        Type = "Toggle",
        Stroke = stroke,
        State = function()
            return State[varName]
        end
    })

    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn)
        State[varName] = not State[varName]
        active = State[varName]
        status.Text = active and "ON" or "OFF"
        TweenService:Create(status, TweenInfo.new(0.2), {TextColor3 = active and Theme.AccentOn or Theme.AccentOff}):Play()
        if not State.RGB then
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = active and Theme.AccentOn or Theme.Stroke}):Play()
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg}):Play()
        if varName ~= "AutoSave" then
            if active then
                MakeToast("Đã Bật", text, Theme.AccentOn)
            else
                MakeToast("Đã Tắt", text, Theme.AccentOff)
            end
            if State.AutoSave then
                saveConfig()
            end
        end
        if callback then
            callback(active)
        end
    end)

    if active and callback then
        task.spawn(callback, active)
    end

    return btnFrame
end

local function createButton(parent, text, color, callback)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0.92, 0, 0, 32)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = Theme.ItemBg
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 10
    btn.Parent = btnFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = color})

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = color
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11.5
    title.ZIndex = 10
    title.Parent = btn

    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn)
        if not State.RGB then
            TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play()
        end
        task.wait(0.15)
        if not State.RGB then
            TweenService:Create(stroke, TweenInfo.new(0.3), {Color = color}):Play()
        end
        MakeToast("Đã thực thi", text, color)
        callback()
    end)

    return btnFrame
end

local function createDualButtons(parent, text1, color1, cb1, text2, color2, cb2)
    local dFrame = Instance.new("Frame")
    dFrame.Size = UDim2.new(0.92, 0, 0, 32)
    dFrame.BackgroundTransparency = 1
    dFrame.Parent = parent

    local function makeBtn(xPos, txt, col, cb)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.485, 0, 1, 0)
        btn.Position = UDim2.new(xPos, 0, 0, 0)
        btn.BackgroundColor3 = Theme.ItemBg
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10
        btn.Parent = dFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = col
        stroke.Thickness = 1.2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn
        table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = col})

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = txt
        title.TextColor3 = col
        title.Font = Enum.Font.GothamBold
        title.TextSize = 10
        title.ZIndex = 10
        title.Parent = btn

        btn.MouseButton1Click:Connect(function()
            clickAnimate(btn)
            if not State.RGB then
                TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play()
            end
            task.wait(0.15)
            if not State.RGB then
                TweenService:Create(stroke, TweenInfo.new(0.3), {Color = col}):Play()
            end
            if txt ~= "🗑️ XÓA TẤT CẢ" then
                MakeToast("Đã thực thi", txt, col)
            end
            cb()
        end)
    end

    makeBtn(0, text1, color1, cb1)
    makeBtn(0.515, text2, color2, cb2)

    return dFrame
end

local function createSlider(parent, text, min, max, varName, callback)
    local sFrame = Instance.new("Frame")
    sFrame.Size = UDim2.new(0.92, 0, 0, 38)
    sFrame.BackgroundTransparency = 1
    sFrame.Parent = parent

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.ItemBg
    bg.ZIndex = 10
    bg.Parent = sFrame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = bg

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Stroke
    stroke.Thickness = 1.2
    stroke.Parent = bg
    table.insert(RGBElements, {Type = "Slider", Stroke = stroke})

    local sTitle = Instance.new("TextLabel")
    sTitle.Size = UDim2.new(0.7, 0, 0.45, 0)
    sTitle.Position = UDim2.new(0.04, 0, 0.08, 0)
    sTitle.BackgroundTransparency = 1
    sTitle.Text = text
    sTitle.TextColor3 = Theme.TextDim
    sTitle.Font = Enum.Font.GothamSemibold
    sTitle.TextSize = 11
    sTitle.TextXAlignment = Enum.TextXAlignment.Left
    sTitle.ZIndex = 10
    sTitle.Parent = bg

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.25, 0, 0.45, 0)
    valLabel.Position = UDim2.new(0.71, 0, 0.08, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(State[varName])
    valLabel.TextColor3 = Theme.Brand
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 11
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.ZIndex = 10
    valLabel.Parent = bg

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.92, 0, 0.18, 0)
    track.Position = UDim2.new(0.04, 0, 0.64, 0)
    track.BackgroundColor3 = Theme.MainBg
    track.ZIndex = 10
    track.Parent = bg

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp((State[varName] - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = Theme.AccentOn
    fill.ZIndex = 10
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        valLabel.Text = tostring(value)
        TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        State[varName] = value
        if callback then
            callback(value)
        end
        if State.AutoSave then
            saveConfig()
        end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    if callback then
        task.spawn(callback, State[varName])
    end

    return sFrame
end

task.spawn(function()
    while task.wait(0.05) do
        if State.RGB then
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            titleLabel.TextColor3 = color
            frameStroke.Color = color
            headerStroke.Color = color
            avatarStroke.Color = color
            openStroke.Color = color
            for _, obj in pairs(RGBElements) do
                if obj.Stroke and obj.Stroke.Parent then
                    obj.Stroke.Color = color
                end
            end
        end
    end
end)

-- ==========================================
-- [TAB 1: THÔNG TIN - TÁCH TỪNG DÒNG RIÊNG BIỆT]
-- ==========================================
local function createInfoBox(parent, icon, titleText, heightOffset)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(0.92, 0, 0, heightOffset or 90)
    item.BackgroundColor3 = Theme.ItemBg
    item.ZIndex = 10
    item.Parent = parent

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 8)
    itemCorner.Parent = item

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Stroke
    stroke.Thickness = 1.2
    stroke.Parent = item
    table.insert(RGBElements, {Type = "Info", Stroke = stroke})

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 0, 20)
    title.Position = UDim2.new(0, 8, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = icon .. " " .. titleText
    title.TextColor3 = Theme.Brand
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 10
    title.Parent = item

    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -16, 1, -26)
    content.Position = UDim2.new(0, 8, 0, 24)
    content.BackgroundTransparency = 1
    content.Text = "Đang tải..."
    content.TextColor3 = Theme.TextTitle
    content.Font = Enum.Font.Gotham
    content.TextSize = 10.5
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.RichText = true
    content.ZIndex = 10
    content.Parent = item

    return content, item
end

local playerInfoLabel = createInfoBox(page1, "👤", "THÔNG TIN NHÂN VẬT", 104)
local serverInfoLabel, serverInfoFrame = createInfoBox(page1, "🌐", "THÔNG TIN MÁY CHỦ", 90)

local copyIdBtn = Instance.new("TextButton")
copyIdBtn.Size = UDim2.new(0, 22, 0, 22)
copyIdBtn.Position = UDim2.new(1, -26, 1, -24)
copyIdBtn.Text = "📜"
copyIdBtn.BackgroundTransparency = 1
copyIdBtn.TextSize = 13
copyIdBtn.ZIndex = 11
copyIdBtn.Parent = serverInfoFrame

copyIdBtn.MouseButton1Click:Connect(function()
    clickAnimate(copyIdBtn)
    pcall(function()
        if setclipboard then
            setclipboard(tostring(game.JobId))
            MakeToast("Đã Copy", "Đã lưu ID Server vào bộ nhớ tạm", Theme.AccentOn)
            local oldText = copyIdBtn.Text
            copyIdBtn.Text = "✅"
            task.wait(1)
            copyIdBtn.Text = oldText
        end
    end)
end)

local joinIdFrame = Instance.new("Frame")
joinIdFrame.Size = UDim2.new(0.92, 0, 0, 34)
joinIdFrame.BackgroundColor3 = Theme.ItemBg
joinIdFrame.ZIndex = 10
joinIdFrame.Parent = page1

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = joinIdFrame

local jStroke = Instance.new("UIStroke")
jStroke.Color = Theme.Stroke
jStroke.Thickness = 1.2
jStroke.Parent = joinIdFrame
table.insert(RGBElements, {Type = "Info", Stroke = jStroke})

local idBox = Instance.new("TextBox")
idBox.Size = UDim2.new(0.65, 0, 1, 0)
idBox.Position = UDim2.new(0.04, 0, 0, 0)
idBox.BackgroundTransparency = 1
idBox.PlaceholderText = "Dán ID Server vào đây..."
idBox.Text = ""
idBox.TextColor3 = Theme.Brand
idBox.Font = Enum.Font.Gotham
idBox.TextSize = 10.5
idBox.TextXAlignment = Enum.TextXAlignment.Left
idBox.ClearTextOnFocus = false
idBox.ZIndex = 10
idBox.Parent = joinIdFrame

local joinBtn = Instance.new("TextButton")
joinBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
joinBtn.Position = UDim2.new(0.72, 0, 0.15, 0)
joinBtn.BackgroundColor3 = Theme.AccentOn
joinBtn.Text = "VÀO"
joinBtn.TextColor3 = Color3.new(1, 1, 1)
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 10.5
joinBtn.ZIndex = 10
joinBtn.Parent = joinIdFrame

local joinBtnCorner = Instance.new("UICorner")
joinBtnCorner.CornerRadius = UDim.new(0, 6)
joinBtnCorner.Parent = joinBtn

joinBtn.MouseButton1Click:Connect(function()
    clickAnimate(joinBtn)
    local targetId = idBox.Text:gsub("%s+", "")
    if targetId ~= "" then
        MakeToast("Đang Join", "Đang chuyển máy chủ...", Theme.AccentOn)
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player)
        end)
    end
end)

local extraInfoLabel = createInfoBox(page1, "⚙️", "TRẠNG THÁI", 78)
local fps = 0
RunService.RenderStepped:Connect(function(dt)
    fps = math.floor(1 / dt)
end)

task.spawn(function()
    while task.wait(0.5) do
        local hp = 0
        local maxHp = 0
        local ws = 0
        local jp = 0
        local coords = "0, 0, 0"

        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            hp = math.floor(hum.Health)
            maxHp = math.floor(hum.MaxHealth)
            ws = math.floor(hum.WalkSpeed)
            jp = math.floor(hum.JumpPower)
        end

        if player.Character then
            local root = getUniversalRoot(player.Character)
            if root then
                local pos = root.Position
                coords = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            end
        end

        playerInfoLabel.Text = string.format(
            "<font color='#FF00FF'>Tên:</font> %s (@%s)\n<font color='#FF00FF'>Máu:</font> %d / %d\n<font color='#FF00FF'>Tốc độ:</font> %d\n<font color='#FF00FF'>Lực nhảy:</font> %d\n<font color='#FF00FF'>Tọa độ:</font> %s",
            player.DisplayName,
            player.Name,
            hp,
            maxHp,
            ws,
            jp,
            coords
        )

        local ping = "0"
        pcall(function()
            local stats = game:GetService("Stats")
            if stats and stats:FindFirstChild("Network") and stats.Network:FindFirstChild("ServerStatsItem") then
                ping = stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            else
                ping = tostring(math.floor(player:GetNetworkPing() * 1000)) .. " ms"
            end
        end)

        local pCount = #Players:GetPlayers()
        local maxP = Players.MaxPlayers
        local jobText = game.JobId ~= "" and string.sub(game.JobId, 1, 14) .. "..." or "N/A"

        serverInfoLabel.Text = string.format(
            "<font color='#FF00FF'>FPS:</font> %d\n<font color='#FF00FF'>Ping:</font> %s\n<font color='#FF00FF'>Người chơi:</font> %d / %d\n<font color='#FF00FF'>ID SV:</font> %s",
            fps,
            ping,
            pCount,
            maxP,
            jobText
        )

        local execTime = math.floor(workspace.DistributedGameTime)
        local hours = math.floor(execTime / 3600)
        local mins = math.floor((execTime % 3600) / 60)
        local secs = execTime % 60

        extraInfoLabel.Text = string.format(
            "<font color='#FF00FF'>Thời gian chơi:</font> %02d:%02d:%02d\n<font color='#FF00FF'>Giờ hệ thống:</font> %s\n<font color='#FF00FF'>Phiên bản:</font> VIP PRO MAX V1.13.3",
            hours,
            mins,
            secs,
            os.date("%H:%M:%S")
        )
    end
end)

-- ==========================================
-- [TAB 2: TÍNH NĂNG]
-- ==========================================
createToggle(page2, "🛡️ Chống ngã & Chống văng xa", "AntiStun")

createToggle(page2, "🔒 Khóa vị trí", "LockPosition", function(v)
    if not v and player.Character then
        local r = getUniversalRoot(player.Character)
        if r then
            r.Anchored = false
        end
    end
end)

createToggle(page2, "🚀 Nhảy trên không", "InfJump")
UIS.JumpRequest:Connect(function()
    if State.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

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
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end)
    end
end)

local xrayTick = 0
createToggle(page2, "👀 Nhìn xuyên map (xray)", "XRay", function(v)
    xrayTick = xrayTick + 1
    local currentTick = xrayTick
    task.spawn(function()
        if v then
            for i, obj in ipairs(workspace:GetDescendants()) do
                if currentTick ~= xrayTick then
                    return
                end
                if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) and obj.Name ~= "Terrain" and obj.Transparency < 1 then
                    if not xrayMats[obj] then
                        xrayMats[obj] = obj.Transparency
                    end
                    obj.Transparency = 0.5
                end
                if i % 300 == 0 then
                    task.wait()
                end
            end
        else
            local count = 0
            for obj, origTrans in pairs(xrayMats) do
                if currentTick ~= xrayTick then
                    return
                end
                if obj and obj.Parent then
                    obj.Transparency = origTrans
                end
                count = count + 1
                if count % 300 == 0 then
                    task.wait()
                end
            end
            if currentTick == xrayTick then
                xrayMats = {}
            end
        end
    end)
end)

createToggle(page2, "🔴 ESP người chơi", "ESP")

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
            if root and root:FindFirstChild("FlyBodyVelocity") then
                root.FlyBodyVelocity:Destroy()
            end
            if root and root:FindFirstChild("FlyBodyGyro") then
                root.FlyBodyGyro:Destroy()
            end
            if hum then
                hum.PlatformStand = false
            end
        end
    end
end)
createSlider(page3, "Tốc độ bay", 10, 1000, "FlySpeed")

createToggle(page3, "🏃 Chạy nhanh", "Speed")
createSlider(page3, "Tốc độ chạy", 1, 1000, "SpeedValue")

local defaultJumpPower = 50
createToggle(page3, "🦘 Nhảy cao", "Jump", function(v)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if v then
            defaultJumpPower = player.Character.Humanoid.JumpPower
        else
            player.Character.Humanoid.UseJumpPower = true
            player.Character.Humanoid.JumpPower = defaultJumpPower
        end
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

createToggle(page3, "💡 Ánh sáng quanh người", "PlayerLight", function(v)
    if not v and player.Character then
        local root = getUniversalRoot(player.Character)
        if root then
            local light = root:FindFirstChild("PlayerPointLight")
            if light then
                light:Destroy()
            end
        end
    end
end)
createSlider(page3, "Phạm vi sáng (Max 60)", 0, 60, "LightRange")
createSlider(page3, "Độ sáng", 0, 5, "LightBrightness")
createCycleBtn(page3, "🎨 Đổi màu:", PlayerLightColors, "LightColorIdx")

-- ==========================================
-- [TAB 4: TIỆN ÍCH]
-- ==========================================
createToggle(page4, "💾 Lưu Cài Đặt", "AutoSave", function(v)
    if v then
        saveConfig()
        MakeToast("Đã Bật", "Đã lưu cấu hình hiện tại!", Theme.AccentOn)
    else
        pcall(function()
            if isfile and isfile(configFileName) then
                delfile(configFileName)
            end
        end)
        MakeToast("Đã Tắt", "Đã xóa cấu hình cũ!", Theme.AccentOff)
    end
end)

createToggle(page4, "🌈 Chế độ RGB", "RGB", function(v)
    if not v then
        titleLabel.TextColor3 = Theme.TextTitle
        frameStroke.Color = Theme.Stroke
        headerStroke.Color = Theme.Stroke
        avatarStroke.Color = Theme.Brand
        openStroke.Color = opened and Theme.AccentOff or Theme.Brand
        for _, obj in pairs(RGBElements) do
            if obj.Stroke and obj.Stroke.Parent then
                if obj.Type == "Toggle" then
                    obj.Stroke.Color = obj.State() and Theme.AccentOn or Theme.Stroke
                elseif obj.Type == "Button" then
                    obj.Stroke.Color = obj.DefaultColor
                elseif obj.Type == "Slider" or obj.Type == "Info" or obj.Type == "Container" then
                    obj.Stroke.Color = Theme.Stroke
                end
            end
        end
    end
end)

createToggle(page4, "💫 Mở khóa ShiftLock Mobile", "ShiftLock", function(v)
    pcall(function()
        player.DevEnableMouseLock = v
    end)
end)

createToggle(page4, "🖱️ Auto Click", "AutoClick")
task.spawn(function()
    while task.wait(0.1) do
        if State.AutoClick and player.Character then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
        end
    end
end)

createToggle(page4, "🛡️ Chống AFK (Antiafk)", "AntiAfk")

player.Idled:Connect(function()
    if State.AntiAfk then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.5)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

local function hopServer(sortOrder)
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=100"
    local function getServers(cursor)
        local url = api .. (cursor and "&cursor=" .. cursor or "")
        local success, res = pcall(function()
            return game:HttpGet(url)
        end)
        if success then
            return HttpService:JSONDecode(res)
        end
    end
    local nextCursor = nil
    local targetServer = nil
    repeat
        local data = getServers(nextCursor)
        if not data or not data.data then
            break
        end
        for _, s in pairs(data.data) do
            if s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
                if sortOrder == "Asc" then
                    if s.playing > 0 then
                        targetServer = s
                        break
                    end
                else
                    targetServer = s
                    break
                end
            end
        end
        if targetServer then
            break
        end
        nextCursor = data.nextPageCursor
    until not nextCursor
    if targetServer then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, player)
    end
end

local function rejoinServer()
    if #Players:GetPlayers() <= 1 then
        player:Kick("\nĐang vào lại server...")
        task.wait()
        TeleportService:Teleport(game.PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end

-- Nút Trời Sáng & Trời Tối
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

createDualButtons(
    page4,
    "🔄 VÀO LẠI SV",
    Theme.AccentOn,
    rejoinServer,
    "🎲 ĐỔI SV NGẪU NHIÊN",
    Theme.Brand,
    function()
        hopServer("Desc")
    end
)

createDualButtons(
    page4,
    "📉 ĐỔI SV ÍT NGƯỜI",
    Color3.fromRGB(52, 152, 219),
    function()
        hopServer("Asc")
    end,
    "📈 ĐỔI SV NHIỀU NGƯỜI",
    Color3.fromRGB(231, 76, 60),
    function()
        hopServer("Desc")
    end
)

-- Lệnh Admin & TP SAVE
createDualButtons(
    page4,
    "💻 LỆNH ADMIN",
    Theme.AccentOn,
    function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
    end,
    "📁 TP SAVE",
    Theme.Brand,
    function()
        pcall(function()
            -- menu save vị trí
            loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip13/refs/heads/main/menu-save.lua"))()
        end)
    end
)

-- FLY V1 & FLY V3 (Mỗi lệnh tách dòng riêng để không bị xóa nhầm end)
createDualButtons(
    page4,
    "🕊️ FLY V1",
    Theme.Brand,
    function()
        pcall(function()
            loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
        end)
    end,
    "🕊️ FLY V3",
    Theme.Brand,
    function()
        pcall(function()
            -- menu fly v3
            loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip/refs/heads/main/menu-fly.lua"))()
        end)
    end
)

-- Ô nút mới: TP PLAYS (người chơi)
createButton(
    page4,
    "🎯 TP PLAYS (người chơi)",
    Theme.AccentOn,
    function()
        pcall(function()
            -- menu players người chơi
            loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/hack.lua/refs/heads/main/menu-tp-play.lua"))()
        end)
    end
)

-- ==========================================
-- [TAB 5: NHẠC ID] & [TAB 6: TP SAVE]
-- ==========================================
local currentSound = nil
local currentMusicId = ""
local savedMusicList = {}

local musicControlFrame = Instance.new("Frame")
musicControlFrame.Size = UDim2.new(0.92, 0, 0, 62)
musicControlFrame.BackgroundColor3 = Theme.ItemBg
musicControlFrame.ZIndex = 10
musicControlFrame.LayoutOrder = 1
musicControlFrame.Parent = page5

local musicCorner = Instance.new("UICorner")
musicCorner.CornerRadius = UDim.new(0, 8)
musicCorner.Parent = musicControlFrame

local mStroke = Instance.new("UIStroke")
mStroke.Color = Theme.Stroke
mStroke.Thickness = 1.2
mStroke.Parent = musicControlFrame
table.insert(RGBElements, {Type = "Info", Stroke = mStroke})

local musicIcon = Instance.new("TextLabel")
musicIcon.Size = UDim2.new(0.12, 0, 0, 30)
musicIcon.BackgroundTransparency = 1
musicIcon.Text = "🎼"
musicIcon.TextSize = 15
musicIcon.ZIndex = 10
musicIcon.Parent = musicControlFrame

local musicIdBox = Instance.new("TextBox")
musicIdBox.Size = UDim2.new(0.66, 0, 0, 30)
musicIdBox.Position = UDim2.new(0.12, 0, 0, 0)
musicIdBox.BackgroundTransparency = 1
musicIdBox.PlaceholderText = "Nhập ID Nhạc..."
musicIdBox.Text = ""
musicIdBox.TextColor3 = Theme.TextTitle
musicIdBox.Font = Enum.Font.GothamSemibold
musicIdBox.TextSize = 11
musicIdBox.TextXAlignment = Enum.TextXAlignment.Left
musicIdBox.ClearTextOnFocus = false
musicIdBox.ZIndex = 10
musicIdBox.Parent = musicControlFrame

local saveIdBtn = Instance.new("TextButton")
saveIdBtn.Size = UDim2.new(0.22, 0, 0, 30)
saveIdBtn.Position = UDim2.new(0.78, 0, 0, 0)
saveIdBtn.BackgroundTransparency = 1
saveIdBtn.Text = "💾 Lưu"
saveIdBtn.TextColor3 = Theme.AccentOn
saveIdBtn.Font = Enum.Font.GothamBold
saveIdBtn.TextSize = 10.5
saveIdBtn.ZIndex = 10
saveIdBtn.Parent = musicControlFrame

local divLine = Instance.new("Frame")
divLine.Size = UDim2.new(0.92, 0, 0, 1)
divLine.Position = UDim2.new(0.04, 0, 0, 30)
divLine.BackgroundColor3 = Theme.Stroke
divLine.BorderSizePixel = 0
divLine.ZIndex = 10
divLine.Parent = musicControlFrame

local nowPlayingLabel = Instance.new("TextLabel")
nowPlayingLabel.Size = UDim2.new(0.92, 0, 0, 30)
nowPlayingLabel.Position = UDim2.new(0.04, 0, 0, 31)
nowPlayingLabel.BackgroundTransparency = 1
nowPlayingLabel.RichText = true
nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Chưa có nhạc phát</font>"
nowPlayingLabel.Font = Enum.Font.GothamSemibold
nowPlayingLabel.TextSize = 11
nowPlayingLabel.TextWrapped = true
nowPlayingLabel.ZIndex = 10
nowPlayingLabel.Parent = musicControlFrame

local function getSongName(id)
    local numId = tonumber(id)
    if not numId then
        return "ID sai!"
    end
    local s, info = pcall(function()
        return MarketplaceService:GetProductInfo(numId)
    end)
    if s and info then
        return info.Name
    else
        return "Ẩn danh"
    end
end

local function playMusic(id)
    if currentSound then
        currentSound:Destroy()
    end
    local soundId = tostring(id):match("%d+")
    if not soundId or soundId == "" then
        return
    end
    currentMusicId = soundId
    nowPlayingLabel.Text = "<font color='#FFFFFF'>⏳ Tải...</font>"
    task.spawn(function()
        local name = getSongName(soundId)
        if currentMusicId == soundId then
            nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Phát:</font> <font color='#FFFF00'>" .. name .. "</font>"
        end
    end)
    currentSound = Instance.new("Sound")
    currentSound.SoundId = "rbxassetid://" .. soundId
    currentSound.Volume = State.MusicVolume
    currentSound.Parent = workspace
    currentSound.Ended:Connect(function()
        if #savedMusicList > 0 then
            local cx = 0
            for i, v in ipairs(savedMusicList) do
                if v.id == currentMusicId then
                    cx = i
                    break
                end
            end
            local nx = cx + 1
            if nx > #savedMusicList then
                nx = 1
            end
            playMusic(savedMusicList[nx].id)
        end
    end)
    currentSound:Play()
end

local function stopMusic()
    if currentSound then
        currentSound:Stop()
        currentSound:Destroy()
        currentSound = nil
        currentMusicId = ""
        nowPlayingLabel.Text = "<font color='#FFFFFF'>⏹ Đã dừng nhạc</font>"
    end
end

local playControlFrame = createDualButtons(
    page5,
    "▶️ PHÁT NHẠC",
    Theme.AccentOn,
    function()
        playMusic(musicIdBox.Text)
    end,
    "⏸️ TẮT NHẠC",
    Theme.AccentOff,
    function()
        stopMusic()
    end
)
playControlFrame.LayoutOrder = 2

local volumeFrame = createSlider(page5, "ÂM LƯỢNG 🔊", 0, 10, "MusicVolume", function(val)
    if currentSound then
        currentSound.Volume = val
    end
end)
volumeFrame.LayoutOrder = 3

local savedMusicContent = Instance.new("ScrollingFrame")
savedMusicContent.Size = UDim2.new(0.92, 0, 1, -155)
savedMusicContent.BackgroundTransparency = 1
savedMusicContent.ScrollBarThickness = 4
savedMusicContent.ScrollBarImageColor3 = Theme.Brand
savedMusicContent.BorderSizePixel = 0
savedMusicContent.ZIndex = 10
savedMusicContent.LayoutOrder = 4
savedMusicContent.Parent = page5

local sLayout = Instance.new("UIListLayout")
sLayout.SortOrder = Enum.SortOrder.LayoutOrder
sLayout.Padding = UDim.new(0, 5)
sLayout.Parent = savedMusicContent

sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    savedMusicContent.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 12)
end)

local fileName = "MenuVipProMax_SavedMusic.json"
pcall(function()
    if isfile and isfile(fileName) then
        local decoded = HttpService:JSONDecode(readfile(fileName))
        if type(decoded) == "table" then
            savedMusicList = decoded
        end
    end
end)

local function saveMusicData()
    pcall(function()
        if writefile then
            writefile(fileName, HttpService:JSONEncode(savedMusicList))
        end
    end)
end

local function renderSavedMusic()
    for _, child in pairs(savedMusicContent:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    for i, data in ipairs(savedMusicList) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, -6, 0, 36)
        item.BackgroundColor3 = Theme.ItemBg
        item.ZIndex = 10
        item.Parent = savedMusicContent

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = item

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.Stroke
        stroke.Thickness = 1.2
        stroke.Parent = item
        table.insert(RGBElements, {Type = "Info", Stroke = stroke})

        local nameBox = Instance.new("TextBox")
        nameBox.Size = UDim2.new(0.54, 0, 1, 0)
        nameBox.Position = UDim2.new(0.05, 0, 0, 0)
        nameBox.Text = data.name
        nameBox.TextColor3 = Theme.TextTitle
        nameBox.Font = Enum.Font.GothamSemibold
        nameBox.TextSize = 10.5
        nameBox.BackgroundTransparency = 1
        nameBox.TextXAlignment = Enum.TextXAlignment.Left
        nameBox.ClearTextOnFocus = false
        nameBox.ZIndex = 10
        nameBox.Parent = item

        nameBox.FocusLost:Connect(function()
            if nameBox.Text ~= "" then
                data.name = nameBox.Text
                saveMusicData()
            else
                nameBox.Text = data.name
            end
        end)

        local playBtn = Instance.new("TextButton")
        playBtn.Size = UDim2.new(0.18, 0, 0.65, 0)
        playBtn.Position = UDim2.new(0.62, 0, 0.175, 0)
        playBtn.Text = "▶️"
        playBtn.BackgroundColor3 = Theme.Brand
        playBtn.TextColor3 = Color3.new(1, 1, 1)
        playBtn.Font = Enum.Font.GothamBold
        playBtn.TextSize = 10
        playBtn.ZIndex = 10
        playBtn.Parent = item

        local playCorner = Instance.new("UICorner")
        playCorner.CornerRadius = UDim.new(0, 6)
        playCorner.Parent = playBtn

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0.15, 0, 0.65, 0)
        delBtn.Position = UDim2.new(0.82, 0, 0.175, 0)
        delBtn.Text = "❌"
        delBtn.BackgroundColor3 = Theme.AccentOff
        delBtn.TextColor3 = Color3.new(1, 1, 1)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 10
        delBtn.ZIndex = 10
        delBtn.Parent = item

        local delCorner = Instance.new("UICorner")
        delCorner.CornerRadius = UDim.new(0, 6)
        delCorner.Parent = delBtn

        playBtn.MouseButton1Click:Connect(function()
            clickAnimate(playBtn)
            musicIdBox.Text = data.id
            playMusic(data.id)
        end)

        delBtn.MouseButton1Click:Connect(function()
            clickAnimate(delBtn)
            table.remove(savedMusicList, i)
            saveMusicData()
            renderSavedMusic()
        end)
    end
end

saveIdBtn.MouseButton1Click:Connect(function()
    clickAnimate(saveIdBtn)
    local rawId = musicIdBox.Text:match("%d+")
    if rawId and rawId ~= "" then
        saveIdBtn.Text = "⏳..."
        task.spawn(function()
            local name = getSongName(rawId)
            table.insert(savedMusicList, {id = rawId, name = name})
            saveMusicData()
            renderSavedMusic()
            saveIdBtn.Text = "💾 Lưu"
        end)
    end
end)

renderSavedMusic()

local tpFileName = "MenuVipProMax_SavedTPs.json"
local savedTpList = {}
pcall(function()
    if isfile and isfile(tpFileName) then
        local decoded = HttpService:JSONDecode(readfile(tpFileName))
        if type(decoded) == "table" then
            savedTpList = decoded
        end
    end
end)

local function saveTpData()
    pcall(function()
        if writefile then
            local d = {}
            for _, v in ipairs(savedTpList) do
                if not v.isTemp then
                    table.insert(d, v)
                end
            end
            writefile(tpFileName, HttpService:JSONEncode(d))
        end
    end)
end

local pendingDeleteAll = false
local renderSavedTps

local tpControlFrame_New = createDualButtons(
    page6,
    "📍 LƯU VỊ TRÍ",
    Theme.Brand,
    function()
        if player.Character then
            local root = getUniversalRoot(player.Character)
            if root then
                local cf = {root.CFrame:GetComponents()}
                local mx = 0
                for _, v in ipairs(savedTpList) do
                    local num = string.match(v.name, "Lưu Vị Trí (%d+)")
                    if num then
                        mx = math.max(mx, tonumber(num))
                    end
                end
                table.insert(savedTpList, {
                    name = "Lưu Vị Trí " .. (mx + 1),
                    cframe = cf,
                    isTemp = false
                })
                saveTpData()
                renderSavedTps()
            end
        end
    end,
    "🗑️ XÓA TẤT CẢ",
    Theme.AccentOff,
    function()
        if not pendingDeleteAll then
            pendingDeleteAll = true
            MakeToast("⚠️ CẢNH BÁO", "Ấn lần nữa để xác nhận xóa sạch!", Theme.AccentOff)
            task.delay(3, function()
                pendingDeleteAll = false
            end)
        else
            savedTpList = {}
            saveTpData()
            renderSavedTps()
            MakeToast("Thành công", "Đã xóa toàn bộ!", Theme.Brand)
            pendingDeleteAll = false
        end
    end
)
tpControlFrame_New.LayoutOrder = 1

local savedTpContent = Instance.new("ScrollingFrame")
savedTpContent.Size = UDim2.new(0.92, 0, 1, -48)
savedTpContent.BackgroundTransparency = 1
savedTpContent.ScrollBarThickness = 4
savedTpContent.ScrollBarImageColor3 = Theme.Brand
savedTpContent.BorderSizePixel = 0
savedTpContent.ZIndex = 10
savedTpContent.LayoutOrder = 2
savedTpContent.Parent = page6

local tpLayout = Instance.new("UIListLayout")
tpLayout.SortOrder = Enum.SortOrder.LayoutOrder
tpLayout.Padding = UDim.new(0, 5)
tpLayout.Parent = savedTpContent

tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    savedTpContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 12)
end)

renderSavedTps = function()
    for _, child in pairs(savedTpContent:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    for i, data in ipairs(savedTpList) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, -6, 0, 36)
        item.BackgroundColor3 = Theme.ItemBg
        item.ZIndex = 10
        item.Parent = savedTpContent

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = item

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.Stroke
        stroke.Thickness = 1.2
        stroke.Parent = item
        table.insert(RGBElements, {Type = "Info", Stroke = stroke})

        local nameBox = Instance.new("TextBox")
        nameBox.Size = UDim2.new(0.48, 0, 1, 0)
        nameBox.Position = UDim2.new(0.04, 0, 0, 0)
        nameBox.Text = data.name
        nameBox.TextColor3 = Theme.TextTitle
        nameBox.Font = Enum.Font.GothamSemibold
        nameBox.TextSize = 11
        nameBox.BackgroundTransparency = 1
        nameBox.TextXAlignment = Enum.TextXAlignment.Left
        nameBox.ClearTextOnFocus = false
        nameBox.ZIndex = 10
        nameBox.Parent = item

        nameBox.FocusLost:Connect(function()
            if nameBox.Text ~= "" then
                data.name = nameBox.Text
                saveTpData()
            else
                nameBox.Text = data.name
            end
        end)

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0.24, 0, 0.65, 0)
        tpBtn.Position = UDim2.new(0.54, 0, 0.175, 0)
        tpBtn.Text = "TP"
        tpBtn.BackgroundColor3 = Theme.Brand
        tpBtn.TextColor3 = Color3.new(1, 1, 1)
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 10.5
        tpBtn.ZIndex = 10
        tpBtn.Parent = item

        local tpCorner = Instance.new("UICorner")
        tpCorner.CornerRadius = UDim.new(0, 6)
        tpCorner.Parent = tpBtn

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0.15, 0, 0.65, 0)
        delBtn.Position = UDim2.new(0.81, 0, 0.175, 0)
        delBtn.Text = "X"
        delBtn.BackgroundColor3 = Theme.AccentOff
        delBtn.TextColor3 = Color3.new(1, 1, 1)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 11
        delBtn.ZIndex = 10
        delBtn.Parent = item

        local delCorner = Instance.new("UICorner")
        delCorner.CornerRadius = UDim.new(0, 6)
        delCorner.Parent = delBtn

        tpBtn.MouseButton1Click:Connect(function()
            clickAnimate(tpBtn)
            if player.Character then
                local r = getUniversalRoot(player.Character)
                if r then
                    r.CFrame = CFrame.new(unpack(data.cframe))
                    MakeToast("Dịch chuyển", "Đến " .. data.name, Theme.Brand)
                end
            end
        end)

        delBtn.MouseButton1Click:Connect(function()
            clickAnimate(delBtn)
            table.remove(savedTpList, i)
            saveTpData()
            renderSavedTps()
        end)
    end
end
renderSavedTps()

-- ==========================================
-- [TAB 7: TP NGƯỜI CHƠI (TƯ THẾ NẰM NGANG KHI TRÊN ĐẦU / DƯỚI CHÂN)]
-- ==========================================
local targetTpPlayer = nil
local autoTpPlayerEnabled = false
local spectatePlayerEnabled = false
local wasHorizontalTp = false

local function restoreNormalPosture()
    local myChar = player.Character
    if not myChar then
        return
    end
    local myRoot = getUniversalRoot(myChar)
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if myHum then
        myHum.AutoRotate = true
        if not State.Fly and not State.AntiStun then
            myHum.PlatformStand = false
        end
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
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    wasHorizontalTp = false
end

local tpControlCard = Instance.new("Frame")
tpControlCard.Size = UDim2.new(0.94, 0, 0, 86)
tpControlCard.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
tpControlCard.LayoutOrder = 1
tpControlCard.ZIndex = 10
tpControlCard.Parent = page7

local tpCardCorner = Instance.new("UICorner")
tpCardCorner.CornerRadius = UDim.new(0, 8)
tpCardCorner.Parent = tpControlCard

local tpCardStroke = Instance.new("UIStroke")
tpCardStroke.Color = Theme.Brand
tpCardStroke.Thickness = 1.4
tpCardStroke.Parent = tpControlCard
table.insert(RGBElements, {Type = "Button", Stroke = tpCardStroke, DefaultColor = Theme.Brand})

local targetHeaderRow = Instance.new("Frame")
targetHeaderRow.Size = UDim2.new(1, -12, 0, 26)
targetHeaderRow.Position = UDim2.new(0, 6, 0, 4)
targetHeaderRow.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
targetHeaderRow.ZIndex = 10
targetHeaderRow.Parent = tpControlCard

local targetRowCorner = Instance.new("UICorner")
targetRowCorner.CornerRadius = UDim.new(0, 6)
targetRowCorner.Parent = targetHeaderRow

local selectedAvatarImg = Instance.new("ImageLabel")
selectedAvatarImg.Size = UDim2.new(0, 20, 0, 20)
selectedAvatarImg.Position = UDim2.new(0, 5, 0.5, -10)
selectedAvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
selectedAvatarImg.Image = "rbxassetid://0"
selectedAvatarImg.ZIndex = 10
selectedAvatarImg.Parent = targetHeaderRow

local selAvaCorner = Instance.new("UICorner")
selAvaCorner.CornerRadius = UDim.new(1, 0)
selAvaCorner.Parent = selectedAvatarImg

local selAvaStroke = Instance.new("UIStroke")
selAvaStroke.Color = Theme.Brand
selAvaStroke.Thickness = 1
selAvaStroke.Parent = selectedAvatarImg

local targetStatusLabel = Instance.new("TextLabel")
targetStatusLabel.Size = UDim2.new(1, -112, 1, 0)
targetStatusLabel.Position = UDim2.new(0, 30, 0, 0)
targetStatusLabel.BackgroundTransparency = 1
targetStatusLabel.RichText = true
targetStatusLabel.Text = "🎯 <font color='#FF6B81'>Chưa chọn mục tiêu</font>"
targetStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetStatusLabel.Font = Enum.Font.GothamBold
