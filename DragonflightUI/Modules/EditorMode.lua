local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local moduleName = 'EditorMode'
local Module = DFUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.editorFrame = nil

local function CreateEditModeFrame()
    local editorFrame = CreateFrame("Frame", 'DFUI_EditorFrame', UIParent)
    editorFrame:SetPoint("TOPLEFT", 0, 0)
    editorFrame:SetSize(GetScreenWidth(), GetScreenHeight())
    editorFrame:SetFrameLevel(0)

    do
        local texture = editorFrame:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints(editorFrame)
        texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\grid.blp", "REPEAT", "REPEAT")
        texture:SetTexCoord(0, 1, 0, 1)
        texture:SetVertTile(true)
        texture:SetHorizTile(true)
        texture:SetSize(32, 32)
        texture:SetAlpha(0.4)

        editorFrame.grid = texture
    end

    editorFrame:Hide()
    return editorFrame
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function(self)
        Module.editorFrame = CreateEditModeFrame()
    end)
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Module:Show()
    self.editorFrame:Show()

    local ActionBar = DFUI:GetModule("ActionBar")
    ActionBar:EnableEditorPreviewForActionBars()
    ActionBar:EnableEditorPreviewForBags()
    ActionBar:EnableEditorPreviewForMicroMenuBar()
    ActionBar:EnableEditorPreviewForRepExpBar()

    local UnitFrame = DFUI:GetModule("UnitFrame")
    UnitFrame:EnableEditorPreviewForPlayerFrame()
    UnitFrame:EnableEditorPreviewForTargetFrame()
    UnitFrame:EnableEditorPreviewForTargetOfTargetFrame()
    UnitFrame:EnableEditorPreviewForFocusFrame()
end

function Module:Hide()
    self.editorFrame:Hide()

    local ActionBar = DFUI:GetModule("ActionBar")
    ActionBar:DisableEditorPreviewForActionBars()
    ActionBar:DisableEditorPreviewForBags()
    ActionBar:DisableEditorPreviewForMicroMenuBar()
    ActionBar:DisableEditorPreviewForRepExpBar()

    local UnitFrame = DFUI:GetModule("UnitFrame")
    UnitFrame:DisableEditorPreviewForPlayerFrame()
    UnitFrame:DisableEditorPreviewForTargetFrame()
    UnitFrame:DisableEditorPreviewForTargetOfTargetFrame()
    UnitFrame:DisableEditorPreviewForFocusFrame()
end

function Module:IsShown()
    return self.editorFrame:IsShown()
end
