if not TukuiCF["raidframes"].enable == true then return end

local raid_width = TukuiDB.Scale((TukuiActionBarBackground:GetWidth() / 5) - 7)*TukuiCF["raidframes"].scale
local raid_height = TukuiDB.Scale(42)*TukuiCF["raidframes"].scale
local function Shared(self, unit)
	self.colors = TukuiDB.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = TukuiDB.SpawnMenu

	-- an update script to all elements
	self:HookScript("OnShow", TukuiDB.updateAllElements)

	self:SetBackdrop({bgFile = TukuiCF["media"].blank, insets = {top = -TukuiDB.mult, left = -TukuiDB.mult, bottom = -TukuiDB.mult, right = -TukuiDB.mult}})
	self:SetBackdropColor(0.1, 0.1, 0.1)
	
	local health = CreateFrame('StatusBar', nil, self)
	health:SetHeight(raid_height*.83)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:SetStatusBarTexture(TukuiCF["media"].normTex)
	if TukuiCF["raidframes"].gridhealthvertical == true then
		health:SetOrientation("VERTICAL")
	end
	self.Health = health
	
	health.bg = health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(health)
	health.bg:SetTexture(TukuiCF["media"].normTex)
	
	self.Health.bg = health.bg
	
	health.value = health:CreateFontString(nil, "OVERLAY")
	health.value:SetPoint("BOTTOM", health, "BOTTOM", 0, TukuiDB.Scale(4))
	health.value:SetFont(TukuiCF["media"].uffont, (TukuiCF["raidframes"].fontsize*.83)*TukuiCF["raidframes"].scale, "THINOUTLINE")
	health.value:SetTextColor(1,1,1)
	health.value:SetShadowOffset(1, -1)
	self.Health.value = health.value		
	
	health.PostUpdate = TukuiDB.PostUpdateHealth
	health.frequentUpdates = true
	
	-- Setup Colors
	if TukuiCF["unitframes"].classcolor ~= true then
		health.colorTapping = false
		health.colorClass = false
		health:SetStatusBarColor(unpack(TukuiCF["unitframes"].healthcolor))	
		self.Health.bg:SetTexture(unpack(TukuiCF["unitframes"].healthbackdropcolor))
	else
		health.colorTapping = true	
		health.colorClass = true
		health.colorReaction = true		
		health.bg.multiplier = 0.3				
	end
	health.colorDisconnected = false
	
	-- border for all frames
	local FrameBorder = CreateFrame("Frame", nil, self)
	FrameBorder:SetPoint("TOPLEFT", self, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
	FrameBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
	TukuiDB.SetTemplate(FrameBorder)
	FrameBorder:SetBackdropBorderColor(unpack(TukuiCF["media"].altbordercolor))
	FrameBorder:SetFrameLevel(2)
	self.FrameBorder = FrameBorder
	
	-- power
	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, TukuiDB.Scale(-1)+(-TukuiDB.mult*2))
	power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, TukuiDB.Scale(-1)+(-TukuiDB.mult*2))
	power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
	power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
	power:SetStatusBarTexture(TukuiCF["media"].normTex)
	self.Power = power
	if TukuiCF["raidframes"].hidenonmana == true then
		power.PostUpdate = TukuiDB.PostUpdatePower
	end
	-- border between health and power
	self.HealthBorder = CreateFrame("Frame", nil, power)
	self.HealthBorder:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -TukuiDB.mult)
	self.HealthBorder:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -TukuiDB.mult)
	self.HealthBorder:SetPoint("BOTTOMLEFT", power, "TOPLEFT", 0, TukuiDB.mult)
	self.HealthBorder:SetPoint("BOTTOMRIGHT", power, "TOPRIGHT", 0, TukuiDB.mult)
	TukuiDB.SetTemplate(self.HealthBorder)
	self.HealthBorder:SetBackdropBorderColor(unpack(TukuiCF["media"].altbordercolor))	
	
	power.frequentUpdates = true

	power.bg = self.Power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(TukuiCF["media"].normTex)
	power.bg.multiplier = 0.3
	self.Power.bg = power.bg
	
	power.colorPower = true
	power.colorTapping = false
	power.colorDisconnected = true
	
	local name = health:CreateFontString(nil, "OVERLAY")
    name:SetPoint("TOP", health, 0, TukuiDB.Scale(-2))
	name:SetFont(TukuiCF["media"].uffont, TukuiCF["raidframes"].fontsize*TukuiCF["raidframes"].scale, "THINOUTLINE")
	name:SetShadowOffset(1, -1)
	
	self:Tag(name, "[Tukui:getnamecolor][Tukui:nameshort]")
	self.Name = name
	
	if TukuiCF["raidframes"].role == true then
		local LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
		if TukuiCF["raidframes"].role == 1 then
			LFDRole:SetHeight(TukuiDB.Scale(6))
			LFDRole:SetWidth(TukuiDB.Scale(6))
			LFDRole:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\lfdicons.blp")
		else
			LFDRole:SetHeight(TukuiDB.Scale(12))
			LFDRole:SetWidth(TukuiDB.Scale(12))
		end
		LFDRole:SetPoint("TOP", self.Name, "BOTTOM", 0, TukuiDB.Scale(-2))
		self.LFDRole = LFDRole
	end
	
    if TukuiCF["unitframes"].aggro == true then
		table.insert(self.__elements, TukuiDB.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', TukuiDB.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', TukuiDB.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', TukuiDB.UpdateThreat)
	end
	
	if TukuiCF["unitframes"].showsymbols == true then
		local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetHeight(TukuiDB.Scale(15)*TukuiCF["raidframes"].scale)
		RaidIcon:SetWidth(TukuiDB.Scale(15)*TukuiCF["raidframes"].scale)
		RaidIcon:SetPoint('CENTER', self, 'TOP', 0, 3)
		RaidIcon:SetTexture('Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp')
		self.RaidIcon = RaidIcon
	end
	
	local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:SetHeight(TukuiCF["raidframes"].fontsize)
	ReadyCheck:SetWidth(TukuiCF["raidframes"].fontsize)
	ReadyCheck:SetPoint('CENTER', self.Health, 'CENTER', 0, -4)
	self.ReadyCheck = ReadyCheck
	
	if TukuiCF["unitframes"].debuffhighlight == true then
		local dbh = health:CreateTexture(nil, "OVERLAY", health)
		dbh:SetAllPoints(health)
		dbh:SetTexture(TukuiCF["media"].normTex)
		dbh:SetBlendMode("ADD")
		dbh:SetVertexColor(0,0,0,0)
		self.DebuffHighlight = dbh
		self.DebuffHighlightFilter = true
		self.DebuffHighlightAlpha = 0.4		
	end
		
	--Heal Comm
	if TukuiCF["raidframes"].healcomm == true then
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		if TukuiCF["raidframes"].gridhealthvertical == true then
			mhpb:SetOrientation("VERTICAL")
			mhpb:SetPoint('BOTTOM', self.Health:GetStatusBarTexture(), 'TOP', 0, 0)
			mhpb:SetHeight(raid_height)
		else
			mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)		
		end
		mhpb:SetWidth(raid_width)
		mhpb:SetStatusBarTexture(TukuiCF["media"].normTex)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		if TukuiCF["raidframes"].gridhealthvertical == true then		
			ohpb:SetOrientation("VERTICAL")
			ohpb:SetPoint('BOTTOM', mhpb:GetStatusBarTexture(), 'TOP', 0, 0)
			ohpb:SetHeight(raid_height)
		else
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)		
		end
		ohpb:SetWidth(raid_width)
		ohpb:SetStatusBarTexture(TukuiCF["media"].normTex)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
	

	local debuffs = CreateFrame('Frame', nil, self)
	debuffs:SetPoint('CENTER', self, 'CENTER', 0, TukuiDB.Scale(-6))
	debuffs:SetHeight((raid_width / 2)*.73)
	debuffs:SetWidth(raid_width)
	debuffs.size = ((raid_width / 2) *.73)
	debuffs.spacing = 0
	debuffs.initialAnchor = 'CENTER'
	debuffs.num = 1
	debuffs.PostCreateIcon = TukuiDB.PostCreateAura
	debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
	self.Debuffs = debuffs
	self.Debuffs.CustomFilter = TukuiDB.AuraFilter

			
	if TukuiCF["raidframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = TukuiCF["raidframes"].raidalphaoor}
		self.Range = range
	end
	
	if TukuiCF["unitframes"].showsmooth == true then
		health.Smooth = true
		if self.Power then
			power.Smooth = true
		end
	end	
	
	if TukuiCF["auras"].raidunitbuffwatch == true then
		TukuiDB.createAuraWatch(self,unit)
    end
	
	if TukuiCF["raidframes"].hidenonmana == true then
		self:RegisterEvent("UNIT_DISPLAYPOWER", TukuiDB.CheckPower)	
	end
	
	-- execute an update on every raids unit if party or raid member changed
	-- should fix issues with names/symbols/etc not updating introduced with 4.0.3 patch
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", TukuiDB.updateAllElements)
	self:RegisterEvent("RAID_ROSTER_UPDATE", TukuiDB.updateAllElements)
	
	return self
end


oUF:RegisterStyle('TukuiHealR6R25', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiHealR6R25")	
	local yOffset = 0
	if TukuiCF["castbar"].castermode == true and (HealElementsCharPos and HealElementsCharPos["PlayerCastBar"] ~= true) then
		yOffset = yOffset + 28
	end
	local raid = self:SpawnHeader("oUF_TukuiHealR6R25", nil, "custom [@raid6,noexists][@raid26,exists] hide;show",
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', raid_width,
		'initial-height', raid_height,	
		"showRaid", true, 
		"showParty", true,
		"showPlayer", TukuiCF["raidframes"].showplayerinparty,
		"xoffset", TukuiDB.Scale(6),
		"yOffset", TukuiDB.Scale(-6),
		"point", "LEFT",
		"groupFilter", "1,2,3,4,5",
		"groupingOrder", "1,2,3,4,5",
		"groupBy", "GROUP",
		"maxColumns", 5,
		"unitsPerColumn", 5,
		"columnSpacing", TukuiDB.Scale(6),
		"columnAnchorPoint", "TOP"		
	)
	raid:SetPoint("BOTTOM", TukuiActionBarBackground, "TOP", 0, TukuiDB.Scale(6+yOffset))	
	
	local function ChangeVisibility(visibility)
		if(visibility) then
			local type, list = string.split(' ', visibility, 2)
			if(list and type == 'custom') then
				RegisterAttributeDriver(oUF_TukuiHealR6R25, 'state-visibility', list)
			end
		end	
	end
	
	local raidToggle = CreateFrame("Frame")
	raidToggle:RegisterEvent("PLAYER_ENTERING_WORLD")
	raidToggle:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	raidToggle:SetScript("OnEvent", function(self)
		local inInstance, instanceType = IsInInstance()
		local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
		if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
		if not InCombatLockdown() then
			if inInstance and instanceType == "raid" and maxPlayers ~= 40 then
				ChangeVisibility("custom [group:party,nogroup:raid][group:raid] show;hide")
			else
				if TukuiCF["raidframes"].gridonly == true then
					ChangeVisibility("custom [@raid26,exists] hide;show")
				else
					ChangeVisibility("custom [@raid6,noexists][@raid26,exists] hide;show")
				end
			end
		else
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	end)
end)