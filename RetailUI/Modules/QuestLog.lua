local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'QuestLog'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.questLogFrame = nil

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    self.questLogFrame = CreateUIFrame(230, 500, "QuestLogFrame")
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")

    self.questLogFrame = nil
end

function Module:ReplaceBlizzardFrames()
    local watchFrame = WatchFrame
    watchFrame:SetMovable(true)
    watchFrame:SetUserPlaced(true)
    watchFrame:ClearAllPoints()
    watchFrame:SetPoint("TOPRIGHT", self.questLogFrame, "TOPRIGHT", 0, 0)
end

function Module:PLAYER_ENTERING_WORLD()
    self:ReplaceBlizzardFrames()

    if RUI.DB.profile.widgets.questLog == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.questLog = { anchor = "RIGHT", posX = -100, posY = -37 }
end

function Module:UpdateWidgets()
    local widgetOptions = RUI.DB.profile.widgets.questLog
    self.questLogFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
end

function Module:EnableEditorPreviewForQuestLogFrame()
    local questLogFrame = self.questLogFrame

    questLogFrame:SetMovable(true)
    questLogFrame:EnableMouse(true)

    questLogFrame.editorTexture:Show()
    questLogFrame.editorText:Show()
end

function Module:DisableEditorPreviewForQuestLogFrame()
    local questLogFrame = self.questLogFrame

    questLogFrame:SetMovable(false)
    questLogFrame:EnableMouse(false)

    questLogFrame.editorTexture:Hide()
    questLogFrame.editorText:Hide()

    local _, _, relativePoint, posX, posY = questLogFrame:GetPoint('CENTER')
    RUI.DB.profile.widgets.questLog.anchor = relativePoint
    RUI.DB.profile.widgets.questLog.posX = posX
    RUI.DB.profile.widgets.questLog.posY = posY
end
