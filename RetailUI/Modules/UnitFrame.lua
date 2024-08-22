local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'UnitFrame'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.playerFrame = nil
Module.targetFrame = nil
Module.targetOfTargetFrame = nil
Module.focusFrame = nil
Module.petFrame = nil

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
    frameBorder:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("RUNE_TYPE_UPDATE")

    self:SecureHook('TargetFrame_UpdateAuras', TargetFrame_UpdateAuras)
    self:SecureHook('PetFrame_Update', PetFrame_Update)
    PlayerFrame:HookScript('OnUpdate', PlayerFrame_OnUpdate)

    self:CreateUIFrames()
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("RUNE_TYPE_UPDATE")

    self:Unhook('TargetFrame_UpdateAuras', TargetFrame_UpdateAuras)
    self:Unhook('PetFrame_Update', PetFrame_Update)
    PlayerFrame:Unhook('OnUpdate', PlayerFrame_OnUpdate)
end

local function UpdateRune(button)
    local rune = button:GetID()
    local runeType = GetRuneType(rune)

    if runeType then
        local runeTexture = _G[button:GetName() .. "Rune"]
        if runeTexture then
            runeTexture:SetTexture(
                'Interface\\AddOns\\RetailUI\\Textures\\PlayerFrame\\ClassOverlayDeathKnightRunes.BLP')
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
    self:RemoveBlizzardFrames()
    self:ReplaceBlizzardFrames()

    if RUI.DB.profile.widgets.player == nil or RUI.DB.profile.widgets.target == nil or
        RUI.DB.profile.widgets.targetOfTarget == nil or RUI.DB.profile.widgets.focus == nil or
        RUI.DB.profile.widgets.pet == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

local blizzUnitFrames = {
    PlayerAttackBackground,
    PlayerAttackIcon,
    TargetFrameTextureFrameTexture,
    FocusFrameTextureFrameTexture,
    TargetFrameToTTextureFrameTexture,
    PlayerFrameRoleIcon,
    PlayerGuideIcon,
    PlayerFrameGroupIndicatorLeft,
    PlayerFrameGroupIndicatorRight
};

function Module:RemoveBlizzardFrames()
    for _, blizzFrame in pairs(blizzUnitFrames) do
        blizzFrame:SetAlpha(0)
    end
end

function Module:ReplaceBlizzardPlayerFrame()
    local playerFrame = PlayerFrame
    playerFrame:ClearAllPoints()
    playerFrame:SetPoint("LEFT", self.playerFrame, "LEFT", 0)

    playerFrame:SetSize(self.playerFrame:GetWidth(), self.playerFrame:GetHeight())

    -- Main
    local playerPortrait = PlayerPortrait
    playerPortrait:ClearAllPoints()
    playerPortrait:SetPoint("LEFT", 1, -1)
    playerPortrait:SetSize(58, 58)
    playerPortrait:SetDrawLayer("BACKGROUND")

    local frameBorder = _G[playerFrame:GetName() .. 'Texture']
    frameBorder:GetParent():SetFrameLevel(playerFrame:GetFrameLevel())
    frameBorder:SetAllPoints(playerFrame)
    frameBorder:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    frameBorder:SetTexCoord(812 / 1024, 1002 / 1024, 3 / 512, 67 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local playerHealthBar = PlayerFrameHealthBar
    playerHealthBar:SetFrameLevel(playerFrame:GetFrameLevel())
    playerHealthBar:ClearAllPoints()
    playerHealthBar:SetPoint("TOPLEFT", 65, -23)
    playerHealthBar:SetPoint("BOTTOMRIGHT", -3, 22)

    local statusBarTexture = playerHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(686 / 1024, 810 / 1024, 158 / 512, 179 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Mana Bar
    local playerManaBar = PlayerFrameManaBar
    playerManaBar:SetFrameLevel(playerFrame:GetFrameLevel())
    playerManaBar:ClearAllPoints()
    playerManaBar:SetPoint("TOPLEFT", 65, -47)
    playerManaBar:SetPoint("BOTTOMRIGHT", -3, 10)

    statusBarTexture = playerManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(698 / 1024, 822 / 1024, 236 / 512, 244 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Font Strings
    local playerNameText = PlayerName
    playerNameText:ClearAllPoints()
    playerNameText:SetPoint("TOP", -6, -9)
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
    playerManaText:SetPoint("CENTER", 30, -18)
    playerManaText:SetDrawLayer('OVERLAY')

    -- Rest Animation Icon
    local playerRestIcon = PlayerRestIcon
    playerRestIcon:ClearAllPoints()
    playerRestIcon:SetPoint("TOPLEFT", 40, 10)
    playerRestIcon:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\PlayerFrame\\PlayerRestFlipbook.blp")
    playerRestIcon:SetDrawLayer('ARTWORK')

    local playerStatusGlow = PlayerStatusGlow
    playerStatusGlow:ClearAllPoints()
    playerStatusGlow:SetFrameLevel(0)
    playerStatusGlow:SetPoint("CENTER", 0, -3)

    local playerStatusTexture = PlayerStatusTexture
    playerStatusTexture:SetAllPoints(playerFrame)
    playerStatusTexture:SetPoint("BOTTOM", 0, -1)
    playerStatusTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    playerStatusTexture:SetTexCoord(201 / 1024, 391 / 1024, 90 / 512, 156 / 512)
    playerStatusTexture:SetDrawLayer("ARTWORK")

    -- Reuse Blizzard Textures
    local arrowElement = PlayerFrameBackground
    arrowElement:ClearAllPoints()
    arrowElement:SetPoint("LEFT", 48, -22)
    arrowElement:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
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
    playerFrameFlash:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    playerFrameFlash:SetTexCoord(201 / 1024, 391 / 1024, 90 / 512, 156 / 512)
    playerFrameFlash:SetDrawLayer("ARTWORK")

    local playerHitText = PlayerHitIndicator
    playerHitText:ClearAllPoints()
    playerHitText:SetJustifyH("CENTER")
    playerHitText:SetPoint("TOPLEFT", 0, 0)
    playerHitText:SetPoint("BOTTOMRIGHT", -120, 0)

    local playerLeaderIcon = PlayerLeaderIcon
    playerLeaderIcon:ClearAllPoints()
    playerLeaderIcon:SetPoint("TOP", -20, 5)

    local playerMasterIcon = PlayerMasterIcon
    playerMasterIcon:ClearAllPoints()
    playerMasterIcon:SetPoint("TOP", 0, 7)

    local playerFrameGroup = PlayerFrameGroupIndicator
    playerFrameGroup:ClearAllPoints()
    playerFrameGroup:SetPoint("TOPRIGHT", -12, 7)
    playerFrameGroup:SetSize(60, 18)

    local background = _G['PlayerFrameGroupIndicator' .. 'Middle']
    background:SetAllPoints(playerFrameGroup)
    background:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    background:SetTexCoord(948 / 1024, 1022 / 1024, 158 / 512, 175 / 512)
    background:SetVertexColor(1, 1, 1, 1)

    local playerGroupText = _G['PlayerFrameGroupIndicator' .. 'Text']
    playerGroupText:ClearAllPoints()
    playerGroupText:SetPoint("TOPRIGHT", -10, -3)

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

local comboPoints = {
    { anchor = 'TOPRIGHT', x = 0,  y = 0 },
    { anchor = 'TOP',      x = 9,  y = 3 },
    { anchor = 'TOP',      x = 4,  y = 1 },
    { anchor = 'TOP',      x = -1, y = 0 },
    { anchor = 'TOP',      x = -7, y = 2 }
}

function Module:ReplaceBlizzardTargetFrame()
    local targetFrame = TargetFrame
    targetFrame:ClearAllPoints()
    targetFrame:SetPoint("LEFT", self.targetFrame, "LEFT", 0)

    targetFrame:SetSize(self.targetFrame:GetWidth(), self.targetFrame:GetHeight())

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
    frameBorder:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    frameBorder:SetTexCoord(782 / 1024, 970 / 1024, 88 / 512, 150 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local targetHealthBar = TargetFrameHealthBar
    targetHealthBar:SetFrameLevel(targetFrame:GetFrameLevel())
    targetHealthBar:ClearAllPoints()
    targetHealthBar:SetPoint("TOPLEFT", 4, -24)
    targetHealthBar:SetPoint("BOTTOMRIGHT", -62, 21)

    local statusBarTexture = targetHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(434 / 1024, 556 / 1024, 183 / 512, 202 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    local targetManaBar = TargetFrameManaBar
    targetManaBar:SetFrameLevel(targetFrame:GetFrameLevel())
    targetManaBar:ClearAllPoints()
    targetManaBar:SetPoint("TOPLEFT", 4, -43)
    targetManaBar:SetPoint("BOTTOMRIGHT", -54, 11)

    statusBarTexture = targetManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(468 / 1024, 598 / 1024, 207 / 512, 220 / 512)
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
    targetFrameFlash:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    targetFrameFlash:SetDrawLayer("ARTWORK")

    -- Raid Icon
    local raidTargetIcon = _G['TargetFrameTextureFrame' .. 'RaidTargetIcon']
    raidTargetIcon:ClearAllPoints()
    raidTargetIcon:SetPoint("TOPRIGHT", -20, 10)

    -- Combo Points
    local comboFrame = ComboFrame
    comboFrame:ClearAllPoints()
    comboFrame:SetPoint("CENTER", targetFrame, "CENTER", -31, 23)

    for index = 1, MAX_COMBO_POINTS do
        local comboPoint = _G['ComboPoint' .. index]
        if index > 1 then
            comboPoint:SetPoint(comboPoints[index].anchor, _G['ComboPoint' .. index - 1], "BOTTOM", comboPoints[index].x,
                comboPoints[index].y)
        else
            comboPoint:SetPoint(comboPoints[index].anchor, comboPoints[index].x, comboPoints[index].y)
        end
        comboPoint:SetSize(16, 16)

        for _, region in pairs { comboPoint:GetRegions() } do
            if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'BACKGROUND' then
                region:SetAllPoints(comboPoint)
                region:SetTexture(
                    "Interface\\AddOns\\RetailUI\\Textures\\PlayerFrame\\ClassOverlayComboPoints.BLP")
                region:SetTexCoord(76 / 128, 98 / 128, 19 / 64, 41 / 64)
            end
        end

        local shine = _G[comboPoint:GetName() .. 'Shine']
        shine:ClearAllPoints()
        shine:SetPoint("CENTER", comboPoint, "CENTER", 0, 0)

        local highlight = _G[comboPoint:GetName() .. 'Highlight']
        highlight:ClearAllPoints()
        highlight:SetPoint("CENTER", comboPoint, "CENTER", 0, 0)
        highlight:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\PlayerFrame\\ClassOverlayComboPoints.BLP")
        highlight:SetTexCoord(55 / 128, 75 / 128, 21 / 64, 41 / 64)
        highlight:SetSize(15, 15)
    end
end

function Module:ReplaceBlizzardPetFrame()
    local petFrame = PetFrame
    petFrame:ClearAllPoints()
    petFrame:SetPoint("LEFT", self.petFrame, "LEFT", 0)

    petFrame:SetSize(self.petFrame:GetWidth(), self.petFrame:GetHeight())

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
    petHealthBar:SetPoint("TOPLEFT", 42, -16)
    petHealthBar:SetPoint("BOTTOMRIGHT", -2, 17)

    local statusBarTexture = petHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(939 / 1024, 1009 / 1024, 179 / 512, 189 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Mana Bar
    local petManaBar = PetFrameManaBar
    petManaBar:SetFrameLevel(petFrame:GetFrameLevel())
    petManaBar:ClearAllPoints()
    petManaBar:SetPoint("TOPLEFT", 39, -28)
    petManaBar:SetPoint("BOTTOMRIGHT", -2, 8)

    statusBarTexture = petManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(475 / 1024, 547 / 1024, 246 / 512, 254 / 512)
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
    targetFrameToT:SetPoint("LEFT", self.targetOfTargetFrame, "LEFT", 0)

    targetFrameToT:SetSize(self.targetOfTargetFrame:GetWidth(), self.targetOfTargetFrame:GetHeight())

    -- Reuse Blizzard Frames
    local frameBorder = _G[targetFrameToT:GetName() .. 'Background']
    frameBorder:GetParent():SetFrameLevel(targetFrameToT:GetFrameLevel())
    frameBorder:SetAllPoints(targetFrameToT)
    frameBorder:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    frameBorder:SetTexCoord(3 / 1024, 117 / 1024, 421 / 512, 463 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local totHealthBar = TargetFrameToTHealthBar
    totHealthBar:SetFrameLevel(targetFrameToT:GetFrameLevel())
    totHealthBar:ClearAllPoints()
    totHealthBar:SetPoint("TOPLEFT", 42, -16)
    totHealthBar:SetPoint("BOTTOMRIGHT", 6, 17)

    local statusBarTexture = totHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(939 / 1024, 1009 / 1024, 179 / 512, 189 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Mana Bar
    local totManaBar = TargetFrameToTManaBar
    totManaBar:SetFrameLevel(targetFrameToT:GetFrameLevel())
    totManaBar:ClearAllPoints()
    totManaBar:SetPoint("TOPLEFT", 39, -28)
    totManaBar:SetPoint("BOTTOMRIGHT", -2, 8)

    statusBarTexture = totManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(475 / 1024, 547 / 1024, 246 / 512, 254 / 512)
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
    focusFrame:SetPoint("LEFT", self.focusFrame, "LEFT", 0)

    focusFrame:SetSize(self.focusFrame:GetWidth(), self.focusFrame:GetHeight())

    local focusPortrait = FocusFramePortrait
    focusPortrait:ClearAllPoints()
    focusPortrait:SetPoint("RIGHT", -3, 1)
    focusPortrait:SetSize(53, 53)
    focusPortrait:SetDrawLayer("BACKGROUND")

    -- Reuse Blizzard Frames
    local frameBorder = _G[focusFrame:GetName() .. 'Background']
    frameBorder:GetParent():SetFrameLevel(focusFrame:GetFrameLevel())
    frameBorder:SetAllPoints(focusFrame)
    frameBorder:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    frameBorder:SetTexCoord(590 / 1024, 774 / 1024, 87 / 512, 150 / 512)
    frameBorder:SetDrawLayer('BORDER')

    -- Health Bar
    local focusHealthBar = FocusFrameHealthBar
    focusHealthBar:SetFrameLevel(focusFrame:GetFrameLevel())
    focusHealthBar:ClearAllPoints()
    focusHealthBar:SetPoint("TOPLEFT", 2, -25)
    focusHealthBar:SetPoint("BOTTOMRIGHT", -60, 29)

    local statusBarTexture = focusHealthBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(813 / 1024, 935 / 1024, 194 / 512, 204 / 512)
    statusBarTexture:SetDrawLayer('ARTWORK')

    -- Mana Bar
    local focusManaBar = FocusFrameManaBar
    focusManaBar:SetFrameLevel(focusFrame:GetFrameLevel())
    focusManaBar:ClearAllPoints()
    focusManaBar:SetPoint("TOPLEFT", 3, -40)
    focusManaBar:SetPoint("BOTTOMRIGHT", -59, 18)

    statusBarTexture = focusManaBar:GetStatusBarTexture()
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(452 / 1024, 577 / 1024, 223 / 512, 231 / 512)
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
    focusManaText:SetPoint("CENTER", -25, -11)
    focusManaText:SetDrawLayer("OVERLAY")

    FocusFrameNameBackground:Hide()
end

function Module:CreateUIFrames()
    self.playerFrame = CreateUIFrame(191, 65, "PlayerFrame")
    self.targetFrame = CreateUIFrame(191, 65, "TargetFrame")
    self.petFrame = CreateUIFrame(113, 42, "PetFrame")
    self.targetOfTargetFrame = CreateUIFrame(113, 42, "TOTFrame")
    self.focusFrame = CreateUIFrame(185, 65, "FocusFrame")
end

function Module:ReplaceBlizzardFrames()
    self:ReplaceBlizzardPlayerFrame()
    self:ReplaceBlizzardTargetFrame()
    self:ReplaceBlizzardPetFrame()
    self:ReplaceBlizzardTOTFrame()
    self:ReplaceBlizzardFocusFrame()
end

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.player = { anchor = "TOPLEFT", posX = 25, posY = -15 }
    RUI.DB.profile.widgets.pet = { anchor = "TOPLEFT", posX = 145, posY = -105 }
    RUI.DB.profile.widgets.target = { anchor = "TOPLEFT", posX = 230, posY = -15 }
    RUI.DB.profile.widgets.targetOfTarget = { anchor = "TOPLEFT", posX = 370, posY = -85 }
    RUI.DB.profile.widgets.focus = { anchor = "TOPLEFT", posX = 105, posY = -160 }
end

function Module:UpdateWidgets()
    do
        local widgetOptions = RUI.DB.profile.widgets.player
        self.playerFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = RUI.DB.profile.widgets.pet
        self.petFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = RUI.DB.profile.widgets.target
        self.targetFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = RUI.DB.profile.widgets.targetOfTarget
        self.targetOfTargetFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = RUI.DB.profile.widgets.focus
        self.focusFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end
end

function Module:EnableEditorPreviewForPlayerFrame()
    local playerFrame = self.playerFrame

    playerFrame:SetMovable(true)
    playerFrame:EnableMouse(true)

    playerFrame.editorTexture:Show()
    playerFrame.editorText:Show()

    local hideFrame = PlayerFrame
    hideFrame:SetAlpha(0)
    hideFrame:EnableMouse(false)

    -- DK Runes
    for index = 1, 6 do
        local runeButton = _G['RuneButtonIndividual' .. index]
        runeButton:SetAlpha(0)
        runeButton:EnableMouse(false)
    end
end

function Module:DisableEditorPreviewForPlayerFrame()
    local playerFrame = self.playerFrame

    playerFrame:SetMovable(false)
    playerFrame:EnableMouse(false)

    playerFrame.editorTexture:Hide()
    playerFrame.editorText:Hide()

    local hideFrame = PlayerFrame
    hideFrame:SetAlpha(1)
    hideFrame:EnableMouse(true)

    -- DK Runes
    for index = 1, 6 do
        local runeButton = _G['RuneButtonIndividual' .. index]
        runeButton:SetAlpha(1)
        runeButton:EnableMouse(true)
    end

    local _, _, relativePoint, posX, posY = playerFrame:GetPoint('CENTER')
    RUI.DB.profile.widgets.player.anchor = relativePoint
    RUI.DB.profile.widgets.player.posX = posX
    RUI.DB.profile.widgets.player.posY = posY
end

function Module:EnableEditorPreviewForTargetFrame()
    local targetFrame = self.targetFrame

    targetFrame:SetMovable(true)
    targetFrame:EnableMouse(true)

    targetFrame.editorTexture:Show()
    targetFrame.editorText:Show()

    local hideFrame = TargetFrame
    hideFrame:SetAlpha(0)
    hideFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForTargetFrame()
    local targetFrame = self.targetFrame

    targetFrame:SetMovable(false)
    targetFrame:EnableMouse(false)

    targetFrame.editorTexture:Hide()
    targetFrame.editorText:Hide()

    local hideFrame = TargetFrame
    hideFrame:SetAlpha(1)
    hideFrame:EnableMouse(true)

    local _, _, relativePoint, posX, posY = targetFrame:GetPoint('CENTER')
    RUI.DB.profile.widgets.target.anchor = relativePoint
    RUI.DB.profile.widgets.target.posX = posX
    RUI.DB.profile.widgets.target.posY = posY
end

function Module:EnableEditorPreviewForTargetOfTargetFrame()
    local targetOfTargetFrame = self.targetOfTargetFrame

    targetOfTargetFrame:SetMovable(true)
    targetOfTargetFrame:EnableMouse(true)

    targetOfTargetFrame.editorTexture:Show()
    targetOfTargetFrame.editorText:Show()

    local hideFrame = TargetFrameToT
    hideFrame:SetAlpha(0)
    hideFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForTargetOfTargetFrame()
    local targetOfTargetFrame = self.targetOfTargetFrame

    targetOfTargetFrame:SetMovable(false)
    targetOfTargetFrame:EnableMouse(false)

    targetOfTargetFrame.editorTexture:Hide()
    targetOfTargetFrame.editorText:Hide()

    local targetFrameTOT = TargetFrameToT
    targetFrameTOT:SetAlpha(1)
    targetFrameTOT:EnableMouse(true)

    local _, _, relativePoint, posX, posY = targetOfTargetFrame:GetPoint('CENTER')
    RUI.DB.profile.widgets.targetOfTarget.anchor = relativePoint
    RUI.DB.profile.widgets.targetOfTarget.posX = posX
    RUI.DB.profile.widgets.targetOfTarget.posY = posY
end

function Module:EnableEditorPreviewForFocusFrame()
    local focusFrame = self.focusFrame

    focusFrame:SetMovable(true)
    focusFrame:EnableMouse(true)

    focusFrame.editorTexture:Show()
    focusFrame.editorText:Show()

    local hideFrame = FocusFrame
    hideFrame:SetAlpha(0)
    hideFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForFocusFrame()
    local focusFrame = self.focusFrame

    focusFrame:SetMovable(false)
    focusFrame:EnableMouse(false)

    focusFrame.editorTexture:Hide()
    focusFrame.editorText:Hide()

    local hideFrame = FocusFrame
    hideFrame:SetAlpha(1)
    hideFrame:EnableMouse(true)

    local _, _, relativePoint, posX, posY = focusFrame:GetPoint('CENTER')
    RUI.DB.profile.widgets.focus.anchor = relativePoint
    RUI.DB.profile.widgets.focus.posX = posX
    RUI.DB.profile.widgets.focus.posY = posY
end

function Module:EnableEditorPreviewForPetFrame()
    local petFrame = self.petFrame

    petFrame:SetMovable(true)
    petFrame:EnableMouse(true)

    petFrame.editorTexture:Show()
    petFrame.editorText:Show()

    local hideFrame = PetFrame
    hideFrame:SetAlpha(0)
    hideFrame:EnableMouse(false)
end

function Module:DisableEditorPreviewForPetFrame()
    local petFrame = self.petFrame

    petFrame:SetMovable(false)
    petFrame:EnableMouse(false)

    petFrame.editorTexture:Hide()
    petFrame.editorText:Hide()

    local hideFrame = PetFrame
    hideFrame:SetAlpha(1)
    hideFrame:EnableMouse(true)

    local _, _, relativePoint, posX, posY = petFrame:GetPoint('CENTER')
    RUI.DB.profile.widgets.pet.anchor = relativePoint
    RUI.DB.profile.widgets.pet.posX = posX
    RUI.DB.profile.widgets.pet.posY = posY
end
