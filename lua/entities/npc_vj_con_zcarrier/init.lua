AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 520
ENT.FlinchChance = 30
ENT.AnimTbl_IdleStand = {ACT_IDLE_RELAXED}
ENT.AnimTbl_Walk = {ACT_WALK_AIM}
ENT.AnimTbl_Run = {ACT_RUN_AIM}
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackBleedEnemy = true 
ENT.MeleeAttackBleedEnemyChance = 2
ENT.MeleeAttackBleedEnemyDamage = 200
ENT.MeleeAttackBleedEnemyTime = 15
ENT.MeleeAttackBleedEnemyReps = 1
ENT.IdleSoundPitch = VJ_Set(85, 85)
ENT.CombatIdleSoundPitch = VJ_Set(85, 85)
ENT.AlertSoundPitch = VJ_Set(85, 85)
ENT.CallForHelpSoundPitch = VJ_Set(85, 85)
ENT.BeforeMeleeAttackSoundPitch = VJ_Set(85, 85)
ENT.PainSoundPitch = VJ_Set(85, 85)
ENT.DeathSoundPitch = VJ_Set(85, 85)
-- Custom
ENT.Zombie_AdvancedStrain = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
 if GetConVarNumber("VJ_CON_CarrierInfection") == 0 then
    self.MeleeAttackBleedEnemy = false  
end	
	self:SetCollisionBounds(Vector(14,14,72),Vector(-14,-14,0))
	self:Zombie_CustomOnInitialize()
	self:ZombieSounds()
	self.IdleAnim = self.AnimTbl_IdleStand[1]
	self.WalkAnim = self.AnimTbl_Walk[1]
	self.RunAnim = self.AnimTbl_Run[1]   		
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
    if !self.Flinching && self:IsMoving() && self.Zombie_NextStumbleT < CurTime() && math.random(1, 50) == 1 then
		self:VJ_ACT_PLAYACTIVITY(ACT_FLINCH_STOMACH,true,false,false)
		self.Zombie_NextStumbleT = CurTime() + 10	
    end
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSuperStrain(hp)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Cripple()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/