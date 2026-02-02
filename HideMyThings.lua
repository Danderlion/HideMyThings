--------------------------------------------------------------------------------
-- HideMyThings: Button-Specific Grouping
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

                    -- 2. Bar 1 Logic (Button specific)
                    local bar1Mouse = false
                    for _, btn in ipairs(Bar1Buttons) do if btn:IsMouseOver() then bar1Mouse = true break end end
                        local showBar1 = bar1Mouse or actionTrigger
                        SetGroupAlpha(Bar1Buttons, showBar1 and 1 or 0)
                        end

                        -- Event Registration
                        f:RegisterEvent("PLAYER_ENTERING_WORLD")
                        f:RegisterEvent("PLAYER_REGEN_DISABLED")
                        f:RegisterEvent("PLAYER_REGEN_ENABLED")
                        f:RegisterEvent("PLAYER_TARGET_CHANGED")

                        f:SetScript("OnEvent", function(self, event)
                        if event == "PLAYER_ENTERING_WORLD" then
                            -- Initial hide
                            RefreshAll()
                            else
                                RefreshAll()
                                end
                                end)

                        -- Mouse checking requires a lightweight ticker since OnLeave on buttons is unreliable
                        C_Timer.NewTicker(0.2, function() RefreshAll() end)
