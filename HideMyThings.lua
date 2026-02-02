local f = CreateFrame("Frame")
local LINGER_DELAY = 1.5
local FADE_SPEED = 1.5

local elements = {
    { name = "PlayerFrame", idleAlpha = 0, combatLinked = true },
    { name = "ObjectiveTrackerFrame", idleAlpha = 0.1, combatLinked = false },
    { name = "MultiBarBottomLeft", idleAlpha = 0, combatLinked = true },
    { name = "MultiBarBottomRight", idleAlpha = 0, combatLinked = true },
    { name = "MultiBarRight", idleAlpha = 0, combatLinked = true },
    { name = "MultiBarLeft", idleAlpha = 0, combatLinked = true },
    { name = "MultiBar5", idleAlpha = 0, combatLinked = true },
    { name = "MultiBar6", idleAlpha = 0, combatLinked = true },
    { name = "StanceBar", idleAlpha = 0, combatLinked = true },
    { name = "PetActionBar", idleAlpha = 0, combatLinked = true },
    { name = "MyResourcesFrame", idleAlpha = 0, combatLinked = true }
}

for _, data in ipairs(elements) do
    data.currentAlpha, data.targetAlpha, data.linger = data.idleAlpha, data.idleAlpha, 0
    end

    -- Cluster 1: Bar 1
    local Bar1 = { currentAlpha = 0, targetAlpha = 0, idleAlpha = 0, linger = 0, combatLinked = true, buttons = {} }
    for i = 1, 12 do table.insert(Bar1.buttons, _G["ActionButton"..i]) end

        -- Cluster 2: Micro/Bags (Combined from your MAS LUA files)
        local Micro = { currentAlpha = 0, targetAlpha = 0, idleAlpha = 0, linger = 0, combatLinked = false, buttons = {} }
        local microList = {
            "CharacterMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton",
            "AchievementMicroButton", "QuestLogMicroButton", "GuildMicroButton",
            "LFDMicroButton", "CollectionsMicroButton", "EJMicroButton",
            "StoreMicroButton", "MainMenuMicroButton", "HousingMicroButton",
            "MainMenuBarBackpackButton", "BagBarExpandToggle", "CharacterReagentBag0Slot"
        }
        for i = 0, 3 do table.insert(microList, "CharacterBag"..i.."Slot") end

            local function ApplyHooks()
            for _, data in ipairs(elements) do
                local frame = _G[data.name]
                if frame and not frame.hooked then
                    hooksecurefunc(frame, "SetAlpha", function(self, a)
                    if a ~= data.currentAlpha then self:SetAlpha(data.currentAlpha) end
                        end)
                    frame.hooked = true
                    end
                    end
                    -- Bar 1 Hooks
                    for _, btn in ipairs(Bar1.buttons) do
                        if btn and not btn.hooked then
                            hooksecurefunc(btn, "SetAlpha", function(self, a)
                            if a ~= Bar1.currentAlpha then self:SetAlpha(Bar1.currentAlpha) end
                                end)
                            btn.hooked = true
                            end
                            end
                            -- Micro/Bag Hooks
                            for _, name in ipairs(microList) do
                                local btn = _G[name]
                                if btn and not btn.hooked then
                                    table.insert(Micro.buttons, btn)
                                    hooksecurefunc(btn, "SetAlpha", function(self, a)
                                    if a ~= Micro.currentAlpha then self:SetAlpha(Micro.currentAlpha) end
                                        end)
                                    btn.hooked = true
                                    end
                                    end
                                    end

                                    f:SetScript("OnUpdate", function(self, elapsed)
                                    local inCombat = UnitAffectingCombat("player")
                                    local hasTarget = UnitExists("target")

                                    -- 1. Elements
                                    for _, data in ipairs(elements) do
                                        local frame = _G[data.name]
                                        if frame then
                                            local isMouseOver = frame:IsMouseOver()
                                            local shouldShow = data.combatLinked and (inCombat or hasTarget or isMouseOver) or (not data.combatLinked and isMouseOver)
                                            if shouldShow then data.linger = 0; data.targetAlpha = 1
                                                else data.linger = data.linger + elapsed; data.targetAlpha = (data.linger >= LINGER_DELAY) and data.idleAlpha or 1 end
                                                    if data.currentAlpha ~= data.targetAlpha then
                                                        data.currentAlpha = (data.currentAlpha < data.targetAlpha) and math.min(data.targetAlpha, data.currentAlpha + (elapsed * 5)) or math.max(data.targetAlpha, data.currentAlpha - (elapsed * FADE_SPEED))
                                                        frame:SetAlpha(data.currentAlpha)
                                                        end
                                                        end
                                                        end

                                                        -- 2. Bar 1 Cluster
                                                        local b1M = false
                                                        for _, btn in ipairs(Bar1.buttons) do if btn and btn:IsMouseOver() then b1M = true break end end
                                                            local sB1 = inCombat or hasTarget or b1M
                                                            if sB1 then Bar1.linger = 0; Bar1.targetAlpha = 1
                                                                else Bar1.linger = Bar1.linger + elapsed; Bar1.targetAlpha = (Bar1.linger >= LINGER_DELAY) and Bar1.idleAlpha or 1 end
                                                                    if Bar1.currentAlpha ~= Bar1.targetAlpha then
                                                                        Bar1.currentAlpha = (Bar1.currentAlpha < Bar1.targetAlpha) and math.min(Bar1.targetAlpha, Bar1.currentAlpha + (elapsed * 5)) or math.max(Bar1.targetAlpha, Bar1.currentAlpha - (elapsed * FADE_SPEED))
                                                                        for _, btn in ipairs(Bar1.buttons) do if btn then btn:SetAlpha(Bar1.currentAlpha) end end
                                                                            if MainMenuBar then MainMenuBar:SetAlpha(Bar1.currentAlpha) end
                                                                                end

                                                                                -- 3. Micro/Bags Cluster
                                                                                local micM = (MicroButtonAndBagsBar and MicroButtonAndBagsBar:IsMouseOver()) or (BagsBar and BagsBar:IsMouseOver())
                                                                                if not micM then for _, btn in ipairs(Micro.buttons) do if btn:IsMouseOver() then micM = true break end end end
                                                                                    if micM then Micro.linger = 0; Micro.targetAlpha = 1
                                                                                        else Micro.linger = Micro.linger + elapsed; Micro.targetAlpha = (Micro.linger >= LINGER_DELAY) and Micro.idleAlpha or 1 end
                                                                                            if Micro.currentAlpha ~= Micro.targetAlpha then
                                                                                                Micro.currentAlpha = (Micro.currentAlpha < Micro.targetAlpha) and math.min(Micro.targetAlpha, Micro.currentAlpha + (elapsed * 5)) or math.max(Micro.targetAlpha, Micro.currentAlpha - (elapsed * FADE_SPEED))
                                                                                                for _, btn in ipairs(Micro.buttons) do if btn then btn:SetAlpha(Micro.currentAlpha) end end
                                                                                                    if MicroButtonAndBagsBar then MicroButtonAndBagsBar:SetAlpha(Micro.currentAlpha) end
                                                                                                        if BagsBar then BagsBar:SetAlpha(Micro.currentAlpha) end
                                                                                                            end
                                                                                                            end)

                                    f:RegisterEvent("PLAYER_ENTERING_WORLD")
                                    f:SetScript("OnEvent", function()
                                    if MainMenuBarVehicleLeaveButton then MainMenuBarVehicleLeaveButton:SetParent(UIParent) end
                                        ApplyHooks()
                                        end)
