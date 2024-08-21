local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local moduleName = 'UnitFrame'
local Module = DFUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.playerFrameBar = nil
Module.targetFrameBar = nil
Module.targetOfTargetFrameBar = nil
Module.focusFrameBar = nil
Module.petFrameBar = nil

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

    local targetFrameFlash = TargetFrameFlash
    targetFrameFlash:SetAllPoints(TargetFrame)
    targetFrameFlash:SetPoint("TOPLEFT", 2, 0)
    targetFrameFlash:SetTexCoord(1 / 1024, 185 / 1024, 300 / 512, 364 / 512)
end

local function PlayerFrame_OnUpdate(self, elapsed)
    AnimateTexCoords(PlayerRestIcon, 512, 512, 64, 64, 42, elapsed, 1)
end

local function PetFrame_Update()
    local frameBorder = _G[PetFrame:GetName() .. 'Texture']
    frameBorder:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("RUNE_TYPE_UPDATE")

    self:SecureHook('TargetFrame_UpdateAuras', TargetFrame_UpdateAuras)
    PlayerFrame:HookScript('OnUpdate', PlayerFrame_OnUpdate)
    self:SecureHook('PetFrame_Update', PetFrame_Update)

    self:CreateUIFrames()
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("RUNE_TYPE_UPDATE")

    self:Unhook('TargetFrame_UpdateAuras', TargetFrame_UpdateAuras)
    PlayerFrame:Unhook('OnUpdate', PlayerFrame_OnUpdate)
    self:Unhook('PetFrame_Update', PetFrame_Update)
end

local function UpdateRune(button)
    local rune = button:GetID()
    local runeType = GetRuneType(rune)

    if runeType then
        local runeTexture = _G[button:GetName() .. "Rune"]
        if runeTexture then
            runeTexture:SetTexture(
                'Interface\\AddOns\\DragonflightUI\\Textures\\PlayerFrame\\ClassOverlayDeathKnightRunes.BLP')
            if runeType == 1 then     -- Blood
                runeTexture:SetTexCoord(0 / 128, 34 / 128, 0 / 128, 34 / 128)
            elseif runeType == 2 then -- Unholy
                runeTexture:SetTexCoord(0 / 128, 34 / 128, 68 / 128, 102 / 128)
            elseif runeType == 3 then -- Frost
                runeTexture:SetTexCoord(34 / 128, 68 / 128, 0 / 128, 34 / 128)
            elseif runeType == 4 then -- Death
                runeTexture:SetTexCoord(68 / 128, 102 / 128, 0 / 128, 34 / 128)
            end
        end
    end
end

function Module:RUNE_TYPE_UPDATE(eventName, rune)
    UpdateRune(_G['RuneButtonIndividual' .. rune])
end

function Module:PLAYER_ENTERING_WORLD()
    self:RemoveBlizzardUnitFrames()
    self:ReplaceBlizzardUnitFrames()

    if DFUI.DB.profile.widgets.playerFrame == nil or DFUI.DB.profile.widgets.targetFrame == nil or
        DFUI.DB.profile.widgets.targetOfTargetFrame == nil or DFUI.DB.profile.widgets.focusFrame == nil or
        DFUI.DB.profile.widgets.petFrame == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

local blizzUnitFrames = {
    PlayerAttackBackground,
    PlayerAttackIcon,
    TargetFrameTextureFrameTexture,
    FocusFrameTextureFrameTexture,
    TargetFrameToTTextureFrameTexture
};

function Module:RemoveBlizzardUnitFrames()
    for _, blizzFrame in pairs(blizzUnitFrames) do
        blizzFrame:SetAlpha(0)
    end
end

function Module:ReplaceBlizzardPlayerFrame()
    local playerFrame = PlayerFrame
    playerFrame:ClearAllPoints()
    playerFrame:SetPoint("LEFT", self.playerFrameBar, "LEFT", 0)

    playerFrame:SetSize(self.playerFrameBar:GetWidth(), self.playerFrameBar:GetHeight())

    -- Main
    local playerPortrait = PlayerPortrait
    playerPortrait:ClearAllPoints()
    playerPortrait:SetPoint("LEFT", 1, -1)
    playerPortrait:SetSize(58, 58)
    playerPortrait:SetDrawLayer("BACKGROUND")

    local frameBorder = _G[playerFrame:GetName() .. 'Texture']
    frameBorder:GetParent():SetFrameLevel(playerFrame:GetFrameLevel())
    frameBorder:SetAllPoints(playerFrame)
    frameBorder:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    frameBorder:SetTexCoord(812 / 1024, 1002 / 1024, 3 / 512, 67 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local playerHealthBar = PlayerFrameHealthBar
    playerHealthBar:SetFrameLevel(playerFrame:GetFrameLevel())
    playerHealthBar:ClearAllPoints()
    playerHealthBar:SetPoint("TOPLEFT", 65, -26)
    playerHealthBar:SetPoint("BOTTOMRIGHT", -2, 22)

    local statusBarTexture = playerHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(561 / 1024, 685 / 1024, 183 / 512, 200 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Mana Bar
    local playerManaBar = PlayerFrameManaBar
    playerManaBar:SetFrameLevel(playerFrame:GetFrameLevel())
    playerManaBar:ClearAllPoints()
    playerManaBar:SetPoint("TOPLEFT", 65, -46)
    playerManaBar:SetPoint("BOTTOMRIGHT", -2, 10)

    statusBarTexture = playerManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(573 / 1024, 696 / 1024, 238 / 512, 244 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Font Strings
    local playerNameText = PlayerName
    playerNameText:ClearAllPoints()
    playerNameText:SetPoint("TOP", 14, -9)
    playerNameText:SetDrawLayer('OVERLAY')

    local playerLevelText = PlayerLevelText
    playerLevelText:ClearAllPoints()
    playerLevelText:SetPoint("TOPRIGHT", -8, -10)
    playerLevelText:SetDrawLayer('OVERLAY')

    local playerHealthText = PlayerFrameHealthBarText
    playerHealthText:ClearAllPoints()
    playerHealthText:SetPoint("CENTER", 30, -1)
    playerHealthText:SetDrawLayer('OVERLAY')

    local playerManaText = PlayerFrameManaBarText
    playerManaText:ClearAllPoints()
    playerManaText:SetPoint("CENTER", 30, -17)
    playerManaText:SetDrawLayer('OVERLAY')

    -- Rest Animation Icon
    local playerRestIcon = PlayerRestIcon
    playerRestIcon:ClearAllPoints()
    playerRestIcon:SetPoint("TOPLEFT", 40, 10)
    playerRestIcon:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\PlayerFrame\\PlayerRestFlipbook.blp")
    playerRestIcon:SetDrawLayer('ARTWORK')

    local playerStatusGlow = PlayerStatusGlow
    playerStatusGlow:ClearAllPoints()
    playerStatusGlow:SetFrameLevel(0)
    playerStatusGlow:SetPoint("CENTER", 0, -3)

    local playerStatusTexture = PlayerStatusTexture
    playerStatusTexture:SetAllPoints(playerFrame)
    playerStatusTexture:SetPoint("BOTTOM", 0, -1)
    playerStatusTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    playerStatusTexture:SetTexCoord(201 / 1024, 391 / 1024, 90 / 512, 156 / 512)
    playerStatusTexture:SetDrawLayer("ARTWORK")

    -- Reuse Blizzard Textures
    local arrowElement = PlayerFrameBackground
    arrowElement:ClearAllPoints()
    arrowElement:SetPoint("LEFT", 48, -22)
    arrowElement:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    arrowElement:SetTexCoord(986 / 1024, 997 / 1024, 144 / 512, 154 / 512)
    arrowElement:SetSize(12, 12)
    arrowElement:SetDrawLayer('BORDER')

    local playerPVPIcon = PlayerPVPIcon
    playerPVPIcon:ClearAllPoints()
    playerPVPIcon:SetPoint("LEFT", -16, -12)

    PlayerPVPTimerText:SetPoint("TOPLEFT", -10, 10)

    local playerFrameFlash = PlayerFrameFlash
    playerFrameFlash:SetAllPoints(playerFrame)
    playerFrameFlash:SetPoint("BOTTOM", 0, -1)
    playerFrameFlash:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    playerFrameFlash:SetTexCoord(201 / 1024, 391 / 1024, 90 / 512, 156 / 512)
    playerFrameFlash:SetDrawLayer("ARTWORK")

    -- DK Runes
    for index = 1, 6 do
        local button = _G['RuneButtonIndividual' .. index]
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint('LEFT', _G['RuneButtonIndividual' .. index - 1], 'RIGHT', 4, 0)
        else
            button:SetPoint('CENTER', PlayerFrame, 'BOTTOM', -20, -6)
        end

        UpdateRune(button)
    end
end

function Module:ReplaceBlizzardTargetFrame()
    local targetFrame = TargetFrame
    targetFrame:ClearAllPoints()
    targetFrame:SetPoint("LEFT", self.targetFrameBar, "LEFT", 0)

    targetFrame:SetSize(self.targetFrameBar:GetWidth(), self.targetFrameBar:GetHeight())

    -- Main
    local targetPortrait = TargetFramePortrait
    targetPortrait:ClearAllPoints()
    targetPortrait:SetPoint("RIGHT", -5, 1)
    targetPortrait:SetSize(58, 58)
    targetPortrait:SetDrawLayer("BACKGROUND")

    -- Reuse Blizzard Textures
    local frameBorder = _G[targetFrame:GetName() .. 'Background']
    frameBorder:GetParent():SetFrameLevel(targetFrame:GetFrameLevel())
    frameBorder:SetAllPoints(targetFrame)
    frameBorder:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    frameBorder:SetTexCoord(782 / 1024, 970 / 1024, 88 / 512, 150 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local targetHealthBar = TargetFrameHealthBar
    targetHealthBar:SetFrameLevel(targetFrame:GetFrameLevel())
    targetHealthBar:ClearAllPoints()
    targetHealthBar:SetPoint("TOPLEFT", 4, -22)
    targetHealthBar:SetPoint("BOTTOMRIGHT", -62, 21)

    local statusBarTexture = targetHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(433 / 1024, 557 / 1024, 157 / 512, 179 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    local targetManaBar = TargetFrameManaBar
    targetManaBar:SetFrameLevel(targetFrame:GetFrameLevel())
    targetManaBar:ClearAllPoints()
    targetManaBar:SetPoint("TOPLEFT", 4, -43)
    targetManaBar:SetPoint("BOTTOMRIGHT", -54, 10)

    statusBarTexture = targetManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(332 / 1024, 463 / 1024, 207 / 512, 221 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Font Strings
    local targetNameText = TargetFrameTextureFrameName
    targetNameText:ClearAllPoints()
    targetNameText:SetPoint("TOP", -16, -9)
    targetNameText:SetDrawLayer("OVERLAY")

    local targetLevelText = TargetFrameTextureFrameLevelText
    targetLevelText:ClearAllPoints()
    targetLevelText:SetPoint("TOPLEFT", 8, -9)
    targetLevelText:SetDrawLayer("OVERLAY")

    local targetHealthText = TargetFrameTextureFrameHealthBarText
    targetHealthText:ClearAllPoints()
    targetHealthText:SetPoint("CENTER", -25, -1)
    targetHealthText:SetDrawLayer("OVERLAY")

    local targetDeathText = TargetFrameTextureFrameDeadText
    targetDeathText:ClearAllPoints()
    targetDeathText:SetPoint("CENTER", -25, -1)
    targetDeathText:SetDrawLayer("OVERLAY")

    local targetManaText = TargetFrameTextureFrameManaBarText
    targetManaText:ClearAllPoints()
    targetManaText:SetPoint("CENTER", -25, -18)
    targetManaText:SetDrawLayer("OVERLAY")

    TargetFrameNameBackground:Hide()

    local targetPVPIcon = TargetFrameTextureFramePVPIcon
    targetPVPIcon:ClearAllPoints()
    targetPVPIcon:SetPoint("RIGHT", 40, -12)

    -- Secure UI Element
    local targetFrameFlash = TargetFrameFlash
    targetFrameFlash:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    targetFrameFlash:SetDrawLayer("ARTWORK")

    -- Combo Points
    local comboFrame = ComboFrame
    comboFrame:ClearAllPoints()
    comboFrame:SetPoint("CENTER", targetFrame, "CENTER", -33, 21)

    for index = 1, MAX_COMBO_POINTS do
        local comboPoint = _G['ComboPoint' .. index]
        comboPoint:SetSize(13, 13)

        for _, region in pairs { comboPoint:GetRegions() } do
            if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'BACKGROUND' then
                region:SetAllPoints(comboPoint)
                region:SetTexture(
                    "Interface\\AddOns\\DragonflightUI\\Textures\\PlayerFrame\\ClassOverlayComboPoints.BLP")
                region:SetTexCoord(100 / 128, 118 / 128, 43 / 64, 61 / 64)
            end
        end

        local highlight = _G[comboPoint:GetName() .. 'Highlight']
        highlight:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\PlayerFrame\\ClassOverlayComboPoints.BLP")
        highlight:SetTexCoord(58 / 128, 72 / 128, 23 / 64, 37 / 64)
        highlight:SetSize(10, 10)
    end
end

function Module:ReplaceBlizzardPetFrame()
    local petFrame = PetFrame
    petFrame:ClearAllPoints()
    petFrame:SetPoint("LEFT", self.petFrameBar, "LEFT", 0)

    petFrame:SetSize(self.petFrameBar:GetWidth(), self.petFrameBar:GetHeight())

    -- Main
    local petPortrait = PetPortrait
    petPortrait:ClearAllPoints()
    petPortrait:SetPoint("LEFT", 2, 0)
    petPortrait:SetSize(33, 33)
    petPortrait:SetDrawLayer("BACKGROUND")

    -- Secure UI Element
    local frameBorder = _G[petFrame:GetName() .. 'Texture']
    frameBorder:GetParent():SetFrameLevel(petFrame:GetFrameLevel())
    frameBorder:SetAllPoints(petFrame)
    frameBorder:SetTexCoord(3 / 1024, 117 / 1024, 421 / 512, 463 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local petHealthBar = PetFrameHealthBar
    petHealthBar:SetFrameLevel(petFrame:GetFrameLevel())
    petHealthBar:ClearAllPoints()
    petHealthBar:SetPoint("TOPLEFT", 40, -15)
    petHealthBar:SetPoint("BOTTOMRIGHT", -2, 17)

    local statusBarTexture = petHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(940 / 1024, 1014 / 1024, 72 / 512, 83 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Mana Bar
    local petManaBar = PetFrameManaBar
    petManaBar:SetFrameLevel(petFrame:GetFrameLevel())
    petManaBar:ClearAllPoints()
    petManaBar:SetPoint("TOPLEFT", 41, -25)
    petManaBar:SetPoint("BOTTOMRIGHT", -3, 8)

    statusBarTexture = petManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(398 / 1024, 470 / 1024, 246 / 512, 254 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Font Strings
    local petNameText = PetName
    petNameText:ClearAllPoints()
    petNameText:SetPoint("TOP", 12, -2)
    petNameText:SetJustifyH("LEFT")
    petNameText:SetDrawLayer("OVERLAY")

    local petHealthText = PetFrameHealthBarText
    petHealthText:ClearAllPoints()
    petHealthText:SetPoint("CENTER", 20, 1)
    petHealthText:SetDrawLayer("OVERLAY")

    local petManaText = PetFrameManaBarText
    petManaText:ClearAllPoints()
    petManaText:SetPoint("CENTER", 19, -9)
    petManaText:SetDrawLayer("OVERLAY")

    local petHappiness = PetFrameHappiness
    petHappiness:ClearAllPoints()
    petHappiness:SetPoint("LEFT", petFrame, "RIGHT", 5, -5)
end

function Module:ReplaceBlizzardTOTFrame()
    local targetFrameToT = TargetFrameToT
    targetFrameToT:ClearAllPoints()
    targetFrameToT:SetPoint("LEFT", self.targetOfTargetFrameBar, "LEFT", 0)

    targetFrameToT:SetSize(self.targetOfTargetFrameBar:GetWidth(), self.targetOfTargetFrameBar:GetHeight())

    -- Reuse Blizzard Frames
    local frameBorder = _G[targetFrameToT:GetName() .. 'Background']
    frameBorder:GetParent():SetFrameLevel(targetFrameToT:GetFrameLevel())
    frameBorder:SetAllPoints(targetFrameToT)
    frameBorder:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    frameBorder:SetTexCoord(3 / 1024, 117 / 1024, 421 / 512, 463 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local totHealthBar = TargetFrameToTHealthBar
    totHealthBar:SetFrameLevel(targetFrameToT:GetFrameLevel())
    totHealthBar:ClearAllPoints()
    totHealthBar:SetPoint("TOPLEFT", 40, -15)
    totHealthBar:SetPoint("BOTTOMRIGHT", -2, 17)

    local statusBarTexture = totHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(940 / 1024, 1014 / 1024, 72 / 512, 83 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Mana Bar
    local totManaBar = TargetFrameToTManaBar
    totManaBar:SetFrameLevel(targetFrameToT:GetFrameLevel())
    totManaBar:ClearAllPoints()
    totManaBar:SetPoint("TOPLEFT", 41, -25)
    totManaBar:SetPoint("BOTTOMRIGHT", -3, 8)

    statusBarTexture = totManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(398 / 1024, 470 / 1024, 246 / 512, 254 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Font Strings
    local totNameText = TargetFrameToTTextureFrameName
    totNameText:ClearAllPoints()
    totNameText:SetPoint("TOPLEFT", 47, -3)
    totNameText:SetDrawLayer("OVERLAY")
end

function Module:ReplaceBlizzardFocusFrame()
    local focusFrame = FocusFrame
    focusFrame:ClearAllPoints()
    focusFrame:SetPoint("LEFT", self.focusFrameBar, "LEFT", 0)

    focusFrame:SetSize(self.focusFrameBar:GetWidth(), self.focusFrameBar:GetHeight())

    local focusPortrait = FocusFramePortrait
    focusPortrait:ClearAllPoints()
    focusPortrait:SetPoint("RIGHT", -3, 1)
    focusPortrait:SetSize(40, 40)
    focusPortrait:SetDrawLayer("BACKGROUND")

    -- Reuse Blizzard Frames
    local frameBorder = _G[focusFrame:GetName() .. 'Background']
    frameBorder:GetParent():SetFrameLevel(focusFrame:GetFrameLevel())
    frameBorder:SetAllPoints(focusFrame)
    frameBorder:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    frameBorder:SetTexCoord(590 / 1024, 774 / 1024, 87 / 512, 150 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local focusHealthBar = FocusFrameHealthBar
    focusHealthBar:SetFrameLevel(focusFrame:GetFrameLevel())
    focusHealthBar:ClearAllPoints()
    focusHealthBar:SetPoint("TOPLEFT", 2, -22)
    focusHealthBar:SetPoint("BOTTOMRIGHT", -60, 28)

    local statusBarTexture = focusHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(812 / 1024, 936 / 1024, 178 / 512, 191 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Mana Bar
    local focusManaBar = FocusFrameManaBar
    focusManaBar:SetFrameLevel(focusFrame:GetFrameLevel())
    focusManaBar:ClearAllPoints()
    focusManaBar:SetPoint("TOPLEFT", 2, -34)
    focusManaBar:SetPoint("BOTTOMRIGHT", -58, 16)

    statusBarTexture = focusManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(323 / 1024, 449 / 1024, 221 / 512, 231 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Font Strings
    local focusNameText = FocusFrameTextureFrameName
    focusNameText:ClearAllPoints()
    focusNameText:SetPoint("TOP", -20, -8)
    focusNameText:SetDrawLayer("OVERLAY")

    local focusLevelText = FocusFrameTextureFrameLevelText
    focusLevelText:ClearAllPoints()
    focusLevelText:SetPoint("TOPLEFT", 8, -9)
    focusLevelText:SetDrawLayer("OVERLAY")

    local focusHealthText = FocusFrameTextureFrameHealthBarText
    focusHealthText:ClearAllPoints()
    focusHealthText:SetPoint("CENTER", -25, 2)
    focusHealthText:SetDrawLayer("OVERLAY")

    local focusDeadText = FocusFrameTextureFrameDeadText
    focusDeadText:ClearAllPoints()
    focusDeadText:SetPoint("CENTER", -25, 2)
    focusDeadText:SetDrawLayer("OVERLAY")

    local focusManaText = FocusFrameTextureFrameManaBarText
    focusManaText:ClearAllPoints()
    focusManaText:SetPoint("CENTER", -25, -10)
    focusManaText:SetDrawLayer("OVERLAY")

    FocusFrameNameBackground:Hide()
end

function Module:CreateUIFrames()
    self.playerFrameBar = CreateUIFrameBar(191, 65, "PlayerFrame")
    self.targetFrameBar = CreateUIFrameBar(191, 65, "TargetFrame")
    self.petFrameBar = CreateUIFrameBar(113, 42, "PetFrame")
    self.targetOfTargetFrameBar = CreateUIFrameBar(113, 42, "TOTFrame")
    self.focusFrameBar = CreateUIFrameBar(185, 59, "FocusFrame")
end

function Module:ReplaceBlizzardUnitFrames()
    self:ReplaceBlizzardPlayerFrame()
    self:ReplaceBlizzardTargetFrame()
    self:ReplaceBlizzardPetFrame()
    self:ReplaceBlizzardTOTFrame()
    self:ReplaceBlizzardFocusFrame()
end

function Module:LoadDefaultSettings()
    DFUI.DB.profile.widgets.playerFrame = { anchor = "TOPLEFT", posX = 105, posY = -15 }
    DFUI.DB.profile.widgets.petFrame = { anchor = "TOPLEFT", posX = 145, posY = -105 }
    DFUI.DB.profile.widgets.targetFrame = { anchor = "TOPLEFT", posX = 300, posY = -15 }
    DFUI.DB.profile.widgets.targetOfTargetFrame = { anchor = "TOPLEFT", posX = 370, posY = -85 }
    DFUI.DB.profile.widgets.focusFrame = { anchor = "TOPLEFT", posX = 105, posY = -140 }
end

function Module:UpdateWidgets()
    do
        local widgetOptions = DFUI.DB.profile.widgets.playerFrame
        self.playerFrameBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = DFUI.DB.profile.widgets.petFrame
        self.petFrameBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
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

    local playerFrame = PlayerFrame
    playerFrame:SetAlpha(0)
    playerFrame:EnableMouse(false)

    -- DK Runes
    for index = 1, 6 do
        local runeButton = _G['RuneButtonIndividual' .. index]
        runeButton:SetAlpha(0)
        runeButton:EnableMouse(false)
    end
end

function Module:DisableEditorPreviewForPlayerFrame()
    local playerFrameBar = self.playerFrameBar

    playerFrameBar:SetMovable(false)
    playerFrameBar:EnableMouse(false)

    playerFrameBar.editorTexture:Hide()
    playerFrameBar.editorText:Hide()

    local playerFrame = PlayerFrame
    playerFrame:SetAlpha(1)
    playerFrame:EnableMouse(true)

    -- DK Runes
    for index = 1, 6 do
        local runeButton = _G['RuneButtonIndividual' .. index]
        runeButton:SetAlpha(1)
        runeButton:EnableMouse(true)
    end

    local _, _, relativePoint, posX, posY = playerFrameBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.playerFrame.anchor = relativePoint
    DFUI.DB.profile.widgets.playerFrame.posX = posX
    DFUI.DB.profile.widgets.playerFrame.posY = posY
end

function Module:EnableEditorPreviewForTargetFrame()
    local targetFrameBar = self.targetFrameBar

    targetFrameBar:SetMovable(true)
    targetFrameBar:EnableMouse(true)

    targetFrameBar.editorTexture:Show()
    targetFrameBar.editorText:Show()

    local targetFrame = TargetFrame
    targetFrame:SetAlpha(0)
    targetFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForTargetFrame()
    local targetFrameBar = self.targetFrameBar

    targetFrameBar:SetMovable(false)
    targetFrameBar:EnableMouse(false)

    targetFrameBar.editorTexture:Hide()
    targetFrameBar.editorText:Hide()

    local targetFrame = TargetFrame
    targetFrame:SetAlpha(1)
    targetFrame:EnableMouse(true)

    local _, _, relativePoint, posX, posY = targetFrameBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.targetFrame.anchor = relativePoint
    DFUI.DB.profile.widgets.targetFrame.posX = posX
    DFUI.DB.profile.widgets.targetFrame.posY = posY
end

function Module:EnableEditorPreviewForTargetOfTargetFrame()
    local targetOfTargetFrameBar = self.targetOfTargetFrameBar

    targetOfTargetFrameBar:SetMovable(true)
    targetOfTargetFrameBar:EnableMouse(true)

    targetOfTargetFrameBar.editorTexture:Show()
    targetOfTargetFrameBar.editorText:Show()

    local targetFrameTOT = TargetFrameToT
    targetFrameTOT:SetAlpha(0)
    targetFrameTOT:EnableMouse(false)
end

function Module:DisableEditorPreviewForTargetOfTargetFrame()
    local targetOfTargetFrameBar = self.targetOfTargetFrameBar

    targetOfTargetFrameBar:SetMovable(false)
    targetOfTargetFrameBar:EnableMouse(false)

    targetOfTargetFrameBar.editorTexture:Hide()
    targetOfTargetFrameBar.editorText:Hide()

    local targetFrameTOT = TargetFrameToT
    targetFrameTOT:SetAlpha(1)
    targetFrameTOT:EnableMouse(true)

    local _, _, relativePoint, posX, posY = targetOfTargetFrameBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.targetOfTargetFrame.anchor = relativePoint
    DFUI.DB.profile.widgets.targetOfTargetFrame.posX = posX
    DFUI.DB.profile.widgets.targetOfTargetFrame.posY = posY
end

function Module:EnableEditorPreviewForFocusFrame()
    local focusFrameBar = self.focusFrameBar

    focusFrameBar:SetMovable(true)
    focusFrameBar:EnableMouse(true)

    focusFrameBar.editorTexture:Show()
    focusFrameBar.editorText:Show()

    local focusFrame = FocusFrame
    focusFrame:SetAlpha(0)
    focusFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForFocusFrame()
    local focusFrameBar = self.focusFrameBar

    focusFrameBar:SetMovable(false)
    focusFrameBar:EnableMouse(false)

    focusFrameBar.editorTexture:Hide()
    focusFrameBar.editorText:Hide()

    local focusFrame = FocusFrame
    focusFrame:SetAlpha(1)
    focusFrame:EnableMouse(true)

    local _, _, relativePoint, posX, posY = focusFrameBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.focusFrame.anchor = relativePoint
    DFUI.DB.profile.widgets.focusFrame.posX = posX
    DFUI.DB.profile.widgets.focusFrame.posY = posY
end

function Module:EnableEditorPreviewForPetFrame()
    local petFrameBar = self.petFrameBar

    petFrameBar:SetMovable(true)
    petFrameBar:EnableMouse(true)

    petFrameBar.editorTexture:Show()
    petFrameBar.editorText:Show()

    local petFrame = PetFrame
    petFrame:SetAlpha(0)
    petFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForPetFrame()
    local petFrameBar = self.petFrameBar

    petFrameBar:SetMovable(false)
    petFrameBar:EnableMouse(false)

    petFrameBar.editorTexture:Hide()
    petFrameBar.editorText:Hide()

    local petFrame = PetFrame
    petFrame:SetAlpha(1)
    petFrame:EnableMouse(true)

    local _, _, relativePoint, posX, posY = petFrameBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.petFrame.anchor = relativePoint
    DFUI.DB.profile.widgets.petFrame.posX = posX
    DFUI.DB.profile.widgets.petFrame.posY = posY
end
