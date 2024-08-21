local DFUI = LibStub('AceAddon-3.0'):NewAddon('DragonflightUI', 'AceConsole-3.0')
local AceConfig = LibStub("AceConfig-3.0")
local AceDB = LibStub("AceDB-3.0")

DFUI.InterfaceVersion = select(4, GetBuildInfo())
DFUI.Wrath = (DFUI.InterfaceVersion >= 30300)

DFUI.DB = nil

function DFUI:OnInitialize()
	DFUI.DB = AceDB:New("DragonflightUIDB", DFUI.default, true)
	AceConfig:RegisterOptionsTable("DFUI Commands", DFUI.optionsSlash, "dfui")
end

function DFUI:OnEnable()

end

function DFUI:OnDisable()

end

function CreateUIFrameBar(width, height, frameName)
	local unitFrameBar = CreateFrame("Frame", 'DFUI_' .. frameName, UIParent)
	unitFrameBar:SetSize(width, height)

	unitFrameBar:RegisterForDrag("LeftButton")
	unitFrameBar:EnableMouse(false)
	unitFrameBar:SetMovable(false)
	unitFrameBar:SetScript("OnDragStart", function(self, button)
		self:StartMoving()
	end)
	unitFrameBar:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	do
		local texture = unitFrameBar:CreateTexture(nil, 'BACKGROUND')
		texture:SetAllPoints(unitFrameBar)
		texture:SetTexture("Interface\\AddOns\\DragonflightUI\\Textures\\UI-ActionBar.blp")
		texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
		texture:Hide()

		unitFrameBar.editorTexture = texture
	end

	do
		local fontString = unitFrameBar:CreateFontString(nil, "BORDER", 'GameFontNormal')
		fontString:SetAllPoints(unitFrameBar)
		fontString:SetText(frameName)
		fontString:Hide()

		unitFrameBar.editorText = fontString
	end

	return unitFrameBar
end
