-- ════════════════════════════════════════════════════════════════════════
--  CustomUI  –  Roblox UI Library  v2.0
--  github.com/PXG4E/Expeditionsw
-- ════════════════════════════════════════════════════════════════════════

-- ─── Services ────────────────────────────────────────────────────────────
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

-- ─── Global Registries (Obsidian-style) ──────────────────────────────────
local getgenv = getgenv or function() return shared end
local Toggles = {}
local Options = {}
getgenv().Toggles = Toggles
getgenv().Options = Options

-- ─── Theme ───────────────────────────────────────────────────────────────
local Theme = {
    Background    = Color3.fromRGB(13,  13,  13),
    Sidebar       = Color3.fromRGB(20,  20,  20),
    Section       = Color3.fromRGB(17,  17,  17),
    Border        = Color3.fromRGB(35,  35,  35),
    Accent        = Color3.fromRGB(0,  180, 230),
    AccentDark    = Color3.fromRGB(0,  140, 190),
    ToggleOn      = Color3.fromRGB(34, 197,  78),
    ToggleOff     = Color3.fromRGB(220,  50,  50),
    TextPrimary   = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(130, 130, 130),
    TextAccent    = Color3.fromRGB(0,  200, 248),
    TabActive     = Color3.fromRGB(0,  180, 230),
    TabInactive   = Color3.fromRGB(28,  28,  28),
    ButtonBg      = Color3.fromRGB(28,  28,  28),
    InputBg       = Color3.fromRGB(22,  22,  22),
    SliderFill    = Color3.fromRGB(0,  200, 248),
    SliderTrack   = Color3.fromRGB(40,  40,  40),
}

-- ─── Assets ──────────────────────────────────────────────────────────────
local Assets = {
    CheckIcon     = "rbxassetid://139144590557777",
    XIcon         = "rbxassetid://89701503974482",
    CloseIcon     = "rbxassetid://89701503974482",
    SearchIcon    = "rbxassetid://136831385960096",
    ChevronDown   = "rbxassetid://99824465061925",
    WaveLine      = "rbxassetid://109683955374425",
    Header        = "rbxassetid://96636463928154",
    BackgroundBox = "rbxassetid://112926402292773",
    Checkered     = "rbxassetid://138476777747027",
}

-- ─── Helpers ─────────────────────────────────────────────────────────────
local function Tween(obj, props, duration)
    TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

local function Make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function AddCorner(parent, radius)
    return Make("UICorner", { CornerRadius = UDim.new(0, radius or 6) }, parent)
end

local function AddStroke(parent, color, thickness)
    return Make("UIStroke", {
        Color           = color or Theme.Border,
        Thickness       = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function AddPadding(parent, top, right, bottom, left)
    return Make("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 8),
        PaddingRight  = UDim.new(0, right  or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft   = UDim.new(0, left   or 8),
    }, parent)
end

local function AddListLayout(parent, dir, padding, halign)
    return Make("UIListLayout", {
        FillDirection       = dir    or Enum.FillDirection.Vertical,
        Padding             = UDim.new(0, padding or 6),
        HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
        SortOrder           = Enum.SortOrder.LayoutOrder,
    }, parent)
end

-- ════════════════════════════════════════════════════════════════════════
--  Notification System
-- ════════════════════════════════════════════════════════════════════════
local Library = {}

local _notifGui

local function getNotifGui()
    if _notifGui and _notifGui.Parent then return _notifGui end
    local gui = Make("ScreenGui", {
        Name         = "CustomUI_Notifs",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    }, LocalPlayer.PlayerGui)

    _notifGui = Make("Frame", {
        Name                = "Stack",
        BackgroundTransparency = 1,
        Size                = UDim2.new(0, 290, 1, 0),
        Position            = UDim2.new(1, -302, 0, 12),
        AnchorPoint         = Vector2.new(0, 0),
    }, gui)

    AddListLayout(_notifGui, Enum.FillDirection.Vertical, 8)
    return _notifGui
end

function Library:Notify(opts)
    opts = opts or {}
    local title = opts.Title       or "Notification"
    local desc  = opts.Description or ""
    local time  = opts.Time        or 3

    local stack = getNotifGui()

    local card = Make("Frame", {
        BackgroundColor3    = Color3.fromRGB(18, 18, 18),
        Size                = UDim2.new(1, 0, 0, 64),
        ClipsDescendants    = false,
        BackgroundTransparency = 1,
    }, stack)
    AddCorner(card, 8)
    AddStroke(card, Theme.Accent, 1)

    -- left accent bar
    local bar = Make("Frame", {
        BackgroundColor3 = Theme.Accent,
        Size             = UDim2.new(0, 3, 1, 0),
        BorderSizePixel  = 0,
        ZIndex           = 2,
    }, card)
    AddCorner(bar, 2)

    local inner = Make("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, -18, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
    }, card)
    AddPadding(inner, 10, 8, 10, 0)

    Make("TextLabel", {
        Text               = title,
        TextColor3         = Theme.TextAccent,
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, 0, 0, 18),
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, inner)

    Make("TextLabel", {
        Text               = desc,
        TextColor3         = Theme.TextSecondary,
        Font               = Enum.Font.Gotham,
        TextSize           = 11,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, 0, 0, 28),
        Position           = UDim2.new(0, 0, 0, 20),
        TextXAlignment     = Enum.TextXAlignment.Left,
        TextWrapped        = true,
    }, inner)

    -- slide in
    card.BackgroundTransparency = 0
    card.Position = UDim2.new(1, 10, 0, 0)
    Tween(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.25)

    task.delay(time, function()
        Tween(card, { BackgroundTransparency = 1 }, 0.3)
        task.delay(0.35, function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════════════════════════════════════
--  Component Mixin  (shared by Section, LeftGroupbox, RightGroupbox)
-- ════════════════════════════════════════════════════════════════════════
local ComponentMixin = {}

-- ── Divider ──────────────────────────────────────────────────────────────
function ComponentMixin:AddDivider()
    Make("Frame", {
        BackgroundColor3 = Theme.Border,
        Size             = UDim2.new(1, -8, 0, 1),
        BorderSizePixel  = 0,
        LayoutOrder      = self._order,
    }, self._content)
    self._order += 1
end

-- ── Label ─────────────────────────────────────────────────────────────────
function ComponentMixin:AddLabel(text)
    local lbl = Make("TextLabel", {
        Text               = text or "",
        TextColor3         = Theme.TextSecondary,
        Font               = Enum.Font.Gotham,
        TextSize           = 12,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, 0, 0, 20),
        TextXAlignment     = Enum.TextXAlignment.Left,
        TextWrapped        = true,
        LayoutOrder        = self._order,
    }, self._content)
    self._order += 1

    local handle = {}
    function handle:SetText(t) lbl.Text = t end
    -- chainable stub for future AddKeyPicker
    function handle:AddKeyPicker(key, kopts)
        -- TODO: implement keybind picker
        return handle
    end
    return handle
end

-- ── Toggle ────────────────────────────────────────────────────────────────
function ComponentMixin:AddToggle(keyOrOpts, opts2)
    local key, opts
    if type(keyOrOpts) == "string" then
        key = keyOrOpts; opts = opts2 or {}
    else
        opts = keyOrOpts or {}; key = nil
    end

    local text    = opts.Text     or "Toggle"
    local desc    = opts.Desc
    local default = opts.Default  ~= nil and opts.Default or false
    local cb      = opts.Callback or function() end

    local rowH = desc and 54 or 36
    local row = Make("Frame", {
        BackgroundColor3 = Theme.ButtonBg,
        Size             = UDim2.new(1, 0, 0, rowH),
        BorderSizePixel  = 0,
        LayoutOrder      = self._order,
        ClipsDescendants = false,
    }, self._content)
    AddCorner(row, 6)
    AddPadding(row, 8, 10, 8, 10)
    AddStroke(row, Theme.Border, 1)
    self._order += 1

    Make("TextLabel", {
        Text               = text,
        TextColor3         = Theme.TextPrimary,
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, -48, 0, 18),
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, row)

    if desc then
        Make("TextLabel", {
            Text               = desc,
            TextColor3         = Theme.TextSecondary,
            Font               = Enum.Font.Gotham,
            TextSize           = 11,
            BackgroundTransparency = 1,
            Size               = UDim2.new(1, -48, 0, 14),
            Position           = UDim2.new(0, 0, 0, 20),
            TextXAlignment     = Enum.TextXAlignment.Left,
        }, row)
    end

    local btn = Make("TextButton", {
        Text             = "",
        Size             = UDim2.new(0, 38, 0, 22),
        Position         = UDim2.new(1, -38, 0.5, -11),
        BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        ZIndex           = 3,
    }, row)
    AddCorner(btn, 5)

    local icon = Make("ImageLabel", {
        Image                 = default and Assets.CheckIcon or Assets.XIcon,
        ImageColor3           = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size                  = UDim2.new(0, 14, 0, 14),
        Position              = UDim2.new(0.5, -7, 0.5, -7),
        ZIndex                = 4,
    }, btn)

    local value = default
    cb(value)

    local handle = { Value = value }

    local function setValue(v, fire)
        value = v; handle.Value = v
        Tween(btn,  { BackgroundColor3 = v and Theme.ToggleOn or Theme.ToggleOff }, 0.15)
        icon.Image = v and Assets.CheckIcon or Assets.XIcon
        if fire then cb(v) end
    end

    btn.MouseButton1Click:Connect(function() setValue(not value, true) end)

    function handle:Set(v) setValue(v, true) end

    if key then Toggles[key] = handle end
    return handle
end

-- ── Button ────────────────────────────────────────────────────────────────
function ComponentMixin:AddButton(textOrOpts, callback)
    local opts
    if type(textOrOpts) == "string" then
        opts = { Text = textOrOpts, Callback = callback }
    else
        opts = textOrOpts or {}
        opts.Callback = opts.Callback or opts.Func
    end

    local text = opts.Text     or "Button"
    local desc = opts.Desc
    local cb   = opts.Callback or function() end

    local rowH = desc and 54 or 36
    local row = Make("TextButton", {
        Text             = "",
        BackgroundColor3 = Theme.ButtonBg,
        Size             = UDim2.new(1, 0, 0, rowH),
        BorderSizePixel  = 0,
        LayoutOrder      = self._order,
        AutoButtonColor  = false,
    }, self._content)
    AddCorner(row, 6)
    AddPadding(row, 8, 10, 8, 10)
    AddStroke(row, Theme.Border, 1)
    self._order += 1

    Make("TextLabel", {
        Text               = text,
        TextColor3         = Theme.TextPrimary,
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, 0, 0, 18),
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, row)

    if desc then
        Make("TextLabel", {
            Text               = desc,
            TextColor3         = Theme.TextSecondary,
            Font               = Enum.Font.Gotham,
            TextSize           = 11,
            BackgroundTransparency = 1,
            Size               = UDim2.new(1, 0, 0, 14),
            Position           = UDim2.new(0, 0, 0, 20),
            TextXAlignment     = Enum.TextXAlignment.Left,
        }, row)
    end

    row.MouseEnter:Connect(function()
        Tween(row, { BackgroundColor3 = Color3.fromRGB(36, 36, 36) }, 0.1)
    end)
    row.MouseLeave:Connect(function()
        Tween(row, { BackgroundColor3 = Theme.ButtonBg }, 0.1)
    end)
    row.MouseButton1Down:Connect(function()
        Tween(row, { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }, 0.05)
    end)
    row.MouseButton1Up:Connect(function()
        Tween(row, { BackgroundColor3 = Color3.fromRGB(36, 36, 36) }, 0.1)
    end)
    row.MouseButton1Click:Connect(cb)
end

-- ── Slider ────────────────────────────────────────────────────────────────
function ComponentMixin:AddSlider(keyOrOpts, opts2)
    local key, opts
    if type(keyOrOpts) == "string" then
        key = keyOrOpts; opts = opts2 or {}
    else
        opts = keyOrOpts or {}; key = nil
    end

    local text     = opts.Text     or "Slider"
    local desc     = opts.Desc
    local min      = opts.Min      or 0
    local max      = opts.Max      or 100
    local default  = opts.Default  or min
    local rounding = opts.Rounding or 0
    local suffix   = opts.Suffix   or ""
    local cb       = opts.Callback or function() end

    local rowH = desc and 72 or 58
    local row = Make("Frame", {
        BackgroundColor3 = Theme.ButtonBg,
        Size             = UDim2.new(1, 0, 0, rowH),
        BorderSizePixel  = 0,
        LayoutOrder      = self._order,
        ClipsDescendants = false,
    }, self._content)
    AddCorner(row, 6)
    AddPadding(row, 8, 10, 8, 10)
    AddStroke(row, Theme.Border, 1)
    self._order += 1

    Make("TextLabel", {
        Text               = text,
        TextColor3         = Theme.TextPrimary,
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, -62, 0, 18),
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, row)

    if desc then
        Make("TextLabel", {
            Text               = desc,
            TextColor3         = Theme.TextSecondary,
            Font               = Enum.Font.Gotham,
            TextSize           = 11,
            BackgroundTransparency = 1,
            Size               = UDim2.new(1, -62, 0, 14),
            Position           = UDim2.new(0, 0, 0, 20),
            TextXAlignment     = Enum.TextXAlignment.Left,
        }, row)
    end

    -- value box (top-right)
    local valBox = Make("TextLabel", {
        Text             = tostring(default) .. suffix,
        TextColor3       = Theme.TextAccent,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        BackgroundColor3 = Theme.InputBg,
        Size             = UDim2.new(0, 54, 0, 20),
        Position         = UDim2.new(1, -54, 0, 0),
        TextXAlignment   = Enum.TextXAlignment.Center,
    }, row)
    AddCorner(valBox, 4)

    -- track
    local trackY = desc and 44 or 32
    local track = Make("Frame", {
        BackgroundColor3 = Theme.SliderTrack,
        Size             = UDim2.new(1, 0, 0, 6),
        Position         = UDim2.new(0, 0, 0, trackY),
        BorderSizePixel  = 0,
    }, row)
    AddCorner(track, 3)

    local pct0 = (default - min) / (max - min)

    local fill = Make("Frame", {
        BackgroundColor3 = Theme.SliderFill,
        Size             = UDim2.new(pct0, 0, 1, 0),
        BorderSizePixel  = 0,
    }, track)
    AddCorner(fill, 3)

    local thumb = Make("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size             = UDim2.new(0, 14, 0, 14),
        Position         = UDim2.new(pct0, -7, 0.5, -7),
        BorderSizePixel  = 0,
        ZIndex           = 5,
    }, track)
    AddCorner(thumb, 7)

    local value   = default
    local dragging = false
    local handle  = { Value = value }

    local function round(v)
        if rounding == 0 then return math.floor(v + 0.5) end
        local f = 10 ^ rounding
        return math.floor(v * f + 0.5) / f
    end

    local function setValue(v, fire)
        v = round(math.clamp(v, min, max))
        value = v; handle.Value = v
        local p = (v - min) / (max - min)
        fill.Size     = UDim2.new(p, 0, 1, 0)
        thumb.Position = UDim2.new(p, -7, 0.5, -7)
        valBox.Text   = tostring(v) .. suffix
        if fire then cb(v) end
    end

    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local p = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            setValue(min + p * (max - min), true)
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            local p = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            setValue(min + p * (max - min), true)
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    function handle:Set(v) setValue(v, true) end

    if key then Options[key] = handle end
    return handle
end

-- ── Dropdown ──────────────────────────────────────────────────────────────
function ComponentMixin:AddDropdown(keyOrOpts, opts2)
    local key, opts
    if type(keyOrOpts) == "string" then
        key = keyOrOpts; opts = opts2 or {}
    else
        opts = keyOrOpts or {}; key = nil
    end

    local text    = opts.Text     or "Dropdown"
    local desc    = opts.Desc
    local values  = opts.Values   or {}
    local default = opts.Default  or (values[1] or "")
    local cb      = opts.Callback or function() end

    local rowH  = desc and 66 or 50
    local ITEM_H = 28
    local LIST_H = math.min(#values * ITEM_H + 10, 160)

    local row = Make("Frame", {
        BackgroundColor3 = Theme.ButtonBg,
        Size             = UDim2.new(1, 0, 0, rowH),
        BorderSizePixel  = 0,
        LayoutOrder      = self._order,
        ClipsDescendants = false,
        ZIndex           = 2,
    }, self._content)
    AddCorner(row, 6)
    AddPadding(row, 8, 10, 8, 10)
    AddStroke(row, Theme.Border, 1)
    self._order += 1

    Make("TextLabel", {
        Text               = text,
        TextColor3         = Theme.TextPrimary,
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, 0, 0, 18),
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, row)

    if desc then
        Make("TextLabel", {
            Text               = desc,
            TextColor3         = Theme.TextSecondary,
            Font               = Enum.Font.Gotham,
            TextSize           = 11,
            BackgroundTransparency = 1,
            Size               = UDim2.new(1, 0, 0, 14),
            Position           = UDim2.new(0, 0, 0, 20),
            TextXAlignment     = Enum.TextXAlignment.Left,
        }, row)
    end

    local btnY  = desc and 38 or 26
    local selBtn = Make("TextButton", {
        Text             = "",
        BackgroundColor3 = Theme.InputBg,
        Size             = UDim2.new(1, 0, 0, 24),
        Position         = UDim2.new(0, 0, 0, btnY),
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        ZIndex           = 3,
    }, row)
    AddCorner(selBtn, 4)
    AddStroke(selBtn, Theme.Border, 1)

    local selLabel = Make("TextLabel", {
        Text               = default,
        TextColor3         = Theme.TextPrimary,
        Font               = Enum.Font.Gotham,
        TextSize           = 12,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, -30, 1, 0),
        Position           = UDim2.new(0, 8, 0, 0),
        TextXAlignment     = Enum.TextXAlignment.Left,
        ZIndex             = 4,
    }, selBtn)

    local chevron = Make("ImageLabel", {
        Image                 = Assets.ChevronDown,
        ImageColor3           = Theme.TextSecondary,
        BackgroundTransparency = 1,
        Size                  = UDim2.new(0, 12, 0, 12),
        Position              = UDim2.new(1, -20, 0.5, -6),
        ZIndex                = 4,
    }, selBtn)

    -- list panel
    local dropList = Make("ScrollingFrame", {
        BackgroundColor3      = Color3.fromRGB(22, 22, 22),
        Size                  = UDim2.new(1, 0, 0, 0),
        Position              = UDim2.new(0, 0, 1, 4),
        BorderSizePixel       = 0,
        ClipsDescendants      = true,
        Visible               = false,
        ZIndex                = 10,
        ScrollBarThickness    = 3,
        ScrollBarImageColor3  = Theme.Accent,
        CanvasSize            = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize   = Enum.AutomaticSize.Y,
    }, selBtn)
    AddCorner(dropList, 6)
    AddStroke(dropList, Theme.Border, 1)
    AddPadding(dropList, 4, 4, 4, 4)
    AddListLayout(dropList, Enum.FillDirection.Vertical, 3)

    local value  = default
    local open   = false
    local handle = { Value = value }

    for _, v in ipairs(values) do
        local item = Make("TextButton", {
            Text             = v,
            TextColor3       = Theme.TextPrimary,
            Font             = Enum.Font.Gotham,
            TextSize         = 12,
            BackgroundColor3 = Color3.fromRGB(28, 28, 28),
            Size             = UDim2.new(1, 0, 0, ITEM_H),
            BorderSizePixel  = 0,
            AutoButtonColor  = false,
            TextXAlignment   = Enum.TextXAlignment.Left,
            ZIndex           = 11,
        }, dropList)
        AddCorner(item, 4)
        AddPadding(item, 0, 8, 0, 8)

        item.MouseEnter:Connect(function()
            Tween(item, { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }, 0.1)
        end)
        item.MouseLeave:Connect(function()
            Tween(item, { BackgroundColor3 = Color3.fromRGB(28, 28, 28) }, 0.1)
        end)
        item.MouseButton1Click:Connect(function()
            value = v; handle.Value = v
            selLabel.Text = v
            cb(v)
            open = false
            dropList.Visible = false
            Tween(chevron, { Rotation = 0 }, 0.15)
            row.Size = UDim2.new(1, 0, 0, rowH)
        end)
    end

    selBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            dropList.Visible = true
            Tween(dropList, { Size = UDim2.new(1, 0, 0, LIST_H) }, 0.15)
            Tween(chevron,  { Rotation = 180 }, 0.15)
            row.Size = UDim2.new(1, 0, 0, rowH + LIST_H + 8)
        else
            Tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.12)
            Tween(chevron,  { Rotation = 0 }, 0.15)
            task.delay(0.13, function() dropList.Visible = false end)
            row.Size = UDim2.new(1, 0, 0, rowH)
        end
    end)

    function handle:Set(v)
        value = v; handle.Value = v
        selLabel.Text = v
        cb(v)
    end

    if key then Options[key] = handle end
    return handle
end

-- ── Input ─────────────────────────────────────────────────────────────────
function ComponentMixin:AddInput(keyOrOpts, opts2)
    local key, opts
    if type(keyOrOpts) == "string" then
        key = keyOrOpts; opts = opts2 or {}
    else
        opts = keyOrOpts or {}; key = nil
    end

    local text        = opts.Text        or "Input"
    local desc        = opts.Desc
    local placeholder = opts.Placeholder or ""
    local default     = opts.Default     or ""
    local cb          = opts.Callback    or function() end

    local rowH = desc and 66 or 50
    local row = Make("Frame", {
        BackgroundColor3 = Theme.ButtonBg,
        Size             = UDim2.new(1, 0, 0, rowH),
        BorderSizePixel  = 0,
        LayoutOrder      = self._order,
    }, self._content)
    AddCorner(row, 6)
    AddPadding(row, 8, 10, 8, 10)
    AddStroke(row, Theme.Border, 1)
    self._order += 1

    Make("TextLabel", {
        Text               = text,
        TextColor3         = Theme.TextPrimary,
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, 0, 0, 18),
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, row)

    if desc then
        Make("TextLabel", {
            Text               = desc,
            TextColor3         = Theme.TextSecondary,
            Font               = Enum.Font.Gotham,
            TextSize           = 11,
            BackgroundTransparency = 1,
            Size               = UDim2.new(1, 0, 0, 14),
            Position           = UDim2.new(0, 0, 0, 20),
            TextXAlignment     = Enum.TextXAlignment.Left,
        }, row)
    end

    local inputY = desc and 38 or 26
    local box = Make("TextBox", {
        Text               = default,
        PlaceholderText    = placeholder,
        PlaceholderColor3  = Theme.TextSecondary,
        TextColor3         = Theme.TextPrimary,
        Font               = Enum.Font.Gotham,
        TextSize           = 12,
        BackgroundColor3   = Theme.InputBg,
        Size               = UDim2.new(1, 0, 0, 24),
        Position           = UDim2.new(0, 0, 0, inputY),
        BorderSizePixel    = 0,
        ClearTextOnFocus   = false,
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, row)
    AddCorner(box, 4)
    AddStroke(box, Theme.Border, 1)
    AddPadding(box, 0, 8, 0, 8)

    local value  = default
    local handle = { Value = value }

    box.FocusLost:Connect(function()
        value = box.Text; handle.Value = value
        cb(value)
    end)

    function handle:Set(v)
        value = v; handle.Value = v; box.Text = v; cb(v)
    end
    function handle:Get() return handle.Value end

    if key then Options[key] = handle end
    return handle
end

-- ════════════════════════════════════════════════════════════════════════
--  Section / Groupbox factory
-- ════════════════════════════════════════════════════════════════════════
local function newGroupObject(contentFrame)
    local obj = setmetatable({}, { __index = ComponentMixin })
    obj._content = contentFrame
    obj._order   = 0
    return obj
end

local function buildGroupFrame(parent, title)
    local wrapper = Make("Frame", {
        BackgroundColor3 = Theme.Section,
        Size             = UDim2.new(1, 0, 0, 36),
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        LayoutOrder      = 0,
    }, parent)
    AddCorner(wrapper, 8)
    AddStroke(wrapper, Theme.Border, 1)

    -- header
    local header = Make("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 30),
    }, wrapper)

    Make("TextLabel", {
        Text               = title,
        TextColor3         = Theme.TextAccent,
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, -16, 1, 0),
        Position           = UDim2.new(0, 12, 0, 0),
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, header)

    -- wave line under header
    Make("ImageLabel", {
        Image                 = Assets.WaveLine,
        ImageColor3           = Theme.Accent,
        BackgroundTransparency = 1,
        Size                  = UDim2.new(1, 0, 0, 3),
        Position              = UDim2.new(0, 0, 1, -3),
        ScaleType             = Enum.ScaleType.Tile,
        TileSize              = UDim2.new(0, 64, 1, 0),
    }, header)

    -- content
    local content = Make("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 34),
    }, wrapper)
    AddPadding(content, 4, 8, 8, 8)

    local layout = AddListLayout(content, Enum.FillDirection.Vertical, 6)

    local function resize()
        local h = layout.AbsoluteContentSize.Y + 20
        content.Size  = UDim2.new(1, 0, 0, h)
        wrapper.Size  = UDim2.new(1, 0, 0, 34 + h)
    end
    layout.Changed:Connect(resize)

    return wrapper, content
end

-- ════════════════════════════════════════════════════════════════════════
--  Tab Class
-- ════════════════════════════════════════════════════════════════════════
local TabClass = {}
TabClass.__index = TabClass

function TabClass:AddSection(title)
    local _, content = buildGroupFrame(self._scroll, title)
    return newGroupObject(content)
end

function TabClass:AddLeftGroupbox(title, _icon)
    self:_ensureColumns()
    local _, content = buildGroupFrame(self._leftCol, title)
    return newGroupObject(content)
end

function TabClass:AddRightGroupbox(title, _icon)
    self:_ensureColumns()
    local _, content = buildGroupFrame(self._rightCol, title)
    return newGroupObject(content)
end

function TabClass:_ensureColumns()
    if self._columns then return end

    local colRow = Make("Frame", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BorderSizePixel  = 0,
    }, self._scroll)

    local left = Make("Frame", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(0.5, -4, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        Position         = UDim2.new(0, 0, 0, 0),
    }, colRow)
    AddListLayout(left, Enum.FillDirection.Vertical, 8)

    local right = Make("Frame", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(0.5, -4, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        Position         = UDim2.new(0.5, 4, 0, 0),
    }, colRow)
    AddListLayout(right, Enum.FillDirection.Vertical, 8)

    self._leftCol  = left
    self._rightCol = right
    self._columns  = colRow
end

-- ════════════════════════════════════════════════════════════════════════
--  Window  /  Library:CreateWindow
-- ════════════════════════════════════════════════════════════════════════
function Library:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "CustomUI"

    -- ── ScreenGui ──────────────────────────────────────────────────────
    local gui = Make("ScreenGui", {
        Name           = "CustomUI",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 100,
    }, LocalPlayer.PlayerGui)

    -- ── Main window frame ──────────────────────────────────────────────
    local win = Make("Frame", {
        Name             = "Window",
        BackgroundColor3 = Theme.Background,
        Size             = UDim2.new(0, 880, 0, 530),
        Position         = UDim2.new(0.5, -440, 0.5, -265),
        BorderSizePixel  = 0,
        ClipsDescendants = false,
    }, gui)
    AddCorner(win, 10)
    AddStroke(win, Theme.Accent, 2)

    -- shadow (BackgroundBox asset)
    Make("ImageLabel", {
        Image                = Assets.BackgroundBox,
        ImageColor3          = Color3.fromRGB(0, 0, 0),
        ImageTransparency    = 0.5,
        BackgroundTransparency = 1,
        Size                 = UDim2.new(1, 40, 1, 40),
        Position             = UDim2.new(0, -20, 0, -20),
        ZIndex               = 0,
        ScaleType            = Enum.ScaleType.Slice,
        SliceCenter          = Rect.new(20, 20, 20, 20),
    }, win)

    -- ── Title badge (top-left, overlaps border) ────────────────────────
    local badge = Make("Frame", {
        BackgroundColor3 = Theme.Accent,
        Size             = UDim2.new(0, 110, 0, 26),
        Position         = UDim2.new(0, 14, 0, -13),
        ZIndex           = 5,
        ClipsDescendants = false,
    }, win)
    AddCorner(badge, 6)

    Make("UIGradient", {
        Color    = ColorSequence.new(Theme.Accent, Theme.AccentDark),
        Rotation = 90,
    }, badge)

    Make("TextLabel", {
        Text               = title,
        TextColor3         = Color3.fromRGB(255, 255, 255),
        Font               = Enum.Font.GothamBold,
        TextSize           = 13,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, 0, 1, 0),
        TextXAlignment     = Enum.TextXAlignment.Center,
        ZIndex             = 6,
    }, badge)

    -- ── Header bar (search + close) ────────────────────────────────────
    local header = Make("Frame", {
        BackgroundColor3 = Color3.fromRGB(16, 16, 16),
        Size             = UDim2.new(1, 0, 0, 40),
        Position         = UDim2.new(0, 0, 0, 0),
        BorderSizePixel  = 0,
        ZIndex           = 3,
    }, win)
    Make("UICorner", { CornerRadius = UDim.new(0, 10) }, header)

    -- header image decoration
    Make("ImageLabel", {
        Image                = Assets.Header,
        BackgroundTransparency = 1,
        Size                 = UDim2.new(1, 0, 1, 0),
        ImageTransparency    = 0.85,
        ZIndex               = 2,
        ScaleType            = Enum.ScaleType.Crop,
    }, header)

    -- search box
    local searchFrame = Make("Frame", {
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        Size             = UDim2.new(0, 200, 0, 26),
        Position         = UDim2.new(0, 130, 0.5, -13),
        BorderSizePixel  = 0,
        ZIndex           = 4,
    }, header)
    AddCorner(searchFrame, 13)
    AddStroke(searchFrame, Theme.Border, 1)

    Make("ImageLabel", {
        Image                = Assets.SearchIcon,
        ImageColor3          = Theme.TextSecondary,
        BackgroundTransparency = 1,
        Size                 = UDim2.new(0, 14, 0, 14),
        Position             = UDim2.new(0, 8, 0.5, -7),
        ZIndex               = 5,
    }, searchFrame)

    local searchBox = Make("TextBox", {
        Text               = "",
        PlaceholderText    = "Search settings...",
        PlaceholderColor3  = Theme.TextSecondary,
        TextColor3         = Theme.TextPrimary,
        Font               = Enum.Font.Gotham,
        TextSize           = 12,
        BackgroundTransparency = 1,
        Size               = UDim2.new(1, -30, 1, 0),
        Position           = UDim2.new(0, 26, 0, 0),
        BorderSizePixel    = 0,
        ClearTextOnFocus   = false,
        ZIndex             = 5,
        TextXAlignment     = Enum.TextXAlignment.Left,
    }, searchFrame)

    -- close button
    local closeBtn = Make("TextButton", {
        Text             = "",
        BackgroundColor3 = Color3.fromRGB(200, 40, 40),
        Size             = UDim2.new(0, 26, 0, 26),
        Position         = UDim2.new(1, -36, 0.5, -13),
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        ZIndex           = 4,
    }, header)
    AddCorner(closeBtn, 6)

    Make("ImageLabel", {
        Image                = Assets.CloseIcon,
        ImageColor3          = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size                 = UDim2.new(0, 14, 0, 14),
        Position             = UDim2.new(0.5, -7, 0.5, -7),
        ZIndex               = 5,
    }, closeBtn)

    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(230, 60, 60) }, 0.1)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(200, 40, 40) }, 0.1)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- ── Body (below header) ────────────────────────────────────────────
    local body = Make("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
    }, win)

    -- ── Sidebar ────────────────────────────────────────────────────────
    local sidebar = Make("ScrollingFrame", {
        BackgroundColor3     = Theme.Sidebar,
        Size                 = UDim2.new(0, 210, 1, 0),
        BorderSizePixel      = 0,
        ScrollBarThickness   = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize           = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    }, body)
    Make("UICorner", {
        CornerRadius = UDim.new(0, 0),
    }, sidebar)
    AddPadding(sidebar, 8, 8, 8, 8)
    AddListLayout(sidebar, Enum.FillDirection.Vertical, 4)

    -- right separator line
    Make("Frame", {
        BackgroundColor3 = Theme.Border,
        Size             = UDim2.new(0, 1, 1, 0),
        Position         = UDim2.new(0, 210, 0, 0),
        BorderSizePixel  = 0,
    }, body)

    -- ── Content area ───────────────────────────────────────────────────
    local contentArea = Make("Frame", {
        BackgroundColor3 = Theme.Background,
        Size             = UDim2.new(1, -211, 1, 0),
        Position         = UDim2.new(0, 211, 0, 0),
        ClipsDescendants = true,
    }, body)
    Make("UICorner", { CornerRadius = UDim.new(0, 10) }, contentArea)

    -- ── Drag ───────────────────────────────────────────────────────────
    local dragging, dragStart, startPos = false, nil, nil

    header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = win.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- ── Tab management ─────────────────────────────────────────────────
    local tabs     = {}
    local tabBtns  = {}
    local active   = nil

    local WindowObj = {}

    local function selectTab(index)
        if active == index then return end
        active = index
        for i, page in ipairs(tabs) do
            page.Visible = (i == index)
        end
        for i, btn in ipairs(tabBtns) do
            local isActive = (i == index)
            Tween(btn, {
                BackgroundColor3 = isActive and Theme.TabActive or Theme.TabInactive,
                TextColor3       = isActive and Color3.fromRGB(255,255,255) or Theme.TextSecondary,
            }, 0.15)
        end
    end

    function WindowObj:AddTab(name, _icon)
        local idx = #tabs + 1

        -- sidebar button
        local btn = Make("TextButton", {
            Text             = name,
            TextColor3       = Theme.TextSecondary,
            Font             = Enum.Font.GothamBold,
            TextSize         = 13,
            BackgroundColor3 = Theme.TabInactive,
            Size             = UDim2.new(1, 0, 0, 34),
            BorderSizePixel  = 0,
            AutoButtonColor  = false,
            TextXAlignment   = Enum.TextXAlignment.Left,
        }, sidebar)
        AddCorner(btn, 6)
        AddPadding(btn, 0, 0, 0, 12)

        -- page (ScrollingFrame)
        local page = Make("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size                   = UDim2.new(1, 0, 1, 0),
            BorderSizePixel        = 0,
            Visible                = false,
            ScrollBarThickness     = 3,
            ScrollBarImageColor3   = Theme.Accent,
            CanvasSize             = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize    = Enum.AutomaticSize.Y,
            ClipsDescendants       = false,
        }, contentArea)
        AddPadding(page, 12, 12, 12, 12)

        local pageLayout = AddListLayout(page, Enum.FillDirection.Vertical, 10)

        table.insert(tabs, page)
        table.insert(tabBtns, btn)

        btn.MouseButton1Click:Connect(function() selectTab(idx) end)
        btn.MouseEnter:Connect(function()
            if active ~= idx then
                Tween(btn, { BackgroundColor3 = Color3.fromRGB(36, 36, 36) }, 0.1)
            end
        end)
        btn.MouseLeave:Connect(function()
            if active ~= idx then
                Tween(btn, { BackgroundColor3 = Theme.TabInactive }, 0.1)
            end
        end)

        -- auto-select first tab
        if idx == 1 then selectTab(1) end

        local tabObj = setmetatable({}, TabClass)
        tabObj._scroll  = page
        tabObj._layout  = pageLayout
        tabObj._columns = nil
        return tabObj
    end

    return WindowObj
end

-- ════════════════════════════════════════════════════════════════════════
return Library
