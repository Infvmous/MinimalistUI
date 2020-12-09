local addonName, MinimalistUI = ...

MinimalistUI.modules = {}

-- Event handler for ADD_LOADED
local EventHandler = CreateFrame("Frame", nil, UIParent)

EventHandler:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)
EventHandler:RegisterEvent("ADDON_LOADED")


MinimalistUI.defaultSettings = {
	profile = {
	},
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
	args = {
	},
}


function MinimalistUI:CreateModule(module)
	self.modules[module] = {}
	return self.modules[module]
end


function MinimalistUI:OnProfileChange()
	for module, _ in pairs(self.modules) do
		self.modules[module].db = self.db.profile[module]
		if self.modules[module].OnProfileChange then
			self.modules[module]:OnProfileChange()
		end
	end
end


function EventHandler:ADDON_LOADED(addon)
	if addon ~= addonName then
		return
	end

	local order = 0
	for module, _ in pairs(MinimalistUI.modules) do
		MinimalistUI.optionsTable.args[module] = {
			name = module,
			type = "group",
			order = order,
			get = function(info) return MinimalistUI.modules[module].db[info[#info]] end,
			args = MinimalistUI.modules[module].optionsTable,
		}

		MinimalistUI.defaultSettings.profile[module] = MinimalistUI.modules[module].defaultSettings

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

	for module, _ in pairs(MinimalistUI.modules) do
		MinimalistUI.modules[module].db = MinimalistUI.db.profile[module]
		if MinimalistUI.modules[module].OnLoad then
			MinimalistUI.modules[module]:OnLoad()
		end
	end
end