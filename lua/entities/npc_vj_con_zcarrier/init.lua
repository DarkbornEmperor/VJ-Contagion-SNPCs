include("entities/npc_vj_con_zmale/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 520 // 220
ENT.FlinchChance = 30
/*ENT.IdleSoundPitch = VJ.SET(85, 85)
ENT.CombatIdleSoundPitch = VJ.SET(85, 85)
ENT.InvestigateSoundPitch = VJ.SET(85, 85)
ENT.AlertSoundPitch = VJ.SET(85, 85)
ENT.CallForHelpSoundPitch = VJ.SET(85, 85)
ENT.BeforeMeleeAttackSoundPitch = VJ.SET(85, 85)
ENT.PainSoundPitch = VJ.SET(85, 85)
ENT.DeathSoundPitch = VJ.SET(85, 85)*/
-- Custom
ENT.Zombie_Sprinter = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
    self:Zombie_CustomOnInitialize()
    self:ZombieVoices()
    -- Getting up animation
    if VJ_CVAR_AI_ENABLED && math.random(1,2) == 1 then
        timer.Simple(0, function()
            self:VJ_ACT_PLAYACTIVITY("vjseq_sit_to_idle1",true,false)
            self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
end)
        timer.Simple(VJ.AnimDuration(self,"sit_to_idle1"), function() if IsValid(self) then
            self:SetState()
            end
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
    if self:IsOnFire() && self:Health() > 0 then self:PlaySoundSystem("Pain",self.SoundTbl_Burning) end
    if self.RiotBrute_Charging then return end
    if self:Health() > 0 && !self.Zombie_Crouching && self:IsMoving() && self.Zombie_NextStumbleT < CurTime() && math.random(1,50) == 1 && self:GetSequence() != self:LookupSequence("shoved_backwards_heavy") && self:GetSequence() != self:LookupSequence("shoved_forward1") && self:GetSequence() != self:LookupSequence("shoved_forward2") && self:GetSequence() != self:LookupSequence("shoved_backwards1") && self:GetSequence() != self:LookupSequence("shoved_backwards2") && self:GetSequence() != self:LookupSequence("shoved_backwards3") then
    if dmginfo:GetDamage() > 30 or dmginfo:GetDamageForce():Length() > 10000 or bit.band(dmginfo:GetDamageType(), DMG_BUCKSHOT) != 0 or dmginfo:IsExplosionDamage() then
    /*if self:IsPlayingGesture(self.CurrentAttackAnimation) then -- Stop the attack gesture!
        self:RemoveGesture(self.CurrentAttackAnimation)
end*/
        self:VJ_ACT_PLAYACTIVITY("vjseq_shoved_forward_heavy",true,false,false)
    else
        self:VJ_ACT_PLAYACTIVITY({"vjseq_shoved_forward1","vjseq_shoved_forward2"},true,false,false)
        self.Zombie_NextStumbleT = CurTime() + math.Rand(8,12)
        end
    end
end
/*-----------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/