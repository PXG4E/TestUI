-- ════════════════════════════════════════════════════════════════════════
--  AssetID Scraper
--  Scans the entire game for rbxassetid:// values, deduplicates them,
--  prints each one, then copies the full list to your clipboard.
-- ════════════════════════════════════════════════════════════════════════

local ids = {}
local seen = {}

-- Properties on each class that can hold an rbxassetid
local ASSET_PROPS = {
    ImageLabel    = { "Image", "HoverImage", "PressedImage" },
    ImageButton   = { "Image", "HoverImage", "PressedImage" },
    Decal         = { "Texture" },
    Texture       = { "Texture" },
    SpecialMesh   = { "MeshId", "TextureId" },
    FileMesh      = { "MeshId", "TextureId" },
    Sky           = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" },
    Shirt         = { "ShirtTemplate" },
    Pants         = { "PantsTemplate" },
    ShirtGraphic  = { "Graphic" },
    Humanoid      = {},  -- skip
    Sound         = { "SoundId" },
    Animation     = { "AnimationId" },
    ParticleEmitter = { "Texture" },
    Trail         = { "Texture" },
    Beam          = { "Texture" },
    SelectionBox  = {},  -- skip
}

-- Grab the numeric ID from any string that contains rbxassetid://
local function extractId(str)
    if type(str) ~= "string" then return nil end
    local id = str:match("rbxassetid://(%d+)")
    return id
end

-- Recursively walk every descendant in a service
local function scan(root)
    local ok, descendants = pcall(function() return root:GetDescendants() end)
    if not ok then return end

    for _, obj in ipairs(descendants) do
        local className = obj.ClassName
        local propsToCheck = ASSET_PROPS[className]

        if propsToCheck then
            for _, prop in ipairs(propsToCheck) do
                local ok2, value = pcall(function() return obj[prop] end)
                if ok2 then
                    local id = extractId(tostring(value))
                    if id and not seen[id] then
                        seen[id] = true
                        table.insert(ids, id)
                    end
                end
            end
        end
    end
end

-- Only scan the specific header frame
local ok, target = pcall(function()
    return game:GetService("Players").LocalPlayer.PlayerGui.Settings.Frame.Frame.Frame:GetChildren()[4]
end)

if not ok or not target then
    print("[AssetScraper] ⚠ Could not find the target frame — make sure the Settings GUI is open and try again.")
    return
end

print("[AssetScraper] Scanning: " .. target:GetFullName())
scan(target)

-- ── Output ────────────────────────────────────────────────────────────────

if #ids == 0 then
    print("[AssetScraper] No rbxassetid:// values found in the game.")
    return
end

-- Sort numerically so related IDs group together
table.sort(ids, function(a, b)
    return tonumber(a) < tonumber(b)
end)

print(string.format("[AssetScraper] Found %d unique asset IDs:\n", #ids))
for _, id in ipairs(ids) do
    print(id)
end

-- Build clipboard string — one ID per line, no prefix
local clipboardText = table.concat(ids, "\n")

-- setclipboard is an executor function (Synapse, KRNL, etc.)
if setclipboard then
    setclipboard(clipboardText)
    print(string.format("\n[AssetScraper] ✓ Copied %d IDs to clipboard.", #ids))
elseif syn and syn.clipboard and syn.clipboard.set then
    -- Synapse fallback
    syn.clipboard.set(clipboardText)
    print(string.format("\n[AssetScraper] ✓ Copied %d IDs to clipboard (Synapse).", #ids))
else
    print("\n[AssetScraper] ⚠ setclipboard not available in this executor.")
    print("Copy the list above manually.")
end
