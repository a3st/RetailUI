local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local moduleName = 'Minimap'
local Module = DFUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.minimapBar = nil
Module.rotateFrame = nil

local function Minimap_UpdateRotationSetting()
    if GetCVar("rotateMinimap") == "1" then
        Module.rotateFrame:Show()
        MinimapBorder:Hide()
    else
        Module.rotateFrame:Hide()
        MinimapBorder:Show()
    end

    MinimapNorthTag:Hide()
    MinimapCompassTexture:Hide()
end

local function MinimapRotateFrame_OnUpdate(self)
    local angle = GetPlayerFacing()
    self.border:SetRotation(angle)
end

local function BuffFrame_UpdateAllBuffAnchors()
    BuffButton1:SetPoint("TOPRIGHT", -80, 0)
end

local function DebuffButton_UpdateAnchors()

end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")

    self:SecureHook('Minimap_UpdateRotationSetting', Minimap_UpdateRotationSetting)

    self:SecureHook('BuffFrame_UpdateAllBuffAnchors', BuffFrame_UpdateAllBuffAnchors)
    self:SecureHook('DebuffButton_UpdateAnchors', DebuffButton_UpdateAnchors)

    self:CreateUIFrames()

    if not IsAddOnLoaded('Blizzard_TimeManager') then
        LoadAddOn('Blizzard_TimeManager')
    end
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("CALENDAR_UPDATE_PENDING_INVITES")

    self:Unhook('Minimap_UpdateRotationSetting', Minimap_UpdateRotationSetting)

    self:Unhook('BuffFrame_UpdateAllBuffAnchors', BuffFrame_UpdateAllBuffAnchors)
    self:Unhook('DebuffButton_UpdateAnchors', DebuffButton_UpdateAnchors)
end

function Module:PLAYER_ENTERING_WORLD()
    self:RemoveBlizzardFrames()
    self:ReplaceBlizzardFrames()

    if DFUI.DB.profile.widgets.minimapBar == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

local blizzActionBarFrames = {
    MiniMapWorldMapButton,
    MiniMapTrackingIcon,
    MiniMapTrackingIconOverlay
}

function Module:RemoveBlizzardFrames()
    for _, frame in pairs(blizzActionBarFrames) do
        frame:SetAlpha(0)
    end
end

local calendarStyles = {
    {
        normalTexture = { left = 47 / 256, right = 68 / 256, top = 1 / 256, bottom = 20 / 256 },
        pushedTexture = { left = 1 / 256, right = 22 / 256, top = 1 / 256, bottom = 20 / 256 },
        highlightTexture = { left = 24 / 256, right = 45 / 256, top = 1 / 256, bottom = 20 / 256 }
    }
}

local function UpdateCalendarDate()
    --local _, _, day = CalendarGetDate()
    local day = 1

    local gameTimeFrame = GameTimeFrame

    local normalTexture = gameTimeFrame:GetNormalTexture()
    normalTexture:SetAllPoints(gameTimeFrame)
    normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\Minimap\\Calendar.blp")
    normalTexture:SetTexCoord(calendarStyles[day].normalTexture.left, calendarStyles[day].normalTexture.right,
        calendarStyles[day].normalTexture.top, calendarStyles[day].normalTexture.bottom)

    local highlightTexture = gameTimeFrame:GetHighlightTexture()
    highlightTexture:SetAllPoints(gameTimeFrame)
    highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\Minimap\\Calendar.blp")
    highlightTexture:SetTexCoord(calendarStyles[day].highlightTexture.left,
        calendarStyles[day].highlightTexture.right, calendarStyles[day].highlightTexture.top,
        calendarStyles[day].highlightTexture.bottom)

    local pushedTexture = gameTimeFrame:GetPushedTexture()
    pushedTexture:SetAllPoints(gameTimeFrame)
    pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\Minimap\\Calendar.blp")
    pushedTexture:SetTexCoord(calendarStyles[day].pushedTexture.left,
        calendarStyles[day].pushedTexture.right, calendarStyles[day].pushedTexture.top,
        calendarStyles[day].pushedTexture.bottom)
end

function Module:CALENDAR_UPDATE_PENDING_INVITES()
    UpdateCalendarDate()
end

function Module:ReplaceBlizzardFrames()
    local minimapCluster = MinimapCluster
    minimapCluster:ClearAllPoints()

    minimapCluster:SetPoint("CENTER", self.minimapBar, "CENTER", 0, 0)

    -- Zone Info Bar
    local minimapBorderTop = MinimapBorderTop
    minimapBorderTop:ClearAllPoints()
    minimapBorderTop:SetPoint("TOP", 0, 0)
    minimapBorderTop:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    minimapBorderTop:SetTexCoord(105 / 512, 360 / 512, 609 / 1024, 636 / 1024)
    minimapBorderTop:SetSize(156, 20)

    local minimapZoneButton = MinimapZoneTextButton
    minimapZoneButton:ClearAllPoints()
    minimapZoneButton:SetPoint("TOP", -23, -4)

    local timeClockButton = TimeManagerClockButton
    timeClockButton:GetRegions():Hide()
    timeClockButton:ClearAllPoints()
    timeClockButton:SetPoint("RIGHT", minimapBorderTop, "RIGHT", 5, 1)

    -- GameTime (Calendar)
    local gameTimeFrame = GameTimeFrame
    gameTimeFrame:ClearAllPoints()
    gameTimeFrame:SetPoint("LEFT", minimapBorderTop, "RIGHT", 5, -1)
    gameTimeFrame:SetSize(26, 24)
    gameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
    gameTimeFrame:GetFontString():Hide()

    UpdateCalendarDate()

    -- Tracking
    local minimapTracking = MiniMapTracking
    minimapTracking:ClearAllPoints()
    minimapTracking:SetPoint("RIGHT", minimapBorderTop, "LEFT", -5, 0)
    minimapTracking:SetSize(26, 24)

    local background = _G[minimapTracking:GetName() .. "Background"]
    background:SetAllPoints(minimapTracking)
    background:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    background:SetTexCoord(441 / 512, 480 / 512, 402 / 1024, 440 / 1024)

    local minimapTrackingButton = _G[minimapTracking:GetName() .. 'Button']
    minimapTrackingButton:ClearAllPoints()
    minimapTrackingButton:SetPoint("CENTER", 0, 0)

    minimapTrackingButton:SetSize(17, 15)
    minimapTrackingButton:SetHitRectInsets(0, 0, 0, 0)

    local shine = _G[minimapTrackingButton:GetName() .. "Shine"]
    shine:SetTexture(nil)

    local border = _G[minimapTrackingButton:GetName() .. "Border"]
    border:SetTexture(nil)

    local normalTexture = minimapTrackingButton:GetNormalTexture() or minimapTrackingButton:CreateTexture(nil, "BORDER")
    normalTexture:SetAllPoints(minimapTrackingButton)
    normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    normalTexture:SetTexCoord(149 / 512, 179 / 512, 520 / 1024, 548 / 1024)

    minimapTrackingButton:SetNormalTexture(normalTexture)

    local highlightTexture = minimapTrackingButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(minimapTrackingButton)
    highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    highlightTexture:SetTexCoord(117 / 512, 147 / 512, 520 / 1024, 548 / 1024)

    local pushedTexture = minimapTrackingButton:GetPushedTexture() or minimapTrackingButton:CreateTexture(nil, "BORDER")
    pushedTexture:SetAllPoints(minimapTrackingButton)
    pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    pushedTexture:SetTexCoord(83 / 512, 115 / 512, 520 / 1024, 550 / 1024)

    minimapTrackingButton:SetPushedTexture(pushedTexture)

    -- Minimap Frame
    local minimapFrame = Minimap
    minimapFrame:ClearAllPoints()
    minimapFrame:SetPoint("CENTER", self.minimapBar, "CENTER", 0, -30)
    minimapFrame:SetSize(175, 175)

    local minimapBackdrop = MinimapBackdrop
    minimapBackdrop:ClearAllPoints()
    minimapBackdrop:SetPoint("CENTER", minimapFrame, "CENTER", 0, 3)

    local minimapBorder = MinimapBorder
    minimapBorder:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    minimapBorder:SetTexCoord(1 / 512, 431 / 512, 63 / 1024, 498 / 1024)

    local zoomInButton = MinimapZoomIn
    zoomInButton:ClearAllPoints()
    zoomInButton:SetPoint("BOTTOMRIGHT", 0, 15)

    zoomInButton:SetSize(25, 24)
    zoomInButton:SetHitRectInsets(0, 0, 0, 0)

    normalTexture = zoomInButton:GetNormalTexture()
    normalTexture:SetAllPoints(zoomInButton)
    normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    normalTexture:SetTexCoord(1 / 512, 35 / 512, 552 / 1024, 586 / 1024)

    highlightTexture = zoomInButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(zoomInButton)
    highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    highlightTexture:SetTexCoord(1 / 512, 35 / 512, 624 / 1024, 658 / 1024)

    pushedTexture = zoomInButton:GetPushedTexture()
    pushedTexture:SetAllPoints(zoomInButton)
    pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    pushedTexture:SetTexCoord(1 / 512, 35 / 512, 588 / 1024, 622 / 1024)

    local disabledTexture = zoomInButton:GetDisabledTexture()
    disabledTexture:SetAllPoints(zoomInButton)
    disabledTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    disabledTexture:SetTexCoord(1 / 512, 35 / 512, 588 / 1024, 622 / 1024)

    local zoomOutButton = MinimapZoomOut
    zoomOutButton:ClearAllPoints()
    zoomOutButton:SetPoint("BOTTOMRIGHT", -22, 0)

    zoomOutButton:SetSize(20, 12)
    zoomOutButton:SetHitRectInsets(0, 0, 0, 0)

    normalTexture = zoomOutButton:GetNormalTexture()
    normalTexture:SetAllPoints(zoomOutButton)
    normalTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    normalTexture:SetTexCoord(181 / 512, 215 / 512, 520 / 1024, 538 / 1024)

    highlightTexture = zoomOutButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(zoomOutButton)
    highlightTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    highlightTexture:SetTexCoord(253 / 512, 287 / 512, 520 / 1024, 538 / 1024)

    pushedTexture = zoomOutButton:GetPushedTexture()
    pushedTexture:SetAllPoints(zoomOutButton)
    pushedTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    pushedTexture:SetTexCoord(217 / 512, 251 / 512, 520 / 1024, 538 / 1024)

    disabledTexture = zoomOutButton:GetDisabledTexture()
    disabledTexture:SetAllPoints(zoomOutButton)
    disabledTexture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-Minimap.blp")
    disabledTexture:SetTexCoord(217 / 512, 251 / 512, 520 / 1024, 538 / 1024)
end

function Module:CreateUIFrames()
    self.minimapBar = CreateUIFrameBar(250, 250, 'Minimap')

    do
        local rotateFrame = CreateFrame('Frame', MinimapBackdrop)
        rotateFrame:SetScript("OnUpdate", MinimapRotateFrame_OnUpdate)

        do
            local texture = rotateFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("CENTER", MinimapBorder, "CENTER", 0, -2)
            texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\Minimap\\MinimapBorder.blp")
            texture:SetSize(232, 232)

            rotateFrame.border = texture
        end

        rotateFrame:Hide()
        self.rotateFrame = rotateFrame
    end
end

function Module:LoadDefaultSettings()
    DFUI.DB.profile.widgets.minimapBar = { anchor = "CENTER", posX = 0, posY = 0 }
end

function Module:UpdateWidgets()
    do
        local widgetOptions = DFUI.DB.profile.widgets.minimapBar
        self.minimapBar:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
    end
end

function Module:EnableEditorPreviewForMinimapFrame()
    local minimapBar = self.minimapBar

    minimapBar:SetMovable(true)
    minimapBar:EnableMouse(true)

    minimapBar.editorTexture:Show()
    minimapBar.editorText:Show()
end

function Module:DisableEditorPreviewForMinimapFrame()
    local minimapBar = self.minimapBar

    minimapBar:SetMovable(false)
    minimapBar:EnableMouse(false)

    minimapBar.editorTexture:Hide()
    minimapBar.editorText:Hide()

    local _, _, relativePoint, posX, posY = minimapBar:GetPoint('CENTER')
    DFUI.DB.profile.widgets.minimapBar.anchor = relativePoint
    DFUI.DB.profile.widgets.minimapBar.posX = posX
    DFUI.DB.profile.widgets.minimapBar.posY = posY
end
