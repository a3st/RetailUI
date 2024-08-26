local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'ActionBar'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.actionBars = {}
Module.repExpBar = nil
Module.bagsBar = nil
Module.microMenuBar = nil
Module.toggleBags = false

local function verticalString(str)
    local _, len = str:gsub("[^\128-\193]", "")
    if (len == #str) then
        return str:gsub(".", "%1\n")
    else
        return str:gsub("([%z\1-\127\194-\244][\128-\191]*)", "%1\n")
    end
end

local function CreateNineSliceFrame(width, height)
    local nineSliceFrame = CreateFrame("Frame", nil, UIParent)
    nineSliceFrame:SetSize(width, height)

    do
        local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
        texture:SetPoint("TOPLEFT", 10, 7)
        texture:SetPoint("TOPRIGHT", -10, 7)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        texture:SetTexCoord(0, 32 / 512, 145 / 2048, 177 / 2048)
        texture:SetHorizTile(true)
        texture:SetSize(width, 20)
    end

    do
        local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
        texture:SetPoint("BOTTOMLEFT", 10, -7)
        texture:SetPoint("BOTTOMRIGHT", -10, -7)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        texture:SetTexCoord(0, 32 / 512, 97 / 2048, 143 / 2048)
        texture:SetHorizTile(true)
        texture:SetSize(width, 20)
    end

    do
        local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
        texture:SetPoint("TOPLEFT", -7, 7)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        texture:SetTexCoord(463 / 512, 497 / 512, 475 / 2048, 507 / 2048)
        texture:SetSize(20, 20)
    end

    do
        local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
        texture:SetPoint("TOPLEFT", -7, -10)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        texture:SetTexCoord(465 / 512, 499 / 512, 383 / 2048, 405 / 2048)
        texture:SetSize(20, height / 2)
    end

    do
        local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
        texture:SetPoint("BOTTOMLEFT", -7, -7)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        texture:SetTexCoord(465 / 512, 499 / 512, 383 / 2048, 429 / 2048)
        texture:SetSize(20, 20)
    end

    do
        local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
        texture:SetPoint("TOPRIGHT", 7, 7)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        texture:SetTexCoord(463 / 512, 507 / 512, 441 / 2048, 473 / 2048)
        texture:SetSize(20, 20)
    end

    do
        local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
        texture:SetPoint("TOPRIGHT", 7, -10)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        texture:SetTexCoord(465 / 512, 509 / 512, 335 / 2048, 359 / 2048)
        texture:SetSize(20, height / 2)
    end

    do
        local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
        texture:SetPoint("BOTTOMRIGHT", 7, -7)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        texture:SetTexCoord(465 / 512, 509 / 512, 335 / 2048, 381 / 2048)
        texture:SetSize(20, 20)
    end

    return nineSliceFrame
end

local MainMenuBarNineSlice = nil

local function CreateActionFrameBar(barID, buttonCount, buttonSize, gap, vertical, frameName)
    if buttonCount > 12 then
        assert(nil, "The Action Bar cannot contain more than 12 buttons")
    end

    local width
    local height

    if vertical then
        width = (buttonSize - 2)
        height = gap * (buttonCount - 1) + ((buttonSize - 2) * buttonCount)
    else
        width = gap * (buttonCount - 1) + ((buttonSize - 2) * buttonCount)
        height = (buttonSize - 2)
    end

    -- Default
    frameName = frameName or ('ActionBar' .. barID)

    local frameBar = CreateUIFrame(width, height, frameName)

    -- Change text direction if vertical bar
    if vertical then
        frameBar.editorText:SetText(verticalString(frameBar.editorText:GetText()))
    end

    if barID == MAIN_ACTION_BAR_ID then
        frameBar.nineSlice = CreateNineSliceFrame(width, height)
        frameBar.nineSlice:SetPoint("LEFT", frameBar, "LEFT", 0, 0)
        MainMenuBarNineSlice = frameBar.nineSlice
    end

    frameBar.ID = barID
    frameBar.buttonSize = buttonSize
    frameBar.buttonCount = buttonCount
    frameBar.gap = gap
    frameBar.vertical = vertical

    return frameBar
end

MAIN_ACTION_BAR_ID = 1
BONUS_ACTION_BAR_ID = 6
SHAPESHIFT_ACTION_BAR_ID = 7
PET_ACTION_BAR_ID = 8
POSSESS_ACTION_BAR_ID = 9
MULTICAST_ACTION_BAR_ID = 10

local blizzActionBars = {
    'ActionButton',
    'MultiBarBottomLeftButton',
    'MultiBarBottomRightButton',
    'MultiBarRightButton',
    'MultiBarLeftButton',
    'BonusActionButton',
    'ShapeshiftButton',
    'PetActionButton',
    'PossessButton'
}

local function ReplaceBlizzardActionBarFrame(frameBar)
    if frameBar.ID == MAIN_ACTION_BAR_ID then
        local faction = UnitFactionGroup('player')

        local leftEndCapTexture = MainMenuBarLeftEndCap
        leftEndCapTexture:ClearAllPoints()
        leftEndCapTexture:SetPoint("RIGHT", frameBar, "LEFT", 6, 4)

        local rightEndCapTexture = MainMenuBarRightEndCap
        rightEndCapTexture:ClearAllPoints()
        rightEndCapTexture:SetPoint("LEFT", frameBar, "RIGHT", -6, 4)
        rightEndCapTexture:SetSize(92, 92)

        if faction == 'Alliance' then
            leftEndCapTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
            leftEndCapTexture:SetTexCoord(1 / 512, 357 / 512, 209 / 2048, 543 / 2048)
            leftEndCapTexture:SetSize(92, 92)

            rightEndCapTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
            rightEndCapTexture:SetTexCoord(1 / 512, 357 / 512, 545 / 2048, 879 / 2048)
            rightEndCapTexture:SetSize(92, 92)
        else
            leftEndCapTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
            leftEndCapTexture:SetTexCoord(1 / 512, 357 / 512, 881 / 2048, 1215 / 2048)
            leftEndCapTexture:SetSize(104.5, 96)

            rightEndCapTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
            rightEndCapTexture:SetTexCoord(1 / 512, 357 / 512, 1217 / 2048, 1551 / 2048)
            rightEndCapTexture:SetSize(104.5, 96)
        end

        local pageNumberText = _G['MainMenuBarPageNumber']
        pageNumberText:SetPoint("CENTER", frameBar, "LEFT", -18, 0)
        pageNumberText:SetFontObject(GameFontNormal)

        local barUpButton = _G['ActionBarUpButton']
        barUpButton:SetPoint("CENTER", pageNumberText, "CENTER", 0, 15)

        local normalTexture = barUpButton:GetNormalTexture()
        normalTexture:SetPoint("TOPLEFT", 7, -6)
        normalTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        normalTexture:SetTexCoord(359 / 512, 393 / 512, 833 / 2048, 861 / 2048)

        local pushedTexture = barUpButton:GetPushedTexture()
        pushedTexture:SetPoint("TOPLEFT", 7, -6)
        pushedTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        pushedTexture:SetTexCoord(453 / 512, 487 / 512, 679 / 2048, 707 / 2048)

        local highlightTexture = barUpButton:GetHighlightTexture()
        highlightTexture:SetPoint("TOPLEFT", 7, -6)
        highlightTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        highlightTexture:SetTexCoord(453 / 512, 487 / 512, 709 / 2048, 737 / 2048)

        local barDownButton = _G['ActionBarDownButton']
        barDownButton:SetPoint("CENTER", pageNumberText, "CENTER", 0, -15)

        normalTexture = barDownButton:GetNormalTexture()
        normalTexture:SetPoint("TOPLEFT", 7, -6)
        normalTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        normalTexture:SetTexCoord(463 / 512, 497 / 512, 605 / 2048, 633 / 2048)

        pushedTexture = barDownButton:GetPushedTexture()
        pushedTexture:SetPoint("TOPLEFT", 7, -6)
        pushedTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        pushedTexture:SetTexCoord(463 / 512, 497 / 512, 545 / 2048, 573 / 2048)

        highlightTexture = barDownButton:GetHighlightTexture()
        highlightTexture:SetPoint("TOPLEFT", 7, -6)
        highlightTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        highlightTexture:SetTexCoord(463 / 512, 497 / 512, 575 / 2048, 603 / 2048)
    end

    for index = 1, frameBar.buttonCount do
        local button = _G[blizzActionBars[frameBar.ID] .. index]
        button:ClearAllPoints()

        if index > 1 then
            if frameBar.vertical then
                button:SetPoint("TOP", _G[blizzActionBars[frameBar.ID] .. index - 1], "BOTTOM", 0, -frameBar.gap)
            else
                button:SetPoint("LEFT", _G[blizzActionBars[frameBar.ID] .. index - 1], "RIGHT", frameBar.gap, 0)
            end
        else
            if frameBar.vertical then
                button:SetPoint("TOP", frameBar, "TOP", 0, 0)
            else
                button:SetPoint("LEFT", frameBar, "LEFT", 0, 0)
            end
        end

        button:SetSize(frameBar.buttonSize - 2, frameBar.buttonSize - 2)

        local normalTexture = button:GetNormalTexture()
        normalTexture:SetAllPoints(button)
        normalTexture:SetPoint("TOPLEFT", -2, 2)
        normalTexture:SetPoint("BOTTOMRIGHT", 2, -2)
        normalTexture:SetDrawLayer("BACKGROUND")
        normalTexture:SetAlpha(0)

        button.background = button.background or button:CreateTexture(nil, "BACKGROUND")
        local backgroundTexture = button.background
        backgroundTexture:SetAllPoints(button)
        backgroundTexture:SetPoint("TOPLEFT", -2, 2)
        backgroundTexture:SetPoint("BOTTOMRIGHT", 2, -2)
        backgroundTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        backgroundTexture:SetTexCoord(359 / 512, 487 / 512, 209 / 2048, 333 / 2048)

        if frameBar.ID == MAIN_ACTION_BAR_ID or frameBar.ID == BONUS_ACTION_BAR_ID then
            backgroundTexture:Show()
        else
            backgroundTexture:Hide()
        end

        local highlightTexture = button:GetHighlightTexture()
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        highlightTexture:SetTexCoord(359 / 512, 451 / 512, 1065 / 2048, 1155 / 2048)

        local pushedTexture = button:GetPushedTexture()
        pushedTexture:SetAllPoints(button)
        pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        pushedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

        local checkedTexture = button:GetCheckedTexture()
        checkedTexture:SetAllPoints(button)
        checkedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        checkedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

        local iconTexture = _G[button:GetName() .. "Icon"]
        iconTexture:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
        iconTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
        iconTexture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        iconTexture:SetDrawLayer('BORDER')

        local borderTexture = _G[button:GetName() .. "Border"]
        borderTexture:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
        borderTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
        borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        borderTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)
        borderTexture:SetDrawLayer("OVERLAY")

        local flashTexture = _G[button:GetName() .. "Flash"]
        flashTexture:SetAllPoints(button)
        flashTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        flashTexture:SetTexCoord(359 / 512, 451 / 512, 973 / 2048, 1063 / 2048)

        local macroText = _G[button:GetName() .. "Name"]
        macroText:SetPoint("BOTTOM", 0, 5)

        local countText = _G[button:GetName() .. "Count"]
        countText:SetPoint("BOTTOMRIGHT", -4, 3)

        local hotKeyText = _G[button:GetName() .. "HotKey"]
        hotKeyText:SetPoint("TOPLEFT", 4, -3)

        local cooldown = _G[button:GetName() .. "Cooldown"]
        cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
        cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

        button.border = button.border or button:CreateTexture(nil, "OVERLAY")
        borderTexture = button.border
        borderTexture:SetAllPoints(button)
        borderTexture:SetPoint("TOPLEFT", -2, 2)
        borderTexture:SetPoint("BOTTOMRIGHT", 2, -2)
        borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
        borderTexture:SetTexCoord(359 / 512, 451 / 512, 649 / 2048, 739 / 2048)
    end
end

local function ReplaceBlizzardMultiSlotButton(button, frameBar)
    button:SetSize(frameBar.buttonSize - 2, frameBar.buttonSize - 2)

    for _, region in pairs { button:GetRegions() } do
        if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'OVERLAY' then
            region:Hide()
        end
    end

    button.border = button.border or button:CreateTexture(nil, "BORDER")
    local borderTexture = button.border
    borderTexture:SetAllPoints(button)
    borderTexture:SetPoint("TOPLEFT", -2, 2)
    borderTexture:SetPoint("BOTTOMRIGHT", 2, -2)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    borderTexture:SetTexCoord(359 / 512, 451 / 512, 649 / 2048, 739 / 2048)
end

local function ReplaceBlizzardMultiActionButton(button, frameBar)
    button:SetSize(frameBar.buttonSize - 2, frameBar.buttonSize - 2)

    for _, region in pairs { button:GetRegions() } do
        if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'OVERLAY' then
            region:Hide()
        end
    end

    local normalTexture = button:GetNormalTexture()
    normalTexture:SetAllPoints(button)
    normalTexture:SetPoint("TOPLEFT", -2, 2)
    normalTexture:SetPoint("BOTTOMRIGHT", 2, -2)
    normalTexture:SetDrawLayer("BACKGROUND")
    normalTexture:SetAlpha(0)

    local highlightTexture = button:GetHighlightTexture()
    highlightTexture:SetAllPoints(button)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    highlightTexture:SetTexCoord(359 / 512, 451 / 512, 1065 / 2048, 1155 / 2048)

    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetAllPoints(button)
    pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    pushedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

    local checkedTexture = button:GetCheckedTexture()
    checkedTexture:SetAllPoints(button)
    checkedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    checkedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

    local iconTexture = _G[button:GetName() .. "Icon"]
    iconTexture:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
    iconTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    iconTexture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    iconTexture:SetDrawLayer('BACKGROUND')

    local borderTexture = _G[button:GetName() .. "Border"]
    borderTexture:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
    borderTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    borderTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)
    borderTexture:SetDrawLayer("OVERLAY")

    local flashTexture = _G[button:GetName() .. "Flash"]
    flashTexture:SetAllPoints(button)
    flashTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    flashTexture:SetTexCoord(359 / 512, 451 / 512, 973 / 2048, 1063 / 2048)

    local macroText = _G[button:GetName() .. "Name"]
    macroText:SetPoint("BOTTOM", 0, 5)

    local countText = _G[button:GetName() .. "Count"]
    countText:SetPoint("BOTTOMRIGHT", -4, 3)

    local hotKeyText = _G[button:GetName() .. "HotKey"]
    hotKeyText:SetPoint("TOPLEFT", 4, -3)

    local cooldown = _G[button:GetName() .. "Cooldown"]
    cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
    cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

    button.border = button.border or button:CreateTexture(nil, "BORDER")
    borderTexture = button.border
    borderTexture:SetAllPoints(button)
    borderTexture:SetPoint("TOPLEFT", -2, 2)
    borderTexture:SetPoint("BOTTOMRIGHT", 2, -2)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    borderTexture:SetTexCoord(359 / 512, 451 / 512, 649 / 2048, 739 / 2048)
end

local multiActionBarGap = 0

local function ReplaceBlizzardMultiActionBarFrame(frameBar)
    -- Page/Summon Button
    local button = MultiCastSummonSpellButton
    button:ClearAllPoints()
    button:SetPoint("LEFT", frameBar, "LEFT", 0, 0)

    ReplaceBlizzardMultiActionButton(button, frameBar)

    local flyoutOpenButton = MultiCastFlyoutFrameOpenButton
    flyoutOpenButton:SetSize(24, 13)
    flyoutOpenButton:SetHitRectInsets(0, 0, 0, 0)

    local normalTexture = flyoutOpenButton:GetNormalTexture()
    normalTexture:SetAllPoints(flyoutOpenButton)
    normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CollapseButton.blp")

    local highlightTexture = flyoutOpenButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(flyoutOpenButton)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CollapseButton.blp")
    highlightTexture:SetTexCoord(31 / 64, 63 / 64, 10 / 64, 27 / 64)

    local flyoutCloseButton = MultiCastFlyoutFrameCloseButton
    flyoutCloseButton:SetSize(24, 13)
    flyoutCloseButton:SetHitRectInsets(0, 0, 0, 0)

    normalTexture = flyoutCloseButton:GetNormalTexture()
    normalTexture:SetAllPoints(flyoutCloseButton)
    normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CollapseButton.blp")

    highlightTexture = flyoutCloseButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(flyoutCloseButton)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CollapseButton.blp")
    highlightTexture:SetTexCoord(31 / 64, 62 / 64, 37 / 64, 54 / 64)

    for index = 1, NUM_MULTI_CAST_BUTTONS_PER_PAGE do
        local button = _G['MultiCastSlotButton' .. index]
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint("LEFT", _G['MultiCastSlotButton' .. index - 1], "RIGHT", frameBar.gap, 0)
        else
            button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", frameBar.gap, 0)
        end

        ReplaceBlizzardMultiSlotButton(button, frameBar)
    end

    for page = 1, NUM_MULTI_CAST_PAGES do
        for index = 1, NUM_MULTI_CAST_BUTTONS_PER_PAGE do
            local button = _G['MultiCastActionButton' .. (page - 1) * NUM_MULTI_CAST_BUTTONS_PER_PAGE + index]
            button:ClearAllPoints()

            if index > 1 then
                button:SetPoint("LEFT",
                    _G['MultiCastActionButton' .. (page - 1) * NUM_MULTI_CAST_BUTTONS_PER_PAGE + index - 1], "RIGHT",
                    frameBar.gap, 0)
            else
                button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", frameBar.gap, 0)
            end

            ReplaceBlizzardMultiActionButton(button, frameBar)
        end
    end

    -- Recall Button
    button = MultiCastRecallSpellButton
    button:ClearAllPoints()
    local activeSlots = MultiCastActionBarFrame.numActiveSlots
    if activeSlots > 0 then
        button:SetPoint("LEFT", _G['MultiCastActionButton' .. activeSlots], "RIGHT", frameBar.gap, 0)
    end

    ReplaceBlizzardMultiActionButton(button, frameBar)

    -- Flyout Frame
    local flyoutFrame = MultiCastFlyoutFrame
    for _, region in pairs { flyoutFrame:GetRegions() } do
        if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'BACKGROUND' then
            region:Hide()
        end
    end

    multiActionBarGap = frameBar.gap
end

local function ReplaceBlizzardRepExpBarFrame(frameBar)
    local mainMenuExpBar = MainMenuExpBar
    mainMenuExpBar:ClearAllPoints()

    mainMenuExpBar:SetWidth(frameBar:GetWidth())

    for _, region in pairs { mainMenuExpBar:GetRegions() } do
        if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'BACKGROUND' then
            region:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ExperienceBar.blp")
            region:SetTexCoord(0.00088878125, 570 / 2048, 20 / 64, 29 / 64)
        end
    end

    local exhaustionLevelBar = ExhaustionLevelFillBar
    exhaustionLevelBar:SetHeight(frameBar:GetHeight())

    local borderTexture = MainMenuXPBarTexture0
    borderTexture:SetAllPoints(mainMenuExpBar)
    borderTexture:SetPoint("TOPLEFT", mainMenuExpBar, "TOPLEFT", -3, 3)
    borderTexture:SetPoint("BOTTOMRIGHT", mainMenuExpBar, "BOTTOMRIGHT", 3, -6)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ExperienceBar.blp")
    borderTexture:SetTexCoord(1 / 2048, 572 / 2048, 1 / 64, 18 / 64)

    local expText = MainMenuBarExpText
    expText:SetPoint("CENTER", mainMenuExpBar, "CENTER", 0, 2)

    local repWatchBar = ReputationWatchBar
    repWatchBar:ClearAllPoints()

    repWatchBar:SetWidth(frameBar:GetWidth())

    local repStatusBar = ReputationWatchStatusBar
    repStatusBar:SetAllPoints(repWatchBar)

    repStatusBar:SetWidth(repWatchBar:GetWidth())

    local backgroundTexture = _G[repStatusBar:GetName() .. "Background"]
    backgroundTexture:SetAllPoints(repStatusBar)
    backgroundTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ExperienceBar.blp")
    backgroundTexture:SetTexCoord(0.00088878125, 570 / 2048, 20 / 64, 29 / 64)

    borderTexture = ReputationXPBarTexture0
    borderTexture:SetAllPoints(repStatusBar)
    borderTexture:SetPoint("TOPLEFT", repStatusBar, "TOPLEFT", -3, 2)
    borderTexture:SetPoint("BOTTOMRIGHT", repStatusBar, "BOTTOMRIGHT", 3, -7)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ExperienceBar.blp")
    borderTexture:SetTexCoord(1 / 2048, 572 / 2048, 1 / 64, 18 / 64)

    borderTexture = ReputationWatchBarTexture0
    borderTexture:SetAllPoints(repStatusBar)
    borderTexture:SetPoint("TOPLEFT", repStatusBar, "TOPLEFT", -3, 2)
    borderTexture:SetPoint("BOTTOMRIGHT", repStatusBar, "BOTTOMRIGHT", 3, -7)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ExperienceBar.blp")
    borderTexture:SetTexCoord(1 / 2048, 572 / 2048, 1 / 64, 18 / 64)
end

local microMenuButtons = {
    CharacterMicroButton,
    SpellbookMicroButton,
    TalentMicroButton,
    AchievementMicroButton,
    QuestLogMicroButton,
    SocialsMicroButton,
    PVPMicroButton,
    LFDMicroButton,
    MainMenuMicroButton,
    HelpMicroButton
}

local microMenuStyles = {
    {
        normalTexture = { left = 1 / 256, right = 39 / 256, top = 325 / 512, bottom = 377 / 512 },
        pushedTexture = { left = 121 / 256, right = 159 / 256, top = 163 / 512, bottom = 215 / 512 },
        highlightTexture = { left = 81 / 256, right = 119 / 256, top = 217 / 512, bottom = 269 / 512 }
    },
    {
        normalTexture = { left = 121 / 256, right = 159 / 256, top = 55 / 512, bottom = 107 / 512 },
        pushedTexture = { left = 81 / 256, right = 119 / 256, top = 433 / 512, bottom = 485 / 512 },
        highlightTexture = { left = 189 / 256, right = 227 / 256, top = 433 / 512, bottom = 485 / 512 }
    },
    {
        normalTexture = { left = 161 / 256, right = 199 / 256, top = 1 / 512, bottom = 53 / 512 },
        pushedTexture = { left = 81 / 256, right = 119 / 256, top = 271 / 512, bottom = 323 / 512 },
        highlightTexture = { left = 81 / 256, right = 119 / 256, top = 1 / 512, bottom = 53 / 512 },
        disabledTexture = { left = 81 / 256, right = 119 / 256, top = 55 / 512, bottom = 107 / 512 }
    },
    {
        normalTexture = { left = 161 / 256, right = 199 / 256, top = 109 / 512, bottom = 161 / 512 },
        pushedTexture = { left = 161 / 256, right = 199 / 256, top = 55 / 512, bottom = 107 / 512 },
        highlightTexture = { left = 201 / 256, right = 239 / 256, top = 55 / 512, bottom = 107 / 512 },
        disabledTexture = { left = 201 / 256, right = 239 / 256, top = 109 / 512, bottom = 161 / 512 }
    },
    {
        normalTexture = { left = 201 / 256, right = 239 / 256, top = 271 / 512, bottom = 323 / 512 },
        pushedTexture = { left = 121 / 256, right = 159 / 256, top = 271 / 512, bottom = 323 / 512 },
        highlightTexture = { left = 41 / 256, right = 79 / 256, top = 433 / 512, bottom = 485 / 512 }
    },
    {
        normalTexture = { left = 41 / 256, right = 79 / 256, top = 55 / 512, bottom = 107 / 512 },
        pushedTexture = { left = 1 / 256, right = 39 / 256, top = 1 / 512, bottom = 53 / 512 },
        highlightTexture = { left = 41 / 256, right = 79 / 256, top = 1 / 512, bottom = 53 / 512 }
    },
    {
        normalTexture = { left = 1 / 256, right = 39 / 256, top = 271 / 512, bottom = 323 / 512 },
        pushedTexture = { left = 201 / 256, right = 239 / 256, top = 163 / 512, bottom = 215 / 512 },
        highlightTexture = { left = 1 / 256, right = 39 / 256, top = 271 / 512, bottom = 323 / 512 },
        disabledTexture = { left = 81 / 256, right = 119 / 256, top = 163 / 512, bottom = 215 / 512 }
    },
    {
        normalTexture = { left = 1 / 256, right = 39 / 256, top = 163 / 512, bottom = 215 / 512 },
        pushedTexture = { left = 81 / 256, right = 119 / 256, top = 109 / 512, bottom = 161 / 512 },
        highlightTexture = { left = 41 / 256, right = 79 / 256, top = 109 / 512, bottom = 161 / 512 },
        disabledTexture = { left = 41 / 256, right = 79 / 256, top = 271 / 512, bottom = 323 / 512 }
    },
    {
        normalTexture = { left = 1 / 256, right = 39 / 256, top = 109 / 512, bottom = 161 / 512 },
        pushedTexture = { left = 161 / 256, right = 199 / 256, top = 271 / 512, bottom = 323 / 512 },
        highlightTexture = { left = 121 / 256, right = 159 / 256, top = 325 / 512, bottom = 377 / 512 }
    },
    {
        normalTexture = { left = 201 / 256, right = 239 / 256, top = 217 / 512, bottom = 269 / 512 },
        pushedTexture = { left = 121 / 256, right = 159 / 256, top = 217 / 512, bottom = 269 / 512 },
        highlightTexture = { left = 161 / 256, right = 199 / 256, top = 217 / 512, bottom = 269 / 512 }
    }
}

local function ReplaceBlizzardMicroMenuBarFrame(frameBar)
    for index, button in pairs(microMenuButtons) do
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint("LEFT", microMenuButtons[index - 1], "RIGHT", frameBar.gap, 0)
        else
            button:SetPoint("LEFT", frameBar, "LEFT", 0, 0)
        end

        button:SetSize(21, 29)
        button:SetHitRectInsets(0, 0, 0, 0)

        local normalTexture = button:GetNormalTexture()
        normalTexture:SetAllPoints(button)
        normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-MicroMenu.blp")
        normalTexture:SetTexCoord(microMenuStyles[index].normalTexture.left, microMenuStyles[index].normalTexture.right,
            microMenuStyles[index].normalTexture.top, microMenuStyles[index].normalTexture.bottom)

        local highlightTexture = button:GetHighlightTexture()
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-MicroMenu.blp")
        highlightTexture:SetTexCoord(microMenuStyles[index].highlightTexture.left,
            microMenuStyles[index].highlightTexture.right, microMenuStyles[index].highlightTexture.top,
            microMenuStyles[index].highlightTexture.bottom)

        local pushedTexture = button:GetPushedTexture()
        pushedTexture:SetAllPoints(button)
        pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-MicroMenu.blp")
        pushedTexture:SetTexCoord(microMenuStyles[index].pushedTexture.left,
            microMenuStyles[index].pushedTexture.right, microMenuStyles[index].pushedTexture.top,
            microMenuStyles[index].pushedTexture.bottom)

        if microMenuStyles[index].disabledTexture ~= nil then
            local disabledTexture = button:GetDisabledTexture() or button:CreateTexture(nil, "OVERLAY")
            disabledTexture:SetAllPoints(button)
            disabledTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-MicroMenu.blp")
            disabledTexture:SetTexCoord(microMenuStyles[index].disabledTexture.left,
                microMenuStyles[index].disabledTexture.right, microMenuStyles[index].disabledTexture.top,
                microMenuStyles[index].disabledTexture.bottom)

            button:SetDisabledTexture(disabledTexture)
        end
    end

    -- Portrait
    local playerPortraitTexture = MicroButtonPortrait
    playerPortraitTexture:Hide()

    -- PVP Flag
    local pvpButtonTexture = _G['PVPMicroButton' .. "Texture"]
    pvpButtonTexture:Hide()
end

local bagSlotButtons = {
    KeyRingButton,
    CharacterBag3Slot,
    CharacterBag2Slot,
    CharacterBag1Slot,
    CharacterBag0Slot
}

local function ReplaceBlizzardBagsBarFrame(frameBar)
    for index, button in pairs(bagSlotButtons) do
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint("LEFT", bagSlotButtons[index - 1], "RIGHT", frameBar.gap, 0)
        else
            button:SetPoint("LEFT", frameBar, "LEFT", 0, 0)
        end

        button:SetSize(32, 32)

        button:SetNormalTexture('')
        button:SetPushedTexture(nil)

        local highlightTexture = button:GetHighlightTexture()
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-BagSlots.blp")
        highlightTexture:SetTexCoord(358 / 512, 419 / 512, 1 / 128, 62 / 128)

        local checkedTexture = button:GetCheckedTexture() or button:CreateTexture(nil, 'OVERLAY')
        checkedTexture:SetAllPoints(button)
        checkedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-BagSlots.blp")
        checkedTexture:SetTexCoord(358 / 512, 419 / 512, 1 / 128, 62 / 128)

        button:SetCheckedTexture(checkedTexture)

        local iconTexture = _G[button:GetName() .. 'IconTexture']
        if iconTexture then
            iconTexture:ClearAllPoints()
            iconTexture:SetPoint('TOPLEFT', 6, -5)
            iconTexture:SetPoint('BOTTOMRIGHT', -7, 7)
            iconTexture:SetTexCoord(.08, .92, .08, .92)
            iconTexture:SetDrawLayer('BACKGROUND')
        end

        button.border = button.border or button:CreateTexture(nil, "BORDER")
        local borderTexture = button.border
        borderTexture:SetAllPoints(button)

        if index == 1 then -- Keys
            borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-BagSlotsKey.blp")
            borderTexture:SetTexCoord(3 / 128, 63 / 128, 64 / 128, 125 / 128)
        else -- Bags
            borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-BagSlots.blp")
            borderTexture:SetTexCoord(295 / 512, 356 / 512, 1 / 128, 62 / 128)

            local slotsText = _G[button:GetName() .. 'Count']
            slotsText:ClearAllPoints()
            slotsText:SetPoint("BOTTOM", 0, 2)
        end

        button:Hide()
    end

    frameBar.toggleButton = frameBar.toggleButton or CreateFrame('Button', nil, UIParent)
    local toggleButton = frameBar.toggleButton
    toggleButton:SetPoint("LEFT", CharacterBag0Slot, "RIGHT", frameBar.gap, 0)

    toggleButton:SetSize(13, 24)
    toggleButton:SetHitRectInsets(0, 0, 0, 0)

    local normalTexture = toggleButton:GetNormalTexture() or toggleButton:CreateTexture(nil, "BORDER")
    normalTexture:SetAllPoints(toggleButton)
    normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CollapseButton.blp")
    normalTexture:SetTexCoord(4 / 64, 22 / 64, 0 / 64, 31 / 64)

    toggleButton:SetNormalTexture(normalTexture)

    local highlightTexture = toggleButton:GetHighlightTexture() or toggleButton:CreateTexture(nil, "HIGHLIGHT")
    highlightTexture:SetAllPoints(toggleButton)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CollapseButton.blp")
    highlightTexture:SetTexCoord(4 / 64, 22 / 64, 0 / 64, 31 / 64)

    toggleButton:SetHighlightTexture(highlightTexture)

    toggleButton:SetScript("OnClick", function(self)
        if Module.toggleBags then
            local normalTexture = self:GetNormalTexture()
            normalTexture:SetTexCoord(4 / 64, 22 / 64, 0 / 64, 31 / 64)

            local highlightTexture = toggleButton:GetHighlightTexture()
            highlightTexture:SetTexCoord(4 / 64, 22 / 64, 0 / 64, 31 / 64)

            for _, button in pairs(bagSlotButtons) do
                button:Hide()
            end
        else
            local normalTexture = self:GetNormalTexture()
            normalTexture:SetTexCoord(5 / 64, 22 / 64, 31 / 64, 62 / 64)

            local highlightTexture = toggleButton:GetHighlightTexture()
            highlightTexture:SetTexCoord(5 / 64, 22 / 64, 31 / 64, 62 / 64)

            for _, button in pairs(bagSlotButtons) do
                button:Show()
            end
        end

        Module.toggleBags = not Module.toggleBags
    end)

    do
        local button = MainMenuBarBackpackButton
        button:ClearAllPoints()
        button:SetPoint("LEFT", toggleButton, "RIGHT", frameBar.gap, 0)

        button:SetSize(50, 50)

        button:SetNormalTexture(nil)
        button:SetPushedTexture(nil)

        highlightTexture = button:GetHighlightTexture()
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-BagSlots.blp")
        highlightTexture:SetTexCoord(99 / 512, 195 / 512, 1 / 128, 97 / 128)

        button:SetCheckedTexture(highlightTexture)
        button:SetHighlightTexture(highlightTexture)

        local iconTexture = _G[button:GetName() .. 'IconTexture']
        iconTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-BagSlots.blp")
        iconTexture:SetTexCoord(1 / 512, 97 / 512, 1 / 128, 97 / 128)
    end

    local backpackSlotsText = MainMenuBarBackpackButtonCount
    backpackSlotsText:ClearAllPoints()
    backpackSlotsText:SetPoint("BOTTOM", 0, 8)
end

local blizzFrames = {
    MainMenuBarPerformanceBar,
    MainMenuBarTexture0,
    MainMenuBarTexture1,
    MainMenuBarTexture2,
    MainMenuBarTexture3,
    MainMenuBarMaxLevelBar,
    ReputationXPBarTexture1,
    ReputationXPBarTexture2,
    ReputationXPBarTexture3,
    ReputationWatchBarTexture1,
    ReputationWatchBarTexture2,
    ReputationWatchBarTexture3,
    MainMenuXPBarTexture1,
    MainMenuXPBarTexture2,
    MainMenuXPBarTexture3,
    SlidingActionBarTexture0,
    SlidingActionBarTexture1,
    BonusActionBarTexture0,
    BonusActionBarTexture1,
    ShapeshiftBarLeft,
    ShapeshiftBarMiddle,
    ShapeshiftBarRight,
    PossessBackground1,
    PossessBackground2
}

local function RemoveBlizzardFrames()
    for _, frame in pairs(blizzFrames) do
        frame:SetAlpha(0)
    end

    MainMenuBar:EnableMouse(false)
    ShapeshiftBarFrame:EnableMouse(false)
    PossessBarFrame:EnableMouse(false)
    PetActionBarFrame:EnableMouse(false)
    MultiCastActionBarFrame:EnableMouse(false)
end

local function ShowBackgroundActionButton(button)
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetAlpha(0)
end

local function ActionButton_ShowGrid(button)
    ShowBackgroundActionButton(button)
    button:Show()
end

local function ActionButton_Update(button)
    ShowBackgroundActionButton(button)
end

local function ReputationWatchBar_Update()
    local factionInfo = GetWatchedFactionInfo()
    if factionInfo then
        local repWatchBar = ReputationWatchBar
        repWatchBar:ClearAllPoints()
        repWatchBar:SetHeight(Module.repExpBar:GetHeight())
        repWatchBar:SetPoint("LEFT", Module.repExpBar, "LEFT", 0, 0)
    end
end

local function MainMenuExpBar_Update()
    local mainMenuExpBar = MainMenuExpBar
    mainMenuExpBar:ClearAllPoints()
    mainMenuExpBar:SetWidth(Module.repExpBar:GetWidth())
    mainMenuExpBar:SetHeight(Module.repExpBar:GetHeight())
    mainMenuExpBar:SetPoint("LEFT", Module.repExpBar, "LEFT", 0, 0)

    local repWatchBar = ReputationWatchBar
    if repWatchBar:IsShown() then
        mainMenuExpBar:SetPoint("LEFT", repWatchBar, "LEFT", 0, -22)
    else
        mainMenuExpBar:SetPoint("LEFT", Module.repExpBar, "LEFT", 0, 0)
    end
end

local function ShapeshiftBar_Update()
    local button = _G['ShapeshiftButton' .. 1]
    button:ClearAllPoints()
    button:SetPoint("LEFT", Module.actionBars[SHAPESHIFT_ACTION_BAR_ID], "LEFT", 0)

    if GetNumShapeshiftForms() > 0 then
        button = _G['ShapeshiftButton' .. GetNumShapeshiftForms()]
        Module.actionBars[PET_ACTION_BAR_ID]:SetPoint("LEFT", button, "RIGHT", 10, 0)
    else
        Module.actionBars[PET_ACTION_BAR_ID]:SetPoint("LEFT", Module.actionBars[SHAPESHIFT_ACTION_BAR_ID], "LEFT", 0, 0)
    end

    Module.actionBars[POSSESS_ACTION_BAR_ID]:SetPoint("LEFT", Module.actionBars[SHAPESHIFT_ACTION_BAR_ID], "LEFT", 0, 0)
    Module.actionBars[MULTICAST_ACTION_BAR_ID]:SetPoint("LEFT", Module.actionBars[SHAPESHIFT_ACTION_BAR_ID], "LEFT", 0, 0)
end

local function MultiCastFlyoutFrameOpenButton_Show(self, type, parent)
    self:ClearAllPoints()
    self:SetPoint("BOTTOM", parent, "TOP", -1, 0)
    self:GetNormalTexture():SetTexCoord(31 / 64, 63 / 64, 10 / 64, 27 / 64)
end

local function MultiCastFlyoutFrame_ToggleFlyout(self, type, parent)
    local button = MultiCastFlyoutFrameCloseButton
    button:ClearAllPoints()
    button:SetPoint("BOTTOM", parent, "TOP", -1, 0)
    button:GetNormalTexture():SetTexCoord(31 / 64, 62 / 64, 37 / 64, 54 / 64)

    self:SetPoint("BOTTOM", parent, "TOP", 0, 15)
end

local function ReplaceBlizzardFlyoutButton(button, buttonSize, replaceUV)
    button:SetSize(buttonSize - 2, buttonSize - 2)

    local iconTexture = _G[button:GetName() .. "Icon"]
    iconTexture:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
    iconTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    if replaceUV then
        iconTexture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end
    iconTexture:SetDrawLayer('BACKGROUND')

    local highlightTexture = button:GetHighlightTexture()
    highlightTexture:SetAllPoints(button)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    highlightTexture:SetTexCoord(359 / 512, 451 / 512, 1065 / 2048, 1155 / 2048)

    button.border = button.border or button:CreateTexture(nil, "BORDER")
    local borderTexture = button.border
    borderTexture:SetAllPoints(button)
    borderTexture:SetPoint("TOPLEFT", -2, 2)
    borderTexture:SetPoint("BOTTOMRIGHT", 2, -2)
    borderTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
    borderTexture:SetTexCoord(359 / 512, 451 / 512, 649 / 2048, 739 / 2048)
end

local function MultiCastFlyoutFrame_LoadPageSpells(self)
    local buttons = self.buttons
    local numButtons = #buttons

    for index = 1, numButtons do
        local button = _G["MultiCastFlyoutButton" .. index]
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint("BOTTOM", _G["MultiCastFlyoutButton" .. index - 1], "TOP", 0, 6)
        else
            button:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
        end

        ReplaceBlizzardFlyoutButton(button, 32, true)
    end
end

local function MultiCastFlyoutFrame_LoadSlotSpells(self, slot, ...)
    local buttons = self.buttons
    local numButtons = #buttons

    for index = 1, numButtons do
        local button = _G["MultiCastFlyoutButton" .. index]
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint("BOTTOM", _G["MultiCastFlyoutButton" .. index - 1], "TOP", 0, 6)
        else
            button:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
        end

        ReplaceBlizzardFlyoutButton(button, 32, index ~= 1)
    end
end

local function MultiCastSummonSpellButton_Update(self)
    for index = 1, NUM_MULTI_CAST_BUTTONS_PER_PAGE do
        local button = _G['MultiCastSlotButton' .. index]
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint("LEFT", _G['MultiCastSlotButton' .. index - 1], "RIGHT", multiActionBarGap, 0)
        else
            button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", multiActionBarGap, 0)
        end
    end
end

local function MultiCastRecallSpellButton_Update(self)
    local activeSlots = MultiCastActionBarFrame.numActiveSlots
    if activeSlots > 0 then
        self:ClearAllPoints()
        self:SetPoint("LEFT", _G["MultiCastSlotButton" .. activeSlots], "RIGHT", multiActionBarGap, 0)
    end
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PET_BAR_UPDATE")

    self:SecureHook('ActionButton_ShowGrid', ActionButton_ShowGrid)
    self:SecureHook('ActionButton_Update', ActionButton_Update)
    self:SecureHook('ReputationWatchBar_Update', ReputationWatchBar_Update)
    self:SecureHook('MainMenuExpBar_Update', MainMenuExpBar_Update)
    self:SecureHook('ShapeshiftBar_Update', ShapeshiftBar_Update)
    self:SecureHook('MultiCastFlyoutFrameOpenButton_Show', MultiCastFlyoutFrameOpenButton_Show)
    self:SecureHook('MultiCastFlyoutFrame_ToggleFlyout', MultiCastFlyoutFrame_ToggleFlyout)
    self:SecureHook('MultiCastFlyoutFrame_LoadPageSpells', MultiCastFlyoutFrame_LoadPageSpells)
    self:SecureHook('MultiCastFlyoutFrame_LoadSlotSpells', MultiCastFlyoutFrame_LoadSlotSpells)
    self:SecureHook('MultiCastSummonSpellButton_Update', MultiCastSummonSpellButton_Update)
    self:SecureHook('MultiCastRecallSpellButton_Update', MultiCastRecallSpellButton_Update)

    -- Main
    self.actionBars[MAIN_ACTION_BAR_ID] = CreateActionFrameBar(MAIN_ACTION_BAR_ID, 12, 42, 4, false)

    for index = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G['ActionButton' .. index]
        button:SetAttribute('showgrid', 1)
        ActionButton_ShowGrid(button)
    end

    -- RepExp
    self.repExpBar = CreateUIFrame(self.actionBars[MAIN_ACTION_BAR_ID]:GetWidth(), 16, "RepExpBar")

    -- Bottom Side
    for index = 2, 3 do
        self.actionBars[index] = CreateActionFrameBar(index, 12, 42, 4, false)
    end

    -- Right Side
    for index = 4, 5 do
        self.actionBars[index] = CreateActionFrameBar(index, 12, 42, 6, true)
    end

    -- Bonus
    self.actionBars[BONUS_ACTION_BAR_ID] = CreateActionFrameBar(BONUS_ACTION_BAR_ID, 12, 42, 4, false)

    for index = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G['BonusActionButton' .. index]
        button:SetAttribute('showgrid', 1)
        ActionButton_ShowGrid(button)
    end

    -- Stance (Shapeshift)
    self.actionBars[SHAPESHIFT_ACTION_BAR_ID] = CreateActionFrameBar(SHAPESHIFT_ACTION_BAR_ID, 10, 40, 4, false)

    -- Possess
    self.actionBars[POSSESS_ACTION_BAR_ID] = CreateActionFrameBar(POSSESS_ACTION_BAR_ID, 2, 40, 4, false)

    -- Pet
    self.actionBars[PET_ACTION_BAR_ID] = CreateActionFrameBar(PET_ACTION_BAR_ID, 10, 36, 4, false)

    -- MultiCast
    self.actionBars[MULTICAST_ACTION_BAR_ID] = CreateActionFrameBar(MULTICAST_ACTION_BAR_ID, 6, 36, 6, false)

    -- Micro Menu
    self.microMenuBar = CreateActionFrameBar(nil, 10, 29, 2, false, 'MicroMenuBar')

    -- Bags
    self.bagsBar = CreateActionFrameBar(nil, 5, 50, 2, false, 'BagsBar')
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("PET_BAR_UPDATE")

    self:Unhook('ActionButton_ShowGrid', ActionButton_ShowGrid)
    self:Unhook('ActionButton_Update', ActionButton_Update)
    self:Unhook('ReputationWatchBar_Update', ReputationWatchBar_Update)
    self:Unhook('MainMenuExpBar_Update', MainMenuExpBar_Update)
    self:Unhook('ShapeshiftBar_Update', ShapeshiftBar_Update)
    self:Unhook('MultiCastFlyoutFrameOpenButton_Show', MultiCastFlyoutFrameOpenButton_Show)
    self:Unhook('MultiCastFlyoutFrame_ToggleFlyout', MultiCastFlyoutFrame_ToggleFlyout)
    self:Unhook('MultiCastFlyoutFrame_LoadPageSpells', MultiCastFlyoutFrame_LoadPageSpells)
    self:Unhook('MultiCastFlyoutFrame_LoadSlotSpells', MultiCastFlyoutFrame_LoadSlotSpells)
    self:Unhook('MultiCastSummonSpellButton_Update', MultiCastSummonSpellButton_Update)
    self:Unhook('MultiCastRecallSpellButton_Update', MultiCastRecallSpellButton_Update)
end

function Module:PLAYER_ENTERING_WORLD()
    RemoveBlizzardFrames()

    for _, actionBar in pairs(self.actionBars) do
        if actionBar.ID ~= PET_ACTION_BAR_ID and actionBar.ID ~= SHAPESHIFT_ACTION_BAR_ID and actionBar.ID ~= MULTICAST_ACTION_BAR_ID then
            ReplaceBlizzardActionBarFrame(actionBar)
        end
    end

    ReplaceBlizzardMultiActionBarFrame(self.actionBars[MULTICAST_ACTION_BAR_ID])
    ReplaceBlizzardRepExpBarFrame(self.repExpBar)
    ReplaceBlizzardMicroMenuBarFrame(self.microMenuBar)
    ReplaceBlizzardBagsBarFrame(self.bagsBar)

    local widgets = {
        'actionBar' .. 1,
        'actionBar' .. 2,
        'actionBar' .. 3,
        'actionBar' .. 4,
        'actionBar' .. 5,
        'actionBar' .. 6,
        'actionBar' .. 7,
        'actionBar' .. 8,
        'actionBar' .. 9,
        'actionBar' .. 10,
        'bagsBar',
        'microMenuBar',
        'repExpBar'
    }

    for _, widget in pairs(widgets) do
        if RUI.DB.profile.widgets[widget] == nil then
            self:LoadDefaultSettings()
            break
        end
    end

    self:UpdateWidgets()
end

local petBarInitialized = false

function Module:PET_BAR_UPDATE()
    if not petBarInitialized then
        ReplaceBlizzardActionBarFrame(self.actionBars[SHAPESHIFT_ACTION_BAR_ID])
        ReplaceBlizzardActionBarFrame(self.actionBars[PET_ACTION_BAR_ID])
    end

    petBarInitialized = true
end

function Module:EnableEditorPreview()
    local hideMainActionBarFrames = {
        MainMenuBarNineSlice,
        MainMenuBarPageNumber,
        MainMenuBarLeftEndCap,
        MainMenuBarRightEndCap,
        ActionBarUpButton,
        ActionBarDownButton
    }

    HideUIFrame(self.actionBars[MAIN_ACTION_BAR_ID], hideMainActionBarFrames)

    for index, actionBar in pairs(self.actionBars) do
        if index ~= MAIN_ACTION_BAR_ID and index ~= BONUS_ACTION_BAR_ID and index ~= PET_ACTION_BAR_ID and index ~= POSSESS_ACTION_BAR_ID and index ~= MULTICAST_ACTION_BAR_ID then
            HideUIFrame(actionBar)
        end
    end

    HideUIFrame(self.bagsBar)
    HideUIFrame(self.microMenuBar)
    HideUIFrame(self.repExpBar)
end

function Module:DisableEditorPreview()
    for index, actionBar in pairs(self.actionBars) do
        if index ~= BONUS_ACTION_BAR_ID and index ~= PET_ACTION_BAR_ID and index ~= POSSESS_ACTION_BAR_ID and index ~= MULTICAST_ACTION_BAR_ID then
            ShowUIFrame(actionBar)
            SaveUIFramePosition(actionBar, 'actionBar' .. index)
        end
    end

    ShowUIFrame(self.bagsBar)
    SaveUIFramePosition(self.bagsBar, 'bagsBar')

    ShowUIFrame(self.microMenuBar)
    SaveUIFramePosition(self.microMenuBar, 'microMenuBar')

    ShowUIFrame(self.repExpBar)
    SaveUIFramePosition(self.repExpBar, 'repExpBar')
end

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.actionBar = {}

    for index = 1, 3 do
        RUI.DB.profile.widgets['actionBar' .. index] = {
            anchor = "BOTTOM",
            posX = 0,
            posY = 60 + 4 * (index - 1) +
                42 * (index - 1)
        }
    end

    for index = 4, 5 do
        RUI.DB.profile.widgets['actionBar' .. index] = {
            anchor = "RIGHT",
            posX = -4 * (index - 4) - 42 * (index - 4),
            posY = -60
        }
    end

    RUI.DB.profile.widgets['actionBar' .. SHAPESHIFT_ACTION_BAR_ID] = {
        anchor = "BOTTOM",
        posX = -54,
        posY = 200
    }

    RUI.DB.profile.widgets.microMenuBar = { anchor = "BOTTOMRIGHT", posX = 50, posY = 10 }
    RUI.DB.profile.widgets.bagsBar = { anchor = "BOTTOMRIGHT", posX = 5, posY = 45 }
    RUI.DB.profile.widgets.repExpBar = { anchor = "BOTTOM", posX = 0, posY = 30 }

    -- Static
    RUI.DB.profile.widgets['actionBar' .. PET_ACTION_BAR_ID] = {
        anchor = "CENTER",
        posX = 0,
        posY = 0
    }

    RUI.DB.profile.widgets['actionBar' .. BONUS_ACTION_BAR_ID] = {
        anchor = "CENTER",
        posX = 0,
        posY = 0
    }

    RUI.DB.profile.widgets['actionBar' .. POSSESS_ACTION_BAR_ID] = {
        anchor = "CENTER",
        posX = 0,
        posY = 0
    }

    RUI.DB.profile.widgets['actionBar' .. MULTICAST_ACTION_BAR_ID] = {
        anchor = "CENTER",
        posX = 0,
        posY = 0
    }
end

function Module:UpdateWidgets()
    for index, actionBar in pairs(self.actionBars) do
        local widgetOptions = RUI.DB.profile.widgets['actionBar' .. index]
        actionBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = RUI.DB.profile.widgets.microMenuBar
        self.microMenuBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = RUI.DB.profile.widgets.bagsBar
        self.bagsBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = RUI.DB.profile.widgets.repExpBar
        self.repExpBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    -- Static
    do
        self.actionBars[BONUS_ACTION_BAR_ID]:SetPoint('LEFT', self.actionBars[MAIN_ACTION_BAR_ID], 'LEFT', 0, 0)
    end
end
