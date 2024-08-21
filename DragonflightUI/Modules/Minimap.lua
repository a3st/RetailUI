local DFUI = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
local moduleName = 'Minimap'
local Module = DFUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    self:CreateUIFrames()
end

function Module:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Module:PLAYER_ENTERING_WORLD()

end

function Module:CreateUIFrames()

end
