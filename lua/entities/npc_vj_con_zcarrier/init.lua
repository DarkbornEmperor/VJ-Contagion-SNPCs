AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 175
ENT.AnimTbl_Walk = {ACT_WALK_AIM}
ENT.AnimTbl_Run = {ACT_RUN_AIM}
ENT.MeleeAttackBleedEnemy = true 
ENT.MeleeAttackBleedEnemyChance = 2
ENT.MeleeAttackBleedEnemyDamage = 200
ENT.MeleeAttackBleedEnemyTime = 15
ENT.MeleeAttackBleedEnemyReps = 1
ENT.PainSoundPitch1 = 80
ENT.PainSoundPitch2 = 80
ENT.DeathSoundPitch1 = 80
ENT.DeathSoundPitch2 = 80
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if self:GetClass() == "npc_vj_con_zcarrier" then
		self.Model = {
			"models/cpthazama/contagion/zombies/carrier_zombie.mdl"
		}
		--if math.random(1,10) == 1 then
			--self.AdvancedStrain = true
		--end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CustomOnInitialize()
	--self:SetBodygroup(0,math.random(0,1))
	--self:SetSkin(math.random(0,9))
	--if self.AdvancedStrain then
		--self:SetSuperStrain(175)
	--end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/