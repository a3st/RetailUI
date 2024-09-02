--[[
    Copyright (c) Dmitriy. All rights reserved.
    Licensed under the MIT license. See LICENSE file in the project root for details.
]]

local addonPath = 'Interface\\AddOns\\RetailUI\\'

local UnitFrameAsset = addonPath .. 'Textures\\UI\\UnitFrame.blp'
local CastingBarAsset = addonPath .. 'Textures\\UI\\CastingBar.blp'
local CollapseButtonAsset = addonPath .. 'Textures\\UI\\CollapseButton.blp'
local MinimapAsset = addonPath .. 'Textures\\UI\\Minimap.blp'
local ActionBarAsset = addonPath .. 'Textures\\UI\\ActionBar.blp'
local ExperienceBar = addonPath .. 'Textures\\UI\\ExperienceBar.blp'
local BagSlotsAsset = addonPath .. 'Textures\\UI\\BagSlots.blp'
local BagSlotsKeyAsset = addonPath .. 'Textures\\UI\\BagSlotsKey.blp'
local MicroMenuAsset = addonPath .. 'Textures\\UI\\MicroMenu.blp'
local CalendarAsset = addonPath .. 'Textures\\Minimap\\Calendar.blp'
local LFGRoleAsset = addonPath .. 'Textures\\PlayerFrame\\LFGRoleIcons.blp'
local QuestTrackerAsset = addonPath .. 'Textures\\UI\\QuestTracker.BLP'

local atlasTextures = {
    ['QuestTracker-Header'] = {
        asset = { QuestTrackerAsset, 1024, 512 }, texcoord = { 11, 571, 247, 317 }
    },

    ['LFGRole-Tank'] = {
        asset = { LFGRoleAsset, 64, 32 }, texcoord = { 35, 53, 0, 17 }
    },
    ['LFGRole-Healer'] = {
        asset = { LFGRoleAsset, 64, 32 }, texcoord = { 18, 35, 0, 18 }
    },
    ['LFGRole-Damage'] = {
        asset = { LFGRoleAsset, 64, 32 }, texcoord = { 0, 17, 0, 17 }
    },

    ['TargetFrame-TextureFrame-Normal'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 423, 633, 0, 89 }
    },
    ['TargetFrame-TextureFrame-Vehicle'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 636, 846, 91, 181 }
    },
    ['TargetFrame-TextureFrame-Elite'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 211, 421, 0, 89 }
    },
    ['TargetFrame-TextureFrame-Rare'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 0, 209, 0, 89 }
    },
    ['TargetFrame-TextureFrame-RareElite'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 0, 222, 91, 181 }
    },
    ['TargetFrame-StatusBar-Health'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 3, 128, 459, 481 }
    },
    ['TargetFrame-StatusBar-Mana'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 130, 264, 459, 471 }
    },
    ['TargetFrame-Status'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 0, 209, 275, 365 }
    },
    ['TargetFrame-Flash'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 211, 422, 275, 365 }
    },
    ['TargetFrame-HighLevelIcon'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 252, 262, 490, 503 }
    },

    ['PlayerFrame-TextureFrame-Normal'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 423, 633, 91, 181 }
    },
    ['PlayerFrame-TextureFrame-Vehicle'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 636, 845, 0, 89 }
    },
    ['PlayerFrame-StatusBar-Health'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 3, 128, 483, 505 }
    },
    ['PlayerFrame-StatusBar-Mana'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 130, 256, 474, 485 }
    },
    ['PlayerFrame-Flash'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 212, 421, 184, 273 }
    },
    ['PlayerFrame-Status'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 0, 209, 184, 273 }
    },
    ['PlayerFrame-GroupIndicator'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 131, 203, 491, 505 }
    },

    ['PartyFrame-TextureFrame-Normal'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 848, 968, 0, 47 }
    },
    ['PartyFrame-StatusBar-Health'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 259, 330, 474, 485 }
    },
    ['PartyFrame-StatusBar-Mana'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 267, 341, 460, 469 }
    },
    ['PartyFrame-Flash'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 848, 968, 50, 97 }
    },
    ['PartyFrame-Status'] = {
        asset = { UnitFrameAsset, 1024, 512 }, texcoord = { 848, 968, 184, 147 }
    },

    ['CastingBar-Background'] = {
        asset = { CastingBarAsset, 512, 256 }, texcoord = { 0, 417, 95, 122 }
    },
    ['CastingBar-Border'] = {
        asset = { CastingBarAsset, 512, 256 }, texcoord = { 0, 423, 63, 90 }
    },
    ['CastingBar-MainBackground'] = {
        asset = { CastingBarAsset, 512, 256 }, texcoord = { 0, 419, 0, 56 }
    },
    ['CastingBar-StatusBar-Casting'] = {
        asset = { CastingBarAsset, 512, 256 }, texcoord = { 0, 418, 149, 170 }
    },
    ['CastingBar-StatusBar-Channeling'] = {
        asset = { CastingBarAsset, 512, 256 }, texcoord = { 0, 417, 124, 146 }
    },
    ['CastingBar-StatusBar-Failed'] = {
        asset = { CastingBarAsset, 512, 256 }, texcoord = { 0, 417, 173, 196 }
    },
    ['CastingBar-Spark'] = {
        asset = { CastingBarAsset, 512, 256 }, texcoord = { 423, 430, 97, 150 }
    },
    ['CastingBar-BorderShield'] = {
        asset = { CastingBarAsset, 512, 256 }, texcoord = { 437, 509, 1, 87 }
    },

    ['CollapseButton-Left'] = {
        asset = { CollapseButtonAsset, 64, 64 }, texcoord = { 4, 22, 0, 31 }
    },
    ['CollapseButton-Right'] = {
        asset = { CollapseButtonAsset, 64, 64 }, texcoord = { 5, 22, 31, 62 }
    },
    ['CollapseButton-Up'] = {
        asset = { CollapseButtonAsset, 64, 64 }, texcoord = { 31, 63, 10, 27 }
    },
    ['CollapseButton-Down'] = {
        asset = { CollapseButtonAsset, 64, 64 }, texcoord = { 31, 62, 37, 54 }
    },

    ['Minimap-Border'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 1, 431, 63, 498 }
    },
    ['Minimap-Border-Top'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 105, 360, 609, 636 }
    },
    ['Minimap-Mail-Normal'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 42, 80, 521, 548 }
    },
    ['Minimap-Mail-Highlight'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 1, 39, 521, 548 }
    },
    ['Minimap-Calendar-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 0.18359375 * 256, 0.265625 * 256, 0.00390625 * 256, 0.078125 * 256 }
    },
    ['Minimap-Calendar-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 0.09375 * 256, 0.17578125 * 256, 0.00390625 * 256, 0.078125 * 256 }
    },
    ['Minimap-Calendar-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 0.00390625 * 256, 0.0859375 * 256, 0.00390625 * 256, 0.078125 * 256 }
    },
    ['Minimap-Tracking-Background'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 441, 480, 402, 440 }
    },
    ['Minimap-Tracking-Normal'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 149, 179, 520, 548 }
    },
    ['Minimap-Tracking-Highlight'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 117, 147, 520, 548 }
    },
    ['Minimap-Tracking-Pushed'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 83, 115, 520, 550 }
    },
    ['Minimap-ZoomIn-Normal'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 1, 35, 552, 586 }
    },
    ['Minimap-ZoomIn-Highlight'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 1, 35, 624, 658 }
    },
    ['Minimap-ZoomIn-Pushed'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 1, 35, 588, 622 }
    },
    ['Minimap-ZoomOut-Normal'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 181, 215, 520, 538 }
    },
    ['Minimap-ZoomOut-Highlight'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 253, 287, 520, 538 }
    },
    ['Minimap-ZoomOut-Pushed'] = {
        asset = { MinimapAsset, 512, 1024 }, texcoord = { 217, 251, 520, 538 }
    },
    ['Minimap-Calendar-1-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 1, 20 }
    },
    ['Minimap-Calendar-1-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 1, 20 }
    },
    ['Minimap-Calendar-1-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 1, 20 }
    },
    ['Minimap-Calendar-2-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 43, 62 }
    },
    ['Minimap-Calendar-2-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 43, 62 }
    },
    ['Minimap-Calendar-2-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 43, 62 }
    },
    ['Minimap-Calendar-3-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 85, 104 }
    },
    ['Minimap-Calendar-3-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 232, 251 }
    },
    ['Minimap-Calendar-3-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 211, 230 }
    },
    ['Minimap-Calendar-4-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 127, 146 }
    },
    ['Minimap-Calendar-4-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 106, 125 }
    },
    ['Minimap-Calendar-4-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 231, 252, 85, 104 }
    },
    ['Minimap-Calendar-5-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 190, 209 }
    },
    ['Minimap-Calendar-5-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 169, 188 }
    },
    ['Minimap-Calendar-5-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 148, 167 }
    },
    ['Minimap-Calendar-6-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 106, 125 }
    },
    ['Minimap-Calendar-6-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 232, 251 }
    },
    ['Minimap-Calendar-6-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 211, 230 }
    },
    ['Minimap-Calendar-7-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 162, 183, 106, 125 }
    },
    ['Minimap-Calendar-7-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 139, 160, 106, 125 }
    },
    ['Minimap-Calendar-7-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 116, 137, 106, 125 }
    },
    ['Minimap-Calendar-8-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 231, 252, 106, 125 }
    },
    ['Minimap-Calendar-8-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 208, 229, 106, 125 }
    },
    ['Minimap-Calendar-8-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 185, 206, 106, 125 }
    },
    ['Minimap-Calendar-9-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 169, 188 }
    },
    ['Minimap-Calendar-9-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 169, 188 }
    },
    ['Minimap-Calendar-9-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 127, 146 }
    },
    ['Minimap-Calendar-10-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 116, 137, 1, 20 }
    },
    ['Minimap-Calendar-10-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 1, 20 }
    },
    ['Minimap-Calendar-10-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 1, 20 }
    },
    ['Minimap-Calendar-11-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 185, 206, 1, 20 }
    },
    ['Minimap-Calendar-11-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 162, 183, 1, 20 }
    },
    ['Minimap-Calendar-11-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 139, 160, 1, 20 }
    },
    ['Minimap-Calendar-12-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 22, 41 }
    },
    ['Minimap-Calendar-12-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 231, 252, 1, 20 }
    },
    ['Minimap-Calendar-12-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 208, 229, 1, 20 }
    },
    ['Minimap-Calendar-13-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 22, 41 }
    },
    ['Minimap-Calendar-13-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 22, 41 }
    },
    ['Minimap-Calendar-13-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 22, 41 }
    },
    ['Minimap-Calendar-14-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 139, 160, 22, 41 }
    },
    ['Minimap-Calendar-14-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 116, 137, 22, 41 }
    },
    ['Minimap-Calendar-14-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 22, 41 }
    },
    ['Minimap-Calendar-15-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 208, 229, 22, 41 }
    },
    ['Minimap-Calendar-15-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 185, 206, 22, 41 }
    },
    ['Minimap-Calendar-15-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 162, 183, 22, 41 }
    },
    ['Minimap-Calendar-16-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 64, 83 }
    },
    ['Minimap-Calendar-16-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 43, 62 }
    },
    ['Minimap-Calendar-16-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 231, 252, 22, 41 }
    },
    ['Minimap-Calendar-17-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 127, 146 }
    },
    ['Minimap-Calendar-17-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 106, 125 }
    },
    ['Minimap-Calendar-17-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 85, 104 }
    },
    ['Minimap-Calendar-18-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 190, 209 }
    },
    ['Minimap-Calendar-18-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 169, 188 }
    },
    ['Minimap-Calendar-18-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 148, 167 }
    },
    ['Minimap-Calendar-19-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 43, 62 }
    },
    ['Minimap-Calendar-19-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 232, 251 }
    },
    ['Minimap-Calendar-19-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 1, 22, 211, 230 }
    },
    ['Minimap-Calendar-20-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 162, 183, 43, 62 }
    },
    ['Minimap-Calendar-20-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 139, 160, 43, 62 }
    },
    ['Minimap-Calendar-20-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 116, 137, 43, 62 }
    },
    ['Minimap-Calendar-21-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 231, 252, 43, 62 }
    },
    ['Minimap-Calendar-21-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 208, 229, 43, 62 }
    },
    ['Minimap-Calendar-21-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 185, 206, 43, 62 }
    },
    ['Minimap-Calendar-22-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 106, 125 }
    },
    ['Minimap-Calendar-22-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 85, 104 }
    },
    ['Minimap-Calendar-22-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 64, 83 }
    },
    ['Minimap-Calendar-23-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 169, 188 }
    },
    ['Minimap-Calendar-23-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 148, 167 }
    },
    ['Minimap-Calendar-23-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 127, 146 }
    },
    ['Minimap-Calendar-24-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 232, 251 }
    },
    ['Minimap-Calendar-24-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 211, 230 }
    },
    ['Minimap-Calendar-24-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 24, 45, 190, 209 }
    },
    ['Minimap-Calendar-25-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 64, 83 }
    },
    ['Minimap-Calendar-25-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 70, 91, 64, 83 }
    },
    ['Minimap-Calendar-25-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 64, 83 }
    },
    ['Minimap-Calendar-26-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 162, 183, 64, 83 }
    },
    ['Minimap-Calendar-26-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 139, 160, 64, 83 }
    },
    ['Minimap-Calendar-26-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 116, 137, 64, 83 }
    },
    ['Minimap-Calendar-27-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 231, 252, 64, 83 }
    },
    ['Minimap-Calendar-27-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 208, 229, 64, 83 }
    },
    ['Minimap-Calendar-27-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 185, 206, 64, 83 }
    },
    ['Minimap-Calendar-28-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 127, 146 }
    },
    ['Minimap-Calendar-28-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 106, 125 }
    },
    ['Minimap-Calendar-28-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 85, 104 }
    },
    ['Minimap-Calendar-29-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 190, 209 }
    },
    ['Minimap-Calendar-29-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 169, 188 }
    },
    ['Minimap-Calendar-29-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 47, 68, 148, 167 }
    },
    ['Minimap-Calendar-30-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 139, 160, 85, 104 }
    },
    ['Minimap-Calendar-30-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 116, 137, 85, 104 }
    },
    ['Minimap-Calendar-30-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 93, 114, 85, 104 }
    },
    ['Minimap-Calendar-31-Normal'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 208, 229, 85, 104 }
    },
    ['Minimap-Calendar-31-Highlight'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 185, 206, 85, 104 }
    },
    ['Minimap-Calendar-31-Pushed'] = {
        asset = { CalendarAsset, 256, 256 }, texcoord = { 162, 183, 85, 104 }
    },

    ['ActionBar-LeftCap-Alliance'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 1, 357, 209, 543 }
    },
    ['ActionBar-RightCap-Alliance'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 1, 357, 545, 879 }
    },
    ['ActionBar-LeftCap-Horde'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 1, 357, 881, 1215 }
    },
    ['ActionBar-RightCap-Horde'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 1, 357, 1217, 1551 }
    },
    ['ActionBar-ButtonUp-Normal'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 359, 393, 833, 861 }
    },
    ['ActionBar-ButtonUp-Highlight'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 453, 487, 709, 737 }
    },
    ['ActionBar-ButtonUp-Pushed'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 453, 487, 679, 707 }
    },
    ['ActionBar-ButtonDown-Normal'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 463, 497, 605, 633 }
    },
    ['ActionBar-ButtonDown-Highlight'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 463, 497, 575, 603 }
    },
    ['ActionBar-ButtonDown-Pushed'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 463, 497, 545, 573 }
    },
    ['ActionBar-ActionButton-Highlight'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 359, 451, 1065, 1155 }
    },
    ['ActionBar-ActionButton-Pushed'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 359, 451, 881, 971 }
    },
    ['ActionBar-ActionButton-Flash'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 359, 451, 973, 1063 }
    },
    ['ActionBar-ActionButton-Border'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 359, 451, 649, 739 }
    },
    ['ActionBar-ActionButton-Background'] = {
        asset = { ActionBarAsset, 512, 2048 }, texcoord = { 359, 487, 209, 333 }
    },

    ['ExperienceBar-Background'] = {
        asset = { ExperienceBar, 2048, 64 }, texcoord = { 0.00088878125, 570, 20, 29 }
    },
    ['ExperienceBar-Border'] = {
        asset = { ExperienceBar, 2048, 64 }, texcoord = { 1, 572, 1, 18 }
    },

    ['BagsBar-SlotButton-Highlight'] = {
        asset = { BagSlotsAsset, 512, 128 }, texcoord = { 358, 419, 1, 62 }
    },
    ['BagsBar-SlotButton-Border'] = {
        asset = { BagSlotsAsset, 512, 128 }, texcoord = { 295, 356, 1, 62 }
    },
    ['BagsBar-KeySlot-Normal'] = {
        asset = { BagSlotsKeyAsset, 128, 128 }, texcoord = { 3, 63, 64, 125 }
    },
    ['BagsBar-MainSlot-Normal'] = {
        asset = { BagSlotsAsset, 512, 128 }, texcoord = { 1, 97, 1, 97 }
    },
    ['BagsBar-MainSlot-Highlight'] = {
        asset = { BagSlotsAsset, 512, 128 }, texcoord = { 99, 195, 1, 97 }
    },


    ['MicroMenu-Spellbook-Normal'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 389, 440, 312, 382 }
    },
    ['MicroMenu-Spellbook-Highlight'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 334, 385, 312, 382 }
    },
    ['MicroMenu-Spellbook-Pushed'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 280, 331, 312, 382 }
    },
    ['MicroMenu-Talent-Normal'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 170, 221, 312, 382 }
    },
    ['MicroMenu-Talent-Highlight'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 116, 167, 312, 382 }
    },
    ['MicroMenu-Talent-Pushed'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 63, 114, 312, 382 }
    },
    ['MicroMenu-Talent-Disabled'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 6, 57, 312, 382 }
    },
    ['MicroMenu-LFD-Normal'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 387, 438, 158, 229 }
    },
    ['MicroMenu-LFD-Highlight'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 331, 382, 158, 229 }
    },
    ['MicroMenu-LFD-Pushed'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 277, 328, 158, 229 }
    },
    ['MicroMenu-LFD-Disabled'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 222, 273, 158, 229 }
    },
    ['MicroMenu-MainMenu-Normal'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 387, 438, 235, 305 }
    },
    ['MicroMenu-MainMenu-Highlight'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 278, 329, 235, 305 }
    },
    ['MicroMenu-MainMenu-Pushed'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 333, 383, 235, 305 }
    },
    ['MicroMenu-Help-Normal'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 169, 219, 158, 228 }
    },
    ['MicroMenu-Help-Highlight'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 115, 166, 158, 228 }
    },
    ['MicroMenu-Help-Pushed'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 60, 111, 158, 228 }
    },
    ['MicroMenu-Socials-Normal'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 169, 220, 235, 305 }
    },
    ['MicroMenu-Socials-Highlight'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 115, 166, 235, 305 }
    },
    ['MicroMenu-Socials-Pushed'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 61, 112, 235, 305 }
    },
    ['MicroMenu-Achievement-Normal'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 383, 433, 4, 74 }
    },
    ['MicroMenu-Achievement-Highlight'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 329, 380, 4, 74 }
    },
    ['MicroMenu-Achievement-Pushed'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 274, 325, 4, 74 }
    },
    ['MicroMenu-Achievement-Disabled'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 220, 271, 4, 74 }
    },
    ['MicroMenu-QuestLog-Normal'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 166, 217, 4, 74 }
    },
    ['MicroMenu-QuestLog-Highlight'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 112, 164, 4, 74 }
    },
    ['MicroMenu-QuestLog-Pushed'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 58, 109, 4, 74 }
    },
    ['MicroMenu-QuestLog-Disabled'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 4, 55, 4, 74 }
    },
    ['MicroMenu-Empty'] = {
        asset = { MicroMenuAsset, 512, 512 }, texcoord = { 384, 435, 82, 151 }
    }
}

function SetAtlasTexture(texture, textureName)
    local atlasInfo = atlasTextures[textureName]
    local assetPath, width, height = unpack(atlasInfo.asset)

    local texCoordInfo = atlasInfo.texcoord
    local left, right, top, bottom = unpack(texCoordInfo)

    texture:SetTexture(assetPath)
    texture:SetTexCoord(left / width, right / width, top / height, bottom / height)
    texture:SetSize(right - left, bottom - top)
end
