AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if dmginfo:IsBulletDamage() && hitgroup == 1 && GetConVarNumber("VJ_CON_Headshot") == 1 && !self.Riot_Helmet then
		dmginfo:SetDamage(self:Health())		
end		
	if dmginfo:IsBulletDamage() && self.HasSounds && self.HasImpactSounds && (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH) then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
	if math.random(1,3) == 1 then
	    dmginfo:ScaleDamage(0.50)
		local spark = ents.Create("env_spark")
		spark:SetKeyValue("Magnitude","1")
		spark:SetKeyValue("Spark Trail Length","1")
		spark:SetPos(dmginfo:GetDamagePosition())
		spark:SetAngles(self:GetAngles())
		spark:SetParent(self)
		spark:Spawn()
		spark:Activate()
	    spark:Fire("StartSpark", "", 0)
		spark:Fire("StopSpark", "", 0.001)
		self:DeleteOnRemove(spark)
	else
	    dmginfo:ScaleDamage(0.80)		
        end		
    end		
end	
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/