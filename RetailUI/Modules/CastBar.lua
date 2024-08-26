local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'CastBar'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.playerCastBar = nil

local function ReplaceBlizzardCastBarFrame(castBarFrame, attachTo)
    local statusBar = castBarFrame
    statusBar:SetMovable(true)
    statusBar:SetUserPlaced(true)
    statusBar:ClearAllPoints()

    -- User Defined
    statusBar.selfInterrupt = false

    attachTo = attachTo or nil

    if attachTo then
        statusBar:SetPoint("LEFT", attachTo, "LEFT", 0, 0)
        statusBar:SetSize(attachTo:GetWidth(), attachTo:GetHeight())
    end

    statusBar:SetMinMaxValues(0.0, 1.0)

    local border = _G[statusBar:GetName() .. "Border"]
    border:SetAllPoints(statusBar)
    border:SetPoint("TOPLEFT", -2, 2)
    border:SetPoint("BOTTOMRIGHT", 2, -2)
    border:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
    border:SetTexCoord(423 / 1024, 847 / 1024, 2 / 512, 30 / 512)

    for _, region in pairs { statusBar:GetRegions() } do
        if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'BACKGROUND' then
            region:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
            region:SetTexCoord(2 / 1024, 421 / 1024, 185 / 512, 215 / 512)
        end
    end

    local spark = _G[statusBar:GetName() .. "Spark"]
    spark:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
    spark:SetTexCoord(77 / 1024, 88 / 1024, 413 / 512, 460 / 512)
    spark:SetSize(5, statusBar:GetHeight() * 1.25)

    local castNameText = _G[statusBar:GetName() .. "Text"]
    castNameText:ClearAllPoints()
    castNameText:SetPoint("BOTTOMLEFT", 5, -16)
    castNameText:SetJustifyH("LEFT")
    castNameText:SetWidth(statusBar:GetWidth() * 0.6)

    local statusBarTexture = statusBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(statusBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
    statusBarTexture:SetDrawLayer('BORDER')

    statusBar.background = statusBar.background or statusBar:CreateTexture(nil, "BACKGROUND")
    local background = statusBar.background
    background:SetAllPoints(statusBar)
    background:SetPoint("BOTTOMRIGHT", 0, -16)
    background:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
    background:SetTexCoord(1 / 1024, 419 / 1024, 1 / 512, 55 / 512)

    statusBar.castTime = statusBar.castTime or statusBar:CreateFontString(nil, "BORDER", 'GameFontHighlightSmall')
    local castTimeText = statusBar.castTime
    castTimeText:SetPoint("BOTTOMRIGHT", -4, -14)
    castTimeText:SetJustifyH("RIGHT")

    local castBarFlash = _G[statusBar:GetName() .. "Flash"]
    castBarFlash:SetAlpha(0)
end

local function CastingBarFrame_OnUpdate(self, elapsed)
    local currentTime, value, remainingTime = GetTime(), 0, 0
    if self.channelingEx or self.castingEx then
        if self.castingEx then
            remainingTime = min(currentTime, self.endTime) - self.startTime
            value = remainingTime / (self.endTime - self.startTime)
        elseif self.channelingEx then
            remainingTime = self.endTime - currentTime
            value = remainingTime / (self.endTime - self.startTime)
        end

        self:SetValue(value)

        self.castTime:SetText(string.format('%.1f/%.2f', abs(remainingTime),
            self.endTime - self.startTime))

        local spark = _G[self:GetName() .. "Spark"]
        if spark then
            spark:ClearAllPoints()
            spark:SetPoint("CENTER", self, "LEFT", value * self:GetWidth(), 0)
        end

        if currentTime > self.endTime then
            self.castingEx, self.channelingEx = nil, nil
            self.fadeOutEx = true
        end
    elseif self.fadeOutEx then
        local spark = _G[self:GetName() .. "Spark"]
        if spark then
            spark:Hide()
        end

        if self:GetAlpha() <= 0.0 then
            self:Hide()
        end
    end
end

local function Target_Spellbar_AdjustPosition(self)
    self.SetPoint = UIParent.SetPoint
    local parentFrame = self:GetParent()
    if (parentFrame.haveToT) then
        if (parentFrame.auraRows <= 1) then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -40)
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -20)
        end
    elseif (parentFrame.haveElite) then
        if (parentFrame.auraRows <= 1) then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -10)
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -10)
        end
    else
        if (parentFrame.auraRows > 0) then
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -10)
        else
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 25, -10)
        end
    end
    self.SetPoint = function() end
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("UNIT_SPELLCAST_START")
    self:RegisterEvent("UNIT_SPELLCAST_STOP")
    self:RegisterEvent("UNIT_SPELLCAST_FAILED")
    self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    self:RegisterEvent("UNIT_SPELLCAST_DELAYED")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_INTERRUPTED")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("PLAYER_FOCUS_CHANGED")

    CastingBarFrame:UnregisterAllEvents()
    CastingBarFrame:HookScript("OnUpdate", CastingBarFrame_OnUpdate)

    TargetFrameSpellBar:UnregisterAllEvents()
    TargetFrameSpellBar:HookScript("OnUpdate", CastingBarFrame_OnUpdate)

    FocusFrameSpellBar:UnregisterAllEvents()
    FocusFrameSpellBar:HookScript("OnUpdate", CastingBarFrame_OnUpdate)

    self:SecureHook('Target_Spellbar_AdjustPosition', Target_Spellbar_AdjustPosition)

    self.playerCastBar = CreateUIFrame(228, 18, "CastBarFrame")
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("UNIT_SPELLCAST_START")
    self:UnregisterEvent("UNIT_SPELLCAST_STOP")
    self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
    self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    self:UnregisterEvent("UNIT_SPELLCAST_DELAYED")
    self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_INTERRUPTED")
    self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
    self:UnregisterEvent("PLAYER_TARGET_CHANGED")
    self:UnregisterEvent("PLAYER_FOCUS_CHANGED")

    CastingBarFrame:Unhook("OnUpdate", CastingBarFrame_OnUpdate)
    TargetFrameSpellBar:Unhook("OnUpdate", CastingBarFrame_OnUpdate)
    FocusFrameSpellBar:Unhook("OnUpdate", CastingBarFrame_OnUpdate)

    self:Unhook('Target_Spellbar_AdjustPosition', Target_Spellbar_AdjustPosition)
end

function Module:PLAYER_ENTERING_WORLD()
    ReplaceBlizzardCastBarFrame(CastingBarFrame, self.playerCastBar)
    ReplaceBlizzardCastBarFrame(TargetFrameSpellBar)
    ReplaceBlizzardCastBarFrame(FocusFrameSpellBar)

    if RUI.DB.profile.widgets.playerCastBar == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

function Module:PLAYER_TARGET_CHANGED()
    local statusBar = TargetFrameSpellBar

    if UnitExists("target") and statusBar.unit == UnitGUID("target") then
        if GetTime() > statusBar.endTime then
            statusBar:Hide()
        else
            statusBar:Show()
        end
    else
        statusBar:Hide()
    end
end

function Module:PLAYER_FOCUS_CHANGED()
    local statusBar = FocusFrameSpellBar

    if UnitExists("focus") and statusBar.unit == UnitGUID("focus") then
        if GetTime() > statusBar.endTime then
            statusBar:Hide()
        else
            statusBar:Show()
        end
    else
        statusBar:Hide()
    end
end

function Module:UNIT_SPELLCAST_START(eventName, unit)
    local statusBar
    if unit == 'player' then
        statusBar = CastingBarFrame
    elseif unit == 'target' then
        statusBar = TargetFrameSpellBar
        statusBar.unit = UnitGUID("target")
    elseif unit == 'focus' then
        statusBar = FocusFrameSpellBar
        statusBar.unit = UnitGUID("focus")
    else
        return
    end

    local castText = _G[statusBar:GetName() .. "Text"]

    local spell, rank, displayName, icon, startTime, endTime
    if eventName == 'UNIT_SPELLCAST_START' then
        spell, rank, displayName, icon, startTime, endTime = UnitCastingInfo(unit)
        statusBar.castingEx = true

        statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 849 / 1024, 160 / 512, 180 / 512)
    else
        spell, rank, displayName, icon, startTime, endTime = UnitChannelInfo(unit)
        statusBar.channelingEx = true

        statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 850 / 1024, 63 / 512, 85 / 512)
    end

    local iconTexture = _G[statusBar:GetName() .. 'Icon']
    if unit ~= 'player' then
        iconTexture:SetTexture(icon)
        iconTexture:Show()
    else
        iconTexture:Hide()
    end

    castText:SetText(displayName)
    statusBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)

    statusBar.startTime = startTime / 1000
    statusBar.endTime = endTime / 1000

    UIFrameFadeRemoveFrame(statusBar)

    local spark = _G[statusBar:GetName() .. "Spark"]
    if spark then
        spark:Show()
    end

    statusBar:SetAlpha(1.0)
    statusBar:Show()
end

Module.UNIT_SPELLCAST_CHANNEL_START = Module.UNIT_SPELLCAST_START

function Module:UNIT_SPELLCAST_STOP(eventName, unit)
    local statusBar
    if unit == 'player' then
        statusBar = CastingBarFrame
    elseif unit == 'target' then
        statusBar = TargetFrameSpellBar
        if statusBar.unit ~= UnitGUID('target') then
            return
        end
    elseif unit == 'focus' then
        statusBar = FocusFrameSpellBar
        if statusBar.unit ~= UnitGUID('focus') then
            return
        end
    else
        return
    end

    if statusBar.castingEx then
        statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 849 / 1024, 160 / 512, 180 / 512)
    elseif statusBar.channelingEx then
        statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 850 / 1024, 63 / 512, 85 / 512)
        statusBar.selfInterrupt = true
    end

    statusBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)

    statusBar.castingEx, statusBar.channelingEx = false, false
    statusBar.fadeOutEx = true

    UIFrameFadeOut(statusBar, 1, 1.0, 0.0)
end

Module.UNIT_SPELLCAST_CHANNEL_STOP = Module.UNIT_SPELLCAST_STOP

function Module:UNIT_SPELLCAST_FAILED(eventName, unit)
    local statusBar
    if unit == 'player' then
        statusBar = CastingBarFrame
    elseif unit == 'target' then
        statusBar = TargetFrameSpellBar
        if statusBar.unit ~= UnitGUID('target') then
            return
        end
    elseif unit == 'focus' then
        statusBar = FocusFrameSpellBar
        if statusBar.unit ~= UnitGUID('focus') then
            return
        end
    else
        return
    end

    if statusBar.castingEx then
        statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 849 / 1024, 160 / 512, 180 / 512)
    elseif statusBar.channelingEx then
        statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 850 / 1024, 63 / 512, 85 / 512)
    end

    statusBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)
end

function Module:UNIT_SPELLCAST_INTERRUPTED(eventName, unit)
    local statusBar
    if unit == 'player' then
        statusBar = CastingBarFrame
    elseif unit == 'target' then
        statusBar = TargetFrameSpellBar
        if statusBar.unit ~= UnitGUID('target') then
            return
        end
    elseif unit == 'focus' then
        statusBar = FocusFrameSpellBar
        if statusBar.unit ~= UnitGUID('focus') then
            return
        end
    else
        return
    end

    if not statusBar.selfInterrupt then
        statusBar:SetValue(1.0)
        statusBar:GetStatusBarTexture():SetTexCoord(2 / 1024, 416 / 1024, 335 / 512, 358 / 512)
        statusBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)

        local castText = _G[statusBar:GetName() .. "Text"]
        castText:SetText("Interrupted")
    else
        statusBar.selfInterrupt = false
    end

    statusBar.castingEx, statusBar.channelingEx = false, false
    statusBar.fadeOutEx = true

    UIFrameFadeOut(statusBar, 1, 1.0, 0.0)
end

Module.UNIT_SPELLCAST_CHANNEL_INTERRUPTED = Module.UNIT_SPELLCAST_INTERRUPTED

function Module:UNIT_SPELLCAST_DELAYED(eventName, unit)
    local statusBar
    if unit == 'player' then
        statusBar = CastingBarFrame
    elseif unit == 'target' then
        statusBar = TargetFrameSpellBar
        if statusBar.unit ~= UnitGUID('target') then
            return
        end
    elseif unit == 'focus' then
        statusBar = FocusFrameSpellBar
        if statusBar.unit ~= UnitGUID('focus') then
            return
        end
    else
        return
    end

    local spell, rank, displayName, icon, startTime, endTime
    if statusBar.castingEx then
        spell, rank, displayName, icon, startTime, endTime = UnitCastingInfo(unit)
    elseif statusBar.channelingEx then
        spell, rank, displayName, icon, startTime, endTime = UnitChannelInfo(unit)
    end

    if not spell then
        statusBar:Hide()
        return
    end

    statusBar.startTime = startTime / 1000
    statusBar.endTime = endTime / 1000
end

Module.UNIT_SPELLCAST_CHANNEL_UPDATE = Module.UNIT_SPELLCAST_DELAYED

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.playerCastBar = { anchor = "BOTTOM", posX = 0, posY = 270 }
end

function Module:UpdateWidgets()
    local widgetOptions = RUI.DB.profile.widgets.playerCastBar
    self.playerCastBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
end

function Module:EnableEditorPreview()
    HideUIFrame(self.playerCastBar)

    local statusBar = CastingBarFrame
    statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 849 / 1024, 160 / 512, 180 / 512)
    statusBar:GetStatusBarTexture():SetVertexColor(1, 1, 1, 1)
    statusBar:SetValue(0.5)

    local castText = _G[statusBar:GetName() .. "Text"]
    castText:SetText("Healing Wave")
    statusBar.castTime:SetText(string.format('%.1f/%.2f', 0.5, 1.0))

    statusBar:SetAlpha(1.0)
    statusBar:Show()
end

function Module:DisableEditorPreview()
    ShowUIFrame(self.playerCastBar)
    SaveUIFramePosition(self.playerCastBar, 'playerCastBar')

    local statusBar = CastingBarFrame
    statusBar:Hide()
end
