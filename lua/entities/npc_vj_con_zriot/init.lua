AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
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
//ENT.Riot_HelmetHP = 200
ENT.LegHealth = 35
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if self:GetClass() == "npc_vj_con_zriot" then
		self.Model = {
			"models/cpthazama/contagion/zombies/riot_zombie.mdl"
		}
		if math.random(1,10) == 1 then
			self.AdvancedStrain = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CustomOnInitialize()
	 if self.AdvancedStrain then	
	    self:SetSuperStrain(225)
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if hitgroup == 1 && GetConVarNumber("VJ_CON_Headshot") == 1 && !self.Riot_Helmet then
		dmginfo:SetDamage(self:Health())		
end	
	if self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_HEAD && self.Riot_Helmet then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
	    self.Bleeds = false
		dmginfo:ScaleDamage(0.00)
		self.DamageSpark1 = ents.Create("env_spark")
		self.DamageSpark1:SetKeyValue("Magnitude","1")
		self.DamageSpark1:SetKeyValue("Spark Trail Length","1")
		self.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
		self.DamageSpark1:SetAngles(self:GetAngles())
		//self.DamageSpark1:Fire("LightColor", "255 255 255")
		self.DamageSpark1:SetParent(self)
		self.DamageSpark1:Spawn()
		self.DamageSpark1:Activate()
		self.DamageSpark1:Fire("StartSpark", "", 0)
		self.DamageSpark1:Fire("StopSpark", "", 0.001)
		self:DeleteOnRemove(self.DamageSpark1)
    else
        self.Bleeds = true
		dmginfo:ScaleDamage(0.50)
end		
    if math.random(1,50) == 1 && hitgroup == HITGROUP_HEAD && self.Riot_Helmet then
           self.Riot_Helmet = false	
		   self.Bleeds = true
           self:SetBodygroup(1,1)	
		   dmginfo:ScaleDamage(1.0)	
	if IsValid(self.DamageSpark1) then self.DamageSpark1:Remove() end
           self:BreakHelmet()
   return
end
	if self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
	if math.random(1,5) == 1 then
		self.DamageSpark1 = ents.Create("env_spark")
		self.DamageSpark1:SetKeyValue("Magnitude","1")
		self.DamageSpark1:SetKeyValue("Spark Trail Length","1")
		self.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
		self.DamageSpark1:SetAngles(self:GetAngles())
		//self.DamageSpark1:Fire("LightColor", "255 255 255")
		self.DamageSpark1:SetParent(self)
		self.DamageSpark1:Spawn()
		self.DamageSpark1:Activate()
		self.DamageSpark1:Fire("StartSpark", "", 0)
		self.DamageSpark1:Fire("StopSpark", "", 0.001)
		self:DeleteOnRemove(self.DamageSpark1)
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