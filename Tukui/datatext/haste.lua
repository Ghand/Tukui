--------------------------------------------------------------------
-- player haste
--------------------------------------------------------------------

if TukuiCF["datatext"].haste and TukuiCF["datatext"].haste > 0 then
	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("MEDIUM")
	Stat:SetFrameLevel(3)

	local Text  = TukuiBottomPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize, "THINOUTLINE")
	Text:SetShadowOffset(TukuiDB.mult, -TukuiDB.mult)
	TukuiDB.PP(TukuiCF["datatext"].haste, Text)

	local int = 1

	local function Update(self, t)
		local id
		if GetCombatRating(18) > GetCombatRating(20) and TukuiDB.class ~= "HUNTER" then
			id = 18
		elseif TukuiDB.class == "HUNTER" then
			id = 19
		else
			id = 20
		end
		
		int = int - t
		if int < 0 then
			Text:SetText(SPELL_HASTE_ABBR..": "..valuecolor..format("%.2f", GetCombatRatingBonus(id)).."%")
			int = 1
		end     
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end