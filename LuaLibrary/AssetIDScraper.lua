-- ════════════════════════════════════════════════════════════════════════
--  TDS Asset ID Scraper  v3  —  Settings-focused
--  Run while the TDS Settings panel is open.
--  Prints each image with: PATH | SIZE | COLOR | ID
--  so you can tell exactly which image is which.
-- ════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local lp      = Players.LocalPlayer
local gui     = lp:WaitForChild("PlayerGui", 10)
if not gui then print("[Scraper] PlayerGui not found.") return end

-- Try to narrow to the Settings GUI only first
local settingsGui = gui:FindFirstChild("Settings") or gui
print("[Scraper] Scanning: " .. settingsGui:GetFullName() .. "\n")

local seen = {}
local rows = {}

local function col3str(c)
    return string.format("rgb(%d,%d,%d)", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
end

local function getPath(obj)
    local parts, cur = {}, obj
    while cur and cur ~= gui do
        table.insert(parts, 1, cur.Name)
        cur = cur.Parent
    end
    return table.concat(parts, ".")
end

for _, obj in ipairs(settingsGui:GetDescendants()) do
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        local ok, img = pcall(function() return obj.Image end)
        if ok and type(img) == "string" then
            local id = img:match("rbxassetid://(%d+)")
            if id and not seen[id] then
                seen[id] = true
                local absSize = obj.AbsoluteSize
                local imgColor = obj.ImageColor3
                local transp   = obj.ImageTransparency
                table.insert(rows, {
                    id      = id,
                    path    = getPath(obj),
                    size    = string.format("%dx%d", math.floor(absSize.X), math.floor(absSize.Y)),
                    color   = col3str(imgColor),
                    transp  = string.format("%.2f", transp),
                    parent  = obj.Parent and obj.Parent.ClassName or "?",
                })
            end
        end
    end
end

if #rows == 0 then
    print("[Scraper] No assets found — make sure the Settings GUI is open.")
    return
end

table.sort(rows, function(a,b) return a.path < b.path end)

-- Header
print(string.format("%-18s  %-12s  %-22s  %s", "ID", "SIZE", "COLOR (transp)", "PATH"))
print(string.rep("-", 110))

local lines = {}
for _, r in ipairs(rows) do
    local dispColor = r.color .. (r.transp ~= "0.00" and "  t="..r.transp or "")
    print(string.format("%-18s  %-12s  %-22s  %s", r.id, r.size, dispColor, r.path))
    table.insert(lines, string.format(
        '["id_%s"] = "rbxassetid://%s", -- size=%s  %s',
        r.id, r.id, r.size, r.path
    ))
end

local clip = "-- TDS Assets ("..#rows.." found)\nlocal A = {\n    "
    .. table.concat(lines, "\n    ") .. "\n}"

if setclipboard then setclipboard(clip)
elseif syn and syn.clipboard then syn.clipboard.set(clip)
else print("\n[Scraper] setclipboard unavailable — copy output above manually.") return end

print(string.format("\n[Scraper] ✓ %d assets copied to clipboard.", #rows))
