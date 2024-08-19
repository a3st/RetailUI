local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local moduleName = 'CastBar'
local Module = DFUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.castBar = nil
Module.startTime = 0
Module.endTime = 0
Module.casting = false
Module.channeling = false
Module.fadeOut = false

function Module:OnEnable()
    CastingBarFrame:UnregisterAllEvents()
    CastingBarFrame:SetScript("OnUpdate", function(self, elapsed)
        local currentTime, value, remainingTime = GetTime(), 0, 0
        if Module.channeling or Module.casting then
            if Module.casting then
                remainingTime = currentTime - Module.startTime
                value = remainingTime / (Module.endTime - Module.startTime)
            elseif Module.channeling then
                remainingTime = Module.endTime - currentTime
                value = remainingTime / (Module.endTime - Module.startTime)
            end

            CastingBarFrame:SetValue(value)

            CastingBarFrame.timeText:SetText(string.format('%.1f/%.2f', remainingTime,
                Module.endTime - Module.startTime))

            local spark = _G[CastingBarFrame:GetName() .. "Spark"]
            if spark then
                spark:ClearAllPoints()
                spark:SetPoint("CENTER", CastingBarFrame, "LEFT", 6 + value * 228, 0)
            end

            if currentTime > Module.endTime then
                Module.casting, Module.channeling = nil, nil
                Module.fadeOut = true
            end
        elseif Module.fadeOut then
            local spark = _G[CastingBarFrame:GetName() .. "Spark"]
            if spark then
                spark:Hide()
            end

            if CastingBarFrame:GetAlpha() <= 0.0 then
                CastingBarFrame:Hide()
            end
        end
    end)

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("UNIT_SPELLCAST_START")
    self:RegisterEvent("UNIT_SPELLCAST_STOP")
    self:RegisterEvent("UNIT_SPELLCAST_FAILED")
    self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_INTERRUPTED")
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("UNIT_SPELLCAST_START")
    self:UnregisterEvent("UNIT_SPELLCAST_STOP")
    self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
    self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_INTERRUPTED")
end

local function CreateCastBar()
    local width = 228 + 8
    local height = 10 + 8

    local castBar = CreateFrame("Frame", 'DFUI_CastBar', UIParent)
    castBar:SetSize(width, height)

    castBar:RegisterForDrag("LeftButton")
    castBar:EnableMouse(false)
    castBar:SetMovable(false)
    castBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    castBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = castBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(castBar)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        castBar.editorTexture = texture

        local fontString = castBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Cast Bar Frame")
        fontString:Hide()

        castBar.editorText = fontString
    end

    local statusBar = CastingBarFrame
    statusBar:ClearAllPoints()

    statusBar:SetSize(228, 8)
    statusBar:SetMinMaxValues(0.0, 1.0)

    local border = _G[statusBar:GetName() .. "Border"]
    if border then
        border:SetAllPoints(castBar)
        border:SetPoint("TOPLEFT", -2, 2)
        border:SetPoint("BOTTOMRIGHT", 2, -2)
        border:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uicastingbar2x.blp")
        border:SetTexCoord(423 / 1024, 846 / 1024, 2 / 512, 30 / 512)
    end

    for _, region in pairs { statusBar:GetRegions() } do
        if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'BACKGROUND' then
            region:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uicastingbar2x.blp")
            region:SetTexCoord(2 / 1024, 421 / 1024, 185 / 512, 215 / 512)
        end
    end

    local spark = _G[statusBar:GetName() .. "Spark"]
    if spark then
        spark:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uicastingbar2x.blp")
        spark:SetTexCoord(77 / 1024, 88 / 1024, 413 / 512, 460 / 512)
        spark:SetSize(5, 19)
    end

    local castText = _G[statusBar:GetName() .. "Text"]
    if castText then
        castText:ClearAllPoints()
        castText:SetPoint("BOTTOMLEFT", 5, -16)
        castText:SetJustifyH("LEFT")
    end

    do
        local statusBarTexture = statusBar:CreateTexture(nil, 'BORDER')
        statusBarTexture:SetAllPoints(statusBar)
        statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uicastingbar2x.blp")

        statusBar:SetStatusBarTexture(statusBarTexture)
    end

    do
        local texture = statusBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(statusBar)
        texture:SetPoint("BOTTOMRIGHT", 0, -16)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uicastingbar2x.blp")
        texture:SetTexCoord(1 / 1024, 419 / 1024, 1 / 512, 55 / 512)
    end

    do
        local fontString = statusBar:CreateFontString(nil, "BORDER", 'GameFontHighlightSmall')
        fontString:SetPoint("BOTTOMRIGHT", -4, -14)
        fontString:SetJustifyH("RIGHT")

        statusBar.timeText = fontString
    end

    local flash = _G[statusBar:GetName() .. "Flash"]
    flash:SetAlpha(0)

    return castBar
end

function Module:PLAYER_ENTERING_WORLD()
    self.castBar = CreateCastBar()

    if DFUI.DB.profile.widgets.castBar == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

function Module:UNIT_SPELLCAST_START(eventName, unit)
    if unit ~= 'player' then return end

    local statusBar = CastingBarFrame
    statusBar:SetAllPoints(self.castBar)

    local castText = _G[statusBar:GetName() .. "Text"]

    local spell, rank, displayName, icon, startTime, endTime, isTradeSkill, notInterruptible
    if eventName == 'UNIT_SPELLCAST_START' then
        spell, rank, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible =
            UnitCastingInfo(
                unit)
        self.casting = true
        castText:SetText(displayName)

        statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 850 / 1024, 158 / 512, 180 / 512)
    else
        spell, rank, displayName, icon, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo(unit)
        self.channeling = true
        castText:SetText("Channeling")

        statusBar:GetStatusBarTexture():SetTexCoord(432 / 1024, 850 / 1024, 63 / 512, 85 / 512)
    end

    self.startTime = startTime / 1000
    self.endTime = endTime / 1000

    UIFrameFadeRemoveFrame(statusBar)

    local spark = _G[CastingBarFrame:GetName() .. "Spark"]
    if spark then
        spark:Show()
    end

    statusBar:SetAlpha(1.0)
    statusBar:Show()
end

Module.UNIT_SPELLCAST_CHANNEL_START = Module.UNIT_SPELLCAST_START

function Module:UNIT_SPELLCAST_STOP(eventName, unit)
    if unit ~= 'player' then return end

    self.casting, self.channeling = false, false
    self.fadeOut = true

    UIFrameFadeOut(CastingBarFrame, 1, 1.0, 0.0)
end

Module.UNIT_SPELLCAST_CHANNEL_STOP = Module.UNIT_SPELLCAST_STOP

function Module:UNIT_SPELLCAST_FAILED(eventName, unit)
    if unit ~= 'player' then return end

    local statusBar = CastingBarFrame

    if self.casting then
        statusBar:SetValue(1.0)
        statusBar:GetStatusBarTexture():SetTexCoord(2 / 1024, 416 / 1024, 335 / 512, 358 / 512)
    end

    self.casting, self.channeling = false, false
    self.fadeOut = true

    UIFrameFadeOut(statusBar, 1, 1.0, 0.0)
end

function Module:UNIT_SPELLCAST_INTERRUPTED(eventName, unit)
    if unit ~= 'player' then return end

    local statusBar = CastingBarFrame

    if self.casting then
        statusBar:SetValue(1.0)
        statusBar:GetStatusBarTexture():SetTexCoord(2 / 1024, 416 / 1024, 335 / 512, 358 / 512)

        local castText = _G[statusBar:GetName() .. "Text"]
        castText:SetText("Interrupted")
    end

    self.casting, self.channeling = false, false
    self.fadeOut = true

    UIFrameFadeOut(statusBar, 1, 1.0, 0.0)
end

Module.UNIT_SPELLCAST_CHANNEL_INTERRUPTED = Module.UNIT_SPELLCAST_INTERRUPTED

function Module:LoadDefaultSettings()
    DFUI.DB.profile.widgets.castBar = { anchor = "BOTTOM", posX = 0, posY = 250 }
end

function Module:UpdateWidgets()
    do
        local widgetOptions = DFUI.DB.profile.widgets.castBar
        self.castBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end
end

function Module:EnableEditorPreviewForCastBar()
    local castBar = self.castBar

    castBar:SetMovable(true)
    castBar:EnableMouse(true)

    castBar.editorTexture:Show()
    castBar.editorText:Show()

    CastingBarFrame:SetAlpha(0)
    CastingBarFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForCastBar()
    local castBar = self.castBar

    castBar:SetMovable(false)
    castBar:EnableMouse(false)

    castBar.editorTexture:Hide()
    castBar.editorText:Hide()

    CastingBarFrame:SetAlpha(1)
    CastingBarFrame:EnableMouse(true)

    local _, _, relativePoint, posX, posY = castBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.castBar.anchor = relativePoint
    DFUI.DB.profile.widgets.castBar.posX = posX
    DFUI.DB.profile.widgets.castBar.posY = posY
end
