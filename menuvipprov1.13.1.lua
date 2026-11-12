-- ==========================================
-- MENU VIP PRO MAX V1.13.2 (FIX FULL TAB 7 + FLY V2)
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

local player = Players.LocalPlayer

local State = {
    Instant = false, Noclip = false, LowGfx = false, Speed = false, Jump = false,
    InfJump = false, PlayerLight = false, ESP = false, AntiAfk = true, AntiStun = false,
    XRay = false, LockPosition = false, AutoCollect = false, Fly = false, FlySpeed = 50,
    SpinBot = false, SpinSpeed = 50, Hitbox = false, HitboxSize = 15, AutoClick = false, RGB = false,
    Reach = false, ReachSize = 15, AutoDash = false, DashSpeed = 10, AutoSave = false,
    ShiftLock = false, SpeedValue = 60, JumpValue = 120, LightRange = 60, LightBrightness = 3,
    MusicVolume = 5, LightColorIdx = 1, NoFog = false,
    FpsCapValue = 60, Disable3D = false, AfkModeScreen = false,
    HidePlayers = false, OptimizeTerrain = false, NoShadows = false,
    AutoSkillZ = false, AutoSkillX = false, AutoSkillC = false, AutoSkillV = false, AutoSkillE = false, AutoSkillF = false,
    AutoSkill1 = false, AutoSkill2 = false, AutoSkill3 = false, AutoSkill4 = false, AutoSkill5 = false, AutoSkill6 = false,
    TpPositionIdx = 1, TpDistance = 4
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
    {Name = "Sau lưng", GetOffset = function(d) return CFrame.new(0, 0, d) end},
    {Name = "Trước mặt", GetOffset = function(d) return CFrame.new(0, 0, -d) * CFrame.Angles(0, math.pi, 0) end},
    {Name = "Trên đầu", GetOffset = function(d) return CFrame.new(0, d, 0) * CFrame.Angles(math.rad(-90), 0, 0) end},
    {Name = "Dưới chân", GetOffset = function(d) return CFrame.new(0, -d, 0) * CFrame.Angles(math.rad(90), 0, 0) end}
}

local RGBElements, ActiveESPs, originalHitboxSizes, originalToolSizes, cachedPrompts, xrayMats, OriginalGFX = {}, {}, {}, {}, {}, {}, {}

local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
    if gethui and type(gethui) == "function" then
        guiParent = gethui() or guiParent
    elseif game:GetService("CoreGui") then
        guiParent = game:GetService("CoreGui")
    end
end)

for _, v in pairs(guiParent:GetChildren()) do
    if v.Name == "MenuVipProMax" or v.Name == "MobileProMax" then v:Destroy() end
end

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

local gui = Instance.new("ScreenGui", guiParent)
gui.Name = "MenuVipProMax"; gui.ResetOnSpawn = false; gui.DisplayOrder = 99999; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local notifGui = Instance.new("Frame", gui)
notifGui.Size = UDim2.new(0, 190, 0.8, 0); notifGui.Position = UDim2.new(1, -200, 0.1, 0); notifGui.BackgroundTransparency = 1; notifGui.ZIndex = 9999
local notifLayout = Instance.new("UIListLayout", notifGui)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder; notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; notifLayout.Padding = UDim.new(0, 6)

local function MakeToast(title, desc, color)
    local toast = Instance.new("Frame", notifGui)
    toast.Size = UDim2.new(1, 0, 0, 44); toast.BackgroundColor3 = Theme.ItemBg; toast.BackgroundTransparency = 0.1
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", toast); stroke.Color = color; stroke.Thickness = 1.2
    local colorBar = Instance.new("Frame", toast)
    colorBar.Size = UDim2.new(0, 3, 1, -12); colorBar.Position = UDim2.new(0, 6, 0, 6); colorBar.BackgroundColor3 = color; colorBar.BorderSizePixel = 0
    Instance.new("UICorner", colorBar).CornerRadius = UDim.new(1, 0)
    local tLabel = Instance.new("TextLabel", toast)
    tLabel.Size = UDim2.new(1, -24, 0, 16); tLabel.Position = UDim2.new(0, 16, 0, 5); tLabel.BackgroundTransparency = 1; tLabel.Text = title; tLabel.TextColor3 = color; tLabel.Font = Enum.Font.GothamBold; tLabel.TextSize = 11; tLabel.TextXAlignment = Enum.TextXAlignment.Left
    local dLabel = Instance.new("TextLabel", toast)
    dLabel.Size = UDim2.new(1, -24, 0, 16); dLabel.Position = UDim2.new(0, 16, 0, 22); dLabel.BackgroundTransparency = 1; dLabel.Text = desc; dLabel.TextColor3 = Theme.TextTitle; dLabel.Font = Enum.Font.Gotham; dLabel.TextSize = 10; dLabel.TextXAlignment = Enum.TextXAlignment.Left
    task.delay(2, function() toast:Destroy() end)
end

local screenOverlay = Instance.new("Frame", gui)
screenOverlay.Size = UDim2.new(2, 0, 2, 0); screenOverlay.Position = UDim2.new(-0.5, 0, -0.5, 0); screenOverlay.BackgroundColor3 = Color3.new(0,0,0); screenOverlay.ZIndex = 0; screenOverlay.Visible = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 40, 0, 40); openBtn.Position = UDim2.new(0, 15, 0.25, 0); openBtn.Text = "🇻🇳"; openBtn.BackgroundColor3 = Theme.MainBg; openBtn.BackgroundTransparency = 0.25; openBtn.TextColor3 = Theme.Brand; openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 19; openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke", openBtn); openStroke.Color = Theme.Brand; openStroke.Thickness = 1.8; openStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local function clickAnimate(obj)
    local scale = Instance.new("UIScale", obj)
    TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 0.92}):Play()
    task.wait(0.1)
    TweenService:Create(scale, TweenInfo.new(0.15), {Scale = 1}):Play()
    task.delay(0.2, function() scale:Destroy() end)
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
frame.Size = UDim2.new(0, 350, 0, 305); frame.Position = UDim2.new(0.5, -175, 0.5, -152); frame.BackgroundColor3 = Theme.MainBg; frame.BackgroundTransparency = 0.05; frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
local frameStroke = Instance.new("UIStroke", frame); frameStroke.Color = Theme.Stroke; frameStroke.Thickness = 1.8
table.insert(RGBElements, {Type = "Frame", Stroke = frameStroke})

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 32); header.BackgroundColor3 = Theme.HeaderBg; header.BorderSizePixel = 0; header.ZIndex = 10
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)
local headerCover = Instance.new("Frame", header)
headerCover.Size = UDim2.new(1, 0, 0, 10); headerCover.Position = UDim2.new(0, 0, 1, -10); headerCover.BackgroundColor3 = Theme.HeaderBg; headerCover.BorderSizePixel = 0; headerCover.ZIndex = 10
local headerStroke = Instance.new("UIStroke", header); headerStroke.Color = Theme.Stroke; headerStroke.Thickness = 1.2; headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
table.insert(RGBElements, {Type = "Header", Stroke = headerStroke})

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, 0, 1, 0); titleLabel.BackgroundTransparency = 1; titleLabel.Text = "MENU VIP PRO MAX"; titleLabel.TextColor3 = Theme.TextTitle; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 13; titleLabel.ZIndex = 10

local avatarImg = Instance.new("ImageLabel", header)
avatarImg.Size = UDim2.new(0, 22, 0, 22); avatarImg.Position = UDim2.new(0, 10, 0.5, -11); avatarImg.BackgroundTransparency = 1; avatarImg.ZIndex = 10
pcall(function() avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
local avatarStroke = Instance.new("UIStroke", avatarImg); avatarStroke.Color = Theme.Brand; avatarStroke.Thickness = 1.2

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

local tabBar = Instance.new("ScrollingFrame", frame)
tabBar.Size = UDim2.new(1, 0, 0, 28); tabBar.Position = UDim2.new(0, 0, 0, 32); tabBar.BackgroundColor3 = Theme.TabBg; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 10; tabBar.ScrollBarThickness = 0; tabBar.ScrollingDirection = Enum.ScrollingDirection.X; tabBar.ClipsDescendants = true
local tabLayout = Instance.new("UIListLayout", tabBar); tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0) end)

local function createTab(name, width)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0, width, 1, 0); btn.Text = name; btn.BackgroundTransparency = 1; btn.TextColor3 = Theme.TextDim; btn.BorderSizePixel = 0; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8; btn.ZIndex = 10
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0.5, 0, 0, 2); indicator.Position = UDim2.new(0.25, 0, 1, -2); indicator.BackgroundColor3 = Theme.Brand; indicator.BorderSizePixel = 0; indicator.Visible = false; indicator.ZIndex = 10
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
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

local pageContainer = Instance.new("Frame", frame)
pageContainer.Size = UDim2.new(1, 0, 1, -62); pageContainer.Position = UDim2.new(0, 0, 0, 61); pageContainer.BackgroundTransparency = 1; pageContainer.ZIndex = 10

local function createPage()
    local pg = Instance.new("ScrollingFrame", pageContainer)
    pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1; pg.ScrollBarThickness = 4; pg.ScrollBarImageColor3 = Theme.Brand; pg.Visible = false; pg.BorderSizePixel = 0; pg.ZIndex = 10
    local layout = Instance.new("UIListLayout", pg); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 6); layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", pg); pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 16)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30) end)
    return pg
end

local function createFixedPage()
    local pg = Instance.new("Frame", pageContainer)
    pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1; pg.Visible = false; pg.ZIndex = 10
    local l = Instance.new("UIListLayout", pg); l.HorizontalAlignment = Enum.HorizontalAlignment.Center; l.Padding = UDim.new(0, 5); l.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", pg).PaddingTop = UDim.new(0, 5)
    return pg
end

local page1, page2, page3, page4, page8, page9 = createPage(), createPage(), createPage(), createPage(), createPage(), createPage()
local page5, page6, page7 = createFixedPage(), createFixedPage(), createFixedPage()

local function showTab(pg, tb, ind)
    for _, p in pairs({page1, page2, page3, page4, page5, page6, page7, page8, page9}) do p.Visible = false end
    for _, t in pairs({tab1, tab2, tab3, tab4, tab5, tab6, tab7, tab8, tab9}) do t.TextColor3 = Theme.TextDim end
    for _, i in pairs({ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8, ind9}) do i.Visible = false end
    pg.Visible = true; tb.TextColor3 = Theme.TextTitle; ind.Visible = true
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
    if not State.RGB then openStroke.Color = opened and Theme.AccentOff or Theme.Brand end
    frame:TweenPosition(opened and UDim2.new(0.5, -175, 0.5, -152) or UDim2.new(0.5, -175, 1.2, 0), "Out", "Back", 0.45)
end)

local function getUniversalRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char.PrimaryPart or char:FindFirstChildWhichIsA("BasePart")
end

local function createDivider(parent, text)
    local dFrame = Instance.new("Frame", parent); dFrame.Size = UDim2.new(0.92, 0, 0, 15); dFrame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", dFrame); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = "─── " .. text .. " ───"; label.TextColor3 = Theme.Brand; label.Font = Enum.Font.GothamBold; label.TextSize = 10
    return dFrame
end

local function createCycleBtn(parent, prefix, options, stateVar)
    local btnFrame = Instance.new("Frame", parent); btnFrame.Size = UDim2.new(0.92, 0, 0, 32); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = Theme.Brand; stroke.Thickness = 1.2; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = Theme.Brand})
    local title = Instance.new("TextLabel", btn); title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.TextColor3 = Theme.Brand; title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.ZIndex = 10
    local function updateText() title.Text = prefix .. " < " .. (options[State[stateVar]] or options[1]).Name .. " >" end
    updateText()
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); State[stateVar] = (State[stateVar] % #options) + 1; updateText()
        if State.AutoSave then saveConfig() end
    end)
    return btnFrame
end

local function createToggle(parent, text, varName, callback)
    local btnFrame = Instance.new("Frame", parent); btnFrame.Size = UDim2.new(0.92, 0, 0, 34); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame); btn.Size = UDim2.new(1, 0, 1, 0); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 1.2
    local title = Instance.new("TextLabel", btn); title.Size = UDim2.new(0.74, 0, 1, 0); title.Position = UDim2.new(0.04, 0, 0, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = Theme.TextTitle; title.Font = Enum.Font.GothamSemibold; title.TextSize = 11.5; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local status = Instance.new("TextLabel", btn); status.Size = UDim2.new(0.18, 0, 1, 0); status.Position = UDim2.new(0.78, 0, 0, 0); status.BackgroundTransparency = 1; status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Right; status.ZIndex = 10
    local active = State[varName] or false
    status.Text = active and "ON" or "OFF"; status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
    stroke.Color = active and Theme.AccentOn or Theme.Stroke
    btn.BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg
    table.insert(RGBElements, {Type = "Toggle", Stroke = stroke, State = function() return State[varName] end})
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); State[varName] = not State[varName]; active = State[varName]
        status.Text = active and "ON" or "OFF"; status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
        if not State.RGB then stroke.Color = active and Theme.AccentOn or Theme.Stroke end
        btn.BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg
        if varName ~= "AutoSave" then MakeToast(active and "Đã Bật" or "Đã Tắt", text, active and Theme.AccentOn or Theme.AccentOff); if State.AutoSave then saveConfig() end end
        if callback then callback(active) end
    end)
    if active and callback then task.spawn(callback, active) end
    return btnFrame
end

local function createButton(parent, text, color, callback)
    local btnFrame = Instance.new("Frame", parent); btnFrame.Size = UDim2.new(0.92, 0, 0, 32); btnFrame.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", btnFrame); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = color; stroke.Thickness = 1.2; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = color})
    local title = Instance.new("TextLabel", btn); title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = color; title.Font = Enum.Font.GothamBold; title.TextSize = 11.5; title.ZIndex = 10
    btn.MouseButton1Click:Connect(function() clickAnimate(btn); MakeToast("Đã thực thi", text, color); callback() end)
    return btnFrame
end

local function createDualButtons(parent, text1, color1, cb1, text2, color2, cb2)
    local dFrame = Instance.new("Frame", parent); dFrame.Size = UDim2.new(0.92, 0, 0, 32); dFrame.BackgroundTransparency = 1
    local function makeBtn(xPos, txt, col, cb)
        local btn = Instance.new("TextButton", dFrame); btn.Size = UDim2.new(0.485, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn); stroke.Color = col; stroke.Thickness = 1.2; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(RGBElements, {Type = "Button", Stroke = stroke, DefaultColor = col})
        local title = Instance.new("TextLabel", btn); title.Size = UDim2.new(1, 0, 1, 0); title.BackgroundTransparency = 1; title.Text = txt; title.TextColor3 = col; title.Font = Enum.Font.GothamBold; title.TextSize = 10; title.ZIndex = 10
        btn.MouseButton1Click:Connect(function() clickAnimate(btn); if txt ~= "🗑️ XÓA TẤT CẢ" then MakeToast("Đã thực thi", txt, col) end; cb() end)
    end
    makeBtn(0, text1, color1, cb1); makeBtn(0.515, text2, color2, cb2)
    return dFrame
end

local function createSlider(parent, text, min, max, varName, callback)
    local sFrame = Instance.new("Frame", parent); sFrame.Size = UDim2.new(0.92, 0, 0, 38); sFrame.BackgroundTransparency = 1
    local bg = Instance.new("Frame", sFrame); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Theme.ItemBg; bg.ZIndex = 10
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", bg); stroke.Color = Theme.Stroke; stroke.Thickness = 1.2
    table.insert(RGBElements, {Type = "Slider", Stroke = stroke})
    local titleLabel = Instance.new("TextLabel", bg); titleLabel.Size = UDim2.new(0.7, 0, 0.45, 0); titleLabel.Position = UDim2.new(0.04, 0, 0.08, 0); titleLabel.BackgroundTransparency = 1; titleLabel.Text = text; titleLabel.TextColor3 = Theme.TextDim; titleLabel.Font = Enum.Font.GothamSemibold; titleLabel.TextSize = 11; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.ZIndex = 10
    local valLabel = Instance.new("TextLabel", bg); valLabel.Size = UDim2.new(0.25, 0, 0.45, 0); valLabel.Position = UDim2.new(0.71, 0, 0.08, 0); valLabel.BackgroundTransparency = 1; valLabel.Text = tostring(State[varName]); valLabel.TextColor3 = Theme.Brand; valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 11; valLabel.TextXAlignment = Enum.TextXAlignment.Right; valLabel.ZIndex = 10
    local track = Instance.new("Frame", bg); track.Size = UDim2.new(0.92, 0, 0.18, 0); track.Position = UDim2.new(0.04, 0, 0.64, 0); track.BackgroundColor3 = Theme.MainBg; track.ZIndex = 10
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track); fill.Size = UDim2.new(math.clamp((State[varName] - min) / (max - min), 0, 1), 0, 1, 0); fill.BackgroundColor3 = Theme.AccentOn; fill.ZIndex = 10
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        valLabel.Text = tostring(value); fill.Size = UDim2.new(pos, 0, 1, 0)
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
            local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            titleLabel.TextColor3 = color; frameStroke.Color = color; headerStroke.Color = color; avatarStroke.Color = color; openStroke.Color = color
            for _, obj in pairs(RGBElements) do if obj.Stroke and obj.Stroke.Parent then obj.Stroke.Color = color end end
        end
    end
end)

-- ==========================================
-- [TAB 1: THÔNG TIN]
-- ==========================================
local function createInfoBox(parent, icon, titleText, heightOffset)
    local item = Instance.new("Frame", parent); item.Size = UDim2.new(0.92, 0, 0, heightOffset or 90); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", item); stroke.Color = Theme.Stroke; stroke.Thickness = 1.2; table.insert(RGBElements, {Type = "Info", Stroke = stroke})
    local title = Instance.new("TextLabel", item); title.Size = UDim2.new(1, -16, 0, 20); title.Position = UDim2.new(0, 8, 0, 4); title.BackgroundTransparency = 1; title.Text = icon .. " " .. titleText; title.TextColor3 = Theme.Brand; title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local content = Instance.new("TextLabel", item); content.Size = UDim2.new(1, -16, 1, -26); content.Position = UDim2.new(0, 8, 0, 24); content.BackgroundTransparency = 1; content.Text = "Đang tải..."; content.TextColor3 = Theme.TextTitle; content.Font = Enum.Font.Gotham; content.TextSize = 10.5; content.TextXAlignment = Enum.TextXAlignment.Left; content.TextYAlignment = Enum.TextYAlignment.Top; content.RichText = true; content.ZIndex = 10
    return content, item
end

local playerInfoLabel = createInfoBox(page1, "👤", "THÔNG TIN NHÂN VẬT", 104)
local serverInfoLabel, serverInfoFrame = createInfoBox(page1, "🌐", "THÔNG TIN MÁY CHỦ", 90)

local copyIdBtn = Instance.new("TextButton", serverInfoFrame)
copyIdBtn.Size = UDim2.new(0, 22, 0, 22); copyIdBtn.Position = UDim2.new(1, -26, 1, -24); copyIdBtn.Text = "📜"; copyIdBtn.BackgroundTransparency = 1; copyIdBtn.TextSize = 13; copyIdBtn.ZIndex = 11
copyIdBtn.MouseButton1Click:Connect(function()
    clickAnimate(copyIdBtn)
    pcall(function() if setclipboard then setclipboard(tostring(game.JobId)); MakeToast("Đã Copy", "Đã lưu ID Server", Theme.AccentOn) end end)
end)

local joinIdFrame = Instance.new("Frame", page1); joinIdFrame.Size = UDim2.new(0.92, 0, 0, 34); joinIdFrame.BackgroundColor3 = Theme.ItemBg; joinIdFrame.ZIndex = 10
Instance.new("UICorner", joinIdFrame).CornerRadius = UDim.new(0, 8)
local jStroke = Instance.new("UIStroke", joinIdFrame); jStroke.Color = Theme.Stroke; jStroke.Thickness = 1.2; table.insert(RGBElements, {Type = "Info", Stroke = jStroke})
local idBox = Instance.new("TextBox", joinIdFrame); idBox.Size = UDim2.new(0.65, 0, 1, 0); idBox.Position = UDim2.new(0.04, 0, 0, 0); idBox.BackgroundTransparency = 1; idBox.PlaceholderText = "Dán ID Server vào đây..."; idBox.Text = ""; idBox.TextColor3 = Theme.Brand; idBox.Font = Enum.Font.Gotham; idBox.TextSize = 10.5; idBox.TextXAlignment = Enum.TextXAlignment.Left; idBox.ClearTextOnFocus = false; idBox.ZIndex = 10
local joinBtn = Instance.new("TextButton", joinIdFrame); joinBtn.Size = UDim2.new(0.25, 0, 0.7, 0); joinBtn.Position = UDim2.new(0.72, 0, 0.15, 0); joinBtn.BackgroundColor3 = Theme.AccentOn; joinBtn.Text = "VÀO"; joinBtn.TextColor3 = Color3.new(1, 1, 1); joinBtn.Font = Enum.Font.GothamBold; joinBtn.TextSize = 10.5; joinBtn.ZIndex = 10
Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 6)
joinBtn.MouseButton1Click:Connect(function() clickAnimate(joinBtn); local targetId = idBox.Text:gsub("%s+", ""); if targetId ~= "" then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player) end) end end)

local extraInfoLabel = createInfoBox(page1, "⚙️", "TRẠNG THÁI", 78)
local fps = 0; RunService.RenderStepped:Connect(function(dt) fps = math.floor(1/dt) end)

task.spawn(function()
    while task.wait(0.5) do
        local hp, maxHp, ws, jp, coords = 0, 0, 0, 0, "0, 0, 0"
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid; hp = math.floor(hum.Health); maxHp = math.floor(hum.MaxHealth); ws = math.floor(hum.WalkSpeed); jp = math.floor(hum.JumpPower)
        end
        if player.Character then
            local root = getUniversalRoot(player.Character)
            if root then local pos = root.Position; coords = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z) end
        end
        playerInfoLabel.Text = string.format("<font color='#FF00FF'>Tên:</font> %s (@%s)\n<font color='#FF00FF'>Máu:</font> %d / %d\n<font color='#FF00FF'>Tốc độ:</font> %d\n<font color='#FF00FF'>Lực nhảy:</font> %d\n<font color='#FF00FF'>Tọa độ:</font> %s", player.DisplayName, player.Name, hp, maxHp, ws, jp, coords)
        local ping = "0"
        pcall(function() ping = tostring(math.floor(player:GetNetworkPing() * 1000)) .. " ms" end)
        local jobText = game.JobId ~= "" and string.sub(game.JobId, 1, 14).."..." or "N/A"
        serverInfoLabel.Text = string.format("<font color='#FF00FF'>FPS:</font> %d\n<font color='#FF00FF'>Ping:</font> %s\n<font color='#FF00FF'>Người chơi:</font> %d / %d\n<font color='#FF00FF'>ID SV:</font> %s", fps, ping, #Players:GetPlayers(), Players.MaxPlayers, jobText)
        local execTime = math.floor(workspace.DistributedGameTime)
        extraInfoLabel.Text = string.format("<font color='#FF00FF'>Thời gian chơi:</font> %02d:%02d:%02d\n<font color='#FF00FF'>Giờ hệ thống:</font> %s\n<font color='#FF00FF'>Phiên bản:</font> VIP PRO MAX V1.13.2", math.floor(execTime / 3600), math.floor((execTime % 3600) / 60), execTime % 60, os.date("%H:%M:%S"))
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
            for _, part in ipairs(player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
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
                if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) and obj.Name ~= "Terrain" and obj.Transparency < 1 then
                    if not xrayMats[obj] then xrayMats[obj] = obj.Transparency end; obj.Transparency = 0.5
                end
                if i % 300 == 0 then task.wait() end
            end
        else
            for obj, origTrans in pairs(xrayMats) do if obj and obj.Parent then obj.Transparency = origTrans end end
            xrayMats = {}
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
        local root = getUniversalRoot(char); local hum = char:FindFirstChildOfClass("Humanoid")
        if not v then
            if root and root:FindFirstChild("FlyBodyVelocity") then root.FlyBodyVelocity:Destroy() end
            if root and root:FindFirstChild("FlyBodyGyro") then root.FlyBodyGyro:Destroy() end
            if hum then hum.PlatformStand = false end
        end
    end
end)
createSlider(page3, "Tốc độ bay", 10, 1000, "FlySpeed")
createToggle(page3, "🏃 Chạy nhanh", "Speed")
createSlider(page3, "Tốc độ chạy", 1, 1000, "SpeedValue")
local defaultJumpPower = 50
createToggle(page3, "🦘 Nhảy cao", "Jump", function(v)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if v then defaultJumpPower = player.Character.Humanoid.JumpPower else player.Character.Humanoid.JumpPower = defaultJumpPower end
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
createToggle(page3, "💡 Ánh sáng quanh người", "PlayerLight", function(v) if not v and player.Character then local r = getUniversalRoot(player.Character); if r and r:FindFirstChild("PlayerPointLight") then r.PlayerPointLight:Destroy() end end end)
createSlider(page3, "Phạm vi sáng (Max 60)", 0, 60, "LightRange")
createSlider(page3, "Độ sáng", 0, 5, "LightBrightness")
createCycleBtn(page3, "🎨 Đổi màu:", PlayerLightColors, "LightColorIdx")

-- ==========================================
-- [TAB 4: TIỆN ÍCH (CÓ FLY V2)]
-- ==========================================
createToggle(page4, "💾 Lưu Cài Đặt", "AutoSave", function(v)
    if v then saveConfig() else pcall(function() if isfile and isfile(configFileName) then delfile(configFileName) end end) end
end)
createToggle(page4, "🌈 Chế độ RGB", "RGB")
createToggle(page4, "💫 Mở khóa ShiftLock Mobile", "ShiftLock", function(v) pcall(function() player.DevEnableMouseLock = v end) end)
createToggle(page4, "🖱️ Auto Click", "AutoClick")
task.spawn(function()
    while task.wait(0.1) do
        if State.AutoClick and player.Character then pcall(function() local t = player.Character:FindFirstChildOfClass("Tool"); if t then t:Activate() end end) end
    end
end)
createToggle(page4, "🛡️ Chống AFK (Antiafk)", "AntiAfk")
player.Idled:Connect(function()
    if State.AntiAfk then pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end
end)

local function hopServer(sortOrder)
    pcall(function()
        local res = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=100"))
        for _, s in pairs(res.data or {}) do
            if s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player); break
            end
        end
    end)
end
local function rejoinServer() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end

createDualButtons(page4, "☀️ TRỜI SÁNG", Color3.fromRGB(255, 200, 50), function() Lighting.ClockTime = 12; Lighting.Brightness = 2 end, "🌙 TRỜI TỐI", Color3.fromRGB(130, 140, 255), function() Lighting.ClockTime = 0; Lighting.Brightness = 1 end)
createDualButtons(page4, "🔄 VÀO LẠI SV", Theme.AccentOn, rejoinServer, "🎲 ĐỔI SV NGẪU NHIÊN", Theme.Brand, function() hopServer("Desc") end)
createDualButtons(page4, "📉 ĐỔI SV ÍT NGƯỜI", Color3.fromRGB(52, 152, 219), function() hopServer("Asc") end, "📈 ĐỔI SV NHIỀU NGƯỜI", Color3.fromRGB(231, 76, 60), function() hopServer("Desc") end)

createDualButtons(
    page4,
    "💻 LỆNH ADMIN", Theme.AccentOn, function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end) end,
    "📁 TP SAVE", Theme.Brand, function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip13/refs/heads/main/menu-save.lua"))() end) end
)

createDualButtons(
    page4,
    "🕊️ FLY V1", Theme.Brand, function() pcall(function() loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")() end) end,
    "🕊️ FLY V2", Theme.Brand, function() pcall(function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-fly-v3-by-hibatzzz-243731"))() end) end
)

createDualButtons(
    page4,
    "🕊️ FLY V3", Theme.Brand, function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip/refs/heads/main/menu-fly.lua"))() end) end,
    "🎯 TP PLAYS", Theme.AccentOn, function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/haudeptrai2k6/hack.lua/refs/heads/main/menu-tp-play.lua"))() end) end
)

-- ==========================================
-- [TAB 5: NHẠC ID] & [TAB 6: TP SAVE]
-- ==========================================
local currentSound, currentMusicId, savedMusicList = nil, "", {}
local musicControlFrame = Instance.new("Frame", page5); musicControlFrame.Size = UDim2.new(0.92, 0, 0, 62); musicControlFrame.BackgroundColor3 = Theme.ItemBg; musicControlFrame.ZIndex = 10; musicControlFrame.LayoutOrder = 1; Instance.new("UICorner", musicControlFrame).CornerRadius = UDim.new(0, 8)
local mStroke = Instance.new("UIStroke", musicControlFrame); mStroke.Color = Theme.Stroke; mStroke.Thickness = 1.2; table.insert(RGBElements, {Type = "Info", Stroke = mStroke})
local musicIdBox = Instance.new("TextBox", musicControlFrame); musicIdBox.Size = UDim2.new(0.72, 0, 0, 30); musicIdBox.Position = UDim2.new(0.05, 0, 0, 0); musicIdBox.BackgroundTransparency = 1; musicIdBox.PlaceholderText = "🎼 Nhập ID Nhạc..."; musicIdBox.Text = ""; musicIdBox.TextColor3 = Theme.TextTitle; musicIdBox.Font = Enum.Font.GothamSemibold; musicIdBox.TextSize = 11; musicIdBox.TextXAlignment = Enum.TextXAlignment.Left; musicIdBox.ClearTextOnFocus = false; musicIdBox.ZIndex = 10
local saveIdBtn = Instance.new("TextButton", musicControlFrame); saveIdBtn.Size = UDim2.new(0.22, 0, 0, 30); saveIdBtn.Position = UDim2.new(0.78, 0, 0, 0); saveIdBtn.BackgroundTransparency = 1; saveIdBtn.Text = "💾 Lưu"; saveIdBtn.TextColor3 = Theme.AccentOn; saveIdBtn.Font = Enum.Font.GothamBold; saveIdBtn.TextSize = 10.5; saveIdBtn.ZIndex = 10
local nowPlayingLabel = Instance.new("TextLabel", musicControlFrame); nowPlayingLabel.Size = UDim2.new(0.92, 0, 0, 30); nowPlayingLabel.Position = UDim2.new(0.04, 0, 0, 31); nowPlayingLabel.BackgroundTransparency = 1; nowPlayingLabel.RichText = true; nowPlayingLabel.Text = "🎵 Chưa có nhạc phát"; nowPlayingLabel.TextColor3 = Color3.new(1,1,1); nowPlayingLabel.Font = Enum.Font.GothamSemibold; nowPlayingLabel.TextSize = 11; nowPlayingLabel.ZIndex = 10

local function getSongName(id)
    local s, info = pcall(function() return MarketplaceService:GetProductInfo(tonumber(id)) end)
    return (s and info and info.Name) or ("Nhạc " .. tostring(id))
end
local function playMusic(id)
    if currentSound then currentSound:Destroy() end
    local soundId = tostring(id):match("%d+"); if not soundId then return end
    currentMusicId = soundId; nowPlayingLabel.Text = "🎵 Đang phát: " .. soundId
    currentSound = Instance.new("Sound", workspace); currentSound.SoundId = "rbxassetid://" .. soundId; currentSound.Volume = State.MusicVolume; currentSound:Play()
end
local function stopMusic() if currentSound then currentSound:Stop(); currentSound:Destroy(); currentSound = nil; nowPlayingLabel.Text = "⏹ Đã dừng nhạc" end end

createDualButtons(page5, "▶️ PHÁT NHẠC", Theme.AccentOn, function() playMusic(musicIdBox.Text) end, "⏸️ TẮT NHẠC", Theme.AccentOff, stopMusic).LayoutOrder = 2
createSlider(page5, "ÂM LƯỢNG 🔊", 0, 10, "MusicVolume", function(val) if currentSound then currentSound.Volume = val end end).LayoutOrder = 3
local savedMusicContent = Instance.new("ScrollingFrame", page5); savedMusicContent.Size = UDim2.new(0.92, 0, 1, -155); savedMusicContent.BackgroundTransparency = 1; savedMusicContent.ScrollBarThickness = 4; savedMusicContent.ScrollBarImageColor3 = Theme.Brand; savedMusicContent.BorderSizePixel = 0; savedMusicContent.ZIndex = 10; savedMusicContent.LayoutOrder = 4
local sLayout = Instance.new("UIListLayout", savedMusicContent); sLayout.SortOrder = Enum.SortOrder.LayoutOrder; sLayout.Padding = UDim.new(0, 5)
sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedMusicContent.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 12) end)

local musicFileName = "MenuVipProMax_SavedMusic.json"
pcall(function() if isfile and isfile(musicFileName) then savedMusicList = HttpService:JSONDecode(readfile(musicFileName)) or {} end end)
local function saveMusicData() pcall(function() if writefile then writefile(musicFileName, HttpService:JSONEncode(savedMusicList)) end end) end
local function renderSavedMusic()
    for _, c in pairs(savedMusicContent:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i, data in ipairs(savedMusicList) do
        local item = Instance.new("Frame", savedMusicContent); item.Size = UDim2.new(1, -6, 0, 34); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.55, 0, 1, 0); nameBox.Position = UDim2.new(0.04, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 10.5; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
        nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveMusicData() end end)
        local playBtn = Instance.new("TextButton", item); playBtn.Size = UDim2.new(0.18, 0, 0.7, 0); playBtn.Position = UDim2.new(0.62, 0, 0.15, 0); playBtn.Text = "▶️"; playBtn.BackgroundColor3 = Theme.Brand; playBtn.TextColor3 = Color3.new(1,1,1); playBtn.ZIndex = 10; Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)
        local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.7, 0); delBtn.Position = UDim2.new(0.82, 0, 0.15, 0); delBtn.Text = "❌"; delBtn.BackgroundColor3 = Theme.AccentOff; delBtn.TextColor3 = Color3.new(1,1,1); delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        playBtn.MouseButton1Click:Connect(function() musicIdBox.Text = data.id; playMusic(data.id) end)
        delBtn.MouseButton1Click:Connect(function() table.remove(savedMusicList, i); saveMusicData(); renderSavedMusic() end)
    end
end
saveIdBtn.MouseButton1Click:Connect(function() local rawId = musicIdBox.Text:match("%d+"); if rawId then task.spawn(function() table.insert(savedMusicList, {id = rawId, name = getSongName(rawId)}); saveMusicData(); renderSavedMusic() end) end end)
renderSavedMusic()

local tpFileName, savedTpList, renderSavedTps = "MenuVipProMax_SavedTPs.json", {}, nil
pcall(function() if isfile and isfile(tpFileName) then savedTpList = HttpService:JSONDecode(readfile(tpFileName)) or {} end end)
local function saveTpData() pcall(function() if writefile then writefile(tpFileName, HttpService:JSONEncode(savedTpList)) end end) end

createDualButtons(page6, "📍 LƯU VỊ TRÍ", Theme.Brand, function()
    if player.Character then
        local root = getUniversalRoot(player.Character)
        if root then table.insert(savedTpList, {name = "Vị Trí " .. (#savedTpList + 1), cframe = {root.CFrame:GetComponents()}}); saveTpData(); renderSavedTps() end
    end
end, "🗑️ XÓA TẤT CẢ", Theme.AccentOff, function() savedTpList = {}; saveTpData(); renderSavedTps() end).LayoutOrder = 1

local savedTpContent = Instance.new("ScrollingFrame", page6); savedTpContent.Size = UDim2.new(0.92, 0, 1, -48); savedTpContent.BackgroundTransparency = 1; savedTpContent.ScrollBarThickness = 4; savedTpContent.ScrollBarImageColor3 = Theme.Brand; savedTpContent.BorderSizePixel = 0; savedTpContent.ZIndex = 10; savedTpContent.LayoutOrder = 2
local tpLayout = Instance.new("UIListLayout", savedTpContent); tpLayout.SortOrder = Enum.SortOrder.LayoutOrder; tpLayout.Padding = UDim.new(0, 5)
tpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() savedTpContent.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 12) end)

renderSavedTps = function()
    for _, c in pairs(savedTpContent:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i, data in ipairs(savedTpList) do
        local item = Instance.new("Frame", savedTpContent); item.Size = UDim2.new(1, -6, 0, 34); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local nameBox = Instance.new("TextBox", item); nameBox.Size = UDim2.new(0.48, 0, 1, 0); nameBox.Position = UDim2.new(0.04, 0, 0, 0); nameBox.Text = data.name; nameBox.TextColor3 = Theme.TextTitle; nameBox.Font = Enum.Font.GothamSemibold; nameBox.TextSize = 11; nameBox.BackgroundTransparency = 1; nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.ClearTextOnFocus = false; nameBox.ZIndex = 10
        nameBox.FocusLost:Connect(function() if nameBox.Text ~= "" then data.name = nameBox.Text; saveTpData() end end)
        local tpBtn = Instance.new("TextButton", item); tpBtn.Size = UDim2.new(0.24, 0, 0.7, 0); tpBtn.Position = UDim2.new(0.54, 0, 0.15, 0); tpBtn.Text = "TP"; tpBtn.BackgroundColor3 = Theme.Brand; tpBtn.TextColor3 = Color3.new(1,1,1); tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 10.5; tpBtn.ZIndex = 10; Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
        local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.7, 0); delBtn.Position = UDim2.new(0.81, 0, 0.15, 0); delBtn.Text = "X"; delBtn.BackgroundColor3 = Theme.AccentOff; delBtn.TextColor3 = Color3.new(1,1,1); delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 11; delBtn.ZIndex = 10; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        tpBtn.MouseButton1Click:Connect(function() if player.Character then local r = getUniversalRoot(player.Character); if r then r.CFrame = CFrame.new(unpack(data.cframe)) end end end)
        delBtn.MouseButton1Click:Connect(function() table.remove(savedTpList, i); saveTpData(); renderSavedTps() end)
    end
end
renderSavedTps()

-- ==========================================
-- [TAB 7: TP PLAYER (HIỂN THỊ ĐẦY ĐỦ 100%)]
-- ==========================================
local targetTpPlayer = nil
local autoTpPlayerEnabled = false
local spectatePlayerEnabled = false

local tpControlCard = Instance.new("Frame", page7)
tpControlCard.Size = UDim2.new(0.94, 0, 0, 86); tpControlCard.BackgroundColor3 = Color3.fromRGB(28, 30, 42); tpControlCard.LayoutOrder = 1; tpControlCard.ZIndex = 10
Instance.new("UICorner", tpControlCard).CornerRadius = UDim.new(0, 8)
local tpCardStroke = Instance.new("UIStroke", tpControlCard); tpCardStroke.Color = Theme.Brand; tpCardStroke.Thickness = 1.4
table.insert(RGBElements, {Type = "Button", Stroke = tpCardStroke, DefaultColor = Theme.Brand})

local targetHeaderRow = Instance.new("Frame", tpControlCard)
targetHeaderRow.Size = UDim2.new(1, -12, 0, 26); targetHeaderRow.Position = UDim2.new(0, 6, 0, 4); targetHeaderRow.BackgroundColor3 = Color3.fromRGB(18, 20, 28); targetHeaderRow.ZIndex = 10
Instance.new("UICorner", targetHeaderRow).CornerRadius = UDim.new(0, 6)

local selectedAvatarImg = Instance.new("ImageLabel", targetHeaderRow)
selectedAvatarImg.Size = UDim2.new(0, 20, 0, 20); selectedAvatarImg.Position = UDim2.new(0, 5, 0.5, -10); selectedAvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 55); selectedAvatarImg.Image = "rbxassetid://0"; selectedAvatarImg.ZIndex = 10
Instance.new("UICorner", selectedAvatarImg).CornerRadius = UDim.new(1, 0)
local selAvaStroke = Instance.new("UIStroke", selectedAvatarImg); selAvaStroke.Color = Theme.Brand; selAvaStroke.Thickness = 1

local targetStatusLabel = Instance.new("TextLabel", targetHeaderRow)
targetStatusLabel.Size = UDim2.new(1, -112, 1, 0); targetStatusLabel.Position = UDim2.new(0, 30, 0, 0); targetStatusLabel.BackgroundTransparency = 1; targetStatusLabel.Text = "🎯 Chưa chọn mục tiêu"; targetStatusLabel.TextColor3 = Color3.fromRGB(255, 107, 129); targetStatusLabel.Font = Enum.Font.GothamBold; targetStatusLabel.TextSize = 11; targetStatusLabel.TextTruncate = Enum.TextTruncate.AtEnd; targetStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; targetStatusLabel.ZIndex = 10

local spectateBtn = Instance.new("TextButton", targetHeaderRow)
spectateBtn.Size = UDim2.new(0, 76, 0, 20); spectateBtn.Position = UDim2.new(1, -80, 0.5, -10); spectateBtn.BackgroundColor3 = Color3.fromRGB(55, 35, 45); spectateBtn.Text = "👁️ XEM [TẮT]"; spectateBtn.TextColor3 = Theme.AccentOff; spectateBtn.Font = Enum.Font.GothamBold; spectateBtn.TextSize = 9.5; spectateBtn.AutoButtonColor = false; spectateBtn.ZIndex = 10
Instance.new("UICorner", spectateBtn).CornerRadius = UDim.new(0, 5)
local spectateStroke = Instance.new("UIStroke", spectateBtn); spectateStroke.Color = Theme.AccentOff; spectateStroke.Thickness = 1; spectateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local tpPosBtn = Instance.new("TextButton", tpControlCard)
tpPosBtn.Size = UDim2.new(1, -12, 0, 24); tpPosBtn.Position = UDim2.new(0, 6, 0, 33); tpPosBtn.BackgroundColor3 = Color3.fromRGB(0, 105, 155); tpPosBtn.Text = ""; tpPosBtn.AutoButtonColor = false; tpPosBtn.ZIndex = 10
Instance.new("UICorner", tpPosBtn).CornerRadius = UDim.new(0, 6)
local tpPosStroke = Instance.new("UIStroke", tpPosBtn); tpPosStroke.Color = Color3.fromRGB(80, 220, 255); tpPosStroke.Thickness = 1.2; tpPosStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local tpPosLabel = Instance.new("TextLabel", tpPosBtn)
tpPosLabel.Size = UDim2.new(1, 0, 1, 0); tpPosLabel.BackgroundTransparency = 1; tpPosLabel.TextColor3 = Color3.fromRGB(255, 255, 100); tpPosLabel.Font = Enum.Font.GothamBlack; tpPosLabel.TextSize = 11; tpPosLabel.ZIndex = 10

local function updateTpPosText()
    local item = TpPositions[State.TpPositionIdx] or TpPositions[1]
    tpPosLabel.Text = "📍 VỊ TRÍ TP: < " .. string.upper(item.Name) .. " >"
end
updateTpPosText()

tpPosBtn.MouseButton1Click:Connect(function()
    clickAnimate(tpPosBtn)
    State.TpPositionIdx = (State.TpPositionIdx % #TpPositions) + 1
    updateTpPosText()
    if State.AutoSave then saveConfig() end
end)

local tpDistContainer = Instance.new("Frame", tpControlCard)
tpDistContainer.Size = UDim2.new(1, -12, 0, 24); tpDistContainer.Position = UDim2.new(0, 6, 0, 59); tpDistContainer.BackgroundTransparency = 1; tpDistContainer.ZIndex = 10
local tpDistTitle = Instance.new("TextLabel", tpDistContainer)
tpDistTitle.Size = UDim2.new(0.7, 0, 0, 12); tpDistTitle.Position = UDim2.new(0, 2, 0, 0); tpDistTitle.BackgroundTransparency = 1; tpDistTitle.Text = "📏 Khoảng cách đứng (Studs):"; tpDistTitle.TextColor3 = Color3.fromRGB(240, 245, 255); tpDistTitle.Font = Enum.Font.GothamBold; tpDistTitle.TextSize = 10.5; tpDistTitle.TextXAlignment = Enum.TextXAlignment.Left; tpDistTitle.ZIndex = 10
local tp
