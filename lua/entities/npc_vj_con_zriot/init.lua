AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 225
ENT.IdleSoundPitch = VJ_Set(85, 85)
ENT.CombatIdleSoundPitch = VJ_Set(85, 85)
ENT.AlertSoundPitch = VJ_Set(85, 85)
ENT.CallForHelpSoundPitch = VJ_Set(85, 85)
ENT.BeforeMeleeAttackSoundPitch = VJ_Set(85, 85)
ENT.PainSoundPitch = VJ_Set(85, 85)
ENT.DeathSoundPitch = VJ_Set(85, 85)
-- Custom 
ENT.Riot_Helmet = true
ENT.Riot_HelmetHP = 100
ENT.Zombie_LegHealth = 75
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
 if dmginfo:IsBulletDamage() && hitgroup == HITGROUP_HEAD && GetConVarNumber("VJ_CON_Headshot") == 1 && !self.Riot_Helmet then
	dmginfo:SetDamage(self:Health())		
end	
	if dmginfo:IsBulletDamage() && self.HasSounds && self.HasImpactSounds && hitgroup == HITGROUP_HEAD && self.Riot_Helmet && self:GetBodygroup(1) == 0 then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
	    self.Bleeds = false
		dmginfo:ScaleDamage(0.10)
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
    if hitgroup == HITGROUP_HEAD && self.Riot_Helmet && self:GetBodygroup(1) == 0 then
    self.Riot_HelmetHP = self.Riot_HelmetHP -dmginfo:GetDamage()	
	if self.Riot_HelmetHP <= 0 then
	if IsValid(spark) then SafeRemoveEntity(spark) end
	    self.Riot_Helmet = false
		self.Bleeds = true
        self:SetBodygroup(1,1)
		self:RemoveAllDecals()
        self:BreakHelmet()
	end
end
 	if dmginfo:IsBulletDamage() && self.HasSounds && self.HasImpactSounds && (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG) then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
	if math.random(1,3) == 1 then
	    dmginfo:ScaleDamage(0.05)
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
	    dmginfo:ScaleDamage(0.08)
        end		
    end		
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BreakHelmet()	
	local HelmetGib = ents.Create("prop_physics")
	HelmetGib:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib01.mdl")
	HelmetGib:SetPos(self:GetAttachment(self:LookupAttachment("particle_neck")).Pos)
	HelmetGib:SetAngles(self:GetAttachment(self:LookupAttachment("particle_neck")).Ang)
	HelmetGib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)	
	HelmetGib:Spawn()
	HelmetGib:Activate()
	SafeRemoveEntityDelayed(HelmetGib,30)
	
	local HelmetGib2 = ents.Create("prop_physics")
	HelmetGib2:SetPos(self:LocalToWorld(Vector(0,0,-100)))
	HelmetGib2:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib02.mdl")
	HelmetGib2:SetPos(self:GetAttachment(self:LookupAttachment("particle_headr")).Pos)
	HelmetGib2:SetAngles(self:GetAttachment(self:LookupAttachment("particle_headr")).Ang)
	HelmetGib2:SetCollisionGroup(COLLISION_GROUP_DEBRIS)	
	HelmetGib2:Spawn()
	HelmetGib2:Activate()
	SafeRemoveEntityDelayed(HelmetGib2,30)	
	
	local HelmetGib3 = ents.Create("prop_physics")
	HelmetGib3:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib03.mdl")
	HelmetGib3:SetPos(self:GetAttachment(self:LookupAttachment("particle_headl")).Pos)
	HelmetGib3:SetAngles(self:GetAttachment(self:LookupAttachment("particle_headl")).Ang)
	HelmetGib3:SetCollisionGroup(COLLISION_GROUP_DEBRIS)	
	HelmetGib3:Spawn()
	HelmetGib3:Activate()
	SafeRemoveEntityDelayed(HelmetGib3,30)

	local HelmetGib4 = ents.Create("prop_physics")
	HelmetGib4:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib04.mdl")
	HelmetGib4:SetPos(self:GetAttachment(self:LookupAttachment("forward")).Pos)
	HelmetGib4:SetAngles(self:GetAttachment(self:LookupAttachment("forward")).Ang)
	HelmetGib4:SetCollisionGroup(COLLISION_GROUP_DEBRIS)	
	HelmetGib4:Spawn()
	HelmetGib4:Activate()
	SafeRemoveEntityDelayed(HelmetGib4,30)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/