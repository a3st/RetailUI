local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local moduleName = 'EditorMode'
local Module = DFUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.gridFrame = nil

local function CreateGridFrame()
    local gridFrame = CreateFrame("Frame", 'DFUI_GridFrame', UIParent)
    gridFrame:SetPoint("TOPLEFT", 0, 0)
    gridFrame:SetSize(GetScreenWidth(), GetScreenHeight())
    gridFrame:SetFrameLevel(0)

    do
        local texture = gridFrame:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints(gridFrame)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\grid.blp", "REPEAT", "REPEAT")
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
    self.gridFrame:Show()

    local ActionBar = DFUI:GetModule("ActionBar")
    ActionBar:EnableEditorPreviewForActionBars()
    --ActionBar:EnableEditorPreviewForStanceBar()
    --ActionBar:EnableEditorPreviewForBags()
    --ActionBar:EnableEditorPreviewForMicroMenuBar()
    --ActionBar:EnableEditorPreviewForRepExpBar()

    local UnitFrame = DFUI:GetModule("UnitFrame")
    UnitFrame:EnableEditorPreviewForPlayerFrame()
    UnitFrame:EnableEditorPreviewForPetFrame()
    UnitFrame:EnableEditorPreviewForTargetFrame()
    UnitFrame:EnableEditorPreviewForTargetOfTargetFrame()
    UnitFrame:EnableEditorPreviewForFocusFrame()

    local CastBar = DFUI:GetModule("CastBar")
    CastBar:EnableEditorPreviewForCastBar()
end

function Module:Hide()
    self.gridFrame:Hide()

    local ActionBar = DFUI:GetModule("ActionBar")
    ActionBar:DisableEditorPreviewForActionBars()
    --ActionBar:DisableEditorPreviewForStanceBar()
    --ActionBar:DisableEditorPreviewForBags()
    --ActionBar:DisableEditorPreviewForMicroMenuBar()
    --ActionBar:DisableEditorPreviewForRepExpBar()

    local UnitFrame = DFUI:GetModule("UnitFrame")
    UnitFrame:DisableEditorPreviewForPlayerFrame()
    UnitFrame:DisableEditorPreviewForPetFrame()
    UnitFrame:DisableEditorPreviewForTargetFrame()
    UnitFrame:DisableEditorPreviewForTargetOfTargetFrame()
    UnitFrame:DisableEditorPreviewForFocusFrame()

    local CastBar = DFUI:GetModule("CastBar")
    CastBar:DisableEditorPreviewForCastBar()
end

function Module:IsShown()
    return self.gridFrame:IsShown()
end
