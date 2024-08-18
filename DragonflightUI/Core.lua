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
