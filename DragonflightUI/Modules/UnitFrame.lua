local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local moduleName = 'UnitFrame'
local Module = DFUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.playerFrameBar = nil
Module.targetFrameBar = nil
Module.targetOfTargetFrameBar = nil
Module.focusFrameBar = nil

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        self:RemoveBlizzardUnitFrames()
        self:CreateUnitFrames()

        if DFUI.DB.profile.widgets.playerFrame == nil or DFUI.DB.profile.widgets.targetFrame == nil or
            DFUI.DB.profile.widgets.targetOfTargetFrame == nil or DFUI.DB.profile.widgets.focusFrame == nil then
            self:LoadDefaultSettings()
        end

        self:UpdateWidgets()
    end)
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local blizzUnitFrames = {
    PlayerFrameTexture,
    PlayerFrameBackground,
    PlayerAttackBackground,
    PlayerAttackIcon,
    TargetFrameTextureFrameTexture,
    TargetFrameBackground,
    FocusFrameTextureFrameTexture,
    FocusFrameBackground,
    TargetFrameToTTextureFrameTexture,
    TargetFrameToTBackground
};

function Module:RemoveBlizzardUnitFrames()
    for _, blizzFrame in pairs(blizzUnitFrames) do
        blizzFrame:SetAlpha(0)
    end
end

local function CreatePlayerUnitFrame()
    local width = 191 + 8
    local height = 65 + 8

    local playerFrameBar = CreateFrame("Frame", 'DFUI_PlayerFrame', UIParent)
    playerFrameBar:SetSize(width, height)

    playerFrameBar:RegisterForDrag("LeftButton")
    playerFrameBar:EnableMouse(false)
    playerFrameBar:SetMovable(false)
    playerFrameBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    playerFrameBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = playerFrameBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(PlayerFrame)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        playerFrameBar.editorTexture = texture

        local fontString = playerFrameBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Player Frame")
        fontString:Hide()

        playerFrameBar.editorText = fontString
    end

    local playerFrame = PlayerFrame
    playerFrame:ClearAllPoints()
    playerFrame:SetPoint("CENTER", playerFrameBar, "LEFT", 4)

    playerFrame:SetSize(191, 65)

    local portrait = PlayerPortrait
    portrait:ClearAllPoints()
    portrait:SetPoint("LEFT", 1, -1)
    portrait:SetSize(portrait:GetWidth() - 3, portrait:GetHeight() - 3)
    portrait:SetDrawLayer("BACKGROUND")

    do
        local texture = playerFrame:CreateTexture(nil, "BORDER")
        texture:SetAllPoints(playerFrame)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
        texture:SetTexCoord(812 / 1024, 1002 / 1024, 3 / 512, 67 / 512)

        playerFrame.background = texture
    end

    local healthBar = PlayerFrameHealthBar
    healthBar:ClearAllPoints()
    healthBar:SetPoint("TOPLEFT", 65, -26)
    healthBar:SetPoint("BOTTOMRIGHT", -2, 22)

    local statusBarTexture = healthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusBarTexture:SetTexCoord(561 / 1024, 685 / 1024, 183 / 512, 200 / 512)

    local manaBar = PlayerFrameManaBar
    manaBar:ClearAllPoints()
    manaBar:SetPoint("TOPLEFT", 65, -46)
    manaBar:SetPoint("BOTTOMRIGHT", -2, 10)

    statusBarTexture = manaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusBarTexture:SetTexCoord(573 / 1024, 696 / 1024, 238 / 512, 244 / 512)

    PlayerName:SetPoint("TOP", 14, -9)
    PlayerLevelText:SetPoint("TOPRIGHT", -8, -10)
    PlayerFrameHealthBarText:SetPoint("CENTER", 30, -1)
    PlayerFrameManaBarText:SetPoint("CENTER", 30, -17)

    local restIcon = PlayerRestIcon
    restIcon:ClearAllPoints()
    restIcon:SetPoint("TOPLEFT", 50, 20)
    restIcon:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframerestingflipbook.blp")

    local statusGlow = PlayerStatusGlow
    statusGlow:ClearAllPoints()
    statusGlow:SetFrameLevel(0)
    statusGlow:SetPoint("CENTER", 0, -3)

    local statusTexture = PlayerStatusTexture
    statusTexture:SetAllPoints(playerFrame)
    statusTexture:SetPoint("BOTTOM", 0, -1)
    statusTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusTexture:SetTexCoord(201 / 1024, 391 / 1024, 90 / 512, 156 / 512)
    statusTexture:SetDrawLayer("ARTWORK")

    playerFrame:HookScript('OnUpdate', function(self, elapsed)
        AnimateTexCoords(PlayerRestIcon, 512, 512, 64, 64, 42, elapsed, 0.1)
    end)

    local arrowTexture = playerFrame:CreateTexture(nil, "BORDER")
    arrowTexture:SetPoint("LEFT", 48, -22)
    arrowTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    arrowTexture:SetTexCoord(986 / 1024, 997 / 1024, 144 / 512, 154 / 512)
    arrowTexture:SetSize(12, 12)

    local pvpIcon = PlayerPVPIcon
    pvpIcon:ClearAllPoints()
    pvpIcon:SetPoint("LEFT", -16, -12)

    PlayerPVPTimerText:SetPoint("TOPLEFT", -10, 10)

    local frameFlash = PlayerFrameFlash
    frameFlash:SetAllPoints(playerFrame)
    frameFlash:SetPoint("BOTTOM", 0, -1)
    frameFlash:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    frameFlash:SetTexCoord(201 / 1024, 391 / 1024, 90 / 512, 156 / 512)
    frameFlash:SetDrawLayer("ARTWORK")

    return playerFrameBar
end

local function CreateTargetUnitFrame()
    local width = 191 + 8
    local height = 65 + 8

    local targetFrameBar = CreateFrame("Frame", 'DFUI_TargetFrame', UIParent)
    targetFrameBar:SetSize(width, height)

    targetFrameBar:RegisterForDrag("LeftButton")
    targetFrameBar:EnableMouse(false)
    targetFrameBar:SetMovable(false)
    targetFrameBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    targetFrameBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = targetFrameBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(TargetFrame)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        targetFrameBar.editorTexture = texture

        local fontString = targetFrameBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Target Frame")
        fontString:Hide()

        targetFrameBar.editorText = fontString
    end

    local targetFrame = TargetFrame
    targetFrame:ClearAllPoints()
    targetFrame:SetPoint("CENTER", targetFrameBar, "LEFT", 4)

    targetFrame:SetSize(191, 65)

    local portrait = TargetFramePortrait
    portrait:ClearAllPoints()
    portrait:SetPoint("RIGHT", -5, 1)
    portrait:SetSize(portrait:GetWidth() - 8, portrait:GetHeight() - 8)
    portrait:SetDrawLayer("BACKGROUND")

    do
        local texture = targetFrame:CreateTexture(nil, "BORDER")
        texture:SetAllPoints(targetFrame)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
        texture:SetTexCoord(782 / 1024, 970 / 1024, 88 / 512, 150 / 512)

        targetFrame.background = texture
    end

    local healthBar = TargetFrameHealthBar
    healthBar:ClearAllPoints()
    healthBar:SetPoint("TOPLEFT", 4, -22)
    healthBar:SetPoint("BOTTOMRIGHT", -62, 21)

    local statusBarTexture = healthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusBarTexture:SetTexCoord(433 / 1024, 557 / 1024, 157 / 512, 179 / 512)

    local manaBar = TargetFrameManaBar
    manaBar:ClearAllPoints()
    manaBar:SetPoint("TOPLEFT", 4, -43)
    manaBar:SetPoint("BOTTOMRIGHT", -54, 10)

    statusBarTexture = manaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusBarTexture:SetTexCoord(332 / 1024, 463 / 1024, 207 / 512, 221 / 512)

    local nameText = TargetFrameTextureFrameName
    nameText:SetPoint("TOP", -16, -9)
    nameText:SetDrawLayer("OVERLAY")

    local levelText = TargetFrameTextureFrameLevelText
    levelText:SetPoint("TOPLEFT", 8, -9)
    levelText:SetDrawLayer("OVERLAY")

    local healthBarText = TargetFrameTextureFrameHealthBarText
    healthBarText:SetPoint("CENTER", -25, -1)
    healthBarText:SetDrawLayer("OVERLAY")

    local deadText = TargetFrameTextureFrameDeadText
    deadText:SetPoint("CENTER", -25, -1)
    deadText:SetDrawLayer("OVERLAY")

    local manaBarText = TargetFrameTextureFrameManaBarText
    manaBarText:SetPoint("CENTER", -25, -18)
    manaBarText:SetDrawLayer("OVERLAY")

    TargetFrameNameBackground:Hide()

    local pvpIcon = TargetFrameTextureFramePVPIcon
    pvpIcon:ClearAllPoints()
    pvpIcon:SetPoint("RIGHT", 40, -12)

    local frameFlash = TargetFrameFlash
    frameFlash:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    frameFlash:SetDrawLayer("ARTWORK")

    return targetFrameBar
end

local function CreateTargetOfTargetFrame()
    local width = 113 + 8
    local height = 42 + 8

    local targetOfTargetFrameBar = CreateFrame("Frame", 'DFUI_TargetOfTargetFrame', UIParent)
    targetOfTargetFrameBar:SetSize(width, height)

    targetOfTargetFrameBar:RegisterForDrag("LeftButton")
    targetOfTargetFrameBar:EnableMouse(false)
    targetOfTargetFrameBar:SetMovable(false)
    targetOfTargetFrameBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    targetOfTargetFrameBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = targetOfTargetFrameBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(TargetFrameToT)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        targetOfTargetFrameBar.editorTexture = texture

        local fontString = targetOfTargetFrameBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("TOT Frame")
        fontString:Hide()

        targetOfTargetFrameBar.editorText = fontString
    end

    local targetFrameToT = TargetFrameToT
    targetFrameToT:ClearAllPoints()
    targetFrameToT:SetPoint("CENTER", targetOfTargetFrameBar, "LEFT", 4)

    targetFrameToT:SetSize(113, 42)

    do
        local texture = targetFrameToT:CreateTexture(nil, "BORDER")
        texture:SetAllPoints(targetFrameToT)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
        texture:SetTexCoord(3 / 1024, 117 / 1024, 421 / 512, 463 / 512)

        targetFrameToT.background = texture
    end

    local healthBar = TargetFrameToTHealthBar
    healthBar:ClearAllPoints()
    healthBar:SetPoint("TOPLEFT", 40, -15)
    healthBar:SetPoint("BOTTOMRIGHT", -2, 17)

    local statusBarTexture = healthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusBarTexture:SetTexCoord(940 / 1024, 1014 / 1024, 72 / 512, 83 / 512)

    local manaBar = TargetFrameToTManaBar
    manaBar:ClearAllPoints()
    manaBar:SetPoint("TOPLEFT", 41, -25)
    manaBar:SetPoint("BOTTOMRIGHT", -3, 8)

    statusBarTexture = manaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusBarTexture:SetTexCoord(398 / 1024, 470 / 1024, 246 / 512, 254 / 512)

    local nameText = TargetFrameToTTextureFrameName
    nameText:SetPoint("TOPLEFT", 47, 24)
    nameText:SetDrawLayer("OVERLAY")

    return targetOfTargetFrameBar
end

local function CreateFocusFrame()
    local width = 185 + 8
    local height = 59 + 8

    local focusFrameBar = CreateFrame("Frame", 'DFUI_FocusFrame', UIParent)
    focusFrameBar:SetSize(width, height)

    focusFrameBar:RegisterForDrag("LeftButton")
    focusFrameBar:EnableMouse(true)
    focusFrameBar:SetMovable(true)
    focusFrameBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    focusFrameBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = focusFrameBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(FocusFrame)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        focusFrameBar.editorTexture = texture

        local fontString = focusFrameBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Focus Frame")
        fontString:Hide()

        focusFrameBar.editorText = fontString
    end

    local focusFrame = FocusFrame
    focusFrame:ClearAllPoints()
    focusFrame:SetPoint("CENTER", focusFrameBar, "LEFT", 4)

    focusFrame:SetSize(185, 59)

    local portrait = FocusFramePortrait
    portrait:ClearAllPoints()
    portrait:SetPoint("RIGHT", -3, 1)
    portrait:SetSize(portrait:GetWidth() - 12, portrait:GetHeight() - 12)
    portrait:SetDrawLayer("BACKGROUND")

    do
        local texture = focusFrame:CreateTexture(nil, "BORDER")
        texture:SetAllPoints(focusFrame)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
        texture:SetTexCoord(590 / 1024, 774 / 1024, 87 / 512, 150 / 512)

        focusFrame.background = texture
    end

    local healthBar = FocusFrameHealthBar
    healthBar:ClearAllPoints()
    healthBar:SetPoint("TOPLEFT", 2, -22)
    healthBar:SetPoint("BOTTOMRIGHT", -60, 28)

    local statusBarTexture = healthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusBarTexture:SetTexCoord(812 / 1024, 936 / 1024, 178 / 512, 191 / 512)

    local manaBar = FocusFrameManaBar
    manaBar:ClearAllPoints()
    manaBar:SetPoint("TOPLEFT", 2, -34)
    manaBar:SetPoint("BOTTOMRIGHT", -58, 16)

    statusBarTexture = manaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiunitframe.blp")
    statusBarTexture:SetTexCoord(323 / 1024, 449 / 1024, 221 / 512, 231 / 512)

    local nameText = FocusFrameTextureFrameName
    nameText:SetPoint("TOP", -20, -8)
    nameText:SetDrawLayer("OVERLAY")

    local levelText = FocusFrameTextureFrameLevelText
    levelText:SetPoint("TOPLEFT", 8, -9)
    levelText:SetDrawLayer("OVERLAY")

    local healthBarText = FocusFrameTextureFrameHealthBarText
    healthBarText:SetPoint("CENTER", -25, 2)
    healthBarText:SetDrawLayer("OVERLAY")

    local deadText = FocusFrameTextureFrameDeadText
    deadText:SetPoint("CENTER", -25, 2)
    deadText:SetDrawLayer("OVERLAY")

    local manaBarText = FocusFrameTextureFrameManaBarText
    manaBarText:SetPoint("CENTER", -25, -10)
    manaBarText:SetDrawLayer("OVERLAY")

    FocusFrameNameBackground:Hide()

    return focusFrameBar
end

local function TargetFrame_UpdateAuras()
    local targetFrameBuffs = _G["TargetFrameBuff1"]
    if targetFrameBuffs then
        targetFrameBuffs:ClearAllPoints()
        targetFrameBuffs:SetPoint("BOTTOMLEFT", 3, -13)
    end

    local targetFrameDebuffs = _G["TargetFrameDebuff1"]
    if targetFrameDebuffs then
        targetFrameDebuffs:ClearAllPoints()
        targetFrameDebuffs:SetPoint("BOTTOMLEFT", 3, -13)
    end

    local frameFlash = TargetFrameFlash
    frameFlash:SetAllPoints(TargetFrame)
    frameFlash:SetPoint("TOPLEFT", 2, 0)
    frameFlash:SetTexCoord(1 / 1024, 185 / 1024, 300 / 512, 364 / 512)
end

function Module:CreateUnitFrames()
    self.playerFrameBar = CreatePlayerUnitFrame()
    self.playerFrameBar:SetPoint("CENTER", -200, 0)

    self.targetFrameBar = CreateTargetUnitFrame()
    self.targetFrameBar:SetPoint("CENTER", 200, 0)

    self.targetOfTargetFrameBar = CreateTargetOfTargetFrame()
    self.targetOfTargetFrameBar:SetPoint('CENTER', self.targetFrameBar, "BOTTOMRIGHT", -5, -25)

    self.focusFrameBar = CreateFocusFrame()
    self.focusFrameBar:SetPoint('CENTER', self.playerFrameBar, "BOTTOM", 0, -25)

    self:SecureHook('TargetFrame_UpdateAuras', TargetFrame_UpdateAuras)
end

function Module:LoadDefaultSettings()
    DFUI.DB.profile.widgets.playerFrame = { anchor = "TOPLEFT", posX = 105, posY = -15 }
    DFUI.DB.profile.widgets.targetFrame = { anchor = "TOPLEFT", posX = 300, posY = -15 }
    DFUI.DB.profile.widgets.targetOfTargetFrame = { anchor = "TOPLEFT", posX = 370, posY = -85 }
    DFUI.DB.profile.widgets.focusFrame = { anchor = "TOPLEFT", posX = 105, posY = -85 }
end

function Module:UpdateWidgets()
    do
        local widgetOptions = DFUI.DB.profile.widgets.playerFrame
        self.playerFrameBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = DFUI.DB.profile.widgets.targetFrame
        self.targetFrameBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = DFUI.DB.profile.widgets.targetOfTargetFrame
        self.targetOfTargetFrameBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = DFUI.DB.profile.widgets.focusFrame
        self.focusFrameBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end
end

function Module:EnableEditorPreviewForPlayerFrame()
    local playerFrameBar = self.playerFrameBar

    playerFrameBar:SetMovable(true)
    playerFrameBar:EnableMouse(true)

    playerFrameBar.editorTexture:Show()
    playerFrameBar.editorText:Show()

    PlayerFrame:SetAlpha(0)
    PlayerFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForPlayerFrame()
    local playerFrameBar = self.playerFrameBar

    playerFrameBar:SetMovable(false)
    playerFrameBar:EnableMouse(false)

    playerFrameBar.editorTexture:Hide()
    playerFrameBar.editorText:Hide()

    PlayerFrame:SetAlpha(1)
    PlayerFrame:EnableMouse(true)
end

function Module:EnableEditorPreviewForTargetFrame()
    local targetFrameBar = self.targetFrameBar

    targetFrameBar:SetMovable(true)
    targetFrameBar:EnableMouse(true)

    targetFrameBar.editorTexture:Show()
    targetFrameBar.editorText:Show()

    TargetFrame:SetAlpha(0)
    TargetFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForTargetFrame()
    local targetFrameBar = self.targetFrameBar

    targetFrameBar:SetMovable(false)
    targetFrameBar:EnableMouse(false)

    targetFrameBar.editorTexture:Hide()
    targetFrameBar.editorText:Hide()

    TargetFrame:SetAlpha(1)
    TargetFrame:EnableMouse(true)
end

function Module:EnableEditorPreviewForTargetOfTargetFrame()
    local targetOfTargetFrameBar = self.targetOfTargetFrameBar

    targetOfTargetFrameBar:SetMovable(true)
    targetOfTargetFrameBar:EnableMouse(true)

    targetOfTargetFrameBar.editorTexture:Show()
    targetOfTargetFrameBar.editorText:Show()

    TargetFrameToT:SetAlpha(0)
    TargetFrameToT:EnableMouse(false)
end

function Module:DisableEditorPreviewForTargetOfTargetFrame()
    local targetOfTargetFrameBar = self.targetOfTargetFrameBar

    targetOfTargetFrameBar:SetMovable(false)
    targetOfTargetFrameBar:EnableMouse(false)

    targetOfTargetFrameBar.editorTexture:Hide()
    targetOfTargetFrameBar.editorText:Hide()

    TargetFrameToT:SetAlpha(1)
    TargetFrameToT:EnableMouse(true)
end

function Module:EnableEditorPreviewForFocusFrame()
    local focusFrameBar = self.focusFrameBar

    focusFrameBar:SetMovable(true)
    focusFrameBar:EnableMouse(true)

    focusFrameBar.editorTexture:Show()
    focusFrameBar.editorText:Show()

    FocusFrame:SetAlpha(0)
    FocusFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForFocusFrame()
    local focusFrameBar = self.focusFrameBar

    focusFrameBar:SetMovable(false)
    focusFrameBar:EnableMouse(false)

    focusFrameBar.editorTexture:Hide()
    focusFrameBar.editorText:Hide()

    FocusFrame:SetAlpha(1)
    FocusFrame:EnableMouse(true)
end
