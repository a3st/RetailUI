--[[
    Copyright (c) Dmitriy. All rights reserved.
    Licensed under the MIT license. See LICENSE file in the project root for details.
]]

local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'Minimap'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.minimapFrame = nil
Module.borderFrame = nil

local function UpdateCalendarDate()
    local _, _, day = CalendarGetDate()

    local gameTimeFrame = GameTimeFrame

    local normalTexture = gameTimeFrame:GetNormalTexture()
    normalTexture:SetAllPoints(gameTimeFrame)
    SetAtlasTexture(normalTexture, 'Minimap-Calendar-' .. day .. '-Normal')

    local highlightTexture = gameTimeFrame:GetHighlightTexture()
    highlightTexture:SetAllPoints(gameTimeFrame)
    SetAtlasTexture(highlightTexture, 'Minimap-Calendar-' .. day .. '-Highlight')

    local pushedTexture = gameTimeFrame:GetPushedTexture()
    pushedTexture:SetAllPoints(gameTimeFrame)
    SetAtlasTexture(pushedTexture, 'Minimap-Calendar-' .. day .. '-Pushed')
end

local function ReplaceBlizzardFrame(frame)
    local minimapCluster = MinimapCluster
    minimapCluster:ClearAllPoints()
    minimapCluster:SetPoint("CENTER", frame, "CENTER", 0, 0)

    local minimapBorderTop = MinimapBorderTop
    minimapBorderTop:ClearAllPoints()
    minimapBorderTop:SetPoint("TOP", 0, 5)
    SetAtlasTexture(minimapBorderTop, 'Minimap-Border-Top')
    minimapBorderTop:SetSize(156, 20)

    local minimapZoneButton = MinimapZoneTextButton
    minimapZoneButton:ClearAllPoints()
    minimapZoneButton:SetPoint("LEFT", minimapBorderTop, "LEFT", 7, 1)
    minimapZoneButton:SetWidth(108)

    local minimapZoneText = MinimapZoneText
    minimapZoneText:SetAllPoints(minimapZoneButton)
    minimapZoneText:SetJustifyH("LEFT")

    local timeClockButton = TimeManagerClockButton
    timeClockButton:GetRegions():Hide()
    timeClockButton:ClearAllPoints()
    timeClockButton:SetPoint("RIGHT", minimapBorderTop, "RIGHT", -5, 1)
    timeClockButton:SetWidth(30)

    local gameTimeFrame = GameTimeFrame
    gameTimeFrame:ClearAllPoints()
    gameTimeFrame:SetPoint("LEFT", minimapBorderTop, "RIGHT", 3, -1)
    gameTimeFrame:SetSize(26, 24)
    gameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
    gameTimeFrame:GetFontString():Hide()

    UpdateCalendarDate()

    local minimapBattlefieldFrame = MiniMapBattlefieldFrame
    minimapBattlefieldFrame:ClearAllPoints()
    minimapBattlefieldFrame:SetPoint("BOTTOMLEFT", 8, 2)

    local minimapLFGFrame = MiniMapLFGFrame
    minimapLFGFrame:ClearAllPoints()
    minimapLFGFrame:SetPoint("BOTTOMLEFT", -5, 15)
    minimapLFGFrame:SetSize(50, 50)
    minimapLFGFrame:SetHitRectInsets(0, 0, 0, 0)

    local eyeFrame = _G[minimapLFGFrame:GetName() .. 'Icon']
    eyeFrame:SetAllPoints(minimapLFGFrame)

    local iconTexture = eyeFrame.texture
    iconTexture:SetAllPoints(eyeFrame)
    iconTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\Minimap\\EyeGroupFinderFlipbook.blp")

    local minimapInstanceTexture = MiniMapInstanceDifficulty
    minimapInstanceTexture:ClearAllPoints()
    minimapInstanceTexture:SetPoint("TOPRIGHT", -15, -15)

    local minimapTracking = MiniMapTracking
    minimapTracking:ClearAllPoints()
    minimapTracking:SetPoint("RIGHT", minimapBorderTop, "LEFT", -3, 0)
    minimapTracking:SetSize(26, 24)

    local minimapMailFrame = MiniMapMailFrame
    minimapMailFrame:ClearAllPoints()
    minimapMailFrame:SetPoint("TOP", minimapTracking, "BOTTOM", 0, -3)
    minimapMailFrame:SetSize(24, 18)
    minimapMailFrame:SetHitRectInsets(0, 0, 0, 0)

    local minimapMailIconTexture = MiniMapMailIcon
    minimapMailIconTexture:SetAllPoints(minimapMailFrame)
    SetAtlasTexture(minimapMailIconTexture, 'Minimap-Mail-Normal')

    local backgroundTexture = _G[minimapTracking:GetName() .. "Background"]
    backgroundTexture:SetAllPoints(minimapTracking)
    SetAtlasTexture(backgroundTexture, 'Minimap-Tracking-Background')

    local minimapTrackingButton = _G[minimapTracking:GetName() .. 'Button']
    minimapTrackingButton:ClearAllPoints()
    minimapTrackingButton:SetPoint("CENTER", 0, 0)

    minimapTrackingButton:SetSize(17, 15)
    minimapTrackingButton:SetHitRectInsets(0, 0, 0, 0)

    local shineTexture = _G[minimapTrackingButton:GetName() .. "Shine"]
    shineTexture:SetTexture(nil)

    local normalTexture = minimapTrackingButton:GetNormalTexture() or minimapTrackingButton:CreateTexture(nil, "BORDER")
    normalTexture:SetAllPoints(minimapTrackingButton)
    SetAtlasTexture(normalTexture, 'Minimap-Tracking-Normal')

    minimapTrackingButton:SetNormalTexture(normalTexture)

    local highlightTexture = minimapTrackingButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(minimapTrackingButton)
    SetAtlasTexture(highlightTexture, 'Minimap-Tracking-Highlight')

    local pushedTexture = minimapTrackingButton:GetPushedTexture() or minimapTrackingButton:CreateTexture(nil, "BORDER")
    pushedTexture:SetAllPoints(minimapTrackingButton)
    SetAtlasTexture(pushedTexture, 'Minimap-Tracking-Pushed')

    minimapTrackingButton:SetPushedTexture(pushedTexture)

    local minimapFrame = Minimap
    minimapFrame:ClearAllPoints()
    minimapFrame:SetPoint("CENTER", minimapCluster, "CENTER", 0, -30)
    minimapFrame:SetSize(175, 175)

    local minimapBackdropTexture = MinimapBackdrop
    minimapBackdropTexture:ClearAllPoints()
    minimapBackdropTexture:SetPoint("CENTER", minimapFrame, "CENTER", 0, 3)

    local minimapBorderTexture = MinimapBorder
    SetAtlasTexture(minimapBorderTexture, 'Minimap-Border')

    local zoomInButton = MinimapZoomIn
    zoomInButton:ClearAllPoints()
    zoomInButton:SetPoint("BOTTOMRIGHT", 0, 15)

    zoomInButton:SetSize(25, 24)
    zoomInButton:SetHitRectInsets(0, 0, 0, 0)

    normalTexture = zoomInButton:GetNormalTexture()
    normalTexture:SetAllPoints(zoomInButton)
    SetAtlasTexture(normalTexture, 'Minimap-ZoomIn-Normal')

    highlightTexture = zoomInButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(zoomInButton)
    SetAtlasTexture(highlightTexture, 'Minimap-ZoomIn-Highlight')

    pushedTexture = zoomInButton:GetPushedTexture()
    pushedTexture:SetAllPoints(zoomInButton)
    SetAtlasTexture(pushedTexture, 'Minimap-ZoomIn-Pushed')

    local disabledTexture = zoomInButton:GetDisabledTexture()
    disabledTexture:SetAllPoints(zoomInButton)
    SetAtlasTexture(disabledTexture, 'Minimap-ZoomIn-Pushed')

    local zoomOutButton = MinimapZoomOut
    zoomOutButton:ClearAllPoints()
    zoomOutButton:SetPoint("BOTTOMRIGHT", -22, 0)

    zoomOutButton:SetSize(20, 12)
    zoomOutButton:SetHitRectInsets(0, 0, 0, 0)

    normalTexture = zoomOutButton:GetNormalTexture()
    normalTexture:SetAllPoints(zoomOutButton)
    SetAtlasTexture(normalTexture, 'Minimap-ZoomOut-Normal')

    highlightTexture = zoomOutButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(zoomOutButton)
    SetAtlasTexture(highlightTexture, 'Minimap-ZoomOut-Highlight')

    pushedTexture = zoomOutButton:GetPushedTexture()
    pushedTexture:SetAllPoints(zoomOutButton)
    SetAtlasTexture(pushedTexture, 'Minimap-ZoomOut-Pushed')

    disabledTexture = zoomOutButton:GetDisabledTexture()
    disabledTexture:SetAllPoints(zoomOutButton)
    SetAtlasTexture(disabledTexture, 'Minimap-ZoomOut-Pushed')
end

local function CreateMinimapBorderFrame(width, height)
    local minimapBorderFrame = CreateFrame('Frame', UIParent)
    minimapBorderFrame:SetSize(width, height)
    minimapBorderFrame:SetScript("OnUpdate", function(self)
        local angle = GetPlayerFacing()
        self.border:SetRotation(angle)
    end)

    do
        local texture = minimapBorderFrame:CreateTexture(nil, "BORDER")
        texture:SetAllPoints(minimapBorderFrame)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\Minimap\\MinimapBorder.blp")

        minimapBorderFrame.border = texture
    end

    minimapBorderFrame:Hide()
    return minimapBorderFrame
end

local function RemoveBlizzardFrames()
    local blizzFrames = {
        MiniMapWorldMapButton,
        MiniMapTrackingIcon,
        MiniMapTrackingIconOverlay,
        MiniMapMailBorder,
        MiniMapTrackingButtonBorder,
        MiniMapLFGFrameBorder
    }

    for _, frame in pairs(blizzFrames) do
        frame:SetAlpha(0)
    end
end

local function Minimap_UpdateRotationSetting()
    local minimapBorder = MinimapBorder
    if GetCVar("rotateMinimap") == "1" then
        Module.borderFrame:Show()
        minimapBorder:Hide()
    else
        Module.borderFrame:Hide()
        minimapBorder:Show()
    end

    MinimapNorthTag:Hide()
    MinimapCompassTexture:Hide()
end

local function MiniMapMailFrame_OnEnter(self)
    local minimapMailIconTexture = MiniMapMailIcon
    minimapMailIconTexture:SetAllPoints(MiniMapMailFrame)
    SetAtlasTexture(minimapMailIconTexture, 'Minimap-Mail-Highlight')
end

local function MiniMapMailFrame_OnLeave(self)
    local minimapMailIconTexture = MiniMapMailIcon
    minimapMailIconTexture:SetAllPoints(MiniMapMailFrame)
    SetAtlasTexture(minimapMailIconTexture, 'Minimap-Mail-Normal')
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    self:SecureHook('Minimap_UpdateRotationSetting', Minimap_UpdateRotationSetting)

    MiniMapMailFrame:HookScript("OnEnter", MiniMapMailFrame_OnEnter)
    MiniMapMailFrame:HookScript("OnLeave", MiniMapMailFrame_OnLeave)

    self.minimapFrame = CreateUIFrame(230, 230, 'MinimapFrame')

    self.borderFrame = CreateMinimapBorderFrame(232, 232)
    self.borderFrame:SetPoint("CENTER", MinimapBorder, "CENTER", 0, -2)

    if not IsAddOnLoaded('Blizzard_TimeManager') then
        LoadAddOn('Blizzard_TimeManager')
    end
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")

    self:Unhook('Minimap_UpdateRotationSetting', Minimap_UpdateRotationSetting)

    MiniMapMailFrame:Unhook("OnEnter", MiniMapMailFrame_OnEnter)
    MiniMapMailFrame:Unhook("OnLeave", MiniMapMailFrame_OnLeave)
end

function Module:PLAYER_ENTERING_WORLD()
    RemoveBlizzardFrames()
    ReplaceBlizzardFrame(self.minimapFrame)

    CheckSettingsExists(Module, { 'minimap' })
end

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.minimap = { anchor = "TOPRIGHT", posX = 0, posY = 0 }
end

function Module:UpdateWidgets()
    local widgetOptions = RUI.DB.profile.widgets.minimap
    self.minimapFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
end

function Module:ShowEditorTest()
    HideUIFrame(self.minimapFrame)
end

function Module:HideEditorTest(refresh)
    ShowUIFrame(self.minimapFrame)
    SaveUIFramePosition(self.minimapFrame, 'minimap')

    if refresh then
        self:UpdateWidgets()
    end
end
