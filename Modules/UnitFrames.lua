local _, MinimalistUI = ...
local UnitFrames = MinimalistUI:CreateModule("Unit Frames")

local playerFrame = PlayerFrame
local targetFrame = TargetFrame
local focusFrame = FocusFrame
local playerLevelText = PlayerLevelText

local sb = _G.GameTooltipStatusBar
local	UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS, PlayerFrameHealthBar =
		UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS, PlayerFrameHealthBar
local _, class, c

local feedbackText = playerFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")

local playerRoleIcon = _G[playerFrame:GetName().."RoleIcon"];

local eventHandler = CreateFrame("Frame", nil , UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)

function UnitFrames:OnLoad()
	-- Class colors
   eventHandler:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	hooksecurefunc("UnitFrameHealthBar_Update", self.ColorStatusbar)
	hooksecurefunc("HealthBar_OnValueChanged", function(self)
      UnitFrames.ColorStatusbar(self, self.unit)
   end)

   hooksecurefunc("PlayerFrame_UpdateStatus", function()
      self:HideRestingStatus(self.db.hideRestingStatus)
   end)

   hooksecurefunc("PlayerFrame_UpdateLevelTextAnchor", function()
      self:EnableCombatIndicator(self.db.combatIndicator)
   end)

   hooksecurefunc("PlayerFrame_UpdateRolesAssigned", function()
      self:HideRoleIcon(self.db.hideRoleIcon)
   end)

   -- Hide Leader and Guide icons for player frame
   hooksecurefunc("PlayerFrame_UpdatePartyLeader", function()
      PlayerLeaderIcon:Hide()
      PlayerGuideIcon:Hide()
   end)

   -- Hide group leader icon for target and focus
   hooksecurefunc("TargetFrame_Update", function()
      targetFrame.leaderIcon:Hide()
      focusFrame.leaderIcon:Hide()
   end)

   self:HideFeedbackText(self.db.hideFeedbackText)
	self:HidePvPIcons(self.db.hidePvpIcons)

   -- Hide gryphons
   MainMenuBarArtFrame.RightEndCap:Hide()
   MainMenuBarArtFrame.LeftEndCap:Hide()

   -- Hide bags
   MicroButtonAndBagsBar:Hide()

   -- Move target of target frame to hide last buff slot on target
   TargetFrameToT:ClearAllPoints()
   TargetFrameToT:SetPoint("CENTER", TargetFrame, "Right", -50, -46)
   FocusFrameToT:ClearAllPoints()
   FocusFrameToT:SetPoint("CENTER", FocusFrame, "Right", -50, -46)

   -- Increase cast bars
   TargetFrameSpellBar:SetScale(1.15)
   FocusFrameSpellBar:SetScale(1.15)

   -- Hide character name
   playerFrame.name:Hide()

   --
   PlayerAttackGlow:Hide()

   -- Hide Server names in party frames
   hooksecurefunc("CompactUnitFrame_UpdateName",function(frame)
      if frame and not frame:IsForbidden() then
         local frame_name = frame:GetName()
         if frame_name and frame_name:match("^CompactRaidFrame%d") and frame.unit and frame.name then
            local unit_name = GetUnitName(frame.unit, true)
            if unit_name then
               --frame.name:SetText(nil)
               frame.name:SetText(unit_name:match("[^-]+"))
            end
         end
      end
   end)

   -- Combo points on target
   SetCVar("comboPointLocation", 1)

   -- Arena 123 on arena
   --local U = UnitIsUnit
   --hooksecurefunc("CompactUnitFrame_UpdateName",function(F)
   --   if IsActiveBattlefieldArena() and F.unit:find("nameplate") then
   --      for i = 1,5 do
   --         if U(F.unit,"arena"..i) then
   --            F.name:SetText(i)
   --            F.name:SetTextColor(1,1,0)
   --            break
   --         end
   --      end
   --   end
   --end)

   -- Hide minimap zoom icons
   MinimapZoomIn:Hide()
   MinimapZoomOut:Hide()

   -- Enable zooming on minimap with scrollwheel
   Minimap:EnableMouseWheel(true)
   Minimap:SetScript("OnMouseWheel", function(self, arg1)
      if arg1 > 0 then
         Minimap_ZoomIn()
      else
         Minimap_ZoomOut()
      end
   end)

   -- Hide glow
   SetCVar("ffxGlow", 0)

   -- Hide effects
   SetCVar("ffxDeath", 0)
   SetCVar("ffxNether", 0)

   -- Hide loss of control background
   LossOfControlFrame.blackBg:SetAlpha(0)
   LossOfControlFrame.RedLineTop:SetAlpha(0)
   LossOfControlFrame.RedLineBottom:SetAlpha(0)


   --Move combo points to character name
   --local _, playerClass = UnitClass("player")
   --   if playerClass == "ROGUE" and GetCVar("comboPointLocation") == "2" then
   --      hooksecurefunc(ComboPointPlayerFrame,"Setup", function()
   --         ComboPointPlayerFrame:ClearAllPoints()
   --         ComboPointPlayerFrame:SetPoint("CENTER", PlayerFrame, 56, 23.82)
   --         ComboPointPlayerFrame.Background:Hide()
   --         ComboPointPlayerFrame:SetScale(.9)
   --      end)
   --   end



	--self:MoveTargetOfTarget(self.db.moveTargetOfTarget)

	--hooksecurefunc("PlayerFrame_UpdateStatus", function()
 --   	

 --   	-- Hide Player leader/guide icons
 --   	PlayerGuideIcon:Hide()
	--	PlayerLeaderIcon:Hide()

	--	-- Hide combat flashing animation
	--	
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
	self:EnableCombatIndicator(self.db.combatIndicator)
   self:HideFeedbackText(self.db.hideFeedbackText)
	self:HidePvPIcons(self.db.hidePvpIcons)
	
	--self:MoveTargetOfTarget(self.db.moveTargetOfTarget)

	--hooksecurefunc("PlayerFrame_UpdateStatus", function()
 --   	UnitFrames:HideRestingStatus(self.db.hideRestingStatus)
	--end)

	--self:ChangeCastBarSize(self.db.castBarSize)

	UnitFrameHealthBar_Update(PlayerFrameHealthBar, "player")
	UnitFrameHealthBar_Update(TargetFrameHealthBar, "target")
	UnitFrameHealthBar_Update(FocusFrameHealthBar, "focus")
end

function eventHandler:UPDATE_MOUSEOVER_UNIT()
	if UnitFrames.db.classColors[3] then
		UnitFrames.ColorStatusbar(sb, "mouseover") end
end

function UnitFrames.ColorStatusbar(statusbar, unit)
	if statusbar == PlayerFrameHealthBar and not
			UnitFrames.db.classColors[1] then return
	end
	
	if statusbar ~= PlayerFrameHealthBar and
      statusbar ~= sb and not
      UnitFrames.db.classColors[2] then return
	end

	if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
		if unit == statusbar.unit or statusbar == sb then
			_, class = UnitClass(unit)
			c = RAID_CLASS_COLORS[class]
			statusbar:SetStatusBarColor(c.r, c.g, c.b)
		end
	end
end

function UnitFrames:HideFeedbackText(hide)
	self.db.hideFeedbackText = hide
	if hide then
		playerFrame.feedbackText = feedbackText
		playerFrame.feedbackStartTime = 0
		PetFrame.feedbackText = feedbackText
		PetFrame.feedbackStartTime = 0

		PlayerHitIndicator:Hide()
		PetHitIndicator:Hide()
	else
		local time = GetTime()
		playerFrame.feedbackText = PlayerHitIndicator
		playerFrame.feedbackStartTime = time
		PetFrame.feedbackText = PetHitIndicator
		PetFrame.feedbackStartTime = time
	end
end

-- Combat indicators for target & focus
function UnitFrames:AddCombatIconTextureTo(frame)
	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetTexture("Interface\\CHARACTERFRAME\\UI-StateIcon.blp")
	texture:SetTexCoord(.5, 1, 0, .484375)
	texture:SetWidth(31)
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
	local unitEffectiveLevel = UnitEffectiveLevel(unit)
   if UnitAffectingCombat(unit) then
		if unitEffectiveLevel < 0 then
         --unit.highLevelTexture:Hide()
      end
      indicator:Show()
      parentFrame.levelText:Hide()
	else
      indicator:Hide()
      if unitEffectiveLevel > 0 then
         parentFrame.levelText:Show()
      else
         parentFrame.levelText:Hide()
      end
	end
end

function UnitFrames:ToggleLevelTextOnPlayerFrame() 
   local player = "player"
   if UnitAffectingCombat(player) then
      if IsResting(player) and self.db.hideRestingStatus then
         PlayerAttackIcon:Show()
      elseif IsResting(player) and not self.db.hideRestingStatus then
         PlayerAttackIcon:Hide()
      end
      playerLevelText:Hide()
   else
      playerLevelText:Show()
   end
end

function UnitFrames:EnableCombatIndicator(enable)
	self.db.combatIndicator = enable
	if enable then
		eventHandler:SetScript("OnUpdate", function()
         self:ToggleLevelTextOnPlayerFrame()
			self:ToggleCombatIndicator(targetFrame, targetCombatIconFrame, "target")
			self:ToggleCombatIndicator(focusFrame, focusCombatIconFrame, "focus")
		end)
	else
		eventHandler:SetScript("OnUpdate", nil)
		targetCombatIconFrame:Hide()
		focusCombatIconFrame:Hide()
		targetFrame.levelText:Show()
		focusFrame.levelText:Show()
      playerLevelText:Show()
	end
end

function UnitFrames:HidePvPIcons(hide)
	self.db.hidePvpIcons = hide
	hide = hide and 0 or 1
	PlayerPVPIcon:SetAlpha(hide)
	PlayerPrestigeBadge:SetAlpha(hide)
	PlayerPrestigePortrait:SetAlpha(hide)
	TargetFrameTextureFramePVPIcon:SetAlpha(hide)
	TargetFrameTextureFramePrestigeBadge:SetAlpha(hide)
	TargetFrameTextureFramePrestigePortrait:SetAlpha(hide)
	FocusFrameTextureFramePVPIcon:SetAlpha(hide)
	FocusFrameTextureFramePrestigeBadge:SetAlpha(hide)
	FocusFrameTextureFramePrestigePortrait:SetAlpha(hide)
end

function UnitFrames:HideRestingStatus(hide)
   self.db.hideRestingStatus = hide
   self.UpdateRestingStatus()
end

function UnitFrames:UpdateRestingStatus()
   if UnitFrames.db.hideRestingStatus then
      if IsResting("player") then
         PlayerStatusTexture:Hide()
         PlayerRestGlow:Hide()
         PlayerRestIcon:Hide()
         PlayerStatusGlow:Hide()
      end
   else
      if IsResting("player") then
         PlayerStatusTexture:Show()
         PlayerRestGlow:Show()
         PlayerRestIcon:Show()
         PlayerStatusGlow:Show()
      end
   end
end

function UnitFrames:HideRoleIcon(hide)
   self.db.hideRoleIcon = hide 
   if hide then
      playerRoleIcon:Hide()
   else
      local role = UnitGroupRolesAssigned("player");
      if role == "TANK" or role == "HEALER" or role == "DAMAGER" then
         playerRoleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role));
         playerRoleIcon:Show();
      else
         playerRoleIcon:Hide();
      end
   end
end

--function UnitFrames:HideFrameCombatFlashing(hide)
--   self.db.hideFrameCombatFlashing = hide
--   if hide then
--      PlayerAttackGlow:Hide()
--   else
--      -- Bring back frame flash
--      PlayerAttackGlow:Show()
--   end
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




-- TODO: Hide role on player frame
-- TODO: Hide leader status of group on player frame


UnitFrames.defaultSettings = {
	combatIndicator = true,
   hideFeedbackText = true,
	hidePvpIcons = true,
   hideRestingStatus = true,
   hideRoleIcon = true,
	--moveTargetOfTarget = true,
	
	
	--playerCastBarSize = 1,
	--targetCastBarSize = 1,
	--focusCastBarSize = 1,
   classColors = {
      false,   -- Player
      false,   -- Others
      false -- Tooltip
   },
}

UnitFrames.optionsTable = {
   hideFeedbackText = {
      name = "Hide Feedback Text",
      desc = "Healing and Damage text on the player & pet portraits",
      type = "toggle",
      width = "full",
      order = 1,
      set = function(info, val) UnitFrames:HideFeedbackText(val) end,
   },
	hidePvpIcons = {
		name = "Hide PvP Icons",
		desc = "Icons indicating if a player is flagged for PvP and prestige badges",
		type = "toggle",
		width = "full",
		order = 2,
		set = function(info, val) UnitFrames:HidePvPIcons(val) end,
	},
   hideRestingStatus = {
      name = "Hide Resting Icon and Resting Glow",
      desc = "Icon and yellow glow which is indicating that player in rest zone",
      type = "toggle",
      width = "full",
      order = 3,
      set = function(info, val) UnitFrames:HideRestingStatus(val) end,
   },
   hideRoleIcon = {
      name = "Hide Role Icon",
      desc = "Icon indicating role assigned",
      type = "toggle",
      width = "full",
      order = 4,
      set = function(info, val) UnitFrames:HideRoleIcon(val) end,
   },
   combat = {
      name = "Combat",
      type = "group",
      inline = true,
      order = 6,
      args = {
         combatIndicator = {
            name = "Combat Indicators",
            desc = "Small Icon indicating when target & focus are in combat",
            type = "toggle",
            width = "full",
            order = 1,
            set = function(info, val) UnitFrames:EnableCombatIndicator(val) end,
         },
         --hideAttackGlowOnPlayerFrame = {
         --   name = "Hide Combat Flashing",
         --   desc = "Red flashing glow on player frame when in combat",
         --   type = "toggle",
         --   width = "full",
         --   order = 2,
         --   set = function(info, val) UnitFrames:HideAttackGlowOnPlayerFrame(val) end,
         --}
      },
      
   },
	--moveTargetOfTarget = {
	--	name = "Move Target of Target and Focus Frame",
	--	desc = "Moves target of target and focus frames so it's not hiding last debuff slot",
	--	type = "toggle",
	--	width = "full",
	--	order = 4,
	--	set = function(info, val) UnitFrames:MoveTargetOfTarget(val) end,
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
   classColors = {
      name = "Class colors",
      type = "multiselect",
      order = 10,
      get = function(info, val) return UnitFrames.db.classColors[val] end,
      set = function(info, key, val)
               UnitFrames.db.classColors[key] = val
               UnitFrameHealthBar_Update(PlayerFrameHealthBar, "player")
               UnitFrameHealthBar_Update(TargetFrameHealthBar, "target")
               UnitFrameHealthBar_Update(FocusFrameHealthBar, "focus")
            end,
      values = {
         "Player",
         "Others",
         "Tooltip",
      },
   },
}