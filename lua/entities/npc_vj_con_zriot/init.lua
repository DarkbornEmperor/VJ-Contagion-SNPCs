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
    self:CreateGibEntity("prop_physics","models/cpthazama/contagion/zombies/riot_helmet_gib01.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_neck")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/cpthazama/contagion/zombies/riot_helmet_gib02.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_headr")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/cpthazama/contagion/zombies/riot_helmet_gib03.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_headl")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/cpthazama/contagion/zombies/riot_helmet_gib04.mdl",{Pos=self:GetAttachment(self:LookupAttachment("forward")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/