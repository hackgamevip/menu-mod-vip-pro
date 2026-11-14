-- ==========================================
-- MENU VIP PRO MAX V1.15.0 (MODERN BENTO & SIDEBAR UI)
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
    AutoSkillDelay = 5,
    AutoSkillZ = false, AutoSkillX = false, AutoSkillC = false, AutoSkillV = false, AutoSkillE = false, AutoSkillF = false,
    AutoSkill1 = false, AutoSkill2 = false, AutoSkill3 = false, AutoSkill4 = false, AutoSkill5 = false, AutoSkill6 = false,
    TpPositionIdx = 1, TpDistance = 4,
    AirWalk = false,
    HidePopups = false, MuteSFX = false, DisableAnims = false, DarkMap = false,
    MiniHUD = false, AutoReconnect = true, MagnetOrbs = false
}

-- Bảng màu Modern Dark Glass (Dịu mắt, có chiều sâu)
local Theme = {
    MainBg = Color3.fromRGB(15, 17, 24),
    SidebarBg = Color3.fromRGB(19, 21, 30),
    HeaderBg = Color3.fromRGB(22, 25, 36),
    ItemBg = Color3.fromRGB(25, 28, 39),
    ItemActive = Color3.fromRGB(24, 42, 40),
    Stroke = Color3.fromRGB(46, 52, 70),
    TextTitle = Color3.fromRGB(224, 232, 245),
    TextDim = Color3.fromRGB(138, 148, 168),
    AccentOn = Color3.fromRGB(56, 204, 136),
    AccentOff = Color3.fromRGB(224, 86, 102),
    Brand = Color3.fromRGB(88, 182, 242),
    BrandSoft = Color3.fromRGB(32, 52, 76)
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

local function addSoftGradient(parent, c1, c2, rot)
    local grad = Instance.new("UIGradient", parent)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2)
    })
    grad.Rotation = rot or 90
    return grad
end

-- ==========================================
-- GIAO DIỆN CHÍNH & SIDEBAR HIỆN ĐẠI
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "MenuVipProMax"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

local notifGui = Instance.new("Frame", gui)
notifGui.Size = UDim2.new(0, 200, 0.8, 0); notifGui.Position = UDim2.new(1, -210, 0.1, 0)
notifGui.BackgroundTransparency = 1; notifGui.ZIndex = 9999
local notifLayout = Instance.new("UIListLayout", notifGui)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder; notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; notifLayout.Padding = UDim.new(0, 6)

local function MakeToast(title, desc, color)
    local toast = Instance.new("Frame", notifGui)
    toast.Size = UDim2.new(1, 0, 0, 44); toast.BackgroundColor3 = Theme.HeaderBg
    toast.BackgroundTransparency = 1; Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 9)
    local stroke = Instance.new("UIStroke", toast); stroke.Color = color; stroke.Thickness = 1.1; stroke.Transparency = 1
    
    local glowBar = Instance.new("Frame", toast)
    glowBar.Size = UDim2.new(0, 3, 1, -12); glowBar.Position = UDim2.new(0, 6, 0, 6)
    glowBar.BackgroundColor3 = color; glowBar.BorderSizePixel = 0; Instance.new("UICorner", glowBar).CornerRadius = UDim.new(1, 0)
    glowBar.BackgroundTransparency = 1

    local tLabel = Instance.new("TextLabel", toast)
    tLabel.Size = UDim2.new(1, -22, 0, 16); tLabel.Position = UDim2.new(0, 15, 0, 5)
    tLabel.BackgroundTransparency = 1; tLabel.Text = title; tLabel.TextColor3 = color; tLabel.Font = Enum.Font.GothamBold; tLabel.TextSize = 10.5; tLabel.TextXAlignment = Enum.TextXAlignment.Left; tLabel.TextTransparency = 1
    
    local dLabel = Instance.new("TextLabel", toast)
    dLabel.Size = UDim2.new(1, -22, 0, 16); dLabel.Position = UDim2.new(0, 15, 0, 22)
    dLabel.BackgroundTransparency = 1; dLabel.Text = desc; dLabel.TextColor3 = Theme.TextTitle; dLabel.Font = Enum.Font.Gotham; dLabel.TextSize = 9.5; dLabel.TextXAlignment = Enum.TextXAlignment.Left; dLabel.TextTransparency = 1; dLabel.TextTruncate = Enum.TextTruncate.AtEnd
    
    TweenService:Create(toast, TweenInfo.new(0.25), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 0.2}):Play()
    TweenService:Create(glowBar, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    TweenService:Create(tLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    TweenService:Create(dLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    
    task.delay(2.2, function()
        TweenService:Create(toast, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.35), {Transparency = 1}):Play()
        TweenService:Create(glowBar, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
        TweenService:Create(tLabel, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        TweenService:Create(dLabel, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        task.wait(0.35); toast:Destroy()
    end)
end

local screenOverlay = Instance.new("Frame", gui)
screenOverlay.Size = UDim2.new(2, 0, 2, 0); screenOverlay.Position = UDim2.new(-0.5, 0, -0.5, 0)
screenOverlay.BackgroundColor3 = Color3.new(0,0,0); screenOverlay.ZIndex = 0; screenOverlay.Visible = false

-- Nút bật/tắt nổi (Floating Pill / Circle Button)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 44, 0, 44); openBtn.Position = UDim2.new(0, 15, 0.26, 0)
openBtn.Text = "🇻🇳"; openBtn.BackgroundColor3 = Theme.HeaderBg; openBtn.BackgroundTransparency = 0.1
openBtn.TextColor3 = Theme.Brand; openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 20; openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 14)
local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = Theme.Brand; openStroke.Thickness = 1.6; openStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 

local function clickAnimate(obj)
    local scale = obj:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", obj)
    TweenService:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.95}):Play()
    task.delay(0.08, function()
        if scale and scale.Parent then
            TweenService:Create(scale, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end
    end)
end

do
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
end

-- Khung chính Widescreen (430x285): Không bao giờ đè lên thanh Cấp Độ hay thanh Hotbar bên dưới
local OPEN_POS = UDim2.new(0.5, -215, 0.5, -148)
local CLOSE_POS = UDim2.new(0.5, -215, 1.25, 0)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 430, 0, 285)
frame.Position = OPEN_POS
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.02
frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
addSoftGradient(frame, Color3.fromRGB(20, 23, 33), Color3.fromRGB(14, 16, 23), 135)

local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = Theme.Stroke; frameStroke.Thickness = 1.5
table.insert(RGBElements, {Type = "Frame", Stroke = frameStroke})

-- THANH TIÊU ĐỀ (HEADER HIỆN ĐẠI)
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 36); header.BackgroundColor3 = Color3.fromRGB(255, 255, 255); header.BackgroundTransparency = 0; header.BorderSizePixel = 0; header.ZIndex = 11
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
addSoftGradient(header, Color3.fromRGB(28, 32, 46), Color3.fromRGB(21, 24, 34), 0)

local headerCover = Instance.new("Frame", header) 
headerCover.Size = UDim2.new(1, 0, 0, 10); headerCover.Position = UDim2.new(0, 0, 1, -10); headerCover.BackgroundColor3 = Color3.fromRGB(23, 26, 38); headerCover.BorderSizePixel = 0; headerCover.ZIndex = 11

local headerLine = Instance.new("Frame", header)
headerLine.Size = UDim2.new(1, 0, 0, 1); headerLine.Position = UDim2.new(0, 0, 1, -1); headerLine.BackgroundColor3 = Theme.Stroke; headerLine.BorderSizePixel = 0; headerLine.ZIndex = 12

local avatarImg = Instance.new("ImageLabel", header)
avatarImg.Size = UDim2.new(0, 24, 0, 24); avatarImg.Position = UDim2.new(0, 10, 0.5, -12); avatarImg.BackgroundColor3 = Theme.ItemBg; avatarImg.ZIndex = 12
pcall(function() avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
local avatarStroke = Instance.new("UIStroke", avatarImg); avatarStroke.Color = Theme.Brand; avatarStroke.Thickness = 1.2

local onlineDot = Instance.new("Frame", avatarImg)
onlineDot.Size = UDim2.new(0, 7, 0, 7); onlineDot.Position = UDim2.new(1, -6, 1, -6)
onlineDot.BackgroundColor3 = Theme.AccentOn; onlineDot.ZIndex = 13
Instance.new("UICorner", onlineDot).CornerRadius = UDim.new(1, 0)
local dotStroke = Instance.new("UIStroke", onlineDot); dotStroke.Color = Theme.HeaderBg; dotStroke.Thickness = 1.2

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(0, 170, 0, 16); titleLabel.Position = UDim2.new(0, 42, 0, 4); titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MENU VIP PRO MAX"
titleLabel.TextColor3 = Theme.TextTitle; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 12; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.ZIndex = 12

local subTitleLabel = Instance.new("TextLabel", header)
subTitleLabel.Size = UDim2.new(0, 180, 0, 12); subTitleLabel.Position = UDim2.new(0, 42, 0, 19); subTitleLabel.BackgroundTransparency = 1
subTitleLabel.Text = "@" .. player.Name .. " • Active"
subTitleLabel.TextColor3 = Theme.TextDim; subTitleLabel.Font = Enum.Font.GothamSemibold; subTitleLabel.TextSize = 9; subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left; subTitleLabel.ZIndex = 12

-- Khung trạng thái FPS/Ping trực tiếp trên Header
local headerStatPill = Instance.new("Frame", header)
headerStatPill.Size = UDim2.new(0, 108, 0, 20); headerStatPill.Position = UDim2.new(1, -190, 0.5, -10)
headerStatPill.BackgroundColor3 = Color3.fromRGB(16, 18, 26); headerStatPill.ZIndex = 12
Instance.new("UICorner", headerStatPill).CornerRadius = UDim.new(1, 0)
local hspStroke = Instance.new("UIStroke", headerStatPill); hspStroke.Color = Theme.Stroke; hspStroke.Thickness = 1

local headerStatText = Instance.new("TextLabel", headerStatPill)
headerStatText.Size = UDim2.new(1, 0, 1, 0); headerStatText.BackgroundTransparency = 1
headerStatText.RichText = true; headerStatText.Text = "<font color='#38CC88'>60 FPS</font> • <font color='#58B6F2'>0ms</font>"
headerStatText.TextColor3 = Theme.TextTitle; headerStatText.Font = Enum.Font.GothamBold; headerStatText.TextSize = 9; headerStatText.ZIndex = 13

local verBadge = Instance.new("TextLabel", header)
verBadge.Size = UDim2.new(0, 42, 0, 20); verBadge.Position = UDim2.new(1, -76, 0.5, -10)
verBadge.BackgroundColor3 = Theme.BrandSoft; verBadge.Text = "v1.15"; verBadge.TextColor3 = Theme.Brand
verBadge.Font = Enum.Font.GothamBold; verBadge.TextSize = 9.5; verBadge.ZIndex = 12
Instance.new("UICorner", verBadge).CornerRadius = UDim.new(0, 6)
local verStroke = Instance.new("UIStroke", verBadge); verStroke.Color = Theme.Brand; verStroke.Thickness = 0.9; verStroke.Transparency = 0.35

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 22, 0, 20); minBtn.Position = UDim2.new(1, -28, 0.5, -10)
minBtn.BackgroundColor3 = Color3.fromRGB(34, 38, 52); minBtn.Text = "—"; minBtn.TextColor3 = Theme.TextTitle
minBtn.Font = Enum.Font.GothamBlack; minBtn.TextSize = 11; minBtn.AutoButtonColor = false; minBtn.ZIndex = 12
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
local minStroke = Instance.new("UIStroke", minBtn); minStroke.Color = Theme.Stroke; minStroke.Thickness = 1

do
    local dragToggle, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
            OPEN_POS = frame.Position
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end
    end)
end

-- ==========================================
-- THANH ĐIỀU HƯỚNG DỌC BÊN TRÁI (LEFT SIDEBAR)
-- Hiển thị đầy đủ 9 Tab không bị khuất chữ
-- ==========================================
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 108, 1, -36); sidebar.Position = UDim2.new(0, 0, 0, 36)
sidebar.BackgroundColor3 = Theme.SidebarBg; sidebar.BorderSizePixel = 0; sidebar.ZIndex = 10
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)

local sidebarPatchTop = Instance.new("Frame", sidebar)
sidebarPatchTop.Size = UDim2.new(1, 0, 0, 12); sidebarPatchTop.Position = UDim2.new(0, 0, 0, 0)
sidebarPatchTop.BackgroundColor3 = Theme.SidebarBg; sidebarPatchTop.BorderSizePixel = 0; sidebarPatchTop.ZIndex = 10

local sidebarPatchRight = Instance.new("Frame", sidebar)
sidebarPatchRight.Size = UDim2.new(0, 12, 1, 0); sidebarPatchRight.Position = UDim2.new(1, -12, 0, 0)
sidebarPatchRight.BackgroundColor3 = Theme.SidebarBg; sidebarPatchRight.BorderSizePixel = 0; sidebarPatchRight.ZIndex = 10

local sidebarDivider = Instance.new("Frame", sidebar)
sidebarDivider.Size = UDim2.new(0, 1, 1, 0); sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
sidebarDivider.BackgroundColor3 = Theme.Stroke; sidebarDivider.BorderSizePixel = 0; sidebarDivider.ZIndex = 11

local tabBar = Instance.new("ScrollingFrame", sidebar)
tabBar.Size = UDim2.new(1, 0, 1, 0); tabBar.BackgroundTransparency = 1; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 11
tabBar.ScrollBarThickness = 0; tabBar.ScrollingDirection = Enum.ScrollingDirection.Y

local tabPad = Instance.new("UIPadding", tabBar)
tabPad.PaddingLeft = UDim.new(0, 6); tabPad.PaddingRight = UDim.new(0, 7)
tabPad.PaddingTop = UDim.new(0, 6); tabPad.PaddingBottom = UDim.new(0, 6)

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Vertical
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 3)
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tabBar.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 12)
end)

local allTabs = {}
local function createTab(icon, name)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.Text = ""; btn.BackgroundColor3 = Theme.BrandSoft
    btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.ZIndex = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 3, 0, 13); indicator.Position = UDim2.new(0, 3, 0.5, -6.5)
    indicator.BackgroundColor3 = Theme.Brand; indicator.BorderSizePixel = 0; indicator.Visible = false; indicator.ZIndex = 12
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local iconLbl = Instance.new("TextLabel", btn)
    iconLbl.Size = UDim2.new(0, 18, 1, 0); iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1; iconLbl.Text = icon; iconLbl.TextSize = 11; iconLbl.Font = Enum.Font.GothamBold; iconLbl.ZIndex = 12

    local txtLbl = Instance.new("TextLabel", btn)
    txtLbl.Size = UDim2.new(1, -28, 1, 0); txtLbl.Position = UDim2.new(0, 27, 0, 0)
    txtLbl.BackgroundTransparency = 1; txtLbl.Text = name; txtLbl.TextColor3 = Theme.TextDim
    txtLbl.Font = Enum.Font.GothamBold; txtLbl.TextSize = 9.5; txtLbl.TextXAlignment = Enum.TextXAlignment.Left; txtLbl.ZIndex = 12

    table.insert(allTabs, {Btn = btn, Ind = indicator, Txt = txtLbl})
    return btn, indicator, txtLbl
end

local tab1, ind1 = createTab("📊", "THÔNG TIN")
local tab2, ind2 = createTab("⚡", "TÍNH NĂNG")
local tab3, ind3 = createTab("🏃", "NHÂN VẬT")
local tab4, ind4 = createTab("🛠️", "TIỆN ÍCH")
local tab5, ind5 = createTab("🎵", "NHẠC ID") 
local tab6, ind6 = createTab("📍", "TP SAVE")
local tab7, ind7 = createTab("🎯", "TP PLAYER")
local tab8, ind8 = createTab("⌨️", "AUTO SKILL") 
local tab9, ind9 = createTab("🚀", "CẤU HÌNH")

local pageContainer = Instance.new("Frame", frame)
pageContainer.Size = UDim2.new(1, -108, 1, -36); pageContainer.Position = UDim2.new(0, 108, 0, 36)
pageContainer.BackgroundTransparency = 1; pageContainer.ZIndex = 10

local function createPage()
    local pg = Instance.new("ScrollingFrame", pageContainer)
    pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1
    pg.ScrollBarThickness = 3; pg.ScrollBarImageColor3 = Theme.Brand; pg.Visible = false; pg.BorderSizePixel = 0; pg.ZIndex = 10
    local layout = Instance.new("UIListLayout", pg)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 6); layout.SortOrder = Enum.SortOrder.LayoutOrder 
    local pad = Instance.new("UIPadding", pg)
    pad.PaddingTop = UDim.new(0, 7); pad.PaddingBottom = UDim.new(0, 14) 
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 22) end)
    return pg
end

local page1, page2, page3, page4, page8, page9 = createPage(), createPage(), createPage(), createPage(), createPage(), createPage()

local page5 = Instance.new("Frame", pageContainer)
page5.Size = UDim2.new(1, 0, 1, 0); page5.BackgroundTransparency = 1; page5.Visible = false; page5.ZIndex = 10
local l5 = Instance.new("UIListLayout", page5); l5.HorizontalAlignment = Enum.HorizontalAlignment.Center; l5.Padding = UDim.new(0, 6); l5.SortOrder = Enum.SortOrder.LayoutOrder; Instance.new("UIPadding", page5).PaddingTop = UDim.new(0, 7)

local page6 = Instance.new("Frame", pageContainer)
page6.Size = UDim2.new(1, 0, 1, 0); page6.BackgroundTransparency = 1; page6.Visible = false; page6.ZIndex = 10
local l6 = Instance.new("UIListLayout", page6); l6.HorizontalAlignment = Enum.HorizontalAlignment.Center; l6.Padding = UDim.new(0, 6); l6.SortOrder = Enum.SortOrder.LayoutOrder; Instance.new("UIPadding", page6).PaddingTop = UDim.new(0, 7)

local page7 = Instance.new("Frame", pageContainer)
page7.Size = UDim2.new(1, 0, 1, 0); page7.BackgroundTransparency = 1; page7.Visible = false; page7.ZIndex = 10
local l7 = Instance.new("UIListLayout", page7); l7.HorizontalAlignment = Enum.HorizontalAlignment.Center; l7.Padding = UDim.new(0, 5); l7.SortOrder = Enum.SortOrder.LayoutOrder
local pad7 = Instance.new("UIPadding", page7); pad7.PaddingTop = UDim.new(0, 6)

local onTab9Shown = nil
local function showTab(pg, tb, ind)
    for _, p in pairs({page1, page2, page3, page4, page5, page6, page7, page8, page9}) do p.Visible = false end
    for _, item in ipairs(allTabs) do
        item.Txt.TextColor3 = Theme.TextDim
        TweenService:Create(item.Btn, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
        item.Ind.Visible = false
    end
    pg.Visible = true
    for _, item in ipairs(allTabs) do
        if item.Btn == tb then
            item.Txt.TextColor3 = Theme.TextTitle
            break
        end
    end
    TweenService:Create(tb, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
    ind.Visible = true
    ind.Size = UDim2.new(0, 3, 0, 0)
    TweenService:Create(ind, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 13)}):Play()

    if pg == page9 and onTab9Shown then
        task.spawn(onTab9Shown)
    end
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
local function toggleMenuWindow()
    opened = not opened
    if not State.RGB then
        TweenService:Create(openStroke, TweenInfo.new(0.3), {Color = opened and Theme.Brand or Theme.AccentOff}):Play()
    end
    frame:TweenPosition(opened and OPEN_POS or CLOSE_POS, "Out", "Back", 0.38, true)
end

openBtn.MouseButton1Click:Connect(function()
    clickAnimate(openBtn)
    toggleMenuWindow()
end)

minBtn.MouseButton1Click:Connect(function()
    clickAnimate(minBtn)
    toggleMenuWindow()
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

-- ==========================================
-- COMPONENTS ĐƯỢC NÂNG CẤP HIỆN ĐẠI
-- ==========================================
local function createDivider(parent, text)
    local dFrame = Instance.new("Frame", parent)
    dFrame.Size = UDim2.new(0.94, 0, 0, 18)
    dFrame.BackgroundTransparency = 1
    dFrame.ZIndex = 10

    local lineLeft = Instance.new("Frame", dFrame)
    lineLeft.Size = UDim2.new(1, 0, 0, 1); lineLeft.Position = UDim2.new(0, 0, 0.5, 0)
    lineLeft.BackgroundColor3 = Theme.Stroke; lineLeft.BorderSizePixel = 0; lineLeft.ZIndex = 10

    local pill = Instance.new("TextLabel", dFrame)
    pill.AutomaticSize = Enum.AutomaticSize.X
    pill.Size = UDim2.new(0, 0, 0, 16)
    pill.AnchorPoint = Vector2.new(0.5, 0.5)
    pill.Position = UDim2.new(0.5, 0, 0.5, 0)
    pill.BackgroundColor3 = Color3.fromRGB(18, 20, 29)
    pill.Text = "  " .. text .. "  "
    pill.TextColor3 = Theme.Brand
    pill.Font = Enum.Font.GothamBold
    pill.TextSize = 9
    pill.ZIndex = 11
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local pStroke = Instance.new("UIStroke", pill); pStroke.Color = Theme.Stroke; pStroke.Thickness = 0.8
    return dFrame
end

local function createCycleBtn(parent, prefix, options, stateVar)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.94, 0, 0, 32); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = Theme.Brand; stroke.Thickness = 1; stroke.Transparency = 0.25; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = Theme.Brand})
    
    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.TextColor3 = Theme.Brand; title.Font = Enum.Font.GothamBold; title.TextSize = 10.5; title.ZIndex = 10
    
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
    btnFrame.Size = UDim2.new(0.94, 0, 0, 34); btnFrame.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 1

    local leftBar = Instance.new("Frame", btn)
    leftBar.Size = UDim2.new(0, 3, 0, 16); leftBar.Position = UDim2.new(0, 6, 0.5, -8)
    leftBar.BorderSizePixel = 0; leftBar.ZIndex = 11
    Instance.new("UICorner", leftBar).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(1, -76, 1, 0); title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = Theme.TextTitle
    title.Font = Enum.Font.GothamSemibold; title.TextSize = 10.5; title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd; title.ZIndex = 11

    local switchTrack = Instance.new("Frame", btn)
    switchTrack.Size = UDim2.new(0, 38, 0, 19); switchTrack.Position = UDim2.new(1, -46, 0.5, -9.5)
    switchTrack.BorderSizePixel = 0; switchTrack.ZIndex = 11
    Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)
    local switchStroke = Instance.new("UIStroke", switchTrack); switchStroke.Thickness = 1; switchStroke.Transparency = 0.25

    local switchKnob = Instance.new("Frame", switchTrack)
    switchKnob.Size = UDim2.new(0, 13, 0, 13)
    switchKnob.BorderSizePixel = 0; switchKnob.ZIndex = 12
    Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)

    local active = State[varName] and true or false

    local function applyVisual(isOn, instant)
        local tInfo = TweenInfo.new(instant and 0 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local trackCol = isOn and Color3.fromRGB(34, 118, 82) or Color3.fromRGB(18, 20, 28)
        local knobCol = isOn and Color3.fromRGB(240, 255, 245) or Color3.fromRGB(125, 135, 155)
        local knobPos = isOn and UDim2.new(1, -16, 0.5, -6.5) or UDim2.new(0, 3, 0.5, -6.5)
        local barCol = isOn and Theme.AccentOn or Color3.fromRGB(60, 66, 84)
        local bgCol = isOn and Theme.ItemActive or Theme.ItemBg
        local borderCol = isOn and Color3.fromRGB(54, 140, 98) or Theme.Stroke

        TweenService:Create(switchTrack, tInfo, {BackgroundColor3 = trackCol}):Play()
        TweenService:Create(switchStroke, tInfo, {Color = isOn and Theme.AccentOn or Theme.Stroke}):Play()
        TweenService:Create(switchKnob, tInfo, {Position = knobPos, BackgroundColor3 = knobCol}):Play()
        TweenService:Create(leftBar, tInfo, {BackgroundColor3 = barCol}):Play()
        TweenService:Create(btn, tInfo, {BackgroundColor3 = bgCol}):Play()
        if not State.RGB then
            TweenService:Create(stroke, tInfo, {Color = borderCol}):Play()
        end
    end

    applyVisual(active, true)
    table.insert(RGBElements, {Type = "Toggle", Stroke = stroke, State = function() return State[varName] end})

    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn)
        State[varName] = not State[varName]
        active = State[varName]
        applyVisual(active, false)
        if varName ~= "AutoSave" then
            if active then MakeToast("Đã Bật", text, Theme.AccentOn) else MakeToast("Đã Tắt", text, Theme.AccentOff) end
            if State.AutoSave then saveConfig() end
        end
        if callback then callback(active) end
    end)

    if active and callback then task.spawn(callback, active) end
    return btnFrame, applyVisual
end

local function createButton(parent, text, color, callback)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.94, 0, 0, 31); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    addSoftGradient(btn, Color3.fromRGB(32, 36, 50), Color3.fromRGB(24, 27, 38), 90)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = color; stroke.Thickness = 1.1; stroke.Transparency = 0.25; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = color})
    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = color; title.Font = Enum.Font.GothamBold; title.TextSize = 10.5; title.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
        task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = color}):Play() end
        MakeToast("Đã thực thi", text, color); callback()
    end)
    return btnFrame
end

local function createDualButtons(parent, text1, color1, cb1, text2, color2, cb2)
    local dFrame = Instance.new("Frame", parent)
    dFrame.Size = UDim2.new(0.94, 0, 0, 31); dFrame.BackgroundTransparency = 1
    local function makeBtn(xPos, txt, col, cb)
        local btn = Instance.new("TextButton", dFrame)
        btn.Size = UDim2.new(0.486, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0); btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        addSoftGradient(btn, Color3.fromRGB(31, 35, 48), Color3.fromRGB(23, 26, 36), 90)
        local stroke = Instance.new("UIStroke", btn); stroke.Color = col; stroke.Thickness = 1.1; stroke.Transparency = 0.25; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = col})
        local title = Instance.new("TextLabel", btn)
        title.Size = UDim2.new(1, -6, 1, 0); title.Position = UDim2.new(0, 3, 0, 0); title.BackgroundTransparency = 1; title.Text = txt; title.TextColor3 = col; title.Font = Enum.Font.GothamBold; title.TextSize = 9.5; title.TextTruncate = Enum.TextTruncate.AtEnd; title.ZIndex = 10
        btn.MouseButton1Click:Connect(function()
            clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
            task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = col}):Play() end
            if txt ~= "🗑️ XÓA TẤT CẢ" then MakeToast("Đã thực thi", txt, col) end; cb()
        end)
    end
    makeBtn(0, text1, color1, cb1); makeBtn(0.514, text2, color2, cb2)
    return dFrame
end

local function createSlider(parent, text, min, max, varName, callback)
    local sFrame = Instance.new("Frame", parent)
    sFrame.Size = UDim2.new(0.94, 0, 0, 40); sFrame.BackgroundTransparency = 1
    local bg = Instance.new("Frame", sFrame); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Theme.ItemBg; bg.ZIndex = 10
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", bg); stroke.Color = Theme.Stroke; stroke.Thickness = 1
    table.insert(RGBElements, {Type = "Slider", Stroke = stroke})

    local titleLabel = Instance.new("TextLabel", bg)
    titleLabel.Size = UDim2.new(0.72, 0, 0, 17); titleLabel.Position = UDim2.new(0, 12, 0, 4)
    titleLabel.BackgroundTransparency = 1; titleLabel.Text = text; titleLabel.TextColor3 = Theme.TextTitle
    titleLabel.Font = Enum.Font.GothamSemibold; titleLabel.TextSize = 10; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.ZIndex = 10

    local valBadge = Instance.new("Frame", bg)
    valBadge.Size = UDim2.new(0, 44, 0, 15); valBadge.Position = UDim2.new(1, -54, 0, 5)
    valBadge.BackgroundColor3 = Color3.fromRGB(17, 19, 27); valBadge.ZIndex = 10
    Instance.new("UICorner", valBadge).CornerRadius = UDim.new(0, 5)
    local valStroke = Instance.new("UIStroke", valBadge); valStroke.Color = Theme.Stroke; valStroke.Thickness = 0.8

    local valLabel = Instance.new("TextLabel", valBadge)
    valLabel.Size = UDim2.new(1, 0, 1, 0); valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(State[varName]); valLabel.TextColor3 = Theme.Brand
    valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 9.5; valLabel.ZIndex = 11

    local track = Instance.new("Frame", bg)
    track.Size = UDim2.new(1, -24, 0, 5); track.Position = UDim2.new(0, 12, 0, 27)
    track.BackgroundColor3 = Color3.fromRGB(15, 17, 24); track.ZIndex = 10
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local initPos = math.clamp((State[varName] - min) / (max - min), 0, 1)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(initPos, 0, 1, 0); fill.BackgroundColor3 = Theme.Brand; fill.ZIndex = 11
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 11, 0, 11); knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(initPos, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(240, 248, 255); knob.ZIndex = 12
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob); knobStroke.Color = Theme.Brand; knobStroke.Thickness = 1.4

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        valLabel.Text = tostring(value)
        TweenService:Create(fill, TweenInfo.new(0.08), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.08), {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
        State[varName] = value
        if callback then callback(value) end
        if State.AutoSave then saveConfig() end
    end
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; updateSlider(input)
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
    if callback then task.spawn(callback, State[varName]) end
    return sFrame
end

task.spawn(function()
    while task.wait(0.05) do
        if State.RGB then
            local hue = tick() % 5 / 5; local color = Color3.fromHSV(hue, 0.75, 0.95)
            titleLabel.TextColor3 = color; frameStroke.Color = color; avatarStroke.Color = color; openStroke.Color = color
            for _, obj in pairs(RGBElements) do if obj.Stroke and obj.Stroke.Parent then obj.Stroke.Color = color end end
        end
    end
end)

local fps = 60
RunService.RenderStepped:Connect(function(dt) fps = math.floor(1 / math.max(dt, 0.001)) end)

task.spawn(function()
    while task.wait(0.7) do
        if frame.Visible then
            local pingNum = 0
            pcall(function()
                if Stats and Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem") then
                    local raw = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                    pingNum = tonumber(raw and raw:match("%d+")) or math.floor(player:GetNetworkPing() * 1000)
                else
                    pingNum = math.floor(player:GetNetworkPing() * 1000)
                end
            end)
            local fCol = fps >= 45 and "#38CC88" or (fps >= 25 and "#E5B85B" or "#E05666")
            headerStatText.Text = string.format("<font color='%s'>%d FPS</font> • <font color='#58B6F2'>%dms</font>", fCol, fps, pingNum)
        end
    end
end)

-- ==========================================
-- [TAB 2: TÍNH NĂNG]
-- ==========================================
createToggle(page2, "🛡️ Chống ngã & Chống văng xa", "AntiStun")
createToggle(page2, "🔒 Khóa vị trí nhân vật", "LockPosition", function(v) if not v and player.Character then local r = getUniversalRoot(player.Character); if r then r.Anchored = false end end end)
createToggle(page2, "🚀 Nhảy trên không (Inf Jump)", "InfJump") 
UIS.JumpRequest:Connect(function() if State.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)
createToggle(page2, "🐿️ Lấy đồ nhanh (Instant Prompt)", "Instant")
createToggle(page2, "🧲 Auto nhặt đồ xung quanh", "AutoCollect")

createToggle(page2, "🚷 Đi xuyên tường (Noclip)", "Noclip", function(v) 
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
createToggle(page2, "👀 Nhìn xuyên bản đồ (Xray)", "XRay", function(v) 
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
createToggle(page2, "🔴 Định vị người chơi (ESP)", "ESP")

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

createButton(page2, "🪄 NHẬN GẬY CLICK TP", Theme.Brand, function()
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
    Color3.fromRGB(225, 175, 75),
    function()
        pcall(function()
            player.CameraMaxZoomDistance = 10000
            player.CameraMinZoomDistance = 0.5
            player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            workspace.CurrentCamera.FieldOfView = 105
        end)
    end,
    "👥 TẠO PHÂN THÂN",
    Color3.fromRGB(175, 130, 235),
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
-- [TAB 3: NHÂN VẬT]
-- ==========================================
createToggle(page3, "🕊️ Bay trên bầu trời (Fly)", "Fly", function(v)
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
createToggle(page3, "🏃 Chạy nhanh (WalkSpeed)", "Speed", function(v)
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
createToggle(page3, "🦘 Nhảy cao (JumpPower)", "Jump", function(v) 
    if player.Character and player.Character:FindFirstChild("Humanoid") then 
        if v then defaultJumpPower = player.Character.Humanoid.JumpPower else player.Character.Humanoid.UseJumpPower = true; player.Character.Humanoid.JumpPower = defaultJumpPower end
    end 
end)
createSlider(page3, "Lực nhảy", 1, 1000, "JumpValue")

createToggle(page3, "💨 Lướt liên tục (Auto Dash)", "AutoDash")
createSlider(page3, "Tốc độ lướt", 1, 50, "DashSpeed")

createToggle(page3, "⚔️ Đánh xa (Reach Vũ Khí)", "Reach")
createSlider(page3, "Kích thước vũ khí", 0, 300, "ReachSize")
createToggle(page3, "🎯 Mở rộng Hitbox", "Hitbox")
createSlider(page3, "Kích thước Hitbox", 0, 100, "HitboxSize")
createToggle(page3, "🌪️ Xoay vòng tròn (SpinBot)", "SpinBot")
createSlider(page3, "Tốc độ xoay", 0, 100, "SpinSpeed")
createToggle(page3, "💡 Ánh sáng quanh người", "PlayerLight", function(v) if not v and player.Character then local root = getUniversalRoot(player.Character); if root then local light = root:FindFirstChild("PlayerPointLight"); if light then light:Destroy() end end end end)
createSlider(page3, "Phạm vi sáng (Max 60)", 0, 60, "LightRange")
createSlider(page3, "Độ sáng", 0, 5, "LightBrightness")
createCycleBtn(page3, "🎨 Đổi màu sáng:", PlayerLightColors, "LightColorIdx")

-- ==========================================
-- [TAB 4: TIỆN ÍCH]
-- ==========================================
createToggle(page4, "💾 Lưu Cài Đặt Tự Động", "AutoSave", function(v) 
    if v then saveConfig(); MakeToast("Đã Bật", "Đã lưu cấu hình hiện tại!", Theme.AccentOn)
    else pcall(function() if isfile and isfile(configFileName) then delfile(configFileName) end end); MakeToast("Đã Tắt", "Đã xóa cấu hình cũ!", Theme.AccentOff) end 
end)
createToggle(page4, "🌈 Chế độ viền RGB", "RGB", function(v) 
    if not v then 
        titleLabel.TextColor3 = Theme.TextTitle; frameStroke.Color = Theme.Stroke; avatarStroke.Color = Theme.Brand; openStroke.Color = opened and Theme.Brand or Theme.AccentOff
        for _, obj in pairs(RGBElements) do
            if obj.Stroke and obj.Stroke.Parent then
                if obj.Type == "Toggle" then obj.Stroke.Color = obj.State() and Color3.fromRGB(54, 140, 98) or Theme.Stroke
                elseif obj.Type == "Button" then obj.Stroke.Color = obj.DefaultColor
                elseif obj.Type == "Slider" or obj.Type == "Info" or obj.Type == "Container" then obj.Stroke.Color = Theme.Stroke end
            end
        end
    end 
end)

createToggle(page4, "💫 Mở khóa ShiftLock Mobile", "ShiftLock", function(v) pcall(function() player.DevEnableMouseLock = v end) end)
createToggle(page4, "🖱️ Auto Click Vũ Khí", "AutoClick")
task.spawn(function()
    while task.wait(0.1) do 
        if State.AutoClick and player.Character then pcall(function() local tool = player.Character:FindFirstChildOfClass("Tool"); if tool then tool:Activate() end end) end
    end
end)

createToggle(page4, "🛡️ Chống AFK (Anti-AFK)", "AntiAfk")

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

createDivider(page4, "ĐIỀU KHIỂN SERVER & MÔI TRƯỜNG")

createDualButtons(
    page4,
    "☀️ TRỜI SÁNG",
    Color3.fromRGB(225, 185, 75),
    function()
        pcall(function()
            Lighting.ClockTime = 12
            Lighting.Brightness = 2
        end)
    end,
    "🌙 TRỜI TỐI",
    Color3.fromRGB(135, 150, 230),
    function()
        pcall(function()
            Lighting.ClockTime = 0
            Lighting.Brightness = 1
        end)
    end
)

createDualButtons(page4, "🔄 VÀO LẠI SV", Theme.AccentOn, rejoinServer, "🎲 ĐỔI SV NGẪU NHIÊN", Theme.Brand, function() hopServer("Desc") end)
createDualButtons(page4, "📉 ĐỔI SV ÍT NGƯỜI", Color3.fromRGB(90, 170, 225), function() hopServer("Asc") end, "📈 ĐỔI SV ĐÔNG NGƯỜI", Color3.fromRGB(220, 105, 95), function() hopServer("Desc") end)

createDivider(page4, "CÔNG CỤ SCRIPT NGOÀI")

createDualButtons(
    page4,
    "💻 LỆNH ADMIN",
    Theme.AccentOn,
    function()
        pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end)
    end,
    "📁 MENU TP SAVE",
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
    "🎯 TP PLAYS",
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
do
    local musicControlFrame = Instance.new("Frame", page5); musicControlFrame.Size = UDim2.new(0.94, 0, 0, 56); musicControlFrame.BackgroundColor3 = Theme.ItemBg; musicControlFrame.ZIndex = 10; musicControlFrame.LayoutOrder = 1; Instance.new("UICorner", musicControlFrame).CornerRadius = UDim.new(0, 8)
    local mStroke = Instance.new("UIStroke", musicControlFrame); mStroke.Color = Theme.Stroke; mStroke.Thickness = 1; table.insert(RGBElements, {Type = "Info", Stroke = mStroke})
    local musicIcon = Instance.new("TextLabel", musicControlFrame); musicIcon.Size = UDim2.new(0.11, 0, 0, 28); musicIcon.BackgroundTransparency = 1; musicIcon.Text = "🎼"; musicIcon.TextSize = 14; musicIcon.ZIndex = 10
    local musicIdBox = Instance.new("TextBox", musicControlFrame); musicIdBox.Size = UDim2.new(0.65, 0, 0, 28); musicIdBox.Position = UDim2.new(0.11, 0, 0, 0); musicIdBox.BackgroundTransparency = 1; musicIdBox.PlaceholderText = "Nhập ID Nhạc Roblox..."; musicIdBox.PlaceholderColor3 = Theme.TextDim; musicIdBox.Text = ""; musicIdBox.TextColor3 = Theme.TextTitle; musicIdBox.Font = Enum.Font.GothamSemibold; musicIdBox.TextSize = 10; musicIdBox.TextXAlignment = Enum.TextXAlignment.Left; musicIdBox.ClearTextOnFocus = false; musicIdBox.ZIndex = 10
    
    local saveIdBtn = Instance.new("TextButton", musicControlFrame)
    saveIdBtn.Size = UDim2.new(0.21, 0, 0, 20); saveIdBtn.Position = UDim2.new(0.77, 0, 0, 4)
    saveIdBtn.BackgroundColor3 = Color3.fromRGB(28, 48, 38); saveIdBtn.Text = "💾 Lưu"; saveIdBtn.TextColor3 = Theme.AccentOn
    saveIdBtn.Font = Enum.Font.GothamBold; saveIdBtn.TextSize = 9.5; saveIdBtn.ZIndex = 10
    Instance.new("UICorner", saveIdBtn).CornerRadius = UDim.new(0, 5)
    local saveIdStroke = Instance.new("UIStroke", saveIdBtn); saveIdStroke.Color = Theme.AccentOn; saveIdStroke.Thickness = 0.9; saveIdStroke.Transparency = 0.3

    local divLine = Instance.new("Frame", musicControlFrame); divLine.Size = UDim2.new(0.94, 0, 0, 1); divLine.Position = UDim2.new(0.03, 0, 0, 28); divLine.BackgroundColor3 = Theme.Stroke; divLine.BorderSizePixel = 0; divLine.ZIndex = 10
    local nowPlayingLabel = Instance.new("TextLabel", musicControlFrame); nowPlayingLabel.Size = UDim2.new(0.92, 0, 0, 26); nowPlayingLabel.Position = UDim2.new(0.04, 0, 0, 29); nowPlayingLabel.BackgroundTransparency = 1; nowPlayingLabel.RichText = true; nowPlayingLabel.Text = "<font color='#9AA4B8'>🎵 Chưa có nhạc phát</font>"; nowPlayingLabel.Font = Enum.Font.GothamSemibold; nowPlayingLabel.TextSize = 10; nowPlayingLabel.TextWrapped = true; nowPlayingLabel.ZIndex = 10

    local function getSongName(id) local numId = tonumber(id); if not numId then return "ID sai!" end; local s, info = pcall(function() return MarketplaceService:GetProductInfo(numId) end); if s and info then return info.Name else return "Ẩn danh" end end
    local function playMusic(id)
        if currentSound then currentSound:Destroy() end; local soundId = tostring(id):match("%d+"); if not soundId or soundId == "" then return end
        currentMusicId = soundId; nowPlayingLabel.Text = "<font color='#D6DEEB'>⏳ Đang tải thông tin bài hát...</font>"
        task.spawn(function() local name = getSongName(soundId); if currentMusicId == soundId then nowPlayingLabel.Text = "<font color='#9AA4B8'>🎵 Đang phát:</font> <font color='#F0C868'>" .. name .. "</font>" end end)
        currentSound = Instance.new("Sound"); currentSound.SoundId = "rbxassetid://" .. soundId; currentSound.Volume = State.MusicVolume; currentSound.Parent = workspace
        currentSound.Ended:Connect(function()
            if #savedMusicList > 0 then
                local cx = 0; for i, v in ipairs(savedMusicList) do if v.id == currentMusicId then cx = i; break end end
                local nx = cx + 1; if nx > #savedMusicList then nx = 1 end; playMusic(savedMusicList[nx].id)
            end
        end)
        currentSound:Play()
    end
    local function stopMusic() if currentSound then currentSound:Stop(); currentSound:Destroy(); currentSound = nil; currentMusicId = ""; nowPlayingLabel.Text = "<font color='#9AA4B8'>⏹ Đã dừng phát nhạc</font>" end end

    local playControlFrame = createDualButtons(page5, "▶️ PHÁT NHẠC", Theme.AccentOn, function() playMusic(musicIdBox.Text) end, "⏹️ TẮT NHẠC", Theme.AccentOff, function() stopMusic() end); playControlFrame.LayoutOrder = 2
    local volumeFrame = createSlider(page5, "ÂM LƯỢNG NHẠC 🔊", 0, 10, "MusicVolume", function(val) if currentSound then currentSound.Volume = val end end); volumeFrame.LayoutOrder = 3

    local musicListCard = Instance.new("Frame", page5)
    musicListCard.Size = UDim2.new(0.94, 0, 1, -156); musicListCard.BackgroundColor3 = Color3.fromRGB(20, 22, 31); musicListCard.LayoutOrder = 4; musicListCard.ZIndex = 10
    Instance.new("UICorner", musicListCard).CornerRadius = UDim.new(0, 8)
    local mlStroke = Instance.new("UIStroke", musicListCard); mlStroke.Color = Theme.Stroke; mlStroke.Thickness = 1; table.insert(RGBElements, {Type = "Info", Stroke = mlStroke})

    local mlHeader = Instance.new("TextLabel", musicListCard)
    mlHeader.Size = UDim2.new(1, -16, 0, 18); mlHeader.Position = UDim2.new(0, 10, 0, 3); mlHeader.BackgroundTransparency = 1
    mlHeader.Text = "🎵 DANH SÁCH NHẠC ĐÃ LƯU"; mlHeader.TextColor3 = Theme.Brand; mlHeader.Font = Enum.Font.GothamBold; mlHeader.TextSize = 9; mlHeader.TextXAlignment = Enum.TextXAlignment.Left; mlHeader.ZIndex = 10

    local savedMusicContent = Instance.new("ScrollingFrame", musicListCard)
    savedMusicContent.Size = UDim2.new(1, -10, 1, -24); savedMusicContent.Position = UDim2.new(0, 5, 0, 22)
    savedMusicContent.BackgroundTransparency = 1; savedMusicContent.ScrollBarThickness = 3; savedMusicContent.ScrollBarImageColor3 = Theme.Brand; savedMusicContent.BorderSizePixel = 0; savedMusicContent.ZIndex = 10
    local sLayout = Instance.new("UIListLayout", savedMusicContent); sLayout.SortOrder = Enum.SortOrder.LayoutOrder; sLayout.Padding = UDim.new(0, 4)
    sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedMusicContent.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 8) end)

    local fileName = "MenuVipProMax_SavedMusic.json"
    pcall(function() if isfile and isfile(fileName) then local decoded = HttpService:JSONDecode(readfile(fileName)); if type(decoded) == "table" then savedMusicList = decoded end end end)
    local function saveMusicData() pcall(function() if writefile then writefile(fileName, HttpService:JSONEncode(savedMusicList)) end end) end
    local function renderSavedMusic()
        for _, child in pairs(savedMusicContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        mlHeader.Text = "🎵 DANH SÁCH NHẠC ĐÃ LƯU (" .. #savedMusicList .. ")"
        if #savedMusicList == 0 then
            local empty = Instance.new("Frame", savedMusicContent); empty.Size = UDim2.new(1, 0, 0, 38); empty.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", empty); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Text = "Chưa có bài nhạc nào được lưu.\nNhập ID Nhạc bên trên và bấm '💾 Lưu' để thêm!"; lbl.TextColor3 = Theme.TextDim; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.ZIndex = 10
            return
        end
        for i, data in ipairs(savedMusicList) do
            local item = Instance.new("Frame", savedMusicContent); item.Size = UDim2.new(1, -4, 0, 30); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1; table.insert(RGBElements, {Type = "Info", Stroke = stroke})
            local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.56, 0, 1, 0); nameBox.Position = UDim2.new(0.04, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 9.5; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
            nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveMusicData() else nameBox.Text = data.name end end)
            
            local playBtn = Instance.new("TextButton", item); playBtn.Size = UDim2.new(0.18, 0, 0.7, 0); playBtn.Position = UDim2.new(0.62, 0, 0.15, 0); playBtn.Text = "▶ Phát"; playBtn.BackgroundColor3 = Color3.fromRGB(28, 48, 62); playBtn.TextColor3 = Theme.Brand; playBtn.Font = Enum.Font.GothamBold; playBtn.TextSize = 9; playBtn.ZIndex = 10; Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 5)
            local pSt = Instance.new("UIStroke", playBtn); pSt.Color = Theme.Brand; pSt.Thickness = 0.8; pSt.Transparency = 0.3

            local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.7, 0); delBtn.Position = UDim2.new(0.82, 0, 0.15, 0); delBtn.Text = "Xóa"; delBtn.BackgroundColor3 = Color3.fromRGB(48, 28, 34); delBtn.TextColor3 = Theme.AccentOff; delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 9; delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 5)
            local dSt = Instance.new("UIStroke", delBtn); dSt.Color = Theme.AccentOff; dSt.Thickness = 0.8; dSt.Transparency = 0.3

            playBtn.MouseButton1Click:Connect(function() clickAnimate(playBtn); musicIdBox.Text = data.id; playMusic(data.id) end)
            delBtn.MouseButton1Click:Connect(function() clickAnimate(delBtn); table.remove(savedMusicList, i); saveMusicData(); renderSavedMusic() end)
        end
    end
    saveIdBtn.MouseButton1Click:Connect(function() clickAnimate(saveIdBtn); local rawId = musicIdBox.Text:match("%d+"); if rawId and rawId ~= "" then saveIdBtn.Text = "⏳..."; task.spawn(function() local name = getSongName(rawId); table.insert(savedMusicList, {id = rawId, name = name}); saveMusicData(); renderSavedMusic(); saveIdBtn.Text = "💾 Lưu" end) end end)
    renderSavedMusic()
end

do
    local tpFileName = "MenuVipProMax_SavedTPs.json"; local savedTpList = {}; pcall(function() if isfile and isfile(tpFileName) then local decoded = HttpService:JSONDecode(readfile(tpFileName)); if type(decoded) == "table" then savedTpList = decoded end end end)
    local function saveTpData() pcall(function() if writefile then local d = {}; for _, v in ipairs(savedTpList) do if not v.isTemp then table.insert(d, v) end end; writefile(tpFileName, HttpService:JSONEncode(d)) end end) end
    local pendingDeleteAll = false
    local renderSavedTps

    local tpControlFrame_New = createDualButtons(page6, "📍 LƯU VỊ TRÍ HIỆN TẠI", Theme.Brand, function()
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

    local tpListCard = Instance.new("Frame", page6)
    tpListCard.Size = UDim2.new(0.94, 0, 1, -46); tpListCard.BackgroundColor3 = Color3.fromRGB(20, 22, 31); tpListCard.LayoutOrder = 2; tpListCard.ZIndex = 10
    Instance.new("UICorner", tpListCard).CornerRadius = UDim.new(0, 8)
    local tlStroke = Instance.new("UIStroke", tpListCard); tlStroke.Color = Theme.Stroke; tlStroke.Thickness = 1; table.insert(RGBElements, {Type = "Info", Stroke = tlStroke})

    local tlHeader = Instance.new("TextLabel", tpListCard)
    tlHeader.Size = UDim2.new(1, -16, 0, 18); tlHeader.Position = UDim2.new(0, 10, 0, 3); tlHeader.BackgroundTransparency = 1
    tlHeader.Text = "📍 DANH SÁCH TỌA ĐỘ ĐÃ LƯU"; tlHeader.TextColor3 = Theme.Brand; tlHeader.Font = Enum.Font.GothamBold; tlHeader.TextSize = 9; tlHeader.TextXAlignment = Enum.TextXAlignment.Left; tlHeader.ZIndex = 10

    local savedTpContent = Instance.new("ScrollingFrame", tpListCard); savedTpContent.Size = UDim2.new(1, -10, 1, -24); savedTpContent.Position = UDim2.new(0, 5, 0, 22); savedTpContent.BackgroundTransparency = 1; savedTpContent.ScrollBarThickness = 3; savedTpContent.ScrollBarImageColor3 = Theme.Brand; savedTpContent.BorderSizePixel = 0; savedTpContent.ZIndex = 10
    local tpLayout = Instance.new("UIListLayout", savedTpContent); tpLayout.SortOrder = Enum.SortOrder.LayoutOrder; tpLayout.Padding = UDim.new(0, 4)
    tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedTpContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 10) end)

    renderSavedTps = function()
        for _, child in pairs(savedTpContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        tlHeader.Text = "📍 DANH SÁCH TỌA ĐỘ ĐÃ LƯU (" .. #savedTpList .. ")"
        if #savedTpList == 0 then
            local empty = Instance.new("Frame", savedTpContent); empty.Size = UDim2.new(1, 0, 0, 42); empty.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", empty); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Text = "Chưa có vị trí nào được lưu.\nBấm '📍 LƯU VỊ TRÍ HIỆN TẠI' để đánh dấu tọa độ!"; lbl.TextColor3 = Theme.TextDim; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.ZIndex = 10
            return
        end
        for i, data in ipairs(savedTpList) do
            local item = Instance.new("Frame", savedTpContent); item.Size = UDim2.new(1, -4, 0, 32); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1; table.insert(RGBElements, {Type = "Info", Stroke = stroke})
            
            local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.52, 0, 1, 0); nameBox.Position = UDim2.new(0.04, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 10; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
            nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveTpData() else nameBox.Text = data.name end end)
            
            local tpBtn = Instance.new("TextButton", item); tpBtn.Size = UDim2.new(0.22, 0, 0.68, 0); tpBtn.Position = UDim2.new(0.57, 0, 0.16, 0); tpBtn.Text = "⚡ TP"; tpBtn.BackgroundColor3 = Color3.fromRGB(26, 46, 62); tpBtn.TextColor3 = Theme.Brand; tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 9.5; tpBtn.ZIndex = 10; Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 5)
            local tpSt = Instance.new("UIStroke", tpBtn); tpSt.Color = Theme.Brand; tpSt.Thickness = 0.9; tpSt.Transparency = 0.25

            local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.68, 0); delBtn.Position = UDim2.new(0.81, 0, 0.16, 0); delBtn.Text = "Xóa"; delBtn.BackgroundColor3 = Color3.fromRGB(48, 28, 34); delBtn.TextColor3 = Theme.AccentOff; delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 9; delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 5)
            local dlSt = Instance.new("UIStroke", delBtn); dlSt.Color = Theme.AccentOff; dlSt.Thickness = 0.9; dlSt.Transparency = 0.25

            tpBtn.MouseButton1Click:Connect(function() clickAnimate(tpBtn); if player.Character then local r = getUniversalRoot(player.Character); if r then r.CFrame = CFrame.new(unpack(data.cframe)); MakeToast("Dịch chuyển", "Đến " .. data.name, Theme.Brand) end end end)
            delBtn.MouseButton1Click:Connect(function() clickAnimate(delBtn); table.remove(savedTpList, i); saveTpData(); renderSavedTps() end)
        end
    end
    renderSavedTps()
end

-- ==========================================
-- [TAB 7: TP NGƯỜI CHƠI (THẺ HIỆN ĐẠI KIỂU DISCORD)]
-- ==========================================
local targetTpPlayer = nil
local autoTpPlayerEnabled = false
local spectatePlayerEnabled = false
local wasHorizontalTp = false
local spectateProxyPart = nil
local lastSpectateStreamTick = 0
local playerListContainer, playerListScroll
local playerDistLabels = {}

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

do
    local tpControlCard = Instance.new("Frame", page7)
    tpControlCard.Size = UDim2.new(0.94, 0, 0, 80)
    tpControlCard.BackgroundColor3 = Theme.ItemBg
    tpControlCard.LayoutOrder = 1
    tpControlCard.ZIndex = 10
    Instance.new("UICorner", tpControlCard).CornerRadius = UDim.new(0, 8)
    local tpCardStroke = Instance.new("UIStroke", tpControlCard)
    tpCardStroke.Color = Theme.Stroke
    tpCardStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = tpCardStroke})

    local targetHeaderRow = Instance.new("Frame", tpControlCard)
    targetHeaderRow.Size = UDim2.new(1, -12, 0, 24)
    targetHeaderRow.Position = UDim2.new(0, 6, 0, 4)
    targetHeaderRow.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    targetHeaderRow.ZIndex = 10
    Instance.new("UICorner", targetHeaderRow).CornerRadius = UDim.new(0, 6)

    local selectedAvatarImg = Instance.new("ImageLabel", targetHeaderRow)
    selectedAvatarImg.Size = UDim2.new(0, 18, 0, 18)
    selectedAvatarImg.Position = UDim2.new(0, 5, 0.5, -9)
    selectedAvatarImg.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
    selectedAvatarImg.Image = "rbxassetid://0"
    selectedAvatarImg.ZIndex = 10
    Instance.new("UICorner", selectedAvatarImg).CornerRadius = UDim.new(1, 0)
    local selAvaStroke = Instance.new("UIStroke", selectedAvatarImg)
    selAvaStroke.Color = Theme.Brand
    selAvaStroke.Thickness = 1

    local targetStatusLabel = Instance.new("TextLabel", targetHeaderRow)
    targetStatusLabel.Size = UDim2.new(1, -108, 1, 0)
    targetStatusLabel.Position = UDim2.new(0, 28, 0, 0)
    targetStatusLabel.BackgroundTransparency = 1
    targetStatusLabel.RichText = true
    targetStatusLabel.Text = "🎯 <font color='#E05666'>Chưa chọn mục tiêu</font>"
    targetStatusLabel.TextColor3 = Theme.TextTitle
    targetStatusLabel.Font = Enum.Font.GothamBold
    targetStatusLabel.TextSize = 10
    targetStatusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    targetStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetStatusLabel.ZIndex = 10

    local spectateBtn = Instance.new("TextButton", targetHeaderRow)
    spectateBtn.Size = UDim2.new(0, 72, 0, 18)
    spectateBtn.Position = UDim2.new(1, -76, 0.5, -9)
    spectateBtn.BackgroundColor3 = Color3.fromRGB(45, 28, 35)
    spectateBtn.Text = "👁️ XEM [TẮT]"
    spectateBtn.TextColor3 = Theme.AccentOff
    spectateBtn.Font = Enum.Font.GothamBold
    spectateBtn.TextSize = 8.5
    spectateBtn.AutoButtonColor = false
    spectateBtn.ZIndex = 10
    Instance.new("UICorner", spectateBtn).CornerRadius = UDim.new(0, 5)
    local spectateStroke = Instance.new("UIStroke", spectateBtn)
    spectateStroke.Color = Theme.AccentOff
    spectateStroke.Thickness = 0.9
    spectateStroke.Transparency = 0.25

    local tpPosBtn = Instance.new("TextButton", tpControlCard)
    tpPosBtn.Size = UDim2.new(1, -12, 0, 22)
    tpPosBtn.Position = UDim2.new(0, 6, 0, 31)
    tpPosBtn.BackgroundColor3 = Color3.fromRGB(26, 44, 62)
    tpPosBtn.Text = ""
    tpPosBtn.AutoButtonColor = false
    tpPosBtn.ZIndex = 10
    Instance.new("UICorner", tpPosBtn).CornerRadius = UDim.new(0, 6)
    local tpPosStroke = Instance.new("UIStroke", tpPosBtn)
    tpPosStroke.Color = Theme.Brand
    tpPosStroke.Thickness = 1
    tpPosStroke.Transparency = 0.25

    local tpPosLabel = Instance.new("TextLabel", tpPosBtn)
    tpPosLabel.Size = UDim2.new(1, 0, 1, 0)
    tpPosLabel.BackgroundTransparency = 1
    tpPosLabel.RichText = true
    tpPosLabel.TextColor3 = Theme.TextTitle
    tpPosLabel.Font = Enum.Font.GothamBold
    tpPosLabel.TextSize = 10
    tpPosLabel.ZIndex = 10

    local function updateTpPosText()
        local item = TpPositions[State.TpPositionIdx] or TpPositions[1]
        tpPosLabel.Text = "📍 VỊ TRÍ TP: <font color='#F0C868'>" .. string.upper(item.Name) .. "</font>"
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
    tpDistContainer.Size = UDim2.new(1, -12, 0, 22)
    tpDistContainer.Position = UDim2.new(0, 6, 0, 55)
    tpDistContainer.BackgroundTransparency = 1
    tpDistContainer.ZIndex = 10

    local tpDistTitle = Instance.new("TextLabel", tpDistContainer)
    tpDistTitle.Size = UDim2.new(0.7, 0, 0, 11)
    tpDistTitle.Position = UDim2.new(0, 2, 0, 0)
    tpDistTitle.BackgroundTransparency = 1
    tpDistTitle.Text = "📏 Khoảng cách đứng (Studs):"
    tpDistTitle.TextColor3 = Theme.TextDim
    tpDistTitle.Font = Enum.Font.GothamSemibold
    tpDistTitle.TextSize = 9.5
    tpDistTitle.TextXAlignment = Enum.TextXAlignment.Left
    tpDistTitle.ZIndex = 10

    local tpDistValLabel = Instance.new("TextLabel", tpDistContainer)
    tpDistValLabel.Size = UDim2.new(0.3, -4, 0, 11)
    tpDistValLabel.Position = UDim2.new(0.7, 0, 0, 0)
    tpDistValLabel.BackgroundTransparency = 1
    tpDistValLabel.Text = tostring(State.TpDistance) .. " m"
    tpDistValLabel.TextColor3 = Color3.fromRGB(240, 200, 104)
    tpDistValLabel.Font = Enum.Font.GothamBold
    tpDistValLabel.TextSize = 10
    tpDistValLabel.TextXAlignment = Enum.TextXAlignment.Right
    tpDistValLabel.ZIndex = 10

    local tpDistTrack = Instance.new("Frame", tpDistContainer)
    tpDistTrack.Size = UDim2.new(1, -4, 0, 5)
    tpDistTrack.Position = UDim2.new(0, 2, 0, 14)
    tpDistTrack.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
    tpDistTrack.ZIndex = 10
    Instance.new("UICorner", tpDistTrack).CornerRadius = UDim.new(1, 0)

    local initTpPos = math.clamp((State.TpDistance - 1) / 24, 0, 1)
    local tpDistFill = Instance.new("Frame", tpDistTrack)
    tpDistFill.Size = UDim2.new(initTpPos, 0, 1, 0)
    tpDistFill.BackgroundColor3 = Theme.Brand
    tpDistFill.ZIndex = 11
    Instance.new("UICorner", tpDistFill).CornerRadius = UDim.new(1, 0)

    local tpKnob = Instance.new("Frame", tpDistTrack)
    tpKnob.Size = UDim2.new(0, 10, 0, 10); tpKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    tpKnob.Position = UDim2.new(initTpPos, 0, 0.5, 0)
    tpKnob.BackgroundColor3 = Color3.fromRGB(240, 248, 255); tpKnob.ZIndex = 12
    Instance.new("UICorner", tpKnob).CornerRadius = UDim.new(1, 0)

    local draggingTpDist = false
    local function updateTpDistSlider(input)
        local pos = math.clamp((input.Position.X - tpDistTrack.AbsolutePosition.X) / tpDistTrack.AbsoluteSize.X, 0, 1)
        local value = math.floor(1 + (24 * pos))
        tpDistValLabel.Text = tostring(value) .. " m"
        TweenService:Create(tpDistFill, TweenInfo.new(0.08), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        TweenService:Create(tpKnob, TweenInfo.new(0.08), {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
        State.TpDistance = value
        if State.AutoSave then saveConfig() end
    end
    tpDistContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingTpDist = true; updateTpDistSlider(input)
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
            targetStatusLabel.Text = string.format("🎯 <font color='#38CC88'>%s</font> <font color='#F0C868'>(@%s)</font>", targetTpPlayer.DisplayName, targetTpPlayer.Name)
            selAvaStroke.Color = Theme.AccentOn
            task.spawn(function()
                pcall(function()
                    selectedAvatarImg.Image = Players:GetUserThumbnailAsync(targetTpPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                end)
            end)
        else
            targetStatusLabel.Text = "🎯 <font color='#E05666'>Chưa chọn mục tiêu</font>"
            selAvaStroke.Color = Theme.AccentOff
            selectedAvatarImg.Image = "rbxassetid://0"
        end
    end

    local tpActionRow = Instance.new("Frame", page7)
    tpActionRow.Size = UDim2.new(0.94, 0, 0, 26)
    tpActionRow.BackgroundTransparency = 1
    tpActionRow.LayoutOrder = 2

    local tpOnceBtn = Instance.new("TextButton", tpActionRow)
    tpOnceBtn.Size = UDim2.new(0.486, 0, 1, 0)
    tpOnceBtn.Position = UDim2.new(0, 0, 0, 0)
    tpOnceBtn.BackgroundColor3 = Color3.fromRGB(24, 40, 56)
    tpOnceBtn.Text = "⚡ TP 1 LẦN"
    tpOnceBtn.TextColor3 = Theme.Brand
    tpOnceBtn.Font = Enum.Font.GothamBold
    tpOnceBtn.TextSize = 10
    tpOnceBtn.AutoButtonColor = false
    tpOnceBtn.ZIndex = 10
    Instance.new("UICorner", tpOnceBtn).CornerRadius = UDim.new(0, 6)
    local tpOnceStroke = Instance.new("UIStroke", tpOnceBtn)
    tpOnceStroke.Color = Theme.Brand
    tpOnceStroke.Thickness = 1; tpOnceStroke.Transparency = 0.25
    table.insert(RGBElements, {Type = "Button", Stroke = tpOnceStroke, DefaultColor = Theme.Brand})

    local autoTpBtn = Instance.new("TextButton", tpActionRow)
    autoTpBtn.Size = UDim2.new(0.486, 0, 1, 0)
    autoTpBtn.Position = UDim2.new(0.514, 0, 0, 0)
    autoTpBtn.BackgroundColor3 = Color3.fromRGB(45, 28, 35)
    autoTpBtn.Text = "🔁 AUTO TP [TẮT]"
    autoTpBtn.TextColor3 = Theme.AccentOff
    autoTpBtn.Font = Enum.Font.GothamBold
    autoTpBtn.TextSize = 10
    autoTpBtn.AutoButtonColor = false
    autoTpBtn.ZIndex = 10
    Instance.new("UICorner", autoTpBtn).CornerRadius = UDim.new(0, 6)
    local autoTpStroke = Instance.new("UIStroke", autoTpBtn)
    autoTpStroke.Color = Theme.AccentOff
    autoTpStroke.Thickness = 1; autoTpStroke.Transparency = 0.25
    table.insert(RGBElements, {Type = "Toggle", Stroke = autoTpStroke, State = function() return autoTpPlayerEnabled end})

    local function updateAutoTpBtnUI()
        autoTpBtn.Text = autoTpPlayerEnabled and "🔁 AUTO TP [BẬT]" or "🔁 AUTO TP [TẮT]"
        autoTpBtn.TextColor3 = autoTpPlayerEnabled and Theme.AccentOn or Theme.AccentOff
        autoTpBtn.BackgroundColor3 = autoTpPlayerEnabled and Color3.fromRGB(28, 48, 38) or Color3.fromRGB(45, 28, 35)
        if not State.RGB then
            autoTpStroke.Color = autoTpPlayerEnabled and Theme.AccentOn or Theme.AccentOff
        end
    end

    local function updateSpectateBtnUI()
        spectateBtn.Text = spectatePlayerEnabled and "👁️ XEM [BẬT]" or "👁️ XEM [TẮT]"
        spectateBtn.TextColor3 = spectatePlayerEnabled and Theme.AccentOn or Theme.AccentOff
        spectateBtn.BackgroundColor3 = spectatePlayerEnabled and Color3.fromRGB(28, 48, 38) or Color3.fromRGB(45, 28, 35)
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

    playerListContainer = Instance.new("Frame", page7)
    playerListContainer.Size = UDim2.new(0.94, 0, 1, -122)
    playerListContainer.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
    playerListContainer.LayoutOrder = 3
    playerListContainer.ZIndex = 10
    Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 8)
    local listContainerStroke = Instance.new("UIStroke", playerListContainer)
    listContainerStroke.Color = Theme.Stroke
    listContainerStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = listContainerStroke})

    playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
    playerListScroll.Size = UDim2.new(1, -6, 1, -8)
    playerListScroll.Position = UDim2.new(0, 3, 0, 4)
    playerListScroll.BackgroundTransparency = 1
    playerListScroll.BorderSizePixel = 0
    playerListScroll.ScrollBarThickness = 3
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
    playerScrollPad.PaddingRight = UDim.new(0, 4)

    local function updatePlayerList()
        playerDistLabels = {}
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
                btn.BackgroundColor3 = isSelected and Theme.ItemActive or Theme.ItemBg
                btn.Text = ""
                btn.AutoButtonColor = false
                btn.ZIndex = 10
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
                
                local stroke = Instance.new("UIStroke", btn)
                stroke.Color = isSelected and Theme.AccentOn or Theme.Stroke
                stroke.Thickness = 1
                table.insert(RGBElements, {Type = "Info", Stroke = stroke})

                -- Avatar tròn nằm bên trái (Kiểu Discord hiện đại)
                local targetAvatar = Instance.new("ImageLabel", btn)
                targetAvatar.Size = UDim2.new(0, 24, 0, 24)
                targetAvatar.Position = UDim2.new(0, 6, 0.5, -12)
                targetAvatar.BackgroundColor3 = Color3.fromRGB(30, 34, 46)
                targetAvatar.ZIndex = 11
                Instance.new("UICorner", targetAvatar).CornerRadius = UDim.new(1, 0)
                
                local targetStroke = Instance.new("UIStroke", targetAvatar)
                targetStroke.Color = isSelected and Theme.AccentOn or Theme.Brand
                targetStroke.Thickness = 1
                targetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                table.insert(RGBElements, {Type = "Info", Stroke = targetStroke})
                
                local nLabel = Instance.new("TextLabel", btn)
                nLabel.Size = UDim2.new(1, -96, 0, 15)
                nLabel.Position = UDim2.new(0, 36, 0, 3)
                nLabel.BackgroundTransparency = 1
                nLabel.Text = (isSelected and "✅ " or "") .. p.DisplayName
                nLabel.TextColor3 = isSelected and Theme.AccentOn or Theme.TextTitle
                nLabel.Font = Enum.Font.GothamBold
                nLabel.TextSize = 10.5
                nLabel.TextTruncate = Enum.TextTruncate.AtEnd
                nLabel.TextXAlignment = Enum.TextXAlignment.Left
                nLabel.ZIndex = 11
                
                local subLabel = Instance.new("TextLabel", btn)
                subLabel.Size = UDim2.new(1, -96, 0, 13)
                subLabel.Position = UDim2.new(0, 36, 0, 17)
                subLabel.BackgroundTransparency = 1
                subLabel.Text = "@" .. p.Name
                subLabel.TextColor3 = Theme.TextDim
                subLabel.Font = Enum.Font.GothamSemibold
                subLabel.TextSize = 9
                subLabel.TextTruncate = Enum.TextTruncate.AtEnd
                subLabel.TextXAlignment = Enum.TextXAlignment.Left
                subLabel.ZIndex = 11

                -- Nhãn khoảng cách thời gian thực bên phải
                local distPill = Instance.new("TextLabel", btn)
                distPill.Size = UDim2.new(0, 50, 0, 18)
                distPill.Position = UDim2.new(1, -56, 0.5, -9)
                distPill.BackgroundColor3 = Color3.fromRGB(18, 20, 29)
                distPill.Text = "-- m"
                distPill.TextColor3 = Theme.Brand
                distPill.Font = Enum.Font.GothamBold
                distPill.TextSize = 9
                distPill.ZIndex = 11
                Instance.new("UICorner", distPill).CornerRadius = UDim.new(0, 5)
                playerDistLabels[p] = distPill
                
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

    task.spawn(function()
        while task.wait(0.5) do
            if page7.Visible then
                local myRoot = getUniversalRoot(player.Character)
                for p, lbl in pairs(playerDistLabels) do
                    if p and p.Parent and lbl and lbl.Parent then
                        local tCF = getCharacterCFrame(p.Character)
                        if myRoot and tCF then
                            lbl.Text = tostring(math.floor((myRoot.Position - tCF.Position).Magnitude)) .. " m"
                        else
                            lbl.Text = "-- m"
                        end
                    end
                end
            end
        end
    end)

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
end

-- ==========================================
-- [TAB 8: AUTO SKILL (LƯỚI KEYCAP 2 CỘT HIỆN ĐẠI)]
-- ==========================================
createDivider(page8, "TỐC ĐỘ KÍCH HOẠT CHIÊU")
createSlider(page8, "⏱️ Chu kỳ nhấn phím (x0.1 giây)", 1, 50, "AutoSkillDelay")

local function createKeycapGrid(parent, keysList)
    local gridContainer = Instance.new("Frame", parent)
    local rows = math.ceil(#keysList / 2)
    gridContainer.Size = UDim2.new(0.94, 0, 0, rows * 34 + (rows - 1) * 5)
    gridContainer.BackgroundTransparency = 1
    gridContainer.ZIndex = 10

    local grid = Instance.new("UIGridLayout", gridContainer)
    grid.CellSize = UDim2.new(0.488, 0, 0, 34)
    grid.CellPadding = UDim2.new(0.024, 0, 0, 5)
    grid.SortOrder = Enum.SortOrder.LayoutOrder

    for idx, item in ipairs(keysList) do
        local cell = Instance.new("TextButton", gridContainer)
        cell.LayoutOrder = idx
        cell.Text = ""
        cell.AutoButtonColor = false
        cell.ZIndex = 10
        Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 8)
        local cStroke = Instance.new("UIStroke", cell); cStroke.Thickness = 1

        -- Ô biểu tượng phím (Keycap)
        local keycap = Instance.new("TextLabel", cell)
        keycap.Size = UDim2.new(0, 24, 0, 22); keycap.Position = UDim2.new(0, 6, 0.5, -11)
        keycap.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
        keycap.Text = item.Key
        keycap.Font = Enum.Font.GothamBlack; keycap.TextSize = 10.5; keycap.ZIndex = 11
        Instance.new("UICorner", keycap).CornerRadius = UDim.new(0, 5)
        local kStroke = Instance.new("UIStroke", keycap); kStroke.Thickness = 1

        local kTitle = Instance.new("TextLabel", cell)
        kTitle.Size = UDim2.new(1, -78, 1, 0); kTitle.Position = UDim2.new(0, 35, 0, 0)
        kTitle.BackgroundTransparency = 1; kTitle.Text = "Phím " .. item.Key
        kTitle.TextColor3 = Theme.TextTitle; kTitle.Font = Enum.Font.GothamSemibold; kTitle.TextSize = 10
        kTitle.TextXAlignment = Enum.TextXAlignment.Left; kTitle.ZIndex = 11

        local miniTrack = Instance.new("Frame", cell)
        miniTrack.Size = UDim2.new(0, 32, 0, 16); miniTrack.Position = UDim2.new(1, -38, 0.5, -8)
        miniTrack.BorderSizePixel = 0; miniTrack.ZIndex = 11
        Instance.new("UICorner", miniTrack).CornerRadius = UDim.new(1, 0)

        local miniKnob = Instance.new("Frame", miniTrack)
        miniKnob.Size = UDim2.new(0, 12, 0, 12); miniKnob.BorderSizePixel = 0; miniKnob.ZIndex = 12
        Instance.new("UICorner", miniKnob).CornerRadius = UDim.new(1, 0)

        local function syncKeyVisual(isOn, instant)
            local tInfo = TweenInfo.new(instant and 0 or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(cell, tInfo, {BackgroundColor3 = isOn and Theme.ItemActive or Theme.ItemBg}):Play()
            TweenService:Create(keycap, tInfo, {TextColor3 = isOn and Theme.AccentOn or Theme.Brand}):Play()
            TweenService:Create(kStroke, tInfo, {Color = isOn and Theme.AccentOn or Theme.Stroke}):Play()
            TweenService:Create(miniTrack, tInfo, {BackgroundColor3 = isOn and Color3.fromRGB(34, 118, 82) or Color3.fromRGB(16, 18, 26)}):Play()
            TweenService:Create(miniKnob, tInfo, {
                Position = isOn and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
                BackgroundColor3 = isOn and Color3.fromRGB(240, 255, 245) or Color3.fromRGB(125, 135, 155)
            }):Play()
            if not State.RGB then
                TweenService:Create(cStroke, tInfo, {Color = isOn and Color3.fromRGB(54, 140, 98) or Theme.Stroke}):Play()
            end
        end

        syncKeyVisual(State[item.Var] and true or false, true)
        table.insert(RGBElements, {Type = "Toggle", Stroke = cStroke, State = function() return State[item.Var] end})

        cell.MouseButton1Click:Connect(function()
            clickAnimate(cell)
            State[item.Var] = not State[item.Var]
            local nowOn = State[item.Var]
            syncKeyVisual(nowOn, false)
            MakeToast(nowOn and "Đã Bật Auto Skill" or "Đã Tắt Auto Skill", "Tự động kích hoạt Phím [" .. item.Key .. "]", nowOn and Theme.AccentOn or Theme.AccentOff)
            if State.AutoSave then saveConfig() end
        end)
    end
end

createDivider(page8, "BẢNG PHÍM CHỮ (2 CỘT)")
createKeycapGrid(page8, {
    {Key = "Z", Var = "AutoSkillZ"},
    {Key = "X", Var = "AutoSkillX"},
    {Key = "C", Var = "AutoSkillC"},
    {Key = "V", Var = "AutoSkillV"},
    {Key = "E", Var = "AutoSkillE"},
    {Key = "F", Var = "AutoSkillF"}
})

createDivider(page8, "BẢNG PHÍM SỐ (2 CỘT)")
createKeycapGrid(page8, {
    {Key = "1", Var = "AutoSkill1"},
    {Key = "2", Var = "AutoSkill2"},
    {Key = "3", Var = "AutoSkill3"},
    {Key = "4", Var = "AutoSkill4"},
    {Key = "5", Var = "AutoSkill5"},
    {Key = "6", Var = "AutoSkill6"}
})

task.spawn(function()
    while true do
        local waitTime = math.clamp((tonumber(State.AutoSkillDelay) or 5) * 0.1, 0.1, 5)
        task.wait(waitTime)
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
                task.wait(0.04) 
            end
        end
    end
end)

-- ==========================================
-- [TAB 9: CẤU HÌNH (LIVE MONITOR HIỆN ĐẠI)]
-- ==========================================
;(function()
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
        local frameItem, applyVis = createToggle(parent, text, varName, callback)
        Cache.Toggles[varName] = function(targetState)
            if State[varName] ~= targetState then
                State[varName] = targetState
                if applyVis then applyVis(targetState, false) end
                if callback then task.spawn(callback, targetState) end
            end
        end
        return frameItem
    end

    local liveMonitorCard = Instance.new("Frame", page9)
    liveMonitorCard.Size = UDim2.new(0.94, 0, 0, 52)
    liveMonitorCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    liveMonitorCard.ZIndex = 10
    Instance.new("UICorner", liveMonitorCard).CornerRadius = UDim.new(0, 8)
    addSoftGradient(liveMonitorCard, Color3.fromRGB(25, 32, 46), Color3.fromRGB(19, 22, 32), 0)
    local monitorStroke = Instance.new("UIStroke", liveMonitorCard)
    monitorStroke.Color = Theme.Brand
    monitorStroke.Thickness = 1.1; monitorStroke.Transparency = 0.25
    table.insert(RGBElements, {Type = "Button", Stroke = monitorStroke, DefaultColor = Theme.Brand})

    local monitorTitle = Instance.new("TextLabel", liveMonitorCard)
    monitorTitle.Size = UDim2.new(1, -16, 0, 15)
    monitorTitle.Position = UDim2.new(0, 10, 0, 4)
    monitorTitle.BackgroundTransparency = 1
    monitorTitle.Text = "📊 THÔNG SỐ HIỆU NĂNG THỜI GIAN THỰC (LIVE MONITOR)"
    monitorTitle.TextColor3 = Theme.Brand
    monitorTitle.Font = Enum.Font.GothamBold
    monitorTitle.TextSize = 9
    monitorTitle.TextXAlignment = Enum.TextXAlignment.Left
    monitorTitle.ZIndex = 10

    local monitorStatsLabel = Instance.new("TextLabel", liveMonitorCard)
    monitorStatsLabel.Size = UDim2.new(1, -20, 0, 28)
    monitorStatsLabel.Position = UDim2.new(0, 10, 0, 20)
    monitorStatsLabel.BackgroundTransparency = 1
    monitorStatsLabel.RichText = true
    monitorStatsLabel.TextColor3 = Theme.TextTitle
    monitorStatsLabel.Font = Enum.Font.GothamSemibold
    monitorStatsLabel.TextSize = 10
    monitorStatsLabel.LineHeight = 1.15
    monitorStatsLabel.TextXAlignment = Enum.TextXAlignment.Left
    monitorStatsLabel.TextYAlignment = Enum.TextYAlignment.Top
    monitorStatsLabel.ZIndex = 10

    local function refreshLiveMonitor()
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
        local fpsColor = fps >= 45 and "#38CC88" or (fps >= 25 and "#E5B85B" or "#E05666")
        monitorStatsLabel.Text = string.format(
            "⚡ FPS: <font color='%s'>%d</font>   |   🌐 Ping: <font color='#58B6F2'>%s</font>\n🧠 RAM: <font color='#E5A55D'>%d MB</font>   |   🧱 Vật thể (Parts): <font color='#A89EE8'>%d</font>",
            fpsColor, fps, pingStr, ramMB, Cache.PartCount
        )
    end

    onTab9Shown = refreshLiveMonitor
    refreshLiveMonitor()

    task.spawn(function()
        for i, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then Cache.PartCount = Cache.PartCount + 1 end
            if i % 500 == 0 then task.wait() end
        end
        refreshLiveMonitor()
    end)
    workspace.DescendantAdded:Connect(function(v)
        if v:IsA("BasePart") then Cache.PartCount = Cache.PartCount + 1 end
    end)
    workspace.DescendantRemoving:Connect(function(v)
        if v:IsA("BasePart") then Cache.PartCount = math.max(0, Cache.PartCount - 1) end
    end)

    task.spawn(function()
        while task.wait(0.6) do
            if page9.Visible then
                refreshLiveMonitor()
            end
        end
    end)

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

    createDivider(page9, "TỐI ƯU HIỆU SUẤT TỐI ĐA")

    createButton(page9, "🥔 SIÊU KHOAI TÂY (1-Click Ultra Boost)", Color3.fromRGB(230, 185, 70), function()
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
-- [ESP GỌN ĐẸP + XUYÊN STREAMING]
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
                    tLabel.TextColor3 = Color3.fromRGB(255, 75, 85)
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
                    hl.FillColor = Color3.fromRGB(255, 65, 75)
                    hl.FillTransparency = 0.65
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.OutlineTransparency = 0.1
                    hl.Parent = guiParent
                    data.Highlight = hl
                end
                data.Highlight.Adornee = tChar

                if myPos then
                    local dist = math.floor((myPos - targetPos).Magnitude)
                    data.Billboard.NameLabel.Text = p.DisplayName .. '\n<font color="#78D2FF">[' .. dist .. 'm]</font>'
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

RunService.Heartbeat:Connect(function()
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

    local ExtCache = {
        Popups = {},
        Sounds = {},
        Anims = {},
        DarkParts = {},
        LightingOrig = nil,
        Tickets = {Popup = 0, Sound = 0, Anim = 0, Dark = 0}
    }

    pcall(function()
        if playerListContainer and playerListScroll then
            local searchBar = Instance.new("Frame", playerListContainer)
            searchBar.Size = UDim2.new(1, -8, 0, 22)
            searchBar.Position = UDim2.new(0, 4, 0, 4)
            searchBar.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
            searchBar.ZIndex = 11
            Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 6)
            local sStroke = Instance.new("UIStroke", searchBar)
            sStroke.Color = Theme.Brand
            sStroke.Thickness = 0.9; sStroke.Transparency = 0.35
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
            searchBox.TextSize = 9.5
            searchBox.TextXAlignment = Enum.TextXAlignment.Left
            searchBox.ClearTextOnFocus = false
            searchBox.ZIndex = 11

            playerListScroll.Size = UDim2.new(1, -6, 1, -32)
            playerListScroll.Position = UDim2.new(0, 3, 0, 28)

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

    createDivider(page9, "TỐI ƯU CHUYÊN SÂU SIMULATOR")

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

    createDivider(page4, "TIỆN ÍCH TREO MÁY & HỖ TRỢ")

    local miniHudFrame = Instance.new("Frame", gui)
    miniHudFrame.Size = UDim2.new(0, 128, 0, 26)
    miniHudFrame.Position = UDim2.new(0, 66, 0.26, 9)
    miniHudFrame.BackgroundColor3 = Theme.MainBg
    miniHudFrame.BackgroundTransparency = 0.12
    miniHudFrame.Visible = State.MiniHUD
    miniHudFrame.ZIndex = 10
    Instance.new("UICorner", miniHudFrame).CornerRadius = UDim.new(1, 0)
    local hudStroke = Instance.new("UIStroke", miniHudFrame)
    hudStroke.Color = Theme.Brand
    hudStroke.Thickness = 1.2
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
                local fCol = fps >= 45 and "#38CC88" or (fps >= 25 and "#E5B85B" or "#E05666")
                hudLabel.Text = string.format("⚡ <font color='%s'>%d FPS</font> | 🌐 <font color='#58B6F2'>%d ms</font>", fCol, fps, pingNum)
            end
        end
    end)

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
-- [TAB 1: DASHBOARD BENTO + QUẢN LÝ SERVER]
-- ==========================================
;(function()
    if not page1 then return end

    for _, child in ipairs(page1:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local savedServersFile = "MenuVipProMax_SavedServers.json"
    local savedServers = {}
    pcall(function()
        if isfile and isfile(savedServersFile) then
            local dec = HttpService:JSONDecode(readfile(savedServersFile))
            if type(dec) == "table" then savedServers = dec end
        end
    end)
    local function saveServerList()
        pcall(function()
            if writefile then writefile(savedServersFile, HttpService:JSONEncode(savedServers)) end
        end)
    end

    local gameName = "Đang tải..."
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

    -- HÀNG 4 Ô BENTO THỐNG KÊ NHANH (QUICK STATS ROW)
    local bentoRow = Instance.new("Frame", page1)
    bentoRow.Size = UDim2.new(0.94, 0, 0, 38)
    bentoRow.BackgroundTransparency = 1
    bentoRow.LayoutOrder = 0
    bentoRow.ZIndex = 10

    local bentoGrid = Instance.new("UIGridLayout", bentoRow)
    bentoGrid.CellSize = UDim2.new(0.235, 0, 1, 0)
    bentoGrid.CellPadding = UDim2.new(0.02, 0, 0, 0)
    bentoGrid.SortOrder = Enum.SortOrder.LayoutOrder

    local function makeBentoStat(order, labelText, defaultVal, valColor)
        local box = Instance.new("Frame", bentoRow)
        box.LayoutOrder = order
        box.BackgroundColor3 = Theme.ItemBg
        box.ZIndex = 10
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
        local st = Instance.new("UIStroke", box); st.Color = Theme.Stroke; st.Thickness = 1
        table.insert(RGBElements, {Type = "Info", Stroke = st})

        local t = Instance.new("TextLabel", box)
        t.Size = UDim2.new(1, 0, 0, 13); t.Position = UDim2.new(0, 0, 0, 4)
        t.BackgroundTransparency = 1; t.Text = labelText; t.TextColor3 = Theme.TextDim
        t.Font = Enum.Font.GothamBold; t.TextSize = 8; t.ZIndex = 11

        local v = Instance.new("TextLabel", box)
        v.Size = UDim2.new(1, 0, 0, 18); v.Position = UDim2.new(0, 0, 0, 17)
        v.BackgroundTransparency = 1; v.Text = defaultVal; v.TextColor3 = valColor
        v.Font = Enum.Font.GothamBlack; v.TextSize = 11; v.ZIndex = 11
        return v
    end

    local bFpsVal = makeBentoStat(1, "⚡ FPS", "60", Theme.AccentOn)
    local bPingVal = makeBentoStat(2, "🌐 PING", "0 ms", Theme.Brand)
    local bPlrVal = makeBentoStat(3, "👥 SERVER", "1/1", Color3.fromRGB(235, 195, 95))
    local bActVal = makeBentoStat(4, "🔥 ĐANG BẬT", "0", Color3.fromRGB(185, 140, 245))

    local function makeSoftMiniBtn(parent, text, posUDim, sizeUDim, textCol, bgCol, borderCol)
        local btn = Instance.new("TextButton", parent)
        btn.Size = sizeUDim
        btn.Position = posUDim
        btn.BackgroundColor3 = bgCol
        btn.Text = text
        btn.TextColor3 = textCol
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 8.5
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local st = Instance.new("UIStroke", btn)
        st.Color = borderCol
        st.Thickness = 1
        st.Transparency = 0.35
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        return btn, st
    end

    local function makeCard(titleIcon, titleText, height, order)
        local card = Instance.new("Frame", page1)
        card.Size = UDim2.new(0.94, 0, 0, height)
        card.BackgroundColor3 = Theme.ItemBg
        card.LayoutOrder = order
        card.ZIndex = 10
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Theme.Stroke
        stroke.Thickness = 1
        table.insert(RGBElements, {Type = "Info", Stroke = stroke})

        local headerTitle = Instance.new("TextLabel", card)
        headerTitle.Size = UDim2.new(1, -16, 0, 19)
        headerTitle.Position = UDim2.new(0, 10, 0, 3)
        headerTitle.BackgroundTransparency = 1
        headerTitle.Text = titleIcon .. " " .. titleText
        headerTitle.TextColor3 = Theme.Brand
        headerTitle.Font = Enum.Font.GothamBold
        headerTitle.TextSize = 9.5
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        headerTitle.ZIndex = 10

        local line = Instance.new("Frame", card)
        line.Size = UDim2.new(1, -20, 0, 1)
        line.Position = UDim2.new(0, 10, 0, 22)
        line.BackgroundColor3 = Theme.Stroke
        line.BorderSizePixel = 0
        line.ZIndex = 10

        local body = Instance.new("TextLabel", card)
        body.Size = UDim2.new(1, -20, 1, -28)
        body.Position = UDim2.new(0, 10, 0, 25)
        body.BackgroundTransparency = 1
        body.RichText = true
        body.Text = "Đang tải..."
        body.TextColor3 = Color3.fromRGB(205, 214, 228)
        body.Font = Enum.Font.Gotham
        body.TextSize = 10
        body.LineHeight = 1.18
        body.TextXAlignment = Enum.TextXAlignment.Left
        body.TextYAlignment = Enum.TextYAlignment.Top
        body.ZIndex = 10

        return card, body
    end

    -- 1. THẺ NHÂN VẬT
    local charCard, charBody = makeCard("👤", "THÔNG TIN NHÂN VẬT", 112, 1)

    local copyCoordBtn = makeSoftMiniBtn(
        charCard, "📍 Copy Tọa Độ",
        UDim2.new(1, -84, 0, 3), UDim2.new(0, 76, 0, 16),
        Color3.fromRGB(175, 215, 240), Color3.fromRGB(28, 38, 48), Color3.fromRGB(80, 130, 165)
    )
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
    hpBarBg.Size = UDim2.new(1, -20, 0, 4)
    hpBarBg.Position = UDim2.new(0, 10, 1, -7)
    hpBarBg.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    hpBarBg.BorderSizePixel = 0
    hpBarBg.ZIndex = 11
    Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(1, 0)

    local hpBarFill = Instance.new("Frame", hpBarBg)
    hpBarFill.Size = UDim2.new(1, 0, 1, 0)
    hpBarFill.BackgroundColor3 = Theme.AccentOn
    hpBarFill.BorderSizePixel = 0
    hpBarFill.ZIndex = 11
    Instance.new("UICorner", hpBarFill).CornerRadius = UDim.new(1, 0)

    -- 2. THẺ MÁY CHỦ
    local svCard, svBody = makeCard("🌐", "THÔNG TIN MÁY CHỦ", 96, 2)

    local resetCharBtn = makeSoftMiniBtn(
        svCard, "🔄 Reset NV",
        UDim2.new(1, -78, 0, 3), UDim2.new(0, 70, 0, 16),
        Color3.fromRGB(230, 165, 170), Color3.fromRGB(45, 28, 34), Color3.fromRGB(155, 75, 85)
    )
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

    -- 3. THẺ TRẠNG THÁI & HỆ THỐNG
    local sysCard, sysBody = makeCard("⚙️", "TRẠNG THÁI & HỆ THỐNG", 86, 3)

    -- 4. KHUNG QUẢN LÝ & KẾT NỐI ID SERVER
    local idToolCard = Instance.new("Frame", page1)
    idToolCard.Size = UDim2.new(0.94, 0, 0, 88)
    idToolCard.BackgroundColor3 = Theme.ItemBg
    idToolCard.LayoutOrder = 4
    idToolCard.ZIndex = 10
    Instance.new("UICorner", idToolCard).CornerRadius = UDim.new(0, 8)
    local itStroke = Instance.new("UIStroke", idToolCard)
    itStroke.Color = Theme.Stroke
    itStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = itStroke})

    local idHeader = Instance.new("TextLabel", idToolCard)
    idHeader.Size = UDim2.new(1, -16, 0, 17)
    idHeader.Position = UDim2.new(0, 10, 0, 3)
    idHeader.BackgroundTransparency = 1
    idHeader.Text = "🔑 QUẢN LÝ & KẾT NỐI ID SERVER"
    idHeader.TextColor3 = Theme.Brand
    idHeader.Font = Enum.Font.GothamBold
    idHeader.TextSize = 9.5
    idHeader.TextXAlignment = Enum.TextXAlignment.Left
    idHeader.ZIndex = 10

    local inputBg = Instance.new("Frame", idToolCard)
    inputBg.Size = UDim2.new(1, -16, 0, 26)
    inputBg.Position = UDim2.new(0, 8, 0, 22)
    inputBg.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    inputBg.ZIndex = 10
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 6)
    local ibStroke = Instance.new("UIStroke", inputBg)
    ibStroke.Color = Theme.Stroke
    ibStroke.Thickness = 1

    local jobInput = Instance.new("TextBox", inputBg)
    jobInput.Size = UDim2.new(0.55, 0, 1, 0)
    jobInput.Position = UDim2.new(0.03, 0, 0, 0)
    jobInput.BackgroundTransparency = 1
    jobInput.PlaceholderText = "🔍 Dán ID Server cần vào..."
    jobInput.PlaceholderColor3 = Theme.TextDim
    jobInput.Text = ""
    jobInput.TextColor3 = Color3.fromRGB(195, 215, 235)
    jobInput.Font = Enum.Font.Gotham
    jobInput.TextSize = 9.5
    jobInput.TextXAlignment = Enum.TextXAlignment.Left
    jobInput.ClearTextOnFocus = false
    jobInput.ZIndex = 10

    local clearBtn = makeSoftMiniBtn(
        inputBg, "XÓA",
        UDim2.new(0.59, 0, 0.14, 0), UDim2.new(0.17, 0, 0.72, 0),
        Color3.fromRGB(200, 205, 215), Color3.fromRGB(38, 40, 52), Color3.fromRGB(75, 80, 100)
    )
    clearBtn.MouseButton1Click:Connect(function()
        clickAnimate(clearBtn)
        jobInput.Text = ""
    end)

    local joinBtnNew = makeSoftMiniBtn(
        inputBg, "VÀO",
        UDim2.new(0.78, 0, 0.14, 0), UDim2.new(0.19, 0, 0.72, 0),
        Color3.fromRGB(210, 245, 225), Color3.fromRGB(35, 110, 72), Color3.fromRGB(65, 175, 115)
    )
    joinBtnNew.MouseButton1Click:Connect(function()
        clickAnimate(joinBtnNew)
        local targetId = jobInput.Text:gsub("%s+", "")
        if targetId ~= "" then
            MakeToast("Đang Vào Server", "Đang kết nối tới ID Server...", Theme.AccentOn)
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player) end)
        else
            MakeToast("⚠️ Trống ID", "Bạn chưa dán ID Server vào ô!", Theme.AccentOff)
        end
    end)

    local btnCopyIdDown = makeSoftMiniBtn(
        idToolCard, "📜 Copy ID SV",
        UDim2.new(0, 8, 0, 54), UDim2.new(0.31, -4, 0, 24),
        Color3.fromRGB(165, 220, 185), Color3.fromRGB(28, 42, 35), Color3.fromRGB(75, 145, 105)
    )
    local btnSaveSv = makeSoftMiniBtn(
        idToolCard, "📌 Lưu ID SV Này",
        UDim2.new(0.345, 2, 0, 54), UDim2.new(0.31, -4, 0, 24),
        Color3.fromRGB(175, 215, 240), Color3.fromRGB(28, 38, 48), Color3.fromRGB(75, 125, 160)
    )
    local btnCopyScript = makeSoftMiniBtn(
        idToolCard, "📤 Copy Lệnh Join",
        UDim2.new(0.69, 0, 0, 54), UDim2.new(0.31, -8, 0, 24),
        Color3.fromRGB(225, 205, 155), Color3.fromRGB(42, 38, 28), Color3.fromRGB(145, 125, 70)
    )

    btnCopyIdDown.MouseButton1Click:Connect(function()
        clickAnimate(btnCopyIdDown)
        pcall(function()
            if setclipboard then
                setclipboard(tostring(game.JobId))
                MakeToast("Đã Copy ID SV", "Đã lưu JobId hiện tại vào bộ nhớ tạm!", Theme.AccentOn)
            end
        end)
    end)

    btnCopyScript.MouseButton1Click:Connect(function()
        clickAnimate(btnCopyScript)
        pcall(function()
            if setclipboard and game.JobId ~= "" then
                local joinScript = string.format(
                    'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)',
                    game.PlaceId, game.JobId
                )
                setclipboard(joinScript)
                MakeToast("Đã Copy Lệnh Join", "Gửi lệnh này cho bạn bè để vào chung SV!", Theme.AccentOn)
            end
        end)
    end)

    -- 5. DANH SÁCH & BỘ LỌC SERVER
    local svListCard = Instance.new("Frame", page1)
    svListCard.Size = UDim2.new(0.94, 0, 0, 144)
    svListCard.BackgroundColor3 = Theme.ItemBg
    svListCard.LayoutOrder = 5
    svListCard.ZIndex = 10
    Instance.new("UICorner", svListCard).CornerRadius = UDim.new(0, 8)
    local slStroke = Instance.new("UIStroke", svListCard)
    slStroke.Color = Theme.Stroke
    slStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = slStroke})

    local tabFilterRow = Instance.new("Frame", svListCard)
    tabFilterRow.Size = UDim2.new(1, -12, 0, 22)
    tabFilterRow.Position = UDim2.new(0, 6, 0, 5)
    tabFilterRow.BackgroundTransparency = 1
    tabFilterRow.ZIndex = 11

    local tabBtnSaved, stSaved = makeSoftMiniBtn(
        tabFilterRow, "💾 Đã Lưu",
        UDim2.new(0, 0, 0, 0), UDim2.new(0.24, -2, 1, 0),
        Color3.fromRGB(210, 235, 255), Color3.fromRGB(35, 65, 90), Color3.fromRGB(90, 165, 220)
    )
    local tabBtnLow, stLow = makeSoftMiniBtn(
        tabFilterRow, "📉 Ít Người",
        UDim2.new(0.25, 1, 0, 0), UDim2.new(0.25, -2, 1, 0),
        Color3.fromRGB(175, 215, 240), Color3.fromRGB(22, 24, 34), Color3.fromRGB(65, 75, 95)
    )
    local tabBtnHigh, stHigh = makeSoftMiniBtn(
        tabFilterRow, "📈 Đông Người",
        UDim2.new(0.50, 1, 0, 0), UDim2.new(0.25, -2, 1, 0),
        Color3.fromRGB(175, 215, 240), Color3.fromRGB(22, 24, 34), Color3.fromRGB(65, 75, 95)
    )
    local tabBtnPing, stPing = makeSoftMiniBtn(
        tabFilterRow, "⚡ Ping Thấp",
        UDim2.new(0.75, 1, 0, 0), UDim2.new(0.25, -1, 1, 0),
        Color3.fromRGB(175, 215, 240), Color3.fromRGB(22, 24, 34), Color3.fromRGB(65, 75, 95)
    )

    local filterButtons = {
        {btn = tabBtnSaved, st = stSaved},
        {btn = tabBtnLow,   st = stLow},
        {btn = tabBtnHigh,  st = stHigh},
        {btn = tabBtnPing,  st = stPing}
    }
    local function highlightFilterTab(activeBtn)
        for _, item in ipairs(filterButtons) do
            local isAct = (item.btn == activeBtn)
            item.btn.BackgroundColor3 = isAct and Color3.fromRGB(35, 65, 90) or Color3.fromRGB(22, 24, 34)
            item.btn.TextColor3 = isAct and Color3.fromRGB(220, 240, 255) or Color3.fromRGB(150, 165, 185)
            item.st.Color = isAct and Color3.fromRGB(90, 165, 220) or Color3.fromRGB(65, 75, 95)
        end
    end

    local svListTitle = Instance.new("TextLabel", svListCard)
    svListTitle.Size = UDim2.new(1, -16, 0, 15)
    svListTitle.Position = UDim2.new(0, 10, 0, 30)
    svListTitle.BackgroundTransparency = 1
    svListTitle.Text = "📋 DANH SÁCH ID SERVER ĐÃ LƯU"
    svListTitle.TextColor3 = Theme.Brand
    svListTitle.Font = Enum.Font.GothamBold
    svListTitle.TextSize = 9
    svListTitle.TextXAlignment = Enum.TextXAlignment.Left
    svListTitle.ZIndex = 10

    local svScroll = Instance.new("ScrollingFrame", svListCard)
    svScroll.Size = UDim2.new(1, -12, 1, -50)
    svScroll.Position = UDim2.new(0, 6, 0, 46)
    svScroll.BackgroundTransparency = 1
    svScroll.BorderSizePixel = 0
    svScroll.ScrollBarThickness = 3
    svScroll.ScrollBarImageColor3 = Theme.Brand
    svScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    svScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    svScroll.ZIndex = 10

    local svLayout = Instance.new("UIListLayout", svScroll)
    svLayout.SortOrder = Enum.SortOrder.LayoutOrder
    svLayout.Padding = UDim.new(0, 4)

    local function renderServerList(customList, isScanned)
        for _, ch in ipairs(svScroll:GetChildren()) do
            if ch:IsA("Frame") then ch:Destroy() end
        end
        local listToRender = customList or savedServers
        if #listToRender == 0 then
            local empty = Instance.new("Frame", svScroll)
            empty.Size = UDim2.new(1, 0, 0, 28)
            empty.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", empty)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = isScanned and "Không tìm thấy server phù hợp!" or "Chưa có ID nào. Bấm 'Lưu ID SV Này' hoặc chọn ô bên trên!"
            lbl.TextColor3 = Theme.TextDim
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 9
            lbl.ZIndex = 10
            return
        end

        for idx, item in ipairs(listToRender) do
            local row = Instance.new("Frame", svScroll)
            row.Size = UDim2.new(1, -6, 0, 25)
            row.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
            row.ZIndex = 10
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

            local infoTxt = Instance.new("TextLabel", row)
            infoTxt.Size = UDim2.new(0.56, 0, 1, 0)
            infoTxt.Position = UDim2.new(0, 8, 0, 0)
            infoTxt.BackgroundTransparency = 1
            infoTxt.Text = string.format("%s (%s)", item.label or ("SV #" .. idx), string.sub(item.id, 1, 10) .. "..")
            infoTxt.TextColor3 = Color3.fromRGB(195, 205, 220)
            infoTxt.Font = Enum.Font.Gotham
            infoTxt.TextSize = 9
            infoTxt.TextXAlignment = Enum.TextXAlignment.Left
            infoTxt.ZIndex = 10

            local pickBtn = makeSoftMiniBtn(
                row, "Lấy ID",
                UDim2.new(0.57, 0, 0.15, 0), UDim2.new(0.19, 0, 0.7, 0),
                Color3.fromRGB(175, 215, 240), Color3.fromRGB(30, 42, 54), Color3.fromRGB(75, 125, 160)
            )
            pickBtn.MouseButton1Click:Connect(function()
                clickAnimate(pickBtn)
                jobInput.Text = item.id
                if setclipboard then pcall(setclipboard, item.id) end
                MakeToast("Đã Điền ID", "Đã điền vào ô & copy ID Server!", Theme.Brand)
            end)

            local goBtn = makeSoftMiniBtn(
                row, isScanned and "Vào" or "Xóa",
                UDim2.new(0.78, 0, 0.15, 0), UDim2.new(0.19, 0, 0.7, 0),
                isScanned and Color3.fromRGB(170, 225, 190) or Color3.fromRGB(230, 165, 170),
                isScanned and Color3.fromRGB(28, 48, 36) or Color3.fromRGB(48, 28, 34),
                isScanned and Color3.fromRGB(70, 150, 100) or Color3.fromRGB(150, 75, 85)
            )
            goBtn.MouseButton1Click:Connect(function()
                clickAnimate(goBtn)
                if isScanned then
                    MakeToast("Đang Vào", "Đang chuyển sang Server đã chọn...", Theme.AccentOn)
                    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, item.id, player) end)
                else
                    table.remove(savedServers, idx)
                    saveServerList()
                    svListTitle.Text = "📋 DANH SÁCH ID SERVER ĐÃ LƯU (" .. #savedServers .. ")"
                    renderServerList(savedServers, false)
                end
            end)
        end
    end

    local function fetchAndShowServers(sortOrder, sortByPing, titlePrefix)
        svListTitle.Text = "⏳ Đang tải " .. titlePrefix .. "..."
        task.spawn(function()
            local scanned = {}
            pcall(function()
                local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=50"
                local res = game:HttpGet(url)
                local data = HttpService:JSONDecode(res)
                if data and data.data then
                    for _, s in ipairs(data.data) do
                        if s.id and s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
                            table.insert(scanned, {
                                id = s.id,
                                playing = tonumber(s.playing) or 0,
                                ping = tonumber(s.ping) or 999,
                                label = string.format("🌐 %d/%d người (%dms)", s.playing, s.maxPlayers, tonumber(s.ping) or 0)
                            })
                        end
                    end
                end
            end)
            if sortByPing and #scanned > 1 then
                table.sort(scanned, function(a, b) return a.ping < b.ping end)
            end
            svListTitle.Text = titlePrefix .. " (" .. #scanned .. " SV)"
            renderServerList(scanned, true)
        end)
    end

    tabBtnSaved.MouseButton1Click:Connect(function()
        clickAnimate(tabBtnSaved)
        highlightFilterTab(tabBtnSaved)
        svListTitle.Text = "📋 DANH SÁCH ID SERVER ĐÃ LƯU (" .. #savedServers .. ")"
        renderServerList(savedServers, false)
    end)

    tabBtnLow.MouseButton1Click:Connect(function()
        clickAnimate(tabBtnLow)
        highlightFilterTab(tabBtnLow)
        fetchAndShowServers("Asc", false, "📉 DANH SÁCH SV ÍT NGƯỜI")
    end)

    tabBtnHigh.MouseButton1Click:Connect(function()
        clickAnimate(tabBtnHigh)
        highlightFilterTab(tabBtnHigh)
        fetchAndShowServers("Desc", false, "📈 DANH SÁCH SV ĐÔNG NGƯỜI")
    end)

    tabBtnPing.MouseButton1Click:Connect(function()
        clickAnimate(tabBtnPing)
        highlightFilterTab(tabBtnPing)
        fetchAndShowServers("Asc", true, "⚡ DANH SÁCH SV PING THẤP")
    end)

    btnSaveSv.MouseButton1Click:Connect(function()
        clickAnimate(btnSaveSv)
        if game.JobId == "" then
            MakeToast("Lỗi", "Không lấy được JobId của server này!", Theme.AccentOff)
            return
        end
        highlightFilterTab(tabBtnSaved)
        for _, v in ipairs(savedServers) do
            if v.id == game.JobId then
                MakeToast("Thông báo", "ID Server này đã có trong danh sách lưu!", Theme.Brand)
                svListTitle.Text = "📋 DANH SÁCH ID SERVER ĐÃ LƯU (" .. #savedServers .. ")"
                renderServerList(savedServers, false)
                return
            end
        end
        table.insert(savedServers, 1, {
            id = game.JobId,
            label = string.format("📌 Lưu %s [%d/%d]", os.date("%H:%M"), #Players:GetPlayers(), Players.MaxPlayers)
        })
        saveServerList()
        svListTitle.Text = "📋 DANH SÁCH ID SERVER ĐÃ LƯU (" .. #savedServers .. ")"
        renderServerList(savedServers, false)
        MakeToast("Đã Lưu Server", "Đã thêm ID Server hiện tại vào mục Đã Lưu!", Theme.AccentOn)
    end)

    svListTitle.Text = "📋 DANH SÁCH ID SERVER ĐÃ LƯU (" .. #savedServers .. ")"
    renderServerList(savedServers, false)

    local function updateTab1Stats()
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
        local hpHex = hpRatio > 0.5 and "#38CC88" or (hpRatio > 0.25 and "#DFB868" or "#E05666")
        TweenService:Create(hpBarFill, TweenInfo.new(0.25), {
            Size = UDim2.new(hpRatio, 0, 1, 0),
            BackgroundColor3 = Color3.fromHex(hpHex)
        }):Play()

        charBody.Text = string.format(
            "<font color='#78B4DC'>• Tên:</font> %s <font color='#909AA8'>(@%s)</font>\n" ..
            "<font color='#78B4DC'>• ID / Tuổi:</font> %d <font color='#D8B870'>(%d ngày)</font>\n" ..
            "<font color='#78B4DC'>• Máu (HP):</font> <font color='%s'>%d / %d (%d%%)</font>\n" ..
            "<font color='#78B4DC'>• Tốc chạy:</font> <font color='#38CC88'>%d</font>   |   <font color='#78B4DC'>Nhảy:</font> <font color='#38CC88'>%d</font>\n" ..
            "<font color='#78B4DC'>• Tọa độ:</font> <font color='#D8B870'>%s</font>",
            player.DisplayName, player.Name,
            player.UserId, player.AccountAge,
            hpHex, hp, maxHp, math.floor(hpRatio * 100),
            ws, jp,
            coords
        )

        local pingNum = 0
        pcall(function()
            if Stats and Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem") then
                local raw = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                pingNum = tonumber(raw and raw:match("%d+")) or math.floor(player:GetNetworkPing() * 1000)
            else
                pingNum = math.floor(player:GetNetworkPing() * 1000)
            end
        end)
        local fpsHex = fps >= 45 and "#38CC88" or (fps >= 25 and "#DFB868" or "#E05666")
        local pingHex = pingNum <= 120 and "#38CC88" or (pingNum <= 220 and "#DFB868" or "#E05666")
        local shortJob = game.JobId ~= "" and (string.sub(game.JobId, 1, 18) .. "...") or "Private/Studio"

        local activeCount = 0
        for _, v in pairs(State) do
            if v == true then activeCount = activeCount + 1 end
        end

        -- Cập nhật 4 ô Bento đầu trang
        bFpsVal.Text = tostring(fps)
        bFpsVal.TextColor3 = Color3.fromHex(fpsHex)
        bPingVal.Text = pingNum .. " ms"
        bPingVal.TextColor3 = Color3.fromHex(pingHex)
        bPlrVal.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
        bActVal.Text = tostring(activeCount)

        svBody.Text = string.format(
            "<font color='#78B4DC'>• Tựa game:</font> <font color='#D8B870'>%s</font>\n" ..
            "<font color='#78B4DC'>• FPS:</font> <font color='%s'>%d</font>   |   <font color='#78B4DC'>Ping:</font> <font color='%s'>%d ms</font>\n" ..
            "<font color='#78B4DC'>• Người chơi:</font> %d / %d   |   <font color='#78B4DC'>PlaceId:</font> %d\n" ..
            "<font color='#78B4DC'>• ID Server:</font> <font color='#909AA8'>%s</font>",
            string.sub(gameName, 1, 24),
            fpsHex, fps, pingHex, pingNum,
            #Players:GetPlayers(), Players.MaxPlayers, game.PlaceId,
            shortJob
        )

        local execTime = math.floor(workspace.DistributedGameTime)
        local h = math.floor(execTime / 3600)
        local m = math.floor((execTime % 3600) / 60)
        local s = execTime % 60

        sysBody.Text = string.format(
            "<font color='#78B4DC'>• Executor:</font> <font color='#38CC88'>%s</font>   |   <font color='#78B4DC'>Đang bật:</font> <font color='#D8B870'>%d tính năng</font>\n" ..
            "<font color='#78B4DC'>• Treo máy:</font> %02d:%02d:%02d   |   <font color='#78B4DC'>Giờ:</font> %s\n" ..
            "<font color='#78B4DC'>• Phiên bản:</font> <font color='#E09F67'>VIP PRO MAX V1.15.0</font>",
            execName, activeCount,
            h, m, s, os.date("%H:%M:%S")
        )
    end

    updateTab1Stats()
    task.spawn(function()
        while task.wait(0.5) do
            if page1.Visible then
                updateTab1Stats()
            end
        end
    end)
end)()

-- ==========================================
-- [BẢN VÁ GỘP CHUNG CÔNG TẮC & THANH TRƯỢT - TAB NHÂN VẬT]
-- Dán vào cuối Script hoặc thay thế phần [TAB 3: NHÂN VẬT]
-- ==========================================
;(function()
    if not page3 then return end

    -- Xóa các ô tách rời cũ trong Tab Nhân Vật (nếu có)
    for _, child in ipairs(page3:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Hàm tạo Khung Gộp: Công tắc Bật/Tắt (ở trên) + Thanh trượt (ở dưới)
    local function createCombinedToggleSlider(parent, toggleText, toggleVar, sliderText, min, max, sliderVar, toggleCb, sliderCb)
        local card = Instance.new("Frame", parent)
        card.Size = UDim2.new(0.94, 0, 0, 64)
        card.BackgroundColor3 = Theme.ItemBg
        card.ZIndex = 10
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", card)
        stroke.Thickness = 1

        -- 1. NỬA TRÊN: NÚT BẬT / TẮT
        local topBtn = Instance.new("TextButton", card)
        topBtn.Size = UDim2.new(1, 0, 0, 31)
        topBtn.BackgroundTransparency = 1
        topBtn.Text = ""
        topBtn.AutoButtonColor = false
        topBtn.ZIndex = 11

        local leftBar = Instance.new("Frame", topBtn)
        leftBar.Size = UDim2.new(0, 3, 0, 15)
        leftBar.Position = UDim2.new(0, 6, 0.5, -7.5)
        leftBar.BorderSizePixel = 0
        leftBar.ZIndex = 12
        Instance.new("UICorner", leftBar).CornerRadius = UDim.new(1, 0)

        local title = Instance.new("TextLabel", topBtn)
        title.Size = UDim2.new(1, -70, 1, 0)
        title.Position = UDim2.new(0, 15, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = toggleText
        title.TextColor3 = Theme.TextTitle
        title.Font = Enum.Font.GothamBold
        title.TextSize = 10.5
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.ZIndex = 12

        local switchTrack = Instance.new("Frame", topBtn)
        switchTrack.Size = UDim2.new(0, 38, 0, 18)
        switchTrack.Position = UDim2.new(1, -46, 0.5, -9)
        switchTrack.BorderSizePixel = 0
        switchTrack.ZIndex = 12
        Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)
        local switchStroke = Instance.new("UIStroke", switchTrack)
        switchStroke.Thickness = 1
        switchStroke.Transparency = 0.25

        local switchKnob = Instance.new("Frame", switchTrack)
        switchKnob.Size = UDim2.new(0, 12, 0, 12)
        switchKnob.BorderSizePixel = 0
        switchKnob.ZIndex = 13
        Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)

        -- Vạch ngăn cách mảnh giữa phần Bật/Tắt và Thanh trượt
        local divider = Instance.new("Frame", card)
        divider.Size = UDim2.new(1, -16, 0, 1)
        divider.Position = UDim2.new(0, 8, 0, 31)
        divider.BackgroundColor3 = Theme.Stroke
        divider.BackgroundTransparency = 0.35
        divider.BorderSizePixel = 0
        divider.ZIndex = 11

        -- 2. NỬA DƯỚI: THANH TRƯỢT (SLIDER)
        local sliderArea = Instance.new("Frame", card)
        sliderArea.Size = UDim2.new(1, 0, 0, 32)
        sliderArea.Position = UDim2.new(0, 0, 0, 32)
        sliderArea.BackgroundTransparency = 1
        sliderArea.ZIndex = 11

        local sTitle = Instance.new("TextLabel", sliderArea)
        sTitle.Size = UDim2.new(0.68, 0, 0, 14)
        sTitle.Position = UDim2.new(0, 15, 0, 2)
        sTitle.BackgroundTransparency = 1
        sTitle.Text = "↳ " .. sliderText
        sTitle.Font = Enum.Font.GothamSemibold
        sTitle.TextSize = 9.5
        sTitle.TextXAlignment = Enum.TextXAlignment.Left
        sTitle.ZIndex = 12

        local valBadge = Instance.new("Frame", sliderArea)
        valBadge.Size = UDim2.new(0, 44, 0, 14)
        valBadge.Position = UDim2.new(1, -52, 0, 2)
        valBadge.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
        valBadge.ZIndex = 12
        Instance.new("UICorner", valBadge).CornerRadius = UDim.new(0, 4)
        local valStroke = Instance.new("UIStroke", valBadge)
        valStroke.Color = Theme.Stroke
        valStroke.Thickness = 0.8

        local valLabel = Instance.new("TextLabel", valBadge)
        valLabel.Size = UDim2.new(1, 0, 1, 0)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(State[sliderVar])
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = 9.5
        valLabel.ZIndex = 13

        local track = Instance.new("Frame", sliderArea)
        track.Size = UDim2.new(1, -26, 0, 5)
        track.Position = UDim2.new(0, 13, 0, 21)
        track.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
        track.ZIndex = 12
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local initPos = math.clamp((State[sliderVar] - min) / (max - min), 0, 1)
        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new(initPos, 0, 1, 0)
        fill.ZIndex = 13
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.new(0, 11, 0, 11)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(initPos, 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.fromRGB(240, 248, 255)
        knob.ZIndex = 14
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local knobStroke = Instance.new("UIStroke", knob)
        knobStroke.Thickness = 1.4

        local active = State[toggleVar] and true or false

        local function syncVisual(isOn, instant)
            local tInfo = TweenInfo.new(instant and 0 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local trackCol = isOn and Color3.fromRGB(34, 118, 82) or Color3.fromRGB(18, 20, 28)
            local knobCol = isOn and Color3.fromRGB(240, 255, 245) or Color3.fromRGB(125, 135, 155)
            local knobPos = isOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            local barCol = isOn and Theme.AccentOn or Color3.fromRGB(60, 66, 84)
            local bgCol = isOn and (Theme.ItemActive or Color3.fromRGB(24, 42, 40)) or Theme.ItemBg
            local borderCol = isOn and Color3.fromRGB(54, 140, 98) or Theme.Stroke
            local sliderAccent = isOn and Theme.AccentOn or Theme.Brand

            TweenService:Create(switchTrack, tInfo, {BackgroundColor3 = trackCol}):Play()
            TweenService:Create(switchStroke, tInfo, {Color = isOn and Theme.AccentOn or Theme.Stroke}):Play()
            TweenService:Create(switchKnob, tInfo, {Position = knobPos, BackgroundColor3 = knobCol}):Play()
            TweenService:Create(leftBar, tInfo, {BackgroundColor3 = barCol}):Play()
            TweenService:Create(card, tInfo, {BackgroundColor3 = bgCol}):Play()
            TweenService:Create(fill, tInfo, {BackgroundColor3 = sliderAccent}):Play()
            TweenService:Create(knobStroke, tInfo, {Color = sliderAccent}):Play()
            TweenService:Create(valLabel, tInfo, {TextColor3 = sliderAccent}):Play()
            TweenService:Create(sTitle, tInfo, {TextColor3 = isOn and Theme.TextTitle or Theme.TextDim}):Play()

            if not State.RGB then
                TweenService:Create(stroke, tInfo, {Color = borderCol}):Play()
            end
        end

        syncVisual(active, true)
        table.insert(RGBElements, {Type = "Toggle", Stroke = stroke, State = function() return State[toggleVar] end})

        -- Sự kiện bấm Bật/Tắt ở nửa trên
        topBtn.MouseButton1Click:Connect(function()
            clickAnimate(card)
            State[toggleVar] = not State[toggleVar]
            active = State[toggleVar]
            syncVisual(active, false)
            if active then
                MakeToast("Đã Bật", toggleText, Theme.AccentOn)
            else
                MakeToast("Đã Tắt", toggleText, Theme.AccentOff)
            end
            if State.AutoSave then saveConfig() end
            if toggleCb then toggleCb(active) end
        end)

        -- Sự kiện kéo Thanh trượt ở nửa dưới
        local dragging = false
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + ((max - min) * pos))
            valLabel.Text = tostring(value)
            TweenService:Create(fill, TweenInfo.new(0.08), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.08), {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
            State[sliderVar] = value
            if sliderCb then sliderCb(value) end
            if State.AutoSave then saveConfig() end
        end

        sliderArea.InputBegan:Connect(function(input)
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

        if active and toggleCb then task.spawn(toggleCb, active) end
        if sliderCb then task.spawn(sliderCb, State[sliderVar]) end
        return card
    end

    -- ==========================================
    -- KHỞI TẠO CÁC Ô GỘP TRONG TAB 3 (NHÂN VẬT)
    -- ==========================================

    -- 1. Bay + Tốc độ bay
    createCombinedToggleSlider(page3, "🕊️ Bay trên bầu trời (Fly)", "Fly", "Tốc độ bay", 10, 1000, "FlySpeed", function(v)
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

    -- 2. Chạy nhanh + Tốc độ chạy
    local defaultWalkSpeed = 16
    createCombinedToggleSlider(page3, "🏃 Chạy nhanh (WalkSpeed)", "Speed", "Tốc độ chạy", 1, 1000, "SpeedValue", function(v)
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            if v then
                if hum.WalkSpeed ~= State.SpeedValue then defaultWalkSpeed = hum.WalkSpeed end
                hum.WalkSpeed = State.SpeedValue
            else
                hum.WalkSpeed = defaultWalkSpeed
            end
        end
    end, function(val)
        if State.Speed and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end)

    -- 3. Nhảy cao + Lực nhảy
    local defaultJumpPower = 50
    createCombinedToggleSlider(page3, "🦘 Nhảy cao (JumpPower)", "Jump", "Lực nhảy", 1, 1000, "JumpValue", function(v)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if v then
                defaultJumpPower = player.Character.Humanoid.JumpPower
            else
                player.Character.Humanoid.UseJumpPower = true
                player.Character.Humanoid.JumpPower = defaultJumpPower
            end
        end
    end)

    -- 4. Lướt liên tục + Tốc độ lướt
    createCombinedToggleSlider(page3, "💨 Lướt liên tục (Auto Dash)", "AutoDash", "Tốc độ lướt", 1, 50, "DashSpeed")

    -- 5. Đánh xa + Kích thước vũ khí
    createCombinedToggleSlider(page3, "⚔️ Đánh xa (Reach Vũ Khí)", "Reach", "Kích thước vũ khí", 0, 300, "ReachSize")

    -- 6. Hitbox + Kích thước Hitbox
    createCombinedToggleSlider(page3, "🎯 Mở rộng Hitbox", "Hitbox", "Kích thước Hitbox", 0, 100, "HitboxSize")

    -- 7. Xoay vòng tròn + Tốc độ xoay
    createCombinedToggleSlider(page3, "🌪️ Xoay vòng tròn (SpinBot)", "SpinBot", "Tốc độ xoay", 0, 100, "SpinSpeed")

    -- 8. Ánh sáng quanh người (Gộp Công tắc + Phạm vi sáng + Độ sáng)
    createCombinedToggleSlider(page3, "💡 Ánh sáng quanh người", "PlayerLight", "Phạm vi sáng (Max 60)", 0, 60, "LightRange", function(v)
        if not v and player.Character then
            local root = getUniversalRoot(player.Character)
            if root then
                local light = root:FindFirstChild("PlayerPointLight")
                if light then light:Destroy() end
            end
        end
    end)
    createSlider(page3, "↳ Độ sáng đèn", 0, 5, "LightBrightness")
    createCycleBtn(page3, "🎨 Đổi màu sáng:", PlayerLightColors, "LightColorIdx")
end)()
