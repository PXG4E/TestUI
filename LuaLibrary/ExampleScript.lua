-- ════════════════════════════════════════════════════════════════════════
--  CustomUI  –  Blank Template
--  Copy this, swap the URL, and build your UI.
-- ════════════════════════════════════════════════════════════════════════

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/PXG4E/TestUI/main/LuaLibrary/CustomUI.lua"))()

-- ─── Window ───────────────────────────────────────────────────────────────
local Window = Library:CreateWindow({ Title = "My Script" })

-- ─── Tabs ─────────────────────────────────────────────────────────────────
local Tabs = {
    Main = Window:AddTab("Main"),
    Misc = Window:AddTab("Misc"),
}

-- ─── Groupboxes (two-column layout) ───────────────────────────────────────
local LeftGroup  = Tabs.Main:AddLeftGroupbox("Group A")
local RightGroup = Tabs.Main:AddRightGroupbox("Group B")

-- ─── Components ───────────────────────────────────────────────────────────

-- Toggle  (key-based → auto-stored in global Toggles table)
LeftGroup:AddToggle("MyToggle", {
    Text     = "My Toggle",
    Default  = false,
    Callback = function(Value)
        print("MyToggle:", Value)
    end,
})

-- Slider  (key-based → auto-stored in global Options table)
LeftGroup:AddSlider("MySlider", {
    Text     = "My Slider",
    Min      = 0,
    Max      = 100,
    Default  = 50,
    Rounding = 0,
    Suffix   = "%",
    Callback = function(Value)
        print("MySlider:", Value)
    end,
})

-- Dropdown
RightGroup:AddDropdown("MyDropdown", {
    Text     = "My Dropdown",
    Values   = { "Option A", "Option B", "Option C" },
    Default  = "Option A",
    Callback = function(Value)
        print("MyDropdown:", Value)
    end,
})

-- Button  (simple form)
RightGroup:AddButton("My Button", function()
    Library:Notify({ Title = "Clicked!", Description = "Button works.", Time = 2 })
end)

-- Input
Tabs.Misc:AddSection("Misc"):AddInput("MyInput", {
    Text        = "My Input",
    Placeholder = "Type here...",
    Callback    = function(Value)
        print("MyInput:", Value)
    end,
})

-- ─── Accessing values globally (no need to store return values) ───────────
-- Toggles.MyToggle.Value        → read current state
-- Toggles.MyToggle:Set(true)    → set state
-- Options.MySlider.Value        → read slider value
-- Options.MySlider:Set(75)      → set slider value

-- ─── Startup notification ─────────────────────────────────────────────────
Library:Notify({ Title = "Loaded", Description = "CustomUI is ready.", Time = 3 })
