include("entities/npc_vj_con_zmale/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 520
ENT.FlinchChance = 30
ENT.MeleeAttackDamage = 20
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
    if !self.Flinching && self:IsMoving() && self.Zombie_NextStumbleT < CurTime() && math.random(1,30) == 1 then
        self:VJ_ACT_PLAYACTIVITY("vjseq_shoved_forward_heavy",true,false,false)
        self.Zombie_NextStumbleT = CurTime() + 10
    end
end
/*-----------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/