include("entities/npc_vj_con_zmale/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 225
ENT.IdleSoundPitch = VJ.SET(85, 85)
ENT.CombatIdleSoundPitch = VJ.SET(85, 85)
ENT.InvestigateSoundPitch = VJ.SET(85, 85)
ENT.AlertSoundPitch = VJ.SET(85, 85)
ENT.CallForHelpSoundPitch = VJ.SET(85, 85)
ENT.BeforeMeleeAttackSoundPitch = VJ.SET(85, 85)
ENT.PainSoundPitch = VJ.SET(85, 85)
ENT.DeathSoundPitch = VJ.SET(85, 85)
-- Custom
ENT.Riot_Helmet = true
ENT.Riot_HelmetHP = 100
ENT.Zombie_LegHealth = 75
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoices()
    self:ZombieVoice_George()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ArmorDamage(dmginfo,hitgroup,status)
 if status == "PreDamage" then
    if dmginfo:IsBulletDamage() && hitgroup == HITGROUP_HEAD && self.Riot_Helmet && self:GetBodygroup(1) == 0 then
    if self.HasSounds && self.HasImpactSounds then
    VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ImpactBullet_Metal_layer01_0"..math.random(1,5)..".wav",70)
    VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ImpactBullet_Metal_layer02_0"..math.random(1,7)..".wav",70)
end
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
        VJ.EmitSound(self,"vj_contagion/zombies/shared/physics_impact_break_glass_layer02_0"..math.random(1,8)..".wav",80)
        self.Riot_Helmet = false
        self.Bleeds = true
        self:SetBodygroup(2,1)
        self:RemoveAllDecals()
        self:BreakHelmet()
        end
    end
end
    if status == "PreDamage" && dmginfo:IsBulletDamage() && (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH) then
    if self.HasSounds && self.HasImpactSounds then
    VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ImpactBullet_Metal_layer01_0"..math.random(1,5)..".wav",70)
    VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ImpactBullet_Metal_layer02_0"..math.random(1,7)..".wav",70)
end
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
        dmginfo:ScaleDamage(0.5)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BreakHelmet()
    self:CreateGibEntity("prop_physics","models/vj_contagion/zombies/riot_helmet_gib01.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_neck")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/vj_contagion/zombies/riot_helmet_gib02.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_headr")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/vj_contagion/zombies/riot_helmet_gib03.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_headl")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/vj_contagion/zombies/riot_helmet_gib04.mdl",{Pos=self:GetAttachment(self:LookupAttachment("forward")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
end
/*-----------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/