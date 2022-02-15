AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 200
-- Custom 
ENT.Riot_Helmet = true
//ENT.Riot_HelmetHP = 200
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if dmginfo:IsBulletDamage() && hitgroup == 1 && GetConVarNumber("VJ_CON_Headshot") == 1 && !self.Riot_Helmet then
		dmginfo:SetDamage(self:Health())		
end	
	if dmginfo:IsBulletDamage() && self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_HEAD && self.Riot_Helmet then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
	    self.Bleeds = false
		dmginfo:ScaleDamage(0.00)
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
        self.Bleeds = true		
end		
    if dmginfo:IsBulletDamage() && math.random(5,80) == 5 && hitgroup == HITGROUP_HEAD && self.Riot_Helmet then
           self.Riot_Helmet = false	
		   self.Bleeds = true
           self:SetBodygroup(2,1)		   
		   //dmginfo:ScaleDamage(1.0)	
	if IsValid(spark) then spark:Remove() end
           self:BreakHelmet()
    return			
end		
	if dmginfo:IsBulletDamage() && self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH then
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
	        dmginfo:ScaleDamage(0.60)		
        end		
    end		
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BreakHelmet()	
	local prop = ents.Create("prop_physics")
	prop:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib01.mdl")
	prop:SetPos(self:GetAttachment(self:LookupAttachment("particle_neck")).Pos)
	prop:SetAngles(self:GetAttachment(self:LookupAttachment("particle_neck")).Ang)
	prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
	prop:Spawn()
	prop:Activate()
	SafeRemoveEntityDelayed(prop,30)
	
	local prop2 = ents.Create("prop_physics")
	prop2:SetPos(self:LocalToWorld(Vector(0,0,-100)))
	prop2:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib02.mdl")
	prop2:SetPos(self:GetAttachment(self:LookupAttachment("particle_headr")).Pos)
	prop2:SetAngles(self:GetAttachment(self:LookupAttachment("particle_headr")).Ang)
	prop2:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
	prop2:Spawn()
	prop2:Activate()
	SafeRemoveEntityDelayed(prop2,30)	
	
	local prop3 = ents.Create("prop_physics")
	prop3:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib03.mdl")
	prop3:SetPos(self:GetAttachment(self:LookupAttachment("particle_headl")).Pos)
	prop3:SetAngles(self:GetAttachment(self:LookupAttachment("particle_headl")).Ang)
	prop3:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
	prop3:Spawn()
	prop3:Activate()
	SafeRemoveEntityDelayed(prop3,30)

	local prop4 = ents.Create("prop_physics")
	prop4:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib04.mdl")
	prop4:SetPos(self:GetAttachment(self:LookupAttachment("forward")).Pos)
	prop4:SetAngles(self:GetAttachment(self:LookupAttachment("forward")).Ang)
	prop4:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
	prop4:Spawn()
	prop4:Activate()
	SafeRemoveEntityDelayed(prop4,30)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/