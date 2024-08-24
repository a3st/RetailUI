local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'UnitFrame'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.playerFrame = nil
Module.targetFrame = nil
Module.targetOfTargetFrame = nil
Module.focusFrame = nil
Module.petFrame = nil

local function PlayerFrame_OnUpdate(self, elapsed)
    local playerRestIcon = PlayerRestIcon
    AnimateTexCoords(playerRestIcon, 512, 512, 64, 64, 42, elapsed, 1)
end

local AURA_OFFSET_Y = 3
local AURA_START_X = 3
local AURA_START_Y = 3

local function TargetFrame_UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY)
    local buff = _G[buffName .. index]
    if (index == 1) then
        if (UnitIsFriend("player", self.unit) or numDebuffs == 0) then
            -- unit is friendly or there are no debuffs...buffs start on top
            buff:SetPoint("TOPLEFT", self, "BOTTOMLEFT", AURA_START_X, AURA_START_Y)
        else
            -- unit is not friendly and we have debuffs...buffs start on bottom
            buff:SetPoint("TOPLEFT", self.debuffs, "BOTTOMLEFT", 0, -offsetY)
        end
        self.buffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0);
        self.buffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, -AURA_OFFSET_Y)
        self.spellbarAnchor = buff
    elseif (anchorIndex ~= (index - 1)) then
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
    if (index == 1) then
        if (isFriend and numBuffs > 0) then
            -- unit is friendly and there are buffs...debuffs start on bottom
            buff:SetPoint("TOPLEFT", self.buffs, "BOTTOMLEFT", 0, -offsetY)
        else
            -- unit is not friendly or there are no buffs...debuffs start on top
            buff:SetPoint("TOPLEFT", self, "BOTTOMLEFT", AURA_START_X, AURA_START_Y)
        end
        self.debuffs:SetPoint("TOPLEFT", buff, "TOPLEFT", 0, 0)
        self.debuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, -AURA_OFFSET_Y)
        if ((isFriend) or (not isFriend and numBuffs == 0)) then
            self.spellbarAnchor = buff
        end
    elseif (anchorIndex ~= (index - 1)) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint("TOPLEFT", _G[debuffName .. anchorIndex], "BOTTOMLEFT", 0, -offsetY)
        self.debuffs:SetPoint("BOTTOMLEFT", buff, "BOTTOMLEFT", 0, -AURA_OFFSET_Y)
        if ((isFriend) or (not isFriend and numBuffs == 0)) then
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
    if (classification == "worldboss" or classification == "elite") then
        self.elite:SetTexCoord(0 / 512, 160 / 512, 161 / 512, 322 / 512)
        self.elite:SetPoint("RIGHT", 9, 0)
        self.elite:SetSize(79, 82)
        self.elite:Show()
    elseif (classification == "rareelite") then
        self.elite:SetTexCoord(0 / 512, 196 / 512, 0 / 512, 160 / 512)
        self.elite:SetPoint("RIGHT", 27, 0)
        self.elite:SetSize(98, 80)
        self.elite:Show()
    elseif (classification == "rare") then
        self.elite:SetTexCoord(0 / 512, 160 / 512, 322 / 512, 485 / 512)
        self.elite:SetPoint("RIGHT", 9, 0)
        self.elite:SetSize(79, 82)
        self.elite:Show()
    else
        self.elite:Hide()
    end
end

local function FocusFrame_SetSmallSize(smallSize, onChange)
    Module.ReplaceBlizzardFocusFrame(Module)
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("RUNE_TYPE_UPDATE")

    PlayerFrame:HookScript('OnUpdate', PlayerFrame_OnUpdate)
    self:SecureHook('TargetFrame_UpdateBuffAnchor', TargetFrame_UpdateBuffAnchor)
    self:SecureHook('TargetFrame_UpdateDebuffAnchor', TargetFrame_UpdateDebuffAnchor)
    self:SecureHook('TargetFrame_CheckClassification', TargetFrame_CheckClassification)
    self:SecureHook('FocusFrame_SetSmallSize', FocusFrame_SetSmallSize)

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
    self:Unhook('TargetFrame_UpdateBuffAnchor', TargetFrame_UpdateBuffAnchor)
    self:Unhook('TargetFrame_UpdateDebuffAnchor', TargetFrame_UpdateDebuffAnchor)
    self:Unhook('TargetFrame_CheckClassification', TargetFrame_CheckClassification)
    self:Unhook('FocusFrame_SetSmallSize', FocusFrame_SetSmallSize)

    self.playerFrame = nil
    self.targetFrame = nil
    self.targetOfTargetFrame = nil
    self.focusFrame = nil
    self.petFrame = nil
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

function Module:RemoveBlizzardFrames()
    for _, blizzFrame in pairs(blizzUnitFrames) do
        blizzFrame:SetAlpha(0)
        blizzFrame.SetAlpha = function() end
    end
end

function Module:ReplaceBlizzardPlayerFrame()
    local playerFrame = PlayerFrame
    playerFrame:ClearAllPoints()
    playerFrame:SetPoint("LEFT", self.playerFrame, "LEFT", 0)

    playerFrame:SetSize(self.playerFrame:GetWidth(), self.playerFrame:GetHeight())
    playerFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local playerPortrait = PlayerPortrait
    playerPortrait:ClearAllPoints()
    playerPortrait:SetPoint("LEFT", 3, -1)
    playerPortrait:SetSize(58, 58)
    playerPortrait:SetDrawLayer('BACKGROUND')

    local border = _G[playerFrame:GetName() .. 'Texture']
    border:SetAllPoints(playerFrame)
    border:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    border:SetTexCoord(812 / 1024, 1002 / 1024, 3 / 512, 68 / 512)
    border:SetDrawLayer('BORDER')

    -- Health Bar
    local playerHealthBar = PlayerFrameHealthBar
    playerHealthBar:SetFrameLevel(playerFrame:GetFrameLevel() + 2)
    playerHealthBar:ClearAllPoints()
    playerHealthBar:SetPoint("TOPLEFT", 65, -25)
    playerHealthBar:SetSize(124, 18)

    local statusBarTexture = playerHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(playerHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(687 / 1024, 810 / 1024, 161 / 512, 179 / 512)

    -- Mana Bar
    local playerManaBar = PlayerFrameManaBar
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
    playerStatusTexture:SetDrawLayer("OVERLAY")

    -- Arrow
    playerFrame.arrowIcon = playerFrame.arrowIcon or playerFrame:CreateTexture(nil, "BORDER")
    local arrowIcon = playerFrame.arrowIcon
    arrowIcon:ClearAllPoints()
    arrowIcon:SetPoint("LEFT", 48, -22)
    arrowIcon:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    arrowIcon:SetTexCoord(986 / 1024, 997 / 1024, 144 / 512, 154 / 512)
    arrowIcon:SetSize(12, 12)
    arrowIcon:SetDrawLayer('BORDER')

    local playerPVPIcon = PlayerPVPIcon
    playerPVPIcon:ClearAllPoints()
    playerPVPIcon:SetPoint("LEFT", -16, -12)

    PlayerPVPTimerText:SetPoint("TOPLEFT", -10, 5)

    local playerFrameFlash = PlayerFrameFlash
    playerFrameFlash:SetAllPoints(playerFrame)
    playerFrameFlash:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    playerFrameFlash:SetTexCoord(202 / 1024, 392 / 1024, 90 / 512, 154 / 512)
    playerFrameFlash:SetDrawLayer("OVERLAY")

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
    targetFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local border = _G[targetFrame:GetName() .. 'TextureFrame' .. 'Texture']
    border:SetAllPoints(targetFrame)
    border:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    border:SetTexCoord(782 / 1024, 971 / 1024, 88 / 512, 150 / 512)
    border:SetDrawLayer('BORDER')
    border.SetAllPoints = function() end
    border.SetTexture = function() end

    local targetPortrait = TargetFramePortrait
    targetPortrait:ClearAllPoints()
    targetPortrait:SetPoint("RIGHT", -5, 1)
    targetPortrait:SetSize(58, 58)
    targetPortrait:SetDrawLayer('BACKGROUND')

    local background = TargetFrameNameBackground
    background:ClearAllPoints()
    background:SetPoint('TOPLEFT', 2, -8)
    background:SetPoint('BOTTOMRIGHT', -58, 42)
    background:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    background:SetTexCoord(690 / 1024, 808 / 1024, 162 / 512, 166 / 512)
    background:SetDrawLayer("BACKGROUND")
    background:SetBlendMode('BLEND')

    -- Health Bar
    local targetHealthBar = TargetFrameHealthBar
    targetHealthBar:SetFrameLevel(targetFrame:GetFrameLevel() + 1)
    targetHealthBar:ClearAllPoints()
    targetHealthBar:SetPoint("TOPLEFT", 4, -24)
    targetHealthBar:SetSize(124, 20)

    local statusBarTexture = targetHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(targetHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(434 / 1024, 557 / 1024, 183 / 512, 202 / 512)

    -- Mana Bar
    local targetManaBar = TargetFrameManaBar
    targetManaBar:SetFrameLevel(targetFrame:GetFrameLevel() + 1)
    targetManaBar:ClearAllPoints()
    targetManaBar:SetPoint("TOPLEFT", 4, -43)
    targetManaBar:SetSize(130, 12)

    statusBarTexture = targetManaBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(targetManaBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(466 / 1024, 598 / 1024, 207 / 512, 220 / 512)

    -- Font Strings
    local targetNameText = TargetFrameTextureFrameName
    targetNameText:ClearAllPoints()
    targetNameText:SetPoint("CENTER", -10, 18)
    targetNameText:SetDrawLayer("OVERLAY")
    targetNameText:SetJustifyH("LEFT")
    targetNameText:SetWidth(80)

    local targetLevelText = TargetFrameTextureFrameLevelText
    targetLevelText:ClearAllPoints()
    targetLevelText:SetPoint("CENTER", -80, 18)
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

    local targetPVPIcon = TargetFrameTextureFramePVPIcon
    targetPVPIcon:ClearAllPoints()
    targetPVPIcon:SetPoint("RIGHT", 40, -12)

    local targetLeaderIcon = TargetFrameTextureFrameLeaderIcon
    targetLeaderIcon:ClearAllPoints()
    targetLeaderIcon:SetPoint("TOPRIGHT", 0, 0)

    local targetFrameFlash = TargetFrameFlash
    targetFrameFlash:SetAllPoints(targetFrame)
    targetFrameFlash:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    targetFrameFlash:SetTexCoord(1 / 1024, 187 / 1024, 301 / 512, 363 / 512)
    targetFrameFlash:SetDrawLayer("OVERLAY")
    targetFrameFlash.SetPoint = function() end
    targetFrameFlash.SetTexCoord = function() end

    targetFrame.elite = targetFrame.elite or
        _G[targetFrame:GetName() .. 'TextureFrame']:CreateTexture(nil, 'OVERLAY')
    local elite = targetFrame.elite
    elite:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\TargetFrame\\BossFrame.blp")

    -- Raid Icon
    local raidTargetIcon = _G['TargetFrame' .. 'TextureFrame' .. 'RaidTargetIcon']
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
    petFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local petPortrait = PetPortrait
    petPortrait:ClearAllPoints()
    petPortrait:SetPoint("LEFT", 4, 0)
    petPortrait:SetSize(34, 34)
    petPortrait:SetDrawLayer('BACKGROUND')

    local border = _G[petFrame:GetName() .. 'Texture']
    border:SetAllPoints(petFrame)
    border:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    border:SetTexCoord(3 / 1024, 117 / 1024, 421 / 512, 463 / 512)
    border:SetDrawLayer('BORDER')
    border.SetTexture = function() end

    -- Health Bar
    local petHealthBar = PetFrameHealthBar
    petHealthBar:SetFrameLevel(petFrame:GetFrameLevel() + 2)
    petHealthBar:ClearAllPoints()
    petHealthBar:SetPoint("TOPLEFT", 42, -17)
    petHealthBar:SetSize(68, 8)

    local statusBarTexture = petHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(petHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(942 / 1024, 1009 / 1024, 181 / 512, 189 / 512)

    -- Mana Bar
    local petManaBar = PetFrameManaBar
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
    targetFrameToT:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local totPortrait = TargetFrameToTPortrait
    totPortrait:ClearAllPoints()
    totPortrait:SetPoint("LEFT", 4, 0)
    totPortrait:SetSize(34, 34)
    totPortrait:SetDrawLayer("BACKGROUND")

    local border = _G[targetFrameToT:GetName() .. 'TextureFrame' .. 'Texture']
    border:SetAllPoints(targetFrameToT)
    border:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    border:SetTexCoord(3 / 1024, 117 / 1024, 421 / 512, 463 / 512)
    border:SetDrawLayer('BORDER')
    border.SetAllPoints = function() end
    border.SetTexture = function() end

    -- Health Bar
    local totHealthBar = TargetFrameToTHealthBar
    totHealthBar:SetFrameLevel(targetFrameToT:GetFrameLevel() + 2)
    totHealthBar:ClearAllPoints()
    totHealthBar:SetPoint("TOPLEFT", 42, -17)
    totHealthBar:SetSize(69, 8)

    local statusBarTexture = totHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(totHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(942 / 1024, 1010 / 1024, 181 / 512, 189 / 512)

    -- Mana Bar
    local totManaBar = TargetFrameToTManaBar
    totManaBar:SetFrameLevel(targetFrameToT:GetFrameLevel() + 2)
    totManaBar:ClearAllPoints()
    totManaBar:SetPoint("TOPLEFT", 39, -28)
    totManaBar:SetSize(71, 5)

    statusBarTexture = totManaBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(totManaBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(473 / 1024, 546 / 1024, 247 / 512, 255 / 512)

    -- Font Strings
    local totNameText = TargetFrameToTTextureFrameName
    totNameText:ClearAllPoints()
    totNameText:SetPoint("CENTER", 16, 13)
    totNameText:SetDrawLayer("OVERLAY")
    totNameText:SetWidth(65)
end

function Module:ReplaceBlizzardFocusFrame()
    local focusFrame = FocusFrame
    focusFrame:ClearAllPoints()
    focusFrame:SetPoint("LEFT", self.focusFrame, "LEFT", 0)

    focusFrame:SetSize(self.focusFrame:GetWidth(), self.focusFrame:GetHeight())
    focusFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Main
    local border = _G[focusFrame:GetName() .. 'TextureFrame' .. 'Texture']
    border:SetAllPoints(focusFrame)
    border:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    border:SetTexCoord(782 / 1024, 970 / 1024, 88 / 512, 150 / 512)
    border:SetDrawLayer('BORDER')
    border.SetAllPoints = function() end
    border.SetTexture = function() end

    local focusPortrait = FocusFramePortrait
    focusPortrait:ClearAllPoints()
    focusPortrait:SetPoint("RIGHT", -5, 1)
    focusPortrait:SetSize(58, 58)
    focusPortrait:SetDrawLayer("BACKGROUND")

    local background = FocusFrameNameBackground
    background:ClearAllPoints()
    background:SetPoint('TOPLEFT', 2, -8)
    background:SetPoint('BOTTOMRIGHT', -58, 42)
    background:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    background:SetTexCoord(690 / 1024, 808 / 1024, 162 / 512, 166 / 512)
    background:SetDrawLayer("BACKGROUND")
    background:SetBlendMode('BLEND')

    -- Health Bar
    local focusHealthBar = FocusFrameHealthBar
    focusHealthBar:SetFrameLevel(focusFrame:GetFrameLevel() + 1)
    focusHealthBar:ClearAllPoints()
    focusHealthBar:SetPoint("TOPLEFT", 4, -24)
    focusHealthBar:SetSize(124, 20)

    local statusBarTexture = focusHealthBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(focusHealthBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(434 / 1024, 557 / 1024, 183 / 512, 202 / 512)

    -- Mana Bar
    local focusManaBar = FocusFrameManaBar
    focusManaBar:SetFrameLevel(focusFrame:GetFrameLevel() + 1)
    focusManaBar:ClearAllPoints()
    focusManaBar:SetPoint("TOPLEFT", 4, -43)
    focusManaBar:SetSize(131, 12)

    statusBarTexture = focusManaBar:GetStatusBarTexture()
    statusBarTexture:SetAllPoints(focusManaBar)
    statusBarTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-UnitFrame.blp")
    statusBarTexture:SetTexCoord(466 / 1024, 598 / 1024, 207 / 512, 220 / 512)

    -- Font Strings
    local focusNameText = FocusFrameTextureFrameName
    focusNameText:ClearAllPoints()
    focusNameText:SetPoint("CENTER", -10, 18)
    focusNameText:SetDrawLayer("OVERLAY")
    focusNameText:SetJustifyH("LEFT")
    focusNameText:SetWidth(80)
    focusNameText:SetFont(TargetFrameTextureFrameName:GetFont())

    local focusLevelText = FocusFrameTextureFrameLevelText
    focusLevelText:ClearAllPoints()
    focusLevelText:SetPoint("CENTER", -80, 18)
    focusLevelText:SetDrawLayer("OVERLAY")
    focusLevelText:SetFont(TargetFrameTextureFrameLevelText:GetFont())

    local focusHealthText = FocusFrameTextureFrameHealthBarText
    focusHealthText:ClearAllPoints()
    focusHealthText:SetPoint("CENTER", -25, -1)
    focusHealthText:SetDrawLayer("OVERLAY")
    focusHealthText:SetFont(TargetFrameTextureFrameHealthBarText:GetFont())

    local focusDeadText = FocusFrameTextureFrameDeadText
    focusDeadText:ClearAllPoints()
    focusDeadText:SetPoint("CENTER", -25, -1)
    focusDeadText:SetDrawLayer("OVERLAY")
    focusDeadText:SetFont(TargetFrameTextureFrameDeadText:GetFont())

    local focusManaText = FocusFrameTextureFrameManaBarText
    focusManaText:ClearAllPoints()
    focusManaText:SetPoint("CENTER", -25, -18)
    focusManaText:SetDrawLayer("OVERLAY")
    focusManaText:SetFont(TargetFrameTextureFrameManaBarText:GetFont())

    local focusPVPIcon = FocusFrameTextureFramePVPIcon
    focusPVPIcon:ClearAllPoints()
    focusPVPIcon:SetPoint("RIGHT", 40, -12)

    local focusLeaderIcon = FocusFrameTextureFrameLeaderIcon
    focusLeaderIcon:ClearAllPoints()
    focusLeaderIcon:SetPoint("TOPRIGHT", 0, 0)

    focusFrame.elite = focusFrame.elite or
        _G[focusFrame:GetName() .. 'TextureFrame']:CreateTexture(nil, 'OVERLAY')
    local elite = focusFrame.elite
    elite:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\TargetFrame\\BossFrame.blp")
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
        local button = _G['RuneButtonIndividual' .. index]
        button:SetAlpha(0)
        button:EnableMouse(false)
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
        local button = _G['RuneButtonIndividual' .. index]
        button:SetAlpha(1)
        button:EnableMouse(true)
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
