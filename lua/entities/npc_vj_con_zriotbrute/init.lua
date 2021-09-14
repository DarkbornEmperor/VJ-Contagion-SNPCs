AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 300
ENT.AnimTbl_Run = {ACT_WALK_AGITATED}
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CustomOnInitialize()		
	    self.ShieldModel = ents.Create("prop_vj_animatable")
	    self.ShieldModel:SetModel("models/cpthazama/contagion/zombies/police_shield.mdl")
	    self.ShieldModel:SetLocalPos(self:GetPos())
	    self.ShieldModel:SetOwner(self)
	    self.ShieldModel:SetParent(self)
	    self.ShieldModel:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	    self.ShieldModel:Spawn()
	    self.ShieldModel:Activate()
	    self.ShieldModel:SetSolid(SOLID_NONE)
	    self.ShieldModel:AddEffects(EF_BONEMERGE)
		
	if self.AdvancedStrain then
		self:SetSuperStrain(300)
    end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSuperStrain(hp)
	self:SetHealth(hp)
	self:SetMaxHealth(hp)
	self.AnimTbl_Run = {ACT_RUN_AGITATED}
	self.MeleeAttackDamage = self.MeleeAttackDamage +11
	//self.MaxJumpLegalDistance = VJ_Set(0,600)
	//self.LegHealth = hp /2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13,13,72),Vector(-13,-13,0))
	self:Zombie_CustomOnInitialize()
	self:ZombieSounds()
    self.AnimTbl_IdleStand = {ACT_IDLE}
    self.AnimTbl_Walk = {ACT_WALK_AGITATED}

	if GetConVarNumber("VJ_CON_AllowClimbing") == 1 then self.Zombie_AllowClimbing = true end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if hitgroup == 1 && GetConVarNumber("VJ_CON_Headshot") == 1 && !self.Riot_Helmet then
		dmginfo:SetDamage(self:Health())		
end	
	if (dmginfo:IsBulletDamage()) && hitgroup == HITGROUP_HEAD && self.Riot_Helmet or hitgroup == 9 then
		dmginfo:ScaleDamage(0.00)	
end	
	if self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_HEAD && self.Riot_Helmet then
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
    if math.random(1,50) == 1 && hitgroup == HITGROUP_HEAD && self.Riot_Helmet then
           self.Riot_Helmet = false	
		   self.Bleeds = true
           self:SetBodygroup(1,1)	
		   dmginfo:ScaleDamage(1.0)	
	if IsValid(spark) then spark:Remove() end
           self:BreakHelmet()
    return
end
 	if self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
	if math.random(1,3) == 1 then
	    dmginfo:ScaleDamage(0.20)
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Cripple()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Crouch(bCrouch)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
		if IsValid(self:GetEnemy()) && !self.Crippled && self.CanUseUnableAnim == true && !self.MeleeAttacking then
			self.AnimTbl_IdleStand = {"idle_unable_to_reach_01","idle_unable_to_reach_02"}
		elseif IsValid(self:GetEnemy()) && !self.Crippled && self.MeleeAttacking then
			self.AnimTbl_IdleStand = {"melee_cont_01"}
	    elseif !self.Crippled then
		    self.AnimTbl_IdleStand = {ACT_IDLE}
    			
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
GetCorpse.BloodEffect = self.CustomBlood_Particle
	local hookName = "VJ_CON_CorpseBlood_" .. GetCorpse:EntIndex()
	hook.Add("EntityTakeDamage",hookName,function(ent,dmginfo)
		if !IsValid(GetCorpse) then
			hook.Remove("EntityTakeDamage",hookName)
end
		if ent == GetCorpse then
			local attacker = dmginfo:GetAttacker()
			if GetCorpse.BloodEffect then
				for _,i in ipairs(GetCorpse.BloodEffect) do
					sound.Play("physics/flesh/flesh_impact_bullet"..math.random(1,3)..".wav",dmginfo:GetDamagePosition(),60,100)
					ParticleEffect(i,dmginfo:GetDamagePosition(),Angle(math.random(0,360),math.random(0,360),math.random(0,360)),nil)
				end
			end
		end
	end)
	self:CreateExtraDeathCorpse("prop_physics","models/cpthazama/contagion/zombies/police_shield.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_larmr")).Pos + self:GetUp()*-20})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
    -- If no corpse spawned, make sure to remove the mask!
    if !IsValid(self.Corpse) && IsValid(self.ShieldModel) then
        self.ShieldModel:Remove()
    end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/