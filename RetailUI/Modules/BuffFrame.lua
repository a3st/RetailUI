local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'BuffFrame'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.buffFrame = nil
Module.toggleBuffs = true

local function ReplaceBlizzardFrame(frame)
    frame.toggleButton = frame.toggleButton or CreateFrame('Button', nil, UIParent)
    local toggleButton = frame.toggleButton
    toggleButton:SetPoint("RIGHT", frame, "RIGHT", 0, -3)

    toggleButton:SetSize(13, 24)
    toggleButton:SetHitRectInsets(0, 0, 0, 0)

    local normalTexture = toggleButton:GetNormalTexture() or toggleButton:CreateTexture(nil, "BORDER")
    normalTexture:SetAllPoints(toggleButton)
    normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CollapseButton.blp")
    normalTexture:SetTexCoord(5 / 64, 22 / 64, 31 / 64, 62 / 64)

    toggleButton:SetNormalTexture(normalTexture)

    local highlightTexture = toggleButton:GetHighlightTexture() or toggleButton:CreateTexture(nil, "HIGHLIGHT")
    highlightTexture:SetAllPoints(toggleButton)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-CollapseButton.blp")
    highlightTexture:SetTexCoord(5 / 64, 22 / 64, 31 / 64, 62 / 64)

    toggleButton:SetHighlightTexture(highlightTexture)

    toggleButton:SetScript("OnClick", function(self)
        if Module.toggleBuffs then
            local normalTexture = self:GetNormalTexture()
            normalTexture:SetTexCoord(4 / 64, 22 / 64, 0 / 64, 31 / 64)

            local highlightTexture = toggleButton:GetHighlightTexture()
            highlightTexture:SetTexCoord(4 / 64, 22 / 64, 0 / 64, 31 / 64)

            for index = 1, BUFF_ACTUAL_DISPLAY do
                local button = _G['BuffButton' .. index]
                if button then
                    button:Hide()
                end
            end
        else
            local normalTexture = self:GetNormalTexture()
            normalTexture:SetTexCoord(5 / 64, 22 / 64, 31 / 64, 62 / 64)

            local highlightTexture = toggleButton:GetHighlightTexture()
            highlightTexture:SetTexCoord(5 / 64, 22 / 64, 31 / 64, 62 / 64)

            for index = 1, BUFF_ACTUAL_DISPLAY do
                local button = _G['BuffButton' .. index]
                if button then
                    button:Show()
                end
            end
        end

        Module.toggleBuffs = not Module.toggleBuffs
    end)

    local consolidatedBuffFrame = ConsolidatedBuffs
    consolidatedBuffFrame:SetMovable(true)
    consolidatedBuffFrame:SetUserPlaced(true)
    consolidatedBuffFrame:ClearAllPoints()
    consolidatedBuffFrame:SetPoint("RIGHT", toggleButton, "LEFT", -6, 0)
end

local function showToggleButtonIf(condition)
    if condition then
        Module.buffFrame.toggleButton:Show()
    else
        Module.buffFrame.toggleButton:Hide()
    end
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("UNIT_AURA")

    self.buffFrame = CreateUIFrame(BuffFrame:GetWidth(), BuffFrame:GetHeight(), "BuffFrame")
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("UNIT_AURA")
end

function Module:PLAYER_ENTERING_WORLD()
    ReplaceBlizzardFrame(self.buffFrame)

    showToggleButtonIf(BUFF_ACTUAL_DISPLAY > 0)

    if RUI.DB.profile.widgets.buffs == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

function Module:UNIT_AURA(eventName, unit)
    if unit ~= 'player' then return end

    showToggleButtonIf(BUFF_ACTUAL_DISPLAY > 0)
end

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.buffs = { anchor = "TOPRIGHT", posX = -260, posY = -20 }
end

function Module:UpdateWidgets()
    local widgetOptions = RUI.DB.profile.widgets.buffs
    self.buffFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
end

function Module:EnableEditorPreview()
    HideUIFrame(self.buffFrame)
end

function Module:DisableEditorPreview()
    ShowUIFrame(self.buffFrame)
    SaveUIFramePosition(self.buffFrame, 'buffs')
end
