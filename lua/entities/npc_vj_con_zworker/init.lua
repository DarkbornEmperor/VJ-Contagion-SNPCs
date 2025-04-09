include("entities/npc_vj_con_zmale/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
-- Custom
ENT.Riot_Helmet = true
ENT.Riot_HelmetHP = 25
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ArmorDamage(dmginfo,hitgroup,status)
 if status == "PreDamage" then
 if dmginfo:IsBulletDamage() && hitgroup == HITGROUP_HEAD && self.Riot_Helmet /*&& self:GetBodygroup(1) == 0 or self:GetModel() == "models/vj_contagion/zombies/worker_zombie.mdl" && (self:GetBodygroup(1) == 0 or self:GetBodygroup(1) == 1 or self:GetBodygroup(1) == 2)*/ then
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
 if hitgroup == HITGROUP_HEAD && self.Riot_Helmet /*&& self:GetBodygroup(1) == 0 or self:GetModel() == "models/vj_contagion/zombies/worker_zombie.mdl" && (self:GetBodygroup(1) == 0 or self:GetBodygroup(1) == 1 or self:GetBodygroup(1) == 2)*/ then
    self.Riot_HelmetHP = self.Riot_HelmetHP -dmginfo:GetDamage()
 if self.Riot_HelmetHP <= 0 then
 if IsValid(spark) then SafeRemoveEntity(spark) end
    VJ.EmitSound(self,"vj_contagion/zombies/shared/physics_impact_break_glass_layer02_0"..math.random(1,8)..".wav",80)
    self.Riot_Helmet = false
    self.Bleeds = true
 if self:GetModel() == "models/vj_contagion/zombies/worker_zombie.mdl" then
    self:SetBodygroup(1,3)
 else
    self:SetBodygroup(1,1)
end
        self:RemoveAllDecals()
        self:BreakHelmet() end
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
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/