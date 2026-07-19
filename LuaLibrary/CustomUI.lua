-- ════════════════════════════════════════════════════════════════════════
--  CustomUI  –  Roblox UI Library  v3.0  (TDS-accurate)
--  github.com/PXG4E/TestUI
-- ════════════════════════════════════════════════════════════════════════

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

-- ─── Global Registries ───────────────────────────────────────────────────
local getgenv = getgenv or function() return shared end
local Toggles = {}; local Options = {}
getgenv().Toggles = Toggles; getgenv().Options = Options

-- ─── Theme ───────────────────────────────────────────────────────────────
local T = {
    Bg          = Color3.fromRGB(10,  10,  10),
    Sidebar     = Color3.fromRGB(16,  16,  16),
    Section     = Color3.fromRGB(18,  18,  18),
    Header      = Color3.fromRGB(14,  14,  14),
    Border      = Color3.fromRGB(35,  35,  35),
    Accent      = Color3.fromRGB(0,   190, 235),
    AccentDark  = Color3.fromRGB(0,   130, 180),
    TxtPrimary  = Color3.fromRGB(230, 230, 230),
    TxtSub      = Color3.fromRGB(110, 110, 110),
    TxtAccent   = Color3.fromRGB(0,   210, 255),
    TabActive   = Color3.fromRGB(0,   185, 235),
    TabInactive = Color3.fromRGB(26,  26,  26),
    InputBg     = Color3.fromRGB(22,  22,  22),
    SliderTrack = Color3.fromRGB(38,  38,  38),
    -- Toggle gradient colours (set via UIGradient)
    GreenTop    = Color3.fromRGB(110, 210, 55),
    GreenBot    = Color3.fromRGB(38,  145, 12),
    RedTop      = Color3.fromRGB(205, 55,  40),
    RedBot      = Color3.fromRGB(140, 12,  12),
    BtnTop      = Color3.fromRGB(85,  85,  85),
    BtnBot      = Color3.fromRGB(48,  48,  48),
}

-- ─── Asset Auto-Downloader ───────────────────────────────────────────────
local ASSET_FOLDER = "CustomUI"
local BASE_URL     = "https://raw.githubusercontent.com/PXG4E/TestUI/main/assets/ui/"

local ASSET_FILES = {
    Check      = "check.png",
    X          = "x.png",
    Chevron    = "chevron.png",
    Search     = "search.png",
    Wave       = "wave.png",
    IconAudio  = "icon_audio.png",
    IconGear   = "icon_gear.png",
    IconEye    = "icon_eye.png",
    IconTarget = "icon_crosshair.png",
    IconSkull  = "icon_skull.png",
    IconDots   = "icon_dots.png",
    IconKeys   = "icon_keyboard.png",
    IconFlask  = "icon_flask.png",
    IconPerson = "icon_person.png",
    IconLock   = "icon_lock.png",
    TabBg      = "tab_bg.png",
}

if not isfolder(ASSET_FOLDER) then makefolder(ASSET_FOLDER) end

local missing = {}
for key, file in pairs(ASSET_FILES) do
    local path = ASSET_FOLDER.."/"..file
    if not isfile(path) then missing[#missing+1] = {key=key, file=file, path=path} end
end

if #missing > 0 then
    local loadGui = Instance.new("ScreenGui")
    loadGui.Name="CustomUI_Loading"; loadGui.ResetOnSpawn=false
    loadGui.DisplayOrder=9999; loadGui.Parent=LocalPlayer.PlayerGui
    local lbl = Instance.new("TextLabel")
    lbl.Size=UDim2.new(0,280,0,34); lbl.Position=UDim2.new(0.5,-140,1,-54)
    lbl.BackgroundColor3=Color3.fromRGB(12,12,12)
    lbl.TextColor3=T.TxtAccent; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13
    lbl.Text="CustomUI — downloading assets…"; lbl.BorderSizePixel=0; lbl.Parent=loadGui
    Instance.new("UICorner",lbl).CornerRadius=UDim.new(0,8)
    for i,e in ipairs(missing) do
        lbl.Text=("CustomUI — %d / %d"):format(i,#missing)
        local ok,res=pcall(function() return game:HttpGet(BASE_URL..e.file,true) end)
        if ok and res and #res>0 then writefile(e.path,res) end
    end
    loadGui:Destroy()
end

local A = {}
for key, file in pairs(ASSET_FILES) do
    A[key] = getcustomasset(ASSET_FOLDER.."/"..file)
end

-- ─── Helpers ─────────────────────────────────────────────────────────────
local function Tween(obj,props,t)
    TweenService:Create(obj,TweenInfo.new(t or 0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
end
local function New(cls,props,parent)
    local o=Instance.new(cls)
    for k,v in pairs(props or {}) do o[k]=v end
    if parent then o.Parent=parent end
    return o
end
local function Corner(p,r) return New("UICorner",{CornerRadius=UDim.new(0,r or 6)},p) end
local function Stroke(p,col,thick)
    return New("UIStroke",{Color=col or T.Border,Thickness=thick or 1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},p)
end
local function Pad(p,top,right,bot,left)
    return New("UIPadding",{
        PaddingTop=UDim.new(0,top or 8),PaddingRight=UDim.new(0,right or 8),
        PaddingBottom=UDim.new(0,bot or 8),PaddingLeft=UDim.new(0,left or 8),
    },p)
end
local function List(p,dir,gap,align)
    return New("UIListLayout",{
        FillDirection=dir or Enum.FillDirection.Vertical,
        Padding=UDim.new(0,gap or 0),
        HorizontalAlignment=align or Enum.HorizontalAlignment.Left,
        SortOrder=Enum.SortOrder.LayoutOrder,
    },p)
end
local function Lbl(props,parent)
    props.BackgroundTransparency=1; props.BorderSizePixel=0
    props.Font=props.Font or Enum.Font.Gotham
    props.TextSize=props.TextSize or 13
    props.TextColor3=props.TextColor3 or T.TxtPrimary
    props.TextXAlignment=props.TextXAlignment or Enum.TextXAlignment.Left
    props.TextTruncate=props.TextTruncate or Enum.TextTruncate.AtEnd
    return New("TextLabel",props,parent)
end

-- gradient helper — sets a vertical gradient on a frame
local function Grad(parent, topCol, botCol)
    local g = parent:FindFirstChildOfClass("UIGradient") or New("UIGradient",{Rotation=90},parent)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, topCol),
        ColorSequenceKeypoint.new(1, botCol),
    })
    return g
end

-- ════════════════════════════════════════════════════════════════════════
--  Library
-- ════════════════════════════════════════════════════════════════════════
local Library = {}

-- ── Notifications ─────────────────────────────────────────────────────────
local _nStack
local function notifStack()
    if _nStack and _nStack.Parent then return _nStack end
    local g=New("ScreenGui",{Name="CustomUI_Notifs",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=999},LocalPlayer.PlayerGui)
    _nStack=New("Frame",{BackgroundTransparency=1,Size=UDim2.new(0,280,1,0),Position=UDim2.new(1,-292,0,12)},g)
    List(_nStack,Enum.FillDirection.Vertical,8)
    return _nStack
end
function Library:Notify(opts)
    opts=opts or {}
    local card=New("Frame",{BackgroundColor3=Color3.fromRGB(18,18,18),Size=UDim2.new(1,0,0,62)},notifStack())
    Corner(card,8); Stroke(card,T.Accent,1)
    New("Frame",{BackgroundColor3=T.Accent,Size=UDim2.new(0,3,1,0),BorderSizePixel=0,ZIndex=2},card)
    local inner=New("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,12,0,0)},card)
    Pad(inner,10,0,10,0)
    Lbl({Text=opts.Title or "Notice",TextColor3=T.TxtAccent,Font=Enum.Font.GothamBold,TextSize=13,Size=UDim2.new(1,0,0,16)},inner)
    Lbl({Text=opts.Description or "",TextColor3=T.TxtSub,TextSize=11,Size=UDim2.new(1,0,0,26),Position=UDim2.new(0,0,0,18),TextWrapped=true},inner)
    task.delay(opts.Time or 3,function()
        Tween(card,{BackgroundTransparency=1},0.3)
        task.delay(0.35,function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════════════════════════════════════
--  Component Mixin  —  TDS-accurate row styling
-- ════════════════════════════════════════════════════════════════════════
local CM = {}

local function Row(content, order, height)
    return New("Frame",{
        BackgroundTransparency=1, Size=UDim2.new(1,0,0,height),
        BorderSizePixel=0, LayoutOrder=order,
    },content)
end

-- ── Divider ───────────────────────────────────────────────────────────────
function CM:AddDivider()
    local d=New("Frame",{BackgroundColor3=T.Border,Size=UDim2.new(1,0,0,1),BorderSizePixel=0,LayoutOrder=self._o},self._c)
    self._o+=1; return d
end

-- ── Label ─────────────────────────────────────────────────────────────────
function CM:AddLabel(text)
    local r=Row(self._c,self._o,26); self._o+=1
    Pad(r,4,0,4,0)
    local l=Lbl({Text=text or "",TextColor3=T.TxtSub,TextSize=12,Size=UDim2.new(1,0,1,0),TextWrapped=true},r)
    local h={}
    function h:SetText(t) l.Text=t end
    function h:AddKeyPicker() return h end
    return h
end

-- ── Toggle ────────────────────────────────────────────────────────────────
-- TDS: gradient green/red rounded-square button on the far right
function CM:AddToggle(keyOrOpts, opts2)
    local key,opts
    if type(keyOrOpts)=="string" then key=keyOrOpts; opts=opts2 or {}
    else opts=keyOrOpts or {}; key=nil end

    local text    = opts.Text    or "Toggle"
    local desc    = opts.Desc
    local default = opts.Default ~= nil and opts.Default or false
    local cb      = opts.Callback or function() end

    local H = desc and 54 or 40
    local r = Row(self._c, self._o, H); self._o+=1
    Pad(r, 6, 8, 6, 12)

    Lbl({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,-52,0,18)}, r)
    if desc then
        Lbl({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,-52,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    -- TDS toggle: rounded square with gradient
    local BTN = 32
    local btn = New("TextButton",{
        Text="", AutoButtonColor=false,
        BackgroundColor3=Color3.new(1,1,1),  -- gradient overrides this
        Size=UDim2.new(0,BTN,0,BTN),
        Position=UDim2.new(1,-BTN,0.5,-BTN/2),
        BorderSizePixel=0, ZIndex=3,
    },r)
    Corner(btn, 6)

    local grad = Grad(btn, default and T.GreenTop or T.RedTop, default and T.GreenBot or T.RedBot)

    local icon = New("ImageLabel",{
        Image=default and A.Check or A.X,
        ImageColor3=Color3.new(1,1,1),
        BackgroundTransparency=1,
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new(0.5,-9,0.5,-9),
        ZIndex=4,
    },btn)

    local val = default
    cb(val)

    local h={Value=val}
    local function setGrad(on)
        grad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, on and T.GreenTop or T.RedTop),
            ColorSequenceKeypoint.new(1, on and T.GreenBot or T.RedBot),
        })
        icon.Image = on and A.Check or A.X
    end
    local function set(v,fire)
        val=v; h.Value=v; setGrad(v)
        if fire then cb(v) end
    end
    btn.MouseButton1Click:Connect(function() set(not val, true) end)
    function h:Set(v) set(v,true) end
    if key then Toggles[key]=h end
    return h
end

-- ── Button ────────────────────────────────────────────────────────────────
-- TDS: text+desc on left, gray gradient rounded square on right
function CM:AddButton(textOrOpts, callback)
    local opts
    if type(textOrOpts)=="string" then opts={Text=textOrOpts, Callback=callback}
    else opts=textOrOpts or {}; opts.Callback=opts.Callback or opts.Func end

    local text = opts.Text    or "Button"
    local desc = opts.Desc
    local cb   = opts.Callback or function() end

    local H = desc and 54 or 40
    local r = New("TextButton",{
        Text="", AutoButtonColor=false, BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,H), BorderSizePixel=0, LayoutOrder=self._o,
    },self._c)
    Pad(r, 6, 8, 6, 12); self._o+=1

    Lbl({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,-50,0,18)}, r)
    if desc then
        Lbl({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,-50,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    -- TDS gray gradient action button on right
    local BTN = 32
    local dot = New("TextButton",{
        Text="", AutoButtonColor=false,
        BackgroundColor3=Color3.new(1,1,1),
        Size=UDim2.new(0,BTN,0,BTN),
        Position=UDim2.new(1,-BTN,0.5,-BTN/2),
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    },r)
    Corner(dot, 6)
    Grad(dot, T.BtnTop, T.BtnBot)

    New("ImageLabel",{
        Image=A.IconPerson, ImageColor3=Color3.fromRGB(180,180,180),
        BackgroundTransparency=1,
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new(0.5,-9,0.5,-9),
        ZIndex=4,
    },dot)

    local function click()
        Tween(dot,{BackgroundTransparency=0.3},0.06)
        task.delay(0.12,function() Tween(dot,{BackgroundTransparency=0},0.12) end)
        cb()
    end
    r.MouseEnter:Connect(function() Tween(r,{BackgroundTransparency=0.94},0.1) end)
    r.MouseLeave:Connect(function() Tween(r,{BackgroundTransparency=1},0.1) end)
    r.MouseButton1Click:Connect(click)
    dot.MouseButton1Click:Connect(click)
end

-- ── Slider ────────────────────────────────────────────────────────────────
-- TDS: title top, then [dark value box LEFT] [dark track RIGHT with gray thumb]
function CM:AddSlider(keyOrOpts, opts2)
    local key,opts
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

    local H = desc and 76 or 62
    local r = Row(self._c, self._o, H); self._o+=1
    Pad(r, 8, 12, 8, 12)

    -- title
    Lbl({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,0,0,18)}, r)
    if desc then
        Lbl({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    local rowY   = desc and 38 or 26
    local BOX_W  = 44

    -- value box — dark, left side, TDS style
    local vBox = New("Frame",{
        BackgroundColor3=Color3.fromRGB(28,28,28),
        Size=UDim2.new(0,BOX_W,0,28),
        Position=UDim2.new(0,0,0,rowY),
        BorderSizePixel=0,
    },r)
    Corner(vBox, 6)
    Stroke(vBox, T.Border, 1)
    local vLbl = Lbl({
        Text=tostring(default)..suffix,
        TextColor3=T.TxtPrimary, Font=Enum.Font.GothamBold, TextSize=12,
        Size=UDim2.new(1,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Center,
    },vBox)

    -- track
    local trackX = BOX_W + 10
    local track = New("Frame",{
        BackgroundColor3=T.SliderTrack,
        Size=UDim2.new(1,-trackX,0,6),
        Position=UDim2.new(0,trackX,0,rowY+11),
        BorderSizePixel=0,
    },r)
    Corner(track, 3)

    -- subtle inner gradient on track (slightly lighter at top)
    Grad(track, Color3.fromRGB(48,48,48), Color3.fromRGB(30,30,30))

    local p0 = math.clamp((default-min)/(max-min), 0, 1)

    -- fill — no bright colour, just slightly lighter than track (TDS has no cyan fill)
    local fill = New("Frame",{
        BackgroundColor3=Color3.fromRGB(60,60,60),
        Size=UDim2.new(p0,0,1,0), BorderSizePixel=0,
    },track)
    Corner(fill, 3)

    -- thumb — gray gradient rectangle, taller than track
    local TW,TH = 14,26
    local thumb = New("Frame",{
        BackgroundColor3=Color3.new(1,1,1),
        Size=UDim2.new(0,TW,0,TH),
        Position=UDim2.new(p0,-TW/2,0.5,-TH/2),
        BorderSizePixel=0, ZIndex=5,
    },track)
    Corner(thumb, 4)
    Grad(thumb, Color3.fromRGB(160,160,160), Color3.fromRGB(95,95,95))
    -- thin border on thumb
    Stroke(thumb, Color3.fromRGB(200,200,200), 1)

    local val=default; local drag=false; local h={Value=val}

    local function round(v)
        if rounding==0 then return math.floor(v+0.5) end
        local f=10^rounding; return math.floor(v*f+0.5)/f
    end
    local function setVal(v,fire)
        v=round(math.clamp(v,min,max)); val=v; h.Value=v
        local p=math.clamp((v-min)/(max-min),0,1)
        fill.Size=UDim2.new(p,0,1,0)
        thumb.Position=UDim2.new(p,-TW/2,0.5,-TH/2)
        vLbl.Text=tostring(v)..suffix
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
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)

    function h:Set(v) setVal(v,true) end
    if key then Options[key]=h end
    return h
end

-- ── Dropdown ──────────────────────────────────────────────────────────────
function CM:AddDropdown(keyOrOpts, opts2)
    local key,opts
    if type(keyOrOpts)=="string" then key=keyOrOpts; opts=opts2 or {}
    else opts=keyOrOpts or {}; key=nil end

    local text    = opts.Text     or "Dropdown"
    local desc    = opts.Desc
    local values  = opts.Values   or {}
    local default = opts.Default  or (values[1] or "")
    local cb      = opts.Callback or function() end

    local ITEM_H = 28; local LIST_H = math.min(#values*ITEM_H+10, 160)
    local H = desc and 66 or 50

    local r = Row(self._c, self._o, H); self._o+=1
    Pad(r, 8, 12, 8, 12)
    r.ClipsDescendants=false; r.ZIndex=2

    Lbl({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,0,0,18)}, r)
    if desc then
        Lbl({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,20)}, r)
    end

    local selY = desc and 38 or 26
    local sel = New("TextButton",{
        Text="", AutoButtonColor=false, BackgroundColor3=T.InputBg,
        Size=UDim2.new(1,0,0,24), Position=UDim2.new(0,0,0,selY),
        BorderSizePixel=0, ZIndex=3,
    },r)
    Corner(sel,5); Stroke(sel,T.Border,1)

    local selLbl = Lbl({Text=default, TextSize=12, Size=UDim2.new(1,-28,1,0), Position=UDim2.new(0,8,0,0), ZIndex=4},sel)
    local chev = New("ImageLabel",{Image=A.Chevron, ImageColor3=T.TxtSub, BackgroundTransparency=1, Size=UDim2.new(0,12,0,12), Position=UDim2.new(1,-18,0.5,-6), ZIndex=4},sel)

    local list = New("ScrollingFrame",{
        BackgroundColor3=Color3.fromRGB(20,20,20), Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,1,4), BorderSizePixel=0, ClipsDescendants=true,
        Visible=false, ZIndex=10, ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
    },sel)
    Corner(list,6); Stroke(list,T.Border,1); Pad(list,4,4,4,4); List(list,Enum.FillDirection.Vertical,3)

    local open=false; local val=default; local h={Value=val}
    for _,v in ipairs(values) do
        local item=New("TextButton",{Text=v, TextColor3=T.TxtPrimary, Font=Enum.Font.Gotham, TextSize=12,
            BackgroundColor3=Color3.fromRGB(28,28,28), Size=UDim2.new(1,0,0,ITEM_H),
            BorderSizePixel=0, AutoButtonColor=false, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11},list)
        Corner(item,4); Pad(item,0,8,0,8)
        item.MouseEnter:Connect(function() Tween(item,{BackgroundColor3=Color3.fromRGB(40,40,40)},0.1) end)
        item.MouseLeave:Connect(function() Tween(item,{BackgroundColor3=Color3.fromRGB(28,28,28)},0.1) end)
        item.MouseButton1Click:Connect(function()
            val=v; h.Value=v; selLbl.Text=v; cb(v)
            open=false; list.Visible=false
            Tween(chev,{Rotation=0},0.15); r.Size=UDim2.new(1,0,0,H)
        end)
    end
    sel.MouseButton1Click:Connect(function()
        open=not open
        if open then
            list.Visible=true; Tween(list,{Size=UDim2.new(1,0,0,LIST_H)},0.15)
            Tween(chev,{Rotation=180},0.15); r.Size=UDim2.new(1,0,0,H+LIST_H+8)
        else
            Tween(list,{Size=UDim2.new(1,0,0,0)},0.12); Tween(chev,{Rotation=0},0.15)
            task.delay(0.13,function() list.Visible=false end); r.Size=UDim2.new(1,0,0,H)
        end
    end)
    function h:Set(v) val=v; h.Value=v; selLbl.Text=v; cb(v) end
    if key then Options[key]=h end
    return h
end

-- ── Input ─────────────────────────────────────────────────────────────────
function CM:AddInput(keyOrOpts, opts2)
    local key,opts
    if type(keyOrOpts)=="string" then key=keyOrOpts; opts=opts2 or {}
    else opts=keyOrOpts or {}; key=nil end

    local text=opts.Text or "Input"; local desc=opts.Desc
    local placeholder=opts.Placeholder or ""; local default=opts.Default or ""
    local cb=opts.Callback or function() end

    local H = desc and 66 or 50
    local r = Row(self._c, self._o, H); self._o+=1
    Pad(r, 8, 12, 8, 12)

    Lbl({Text=text, Font=Enum.Font.GothamBold, TextSize=13, Size=UDim2.new(1,0,0,18)}, r)
    if desc then Lbl({Text=desc, TextColor3=T.TxtSub, TextSize=11, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,20)}, r) end

    local inputY = desc and 38 or 26
    local box = New("TextBox",{
        Text=default, PlaceholderText=placeholder, PlaceholderColor3=T.TxtSub,
        TextColor3=T.TxtPrimary, Font=Enum.Font.Gotham, TextSize=12,
        BackgroundColor3=T.InputBg, Size=UDim2.new(1,0,0,24),
        Position=UDim2.new(0,0,0,inputY), BorderSizePixel=0,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left,
    },r)
    Corner(box,5); Stroke(box,T.Border,1); Pad(box,0,8,0,8)

    local val=default; local h={Value=val}
    box.FocusLost:Connect(function() val=box.Text; h.Value=val; cb(val) end)
    function h:Set(v) val=v; h.Value=v; box.Text=v; cb(v) end
    function h:Get() return h.Value end
    if key then Options[key]=h end
    return h
end

-- ════════════════════════════════════════════════════════════════════════
--  Section / Groupbox builder  —  TDS accurate header style
-- ════════════════════════════════════════════════════════════════════════
local function newCM(content)
    local o=setmetatable({},{__index=CM}); o._c=content; o._o=0; return o
end

-- icon lookup for common section names
local SECTION_ICONS = {
    audio="IconAudio", gameplay="IconGear", graphics="IconEye",
    units="IconTarget", enemies="IconSkull", miscellaneous="IconDots",
    misc="IconDots", keybinds="IconKeys", testing="IconFlask",
    all="IconGear",
}

local function sectionIcon(title)
    local k = title:lower():match("^%a+") or ""
    return A[SECTION_ICONS[k]] or A.IconGear
end

local function buildSection(parent, title)
    local wrap = New("Frame",{
        BackgroundColor3=T.Section, Size=UDim2.new(1,0,0,38),
        BorderSizePixel=0, ClipsDescendants=false, LayoutOrder=0,
    },parent)
    Corner(wrap, 8)
    -- subtle border matching TDS
    Stroke(wrap, T.Border, 1)

    -- ── Header bar ─────────────────────────────────────────────────────
    local hdr = New("Frame",{
        BackgroundColor3=Color3.fromRGB(14,14,14),
        Size=UDim2.new(1,0,0,34), BorderSizePixel=0,
    },wrap)
    -- rounded only on top
    New("UICorner",{CornerRadius=UDim.new(0,8)},hdr)

    -- cyan top accent line (TDS has 2px cyan line at very top of section)
    New("Frame",{
        BackgroundColor3=T.Accent,
        Size=UDim2.new(1,0,0,2),
        Position=UDim2.new(0,0,0,0),
        BorderSizePixel=0, ZIndex=3,
    },hdr)

    -- small section icon
    New("ImageLabel",{
        Image=sectionIcon(title), ImageColor3=T.Accent,
        BackgroundTransparency=1,
        Size=UDim2.new(0,14,0,14),
        Position=UDim2.new(0,10,0.5,-7),
        ZIndex=3,
    },hdr)

    -- section title  —  white text, GothamBold
    Lbl({
        Text=title, Font=Enum.Font.GothamBold,
        TextColor3=T.TxtPrimary, TextSize=13,
        Size=UDim2.new(1,-36,1,0),
        Position=UDim2.new(0,30,0,0),
        ZIndex=3,
    },hdr)

    -- wave decoration strip below header text
    New("ImageLabel",{
        Image=A.Wave, ImageColor3=Color3.fromRGB(0,140,180),
        ImageTransparency=0.35,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,20),
        Position=UDim2.new(0,0,1,-8),
        ScaleType=Enum.ScaleType.Crop,
        ZIndex=2,
    },hdr)

    -- ── Content list ───────────────────────────────────────────────────
    local content = New("Frame",{
        BackgroundTransparency=1, Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,0,38), ClipsDescendants=false,
    },wrap)
    Pad(content, 4, 4, 8, 4)

    local layout = List(content, Enum.FillDirection.Vertical, 2)

    -- thin separator under header
    New("Frame",{
        BackgroundColor3=T.Border,
        Size=UDim2.new(1,0,0,1),
        Position=UDim2.new(0,0,0,34),
        BorderSizePixel=0,
    },wrap)

    local function resize()
        local h=layout.AbsoluteContentSize.Y+20
        content.Size=UDim2.new(1,0,0,h)
        wrap.Size=UDim2.new(1,0,0,38+h)
    end
    layout.Changed:Connect(resize)

    return wrap, content
end

-- ════════════════════════════════════════════════════════════════════════
--  Tab Class
-- ════════════════════════════════════════════════════════════════════════
local TabClass = {}; TabClass.__index = TabClass

function TabClass:AddSection(title)
    local _,c=buildSection(self._scroll,title); return newCM(c)
end
function TabClass:AddLeftGroupbox(title)
    self:_cols(); local _,c=buildSection(self._lCol,title); return newCM(c)
end
function TabClass:AddRightGroupbox(title)
    self:_cols(); local _,c=buildSection(self._rCol,title); return newCM(c)
end
function TabClass:_cols()
    if self._colsDone then return end; self._colsDone=true
    local row=New("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0},self._scroll)
    local l=New("Frame",{BackgroundTransparency=1,Size=UDim2.new(0.5,-5,0,0),AutomaticSize=Enum.AutomaticSize.Y},row)
    List(l,Enum.FillDirection.Vertical,10)
    local r2=New("Frame",{BackgroundTransparency=1,Size=UDim2.new(0.5,-5,0,0),AutomaticSize=Enum.AutomaticSize.Y,Position=UDim2.new(0.5,5,0,0)},row)
    List(r2,Enum.FillDirection.Vertical,10)
    self._lCol=l; self._rCol=r2
end

-- ════════════════════════════════════════════════════════════════════════
--  Sidebar tab icons
-- ════════════════════════════════════════════════════════════════════════
local TAB_ICONS = {
    All="IconGear", Audio="IconAudio", Gameplay="IconGear",
    Graphics="IconEye", Units="IconTarget", Enemies="IconSkull",
    Miscellaneous="IconDots", Misc="IconDots", Keybinds="IconKeys", Testing="IconFlask",
}
local function tabIcon(name)
    for k,v in pairs(TAB_ICONS) do
        if name:lower():find(k:lower()) then return A[v] end
    end
    return A.IconGear
end

-- ════════════════════════════════════════════════════════════════════════
--  Window
-- ════════════════════════════════════════════════════════════════════════
function Library:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "Script"

    local gui = New("ScreenGui",{
        Name="CustomUI", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=100,
    },LocalPlayer.PlayerGui)

    -- ── Window frame ──────────────────────────────────────────────────
    local win = New("Frame",{
        Name="Window",
        BackgroundColor3=T.Bg,
        Size=UDim2.new(0,900,0,540),
        Position=UDim2.new(0.5,-450,0.5,-270),
        BorderSizePixel=0, ClipsDescendants=false,
    },gui)
    Corner(win, 10)
    -- outer cyan glow border (2px, TDS style)
    Stroke(win, T.Accent, 2)

    -- ── Header bar  ───────────────────────────────────────────────────
    -- TDS: full-width dark strip at the top. No title badge — title
    -- sits in the sidebar area instead (to match TDS layout).
    local hdrBar = New("Frame",{
        BackgroundColor3=Color3.fromRGB(10,10,10),
        Size=UDim2.new(1,0,0,46),
        BorderSizePixel=0, ZIndex=3,
    },win)
    New("UICorner",{CornerRadius=UDim.new(0,10)},hdrBar)
    -- thin cyan bottom border on header
    New("Frame",{BackgroundColor3=T.Accent,Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),BorderSizePixel=0,ZIndex=4},hdrBar)

    -- ── Sidebar title (TDS: "Settings" style label in sidebar header) ──
    local sideHdr = New("Frame",{
        BackgroundColor3=Color3.fromRGB(12,12,12),
        Size=UDim2.new(0,210,0,46),
        BorderSizePixel=0, ZIndex=4,
    },hdrBar)
    New("UICorner",{CornerRadius=UDim.new(0,10)},sideHdr)
    -- cyan gradient inside sidebar header
    Grad(sideHdr, Color3.fromRGB(0,180,230), Color3.fromRGB(0,100,160))
    Lbl({
        Text=title, Font=Enum.Font.GothamBold, TextSize=15,
        TextColor3=Color3.new(1,1,1),
        Size=UDim2.new(1,-16,1,0),
        Position=UDim2.new(0,12,0,0),
        ZIndex=5,
    },sideHdr)

    -- ── Search bar (full width in header, TDS style) ───────────────────
    local searchBox = New("TextBox",{
        Text="", PlaceholderText="Search...",
        PlaceholderColor3=Color3.fromRGB(90,90,90),
        TextColor3=T.TxtPrimary,
        Font=Enum.Font.Gotham, TextSize=13,
        BackgroundColor3=Color3.fromRGB(14,14,14),
        Size=UDim2.new(1,-284,0,30),
        Position=UDim2.new(0,218,0.5,-15),
        BorderSizePixel=0, ClearTextOnFocus=false,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=4,
    },hdrBar)
    Corner(searchBox, 8)
    Stroke(searchBox, T.Border, 1)
    Pad(searchBox, 0,10,0,12)

    -- ── Close button — red circle, far right (TDS style) ──────────────
    local closeBtn = New("TextButton",{
        Text="", AutoButtonColor=false,
        BackgroundColor3=Color3.new(1,1,1),
        Size=UDim2.new(0,30,0,30),
        Position=UDim2.new(1,-40,0.5,-15),
        BorderSizePixel=0, ZIndex=5,
    },hdrBar)
    -- red gradient (matches TDS red X close button)
    Corner(closeBtn, 15) -- full circle
    Grad(closeBtn, Color3.fromRGB(210,55,40), Color3.fromRGB(145,14,14))
    New("ImageLabel",{
        Image=A.X, ImageColor3=Color3.new(1,1,1),
        BackgroundTransparency=1,
        Size=UDim2.new(0,14,0,14),
        Position=UDim2.new(0.5,-7,0.5,-7),
        ZIndex=6,
    },closeBtn)
    closeBtn.MouseEnter:Connect(function()
        Grad(closeBtn,Color3.fromRGB(230,70,55),Color3.fromRGB(165,20,20))
    end)
    closeBtn.MouseLeave:Connect(function()
        Grad(closeBtn,Color3.fromRGB(210,55,40),Color3.fromRGB(145,14,14))
    end)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- ── Body ──────────────────────────────────────────────────────────
    local body = New("Frame",{
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,-46),
        Position=UDim2.new(0,0,0,46),
    },win)

    -- sidebar
    local sidebar = New("ScrollingFrame",{
        BackgroundColor3=Color3.fromRGB(14,14,14),
        Size=UDim2.new(0,210,1,0),
        BorderSizePixel=0,
        ScrollBarThickness=2, ScrollBarImageColor3=T.Accent,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
    },body)
    Pad(sidebar, 10, 8, 10, 8)
    List(sidebar, Enum.FillDirection.Vertical, 5)

    -- separator line
    New("Frame",{
        BackgroundColor3=T.Border,
        Size=UDim2.new(0,1,1,0),
        Position=UDim2.new(0,210,0,0),
        BorderSizePixel=0,
    },body)

    -- content area
    local content = New("Frame",{
        BackgroundColor3=T.Bg,
        Size=UDim2.new(1,-211,1,0),
        Position=UDim2.new(0,211,0,0),
        ClipsDescendants=true,
    },body)
    New("UICorner",{CornerRadius=UDim.new(0,10)},content)

    -- drag
    local drag,dStart,dPos=false,nil,nil
    hdrBar.InputBegan:Connect(function(inp)
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
    local pages,btns,bgs,active={},{},{},nil

    local function selectTab(i)
        if active==i then return end; active=i
        for j,pg in ipairs(pages) do pg.Visible=(j==i) end
        for j,btn in ipairs(btns) do
            local on=(j==i)
            -- tint the background image: full opacity active, faded inactive
            Tween(bgs[j],{ImageTransparency=on and 0 or 0.35},0.15)
            local lbl=btn:FindFirstChild("__lbl")
            if lbl then Tween(lbl,{TextColor3=on and T.TxtPrimary or T.TxtSub},0.15) end
            -- first ImageLabel after btnBg is the tab icon
            for _,ch in ipairs(btn:GetChildren()) do
                if ch:IsA("ImageLabel") and ch~=bgs[j] then
                    Tween(ch,{ImageColor3=on and T.Accent or T.TxtSub},0.15)
                    break
                end
            end
        end
    end

    local Win={}

    function Win:AddTab(name)
        local idx=#pages+1

        -- Image-backed tab button using user's custom tab_bg asset
        local btn=New("TextButton",{
            Text="", AutoButtonColor=false,
            BackgroundTransparency=1,
            Size=UDim2.new(1,0,0,38),
            BorderSizePixel=0,
        },sidebar)
        -- background image (the dark rounded rectangle the user supplied)
        local btnBg=New("ImageLabel",{
            Image=A.TabBg,
            ImageColor3=Color3.new(1,1,1),
            BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0),
            ScaleType=Enum.ScaleType.Stretch,
            ZIndex=1,
        },btn)

        -- tab icon
        New("ImageLabel",{
            Image=tabIcon(name), ImageColor3=T.TxtSub,
            BackgroundTransparency=1,
            Size=UDim2.new(0,16,0,16),
            Position=UDim2.new(0,10,0.5,-8),
            ZIndex=3,
        },btn)

        -- tab label
        local tl=Lbl({
            Name="__lbl",
            Text=name, Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=T.TxtSub,
            Size=UDim2.new(1,-34,1,0),
            Position=UDim2.new(0,32,0,0),
            ZIndex=3,
        },btn)

        -- page
        local page=New("ScrollingFrame",{
            BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0), BorderSizePixel=0,
            Visible=false, ScrollBarThickness=3,
            ScrollBarImageColor3=T.Accent,
            CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
            ClipsDescendants=false,
        },content)
        Pad(page, 14, 14, 14, 14)
        List(page, Enum.FillDirection.Vertical, 12)

        table.insert(pages,page); table.insert(btns,btn); table.insert(bgs,btnBg)

        btn.MouseButton1Click:Connect(function() selectTab(idx) end)
        btn.MouseEnter:Connect(function()
            if active~=idx then Tween(btnBg,{ImageTransparency=0.15},0.1) end
        end)
        btn.MouseLeave:Connect(function()
            if active~=idx then Tween(btnBg,{ImageTransparency=0.35},0.1) end
        end)

        if idx==1 then selectTab(1) end

        local tab=setmetatable({},TabClass)
        tab._scroll=page; tab._colsDone=false
        return tab
    end

    return Win
end

return Library
