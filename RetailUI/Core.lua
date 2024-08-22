local RUI = LibStub('AceAddon-3.0'):NewAddon('RetailUI', 'AceConsole-3.0')
local AceConfig = LibStub("AceConfig-3.0")
local AceDB = LibStub("AceDB-3.0")

RUI.InterfaceVersion = select(4, GetBuildInfo())
RUI.Wrath = (RUI.InterfaceVersion >= 30300)
RUI.DB = nil

function RUI:OnInitialize()
	RUI.DB = AceDB:New("RetailUIDB", RUI.default, true)
	AceConfig:RegisterOptionsTable("RUI Commands", RUI.optionsSlash, "rui")
end

function RUI:OnEnable() end

function RUI:OnDisable() end

function CreateUIFrame(width, height, frameName)
	local unitFrame = CreateFrame("Frame", 'RUI_' .. frameName, UIParent)
	unitFrame:SetSize(width, height)

	unitFrame:RegisterForDrag("LeftButton")
	unitFrame:EnableMouse(false)
	unitFrame:SetMovable(false)
	unitFrame:SetScript("OnDragStart", function(self, button)
		self:StartMoving()
	end)
	unitFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	do
		local texture = unitFrame:CreateTexture(nil, 'BACKGROUND')
		texture:SetAllPoints(unitFrame)
		texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI-ActionBar.blp")
		texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
		texture:Hide()

		unitFrame.editorTexture = texture
	end

	do
		local fontString = unitFrame:CreateFontString(nil, "BORDER", 'GameFontNormal')
		fontString:SetAllPoints(unitFrame)
		fontString:SetText(frameName)
		fontString:Hide()

		unitFrame.editorText = fontString
	end

	return unitFrame
end
