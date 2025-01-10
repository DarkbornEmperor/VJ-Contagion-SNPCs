include("entities/npc_vj_con_zmale/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 520 // 220
ENT.FlinchChance = 30
ENT.IdleSoundPitch = VJ.SET(75, 75)
ENT.CombatIdleSoundPitch = VJ.SET(75, 75)
ENT.InvestigateSoundPitch = VJ.SET(75, 75)
ENT.AlertSoundPitch = VJ.SET(75, 75)
ENT.CallForHelpSoundPitch = VJ.SET(75, 75)
ENT.BeforeMeleeAttackSoundPitch = VJ.SET(75, 75)
ENT.PainSoundPitch = VJ.SET(75, 75)
ENT.DeathSoundPitch = VJ.SET(75, 75)
-- Custom
ENT.Zombie_Sprinter = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoices()
    self:ZombieVoice_George()
end
/*-----------------------------------------------
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/