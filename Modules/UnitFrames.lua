local _, MinimalistUI = ...
local UnitFrames = MinimalistUI:CreateModule("Unit Frames")

local playerFrame = PlayerFrame
local targetFrame = TargetFrame
local focusFrame = FocusFrame

-- Size of icons for combat indicator
--local iconWidth  = 30
--local iconHeight = 30


-- Class colors
--local sb = _G.GameTooltipStatusBar
--local	UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS, PlayerFrameHealthBar =
--		UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS, PlayerFrameHealthBar
--local _, class, c

-- Feedback text
--local feedbackText = PlayerFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")

-- Sizes for buffs, castbars, ui etc
--local minVal = 0.65
--local maxVal = 1.5
--local sliderStep = 0.01
--local sliderBigStep = 0.05


local eventHandler = CreateFrame("Frame", nil , UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)


function UnitFrames:OnLoad()
	-- Combat indicators
	self:EnableCombatIndicator(self.db.combatIndicator)

	--eventHandler:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

	--hooksecurefunc("UnitFrameHealthBar_Update", self.ColorStatusbar)
	--hooksecurefunc("HealthBar_OnValueChanged", function(self)
	--	UnitFrames.ColorStatusbar(self, self.unit)
	--end)
	
	--self:HidePvPIcons(self.db.hidePvpIcons)
	--self:HideFeedbackText(self.db.hideFeedbackText)
	--self:MoveTargetOfTarget(self.db.moveTargetOfTarget)
	--self:HandleCombatIndicator(self.db.combatIndicator)

	--hooksecurefunc("PlayerFrame_UpdateStatus", function()
 --   	self:HideRestingStatus(self.db.hideRestingStatus)

 --   	-- Hide Player leader/guide icons
 --   	PlayerGuideIcon:Hide()
	--	PlayerLeaderIcon:Hide()

	--	-- Hide combat flashing animation
	--	PlayerFrameFlash:Hide()
	--end)

	--hooksecurefunc("TargetFrame_Update", function()
	--	-- Hide leader icon on Target
	--	self.targetFrame.leaderIcon:Hide()
	--	self.focusFrame.leaderIcon:Hide()
	--end)

	--hooksecurefunc("TargetFrame_Update", function()
	--	-- Hide leader icon on Target
	--	self.targetFrame.leaderIcon:Hide()
	--end)

	--hooksecurefunc("PlayerFrame_UpdateRolesAssigned", function()
	--	-- Hide role icon on playerframe
	--	local roleIcon = _G[UnitFrames.playerFrame:GetName().."RoleIcon"]
	--	roleIcon:Hide()
	--end)

	--self:ChangeCastBarSize(self.db.castBarSize)
end


function UnitFrames:OnProfileChange()
	--self:HandleCombatIndicator(self.db.combatIndicator)
	--self:HidePvPIcons(self.db.hidePvpIcons)
	--self:HideFeedbackText(self.db.hideFeedbackText)
	--self:MoveTargetOfTarget(self.db.moveTargetOfTarget)

	--hooksecurefunc("PlayerFrame_UpdateStatus", function()
 --   	UnitFrames:HideRestingStatus(self.db.hideRestingStatus)
	--end)

	--self:ChangeCastBarSize(self.db.castBarSize)

	--UnitFrameHealthBar_Update(PlayerFrameHealthBar, "player")
	--UnitFrameHealthBar_Update(TargetFrameHealthBar, "target")
	--UnitFrameHealthBar_Update(FocusFrameHealthBar, "focus")
end


-- Class colors on health bars
--function eventHandler:UPDATE_MOUSEOVER_UNIT()
--	if UnitFrames.db.classColors[3] then
--		UnitFrames.ColorStatusbar(sb, "mouseover") end
--end


--function UnitFrames.ColorStatusbar(statusbar, unit)
--	if statusbar == PlayerFrameHealthBar and not
--			UnitFrames.db.classColors[1] then return
--	end
	
--	if statusbar ~= PlayerFrameHealthBar and
--			statusbar ~= sb and not
--			UnitFrames.db.classColors[2] then return
--	end

--	if UnitIsPlayer(unit) and
--			UnitIsConnected(unit) and
--			UnitClass(unit) then
--		if unit == statusbar.unit or statusbar == sb then
--			_, class = UnitClass(unit)
--			c = RAID_CLASS_COLORS[class]
--			statusbar:SetStatusBarColor(c.r, c.g, c.b)
--		end
--	end
--end


-- Toggle for feedback text
--function UnitFrames:HideFeedbackText(hide)
--	self.db.hideFeedbackText = hide
--	if hide then
--		PlayerFrame.feedbackText = feedbackText
--		PlayerFrame.feedbackStartTime = 0
--		PetFrame.feedbackText = feedbackText
--		PetFrame.feedbackStartTime = 0

--		PlayerHitIndicator:Hide()
--		PetHitIndicator:Hide()
--	else
--		local time = GetTime()
--		PlayerFrame.feedbackText = PlayerHitIndicator
--		PlayerFrame.feedbackStartTime = time
--		PetFrame.feedbackText = PetHitIndicator
--		PetFrame.feedbackStartTime = time
--	end
--end


-- Combat indicators for target & focus
function UnitFrames:AddCombatIconTextureTo(frame)
	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetTexture("Interface\\CHARACTERFRAME\\UI-StateIcon.blp")
	texture:SetTexCoord(.5, 1, 0, .484375)
	texture:SetWidth(32)
	texture:SetHeight(31)
	texture:SetPoint("TOPLEFT")
	return texture
end

function UnitFrames:CreateCombatIconFrameOn(parentFrame)
	local frame = CreateFrame("Frame", nil, parentFrame)
	frame:SetWidth(30)
	frame:SetHeight(30)
	frame:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -39, 21)
	frame:Hide()
	UnitFrames:AddCombatIconTextureTo(frame)
	RaiseFrameLevel(frame)
	return frame
end

local targetCombatIconFrame = UnitFrames:CreateCombatIconFrameOn(targetFrame)
local focusCombatIconFrame = UnitFrames:CreateCombatIconFrameOn(focusFrame)

function UnitFrames:ToggleCombatIndicator(parentFrame, indicator, unit)
	if UnitAffectingCombat(unit) then
		indicator:Show()
		parentFrame.levelText:Hide()
	else
		indicator:Hide()
		parentFrame.levelText:Show()
	end
end

function UnitFrames:EnableCombatIndicator(enable)
	self.db.combatIndicator = enable
	if enable then
		eventHandler:SetScript("OnUpdate", function()
			self:ToggleCombatIndicator(targetFrame, targetCombatIconFrame, "target")
			self:ToggleCombatIndicator(focusFrame, focusCombatIconFrame, "focus")
		end)
	else
		eventHandler:SetScript("OnUpdate", nil)
		targetCombatIconFrame:Hide()
		focusCombatIconFrame:Hide()
		targetFrame.levelText:Show()
		focusFrame.levelText:Show()
	end
end


-- Hide PvP and Prestige icons on unit frames
--function UnitFrames:HidePvPIcons(hide)
--	self.db.hidePvpIcons = hide
	
--	hide = hide and 0 or 1
--	PlayerPVPIcon:SetAlpha(hide)
--	PlayerPrestigeBadge:SetAlpha(hide)
--	PlayerPrestigePortrait:SetAlpha(hide)
--	TargetFrameTextureFramePVPIcon:SetAlpha(hide)
--	TargetFrameTextureFramePrestigeBadge:SetAlpha(hide)
--	TargetFrameTextureFramePrestigePortrait:SetAlpha(hide)
--	FocusFrameTextureFramePVPIcon:SetAlpha(hide)
--	FocusFrameTextureFramePrestigeBadge:SetAlpha(hide)
--	FocusFrameTextureFramePrestigePortrait:SetAlpha(hide)
--end


-- Move Target of Target and Focus to the right
--function UnitFrames:MoveTargetOfTarget(move)
--	self.db.moveTargetOfTarget = move

--	if move then
--		TargetFrameToT:ClearAllPoints()
--		TargetFrameToT:SetPoint("CENTER", TargetFrame, "Right", -55, -45)
		
--		FocusFrameToT:ClearAllPoints()
--	    FocusFrameToT:SetPoint("CENTER", FocusFrame, "Right", -55, -45)
--	else
--		TargetFrameToT:ClearAllPoints()
--		TargetFrameToT:SetPoint("CENTER", TargetFrame, "Right", -80, -40)
		
--		FocusFrameToT:ClearAllPoints()
--	    FocusFrameToT:SetPoint("CENTER", FocusFrame, "Right", -80, -40)
--	end
--end


-- Change cast bar size for target and focus
--function UnitFrames:ChangeCastBarSize(size, unit)
--	self.db.castBarSize = size
--	-- TODO: call unit:SetScale(size) somehow
--end


-- Disable Resting Indicator
--function UnitFrames:HideRestingStatus(hide)
--	self.db.hideRestingStatus = hide
--	self.UpdateRestingStatus()
--end


--function UnitFrames:UpdateRestingStatus()
--    if UnitFrames.db.hideRestingStatus then
--        if IsResting("player") then
--            PlayerStatusTexture:Hide()
--            PlayerRestGlow:Hide()
--            PlayerRestIcon:Hide()
--            PlayerStatusGlow:Hide()
--        end
--    else
--        if IsResting("player") then
--            PlayerStatusTexture:Show()
--            PlayerRestGlow:Show()
--            PlayerRestIcon:Show()
--            PlayerStatusGlow:Show()
--        end
--    end
--end

-- TODO: Hide role on player frame
-- TODO: Hide leader status of group on player frame


UnitFrames.defaultSettings = {
	combatIndicator = true,
	--hidePvpIcons = true,
	--hideFeedbackText = true,
	--moveTargetOfTarget = true,
	--hideRestingStatus = true,
	--classColors = {
	--	false,	-- Player
	--	false,	-- Others
	--	false	-- Tooltip
	--},
	--playerCastBarSize = 1,
	--targetCastBarSize = 1,
	--focusCastBarSize = 1,
}


UnitFrames.optionsTable = {
	combatIndicator = {
		name = "Combat Indicators",
		desc = "Small Icon indicating when target & focus are in combat",
		type = "toggle",
		width = "full",
		order = 1,
		set = function(info, val) UnitFrames:HandleCombatIndicator(val) end,
	},
	--hidePvpIcons = {
	--	name = "Hide PvP Icons",
	--	desc = "Icons indicating if a player if flagged for PvP and/or prestige badge",
	--	type = "toggle",
	--	width = "full",
	--	order = 2,
	--	set = function(info, val) UnitFrames:HidePvPIcons(val) end,
	--},
	--hideFeedbackText = {
	--	name = "Hide Feedback Text",
	--	desc = "Healing/damage text on the player & pet portraits",
	--	type = "toggle",
	--	width = "full",
	--	order = 3,
	--	set = function(info, val) UnitFrames:HideFeedbackText(val) end,
	--},
	--moveTargetOfTarget = {
	--	name = "Move Target of Target and Focus Frame",
	--	desc = "Moves target of target and focus frames so it's not hiding last debuff slot",
	--	type = "toggle",
	--	width = "full",
	--	order = 4,
	--	set = function(info, val) UnitFrames:MoveTargetOfTarget(val) end,
	--},
	--hideRestingStatus = {
	--	name = "Hide Resting Icon and Resting Glow",
	--	desc = "Hiding icon which is showing that player is resting, also hiding yellow glow",
	--	type = "toggle",
	--	width = "full",
	--	order = 5,
	--	set = function(info, val) UnitFrames:HideRestingStatus(val) end,
	--},
	--classColors = {
	--	name = "Class colors",
	--	type = "multiselect",
	--	order = 6,
	--	get = function(info, val) return UnitFrames.db.classColors[val] end,
	--	set = function(info, key, val)
	--			UnitFrames.db.classColors[key] = val
	--			UnitFrameHealthBar_Update(PlayerFrameHealthBar, "player")
	--			UnitFrameHealthBar_Update(TargetFrameHealthBar, "target")
	--			UnitFrameHealthBar_Update(FocusFrameHealthBar, "focus")
	--		end,
	--	values = {
	--		"Player",
	--		"Others",
	--		"Tooltip",
	--	},
	--},
	--unitFrameSize = {
	--	name = "Cast Bars size",
	--	type = "group",
	--	inline = true,
	--	order = 7,
	--	args = {
	--		playerCastBarSize = {
	--			name = "Player",
	--			desc = "Cast bar size of player",
	--			type = "range",
	--			order = 1,
	--			min = minVal,
	--			max = maxVal,
	--			step = sliderStep,
	--			bigStep = sliderBigStep,
	--			set = function(info, val)
	--					UnitFrames:ChangeCastBarSize(val, CastingBarFrame)
	--				end,
	--		},
	--		targetCastBarSize = {
	--			name = "Target",
	--			desc = "Cast bar size of target",
	--			type = "range",
	--			order = 2,
	--			min = minVal,
	--			max = maxVal,
	--			step = sliderStep,
	--			bigStep = sliderBigStep,
	--			set = function(info, val)
	--					UnitFrames:ChangeCastBarSize(val, TargetFrameSpellBar)
	--				end,
	--		},
	--		focusCastBarSize = {
	--			name = "Focus",
	--			desc = "Cast bar size of focus",
	--			type = "range",
	--			order = 3,
	--			min = minVal,
	--			max = maxVal,
	--			step = sliderStep,
	--			bigStep = sliderBigStep,
	--			set = function(info, val)
	--					UnitFrames:ChangeCastBarSize(val, FocusFrameSpellBar)
	--				end,
	--		},
	--	},
	--},
}