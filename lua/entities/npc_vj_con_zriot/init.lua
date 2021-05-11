AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 225
ENT.IdleSoundPitch = VJ_Set(80, 80)
ENT.CombatIdleSoundPitch = VJ_Set(80, 80)
ENT.AlertSoundPitch = VJ_Set(80, 80)
ENT.CallForHelpSoundPitch = VJ_Set(80, 80)
ENT.BeforeMeleeAttackSoundPitch = VJ_Set(80, 80)
ENT.PainSoundPitch1 = 80
ENT.PainSoundPitch2 = 80
ENT.DeathSoundPitch1 = 80
ENT.DeathSoundPitch2 = 80
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
	if hitgroup == 1 && GetConVarNumber("vj_con_headshot") == 1 then
		dmginfo:SetDamage(self:Health())		
end	

	if (dmginfo:IsBulletDamage()) && hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(0.00)	
end	
    --if math.random(1,150) == 1 && hitgroup == HITGROUP_HEAD then	
           --self:SetBodygroup(1,1)
          -- self:CreateHelmet()	
		   --dmginfo:ScaleDamage(1.0)
--end	
		if (dmginfo:IsBulletDamage()) && self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG then VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70) end
		local attacker = dmginfo:GetAttacker()
		dmginfo:ScaleDamage(0.50)
		if math.random(1,3) == 1 then
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateHelmet()
	--local prop = ents.Create("prop_physics")
	--prop:SetPos(self:LocalToWorld(Vector(0,0,100)))
	--prop:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib01.mdl")
	--prop:SetAngles(self:GetAngles())
	--prop:Spawn()
	--prop:Activate()
	--prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	--SafeRemoveEntityDelayed(prop,30)
	
	--local prop2 = ents.Create("prop_physics")
	--prop2:SetPos(self:LocalToWorld(Vector(0,0,100)))
	--prop2:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib02.mdl")
	--prop2:SetAngles(self:GetAngles())
	--prop2:Spawn()
	--prop2:Activate()
	--prop2:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	--SafeRemoveEntityDelayed(prop2,30)	
	
	--local prop3 = ents.Create("prop_physics")
	--prop3:SetPos(self:LocalToWorld(Vector(0,0,100)))
	--prop3:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib03.mdl")
	--prop3:SetAngles(self:GetAngles())
	--prop3:Spawn()
	--prop3:Activate()
	--prop3:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	--SafeRemoveEntityDelayed(prop3,30)

	--local prop4 = ents.Create("prop_physics")
	--prop4:SetPos(self:LocalToWorld(Vector(0,0,100)))
	--prop4:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib04.mdl")
	--prop4:SetAngles(self:GetAngles())
	--prop4:Spawn()
	--prop4:Activate()
	--prop4:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	--SafeRemoveEntityDelayed(prop4,30)		
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/