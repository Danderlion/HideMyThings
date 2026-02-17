--------------------------------------------------------------------------------
-- HideMyThings: Fully Fixed & Optimized
--------------------------------------------------------------------------------

local f = CreateFrame("Frame")
local elements = {
    { name = "PlayerFrame", idle = 0, target = true },
    { name = "ObjectiveTrackerFrame", idle = 0.1 },
    { name = "MultiBarBottomLeft", idle = 0 },
    { name = "MultiBarBottomRight", idle = 0 },
    { name = "MultiBarRight", idle = 0 },
    { name = "MultiBarLeft", idle = 0 },
    { name = "MultiBar5", idle = 0 },
    { name = "MultiBar6", idle = 0 },
    { name = "StanceBar", idle = 0 },
    { name = "PetActionBar", idle = 0 },
    { name = "MyResourcesFrame", idle = 0, target = true }
    -- Note: PartyFrame (Standard) is handled separately if you use Raid-Style
}

-- Bar 1 Button List
local Bar1Buttons = {}
for i = 1, 12 do table.insert(Bar1Buttons, _G["ActionButton"..i]) end

    local function SetGroupAlpha(group, alpha)
    for _, btn in ipairs(group) do
        if btn then btn:SetAlpha(alpha) end
            end
            end

            local function RefreshAll()
            local inCombat = UnitAffectingCombat("player")
            local isSafe = IsResting() or (GetZonePVPInfo() == "sanctuary")
            local hasTarget = UnitExists("target")
            local actionTrigger = not isSafe and inCombat

            -- 1. Standard Elements
            for _, data in ipairs(elements) do
                local frame = _G[data.name]
                if frame then
                    local show = frame:IsMouseOver() or actionTrigger or (data.target and hasTarget)
                    frame:SetAlpha(show and 1 or data.idle)
                    end
                    end

                    -- 2. Solo Raid Frame (SRF) / Compact Party Logic
                    if CompactPartyFrame then
                        local srfMouse = CompactPartyFrame:IsMouseOver()
                        local showSRF = srfMouse or actionTrigger or hasTarget
                        local alpha = showSRF and 1 or 0

                        -- HIDE THE MAIN BOX: Targeting the textures and borders
                        if CompactPartyFrame.background then CompactPartyFrame.background:SetAlpha(alpha) end
                            if CompactPartyFrameBorderFrame then CompactPartyFrameBorderFrame:SetAlpha(alpha) end

                                for _, region in pairs({CompactPartyFrame:GetRegions()}) do
                                    if region.SetAlpha then region:SetAlpha(alpha) end
                                        end

                                        -- HIDE THE UNIT BOXES
                                        for _, child in pairs({CompactPartyFrame:GetChildren()}) do
                                            -- Only target actual unit buttons (which have selectionHighlight)
                                            if child.selectionHighlight then
                                                child:SetAlpha(1) -- Keep button active for click-casting/updates

                                                -- Fade the HP/Name and the unit's specific background
                                                if child.background then child.background:SetAlpha(alpha) end
                                                    child.selectionHighlight:SetAlpha(alpha)
                                                    if child.healthBar then child.healthBar:SetAlpha(alpha) end
                                                        if child.name then child.name:SetAlpha(alpha) end
                                                            if child.statusText then child.statusText:SetAlpha(alpha) end
                                                                if child.roleIcon then child.roleIcon:SetAlpha(alpha) end
                                                                    end
                                                                    end
                                                                    end

                                                                    -- 3. Bar 1 Logic (Moved outside of Party logic)
                                                                    local bar1Mouse = false
                                                                    for _, btn in ipairs(Bar1Buttons) do
                                                                        if btn:IsMouseOver() then bar1Mouse = true break end
                                                                            end
                                                                            local showBar1 = bar1Mouse or actionTrigger
                                                                            SetGroupAlpha(Bar1Buttons, showBar1 and 1 or 0)

                                                                            end -- This closes the RefreshAll function correctly.

                                                                            -- Event Registration
                                                                            f:RegisterEvent("PLAYER_ENTERING_WORLD")
                                                                            f:RegisterEvent("PLAYER_REGEN_DISABLED")
                                                                            f:RegisterEvent("PLAYER_REGEN_ENABLED")
                                                                            f:RegisterEvent("PLAYER_TARGET_CHANGED")

                                                                            f:SetScript("OnEvent", function(self, event)
                                                                            RefreshAll()
                                                                            end)

                                                                            -- Mouse checking ticker
                                                                            C_Timer.NewTicker(0.2, function() RefreshAll() end)
