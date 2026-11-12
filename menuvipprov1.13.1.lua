-- ==========================================
-- MENU VIP PRO V1.13.4 (FIXED FLY & FULL TABS)
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
    MainBg = Color3.fromRGB(20, 20, 26), HeaderBg = Color3.fromRGB(26, 26, 34),
    TabBg = Color3.fromRGB(24, 24, 30), ItemBg = Color3.fromRGB(35, 35, 45),
    Stroke = Color3.fromRGB(60, 60, 75), TextTitle = Color3.fromRGB(210, 225, 240),
    TextDim = Color3.fromRGB(160, 160, 175), AccentOn = Color3.fromRGB(46, 204, 113),
    AccentOff = Color3.fromRGB(255, 71, 87), Brand = Color3.fromRGB(0, 200, 255)
}

local PlayerLightColors = {
    {Name = "Trắng", Value = Color3.fromRGB(255, 255, 255)}, {Name = "Đỏ", Value = Color3.fromRGB(255, 0, 0)},
    {Name = "Cam", Value = Color3.fromRGB(255, 128, 0)}, {Name = "Vàng", Value = Color3.fromRGB(255, 255, 0)},
    {Name = "Xanh lá", Value = Color3.fromRGB(0, 255, 0)}, {Name = "Xanh lơ", Value = Color3.fromRGB(0, 255, 255)},
    {Name = "Xanh dương", Value = Color3.fromRGB(0, 0, 255)}, {Name = "Tím", Value = Color3.fromRGB(128, 0, 255)},
    {Name = "Hồng", Value = Color3.fromRGB(255, 105, 180)}
}

local TpPositions = {
    {Name = "Sau lưng", IsHorizontal = false, GetOffset = function(d) return CFrame.new(0, 0, d) end},
    {Name = "Trước mặt", IsHorizontal = false, GetOffset = function(d) return CFrame.new(0, 0, -d) * CFrame.Angles(0, math.pi, 0) end},
    {Name = "Trên đầu", IsHorizontal = true, GetOffset = function(d) return CFrame.new(0, d, 0) * CFrame.Angles(math.rad(-90), 0, 0) end},
    {Name = "Dưới chân", IsHorizontal = true, GetOffset = function(d) return CFrame.new(0, -d, 0) * CFrame.Angles(math.rad(90), 0, 0) end}
}

local RGBElements, ActiveESPs, originalHitboxSizes, originalToolSizes, cachedPrompts, xrayMats, OriginalGFX = {}, {}, {}, {}, {}, {}, {}

local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
    if gethui and type(gethui) == "function" then guiParent = gethui() or guiParent
    elseif game:GetService("CoreGui") then guiParent = game:GetService("CoreGui") end
end)

for _, v in pairs(guiParent:GetChildren()) do
    if v.Name == "MenuVipProMax" or v.Name == "MobileProMax" then v:Destroy() end
end

local configFileName = "MenuVipProMax_Cfg.json"
pcall(function()
    if isfile and isfile(configFileName) then
        local data = HttpService:JSONDecode(readfile(configFileName))
        for k, v in pairs(data) do if State[k] ~= nil and type(State[k]) == type(v) then State[k] = v end end
    end
end)
State.TpPositionIdx = TpPositions[State.TpPositionIdx] and State.TpPositionIdx or 1
State.LightColorIdx = PlayerLightColors[State.LightColorIdx] and State.LightColorIdx or 1
State.TpDistance = tonumber(State.TpDistance) or 4

local function saveConfig()
    pcall(function() if writefile then writefile(configFileName, HttpService:JSONEncode(State)) end end)
end

local function addCorner(obj, r)
    local c = Instance.new("UICorner", obj); c.CornerRadius = UDim.new(0, r or 8); return c
end

local function addStroke(obj, col, thick, borderMode, rgbType)
    local s = Instance.new("UIStroke", obj); s.Color = col or Theme.Stroke; s.Thickness = thick or 1.2
    if borderMode then s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end
    if rgbType then table.insert(RGBElements, {Type = rgbType, Stroke = s, DefaultColor = col}) end
    return s
end

-- GIAO DIỆN CHÍNH
local gui = Instance.new("ScreenGui", guiParent)
gui.Name = "MenuVipProMax"; gui.ResetOnSpawn = false; gui.DisplayOrder = 99999; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local notifGui = Instance.new("Frame", gui)
notifGui.Size = UDim2.new(0, 190, 0.8, 0); notifGui.Position = UDim2.new(1, -200, 0.1, 0); notifGui.BackgroundTransparency = 1; notifGui.ZIndex = 9999
local notifLayout = Instance.new("UIListLayout", notifGui)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder; notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; notifLayout.Padding = UDim.new(0, 6)

local function MakeToast(title, desc, color)
    local toast = Instance.new("Frame", notifGui)
    toast.Size = UDim2.new(1, 0, 0, 44); toast.BackgroundColor3 = Theme.ItemBg; toast.BackgroundTransparency = 0.1; addCorner(toast, 8)
    addStroke(toast, color, 1.2)
    local bar = Instance.new("Frame", toast)
    bar.Size = UDim2.new(0, 3, 1, -12); bar.Position = UDim2.new(0, 6, 0, 6); bar.BackgroundColor3 = color; addCorner(bar, 99)
    local tL = Instance.new("TextLabel", toast)
    tL.Size = UDim2.new(1, -24, 0, 16); tL.Position = UDim2.new(0, 16, 0, 5); tL.BackgroundTransparency = 1; tL.Text = title; tL.TextColor3 = color; tL.Font = Enum.Font.GothamBold; tL.TextSize = 11; tL.TextXAlignment = Enum.TextXAlignment.Left
    local dL = Instance.new("TextLabel", toast)
    dL.Size = UDim2.new(1, -24, 0, 16); dL.Position = UDim2.new(0, 16, 0, 22); dL.BackgroundTransparency = 1; dL.Text = desc; dL.TextColor3 = Theme.TextTitle; dL.Font = Enum.Font.Gotham; dL.TextSize = 10; dL.TextXAlignment = Enum.TextXAlignment.Left
    task.delay(2.2, function() if toast then toast:Destroy() end end)
end

local function safeLoadUrl(url)
    task.spawn(function()
        local ok, content = pcall(function() return game:HttpGet(url) end)
        if ok and type(content) == "string" and #content > 0 then
            content = content:gsub("^%s*Local%s+", "local "):gsub("\n%s*Local%s+", "\nlocal ")
            local fn = loadstring(content)
            if fn then pcall(fn) end
        else
            MakeToast("Lỗi tải Script", "Không thể kết nối tới link!", Theme.AccentOff)
        end
    end)
end

local screenOverlay = Instance.new("Frame", gui)
screenOverlay.Size = UDim2.new(2, 0, 2, 0); screenOverlay.Position = UDim2.new(-0.5, 0, -0.5, 0); screenOverlay.BackgroundColor3 = Color3.new(0,0,0); screenOverlay.ZIndex = 0; screenOverlay.Visible = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 40, 0, 40); openBtn.Position = UDim2.new(0, 15, 0.25, 0); openBtn.Text = "🇻🇳"; openBtn.BackgroundColor3 = Theme.MainBg; openBtn.BackgroundTransparency = 0.25; openBtn.TextColor3 = Theme.Brand; openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 19; openBtn.ZIndex = 10
addCorner(openBtn, 99)
local openStroke = addStroke(openBtn, Theme.Brand, 1.8, true)

local function clickAnimate(obj)
    task.spawn(function()
        local sc = Instance.new("UIScale", obj)
        TweenService:Create(sc, TweenInfo.new(0.1), {Scale = 0.92}):Play(); task.wait(0.1)
        TweenService:Create(sc, TweenInfo.new(0.15), {Scale = 1}):Play(); task.wait(0.2); sc:Destroy()
    end)
end

local function makeDraggable(handle, target)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = inp.Position; startPos = target.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (inp.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (inp.Position.Y - dragStart.Y))
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end
makeDraggable(openBtn, openBtn)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 305); frame.Position = UDim2.new(0.5, -175, 0.5, -152); frame.BackgroundColor3 = Theme.MainBg; frame.BackgroundTransparency = 0.05; frame.ZIndex = 10
addCorner(frame, 14)
local frameStroke = addStroke(frame, Theme.Stroke, 1.8, false, "Frame")

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 32); header.BackgroundColor3 = Theme.HeaderBg; header.ZIndex = 10; addCorner(header, 14)
local headerStroke = addStroke(header, Theme.Stroke, 1.2, true, "Header")
makeDraggable(header, frame)

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, 0, 1, 0); titleLabel.BackgroundTransparency = 1; titleLabel.Text = "MENU VIP PRO MAX"; titleLabel.TextColor3 = Theme.TextTitle; titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 13; titleLabel.ZIndex = 10

local avatarImg = Instance.new("ImageLabel", header)
avatarImg.Size = UDim2.new(0, 22, 0, 22); avatarImg.Position = UDim2.new(0, 10, 0.5, -11); avatarImg.BackgroundTransparency = 1; avatarImg.ZIndex = 10; addCorner(avatarImg, 99)
local avatarStroke = addStroke(avatarImg, Theme.Brand, 1.2, true)
task.spawn(function() pcall(function() avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end)

local tabBar = Instance.new("ScrollingFrame", frame)
tabBar.Size = UDim2.new(1, 0, 0, 28); tabBar.Position = UDim2.new(0, 0, 0, 32); tabBar.BackgroundColor3 = Theme.TabBg; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 10; tabBar.ScrollBarThickness = 0; tabBar.ScrollingDirection = Enum.ScrollingDirection.X; tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local pageContainer = Instance.new("Frame", frame)
pageContainer.Size = UDim2.new(1, 0, 1, -62); pageContainer.Position = UDim2.new(0, 0, 0, 61); pageContainer.BackgroundTransparency = 1; pageContainer.ZIndex = 10

local function createPage(isFixed)
    local pg = Instance.new(isFixed and "Frame" or "ScrollingFrame", pageContainer)
    pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1; pg.Visible = false; pg.BorderSizePixel = 0; pg.ZIndex = 10
    local layout = Instance.new("UIListLayout", pg)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 5); layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", pg); pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 14)
    if not isFixed then
        pg.ScrollBarThickness = 4; pg.ScrollBarImageColor3 = Theme.Brand
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 25) end)
    end
    return pg
end

local page1, page2, page3, page4 = createPage(false), createPage(false), createPage(false), createPage(false)
local page5, page6, page7 = createPage(true), createPage(true), createPage(true)
local page8, page9 = createPage(false), createPage(false)

local allPages = {page1, page2, page3, page4, page5, page6, page7, page8, page9}
local allTabs, allInds = {}, {}
local tabNames = {
    {"THÔNG TIN", 65}, {"TÍNH NĂNG", 65}, {"PLAYER", 55}, {"TIỆN ÍCH", 58},
    {"NHẠC ID", 55}, {"TP SAVE", 58}, {"TP PLAYER", 65}, {"AUTO SKILL", 68}, {"CẤU HÌNH", 65}
}

for idx, info in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0, info[2], 1, 0); btn.Text = info[1]; btn.BackgroundTransparency = 1; btn.TextColor3 = Theme.TextDim; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8; btn.ZIndex = 10
    local ind = Instance.new("Frame", btn)
    ind.Size = UDim2.new(0.5, 0, 0, 2); ind.Position = UDim2.new(0.25, 0, 1, -2); ind.BackgroundColor3 = Theme.Brand; ind.Visible = false; ind.ZIndex = 10; addCorner(ind, 99)
    allTabs[idx] = btn; allInds[idx] = ind
    btn.MouseButton1Click:Connect(function()
        for i = 1, 9 do
            allPages[i].Visible = (i == idx)
            allTabs[i].TextColor3 = (i == idx) and Theme.TextTitle or Theme.TextDim
            allInds[i].Visible = (i == idx)
        end
    end)
end
allPages[1].Visible = true; allTabs[1].TextColor3 = Theme.TextTitle; allInds[1].Visible = true

local opened = true
openBtn.MouseButton1Click:Connect(function()
    clickAnimate(openBtn); opened = not opened
    if not State.RGB then openStroke.Color = opened and Theme.AccentOff or Theme.Brand end
    frame:TweenPosition(opened and UDim2.new(0.5, -175, 0.5, -152) or UDim2.new(0.5, -175, 1.2, 0), "Out", "Back", 0.45)
end)

local function getUniversalRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char.PrimaryPart or char:FindFirstChildWhichIsA("BasePart"))
end

local function createDivider(parent, text)
    local d = Instance.new("Frame", parent); d.Size = UDim2.new(0.92, 0, 0, 15); d.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", d); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = "─── " .. text .. " ───"; l.TextColor3 = Theme.Brand; l.Font = Enum.Font.GothamBold; l.TextSize = 10
    return d
end

local function createCycleBtn(parent, prefix, options, stateVar, onChange)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.92, 0, 0, 32); f.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10; addCorner(btn, 8)
    addStroke(btn, Theme.Brand, 1.2, true, "Button")
    local t = Instance.new("TextLabel", btn); t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.TextColor3 = Theme.Brand; t.Font = Enum.Font.GothamBold; t.TextSize = 11; t.ZIndex = 10
    local function upd()
        local item = options[State[stateVar]] or options[1]
        t.Text = prefix .. " < " .. item.Name .. " >"
    end
    upd()
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); State[stateVar] = (State[stateVar] % #options) + 1; upd()
        if onChange then onChange(State[stateVar]) end
        if State.AutoSave then saveConfig() end
    end)
    return f
end

local function createToggle(parent, text, varName, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.92, 0, 0, 34); f.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1, 0, 1, 0); btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10; addCorner(btn, 8)
    local active = State[varName] or false
    local stroke = addStroke(btn, active and Theme.AccentOn or Theme.Stroke, 1.2)
    table.insert(RGBElements, {Type = "Toggle", Stroke = stroke, State = function() return State[varName] end})
    btn.BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg
    local title = Instance.new("TextLabel", btn); title.Size = UDim2.new(0.74, 0, 1, 0); title.Position = UDim2.new(0.04, 0, 0, 0); title.BackgroundTransparency = 1; title.Text = text; title.TextColor3 = Theme.TextTitle; title.Font = Enum.Font.GothamSemibold; title.TextSize = 11; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 10
    local status = Instance.new("TextLabel", btn); status.Size = UDim2.new(0.18, 0, 1, 0); status.Position = UDim2.new(0.78, 0, 0, 0); status.BackgroundTransparency = 1; status.Font = Enum.Font.GothamBold; status.TextSize = 11; status.TextXAlignment = Enum.TextXAlignment.Right; status.ZIndex = 10
    status.Text = active and "ON" or "OFF"; status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
    btn.MouseButton1Click:Connect(function()
        clickAnimate(btn); State[varName] = not State[varName]; active = State[varName]
        status.Text = active and "ON" or "OFF"; status.TextColor3 = active and Theme.AccentOn or Theme.AccentOff
        if not State.RGB then stroke.Color = active and Theme.AccentOn or Theme.Stroke end
        btn.BackgroundColor3 = active and Color3.fromRGB(35, 45, 40) or Theme.ItemBg
        if varName ~= "AutoSave" then MakeToast(active and "Đã Bật" or "Đã Tắt", text, active and Theme.AccentOn or Theme.AccentOff); if State.AutoSave then saveConfig() end end
        if callback then callback(active) end
    end)
    if active and callback then task.spawn(callback, active) end
    return f
end

local function createButton(parent, text, color, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.92, 0, 0, 32); f.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = text; btn.TextColor3 = color; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.AutoButtonColor = false; btn.ZIndex = 10; addCorner(btn, 8)
    addStroke(btn, color, 1.2, true, "Button")
    btn.MouseButton1Click:Connect(function() clickAnimate(btn); MakeToast("Đã thực thi", text, color); callback() end)
    return f
end

local function createDualButtons(parent, text1, color1, cb1, text2, color2, cb2)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.92, 0, 0, 32); f.BackgroundTransparency = 1
    local function mk(xPos, txt, col, cb)
        local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.485, 0, 1, 0); btn.Position = UDim2.new(xPos, 0, 0, 0); btn.BackgroundColor3 = Theme.ItemBg; btn.Text = txt; btn.TextColor3 = col; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.AutoButtonColor = false; btn.ZIndex = 10; addCorner(btn, 8)
        addStroke(btn, col, 1.2, true, "Button")
        btn.MouseButton1Click:Connect(function() clickAnimate(btn); if txt ~= "🗑️ XÓA TẤT CẢ" then MakeToast("Đã thực thi", txt, col) end; cb() end)
    end
    mk(0, text1, color1, cb1); mk(0.515, text2, color2, cb2)
    return f
end

local function createSlider(parent, text, min, max, varName, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.92, 0, 0, 38); f.BackgroundTransparency = 1
    local bg = Instance.new("Frame", f); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Theme.ItemBg; bg.ZIndex = 10; addCorner(bg, 8)
    addStroke(bg, Theme.Stroke, 1.2, false, "Slider")
    local tL = Instance.new("TextLabel", bg); tL.Size = UDim2.new(0.7, 0, 0.45, 0); tL.Position = UDim2.new(0.04, 0, 0.08, 0); tL.BackgroundTransparency = 1; tL.Text = text; tL.TextColor3 = Theme.TextDim; tL.Font = Enum.Font.GothamSemibold; tL.TextSize = 11; tL.TextXAlignment = Enum.TextXAlignment.Left; tL.ZIndex = 10
    local vL = Instance.new("TextLabel", bg); vL.Size = UDim2.new(0.25, 0, 0.45, 0); vL.Position = UDim2.new(0.71, 0, 0.08, 0); vL.BackgroundTransparency = 1; vL.Text = tostring(State[varName]); vL.TextColor3 = Theme.Brand; vL.Font = Enum.Font.GothamBold; vL.TextSize = 11; vL.TextXAlignment = Enum.TextXAlignment.Right; vL.ZIndex = 10
    local tr = Instance.new("Frame", bg); tr.Size = UDim2.new(0.92, 0, 0.18, 0); tr.Position = UDim2.new(0.04, 0, 0.64, 0); tr.BackgroundColor3 = Theme.MainBg; tr.ZIndex = 10; addCorner(tr, 99)
    local fl = Instance.new("Frame", tr); fl.Size = UDim2.new(math.clamp(((tonumber(State[varName]) or min) - min) / (max - min), 0, 1), 0, 1, 0); fl.BackgroundColor3 = Theme.AccentOn; fl.ZIndex = 10; addCorner(fl, 99)
    local dragging = false
    local function upd(inp)
        local pos = math.clamp((inp.Position.X - tr.AbsolutePosition.X) / math.max(tr.AbsoluteSize.X, 1), 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        vL.Text = tostring(val); fl.Size = UDim2.new(pos, 0, 1, 0); State[varName] = val
        if callback then callback(val) end; if State.AutoSave then saveConfig() end
    end
    tr.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true; upd(inp) end end)
    UIS.InputChanged:Connect(function(inp) if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then upd(inp) end end)
    UIS.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    if callback then task.spawn(callback, State[varName]) end
    return f
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

-- [TAB 1: THÔNG TIN]
local function createInfoBox(parent, icon, titleText, h)
    local item = Instance.new("Frame", parent); item.Size = UDim2.new(0.92, 0, 0, h or 90); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; addCorner(item, 8)
    addStroke(item, Theme.Stroke, 1.2, false, "Info")
    local t = Instance.new("TextLabel", item); t.Size = UDim2.new(1, -16, 0, 20); t.Position = UDim2.new(0, 8, 0, 4); t.BackgroundTransparency = 1; t.Text = icon .. " " .. titleText; t.TextColor3 = Theme.Brand; t.Font = Enum.Font.GothamBold; t.TextSize = 11; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 10
    local c = Instance.new("TextLabel", item); c.Size = UDim2.new(1, -16, 1, -26); c.Position = UDim2.new(0, 8, 0, 24); c.BackgroundTransparency = 1; c.Text = "Đang tải..."; c.TextColor3 = Theme.TextTitle; c.Font = Enum.Font.Gotham; c.TextSize = 10.5; c.TextXAlignment = Enum.TextXAlignment.Left; c.TextYAlignment = Enum.TextYAlignment.Top; c.RichText = true; c.ZIndex = 10
    return c, item
end

local playerInfoLabel = createInfoBox(page1, "👤", "THÔNG TIN NHÂN VẬT", 104)
local serverInfoLabel, serverInfoFrame = createInfoBox(page1, "🌐", "THÔNG TIN MÁY CHỦ", 90)
local copyIdBtn = Instance.new("TextButton", serverInfoFrame); copyIdBtn.Size = UDim2.new(0, 22, 0, 22); copyIdBtn.Position = UDim2.new(1, -26, 1, -24); copyIdBtn.Text = "📜"; copyIdBtn.BackgroundTransparency = 1; copyIdBtn.TextSize = 13; copyIdBtn.ZIndex = 11
copyIdBtn.MouseButton1Click:Connect(function() clickAnimate(copyIdBtn); pcall(function() if setclipboard then setclipboard(tostring(game.JobId)); MakeToast("Đã Copy", "Đã lưu ID Server", Theme.AccentOn) end end) end)

local joinIdFrame = Instance.new("Frame", page1); joinIdFrame.Size = UDim2.new(0.92, 0, 0, 34); joinIdFrame.BackgroundColor3 = Theme.ItemBg; joinIdFrame.ZIndex = 10; addCorner(joinIdFrame, 8); addStroke(joinIdFrame, Theme.Stroke, 1.2, false, "Info")
local idBox = Instance.new("TextBox", joinIdFrame); idBox.Size = UDim2.new(0.65, 0, 1, 0); idBox.Position = UDim2.new(0.04, 0, 0, 0); idBox.BackgroundTransparency = 1; idBox.PlaceholderText = "Dán ID Server vào đây..."; idBox.Text = ""; idBox.TextColor3 = Theme.Brand; idBox.Font = Enum.Font.Gotham; idBox.TextSize = 10.5; idBox.TextXAlignment = Enum.TextXAlignment.Left; idBox.ClearTextOnFocus = false; idBox.ZIndex = 10
local joinBtn = Instance.new("TextButton", joinIdFrame); joinBtn.Size = UDim2.new(0.25, 0, 0.7, 0); joinBtn.Position = UDim2.new(0.72, 0, 0.15, 0); joinBtn.BackgroundColor3 = Theme.AccentOn; joinBtn.Text = "VÀO"; joinBtn.TextColor3 = Color3.new(1, 1, 1); joinBtn.Font = Enum.Font.GothamBold; joinBtn.TextSize = 10.5; joinBtn.ZIndex = 10; addCorner(joinBtn, 6)
joinBtn.MouseButton1Click:Connect(function() clickAnimate(joinBtn); local tId = idBox.Text:gsub("%s+", ""); if tId ~= "" then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, tId, player) end) end end)

local extraInfoLabel = createInfoBox(page1, "⚙️", "TRẠNG THÁI", 78)
local fps = 60; RunService.RenderStepped:Connect(function(dt) fps = math.floor(1 / math.max(dt, 0.001)) end)

task.spawn(function()
    while task.wait(0.5) do
        local hp, maxHp, ws, jp, coords = 0, 0, 0, 0, "0, 0, 0"
        if player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hp = math.floor(hum.Health); maxHp = math.floor(hum.MaxHealth); ws = math.floor(hum.WalkSpeed); jp = math.floor(hum.JumpPower) end
            local r = getUniversalRoot(player.Character)
            if r then coords = string.format("%.1f, %.1f, %.1f", r.Position.X, r.Position.Y, r.Position.Z) end
        end
        playerInfoLabel.Text = string.format("<font color='#FF00FF'>Tên:</font> %s (@%s)\n<font color='#FF00FF'>Máu:</font> %d / %d\n<font color='#FF00FF'>Tốc độ:</font> %d\n<font color='#FF00FF'>Lực nhảy:</font> %d\n<font color='#FF00FF'>Tọa độ:</font> %s", player.DisplayName, player.Name, hp, maxHp, ws, jp, coords)
        local ping = "0 ms"
        pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() end)
        local jobText = game.JobId ~= "" and string.sub(game.JobId, 1, 14).."..." or "N/A"
        serverInfoLabel.Text = string.format("<font color='#FF00FF'>FPS:</font> %d\n<font color='#FF00FF'>Ping:</font> %s\n<font color='#FF00FF'>Người chơi:</font> %d / %d\n<font color='#FF00FF'>ID SV:</font> %s", fps, ping, #Players:GetPlayers(), Players.MaxPlayers, jobText)
        local t = math.floor(workspace.DistributedGameTime)
        extraInfoLabel.Text = string.format("<font color='#FF00FF'>Thời gian chơi:</font> %02d:%02d:%02d\n<font color='#FF00FF'>Giờ hệ thống:</font> %s\n<font color='#FF00FF'>Phiên bản:</font> VIP PRO MAX V1.13.4", math.floor(t/3600), math.floor((t%3600)/60), t%60, os.date("%H:%M:%S"))
    end
end)

-- [TAB 2: TÍNH NĂNG]
createToggle(page2, "🛡️ Chống ngã & Chống văng xa", "AntiStun")
createToggle(page2, "🔒 Khóa vị trí", "LockPosition", function(v) if not v and player.Character then local r = getUniversalRoot(player.Character); if r then r.Anchored = false end end end)
createToggle(page2, "🚀 Nhảy trên không", "InfJump")
UIS.JumpRequest:Connect(function() if State.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)
createToggle(page2, "🐿️ Lấy đồ nhanh", "Instant")
createToggle(page2, "🧲 Auto nhặt đồ xung quanh", "AutoCollect")
createToggle(page2, "🚷 Đi xuyên tường", "Noclip", function(v)
    if not v and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
    end
end)
createToggle(page2, "👀 Nhìn xuyên map (xray)", "XRay", function(v)
    task.spawn(function()
        if v then
            for i, obj in ipairs(workspace:GetDescendants()) do
                if not State.XRay then break end
                if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) and obj.Name ~= "Terrain" and obj.Transparency < 1 then
                    xrayMats[obj] = xrayMats[obj] or obj.Transparency; obj.Transparency = 0.5
                end
                if i % 300 == 0 then task.wait() end
            end
        else
            for obj, trans in pairs(xrayMats) do if obj and obj.Parent then obj.Transparency = trans end end; xrayMats = {}
        end
    end)
end)
createToggle(page2, "🔴 ESP người chơi", "ESP")

-- [TAB 3: PLAYER]
createToggle(page3, "🕊️ bay trên bầu trời", "Fly", function(v)
    if not v and player.Character then
        local r = getUniversalRoot(player.Character); local h = player.Character:FindFirstChildOfClass("Humanoid")
        if r and r:FindFirstChild("FlyBodyVelocity") then r.FlyBodyVelocity:Destroy() end
        if r and r:FindFirstChild("FlyBodyGyro") then r.FlyBodyGyro:Destroy() end
        if h then h.PlatformStand = false end
    end
end)
createSlider(page3, "Tốc độ bay", 10, 1000, "FlySpeed")
createToggle(page3, "🏃 Chạy nhanh", "Speed")
createSlider(page3, "Tốc độ chạy", 1, 1000, "SpeedValue")
local defaultJumpPower = 50
createToggle(page3, "🦘 Nhảy cao", "Jump", function(v)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
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

-- [TAB 4: TIỆN ÍCH]
createToggle(page4, "💾 Lưu Cài Đặt", "AutoSave", function(v)
    if v then saveConfig(); MakeToast("Đã Bật", "Đã lưu cấu hình!", Theme.AccentOn)
    else pcall(function() if isfile and isfile(configFileName) then delfile(configFileName) end end); MakeToast("Đã Tắt", "Đã xóa cấu hình!", Theme.AccentOff) end
end)
createToggle(page4, "🌈 Chế độ RGB", "RGB")
createToggle(page4, "💫 Mở khóa ShiftLock Mobile", "ShiftLock", function(v) pcall(function() player.DevEnableMouseLock = v end) end)
createToggle(page4, "🖱️ Auto Click", "AutoClick")
task.spawn(function() while task.wait(0.1) do if State.AutoClick and player.Character then pcall(function() local t = player.Character:FindFirstChildOfClass("Tool"); if t then t:Activate() end end) end end end)
createToggle(page4, "🛡️ Chống AFK (Antiafk)", "AntiAfk")
player.Idled:Connect(function() if State.AntiAfk then pcall(function() VirtualUser:CaptureController(); VirtualUser:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame); task.wait(0.5); VirtualUser:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame) end) end end)

createDualButtons(page4, "☀️ TRỜI SÁNG", Color3.fromRGB(255, 200, 50), function() pcall(function() Lighting.ClockTime = 12; Lighting.Brightness = 2 end) end, "🌙 TRỜI TỐI", Color3.fromRGB(130, 140, 255), function() pcall(function() Lighting.ClockTime = 0; Lighting.Brightness = 1 end) end)
createDualButtons(page4, "🔄 VÀO LẠI SV", Theme.AccentOn, function()
    if #Players:GetPlayers() <= 1 then player:Kick("\nĐang vào lại server..."); task.wait(); TeleportService:Teleport(game.PlaceId, player)
    else TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end
end, "🎲 ĐỔI SV NGẪU NHIÊN", Theme.Brand, function()
    task.spawn(function()
        local ok, res = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100") end)
        if ok and res then
            local data = HttpService:JSONDecode(res)
            if data and data.data then
                for _, s in pairs(data.data) do
                    if s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player); break
                    end
                end
            end
        end
    end)
end)
createDualButtons(page4, "📉 ĐỔI SV ÍT NGƯỜI", Color3.fromRGB(52, 152, 219), function()
    task.spawn(function()
        local ok, res = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100") end)
        if ok and res then
            local data = HttpService:JSONDecode(res)
            if data and data.data then
                for _, s in pairs(data.data) do
                    if s.playing and s.maxPlayers and s.playing > 0 and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player); break
                    end
                end
            end
        end
    end)
end, "📈 ĐỔI SV NHIỀU NGƯỜI", Color3.fromRGB(231, 76, 60), function()
    task.spawn(function()
        local ok, res = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100") end)
        if ok and res then
            local data = HttpService:JSONDecode(res)
            if data and data.data then
                for _, s in pairs(data.data) do
                    if s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player); break
                    end
                end
            end
        end
    end)
end)

createDualButtons(page4, "💻 LỆNH ADMIN", Theme.AccentOn, function() safeLoadUrl("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source") end, "📁 TP SAVE", Theme.Brand, function() safeLoadUrl("https://raw.githubusercontent.com/haudeptrai2k6/menu-hack-vip13/refs/heads/main/menu-save.lua") end)
createDualButtons(page4, "🕊️ FLY V2", Theme.Brand, function() safeLoadUrl("https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f425b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%25202%2520obflucator") end, "🕊️ FLY V3", Theme.Brand, function() safeLoadUrl("https://scriptblox.com/raw/Universal-Script-fly-v3-by-hibatzzz-243731") end)
createButton(page4, "🎯 TP PLAYS (người chơi)", Theme.AccentOn, function() safeLoadUrl("https://raw.githubusercontent.com/haudeptrai2k6/hack.lua/refs/heads/main/menu-tp-play.lua") end)

-- [TAB 5: NHẠC ID]
local currentSound, currentMusicId, savedMusicList = nil, "", {}
local musicControlFrame = Instance.new("Frame", page5); musicControlFrame.Size = UDim2.new(0.92, 0, 0, 62); musicControlFrame.BackgroundColor3 = Theme.ItemBg; musicControlFrame.ZIndex = 10; musicControlFrame.LayoutOrder = 1; addCorner(musicControlFrame, 8); addStroke(musicControlFrame, Theme.Stroke, 1.2, false, "Info")
local musicIdBox = Instance.new("TextBox", musicControlFrame); musicIdBox.Size = UDim2.new(0.74, 0, 0, 30); musicIdBox.Position = UDim2.new(0.04, 0, 0, 0); musicIdBox.BackgroundTransparency = 1; musicIdBox.PlaceholderText = "🎼 Nhập ID Nhạc..."; musicIdBox.Text = ""; musicIdBox.TextColor3 = Theme.TextTitle; musicIdBox.Font = Enum.Font.GothamSemibold; musicIdBox.TextSize = 11; musicIdBox.TextXAlignment = Enum.TextXAlignment.Left; musicIdBox.ClearTextOnFocus = false; musicIdBox.ZIndex = 10
local saveIdBtn = Instance.new("TextButton", musicControlFrame); saveIdBtn.Size = UDim2.new(0.22, 0, 0, 30); saveIdBtn.Position = UDim2.new(0.78, 0, 0, 0); saveIdBtn.BackgroundTransparency = 1; saveIdBtn.Text = "💾 Lưu"; saveIdBtn.TextColor3 = Theme.AccentOn; saveIdBtn.Font = Enum.Font.GothamBold; saveIdBtn.TextSize = 10.5; saveIdBtn.ZIndex = 10
local nowPlayingLabel = Instance.new("TextLabel", musicControlFrame); nowPlayingLabel.Size = UDim2.new(0.92, 0, 0, 30); nowPlayingLabel.Position = UDim2.new(0.04, 0, 0, 31); nowPlayingLabel.BackgroundTransparency = 1; nowPlayingLabel.RichText = true; nowPlayingLabel.Text = "<font color='#FFFFFF'>🎵 Chưa có nhạc phát</font>"; nowPlayingLabel.Font = Enum.Font.GothamSemibold; nowPlayingLabel.TextSize = 11; nowPlayingLabel.ZIndex = 10

local function getSongName(id) local s, info = pcall(function() return MarketplaceService:GetProductInfo(tonumber(id)) end); return (s and info and info.Name) or ("Nhạc ID " .. tostring(id)) end
local function playMusic(id)
    if currentSound then currentSound:Destroy() end; local sId = tostring(id):match("%d+"); if not sId then return end
    currentMusicId = sId; nowPlayingLabel.Text = "<font color='#FFFF00'>🎵 Đang phát ID: " .. sId .. "</font>"
    currentSound = Instance.new("Sound", workspace); currentSound.SoundId = "rbxassetid://" .. sId; currentSound.Volume = State.MusicVolume; currentSound:Play()
end
local function stopMusic() if currentSound then currentSound:Stop(); currentSound:Destroy(); currentSound = nil; nowPlayingLabel.Text = "<font color='#FFFFFF'>⏹ Đã dừng nhạc</font>" end end

createDualButtons(page5, "▶️ PHÁT NHẠC", Theme.AccentOn, function() playMusic(musicIdBox.Text) end, "⏸️ TẮT NHẠC", Theme.AccentOff, stopMusic).LayoutOrder = 2
createSlider(page5, "ÂM LƯỢNG 🔊", 0, 10, "MusicVolume", function(val) if currentSound then currentSound.Volume = val end end).LayoutOrder = 3
local savedMusicContent = Instance.new("ScrollingFrame", page5); savedMusicContent.Size = UDim2.new(0.92, 0, 1, -155); savedMusicContent.BackgroundTransparency = 1; savedMusicContent.ScrollBarThickness = 4; savedMusicContent.ScrollBarImageColor3 = Theme.Brand; savedMusicContent.BorderSizePixel = 0; savedMusicContent.AutomaticCanvasSize = Enum.AutomaticSize.Y; savedMusicContent.ZIndex = 10; savedMusicContent.LayoutOrder = 4
local sLayout = Instance.new("UIListLayout", savedMusicContent); sLayout.SortOrder = Enum.SortOrder.LayoutOrder; sLayout.Padding = UDim.new(0, 5)

local musicFile = "MenuVipProMax_SavedMusic.json"
pcall(function() if isfile and isfile(musicFile) then savedMusicList = HttpService:JSONDecode(readfile(musicFile)) or {} end end)
local function saveMusicData() pcall(function() if writefile then writefile(musicFile, HttpService:JSONEncode(savedMusicList)) end end) end
local function renderSavedMusic()
    for _, ch in pairs(savedMusicContent:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    for i, data in ipairs(savedMusicList) do
        local item = Instance.new("Frame", savedMusicContent); item.Size = UDim2.new(1, -6, 0, 34); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; addCorner(item, 8); addStroke(item, Theme.Stroke, 1.2)
        local nBox = Instance.new("TextBox", item); nBox.Size = UDim2.new(0.55, 0, 1, 0); nBox.Position = UDim2.new(0.04, 0, 0, 0); nBox.Text = data.name; nBox.TextColor3 = Theme.TextTitle; nBox.Font = Enum.Font.GothamSemibold; nBox.TextSize = 10.5; nBox.BackgroundTransparency = 1; nBox.TextXAlignment = Enum.TextXAlignment.Left; nBox.ClearTextOnFocus = false; nBox.ZIndex = 10
        nBox.FocusLost:Connect(function() if nBox.Text ~= "" then data.name = nBox.Text; saveMusicData() end end)
        local pBtn = Instance.new("TextButton", item); pBtn.Size = UDim2.new(0.18, 0, 0.65, 0); pBtn.Position = UDim2.new(0.62, 0, 0.175, 0); pBtn.Text = "▶️"; pBtn.BackgroundColor3 = Theme.Brand; pBtn.TextColor3 = Color3.new(1,1,1); pBtn.Font = Enum.Font.GothamBold; pBtn.TextSize = 10; pBtn.ZIndex = 10; addCorner(pBtn, 6)
        local dBtn = Instance.new("TextButton", item); dBtn.Size = UDim2.new(0.15, 0, 0.65, 0); dBtn.Position = UDim2.new(0.82, 0, 0.175, 0); dBtn.Text = "❌"; dBtn.BackgroundColor3 = Theme.AccentOff; dBtn.TextColor3 = Color3.new(1,1,1); dBtn.Font = Enum.Font.GothamBold; dBtn.TextSize = 10; dBtn.ZIndex = 10; addCorner(dBtn, 6)
        pBtn.MouseButton1Click:Connect(function() musicIdBox.Text = data.id; playMusic(data.id) end)
        dBtn.MouseButton1Click:Connect(function() table.remove(savedMusicList, i); saveMusicData(); renderSavedMusic() end)
    end
end
saveIdBtn.MouseButton1Click:Connect(function() local rId = musicIdBox.Text:match("%d+"); if rId then table.insert(savedMusicList, {id = rId, name = getSongName(rId)}); saveMusicData(); renderSavedMusic() end end)
renderSavedMusic()

-- [TAB 6: TP SAVE]
local tpFileName, savedTpList, pendingDeleteAll = "MenuVipProMax_SavedTPs.json", {}, false
pcall(function() if isfile and isfile(tpFileName) then savedTpList = HttpService:JSONDecode(readfile(tpFileName)) or {} end end)
local function saveTpData() pcall(function() if writefile then writefile(tpFileName, HttpService:JSONEncode(savedTpList)) end end) end
local renderSavedTps

createDualButtons(page6, "📍 LƯU VỊ TRÍ", Theme.Brand, function()
    local r = getUniversalRoot(player.Character)
    if r then table.insert(savedTpList, {name = "Lưu Vị Trí " .. (#savedTpList + 1), cframe = {r.CFrame:GetComponents()}}); saveTpData(); renderSavedTps() end
end, "🗑️ XÓA TẤT CẢ", Theme.AccentOff, function()
    if not pendingDeleteAll then pendingDeleteAll = true; MakeToast("⚠️ CẢNH BÁO", "Ấn lần nữa để xóa sạch!", Theme.AccentOff); task.delay(3, function() pendingDeleteAll = false end)
    else savedTpList = {}; saveTpData(); renderSavedTps(); pendingDeleteAll = false end
end).LayoutOrder = 1

local savedTpContent = Instance.new("ScrollingFrame", page6); savedTpContent.Size = UDim2.new(0.92, 0, 1, -48); savedTpContent.BackgroundTransparency = 1; savedTpContent.ScrollBarThickness = 4; savedTpContent.ScrollBarImageColor3 = Theme.Brand; savedTpContent.BorderSizePixel = 0; savedTpContent.AutomaticCanvasSize = Enum.AutomaticSize.Y; savedTpContent.ZIndex = 10; savedTpContent.LayoutOrder = 2
local tpLayout = Instance.new("UIListLayout", savedTpContent); tpLayout.SortOrder = Enum.SortOrder.LayoutOrder; tpLayout.Padding = UDim.new(0, 5)

renderSavedTps = function()
    for _, ch in pairs(savedTpContent:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    for i, data in ipairs(savedTpList) do
        local item = Instance.new("Frame", savedTpContent); item.Size = UDim2.new(1, -6, 0, 34); item.BackgroundColor3 = Theme.ItemBg; item.ZIndex = 10; addCorner(item, 8); addStroke(item, Theme.Stroke, 1.2)
        local nBox = Instance.new("TextBox", item); nBox.Size = UDim2.new(0.48, 0, 1, 0); nBox.Position = UDim2.new(0.04, 0, 0, 0); nBox.Text = data.name; nBox.TextColor3 = Theme.TextTitle; nBox.Font = Enum.Font.GothamSemibold; nBox.TextSize = 11; nBox.BackgroundTransparency = 1; nBox.TextXAlignment = Enum.TextXAlignment.Left; nBox.ClearTextOnFocus = false; nBox.ZIndex = 10
        nBox.FocusLost:Connect(function() if nBox.Text ~= "" then data.name = nBox.Text; saveTpData() end end)
        local tpBtn = Instance.new("TextButton", item); tpBtn.Size = UDim2.new(0.24, 0, 0.65, 0); tpBtn.Position = UDim2.new(0.54, 0, 0.175, 0); tpBtn.Text = "TP"; tpBtn.BackgroundColor3 = Theme.Brand; tpBtn.TextColor3 = Color3.new(1,1,1); tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 10.5; tpBtn.ZIndex = 10; addCorner(tpBtn, 6)
        local delBtn = Instance.new("TextButton", item); delBtn.Size = UDim2.new(0.15, 0, 0.65, 0); delBtn.Position = UDim2.new(0.81, 0, 0.175, 0); delBtn.Text = "X"; delBtn.BackgroundColor3 = Theme.AccentOff; delBtn.TextColor3 = Color3.new(1,1,1); delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 11; delBtn.ZIndex = 10; addCorner(delBtn, 6)
        tpBtn.MouseButton1Click:Connect(function() local r = getUniversalRoot(player.Character); if r then r.CFrame = CFrame.new(unpack(data.cframe)) end end)
        delBtn.MouseButton1Click:Connect(function() table.remove(savedTpList, i); saveTpData(); renderSavedTps() end)
    end
end
renderSavedTps()

-- [TAB 7: TP NGƯỜI CHƠI]
local targetTpPlayer, autoTpPlayerEnabled, spectatePlayerEnabled, wasHorizontalTp = nil, false, false, false

local function restoreNormalPosture()
    local myChar = player.Character; if not myChar then return end
    local myRoot = getUniversalRoot(myChar); local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if myHum then myHum.AutoRotate = true; if not State.Fly and not State.AntiStun then myHum.PlatformStand = false end end
    if myRoot then
        myRoot.AssemblyLinearVelocity = Vector3.zero; myRoot.AssemblyAngularVelocity = Vector3.zero
        local pos = myRoot.Position; local flatLook = Vector3.new(myRoot.CFrame.LookVector.X, 0, myRoot.CFrame.LookVector.Z)
        myRoot.CFrame = flatLook.Magnitude > 0.001 and CFrame.lookAt(pos, pos + flatLook.Unit) or CFrame.new(pos)
    end
    if not State.Noclip then for _, p in ipairs(myChar:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
    wasHorizontalTp = false
end

local targetHeaderRow = Instance.new("Frame", page7)
targetHeaderRow.Size = UDim2.new(0.92, 0, 0, 28); targetHeaderRow.BackgroundColor3 = Color3.fromRGB(28, 30, 42); targetHeaderRow.LayoutOrder = 1; targetHeaderRow.ZIndex = 10; addCorner(targetHeaderRow, 8); addStroke(targetHeaderRow, Theme.Brand, 1.2)

local targetStatusLabel = Instance.new("TextLabel", targetHeaderRow)
targetStatusLabel.Size = UDim2.new(1, -90, 1, 0); targetStatusLabel.Position = UDim2.new(0, 8, 0, 0); targetStatusLabel.BackgroundTransparency = 1; targetStatusLabel.RichText = true; targetStatusLabel.Text = "🎯 <font color='#FF6B81'>Chưa chọn mục tiêu</font>"; targetStatusLabel.TextColor3 = Color3.new(1,1,1); targetStatusLabel.Font = Enum.Font.GothamBold; targetStatusLabel.TextSize = 11; targetStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; targetStatusLabel.TextTruncate = Enum.TextTruncate.AtEnd; targetStatusLabel.ZIndex = 10

local spectateBtn = Instance.new("TextButton", targetHeaderRow)
spectateBtn.Size = UDim2.new(0, 76, 0, 20); spectateBtn.Position = UDim2.new(1, -80, 0.5, -10); spectateBtn.BackgroundColor3 = Color3.fromRGB(55, 35, 45); spectateBtn.Text = "👁️ XEM [TẮT]"; spectateBtn.TextColor3 = Theme.AccentOff; spectateBtn.Font = Enum.Font.GothamBold; spectateBtn.TextSize = 9.5; spectateBtn.ZIndex = 10; addCorner(spectateBtn, 5)
local spectateStroke = addStroke(spectateBtn, Theme.AccentOff, 1, true)

local posCycleFrame = createCycleBtn(page7, "📍 VỊ TRÍ TP:", TpPositions, "TpPositionIdx", function(idx)
    if not TpPositions[idx].IsHorizontal and wasHorizontalTp then restoreNormalPosture() end
end)
posCycleFrame.LayoutOrder = 2; posCycleFrame.Size = UDim2.new(0.92, 0, 0, 28)

local distSliderFrame = createSlider(page7, "📏 Khoảng cách đứng (Studs)", 1, 25, "TpDistance")
distSliderFrame.LayoutOrder = 3; distSliderFrame.Size = UDim2.new(0.92, 0, 0, 34)

local function teleportToSelectedPlayer()
    if not targetTpPlayer or not targetTpPlayer.Character then return false end
    local targetRoot = getUniversalRoot(targetTpPlayer.Character); local targetHum = targetTpPlayer.Character:FindFirstChildOfClass("Humanoid")
    local myChar = player.Character; if not myChar then return false end
    local myRoot = getUniversalRoot(myChar); local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if targetRoot and myRoot and (not targetHum or targetHum.Health > 0) and (not myHum or myHum.Health > 0) then
        local mode = TpPositions[State.TpPositionIdx] or TpPositions[1]
        local targetPos = targetRoot.Position; local flatLook = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
        local baseCF = flatLook.Magnitude > 0.001 and CFrame.lookAt(targetPos, targetPos + flatLook.Unit) or CFrame.new(targetPos)
        if mode.IsHorizontal then
            if myHum then myHum.AutoRotate = false; myHum.PlatformStand = true end
            wasHorizontalTp = true
            for _, p in ipairs(myChar:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end
        elseif wasHorizontalTp then restoreNormalPosture() end
        myRoot.CFrame = baseCF * mode.GetOffset(State.TpDistance)
        myRoot.AssemblyLinearVelocity = Vector3.zero; myRoot.AssemblyAngularVelocity = Vector3.zero
        return true
    end
    return false
end

local tpActionRow = Instance.new("Frame", page7); tpActionRow.Size = UDim2.new(0.92, 0, 0, 28); tpActionRow.BackgroundTransparency = 1; tpActionRow.LayoutOrder = 4
local tpOnceBtn = Instance.new("TextButton", tpActionRow); tpOnceBtn.Size = UDim2.new(0.485, 0, 1, 0); tpOnceBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 65); tpOnceBtn.Text = "⚡ TP 1 LẦN"; tpOnceBtn.TextColor3 = Theme.Brand; tpOnceBtn.Font = Enum.Font.GothamBlack; tpOnceBtn.TextSize = 11; tpOnceBtn.ZIndex = 10; addCorner(tpOnceBtn, 6); addStroke(tpOnceBtn, Theme.Brand, 1.2, true, "Button")
local autoTpBtn = Instance.new("TextButton", tpActionRow); autoTpBtn.Size = UDim2.new(0.485, 0, 1, 0); autoTpBtn.Position = UDim2.new(0.515, 0, 0, 0); autoTpBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 38); autoTpBtn.Text = "🔁 AUTO TP [TẮT]"; autoTpBtn.TextColor3 = Theme.AccentOff; autoTpBtn.Font = Enum.Font.GothamBlack; autoTpBtn.TextSize = 11; autoTpBtn.ZIndex = 10; addCorner(autoTpBtn, 6)
local autoTpStroke = addStroke(autoTpBtn, Theme.AccentOff, 1.2, true)

local function updateTpUI()
    targetStatusLabel.Text = targetTpPlayer and string.format("🎯 <font color='#2ECC71'>%s</font> <font color='#FFD700'>(@%s)</font>", targetTpPlayer.DisplayName, targetTpPlayer.Name) or "🎯 <font color='#FF6B81'>Chưa chọn mục tiêu</font>"
    autoTpBtn.Text = autoTpPlayerEnabled and "🔁 AUTO TP [BẬT]" or "🔁 AUTO TP [TẮT]"
    autoTpBtn.TextColor3 = autoTpPlayerEnabled and Theme.AccentOn or Theme.AccentOff
    autoTpStroke.Color = autoTpPlayerEnabled and Theme.AccentOn or Theme.AccentOff
    spectateBtn.Text = spectatePlayerEnabled and "👁️ XEM [BẬT]" or "👁️ XEM [TẮT]"
    spectateBtn.TextColor3 = spectatePlayerEnabled and Theme.AccentOn or Theme.AccentOff
    spectateStroke.Color = spectatePlayerEnabled and Theme.AccentOn or Theme.AccentOff
end

tpOnceBtn.MouseButton1Click:Connect(function() clickAnimate(tpOnceBtn); if not targetTpPlayer then MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người ở dưới!", Theme.AccentOff); return end; teleportToSelectedPlayer() end)
autoTpBtn.MouseButton1Click:Connect(function() clickAnimate(autoTpBtn); if not targetTpPlayer then MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người ở dưới!", Theme.AccentOff); return end; autoTpPlayerEnabled = not autoTpPlayerEnabled; if not autoTpPlayerEnabled then restoreNormalPosture() end; updateTpUI() end)
spectateBtn.MouseButton1Click:Connect(function() clickAnimate(spectateBtn); if not targetTpPlayer then MakeToast("⚠️ Chưa chọn ai", "Hãy bấm chọn 1 người ở dưới!", Theme.AccentOff); return end; spectatePlayerEnabled = not spectatePlayerEnabled; if not spectatePlayerEnabled and player.Character then pcall(function() workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid") end) end; updateTpUI() end)

local playerListContainer = Instance.new("Frame", page7)
playerListContainer.Size = UDim2.new(0.92, 0, 1, -138); playerListContainer.BackgroundColor3 = Color3.fromRGB(24, 25, 34); playerListContainer.LayoutOrder = 5; playerListContainer.ZIndex = 10; addCorner(playerListContainer, 8); addStroke(playerListContainer, Theme.Stroke, 1.2)

local playerListScroll = Instance.new("ScrollingFrame", playerListContainer)
playerListScroll.Size = UDim2.new(1, -6, 1, -6); playerListScroll.Position = UDim2.new(0, 3, 0, 3); playerListScroll.BackgroundTransparency = 1; playerListScroll.BorderSizePixel = 0; playerListScroll.ScrollBarThickness = 5; playerListScroll.ScrollBarImageColor3 = Theme.Brand; playerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; playerListScroll.ZIndex = 10
local pLayout = Instance.new("UIListLayout", playerListScroll); pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; pLayout.Padding = UDim.new(0, 4)

local function updatePlayerList()
    for _, ch in pairs(playerListScroll:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local sel = (targetTpPlayer == p)
            local btn = Instance.new("TextButton", playerListScroll)
            btn.Size = UDim2.new(1, -8, 0, 30); btn.BackgroundColor3 = sel and Color3.fromRGB(30, 60, 42) or Theme.ItemBg; btn.Text = (sel and "  ✅ " or "  👤 ") .. p.DisplayName .. " (@" .. p.Name .. ")"; btn.TextColor3 = sel and Theme.AccentOn or Theme.TextTitle; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10.5; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.TextTruncate = Enum.TextTruncate.AtEnd; btn.ZIndex = 10; addCorner(btn, 6)
            addStroke(btn, sel and Theme.AccentOn or Theme.Stroke, 1.2)
            btn.MouseButton1Click:Connect(function() targetTpPlayer = p; updateTpUI(); updatePlayerList(); MakeToast("Đã chọn mục tiêu", p.DisplayName, Theme.AccentOn) end)
        end
    end
end
updatePlayerList()
Players.PlayerAdded:Connect(function() task.wait(0.5); updatePlayerList() end)
Players.PlayerRemoving:Connect(function(lp)
    if lp == targetTpPlayer then targetTpPlayer = nil; autoTpPlayerEnabled = false; spectatePlayerEnabled = false; restoreNormalPosture(); updateTpUI() end
    updatePlayerList()
end)

-- [TAB 8: AUTO SKILL]
createDivider(page8, "KỸ NĂNG PHÍM CHỮ")
for _, k in ipairs({"Z", "X", "C", "V", "E", "F"}) do createToggle(page8, "Tự động kích hoạt Phím [" .. k .. "]", "AutoSkill" .. k) end
createDivider(page8, "KỸ NĂNG PHÍM SỐ")
for _, k in ipairs({"1", "2", "3", "4", "5", "6"}) do createToggle(page8, "Tự động kích hoạt Phím [" .. k .. "]", "AutoSkill" .. k) end

local skillMap = {
    {"AutoSkillZ", Enum.KeyCode.Z}, {"AutoSkillX", Enum.KeyCode.X}, {"AutoSkillC", Enum.KeyCode.C},
    {"AutoSkillV", Enum.KeyCode.V}, {"AutoSkillE", Enum.KeyCode.E}, {"AutoSkillF", Enum.KeyCode.F},
    {"AutoSkill1", Enum.KeyCode.One}, {"AutoSkill2", Enum.KeyCode.Two}, {"AutoSkill3", Enum.KeyCode.Three},
    {"AutoSkill4", Enum.KeyCode.Four}, {"AutoSkill5", Enum.KeyCode.Five}, {"AutoSkill6", Enum.KeyCode.Six}
}
task.spawn(function()
    while task.wait(0.5) do
        for _, pair in ipairs(skillMap) do
            if State[pair[1]] then
                pcall(function() Vim:SendKeyEvent(true, pair[2], false, game); task.wait(0.02); Vim:SendKeyEvent(false, pair[2], false, game) end)
                task.wait(0.04)
            end
        end
    end
end)

-- [TAB 9: CẤU HÌNH]
createDivider(page9, "TỐI ƯU HIỆU SUẤT TỐI ĐA")
createSlider(page9, "Giới hạn FPS (Chống nóng máy)", 10, 120, "FpsCapValue", function(val) pcall(function() setfpscap(val) end) end)
createToggle(page9, "Tắt Render 3D (Màn trắng + Giảm CPU)", "Disable3D", function(v)
    pcall(function() RunService:Set3dRenderingEnabled(not v) end)
    screenOverlay.BackgroundColor3 = Color3.new(1, 1, 1); screenOverlay.Visible = v or State.AfkModeScreen
end)
createToggle(page9, "Chế độ AFK Ngủ (Màn đen + 10 FPS)", "AfkModeScreen", function(v)
    pcall(function() setfpscap(v and 10 or State.FpsCapValue); RunService:Set3dRenderingEnabled(not (v or State.Disable3D)) end)
    screenOverlay.BackgroundColor3 = v and Color3.new(0, 0, 0) or Color3.new(1, 1, 1); screenOverlay.Visible = v or State.Disable3D
end)
createDivider(page9, "CÁC CHỨC NĂNG HỦY DIỆT ĐỒ HỌA")
createToggle(page9, "📉 Giảm Lag (Xóa toàn bộ hiệu ứng)", "LowGfx", function(v)
    Lighting.GlobalShadows = not v
    if v then
        for _, obj in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic
                elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then obj.Enabled = false end
            end)
        end
    end
end)
createToggle(page9, "☀️ Xóa sương mù (Ép tắt 100%)", "NoFog")
createToggle(page9, "👻 Ẩn tất cả người chơi khác", "HidePlayers")
createToggle(page9, "🌊 Tối ưu Địa hình & Nước", "OptimizeTerrain", function(v)
    pcall(function() workspace.Terrain.WaterWaveSize = v and 0 or 0.15; workspace.Terrain.WaterWaveSpeed = v and 0 or 10; workspace.Terrain.WaterReflectance = v and 0 or 1 end)
end)
createToggle(page9, "🌑 Tắt đổ bóng vật thể (No Shadows)", "NoShadows", function(v)
    if v then pcall(function() for _, x in ipairs(workspace:GetDescendants()) do if x:IsA("BasePart") then x.CastShadow = false end end end) end
end)
createButton(page9, "🧹 Dọn rác bản đồ (Clear Debris)", Theme.AccentOff, function()
    local c = 0
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if not obj:IsDescendantOf(player.Character) and (obj:IsA("ParticleEmitter") or obj:IsA("Trail")) then obj:Destroy(); c = c + 1 end
        end
    end)
    MakeToast("Dọn Rác", "Đã dọn " .. c .. " hiệu ứng!", Theme.Brand)
end)

-- VÒNG LẶP HỆ THỐNG & VẬT LÝ
task.spawn(function()
    for _, obj in ipairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then table.insert(cachedPrompts, obj) end end
end)
workspace.DescendantAdded:Connect(function(obj) if obj:IsA("ProximityPrompt") then table.insert(cachedPrompts, obj) end end)

task.spawn(function()
    while task.wait(0.4) do
        if State.NoFog then Lighting.FogEnd = 100000; Lighting.FogStart = 0; local a = Lighting:FindFirstChildOfClass("Atmosphere"); if a then a.Density = 0 end end
        if State.Instant then for _, p in ipairs(cachedPrompts) do if p and p.Parent then p.HoldDuration = 0; p.MaxActivationDistance = 25 end end end
        if State.AutoCollect and player.Character then
            local r = getUniversalRoot(player.Character)
            if r then
                for _, p in ipairs(cachedPrompts) do
                    if p.Parent and p.Parent:IsA("BasePart") and p.Enabled and (p.Parent.Position - r.Position).Magnitude <= 50 and fireproximityprompt then pcall(fireproximityprompt, p) end
                end
            end
        end
        if State.HidePlayers then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then for _, v in ipairs(p.Character:GetDescendants()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end end end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = getUniversalRoot(p.Character)
                if hrp then
                    if State.Hitbox then
                        originalHitboxSizes[p] = originalHitboxSizes[p] or hrp.Size
                        hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize); hrp.Transparency = 0.5; hrp.CanCollide = false; hrp.Massless = true
                    elseif originalHitboxSizes[p] then
                        hrp.Size = originalHitboxSizes[p]; hrp.Transparency = 1; hrp.Massless = false; originalHitboxSizes[p] = nil
                    end
                end
                if State.ESP and hrp then
                    ActiveESPs[p] = ActiveESPs[p] or {}
                    if not ActiveESPs[p].Highlight or not ActiveESPs[p].Highlight.Parent then
                        local hl = Instance.new("Highlight", guiParent); hl.Adornee = p.Character; hl.FillColor = Color3.fromRGB(255, 60, 60); hl.FillTransparency = 0.6; ActiveESPs[p].Highlight = hl
                    end
                    if not ActiveESPs[p].Billboard or not ActiveESPs[p].Billboard.Parent then
                        local bg = Instance.new("BillboardGui", guiParent); bg.Size = UDim2.new(0, 180, 0, 40); bg.StudsOffset = Vector3.new(0, 3.5, 0); bg.AlwaysOnTop = true; bg.Adornee = hrp
                        local tl = Instance.new("TextLabel", bg); tl.Name = "NameLabel"; tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.TextColor3 = Color3.fromRGB(255, 60, 60); tl.Font = Enum.Font.GothamBold; tl.TextSize = 11; tl.RichText = true
                        ActiveESPs[p].Billboard = bg
                    end
                    local myR = getUniversalRoot(player.Character)
                    local d = myR and math.floor((myR.Position - hrp.Position).Magnitude) or 0
                    ActiveESPs[p].Billboard.NameLabel.Text = p.DisplayName .. '\n<font color="#00FFFF">[' .. d .. 'm]</font>'
                end
            end
        end
        if not State.ESP then
            for p, t in pairs(ActiveESPs) do if t.Billboard then t.Billboard:Destroy() end; if t.Highlight then t.Highlight:Destroy() end; ActiveESPs[p] = nil end
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = player.Character
    if char and (State.Noclip or (autoTpPlayerEnabled and wasHorizontalTp)) then
        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if autoTpPlayerEnabled and targetTpPlayer then teleportToSelectedPlayer() end
    local char = player.Character; if not char then return end
    local root, hum = getUniversalRoot(char), char:FindFirstChildOfClass("Humanoid")
    if hum and root then
        if not State.Fly and not autoTpPlayerEnabled then
            if State.Speed and hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * ((State.SpeedValue / 50) * 60 * dt)) end
            if State.AutoDash and hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * (State.DashSpeed / 10)) end
        end
        if State.SpinBot and not (autoTpPlayerEnabled and wasHorizontalTp) then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0) end
    end
end)

RunService.Heartbeat:Connect(function()
    if autoTpPlayerEnabled and targetTpPlayer then teleportToSelectedPlayer() end
    if spectatePlayerEnabled and targetTpPlayer and targetTpPlayer.Character then
        local cam = workspace.CurrentCamera; local th = targetTpPlayer.Character:FindFirstChildOfClass("Humanoid")
        if cam and th and cam.CameraSubject ~= th then cam.CameraSubject = th end
    end
    local char = player.Character; if not char then return end
    local root, hum = getUniversalRoot(char), char:FindFirstChildOfClass("Humanoid")
    if hum and root then
        if State.LockPosition then root.Anchored = true end
        if State.Jump then hum.UseJumpPower = true; hum.JumpPower = State.JumpValue end
        if State.Fly then
            hum.PlatformStand = true
            local bv = root:FindFirstChild("FlyBodyVelocity") or Instance.new("BodyVelocity", root)
            bv.Name = "FlyBodyVelocity"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local bg = root:FindFirstChild("FlyBodyGyro") or Instance.new("BodyGyro", root)
            bg.Name = "FlyBodyGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.P = 10000; bg.D = 100
            local cam = workspace.CurrentCamera; bg.CFrame = cam.CFrame
            local md = hum.MoveDirection
            if md.Magnitude > 0 then
                local fl = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
                local fr = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
                local fU = fl.Magnitude > 0.001 and fl.Unit or Vector3.zero
                local rU = fr.Magnitude > 0.001 and fr.Unit or Vector3.zero
                local dir = (cam.CFrame.LookVector * md:Dot(fU)) + (rU * md:Dot(rU))
                bv.Velocity = dir.Magnitude > 0.001 and (dir.Unit * State.FlySpeed) or Vector3.zero
            else bv.Velocity = Vector3.zero end
        else
            if root:FindFirstChild("FlyBodyVelocity") then root.FlyBodyVelocity:Destroy() end
            if root:FindFirstChild("FlyBodyGyro") then root.FlyBodyGyro:Destroy() end
            if not State.AntiStun and not (autoTpPlayerEnabled and wasHorizontalTp) then hum.PlatformStand = false end
        end
        if State.AntiStun then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false); hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            if Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude > 75 then
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
            end
        end
        local light = root:FindFirstChild("PlayerPointLight")
        if State.PlayerLight then
            if not light then light = Instance.new("PointLight", root); light.Name = "PlayerPointLight" end
            light.Brightness = State.LightBrightness; light.Range = State.LightRange; light.Color = PlayerLightColors[State.LightColorIdx].Value
        elseif light then light:Destroy() end
    end
    if State.Reach then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            originalToolSizes[tool] = originalToolSizes[tool] or tool.Handle.Size
            tool.Handle.Size = Vector3.new(State.ReachSize, State.ReachSize, State.ReachSize); tool.Handle.Massless = true; tool.Handle.CanCollide = false; tool.Handle.Transparency = 0.8
        end
    elseif next(originalToolSizes) then
        for t, s in pairs(originalToolSizes) do if t and t.Parent and t:FindFirstChild("Handle") then t.Handle.Size = s; t.Handle.Transparency = 0 end end; originalToolSizes = {}
    end
end)
