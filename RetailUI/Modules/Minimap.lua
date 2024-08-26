local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'Minimap'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

Module.minimapFrame = nil
Module.rotateFrame = nil

local function ReplaceBlizzardFrame(frame)
    local minimapCluster = MinimapCluster
    minimapCluster:ClearAllPoints()

    minimapCluster:SetPoint("CENTER", frame, "CENTER", 0, 0)

    -- Zone Info Bar
    local minimapBorderTop = MinimapBorderTop
    minimapBorderTop:ClearAllPoints()
    minimapBorderTop:SetPoint("TOP", 0, 5)
    minimapBorderTop:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    minimapBorderTop:SetTexCoord(105 / 512, 360 / 512, 609 / 1024, 636 / 1024)
    minimapBorderTop:SetSize(156, 20)

    local minimapZoneButton = MinimapZoneTextButton
    minimapZoneButton:ClearAllPoints()
    minimapZoneButton:SetPoint("LEFT", minimapBorderTop, "LEFT", 5, 0)
    minimapZoneButton:SetWidth(95)

    local minimapZoneText = MinimapZoneText
    minimapZoneText:SetAllPoints(minimapZoneButton)

    local timeClockButton = TimeManagerClockButton
    timeClockButton:GetRegions():Hide()
    timeClockButton:ClearAllPoints()
    timeClockButton:SetPoint("RIGHT", minimapBorderTop, "RIGHT", -5, 1)
    timeClockButton:SetWidth(30)

    -- GameTime (Calendar)
    local gameTimeFrame = GameTimeFrame
    gameTimeFrame:ClearAllPoints()
    gameTimeFrame:SetPoint("LEFT", minimapBorderTop, "RIGHT", 5, -1)
    gameTimeFrame:SetSize(26, 24)
    gameTimeFrame:SetHitRectInsets(0, 0, 0, 0)

    local dateText = gameTimeFrame:GetFontString()
    dateText:SetAllPoints(gameTimeFrame)
    dateText:SetPoint("TOPLEFT", -3, 4)

    local normalTexture = gameTimeFrame:GetNormalTexture()
    normalTexture:SetAllPoints(gameTimeFrame)
    normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\Minimap\\Calendar.blp")
    normalTexture:SetTexCoord(0.18359375, 0.265625, 0.00390625, 0.078125)

    local highlightTexture = gameTimeFrame:GetHighlightTexture()
    highlightTexture:SetAllPoints(gameTimeFrame)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\Minimap\\Calendar.blp")
    highlightTexture:SetTexCoord(0.09375, 0.17578125, 0.00390625, 0.078125)

    local pushedTexture = gameTimeFrame:GetPushedTexture()
    pushedTexture:SetAllPoints(gameTimeFrame)
    pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\Minimap\\Calendar.blp")
    pushedTexture:SetTexCoord(0.00390625, 0.0859375, 0.00390625, 0.078125)

    -- Mail
    local minimapFrame = MiniMapMailFrame
    minimapFrame:ClearAllPoints()
    minimapFrame:SetPoint("TOPLEFT", -20, 8)
    minimapFrame:SetSize(24, 20)
    minimapFrame:SetHitRectInsets(0, 0, 0, 0)

    local minimapMailIcon = MiniMapMailIcon
    minimapMailIcon:SetAllPoints(minimapFrame)
    minimapMailIcon:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    minimapMailIcon:SetTexCoord(42 / 512, 81 / 512, 520 / 1024, 550 / 1024)

    -- PVP
    local minimapBattlefieldFrame = MiniMapBattlefieldFrame
    minimapBattlefieldFrame:ClearAllPoints()
    minimapBattlefieldFrame:SetPoint("BOTTOMLEFT", 8, 2)

    -- Eye
    local minimapLFGFrame = MiniMapLFGFrame
    minimapLFGFrame:ClearAllPoints()
    minimapLFGFrame:SetPoint("BOTTOMLEFT", -5, 15)
    minimapLFGFrame:SetSize(50, 50)
    minimapLFGFrame:SetHitRectInsets(0, 0, 0, 0)

    -- Instance Difficulty
    local minimapInstance = MiniMapInstanceDifficulty
    minimapInstance:ClearAllPoints()
    minimapInstance:SetPoint("TOPRIGHT", -15, -15)

    local eyeFrame = _G[minimapLFGFrame:GetName() .. 'Icon']
    eyeFrame:SetAllPoints(minimapLFGFrame)

    local icon = eyeFrame.texture
    icon:SetAllPoints(eyeFrame)
    icon:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\Minimap\\EyeGroupFinderFlipbook.blp")

    -- Tracking
    local minimapTracking = MiniMapTracking
    minimapTracking:ClearAllPoints()
    minimapTracking:SetPoint("RIGHT", minimapBorderTop, "LEFT", -5, 0)
    minimapTracking:SetSize(26, 24)

    local background = _G[minimapTracking:GetName() .. "Background"]
    background:SetAllPoints(minimapTracking)
    background:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    background:SetTexCoord(441 / 512, 480 / 512, 402 / 1024, 440 / 1024)

    local minimapTrackingButton = _G[minimapTracking:GetName() .. 'Button']
    minimapTrackingButton:ClearAllPoints()
    minimapTrackingButton:SetPoint("CENTER", 0, 0)

    minimapTrackingButton:SetSize(17, 15)
    minimapTrackingButton:SetHitRectInsets(0, 0, 0, 0)

    local shine = _G[minimapTrackingButton:GetName() .. "Shine"]
    shine:SetTexture(nil)

    local normalTexture = minimapTrackingButton:GetNormalTexture() or minimapTrackingButton:CreateTexture(nil, "BORDER")
    normalTexture:SetAllPoints(minimapTrackingButton)
    normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    normalTexture:SetTexCoord(149 / 512, 179 / 512, 520 / 1024, 548 / 1024)

    minimapTrackingButton:SetNormalTexture(normalTexture)

    local highlightTexture = minimapTrackingButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(minimapTrackingButton)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    highlightTexture:SetTexCoord(117 / 512, 147 / 512, 520 / 1024, 548 / 1024)

    local pushedTexture = minimapTrackingButton:GetPushedTexture() or minimapTrackingButton:CreateTexture(nil, "BORDER")
    pushedTexture:SetAllPoints(minimapTrackingButton)
    pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    pushedTexture:SetTexCoord(83 / 512, 115 / 512, 520 / 1024, 550 / 1024)

    minimapTrackingButton:SetPushedTexture(pushedTexture)

    -- Minimap Frame
    local minimapFrame = Minimap
    minimapFrame:ClearAllPoints()
    minimapFrame:SetPoint("CENTER", minimapCluster, "CENTER", 0, -30)
    minimapFrame:SetSize(175, 175)

    local minimapBackdrop = MinimapBackdrop
    minimapBackdrop:ClearAllPoints()
    minimapBackdrop:SetPoint("CENTER", minimapFrame, "CENTER", 0, 3)

    local minimapBorder = MinimapBorder
    minimapBorder:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    minimapBorder:SetTexCoord(1 / 512, 431 / 512, 63 / 1024, 498 / 1024)

    local zoomInButton = MinimapZoomIn
    zoomInButton:ClearAllPoints()
    zoomInButton:SetPoint("BOTTOMRIGHT", 0, 15)

    zoomInButton:SetSize(25, 24)
    zoomInButton:SetHitRectInsets(0, 0, 0, 0)

    normalTexture = zoomInButton:GetNormalTexture()
    normalTexture:SetAllPoints(zoomInButton)
    normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    normalTexture:SetTexCoord(1 / 512, 35 / 512, 552 / 1024, 586 / 1024)

    highlightTexture = zoomInButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(zoomInButton)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    highlightTexture:SetTexCoord(1 / 512, 35 / 512, 624 / 1024, 658 / 1024)

    pushedTexture = zoomInButton:GetPushedTexture()
    pushedTexture:SetAllPoints(zoomInButton)
    pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    pushedTexture:SetTexCoord(1 / 512, 35 / 512, 588 / 1024, 622 / 1024)

    local disabledTexture = zoomInButton:GetDisabledTexture()
    disabledTexture:SetAllPoints(zoomInButton)
    disabledTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    disabledTexture:SetTexCoord(1 / 512, 35 / 512, 588 / 1024, 622 / 1024)

    local zoomOutButton = MinimapZoomOut
    zoomOutButton:ClearAllPoints()
    zoomOutButton:SetPoint("BOTTOMRIGHT", -22, 0)

    zoomOutButton:SetSize(20, 12)
    zoomOutButton:SetHitRectInsets(0, 0, 0, 0)

    normalTexture = zoomOutButton:GetNormalTexture()
    normalTexture:SetAllPoints(zoomOutButton)
    normalTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    normalTexture:SetTexCoord(181 / 512, 215 / 512, 520 / 1024, 538 / 1024)

    highlightTexture = zoomOutButton:GetHighlightTexture()
    highlightTexture:SetAllPoints(zoomOutButton)
    highlightTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    highlightTexture:SetTexCoord(253 / 512, 287 / 512, 520 / 1024, 538 / 1024)

    pushedTexture = zoomOutButton:GetPushedTexture()
    pushedTexture:SetAllPoints(zoomOutButton)
    pushedTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    pushedTexture:SetTexCoord(217 / 512, 251 / 512, 520 / 1024, 538 / 1024)

    disabledTexture = zoomOutButton:GetDisabledTexture()
    disabledTexture:SetAllPoints(zoomOutButton)
    disabledTexture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-Minimap.blp")
    disabledTexture:SetTexCoord(217 / 512, 251 / 512, 520 / 1024, 538 / 1024)
end

local blizzFrames = {
    MiniMapWorldMapButton,
    MiniMapTrackingIcon,
    MiniMapTrackingIconOverlay,
    MiniMapMailBorder,
    MiniMapTrackingButtonBorder,
    MiniMapLFGFrameBorder
}

local function RemoveBlizzardFrames()
    for _, frame in pairs(blizzFrames) do
        frame:SetAlpha(0)
    end
end

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

local function MiniMapLFGFrame_OnUpdate(self, elapsed)
    AnimateTexCoords(self.texture, 512, 256, 64, 64, 29, elapsed, 1)
end

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    self:SecureHook('Minimap_UpdateRotationSetting', Minimap_UpdateRotationSetting)
    MiniMapLFGFrameIcon:HookScript('OnUpdate', MiniMapLFGFrame_OnUpdate)

    self.minimapFrame = CreateUIFrame(230, 230, 'MinimapFrame')

    do
        local rotateFrame = CreateFrame('Frame', MinimapBackdrop)
        rotateFrame:SetScript("OnUpdate", MinimapRotateFrame_OnUpdate)

        do
            local texture = rotateFrame:CreateTexture(nil, "BORDER")
            texture:SetPoint("CENTER", MinimapBorder, "CENTER", 0, -2)
            texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\Minimap\\MinimapBorder.blp")
            texture:SetSize(232, 232)

            rotateFrame.border = texture
        end

        rotateFrame:Hide()
        self.rotateFrame = rotateFrame
    end

    if not IsAddOnLoaded('Blizzard_TimeManager') then
        LoadAddOn('Blizzard_TimeManager')
    end
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")

    self:Unhook('Minimap_UpdateRotationSetting', Minimap_UpdateRotationSetting)
    MiniMapLFGFrameIcon:Unhook('OnUpdate', MiniMapLFGFrame_OnUpdate)
end

function Module:PLAYER_ENTERING_WORLD()
    RemoveBlizzardFrames()
    ReplaceBlizzardFrame(self.minimapFrame)

    if RUI.DB.profile.widgets.minimap == nil then
        self:LoadDefaultSettings()
    end

    self:UpdateWidgets()
end

function Module:LoadDefaultSettings()
    RUI.DB.profile.widgets.minimap = { anchor = "TOPRIGHT", posX = 0, posY = 0 }
end

function Module:UpdateWidgets()
    local widgetOptions = RUI.DB.profile.widgets.minimap
    self.minimapFrame:SetPoint(widgetOptions.anchor, widgetOptions.posX, widgetOptions.posY)
end

function Module:EnableEditorPreview()
    HideUIFrame(self.minimapFrame)
end

function Module:DisableEditorPreview()
    ShowUIFrame(self.minimapFrame)
    SaveUIFramePosition(self.minimapFrame, 'minimap')
end
