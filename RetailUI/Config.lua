--[[
    Copyright (c) Dmitriy. All rights reserved.
    Licensed under the MIT license. See LICENSE file in the project root for details.
]]

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
        scale = {
            name = "Scale",
            order = 1,
            type = "group",
            args = {
                player = {
                    name = "Player Frame Scale",
                    type = 'input',
                    order = 0,
                    set = function(info, input)
                        SaveUIFrameScale(input, "player")
                    end,
                    dialogHidden = true
                },
                target = {
                    name = "Target Frame Scale",
                    type = 'input',
                    order = 1,
                    set = function(info, input)
                        SaveUIFrameScale(input, "target")
                    end,
                    dialogHidden = true
                },
                focus = {
                    name = "Focus Frame Scale",
                    type = 'input',
                    order = 1,
                    set = function(info, input)
                        SaveUIFrameScale(input, "focus")
                    end,
                    dialogHidden = true
                },
                tot = {
                    name = "Target of Target Frame Scale",
                    type = 'input',
                    order = 1,
                    set = function(info, input)
                        SaveUIFrameScale(input, "targetOfTarget")
                    end,
                    dialogHidden = true
                },
                pet = {
                    name = "Pet Frame Scale",
                    type = 'input',
                    order = 1,
                    set = function(info, input)
                        SaveUIFrameScale(input, "pet")
                    end,
                    dialogHidden = true
                },
            }
        },
        default = {
            name = "Load Default Settings",
            type = 'execute',
            order = 0,
            func = function()
                local UnitFrameModule    = RUI:GetModule("UnitFrame")
                local CastingBarModule   = RUI:GetModule("CastingBar")
                local ActionBarModule    = RUI:GetModule("ActionBar")
                local MinimapModule      = RUI:GetModule("Minimap")
                local QuestTrackerModule = RUI:GetModule("QuestTracker")
                local BuffFrameModule    = RUI:GetModule("BuffFrame")

                ActionBarModule:LoadDefaultSettings()
                ActionBarModule:UpdateWidgets()

                UnitFrameModule:LoadDefaultSettings()
                UnitFrameModule:UpdateWidgets()

                CastingBarModule:LoadDefaultSettings()
                CastingBarModule:UpdateWidgets()

                MinimapModule:LoadDefaultSettings()
                MinimapModule:UpdateWidgets()

                QuestTrackerModule:LoadDefaultSettings()
                QuestTrackerModule:UpdateWidgets()

                BuffFrameModule:LoadDefaultSettings()
                BuffFrameModule:UpdateWidgets()
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
