local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')

DFUI.optionsSlash = {
    name = "DFUI Commands",
    order = 0,
    type = "group",
    args = {
        edit = {
            name = "Enable Edit Mode",
            type = 'execute',
            order = 0,
            func = function()
                local EditorMode = DFUI:GetModule('EditorMode')

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
                local ActionBar = DFUI:GetModule('ActionBar')
                ActionBar:LoadDefaultSettings()
                ActionBar:UpdateWidgets()

                local UnitFrame = DFUI:GetModule('UnitFrame')
                UnitFrame:LoadDefaultSettings()
                UnitFrame:UpdateWidgets()
            end,
            dialogHidden = true
        }
    }
}

DFUI.default = {
    profile = {
        widgets = {

        }
    }
}
