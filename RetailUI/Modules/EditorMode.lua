local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'EditorMode'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.gridFrame = nil

local function CreateGridFrame()
    local gridFrame = CreateFrame("Frame", 'RUI_GridFrame', UIParent)
    gridFrame:SetPoint("TOPLEFT", 0, 0)
    gridFrame:SetSize(GetScreenWidth(), GetScreenHeight())
    gridFrame:SetFrameLevel(0)

    do
        local texture = gridFrame:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints(gridFrame)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Grid.blp", "REPEAT", "REPEAT")
        texture:SetTexCoord(0, 1, 0, 1)
        texture:SetVertTile(true)
        texture:SetHorizTile(true)
        texture:SetSize(32, 32)
        texture:SetAlpha(0.4)
    end

    gridFrame:Hide()
    return gridFrame
end

function Module:OnEnable()
    self.gridFrame = CreateGridFrame()
end

function Module:OnDisable()
    self.gridFrame = nil
end

function Module:Show()
    if InCombatLockdown() then
        self:Printf(DEFAULT_CHAT_FRAME, "Cannot open settings while in combat")
        return
    end

    self.gridFrame:Show()

    local ActionBar = RUI:GetModule("ActionBar")
    ActionBar:EnableEditorPreviewForActionBarFrames()
    ActionBar:EnableEditorPreviewForBagsFrame()
    ActionBar:EnableEditorPreviewForMicroMenuBarFrame()
    ActionBar:EnableEditorPreviewForRepExpBarFrame()

    local UnitFrame = RUI:GetModule("UnitFrame")
    UnitFrame:EnableEditorPreviewForPlayerFrame()
    UnitFrame:EnableEditorPreviewForPetFrame()
    UnitFrame:EnableEditorPreviewForTargetFrame()
    UnitFrame:EnableEditorPreviewForTargetOfTargetFrame()
    UnitFrame:EnableEditorPreviewForFocusFrame()

    local CastBar = RUI:GetModule("CastBar")
    CastBar:EnableEditorPreviewForCastBarFrame()

    local Minimap = RUI:GetModule("Minimap")
    Minimap:EnableEditorPreviewForMinimapFrame()

    local QuestLog = RUI:GetModule("QuestLog")
    QuestLog:EnableEditorPreviewForQuestLogFrame()

    local BuffFrame = RUI:GetModule("BuffFrame")
    BuffFrame:EnableEditorPreviewForBuffFrame()
end

function Module:Hide()
    self.gridFrame:Hide()

    local ActionBar = RUI:GetModule("ActionBar")
    ActionBar:DisableEditorPreviewForActionBarFrames()
    ActionBar:DisableEditorPreviewForBagsFrame()
    ActionBar:DisableEditorPreviewForMicroMenuBarFrame()
    ActionBar:DisableEditorPreviewForRepExpBarFrame()

    ActionBar:UpdateWidgets()

    local UnitFrame = RUI:GetModule("UnitFrame")
    UnitFrame:DisableEditorPreviewForPlayerFrame()
    UnitFrame:DisableEditorPreviewForPetFrame()
    UnitFrame:DisableEditorPreviewForTargetFrame()
    UnitFrame:DisableEditorPreviewForTargetOfTargetFrame()
    UnitFrame:DisableEditorPreviewForFocusFrame()

    UnitFrame:UpdateWidgets()

    local CastBar = RUI:GetModule("CastBar")
    CastBar:DisableEditorPreviewForCastBarFrame()

    CastBar:UpdateWidgets()

    local Minimap = RUI:GetModule("Minimap")
    Minimap:DisableEditorPreviewForMinimapFrame()

    Minimap:UpdateWidgets()

    local QuestLog = RUI:GetModule("QuestLog")
    QuestLog:DisableEditorPreviewForQuestLogFrame()

    QuestLog:UpdateWidgets()

    local BuffFrame = RUI:GetModule("BuffFrame")
    BuffFrame:DisableEditorPreviewForBuffFrame()

    BuffFrame:UpdateWidgets()
end

function Module:IsShown()
    return self.gridFrame:IsShown()
end
