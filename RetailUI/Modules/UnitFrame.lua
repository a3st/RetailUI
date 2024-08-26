local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'UnitFrame'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.playerFrame = nil
Module.targetFrame = nil
Module.targetOfTargetFrame = nil
Module.focusFrame = nil
Module.petFrame = nil

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

local function ReplaceBlizzardPlayerFrame(frame)
    local playerFrame = PlayerFrame
    playerFrame:ClearAllPoints()
    playerFrame:SetPoint("LEFT", frame, "LEFT", 0)

    playerFrame:SetSize(frame:GetWidth(), frame:GetHeight())
    playerFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local playerPortraitTexture = PlayerPortrait
    playerPortraitTexture:ClearAllPoints()
    playerPortraitTexture:SetPoint("LEFT", 3, -1)
    playerPortraitTexture:SetSize(58, 58)
    playerPortraitTexture:SetDrawLayer('BACKGROUND')

    local borderTexture = _G[playerFrame:GetName() .. 'Texture']
    borderTexture:SetAllPoints(playerFrame)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    borderTexture:SetTexCoord(812 / 1024, 1002 / 1024, 3 / 512, 68 / 512)
    borderTexture:SetDrawLayer('BORDER')

    -- Health Bar
    local playerHealthBar = _G[playerFrame:GetName() .. 'HealthBar']
    playerHealthBar:SetFrameLevel(playerFrame:GetFrameLevel() + 2)
    playerHealthBar:ClearAllPoints()
    playerHealthBar:SetPoint("TOPLEFT", 65, -25)
    playerHealthBar:SetSize(124, 18)

    local statusBarTexture = playerHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(playerHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(687 / 1024, 810 / 1024, 161 / 512, 179 / 512)

    -- Mana Bar
    local playerManaBar = _G[playerFrame:GetName() .. 'ManaBar']
    playerManaBar:SetFrameLevel(playerFrame:GetFrameLevel() + 2)
    playerManaBar:ClearAllPoints()
    playerManaBar:SetPoint("TOPLEFT", 65, -46)
    playerManaBar:SetSize(124, 9)

    statusBarTexture = playerManaBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(playerManaBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(699 / 1024, 822 / 1024, 236 / 512, 245 / 512)

    -- Font Strings
    local playerNameText = PlayerName
    playerNameText:ClearAllPoints()
    playerNameText:SetPoint("CENTER", 17, 17)
    playerNameText:SetDrawLayer('OVERLAY')
    playerNameText:SetJustifyH("LEFT")
    playerNameText:SetWidth(90)

    local playerLevelText = PlayerLevelText
    playerLevelText:ClearAllPoints()
    playerLevelText:SetPoint("CENTER", 80, 17)
    playerLevelText:SetDrawLayer('OVERLAY')

    local playerHealthText = _G[playerFrame:GetName() .. 'HealthBarText']
    playerHealthText:ClearAllPoints()
    playerHealthText:SetPoint("CENTER", 30, -1)
    playerHealthText:SetDrawLayer('OVERLAY')

    local playerManaText = _G[playerFrame:GetName() .. 'ManaBarText']
    playerManaText:ClearAllPoints()
    playerManaText:SetPoint("CENTER", 30, -17)
    playerManaText:SetDrawLayer('OVERLAY')

    -- Rest Animation Icon
    local playerRestIconTexture = PlayerRestIcon
    playerRestIconTexture:ClearAllPoints()
    playerRestIconTexture:SetPoint("TOPLEFT", 40, 10)
    playerRestIconTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\PlayerFrame\\PlayerRestFlipbook.blp")
    playerRestIconTexture:SetDrawLayer('ARTWORK')

    local playerStatusTexture = PlayerStatusTexture
    playerStatusTexture:SetAllPoints(playerFrame)
    playerStatusTexture:SetPoint("BOTTOM", 0, -1)
    playerStatusTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    playerStatusTexture:SetTexCoord(201 / 1024, 391 / 1024, 90 / 512, 156 / 512)
    playerStatusTexture:SetDrawLayer("OVERLAY")

    -- Arrow
    playerFrame.arrowIcon = playerFrame.arrowIcon or playerFrame:CreateTexture(nil, "BORDER")
    local arrowIconTexture = playerFrame.arrowIcon
    arrowIconTexture:ClearAllPoints()
    arrowIconTexture:SetPoint("LEFT", 48, -22)
    arrowIconTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    arrowIconTexture:SetTexCoord(986 / 1024, 997 / 1024, 144 / 512, 154 / 512)
    arrowIconTexture:SetSize(12, 12)
    arrowIconTexture:SetDrawLayer('BORDER')

    local playerPVPIconTexture = PlayerPVPIcon
    playerPVPIconTexture:ClearAllPoints()
    playerPVPIconTexture:SetPoint("LEFT", -16, -12)

    PlayerPVPTimerText:SetPoint("TOPLEFT", -10, 5)

    local playerFrameFlashTexture = PlayerFrameFlash
    playerFrameFlashTexture:SetAllPoints(playerFrame)
    playerFrameFlashTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    playerFrameFlashTexture:SetTexCoord(202 / 1024, 392 / 1024, 90 / 512, 154 / 512)
    playerFrameFlashTexture:SetDrawLayer("OVERLAY")

    local playerHitText = PlayerHitIndicator
    playerHitText:ClearAllPoints()
    playerHitText:SetJustifyH("CENTER")
    playerHitText:SetPoint("TOPLEFT", 0, 0)
    playerHitText:SetPoint("BOTTOMRIGHT", -120, 0)

    local playerLeaderIconTexture = PlayerLeaderIcon
    playerLeaderIconTexture:ClearAllPoints()
    playerLeaderIconTexture:SetPoint("TOP", -20, 5)

    local playerMasterIconTexture = PlayerMasterIcon
    playerMasterIconTexture:ClearAllPoints()
    playerMasterIconTexture:SetPoint("TOP", 0, 7)

    local playerFrameGroup = PlayerFrameGroupIndicator
    playerFrameGroup:ClearAllPoints()
    playerFrameGroup:SetPoint("TOPRIGHT", -12, 7)
    playerFrameGroup:SetSize(60, 18)

    local backgroundTexture = _G['PlayerFrameGroupIndicator' .. 'Middle']
    backgroundTexture:SetAllPoints(playerFrameGroup)
    backgroundTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    backgroundTexture:SetTexCoord(948 / 1024, 1022 / 1024, 158 / 512, 175 / 512)
    backgroundTexture:SetVertexColor(1, 1, 1, 1)

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

local function ReplaceBlizzardTargetFrame(frame)
    local targetFrame = TargetFrame
    targetFrame:ClearAllPoints()
    targetFrame:SetPoint("LEFT", frame, "LEFT", 0)

    targetFrame:SetSize(frame:GetWidth(), frame:GetHeight())
    targetFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local borderTexture = _G[targetFrame:GetName() .. 'TextureFrame' .. 'Texture']
    borderTexture:SetAllPoints(targetFrame)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    borderTexture:SetTexCoord(782 / 1024, 971 / 1024, 88 / 512, 150 / 512)
    borderTexture:SetDrawLayer('BORDER')

    local targetPortraitTexture = _G[targetFrame:GetName() .. 'Portrait']
    targetPortraitTexture:ClearAllPoints()
    targetPortraitTexture:SetPoint("RIGHT", -5, 1)
    targetPortraitTexture:SetSize(58, 58)
    targetPortraitTexture:SetDrawLayer('BACKGROUND')

    local backgroundTexture = _G[targetFrame:GetName() .. 'NameBackground']
    backgroundTexture:ClearAllPoints()
    backgroundTexture:SetPoint('TOPLEFT', 2, -8)
    backgroundTexture:SetPoint('BOTTOMRIGHT', -55, 42)
    backgroundTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\TargetFrame\\NameBackground.blp")
    backgroundTexture:SetTexCoord(5 / 256, 138 / 256, 9 / 32, 22 / 32)
    backgroundTexture:SetDrawLayer("BACKGROUND")
    backgroundTexture:SetBlendMode('BLEND')

    -- Health Bar
    local targetHealthBar = _G[targetFrame:GetName() .. 'HealthBar']
    targetHealthBar:SetFrameLevel(targetFrame:GetFrameLevel() + 1)
    targetHealthBar:ClearAllPoints()
    targetHealthBar:SetPoint("TOPLEFT", 4, -24)
    targetHealthBar:SetSize(124, 20)

    local statusBarTexture = targetHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(targetHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(434 / 1024, 557 / 1024, 183 / 512, 202 / 512)

    -- Mana Bar
    local targetManaBar = _G[targetFrame:GetName() .. 'ManaBar']
    targetManaBar:SetFrameLevel(targetFrame:GetFrameLevel() + 1)
    targetManaBar:ClearAllPoints()
    targetManaBar:SetPoint("TOPLEFT", 4, -43)
    targetManaBar:SetSize(130, 12)

    statusBarTexture = targetManaBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(targetManaBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(466 / 1024, 598 / 1024, 207 / 512, 220 / 512)

    -- Font Strings
    local targetNameText = _G[targetFrame:GetName() .. 'TextureFrame' .. 'Name']
    targetNameText:ClearAllPoints()
    targetNameText:SetPoint("CENTER", -14, 18)
    targetNameText:SetDrawLayer("OVERLAY")
    targetNameText:SetJustifyH("LEFT")
    targetNameText:SetWidth(80)

    local targetLevelText = _G[targetFrame:GetName() .. 'TextureFrame' .. 'LevelText']
    targetLevelText:ClearAllPoints()
    targetLevelText:SetPoint("CENTER", -80, 18)
    targetLevelText:SetJustifyH("LEFT")
    targetLevelText:SetDrawLayer("OVERLAY")

    local targetHealthText = _G[targetFrame:GetName() .. 'TextureFrame' .. 'HealthBarText']
    targetHealthText:ClearAllPoints()
    targetHealthText:SetPoint("CENTER", -25, -1)
    targetHealthText:SetDrawLayer("OVERLAY")

    local targetDeathText = _G[targetFrame:GetName() .. 'TextureFrame' .. 'DeadText']
    targetDeathText:ClearAllPoints()
    targetDeathText:SetPoint("CENTER", -25, -1)
    targetDeathText:SetDrawLayer("OVERLAY")

    local targetManaText = _G[targetFrame:GetName() .. 'TextureFrame' .. 'ManaBarText']
    targetManaText:ClearAllPoints()
    targetManaText:SetPoint("CENTER", -25, -18)
    targetManaText:SetDrawLayer("OVERLAY")

    local targetPVPIconTexture = _G[targetFrame:GetName() .. 'TextureFrame' .. 'PVPIcon']
    targetPVPIconTexture:ClearAllPoints()
    targetPVPIconTexture:SetPoint("RIGHT", 40, -12)

    local targetLeaderIconTexture = _G[targetFrame:GetName() .. 'TextureFrame' .. 'LeaderIcon']
    targetLeaderIconTexture:ClearAllPoints()
    targetLeaderIconTexture:SetPoint("TOPRIGHT", 0, 0)

    local targetFrameFlashTexture = _G[targetFrame:GetName() .. 'Flash']
    targetFrameFlashTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    targetFrameFlashTexture:SetDrawLayer("OVERLAY")

    targetFrame.elite = targetFrame.elite or
        _G[targetFrame:GetName() .. 'TextureFrame']:CreateTexture(nil, 'OVERLAY')
    local eliteTexture = targetFrame.elite
    eliteTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\TargetFrame\\BossFrame.blp")

    -- Raid Icon
    local raidTargetIconTexture = _G['TargetFrame' .. 'TextureFrame' .. 'RaidTargetIcon']
    raidTargetIconTexture:ClearAllPoints()
    raidTargetIconTexture:SetPoint("TOPRIGHT", -20, 10)

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

        local shineTexture = _G[comboPoint:GetName() .. 'Shine']
        shineTexture:ClearAllPoints()
        shineTexture:SetPoint("CENTER", comboPoint, "CENTER", 0, 0)

        local highlightTexture = _G[comboPoint:GetName() .. 'Highlight']
        highlightTexture:ClearAllPoints()
        highlightTexture:SetPoint("CENTER", comboPoint, "CENTER", 0, 0)
        highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\PlayerFrame\\ClassOverlayComboPoints.BLP")
        highlightTexture:SetTexCoord(55 / 128, 75 / 128, 21 / 64, 41 / 64)
        highlightTexture:SetSize(15, 15)
    end

    targetFrame.ShowTest = function(self)
        local targetPortraitTexture = _G[self:GetName() .. 'Portrait']
        SetPortraitTexture(targetPortraitTexture, "player")

        local backgroundTexture = _G[self:GetName() .. 'NameBackground']
        backgroundTexture:SetVertexColor(UnitSelectionColor('player'))

        local targetDeathText = _G[self:GetName() .. 'TextureFrame' .. 'DeadText']
        targetDeathText:Hide()

        local highLevelTexture = _G[self:GetName() .. 'TextureFrame' .. 'HighLevelTexture']
        highLevelTexture:Hide()

        local targetNameText = _G[self:GetName() .. 'TextureFrame' .. 'Name']
        targetNameText:SetText(UnitName("player"))

        local targetLevelText = _G[self:GetName() .. 'TextureFrame' .. 'LevelText']
        targetLevelText:SetText(UnitLevel("player"))
        targetLevelText:Show()

        local targetHealthText = _G[self:GetName() .. 'TextureFrame' .. 'HealthBarText']
        local curHealth = UnitHealth("player")
        targetHealthText:SetText(curHealth .. "/" .. curHealth)

        local targetManaText = _G[self:GetName() .. 'TextureFrame' .. 'ManaBarText']
        local curMana = UnitPower("player", Mana)
        targetManaText:SetText(curMana .. "/" .. curMana)

        local targetHealthBar = _G[self:GetName() .. 'HealthBar']
        targetHealthBar:SetMinMaxValues(0, curHealth)
        targetHealthBar:SetStatusBarColor(0.29, 0.69, 0.07)
        targetHealthBar:SetValue(curHealth)
        targetHealthBar:Show()

        local targetManaBar = _G[self:GetName() .. 'ManaBar']
        targetManaBar:SetMinMaxValues(0, curMana)
        targetManaBar:SetValue(curMana)
        targetManaBar:SetStatusBarColor(0.02, 0.32, 0.71)
        targetManaBar:Show()

        self:Show()
    end

    targetFrame.HideTest = function(self)
        self:Hide()
    end
end

local function ReplaceBlizzardPetFrame(frame)
    local petFrame = PetFrame
    petFrame:ClearAllPoints()
    petFrame:SetPoint("LEFT", frame, "LEFT", 0)

    petFrame:SetSize(frame:GetWidth(), frame:GetHeight())
    petFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local petPortraitTexture = PetPortrait
    petPortraitTexture:ClearAllPoints()
    petPortraitTexture:SetPoint("LEFT", 4, 0)
    petPortraitTexture:SetSize(34, 34)
    petPortraitTexture:SetDrawLayer('BACKGROUND')

    local borderTexture = _G[petFrame:GetName() .. 'Texture']
    borderTexture:SetAllPoints(petFrame)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    borderTexture:SetTexCoord(3 / 1024, 117 / 1024, 421 / 512, 463 / 512)
    borderTexture:SetDrawLayer('BORDER')

    -- Health Bar
    local petHealthBar = _G[petFrame:GetName() .. 'HealthBar']
    petHealthBar:SetFrameLevel(petFrame:GetFrameLevel() + 2)
    petHealthBar:ClearAllPoints()
    petHealthBar:SetPoint("TOPLEFT", 42, -17)
    petHealthBar:SetSize(68, 8)

    local statusBarTexture = petHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(petHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(942 / 1024, 1009 / 1024, 181 / 512, 189 / 512)

    -- Mana Bar
    local petManaBar = _G[petFrame:GetName() .. 'ManaBar']
    petManaBar:SetFrameLevel(petFrame:GetFrameLevel() + 2)
    petManaBar:ClearAllPoints()
    petManaBar:SetPoint("TOPLEFT", 39, -28)
    petManaBar:SetSize(71, 5)

    statusBarTexture = petManaBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(petManaBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(473 / 1024, 546 / 1024, 247 / 512, 255 / 512)

    -- Font Strings
    local petNameText = PetName
    petNameText:ClearAllPoints()
    petNameText:SetPoint("CENTER", 16, 13)
    petNameText:SetJustifyH("LEFT")
    petNameText:SetDrawLayer("OVERLAY")
    petNameText:SetWidth(65)

    local petHealthText = _G[petFrame:GetName() .. 'HealthBarText']
    petHealthText:ClearAllPoints()
    petHealthText:SetPoint("CENTER", 20, 1)
    petHealthText:SetDrawLayer("OVERLAY")

    local petManaText = _G[petFrame:GetName() .. 'ManaBarText']
    petManaText:ClearAllPoints()
    petManaText:SetPoint("CENTER", 19, -9)
    petManaText:SetDrawLayer("OVERLAY")

    local petHappinessTexture = _G[petFrame:GetName() .. 'Happiness']
    petHappinessTexture:ClearAllPoints()
    petHappinessTexture:SetPoint("LEFT", petFrame, "RIGHT", 5, -5)
end

local function ReplaceBlizzardTOTFrame(frame)
    local targetFrameToT = TargetFrameToT
    targetFrameToT:ClearAllPoints()
    targetFrameToT:SetPoint("LEFT", frame, "LEFT", 0)

    targetFrameToT:SetSize(frame:GetWidth(), frame:GetHeight())
    targetFrameToT:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local totPortraitTexture = _G[targetFrameToT:GetName() .. 'Portrait']
    totPortraitTexture:ClearAllPoints()
    totPortraitTexture:SetPoint("LEFT", 4, 0)
    totPortraitTexture:SetSize(34, 34)
    totPortraitTexture:SetDrawLayer("BACKGROUND")

    local borderTexture = _G[targetFrameToT:GetName() .. 'TextureFrame' .. 'Texture']
    borderTexture:SetAllPoints(targetFrameToT)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    borderTexture:SetTexCoord(3 / 1024, 117 / 1024, 421 / 512, 463 / 512)
    borderTexture:SetDrawLayer('BORDER')

    -- Health Bar
    local totHealthBar = _G[targetFrameToT:GetName() .. 'HealthBar']
    totHealthBar:SetFrameLevel(targetFrameToT:GetFrameLevel() + 2)
    totHealthBar:ClearAllPoints()
    totHealthBar:SetPoint("TOPLEFT", 42, -17)
    totHealthBar:SetSize(69, 8)

    local statusBarTexture = totHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(totHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(942 / 1024, 1010 / 1024, 181 / 512, 189 / 512)

    -- Mana Bar
    local totManaBar = _G[targetFrameToT:GetName() .. 'ManaBar']
    totManaBar:SetFrameLevel(targetFrameToT:GetFrameLevel() + 2)
    totManaBar:ClearAllPoints()
    totManaBar:SetPoint("TOPLEFT", 39, -28)
    totManaBar:SetSize(71, 5)

    statusBarTexture = totManaBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(totManaBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(473 / 1024, 546 / 1024, 247 / 512, 255 / 512)

    -- Font Strings
    local totNameText = _G[targetFrameToT:GetName() .. 'TextureFrame' .. 'Name']
    totNameText:ClearAllPoints()
    totNameText:SetPoint("CENTER", 16, 13)
    totNameText:SetDrawLayer("OVERLAY")
    totNameText:SetWidth(65)
end

local function ReplaceBlizzardFocusFrame(frame)
    local focusFrame = FocusFrame
    focusFrame:ClearAllPoints()
    focusFrame:SetPoint("LEFT", frame, "LEFT", 0)

    focusFrame:SetSize(frame:GetWidth(), frame:GetHeight())
    focusFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local borderTexture = _G[focusFrame:GetName() .. 'TextureFrame' .. 'Texture']
    borderTexture:SetAllPoints(focusFrame)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    borderTexture:SetTexCoord(782 / 1024, 970 / 1024, 88 / 512, 150 / 512)
    borderTexture:SetDrawLayer('BORDER')

    local focusPortraitTexture = _G[focusFrame:GetName() .. 'Portrait']
    focusPortraitTexture:ClearAllPoints()
    focusPortraitTexture:SetPoint("RIGHT", -5, 1)
    focusPortraitTexture:SetSize(58, 58)
    focusPortraitTexture:SetDrawLayer("BACKGROUND")

    local backgroundTexture = _G[focusFrame:GetName() .. 'NameBackground']
    backgroundTexture:ClearAllPoints()
    backgroundTexture:SetPoint('TOPLEFT', 2, -8)
    backgroundTexture:SetPoint('BOTTOMRIGHT', -55, 42)
    backgroundTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\TargetFrame\\NameBackground.blp")
    backgroundTexture:SetTexCoord(5 / 256, 138 / 256, 9 / 32, 22 / 32)
    backgroundTexture:SetDrawLayer("BACKGROUND")
    backgroundTexture:SetBlendMode('BLEND')

    -- Health Bar
    local focusHealthBar = _G[focusFrame:GetName() .. 'HealthBar']
    focusHealthBar:SetFrameLevel(focusFrame:GetFrameLevel() + 1)
    focusHealthBar:ClearAllPoints()
    focusHealthBar:SetPoint("TOPLEFT", 4, -24)
    focusHealthBar:SetSize(124, 20)

    local statusBarTexture = focusHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(focusHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(434 / 1024, 557 / 1024, 183 / 512, 202 / 512)

    -- Mana Bar
    local focusManaBar = _G[focusFrame:GetName() .. 'ManaBar']
    focusManaBar:SetFrameLevel(focusFrame:GetFrameLevel() + 1)
    focusManaBar:ClearAllPoints()
    focusManaBar:SetPoint("TOPLEFT", 4, -43)
    focusManaBar:SetSize(131, 12)

    statusBarTexture = focusManaBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(focusManaBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(466 / 1024, 598 / 1024, 207 / 512, 220 / 512)

    -- Font Strings
    local focusNameText = _G[focusFrame:GetName() .. 'TextureFrame' .. 'Name']
    focusNameText:ClearAllPoints()
    focusNameText:SetPoint("CENTER", -10, 18)
    focusNameText:SetDrawLayer("OVERLAY")
    focusNameText:SetJustifyH("LEFT")
    focusNameText:SetWidth(80)
    focusNameText:SetFont(TargetFrameTextureFrameName:GetFont())

    local focusLevelText = _G[focusFrame:GetName() .. 'TextureFrame' .. 'LevelText']
    focusLevelText:ClearAllPoints()
    focusLevelText:SetPoint("CENTER", -80, 18)
    focusLevelText:SetDrawLayer("OVERLAY")
    focusLevelText:SetFont(TargetFrameTextureFrameLevelText:GetFont())

    local focusHealthText = _G[focusFrame:GetName() .. 'TextureFrame' .. 'HealthBarText']
    focusHealthText:ClearAllPoints()
    focusHealthText:SetPoint("CENTER", -25, -1)
    focusHealthText:SetDrawLayer("OVERLAY")
    focusHealthText:SetFont(TargetFrameTextureFrameHealthBarText:GetFont())

    local focusDeadText = _G[focusFrame:GetName() .. 'TextureFrame' .. 'DeadText']
    focusDeadText:ClearAllPoints()
    focusDeadText:SetPoint("CENTER", -25, -1)
    focusDeadText:SetDrawLayer("OVERLAY")
    focusDeadText:SetFont(TargetFrameTextureFrameDeadText:GetFont())

    local focusManaText = _G[focusFrame:GetName() .. 'TextureFrame' .. 'ManaBarText']
    focusManaText:ClearAllPoints()
    focusManaText:SetPoint("CENTER", -25, -18)
    focusManaText:SetDrawLayer("OVERLAY")
    focusManaText:SetFont(TargetFrameTextureFrameManaBarText:GetFont())

    local focusPVPIconTexture = _G[focusFrame:GetName() .. 'TextureFrame' .. 'PVPIcon']
    focusPVPIconTexture:ClearAllPoints()
    focusPVPIconTexture:SetPoint("RIGHT", 40, -12)

    local focusLeaderIconTexture = _G[focusFrame:GetName() .. 'TextureFrame' .. 'LeaderIcon']
    focusLeaderIconTexture:ClearAllPoints()
    focusLeaderIconTexture:SetPoint("TOPRIGHT", 0, 0)

    focusFrame.elite = focusFrame.elite or
        _G[focusFrame:GetName() .. 'TextureFrame']:CreateTexture(nil, 'OVERLAY')
    local eliteTexture = focusFrame.elite
    eliteTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\TargetFrame\\BossFrame.blp")

    -- Safe Test Mode
    focusFrame.testMode = false

    focusFrame.ShowTest = function(self)
        self.testMode = true

        local focusPortraitTexture = _G[self:GetName() .. 'Portrait']
        SetPortraitTexture(focusPortraitTexture, "player")

        local backgroundTexture = _G[self:GetName() .. 'NameBackground']
        backgroundTexture:SetVertexColor(UnitSelectionColor('player'))

        local focusDeathText = _G[self:GetName() .. 'TextureFrame' .. 'DeadText']
        focusDeathText:Hide()

        local highLevelTexture = _G[self:GetName() .. 'TextureFrame' .. 'HighLevelTexture']
        highLevelTexture:Hide()

        local focusNameText = _G[self:GetName() .. 'TextureFrame' .. 'Name']
        focusNameText:SetText(UnitName("player"))

        local focusLevelText = _G[self:GetName() .. 'TextureFrame' .. 'LevelText']
        focusLevelText:SetText(UnitLevel("player"))
        focusLevelText:Show()

        local focusHealthText = _G[self:GetName() .. 'TextureFrame' .. 'HealthBarText']
        local curHealth = UnitHealth("player")
        focusHealthText:SetText(curHealth .. "/" .. curHealth)

        local focusManaText = _G[self:GetName() .. 'TextureFrame' .. 'ManaBarText']
        local curMana = UnitPower("player", Mana)
        focusManaText:SetText(curMana .. "/" .. curMana)

        local focusHealthBar = _G[self:GetName() .. 'HealthBar']
        focusHealthBar:SetMinMaxValues(0, curHealth)
        focusHealthBar:SetStatusBarColor(0.29, 0.69, 0.07)
        focusHealthBar:SetValue(curHealth)
        focusHealthBar:Show()

        local focusManaBar = _G[self:GetName() .. 'ManaBar']
        focusManaBar:SetMinMaxValues(0, curMana)
        focusManaBar:SetValue(curMana)
        focusManaBar:SetStatusBarColor(0.02, 0.32, 0.71)
        focusManaBar:Show()

        self:Show()
    end

    focusFrame.HideTest = function(self)
        self.testMode = false

        self:Hide()
    end
end

local blizzFrames = {
    PlayerFrameBackground,
    PlayerAttackBackground,
    PlayerAttackIcon,
    TargetFrameBackground,
    TargetFrameToTBackground,
    FocusFrameBackground,
    PlayerFrameRoleIcon,
    PlayerGuideIcon,
    PlayerFrameGroupIndicatorLeft,
    PlayerFrameGroupIndicatorRight
};

local function RemoveBlizzardFrames()
    for _, blizzFrame in pairs(blizzFrames) do
        blizzFrame:SetAlpha(0)
    end
end

local function PlayerFrame_OnUpdate(self, elapsed)
    local playerRestIcon = PlayerRestIcon
    AnimateTexCoords(playerRestIcon, 512, 512, 64, 64, 42, elapsed, 1)
end

local function PlayerFrame_UpdateStatus()
    PlayerStatusGlow:Hide()
end

local AURA_OFFSET_Y = 3
local AURA_START_X = 3
local AURA_START_Y = 3

local function TargetFrame_UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY)
    local buff = _G[buffName .. index]
    if index == 1 then
        if UnitIsFriend("player", self.unit) or numDebuffs == 0 then
            -- unit is friendly or there are no debuffs...buffs start on top
            buff:SetPoint("TOPLEFT", self, "BOTTOMLEFT", AURA_START_X, AURA_START_Y)
        else
            -- unit is not friendly and we have debuffs...buffs start on bottom
            buff:SetPoint("TOPLEFT", self.debuffs, "BOTTOMLEFT", 0, -offsetY)
        end
        self.buffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
        self.buffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, -AURA_OFFSET_Y)
        self.spellbarAnchor = buff
    elseif anchorIndex ~= index - 1 then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint("TOPLEFT", _G[buffName .. anchorIndex], "BOTTOMLEFT", 0, -offsetY)
        self.buffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, -AURA_OFFSET_Y)
        self.spellbarAnchor = buff
    else
        -- anchor index is the previous index
        buff:SetPoint("TOPLEFT", _G[buffName .. anchorIndex], "TOPRIGHT", offsetX, 0)
    end

    -- Resize
    buff:SetWidth(size)
    buff:SetHeight(size)
end

local function TargetFrame_UpdateDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY)
    local buff = _G[debuffName .. index]
    local isFriend = UnitIsFriend("player", self.unit)
    if index == 1 then
        if isFriend and numBuffs > 0 then
            -- unit is friendly and there are buffs...debuffs start on bottom
            buff:SetPoint("TOPLEFT", self.buffs, "BOTTOMLEFT", 0, -offsetY)
        else
            -- unit is not friendly or there are no buffs...debuffs start on top
            buff:SetPoint("TOPLEFT", self, "BOTTOMLEFT", AURA_START_X, AURA_START_Y)
        end
        self.debuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0)
        self.debuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, -AURA_OFFSET_Y)
        if isFriend or (not isFriend and numBuffs == 0) then
            self.spellbarAnchor = buff
        end
    elseif anchorIndex ~= index - 1 then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint("TOPLEFT", _G[debuffName .. anchorIndex], "BOTTOMLEFT", 0, -offsetY)
        self.debuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, -AURA_OFFSET_Y)
        if isFriend or (not isFriend and numBuffs == 0) then
            self.spellbarAnchor = buff
        end
    else
        -- anchor index is the previous index
        buff:SetPoint("TOPLEFT", _G[debuffName .. (index - 1)], "TOPRIGHT", offsetX, 0)
    end

    -- Resize
    buff:SetWidth(size)
    buff:SetHeight(size)
    local debuffFrame = _G[debuffName .. index .. "Border"]
    debuffFrame:SetWidth(size + 2)
    debuffFrame:SetHeight(size + 2)
end

local function TargetFrame_CheckClassification(self, forceNormalTexture)
    local classification = UnitClassification(self.unit)
    if classification == "worldboss" or classification == "elite" then
        self.elite:SetTexCoord(0 / 512, 160 / 512, 161 / 512, 322 / 512)
        self.elite:SetPoint("RIGHT", 9, 0)
        self.elite:SetSize(79, 82)
        self.elite:Show()
    elseif classification == "rareelite" then
        self.elite:SetTexCoord(0 / 512, 196 / 512, 0 / 512, 160 / 512)
        self.elite:SetPoint("RIGHT", 27, 0)
        self.elite:SetSize(98, 80)
        self.elite:Show()
    elseif classification == "rare" then
        self.elite:SetTexCoord(0 / 512, 160 / 512, 322 / 512, 485 / 512)
        self.elite:SetPoint("RIGHT", 9, 0)
        self.elite:SetSize(79, 82)
        self.elite:Show()
    else
        self.elite:Hide()
    end

    self.borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    self.threatIndicator:SetAllPoints(self)
    self.threatIndicator:SetTexCoord(1 / 1024, 187 / 1024, 301 / 512, 361 / 512)
end

local function FocusFrame_SetSmallSize(smallSize, onChange)
    ReplaceBlizzardFocusFrame(Module.focusFrame)
end

local function UnitFrameHealthBar_Update(statusBar, unit)
    statusBar.disconnected = not UnitIsConnected(unit)

    if statusBar.disconnected then
        if not statusBar.lockColor then
            statusBar:SetStatusBarColor(0.5, 0.5, 0.5)
        end
    else
        if not statusBar.lockColor then
            statusBar:SetStatusBarColor(0.29, 0.69, 0.07)
        end
    end
end

local powerBarColor = {
    ["MANA"] = { r = 0.02, g = 0.32, b = 0.71 },
    ["RAGE"] = { r = 1.00, g = 0.00, b = 0.00 },
    ["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25 },
    ["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00 },
    ["HAPPINESS"] = { r = 0.00, g = 1.00, b = 1.00 },
    ["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 },
    ["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00 },
    ["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 },
    ["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 }
}

powerBarColor[0] = PowerBarColor["MANA"]
powerBarColor[1] = PowerBarColor["RAGE"]
powerBarColor[2] = PowerBarColor["FOCUS"]
powerBarColor[3] = PowerBarColor["ENERGY"]
powerBarColor[4] = PowerBarColor["HAPPINESS"]
powerBarColor[5] = PowerBarColor["RUNES"]
powerBarColor[6] = PowerBarColor["RUNIC_POWER"]

local function UnitFrameManaBar_UpdateType(manaBar)
    local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit)
    local info = powerBarColor[powerToken]

    if info then
        if not manaBar.lockColor then
            manaBar:SetStatusBarColor(info.r, info.g, info.b);
        end
    else
        if not altR then
            info = powerBarColor[powerType] or powerBarColor["MANA"];
        else
            if not manaBar.lockColor then
                manaBar:SetStatusBarColor(altR, altG, altB);
            end
        end
    end
end

local function HealthBar_OnValueChanged(self, value)
    self:SetStatusBarColor(0.29, 0.69, 0.07)
end

local function PetFrame_Update(self)
    PetFrameTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("RUNE_TYPE_UPDATE")

    PlayerFrame:HookScript('OnUpdate', PlayerFrame_OnUpdate)
    PlayerFrameHealthBar:HookScript('OnValueChanged', HealthBar_OnValueChanged)
    self:SecureHook('PlayerFrame_UpdateStatus', PlayerFrame_UpdateStatus)
    TargetFrameHealthBar:HookScript('OnValueChanged', HealthBar_OnValueChanged)
    FocusFrameHealthBar:HookScript('OnValueChanged', HealthBar_OnValueChanged)
    self:SecureHook('TargetFrame_UpdateBuffAnchor', TargetFrame_UpdateBuffAnchor)
    self:SecureHook('TargetFrame_UpdateDebuffAnchor', TargetFrame_UpdateDebuffAnchor)
    self:SecureHook('TargetFrame_CheckClassification', TargetFrame_CheckClassification)
    self:SecureHook('FocusFrame_SetSmallSize', FocusFrame_SetSmallSize)
    self:SecureHook('UnitFrameHealthBar_Update', UnitFrameHealthBar_Update)
    self:SecureHook('UnitFrameManaBar_UpdateType', UnitFrameManaBar_UpdateType)
    self:SecureHook('PetFrame_Update', PetFrame_Update)

    self.playerFrame = CreateUIFrame(191, 65, "PlayerFrame")
    self.targetFrame = CreateUIFrame(191, 65, "TargetFrame")
    self.petFrame = CreateUIFrame(113, 42, "PetFrame")
    self.targetOfTargetFrame = CreateUIFrame(113, 42, "TOTFrame")
    self.focusFrame = CreateUIFrame(191, 65, "FocusFrame")
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("RUNE_TYPE_UPDATE")

    PlayerFrame:Unhook('OnUpdate', PlayerFrame_OnUpdate)
    PlayerFrameHealthBar:Unhook('OnValueChanged', HealthBar_OnValueChanged)
    self:Unhook('PlayerFrame_UpdateStatus', PlayerFrame_UpdateStatus)
    TargetFrameHealthBar:Unhook('OnValueChanged', HealthBar_OnValueChanged)
    FocusFrameHealthBar:Unhook('OnValueChanged', HealthBar_OnValueChanged)
    self:Unhook('TargetFrame_UpdateBuffAnchor', TargetFrame_UpdateBuffAnchor)
    self:Unhook('TargetFrame_UpdateDebuffAnchor', TargetFrame_UpdateDebuffAnchor)
    self:Unhook('TargetFrame_CheckClassification', TargetFrame_CheckClassification)
    self:Unhook('FocusFrame_SetSmallSize', FocusFrame_SetSmallSize)
    self:Unhook('UnitFrameHealthBar_Update', UnitFrameHealthBar_Update)
    self:Unhook('UnitFrameManaBar_UpdateType', UnitFrameManaBar_UpdateType)
    self:Unhook('PetFrame_Update', PetFrame_Update)
end

function Module:RUNE_TYPE_UPDATE(eventName, rune)
    UpdateRune(_G['RuneButtonIndividual' .. rune])
end

function Module:PLAYER_ENTERING_WORLD()
    RemoveBlizzardFrames()

    ReplaceBlizzardPlayerFrame(self.playerFrame)
    ReplaceBlizzardTargetFrame(self.targetFrame)
    ReplaceBlizzardPetFrame(self.petFrame)
    ReplaceBlizzardTOTFrame(self.targetOfTargetFrame)
    ReplaceBlizzardFocusFrame(self.focusFrame)

    local widgets = {
        'player',
        'target',
        'pet',
        'targetOfTarget',
        'focus'
    }

    for _, widget in pairs(widgets) do
        if RUI.DB.profile.widgets[widget] == nil then
            self:LoadDefaultSettings()
            break
        end
    end

    self:UpdateWidgets()
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

function Module:EnableEditorPreview()
    HideUIFrame(self.playerFrame)

    HideUIFrame(self.targetFrame)
    TargetFrame:ShowTest()

    HideUIFrame(self.petFrame)

    HideUIFrame(self.targetOfTargetFrame)

    HideUIFrame(self.focusFrame)
    FocusFrame:ShowTest()
end

function Module:DisableEditorPreview()
    ShowUIFrame(self.playerFrame)
    SaveUIFramePosition(self.playerFrame, 'player')

    ShowUIFrame(self.targetFrame)
    SaveUIFramePosition(self.targetFrame, 'target')
    TargetFrame:HideTest()

    ShowUIFrame(self.petFrame)
    SaveUIFramePosition(self.petFrame, 'pet')

    ShowUIFrame(self.targetOfTargetFrame)
    SaveUIFramePosition(self.targetOfTargetFrame, 'targetOfTarget')

    ShowUIFrame(self.focusFrame)
    SaveUIFramePosition(self.focusFrame, 'focus')
    FocusFrame:HideTest()
end
