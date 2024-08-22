local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'BuffFrame'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.buffFrame = nil

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    self.buffFrame = CreateUIFrame(BuffFrame:GetWidth(), BuffFrame:GetHeight(), "BuffFrame")
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")

    self.buffFrame = nil
end

function Module:ReplaceBlizzardFrames()
    local buffFrame = BuffFrame
    buffFrame:ClearAllPoints()
    buffFrame:SetPoint("TOPLEFT", self.buffFrame, "TOPLEFT", 0, 0)
    buffFrame:SetPoint("TOPRIGHT", self.buffFrame, "TOPRIGHT", 0, 0)

    -- Disable Blizzard UI ability to control this element
    buffFrame.ClearAllPoints = function() end
    buffFrame.SetPoint = function() end

    local consolidatedBuffFrame = ConsolidatedBuffs
    consolidatedBuffFrame:ClearAllPoints()
    consolidatedBuffFrame:SetPoint("BOTTOMLEFT", self.buffFrame, "BOTTOMLEFT", 0, 0)
    consolidatedBuffFrame:SetPoint("BOTTOMRIGHT", self.buffFrame, "BOTTOMRIGHT", 0, 0)

    -- Disable Blizzard UI ability to control this element
    consolidatedBuffFrame.ClearAllPoints = function() end
    consolidatedBuffFrame.SetPoint = function() end
end

function Module:PLAYER_ENTERING_WORLD()
    self:ReplaceBlizzardFrames()

    if RUI.DB.profile.widgets.buffs == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.buffs = { anchor = "TOPRIGHT", posX = -260, posY = -20 }
end

function Module:UpdateWidgets()
    local widgetOptions = RUI.DB.profile.widgets.buffs
    self.buffFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
end

function Module:EnableEditorPreviewForBuffFrame()
    local buffFrame = self.buffFrame

    buffFrame:SetMovable(true)
    buffFrame:EnableMouse(true)

    buffFrame.editorTexture:Show()
    buffFrame.editorText:Show()
end

function Module:DisableEditorPreviewForBuffFrame()
    local buffFrame = self.buffFrame

    buffFrame:SetMovable(false)
    buffFrame:EnableMouse(false)

    buffFrame.editorTexture:Hide()
    buffFrame.editorText:Hide()

    local _, _, relativePoint, posX, posY = buffFrame:GetPoint('CENTER')
    RUI.DB.profile.widgets.buffs.anchor = relativePoint
    RUI.DB.profile.widgets.buffs.posX = posX
    RUI.DB.profile.widgets.buffs.posY = posY
end
