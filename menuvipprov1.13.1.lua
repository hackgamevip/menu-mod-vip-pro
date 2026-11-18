-- ==========================================
-- MENU VIP PRO MAX V1.18.0 (LUXURY CYBER-GLASS & BENTO SIDEBAR EDITION)
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
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

local State = {
    Instant = false, Noclip = false, LowGfx = false, Speed = false, Jump = false,
    InfJump = false, PlayerLight = false, ESP = false, AntiAfk = true, AntiStun = false,
    XRay = false, LockPosition = false, AutoCollect = false, Fly = false, FlySpeed = 50,
    SpinBot = false, SpinSpeed = 50, Hitbox = false, HitboxSize = 15, AutoClick = false, RGB = false,
    Reach = false, ReachSize = 15, AutoDash = false, DashSpeed = 10, AutoSave = false, Astral = false,
    ShiftLock = false, SpeedValue = 60, JumpValue = 120, LightRange = 60, LightBrightness = 3,
    MusicVolume = 5, MusicLoop = false, MusicSpeedIdx = 2, LightColorIdx = 1, ThemeIdx = 1, NoFog = false,
    FpsCapValue = 60, Disable3D = false, AfkModeScreen = false, RemoveTextures = false,
    HidePlayers = false, OptimizeTerrain = false, NoShadows = false,
    DisableParticles = false, DisablePostEffects = false, HidePetsAccessories = false, AutoClearRAM = false,
    AutoSkillDelay = 5,
    AutoSkillZ = false, AutoSkillX = false, AutoSkillC = false, AutoSkillV = false,
    AutoSkillE = false, AutoSkillF = false, AutoSkillQ = false, AutoSkillR = false,
    AutoSkill1 = false, AutoSkill2 = false, AutoSkill3 = false, AutoSkill4 = false, AutoSkill5 = false, AutoSkill6 = false,
    TpPositionIdx = 1, TpDistance = 4,
    TpSaveESP = false, TpSaveLoop = false, TpSaveLoopDelay = 2,
    AirWalk = false,
    HidePopups = false, MuteSFX = false, DisableAnims = false, DarkMap = false,
    MiniHUD = false, AutoReconnect = true, MagnetOrbs = false
}

local Theme = {
    MainBg = Color3.fromRGB(12, 14, 22),
    SidebarBg = Color3.fromRGB(16, 18, 28),
    HeaderBg = Color3.fromRGB(20, 23, 35),
    ItemBg = Color3.fromRGB(23, 27, 40),
    ItemActive = Color3.fromRGB(22, 44, 42),
    Stroke = Color3.fromRGB(48, 56, 78),
    TextTitle = Color3.fromRGB(235, 242, 255),
    TextDim = Color3.fromRGB(142, 154, 178),
    AccentOn = Color3.fromRGB(46, 218, 142),
    AccentOff = Color3.fromRGB(235, 84, 104),
    Brand = Color3.fromRGB(78, 190, 255),
    BrandSoft = Color3.fromRGB(28, 52, 82)
}

local ThemePresets = {
    {Name = "🌌 Cyber Blue", Brand = Color3.fromRGB(88, 182, 242), Soft = Color3.fromRGB(32, 52, 76), On = Color3.fromRGB(56, 204, 136), ActiveBg = Color3.fromRGB(24, 42, 40)},
    {Name = "💜 Neon Purple", Brand = Color3.fromRGB(182, 120, 255), Soft = Color3.fromRGB(48, 32, 78), On = Color3.fromRGB(56, 204, 136), ActiveBg = Color3.fromRGB(24, 42, 40)},
    {Name = "💚 Emerald Matrix", Brand = Color3.fromRGB(56, 218, 148), Soft = Color3.fromRGB(24, 58, 44), On = Color3.fromRGB(56, 204, 136), ActiveBg = Color3.fromRGB(24, 42, 40)},
    {Name = "🌸 Crimson Rose", Brand = Color3.fromRGB(255, 105, 148), Soft = Color3.fromRGB(70, 28, 46), On = Color3.fromRGB(56, 204, 136), ActiveBg = Color3.fromRGB(24, 42, 40)},
    {Name = "✨ Luxury Gold", Brand = Color3.fromRGB(245, 192, 78), Soft = Color3.fromRGB(68, 52, 24), On = Color3.fromRGB(56, 204, 136), ActiveBg = Color3.fromRGB(24, 42, 40)}
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
    {Name = "Sau lưng", Upper = "SAU LƯNG", IsHorizontal = false, GetOffset = function(d) return CFrame.new(0, 0, d) end},
    {Name = "Trước mặt", Upper = "TRƯỚC MẶT", IsHorizontal = false, GetOffset = function(d) return CFrame.new(0, 0, -d) * CFrame.Angles(0, math.pi, 0) end},
    {Name = "Trên đầu", Upper = "TRÊN ĐẦU", IsHorizontal = true, GetOffset = function(d) return CFrame.new(0, d, 0) * CFrame.Angles(math.rad(-90), 0, 0) end},
    {Name = "Dưới chân", Upper = "DƯỚI CHÂN", IsHorizontal = true, GetOffset = function(d) return CFrame.new(0, -d, 0) * CFrame.Angles(math.rad(90), 0, 0) end}
}

local RGBElements = {}
local BrandCallbacks = {}
local SyncCallbacks = {}
local ActiveESPs = {}
local SavedTpESPs = {}
local originalHitboxSizes = {}
local originalToolSizes = {}
local cachedPrompts = {}
local xrayMats = {}
local OriginalGFX = {}

local function cleanRGBElements()
    local cleaned = {}
    for _, obj in ipairs(RGBElements) do
        if obj.Stroke and obj.Stroke.Parent then
            table.insert(cleaned, obj)
        end
    end
    RGBElements = cleaned
end

local function registerBrandUpdater(fn)
    table.insert(BrandCallbacks, fn)
end

local function getSoftBrandColor(c)
    local base = c or Theme.Brand
    return base:Lerp(Color3.fromRGB(195, 205, 222), 0.26)
end

local function isDragUpdateInput(input, activeInput)
    if not activeInput then return false end
    if input == activeInput then return true end
    if activeInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement then
        return true
    end
    return false
end

local function utf8SafeTruncate(str, maxChars)
    if not str then return "" end
    if type(utf8) == "table" and utf8.len and utf8.offset then
        local ok, len = pcall(utf8.len, str)
        if ok and len and len > maxChars then
            local byteOffset = utf8.offset(str, maxChars + 1)
            if byteOffset then
                return string.sub(str, 1, byteOffset - 1) .. ".."
            end
        end
    end
    return str
end

local function registerSync(varName, fn)
    if not SyncCallbacks[varName] then SyncCallbacks[varName] = {} end
    table.insert(SyncCallbacks[varName], fn)
end

local function fireSync(varName, isOn, instant)
    if SyncCallbacks[varName] then
        for _, fn in ipairs(SyncCallbacks[varName]) do
            pcall(fn, isOn, instant)
        end
    end
end

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
local MusicSpeedPresets = {
    {Name = "0.8x (Slowed)", Badge = "0.8x", Speed = 0.8},
    {Name = "1x (Chuẩn)", Badge = "1x", Speed = 1.0},
    {Name = "1.15x (Fast)", Badge = "1.15x", Speed = 1.15},
    {Name = "1.25x (Nightcore)", Badge = "1.25x", Speed = 1.25},
    {Name = "1.5x (Remix)", Badge = "1.5x", Speed = 1.5},
    {Name = "2x (Siêu tốc)", Badge = "2x", Speed = 2.0}
}
if not MusicSpeedPresets[State.MusicSpeedIdx] then State.MusicSpeedIdx = 2 end
if not PlayerLightColors[State.LightColorIdx] then State.LightColorIdx = 1 end
if not ThemePresets[State.ThemeIdx] then State.ThemeIdx = 1 end
do local p = ThemePresets[State.ThemeIdx]; Theme.Brand = p.Brand; Theme.BrandSoft = p.Soft; Theme.AccentOn = p.On; Theme.ItemActive = p.ActiveBg end

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
screenOverlay.BackgroundColor3 = Color3.new(0, 0, 0); screenOverlay.ZIndex = 0; screenOverlay.Visible = false

-- Nút đóng/mở Menu hình Huy Hiệu Rồng 3D Glossy viền trắng (Mở: Rồng Lửa Đỏ Cam | Đóng: Rồng Tím Hắc Ám)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 48, 0, 48); openBtn.Position = UDim2.new(0, 14, 0.05, 0)
openBtn.Text = ""; openBtn.BackgroundColor3 = Color3.fromRGB(16, 10, 18); openBtn.BackgroundTransparency = 0
openBtn.AutoButtonColor = false; openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = Color3.fromRGB(236, 242, 250); openStroke.Thickness = 2; openStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local syncDragonButtonState
do
    local innerSphere = Instance.new("Frame", openBtn)
    innerSphere.Size = UDim2.new(1, -6, 1, -6); innerSphere.Position = UDim2.new(0, 3, 0, 3)
    innerSphere.BackgroundColor3 = Color3.fromRGB(255, 255, 255); innerSphere.BorderSizePixel = 0; innerSphere.ZIndex = 11
    Instance.new("UICorner", innerSphere).CornerRadius = UDim.new(1, 0)

    local sphereGrad = Instance.new("UIGradient", innerSphere)
    sphereGrad.Rotation = 125

    local sphereRim = Instance.new("UIStroke", innerSphere)
    sphereRim.Thickness = 1; sphereRim.Transparency = 0.25

    -- 2 vệt bóng kính góc trên phải giống mẫu 1000085170.png
    local shineDot = Instance.new("Frame", innerSphere)
    shineDot.Size = UDim2.new(0, 4, 0, 4); shineDot.Position = UDim2.new(0.56, 0, 0.10, 0)
    shineDot.BorderSizePixel = 0; shineDot.BackgroundTransparency = 0.35; shineDot.ZIndex = 16
    Instance.new("UICorner", shineDot).CornerRadius = UDim.new(1, 0)

    local shineOval = Instance.new("Frame", innerSphere)
    shineOval.Size = UDim2.new(0, 8, 0, 4); shineOval.Position = UDim2.new(0.66, 0, 0.14, 0); shineOval.Rotation = 28
    shineOval.BorderSizePixel = 0; shineOval.BackgroundTransparency = 0.3; shineOval.ZIndex = 16
    Instance.new("UICorner", shineOval).CornerRadius = UDim.new(1, 0)

    local artHolder = Instance.new("Frame", innerSphere)
    artHolder.Size = UDim2.new(1, 0, 1, 0); artHolder.BackgroundTransparency = 1; artHolder.ZIndex = 12

    local bodyGrads = {}
    local function addDragonSeg(xScale, yScale, w, h, rot, radiusScale, zIdx)
        local seg = Instance.new("Frame", artHolder)
        seg.Size = UDim2.new(0, w, 0, h)
        seg.AnchorPoint = Vector2.new(0.5, 0.5)
        seg.Position = UDim2.new(xScale, 0, yScale, 0)
        if rot then seg.Rotation = rot end
        seg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        seg.BorderSizePixel = 0
        seg.ZIndex = zIdx or 14
        Instance.new("UICorner", seg).CornerRadius = UDim.new(radiusScale or 0.45, 0)
        local g = Instance.new("UIGradient", seg)
        g.Rotation = 90
        table.insert(bodyGrads, g)
        return seg
    end

    -- Thân rồng uốn hình chữ C (từ cổ xuống bụng và vút lên đuôi nhọn bên phải)
    addDragonSeg(0.36, 0.34, 8, 7, -25, 0.5, 14)
    addDragonSeg(0.28, 0.44, 8.5, 8, -50, 0.5, 14)
    addDragonSeg(0.25, 0.56, 8.5, 8, -80, 0.5, 14)
    addDragonSeg(0.29, 0.68, 8.5, 7.5, -115, 0.5, 14)
    addDragonSeg(0.38, 0.77, 9, 7, -145, 0.5, 14)
    addDragonSeg(0.50, 0.81, 9, 6.5, -175, 0.5, 14)
    addDragonSeg(0.62, 0.79, 8.5, 5.5, 155, 0.5, 14)
    addDragonSeg(0.72, 0.72, 7.5, 4.2, 130, 0.5, 14)
    addDragonSeg(0.78, 0.63, 6, 2.8, 110, 0.5, 14)

    -- 5 gai bờm sắc nhọn dọc sống lưng bên trái
    addDragonSeg(0.28, 0.27, 9, 3.2, 15, 0.45, 13)
    addDragonSeg(0.20, 0.36, 10, 3.4, -8, 0.45, 13)
    addDragonSeg(0.16, 0.48, 10, 3.4, -30, 0.45, 13)
    addDragonSeg(0.17, 0.61, 9.5, 3.2, -52, 0.45, 13)
    addDragonSeg(0.23, 0.73, 8.5, 3.0, -72, 0.45, 13)

    -- 2 sừng dài vuốt ngược lên đỉnh đầu
    addDragonSeg(0.39, 0.19, 12, 3.2, 32, 0.45, 14)
    addDragonSeg(0.29, 0.13, 6, 2.2, 40, 0.5, 14)
    addDragonSeg(0.49, 0.19, 9.5, 2.6, 40, 0.45, 13)

    -- Đầu rồng, hàm trên, mũi quặp và hàm dưới há rộng
    addDragonSeg(0.50, 0.29, 11, 5.8, 12, 0.4, 15)
    addDragonSeg(0.63, 0.34, 10.5, 4.6, 22, 0.4, 15)
    addDragonSeg(0.74, 0.38, 4.2, 3.8, 48, 0.35, 15)
    addDragonSeg(0.42, 0.39, 6.5, 2.8, -18, 0.45, 14)
    addDragonSeg(0.58, 0.46, 9.5, 3.2, 36, 0.4, 14)
    addDragonSeg(0.51, 0.49, 5, 2.2, -25, 0.45, 14)

    -- Răng nanh trên & dưới
    local fang1 = Instance.new("Frame", artHolder)
    fang1.Size = UDim2.new(0, 2, 0, 3); fang1.AnchorPoint = Vector2.new(0.5, 0.5); fang1.Position = UDim2.new(0.69, 0, 0.41, 0)
    fang1.Rotation = 15; fang1.BackgroundColor3 = Color3.fromRGB(255, 245, 220); fang1.BorderSizePixel = 0; fang1.ZIndex = 14
    Instance.new("UICorner", fang1).CornerRadius = UDim.new(0.4, 0)

    local fang2 = Instance.new("Frame", artHolder)
    fang2.Size = UDim2.new(0, 1.8, 0, 2.6); fang2.AnchorPoint = Vector2.new(0.5, 0.5); fang2.Position = UDim2.new(0.64, 0, 0.47, 0)
    fang2.Rotation = -15; fang2.BackgroundColor3 = Color3.fromRGB(255, 245, 220); fang2.BorderSizePixel = 0; fang2.ZIndex = 14
    Instance.new("UICorner", fang2).CornerRadius = UDim.new(0.4, 0)

    -- Mắt rồng phát sáng
    local eyeSocket = Instance.new("Frame", artHolder)
    eyeSocket.Size = UDim2.new(0, 5.2, 0, 2.5); eyeSocket.AnchorPoint = Vector2.new(0.5, 0.5)
    eyeSocket.Position = UDim2.new(0.57, 0, 0.31, 0); eyeSocket.Rotation = 22
    eyeSocket.BackgroundColor3 = Color3.fromRGB(20, 6, 12); eyeSocket.BorderSizePixel = 0; eyeSocket.ZIndex = 16
    Instance.new("UICorner", eyeSocket).CornerRadius = UDim.new(1, 0)

    local eyeGlow = Instance.new("Frame", eyeSocket)
    eyeGlow.Size = UDim2.new(0, 3.4, 0, 1.5); eyeGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    eyeGlow.Position = UDim2.new(0.55, 0, 0.5, 0); eyeGlow.BorderSizePixel = 0; eyeGlow.ZIndex = 17
    Instance.new("UICorner", eyeGlow).CornerRadius = UDim.new(1, 0)

    -- Luồng lửa phun ra từ miệng rồng (chỉ hiện khi Menu đang MỞ)
    local fireHolder = Instance.new("Frame", artHolder)
    fireHolder.Size = UDim2.new(1, 0, 1, 0); fireHolder.BackgroundTransparency = 1; fireHolder.ZIndex = 13

    local function addFlameTongue(xS, yS, w, h, rot, col1, col2, zI)
        local fl = Instance.new("Frame", fireHolder)
        fl.Size = UDim2.new(0, w, 0, h); fl.AnchorPoint = Vector2.new(0.5, 0.5)
        fl.Position = UDim2.new(xS, 0, yS, 0); fl.Rotation = rot
        fl.BackgroundColor3 = Color3.fromRGB(255, 255, 255); fl.BorderSizePixel = 0; fl.ZIndex = zI
        Instance.new("UICorner", fl).CornerRadius = UDim.new(0.5, 0)
        addSoftGradient(fl, col1, col2, 45)
    end
    addFlameTongue(0.71, 0.51, 13, 5.5, 32, Color3.fromRGB(255, 120, 20), Color3.fromRGB(220, 35, 10), 13)
    addFlameTongue(0.78, 0.58, 12, 6.5, 42, Color3.fromRGB(255, 95, 15), Color3.fromRGB(195, 20, 10), 13)
    addFlameTongue(0.74, 0.47, 10, 4.0, 18, Color3.fromRGB(255, 180, 30), Color3.fromRGB(245, 75, 15), 14)
    addFlameTongue(0.69, 0.50, 9.5, 3.8, 34, Color3.fromRGB(255, 245, 130), Color3.fromRGB(255, 165, 25), 15)
    addFlameTongue(0.77, 0.55, 8.5, 4.2, 38, Color3.fromRGB(255, 235, 95), Color3.fromRGB(255, 130, 20), 15)

    syncDragonButtonState = function(isOpen)
        fireHolder.Visible = isOpen
        if isOpen then
            -- Trạng thái MỞ: Rồng Lửa Đỏ Cam (giống hình trái trong 1000085170.png)
            sphereGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 22, 14)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(64, 10, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 4, 6))
            })
            sphereRim.Color = Color3.fromRGB(225, 75, 35)
            shineDot.BackgroundColor3 = Color3.fromRGB(245, 110, 85)
            shineOval.BackgroundColor3 = Color3.fromRGB(245, 110, 85)
            eyeGlow.BackgroundColor3 = Color3.fromRGB(255, 245, 150)
            fang1.BackgroundColor3 = Color3.fromRGB(255, 235, 180)
            fang2.BackgroundColor3 = Color3.fromRGB(255, 235, 180)
            local dragonFireSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 210, 55)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(250, 125, 22)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 42, 12))
            })
            for _, g in ipairs(bodyGrads) do g.Color = dragonFireSeq end
        else
            -- Trạng thái ĐÓNG: Rồng Tím Hắc Ám (giống hình phải trong 1000085170.png)
            sphereGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(86, 28, 155)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(36, 12, 74)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 4, 28))
            })
            sphereRim.Color = Color3.fromRGB(155, 85, 240)
            shineDot.BackgroundColor3 = Color3.fromRGB(165, 115, 240)
            shineOval.BackgroundColor3 = Color3.fromRGB(165, 115, 240)
            eyeGlow.BackgroundColor3 = Color3.fromRGB(255, 75, 245)
            fang1.BackgroundColor3 = Color3.fromRGB(235, 215, 255)
            fang2.BackgroundColor3 = Color3.fromRGB(235, 215, 255)
            local dragonPurpleSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(225, 190, 255)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(162, 105, 245)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 48, 185))
            })
            for _, g in ipairs(bodyGrads) do g.Color = dragonPurpleSeq end
        end
        if not State.RGB then
            openStroke.Color = Color3.fromRGB(236, 242, 250)
        end
    end
    syncDragonButtonState(true)
end
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
    local btnDragInput, btnDragStart, btnStartPos = nil, nil, nil
    openBtn.InputBegan:Connect(function(input)
        if not btnDragInput and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            btnDragInput = input; btnDragStart = input.Position; btnStartPos = openBtn.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if isDragUpdateInput(input, btnDragInput) then
            openBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + (input.Position.X - btnDragStart.X), btnStartPos.Y.Scale, btnStartPos.Y.Offset + (input.Position.Y - btnDragStart.Y))
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input == btnDragInput then btnDragInput = nil end
    end)
end
local OPEN_POS = UDim2.new(0.5, -220, 0.5, -146)
local CLOSE_POS = UDim2.new(0.5, -220, 1.25, 0)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 440, 0, 292)
frame.Position = OPEN_POS
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.02
frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
addSoftGradient(frame, Color3.fromRGB(22, 26, 40), Color3.fromRGB(12, 14, 22), 135)

local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = Theme.Brand; frameStroke.Thickness = 1.5; frameStroke.Transparency = 0.2
table.insert(RGBElements, {Type = "Frame", Stroke = frameStroke})

local avatarStroke, titleLabel, headerStatText, refreshThemeVisuals
local page1, page2, page3, page4, page5, page6, page7, page8, page9
local onTab9Shown = nil
local opened = true
do
    local frameScale = Instance.new("UIScale", frame)
    -- HEADER SANG TRỌNG VỚI DẢI NEON LINE
    local header = Instance.new("Frame", frame)
    header.Size = UDim2.new(1, 0, 0, 38); header.BackgroundColor3 = Color3.fromRGB(255, 255, 255); header.BackgroundTransparency = 0; header.BorderSizePixel = 0; header.ZIndex = 11
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)
    addSoftGradient(header, Color3.fromRGB(30, 35, 52), Color3.fromRGB(19, 22, 34), 0)

    local headerCover = Instance.new("Frame", header)
    headerCover.Size = UDim2.new(1, 0, 0, 12); headerCover.Position = UDim2.new(0, 0, 1, -12); headerCover.BackgroundColor3 = Color3.fromRGB(21, 24, 37); headerCover.BorderSizePixel = 0; headerCover.ZIndex = 11

    local headerLine = Instance.new("Frame", header)
    headerLine.Size = UDim2.new(1, 0, 0, 1.5); headerLine.Position = UDim2.new(0, 0, 1, -1.5); headerLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); headerLine.BorderSizePixel = 0; headerLine.ZIndex = 12
    local hLineGrad = Instance.new("UIGradient", headerLine)
    hLineGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Brand),
        ColorSequenceKeypoint.new(0.5, Theme.AccentOn),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 115, 255))
    })

    local avatarImg = Instance.new("ImageLabel", header)
    avatarImg.Size = UDim2.new(0, 26, 0, 26); avatarImg.Position = UDim2.new(0, 10, 0.5, -13); avatarImg.BackgroundColor3 = Theme.ItemBg; avatarImg.ZIndex = 12
    pcall(function() avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
    avatarStroke = Instance.new("UIStroke", avatarImg); avatarStroke.Color = Theme.Brand; avatarStroke.Thickness = 1.4

    local onlineDot = Instance.new("Frame", avatarImg)
    onlineDot.Size = UDim2.new(0, 7, 0, 7); onlineDot.Position = UDim2.new(1, -6, 1, -6)
    onlineDot.BackgroundColor3 = Theme.AccentOn; onlineDot.ZIndex = 13
    Instance.new("UICorner", onlineDot).CornerRadius = UDim.new(1, 0)
    local dotStroke = Instance.new("UIStroke", onlineDot); dotStroke.Color = Theme.HeaderBg; dotStroke.Thickness = 1.3

    titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(0, 175, 0, 16); titleLabel.Position = UDim2.new(0, 43, 0, 5); titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "✨ MENU VIP PRO MAX"
    titleLabel.TextColor3 = Theme.TextTitle; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 11.5; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.ZIndex = 12

    local subTitleLabel = Instance.new("TextLabel", header)
    subTitleLabel.Size = UDim2.new(0, 180, 0, 12); subTitleLabel.Position = UDim2.new(0, 43, 0, 21); subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.RichText = true; subTitleLabel.Text = "@" .. player.Name .. " • <font color='#38CC88'>VIP ACTIVE</font>"
    subTitleLabel.TextColor3 = Theme.TextDim; subTitleLabel.Font = Enum.Font.GothamSemibold; subTitleLabel.TextSize = 8.5; subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left; subTitleLabel.ZIndex = 12

    local headerStatPill = Instance.new("Frame", header)
    headerStatPill.Size = UDim2.new(0, 110, 0, 22); headerStatPill.Position = UDim2.new(1, -200, 0.5, -11)
    headerStatPill.BackgroundColor3 = Color3.fromRGB(14, 16, 25); headerStatPill.ZIndex = 12
    Instance.new("UICorner", headerStatPill).CornerRadius = UDim.new(1, 0)
    local hspStroke = Instance.new("UIStroke", headerStatPill); hspStroke.Color = Theme.Stroke; hspStroke.Thickness = 1

    headerStatText = Instance.new("TextLabel", headerStatPill)
    headerStatText.Size = UDim2.new(1, 0, 1, 0); headerStatText.BackgroundTransparency = 1
    headerStatText.RichText = true; headerStatText.Text = "<font color='#38CC88'>60 FPS</font> • <font color='#58B6F2'>0ms</font>"
    headerStatText.TextColor3 = Theme.TextTitle; headerStatText.Font = Enum.Font.GothamBold; headerStatText.TextSize = 9; headerStatText.ZIndex = 13

    -- Huy hiệu V1.18 nền tối dịu mắt, chữ thanh rõ nét không bị chói sáng trên Mobile
    local verBadge = Instance.new("TextLabel", header)
    verBadge.Size = UDim2.new(0, 48, 0, 20); verBadge.Position = UDim2.new(1, -83, 0.5, -10)
    verBadge.BackgroundColor3 = Color3.fromRGB(18, 21, 30); verBadge.Text = "V1.18"; verBadge.TextColor3 = getSoftBrandColor(Theme.Brand)
    verBadge.Font = Enum.Font.GothamSemibold; verBadge.TextSize = 9.5; verBadge.ZIndex = 12
    Instance.new("UICorner", verBadge).CornerRadius = UDim.new(0, 7)
    local verStroke = Instance.new("UIStroke", verBadge); verStroke.Color = Theme.Brand; verStroke.Thickness = 0.8; verStroke.Transparency = 0.45

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0, 24, 0, 22); minBtn.Position = UDim2.new(1, -29, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(32, 37, 54); minBtn.Text = "—"; minBtn.TextColor3 = Theme.TextTitle
    minBtn.Font = Enum.Font.GothamBlack; minBtn.TextSize = 11; minBtn.AutoButtonColor = false; minBtn.ZIndex = 12
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 7)
    local minStroke = Instance.new("UIStroke", minBtn); minStroke.Color = Theme.Stroke; minStroke.Thickness = 1

    do
        local dragInput, dragStart, startPos = nil, nil, nil
        header.InputBegan:Connect(function(input)
            if not dragInput and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                dragInput = input; dragStart = input.Position; startPos = frame.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if isDragUpdateInput(input, dragInput) then
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
                OPEN_POS = frame.Position
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input == dragInput then dragInput = nil end
        end)
    end

    -- SIDEBAR BENTO PILL HIỆN ĐẠI (TỐI ƯU KHOẢNG THỞ 9 TAB KHÔNG CHẠM ĐÁY)
    local sidebar = Instance.new("Frame", frame)
    sidebar.Size = UDim2.new(0, 114, 1, -38); sidebar.Position = UDim2.new(0, 0, 0, 38)
    sidebar.BackgroundColor3 = Theme.SidebarBg; sidebar.BorderSizePixel = 0; sidebar.ZIndex = 10
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)

    local sidebarPatchTop = Instance.new("Frame", sidebar)
    sidebarPatchTop.Size = UDim2.new(1, 0, 0, 14); sidebarPatchTop.Position = UDim2.new(0, 0, 0, 0)
    sidebarPatchTop.BackgroundColor3 = Theme.SidebarBg; sidebarPatchTop.BorderSizePixel = 0; sidebarPatchTop.ZIndex = 10

    local sidebarPatchRight = Instance.new("Frame", sidebar)
    sidebarPatchRight.Size = UDim2.new(0, 14, 1, 0); sidebarPatchRight.Position = UDim2.new(1, -14, 0, 0)
    sidebarPatchRight.BackgroundColor3 = Theme.SidebarBg; sidebarPatchRight.BorderSizePixel = 0; sidebarPatchRight.ZIndex = 10

    local sidebarDivider = Instance.new("Frame", sidebar)
    sidebarDivider.Size = UDim2.new(0, 1, 1, 0); sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    sidebarDivider.BackgroundColor3 = Theme.Stroke; sidebarDivider.BorderSizePixel = 0; sidebarDivider.ZIndex = 11

    local tabBar = Instance.new("ScrollingFrame", sidebar)
    tabBar.Size = UDim2.new(1, 0, 1, 0); tabBar.BackgroundTransparency = 1; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 11
    tabBar.ScrollBarThickness = 0; tabBar.ScrollingDirection = Enum.ScrollingDirection.Y

    local tabPad = Instance.new("UIPadding", tabBar)
    tabPad.PaddingLeft = UDim.new(0, 6); tabPad.PaddingRight = UDim.new(0, 7)
    tabPad.PaddingTop = UDim.new(0, 4); tabPad.PaddingBottom = UDim.new(0, 4)

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2.5)
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabBar.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 8)
    end)

    -- Bộ vẽ 9 Biểu Tượng 3D Neon cho Sidebar theo đúng mẫu ảnh 3x3 (1000085240.png)
    local function drawSidebarNeonIcon(box, iconKey)
        local function part(xS, yS, wS, hS, col1, col2, rot, rad, zOff)
            local f = Instance.new("Frame", box)
            f.Size = UDim2.new(wS, 0, hS, 0)
            f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.Position = UDim2.new(xS, 0, yS, 0)
            if rot and rot ~= 0 then f.Rotation = rot end
            f.BackgroundColor3 = col2 and Color3.fromRGB(255, 255, 255) or col1
            f.BorderSizePixel = 0
            f.ZIndex = 13 + (zOff or 0)
            Instance.new("UICorner", f).CornerRadius = UDim.new(rad or 0.35, 0)
            if col2 then addSoftGradient(f, col1, col2, 90) end
            return f
        end

        local function ring(xS, yS, wS, hS, strokeCol, thick, rot, zOff)
            local r = Instance.new("Frame", box)
            r.Size = UDim2.new(wS, 0, hS, 0)
            r.AnchorPoint = Vector2.new(0.5, 0.5)
            r.Position = UDim2.new(xS, 0, yS, 0)
            if rot and rot ~= 0 then r.Rotation = rot end
            r.BackgroundTransparency = 1
            r.ZIndex = 13 + (zOff or 0)
            Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
            local st = Instance.new("UIStroke", r)
            st.Color = strokeCol; st.Thickness = thick or 1.2
            return r
        end

        if iconKey == "Info" then
            -- 1. THÔNG TIN: Bảng biểu đồ 4 cột cầu vồng + vòng chữ (i) xanh dương + quầng tím-xanh
            ring(0.5, 0.62, 0.92, 0.42, Color3.fromRGB(165, 95, 255), 1.2, -14, 0)
            local board = part(0.5, 0.48, 0.80, 0.68, Color3.fromRGB(20, 52, 115), Color3.fromRGB(12, 26, 68), -6, 0.22, 1)
            local bSt = Instance.new("UIStroke", board); bSt.Color = Color3.fromRGB(65, 195, 255); bSt.Thickness = 1.1
            ring(0.30, 0.44, 0.28, 0.28, Color3.fromRGB(85, 215, 255), 1.1, 0, 2)
            part(0.30, 0.46, 0.07, 0.14, Color3.fromRGB(160, 235, 255), nil, 0, 0.5, 3)
            part(0.46, 0.62, 0.10, 0.18, Color3.fromRGB(55, 210, 255), Color3.fromRGB(25, 135, 235), 0, 0.25, 2)
            part(0.58, 0.56, 0.10, 0.30, Color3.fromRGB(85, 245, 120), Color3.fromRGB(25, 175, 75), 0, 0.25, 2)
            part(0.70, 0.49, 0.10, 0.44, Color3.fromRGB(255, 225, 65), Color3.fromRGB(235, 145, 20), 0, 0.25, 2)
            part(0.82, 0.42, 0.10, 0.56, Color3.fromRGB(255, 95, 85), Color3.fromRGB(215, 25, 45), 0, 0.25, 2)
        elseif iconKey == "Feature" then
            -- 2. TÍNH NĂNG: Tia sét vàng cam giữa vòng xoáy điện xanh lam
            ring(0.5, 0.54, 0.86, 0.52, Color3.fromRGB(55, 185, 255), 1.4, -22, 0)
            ring(0.5, 0.48, 0.68, 0.68, Color3.fromRGB(35, 115, 235), 1.0, 15, 0)
            part(0.54, 0.32, 0.22, 0.48, Color3.fromRGB(255, 238, 85), Color3.fromRGB(245, 140, 20), 26, 0.3, 2)
            part(0.50, 0.49, 0.44, 0.17, Color3.fromRGB(255, 215, 55), Color3.fromRGB(240, 120, 15), -12, 0.3, 3)
            part(0.45, 0.67, 0.20, 0.48, Color3.fromRGB(255, 195, 45), Color3.fromRGB(230, 75, 15), 26, 0.3, 2)
        elseif iconKey == "Character" then
            -- 3. NHÂN VẬT: Người vàng chạy tốc độ + vệt gió vàng cam
            ring(0.52, 0.60, 0.88, 0.46, Color3.fromRGB(255, 155, 25), 1.3, -16, 0)
            part(0.24, 0.36, 0.32, 0.08, Color3.fromRGB(255, 215, 65), Color3.fromRGB(240, 125, 15), 0, 1, 1)
            part(0.20, 0.50, 0.36, 0.08, Color3.fromRGB(255, 195, 50), Color3.fromRGB(235, 105, 15), 0, 1, 1)
            part(0.24, 0.64, 0.28, 0.08, Color3.fromRGB(255, 175, 40), Color3.fromRGB(225, 85, 15), 0, 1, 1)
            -- Đầu, thân, tay & chân đang chạy
            part(0.68, 0.22, 0.24, 0.24, Color3.fromRGB(255, 235, 80), Color3.fromRGB(245, 155, 20), 0, 1, 3)
            part(0.56, 0.46, 0.18, 0.34, Color3.fromRGB(255, 215, 65), Color3.fromRGB(240, 130, 18), 28, 0.45, 2)
            part(0.72, 0.38, 0.24, 0.11, Color3.fromRGB(255, 220, 70), Color3.fromRGB(240, 135, 20), -35, 0.5, 2)
            part(0.42, 0.38, 0.22, 0.11, Color3.fromRGB(255, 205, 55), Color3.fromRGB(235, 115, 15), 35, 0.5, 2)
            part(0.66, 0.68, 0.14, 0.30, Color3.fromRGB(255, 205, 55), Color3.fromRGB(235, 110, 15), -28, 0.45, 2)
            part(0.40, 0.72, 0.30, 0.13, Color3.fromRGB(255, 190, 45), Color3.fromRGB(225, 95, 15), -32, 0.45, 2)
        elseif iconKey == "TpPlayer" then
            -- 4. TP PLAYER: Avatar người xanh dương trong vòng tròn + nút tam giác vàng cam góc phải dưới
            ring(0.48, 0.50, 0.84, 0.84, Color3.fromRGB(55, 195, 255), 1.3, 0, 0)
            part(0.44, 0.36, 0.32, 0.32, Color3.fromRGB(135, 225, 255), Color3.fromRGB(35, 135, 235), 0, 1, 2)
            part(0.44, 0.68, 0.54, 0.30, Color3.fromRGB(115, 210, 255), Color3.fromRGB(25, 115, 220), 0, 0.5, 2)
            -- Huy hiệu tam giác vàng cam góc dưới phải
            part(0.74, 0.66, 0.34, 0.34, Color3.fromRGB(255, 215, 65), Color3.fromRGB(235, 95, 15), 15, 0.3, 3)
            part(0.75, 0.66, 0.18, 0.18, Color3.fromRGB(255, 245, 155), nil, 45, 0.25, 4)
        elseif iconKey == "TpSave" then
            -- 5. TP SAVE: Ghim vị trí đỏ bóng (Pin) trên vòng tâm đỏ-cam-xanh
            ring(0.5, 0.74, 0.88, 0.34, Color3.fromRGB(65, 195, 255), 1.1, 0, 0)
            ring(0.5, 0.72, 0.62, 0.22, Color3.fromRGB(255, 135, 35), 1.2, 0, 1)
            part(0.5, 0.56, 0.24, 0.28, Color3.fromRGB(245, 55, 55), Color3.fromRGB(175, 15, 25), 45, 0.2, 2)
            part(0.5, 0.36, 0.46, 0.46, Color3.fromRGB(255, 85, 75), Color3.fromRGB(195, 18, 28), 0, 1, 3)
            part(0.42, 0.28, 0.14, 0.10, Color3.fromRGB(255, 215, 215), nil, -25, 1, 4)
        elseif iconKey == "AutoSkill" then
            -- 6. AUTO SKILL: Bàn phím RGB nghiêng viền xanh-tím
            ring(0.5, 0.56, 0.92, 0.44, Color3.fromRGB(215, 75, 255), 1.2, -16, 0)
            local kb = part(0.5, 0.50, 0.84, 0.56, Color3.fromRGB(28, 42, 95), Color3.fromRGB(16, 20, 52), -8, 0.22, 1)
            local kSt = Instance.new("UIStroke", kb); kSt.Color = Color3.fromRGB(65, 205, 255); kSt.Thickness = 1.1
            -- Hàng phím nhỏ & thanh Space cầu vồng
            part(0.28, 0.40, 0.13, 0.11, Color3.fromRGB(75, 215, 255), nil, -8, 0.25, 2)
            part(0.45, 0.38, 0.13, 0.11, Color3.fromRGB(95, 185, 255), nil, -8, 0.25, 2)
            part(0.62, 0.36, 0.13, 0.11, Color3.fromRGB(165, 115, 255), nil, -8, 0.25, 2)
            part(0.77, 0.34, 0.12, 0.11, Color3.fromRGB(225, 85, 245), nil, -8, 0.25, 2)
            part(0.54, 0.60, 0.46, 0.11, Color3.fromRGB(95, 245, 165), Color3.fromRGB(255, 185, 55), -8, 0.3, 2)
        elseif iconKey == "Music" then
            -- 7. NHẠC ID: Nốt nhạc đôi trắng-tím (♫) giữa vòng xoáy tím-xanh
            ring(0.5, 0.56, 0.90, 0.50, Color3.fromRGB(215, 75, 255), 1.3, -20, 0)
            ring(0.5, 0.48, 0.78, 0.44, Color3.fromRGB(55, 205, 255), 1.0, 18, 0)
            part(0.32, 0.70, 0.28, 0.22, Color3.fromRGB(250, 245, 255), Color3.fromRGB(195, 135, 255), -18, 1, 3)
            part(0.68, 0.64, 0.28, 0.22, Color3.fromRGB(250, 245, 255), Color3.fromRGB(195, 135, 255), -18, 1, 3)
            part(0.41, 0.46, 0.11, 0.46, Color3.fromRGB(250, 245, 255), Color3.fromRGB(205, 155, 255), 0, 0.3, 2)
            part(0.77, 0.40, 0.11, 0.46, Color3.fromRGB(250, 245, 255), Color3.fromRGB(205, 155, 255), 0, 0.3, 2)
            part(0.59, 0.24, 0.48, 0.16, Color3.fromRGB(255, 250, 255), Color3.fromRGB(210, 165, 255), -12, 0.35, 3)
        elseif iconKey == "Utility" then
            -- 8. TIỆN ÍCH: Cờ lê bạc chéo tua vít cán vàng trên nền bánh răng xanh
            ring(0.5, 0.5, 0.76, 0.76, Color3.fromRGB(55, 145, 235), 1.6, 0, 0)
            -- Tua vít chéo (45 độ) với cán vàng cam
            part(0.62, 0.38, 0.12, 0.52, Color3.fromRGB(185, 220, 255), nil, 45, 0.3, 1)
            part(0.34, 0.66, 0.24, 0.38, Color3.fromRGB(255, 205, 45), Color3.fromRGB(235, 105, 15), 45, 0.35, 2)
            -- Cờ lê bạc chéo ngược (-45 độ)
            part(0.52, 0.52, 0.18, 0.72, Color3.fromRGB(240, 248, 255), Color3.fromRGB(145, 175, 215), -45, 0.35, 3)
            part(0.30, 0.30, 0.28, 0.24, Color3.fromRGB(245, 250, 255), Color3.fromRGB(165, 195, 230), -45, 1, 3)
        elseif iconKey == "Config" then
            -- 9. CẤU HÌNH: Tên lửa trắng-đỏ phun lửa vàng cam trong vòng xoáy xanh
            ring(0.52, 0.56, 0.88, 0.46, Color3.fromRGB(45, 195, 255), 1.2, -25, 0)
            -- Lửa đuôi tên lửa
            part(0.26, 0.74, 0.26, 0.34, Color3.fromRGB(255, 235, 75), Color3.fromRGB(245, 85, 20), 45, 0.5, 1)
            -- Cánh đỏ 2 bên & mũi đỏ
            part(0.36, 0.44, 0.26, 0.14, Color3.fromRGB(245, 45, 75), nil, 15, 0.35, 1)
            part(0.56, 0.64, 0.14, 0.26, Color3.fromRGB(245, 45, 75), nil, 15, 0.35, 1)
            -- Thân tên lửa trắng bạc & mũi đỏ
            part(0.56, 0.44, 0.28, 0.58, Color3.fromRGB(248, 252, 255), Color3.fromRGB(185, 205, 235), 45, 0.45, 2)
            part(0.73, 0.27, 0.22, 0.24, Color3.fromRGB(255, 55, 65), Color3.fromRGB(195, 15, 35), 45, 0.4, 3)
            -- Cửa sổ tròn xanh dương
            part(0.58, 0.42, 0.17, 0.17, Color3.fromRGB(65, 185, 255), Color3.fromRGB(20, 75, 185), 0, 1, 4)
        end
    end

    local allTabs = {}
    local currentActiveTab = nil
    local function createTab(iconKey, name)
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(1, 0, 0, 23)
        btn.Text = ""; btn.BackgroundColor3 = Theme.BrandSoft
        btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
        local tStroke = Instance.new("UIStroke", btn)
        tStroke.Color = Theme.Brand; tStroke.Thickness = 1; tStroke.Transparency = 1

        local indicator = Instance.new("Frame", btn)
        indicator.Size = UDim2.new(0, 3, 0, 13); indicator.Position = UDim2.new(0, 2, 0.5, -6.5)
        indicator.BackgroundColor3 = Theme.Brand; indicator.BorderSizePixel = 0; indicator.Visible = false; indicator.ZIndex = 12
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        local iconBox = Instance.new("Frame", btn)
        iconBox.Size = UDim2.new(0, 18, 0, 18); iconBox.Position = UDim2.new(0, 6, 0.5, -9)
        iconBox.BackgroundColor3 = Color3.fromRGB(18, 22, 34); iconBox.BorderSizePixel = 0; iconBox.ZIndex = 12
        Instance.new("UICorner", iconBox).CornerRadius = UDim.new(0, 5)
        local ibStroke = Instance.new("UIStroke", iconBox)
        ibStroke.Color = Theme.Brand; ibStroke.Thickness = 0.9; ibStroke.Transparency = 0.65

        drawSidebarNeonIcon(iconBox, iconKey)

        local txtLbl = Instance.new("TextLabel", btn)
        txtLbl.Size = UDim2.new(1, -30, 1, 0); txtLbl.Position = UDim2.new(0, 28, 0, 0)
        txtLbl.BackgroundTransparency = 1; txtLbl.Text = name; txtLbl.TextColor3 = Theme.TextDim
        txtLbl.Font = Enum.Font.GothamBold; txtLbl.TextSize = 9.2; txtLbl.TextXAlignment = Enum.TextXAlignment.Left; txtLbl.ZIndex = 12

        table.insert(allTabs, {Btn = btn, Ind = indicator, Txt = txtLbl, IconBox = iconBox, IconStroke = ibStroke, Stroke = tStroke})
        return btn, indicator, txtLbl
    end

    local tab1, ind1 = createTab("Info", "THÔNG TIN")
    local tab2, ind2 = createTab("Feature", "TÍNH NĂNG")
    local tab3, ind3 = createTab("Character", "NHÂN VẬT")
    local tab7, ind7 = createTab("TpPlayer", "TP PLAYER")
    local tab6, ind6 = createTab("TpSave", "TP SAVE")
    local tab8, ind8 = createTab("AutoSkill", "AUTO SKILL")
    local tab5, ind5 = createTab("Music", "NHẠC ID")
    local tab4, ind4 = createTab("Utility", "TIỆN ÍCH")
    local tab9, ind9 = createTab("Config", "CẤU HÌNH")

    -- Tự động giãn đều chiều cao & khoảng cách 9 Tab bên Sidebar khi kéo phóng to/thu nhỏ Menu
    local function updateSidebarProportions()
        local availH = math.max(254, frame.Size.Y.Offset - 38)
        local padY = math.clamp(math.floor((availH - 254) * 0.045) + 4, 4, 10)
        tabPad.PaddingTop = UDim.new(0, padY)
        tabPad.PaddingBottom = UDim.new(0, padY)
        local spacing = math.clamp(2.5 + ((availH - 254) * 0.025), 2.5, 6.5)
        tabLayout.Padding = UDim.new(0, spacing)
        local totalUsable = availH - (padY * 2) - (spacing * 8) - 2
        local btnH = math.clamp(math.floor(totalUsable / 9), 23, 36)
        local boxSz = math.clamp(btnH - 6, 17, 22)
        local indH = math.clamp(btnH - 10, 13, 18)
        local txtSz = math.clamp(9.2 + ((btnH - 23) * 0.1), 9.2, 10.5)
        for _, item in ipairs(allTabs) do
            item.Btn.Size = UDim2.new(1, 0, 0, btnH)
            item.IconBox.Size = UDim2.new(0, boxSz, 0, boxSz)
            item.IconBox.Position = UDim2.new(0, 7, 0.5, -boxSz / 2)
            item.Txt.Position = UDim2.new(0, 11 + boxSz, 0, 0)
            item.Txt.Size = UDim2.new(1, -(13 + boxSz), 1, 0)
            item.Txt.TextSize = txtSz
            item.Ind.Position = UDim2.new(0, 2, 0.5, -indH / 2)
            if item.Ind.Visible then
                item.Ind.Size = UDim2.new(0, 3, 0, indH)
            end
        end
    end
    frame:GetPropertyChangedSignal("Size"):Connect(updateSidebarProportions)

    local pageContainer = Instance.new("Frame", frame)
    pageContainer.Size = UDim2.new(1, -114, 1, -38); pageContainer.Position = UDim2.new(0, 114, 0, 38)
    pageContainer.BackgroundTransparency = 1; pageContainer.ZIndex = 10

    local function createPage()
        local pg = Instance.new("ScrollingFrame", pageContainer)
        pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1
        pg.ScrollBarThickness = 3; pg.ScrollBarImageColor3 = Theme.Brand; pg.Visible = false; pg.BorderSizePixel = 0; pg.ZIndex = 10
        local layout = Instance.new("UIListLayout", pg)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 6); layout.SortOrder = Enum.SortOrder.LayoutOrder
        local pad = Instance.new("UIPadding", pg)
        pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 14)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) end)
        return pg
    end

    page1, page2, page3, page4, page8, page9 = createPage(), createPage(), createPage(), createPage(), createPage(), createPage()

    page5 = Instance.new("Frame", pageContainer)
    page5.Size = UDim2.new(1, 0, 1, 0); page5.BackgroundTransparency = 1; page5.Visible = false; page5.ZIndex = 10
    local l5 = Instance.new("UIListLayout", page5); l5.HorizontalAlignment = Enum.HorizontalAlignment.Center; l5.Padding = UDim.new(0, 5); l5.SortOrder = Enum.SortOrder.LayoutOrder; Instance.new("UIPadding", page5).PaddingTop = UDim.new(0, 6)

    page6 = Instance.new("Frame", pageContainer)
    page6.Size = UDim2.new(1, 0, 1, 0); page6.BackgroundTransparency = 1; page6.Visible = false; page6.ZIndex = 10
    local l6 = Instance.new("UIListLayout", page6); l6.HorizontalAlignment = Enum.HorizontalAlignment.Center; l6.Padding = UDim.new(0, 5); l6.SortOrder = Enum.SortOrder.LayoutOrder; Instance.new("UIPadding", page6).PaddingTop = UDim.new(0, 6)

    page7 = Instance.new("Frame", pageContainer)
    page7.Size = UDim2.new(1, 0, 1, 0); page7.BackgroundTransparency = 1; page7.Visible = false; page7.ZIndex = 10
    local l7 = Instance.new("UIListLayout", page7); l7.HorizontalAlignment = Enum.HorizontalAlignment.Center; l7.Padding = UDim.new(0, 5); l7.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", page7).PaddingTop = UDim.new(0, 6)

    local function showTab(pg, tb, ind)
        currentActiveTab = tb
        for _, p in pairs({page1, page2, page3, page4, page5, page6, page7, page8, page9}) do p.Visible = false end
        for _, item in ipairs(allTabs) do
            local isSel = (item.Btn == tb)
            item.Txt.TextColor3 = isSel and Theme.TextTitle or Theme.TextDim
            TweenService:Create(item.Btn, TweenInfo.new(0.18), {
                BackgroundTransparency = isSel and 0.12 or 1,
                BackgroundColor3 = Theme.BrandSoft
            }):Play()
            TweenService:Create(item.IconBox, TweenInfo.new(0.18), {
                BackgroundColor3 = isSel and Color3.fromRGB(14, 18, 28) or Color3.fromRGB(20, 24, 36)
            }):Play()
            if item.IconStroke then
                TweenService:Create(item.IconStroke, TweenInfo.new(0.18), {
                    Transparency = isSel and 0.15 or 0.7,
                    Color = Theme.Brand
                }):Play()
            end
            TweenService:Create(item.Stroke, TweenInfo.new(0.18), {
                Transparency = isSel and 0.45 or 1,
                Color = Theme.Brand
            }):Play()
            item.Ind.BackgroundColor3 = Theme.Brand
            item.Ind.Visible = isSel
        end
        pg.Visible = true
        local targetIndH = math.clamp(tb.Size.Y.Offset - 10, 13, 18)
        ind.Position = UDim2.new(0, 2, 0.5, -targetIndH / 2)
        ind.Size = UDim2.new(0, 3, 0, 0)
        TweenService:Create(ind, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, targetIndH)}):Play()

        if pg == page9 and onTab9Shown then
            task.spawn(onTab9Shown)
        end
    end

    refreshThemeVisuals = function()
        local preset = ThemePresets[State.ThemeIdx] or ThemePresets[1]
        Theme.Brand = preset.Brand
        Theme.BrandSoft = preset.Soft
        Theme.AccentOn = preset.On
        Theme.ItemActive = preset.ActiveBg

        if not State.RGB then
            titleLabel.TextColor3 = Theme.TextTitle
            frameStroke.Color = Theme.Brand
            avatarStroke.Color = Theme.Brand
            openStroke.Color = Color3.fromRGB(236, 242, 250)
        end
        verBadge.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
        verBadge.TextColor3 = getSoftBrandColor(Theme.Brand)
        verStroke.Color = Theme.Brand
        onlineDot.BackgroundColor3 = Theme.AccentOn
        hLineGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Brand),
            ColorSequenceKeypoint.new(0.5, Theme.AccentOn),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 115, 255))
        })
        for _, pg in pairs({page1, page2, page3, page4, page8, page9}) do
            pg.ScrollBarImageColor3 = Theme.Brand
        end
        for _, item in ipairs(allTabs) do
            local isSel = (item.Btn == currentActiveTab)
            item.Btn.BackgroundColor3 = Theme.BrandSoft
            item.Ind.BackgroundColor3 = Theme.Brand
            item.Stroke.Color = Theme.Brand
            item.IconBox.BackgroundColor3 = isSel and Color3.fromRGB(14, 18, 28) or Color3.fromRGB(20, 24, 36)
            if item.IconStroke then
                item.IconStroke.Color = Theme.Brand
                item.IconStroke.Transparency = isSel and 0.15 or 0.7
            end
        end
        cleanRGBElements()
        for _, obj in ipairs(RGBElements) do
            if obj.UseBrand then
                obj.DefaultColor = Theme.Brand
                if not State.RGB and obj.Stroke and obj.Stroke.Parent then
                    obj.Stroke.Color = Theme.Brand
                end
            end
        end
        for _, fn in ipairs(BrandCallbacks) do
            pcall(fn, Theme.Brand)
        end
        for k, _ in pairs(SyncCallbacks) do
            fireSync(k, State[k] and true or false, true)
        end
    end

    tab1.MouseButton1Click:Connect(function() clickAnimate(tab1); showTab(page1, tab1, ind1) end)
    tab2.MouseButton1Click:Connect(function() clickAnimate(tab2); showTab(page2, tab2, ind2) end)
    tab3.MouseButton1Click:Connect(function() clickAnimate(tab3); showTab(page3, tab3, ind3) end)
    tab4.MouseButton1Click:Connect(function() clickAnimate(tab4); showTab(page4, tab4, ind4) end)
    tab5.MouseButton1Click:Connect(function() clickAnimate(tab5); showTab(page5, tab5, ind5) end)
    tab6.MouseButton1Click:Connect(function() clickAnimate(tab6); showTab(page6, tab6, ind6) end)
    tab7.MouseButton1Click:Connect(function() clickAnimate(tab7); showTab(page7, tab7, ind7) end)
    tab8.MouseButton1Click:Connect(function() clickAnimate(tab8); showTab(page8, tab8, ind8) end)
    tab9.MouseButton1Click:Connect(function() clickAnimate(tab9); showTab(page9, tab9, ind9) end)
    showTab(page1, tab1, ind1)

    local currentMenuScale = 1

    -- Góc kéo phóng to / thu nhỏ Menu (Drag-to-Resize)
    local resizeHandle = Instance.new("TextButton", frame)
    resizeHandle.Name = "ResizeGrip"
    resizeHandle.Size = UDim2.new(0, 22, 0, 22)
    resizeHandle.Position = UDim2.new(1, -22, 1, -22)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Text = "◢"
    resizeHandle.TextColor3 = getSoftBrandColor(Theme.Brand)
    resizeHandle.TextTransparency = 0.25
    resizeHandle.Font = Enum.Font.GothamBold
    resizeHandle.TextSize = 12
    resizeHandle.AutoButtonColor = false
    resizeHandle.ZIndex = 25

    registerBrandUpdater(function(newBrand)
        if resizeHandle and resizeHandle.Parent then
            resizeHandle.TextColor3 = getSoftBrandColor(newBrand)
        end
    end)

    do
        local resizingInput = nil
        local resizeStartPos = nil
        local startWidth, startHeight, startScale = 440, 292, 1
        local anchorAbsPos = nil
        local lastTapTick = 0

        resizeHandle.InputBegan:Connect(function(input)
            if not resizingInput and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                local now = tick()
                if now - lastTapTick < 0.32 then
                    lastTapTick = 0
                    currentMenuScale = 1
                    frameScale.Scale = 1
                    frame.Size = UDim2.new(0, 440, 0, 292)
                    MakeToast("Kích thước Menu", "Đã khôi phục kích thước mặc định (100%)", Theme.Brand)
                    return
                end
                lastTapTick = now

                resizingInput = input
                resizeStartPos = input.Position
                startWidth = frame.Size.X.Offset
                startHeight = frame.Size.Y.Offset
                startScale = currentMenuScale
                anchorAbsPos = frame.AbsolutePosition
                TweenService:Create(resizeHandle, TweenInfo.new(0.12), {TextTransparency = 0}):Play()
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if isDragUpdateInput(input, resizingInput) then
                local delta = input.Position - resizeStartPos
                local targetVisualW = math.clamp((startWidth * startScale) + delta.X, 310, 680)
                local targetVisualH = math.clamp((startHeight * startScale) + delta.Y, 206, 460)

                if targetVisualW < 440 or targetVisualH < 270 then
                    local scaleW = targetVisualW / 440
                    local scaleH = targetVisualH / 292
                    currentMenuScale = math.clamp(math.min(scaleW, scaleH), 0.70, 1.0)
                    frameScale.Scale = currentMenuScale
                    local unscaledW = math.clamp(math.floor(targetVisualW / currentMenuScale), 440, 680)
                    local unscaledH = math.clamp(math.floor(targetVisualH / currentMenuScale), 280, 460)
                    frame.Size = UDim2.new(0, unscaledW, 0, unscaledH)
                else
                    currentMenuScale = 1
                    frameScale.Scale = 1
                    frame.Size = UDim2.new(0, math.floor(targetVisualW), 0, math.floor(targetVisualH))
                end

                if anchorAbsPos and frame.Parent and frame.Parent:IsA("GuiBase2d") then
                    local parentAbs = frame.Parent.AbsolutePosition
                    frame.Position = UDim2.new(0, anchorAbsPos.X - parentAbs.X, 0, anchorAbsPos.Y - parentAbs.Y)
                    OPEN_POS = frame.Position
                end
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input == resizingInput then
                resizingInput = nil
                TweenService:Create(resizeHandle, TweenInfo.new(0.2), {TextTransparency = 0.25}):Play()
            end
        end)
    end

    local function toggleMenuWindow()
        opened = not opened
        if syncDragonButtonState then syncDragonButtonState(opened) end
        if not State.RGB then
            openStroke.Color = Color3.fromRGB(236, 242, 250)
        end
        if opened then
            frameScale.Scale = currentMenuScale * 0.88
            TweenService:Create(frameScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = currentMenuScale}):Play()
        else
            TweenService:Create(frameScale, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = currentMenuScale * 0.88}):Play()
        end
        frame:TweenPosition(opened and OPEN_POS or CLOSE_POS, "Out", "Back", 0.36, true)
    end

    openBtn.MouseButton1Click:Connect(function() clickAnimate(openBtn); toggleMenuWindow() end)
    minBtn.MouseButton1Click:Connect(function() clickAnimate(minBtn); toggleMenuWindow() end)
end
-- ==========================================
-- COMPONENTS HỆ THỐNG
-- ==========================================
local function createDivider(parent, text)
    local dFrame = Instance.new("Frame", parent)
    dFrame.Size = UDim2.new(0.94, 0, 0, 20); dFrame.BackgroundTransparency = 1; dFrame.ZIndex = 10

    local lineLeft = Instance.new("Frame", dFrame)
    lineLeft.Size = UDim2.new(1, 0, 0, 1.5); lineLeft.Position = UDim2.new(0, 0, 0.5, 0)
    lineLeft.BackgroundColor3 = Theme.Brand; lineLeft.BorderSizePixel = 0; lineLeft.ZIndex = 10
    local lineGrad = Instance.new("UIGradient", lineLeft)
    lineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.35),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.35),
        NumberSequenceKeypoint.new(1, 1)
    })

    local pill = Instance.new("TextLabel", dFrame)
    pill.AutomaticSize = Enum.AutomaticSize.X; pill.Size = UDim2.new(0, 0, 0, 17)
    pill.AnchorPoint = Vector2.new(0.5, 0.5); pill.Position = UDim2.new(0.5, 0, 0.5, 0)
    pill.BackgroundColor3 = Color3.fromRGB(16, 19, 29); pill.Text = "  " .. text .. "  "
    pill.TextColor3 = Theme.Brand; pill.Font = Enum.Font.GothamBold; pill.TextSize = 8.8; pill.ZIndex = 11
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local pStroke = Instance.new("UIStroke", pill); pStroke.Color = Theme.Brand; pStroke.Thickness = 0.9; pStroke.Transparency = 0.45
    table.insert(RGBElements, {Type = "Button", Stroke = pStroke, DefaultColor = Theme.Brand, UseBrand = true})
    registerBrandUpdater(function(newBrand)
        if lineLeft and lineLeft.Parent then lineLeft.BackgroundColor3 = newBrand end
        if pill and pill.Parent then pill.TextColor3 = newBrand end
    end)
    return dFrame
end

local function createCycleBtn(parent, prefix, options, stateVar)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.94, 0, 0, 32); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = Theme.Brand; stroke.Thickness = 1; stroke.Transparency = 0.25; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = Theme.Brand, UseBrand = true})

    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.TextColor3 = Theme.Brand; title.Font = Enum.Font.GothamBold; title.TextSize = 10.5; title.ZIndex = 10
    registerBrandUpdater(function(newBrand)
        if title and title.Parent then title.TextColor3 = newBrand end
    end)

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
    btnFrame.Size = UDim2.new(0.94, 0, 0, 33); btnFrame.BackgroundTransparency = 1

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
    switchKnob.Size = UDim2.new(0, 13, 0, 13); switchKnob.BorderSizePixel = 0; switchKnob.ZIndex = 12
    Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)

    local active = State[varName] and true or false

    local function applyVisual(isOn, instant)
        active = isOn
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
    registerSync(varName, applyVisual)
    table.insert(RGBElements, {Type = "Toggle", Stroke = stroke, State = function() return State[varName] end})

    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn)
        State[varName] = not State[varName]
        active = State[varName]
        fireSync(varName, active, false)
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
    local isBrandColor = (color == Theme.Brand)
    local btnFrame = Instance.new("Frame", parent)
    btnFrame.Size = UDim2.new(0.94, 0, 0, 31); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    addSoftGradient(btn, Color3.fromRGB(32, 36, 50), Color3.fromRGB(24, 27, 38), 90)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = color; stroke.Thickness = 1.1; stroke.Transparency = 0.25; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local rgbEntry = {Type = "Button", Stroke = stroke, DefaultColor = color, UseBrand = isBrandColor}
    table.insert(RGBElements, rgbEntry)
    local title = Instance.new("TextLabel", btn)
    title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = isBrandColor and getSoftBrandColor(color) or color; title.Font = Enum.Font.GothamSemibold; title.TextSize = 10.2; title.ZIndex = 10
    if isBrandColor then
        registerBrandUpdater(function(newBrand)
            if title and title.Parent then title.TextColor3 = getSoftBrandColor(newBrand) end
        end)
    end
    btn.MouseButton1Click:Connect(function()
        local activeCol = isBrandColor and Theme.Brand or color
        clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
        task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = activeCol}):Play() end
        MakeToast("Đã thực thi", text, activeCol); callback()
    end)
    return btnFrame
end

local function createDualButtons(parent, text1, color1, cb1, text2, color2, cb2)
    local dFrame = Instance.new("Frame", parent)
    dFrame.Size = UDim2.new(0.94, 0, 0, 30); dFrame.BackgroundTransparency = 1
    local function makeBtn(xPos, txt, col, cb)
        local isBrandColor = (col == Theme.Brand)
        local btn = Instance.new("TextButton", dFrame)
        btn.Size = UDim2.new(0.486, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0); btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        addSoftGradient(btn, Color3.fromRGB(31, 35, 48), Color3.fromRGB(23, 26, 36), 90)
        local stroke = Instance.new("UIStroke", btn); stroke.Color = col; stroke.Thickness = 1.1; stroke.Transparency = 0.25; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = col, UseBrand = isBrandColor})
        local title = Instance.new("TextLabel", btn)
        title.Size = UDim2.new(1, -6, 1, 0); title.Position = UDim2.new(0, 3, 0, 0); title.BackgroundTransparency = 1; title.Text = txt; title.TextColor3 = isBrandColor and getSoftBrandColor(col) or col; title.Font = Enum.Font.GothamSemibold; title.TextSize = 9.5; title.TextTruncate = Enum.TextTruncate.AtEnd; title.ZIndex = 10
        if isBrandColor then
            registerBrandUpdater(function(newBrand)
                if title and title.Parent then title.TextColor3 = getSoftBrandColor(newBrand) end
            end)
        end
        btn.MouseButton1Click:Connect(function()
            local activeCol = isBrandColor and Theme.Brand or col
            clickAnimate(btn); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Theme.TextTitle}):Play() end
            task.wait(0.15); if not State.RGB then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = activeCol}):Play() end
            if txt ~= "🗑️ XÓA TẤT CẢ" then MakeToast("Đã thực thi", txt, activeCol) end; cb()
        end)
    end
    makeBtn(0, text1, color1, cb1); makeBtn(0.514, text2, color2, cb2)
    return dFrame
end

local function createSlider(parent, text, min, max, varName, callback)
    local sFrame = Instance.new("Frame", parent)
    sFrame.Size = UDim2.new(0.94, 0, 0, 38); sFrame.BackgroundTransparency = 1
    local bg = Instance.new("Frame", sFrame); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Theme.ItemBg; bg.ZIndex = 10
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", bg); stroke.Color = Theme.Stroke; stroke.Thickness = 1
    table.insert(RGBElements, {Type = "Slider", Stroke = stroke})

    local titleLabel = Instance.new("TextLabel", bg)
    titleLabel.Size = UDim2.new(0.72, 0, 0, 17); titleLabel.Position = UDim2.new(0, 12, 0, 3)
    titleLabel.BackgroundTransparency = 1; titleLabel.Text = text; titleLabel.TextColor3 = Theme.TextTitle
    titleLabel.Font = Enum.Font.GothamSemibold; titleLabel.TextSize = 10; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.ZIndex = 10

    local valBadge = Instance.new("Frame", bg)
    valBadge.Size = UDim2.new(0, 44, 0, 15); valBadge.Position = UDim2.new(1, -54, 0, 4)
    valBadge.BackgroundColor3 = Color3.fromRGB(17, 19, 27); valBadge.ZIndex = 10
    Instance.new("UICorner", valBadge).CornerRadius = UDim.new(0, 5)
    local valStroke = Instance.new("UIStroke", valBadge); valStroke.Color = Theme.Stroke; valStroke.Thickness = 0.8

    local valLabel = Instance.new("TextLabel", valBadge)
    valLabel.Size = UDim2.new(1, 0, 1, 0); valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(State[varName]); valLabel.TextColor3 = Theme.Brand
    valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 9.5; valLabel.ZIndex = 11

    local track = Instance.new("Frame", bg)
    track.Size = UDim2.new(1, -24, 0, 5); track.Position = UDim2.new(0, 12, 0, 25)
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

    registerBrandUpdater(function(newBrand)
        if valLabel and valLabel.Parent then valLabel.TextColor3 = newBrand end
        if fill and fill.Parent then fill.BackgroundColor3 = newBrand end
        if knobStroke and knobStroke.Parent then knobStroke.Color = newBrand end
    end)

    local dragInput = nil
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
        if not dragInput and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input; updateSlider(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if isDragUpdateInput(input, dragInput) then
            updateSlider(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input == dragInput then
            dragInput = nil
        end
    end)
    if callback then task.spawn(callback, State[varName]) end
    return sFrame
end

local function createCombinedToggleSlider(parent, toggleText, toggleVar, sliderText, min, max, sliderVar, toggleCb, sliderCb)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(0.94, 0, 0, 62)
    card.BackgroundColor3 = Theme.ItemBg
    card.ZIndex = 10
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", card); stroke.Thickness = 1

    local topBtn = Instance.new("TextButton", card)
    topBtn.Size = UDim2.new(1, 0, 0, 30); topBtn.BackgroundTransparency = 1
    topBtn.Text = ""; topBtn.AutoButtonColor = false; topBtn.ZIndex = 11

    local leftBar = Instance.new("Frame", topBtn)
    leftBar.Size = UDim2.new(0, 3, 0, 15); leftBar.Position = UDim2.new(0, 6, 0.5, -7.5)
    leftBar.BorderSizePixel = 0; leftBar.ZIndex = 12
    Instance.new("UICorner", leftBar).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel", topBtn)
    title.Size = UDim2.new(1, -70, 1, 0); title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1; title.Text = toggleText; title.TextColor3 = Theme.TextTitle
    title.Font = Enum.Font.GothamBold; title.TextSize = 10.5
    title.TextXAlignment = Enum.TextXAlignment.Left; title.TextTruncate = Enum.TextTruncate.AtEnd; title.ZIndex = 12

    local switchTrack = Instance.new("Frame", topBtn)
    switchTrack.Size = UDim2.new(0, 38, 0, 18); switchTrack.Position = UDim2.new(1, -46, 0.5, -9)
    switchTrack.BorderSizePixel = 0; switchTrack.ZIndex = 12
    Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)
    local switchStroke = Instance.new("UIStroke", switchTrack); switchStroke.Thickness = 1; switchStroke.Transparency = 0.25

    local switchKnob = Instance.new("Frame", switchTrack)
    switchKnob.Size = UDim2.new(0, 12, 0, 12); switchKnob.BorderSizePixel = 0; switchKnob.ZIndex = 13
    Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)

    local divider = Instance.new("Frame", card)
    divider.Size = UDim2.new(1, -16, 0, 1); divider.Position = UDim2.new(0, 8, 0, 30)
    divider.BackgroundColor3 = Theme.Stroke; divider.BackgroundTransparency = 0.35; divider.BorderSizePixel = 0; divider.ZIndex = 11

    local sliderArea = Instance.new("Frame", card)
    sliderArea.Size = UDim2.new(1, 0, 0, 31); sliderArea.Position = UDim2.new(0, 0, 0, 31)
    sliderArea.BackgroundTransparency = 1; sliderArea.ZIndex = 11

    local sTitle = Instance.new("TextLabel", sliderArea)
    sTitle.Size = UDim2.new(0.68, 0, 0, 14); sTitle.Position = UDim2.new(0, 15, 0, 2)
    sTitle.BackgroundTransparency = 1; sTitle.Text = "• " .. sliderText
    sTitle.Font = Enum.Font.GothamSemibold; sTitle.TextSize = 9.5; sTitle.TextXAlignment = Enum.TextXAlignment.Left; sTitle.ZIndex = 12

    local valBadge = Instance.new("Frame", sliderArea)
    valBadge.Size = UDim2.new(0, 44, 0, 14); valBadge.Position = UDim2.new(1, -52, 0, 2)
    valBadge.BackgroundColor3 = Color3.fromRGB(16, 18, 26); valBadge.ZIndex = 12
    Instance.new("UICorner", valBadge).CornerRadius = UDim.new(0, 4)
    local valStroke = Instance.new("UIStroke", valBadge); valStroke.Color = Theme.Stroke; valStroke.Thickness = 0.8

    local valLabel = Instance.new("TextLabel", valBadge)
    valLabel.Size = UDim2.new(1, 0, 1, 0); valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(State[sliderVar]); valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 9.5; valLabel.ZIndex = 13

    local track = Instance.new("Frame", sliderArea)
    track.Size = UDim2.new(1, -26, 0, 5); track.Position = UDim2.new(0, 13, 0, 20)
    track.BackgroundColor3 = Color3.fromRGB(15, 17, 24); track.ZIndex = 12
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local initPos = math.clamp((State[sliderVar] - min) / (max - min), 0, 1)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(initPos, 0, 1, 0); fill.BackgroundColor3 = Theme.Brand; fill.ZIndex = 13
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 11, 0, 11); knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(initPos, 0, 0.5, 0); knob.BackgroundColor3 = Color3.fromRGB(240, 248, 255); knob.ZIndex = 14
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob); knobStroke.Thickness = 1.4

    local active = State[toggleVar] and true or false

    local function syncVisual(isOn, instant)
        active = isOn
        local tInfo = TweenInfo.new(instant and 0 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local trackCol = isOn and Color3.fromRGB(34, 118, 82) or Color3.fromRGB(18, 20, 28)
        local knobCol = isOn and Color3.fromRGB(240, 255, 245) or Color3.fromRGB(125, 135, 155)
        local knobPos = isOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        local barCol = isOn and Theme.AccentOn or Color3.fromRGB(60, 66, 84)
        local bgCol = isOn and Theme.ItemActive or Theme.ItemBg
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
    registerSync(toggleVar, syncVisual)
    table.insert(RGBElements, {Type = "Toggle", Stroke = stroke, State = function() return State[toggleVar] end})

    topBtn.MouseButton1Click:Connect(function()
        clickAnimate(card)
        State[toggleVar] = not State[toggleVar]
        active = State[toggleVar]
        fireSync(toggleVar, active, false)
        MakeToast(active and "Đã Bật" or "Đã Tắt", toggleText, active and Theme.AccentOn or Theme.AccentOff)
        if State.AutoSave then saveConfig() end
        if toggleCb then toggleCb(active) end
    end)

    local dragInput = nil
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
        if not dragInput and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input; updateSlider(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if isDragUpdateInput(input, dragInput) then
            updateSlider(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input == dragInput then
            dragInput = nil
        end
    end)

    if active and toggleCb then task.spawn(toggleCb, active) end
    if sliderCb then task.spawn(sliderCb, State[sliderVar]) end
    return card
end

task.spawn(function()
    while task.wait(0.05) do
        if State.RGB then
            local hue = tick() % 5 / 5; local color = Color3.fromHSV(hue, 0.75, 0.95)
            titleLabel.TextColor3 = color; frameStroke.Color = color; avatarStroke.Color = color; openStroke.Color = color
            for _, obj in pairs(RGBElements) do
                if obj.Stroke and obj.Stroke.Parent then obj.Stroke.Color = color end
            end
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
-- [TAB 2: TÍNH NĂNG (SẮP XẾP THEO NHÓM RÕ RÀNG)]
-- ==========================================
local wasHorizontalTp = false
do

-- Sửa lỗi không bật lại trạng thái FallingDown/Ragdoll khi tắt AntiStun
createToggle(page2, "🛡️ Chống ngã & Chống văng xa", "AntiStun", function(v)
    if not v and player.Character then
        pcall(function()
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                if not State.Fly and not wasHorizontalTp then
                    hum.PlatformStand = false
                end
            end
        end)
    end
end)

createToggle(page2, "🔒 Khóa vị trí nhân vật (Anchor)", "LockPosition", function(v)
    if not v and player.Character then
        local r = getUniversalRoot(player.Character)
        if r then r.Anchored = false end
    end
end)
createToggle(page2, "🚀 Nhảy trên không (Inf Jump)", "InfJump")
UIS.JumpRequest:Connect(function()
    if State.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local airWalkPart, airWalkConn, airWalkY = nil, nil, nil
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
        airWalkPart.Name = "VipAirWalk"; airWalkPart.Size = Vector3.new(12, 0.5, 12)
        airWalkPart.Anchored = true; airWalkPart.CanCollide = true; airWalkPart.Transparency = 0.45
        airWalkPart.Material = Enum.Material.Neon; airWalkPart.Color = Theme.Brand; airWalkPart.Parent = workspace

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
                if airWalkY == nil then airWalkY = r.Position.Y - offset end
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

createToggle(page2, "⚡ Lấy đồ nhanh (Instant Prompt)", "Instant")
createToggle(page2, "🧲 Auto nhặt đồ & Tool xung quanh", "AutoCollect")
createToggle(page2, "💎 Hút Tiền, Ngọc & Vật phẩm rơi (Magnet)", "MagnetOrbs")

createToggle(page2, "🔴 Định vị người chơi (ESP)", "ESP")

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

createButton(page2, "⚡ NHẬN GẬY CLICK TP", Theme.Brand, function()
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    if backpack:FindFirstChild("⚡ Click TP") or (player.Character and player.Character:FindFirstChild("⚡ Click TP")) then
        MakeToast("Thông báo", "Bạn đã có Gậy Click TP trong túi!", Theme.Brand)
        return
    end
    local tool = Instance.new("Tool")
    tool.Name = "⚡ Click TP"; tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        if mouse and mouse.Hit and player.Character then
            local root = getUniversalRoot(player.Character)
            if root then
                root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3.5, 0))
                if State.AirWalk then airWalkY = root.Position.Y - getFootOffset(player.Character) end
            end
        end
    end)
    tool.Parent = backpack
end)

createDualButtons(
    page2, "🔭 MỞ KHÓA ZOOM CAM", Theme.Brand,
    function()
        pcall(function()
            player.CameraMaxZoomDistance = 10000
            player.CameraMinZoomDistance = 0.5
            player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            workspace.CurrentCamera.FieldOfView = 105
        end)
    end,
    "👥 TẠO PHÂN THÂN", Theme.Brand,
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

end

-- ==========================================
-- [TAB 3: NHÂN VẬT (DI CHUYỂN, CHIẾN ĐẤU & ÁNH SÁNG)]
-- ==========================================
do
local defaultWalkSpeed = 16
local defaultJumpPower = 50

createCombinedToggleSlider(page3, "🕊️ Bay trên bầu trời (Fly)", "Fly", "Tốc độ bay", 10, 1000, "FlySpeed", function(v)
    local char = player.Character
    if char then
        local root = getUniversalRoot(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if v then
            if root and not root:FindFirstChild("FlyBodyVelocity") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "FlyBodyVelocity"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.zero; bv.Parent = root

                local bg = Instance.new("BodyGyro")
                bg.Name = "FlyBodyGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.P = 10000; bg.D = 100; bg.Parent = root
            end
        else
            if root and root:FindFirstChild("FlyBodyVelocity") then root.FlyBodyVelocity:Destroy() end
            if root and root:FindFirstChild("FlyBodyGyro") then root.FlyBodyGyro:Destroy() end
            if hum then hum.PlatformStand = false end
        end
    end
end)

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

createCombinedToggleSlider(page3, "💨 Lướt liên tục (Auto Dash)", "AutoDash", "Tốc độ lướt", 1, 50, "DashSpeed")

createToggle(page3, "🖱️ Auto Click Vũ Khí", "AutoClick")
createCombinedToggleSlider(page3, "⚔️ Đánh xa (Reach Vũ Khí)", "Reach", "Kích thước vũ khí", 0, 300, "ReachSize")
createCombinedToggleSlider(page3, "🎯 Mở rộng Hitbox", "Hitbox", "Kích thước Hitbox", 0, 100, "HitboxSize")
createCombinedToggleSlider(page3, "🌪️ Xoay vòng tròn (SpinBot)", "SpinBot", "Tốc độ xoay", 0, 100, "SpinSpeed")

createCombinedToggleSlider(page3, "💡 Ánh sáng quanh người", "PlayerLight", "Phạm vi sáng (Max 60)", 0, 60, "LightRange", function(v)
    if not v and player.Character then
        local root = getUniversalRoot(player.Character)
        if root then
            local light = root:FindFirstChild("PlayerPointLight")
            if light then light:Destroy() end
        end
    end
end)
createSlider(page3, "• Độ sáng đèn", 0, 5, "LightBrightness")
createCycleBtn(page3, "🎨 Đổi màu sáng:", PlayerLightColors, "LightColorIdx")
end
-- ==========================================
-- [TAB 4 (SIDEBAR #8): TIỆN ÍCH (GỌN GÀNG & ĐẦY ĐỦ)]
-- ==========================================
local miniHudFrame, hudLabel
do
local function hopServer(sortOrder)
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=100"
    local function getServers(cursor)
        local url = api .. (cursor and "&cursor=" .. cursor or "")
        local success, res = pcall(function() return game:HttpGet(url) end)
        if success then return HttpService:JSONDecode(res) end
    end
    local nextCursor, targetServer = nil, nil
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
    if #Players:GetPlayers() <= 1 then
        player:Kick("\nĐang vào lại server..."); task.wait(); TeleportService:Teleport(game.PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end

createDivider(page4, "GIAO DIỆN & CÀI ĐẶT MENU")
do
    local themeCard = Instance.new("Frame", page4)
    themeCard.Size = UDim2.new(0.94, 0, 0, 32); themeCard.BackgroundTransparency = 1
    local tBtn = Instance.new("TextButton", themeCard)
    tBtn.Size = UDim2.new(1, 0, 1, 0); tBtn.BackgroundColor3 = Theme.ItemBg; tBtn.Text = ""; tBtn.AutoButtonColor = false; tBtn.ZIndex = 10
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 8)
    local tStroke = Instance.new("UIStroke", tBtn); tStroke.Color = Theme.Brand; tStroke.Thickness = 1.1; tStroke.Transparency = 0.2
    table.insert(RGBElements, {Type = "Button", Stroke = tStroke, DefaultColor = Theme.Brand, UseBrand = true})

    local tTitle = Instance.new("TextLabel", tBtn)
    tTitle.Size = UDim2.new(1, 0, 1, 0); tTitle.BackgroundTransparency = 1; tTitle.Font = Enum.Font.GothamBold; tTitle.TextSize = 10.2; tTitle.ZIndex = 11

    local function syncThemeText()
        local p = ThemePresets[State.ThemeIdx] or ThemePresets[1]
        tTitle.Text = "🎨 Chủ đề giao diện: " .. p.Name
        tTitle.TextColor3 = Theme.Brand
        if not State.RGB then tStroke.Color = Theme.Brand end
    end
    syncThemeText()
    registerBrandUpdater(syncThemeText)

    tBtn.MouseButton1Click:Connect(function()
        clickAnimate(tBtn)
        State.ThemeIdx = (State.ThemeIdx % #ThemePresets) + 1
        if refreshThemeVisuals then refreshThemeVisuals() end
        syncThemeText()
        local p = ThemePresets[State.ThemeIdx]
        MakeToast("Đổi Chủ Đề", "Đã chuyển sang " .. p.Name, Theme.Brand)
        if State.AutoSave then saveConfig() end
    end)
end
createToggle(page4, "💾 Lưu Cài Đặt Tự Động", "AutoSave", function(v)
    if v then saveConfig(); MakeToast("Đã Bật", "Đã lưu cấu hình hiện tại!", Theme.AccentOn)
    else pcall(function() if isfile and isfile(configFileName) then delfile(configFileName) end end); MakeToast("Đã Tắt", "Đã xóa cấu hình cũ!", Theme.AccentOff) end
end)

-- Sửa lỗi mất màu viền chủ đề (Theme.Brand) khi tắt chế độ RGB
createToggle(page4, "🌈 Chế độ viền RGB", "RGB", function(v)
    if not v then
        titleLabel.TextColor3 = Theme.TextTitle
        frameStroke.Color = Theme.Brand
        avatarStroke.Color = Theme.Brand
        openStroke.Color = Color3.fromRGB(236, 242, 250)
        cleanRGBElements()
        for _, obj in pairs(RGBElements) do
            if obj.Stroke and obj.Stroke.Parent then
                if obj.Type == "Frame" then
                    obj.Stroke.Color = Theme.Brand
                elseif obj.Type == "Toggle" then
                    obj.Stroke.Color = obj.State() and Color3.fromRGB(54, 140, 98) or Theme.Stroke
                elseif obj.Type == "Button" then
                    obj.Stroke.Color = obj.UseBrand and Theme.Brand or obj.DefaultColor
                elseif obj.Type == "Slider" or obj.Type == "Info" or obj.Type == "Container" then
                    obj.Stroke.Color = Theme.Stroke
                end
            end
        end
        if refreshThemeVisuals then refreshThemeVisuals() end
    end
end)

miniHudFrame = Instance.new("Frame", gui)
miniHudFrame.Size = UDim2.new(0, 128, 0, 26); miniHudFrame.Position = UDim2.new(0, 65, 0.05, 9)
miniHudFrame.BackgroundColor3 = Theme.MainBg; miniHudFrame.BackgroundTransparency = 0.12
miniHudFrame.Visible = State.MiniHUD; miniHudFrame.ZIndex = 10
Instance.new("UICorner", miniHudFrame).CornerRadius = UDim.new(1, 0)
local hudStroke = Instance.new("UIStroke", miniHudFrame); hudStroke.Color = Theme.Brand; hudStroke.Thickness = 1.2
table.insert(RGBElements, {Type = "Button", Stroke = hudStroke, DefaultColor = Theme.Brand, UseBrand = true})

hudLabel = Instance.new("TextLabel", miniHudFrame)
hudLabel.Size = UDim2.new(1, 0, 1, 0); hudLabel.BackgroundTransparency = 1; hudLabel.RichText = true
hudLabel.Text = "⚡ 60 FPS | 🌐 0 ms"; hudLabel.TextColor3 = Theme.TextTitle
hudLabel.Font = Enum.Font.GothamBold; hudLabel.TextSize = 10; hudLabel.ZIndex = 10

do
    local hudDragInput, hudStart, hudPos = nil, nil, nil
    miniHudFrame.InputBegan:Connect(function(inp)
        if not hudDragInput and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            hudDragInput = inp; hudStart = inp.Position; hudPos = miniHudFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if isDragUpdateInput(inp, hudDragInput) then
            miniHudFrame.Position = UDim2.new(hudPos.X.Scale, hudPos.X.Offset + (inp.Position.X - hudStart.X), hudPos.Y.Scale, hudPos.Y.Offset + (inp.Position.Y - hudStart.Y))
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp == hudDragInput then hudDragInput = nil end
    end)
end
createToggle(page4, "📟 Đồng hồ FPS & Ping Mini ngoài màn hình", "MiniHUD", function(v) miniHudFrame.Visible = v end)
createToggle(page4, "💫 Mở khóa ShiftLock Mobile", "ShiftLock", function(v) pcall(function() player.DevEnableMouseLock = v end) end)

createDivider(page4, "TREO MÁY AN TOÀN (AFK GUARD)")
createToggle(page4, "🛡️ Chống AFK (Anti-AFK)", "AntiAfk")
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

createToggle(page4, "🔌 Tự động vào lại khi văng game (Reconnect)", "AutoReconnect")
pcall(function()
    GuiService.ErrorMessageChanged:Connect(function(msg)
        if msg and msg ~= "" and State.AutoReconnect then
            MakeToast("🔌 Auto Reconnect", "Phát hiện mất kết nối! Đang vào lại...", Theme.Brand)
            task.wait(2)
            pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
        end
    end)
end)

createDivider(page4, "ĐIỀU KHIỂN SERVER & MÔI TRƯỜNG")
createDualButtons(
    page4, "☀️ TRỜI SÁNG", Theme.Brand,
    function() pcall(function() Lighting.ClockTime = 12; Lighting.Brightness = 2 end) end,
    "🌙 TRỜI TỐI", Theme.Brand,
    function() pcall(function() Lighting.ClockTime = 0; Lighting.Brightness = 1 end) end
)
createDualButtons(page4, "🔄 VÀO LẠI SV", Theme.Brand, rejoinServer, "🎲 ĐỔI SV NGẪU NHIÊN", Theme.Brand, function() hopServer("Desc") end)
createDualButtons(page4, "📉 ĐỔI SV ÍT NGƯỜI", Theme.Brand, function() hopServer("Asc") end, "📈 ĐỔI SV ĐÔNG NGƯỜI", Theme.Brand, function() hopServer("Desc") end)

createDivider(page4, "CÔNG CỤ SCRIPT NGOÀI")
createDualButtons(
    page4, "💻 LỆNH ADMIN", Theme.Brand,
    function() pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end) end,
    "📁 MENU TP SAVE", Theme.Brand,
    function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip13/refs/heads/main/menu-save.lua"))() end) end
)
createDualButtons(
    page4, "🕊️ FLY V1", Theme.Brand,
    function() pcall(function() loadstring(game:HttpGet('https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f425b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%25202%2520obflucator', true))() end) end,
    "🕊️ FLY V2", Theme.Brand,
    function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))() end) end
)
createDualButtons(
    page4, "🕊️ FLY V3", Theme.Brand,
    function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip/refs/heads/main/menu-fly.lua"))() end) end,
    "🎯 TP PLAYS", Theme.Brand,
    function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/hack.lua/refs/heads/main/menu-tp-play.lua"))() end) end
)

end

-- ==========================================
-- [TAB 5: NHẠC ID (GỘP PLAY/PAUSE 1 NÚT + XOÁ NÚT VUÔNG + Ô NHẬP HẸN GIỜ TỐI ĐA 90 PHÚT)]
-- ==========================================
do
    local currentSound = nil; local currentMusicId = ""; local savedMusicList = {}; local isMusicPaused = false
    local GlossPalette = {
        RimWhite = Color3.fromRGB(234, 240, 248),
        RimActive = Color3.fromRGB(92, 235, 168),
        OuterBevel = Color3.fromRGB(24, 38, 50),
        InnerTop = Color3.fromRGB(62, 90, 112),
        InnerMid = Color3.fromRGB(48, 71, 89),
        InnerBottom = Color3.fromRGB(34, 52, 68),
        InnerActiveTop = Color3.fromRGB(46, 118, 96),
        InnerActiveMid = Color3.fromRGB(35, 92, 76),
        InnerActiveBottom = Color3.fromRGB(22, 66, 54),
        InnerStroke = Color3.fromRGB(88, 120, 145),
        IconWhite = Color3.fromRGB(244, 248, 252),
        IconShadow = Color3.fromRGB(182, 194, 208),
        Shine = Color3.fromRGB(165, 208, 235)
    }

    local timerActive = false
    local timerEndTime = 0
    local timerInputMinutes = 15

    -- Hàm tạo nút tròn 3D Glossy viền trắng + vệt bóng kính góc trên phải
    local function createGlossyCircleBtn(parent, diameter, posUDim, anchorPt)
        local outer = Instance.new("TextButton", parent)
        outer.Size = UDim2.new(0, diameter, 0, diameter)
        outer.Position = posUDim
        if anchorPt then outer.AnchorPoint = anchorPt end
        outer.BackgroundColor3 = GlossPalette.OuterBevel
        outer.Text = ""
        outer.AutoButtonColor = false
        outer.ZIndex = 11
        Instance.new("UICorner", outer).CornerRadius = UDim.new(1, 0)

        local rimStroke = Instance.new("UIStroke", outer)
        rimStroke.Color = GlossPalette.RimWhite
        rimStroke.Thickness = 1.6
        rimStroke.Transparency = 0.05
        rimStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local pad = math.max(3, math.floor(diameter * 0.11))
        local inner = Instance.new("Frame", outer)
        inner.Name = "InnerFace"
        inner.Size = UDim2.new(1, -pad * 2, 1, -pad * 2)
        inner.Position = UDim2.new(0, pad, 0, pad)
        inner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        inner.BorderSizePixel = 0
        inner.ZIndex = 12
        Instance.new("UICorner", inner).CornerRadius = UDim.new(1, 0)

        local innerGrad = addSoftGradient(inner, GlossPalette.InnerTop, GlossPalette.InnerBottom, 90)
        local innerStroke = Instance.new("UIStroke", inner)
        innerStroke.Color = GlossPalette.InnerStroke
        innerStroke.Thickness = 0.9
        innerStroke.Transparency = 0.35

        -- 2 vệt bóng kính góc trên phải
        local sDot = math.max(2, math.floor(diameter * 0.08))
        local shineDot = Instance.new("Frame", inner)
        shineDot.Size = UDim2.new(0, sDot, 0, sDot)
        shineDot.Position = UDim2.new(0.56, 0, 0.11, 0)
        shineDot.BackgroundColor3 = GlossPalette.Shine
        shineDot.BackgroundTransparency = 0.45
        shineDot.BorderSizePixel = 0
        shineDot.ZIndex = 13
        Instance.new("UICorner", shineDot).CornerRadius = UDim.new(1, 0)

        local shineOval = Instance.new("Frame", inner)
        shineOval.Size = UDim2.new(0, math.max(4, math.floor(diameter * 0.16)), 0, sDot)
        shineOval.Position = UDim2.new(0.66, 0, 0.15, 0)
        shineOval.Rotation = 28
        shineOval.BackgroundColor3 = GlossPalette.Shine
        shineOval.BackgroundTransparency = 0.38
        shineOval.BorderSizePixel = 0
        shineOval.ZIndex = 13
        Instance.new("UICorner", shineOval).CornerRadius = UDim.new(1, 0)

        local iconHolder = Instance.new("Frame", inner)
        iconHolder.Name = "IconHolder"
        iconHolder.Size = UDim2.new(1, 0, 1, 0)
        iconHolder.BackgroundTransparency = 1
        iconHolder.ZIndex = 14

        return outer, iconHolder, rimStroke, innerGrad
    end

    -- Hàm tạo thanh Pill dài 3D Glossy viền trắng
    local function createGlossyPillFrame(parent, sizeUDim, posUDim, order)
        local outer = Instance.new("Frame", parent)
        outer.Size = sizeUDim
        if posUDim then outer.Position = posUDim end
        if order then outer.LayoutOrder = order end
        outer.BackgroundColor3 = GlossPalette.OuterBevel
        outer.BorderSizePixel = 0
        outer.ZIndex = 10
        Instance.new("UICorner", outer).CornerRadius = UDim.new(1, 0)

        local rimStroke = Instance.new("UIStroke", outer)
        rimStroke.Color = GlossPalette.RimWhite
        rimStroke.Thickness = 1.5
        rimStroke.Transparency = 0.08

        local inner = Instance.new("Frame", outer)
        inner.Name = "InnerPill"
        inner.Size = UDim2.new(1, -6, 1, -6)
        inner.Position = UDim2.new(0, 3, 0, 3)
        inner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        inner.BorderSizePixel = 0
        inner.ZIndex = 11
        Instance.new("UICorner", inner).CornerRadius = UDim.new(1, 0)
        local innerGrad = addSoftGradient(inner, GlossPalette.InnerTop, GlossPalette.InnerBottom, 90)

        local innerStroke = Instance.new("UIStroke", inner)
        innerStroke.Color = GlossPalette.InnerStroke
        innerStroke.Thickness = 0.9
        innerStroke.Transparency = 0.38

        return outer, inner, rimStroke, innerGrad
    end

    -- Bộ vẽ biểu tượng 3D Neon Cyan -> Blue -> Purple viền tối sắc nét theo đúng mẫu ảnh 1000085250.png
    local NeonIconColors = {
        CyanTop = Color3.fromRGB(98, 245, 255),
        BlueMid = Color3.fromRGB(65, 138, 255),
        PurpleBot = Color3.fromRGB(205, 72, 255),
        MagentaTop = Color3.fromRGB(228, 115, 255),
        MagentaBot = Color3.fromRGB(168, 45, 235),
        DarkOutline = Color3.fromRGB(12, 16, 36)
    }

    local function applyNeonTriGrad(parent, rot)
        local g = Instance.new("UIGradient", parent)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, NeonIconColors.CyanTop),
            ColorSequenceKeypoint.new(0.52, NeonIconColors.BlueMid),
            ColorSequenceKeypoint.new(1, NeonIconColors.PurpleBot)
        })
        g.Rotation = rot or 90
        return g
    end

    local function drawGlossyIcon(holder, iconType, scale)
        local sc = scale or 1
        local function makeNeonPart(w, h, xOff, yOff, rot, radiusScale, zIdx, customGradMode, withStroke)
            local f = Instance.new("Frame", holder)
            f.Size = UDim2.new(0, w * sc, 0, h * sc)
            f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.Position = UDim2.new(0.5, xOff * sc, 0.5, yOff * sc)
            if rot and rot ~= 0 then f.Rotation = rot end
            f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            f.BorderSizePixel = 0
            f.ZIndex = zIdx or 15
            Instance.new("UICorner", f).CornerRadius = UDim.new(radiusScale or 0.42, 0)
            if customGradMode == "cyan_blue" then
                addSoftGradient(f, NeonIconColors.CyanTop, NeonIconColors.BlueMid, 90)
            elseif customGradMode == "purple_magenta" then
                addSoftGradient(f, NeonIconColors.MagentaTop, NeonIconColors.MagentaBot, 90)
            else
                applyNeonTriGrad(f, 90)
            end
            if withStroke ~= false then
                local st = Instance.new("UIStroke", f)
                st.Color = NeonIconColors.DarkOutline
                st.Thickness = 0.85
                st.Transparency = 0.15
            end
            return f
        end

        local function makeDarkCutout(w, h, xOff, yOff, rot, radiusScale, zIdx)
            local f = Instance.new("Frame", holder)
            f.Size = UDim2.new(0, w * sc, 0, h * sc)
            f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.Position = UDim2.new(0.5, xOff * sc, 0.5, yOff * sc)
            if rot and rot ~= 0 then f.Rotation = rot end
            f.BackgroundColor3 = GlossPalette.OuterBevel
            f.BorderSizePixel = 0
            f.ZIndex = zIdx or 16
            Instance.new("UICorner", f).CornerRadius = UDim.new(radiusScale or 0.3, 0)
            return f
        end

        if iconType == "Play" then
            -- Tam giác Play 3D Cyan -> Blue -> Purple (Hàng 1 Cột 1 của ảnh 1000085250.png)
            makeNeonPart(3.4, 13.2, -3.6, 0, 0, 1, 15, nil, false)
            makeNeonPart(3.4, 10.6, -1.6, 0, 0, 1, 15, nil, false)
            makeNeonPart(3.4, 8.0, 0.4, 0, 0, 1, 15, nil, false)
            makeNeonPart(3.4, 5.4, 2.4, 0, 0, 1, 15, nil, false)
            makeNeonPart(2.8, 3.2, 4.2, 0, 0, 1, 15, nil, false)
            -- Vệt sáng bóng trắng-xanh trên cạnh trái
            local hi = Instance.new("Frame", holder)
            hi.Size = UDim2.new(0, 1.3 * sc, 0, 8.5 * sc); hi.AnchorPoint = Vector2.new(0.5, 0.5)
            hi.Position = UDim2.new(0.5, -4.1 * sc, 0.5, -1.2 * sc); hi.BackgroundColor3 = Color3.fromRGB(220, 252, 255)
            hi.BackgroundTransparency = 0.25; hi.BorderSizePixel = 0; hi.ZIndex = 16
            Instance.new("UICorner", hi).CornerRadius = UDim.new(1, 0)
        elseif iconType == "Pause" then
            -- 2 thanh dọc Pause 3D Cyan -> Blue -> Purple (Hàng 1 Cột 2 của ảnh 1000085250.png)
            local b1 = makeNeonPart(4.4, 13.0, -3.5, 0, 0, 0.35, 15, nil, true)
            local b2 = makeNeonPart(4.4, 13.0, 3.5, 0, 0, 0.35, 15, nil, true)
            for _, bar in ipairs({b1, b2}) do
                local hi = Instance.new("Frame", bar)
                hi.Size = UDim2.new(0.32, 0, 0.65, 0); hi.Position = UDim2.new(0.16, 0, 0.1, 0)
                hi.BackgroundColor3 = Color3.fromRGB(225, 252, 255); hi.BackgroundTransparency = 0.3
                hi.BorderSizePixel = 0; hi.ZIndex = 16
                Instance.new("UICorner", hi).CornerRadius = UDim.new(1, 0)
            end
        elseif iconType == "NextTrack" then
            -- Qua bài tiếp ⏭ (Hàng 1 Cột 3 của ảnh 1000085250.png)
            makeNeonPart(2.8, 11.2, -4.4, 0, 0, 1, 15, nil, false)
            makeNeonPart(2.8, 8.6, -2.6, 0, 0, 1, 15, nil, false)
            makeNeonPart(2.8, 6.0, -0.8, 0, 0, 1, 15, nil, false)
            makeNeonPart(2.6, 3.6, 0.8, 0, 0, 1, 15, nil, false)
            makeNeonPart(3.2, 11.4, 4.0, 0, 0, 0.38, 16, nil, true)
        elseif iconType == "PrevTrack" then
            -- Lùi bài trước ⏮ (Hàng 1 Cột 4 của ảnh 1000085250.png)
            makeNeonPart(3.2, 11.4, -4.0, 0, 0, 0.38, 16, nil, true)
            makeNeonPart(2.6, 3.6, -0.8, 0, 0, 1, 15, nil, false)
            makeNeonPart(2.8, 6.0, 0.8, 0, 0, 1, 15, nil, false)
            makeNeonPart(2.8, 8.6, 2.6, 0, 0, 1, 15, nil, false)
            makeNeonPart(2.8, 11.2, 4.4, 0, 0, 1, 15, nil, false)
        elseif iconType == "Cross" then
            makeNeonPart(13.5, 3.4, 0, 0, 45, 0.5, 15, nil, false)
            makeNeonPart(13.5, 3.4, 0, 0, -45, 0.5, 15, nil, false)
        elseif iconType == "MusicNote" then
            makeNeonPart(6.6, 4.8, -1.8, 3.6, -22, 1, 16, "purple_magenta", false)
            makeNeonPart(2.6, 11.2, 0.8, -1.0, 8, 0.4, 15, nil, false)
            makeNeonPart(6.0, 2.8, 3.1, -4.5, 24, 0.5, 16, "cyan_blue", false)
        elseif iconType == "PlaylistNote" then
            -- Icon Danh sách nhạc ☰♫ (Hàng 3 Cột 2 của ảnh 1000085250.png)
            makeNeonPart(10.5, 2.8, -1.8, -4.2, 0, 0.5, 15, "cyan_blue", true)
            makeNeonPart(10.5, 2.8, -1.8, -0.2, 0, 0.5, 15, "cyan_blue", true)
            makeNeonPart(7.2, 2.8, -3.4, 3.8, 0, 0.5, 15, "purple_magenta", true)
            -- Nốt nhạc đôi góc dưới phải
            makeNeonPart(3.8, 3.0, 2.0, 4.8, -18, 1, 17, "purple_magenta", false)
            makeNeonPart(3.8, 3.0, 6.0, 3.8, -18, 1, 17, "purple_magenta", false)
            makeNeonPart(1.8, 7.2, 3.1, 1.5, 0, 0.35, 16, nil, false)
            makeNeonPart(1.8, 7.2, 7.1, 0.5, 0, 0.35, 16, nil, false)
            makeNeonPart(5.6, 2.2, 5.1, -1.8, -14, 0.4, 17, "cyan_blue", false)
        elseif iconType == "Floppy" then
            makeNeonPart(13.5, 13.5, 0, 0, 0, 0.22, 15, nil, true)
            makeDarkCutout(7.6, 4.8, -0.4, -4.2, 0, 0.25, 16)
            makeNeonPart(2.5, 3.4, 1.3, -4.2, 0, 0.3, 17, "cyan_blue", false)
            makeDarkCutout(10.2, 6.2, 0, 3.6, 0, 0.22, 16)
            local lblPart = Instance.new("Frame", holder)
            lblPart.Size = UDim2.new(0, 8.4 * sc, 0, 5.0 * sc); lblPart.AnchorPoint = Vector2.new(0.5, 0.5)
            lblPart.Position = UDim2.new(0.5, 0, 0.5, 3.8 * sc); lblPart.BackgroundColor3 = Color3.fromRGB(235, 245, 255)
            lblPart.BorderSizePixel = 0; lblPart.ZIndex = 17
            Instance.new("UICorner", lblPart).CornerRadius = UDim.new(0.2, 0)
            makeDarkCutout(5.4, 1.1, 0, 2.9, 0, 0.5, 18)
            makeDarkCutout(5.4, 1.1, 0, 4.6, 0, 0.5, 18)
        elseif iconType == "DoubleLoop" then
            -- Icon Lặp lại 2 mũi tên: Cung trên Xanh Băng -> Xanh Lam, Cung dưới Tím -> Hồng Tím (Hàng 2 Cột 2 của ảnh 1000085250.png)
            local r = 5.4
            for a = -152, -32, 15 do
                local rad = math.rad(a)
                makeNeonPart(3.2, 2.8, math.cos(rad) * r, math.sin(rad) * r, a + 90, 1, 16, "cyan_blue", false)
            end
            makeNeonPart(5.4, 2.6, 4.8, -1.6, -32, 0.45, 17, "cyan_blue", false)
            makeNeonPart(5.4, 2.6, 5.7, -3.1, -112, 0.45, 17, "cyan_blue", false)
            makeNeonPart(3.5, 3.1, 4.9, -2.3, 18, 0.45, 17, "cyan_blue", false)

            for a = 28, 148, 15 do
                local rad = math.rad(a)
                makeNeonPart(3.2, 2.8, math.cos(rad) * r, math.sin(rad) * r, a + 90, 1, 16, "purple_magenta", false)
            end
            makeNeonPart(5.4, 2.6, -4.8, 1.6, -32, 0.45, 17, "purple_magenta", false)
            makeNeonPart(5.4, 2.6, -5.7, 3.1, -112, 0.45, 17, "purple_magenta", false)
            makeNeonPart(3.5, 3.1, -4.9, 2.3, 18, 0.45, 17, "purple_magenta", false)
        elseif iconType == "Stopwatch" then
            makeNeonPart(5.4, 2.1, 0, -7.2, 0, 0.45, 16, "cyan_blue", false)
            makeNeonPart(2.4, 2.2, 0, -5.8, 0, 0.2, 15, "cyan_blue", false)

            local dial = Instance.new("Frame", holder)
            dial.Size = UDim2.new(0, 12.2 * sc, 0, 12.2 * sc)
            dial.AnchorPoint = Vector2.new(0.5, 0.5)
            dial.Position = UDim2.new(0.5, 0, 0.5, 1.3 * sc)
            dial.BackgroundTransparency = 1
            dial.ZIndex = 15
            Instance.new("UICorner", dial).CornerRadius = UDim.new(1, 0)
            local dSt = Instance.new("UIStroke", dial)
            dSt.Color = Color3.fromRGB(255, 255, 255)
            dSt.Thickness = 2.3 * sc
            applyNeonTriGrad(dSt, 90)

            makeNeonPart(2.1, 4.4, -0.5, 0.1, 0, 0.45, 17, "cyan_blue", false)
            makeNeonPart(3.8, 2.1, 0.8, 1.3, 0, 0.45, 17, "purple_magenta", false)
        end
    end

    -- 1. KHUNG TRÊN CÙNG: NÚT NỐT NHẠC + PILL NHẬP ID + NÚT LƯU ĐĨA MỀM + THANH TUA NHẠC
    local musicIdBox, saveIdBtn, nowPlayingLabel, musicTimeLabel, seekFill, seekKnob
    local seekDragInput = nil
    local prevTrackBtn, nextTrackBtn, noteBadge
    local function formatTime(sec)
        sec = math.max(0, math.floor(tonumber(sec) or 0))
        return string.format("%02d:%02d", math.floor(sec / 60), sec % 60)
    end
    do
    local topMusicCard = Instance.new("Frame", page5)
    topMusicCard.Size = UDim2.new(0.94, 0, 0, 68)
    topMusicCard.BackgroundColor3 = Theme.ItemBg
    topMusicCard.LayoutOrder = 1; topMusicCard.ZIndex = 10
    Instance.new("UICorner", topMusicCard).CornerRadius = UDim.new(0, 10)
    local tmStroke = Instance.new("UIStroke", topMusicCard); tmStroke.Color = Theme.Stroke; tmStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = tmStroke})

    local noteHolder; noteBadge, noteHolder = createGlossyCircleBtn(topMusicCard, 28, UDim2.new(0, 6, 0, 4))
    drawGlossyIcon(noteHolder, "MusicNote", 0.85)

    local inputPillOuter, inputPillInner = createGlossyPillFrame(topMusicCard, UDim2.new(1, -76, 0, 28), UDim2.new(0, 38, 0, 4))
    musicIdBox = Instance.new("TextBox", inputPillInner)
    musicIdBox.Size = UDim2.new(1, -20, 1, 0); musicIdBox.Position = UDim2.new(0, 10, 0, 0)
    musicIdBox.BackgroundTransparency = 1; musicIdBox.PlaceholderText = "Nhập hoặc dán ID Nhạc..."
    musicIdBox.PlaceholderColor3 = Color3.fromRGB(168, 184, 204); musicIdBox.Text = ""
    musicIdBox.TextColor3 = GlossPalette.IconWhite
    musicIdBox.Font = Enum.Font.GothamSemibold; musicIdBox.TextSize = 9.5
    musicIdBox.TextXAlignment = Enum.TextXAlignment.Left
    musicIdBox.ClearTextOnFocus = false; musicIdBox.ZIndex = 13

    local saveHolder; saveIdBtn, saveHolder = createGlossyCircleBtn(topMusicCard, 28, UDim2.new(1, -34, 0, 4))
    drawGlossyIcon(saveHolder, "Floppy", 0.86)

    nowPlayingLabel = Instance.new("TextLabel", topMusicCard)
    nowPlayingLabel.Size = UDim2.new(1, -138, 0, 16); nowPlayingLabel.Position = UDim2.new(0, 10, 0, 34)
    nowPlayingLabel.BackgroundTransparency = 1; nowPlayingLabel.RichText = true
    nowPlayingLabel.Text = "<font color='#9AA4B8'>🎵 Chưa có nhạc phát</font>"
    nowPlayingLabel.Font = Enum.Font.GothamSemibold; nowPlayingLabel.TextSize = 9.2
    nowPlayingLabel.TextXAlignment = Enum.TextXAlignment.Left
    nowPlayingLabel.TextTruncate = Enum.TextTruncate.AtEnd; nowPlayingLabel.ZIndex = 11

    -- 2 nút Lùi bài (⏮) & Qua bài (⏭) 3D Cyan->Blue->Purple theo mẫu 1000085250.png
    prevTrackBtn = Instance.new("TextButton", topMusicCard)
    prevTrackBtn.Size = UDim2.new(0, 18, 0, 16); prevTrackBtn.Position = UDim2.new(1, -124, 0, 34)
    prevTrackBtn.BackgroundTransparency = 1; prevTrackBtn.Text = ""; prevTrackBtn.AutoButtonColor = false; prevTrackBtn.ZIndex = 14
    drawGlossyIcon(prevTrackBtn, "PrevTrack", 0.72)

    nextTrackBtn = Instance.new("TextButton", topMusicCard)
    nextTrackBtn.Size = UDim2.new(0, 18, 0, 16); nextTrackBtn.Position = UDim2.new(1, -104, 0, 34)
    nextTrackBtn.BackgroundTransparency = 1; nextTrackBtn.Text = ""; nextTrackBtn.AutoButtonColor = false; nextTrackBtn.ZIndex = 14
    drawGlossyIcon(nextTrackBtn, "NextTrack", 0.72)

    musicTimeLabel = Instance.new("TextLabel", topMusicCard)
    musicTimeLabel.Size = UDim2.new(0, 74, 0, 16); musicTimeLabel.Position = UDim2.new(1, -84, 0, 34)
    musicTimeLabel.BackgroundTransparency = 1; musicTimeLabel.Text = "00:00 / 00:00"
    musicTimeLabel.TextColor3 = getSoftBrandColor(Theme.Brand)
    musicTimeLabel.Font = Enum.Font.GothamSemibold; musicTimeLabel.TextSize = 8.8
    musicTimeLabel.TextXAlignment = Enum.TextXAlignment.Right; musicTimeLabel.ZIndex = 11
    registerBrandUpdater(function(newBrand)
        if musicTimeLabel and musicTimeLabel.Parent then musicTimeLabel.TextColor3 = getSoftBrandColor(newBrand) end
    end)

    local seekContainer = Instance.new("Frame", topMusicCard)
    seekContainer.Size = UDim2.new(1, -20, 0, 14); seekContainer.Position = UDim2.new(0, 10, 0, 51)
    seekContainer.BackgroundTransparency = 1; seekContainer.ZIndex = 11

    local seekTrack = Instance.new("Frame", seekContainer)
    seekTrack.Size = UDim2.new(1, 0, 0, 5); seekTrack.Position = UDim2.new(0, 0, 0.5, -2.5)
    seekTrack.BackgroundColor3 = Color3.fromRGB(16, 22, 30); seekTrack.BorderSizePixel = 0; seekTrack.ZIndex = 11
    Instance.new("UICorner", seekTrack).CornerRadius = UDim.new(1, 0)

    seekFill = Instance.new("Frame", seekTrack)
    seekFill.Size = UDim2.new(0, 0, 1, 0); seekFill.BackgroundColor3 = Theme.Brand; seekFill.BorderSizePixel = 0; seekFill.ZIndex = 12
    Instance.new("UICorner", seekFill).CornerRadius = UDim.new(1, 0)

    seekKnob = Instance.new("Frame", seekTrack)
    seekKnob.Size = UDim2.new(0, 10, 0, 10); seekKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    seekKnob.Position = UDim2.new(0, 0, 0.5, 0); seekKnob.BackgroundColor3 = GlossPalette.IconWhite; seekKnob.ZIndex = 13
    Instance.new("UICorner", seekKnob).CornerRadius = UDim.new(1, 0)
    local seekKnobStroke = Instance.new("UIStroke", seekKnob); seekKnobStroke.Color = Theme.Brand; seekKnobStroke.Thickness = 1.2

    registerBrandUpdater(function(newBrand)
        if seekFill and seekFill.Parent then seekFill.BackgroundColor3 = newBrand end
        if seekKnobStroke and seekKnobStroke.Parent then seekKnobStroke.Color = newBrand end
    end)

    local function scrubMusicToInput(input)
        local pos = math.clamp((input.Position.X - seekTrack.AbsolutePosition.X) / math.max(1, seekTrack.AbsoluteSize.X), 0, 1)
        seekFill.Size = UDim2.new(pos, 0, 1, 0)
        seekKnob.Position = UDim2.new(pos, 0, 0.5, 0)
        if currentSound and currentSound.TimeLength > 0 then
            local targetSec = pos * currentSound.TimeLength
            pcall(function() currentSound.TimePosition = targetSec end)
            musicTimeLabel.Text = formatTime(targetSec) .. " / " .. formatTime(currentSound.TimeLength)
        end
    end

    seekContainer.InputBegan:Connect(function(input)
        if not seekDragInput and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            seekDragInput = input; scrubMusicToInput(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if isDragUpdateInput(input, seekDragInput) then scrubMusicToInput(input) end
    end)
    UIS.InputEnded:Connect(function(input)
        if input == seekDragInput then seekDragInput = nil end
    end)
    end

    local function getCurrentSpeedPreset()
        return MusicSpeedPresets[State.MusicSpeedIdx] or MusicSpeedPresets[2]
    end

    local function getSongName(id)
        local numId = tonumber(id); if not numId then return "ID sai!" end
        local s, info = pcall(function() return MarketplaceService:GetProductInfo(numId) end)
        return (s and info and info.Name) or "Ẩn danh"
    end

    local syncPlayPauseBtnVisual
    local renderSavedMusic
    local saveMusicData

    local function markSongStatusById(soundId, newStatus)
        local changed = false
        for _, item in ipairs(savedMusicList) do
            if tostring(item.id) == tostring(soundId) and item.status ~= newStatus then
                item.status = newStatus
                changed = true
            end
        end
        if changed then
            if saveMusicData then saveMusicData() end
            if renderSavedMusic then renderSavedMusic() end
        end
    end

    local function probeSongStatus(songData)
        if not songData or not songData.id then return end
        songData.status = "checking"
        if renderSavedMusic then renderSavedMusic() end
        task.spawn(function()
            local probe = Instance.new("Sound")
            probe.Name = "MenuVipProbe_" .. tostring(songData.id)
            probe.SoundId = "rbxassetid://" .. tostring(songData.id)
            probe.Volume = 0
            probe.Parent = SoundService
            local elapsed = 0
            while elapsed < 2.8 do
                if probe.IsLoaded and probe.TimeLength > 0 then
                    break
                end
                task.wait(0.2)
                elapsed = elapsed + 0.2
            end
            local isPublic = (probe.IsLoaded and probe.TimeLength > 0)
            pcall(function() probe:Destroy() end)
            songData.status = isPublic and "public" or "private"
            if saveMusicData then saveMusicData() end
            if renderSavedMusic then renderSavedMusic() end
        end)
    end

    local function stopMusic()
        if currentSound then
            currentSound:Stop(); currentSound:Destroy(); currentSound = nil
        end
        currentMusicId = ""; isMusicPaused = false
        nowPlayingLabel.Text = "<font color='#9AA4B8'>⏹ Đã dừng phát nhạc</font>"
        seekFill.Size = UDim2.new(0, 0, 1, 0)
        seekKnob.Position = UDim2.new(0, 0, 0.5, 0)
        musicTimeLabel.Text = "00:00 / 00:00"
        if syncPlayPauseBtnVisual then syncPlayPauseBtnVisual() end
    end

    local function playMusic(id)
        if currentSound then currentSound:Destroy(); currentSound = nil end
        local soundId = tostring(id):match("%d+")
        if not soundId or soundId == "" then
            MakeToast("Chưa có ID Nhạc", "Hãy nhập hoặc chọn 1 bài nhạc để phát!", Theme.AccentOff)
            if syncPlayPauseBtnVisual then syncPlayPauseBtnVisual() end
            return
        end
        currentMusicId = soundId; isMusicPaused = false
        nowPlayingLabel.Text = "<font color='#C2CCDC'>⏳ Đang kiểm tra & tải nhạc...</font>"
        local songTitle = "Ẩn danh"
        task.spawn(function()
            songTitle = getSongName(soundId)
            if currentMusicId == soundId and currentSound then
                local stTag = (currentSound.IsLoaded and currentSound.TimeLength > 0)
                    and "<font color='#58D5FF'>[PUBLIC]</font> "
                    or "<font color='#9AA4B8'>[ĐANG TẢI]</font> "
                nowPlayingLabel.Text = stTag .. "<font color='#D8B868'>" .. songTitle .. "</font>"
            end
        end)
        local soundObj = Instance.new("Sound")
        soundObj.Name = "MenuVipMusic"
        soundObj.SoundId = "rbxassetid://" .. soundId
        soundObj.Volume = State.MusicVolume
        soundObj.PlaybackSpeed = getCurrentSpeedPreset().Speed
        soundObj.Looped = State.MusicLoop
        soundObj.Parent = SoundService
        currentSound = soundObj

        soundObj.Loaded:Connect(function()
            if currentSound == soundObj and currentMusicId == soundId then
                if soundObj.TimeLength > 0 then
                    nowPlayingLabel.Text = "<font color='#58D5FF'>[PUBLIC]</font> <font color='#D8B868'>" .. songTitle .. "</font>"
                    markSongStatusById(soundId, "public")
                end
            end
        end)

        soundObj.Ended:Connect(function()
            if not State.MusicLoop then
                if #savedMusicList > 0 then
                    local cx = 0; for i, v in ipairs(savedMusicList) do if v.id == currentMusicId then cx = i; break end end
                    local nx = cx + 1; if nx > #savedMusicList then nx = 1 end
                    playMusic(savedMusicList[nx].id)
                else
                    stopMusic()
                end
            end
        end)
        soundObj:Play()
        if syncPlayPauseBtnVisual then syncPlayPauseBtnVisual() end

        task.delay(3.5, function()
            if currentSound == soundObj and currentMusicId == soundId then
                if not soundObj.IsLoaded or soundObj.TimeLength <= 0 then
                    stopMusic()
                    markSongStatusById(soundId, "private")
                    nowPlayingLabel.Text = "<font color='#FFB838'>[PRIVATE]</font> <font color='#E05666'>Bị khóa ở game này (" .. songTitle .. ")</font>"
                    MakeToast("⚠️ ID Private / Bị Khóa", "Bài '" .. songTitle .. "' là ID Private (chỉ dùng cho game gốc/Boombox)!", Theme.AccentOff)
                else
                    markSongStatusById(soundId, "public")
                    nowPlayingLabel.Text = "<font color='#58D5FF'>[PUBLIC]</font> <font color='#D8B868'>" .. songTitle .. "</font>"
                end
            end
        end)
    end

    local function stepPlaylistTrack(dir)
        if #savedMusicList == 0 then
            MakeToast("Kho nhạc trống", "Hãy lưu ít nhất 1 bài nhạc vào danh sách!", Theme.AccentOff)
            return
        end
        local curIdx = 0
        for i, v in ipairs(savedMusicList) do
            if tostring(v.id) == tostring(currentMusicId) then curIdx = i; break end
        end
        local nextIdx = curIdx + dir
        if nextIdx > #savedMusicList then nextIdx = 1 end
        if nextIdx < 1 then nextIdx = #savedMusicList end
        local chosen = savedMusicList[nextIdx]
        if chosen then
            musicIdBox.Text = chosen.id
            playMusic(chosen.id)
        end
    end

    prevTrackBtn.MouseButton1Click:Connect(function() clickAnimate(prevTrackBtn); stepPlaylistTrack(-1) end)
    nextTrackBtn.MouseButton1Click:Connect(function() clickAnimate(nextTrackBtn); stepPlaylistTrack(1) end)

    noteBadge.MouseButton1Click:Connect(function()
        clickAnimate(noteBadge)
        local pasted = nil
        pcall(function() if getclipboard then pasted = getclipboard() end end)
        if pasted and tostring(pasted):match("%d+") then
            musicIdBox.Text = tostring(pasted):match("%d+")
            MakeToast("Đã Dán ID", "ID Nhạc: " .. musicIdBox.Text, Theme.Brand)
        else
            musicIdBox:CaptureFocus()
        end
    end)

    -- 2. HÀNG ĐIỀU KHIỂN TRUNG TÂM:
    -- Nút 1: Gộp Phát (▶) / Dừng (||) (Xoá nút vuông Stop)
    -- Nút 2: Lặp lại (🔄)
    -- Nút 3: Tốc độ (0.8x..2x)
    -- Cụm 4: Nút Hẹn giờ (⏱️) + Ô nhập số phút hẹn giờ (Tối đa 90 phút)
    -- Cụm 5: Thanh Pill Âm lượng
    local dockRow = Instance.new("Frame", page5)
    dockRow.Size = UDim2.new(0.94, 0, 0, 44); dockRow.BackgroundTransparency = 1; dockRow.LayoutOrder = 2

    do
    local btnDock = Instance.new("Frame", dockRow)
    btnDock.Size = UDim2.new(0, 108, 1, 0); btnDock.Position = UDim2.new(0, 0, 0, 0)
    btnDock.BackgroundTransparency = 1

    local function makeDockItem(idx, iconName, labelTxt)
        local slot = Instance.new("Frame", btnDock)
        slot.Size = UDim2.new(0, 35, 1, 0)
        slot.Position = UDim2.new(0, (idx - 1) * 36, 0, 0)
        slot.BackgroundTransparency = 1

        local circleBtn, holder, rimSt, inGrad = createGlossyCircleBtn(slot, 30, UDim2.new(0.5, 0, 0, 0), Vector2.new(0.5, 0))
        if iconName then
            drawGlossyIcon(holder, iconName, 0.88)
        end

        local subLbl = Instance.new("TextLabel", slot)
        subLbl.Size = UDim2.new(1, 10, 0, 12); subLbl.Position = UDim2.new(0.5, 0, 0, 31); subLbl.AnchorPoint = Vector2.new(0.5, 0)
        subLbl.BackgroundTransparency = 1; subLbl.Text = labelTxt
        subLbl.TextColor3 = Color3.fromRGB(162, 174, 196); subLbl.Font = Enum.Font.GothamSemibold; subLbl.TextSize = 8; subLbl.ZIndex = 12

        return circleBtn, holder, subLbl, rimSt, inGrad
    end

    -- Nút 1: Gộp Play (▶) & Pause (||) theo đúng ảnh 1000085160.png (đã xoá nút vuông Stop)
    local btnPlayPause, playPauseHolder, lblPlayPause, rimPlayPause, gradPlayPause = makeDockItem(1, nil, "Phát")
    local playIconContainer = Instance.new("Frame", playPauseHolder)
    playIconContainer.Size = UDim2.new(1, 0, 1, 0); playIconContainer.BackgroundTransparency = 1; playIconContainer.ZIndex = 15
    drawGlossyIcon(playIconContainer, "Play", 0.88)

    local pauseIconContainer = Instance.new("Frame", playPauseHolder)
    pauseIconContainer.Size = UDim2.new(1, 0, 1, 0); pauseIconContainer.BackgroundTransparency = 1; pauseIconContainer.Visible = false; pauseIconContainer.ZIndex = 15
    drawGlossyIcon(pauseIconContainer, "Pause", 0.88)

    syncPlayPauseBtnVisual = function()
        local hasSound = (currentSound ~= nil and currentSound.Parent ~= nil)
        local isActivelyPlaying = (hasSound and not isMusicPaused)
        playIconContainer.Visible = not isActivelyPlaying
        pauseIconContainer.Visible = isActivelyPlaying
        lblPlayPause.Text = isActivelyPlaying and "Dừng" or "Phát"
        lblPlayPause.TextColor3 = isActivelyPlaying and GlossPalette.RimActive or Color3.fromRGB(162, 174, 196)
        rimPlayPause.Color = isActivelyPlaying and GlossPalette.RimActive or GlossPalette.RimWhite
    end
    syncPlayPauseBtnVisual()

    -- Nút 2: Lặp lại (chữ dưới cố định "Lặp lại", nút tròn đổi màu xanh/trắng khi bật/tắt)
    local btnLoop, _, lblLoop, rimLoop, gradLoop = makeDockItem(2, "DoubleLoop", "Lặp lại")
    local function syncLoopVisual()
        local on = State.MusicLoop
        lblLoop.TextColor3 = on and GlossPalette.RimActive or Color3.fromRGB(162, 174, 196)
        rimLoop.Color = on and GlossPalette.RimActive or GlossPalette.RimWhite
        gradLoop.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, on and GlossPalette.InnerActiveTop or GlossPalette.InnerTop),
            ColorSequenceKeypoint.new(1, on and GlossPalette.InnerActiveBottom or GlossPalette.InnerBottom)
        })
    end
    syncLoopVisual()

    -- Nút 3: Tốc độ (hiển thị 0.8x..2x bên trong hình tròn, chữ dưới là "Tốc độ")
    local btnSpeed, speedHolder, lblSpeed = makeDockItem(3, nil, "Tốc độ")
    local speedBadgeLbl = Instance.new("TextLabel", speedHolder)
    speedBadgeLbl.Size = UDim2.new(1, 2, 1, 0)
    speedBadgeLbl.Position = UDim2.new(0.5, 0, 0.5, 0)
    speedBadgeLbl.AnchorPoint = Vector2.new(0.5, 0.5)
    speedBadgeLbl.BackgroundTransparency = 1
    speedBadgeLbl.Font = Enum.Font.GothamBlack
    speedBadgeLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBadgeLbl.ZIndex = 16
    addSoftGradient(speedBadgeLbl, GlossPalette.IconWhite, GlossPalette.IconShadow, 90)
    local speedTxtStroke = Instance.new("UIStroke", speedBadgeLbl)
    speedTxtStroke.Color = GlossPalette.OuterBevel
    speedTxtStroke.Thickness = 1.3
    speedTxtStroke.Transparency = 0.1

    local function syncSpeedBadgeVisual()
        local preset = getCurrentSpeedPreset()
        local badgeTxt = preset.Badge or "1x"
        speedBadgeLbl.Text = badgeTxt
        local len = #badgeTxt
        if len <= 2 then
            speedBadgeLbl.TextSize = 10.5
        elseif len <= 4 then
            speedBadgeLbl.TextSize = 8.8
        else
            speedBadgeLbl.TextSize = 7.4
        end
    end
    syncSpeedBadgeVisual()

    -- Cụm 4: Ô nhập thời gian Hẹn giờ (Tối đa 90 phút) kết hợp nút Đồng hồ bấm giờ
    local timerGroup = Instance.new("Frame", dockRow)
    timerGroup.Size = UDim2.new(0, 90, 1, 0); timerGroup.Position = UDim2.new(0, 108, 0, 0)
    timerGroup.BackgroundTransparency = 1

    local timerPillOuter, timerPillInner, timerPillRim, timerPillGrad = createGlossyPillFrame(
        timerGroup, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 0)
    )

    local timerBtn, timerIconHolder, rimTimer, gradTimer = createGlossyCircleBtn(
        timerGroup, 30, UDim2.new(0, 0, 0, 0)
    )
    timerBtn.ZIndex = 14
    drawGlossyIcon(timerIconHolder, "Stopwatch", 0.88)

    local timerInputBox = Instance.new("TextBox", timerPillInner)
    timerInputBox.Size = UDim2.new(1, -30, 1, 0)
    timerInputBox.Position = UDim2.new(0, 26, 0, 0)
    timerInputBox.BackgroundTransparency = 1
    timerInputBox.PlaceholderText = "Phút (≤90)"
    timerInputBox.PlaceholderColor3 = Color3.fromRGB(162, 178, 198)
    timerInputBox.Text = ""
    timerInputBox.TextColor3 = GlossPalette.IconWhite
    timerInputBox.Font = Enum.Font.GothamBold
    timerInputBox.TextSize = 8.8
    timerInputBox.TextXAlignment = Enum.TextXAlignment.Center
    timerInputBox.ClearTextOnFocus = false
    timerInputBox.ZIndex = 13

    local lblTimer = Instance.new("TextLabel", timerGroup)
    lblTimer.Size = UDim2.new(1, 0, 0, 12); lblTimer.Position = UDim2.new(0.5, 0, 0, 31); lblTimer.AnchorPoint = Vector2.new(0.5, 0)
    lblTimer.BackgroundTransparency = 1; lblTimer.Text = "Hẹn giờ (≤90p)"
    lblTimer.TextColor3 = Color3.fromRGB(162, 174, 196); lblTimer.Font = Enum.Font.GothamSemibold; lblTimer.TextSize = 7.8; lblTimer.ZIndex = 12

    local function syncTimerVisual()
        local active = (timerActive and timerEndTime > tick())
        rimTimer.Color = active and GlossPalette.RimActive or GlossPalette.RimWhite
        timerPillRim.Color = active and GlossPalette.RimActive or GlossPalette.RimWhite
        gradTimer.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, active and GlossPalette.InnerActiveTop or GlossPalette.InnerTop),
            ColorSequenceKeypoint.new(1, active and GlossPalette.InnerActiveBottom or GlossPalette.InnerBottom)
        })
        if not active then
            lblTimer.Text = "Hẹn giờ (≤90p)"
            lblTimer.TextColor3 = Color3.fromRGB(162, 174, 196)
        else
            lblTimer.TextColor3 = GlossPalette.RimActive
        end
    end
    syncTimerVisual()

    local function startOrUpdateTimerFromInput(rawText)
        local num = tonumber(tostring(rawText):match("%d+"))
        if not num or num <= 0 then
            timerActive = false
            timerEndTime = 0
            timerInputBox.Text = ""
            syncTimerVisual()
            MakeToast("⏰ Hẹn Giờ Tắt Nhạc", "Đã tắt hẹn giờ nhạc", Theme.AccentOff)
            return
        end
        if num > 90 then
            num = 90
            MakeToast("⏰ Giới hạn 90 phút", "Đã tự động đặt mức tối đa là 90 phút!", Theme.Brand)
        else
            MakeToast("⏰ Đã Bật Hẹn Giờ", "Sẽ tự động tắt nhạc sau " .. tostring(num) .. " phút!", Theme.AccentOn)
        end
        timerInputMinutes = num
        timerInputBox.Text = tostring(num) .. "p"
        timerActive = true
        timerEndTime = tick() + (num * 60)
        lblTimer.Text = formatTime(num * 60)
        syncTimerVisual()
    end

    timerInputBox.FocusLost:Connect(function()
        if timerInputBox.Text ~= "" then
            startOrUpdateTimerFromInput(timerInputBox.Text)
        elseif timerActive then
            timerActive = false
            timerEndTime = 0
            syncTimerVisual()
            MakeToast("⏰ Hẹn Giờ Tắt Nhạc", "Đã hủy hẹn giờ nhạc", Theme.AccentOff)
        end
    end)

    timerBtn.MouseButton1Click:Connect(function()
        clickAnimate(timerBtn)
        if timerActive then
            timerActive = false
            timerEndTime = 0
            timerInputBox.Text = ""
            syncTimerVisual()
            MakeToast("⏰ Hẹn Giờ Tắt Nhạc", "Đã tắt hẹn giờ nhạc", Theme.AccentOff)
        else
            local typed = tostring(timerInputBox.Text):match("%d+")
            if typed and tonumber(typed) and tonumber(typed) > 0 then
                startOrUpdateTimerFromInput(typed)
            else
                timerInputBox:CaptureFocus()
                MakeToast("⏰ Nhập Số Phút", "Hãy nhập số phút hẹn giờ (1 - 90 phút) vào ô bên cạnh!", Theme.Brand)
            end
        end
    end)

    btnPlayPause.MouseButton1Click:Connect(function()
        clickAnimate(btnPlayPause)
        local typedId = tostring(musicIdBox.Text):match("%d+")
        if currentSound and currentSound.Parent then
            if typedId and typedId ~= "" and typedId ~= currentMusicId then
                playMusic(typedId)
            elseif isMusicPaused then
                currentSound:Resume(); isMusicPaused = false
                syncPlayPauseBtnVisual()
                MakeToast("Tiếp tục phát", "Đã tiếp tục bài nhạc", Theme.AccentOn)
            else
                currentSound:Pause(); isMusicPaused = true
                syncPlayPauseBtnVisual()
                MakeToast("Tạm dừng", "Đã tạm dừng bài nhạc", Theme.Brand)
            end
        else
            playMusic(musicIdBox.Text)
        end
    end)

    btnLoop.MouseButton1Click:Connect(function()
        clickAnimate(btnLoop)
        State.MusicLoop = not State.MusicLoop
        if currentSound then currentSound.Looped = State.MusicLoop end
        syncLoopVisual()
        if State.AutoSave then saveConfig() end
    end)

    btnSpeed.MouseButton1Click:Connect(function()
        clickAnimate(btnSpeed)
        State.MusicSpeedIdx = (State.MusicSpeedIdx % #MusicSpeedPresets) + 1
        local preset = getCurrentSpeedPreset()
        syncSpeedBadgeVisual()
        if currentSound then currentSound.PlaybackSpeed = preset.Speed end
        MakeToast("Tốc Độ Nhạc", "Chế độ: " .. preset.Name, Theme.Brand)
        if State.AutoSave then saveConfig() end
    end)

    -- Vòng lặp cập nhật thanh thời gian bài hát & đếm ngược Hẹn giờ tắt nhạc
    task.spawn(function()
        while task.wait(0.25) do
            if timerActive and timerEndTime > 0 then
                local remain = timerEndTime - tick()
                if remain <= 0 then
                    timerActive = false
                    timerEndTime = 0
                    timerInputBox.Text = ""
                    stopMusic()
                    syncTimerVisual()
                    MakeToast("⏰ Hết Giờ Hẹn", "Đã tự động tắt nhạc theo thời gian hẹn!", Theme.Brand)
                else
                    lblTimer.Text = formatTime(remain)
                end
            end

            if page5.Visible and not seekDragInput then
                if currentSound and currentSound.Parent and currentSound.TimeLength > 0 then
                    local cur = currentSound.TimePosition
                    local len = currentSound.TimeLength
                    local ratio = math.clamp(cur / len, 0, 1)
                    seekFill.Size = UDim2.new(ratio, 0, 1, 0)
                    seekKnob.Position = UDim2.new(ratio, 0, 0.5, 0)
                    musicTimeLabel.Text = formatTime(cur) .. " / " .. formatTime(len)
                else
                    seekFill.Size = UDim2.new(0, 0, 1, 0)
                    seekKnob.Position = UDim2.new(0, 0, 0.5, 0)
                    musicTimeLabel.Text = "00:00 / 00:00"
                end
            end
        end
    end)

    end

    -- Cụm 5: Thanh Pill 3D chỉnh Âm lượng tích hợp Biểu tượng Loa 3D động (🔊 / 🔉 / 🔇 theo mẫu 1000085250.png)
    do
    local volGroup = Instance.new("Frame", dockRow)
    volGroup.Size = UDim2.new(1, -202, 1, 0); volGroup.Position = UDim2.new(0, 202, 0, 0)
    volGroup.BackgroundTransparency = 1

    local volPillOuter, volPillInner = createGlossyPillFrame(volGroup, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 0))
    local volTitle = Instance.new("TextLabel", volGroup)
    volTitle.Size = UDim2.new(1, 0, 0, 12); volTitle.Position = UDim2.new(0.5, 0, 0, 31); volTitle.AnchorPoint = Vector2.new(0.5, 0)
    volTitle.BackgroundTransparency = 1; volTitle.Text = "Âm lượng: " .. tostring(State.MusicVolume)
    volTitle.TextColor3 = Color3.fromRGB(162, 174, 196); volTitle.Font = Enum.Font.GothamSemibold; volTitle.TextSize = 7.8
    volTitle.TextXAlignment = Enum.TextXAlignment.Center; volTitle.ZIndex = 12

    -- Nút Loa 3D Cyan->Blue->Purple bên trái thanh trượt (bấm để tắt/bật tiếng nhanh)
    local speakerBtn = Instance.new("TextButton", volPillInner)
    speakerBtn.Size = UDim2.new(0, 22, 0, 22); speakerBtn.Position = UDim2.new(0, 4, 0.5, -11)
    speakerBtn.BackgroundTransparency = 1; speakerBtn.Text = ""; speakerBtn.AutoButtonColor = false; speakerBtn.ZIndex = 15

    local spkRear = Instance.new("Frame", speakerBtn)
    spkRear.Size = UDim2.new(0, 4.5, 0, 7.5); spkRear.Position = UDim2.new(0, 2, 0.5, -3.75)
    spkRear.BackgroundColor3 = Color3.fromRGB(255, 255, 255); spkRear.BorderSizePixel = 0; spkRear.ZIndex = 15
    Instance.new("UICorner", spkRear).CornerRadius = UDim.new(0.35, 0)
    applyNeonTriGrad(spkRear, 90)

    local spkCone = Instance.new("Frame", speakerBtn)
    spkCone.Size = UDim2.new(0, 6.5, 0, 12.5); spkCone.Position = UDim2.new(0, 5.5, 0.5, -6.25)
    spkCone.BackgroundColor3 = Color3.fromRGB(255, 255, 255); spkCone.BorderSizePixel = 0; spkCone.ZIndex = 15
    Instance.new("UICorner", spkCone).CornerRadius = UDim.new(0.35, 0)
    applyNeonTriGrad(spkCone, 90)

    local wave1 = Instance.new("Frame", speakerBtn)
    wave1.Size = UDim2.new(0, 2.2, 0, 6.8); wave1.Position = UDim2.new(0, 13.5, 0.5, -3.4)
    wave1.BackgroundColor3 = Color3.fromRGB(255, 255, 255); wave1.BorderSizePixel = 0; wave1.ZIndex = 15
    Instance.new("UICorner", wave1).CornerRadius = UDim.new(1, 0)
    applyNeonTriGrad(wave1, 90)

    local wave2 = Instance.new("Frame", speakerBtn)
    wave2.Size = UDim2.new(0, 2.2, 0, 11.2); wave2.Position = UDim2.new(0, 17, 0.5, -5.6)
    wave2.BackgroundColor3 = Color3.fromRGB(255, 255, 255); wave2.BorderSizePixel = 0; wave2.ZIndex = 15
    Instance.new("UICorner", wave2).CornerRadius = UDim.new(1, 0)
    applyNeonTriGrad(wave2, 90)

    local muteX1 = Instance.new("Frame", speakerBtn)
    muteX1.Size = UDim2.new(0, 7.5, 0, 2.2); muteX1.AnchorPoint = Vector2.new(0.5, 0.5)
    muteX1.Position = UDim2.new(0, 16.5, 0.5, 0); muteX1.Rotation = 45
    muteX1.BackgroundColor3 = Color3.fromRGB(255, 255, 255); muteX1.BorderSizePixel = 0; muteX1.Visible = false; muteX1.ZIndex = 16
    Instance.new("UICorner", muteX1).CornerRadius = UDim.new(1, 0)
    applyNeonTriGrad(muteX1, 90)

    local muteX2 = Instance.new("Frame", speakerBtn)
    muteX2.Size = UDim2.new(0, 7.5, 0, 2.2); muteX2.AnchorPoint = Vector2.new(0.5, 0.5)
    muteX2.Position = UDim2.new(0, 16.5, 0.5, 0); muteX2.Rotation = -45
    muteX2.BackgroundColor3 = Color3.fromRGB(255, 255, 255); muteX2.BorderSizePixel = 0; muteX2.Visible = false; muteX2.ZIndex = 16
    Instance.new("UICorner", muteX2).CornerRadius = UDim.new(1, 0)
    applyNeonTriGrad(muteX2, 90)

    local function syncSpeakerIcon(val)
        if val <= 0 then
            wave1.Visible = false; wave2.Visible = false
            muteX1.Visible = true; muteX2.Visible = true
        elseif val <= 5 then
            wave1.Visible = true; wave2.Visible = false
            muteX1.Visible = false; muteX2.Visible = false
        else
            wave1.Visible = true; wave2.Visible = true
            muteX1.Visible = false; muteX2.Visible = false
        end
    end
    syncSpeakerIcon(State.MusicVolume)

    local volTrack = Instance.new("Frame", volPillInner)
    volTrack.Size = UDim2.new(1, -36, 0, 5); volTrack.Position = UDim2.new(0, 27, 0.5, -2.5)
    volTrack.BackgroundColor3 = Color3.fromRGB(16, 22, 32); volTrack.BorderSizePixel = 0; volTrack.ZIndex = 13
    Instance.new("UICorner", volTrack).CornerRadius = UDim.new(1, 0)

    local initVolPos = math.clamp(State.MusicVolume / 10, 0, 1)
    local volFill = Instance.new("Frame", volTrack)
    volFill.Size = UDim2.new(initVolPos, 0, 1, 0); volFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255); volFill.BorderSizePixel = 0; volFill.ZIndex = 14
    Instance.new("UICorner", volFill).CornerRadius = UDim.new(1, 0)
    applyNeonTriGrad(volFill, 0)

    local volKnob = Instance.new("Frame", volTrack)
    volKnob.Size = UDim2.new(0, 10, 0, 10); volKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    volKnob.Position = UDim2.new(initVolPos, 0, 0.5, 0); volKnob.BackgroundColor3 = GlossPalette.IconWhite; volKnob.ZIndex = 15
    Instance.new("UICorner", volKnob).CornerRadius = UDim.new(1, 0)

    local savedUnmuteVol = State.MusicVolume > 0 and State.MusicVolume or 5
    local function applyVolValue(value)
        if value > 0 then savedUnmuteVol = value end
        local pos = math.clamp(value / 10, 0, 1)
        volTitle.Text = "Âm lượng: " .. tostring(value)
        syncSpeakerIcon(value)
        TweenService:Create(volFill, TweenInfo.new(0.08), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        TweenService:Create(volKnob, TweenInfo.new(0.08), {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
        State.MusicVolume = value
        if currentSound then currentSound.Volume = value end
        if State.AutoSave then saveConfig() end
    end

    speakerBtn.MouseButton1Click:Connect(function()
        clickAnimate(speakerBtn)
        if State.MusicVolume > 0 then
            applyVolValue(0)
        else
            applyVolValue(savedUnmuteVol)
        end
    end)

    local volDragInput = nil
    local function updateVolSlider(input)
        local pos = math.clamp((input.Position.X - volTrack.AbsolutePosition.X) / math.max(1, volTrack.AbsoluteSize.X), 0, 1)
        local value = math.floor(10 * pos + 0.5)
        applyVolValue(value)
    end
    volPillOuter.InputBegan:Connect(function(input)
        if not volDragInput and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            if input.Position.X >= volTrack.AbsolutePosition.X - 6 then
                volDragInput = input; updateVolSlider(input)
            end
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if isDragUpdateInput(input, volDragInput) then updateVolSlider(input) end
    end)
    UIS.InputEnded:Connect(function(input)
        if input == volDragInput then volDragInput = nil end
    end)
    end

    -- 3. KHUNG DANH SÁCH NHẠC ĐÃ LƯU (LOGO 3D PUBLIC XANH BĂNG & PRIVATE LỬA VÀNG THEO MẪU 1000085248.png)
    do
    local currentMusicFilter = "all" -- "all" | "public" | "private"

    -- Hàm dựng Logo 3D PUBLIC (Năng lượng Xanh Băng - Tím) và PRIVATE (Hào quang Lửa Đỏ - Chữ Vàng Cam)
    local function createStatusLogoEmblem(parent, statusType, posUDim, sizeUDim)
        local btn = Instance.new("TextButton", parent)
        btn.Size = sizeUDim or UDim2.new(0, 58, 0, 20)
        btn.Position = posUDim or UDim2.new(1, -112, 0.5, -10)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 14

        -- Quầng xoáy năng lượng / lửa phía sau (2 vòng elip nghiêng ngược chiều)
        local aura1 = Instance.new("Frame", btn)
        aura1.Size = UDim2.new(1, 0, 0.78, 0)
        aura1.AnchorPoint = Vector2.new(0.5, 0.5)
        aura1.Position = UDim2.new(0.5, 0, 0.5, 0)
        aura1.Rotation = -11
        aura1.BackgroundTransparency = 1
        aura1.ZIndex = 14
        Instance.new("UICorner", aura1).CornerRadius = UDim.new(1, 0)
        local aura1Stroke = Instance.new("UIStroke", aura1)
        aura1Stroke.Thickness = 1.4
        local aura1Grad = Instance.new("UIGradient", aura1Stroke)

        local aura2 = Instance.new("Frame", btn)
        aura2.Size = UDim2.new(0.92, 0, 0.68, 0)
        aura2.AnchorPoint = Vector2.new(0.5, 0.5)
        aura2.Position = UDim2.new(0.5, 0, 0.5, 0)
        aura2.Rotation = 10
        aura2.BackgroundTransparency = 1
        aura2.ZIndex = 14
        Instance.new("UICorner", aura2).CornerRadius = UDim.new(1, 0)
        local aura2Stroke = Instance.new("UIStroke", aura2)
        aura2Stroke.Thickness = 1.1

        -- Nền khiên tối sâu giúp chữ 3D nổi bật sắc nét
        local coreShield = Instance.new("Frame", btn)
        coreShield.Size = UDim2.new(0.94, 0, 0.76, 0)
        coreShield.AnchorPoint = Vector2.new(0.5, 0.5)
        coreShield.Position = UDim2.new(0.5, 0, 0.5, 0)
        coreShield.Rotation = -3
        coreShield.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        coreShield.BorderSizePixel = 0
        coreShield.ZIndex = 15
        Instance.new("UICorner", coreShield).CornerRadius = UDim.new(0.45, 0)
        local shieldGrad = Instance.new("UIGradient", coreShield)
        shieldGrad.Rotation = 90
        local shieldStroke = Instance.new("UIStroke", coreShield)
        shieldStroke.Thickness = 1.0

        -- Lớp bóng đổ khối 3D (Extrusion Shadow) phía dưới chữ
        local shadowTxt = Instance.new("TextLabel", btn)
        shadowTxt.Size = UDim2.new(1, 4, 1, 0)
        shadowTxt.AnchorPoint = Vector2.new(0.5, 0.5)
        shadowTxt.Position = UDim2.new(0.5, 1, 0.5, 1.5)
        shadowTxt.Rotation = -4
        shadowTxt.BackgroundTransparency = 1
        shadowTxt.Font = Enum.Font.GothamBlack
        shadowTxt.ZIndex = 16

        -- Lớp chữ 3D ánh kim chính ở trên
        local mainTxt = Instance.new("TextLabel", btn)
        mainTxt.Size = UDim2.new(1, 4, 1, 0)
        mainTxt.AnchorPoint = Vector2.new(0.5, 0.5)
        mainTxt.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainTxt.Rotation = -4
        mainTxt.BackgroundTransparency = 1
        mainTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
        mainTxt.Font = Enum.Font.GothamBlack
        mainTxt.ZIndex = 17
        local txtGrad = Instance.new("UIGradient", mainTxt)
        txtGrad.Rotation = 90
        local txtStroke = Instance.new("UIStroke", mainTxt)
        txtStroke.Thickness = 1.15

        if statusType == "public" then
            -- Logo PUBLIC: Hào quang Xanh Băng - Tím + Chữ 3D Trắng Băng -> Xanh Lam (giống bên phải ảnh 1000085248.png)
            aura1Grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 235, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 115, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 55, 255))
            })
            aura2Stroke.Color = Color3.fromRGB(65, 215, 255)
            shieldGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 38, 88)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 14, 38))
            })
            shieldStroke.Color = Color3.fromRGB(65, 210, 255)
            shadowTxt.Text = "PUBLIC"
            shadowTxt.TextSize = 8.4
            shadowTxt.TextColor3 = Color3.fromRGB(6, 12, 34)
            mainTxt.Text = "PUBLIC"
            mainTxt.TextSize = 8.4
            txtStroke.Color = Color3.fromRGB(10, 24, 62)
            txtGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(248, 254, 255)),
                ColorSequenceKeypoint.new(0.52, Color3.fromRGB(95, 218, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(42, 118, 255))
            })
        elseif statusType == "private" then
            -- Logo PRIVATE: Hào quang Lửa Đỏ Cam + Chữ 3D Vàng Kim -> Cam Đỏ (giống bên trái ảnh 1000085248.png)
            aura1Grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 65)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 95, 18)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 18, 15))
            })
            aura2Stroke.Color = Color3.fromRGB(255, 135, 25)
            shieldGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 16, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 6, 6))
            })
            shieldStroke.Color = Color3.fromRGB(255, 145, 30)
            shadowTxt.Text = "PRIVATE"
            shadowTxt.TextSize = 7.8
            shadowTxt.TextColor3 = Color3.fromRGB(28, 4, 4)
            mainTxt.Text = "PRIVATE"
            mainTxt.TextSize = 7.8
            txtStroke.Color = Color3.fromRGB(48, 10, 6)
            txtGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 125)),
                ColorSequenceKeypoint.new(0.52, Color3.fromRGB(255, 182, 28)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 68, 14))
            })
        else
            aura1Grad.Color = ColorSequence.new(Color3.fromRGB(185, 155, 75))
            aura2Stroke.Color = Color3.fromRGB(145, 120, 60)
            shieldGrad.Color = ColorSequence.new(Color3.fromRGB(34, 30, 20))
            shieldStroke.Color = Color3.fromRGB(175, 145, 65)
            shadowTxt.Text = "ĐO..."
            shadowTxt.TextSize = 7.8
            shadowTxt.TextColor3 = Color3.fromRGB(15, 12, 8)
            mainTxt.Text = "ĐO..."
            mainTxt.TextSize = 7.8
            txtStroke.Color = Color3.fromRGB(25, 20, 12)
            txtGrad.Color = ColorSequence.new(Color3.fromRGB(240, 205, 110))
        end

        return btn
    end

    local musicListCard = Instance.new("Frame", page5)
    musicListCard.Size = UDim2.new(0.94, 0, 1, -128); musicListCard.BackgroundColor3 = Color3.fromRGB(20, 22, 31); musicListCard.LayoutOrder = 3; musicListCard.ZIndex = 10
    Instance.new("UICorner", musicListCard).CornerRadius = UDim.new(0, 8)
    local mlStroke = Instance.new("UIStroke", musicListCard); mlStroke.Color = Theme.Stroke; mlStroke.Thickness = 1; table.insert(RGBElements, {Type = "Info", Stroke = mlStroke})

    local playlistIconBox = Instance.new("Frame", musicListCard)
    playlistIconBox.Size = UDim2.new(0, 18, 0, 18); playlistIconBox.Position = UDim2.new(0, 8, 0, 5)
    playlistIconBox.BackgroundTransparency = 1; playlistIconBox.ZIndex = 12
    drawGlossyIcon(playlistIconBox, "PlaylistNote", 0.92)

    local mlHeader = Instance.new("TextLabel", musicListCard)
    mlHeader.Size = UDim2.new(0.35, 0, 0, 20); mlHeader.Position = UDim2.new(0, 30, 0, 4); mlHeader.BackgroundTransparency = 1
    mlHeader.Text = "KHO NHẠC (0)"; mlHeader.TextColor3 = Color3.fromRGB(178, 190, 210); mlHeader.Font = Enum.Font.GothamSemibold; mlHeader.TextSize = 8.6
    mlHeader.TextXAlignment = Enum.TextXAlignment.Left; mlHeader.TextTruncate = Enum.TextTruncate.AtEnd; mlHeader.ZIndex = 11

    -- 3 nút lọc: Tất cả | Public | Private (Đã làm dịu chữ & nền tối sâu chống chói lóa)
    local filterBar = Instance.new("Frame", musicListCard)
    filterBar.Size = UDim2.new(0, 184, 0, 19); filterBar.Position = UDim2.new(1, -188, 0, 4)
    filterBar.BackgroundTransparency = 1; filterBar.ZIndex = 11

    local function makeMusicFilterBtn(xPos, width, txt)
        local b = Instance.new("TextButton", filterBar)
        b.Size = UDim2.new(0, width, 1, 0); b.Position = UDim2.new(0, xPos, 0, 0)
        b.BackgroundColor3 = Color3.fromRGB(14, 16, 23); b.Text = txt
        b.TextColor3 = Color3.fromRGB(132, 142, 162); b.Font = Enum.Font.GothamMedium; b.TextSize = 8
        b.TextStrokeColor3 = Color3.fromRGB(8, 10, 16); b.TextStrokeTransparency = 0.45
        b.AutoButtonColor = false; b.ZIndex = 12
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", b); st.Color = Color3.fromRGB(42, 48, 66); st.Thickness = 0.8; st.Transparency = 0.45
        return b, st
    end

    local fBtnAll, fStAll = makeMusicFilterBtn(0, 56, "Tất cả")
    local fBtnPub, fStPub = makeMusicFilterBtn(60, 60, "Public")
    local fBtnPriv, fStPriv = makeMusicFilterBtn(124, 60, "Private")

    local function syncMusicFilterTabs()
        local pubCount, privCount = 0, 0
        for _, item in ipairs(savedMusicList) do
            if item.status == "public" then pubCount = pubCount + 1
            elseif item.status == "private" then privCount = privCount + 1 end
        end
        fBtnAll.Text = "Tất cả (" .. #savedMusicList .. ")"
        fBtnPub.Text = "Public (" .. pubCount .. ")"
        fBtnPriv.Text = "Private (" .. privCount .. ")"

        local tabs = {
            {
                btn = fBtnAll, st = fStAll, key = "all",
                col = Color3.fromRGB(198, 208, 224),
                bg = Color3.fromRGB(22, 26, 38),
                border = Color3.fromRGB(88, 102, 132)
            },
            {
                btn = fBtnPub, st = fStPub, key = "public",
                col = Color3.fromRGB(125, 198, 240),
                bg = Color3.fromRGB(16, 28, 44),
                border = Color3.fromRGB(58, 138, 195)
            },
            {
                btn = fBtnPriv, st = fStPriv, key = "private",
                col = Color3.fromRGB(228, 178, 95),
                bg = Color3.fromRGB(34, 22, 18),
                border = Color3.fromRGB(175, 105, 42)
            }
        }
        for _, t in ipairs(tabs) do
            local isSel = (currentMusicFilter == t.key)
            t.btn.BackgroundColor3 = isSel and t.bg or Color3.fromRGB(14, 16, 23)
            t.btn.TextColor3 = isSel and t.col or Color3.fromRGB(124, 134, 154)
            t.st.Color = isSel and t.border or Color3.fromRGB(40, 46, 62)
            t.st.Transparency = isSel and 0.25 or 0.55
        end
    end

    local emptyMusicState = Instance.new("TextLabel", musicListCard)
    emptyMusicState.Size = UDim2.new(1, -24, 1, -28); emptyMusicState.Position = UDim2.new(0, 12, 0, 24)
    emptyMusicState.BackgroundTransparency = 1; emptyMusicState.RichText = true
    emptyMusicState.Text = "🎶 Chưa có bài nhạc nào được lưu.\n<font color='#7E889E'>Nhập ID Nhạc ở trên rồi bấm nút Lưu đĩa mềm bên phải để thêm!</font>"
    emptyMusicState.TextColor3 = Theme.TextDim; emptyMusicState.Font = Enum.Font.GothamSemibold; emptyMusicState.TextSize = 9.2
    emptyMusicState.LineHeight = 1.25; emptyMusicState.TextWrapped = true
    emptyMusicState.TextXAlignment = Enum.TextXAlignment.Center; emptyMusicState.TextYAlignment = Enum.TextYAlignment.Center; emptyMusicState.ZIndex = 11

    local savedMusicContent = Instance.new("ScrollingFrame", musicListCard)
    savedMusicContent.Size = UDim2.new(1, -10, 1, -28); savedMusicContent.Position = UDim2.new(0, 5, 0, 26)
    savedMusicContent.BackgroundTransparency = 1; savedMusicContent.ScrollBarThickness = 3; savedMusicContent.ScrollBarImageColor3 = Theme.Brand; savedMusicContent.BorderSizePixel = 0; savedMusicContent.ZIndex = 10
    local sLayout = Instance.new("UIListLayout", savedMusicContent); sLayout.SortOrder = Enum.SortOrder.LayoutOrder; sLayout.Padding = UDim.new(0, 5)
    local sPad = Instance.new("UIPadding", savedMusicContent); sPad.PaddingTop = UDim.new(0, 2); sPad.PaddingBottom = UDim.new(0, 6); sPad.PaddingLeft = UDim.new(0, 2); sPad.PaddingRight = UDim.new(0, 4)
    sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedMusicContent.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 10) end)

    registerBrandUpdater(function(newBrand)
        if savedMusicContent and savedMusicContent.Parent then savedMusicContent.ScrollBarImageColor3 = newBrand end
        syncMusicFilterTabs()
    end)

    local fileName = "MenuVipProMax_SavedMusic.json"
    pcall(function() if isfile and isfile(fileName) then local decoded = HttpService:JSONDecode(readfile(fileName)); if type(decoded) == "table" then savedMusicList = decoded end end end)
    saveMusicData = function() pcall(function() if writefile then writefile(fileName, HttpService:JSONEncode(savedMusicList)) end end) end

    renderSavedMusic = function()
        for _, child in pairs(savedMusicContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        cleanRGBElements()
        mlHeader.Text = "KHO NHẠC (" .. #savedMusicList .. ")"
        syncMusicFilterTabs()

        local visibleCount = 0
        for i, data in ipairs(savedMusicList) do
            local st = data.status or "checking"
            local matchFilter = (currentMusicFilter == "all")
                or (currentMusicFilter == "public" and st == "public")
                or (currentMusicFilter == "private" and st == "private")

            if matchFilter then
                visibleCount = visibleCount + 1
                local rowOuter, rowInner = createGlossyPillFrame(savedMusicContent, UDim2.new(1, -2, 0, 32), nil, i)

                local songIconBtn, songIconHolder = createGlossyCircleBtn(rowInner, 22, UDim2.new(0, 3, 0.5, 0), Vector2.new(0, 0.5))
                drawGlossyIcon(songIconHolder, "MusicNote", 0.68)

                local nameBox = Instance.new("TextBox", rowInner)
                nameBox.Size = UDim2.new(1, -146, 1, 0); nameBox.Position = UDim2.new(0, 29, 0, 0)
                nameBox.Text = data.name; nameBox.TextColor3 = GlossPalette.IconWhite
                nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 9.2
                nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left
                nameBox.TextTruncate = Enum.TextTruncate.AtEnd
                nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 13
                nameBox.FocusLost:Connect(function()
                    if nameBox.Text ~= "" then data.name = nameBox.Text; saveMusicData() else nameBox.Text = data.name end
                end)

                -- Logo 3D PUBLIC (Xanh Băng) / PRIVATE (Lửa Vàng) theo đúng mẫu 1000085248.png
                local statusBadge = createStatusLogoEmblem(
                    rowInner,
                    st,
                    UDim2.new(1, -112, 0.5, -10),
                    UDim2.new(0, 58, 0, 20)
                )

                statusBadge.MouseButton1Click:Connect(function()
                    clickAnimate(statusBadge)
                    if data.status == "public" then
                        data.status = "private"
                        MakeToast("Phân loại ID", "Đã chuyển '" .. data.name .. "' sang PRIVATE", Theme.AccentOff)
                    else
                        data.status = "public"
                        MakeToast("Phân loại ID", "Đã chuyển '" .. data.name .. "' sang PUBLIC", Theme.AccentOn)
                    end
                    saveMusicData()
                    renderSavedMusic()
                end)

                local playItemBtn, playItemHolder = createGlossyCircleBtn(rowInner, 22, UDim2.new(1, -50, 0.5, 0), Vector2.new(0, 0.5))
                drawGlossyIcon(playItemHolder, "Play", 0.68)

                local delItemBtn, delItemHolder = createGlossyCircleBtn(rowInner, 22, UDim2.new(1, -25, 0.5, 0), Vector2.new(0, 0.5))
                drawGlossyIcon(delItemHolder, "Cross", 0.68)

                songIconBtn.MouseButton1Click:Connect(function() clickAnimate(songIconBtn); musicIdBox.Text = data.id; playMusic(data.id) end)
                playItemBtn.MouseButton1Click:Connect(function() clickAnimate(playItemBtn); musicIdBox.Text = data.id; playMusic(data.id) end)
                delItemBtn.MouseButton1Click:Connect(function() clickAnimate(delItemBtn); table.remove(savedMusicList, i); saveMusicData(); renderSavedMusic() end)
            end
        end

        if #savedMusicList == 0 then
            emptyMusicState.Text = "🎶 Chưa có bài nhạc nào được lưu.\n<font color='#7E889E'>Nhập ID Nhạc ở trên rồi bấm nút Lưu đĩa mềm bên phải để thêm!</font>"
            emptyMusicState.Visible = true
        elseif visibleCount == 0 then
            local filterName = currentMusicFilter == "public" and "PUBLIC" or "PRIVATE"
            emptyMusicState.Text = "🔎 Không có bài nhạc nào thuộc nhóm <font color='#F0C868'>" .. filterName .. "</font>.\n<font color='#7E889E'>Bấm sang mục 'Tất cả' để xem toàn bộ danh sách!</font>"
            emptyMusicState.Visible = true
        else
            emptyMusicState.Visible = false
        end
    end

    fBtnAll.MouseButton1Click:Connect(function() clickAnimate(fBtnAll); currentMusicFilter = "all"; renderSavedMusic() end)
    fBtnPub.MouseButton1Click:Connect(function() clickAnimate(fBtnPub); currentMusicFilter = "public"; renderSavedMusic() end)
    fBtnPriv.MouseButton1Click:Connect(function() clickAnimate(fBtnPriv); currentMusicFilter = "private"; renderSavedMusic() end)

    saveIdBtn.MouseButton1Click:Connect(function()
        clickAnimate(saveIdBtn)
        local rawId = musicIdBox.Text:match("%d+")
        if rawId and rawId ~= "" then
            task.spawn(function()
                local name = getSongName(rawId)
                local newSong = {id = rawId, name = name, status = "checking"}
                table.insert(savedMusicList, newSong)
                saveMusicData(); renderSavedMusic()
                MakeToast("Đã lưu & Đang kiểm tra", "Đang phân loại Public/Private cho: " .. name, Theme.Brand)
                probeSongStatus(newSong)
            end)
        else
            MakeToast("Chưa có ID", "Hãy nhập ID Nhạc trước khi bấm nút Lưu!", Theme.AccentOff)
        end
    end)

    renderSavedMusic()

    -- Tự động kiểm tra phân loại Public / Private cho các bài đã lưu từ trước nhưng chưa có nhãn
    task.spawn(function()
        for _, item in ipairs(savedMusicList) do
            if not item.status or item.status == "checking" then
                probeSongStatus(item)
                task.wait(0.35)
            end
        end
    end)
    end
end
-- ==========================================
-- [TAB 6: TP SAVE (NÂNG CẤP ESP ĐIỂM LƯU + AUTO LOOP TP + CẬP NHẬT VỊ TRÍ)]
-- ==========================================
local savedTpList = {}
local clearSavedTpESPs
do
    local tpFileName = "MenuVipProMax_SavedTPs.json"
    pcall(function() if isfile and isfile(tpFileName) then local decoded = HttpService:JSONDecode(readfile(tpFileName)); if type(decoded) == "table" then savedTpList = decoded end end end)
    local function saveTpData() pcall(function() if writefile then local d = {}; for _, v in ipairs(savedTpList) do if not v.isTemp then table.insert(d, v) end end; writefile(tpFileName, HttpService:JSONEncode(d)) end end) end
    local pendingDeleteAll = false
    local renderSavedTps

    clearSavedTpESPs = function()
        for _, item in pairs(SavedTpESPs) do
            if item.Anchor then item.Anchor:Destroy() end
            if item.Billboard then item.Billboard:Destroy() end
        end
        SavedTpESPs = {}
    end

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
        else savedTpList = {}; saveTpData(); clearSavedTpESPs(); renderSavedTps(); MakeToast("Thành công", "Đã xóa toàn bộ tọa độ!", Theme.Brand); pendingDeleteAll = false end
    end); tpControlFrame_New.LayoutOrder = 1

    local tpListCard = Instance.new("Frame", page6)
    tpListCard.Size = UDim2.new(0.94, 0, 1, -46); tpListCard.BackgroundColor3 = Color3.fromRGB(20, 22, 31); tpListCard.LayoutOrder = 2; tpListCard.ZIndex = 10
    Instance.new("UICorner", tpListCard).CornerRadius = UDim.new(0, 8)
    local tlStroke = Instance.new("UIStroke", tpListCard); tlStroke.Color = Theme.Stroke; tlStroke.Thickness = 1; table.insert(RGBElements, {Type = "Info", Stroke = tlStroke})

    local tlHeader = Instance.new("TextLabel", tpListCard)
    tlHeader.Size = UDim2.new(1, -16, 0, 18); tlHeader.Position = UDim2.new(0, 10, 0, 3); tlHeader.BackgroundTransparency = 1
    tlHeader.Text = "📍 DANH SÁCH TỌA ĐỘ ĐÃ LƯU"; tlHeader.TextColor3 = Theme.Brand; tlHeader.Font = Enum.Font.GothamBold; tlHeader.TextSize = 9; tlHeader.TextXAlignment = Enum.TextXAlignment.Left; tlHeader.ZIndex = 10

    local savedTpContent = Instance.new("ScrollingFrame", tpListCard)
    savedTpContent.Size = UDim2.new(1, -10, 1, -24); savedTpContent.Position = UDim2.new(0, 5, 0, 22)
    savedTpContent.BackgroundTransparency = 1; savedTpContent.ScrollBarThickness = 3; savedTpContent.ScrollBarImageColor3 = Theme.Brand; savedTpContent.BorderSizePixel = 0; savedTpContent.ZIndex = 10
    local tpLayout = Instance.new("UIListLayout", savedTpContent); tpLayout.SortOrder = Enum.SortOrder.LayoutOrder; tpLayout.Padding = UDim.new(0, 4)
    tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedTpContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 10) end)

    registerBrandUpdater(function(newBrand)
        if tlHeader and tlHeader.Parent then tlHeader.TextColor3 = newBrand end
        if savedTpContent and savedTpContent.Parent then savedTpContent.ScrollBarImageColor3 = newBrand end
    end)

    renderSavedTps = function()
        for _, child in pairs(savedTpContent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        cleanRGBElements()
        tlHeader.Text = "📍 DANH SÁCH TỌA ĐỘ ĐÃ LƯU (" .. #savedTpList .. ")"
        if #savedTpList == 0 then
            local empty = Instance.new("Frame", savedTpContent); empty.Size = UDim2.new(1, 0, 0, 42); empty.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", empty); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Text = "Chưa có vị trí nào được lưu.\nBấm '📍 LƯU VỊ TRÍ HIỆN TẠI' để lưu & tự hiện ESP!"; lbl.TextColor3 = Theme.TextDim; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.ZIndex = 10
            return
        end
        for i, data in ipairs(savedTpList) do
            local item = Instance.new("Frame", savedTpContent); item.Size = UDim2.new(1, -4, 0, 32); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1; table.insert(RGBElements, {Type = "Info", Stroke = stroke})

            local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.56, 0, 1, 0); nameBox.Position = UDim2.new(0.03, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 9.5; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
            nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveTpData() else nameBox.Text = data.name end end)

            local tpBtn = Instance.new("TextButton", item); tpBtn.Size = UDim2.new(0.18, 0, 0.68, 0); tpBtn.Position = UDim2.new(0.61, 0, 0.16, 0); tpBtn.Text = "⚡ TP"; tpBtn.BackgroundColor3 = Color3.fromRGB(20, 26, 36); tpBtn.TextColor3 = getSoftBrandColor(Theme.Brand); tpBtn.Font = Enum.Font.GothamSemibold; tpBtn.TextSize = 9; tpBtn.ZIndex = 10; Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 5)
            local tpSt = Instance.new("UIStroke", tpBtn); tpSt.Color = Theme.Brand; tpSt.Thickness = 0.9; tpSt.Transparency = 0.35
            table.insert(RGBElements, {Type = "Button", Stroke = tpSt, DefaultColor = Theme.Brand, UseBrand = true})

            local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.16, 0, 0.68, 0); delBtn.Position = UDim2.new(0.81, 0, 0.16, 0); delBtn.Text = "Xóa"; delBtn.BackgroundColor3 = Color3.fromRGB(32, 20, 26); delBtn.TextColor3 = Color3.fromRGB(190, 115, 128); delBtn.Font = Enum.Font.GothamSemibold; delBtn.TextSize = 9; delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 5)
            local dlSt = Instance.new("UIStroke", delBtn); dlSt.Color = Theme.AccentOff; dlSt.Thickness = 0.9; dlSt.Transparency = 0.4

            tpBtn.MouseButton1Click:Connect(function()
                clickAnimate(tpBtn)
                if player.Character then
                    local r = getUniversalRoot(player.Character)
                    if r then
                        r.CFrame = CFrame.new(unpack(data.cframe))
                        if State.AirWalk then airWalkY = r.Position.Y - getFootOffset(player.Character) end
                        MakeToast("Dịch chuyển", "Đến " .. data.name, Theme.Brand)
                    end
                end
            end)
            delBtn.MouseButton1Click:Connect(function()
                clickAnimate(delBtn)
                table.remove(savedTpList, i)
                saveTpData(); clearSavedTpESPs(); renderSavedTps()
            end)
        end
    end
    renderSavedTps()
end
-- ==========================================
-- [TAB 7: TP NGƯỜI CHƠI (CUỘN MƯỢT KHÔNG GIẬT + KHÔNG KẸT TƯ THẾ TP 1 LẦN)]
-- ==========================================
local targetTpPlayer = nil
local autoTpPlayerEnabled = false
local spectatePlayerEnabled = false
local spectateProxyPart = nil
local lastSpectateStreamTick = 0
local teleportToSelectedPlayer

do
local playerListContainer, playerListScroll
local playerDistLabels = {}
local playerCardRefs = {}

local function restoreNormalPosture()
    local myChar = player.Character
    if not myChar then return end
    local myRoot = getUniversalRoot(myChar)
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if myHum and not State.Fly then myHum.PlatformStand = false end
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
teleportToSelectedPlayer = function(isManualClick)
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
            task.spawn(function() pcall(function() player:RequestStreamAroundAsync(targetPos, 3) end) end)
        end

        local _, targetYaw, _ = targetCF:ToEulerAnglesYXZ()
        local baseCFrame = CFrame.new(targetPos) * CFrame.Angles(0, targetYaw, 0)
        local finalCFrame = baseCFrame * mode.GetOffset(State.TpDistance)

        if mode.IsHorizontal and autoTpPlayerEnabled then
            if myHum then myHum.PlatformStand = true end
            wasHorizontalTp = true
            for _, part in ipairs(myChar:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        elseif mode.IsHorizontal and isManualClick then
            -- Khi chỉ bấm "TP 1 LẦN" ở chế độ Trên Đầu / Dưới Chân: đặt nhân vật đứng thẳng tại điểm đích hoặc tự trả lại tư thế ngay để không bị kẹt nằm đơ
            finalCFrame = CFrame.new(finalCFrame.Position) * CFrame.Angles(0, targetYaw, 0)
            if wasHorizontalTp then restoreNormalPosture() end
        elseif wasHorizontalTp then
            restoreNormalPosture()
        end

        myRoot.CFrame = finalCFrame
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
        if State.AirWalk then airWalkY = myRoot.Position.Y - getFootOffset(myChar) end

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
                        local stepCF = bCF * mode.GetOffset(State.TpDistance)
                        if mode.IsHorizontal and not autoTpPlayerEnabled then
                            stepCF = CFrame.new(stepCF.Position) * CFrame.Angles(0, yaw, 0)
                        end
                        curRoot.CFrame = stepCF
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
        if spectateProxyPart then spectateProxyPart:Destroy(); spectateProxyPart = nil end
        player.ReplicationFocus = nil
        local cam = workspace.CurrentCamera
        if cam and player.Character then
            local myHum = player.Character:FindFirstChildOfClass("Humanoid")
            if myHum then cam.CameraType = Enum.CameraType.Custom; cam.CameraSubject = myHum end
        end
    end)
end

    local tpControlCard = Instance.new("Frame", page7)
    tpControlCard.Size = UDim2.new(0.94, 0, 0, 88); tpControlCard.BackgroundColor3 = Theme.ItemBg
    tpControlCard.LayoutOrder = 1; tpControlCard.ZIndex = 10
    Instance.new("UICorner", tpControlCard).CornerRadius = UDim.new(0, 8)
    local tpCardStroke = Instance.new("UIStroke", tpControlCard); tpCardStroke.Color = Theme.Stroke; tpCardStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = tpCardStroke})

    -- Mở rộng khung hiển thị mục tiêu (cao 32px, avatar 24x24, chữ to rõ hơn)
    local targetHeaderRow = Instance.new("Frame", tpControlCard)
    targetHeaderRow.Size = UDim2.new(1, -12, 0, 32); targetHeaderRow.Position = UDim2.new(0, 6, 0, 4)
    targetHeaderRow.BackgroundColor3 = Color3.fromRGB(16, 18, 26); targetHeaderRow.ZIndex = 10
    Instance.new("UICorner", targetHeaderRow).CornerRadius = UDim.new(0, 7)
    local thrStroke = Instance.new("UIStroke", targetHeaderRow); thrStroke.Color = Theme.Stroke; thrStroke.Thickness = 0.8; thrStroke.Transparency = 0.35

    local selectedAvatarImg = Instance.new("ImageLabel", targetHeaderRow)
    selectedAvatarImg.Size = UDim2.new(0, 24, 0, 24); selectedAvatarImg.Position = UDim2.new(0, 6, 0.5, -12)
    selectedAvatarImg.BackgroundColor3 = Color3.fromRGB(30, 34, 46); selectedAvatarImg.Image = "rbxassetid://0"; selectedAvatarImg.ZIndex = 10
    Instance.new("UICorner", selectedAvatarImg).CornerRadius = UDim.new(1, 0)
    local selAvaStroke = Instance.new("UIStroke", selectedAvatarImg); selAvaStroke.Color = Theme.Brand; selAvaStroke.Thickness = 1.2

    local targetStatusLabel = Instance.new("TextLabel", targetHeaderRow)
    targetStatusLabel.Size = UDim2.new(1, -114, 1, 0); targetStatusLabel.Position = UDim2.new(0, 35, 0, 0)
    targetStatusLabel.BackgroundTransparency = 1; targetStatusLabel.RichText = true
    targetStatusLabel.Text = "🎯 <font color='#C97A86'>Chưa chọn mục tiêu</font>"; targetStatusLabel.TextColor3 = Theme.TextTitle
    targetStatusLabel.Font = Enum.Font.GothamBold; targetStatusLabel.TextSize = 11; targetStatusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    targetStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; targetStatusLabel.ZIndex = 10

    local spectateBtn = Instance.new("TextButton", targetHeaderRow)
    spectateBtn.Size = UDim2.new(0, 72, 0, 22); spectateBtn.Position = UDim2.new(1, -76, 0.5, -11)
    spectateBtn.BackgroundColor3 = Color3.fromRGB(22, 20, 28); spectateBtn.Text = "👁️ XEM [TẮT]"
    spectateBtn.TextColor3 = Color3.fromRGB(185, 115, 126); spectateBtn.Font = Enum.Font.GothamSemibold; spectateBtn.TextSize = 8.5
    spectateBtn.AutoButtonColor = false; spectateBtn.ZIndex = 10
    Instance.new("UICorner", spectateBtn).CornerRadius = UDim.new(0, 5)
    local spectateStroke = Instance.new("UIStroke", spectateBtn); spectateStroke.Color = Color3.fromRGB(165, 85, 98); spectateStroke.Thickness = 0.9; spectateStroke.Transparency = 0.45

    local tpPosBtn = Instance.new("TextButton", tpControlCard)
    tpPosBtn.Size = UDim2.new(1, -12, 0, 22); tpPosBtn.Position = UDim2.new(0, 6, 0, 39)
    tpPosBtn.BackgroundColor3 = Color3.fromRGB(20, 26, 38); tpPosBtn.Text = ""; tpPosBtn.AutoButtonColor = false; tpPosBtn.ZIndex = 10
    Instance.new("UICorner", tpPosBtn).CornerRadius = UDim.new(0, 6)
    local tpPosStroke = Instance.new("UIStroke", tpPosBtn); tpPosStroke.Color = Theme.Brand; tpPosStroke.Thickness = 1; tpPosStroke.Transparency = 0.35
    table.insert(RGBElements, {Type = "Button", Stroke = tpPosStroke, DefaultColor = Theme.Brand, UseBrand = true})

    local tpPosLabel = Instance.new("TextLabel", tpPosBtn)
    tpPosLabel.Size = UDim2.new(1, 0, 1, 0); tpPosLabel.BackgroundTransparency = 1; tpPosLabel.RichText = true
    tpPosLabel.TextColor3 = Color3.fromRGB(210, 218, 232); tpPosLabel.Font = Enum.Font.GothamSemibold; tpPosLabel.TextSize = 10; tpPosLabel.ZIndex = 10

    local function updateTpPosText()
        local item = TpPositions[State.TpPositionIdx] or TpPositions[1]
        tpPosLabel.Text = "📍 VỊ TRÍ TP: <font color='#D8B868'>" .. item.Upper .. "</font>"
    end
    updateTpPosText()

    tpPosBtn.MouseButton1Click:Connect(function()
        clickAnimate(tpPosBtn)
        State.TpPositionIdx = State.TpPositionIdx + 1
        if State.TpPositionIdx > #TpPositions then State.TpPositionIdx = 1 end
        updateTpPosText()
        local currentMode = TpPositions[State.TpPositionIdx] or TpPositions[1]
        if not currentMode.IsHorizontal and wasHorizontalTp then restoreNormalPosture() end
        if State.AutoSave then saveConfig() end
    end)

    local tpDistContainer = Instance.new("Frame", tpControlCard)
    tpDistContainer.Size = UDim2.new(1, -12, 0, 22); tpDistContainer.Position = UDim2.new(0, 6, 0, 63)
    tpDistContainer.BackgroundTransparency = 1; tpDistContainer.ZIndex = 10

    local tpDistTitle = Instance.new("TextLabel", tpDistContainer)
    tpDistTitle.Size = UDim2.new(0.7, 0, 0, 11); tpDistTitle.Position = UDim2.new(0, 2, 0, 0)
    tpDistTitle.BackgroundTransparency = 1; tpDistTitle.Text = "📏 Khoảng cách đứng (Studs):"
    tpDistTitle.TextColor3 = Theme.TextDim; tpDistTitle.Font = Enum.Font.GothamSemibold; tpDistTitle.TextSize = 9.5; tpDistTitle.TextXAlignment = Enum.TextXAlignment.Left; tpDistTitle.ZIndex = 10

    local tpDistValLabel = Instance.new("TextLabel", tpDistContainer)
    tpDistValLabel.Size = UDim2.new(0.3, -4, 0, 11); tpDistValLabel.Position = UDim2.new(0.7, 0, 0, 0)
    tpDistValLabel.BackgroundTransparency = 1; tpDistValLabel.Text = tostring(State.TpDistance) .. " m"
    tpDistValLabel.TextColor3 = Color3.fromRGB(240, 200, 104); tpDistValLabel.Font = Enum.Font.GothamBold; tpDistValLabel.TextSize = 10; tpDistValLabel.TextXAlignment = Enum.TextXAlignment.Right; tpDistValLabel.ZIndex = 10

    local tpDistTrack = Instance.new("Frame", tpDistContainer)
    tpDistTrack.Size = UDim2.new(1, -4, 0, 5); tpDistTrack.Position = UDim2.new(0, 2, 0, 14)
    tpDistTrack.BackgroundColor3 = Color3.fromRGB(16, 17, 24); tpDistTrack.ZIndex = 10
    Instance.new("UICorner", tpDistTrack).CornerRadius = UDim.new(1, 0)

    local initTpPos = math.clamp((State.TpDistance - 1) / 24, 0, 1)
    local tpDistFill = Instance.new("Frame", tpDistTrack)
    tpDistFill.Size = UDim2.new(initTpPos, 0, 1, 0); tpDistFill.BackgroundColor3 = Theme.Brand; tpDistFill.ZIndex = 11
    Instance.new("UICorner", tpDistFill).CornerRadius = UDim.new(1, 0)

    local tpKnob = Instance.new("Frame", tpDistTrack)
    tpKnob.Size = UDim2.new(0, 10, 0, 10); tpKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    tpKnob.Position = UDim2.new(initTpPos, 0, 0.5, 0); tpKnob.BackgroundColor3 = Color3.fromRGB(240, 248, 255); tpKnob.ZIndex = 12
    Instance.new("UICorner", tpKnob).CornerRadius = UDim.new(1, 0)

    registerBrandUpdater(function(newBrand)
        if tpDistFill and tpDistFill.Parent then tpDistFill.BackgroundColor3 = newBrand end
    end)

    local tpDistDragInput = nil
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
        if not tpDistDragInput and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            tpDistDragInput = input; updateTpDistSlider(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if isDragUpdateInput(input, tpDistDragInput) then
            updateTpDistSlider(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input == tpDistDragInput then
            tpDistDragInput = nil
        end
    end)

    local function updateTargetLabel()
        if targetTpPlayer then
            targetStatusLabel.Text = string.format("🎯 <font color='#56C28B'>%s</font> <font color='#C8AF68'>(@%s)</font>", targetTpPlayer.DisplayName, targetTpPlayer.Name)
            selAvaStroke.Color = Color3.fromRGB(86, 194, 139)
            task.spawn(function()
                pcall(function() selectedAvatarImg.Image = Players:GetUserThumbnailAsync(targetTpPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
            end)
        else
            targetStatusLabel.Text = "🎯 <font color='#C97A86'>Chưa chọn mục tiêu</font>"
            selAvaStroke.Color = Color3.fromRGB(185, 115, 126)
            selectedAvatarImg.Image = "rbxassetid://0"
        end
    end

    local tpActionRow = Instance.new("Frame", page7)
    tpActionRow.Size = UDim2.new(0.94, 0, 0, 26); tpActionRow.BackgroundTransparency = 1; tpActionRow.LayoutOrder = 2

    local tpOnceBtn = Instance.new("TextButton", tpActionRow)
    tpOnceBtn.Size = UDim2.new(0.486, 0, 1, 0); tpOnceBtn.BackgroundColor3 = Color3.fromRGB(19, 24, 34)
    tpOnceBtn.Text = "⚡ TP 1 LẦN"; tpOnceBtn.TextColor3 = getSoftBrandColor(Theme.Brand); tpOnceBtn.Font = Enum.Font.GothamSemibold; tpOnceBtn.TextSize = 9.5
    tpOnceBtn.AutoButtonColor = false; tpOnceBtn.ZIndex = 10
    Instance.new("UICorner", tpOnceBtn).CornerRadius = UDim.new(0, 6)
    local tpOnceStroke = Instance.new("UIStroke", tpOnceBtn); tpOnceStroke.Color = Theme.Brand; tpOnceStroke.Thickness = 1; tpOnceStroke.Transparency = 0.4
    table.insert(RGBElements, {Type = "Button", Stroke = tpOnceStroke, DefaultColor = Theme.Brand, UseBrand = true})
    registerBrandUpdater(function(newBrand)
        if tpOnceBtn and tpOnceBtn.Parent then tpOnceBtn.TextColor3 = getSoftBrandColor(newBrand) end
    end)

    local autoTpBtn = Instance.new("TextButton", tpActionRow)
    autoTpBtn.Size = UDim2.new(0.486, 0, 1, 0); autoTpBtn.Position = UDim2.new(0.514, 0, 0, 0)
    autoTpBtn.BackgroundColor3 = Color3.fromRGB(22, 20, 28); autoTpBtn.Text = "🔁 AUTO TP [TẮT]"
    autoTpBtn.TextColor3 = Color3.fromRGB(185, 115, 126); autoTpBtn.Font = Enum.Font.GothamSemibold; autoTpBtn.TextSize = 9.5
    autoTpBtn.AutoButtonColor = false; autoTpBtn.ZIndex = 10
    Instance.new("UICorner", autoTpBtn).CornerRadius = UDim.new(0, 6)
    local autoTpStroke = Instance.new("UIStroke", autoTpBtn); autoTpStroke.Color = Color3.fromRGB(165, 85, 98); autoTpStroke.Thickness = 1; autoTpStroke.Transparency = 0.45
    table.insert(RGBElements, {Type = "Toggle", Stroke = autoTpStroke, State = function() return autoTpPlayerEnabled end})

    local function updateAutoTpBtnUI()
        autoTpBtn.Text = autoTpPlayerEnabled and "🔁 AUTO TP [BẬT]" or "🔁 AUTO TP [TẮT]"
        autoTpBtn.TextColor3 = autoTpPlayerEnabled and Color3.fromRGB(86, 194, 139) or Color3.fromRGB(185, 115, 126)
        autoTpBtn.BackgroundColor3 = autoTpPlayerEnabled and Color3.fromRGB(18, 32, 26) or Color3.fromRGB(22, 20, 28)
        if not State.RGB then autoTpStroke.Color = autoTpPlayerEnabled and Color3.fromRGB(70, 165, 115) or Color3.fromRGB(165, 85, 98) end
    end

    local function updateSpectateBtnUI()
        spectateBtn.Text = spectatePlayerEnabled and "👁️ XEM [BẬT]" or "👁️ XEM [TẮT]"
        spectateBtn.TextColor3 = spectatePlayerEnabled and Color3.fromRGB(86, 194, 139) or Color3.fromRGB(185, 115, 126)
        spectateBtn.BackgroundColor3 = spectatePlayerEnabled and Color3.fromRGB(18, 32, 26) or Color3.fromRGB(22, 20, 28)
        spectateStroke.Color = spectatePlayerEnabled and Color3.fromRGB(70, 165, 115) or Color3.fromRGB(165, 85, 98)
    end

    tpOnceBtn.MouseButton1Click:Connect(function()
        clickAnimate(tpOnceBtn)
        if not targetTpPlayer then MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người chơi ở danh sách dưới!", Theme.AccentOff); return end
        if teleportToSelectedPlayer(true) then
            local modeName = (TpPositions[State.TpPositionIdx] or TpPositions[1]).Name
            MakeToast("Dịch Chuyển", "Đến " .. targetTpPlayer.DisplayName .. " (" .. modeName .. ")", Theme.Brand)
        else
            MakeToast("Lỗi", "Người chơi chưa tải nhân vật hoặc đã chết!", Theme.AccentOff)
        end
    end)

    autoTpBtn.MouseButton1Click:Connect(function()
        clickAnimate(autoTpBtn)
        if not targetTpPlayer then MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người chơi ở danh sách dưới!", Theme.AccentOff); return end
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
        if not targetTpPlayer then MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người chơi ở danh sách dưới!", Theme.AccentOff); return end
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
    playerListContainer.Size = UDim2.new(0.94, 0, 1, -130); playerListContainer.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
    playerListContainer.LayoutOrder = 3; playerListContainer.ZIndex = 10
    Instance.new("UICorner", playerListContainer).CornerRadius = UDim.new(0, 8)
    local listContainerStroke = Instance.new("UIStroke", playerListContainer); listContainerStroke.Color = Theme.Stroke; listContainerStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = listContainerStroke})

    local searchBar = Instance.new("Frame", playerListContainer)
    searchBar.Size = UDim2.new(1, -8, 0, 22); searchBar.Position = UDim2.new(0, 4, 0, 4)
    searchBar.BackgroundColor3 = Color3.fromRGB(16, 18, 26); searchBar.ZIndex = 11
    Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 6)
    local sStroke = Instance.new("UIStroke", searchBar); sStroke.Color = Theme.Brand; sStroke.Thickness = 0.9; sStroke.Transparency = 0.35
    table.insert(RGBElements, {Type = "Button", Stroke = sStroke, DefaultColor = Theme.Brand, UseBrand = true})

    local searchBox = Instance.new("TextBox", searchBar)
    searchBox.Size = UDim2.new(1, -16, 1, 0); searchBox.Position = UDim2.new(0, 8, 0, 0)
    searchBox.BackgroundTransparency = 1; searchBox.PlaceholderText = "🔍 Nhập tên hoặc @username để lọc nhanh..."
    searchBox.PlaceholderColor3 = Theme.TextDim; searchBox.Text = ""; searchBox.TextColor3 = Theme.TextTitle
    searchBox.Font = Enum.Font.GothamSemibold; searchBox.TextSize = 9.5; searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false; searchBox.ZIndex = 11

    playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
    playerListScroll.Size = UDim2.new(1, -6, 1, -30); playerListScroll.Position = UDim2.new(0, 3, 0, 28)
    playerListScroll.BackgroundTransparency = 1; playerListScroll.BorderSizePixel = 0
    playerListScroll.ScrollBarThickness = 3; playerListScroll.ScrollBarImageColor3 = Theme.Brand
    playerListScroll.ScrollingDirection = Enum.ScrollingDirection.Y; playerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; playerListScroll.ZIndex = 10

    registerBrandUpdater(function(newBrand)
        if playerListScroll and playerListScroll.Parent then playerListScroll.ScrollBarImageColor3 = newBrand end
    end)

    local playerScrollLayout = Instance.new("UIListLayout", playerListScroll)
    playerScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; playerScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder; playerScrollLayout.Padding = UDim.new(0, 4)

    local playerScrollPad = Instance.new("UIPadding", playerListScroll)
    playerScrollPad.PaddingTop = UDim.new(0, 2); playerScrollPad.PaddingBottom = UDim.new(0, 6); playerScrollPad.PaddingRight = UDim.new(0, 4)

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
                            matched = true; break
                        end
                    end
                    item.Visible = matched
                end
            end
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(filterPlayerCards)

    -- Cập nhật trạng thái chọn tại chỗ mà không Destroy() danh sách, giúp thanh cuộn không bao giờ bị giật
    local function refreshPlayerSelectionVisuals()
        for p, ref in pairs(playerCardRefs) do
            if ref and ref.Btn and ref.Btn.Parent then
                local isSelected = (targetTpPlayer == p)
                ref.Btn.BackgroundColor3 = isSelected and Theme.ItemActive or Theme.ItemBg
                if not State.RGB then
                    ref.Stroke.Color = isSelected and Theme.AccentOn or Theme.Stroke
                    ref.AvaStroke.Color = isSelected and Theme.AccentOn or Theme.Brand
                end
                ref.NameLabel.Text = (isSelected and "✅ " or "") .. p.DisplayName
                ref.NameLabel.TextColor3 = isSelected and Theme.AccentOn or Theme.TextTitle
            end
        end
    end

    local function updatePlayerList()
        local savedCanvasPos = playerListScroll.CanvasPosition
        playerDistLabels = {}
        playerCardRefs = {}
        for _, child in pairs(playerListScroll:GetChildren()) do
            if child.Name == "PaddingFrame" then child:Destroy() end
        end
        cleanRGBElements()

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                local isSelected = (targetTpPlayer == p)
                local pFrame = Instance.new("Frame", playerListScroll)
                pFrame.Name = "PaddingFrame"; pFrame.Size = UDim2.new(1, -2, 0, 32); pFrame.BackgroundTransparency = 1; pFrame.ZIndex = 10

                local btn = Instance.new("TextButton", pFrame)
                btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = isSelected and Theme.ItemActive or Theme.ItemBg
                btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

                local stroke = Instance.new("UIStroke", btn); stroke.Color = isSelected and Theme.AccentOn or Theme.Stroke; stroke.Thickness = 1
                table.insert(RGBElements, {Type = "Info", Stroke = stroke})

                local targetAvatar = Instance.new("ImageLabel", btn)
                targetAvatar.Size = UDim2.new(0, 22, 0, 22); targetAvatar.Position = UDim2.new(0, 6, 0.5, -11)
                targetAvatar.BackgroundColor3 = Color3.fromRGB(30, 34, 46); targetAvatar.ZIndex = 11
                Instance.new("UICorner", targetAvatar).CornerRadius = UDim.new(1, 0)

                local targetStroke = Instance.new("UIStroke", targetAvatar)
                targetStroke.Color = isSelected and Theme.AccentOn or Theme.Brand; targetStroke.Thickness = 1
                targetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                table.insert(RGBElements, {Type = "Info", Stroke = targetStroke})

                local nLabel = Instance.new("TextLabel", btn)
                nLabel.Size = UDim2.new(1, -110, 0, 14); nLabel.Position = UDim2.new(0, 34, 0, 3)
                nLabel.BackgroundTransparency = 1; nLabel.Text = (isSelected and "✅ " or "") .. p.DisplayName
                nLabel.TextColor3 = isSelected and Theme.AccentOn or Theme.TextTitle; nLabel.Font = Enum.Font.GothamBold; nLabel.TextSize = 10
                nLabel.TextTruncate = Enum.TextTruncate.AtEnd; nLabel.TextXAlignment = Enum.TextXAlignment.Left; nLabel.ZIndex = 11

                local subLabel = Instance.new("TextLabel", btn)
                subLabel.Size = UDim2.new(1, -110, 0, 12); subLabel.Position = UDim2.new(0, 34, 0, 16)
                subLabel.BackgroundTransparency = 1; subLabel.Text = "@" .. p.Name
                subLabel.TextColor3 = Theme.TextDim; subLabel.Font = Enum.Font.GothamSemibold; subLabel.TextSize = 8.5
                subLabel.TextTruncate = Enum.TextTruncate.AtEnd; subLabel.TextXAlignment = Enum.TextXAlignment.Left; subLabel.ZIndex = 11

                local distPill = Instance.new("TextLabel", btn)
                distPill.Size = UDim2.new(0, 68, 0, 18); distPill.Position = UDim2.new(1, -74, 0.5, -9)
                distPill.BackgroundColor3 = Color3.fromRGB(18, 20, 29); distPill.RichText = true; distPill.Text = "-- m"
                distPill.TextColor3 = Theme.Brand; distPill.Font = Enum.Font.GothamBold; distPill.TextSize = 8.5; distPill.ZIndex = 11
                Instance.new("UICorner", distPill).CornerRadius = UDim.new(0, 5)
                playerDistLabels[p] = distPill
                playerCardRefs[p] = {Btn = btn, Stroke = stroke, AvaStroke = targetStroke, NameLabel = nLabel}

                task.spawn(function()
                    pcall(function() targetAvatar.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
                end)

                btn.MouseButton1Click:Connect(function()
                    clickAnimate(btn)
                    targetTpPlayer = p
                    updateTargetLabel()
                    refreshPlayerSelectionVisuals()
                    MakeToast("Đã chọn mục tiêu", p.DisplayName .. " (@" .. p.Name .. ")", Theme.AccentOn)
                end)
            end
        end
        filterPlayerCards()
        task.defer(function()
            if playerListScroll and playerListScroll.Parent then
                playerListScroll.CanvasPosition = savedCanvasPos
            end
        end)
    end
    updatePlayerList()

    task.spawn(function()
        while task.wait(0.5) do
            if page7.Visible then
                local myRoot = getUniversalRoot(player.Character)
                for p, lbl in pairs(playerDistLabels) do
                    if p and p.Parent and lbl and lbl.Parent then
                        local tCF = getCharacterCFrame(p.Character)
                        local tHum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                        local hpPct = (tHum and tHum.MaxHealth > 0) and math.floor((tHum.Health / tHum.MaxHealth) * 100) or nil
                        if myRoot and tCF then
                            local d = math.floor((myRoot.Position - tCF.Position).Magnitude)
                            if hpPct then
                                local hpCol = hpPct > 50 and "#38CC88" or (hpPct > 20 and "#E5B85B" or "#E05666")
                                lbl.Text = string.format("%dm • <font color='%s'>%d%%</font>", d, hpCol, hpPct)
                            else
                                lbl.Text = tostring(d) .. " m"
                            end
                        else
                            lbl.Text = "-- m"
                        end
                    end
                end
            end
        end
    end)

    Players.PlayerAdded:Connect(function() task.wait(0.5); updatePlayerList() end)
    Players.PlayerRemoving:Connect(function(leavingPlayer)
        if leavingPlayer == targetTpPlayer then
            targetTpPlayer = nil
            if autoTpPlayerEnabled then autoTpPlayerEnabled = false; restoreNormalPosture() end
            if spectatePlayerEnabled then spectatePlayerEnabled = false; resetCameraSubject(); updateSpectateBtnUI() end
            updateTargetLabel(); updateAutoTpBtnUI()
            MakeToast("Mục tiêu đã thoát", leavingPlayer.DisplayName .. " đã rời khỏi server!", Theme.AccentOff)
        end
        updatePlayerList()
    end)
end
-- ==========================================
-- [TAB 8: AUTO SKILL (NÂNG CẤP BẬT/TẮT NHANH & PHÍM Q, R)]
-- ==========================================
do
createDivider(page8, "ĐIỀU KHIỂN NHANH & TỐC ĐỘ SPAM")
local allSkillVars = {
    "AutoSkillZ", "AutoSkillX", "AutoSkillC", "AutoSkillV",
    "AutoSkillE", "AutoSkillF", "AutoSkillQ", "AutoSkillR",
    "AutoSkill1", "AutoSkill2", "AutoSkill3", "AutoSkill4", "AutoSkill5", "AutoSkill6"
}

createDualButtons(
    page8, "✅ BẬT TẤT CẢ PHÍM", Theme.AccentOn,
    function()
        for _, vName in ipairs(allSkillVars) do
            State[vName] = true
            fireSync(vName, true, false)
        end
        if State.AutoSave then saveConfig() end
    end,
    "🛑 TẮT TẤT CẢ PHÍM", Theme.AccentOff,
    function()
        for _, vName in ipairs(allSkillVars) do
            State[vName] = false
            fireSync(vName, false, false)
        end
        if State.AutoSave then saveConfig() end
    end
)

createToggle(page8, "🖱️ Auto Click Vũ Khí (Đánh thường)", "AutoClick")
createSlider(page8, "⏱️ Chu kỳ nhấn phím (x0.1 giây)", 1, 50, "AutoSkillDelay")

local function createKeycapGrid(parent, keysList)
    local gridContainer = Instance.new("Frame", parent)
    local rows = math.ceil(#keysList / 2)
    gridContainer.Size = UDim2.new(0.94, 0, 0, rows * 33 + (rows - 1) * 5)
    gridContainer.BackgroundTransparency = 1; gridContainer.ZIndex = 10

    local grid = Instance.new("UIGridLayout", gridContainer)
    grid.CellSize = UDim2.new(0.488, 0, 0, 33); grid.CellPadding = UDim2.new(0.024, 0, 0, 5); grid.SortOrder = Enum.SortOrder.LayoutOrder

    for idx, item in ipairs(keysList) do
        local cell = Instance.new("TextButton", gridContainer)
        cell.LayoutOrder = idx; cell.Text = ""; cell.AutoButtonColor = false; cell.ZIndex = 10
        Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 8)
        local cStroke = Instance.new("UIStroke", cell); cStroke.Thickness = 1

        local keycap = Instance.new("TextLabel", cell)
        keycap.Size = UDim2.new(0, 24, 0, 21); keycap.Position = UDim2.new(0, 6, 0.5, -10.5)
        keycap.BackgroundColor3 = Color3.fromRGB(16, 18, 26); keycap.Text = item.Key
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
        registerSync(item.Var, syncKeyVisual)
        table.insert(RGBElements, {Type = "Toggle", Stroke = cStroke, State = function() return State[item.Var] end})

        cell.MouseButton1Click:Connect(function()
            clickAnimate(cell)
            State[item.Var] = not State[item.Var]
            local nowOn = State[item.Var]
            fireSync(item.Var, nowOn, false)
            MakeToast(nowOn and "Đã Bật Auto Skill" or "Đã Tắt Auto Skill", "Tự động kích hoạt Phím [" .. item.Key .. "]", nowOn and Theme.AccentOn or Theme.AccentOff)
            if State.AutoSave then saveConfig() end
        end)
    end
end

createDivider(page8, "BẢNG PHÍM CHỮ (2 CỘT)")
createKeycapGrid(page8, {
    {Key = "Z", Var = "AutoSkillZ"}, {Key = "X", Var = "AutoSkillX"},
    {Key = "C", Var = "AutoSkillC"}, {Key = "V", Var = "AutoSkillV"},
    {Key = "E", Var = "AutoSkillE"}, {Key = "F", Var = "AutoSkillF"},
    {Key = "Q", Var = "AutoSkillQ"}, {Key = "R", Var = "AutoSkillR"}
})

createDivider(page8, "BẢNG PHÍM SỐ (2 CỘT)")
createKeycapGrid(page8, {
    {Key = "1", Var = "AutoSkill1"}, {Key = "2", Var = "AutoSkill2"},
    {Key = "3", Var = "AutoSkill3"}, {Key = "4", Var = "AutoSkill4"},
    {Key = "5", Var = "AutoSkill5"}, {Key = "6", Var = "AutoSkill6"}
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
        if State.AutoSkillQ then table.insert(keysToPress, Enum.KeyCode.Q) end
        if State.AutoSkillR then table.insert(keysToPress, Enum.KeyCode.R) end
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
end
-- ==========================================
-- [TAB 9: CẤU HÌNH & GIẢM LAG CHUYÊN SÂU (HỢP NHẤT TOÀN BỘ)]
-- ==========================================
do
    local Cache = {
        Particles = {}, PostEffects = {}, Shadows = {}, Players = {}, Pets = {},
        Popups = {}, Sounds = {}, Anims = {}, DarkParts = {}, LightingOrig = nil,
        Toggles = {}, PartCount = 0,
        Tickets = {LowGfx = 0, Particle = 0, Pet = 0, Player = 0, Shadow = 0, Popup = 0, Sound = 0, Anim = 0, Dark = 0}
    }

    local function createTab9Toggle(parent, text, varName, callback)
        local frameItem = createToggle(parent, text, varName, callback)
        Cache.Toggles[varName] = function(targetState)
            if State[varName] ~= targetState then
                State[varName] = targetState
                fireSync(varName, targetState, false)
                if callback then task.spawn(callback, targetState) end
            end
        end
        return frameItem
    end

    local liveMonitorCard = Instance.new("Frame", page9)
    liveMonitorCard.Size = UDim2.new(0.94, 0, 0, 52); liveMonitorCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255); liveMonitorCard.ZIndex = 10
    Instance.new("UICorner", liveMonitorCard).CornerRadius = UDim.new(0, 8)
    addSoftGradient(liveMonitorCard, Color3.fromRGB(25, 32, 46), Color3.fromRGB(19, 22, 32), 0)
    local monitorStroke = Instance.new("UIStroke", liveMonitorCard); monitorStroke.Color = Theme.Brand; monitorStroke.Thickness = 1.1; monitorStroke.Transparency = 0.25
    table.insert(RGBElements, {Type = "Button", Stroke = monitorStroke, DefaultColor = Theme.Brand, UseBrand = true})

    local monitorTitle = Instance.new("TextLabel", liveMonitorCard)
    monitorTitle.Size = UDim2.new(1, -16, 0, 15); monitorTitle.Position = UDim2.new(0, 10, 0, 4)
    monitorTitle.BackgroundTransparency = 1; monitorTitle.Text = "📊 THÔNG SỐ HIỆU NĂNG THỜI GIAN THỰC (LIVE MONITOR)"
    monitorTitle.TextColor3 = Theme.Brand; monitorTitle.Font = Enum.Font.GothamBold; monitorTitle.TextSize = 9; monitorTitle.TextXAlignment = Enum.TextXAlignment.Left; monitorTitle.ZIndex = 10
    registerBrandUpdater(function(newBrand)
        if monitorTitle and monitorTitle.Parent then monitorTitle.TextColor3 = newBrand end
    end)

    local monitorStatsLabel = Instance.new("TextLabel", liveMonitorCard)
    monitorStatsLabel.Size = UDim2.new(1, -20, 0, 28); monitorStatsLabel.Position = UDim2.new(0, 10, 0, 20)
    monitorStatsLabel.BackgroundTransparency = 1; monitorStatsLabel.RichText = true; monitorStatsLabel.TextColor3 = Theme.TextTitle
    monitorStatsLabel.Font = Enum.Font.GothamSemibold; monitorStatsLabel.TextSize = 10; monitorStatsLabel.LineHeight = 1.15
    monitorStatsLabel.TextXAlignment = Enum.TextXAlignment.Left; monitorStatsLabel.TextYAlignment = Enum.TextYAlignment.Top; monitorStatsLabel.ZIndex = 10

    local function refreshLiveMonitor()
        local pingStr, ramMB = "0 ms", 0
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
        if ramMB == 0 then pcall(function() ramMB = math.floor(collectgarbage("count") / 1024) end) end
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
    workspace.DescendantAdded:Connect(function(v) if v:IsA("BasePart") then Cache.PartCount = Cache.PartCount + 1 end end)
    workspace.DescendantRemoving:Connect(function(v) if v:IsA("BasePart") then Cache.PartCount = math.max(0, Cache.PartCount - 1) end end)

    task.spawn(function()
        while task.wait(0.6) do
            if page9.Visible then refreshLiveMonitor() end
        end
    end)

    local function isPlayerCharDescendant(obj)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and obj:IsDescendantOf(p.Character) then return true, p end
        end
        return false, nil
    end

    local function isPetOrAccessory(obj)
        if obj:FindFirstAncestorWhichIsA("Tool") then return false end
        if obj:IsA("Accessory") or obj:IsA("Hat") or obj:FindFirstAncestorWhichIsA("Accessory") or obj:FindFirstAncestorWhichIsA("Hat") then return true end
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
        if obj.Name == "VipAirWalk" or obj.Name == "VipSpectateProxy" or string.find(obj.Name, "^ESPAnchor_") or string.find(obj.Name, "^TpSaveAnchor_") then return end

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

    local function restoreParticlesIfBothOff(ticketCheckFn)
        if State.LowGfx or State.DisableParticles then return end
        task.spawn(function()
            local count = 0
            for obj, enabledVal in pairs(Cache.Particles) do
                if ticketCheckFn and not ticketCheckFn() then return end
                pcall(function() if obj and obj.Parent then obj.Enabled = enabledVal end end)
                count = count + 1
                if count % 350 == 0 then task.wait() end
            end
            if not State.LowGfx and not State.DisableParticles then Cache.Particles = {} end
        end)
    end

    local function cleanDebrisAndRAM(silent)
        local count = 0
        task.spawn(function()
            local descendants = workspace:GetDescendants()
            for i, obj in ipairs(descendants) do
                if i % 400 == 0 then task.wait() end
                pcall(function()
                    if obj and obj.Parent and obj.Name ~= "VipAirWalk" and obj.Name ~= "VipSpectateProxy" and not string.find(obj.Name, "^ESPAnchor_") and not string.find(obj.Name, "^TpSaveAnchor_") then
                        if (not player.Character or not obj:IsDescendantOf(player.Character)) and (not obj.Parent:FindFirstChild("Humanoid")) then
                            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or (obj:IsA("Decal") and obj.Name == "Blood") then
                                obj:Destroy(); count = count + 1
                            elseif obj:IsA("BasePart") and not obj.Anchored and obj.CanCollide == false and obj.Size.Magnitude < 5 and not isPetOrAccessory(obj) then
                                obj:Destroy(); count = count + 1
                            end
                        end
                    end
                end)
            end
            pcall(function() collectgarbage("collect") end)
            if not silent then MakeToast("Dọn Rác & RAM", "Đã dọn " .. count .. " rác & giải phóng bộ nhớ đệm!", Theme.Brand) end
        end)
    end

    createDivider(page9, "TỐI ƯU HIỆU SUẤT TỐI ĐA")
    local allBoostKeys = {"LowGfx", "DisableParticles", "DisablePostEffects", "NoFog", "NoShadows", "OptimizeTerrain", "HidePetsAccessories", "HidePopups"}
    createDualButtons(
        page9, "🥔 SIÊU KHOAI TÂY", Color3.fromRGB(230, 185, 70),
        function()
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
            for _, key in ipairs(allBoostKeys) do
                if Cache.Toggles[key] then Cache.Toggles[key](true) end
            end
            if State.AutoSave then saveConfig() end
            cleanDebrisAndRAM(true)
            MakeToast("🥔 Siêu Khoai Tây", "Đã bật toàn bộ cấu hình giảm lag mạnh nhất!", Theme.AccentOn)
        end,
        "🔄 KHÔI PHỤC GỐC", Theme.Brand,
        function()
            for _, key in ipairs(allBoostKeys) do
                if Cache.Toggles[key] then Cache.Toggles[key](false) end
            end
            if Cache.Toggles["DarkMap"] then Cache.Toggles["DarkMap"](false) end
            if Cache.Toggles["DisableAnims"] then Cache.Toggles["DisableAnims"](false) end
            if Cache.Toggles["HidePlayers"] then Cache.Toggles["HidePlayers"](false) end
            if State.AutoSave then saveConfig() end
            MakeToast("Khôi Phục Đồ Họa", "Đã trả lại đồ họa mặc định của game!", Theme.Brand)
        end
    )

    createSlider(page9, "Giới hạn FPS (Chống nóng máy)", 10, 120, "FpsCapValue", function(val) pcall(function() setfpscap(val) end) end)

    createTab9Toggle(page9, "Tắt Render 3D (Màn trắng + Giảm CPU)", "Disable3D", function(v)
        pcall(function() RunService:Set3dRenderingEnabled(not v) end)
        if v then screenOverlay.BackgroundColor3 = Color3.new(1, 1, 1); screenOverlay.Visible = true
        elseif not State.AfkModeScreen then screenOverlay.Visible = false end
    end)

    createTab9Toggle(page9, "Chế độ AFK Ngủ (Màn đen + 10 FPS)", "AfkModeScreen", function(v)
        if v then
            pcall(function() setfpscap(10) end)
            screenOverlay.BackgroundColor3 = Color3.new(0, 0, 0); screenOverlay.Visible = true
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
                for i, obj in ipairs(workspace:GetDescendants()) do
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
                    pcall(function() if obj and obj.Parent then for k, val in pairs(props) do obj[k] = val end end end)
                    count = count + 1; if count % 350 == 0 then task.wait() end
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
                for i, obj in ipairs(workspace:GetDescendants()) do
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
            elseif Cache.PostEffects[eff] ~= nil then
                eff.Enabled = Cache.PostEffects[eff]
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
        if not v then Lighting.FogEnd = 100000; Lighting.FogStart = 0 end
    end)
    task.spawn(function()
        while task.wait(0.25) do
            if State.NoFog then
                Lighting.FogEnd = 100000; Lighting.FogStart = 0
                local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
                if atmo then atmo.Density = 0; atmo.Offset = 0 end
            end
        end
    end)

    createTab9Toggle(page9, "🐾 Ẩn Pet, Quái phụ & Phụ kiện", "HidePetsAccessories", function(v)
        Cache.Tickets.Pet = Cache.Tickets.Pet + 1
        local myTicket = Cache.Tickets.Pet
        if v then
            task.spawn(function()
                for i, obj in ipairs(workspace:GetDescendants()) do
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
                    count = count + 1; if count % 350 == 0 then task.wait() end
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
                        for _, obj in ipairs(p.Character:GetDescendants()) do pcall(applyObjectOptimizations, obj) end
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
                    count = count + 1; if count % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.Player then Cache.Players = {} end
            end)
        end
    end)

    createTab9Toggle(page9, "🌊 Tối ưu Địa hình & Nước", "OptimizeTerrain", function(v)
        pcall(function()
            if v then
                workspace.Terrain.WaterWaveSize = 0; workspace.Terrain.WaterWaveSpeed = 0
                workspace.Terrain.WaterReflectance = 0; workspace.Terrain.WaterTransparency = 1
            else
                workspace.Terrain.WaterWaveSize = 0.15; workspace.Terrain.WaterWaveSpeed = 10
                workspace.Terrain.WaterReflectance = 1; workspace.Terrain.WaterTransparency = 0.3
            end
        end)
    end)

    createTab9Toggle(page9, "🌑 Tắt đổ bóng vật thể (No Shadows)", "NoShadows", function(v)
        Cache.Tickets.Shadow = Cache.Tickets.Shadow + 1
        local myTicket = Cache.Tickets.Shadow
        if v then
            task.spawn(function()
                for i, obj in ipairs(workspace:GetDescendants()) do
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
                    count = count + 1; if count % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.Shadow then Cache.Shadows = {} end
            end)
        end
    end)

    createDivider(page9, "TỐI ƯU CHUYÊN SÂU SIMULATOR & TREO MÁY")

    local function processPopupObj(obj)
        if not State.HidePopups or not obj or not obj.Parent then return end
        if obj:IsA("BillboardGui") and not string.find(obj.Name, "^MobileESP_") and not string.find(obj.Name, "^TpSaveESP_") then
            if obj.Enabled then
                if Cache.Popups[obj] == nil then Cache.Popups[obj] = obj.Enabled end
                obj.Enabled = false
            end
        elseif obj:IsA("TextLabel") and obj:IsDescendantOf(player:FindFirstChild("PlayerGui")) and not obj:IsDescendantOf(gui) then
            local txt = obj.Text or ""
            if string.find(txt, "^%+[%d%.]+") or string.find(string.lower(obj.Name), "popup") or string.find(string.lower(obj.Name), "damage") then
                if obj.Visible then
                    if Cache.Popups[obj] == nil then Cache.Popups[obj] = obj.Visible end
                    obj.Visible = false
                end
            end
        end
    end

    createTab9Toggle(page9, "🚫 Ẩn chữ bay & Popup (+Chỉ số/Damage)", "HidePopups", function(v)
        Cache.Tickets.Popup = Cache.Tickets.Popup + 1
        local myTicket = Cache.Tickets.Popup
        if v then
            task.spawn(function()
                for i, obj in ipairs(workspace:GetDescendants()) do
                    if myTicket ~= Cache.Tickets.Popup then return end
                    pcall(processPopupObj, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            task.spawn(function()
                local c = 0
                for obj, orig in pairs(Cache.Popups) do
                    if myTicket ~= Cache.Tickets.Popup then return end
                    pcall(function()
                        if obj and obj.Parent then
                            if obj:IsA("BillboardGui") then obj.Enabled = orig else obj.Visible = orig end
                        end
                    end)
                    c = c + 1; if c % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.Popup then Cache.Popups = {} end
            end)
        end
    end)

    local function processSoundObj(obj)
        if not State.MuteSFX or not obj or not obj.Parent then return end
        if obj:IsA("Sound") and obj ~= currentSound and obj.Volume > 0 then
            if Cache.Sounds[obj] == nil then Cache.Sounds[obj] = obj.Volume end
            obj.Volume = 0
        end
    end

    createTab9Toggle(page9, "🔇 Tắt tiếng động Game (Giữ nhạc Menu)", "MuteSFX", function(v)
        Cache.Tickets.Sound = Cache.Tickets.Sound + 1
        local myTicket = Cache.Tickets.Sound
        if v then
            task.spawn(function()
                for _, container in ipairs({workspace, SoundService, player:FindFirstChild("PlayerGui")}) do
                    if container then
                        for i, obj in ipairs(container:GetDescendants()) do
                            if myTicket ~= Cache.Tickets.Sound then return end
                            pcall(processSoundObj, obj)
                            if i % 350 == 0 then task.wait() end
                        end
                    end
                end
            end)
        else
            task.spawn(function()
                local c = 0
                for s, vol in pairs(Cache.Sounds) do
                    if myTicket ~= Cache.Tickets.Sound then return end
                    pcall(function() if s and s.Parent then s.Volume = vol end end)
                    c = c + 1; if c % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.Sound then Cache.Sounds = {} end
            end)
        end
    end)

    local function stopAnimator(obj)
        if not State.DisableAnims or not obj or not obj.Parent then return end
        if obj:IsA("Animator") then
            for _, track in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
        elseif obj:IsA("BaseScript") and obj.Name == "Animate" and obj.Disabled == false then
            Cache.Anims[obj] = false; obj.Disabled = true
        end
    end

    createTab9Toggle(page9, "🎭 Tắt hoạt ảnh Nhân vật & Quái (Giảm CPU)", "DisableAnims", function(v)
        Cache.Tickets.Anim = Cache.Tickets.Anim + 1
        local myTicket = Cache.Tickets.Anim
        if v then
            task.spawn(function()
                for i, obj in ipairs(workspace:GetDescendants()) do
                    if myTicket ~= Cache.Tickets.Anim then return end
                    pcall(stopAnimator, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            for scr, state in pairs(Cache.Anims) do
                pcall(function() if scr and scr.Parent then scr.Disabled = state end end)
            end
            Cache.Anims = {}
        end
    end)

    local darkColor = Color3.fromRGB(38, 40, 48)
    local function processDarkPart(obj)
        if not State.DarkMap or not obj or not obj.Parent then return end
        if obj:IsA("BasePart") and obj.Name ~= "VipAirWalk" and obj.Name ~= "VipSpectateProxy" and not string.find(obj.Name, "^TpSaveAnchor_") then
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and obj:IsDescendantOf(p.Character) then return end
            end
            if obj.Color ~= darkColor then
                if Cache.DarkParts[obj] == nil then Cache.DarkParts[obj] = obj.Color end
                obj.Color = darkColor
            end
        end
    end

    createTab9Toggle(page9, "🌑 Bản đồ Tối Dịu Mắt (Chống chói & Nhẹ máy)", "DarkMap", function(v)
        Cache.Tickets.Dark = Cache.Tickets.Dark + 1
        local myTicket = Cache.Tickets.Dark
        if v then
            pcall(function()
                if not Cache.LightingOrig then
                    Cache.LightingOrig = {Brightness = Lighting.Brightness, OutdoorAmbient = Lighting.OutdoorAmbient, Ambient = Lighting.Ambient}
                end
                Lighting.Brightness = 0.8
                Lighting.OutdoorAmbient = Color3.fromRGB(65, 70, 85)
                Lighting.Ambient = Color3.fromRGB(50, 55, 68)
            end)
            task.spawn(function()
                for i, obj in ipairs(workspace:GetDescendants()) do
                    if myTicket ~= Cache.Tickets.Dark then return end
                    pcall(processDarkPart, obj)
                    if i % 350 == 0 then task.wait() end
                end
            end)
        else
            pcall(function()
                if Cache.LightingOrig then
                    Lighting.Brightness = Cache.LightingOrig.Brightness
                    Lighting.OutdoorAmbient = Cache.LightingOrig.OutdoorAmbient
                    Lighting.Ambient = Cache.LightingOrig.Ambient
                    Cache.LightingOrig = nil
                end
            end)
            task.spawn(function()
                local c = 0
                for part, col in pairs(Cache.DarkParts) do
                    if myTicket ~= Cache.Tickets.Dark then return end
                    pcall(function() if part and part.Parent then part.Color = col end end)
                    c = c + 1; if c % 350 == 0 then task.wait() end
                end
                if myTicket == Cache.Tickets.Dark then Cache.DarkParts = {} end
            end)
        end
    end)

    workspace.DescendantAdded:Connect(function(obj)
        if State.LowGfx or State.DisableParticles or State.NoShadows or State.HidePlayers or State.HidePetsAccessories or State.HidePopups or State.MuteSFX or State.DisableAnims or State.DarkMap then
            task.defer(function()
                pcall(applyObjectOptimizations, obj)
                pcall(processPopupObj, obj); pcall(processSoundObj, obj)
                pcall(stopAnimator, obj); pcall(processDarkPart, obj)
            end)
        end
    end)
    pcall(function()
        player:WaitForChild("PlayerGui").DescendantAdded:Connect(function(obj)
            if State.HidePopups or State.MuteSFX then
                task.defer(function() pcall(processPopupObj, obj); pcall(processSoundObj, obj) end)
            end
        end)
    end)

    createTab9Toggle(page9, "🔄 Tự động dọn rác & Giải phóng RAM (30s)", "AutoClearRAM")
    task.spawn(function()
        while task.wait(30) do
            if State.AutoClearRAM then cleanDebrisAndRAM(true) end
        end
    end)

    createButton(page9, "🧹 Dọn rác bản đồ & Giải phóng RAM ngay", Theme.AccentOff, function() cleanDebrisAndRAM(false) end)
end
-- ==========================================
-- [TAB 1: DASHBOARD BENTO + QUẢN LÝ SERVER (SỬA LỖI UTF-8 & CÂN ĐỐI KHUNG)]
-- ==========================================
do
    local savedServersFile = "MenuVipProMax_SavedServers.json"
    local savedServers = {}
    pcall(function()
        if isfile and isfile(savedServersFile) then
            local dec = HttpService:JSONDecode(readfile(savedServersFile))
            if type(dec) == "table" then savedServers = dec end
        end
    end)
    local function saveServerList()
        pcall(function() if writefile then writefile(savedServersFile, HttpService:JSONEncode(savedServers)) end end)
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
        if identifyexecutor then execName = tostring(identifyexecutor())
        elseif getexecutorname then execName = tostring(getexecutorname()) end
    end)

    local bentoRow = Instance.new("Frame", page1)
    bentoRow.Size = UDim2.new(0.94, 0, 0, 38); bentoRow.BackgroundTransparency = 1; bentoRow.LayoutOrder = 0; bentoRow.ZIndex = 10

    local bentoGrid = Instance.new("UIGridLayout", bentoRow)
    bentoGrid.CellSize = UDim2.new(0.235, 0, 1, 0); bentoGrid.CellPadding = UDim2.new(0.02, 0, 0, 0); bentoGrid.SortOrder = Enum.SortOrder.LayoutOrder

    local function makeBentoStat(order, labelText, defaultVal, valColor)
        local box = Instance.new("Frame", bentoRow)
        box.LayoutOrder = order; box.BackgroundColor3 = Color3.fromRGB(255, 255, 255); box.ZIndex = 10
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
        addSoftGradient(box, Color3.fromRGB(28, 33, 48), Color3.fromRGB(20, 23, 35), 90)
        local st = Instance.new("UIStroke", box); st.Color = valColor; st.Thickness = 1; st.Transparency = 0.55
        table.insert(RGBElements, {Type = "Info", Stroke = st})

        local topBar = Instance.new("Frame", box)
        topBar.Size = UDim2.new(0.55, 0, 0, 2.5); topBar.AnchorPoint = Vector2.new(0.5, 0); topBar.Position = UDim2.new(0.5, 0, 0, 0)
        topBar.BackgroundColor3 = valColor; topBar.BorderSizePixel = 0; topBar.ZIndex = 11
        Instance.new("UICorner", topBar).CornerRadius = UDim.new(1, 0)

        local t = Instance.new("TextLabel", box)
        t.Size = UDim2.new(1, 0, 0, 12); t.Position = UDim2.new(0, 0, 0, 5)
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
        btn.Size = sizeUDim; btn.Position = posUDim; btn.BackgroundColor3 = bgCol; btn.Text = text
        btn.TextColor3 = textCol; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 8.5
        btn.AutoButtonColor = false; btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local st = Instance.new("UIStroke", btn)
        st.Color = borderCol; st.Thickness = 1; st.Transparency = 0.35; st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        return btn, st
    end

    local function makeCard(titleIcon, titleText, height, order)
        local card = Instance.new("Frame", page1)
        card.Size = UDim2.new(0.94, 0, 0, height); card.BackgroundColor3 = Theme.ItemBg
        card.LayoutOrder = order; card.ZIndex = 10
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", card); stroke.Color = Theme.Stroke; stroke.Thickness = 1
        table.insert(RGBElements, {Type = "Info", Stroke = stroke})

        local headerTitle = Instance.new("TextLabel", card)
        headerTitle.Size = UDim2.new(1, -16, 0, 19); headerTitle.Position = UDim2.new(0, 10, 0, 3)
        headerTitle.BackgroundTransparency = 1; headerTitle.Text = titleIcon .. " " .. titleText
        headerTitle.TextColor3 = Theme.Brand; headerTitle.Font = Enum.Font.GothamBold; headerTitle.TextSize = 9.5
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left; headerTitle.ZIndex = 10
        registerBrandUpdater(function(newBrand)
            if headerTitle and headerTitle.Parent then headerTitle.TextColor3 = newBrand end
        end)

        local line = Instance.new("Frame", card)
        line.Size = UDim2.new(1, -20, 0, 1); line.Position = UDim2.new(0, 10, 0, 22)
        line.BackgroundColor3 = Theme.Stroke; line.BorderSizePixel = 0; line.ZIndex = 10

        local body = Instance.new("TextLabel", card)
        body.Size = UDim2.new(1, -20, 1, -28); body.Position = UDim2.new(0, 10, 0, 24)
        body.BackgroundTransparency = 1; body.RichText = true; body.Text = "Đang tải..."
        body.TextColor3 = Color3.fromRGB(205, 214, 228); body.Font = Enum.Font.Gotham; body.TextSize = 9.5
        body.LineHeight = 1.15; body.TextXAlignment = Enum.TextXAlignment.Left; body.TextYAlignment = Enum.TextYAlignment.Top; body.ZIndex = 10

        return card, body
    end

    local charCard, charBody = makeCard("👤", "THÔNG TIN NHÂN VẬT", 94, 1)
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
    hpBarBg.Size = UDim2.new(1, -20, 0, 4); hpBarBg.Position = UDim2.new(0, 10, 1, -7)
    hpBarBg.BackgroundColor3 = Color3.fromRGB(18, 20, 28); hpBarBg.BorderSizePixel = 0; hpBarBg.ZIndex = 11
    Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(1, 0)

    local hpBarFill = Instance.new("Frame", hpBarBg)
    hpBarFill.Size = UDim2.new(1, 0, 1, 0); hpBarFill.BackgroundColor3 = Theme.AccentOn; hpBarFill.BorderSizePixel = 0; hpBarFill.ZIndex = 11
    Instance.new("UICorner", hpBarFill).CornerRadius = UDim.new(1, 0)

    local svCard, svBody = makeCard("🌐", "THÔNG TIN MÁY CHỦ", 84, 2)
    local copyPlaceBtn = makeSoftMiniBtn(
        svCard, "📋 PlaceId",
        UDim2.new(1, -138, 0, 3), UDim2.new(0, 56, 0, 16),
        Color3.fromRGB(175, 215, 240), Color3.fromRGB(28, 38, 48), Color3.fromRGB(80, 130, 165)
    )
    copyPlaceBtn.MouseButton1Click:Connect(function()
        clickAnimate(copyPlaceBtn)
        pcall(function()
            if setclipboard then
                setclipboard(tostring(game.PlaceId))
                MakeToast("Đã Copy PlaceId", tostring(game.PlaceId), Theme.Brand)
            end
        end)
    end)

    local resetCharBtn = makeSoftMiniBtn(
        svCard, "🔄 Reset NV",
        UDim2.new(1, -78, 0, 3), UDim2.new(0, 70, 0, 16),
        Color3.fromRGB(230, 165, 170), Color3.fromRGB(45, 28, 34), Color3.fromRGB(155, 75, 85)
    )
    resetCharBtn.MouseButton1Click:Connect(function()
        clickAnimate(resetCharBtn)
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0; MakeToast("Đã Reset", "Đang hồi sinh lại nhân vật...", Theme.AccentOff) end
        end)
    end)

    local _, sysBody = makeCard("⚙️", "TRẠNG THÁI & HỆ THỐNG", 72, 3)

    local idToolCard = Instance.new("Frame", page1)
    idToolCard.Size = UDim2.new(0.94, 0, 0, 86); idToolCard.BackgroundColor3 = Theme.ItemBg
    idToolCard.LayoutOrder = 4; idToolCard.ZIndex = 10
    Instance.new("UICorner", idToolCard).CornerRadius = UDim.new(0, 8)
    local itStroke = Instance.new("UIStroke", idToolCard); itStroke.Color = Theme.Stroke; itStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = itStroke})

    local idHeader = Instance.new("TextLabel", idToolCard)
    idHeader.Size = UDim2.new(1, -16, 0, 17); idHeader.Position = UDim2.new(0, 10, 0, 3)
    idHeader.BackgroundTransparency = 1; idHeader.Text = "🔑 QUẢN LÝ & KẾT NỐI ID SERVER"
    idHeader.TextColor3 = Theme.Brand; idHeader.Font = Enum.Font.GothamBold; idHeader.TextSize = 9.5
    idHeader.TextXAlignment = Enum.TextXAlignment.Left; idHeader.ZIndex = 10
    registerBrandUpdater(function(newBrand)
        if idHeader and idHeader.Parent then idHeader.TextColor3 = newBrand end
    end)

    local inputBg = Instance.new("Frame", idToolCard)
    inputBg.Size = UDim2.new(1, -16, 0, 25); inputBg.Position = UDim2.new(0, 8, 0, 22)
    inputBg.BackgroundColor3 = Color3.fromRGB(18, 20, 28); inputBg.ZIndex = 10
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 6)
    local ibStroke = Instance.new("UIStroke", inputBg); ibStroke.Color = Theme.Stroke; ibStroke.Thickness = 1

    local jobInput = Instance.new("TextBox", inputBg)
    jobInput.Size = UDim2.new(0.55, 0, 1, 0); jobInput.Position = UDim2.new(0.03, 0, 0, 0)
    jobInput.BackgroundTransparency = 1; jobInput.PlaceholderText = "🔍 Dán ID Server cần vào..."
    jobInput.PlaceholderColor3 = Theme.TextDim; jobInput.Text = ""; jobInput.TextColor3 = Color3.fromRGB(195, 215, 235)
    jobInput.Font = Enum.Font.Gotham; jobInput.TextSize = 9.5; jobInput.TextXAlignment = Enum.TextXAlignment.Left
    jobInput.ClearTextOnFocus = false; jobInput.ZIndex = 10

    local clearBtn = makeSoftMiniBtn(
        inputBg, "XÓA",
        UDim2.new(0.59, 0, 0.14, 0), UDim2.new(0.17, 0, 0.72, 0),
        Color3.fromRGB(200, 205, 215), Color3.fromRGB(38, 40, 52), Color3.fromRGB(75, 80, 100)
    )
    clearBtn.MouseButton1Click:Connect(function() clickAnimate(clearBtn); jobInput.Text = "" end)

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
        UDim2.new(0, 8, 0, 53), UDim2.new(0.31, -4, 0, 24),
        Color3.fromRGB(165, 220, 185), Color3.fromRGB(28, 42, 35), Color3.fromRGB(75, 145, 105)
    )
    local btnSaveSv = makeSoftMiniBtn(
        idToolCard, "📌 Lưu ID SV Này",
        UDim2.new(0.345, 2, 0, 53), UDim2.new(0.31, -4, 0, 24),
        Color3.fromRGB(175, 215, 240), Color3.fromRGB(28, 38, 48), Color3.fromRGB(75, 125, 160)
    )
    local btnCopyScript = makeSoftMiniBtn(
        idToolCard, "📤 Copy Lệnh Join",
        UDim2.new(0.69, 0, 0, 53), UDim2.new(0.31, -8, 0, 24),
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
                local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
                setclipboard(joinScript)
                MakeToast("Đã Copy Lệnh Join", "Gửi lệnh này cho bạn bè để vào chung SV!", Theme.AccentOn)
            end
        end)
    end)

    local svListCard = Instance.new("Frame", page1)
    svListCard.Size = UDim2.new(0.94, 0, 0, 144); svListCard.BackgroundColor3 = Theme.ItemBg
    svListCard.LayoutOrder = 5; svListCard.ZIndex = 10
    Instance.new("UICorner", svListCard).CornerRadius = UDim.new(0, 8)
    local slStroke = Instance.new("UIStroke", svListCard); slStroke.Color = Theme.Stroke; slStroke.Thickness = 1
    table.insert(RGBElements, {Type = "Info", Stroke = slStroke})

    local tabFilterRow = Instance.new("Frame", svListCard)
    tabFilterRow.Size = UDim2.new(1, -12, 0, 22); tabFilterRow.Position = UDim2.new(0, 6, 0, 5)
    tabFilterRow.BackgroundTransparency = 1; tabFilterRow.ZIndex = 11

    local tabBtnSaved, stSaved = makeSoftMiniBtn(tabFilterRow, "💾 Đã Lưu", UDim2.new(0, 0, 0, 0), UDim2.new(0.24, -2, 1, 0), Color3.fromRGB(210, 235, 255), Color3.fromRGB(35, 65, 90), Color3.fromRGB(90, 165, 220))
    local tabBtnLow, stLow = makeSoftMiniBtn(tabFilterRow, "📉 Ít Người", UDim2.new(0.25, 1, 0, 0), UDim2.new(0.25, -2, 1, 0), Color3.fromRGB(175, 215, 240), Color3.fromRGB(22, 24, 34), Color3.fromRGB(65, 75, 95))
    local tabBtnHigh, stHigh = makeSoftMiniBtn(tabFilterRow, "📈 Đông Người", UDim2.new(0.50, 1, 0, 0), UDim2.new(0.25, -2, 1, 0), Color3.fromRGB(175, 215, 240), Color3.fromRGB(22, 24, 34), Color3.fromRGB(65, 75, 95))
    local tabBtnPing, stPing = makeSoftMiniBtn(tabFilterRow, "⚡ Ping Thấp", UDim2.new(0.75, 1, 0, 0), UDim2.new(0.25, -1, 1, 0), Color3.fromRGB(175, 215, 240), Color3.fromRGB(22, 24, 34), Color3.fromRGB(65, 75, 95))

    local filterButtons = {{btn = tabBtnSaved, st = stSaved}, {btn = tabBtnLow, st = stLow}, {btn = tabBtnHigh, st = stHigh}, {btn = tabBtnPing, st = stPing}}
    local function highlightFilterTab(activeBtn)
        for _, item in ipairs(filterButtons) do
            local isAct = (item.btn == activeBtn)
            item.btn.BackgroundColor3 = isAct and Color3.fromRGB(35, 65, 90) or Color3.fromRGB(22, 24, 34)
            item.btn.TextColor3 = isAct and Color3.fromRGB(220, 240, 255) or Color3.fromRGB(150, 165, 185)
            item.st.Color = isAct and Color3.fromRGB(90, 165, 220) or Color3.fromRGB(65, 75, 95)
        end
    end

    local svListTitle = Instance.new("TextLabel", svListCard)
    svListTitle.Size = UDim2.new(1, -16, 0, 15); svListTitle.Position = UDim2.new(0, 10, 0, 30)
    svListTitle.BackgroundTransparency = 1; svListTitle.Text = "📋 DANH SÁCH ID SERVER ĐÃ LƯU"
    svListTitle.TextColor3 = Theme.Brand; svListTitle.Font = Enum.Font.GothamBold; svListTitle.TextSize = 9; svListTitle.TextXAlignment = Enum.TextXAlignment.Left; svListTitle.ZIndex = 10

    local svScroll = Instance.new("ScrollingFrame", svListCard)
    svScroll.Size = UDim2.new(1, -12, 1, -50); svScroll.Position = UDim2.new(0, 6, 0, 46)
    svScroll.BackgroundTransparency = 1; svScroll.BorderSizePixel = 0; svScroll.ScrollBarThickness = 3
    svScroll.ScrollBarImageColor3 = Theme.Brand; svScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; svScroll.CanvasSize = UDim2.new(0, 0, 0, 0); svScroll.ZIndex = 10

    registerBrandUpdater(function(newBrand)
        if svListTitle and svListTitle.Parent then svListTitle.TextColor3 = newBrand end
        if svScroll and svScroll.Parent then svScroll.ScrollBarImageColor3 = newBrand end
    end)

    local svLayout = Instance.new("UIListLayout", svScroll)
    svLayout.SortOrder = Enum.SortOrder.LayoutOrder; svLayout.Padding = UDim.new(0, 4)

    local function renderServerList(customList, isScanned)
        for _, ch in ipairs(svScroll:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
        cleanRGBElements()
        local listToRender = customList or savedServers
        if #listToRender == 0 then
            local empty = Instance.new("Frame", svScroll); empty.Size = UDim2.new(1, 0, 0, 28); empty.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", empty); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Text = isScanned and "Không tìm thấy server phù hợp!" or "Chưa có ID nào. Bấm 'Lưu ID SV Này' hoặc chọn ô bên trên!"
            lbl.TextColor3 = Theme.TextDim; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.ZIndex = 10
            return
        end

        for idx, item in ipairs(listToRender) do
            local row = Instance.new("Frame", svScroll)
            row.Size = UDim2.new(1, -6, 0, 25); row.BackgroundColor3 = Color3.fromRGB(20, 22, 31); row.ZIndex = 10
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

            local infoTxt = Instance.new("TextLabel", row)
            infoTxt.Size = UDim2.new(0.56, 0, 1, 0); infoTxt.Position = UDim2.new(0, 8, 0, 0)
            infoTxt.BackgroundTransparency = 1; infoTxt.Text = string.format("%s (%s)", item.label or ("SV #" .. idx), string.sub(item.id, 1, 10) .. "..")
            infoTxt.TextColor3 = Color3.fromRGB(195, 205, 220); infoTxt.Font = Enum.Font.Gotham; infoTxt.TextSize = 9; infoTxt.TextXAlignment = Enum.TextXAlignment.Left; infoTxt.ZIndex = 10

            local pickBtn = makeSoftMiniBtn(row, "Lấy ID", UDim2.new(0.57, 0, 0.15, 0), UDim2.new(0.19, 0, 0.7, 0), Color3.fromRGB(175, 215, 240), Color3.fromRGB(30, 42, 54), Color3.fromRGB(75, 125, 160))
            pickBtn.MouseButton1Click:Connect(function()
                clickAnimate(pickBtn); jobInput.Text = item.id
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
                    table.remove(savedServers, idx); saveServerList()
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
        clickAnimate(tabBtnSaved); highlightFilterTab(tabBtnSaved)
        svListTitle.Text = "📋 DANH SÁCH ID SERVER ĐÃ LƯU (" .. #savedServers .. ")"
        renderServerList(savedServers, false)
    end)
    tabBtnLow.MouseButton1Click:Connect(function() clickAnimate(tabBtnLow); highlightFilterTab(tabBtnLow); fetchAndShowServers("Asc", false, "📉 DANH SÁCH SV ÍT NGƯỜI") end)
    tabBtnHigh.MouseButton1Click:Connect(function() clickAnimate(tabBtnHigh); highlightFilterTab(tabBtnHigh); fetchAndShowServers("Desc", false, "📈 DANH SÁCH SV ĐÔNG NGƯỜI") end)
    tabBtnPing.MouseButton1Click:Connect(function() clickAnimate(tabBtnPing); highlightFilterTab(tabBtnPing); fetchAndShowServers("Asc", true, "⚡ DANH SÁCH SV PING THẤP") end)

    btnSaveSv.MouseButton1Click:Connect(function()
        clickAnimate(btnSaveSv)
        if game.JobId == "" then MakeToast("Lỗi", "Không lấy được JobId của server này!", Theme.AccentOff); return end
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
                hp = math.floor(hum.Health); maxHp = math.max(1, math.floor(hum.MaxHealth))
                ws = math.floor(hum.WalkSpeed); jp = math.floor(hum.JumpPower)
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
            player.DisplayName, player.Name, player.UserId, player.AccountAge,
            hpHex, hp, maxHp, math.floor(hpRatio * 100), ws, jp, coords
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
        for _, v in pairs(State) do if v == true then activeCount = activeCount + 1 end end

        bFpsVal.Text = tostring(fps); bFpsVal.TextColor3 = Color3.fromHex(fpsHex)
        bPingVal.Text = pingNum .. " ms"; bPingVal.TextColor3 = Color3.fromHex(pingHex)
        bPlrVal.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
        bActVal.Text = tostring(activeCount)

        svBody.Text = string.format(
            "<font color='#78B4DC'>• Tựa game:</font> <font color='#D8B870'>%s</font>\n" ..
            "<font color='#78B4DC'>• PlaceId:</font> %d   |   <font color='#78B4DC'>Người chơi:</font> %d / %d\n" ..
            "<font color='#78B4DC'>• ID Server:</font> <font color='#909AA8'>%s</font>",
            utf8SafeTruncate(gameName, 26), game.PlaceId, #Players:GetPlayers(), Players.MaxPlayers, shortJob
        )

        local execTime = math.floor(workspace.DistributedGameTime)
        local h = math.floor(execTime / 3600)
        local m = math.floor((execTime % 3600) / 60)
        local s = execTime % 60

        sysBody.Text = string.format(
            "<font color='#78B4DC'>• Executor:</font> <font color='#38CC88'>%s</font>   |   <font color='#78B4DC'>Phiên bản:</font> <font color='#E09F67'>V1.18.0</font>\n" ..
            "<font color='#78B4DC'>• Treo máy:</font> %02d:%02d:%02d   |   <font color='#78B4DC'>Giờ hệ thống:</font> %s",
            execName, h, m, s, os.date("%H:%M:%S")
        )
    end

    updateTab1Stats()
    task.spawn(function()
        while task.wait(0.5) do
            if page1.Visible then updateTab1Stats() end
        end
    end)
end
-- ==========================================
-- [HỆ THỐNG AUTO CLICK, AUTO COLLECT, MAGNET & MINI HUD]
-- ==========================================
do
task.spawn(function()
    while task.wait(0.1) do
        if State.AutoClick and player.Character then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end)
        end
    end
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

task.spawn(function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then table.insert(cachedPrompts, obj) end
    end
end)
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then table.insert(cachedPrompts, obj) end
end)

local originalPrompts = {}
task.spawn(function()
    while task.wait(1) do
        if State.Instant then
            for i = #cachedPrompts, 1, -1 do
                local prompt = cachedPrompts[i]
                if prompt.Parent then
                    if not originalPrompts[prompt] then
                        originalPrompts[prompt] = {HoldDuration = prompt.HoldDuration, MaxActivationDistance = prompt.MaxActivationDistance}
                    end
                    prompt.HoldDuration = 0; prompt.MaxActivationDistance = 25
                else
                    table.remove(cachedPrompts, i)
                end
            end
        elseif next(originalPrompts) then
            for prompt, data in pairs(originalPrompts) do
                if prompt and prompt.Parent then
                    prompt.HoldDuration = data.HoldDuration
                    prompt.MaxActivationDistance = data.MaxActivationDistance
                end
            end
            originalPrompts = {}
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
                        if prompt.Parent and prompt.Parent:IsA("BasePart") and prompt.Enabled and (prompt.Parent.Position - rootPos).Magnitude <= 50 then
                            if fireproximityprompt then fireproximityprompt(prompt) end
                        end
                    end
                    local overlapParams = OverlapParams.new()
                    overlapParams.FilterDescendantsInstances = {player.Character}
                    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
                    local partsNearby = workspace:GetPartBoundsInRadius(rootPos, 50, overlapParams)
                    for _, part in ipairs(partsNearby) do
                        if part.Name == "Handle" and part.Parent and part.Parent:IsA("Tool") then
                            part.CanCollide = false
                            if firetouchinterest then
                                firetouchinterest(root, part, 0); task.wait(0.01); firetouchinterest(root, part, 1)
                            else
                                part.CFrame = root.CFrame
                            end
                        end
                    end
                end
            end
        end)
    end
end)

local magnetKeywords = {"coin", "gem", "orb", "diamond", "cash", "money", "yen", "token", "drop", "star", "crystal", "gold", "silver", "emerald"}
local function isMagnetItem(part)
    if not part:IsA("BasePart") or (part.Anchored and part.Size.Magnitude > 8) then return false end
    local name = string.lower(part.Name)
    local pName = part.Parent and string.lower(part.Parent.Name) or ""
    for _, kw in ipairs(magnetKeywords) do
        if string.find(name, kw, 1, true) or string.find(pName, kw, 1, true) then return true end
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

-- ==========================================
-- [ESP NGƯỜI CHƠI + ESP ĐIỂM LƯU TP SAVE + HITBOX]
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
                    hrp.Transparency = 0.5; hrp.CanCollide = false; hrp.Massless = true
                end
            end
        end
    elseif next(originalHitboxSizes) then
        for p, size in pairs(originalHitboxSizes) do
            if p and p.Character then
                local hrp = getUniversalRoot(p.Character)
                if hrp then hrp.Size = size; hrp.Transparency = 1; hrp.Massless = false end
            end
        end
        originalHitboxSizes = {}
    end

    local myRoot = getUniversalRoot(player.Character)
    local myPos = myRoot and myRoot.Position or (workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position)

    -- Cập nhật ESP Điểm Lưu (TP Save Waypoints)
    if #savedTpList > 0 then
        for idx, item in ipairs(savedTpList) do
            if item.cframe then
                local cf = CFrame.new(unpack(item.cframe))
                local pos = cf.Position
                if not SavedTpESPs[idx] then
                    local anchor = Instance.new("Part")
                    anchor.Name = "TpSaveAnchor_" .. idx; anchor.Size = Vector3.new(1.2, 1.2, 1.2)
                    anchor.Shape = Enum.PartType.Ball; anchor.Material = Enum.Material.Neon
                    anchor.Color = Color3.fromRGB(64, 235, 150); anchor.Transparency = 0.25
                    anchor.Anchored = true; anchor.CanCollide = false; anchor.CanQuery = false; anchor.CanTouch = false
                    anchor.Parent = workspace

                    local bgui = Instance.new("BillboardGui")
                    bgui.Name = "TpSaveESP_" .. idx; bgui.Size = UDim2.new(0, 180, 0, 40)
                    bgui.StudsOffset = Vector3.new(0, 2.5, 0); bgui.AlwaysOnTop = true
                    bgui.MaxDistance = math.huge; bgui.LightInfluence = 0; bgui.Adornee = anchor; bgui.Parent = guiParent

                    local lbl = Instance.new("TextLabel", bgui)
                    lbl.Name = "WaypointLabel"; lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(72, 245, 160)
                    lbl.TextStrokeTransparency = 0.15; lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.RichText = true

                    SavedTpESPs[idx] = {Anchor = anchor, Billboard = bgui, Label = lbl}
                end
                local espObj = SavedTpESPs[idx]
                if espObj and espObj.Anchor and espObj.Label then
                    espObj.Anchor.Position = pos
                    local dist = myPos and math.floor((myPos - pos).Magnitude) or 0
                    espObj.Label.Text = "📍 " .. item.name .. '\n<font color="#FFE066">[' .. dist .. 'm]</font>'
                end
            end
        end
        for idx, obj in pairs(SavedTpESPs) do
            if idx > #savedTpList then
                if obj.Anchor then obj.Anchor:Destroy() end
                if obj.Billboard then obj.Billboard:Destroy() end
                SavedTpESPs[idx] = nil
            end
        end
    elseif next(SavedTpESPs) then
        if clearSavedTpESPs then clearSavedTpESPs() end
    end

    if not State.ESP then
        for p, _ in pairs(ActiveESPs) do clearSingleESP(p) end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            pcall(function()
                local tChar = p.Character
                if not tChar then clearSingleESP(p); return end

                local espPart = getUniversalRoot(tChar)
                local targetCF = getCharacterCFrame(tChar)
                if not targetCF then clearSingleESP(p); return end
                local targetPos = targetCF.Position

                if not ActiveESPs[p] then ActiveESPs[p] = {} end
                local data = ActiveESPs[p]

                if not espPart then
                    if not data.Anchor or not data.Anchor.Parent then
                        local anchor = Instance.new("Part")
                        anchor.Name = "ESPAnchor_" .. p.Name; anchor.Size = Vector3.new(1, 1, 1)
                        anchor.Transparency = 1; anchor.Anchored = true; anchor.CanCollide = false
                        anchor.CanQuery = false; anchor.CanTouch = false; anchor.Parent = workspace
                        data.Anchor = anchor
                    end
                    data.Anchor.Position = targetPos
                    espPart = data.Anchor
                elseif data.Anchor then
                    data.Anchor:Destroy(); data.Anchor = nil
                end

                if not data.Billboard or not data.Billboard.Parent then
                    local bgui = Instance.new("BillboardGui")
                    bgui.Name = "MobileESP_" .. p.Name; bgui.Size = UDim2.new(0, 200, 0, 50)
                    bgui.StudsOffset = Vector3.new(0, 3.5, 0); bgui.AlwaysOnTop = true
                    bgui.MaxDistance = math.huge; bgui.LightInfluence = 0; bgui.Parent = guiParent

                    local tLabel = Instance.new("TextLabel", bgui)
                    tLabel.Name = "NameLabel"; tLabel.Size = UDim2.new(1, 0, 1, 0)
                    tLabel.BackgroundTransparency = 1; tLabel.TextColor3 = Color3.fromRGB(255, 75, 85)
                    tLabel.TextStrokeTransparency = 0.15; tLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    tLabel.Font = Enum.Font.GothamBold; tLabel.TextSize = 12; tLabel.RichText = true
                    data.Billboard = bgui
                end
                data.Billboard.Adornee = espPart

                if not data.Highlight or not data.Highlight.Parent then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESPHighlight_" .. p.Name; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillColor = Color3.fromRGB(255, 65, 75); hl.FillTransparency = 0.65
                    hl.OutlineColor = Color3.new(1, 1, 1); hl.OutlineTransparency = 0.1; hl.Parent = guiParent
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
        if not Players:FindFirstChild(p.Name) then clearSingleESP(p) end
    end
end

task.spawn(function()
    while task.wait(0.1) do updateESP_Hitbox() end
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
                if cam.CameraSubject ~= targetHum then cam.CameraSubject = targetHum end
            else
                if not spectateProxyPart or not spectateProxyPart.Parent then
                    spectateProxyPart = Instance.new("Part")
                    spectateProxyPart.Name = "VipSpectateProxy"; spectateProxyPart.Size = Vector3.new(1, 1, 1)
                    spectateProxyPart.Transparency = 1; spectateProxyPart.Anchored = true
                    spectateProxyPart.CanCollide = false; spectateProxyPart.CanQuery = false
                    spectateProxyPart.CanTouch = false; spectateProxyPart.Parent = workspace
                end
                spectateProxyPart.CFrame = targetCF
                pcall(function() player.ReplicationFocus = spectateProxyPart end)
                if cam.CameraSubject ~= spectateProxyPart then cam.CameraSubject = spectateProxyPart end
                if tick() - lastSpectateStreamTick > 0.5 then
                    lastSpectateStreamTick = tick()
                    local streamPos = targetCF.Position
                    task.spawn(function() pcall(function() player:RequestStreamAroundAsync(streamPos, 3) end) end)
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
                bv.Name = "FlyBodyVelocity"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.zero; bv.Parent = root
            end

            local bg = root:FindFirstChild("FlyBodyGyro")
            if not bg then
                bg = Instance.new("BodyGyro")
                bg.Name = "FlyBodyGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.P = 10000; bg.D = 100; bg.Parent = root
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
                bv.Velocity = flyDir.Magnitude > 0.001 and (flyDir.Unit * State.FlySpeed) or Vector3.zero
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
        elseif light then
            light:Destroy()
        end
    end

    if State.Reach then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                if not originalToolSizes[tool] then originalToolSizes[tool] = handle.Size end
                handle.Size = Vector3.new(State.ReachSize, State.ReachSize, State.ReachSize)
                handle.Massless = true; handle.CanCollide = false; handle.Transparency = 0.8
            end
        end
    elseif next(originalToolSizes) then
        for t, origSize in pairs(originalToolSizes) do
            if t and t.Parent and t:FindFirstChild("Handle") then
                t.Handle.Size = origSize; t.Handle.Massless = false; t.Handle.Transparency = 0
            end
        end
        originalToolSizes = {}
    end
end)
end
