local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'CastBar'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.castBar = nil
Module.startTime = 0
Module.endTime = 0
Module.casting = false
Module.channeling = false
Module.fadeOut = false

local function CastingBarFrame_OnUpdate(self, elapsed)
    local castingBarFrame = CastingBarFrame
    local currentTime, value, remainingTime = GetTime(), 0, 0
    if Module.channeling or Module.casting then
        if Module.casting then
            remainingTime = min(currentTime, Module.endTime) - Module.startTime
            value = remainingTime / (Module.endTime - Module.startTime)
        elseif Module.channeling then
            remainingTime = Module.endTime - currentTime
            value = remainingTime / (Module.endTime - Module.startTime)
        end

        castingBarFrame:SetValue(value)

        Module.castTimeText:SetText(string.format('%.1f/%.2f', remainingTime,
            Module.endTime - Module.startTime))

        local spark = _G[castingBarFrame:GetName() .. "Spark"]
        if spark then
            spark:ClearAllPoints()
            spark:SetPoint("CENTER", castingBarFrame, "LEFT", value * 228, 0)
        end

        if currentTime > Module.endTime then
            Module.casting, Module.channeling = nil, nil
            Module.fadeOut = true
        end
    elseif Module.fadeOut then
        local spark = _G[castingBarFrame:GetName() .. "Spark"]
        if spark then
            spark:Hide()
        end

        if castingBarFrame:GetAlpha() <= 0.0 then
            castingBarFrame:Hide()
        end
    end
end

function Module:OnEnable()
    CastingBarFrame:UnregisterAllEvents()
    CastingBarFrame:HookScript("OnUpdate", CastingBarFrame_OnUpdate)

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

    self.castBar = CreateUIFrame(228, 18, "CastBarFrame")
    self.backgroundTexture = self.castBar:CreateTexture(nil, 'BACKGROUND')
    self.castTimeText = self.castBar:CreateFontString(nil, "BORDER", 'GameFontHighlightSmall')
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

    CastingBarFrame:Unhook("OnUpdate", CastingBarFrame_OnUpdate)

    self.castBar = nil
    self.backgroundTexture = nil
    self.castTimeText = nil
end

function Module:ReplaceBlizzardCastBarFrame()
    local statusBar = CastingBarFrame
    statusBar:ClearAllPoints()

    statusBar:SetPoint("LEFT", self.castBar, "LEFT", 4)
    statusBar:SetSize(228, 16)

    -- Disable Blizzard UI ability to control this element
    statusBar.ClearAllPoints = function() end
    statusBar.SetPoint = function() end

    statusBar:SetSize(228, 16)
    statusBar:SetMinMaxValues(0.0, 1.0)

    local frameBorder = _G[statusBar:GetName() .. "Border"]
    frameBorder:SetAllPoints(castBar)
    frameBorder:SetPoint("TOPLEFT", -2, 2)
    frameBorder:SetPoint("BOTTOMRIGHT", 2, -2)
    frameBorder:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
    frameBorder:SetTexCoord(423 / 1024, 847 / 1024, 2 / 512, 30 / 512)

    for _, region in pairs { statusBar:GetRegions() } do
        if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'BACKGROUND' then
            region:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
            region:SetTexCoord(2 / 1024, 421 / 1024, 185 / 512, 215 / 512)
        end
    end

    local spark = _G[statusBar:GetName() .. "Spark"]
    spark:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
    spark:SetTexCoord(77 / 1024, 88 / 1024, 413 / 512, 460 / 512)
    spark:SetSize(5, 19)

    local castNameText = _G[statusBar:GetName() .. "Text"]
    castNameText:ClearAllPoints()
    castNameText:SetPoint("BOTTOMLEFT", 5, -16)
    castNameText:SetJustifyH("LEFT")

    local statusBarTexture = statusBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(statusBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
    statusBarTexture:SetDrawLayer('BORDER')

    local background = self.backgroundTexture
    background:SetParent(statusBar)
    background:SetAllPoints(statusBar)
    background:SetPoint("BOTTOMRIGHT", 0, -16)
    background:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CastingBar.blp")
    background:SetTexCoord(1 / 1024, 419 / 1024, 1 / 512, 55 / 512)

    local castTimeText = self.castTimeText
    castTimeText:SetParent(statusBar)
    castTimeText:SetPoint("BOTTOMRIGHT", -4, -14)
    castTimeText:SetJustifyH("RIGHT")

    local castBarFlash = _G[statusBar:GetName() .. "Flash"]
    castBarFlash:SetAlpha(0)
end

function Module:PLAYER_ENTERING_WORLD()
    self:ReplaceBlizzardCastBarFrame()

    if RUI.DB.profile.widgets.castBar == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

function Module:UNIT_SPELLCAST_START(eventName, unit)
    if unit ~= 'player' then return end

    local statusBar = CastingBarFrame

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

function Module:UNIT_SPELLCAST_DELAYED(eventName, unit)
    if unit ~= 'player' then return end

    local spell, rank, displayName, icon, startTime, endTime
    if self.casting then
        spell, rank, displayName, icon, startTime, endTime = UnitCastingInfo(unit)
    else
        spell, rank, displayName, icon, startTime, endTime = UnitChannelInfo(unit)
    end

    startTime = startTime / 1000
    endTime = endTime / 1000

    self.startTime = startTime
    self.endTime = endTime
end

Module.UNIT_SPELLCAST_CHANNEL_UPDATE = Module.UNIT_SPELLCAST_DELAYED

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.castBar = { anchor = "BOTTOM", posX = 0, posY = 270 }
end

function Module:UpdateWidgets()
    do
        local widgetOptions = RUI.DB.profile.widgets.castBar
        self.castBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end
end

function Module:EnableEditorPreviewForCastBarFrame()
    local castBar = self.castBar

    castBar:SetMovable(true)
    castBar:EnableMouse(true)

    castBar.editorTexture:Show()
    castBar.editorText:Show()

    local hideFrame = CastingBarFrame
    hideFrame:SetAlpha(0)
    hideFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForCastBarFrame()
    local castBar = self.castBar

    castBar:SetMovable(false)
    castBar:EnableMouse(false)

    castBar.editorTexture:Hide()
    castBar.editorText:Hide()

    local hideFrame = CastingBarFrame
    hideFrame:SetAlpha(1)
    hideFrame:EnableMouse(true)

    local _, _, relativePoint, posX, posY = castBar:GetPoint('CENTER')
    RUI.DB.profile.widgets.castBar.anchor = relativePoint
    RUI.DB.profile.widgets.castBar.posX = posX
    RUI.DB.profile.widgets.castBar.posY = posY
end
