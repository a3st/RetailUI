--[[
    Copyright (c) Dmitriy. All rights reserved.
    Licensed under the MIT license. See LICENSE file in the project root for details.
]]

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
	local frame = CreateFrame("Frame", 'RUI_' .. frameName, UIParent)
	frame:SetSize(width, height)

	frame:RegisterForDrag("LeftButton")
	frame:EnableMouse(false)
	frame:SetMovable(false)
	frame:SetScript("OnDragStart", function(self, button)
		self:StartMoving()
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	frame:SetFrameLevel(100)
	frame:SetFrameStrata('FULLSCREEN')

	do
		local texture = frame:CreateTexture(nil, 'BACKGROUND')
		texture:SetAllPoints(frame)
		texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI\\ActionBarHorizontal.blp")
		texture:SetTexCoord(0, 512 / 512, 14 / 2048, 85 / 2048)
		texture:Hide()

		frame.editorTexture = texture
	end

	do
		local fontString = frame:CreateFontString(nil, "BORDER", 'GameFontNormal')
		fontString:SetAllPoints(frame)
		fontString:SetText(frameName)
		fontString:Hide()

		frame.editorText = fontString
	end

	return frame
end

RUI.frames = {}

function ShowUIFrame(frame)
	frame:SetMovable(false)
	frame:EnableMouse(false)

	frame.editorTexture:Hide()
	frame.editorText:Hide()

	for _, target in pairs(RUI.frames[frame]) do
		target:SetAlpha(1)
	end

	RUI.frames[frame] = nil
end

function HideUIFrame(frame, exclude)
	frame:SetMovable(true)
	frame:EnableMouse(true)

	frame.editorTexture:Show()
	frame.editorText:Show()

	RUI.frames[frame] = {}

	exclude = exclude or {}

	for _, target in pairs(exclude) do
		target:SetAlpha(0)
		tinsert(RUI.frames[frame], target)
	end
end

function SaveUIFramePosition(frame, widgetName)
	local _, _, relativePoint, posX, posY = frame:GetPoint('CENTER')
	RUI.DB.profile.widgets[widgetName].anchor = relativePoint
	RUI.DB.profile.widgets[widgetName].posX = posX
	RUI.DB.profile.widgets[widgetName].posY = posY
end

function CheckSettingsExists(self, widgets)
	for _, widget in pairs(widgets) do
		if RUI.DB.profile.widgets[widget] == nil then
			self:LoadDefaultSettings()
			break
		end
	end
	self:UpdateWidgets()
end
