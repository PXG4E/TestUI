-- ════════════════════════════════════════════════════════════════════════
--  CustomUI  –  Roblox UI Library  v2.1
--  github.com/PXG4E/TestUI
-- ════════════════════════════════════════════════════════════════════════

-- ─── Services ────────────────────────────────────────────────────────────
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

-- ─── Global Registries ───────────────────────────────────────────────────
local getgenv = getgenv or function() return shared end
local Toggles = {}
local Options = {}
getgenv().Toggles = Toggles
getgenv().Options = Options

-- ─── Theme ───────────────────────────────────────────────────────────────
local T = {
    Bg          = Color3.fromRGB(13,  13,  13),
    Sidebar     = Color3.fromRGB(20,  20,  20),
    Section     = Color3.fromRGB(22,  22,  22),
    Row         = Color3.fromRGB(22,  22,  22),   -- same as section, flat rows
    Border      = Color3.fromRGB(40,  40,  40),
    Accent      = Color3.fromRGB(0,  180, 230),
    AccentDark  = Color3.fromRGB(0,  130, 180),
    ToggleOn    = Color3.fromRGB(34, 197,  78),
    ToggleOff   = Color3.fromRGB(210,  45,  45),
    TxtPrimary  = Color3.fromRGB(235, 235, 235),
    TxtSub      = Color3.fromRGB(120, 120, 120),
    TxtAccent   = Color3.fromRGB(0,  210, 255),
    TabActive   = Color3.fromRGB(0,  180, 230),
    TabInactive = Color3.fromRGB(28,  28,  28),
    InputBg     = Color3.fromRGB(18,  18,  18),
    SliderFill  = Color3.fromRGB(0,  200, 248),
    SliderTrack = Color3.fromRGB(50,  50,  50),
    BtnHover    = Color3.fromRGB(32,  32,  32),
}

-- ─── Assets ──────────────────────────────────────────────────────────────
local A = {
    Check     = "rbxassetid://139144590557777",
    X         = "rbxassetid://89701503974482",
    Chevron   = "rbxassetid://99824465061925",
    Search    = "rbxassetid://136831385960096",
    Wave      = "rbxassetid://109683955374425",
    Header    = "rbxassetid://96636463928154",
    BgBox     = "rbxassetid://112926402292773",
}

-- ─── Helpers ─────────────────────────────────────────────────────────────
local function Tween(obj, props, t)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props):Play()
end

local function New(cls, props, parent)
    local o = Instance.new(cls)
    for k,v in pairs(props or {}) do o[k]=v end
    if parent then o.Parent = parent end
    return o
end

local function Corner(p, r)
    return New("UICorner", {CornerRadius=UDim.new(0, r or 6)}, p)
end

local function Stroke(p, col, thick)
    return New("UIStroke", {
        Color=col or T.Border, Thickness=thick or 1,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    }, p)
end

local function Pad(p, top, right, bot, left)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, top   or 8),
        PaddingRight  = UDim.new(0, right or 8),
        PaddingBottom = UDim.new(0, bot   or 8),
        PaddingLeft   = UDim.new(0, left  or 8),
    }, p)
end

local function List(p, dir, gap, align)
    return New("UIListLayout", {
        FillDirection       = dir   or Enum.FillDirection.Vertical,
        Padding             = UDim.new(0, gap or 0),
        HorizontalAlignment = align or Enum.HorizontalAlignment.Left,
        SortOrder           = Enum.SortOrder.LayoutOrder,
    }, p)
end

local function Label(props, parent)
    props.BackgroundTransparency = 1
    props.BorderSizePixel        = 0
    props.Font        = props.Font        or Enum.Font.Gotham
    props.TextSize    = props.TextSize    or 13
    props.TextColor3  = props.TextColor3  or T.TxtPrimary
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    props.TextTruncate   = props.TextTruncate   or Enum.TextTruncate.AtEnd
    return New("TextLabel", props, parent)
end

-- ════════════════════════════════════════════════════════════════════════
--  Library
-- ════════════════════════════════════════════════════════════════════════
local Library = {}

-- ── Notifications ─────────────────────────────────────────────────────────
local _nStack
local function notifStack()
    if _nStack and _nStack.Parent then return _nStack end
    local g = New("ScreenGui", {
        Name="CustomUI_Notifs", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=999
    }, LocalPlayer.PlayerGui)
    _nStack = New("Frame", {
        BackgroundTransparency=1,
        Size=UDim2.new(0,280,1,0),
        Position=UDim2.new(1,-292,0,12),
    }, g)
    List(_nStack, Enum.FillDirection.Vertical, 8)
    return _nStack
end

function Library:Notify(opts)
    opts = opts or {}
    local card = New("Frame", {
        BackgroundColor3=Color3.fromRGB(20,20,20),
        Size=UDim2.new(1,0,0,62),
        ClipsDescendants=false,
        BackgroundTransparency=0,
    }, notifStack())
    Corner(card, 8)
    Stroke(card, T.Accent, 1)

    New("Frame", {BackgroundColor3=T.Accent, Size=UDim2.new(0,3,1,0), BorderSizePixel=0, ZIndex=2}, card)
    Corner(New("Frame",{BackgroundColor3=T.Accent,Size=UDim2.new(0,3,1,0),BorderSizePixel=0,ZIndex=2},card), 2)

    local inner = New("Frame", {BackgroundTransparency=1, Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,12,0,0)}, card)
    Pad(inner, 10, 0, 10, 0)
    Label({Text=opts.Title or "Notice", TextColor3=T.TxtAccent, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,0,0,16)}, inner)
    Label({Text=opts.Description or "", TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,0,0,26), Position=UDim2.new(0,0,0,18), TextWrapped=true}, inner)

    task.delay(opts.Time or 3, function()
        Tween(card, {BackgroundTransparency=1}, 0.3)
        task.delay(0.35, function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════════════════════════════════════
--  Component Mixin
--  TDS style: flat rows, no per-item border, control on the far right
-- ════════════════════════════════════════════════════════════════════════
local CM = {}

-- shared row factory — transparent bg, sits directly on section
local function Row(content, order, height)
    local r = New("Frame", {
        BackgroundTransparency = 1,
        Size        = UDim2.new(1, 0, 0, height),
        BorderSizePixel = 0,
        LayoutOrder = order,
    }, content)
    return r
end

-- ── Divider ───────────────────────────────────────────────────────────────
function CM:AddDivider()
    local d = New("Frame", {
        BackgroundColor3 = T.Border,
        Size=UDim2.new(1,0,0,1),
        BorderSizePixel=0,
        LayoutOrder=self._o,
    }, self._c)
    self._o += 1
    return d
end

-- ── Label ─────────────────────────────────────────────────────────────────
function CM:AddLabel(text)
    local r = Row(self._c, self._o, 28); self._o+=1
    Pad(r, 2, 0, 2, 0)
    local l = Label({Text=text or "", TextColor3=T.TxtSub, TextSize=12, Size=UDim2.new(1,0,1,0), TextWrapped=true}, r)
    local h = {}
    function h:SetText(t) l.Text=t end
    function h:AddKeyPicker() return h end
    return h
end

-- ── Toggle ────────────────────────────────────────────────────────────────
-- TDS: text+desc on left, 30×30 square button on far right
function CM:AddToggle(keyOrOpts, opts2)
    local key, opts
    if type(keyOrOpts)=="string" then key=keyOrOpts; opts=opts2 or {}
    else opts=keyOrOpts or {}; key=nil end

    local text    = opts.Text    or "Toggle"
    local desc    = opts.Desc
    local default = opts.Default ~= nil and opts.Default or false
    local cb      = opts.Callback or function() end

    local H = desc and 54 or 38
    local r = Row(self._c, self._o, H); self._o+=1
    Pad(r, 6, 6, 6, 10)

    -- text block (left side, excludes button space)
    local textW = UDim2.new(1,-46,0,18)
    Label({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=textW}, r)
    if desc then
        Label({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,-46,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    -- square toggle button (TDS style)
    local btn = New("TextButton", {
        Text="", AutoButtonColor=false,
        BackgroundColor3 = default and T.ToggleOn or T.ToggleOff,
        Size=UDim2.new(0,30,0,30),
        Position=UDim2.new(1,-30,0.5,-15),
        BorderSizePixel=0, ZIndex=3,
    }, r)
    Corner(btn, 6)

    local icon = New("ImageLabel", {
        Image = default and A.Check or A.X,
        ImageColor3=Color3.new(1,1,1),
        BackgroundTransparency=1,
        Size=UDim2.new(0,16,0,16),
        Position=UDim2.new(0.5,-8,0.5,-8),
        ZIndex=4,
    }, btn)

    local val = default
    cb(val)

    local h = {Value=val}
    local function set(v, fire)
        val=v; h.Value=v
        Tween(btn,{BackgroundColor3=v and T.ToggleOn or T.ToggleOff},0.12)
        icon.Image = v and A.Check or A.X
        if fire then cb(v) end
    end
    btn.MouseButton1Click:Connect(function() set(not val,true) end)
    function h:Set(v) set(v,true) end

    if key then Toggles[key]=h end
    return h
end

-- ── Button ────────────────────────────────────────────────────────────────
-- TDS: flat row, small square button on right (or just clickable row)
function CM:AddButton(textOrOpts, callback)
    local opts
    if type(textOrOpts)=="string" then
        opts={Text=textOrOpts, Callback=callback}
    else
        opts=textOrOpts or {}
        opts.Callback=opts.Callback or opts.Func
    end

    local text = opts.Text     or "Button"
    local desc = opts.Desc
    local cb   = opts.Callback or function() end

    local H = desc and 54 or 38
    local r = New("TextButton", {
        Text="", AutoButtonColor=false,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,H),
        BorderSizePixel=0,
        LayoutOrder=self._o,
    }, self._c)
    Pad(r, 6, 6, 6, 10)
    self._o+=1

    Label({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,-44,0,18)}, r)
    if desc then
        Label({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,-44,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    -- small gray icon button on right (TDS style)
    local dot = New("TextButton", {
        Text="→", TextColor3=T.TxtSub, Font=Enum.Font.GothamBold, TextSize=14,
        BackgroundColor3=Color3.fromRGB(35,35,35),
        Size=UDim2.new(0,30,0,30),
        Position=UDim2.new(1,-30,0.5,-15),
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    }, r)
    Corner(dot, 6)

    local function click()
        Tween(dot,{BackgroundColor3=Color3.fromRGB(55,55,55)},0.05)
        task.delay(0.1,function() Tween(dot,{BackgroundColor3=Color3.fromRGB(35,35,35)},0.12) end)
        cb()
    end

    r.MouseEnter:Connect(function() Tween(r,{BackgroundTransparency=0.85},0.1) end)
    r.MouseLeave:Connect(function() Tween(r,{BackgroundTransparency=1},0.1) end)
    r.MouseButton1Click:Connect(click)
    dot.MouseButton1Click:Connect(click)
end

-- ── Slider ────────────────────────────────────────────────────────────────
-- TDS: title left + value box right (same row), then full-width track below
function CM:AddSlider(keyOrOpts, opts2)
    local key, opts
    if type(keyOrOpts)=="string" then key=keyOrOpts; opts=opts2 or {}
    else opts=keyOrOpts or {}; key=nil end

    local text     = opts.Text     or "Slider"
    local desc     = opts.Desc
    local min      = opts.Min      or 0
    local max      = opts.Max      or 100
    local default  = opts.Default  or min
    local rounding = opts.Rounding or 0
    local suffix   = opts.Suffix   or ""
    local cb       = opts.Callback or function() end

    -- heights: title row + optional desc + track area
    local H = (desc and 72 or 58)
    local r = Row(self._c, self._o, H); self._o+=1
    Pad(r, 8, 10, 8, 10)

    -- title (left)
    Label({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,-62,0,18)}, r)
    if desc then
        Label({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,-62,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    -- value box (right, aligned with title)
    local vBox = New("Frame", {
        BackgroundColor3=T.InputBg,
        Size=UDim2.new(0,54,0,22),
        Position=UDim2.new(1,-54,0,-2),
        BorderSizePixel=0,
    }, r)
    Corner(vBox, 5)
    Stroke(vBox, T.Border, 1)
    local vLabel = Label({
        Text=tostring(default)..suffix,
        TextColor3=T.TxtAccent, Font=Enum.Font.GothamBold, TextSize=12,
        Size=UDim2.new(1,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Center,
    }, vBox)

    -- track row
    local trackY = desc and 42 or 30
    local track = New("Frame", {
        BackgroundColor3=T.SliderTrack,
        Size=UDim2.new(1,0,0,6),
        Position=UDim2.new(0,0,0,trackY),
        BorderSizePixel=0,
    }, r)
    Corner(track, 3)

    local p0 = math.clamp((default-min)/(max-min),0,1)
    local fill = New("Frame", {
        BackgroundColor3=T.SliderFill,
        Size=UDim2.new(p0,0,1,0),
        BorderSizePixel=0,
    }, track)
    Corner(fill, 3)

    -- rectangular thumb (TDS style — wider than tall)
    local thumb = New("Frame", {
        BackgroundColor3=Color3.new(1,1,1),
        Size=UDim2.new(0,12,0,20),
        Position=UDim2.new(p0,-6,0.5,-10),
        BorderSizePixel=0, ZIndex=5,
    }, track)
    Corner(thumb, 3)

    local val=default
    local drag=false
    local h={Value=val}

    local function round(v)
        if rounding==0 then return math.floor(v+0.5) end
        local f=10^rounding; return math.floor(v*f+0.5)/f
    end
    local function setVal(v,fire)
        v=round(math.clamp(v,min,max))
        val=v; h.Value=v
        local p=math.clamp((v-min)/(max-min),0,1)
        fill.Size=UDim2.new(p,0,1,0)
        thumb.Position=UDim2.new(p,-6,0.5,-10)
        vLabel.Text=tostring(v)..suffix
        if fire then cb(v) end
    end

    track.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            drag=true
            local p=math.clamp((inp.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            setVal(min+p*(max-min),true)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not drag then return end
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
            local p=math.clamp((inp.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            setVal(min+p*(max-min),true)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            drag=false
        end
    end)

    function h:Set(v) setVal(v,true) end
    if key then Options[key]=h end
    return h
end

-- ── Dropdown ──────────────────────────────────────────────────────────────
function CM:AddDropdown(keyOrOpts, opts2)
    local key, opts
    if type(keyOrOpts)=="string" then key=keyOrOpts; opts=opts2 or {}
    else opts=keyOrOpts or {}; key=nil end

    local text    = opts.Text     or "Dropdown"
    local desc    = opts.Desc
    local values  = opts.Values   or {}
    local default = opts.Default  or (values[1] or "")
    local cb      = opts.Callback or function() end

    local ITEM_H = 28
    local LIST_H = math.min(#values*ITEM_H+10, 160)
    local H      = desc and 66 or 50

    local r = Row(self._c, self._o, H); self._o+=1
    Pad(r, 8, 10, 8, 10)
    r.ClipsDescendants=false; r.ZIndex=2

    Label({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,0,0,18)}, r)
    if desc then
        Label({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    local selY = desc and 38 or 26
    local sel = New("TextButton", {
        Text="", AutoButtonColor=false,
        BackgroundColor3=T.InputBg,
        Size=UDim2.new(1,0,0,24),
        Position=UDim2.new(0,0,0,selY),
        BorderSizePixel=0, ZIndex=3,
    }, r)
    Corner(sel, 5)
    Stroke(sel, T.Border, 1)

    local selLbl = Label({
        Text=default, TextSize=12,
        Size=UDim2.new(1,-28,1,0),
        Position=UDim2.new(0,8,0,0),
        ZIndex=4,
    }, sel)

    local chev = New("ImageLabel", {
        Image=A.Chevron, ImageColor3=T.TxtSub,
        BackgroundTransparency=1,
        Size=UDim2.new(0,12,0,12),
        Position=UDim2.new(1,-18,0.5,-6),
        ZIndex=4,
    }, sel)

    local list = New("ScrollingFrame", {
        BackgroundColor3=Color3.fromRGB(22,22,22),
        Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,1,4),
        BorderSizePixel=0,
        ClipsDescendants=true,
        Visible=false,
        ZIndex=10,
        ScrollBarThickness=3,
        ScrollBarImageColor3=T.Accent,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
    }, sel)
    Corner(list, 6)
    Stroke(list, T.Border, 1)
    Pad(list, 4, 4, 4, 4)
    List(list, Enum.FillDirection.Vertical, 3)

    local open=false
    local val=default
    local h={Value=val}

    for _,v in ipairs(values) do
        local item = New("TextButton", {
            Text=v, TextColor3=T.TxtPrimary, Font=Enum.Font.Gotham, TextSize=12,
            BackgroundColor3=Color3.fromRGB(30,30,30),
            Size=UDim2.new(1,0,0,ITEM_H),
            BorderSizePixel=0, AutoButtonColor=false,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11,
        }, list)
        Corner(item, 4)
        Pad(item, 0, 8, 0, 8)
        item.MouseEnter:Connect(function() Tween(item,{BackgroundColor3=Color3.fromRGB(42,42,42)},0.1) end)
        item.MouseLeave:Connect(function() Tween(item,{BackgroundColor3=Color3.fromRGB(30,30,30)},0.1) end)
        item.MouseButton1Click:Connect(function()
            val=v; h.Value=v; selLbl.Text=v; cb(v)
            open=false
            list.Visible=false
            Tween(chev,{Rotation=0},0.15)
            r.Size=UDim2.new(1,0,0,H)
        end)
    end

    sel.MouseButton1Click:Connect(function()
        open=not open
        if open then
            list.Visible=true
            Tween(list,{Size=UDim2.new(1,0,0,LIST_H)},0.15)
            Tween(chev,{Rotation=180},0.15)
            r.Size=UDim2.new(1,0,0,H+LIST_H+8)
        else
            Tween(list,{Size=UDim2.new(1,0,0,0)},0.12)
            Tween(chev,{Rotation=0},0.15)
            task.delay(0.13,function() list.Visible=false end)
            r.Size=UDim2.new(1,0,0,H)
        end
    end)

    function h:Set(v) val=v; h.Value=v; selLbl.Text=v; cb(v) end
    if key then Options[key]=h end
    return h
end

-- ── Input ─────────────────────────────────────────────────────────────────
function CM:AddInput(keyOrOpts, opts2)
    local key, opts
    if type(keyOrOpts)=="string" then key=keyOrOpts; opts=opts2 or {}
    else opts=keyOrOpts or {}; key=nil end

    local text        = opts.Text        or "Input"
    local desc        = opts.Desc
    local placeholder = opts.Placeholder or ""
    local default     = opts.Default     or ""
    local cb          = opts.Callback    or function() end

    local H = desc and 66 or 50
    local r = Row(self._c, self._o, H); self._o+=1
    Pad(r, 8, 10, 8, 10)

    Label({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,0,0,18)}, r)
    if desc then
        Label({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    local inputY = desc and 38 or 26
    local box = New("TextBox", {
        Text=default, PlaceholderText=placeholder,
        PlaceholderColor3=T.TxtSub, TextColor3=T.TxtPrimary,
        Font=Enum.Font.Gotham, TextSize=12,
        BackgroundColor3=T.InputBg,
        Size=UDim2.new(1,0,0,24),
        Position=UDim2.new(0,0,0,inputY),
        BorderSizePixel=0, ClearTextOnFocus=false,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, r)
    Corner(box, 5)
    Stroke(box, T.Border, 1)
    Pad(box, 0, 8, 0, 8)

    local val=default
    local h={Value=val}
    box.FocusLost:Connect(function() val=box.Text; h.Value=val; cb(val) end)
    function h:Set(v) val=v; h.Value=v; box.Text=v; cb(v) end
    function h:Get() return h.Value end
    if key then Options[key]=h end
    return h
end

-- ════════════════════════════════════════════════════════════════════════
--  Section / Groupbox builder
-- ════════════════════════════════════════════════════════════════════════
local function newCM(content)
    local o = setmetatable({}, {__index=CM})
    o._c=content; o._o=0
    return o
end

local function buildSection(parent, title, isColumn)
    -- outer frame
    local wrap = New("Frame", {
        BackgroundColor3=T.Section,
        Size=UDim2.new(1,0,0,38),
        BorderSizePixel=0,
        ClipsDescendants=false,
        LayoutOrder=0,
    }, parent)
    Corner(wrap, 8)
    Stroke(wrap, T.Border, 1)

    -- header
    local hdr = New("Frame", {
        BackgroundColor3=Color3.fromRGB(18,18,18),
        Size=UDim2.new(1,0,0,32),
        BorderSizePixel=0,
    }, wrap)
    New("UICorner",{CornerRadius=UDim.new(0,8)},hdr)

    Label({
        Text=title, Font=Enum.Font.GothamBold,
        TextColor3=T.TxtAccent, TextSize=13,
        Size=UDim2.new(1,-16,1,0),
        Position=UDim2.new(0,12,0,0),
    }, hdr)

    -- wave line under header
    New("ImageLabel", {
        Image=A.Wave, ImageColor3=T.Accent,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,4),
        Position=UDim2.new(0,0,1,-4),
        ScaleType=Enum.ScaleType.Tile,
        TileSize=UDim2.new(0,64,1,0),
    }, hdr)

    -- content list
    local content = New("Frame", {
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,0,36),
        ClipsDescendants=false,
    }, wrap)
    Pad(content, 4, 8, 8, 8)

    local layout = List(content, Enum.FillDirection.Vertical, 2)

    -- auto-resize
    local function resize()
        local h = layout.AbsoluteContentSize.Y+18
        content.Size=UDim2.new(1,0,0,h)
        wrap.Size=UDim2.new(1,0,0,36+h)
    end
    layout.Changed:Connect(resize)

    -- thin separator between rows
    local sep = New("Frame", {
        BackgroundColor3=T.Border,
        Size=UDim2.new(1,-16,0,1),
        Position=UDim2.new(0,8,0,32),
        BorderSizePixel=0,
    }, wrap)

    return wrap, content
end

-- ════════════════════════════════════════════════════════════════════════
--  Tab Class
-- ════════════════════════════════════════════════════════════════════════
local TabClass = {}
TabClass.__index = TabClass

function TabClass:AddSection(title)
    local _,c = buildSection(self._scroll, title)
    return newCM(c)
end

function TabClass:AddLeftGroupbox(title)
    self:_cols()
    local _,c = buildSection(self._lCol, title)
    return newCM(c)
end

function TabClass:AddRightGroupbox(title)
    self:_cols()
    local _,c = buildSection(self._rCol, title)
    return newCM(c)
end

function TabClass:_cols()
    if self._colsDone then return end
    self._colsDone=true

    local row = New("Frame", {
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,0),
        AutomaticSize=Enum.AutomaticSize.Y,
        BorderSizePixel=0,
    }, self._scroll)

    local l = New("Frame", {
        BackgroundTransparency=1,
        Size=UDim2.new(0.5,-5,0,0),
        AutomaticSize=Enum.AutomaticSize.Y,
    }, row)
    List(l, Enum.FillDirection.Vertical, 8)

    local r = New("Frame", {
        BackgroundTransparency=1,
        Size=UDim2.new(0.5,-5,0,0),
        AutomaticSize=Enum.AutomaticSize.Y,
        Position=UDim2.new(0.5,5,0,0),
    }, row)
    List(r, Enum.FillDirection.Vertical, 8)

    self._lCol=l; self._rCol=r
end

-- ════════════════════════════════════════════════════════════════════════
--  Window
-- ════════════════════════════════════════════════════════════════════════
function Library:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "CustomUI"

    local gui = New("ScreenGui", {
        Name="CustomUI", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=100,
    }, LocalPlayer.PlayerGui)

    -- ── Window frame ──────────────────────────────────────────────────
    local win = New("Frame", {
        Name="Window",
        BackgroundColor3=T.Bg,
        Size=UDim2.new(0,880,0,530),
        Position=UDim2.new(0.5,-440,0.5,-265),
        BorderSizePixel=0,
        ClipsDescendants=false,
    }, gui)
    Corner(win, 10)
    Stroke(win, T.Accent, 2)

    -- drop shadow
    New("ImageLabel", {
        Image=A.BgBox, ImageColor3=Color3.new(0,0,0),
        ImageTransparency=0.6,
        BackgroundTransparency=1,
        Size=UDim2.new(1,60,1,60),
        Position=UDim2.new(0,-30,0,-30),
        ZIndex=0,
        ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(20,20,20,20),
    }, win)

    -- ── Title badge ───────────────────────────────────────────────────
    local badge = New("Frame", {
        BackgroundColor3=T.Accent,
        Size=UDim2.new(0,120,0,28),
        Position=UDim2.new(0,16,0,-14),
        ZIndex=5,
    }, win)
    Corner(badge, 7)
    New("UIGradient", {Color=ColorSequence.new(T.Accent,T.AccentDark), Rotation=90}, badge)
    Label({
        Text=title, Font=Enum.Font.GothamBold, TextSize=14,
        TextColor3=Color3.new(1,1,1),
        Size=UDim2.new(1,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Center,
        ZIndex=6,
    }, badge)

    -- ── Header bar ────────────────────────────────────────────────────
    local hdr = New("Frame", {
        BackgroundColor3=Color3.fromRGB(16,16,16),
        Size=UDim2.new(1,0,0,44),
        BorderSizePixel=0, ZIndex=3,
    }, win)
    New("UICorner",{CornerRadius=UDim.new(0,10)},hdr)

    -- header bg image
    New("ImageLabel", {
        Image=A.Header, BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,0),
        ImageTransparency=0.82, ZIndex=2,
        ScaleType=Enum.ScaleType.Crop,
    }, hdr)

    -- search bar
    local searchFrame = New("Frame", {
        BackgroundColor3=Color3.fromRGB(28,28,28),
        Size=UDim2.new(0,220,0,28),
        Position=UDim2.new(0,156,0.5,-14),
        BorderSizePixel=0, ZIndex=4,
    }, hdr)
    Corner(searchFrame, 14)
    Stroke(searchFrame, T.Border, 1)

    New("ImageLabel", {
        Image=A.Search, ImageColor3=T.TxtSub,
        BackgroundTransparency=1,
        Size=UDim2.new(0,14,0,14),
        Position=UDim2.new(0,9,0.5,-7),
        ZIndex=5,
    }, searchFrame)

    New("TextBox", {
        Text="", PlaceholderText="Search settings...",
        PlaceholderColor3=T.TxtSub, TextColor3=T.TxtPrimary,
        Font=Enum.Font.Gotham, TextSize=12,
        BackgroundTransparency=1,
        Size=UDim2.new(1,-32,1,0),
        Position=UDim2.new(0,28,0,0),
        BorderSizePixel=0, ClearTextOnFocus=false,
        ZIndex=5, TextXAlignment=Enum.TextXAlignment.Left,
    }, searchFrame)

    -- close button
    local closeBtn = New("TextButton", {
        Text="", AutoButtonColor=false,
        BackgroundColor3=Color3.fromRGB(200,40,40),
        Size=UDim2.new(0,28,0,28),
        Position=UDim2.new(1,-38,0.5,-14),
        BorderSizePixel=0, ZIndex=4,
    }, hdr)
    Corner(closeBtn, 7)
    New("ImageLabel", {
        Image=A.X, ImageColor3=Color3.new(1,1,1),
        BackgroundTransparency=1,
        Size=UDim2.new(0,14,0,14),
        Position=UDim2.new(0.5,-7,0.5,-7),
        ZIndex=5,
    }, closeBtn)
    closeBtn.MouseEnter:Connect(function() Tween(closeBtn,{BackgroundColor3=Color3.fromRGB(230,55,55)},0.1) end)
    closeBtn.MouseLeave:Connect(function() Tween(closeBtn,{BackgroundColor3=Color3.fromRGB(200,40,40)},0.1) end)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- ── Body ──────────────────────────────────────────────────────────
    local body = New("Frame", {
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,-44),
        Position=UDim2.new(0,0,0,44),
    }, win)

    -- sidebar
    local sidebar = New("ScrollingFrame", {
        BackgroundColor3=T.Sidebar,
        Size=UDim2.new(0,200,1,0),
        BorderSizePixel=0,
        ScrollBarThickness=2,
        ScrollBarImageColor3=T.Accent,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
    }, body)
    Pad(sidebar, 10, 8, 10, 8)
    List(sidebar, Enum.FillDirection.Vertical, 4)

    -- separator
    New("Frame", {
        BackgroundColor3=T.Border,
        Size=UDim2.new(0,1,1,0),
        Position=UDim2.new(0,200,0,0),
        BorderSizePixel=0,
    }, body)

    -- content area
    local content = New("Frame", {
        BackgroundColor3=T.Bg,
        Size=UDim2.new(1,-201,1,0),
        Position=UDim2.new(0,201,0,0),
        ClipsDescendants=true,
    }, body)
    New("UICorner",{CornerRadius=UDim.new(0,10)},content)

    -- drag
    local drag,dStart,dPos=false,nil,nil
    hdr.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; dStart=inp.Position; dPos=win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType==Enum.UserInputType.MouseMovement then
            local d=inp.Position-dStart
            win.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)

    -- ── Tab management ────────────────────────────────────────────────
    local pages, btns, active = {}, {}, nil

    local function selectTab(i)
        if active==i then return end
        active=i
        for j,pg in ipairs(pages) do pg.Visible=(j==i) end
        for j,btn in ipairs(btns) do
            local on=(j==i)
            Tween(btn,{
                BackgroundColor3=on and T.TabActive or T.TabInactive,
                TextColor3=on and Color3.new(1,1,1) or T.TxtSub,
            },0.15)
        end
    end

    local Win = {}

    function Win:AddTab(name)
        local idx=#pages+1

        local btn = New("TextButton", {
            Text=name, TextColor3=T.TxtSub,
            Font=Enum.Font.GothamBold, TextSize=13,
            BackgroundColor3=T.TabInactive,
            Size=UDim2.new(1,0,0,36),
            BorderSizePixel=0, AutoButtonColor=false,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, sidebar)
        Corner(btn, 7)
        Pad(btn, 0, 0, 0, 12)

        local page = New("ScrollingFrame", {
            BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0),
            BorderSizePixel=0,
            Visible=false,
            ScrollBarThickness=3,
            ScrollBarImageColor3=T.Accent,
            CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            ClipsDescendants=false,
        }, content)
        Pad(page, 12, 12, 12, 12)
        List(page, Enum.FillDirection.Vertical, 10)

        table.insert(pages, page)
        table.insert(btns, btn)

        btn.MouseButton1Click:Connect(function() selectTab(idx) end)
        btn.MouseEnter:Connect(function()
            if active~=idx then Tween(btn,{BackgroundColor3=Color3.fromRGB(36,36,36)},0.1) end
        end)
        btn.MouseLeave:Connect(function()
            if active~=idx then Tween(btn,{BackgroundColor3=T.TabInactive},0.1) end
        end)

        if idx==1 then selectTab(1) end

        local tab = setmetatable({}, TabClass)
        tab._scroll=page; tab._colsDone=false
        return tab
    end

    return Win
end

return Library
