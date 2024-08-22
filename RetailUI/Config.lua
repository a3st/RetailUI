local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')

RUI.optionsSlash = {
    name = "RetailUI Commands",
    order = 0,
    type = "group",
    args = {
        edit = {
            name = "Enable Edit Mode",
            type = 'execute',
            order = 0,
            func = function()
                local EditorMode = RUI:GetModule('EditorMode')
                if EditorMode:IsShown() then
                    EditorMode:Hide()
                else
                    EditorMode:Show()
                end
            end,
            dialogHidden = true
        },
        default = {
            name = "Load Default Settings",
            type = 'execute',
            order = 0,
            func = function()
                local ActionBar = RUI:GetModule('ActionBar')
                ActionBar:LoadDefaultSettings()
                ActionBar:UpdateWidgets()

                local UnitFrame = RUI:GetModule('UnitFrame')
                UnitFrame:LoadDefaultSettings()
                UnitFrame:UpdateWidgets()

                local CastBar = RUI:GetModule('CastBar')
                CastBar:LoadDefaultSettings()
                CastBar:UpdateWidgets()

                local Minimap = RUI:GetModule('Minimap')
                Minimap:LoadDefaultSettings()
                Minimap:UpdateWidgets()

                local QuestLog = RUI:GetModule('QuestLog')
                QuestLog:LoadDefaultSettings()
                QuestLog:UpdateWidgets()

                local BuffFrame = RUI:GetModule('BuffFrame')
                BuffFrame:LoadDefaultSettings()
                BuffFrame:UpdateWidgets()
            end,
            dialogHidden = true
        }
    }
}

RUI.default = {
    profile = {
        widgets = {}
    }
}
