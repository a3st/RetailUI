local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local moduleName = 'ActionBar'
local Module = DFUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.actionBars = {}
Module.stanceBar = nil
Module.bonusActionBar = nil
Module.petActionBar = nil
Module.repExpBar = nil
Module.bagsBar = nil
Module.microMenuBar = nil

local function ShowBackgroundMainActionButton(button)
    local normalTexture = button:GetNormalTexture()
    if string.find(button:GetName(), 'ActionButton%d') then
        normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        normalTexture:SetVertexColor(1, 1, 1, 1)
    else
        normalTexture:SetAlpha(0)
    end
end

local function ActionButton_ShowGrid(button)
    ShowBackgroundMainActionButton(button)
    button:Show()
end

local function ActionButton_Update(button)
    ShowBackgroundMainActionButton(button)
end

local function ReputationWatchBar_Update()
    local factionInfo = GetWatchedFactionInfo();
    if factionInfo then
        local repWatchBar = ReputationWatchBar
        repWatchBar:SetHeight(16)
        repWatchBar:ClearAllPoints()
        repWatchBar:SetPoint("LEFT", Module.repExpBar, "LEFT", 4, 0)
    end
end

local function MainMenuExpBar_Update()
    local mainMenuExpBar = MainMenuExpBar
    mainMenuExpBar:SetHeight(16)
    mainMenuExpBar:ClearAllPoints()
    mainMenuExpBar:SetPoint("LEFT", Module.repExpBar, "LEFT", 4, 0)

    local repWatchBar = ReputationWatchBar
    if repWatchBar:IsShown() then
        mainMenuExpBar:SetPoint("LEFT", repWatchBar, "LEFT", 0, -22)
    else
        mainMenuExpBar:SetPoint("LEFT", Module.repExpBar, "LEFT", 4, 0)
    end
end

function PetActionBar_UpdatePositionValues()
    if Module.petActionBar == nil or Module.stanceBar == nil then return end

    if GetNumShapeshiftForms() > 0 then
        local shapeShiftActionButton = _G['ShapeshiftButton' .. GetNumShapeshiftForms()]
        Module.petActionBar:SetPoint("LEFT", shapeShiftActionButton, "RIGHT", 10, 0)
    else
        Module.petActionBar:SetPoint("LEFT", Module.stanceBar, "LEFT", 0, 0)
    end
end

function PetActionBarFrame_OnUpdate() end

function HidePetActionBar() end

function ShapeshiftBar_Update() end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("UPDATE_EXHAUSTION")

    self:SecureHook('ActionButton_ShowGrid', ActionButton_ShowGrid)
    self:SecureHook('ActionButton_Update', ActionButton_Update)
    self:SecureHook('ReputationWatchBar_Update', ReputationWatchBar_Update)
    self:SecureHook('MainMenuExpBar_Update', MainMenuExpBar_Update)

    self:CreateActionBars()
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("UPDATE_EXHAUSTION")

    self:Unhook('ActionButton_ShowGrid', ActionButton_ShowGrid)
    self:Unhook('ActionButton_Update', ActionButton_Update)
    self:Unhook('ReputationWatchBar_Update', ReputationWatchBar_Update)
    self:Unhook('MainMenuExpBar_Update', MainMenuExpBar_Update)
end

function Module:PLAYER_ENTERING_WORLD()
    self:RemoveBlizzardActionBarFrames()
    self:ReplaceBlizzardActionBarFrames()

    if DFUI.DB.profile.widgets.actionBar == nil or DFUI.DB.profile.widgets.bagsBar == nil or DFUI.DB.profile.widgets.expBar == nil or
        DFUI.DB.profile.widgets.microMenuBar == nil or DFUI.DB.profile.widgets.repBar == nil or DFUI.DB.profile.widgets.stanceBar == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

function Module:UPDATE_EXHAUSTION()
    local restStateID = GetRestState();

    restLevelBar = ExhaustionLevelFillBar
    restLevelBar:SetAllPoints(MainMenuExpBar)
    restLevelBar:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiexperiencebar.blp")
    restLevelBar:SetTexCoord(574 / 2048, 1136 / 2048, 1 / 64, 10 / 64)

    if restStateID == 1 then
        restLevelBar:SetVertexColor(0.0, 0, 1, 0.45)
    elseif restStateID == 2 then
        restLevelBar:SetVertexColor(0.58, 0.0, 0.55, 0.45)
    end

    ExhaustionTick:Hide()
end

local blizzActionBars = {
    'ActionButton',
    'MultiBarBottomLeftButton',
    'MultiBarBottomRightButton',
    'MultiBarRightButton',
    'MultiBarLeftButton',
    'BonusActionButton'
}

MAIN_ACTION_BAR_ID = 1
BONUS_ACTION_BAR_ID = 6

local function CreateActionFrameBar(barID, buttonCount, buttonSize, gap, vertical)
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

    local frameBar = CreateUIFrameBar(width, height, 'ActionBar' .. barID)

    frameBar.borderTextures = {}
    for index = 1, buttonCount do
        frameBar.borderTextures[index] = frameBar:CreateTexture(nil, 'OVERLAY')
    end

    frameBar.ID = barID
    frameBar.buttonSize = buttonSize
    frameBar.buttonCount = buttonCount
    frameBar.gap = gap
    frameBar.vertical = vertical

    return frameBar
end

function Module:ReplaceBlizzardActionBarFrame(frameBar)
    if frameBar.ID == MAIN_ACTION_BAR_ID then
        local leftEndCap = MainMenuBarLeftEndCap
        leftEndCap:ClearAllPoints()
        leftEndCap:SetPoint("RIGHT", frameBar, "LEFT", 6, 4)
        leftEndCap:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        leftEndCap:SetTexCoord(1 / 512, 357 / 512, 209 / 2048, 543 / 2048)
        leftEndCap:SetSize(92, 92)

        local rightEndCap = MainMenuBarRightEndCap
        rightEndCap:ClearAllPoints()
        rightEndCap:SetPoint("LEFT", frameBar, "RIGHT", -6, 4)
        rightEndCap:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        rightEndCap:SetTexCoord(1 / 512, 357 / 512, 545 / 2048, 879 / 2048)
        rightEndCap:SetSize(92, 92)

        local pageNumber = _G['MainMenuBarPageNumber']
        pageNumber:SetPoint("CENTER", frameBar, "LEFT", -18, 0)
        pageNumber:SetFontObject(GameFontNormal)

        local barUpButton = _G['ActionBarUpButton']
        barUpButton:SetPoint("CENTER", pageNumber, "CENTER", 0, 15)

        local normalTexture = barUpButton:GetNormalTexture()
        normalTexture:SetPoint("TOPLEFT", 7, -6)
        normalTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        normalTexture:SetTexCoord(359 / 512, 393 / 512, 833 / 2048, 861 / 2048)

        local pushedTexture = barUpButton:GetPushedTexture()
        pushedTexture:SetPoint("TOPLEFT", 7, -6)
        pushedTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        pushedTexture:SetTexCoord(453 / 512, 487 / 512, 679 / 2048, 707 / 2048)

        local highlightTexture = barUpButton:GetHighlightTexture()
        highlightTexture:SetPoint("TOPLEFT", 7, -6)
        highlightTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        highlightTexture:SetTexCoord(453 / 512, 487 / 512, 709 / 2048, 737 / 2048)

        local barDownButton = _G['ActionBarDownButton']
        barDownButton:SetPoint("CENTER", pageNumber, "CENTER", 0, -15)

        normalTexture = barDownButton:GetNormalTexture()
        normalTexture:SetPoint("TOPLEFT", 7, -6)
        normalTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        normalTexture:SetTexCoord(463 / 512, 497 / 512, 605 / 2048, 633 / 2048)

        pushedTexture = barDownButton:GetPushedTexture()
        pushedTexture:SetPoint("TOPLEFT", 7, -6)
        pushedTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        pushedTexture:SetTexCoord(463 / 512, 497 / 512, 545 / 2048, 573 / 2048)

        highlightTexture = barDownButton:GetHighlightTexture()
        highlightTexture:SetPoint("TOPLEFT", 7, -6)
        highlightTexture:SetPoint("BOTTOMRIGHT", -7, 6)
        highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
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

        if frameBar.ID == MAIN_ACTION_BAR_ID then
            normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            normalTexture:SetTexCoord(359 / 512, 487 / 512, 209 / 2048, 333 / 2048)
        else
            normalTexture:SetAlpha(0)
        end

        local highlightTexture = button:GetHighlightTexture()
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        highlightTexture:SetTexCoord(359 / 512, 451 / 512, 1065 / 2048, 1155 / 2048)

        local pushedTexture = button:GetPushedTexture()
        pushedTexture:SetAllPoints(button)
        pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        pushedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

        local checkedTexture = button:GetCheckedTexture()
        checkedTexture:SetAllPoints(button)
        checkedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        checkedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

        local icon = _G[button:GetName() .. "Icon"]
        icon:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
        icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        icon:SetDrawLayer('BORDER')

        local border = _G[button:GetName() .. "Border"]
        border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
        border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
        border:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        border:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)
        border:SetDrawLayer("OVERLAY")

        local flash = _G[button:GetName() .. "Flash"]
        flash:SetAllPoints(button)
        flash:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        flash:SetTexCoord(359 / 512, 451 / 512, 973 / 2048, 1063 / 2048)

        local count = _G[button:GetName() .. "Count"]
        count:SetPoint("BOTTOMRIGHT", -4, 3)

        local hotKey = _G[button:GetName() .. "HotKey"]
        hotKey:SetPoint("TOPLEFT", 4, -3)

        local cooldown = _G[button:GetName() .. "Cooldown"]
        cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
        cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

        local borderTexture = frameBar.borderTextures[index]
        borderTexture:SetParent(button)
        borderTexture:SetAllPoints(button)
        borderTexture:SetPoint("TOPLEFT", -2, 2)
        borderTexture:SetPoint("BOTTOMRIGHT", 2, -2)
        borderTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        borderTexture:SetTexCoord(359 / 512, 451 / 512, 649 / 2048, 739 / 2048)
    end
end

local function CreatePetActionBar(buttonSize, gap)
    local buttonCount = 10
    local width = gap * (buttonCount - 1) + ((buttonSize - 2) * buttonCount) + 8
    local height = (buttonSize - 2) + 8

    local petActionBar = CreateFrame("Frame", 'DFUI_PetActionBar', UIParent)
    petActionBar:SetSize(width, height)
    petActionBar:RegisterForDrag("LeftButton")
    petActionBar:EnableMouse(false)
    petActionBar:SetMovable(false)
    petActionBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    petActionBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = petActionBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(petActionBar)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        petActionBar.editorTexture = texture

        local fontString = petActionBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Stance Bar Frame")
        fontString:Hide()

        petActionBar.editorText = fontString
    end

    petActionBar.buttons = {}
    for index = 1, buttonCount do
        local button = _G['PetActionButton' .. index]
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint("LEFT", _G['PetActionButton' .. index - 1], "RIGHT", gap, 0)
        else
            button:SetPoint("LEFT", petActionBar, "LEFT", 4, 0)
        end

        button:SetSize(buttonSize - 2, buttonSize - 2)

        local normalTexture = button:GetNormalTexture()
        normalTexture:SetAllPoints(button)
        normalTexture:SetPoint("TOPLEFT", -2, 2)
        normalTexture:SetPoint("BOTTOMRIGHT", 2, -2)
        normalTexture:SetAlpha(0)

        local highlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        highlightTexture:SetTexCoord(359 / 512, 451 / 512, 1065 / 2048, 1155 / 2048)

        button:SetHighlightTexture(highlightTexture)

        local pushedTexture = button:CreateTexture(nil, "OVERLAY")
        pushedTexture:SetAllPoints(button)
        pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        pushedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

        button:SetPushedTexture(pushedTexture)

        local checkedTexture = button:CreateTexture(nil, "OVERLAY")
        checkedTexture:SetAllPoints(button)
        checkedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        checkedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

        button:SetCheckedTexture(checkedTexture)

        local icon = _G[button:GetName() .. "Icon"]
        if icon then
            icon:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
            icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            icon:SetDrawLayer('BORDER')
        end

        local flash = _G[button:GetName() .. "Flash"]
        if flash then
            flash:SetAllPoints(button)
            flash:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            flash:SetTexCoord(359 / 512, 451 / 512, 973 / 2048, 1063 / 2048)
        end

        local count = _G[button:GetName() .. "Count"]
        if count then
            count:SetPoint("BOTTOMRIGHT", -4, 3)
        end

        local hotKey = _G[button:GetName() .. "HotKey"]
        if hotKey then
            hotKey:SetPoint("TOPLEFT", 4, -3)
        end

        local cooldown = _G[button:GetName() .. "Cooldown"]
        if cooldown then
            cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
            cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
        end

        do
            local texture = button:CreateTexture(nil, 'BACKGROUND')
            texture:SetAllPoints(button)
            texture:SetPoint("TOPLEFT", -2, 2)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(359 / 512, 487 / 512, 209 / 2048, 333 / 2048)

            button.background = texture
        end

        do
            local texture = button:CreateTexture(nil, 'OVERLAY')
            texture:SetAllPoints(button)
            texture:SetPoint("TOPLEFT", -2, 2)
            texture:SetPoint("BOTTOMRIGHT", 2, -2)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(359 / 512, 451 / 512, 649 / 2048, 739 / 2048)
        end

        tinsert(petActionBar.buttons, button)
    end

    return petActionBar
end

local function CreateStanceBar(buttonSize, gap)
    local buttonCount = 10
    local width = gap * (buttonCount - 1) + ((buttonSize - 2) * buttonCount) + 8
    local height = (buttonSize - 2) + 8

    local stanceBar = CreateFrame("Frame", 'DFUI_StanceBar', UIParent)
    stanceBar:SetSize(width, height)
    stanceBar:RegisterForDrag("LeftButton")
    stanceBar:EnableMouse(false)
    stanceBar:SetMovable(false)
    stanceBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    stanceBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = stanceBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(stanceBar)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        stanceBar.editorTexture = texture

        local fontString = stanceBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Stance Bar Frame")
        fontString:Hide()

        stanceBar.editorText = fontString
    end

    stanceBar.buttons = {}
    for index = 1, buttonCount do
        local button = _G['ShapeshiftButton' .. index]
        button:ClearAllPoints()

        if index > 1 then
            button:SetPoint("LEFT", _G['ShapeshiftButton' .. index - 1], "RIGHT", gap, 0)
        else
            button:SetPoint("LEFT", stanceBar, "LEFT", 4, 0)
        end

        button:SetSize(buttonSize - 2, buttonSize - 2)

        local normalTexture = button:GetNormalTexture()
        normalTexture:SetAllPoints(button)
        normalTexture:SetPoint("TOPLEFT", -2, 2)
        normalTexture:SetPoint("BOTTOMRIGHT", 2, -2)
        normalTexture:SetAlpha(0)

        local highlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        highlightTexture:SetTexCoord(359 / 512, 451 / 512, 1065 / 2048, 1155 / 2048)

        button:SetHighlightTexture(highlightTexture)

        local pushedTexture = button:CreateTexture(nil, "OVERLAY")
        pushedTexture:SetAllPoints(button)
        pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        pushedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

        button:SetPushedTexture(pushedTexture)

        local checkedTexture = button:CreateTexture(nil, "OVERLAY")
        checkedTexture:SetAllPoints(button)
        checkedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        checkedTexture:SetTexCoord(359 / 512, 451 / 512, 881 / 2048, 971 / 2048)

        button:SetCheckedTexture(checkedTexture)

        local icon = _G[button:GetName() .. "Icon"]
        if icon then
            icon:SetPoint("TOPLEFT", button, "TOPLEFT", -1, -1)
            icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            icon:SetDrawLayer('BORDER')
        end

        local flash = _G[button:GetName() .. "Flash"]
        if flash then
            flash:SetAllPoints(button)
            flash:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            flash:SetTexCoord(359 / 512, 451 / 512, 973 / 2048, 1063 / 2048)
        end

        local count = _G[button:GetName() .. "Count"]
        if count then
            count:SetPoint("BOTTOMRIGHT", -4, 3)
        end

        local hotKey = _G[button:GetName() .. "HotKey"]
        if hotKey then
            hotKey:SetPoint("TOPLEFT", 4, -3)
        end

        local cooldown = _G[button:GetName() .. "Cooldown"]
        if cooldown then
            cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
            cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
        end

        do
            local texture = button:CreateTexture(nil, 'BACKGROUND')
            texture:SetAllPoints(button)
            texture:SetPoint("TOPLEFT", -2, 2)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(359 / 512, 487 / 512, 209 / 2048, 333 / 2048)

            button.background = texture
        end

        do
            local texture = button:CreateTexture(nil, 'OVERLAY')
            texture:SetAllPoints(button)
            texture:SetPoint("TOPLEFT", -2, 2)
            texture:SetPoint("BOTTOMRIGHT", 2, -2)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(359 / 512, 451 / 512, 649 / 2048, 739 / 2048)
        end

        tinsert(stanceBar.buttons, button)
    end

    return stanceBar
end

local function CreateActionBar(barID, buttonCount, buttonSize, gap, vertical)
    if buttonCount > 12 then
        assert(nil, "The Action Bar cannot contain more than 12 buttons")
    end

    local width
    local height

    if vertical then
        width = (buttonSize - 2) + 8
        height = gap * (buttonCount - 1) + ((buttonSize - 2) * buttonCount) + 8
    else
        width = gap * (buttonCount - 1) + ((buttonSize - 2) * buttonCount) + 8
        height = (buttonSize - 2) + 8
    end

    local actionBar = CreateFrame("Frame", 'DFUI_ActionBar' .. barID, UIParent)
    actionBar:SetSize(width, height)
    actionBar:RegisterForDrag("LeftButton")
    actionBar:EnableMouse(false)
    actionBar:SetMovable(false)
    actionBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    actionBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = actionBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(actionBar)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        actionBar.editorTexture = texture

        local fontString = actionBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Action Bar " .. barID .. " Frame")
        fontString:Hide()

        actionBar.editorText = fontString
    end

    if barID == 1 and not vertical then
        local nineSliceFrame = CreateFrame("Frame", nil, actionBar)
        nineSliceFrame:SetAllPoints(actionBar)

        do
            local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("TOPLEFT", 10, 3)
            texture:SetPoint("TOPRIGHT", -10, 3)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(0, 32 / 512, 145 / 2048, 177 / 2048)
            texture:SetHorizTile(true)
            texture:SetSize(width, 20)
        end

        do
            local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("BOTTOMLEFT", 10, -4)
            texture:SetPoint("BOTTOMRIGHT", -10, -4)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(0, 32 / 512, 97 / 2048, 143 / 2048)
            texture:SetHorizTile(true)
            texture:SetSize(width, 20)
        end

        do
            local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("TOPLEFT", -2, 3)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(463 / 512, 497 / 512, 475 / 2048, 507 / 2048)
            texture:SetSize(20, 20)
        end

        do
            local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("TOPLEFT", -2, -10)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(465 / 512, 499 / 512, 383 / 2048, 405 / 2048)
            texture:SetSize(20, height / 2)
        end

        do
            local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("BOTTOMLEFT", -2, -4)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(465 / 512, 499 / 512, 383 / 2048, 429 / 2048)
            texture:SetSize(20, 20)
        end

        do
            local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("TOPRIGHT", 3, 3)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(463 / 512, 507 / 512, 441 / 2048, 473 / 2048)
            texture:SetSize(20, 20)
        end

        do
            local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("TOPRIGHT", 3, -10)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(465 / 512, 509 / 512, 335 / 2048, 359 / 2048)
            texture:SetSize(20, height / 2)
        end

        do
            local texture = nineSliceFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("BOTTOMRIGHT", 3, -4)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
            texture:SetTexCoord(465 / 512, 509 / 512, 335 / 2048, 381 / 2048)
            texture:SetSize(20, 20)
        end

        actionBar.nineSliceFrame = nineSliceFrame
    end

    actionBar.buttons = {}


    return actionBar
end

local function CreateRepExpBar(width)
    local width = width + 8
    local height = 32 + 8 + 4

    local repExpBar = CreateFrame("Frame", 'DFUI_RepExpBar', UIParent)
    repExpBar:SetSize(width, height)

    repExpBar:RegisterForDrag("LeftButton")
    repExpBar:EnableMouse(false)
    repExpBar:SetMovable(false)
    repExpBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    repExpBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = repExpBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(repExpBar)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        repExpBar.editorTexture = texture

        local fontString = repExpBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Status Bar Frame")
        fontString:Hide()

        repExpBar.editorText = fontString
    end

    local expStatusBar = MainMenuExpBar
    expStatusBar:ClearAllPoints()
    expStatusBar:SetWidth(width)

    for _, region in pairs { expStatusBar:GetRegions() } do
        if region:GetObjectType() == 'Texture' and region:GetDrawLayer() == 'BACKGROUND' then
            region:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiexperiencebar.blp")
            region:SetTexCoord(0.00088878125, 570 / 2048, 20 / 64, 29 / 64)
        end
    end

    do
        local texture = expStatusBar:CreateTexture(nil, 'OVERLAY')
        texture:SetAllPoints(expStatusBar)
        texture:SetPoint("TOPLEFT", expStatusBar, "TOPLEFT", -3, 3)
        texture:SetPoint("BOTTOMRIGHT", expStatusBar, "BOTTOMRIGHT", 3, -6)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiexperiencebar.blp")
        texture:SetTexCoord(1 / 2048, 572 / 2048, 1 / 64, 18 / 64)
    end

    --[[do
        local statusBarTexture = expStatusBar:CreateTexture(nil, 'BORDER')
        statusBarTexture:SetAllPoints(expStatusBar)
        statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\statusbarfill.blp")
        statusBarTexture:SetTexCoord(574 / 2048, 1137 / 2048, 34 / 64, 43 / 64)

        expStatusBar:SetStatusBarTexture(statusBarTexture)
    end]]

    local repWatchBar = ReputationWatchBar
    repWatchBar:ClearAllPoints()
    repWatchBar:SetWidth(width)

    local repStatusBar = ReputationWatchStatusBar
    repStatusBar:SetWidth(width)
    repStatusBar:SetAllPoints(repWatchBar)

    local background = _G[repStatusBar:GetName() .. "Background"]
    if background then
        background:SetAllPoints(repStatusBar)
        background:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiexperiencebar.blp")
        background:SetTexCoord(0.00088878125, 570 / 2048, 20 / 64, 29 / 64)
    end

    do
        local texture = repStatusBar:CreateTexture(nil, 'OVERLAY')
        texture:SetAllPoints(repStatusBar)
        texture:SetPoint("TOPLEFT", repStatusBar, "TOPLEFT", -3, 3)
        texture:SetPoint("BOTTOMRIGHT", repStatusBar, "BOTTOMRIGHT", 3, -6)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiexperiencebar.blp")
        texture:SetTexCoord(1 / 2048, 572 / 2048, 1 / 64, 18 / 64)
    end

    --[[do
        local statusBarTexture = repStatusBar:CreateTexture(nil, 'BORDER')
        statusBarTexture:SetAllPoints(repStatusBar)
        statusBarTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\statusbarfill.blp")
        statusBarTexture:SetTexCoord(0.05, 0.95, 0.05, 0.95)

        repStatusBar:SetStatusBarTexture(statusBarTexture)
    end]]

    return repExpBar
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

local function CreateMicroMenuBar(gap)
    local width = gap * (#microMenuButtons - 1) + (21 * #microMenuButtons) + 8
    local height = 29 + 8

    local microMenuBar = CreateFrame("Frame", 'DFUI_MicroMenuBar', UIParent)
    microMenuBar:SetSize(width, height)

    microMenuBar:RegisterForDrag("LeftButton")
    microMenuBar:EnableMouse(false)
    microMenuBar:SetMovable(false)
    microMenuBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    microMenuBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = microMenuBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(microMenuBar)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        microMenuBar.editorTexture = texture

        local fontString = microMenuBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("MicroMenu Bar Frame")
        fontString:Hide()

        microMenuBar.editorText = fontString
    end

    local lastElement = nil

    for index, button in pairs(microMenuButtons) do
        button:ClearAllPoints()

        if lastElement then
            button:SetPoint("LEFT", lastElement, "RIGHT", gap, 0)
        else
            button:SetPoint("LEFT", microMenuBar, "LEFT", 4, 0)
        end

        lastElement = button

        button:SetSize(21, 29)
        button:SetHitRectInsets(0, 0, 0, 0)

        local normalTexture = button:CreateTexture(nil, "OVERLAY")
        normalTexture:SetAllPoints(button)
        normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uimicromenu2x.blp")
        normalTexture:SetTexCoord(microMenuStyles[index].normalTexture.left, microMenuStyles[index].normalTexture.right,
            microMenuStyles[index].normalTexture.top, microMenuStyles[index].normalTexture.bottom)

        button:SetNormalTexture(normalTexture)

        local highlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uimicromenu2x.blp")
        highlightTexture:SetTexCoord(microMenuStyles[index].highlightTexture.left,
            microMenuStyles[index].highlightTexture.right, microMenuStyles[index].highlightTexture.top,
            microMenuStyles[index].highlightTexture.bottom)

        button:SetHighlightTexture(highlightTexture)

        local pushedTexture = button:CreateTexture(nil, "OVERLAY")
        pushedTexture:SetAllPoints(button)
        pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uimicromenu2x.blp")
        pushedTexture:SetTexCoord(microMenuStyles[index].pushedTexture.left,
            microMenuStyles[index].pushedTexture.right, microMenuStyles[index].pushedTexture.top,
            microMenuStyles[index].pushedTexture.bottom)

        button:SetPushedTexture(pushedTexture)

        if microMenuStyles[index].disabledTexture ~= nil then
            local disabledTexture = button:CreateTexture(nil, "OVERLAY")
            disabledTexture:SetAllPoints(button)
            disabledTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uimicromenu2x.blp")
            disabledTexture:SetTexCoord(microMenuStyles[index].disabledTexture.left,
                microMenuStyles[index].disabledTexture.right, microMenuStyles[index].disabledTexture.top,
                microMenuStyles[index].disabledTexture.bottom)

            button:SetDisabledTexture(disabledTexture)
        end
    end

    local portrait = MicroButtonPortrait
    portrait:Hide()

    local fraction = _G['PVPMicroButton' .. "Texture"]
    if fraction then
        fraction:Hide()
    end

    do
        local texture = microMenuBar:CreateTexture(nil, "OVERLAY")
        texture:SetPoint("CENTER", MainMenuMicroButton, "BOTTOM", 3, -4)
        texture:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-PerformanceBar.blp")
        texture:SetSize(14, 7)

        microMenuBar.performanceBar = texture
    end

    microMenuBar.updateInterval = 0

    microMenuBar:SetScript('OnUpdate', function(self, elapsed)
        local PERFORMANCEBAR_LOW_LATENCY = 300
        local PERFORMANCEBAR_MEDIUM_LATENCY = 600
        local PERFORMANCEBAR_UPDATE_INTERVAL = 10

        if (self.updateInterval > 0) then
            self.updateInterval = self.updateInterval - elapsed;
        else
            self.updateInterval = PERFORMANCEBAR_UPDATE_INTERVAL;
            local bandwidthIn, bandwidthOut, latency = GetNetStats();
            if (latency > PERFORMANCEBAR_MEDIUM_LATENCY) then
                self.performanceBar:SetVertexColor(1, 0, 0);
            elseif (latency > PERFORMANCEBAR_LOW_LATENCY) then
                self.performanceBar:SetVertexColor(1, 1, 0);
            else
                self.performanceBar:SetVertexColor(0, 1, 0);
            end
            if (self.hover) then
                MainMenuBarPerformanceBarFrame_OnEnter(self);
            end
        end
    end)

    return microMenuBar
end

local bagSlotButtons = {
    KeyRingButton,
    CharacterBag3Slot,
    CharacterBag2Slot,
    CharacterBag1Slot,
    CharacterBag0Slot
}

local function CreateBagsBar(gap)
    local width = gap * 5 + (32 * 5) + 50 + 8
    local height = 50 + 8

    local bagsBar = CreateFrame("Frame", 'DFUI_BagsBar', UIParent)
    bagsBar:SetSize(width, height)

    bagsBar:RegisterForDrag("LeftButton")
    bagsBar:EnableMouse(false)
    bagsBar:SetMovable(false)
    bagsBar:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    bagsBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    do
        local texture = bagsBar:CreateTexture(nil, 'BACKGROUND')
        texture:SetAllPoints(bagsBar)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\uiactionbar2x_new.blp")
        texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
        texture:Hide()

        bagsBar.editorTexture = texture

        local fontString = bagsBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
        fontString:SetAllPoints(texture)
        fontString:SetText("Bags Frame")
        fontString:Hide()

        bagsBar.editorText = fontString
    end

    local lastElement = nil

    for _, button in pairs(bagSlotButtons) do
        button:ClearAllPoints()

        if lastElement then
            button:SetPoint("LEFT", lastElement, "RIGHT", gap, 0)
        else
            button:SetPoint("LEFT", bagsBar, "LEFT", 4, 0)
        end

        lastElement = button

        button:SetSize(32, 32)

        button:SetNormalTexture('')
        button:SetPushedTexture(nil)

        local highlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\bagslots2x.blp")
        highlightTexture:SetTexCoord(358 / 512, 419 / 512, 1 / 128, 62 / 128)

        button:SetHighlightTexture(highlightTexture)

        local checkedTexture = button:CreateTexture(nil, "OVERLAY")
        checkedTexture:SetAllPoints(button)
        checkedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\bagslots2x.blp")
        checkedTexture:SetTexCoord(358 / 512, 419 / 512, 1 / 128, 62 / 128)

        button:SetCheckedTexture(checkedTexture)

        local icon = _G[button:GetName() .. 'IconTexture']
        if icon then
            icon:ClearAllPoints()
            icon:SetPoint('TOPLEFT', 6, -5)
            icon:SetPoint('BOTTOMRIGHT', -7, 7)
            icon:SetTexCoord(.08, .92, .08, .92)
            icon:SetDrawLayer('BACKGROUND')
        end

        do
            local texture = button:CreateTexture(nil, 'BORDER')
            texture:SetAllPoints(button)

            if button:GetName() == 'KeyRingButton' then
                texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\bagslots2key.blp")
                texture:SetTexCoord(3 / 128, 63 / 128, 64 / 128, 125 / 128)
            else
                texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\bagslots2x.blp")
                texture:SetTexCoord(295 / 512, 356 / 512, 1 / 128, 62 / 128)
            end
        end
    end

    do
        local button = MainMenuBarBackpackButton
        button:ClearAllPoints()
        button:SetPoint("CENTER", lastElement, "RIGHT", gap + 25, 0)

        button:SetSize(50, 50)

        button:SetNormalTexture(nil)
        button:SetPushedTexture(nil)

        local highlightTexture = button:CreateTexture(nil, "OVERLAY")
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\bagslots2x.blp")
        highlightTexture:SetTexCoord(99 / 512, 195 / 512, 1 / 128, 97 / 128)

        button:SetCheckedTexture(highlightTexture)
        button:SetHighlightTexture(highlightTexture)

        lastElement = button
    end

    MainMenuBarBackpackButtonIconTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\bagslots2x.blp")
    MainMenuBarBackpackButtonIconTexture:SetTexCoord(1 / 512, 97 / 512, 1 / 128, 97 / 128)

    return bagsBar
end

local blizzActionBarFrames = {
    MainMenuBarTexture0,
    MainMenuBarTexture1,
    MainMenuBarTexture2,
    MainMenuBarTexture3,
    MainMenuBarMaxLevelBar,
    ReputationXPBarTexture0,
    ReputationXPBarTexture1,
    ReputationXPBarTexture2,
    ReputationXPBarTexture3,
    ReputationWatchBarTexture0,
    ReputationWatchBarTexture1,
    ReputationWatchBarTexture2,
    ReputationWatchBarTexture3,
    MainMenuBarPerformanceBar,
    MainMenuXPBarTexture0,
    MainMenuXPBarTexture1,
    MainMenuXPBarTexture2,
    MainMenuXPBarTexture3,
    SlidingActionBarTexture0,
    SlidingActionBarTexture1,
    BonusActionBarTexture0,
    BonusActionBarTexture1,
    ShapeshiftBarLeft,
    ShapeshiftBarMiddle,
    ShapeshiftBarRight
}

function Module:RemoveBlizzardActionBarFrames()
    for _, frame in pairs(blizzActionBarFrames) do
        frame:SetAlpha(0)
    end

    MainMenuBar:EnableMouse(false)
    ShapeshiftBarFrame:EnableMouse(false)
end

local hideMainActionBarFrames = {
    MainMenuBarPageNumber,
    MainMenuBarLeftEndCap,
    MainMenuBarRightEndCap,
    ActionBarUpButton,
    ActionBarDownButton
}

function Module:EnableEditorPreviewForActionBars()
    for index, actionBar in pairs(self.actionBars) do
        actionBar:SetMovable(true)
        actionBar:EnableMouse(true)

        actionBar.editorTexture:Show()
        actionBar.editorText:Show()

        if index == 1 then
            ---actionBar.nineSliceFrame:Hide()
            for _, frame in pairs(hideMainActionBarFrames) do
                frame:SetAlpha(0)
            end
        end

        for index = 1, actionBar.buttonCount do
            local button = _G[blizzActionBars[actionBar.ID] .. index]
            button:SetAlpha(0)
            button:EnableMouse(false)
        end
    end
end

function Module:DisableEditorPreviewForActionBars()
    for index, actionBar in pairs(self.actionBars) do
        actionBar:SetMovable(false)
        actionBar:EnableMouse(false)

        actionBar.editorTexture:Hide()
        actionBar.editorText:Hide()

        if index == 1 then
            --actionBar.nineSliceFrame:Show()
            for _, frame in pairs(hideMainActionBarFrames) do
                frame:SetAlpha(1)
            end
        end

        for index = 1, actionBar.buttonCount do
            local button = _G[blizzActionBars[actionBar.ID] .. index]
            button:SetAlpha(1)
            button:EnableMouse(true)
        end

        local _, _, relativePoint, posX, posY = actionBar:GetPoint('CENTER')
        DFUI.DB.profile.widgets.actionBar[index].anchor = relativePoint
        DFUI.DB.profile.widgets.actionBar[index].posX = posX
        DFUI.DB.profile.widgets.actionBar[index].posY = posY
    end
end

local hideBagSlotButtons = {
    MainMenuBarBackpackButton,
    CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,
    KeyRingButton
}

function Module:EnableEditorPreviewForBags()
    local bagsBar = self.bagsBar

    bagsBar:SetMovable(true)
    bagsBar:EnableMouse(true)

    bagsBar.editorTexture:Show()
    bagsBar.editorText:Show()

    for _, button in pairs(hideBagSlotButtons) do
        button:SetAlpha(0)
        button:EnableMouse(false)
    end
end

function Module:DisableEditorPreviewForBags()
    local bagsBar = self.bagsBar

    bagsBar:SetMovable(false)
    bagsBar:EnableMouse(false)

    bagsBar.editorTexture:Hide()
    bagsBar.editorText:Hide()

    for _, button in pairs(hideBagSlotButtons) do
        button:SetAlpha(1)
        button:EnableMouse(true)
    end

    local _, _, relativePoint, posX, posY = bagsBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.bagsBar.anchor = relativePoint
    DFUI.DB.profile.widgets.bagsBar.posX = posX
    DFUI.DB.profile.widgets.bagsBar.posY = posY
end

local hideMicroMenuButtons = {
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

function Module:EnableEditorPreviewForMicroMenuBar()
    local microMenuBar = self.microMenuBar

    microMenuBar:SetMovable(true)
    microMenuBar:EnableMouse(true)

    microMenuBar.editorTexture:Show()
    microMenuBar.editorText:Show()

    for _, button in pairs(hideMicroMenuButtons) do
        button:SetAlpha(0)
        button:EnableMouse(false)
    end

    microMenuBar.performanceBar:Hide()
end

function Module:DisableEditorPreviewForMicroMenuBar()
    local microMenuBar = self.microMenuBar

    microMenuBar:SetMovable(false)
    microMenuBar:EnableMouse(false)

    microMenuBar.editorTexture:Hide()
    microMenuBar.editorText:Hide()

    for _, button in pairs(hideMicroMenuButtons) do
        button:SetAlpha(1)
        button:EnableMouse(true)
    end

    microMenuBar.performanceBar:Show()

    local _, _, relativePoint, posX, posY = microMenuBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.microMenuBar.anchor = relativePoint
    DFUI.DB.profile.widgets.microMenuBar.posX = posX
    DFUI.DB.profile.widgets.microMenuBar.posY = posY
end

function Module:EnableEditorPreviewForRepExpBar()
    local repExpBar = self.repExpBar

    repExpBar:SetMovable(true)
    repExpBar:EnableMouse(true)

    repExpBar.editorTexture:Show()
    repExpBar.editorText:Show()

    ReputationWatchBar:SetAlpha(0)
    ReputationWatchBar:EnableMouse(false)
    MainMenuExpBar:SetAlpha(0)
    MainMenuExpBar:EnableMouse(false)
end

function Module:DisableEditorPreviewForRepExpBar()
    local repExpBar = self.repExpBar

    repExpBar:SetMovable(false)
    repExpBar:EnableMouse(false)

    repExpBar.editorTexture:Hide()
    repExpBar.editorText:Hide()

    ReputationWatchBar:SetAlpha(1)
    ReputationWatchBar:EnableMouse(true)
    MainMenuExpBar:SetAlpha(1)
    MainMenuExpBar:EnableMouse(true)

    local _, _, relativePoint, posX, posY = repExpBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.repExpBar.anchor = relativePoint
    DFUI.DB.profile.widgets.repExpBar.posX = posX
    DFUI.DB.profile.widgets.repExpBar.posY = posY
end

function Module:EnableEditorPreviewForStanceBar()
    local stanceBar = self.stanceBar
    stanceBar:SetMovable(true)
    stanceBar:EnableMouse(true)

    stanceBar.editorTexture:Show()
    stanceBar.editorText:Show()

    for _, button in pairs(stanceBar.buttons) do
        button:SetAlpha(0)
        button:EnableMouse(false)
    end

    for _, button in pairs(self.petActionBar.buttons) do
        button:SetAlpha(0)
        button:EnableMouse(false)
    end
end

function Module:DisableEditorPreviewForStanceBar()
    local stanceBar = self.stanceBar
    stanceBar:SetMovable(false)
    stanceBar:EnableMouse(false)

    stanceBar.editorTexture:Hide()
    stanceBar.editorText:Hide()

    for _, button in pairs(stanceBar.buttons) do
        button:SetAlpha(1)
        button:EnableMouse(true)
    end

    for _, button in pairs(self.petActionBar.buttons) do
        button:SetAlpha(1)
        button:EnableMouse(true)
    end

    local _, _, relativePoint, posX, posY = stanceBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.stanceBar.anchor = relativePoint
    DFUI.DB.profile.widgets.stanceBar.posX = posX
    DFUI.DB.profile.widgets.stanceBar.posY = posY
end

function Module:ReplaceBlizzardActionBarFrames()
    for _, actionBar in pairs(self.actionBars) do
        self:ReplaceBlizzardActionBarFrame(actionBar)
    end
end

function Module:CreateActionBars()
    self.actionBars[1] = CreateActionFrameBar(1, 12, 42, 4, false)

    for index = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G['ActionButton' .. index]
        button:SetAttribute('showgrid', 1)
        ActionButton_ShowGrid(button)
    end

    for index = 2, 3 do
        self.actionBars[index] = CreateActionFrameBar(index, 12, 42, 4, false)
    end

    for index = 4, 5 do
        self.actionBars[index] = CreateActionFrameBar(index, 12, 42, 6, true)
    end

    -- Bonus Actions
    --self.bonusActionBar = CreateActionBar(6, 12, 42, 4, false)
    --for _, button in pairs(self.bonusActionBar.buttons) do
    --    button:SetAttribute('showgrid', 1)
    --    ActionButton_ShowGrid(button)
    --end

    --self.stanceBar = CreateStanceBar(40, 4)
    --self.repExpBar = CreateRepExpBar(self.actionBars[1]:GetWidth() - 10)
    --self.microMenuBar = CreateMicroMenuBar(2)
    --self.bagsBar = CreateBagsBar(2)
    --self.petActionBar = CreatePetActionBar(36, 4)
end

function Module:LoadDefaultSettings()
    DFUI.DB.profile.widgets.actionBar = {}

    for index = 1, 3 do
        DFUI.DB.profile.widgets.actionBar[index] = {
            anchor = "BOTTOM",
            posX = 0,
            posY = 60 + 4 * (index - 1) +
                42 * (index - 1)
        }
    end

    for index = 4, 5 do
        DFUI.DB.profile.widgets.actionBar[index] = {
            anchor = "RIGHT",
            posX = -4 * (index - 4) - 42 * (index - 4),
            posY = -40
        }
    end

    DFUI.DB.profile.widgets.stanceBar = { anchor = "BOTTOM", posX = -54, posY = 200 }
    DFUI.DB.profile.widgets.microMenuBar = { anchor = "BOTTOMRIGHT", posX = -5, posY = 5 }
    DFUI.DB.profile.widgets.bagsBar = { anchor = "BOTTOMRIGHT", posX = -5, posY = 45 }
    DFUI.DB.profile.widgets.repExpBar = { anchor = "BOTTOM", posX = 0, posY = 20 }
end

function Module:UpdateWidgets()
    for index, actionBar in pairs(self.actionBars) do
        local widgetOptions = DFUI.DB.profile.widgets.actionBar[index]
        actionBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    -- Bonus Actions
    --[[do
        local widgetOptions = DFUI.DB.profile.widgets.actionBar[1]
        self.bonusActionBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = DFUI.DB.profile.widgets.microMenuBar
        self.microMenuBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = DFUI.DB.profile.widgets.bagsBar
        self.bagsBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = DFUI.DB.profile.widgets.repExpBar
        self.repExpBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end

    do
        local widgetOptions = DFUI.DB.profile.widgets.stanceBar
        self.stanceBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end]] --
end
