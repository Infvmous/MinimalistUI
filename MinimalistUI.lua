local addonName, MinimalistUI = ...

MinimalistUI.modules = {}

local eventHandler = CreateFrame("Frame", nil, UIParent)

eventHandler:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
eventHandler:RegisterEvent("ADDON_LOADED")

MinimalistUI.defaultSettings = {
   profile = {},
}

MinimalistUI.optionsTable = {
   name = "MinimalistUI",
   type = "group",
	childGroups = "tab",
	validate = function()
				     if InCombatLockdown() then
	                 return "Get out of combat first!"
				     else
	                 return true
	              end
               end,
	args = {},
}

function MinimalistUI:CreateModule(m)
	self.modules[m] = {}
	return self.modules[m]
end

function MinimalistUI:OnProfileChange()
	for m, _ in pairs(self.modules) do
		self.modules[m].db = self.db.profile[m]
		if self.modules[m].OnProfileChange then
			self.modules[m]:OnProfileChange()
		end
	end
end

function eventHandler:ADDON_LOADED(addon)
	if addon ~= addonName then return end
	local order = 0
	for m, _ in pairs(MinimalistUI.modules) do
      MinimalistUI.optionsTable.args[m] = {
			name = m,
			type = "group",
			order = order,
			get = function(info) return MinimalistUI.modules[m].db[info[#info]] end,
			args = MinimalistUI.modules[m].optionsTable,
		}
		MinimalistUI.defaultSettings.profile[m] = MinimalistUI.modules[m].defaultSettings
		order = order + 1
	end

	MinimalistUI.db = LibStub("AceDB-3.0"):New("MinimalistUI_DB", MinimalistUI.defaultSettings, true)
	MinimalistUI.optionsTable.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(MinimalistUI.db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MinimalistUI", MinimalistUI.optionsTable)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MinimalistUI", "MinimalistUI")
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("MinimalistUI", 420, 400)
	MinimalistUI.db.RegisterCallback(self, "OnProfileChanged", MinimalistUI.OnProfileChange)
	MinimalistUI.db.RegisterCallback(self, "OnProfileCopied", MinimalistUI.OnProfileChange)
	MinimalistUI.db.RegisterCallback(self, "OnProfileReset", MinimalistUI.OnProfileChange)

	for m, _ in pairs(MinimalistUI.modules) do
		MinimalistUI.modules[m].db = MinimalistUI.db.profile[m]
		if MinimalistUI.modules[m].OnLoad then
			MinimalistUI.modules[m]:OnLoad()
		end
	end
end