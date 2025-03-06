AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 175
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_con_blood_impact_red_01"}
ENT.BloodDecal = {"VJ_CON_Blood"}
ENT.HasBloodPool = false
//ENT.TurningSpeed = 5
ENT.PoseParameterLooking_Names = {pitch={"body_pitch"}, yaw={"body_yaw"}, roll={}}
ENT.HasMeleeAttack = true
ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 60
ENT.MeleeAttackDamage = 21 // 5 = Easy || 10 = Normal || 21 = Hard || 37 = Extreme || 48 = Nightmare
ENT.TimeUntilMeleeAttackDamage = false
ENT.HasExtraMeleeAttackSounds = true
ENT.MeleeAttackPlayerSpeed = true
ENT.MeleeAttackPlayerSpeedTime = 0.5
ENT.DisableFootStepSoundTimer = true
ENT.HasMeleeAttackPlayerSpeedSounds = false
//ENT.AnimTbl_Flinch = {"vjseq_shoved_backwards1","vjseq_shoved_backwards2","vjseq_shoved_backwards3","vjseq_shoved_forward2","vjseq_shoved_forward2"}
ENT.CanFlinch = true
//ENT.FlinchChance = 1
ENT.FlinchCooldown = 1
ENT.AnimTbl_Flinch = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}
ENT.FlinchHitGroupMap = {
    {HitGroup = {HITGROUP_HEAD}, Animation = {"vjges_injured_head2020_01","vjges_injured_head2020_02","vjges_injured_head2020_03","vjges_injured_head2020_04"}},
}
ENT.HasDeathAnimation = true
ENT.DeathAnimationChance = 1
ENT.AnimTbl_Death = {"vjseq_death2013_01","vjseq_death2013_02","vjseq_death2013_03","vjseq_death2013_04"}
    -- ====== Controller Data ====== --
ENT.ControllerParams = {
    CameraMode = 2, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(40, 25, -50), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "ValveBiped.Bip01_Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
}
    -- ====== Sound File Paths ====== --
ENT.SoundTbl_FootStep = "common/null.wav"
ENT.SoundTbl_MeleeAttackExtra = {
"vj_contagion/zombies/shared/z_hit-01.wav",
"vj_contagion/zombies/shared/z_hit-02.wav",
"vj_contagion/zombies/shared/z_hit-03.wav",
"vj_contagion/zombies/shared/z_hit-04.wav",
"vj_contagion/zombies/shared/z_hit-05.wav",
"vj_contagion/zombies/shared/z_hit-06.wav"
}
ENT.SoundTbl_MeleeAttackMiss = {
"vj_contagion/zombies/shared/z-swipe-1.wav",
"vj_contagion/zombies/shared/z-swipe-2.wav",
"vj_contagion/zombies/shared/z-swipe-3.wav",
"vj_contagion/zombies/shared/z-swipe-4.wav",
"vj_contagion/zombies/shared/z-swipe-5.wav",
"vj_contagion/zombies/shared/z-swipe-6.wav"
}
ENT.SoundTbl_Impact = {
"vj_contagion/zombies/shared/SFX_ImpactBullet_flesh_layer01_01.wav",
"vj_contagion/zombies/shared/SFX_ImpactBullet_flesh_layer01_02.wav",
"vj_contagion/zombies/shared/SFX_ImpactBullet_flesh_layer01_03.wav",
"vj_contagion/zombies/shared/SFX_ImpactBullet_flesh_layer01_04.wav",
"vj_contagion/zombies/shared/SFX_ImpactBullet_flesh_layer01_05.wav",
"vj_contagion/zombies/shared/SFX_ImpactBullet_flesh_layer01_06.wav",
"vj_contagion/zombies/shared/SFX_ImpactBullet_flesh_layer01_07.wav"
}
ENT.IdleSoundChance = 1
ENT.NextSoundTime_Idle = VJ.SET(3,4)
ENT.NextSoundTime_Investigate = VJ.SET(3,4)
ENT.MainSoundPitch = 100
-- Custom
ENT.Zombie_Climbing = false
ENT.Zombie_Crouching = false
ENT.Zombie_NextClimb = 0
ENT.Zombie_AllowClimbing = false
ENT.Zombie_NextCommandT = 0
ENT.Zombie_NextRoarT = 0
ENT.Zombie_NextJumpT = 0
ENT.Zombie_NextStumbleT = 0
ENT.Zombie_ControllerAnim = 0
ENT.Zombie_Sprinter = false
ENT.Zombie_LegHealth = 28
ENT.Zombie_Crippled = false
ENT.Zombie_AttackingDoor = false
ENT.Zombie_DoorToBreak = NULL
ENT.Zombie_Gender = 0 -- 0 = Male | 1 = Female
ENT.IsContagionZombie = true
ENT.FootData = {
    ["lfoot"] = {Range=6.5,OnGround=true},
    ["rfoot"] = {Range=6.5,OnGround=true}
}
util.AddNetworkString("vj_con_zombie_hud")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key,activator,caller,data)
    if key == "step" && self:GetSequenceActivity(self:GetIdealSequence()) != ACT_RUN then
        self:PlayFootstepSound()
    elseif key == "melee" then
        self:ExecuteMeleeAttack()
    elseif key == "body_hit" then
        VJ.EmitSound(self, "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_0"..math.random(1,5)..".wav",75,100)
end
    if key == "break_door" then
        if IsValid(self.Zombie_DoorToBreak) then
        self:PlaySoundSystem("BeforeMeleeAttack", self.SoundTbl_BeforeMeleeAttack)
        VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ZombiePoundDoor_Wood0"..math.random(1,4)..".wav",75,100)
        local doorDmg = self.MeleeAttackDamage
        local door = self.Zombie_DoorToBreak
        if door.doorHP == nil then
            door.doorHP = 200 - doorDmg
        elseif door.doorHP <= 0 then
            self:PlaySoundSystem("MeleeAttackMiss", self.SoundTbl_MeleeAttackMiss)
            return -- To prevent door props making a duplication when it shouldn't
        else
            door.doorHP = door.doorHP - doorDmg
end
        if door:GetClass() == "prop_door_rotating" && door.doorHP <= 0 then
            VJ.EmitSound(door,"physics/wood/wood_furniture_break"..math.random(1,2)..".wav",75,100)
            VJ.EmitSound(door,"ambient/materials/door_hit1.wav",75,100)
            ParticleEffect("door_pound_core",door:GetPos(),door:GetAngles(),nil)
            ParticleEffect("door_explosion_chunks",door:GetPos(),door:GetAngles(),nil)
            door:Remove()
            local doorGib = ents.Create("prop_physics")
            doorGib:SetPos(door:GetPos())
            doorGib:SetAngles(door:GetAngles())
            doorGib:SetModel(door:GetModel())
            doorGib:SetSkin(door:GetSkin())
            doorGib:SetBodygroup(1,door:GetBodygroup(1))
            doorGib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            doorGib:SetSolid(SOLID_NONE)
            doorGib:Spawn()
            doorGib:GetPhysicsObject():ApplyForceCenter(self:GetForward()*5000)
            SafeRemoveEntityDelayed(doorGib,30)
        elseif door:GetClass() == "func_door_rotating" && door.doorHP <= 0 then
            VJ.EmitSound(door,"physics/wood/wood_furniture_break"..math.random(1,2)..".wav",75,100)
            VJ.EmitSound(door,"ambient/materials/door_hit1.wav",75,100)
            ParticleEffect("door_pound_core",door:GetPos(),door:GetAngles(),nil)
            ParticleEffect("door_explosion_chunks",door:GetPos(),door:GetAngles(),nil)
            door:Remove()
            local doorGibs = ents.Create("prop_dynamic")
            doorGibs:SetPos(door:GetPos())
            doorGibs:SetAngles(door:GetAngles())
            doorGibs:SetModel("models/props_c17/FurnitureDresser001a.mdl")
            doorGibs:Spawn()
            doorGibs:TakeDamage(9999)
            doorGibs:Fire("break")
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
    if self:GetClass() == "npc_vj_con_zmale" then
        self.Model = {
        "models/vj_contagion/zombies/common_zombie_a_c.mdl",
        "models/vj_contagion/zombies/common_zombie_a_f.mdl",
        "models/vj_contagion/zombies/common_zombie_a_h.mdl",
        "models/vj_contagion/zombies/common_zombie_a_t.mdl",
        "models/vj_contagion/zombies/common_zombie_b_c.mdl",
        "models/vj_contagion/zombies/common_zombie_b_f.mdl",
        "models/vj_contagion/zombies/common_zombie_b_h.mdl",
        "models/vj_contagion/zombies/common_zombie_b_t.mdl",
        "models/vj_contagion/zombies/common_zombie_c_c.mdl",
        "models/vj_contagion/zombies/common_zombie_c_f.mdl",
        "models/vj_contagion/zombies/common_zombie_c_h.mdl",
        "models/vj_contagion/zombies/common_zombie_c_t.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zcarrier" then
        self.Zombie_Sprinter = true
        self.Model = {
        "models/vj_contagion/zombies/carrier_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zcivi" then
        self.Model = {
        "models/vj_contagion/zombies/civillian_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zcurtis" then
        self.Model = {
        "models/vj_contagion/zombies/curtis_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zdiego" then
        self.Model = {
        "models/vj_contagion/zombies/diego_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zdoc" then
        self.Model = {
        "models/vj_contagion/zombies/doctor_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zelijah" then
        self.Model = {
        "models/vj_contagion/zombies/elijah_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zeugene" then
        self.Model = {
        "models/vj_contagion/zombies/eugene_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zfemale" then
        self.Zombie_Gender = 1
        self.Model = {
        "models/vj_contagion/zombies/common_zombie_female_a_t.mdl",
        "models/vj_contagion/zombies/common_zombie_female_b_t.mdl",
        "models/vj_contagion/zombies/common_zombie_female_c_t.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zinmate" then
        self.Model = {
        "models/vj_contagion/zombies/inmate_zombie01.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zjessica" then
        self.Zombie_Gender = 1
        self.Model = {
        "models/vj_contagion/zombies/jessica_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zlawrence" then
        self.Model = {
        "models/vj_contagion/zombies/lawrence_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zlooter" then
        self.Model = {
        "models/vj_contagion/zombies/looter_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zmanuel" then
        self.Model = {
        "models/vj_contagion/zombies/manuel_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zmarcus" then
        self.Model = {
        "models/vj_contagion/zombies/marcus_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zmia" then
        self.Zombie_Gender = 1
        self.Model = {
        "models/vj_contagion/zombies/mia_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zmike" then
        self.Model = {
        "models/vj_contagion/zombies/engineer.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zmilitary" then
        self.Model = {
        "models/vj_contagion/zombies/military_gasmask_zombie.mdl",
        "models/vj_contagion/zombies/military_nohelmet_zombie.mdl",
        "models/vj_contagion/zombies/military_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_znick" then
        self.Model = {
        "models/vj_contagion/zombies/nick_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_znicole" then
        self.Zombie_Gender = 1
        self.Model = {
        "models/vj_contagion/zombies/nicole_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zofficer" then
        self.Model = {
        "models/vj_contagion/zombies/officer_alt.mdl",
        "models/vj_contagion/zombies/officer_alt2.mdl",
        "models/vj_contagion/zombies/officer_alt3.mdl",
        "models/vj_contagion/zombies/officer_alt4.mdl",
        "models/vj_contagion/zombies/officer_zombie.mdl",
        "models/vj_contagion/zombies/officer_armor.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zriot" then
        self.Model = {
        "models/vj_contagion/zombies/riot_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zriotbrute" then
        self.Model = {
        "models/vj_contagion/zombies/riot_brute_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zriotsol" then
        self.Model = {
        "models/vj_contagion/zombies/riot_soldier.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zryan" then
        self.Model = {
        "models/vj_contagion/zombies/ryan_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_ztony" then
        self.Model = {
        "models/vj_contagion/zombies/tony_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zworker" then
        self.Model = {
        "models/vj_contagion/zombies/worker_visor01_zombie.mdl",
        "models/vj_contagion/zombies/worker_visor02_zombie.mdl",
        "models/vj_contagion/zombies/worker_zombie.mdl"
}
    elseif self:GetClass() == "npc_vj_con_zyumi" then
        self.Zombie_Gender = 1
        self.Model = {
        "models/vj_contagion/zombies/yumi_zombie.mdl"
}
end
        if math.random(1,GetConVar("VJ_CON_RunnerChance"):GetInt()) == 1 && GetConVar("VJ_CON_AllRunners"):GetInt() == 0 then
            self.Zombie_Sprinter = true
end
        if GetConVar("VJ_CON_AllRunners"):GetInt() == 1 then self.Zombie_Sprinter = true end

        if GetConVar("VJ_CON_BreakDoors"):GetInt() == 1 then self.CanOpenDoors = false end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_Init()
     if self:GetModel() == "models/vj_contagion/zombies/common_zombie_a_c.mdl" then
        self:SetBodygroup(1,math.random(0,2))
        self:SetSkin(math.random(0,7))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_a_f.mdl" then
        self.StartHealth = 200
        self:SetBodygroup(1,math.random(0,2))
        self:SetSkin(math.random(0,7))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_a_h.mdl" or self:GetModel() == "models/vj_contagion/zombies/common_zombie_a_t.mdl" then
        self:SetBodygroup(0,math.random(0,3))
        self:SetBodygroup(1,math.random(0,4))
        self:SetSkin(math.random(0,7))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_b_c.mdl" then
        self:SetBodygroup(1,math.random(0,2))
        self:SetSkin(math.random(0,9))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_b_f.mdl" then
        self.StartHealth = 200
        self:SetBodygroup(1,math.random(0,2))
        self:SetSkin(math.random(0,9))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_b_h.mdl" or self:GetModel() == "models/vj_contagion/zombies/common_zombie_b_t.mdl" then
        self:SetBodygroup(0,math.random(0,3))
        self:SetBodygroup(1,math.random(0,4))
        self:SetSkin(math.random(0,9))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_c_c.mdl" then
        self:SetBodygroup(1,math.random(0,2))
        self:SetSkin(math.random(0,9))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_c_f.mdl" then
        self.StartHealth = 200
        self:SetBodygroup(1,math.random(0,2))
        self:SetSkin(math.random(0,9))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_c_h.mdl" then
        self:SetBodygroup(1,math.random(0,2))
        self:SetSkin(math.random(0,9))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_c_t.mdl" then
        self:SetBodygroup(0,math.random(0,3))
        self:SetBodygroup(1,math.random(0,4))
        self:SetSkin(math.random(0,9))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_female_a_t.mdl" or self:GetModel() == "models/vj_contagion/zombies/common_zombie_female_b_t.mdl" then
        self:SetBodygroup(0,math.random(0,1))
        self:SetBodygroup(1,math.random(0,1))
        self:SetBodygroup(2,math.random(0,1))
        self:SetSkin(math.random(0,2))

     elseif self:GetModel() == "models/vj_contagion/zombies/common_zombie_female_c_t.mdl" then
        self:SetBodygroup(0,math.random(0,1))
        self:SetBodygroup(1,math.random(0,2))
        self:SetBodygroup(2,math.random(0,1))
        self:SetSkin(math.random(0,2))

     elseif self:GetModel() == "models/vj_contagion/zombies/civillian_zombie.mdl" then
        self:SetBodygroup(0,math.random(0,1))
        self:SetSkin(math.random(0,9))

     elseif self:GetModel() == "models/vj_contagion/zombies/doctor_zombie.mdl" then
        self:SetBodygroup(0,math.random(0,1))
        self:SetSkin(math.random(0,3))

     elseif self:GetModel() == "models/vj_contagion/zombies/worker_visor01_zombie.mdl" or self:GetModel() == "models/vj_contagion/zombies/worker_visor02_zombie.mdl" then
        self:SetSkin(math.random(0,14))

     elseif self:GetModel() == "models/vj_contagion/zombies/worker_zombie.mdl" then
        self:SetBodygroup(1,math.random(0,2))
        self:SetSkin(math.random(0,14))

     elseif self:GetModel() == "models/vj_contagion/zombies/inmate_zombie01.mdl" then
        self:SetBodygroup(0,math.random(0,3))
        self:SetSkin(math.random(0,3))

     elseif self:GetModel() == "models/vj_contagion/zombies/looter_zombie.mdl" then
        self:SetBodygroup(2,math.random(0,4))
        self:SetSkin(math.random(0,5))

     elseif self:GetModel() == "models/vj_contagion/zombies/officer_alt.mdl" or self:GetModel() == "models/vj_contagion/zombies/officer_alt2.mdl" or self:GetModel() == "models/vj_contagion/zombies/officer_alt3.mdl" or self:GetModel() == "models/vj_contagion/zombies/officer_alt4.mdl" or self:GetModel() == "models/vj_contagion/zombies/officer_zombie.mdl" then
        self.Riot_Helmet = false
        self:SetSkin(math.random(0,5))

     elseif self:GetModel() == "models/vj_contagion/zombies/officer_armor.mdl" then
        //self.StartHealth = 225
        self:SetSkin(math.random(0,5))

     elseif self:GetModel() == "models/vj_contagion/zombies/riot_soldier.mdl" then
        self:SetBodygroup(1,math.random(0,1))

     elseif self:GetModel() == "models/vj_contagion/zombies/military_nohelmet_zombie.mdl" then
        self.Riot_Helmet = false
        self:SetBodygroup(1,math.random(0,1))
        self:SetSkin(math.random(0,3))

     elseif self:GetModel() == "models/vj_contagion/zombies/military_gasmask_zombie.mdl" or self:GetModel() == "models/vj_contagion/zombies/military_zombie.mdl" then
        //self.StartHealth = 225
        self:SetSkin(math.random(0,3))
end
    self:SetHealth((GetConVar("vj_npc_health"):GetInt() > 0) and GetConVar("vj_npc_health"):GetInt() or self:ScaleByDifficulty(self.StartHealth))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
 for attName, var in pairs(self.FootData) do
    var.AttID = self:LookupAttachment(attName)
end
    self:Zombie_Init()
    self:ZombieVoices()
    if GetConVar("VJ_CON_AllowClimbing"):GetInt() == 1 then self.Zombie_AllowClimbing = true end
    -- Getting up animation
    if VJ_CVAR_AI_ENABLED && self.Zombie_Gender == 0 && math.random(1,4) == 1 then
        timer.Simple(0, function()
            self:PlayAnim("vjseq_sit_to_idle1",true,false)
            self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
end)
        timer.Simple(VJ.AnimDuration(self,"sit_to_idle1"), function() if IsValid(self) then
            self:SetState()
            end
        end)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:SetSuperStrain()
 if self:GetClass() == "npc_vj_con_zcarrier" or self:GetClass() == "npc_vj_con_zriotbrute" then return end
    //self:SetHealth(hp)
    //self:SetMaxHealth(hp)
    //self.MeleeAttackDamage = self.MeleeAttackDamage +10
    //self.MaxJumpLegalDistance = VJ.SET(0,600)
    //self.Zombie_LegHealth = hp /2
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoices()
 if self.Zombie_Gender == 0 then
 local maleVoice = math.random(1,6)
    if maleVoice == 1 then
        self:ZombieVoice_George()
    elseif maleVoice == 2 then
        self:ZombieVoice_Andy()
    elseif maleVoice == 3 then
        self:ZombieVoice_Jim()
    elseif maleVoice == 4 then
        self:ZombieVoice_Michael()
    elseif maleVoice == 5 then
        self:ZombieVoice_Scottlam()
    elseif maleVoice == 6 then
        self:ZombieVoice_2013()
end
 elseif self.Zombie_Gender == 1 then
 local femaleVoice = math.random(1,4)
    if femaleVoice == 1 then
        self:ZombieVoice_Christina()
    elseif femaleVoice == 2 then
        self:ZombieVoice_Amisar()
    elseif femaleVoice == 3 then
        self:ZombieVoice_Lindsay()
    elseif femaleVoice == 4 then
        self:ZombieVoice_2013()
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangeActivity(newAct)
 if newAct == ACT_JUMP && !self.VJ_IsBeingControlled then
    self:PlaySoundSystem("Alert",self.SoundTbl_Jump)
end
 if newAct == ACT_LAND && self.VJ_IsBeingControlled then
    self:SetNavType(NAV_GROUND)
end
    return self.BaseClass.OnChangeActivity(self,newAct)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
 if self.VJ_IsBeingControlled or self.Zombie_Crippled or self.Zombie_Sprinter or self.Zombie_Crouching then return end
    if math.random(1,3) == 1 && !self:IsBusy() && ent:Visible(self) then
        self:PlayAnim({"vjseq_idle2013_facearound_01","vjseq_idle2013_facearound_02"},"LetAttacks",math.Rand(0.5,1),true)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCallForHelp(ally)
  if self.VJ_IsBeingControlled or self.Zombie_Crippled or self.Zombie_Crouching or self.RiotBrute_Charging then return end
     if math.random(1,3) == 1 && !self:IsBusy() then
        self:PlayAnim({"vjseq_zombie_grapple_roar1","vjseq_zombie_grapple_roar2"},true,false,true)
        if math.random(1,3) == 1 && !ally:IsBusy() then
            ally:PlayAnim({"vjseq_zombie_grapple_roar1","vjseq_zombie_grapple_roar2"},true,false,true)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply,controlEnt)
  ply:ChatPrint("DUCK: Crouch")
  ply:ChatPrint("JUMP: Jump")
  if !self.Zombie_Sprinter then ply:ChatPrint("WALK: Blend") end
  ply:ChatPrint("RELOAD: Roar")
  ply:ChatPrint("USE: Break Door")
  ply:ChatPrint("ATTACK2: Command")

    net.Start("vj_con_zombie_hud")
        net.WriteBool(false)
        net.WriteEntity(self)
    net.Send(ply)

    function self.VJ_TheControllerEntity:OnStopControlling()
        net.Start("vj_con_zombie_hud")
            net.WriteBool(true)
            net.WriteEntity(self)
        net.Send(ply)
end
function controlEnt:OnKeyBindPressed(key)
    local npc = self.VJCE_NPC
    -- Toggle blend setting
    if key == IN_WALK then
        if npc.Zombie_ControllerAnim == 0 then
            npc.Zombie_ControllerAnim = 1
            self.VJCE_Player:ChatPrint("Blend Disabled")
        else
            npc.Zombie_ControllerAnim = 0
            self.VJCE_Player:ChatPrint("Blend Enabled")
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
 if self.Zombie_Sprinter && !self.Zombie_Crippled or (self.VJ_IsBeingControlled && self.Zombie_ControllerAnim == 1 && !self.Zombie_Crippled) then
 if (act == ACT_IDLE or act == ACT_TURN_LEFT or act == ACT_TURN_RIGHT) && !self.Zombie_Crouching then
    return ACT_IDLE_STIMULATED
 elseif act == ACT_WALK && !self.Zombie_Crouching then
    return ACT_WALK_STIMULATED
 elseif act == ACT_RUN && !self.Zombie_Crouching then
    return ACT_RUN_STIMULATED
end
    if (act == ACT_IDLE or act == ACT_TURN_LEFT or act == ACT_TURN_RIGHT) && self.Zombie_Crouching then
        return ACT_IDLE_STEALTH
    elseif (act == ACT_WALK or act == ACT_RUN) && self.Zombie_Crouching then
        return ACT_WALK_STEALTH
    end
end
 if self.Zombie_Crouching && !self.Zombie_Sprinter && !self.Zombie_Crippled then
 if act == ACT_IDLE or act == ACT_TURN_LEFT or act == ACT_TURN_RIGHT then
    return ACT_IDLE_STEALTH
 elseif act == ACT_WALK or act == ACT_RUN then
    return ACT_WALK_STEALTH
end
 elseif self.Zombie_Crippled && !self.Zombie_Crouching then
 if act == ACT_IDLE or act == ACT_TURN_LEFT or act == ACT_TURN_RIGHT then
    return ACT_IDLE_HURT
 elseif act == ACT_WALK or act == ACT_RUN then
    return ACT_WALK_HURT
end
 elseif act == ACT_IDLE && IsValid(self:GetEnemy()) && !self.Zombie_Sprinter && !self.Zombie_Crouching && !self.Zombie_Crippled then
    //return ACT_IDLE_ANGRY
    return self:ResolveAnimation({ACT_IDLE_ANGRY})

 elseif (act == ACT_RUN or act == ACT_WALK) && self:IsOnFire() && !self.Zombie_Sprinter && !self.Zombie_Crouching && !self.Zombie_Crippled then
    return ACT_RUN_STIMULATED

 elseif act == ACT_JUMP && self.VJ_IsBeingControlled then
    return ACT_HOP
end
    return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
    if self.FootData && self:GetSequenceActivity(self:GetIdealSequence()) == ACT_RUN then
    local checkPos = self:GetPos()
    for attName, var in pairs(self.FootData) do
    if !var.AttID then continue end
    local footPos = self:GetAttachment(var.AttID).Pos
        checkPos.x = footPos.x
        checkPos.y = footPos.y
    if ((footPos -checkPos):LengthSqr()) > (var.Range *var.Range) then
        var.OnGround = false
    elseif !var.OnGround then
        var.OnGround = true
        self:PlayFootstepSound()
        end
    end
end
    if self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP) && self:GetNavType() != NAV_JUMP && !self.RiotBrute_Charging then
      if self:IsOnGround() && CurTime() > self.Zombie_NextJumpT then
      local maxDist = 220
      local maxDepth = 20
      local targetPos = self:GetPos() +Vector(math.Rand(-maxDist,maxDist),math.Rand(-maxDist,maxDist),maxDepth)
        self:Jump(targetPos)
        self:PlaySoundSystem("Alert",self.SoundTbl_Jump)
        self.Zombie_NextJumpT = CurTime() + 1
    end
end
 local curSeq = self:GetSequence()
 if GetConVar("VJ_CON_BreakDoors"):GetInt() == 0 or self.Zombie_Crippled or self.Zombie_Climbing or self.Zombie_Crouching or self.RiotBrute_Charging or self.Dead or self.DeathAnimationCodeRan or self.Flinching then self.Zombie_DoorToBreak = NULL return end
 local curAct = self:GetSequenceActivity(self:GetIdealSequence())
        if !IsValid(self.Zombie_DoorToBreak) && !self.Zombie_AttackingDoor then
          if ((!self.VJ_IsBeingControlled) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_USE))) then
            for _,v in pairs(ents.FindInSphere(self:GetPos(),40)) do
              //if GetConVar("VJ_CON_BreakDoors_Func"):GetInt() == 1 && v:GetClass() == "func_door_rotating" && v:Visible(self) then self.Zombie_DoorToBreak = v end
                 if v:GetClass() == "prop_door_rotating" && v:Visible(self) then
                    local anim = string.lower(v:GetSequenceName(v:GetSequence()))
                    if string.find(anim,"idle") or string.find(anim,"open") /*or string.find(anim,"locked")*/ then
                        self.Zombie_AttackingDoor = true
                        self.Zombie_DoorToBreak = v
                break
            end
        end
    end
end
        else
            if IsValid(self.Zombie_DoorToBreak) then
            local dist = VJ.GetNearestDistance(self,self.Zombie_DoorToBreak)
            if IsValid(self.Zombie_DoorToBreak) && self.Zombie_AttackingDoor && (self.AttackAnimTime > CurTime() or !self.Zombie_DoorToBreak:Visible(self)) or curAct == ACT_OPEN_DOOR && dist > 40 then self.Zombie_AttackingDoor = false self.Zombie_DoorToBreak = NULL self:SetState() return end
            if curAct != ACT_OPEN_DOOR && IsValid(self.Zombie_DoorToBreak) then
                //local ang = self:GetAngles()
                //self:SetAngles(Angle(ang.x,(self.Zombie_DoorToBreak:GetPos() -self:GetPos()):Angle().y,ang.z))
                self:SetTurnTarget(self.Zombie_DoorToBreak)
                self:PlayAnim(ACT_OPEN_DOOR,true,false,false)
                self:SetState(VJ_STATE_ONLY_ANIMATION)
        end
    end
end
        if !IsValid(self.Zombie_DoorToBreak) && self.Zombie_AttackingDoor then
            self.Zombie_AttackingDoor = false
            self:PlayAnim(ACT_IDLE,true,0,false)
            self:SetState()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Jump(pos)
    self:StopMoving()
    self:ResetMoveCalc()
    self:SetNavType(NAV_GROUND)
    self:SetMoveType(MOVETYPE_STEP)
    if self.CurrentSchedule then
        self.CurrentSchedule = nil
        self.CurrentScheduleName = nil
        self.CurrentTask = nil
        self.CurrentTaskID = nil
end
    //self.NextIdleStandTime = CurTime()
    self.NextIdleTime = CurTime()
    self.NextChaseTime = CurTime()
    self:ForceMoveJump(self:CalculateProjectile("Curve", self:GetPos(), self:GetPos() +((((pos or self:GetPos() +self:GetUp() *100) -self:GetPos()):GetNormalized() *50) +(self:GetUp() *25)), 250))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Crouch(bCrouch)
    if bCrouch then
        self:SetHullType(HULL_TINY)
        self:SetCollisionBounds(Vector(13,13,35),Vector(-13,-13,0))
    else
        self:SetHullType(HULL_HUMAN)
        self:SetCollisionBounds(Vector(13,13,72),Vector(-13,-13,0))
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
 self:Zombie_OnThinkActive()
 if CurTime() > self.Zombie_NextRoarT && !self.Zombie_AttackingDoor && !self.RiotBrute_Charging && !self:IsBusy("Activities") then
  for _,v in pairs(ents.FindByClass("npc_vj_con_z*")) do
    if !v.IsFollowing && VJ.HasValue(v.VJ_NPC_Class,"CLASS_ZOMBIE") && v:GetPos():Distance(self:GetPos()) <= 500 && self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_RELOAD) && !v.Zombie_AttackingDoor && !v.RiotBrute_Charging && !v:BusyWithActivity() then
        self:PlaySoundSystem("CallForHelp",self.SoundTbl_CallForHelp)
    if !self.Zombie_Crippled && !self.Zombie_Crouching then
        self:PlayAnim({"vjseq_zombie_grapple_roar1","vjseq_zombie_grapple_roar2"},true,1.7,false) end
    if !v.Zombie_Crippled && !self.Zombie_Crouching then
        v:PlayAnim({"vjseq_zombie_grapple_roar1","vjseq_zombie_grapple_roar2"},true,false,false) end
        v:PlaySoundSystem("CallForHelp",v.SoundTbl_CallForHelp)
        v:Follow(self,true)
        v.IsFollowing = true
        self.Zombie_NextRoarT = CurTime() + math.Rand(5,10)
        end
    end
end
 if CurTime() > self.Zombie_NextCommandT then
  for _,v in pairs(ents.FindByClass("npc_vj_con_z*")) do
    if v.IsFollowing && VJ.HasValue(v.VJ_NPC_Class,"CLASS_ZOMBIE") && self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_ATTACK2) && !v:BusyWithActivity() then
        local bullseye = self.VJ_TheControllerBullseye
        v:PlaySoundSystem("InvestigateSound",v.SoundTbl_Investigate)
        v:ResetFollowBehavior()
        v.IsFollowing = false
        timer.Simple(0.1, function() if IsValid(v) then
        v:SetLastPosition(bullseye:GetPos())
        v:SCHEDULE_GOTO_POSITION("TASK_RUN_PATH", function(x) x.RunCode_OnFail = function() end end) end end)
        self.Zombie_NextCommandT = CurTime() + 3
        end
    end
end
  if self.Zombie_Crippled then return end
  if IsValid(self:GetEnemy()) && self:GetEnemy():IsPlayer() && !self:IsOnFire() && !self.Flinching && !self:IsBusy() && !self.RiotBrute_Charging then
     if IsValid(self:GetBlockingEntity()) || (self:GetEnemy():GetPos():Distance(self:GetPos()) <= 350 && self:GetEnemy():Crouching()) then
        self:Crouch(true)
        self.Zombie_Crouching = true
    else
        self:Crouch(false)
        self.Zombie_Crouching = false
    end
end
  if self.VJ_IsBeingControlled then
     if self.VJ_TheController:KeyDown(IN_DUCK) then
        self:Crouch(true)
        self.Zombie_Crouching = true
    else
        self:Crouch(false)
        self.Zombie_Crouching = false
    end
end
    //print(self:GetBlockingEntity())
    // IsValid(self:GetBlockingEntity()) && !self:GetBlockingEntity():IsNPC() && !self:GetBlockingEntity():IsPlayer()
    if self.Zombie_AllowClimbing && !self.RiotBrute_Charging && !self.Zombie_Crouching && !self.Dead && !self.Zombie_Climbing && CurTime() > self.Zombie_NextClimb then
        //print("-------------------------------------------------------------------------------------")
        local anim = false
        local finalpos = self:GetPos()
        local tr5 = util.TraceLine({start = self:GetPos() + self:GetUp()*144, endpos = self:GetPos() + self:GetUp()*144 + self:GetForward()*40, filter = function(ent) if (ent:GetClass() == "prop_physics") then return true end end}) -- 144
        local tr4 = util.TraceLine({start = self:GetPos() + self:GetUp()*120, endpos = self:GetPos() + self:GetUp()*120 + self:GetForward()*40, filter = function(ent) if (ent:GetClass() == "prop_physics") then return true end end}) -- 120
        local tr3 = util.TraceLine({start = self:GetPos() + self:GetUp()*96, endpos = self:GetPos() + self:GetUp()*96 + self:GetForward()*40, filter = function(ent) if (ent:GetClass() == "prop_physics") then return true end end}) -- 96
        local tr2 = util.TraceLine({start = self:GetPos() + self:GetUp()*72, endpos = self:GetPos() + self:GetUp()*72 + self:GetForward()*40, filter = function(ent) if (ent:GetClass() == "prop_physics") then return true end end}) -- 72
        local tr1 = util.TraceLine({start = self:GetPos() + self:GetUp()*48, endpos = self:GetPos() + self:GetUp()*48 + self:GetForward()*40, filter = function(ent) if (ent:GetClass() == "prop_physics") then return true end end}) -- 48
        local tru = util.TraceLine({start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*200, filter = self})

        //VJ_CreateTestObject(tru.StartPos,self:GetAngles(),Color(0,0,255))
        //VJ_CreateTestObject(tru.HitPos,self:GetAngles(),Color(0,255,0))
        //PrintTable(tr2)
        if !IsValid(tru.Entity) then
            if IsValid(tr5.Entity) then
                local tr5b = util.TraceLine({start = self:GetPos() + self:GetUp()*160, endpos = self:GetPos() + self:GetUp()*160 + self:GetForward()*40, filter = function(ent) if (ent:GetClass() == "prop_physics") then return true end end})
                if !IsValid(tr5b.Entity) then
                    anim = VJ.PICK({"vjseq_zombie_climb_108","vjseq_zombie_climb_120"})
                    finalpos = tr5.HitPos
end
            elseif IsValid(tr4.Entity) then
                anim = VJ.PICK({"vjseq_zombie_climb_84","vjseq_zombie_climb_96"})
                finalpos = tr4.HitPos
            elseif IsValid(tr3.Entity) then
                anim = VJ.PICK({"vjseq_zombie_climb_84","vjseq_zombie_climb_96"})
                finalpos = tr3.HitPos
            elseif IsValid(tr2.Entity) then
                anim = VJ.PICK({"vjseq_zombie_climb_50","vjseq_zombie_climb_60","vjseq_zombie_climb_70","vjseq_zombie_climb_72"})
                finalpos = tr2.HitPos
            elseif IsValid(tr1.Entity) then
                anim = VJ.PICK({"vjseq_zombie_climb_24","vjseq_zombie_climb_36","vjseq_zombie_climb_38","vjseq_zombie_climb_48","vjseq_zombie_climb_38"})
                finalpos = tr1.HitPos
end
            if anim != false then
                //print(anim)
                self:SetGroundEntity(NULL)
                self.Zombie_Climbing = true
                timer.Simple(0.4,function()
                    if IsValid(self) then
                        self:SetPos(finalpos)
    end
end)
                self:PlayAnim(anim,true,false/*self:DecideAnimationLength(anim,false,0.4)*/,true,0,{},function(vsched)
                    vsched.RunCode_OnFinish = function()
                        //self:SetGroundEntity(NULL)
                        //self:SetPos(finalpos)
                        self.Zombie_Climbing = false
                    end
                end)
            end
            self.Zombie_NextClimb = CurTime() + 0.1 //5
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_OnThinkActive() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status,enemy)
    if status == "Init" then
    if self.Zombie_Crippled then
        self.MeleeAttackDistance = 25
        self.MeleeAttackDamageDistance = 45
        self.AnimTbl_MeleeAttack = {
        "vjseq_crawl_melee2013_1",
        "vjseq_crawl_melee2013_2"
}
        return end
    /*
    --if !self:IsMoving() && !self.VJ_IsBeingControlled && !self.Zombie_Crouching then
        self.AnimTbl_MeleeAttack = {
        "vjseq_melee_cont_01"
}
    */
    if self.Zombie_Sprinter or (self.VJ_IsBeingControlled && self.Zombie_ControllerAnim == 1) then
        self.AnimTbl_MeleeAttack = {
        "vjges_melee2020_player_01",
        "vjges_melee2020_player_02",
        "vjges_melee2020_player_03"
}
    elseif !self.Zombie_Sprinter or (self.VJ_IsBeingControlled && self.Zombie_ControllerAnim == 0) then
        self.AnimTbl_MeleeAttack = {
        "vjges_melee2013_01",
        "vjges_melee2013_02",
        "vjges_melee2013_03",
        "vjges_melee2013_04",
        "vjges_melee2013_05",
        "vjges_melee2013_06",
        "vjges_melee2013_07",
        "vjges_melee2013_08"
        //"vjges_"..ACT_MELEE_ATTACK2
}
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt,isProp)
  if self:IsOnFire() then hitEnt:Ignite(4) end
    return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:CustomOnMeleeAttack_Miss()
    if self.Zombie_Crippled or self.Zombie_Crouching or self.VJ_IsBeingControlled then return end
    if self.MeleeAttacking && self:GetSequence() == self:LookupSequence("melee_cont_01") then
       self:PlayAnim("idle2013_facearound_01",true,0.1,true)
       self:StopAttacks(true)
       self.MeleeAttacking = false
       self.AttackAnimTime = 0
       self:DoChaseAnimation()
    end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Cripple()
    self:SetHullType(HULL_TINY)
    self:SetCollisionBounds(Vector(13,13,25),Vector(-13,-13,0))
    //self.MeleeAttackDamage = self.MeleeAttackDamage /2
    self.ControllerParams = {
    CameraMode = 1,
    ThirdP_Offset = Vector(45, 20, -15),
    FirstP_Bone = "ValveBiped.Bip01_Head",
    FirstP_Offset = Vector(10, 0, -30),
}
    self.JumpParams.Enabled = false
    self:CapabilitiesRemove(bit.bor(CAP_MOVE_JUMP, CAP_MOVE_CLIMB))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo,hitgroup,status)
    if status == "PreDamage" && dmginfo:IsBulletDamage() && hitgroup == HITGROUP_HEAD && GetConVar("VJ_CON_Headshot"):GetInt() == 1 && self:GetClass() != "npc_vj_con_zcarrier" && self:GetClass() != "npc_vj_con_zriotbrute" && !self.Riot_Helmet then
        dmginfo:SetDamage(self:GetMaxHealth())
end
    /*if status == "PreDamage" && self:GetClass() == "npc_vj_con_zcarrier" then
        dmginfo:ScaleDamage(0.5)
end*/
    self:ArmorDamage(dmginfo,hitgroup,status)
    if status == "PostDamage" && self:IsOnFire() && self:Health() > 0 then self:PlaySoundSystem("Pain",self.SoundTbl_Burning) end
    if self.Zombie_Crippled then return end
    if status == "PostDamage" && self:Health() > 0 && !self.Zombie_Crouching && self:IsMoving() && self.Zombie_NextStumbleT < CurTime() && math.random(1,16) == 1 && self:GetSequence() != self:LookupSequence("shoved_backwards_heavy") && self:GetSequence() != self:LookupSequence("shoved_forward1") && self:GetSequence() != self:LookupSequence("shoved_forward2") && self:GetSequence() != self:LookupSequence("shoved_backwards1") && self:GetSequence() != self:LookupSequence("shoved_backwards2") && self:GetSequence() != self:LookupSequence("shoved_backwards3") then
    if dmginfo:GetDamage() > 30 or dmginfo:GetDamageForce():Length() > 10000 or bit.band(dmginfo:GetDamageType(), DMG_BUCKSHOT) != 0 or dmginfo:IsExplosionDamage() then
    if self:IsPlayingGesture(self.AttackAnim) then -- Stop the attack gesture!
        self:RemoveGesture(self.AttackAnim)
end
        self:PlayAnim({"vjseq_shoved_forward1","vjseq_shoved_forward2","vjseq_shoved_forward_heavy"},true,false,false)
        self.Zombie_NextStumbleT = CurTime() + math.Rand(8,14)
    end
end
 if self:GetClass() == "npc_vj_con_zcarrier" or self:GetClass() == "npc_vj_con_zriotbrute" or self:GetClass() == "npc_vj_con_zriot" or self:GetClass() == "npc_vj_con_zriotsol" then return end
    if status == "PostDamage" && self:Health() > 0 && !self.Zombie_Crippled && !self.Zombie_Crouching && self:GetSequence() != self:LookupSequence("shoved_forward_heavy") && self:GetSequence() != self:LookupSequence("shoved_backwards_heavy") && self:GetActivity() != ACT_JUMP && self:GetActivity() != ACT_GLIDE then
    local legs = {6,7,10,11}
     if VJ.HasValue(legs,hitgroup) then
        self.Zombie_LegHealth = self.Zombie_LegHealth -dmginfo:GetDamage()
     if self.Zombie_LegHealth <= 0 then
        self.Zombie_Crippled = true
        local anim = "vjseq_gib_legboth"
        if hitgroup == HITGROUP_LEFTLEG or hitgroup == 10 then
            anim = "vjseq_gib_legl"
        elseif hitgroup == HITGROUP_RIGHTLEG or hitgroup == 11 then
            anim = "vjseq_gib_legr"
end
            if math.random(1,4) == 1 then anim = "vjseq_gib_legboth" end
            self:PlayAnim(anim,true,false,false)
            self:Cripple()
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ArmorDamage(dmginfo,hitgroup,status) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo,hitgroup,status)
 if status == "Init" then
    if !self.Zombie_Crouching && !self.Zombie_Crippled && !self.Zombie_Climbing && !self.RiotBrute_Charging then
    if dmginfo:GetDamage() > 30 or dmginfo:GetDamageForce():Length() > 10000 or bit.band(dmginfo:GetDamageType(), DMG_BUCKSHOT) != 0 or dmginfo:IsExplosionDamage() or dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_GENERIC) then
        self.AnimTbl_Flinch = {"vjseq_shoved_backwards1","vjseq_shoved_backwards2","vjseq_shoved_backwards3","vjseq_shoved_backwards_heavy"}
        self.FlinchCooldown = math.Rand(5,8)
    else
        self.AnimTbl_Flinch = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}
        self.FlinchCooldown = 1
    end
end
        return self:GetActivity() == ACT_JUMP or self:GetActivity() == ACT_GLIDE or self:GetActivity() == ACT_LAND or self.Zombie_Crouching or self.Zombie_Climbing or self:GetSequenceName(self:GetSequence()) == "brute_charge_begin" or self:GetSequenceName(self:GetSequence()) == "shoved_backwards_wall1" or self:GetSequence() == self:LookupSequence("shoved_forward_heavy") or self:GetSequence() == self:LookupSequence("shoved_forward1") or self:GetSequence() == self:LookupSequence("shoved_forward2") -- If we are doing certaina activities then DO NOT flinch!
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo,hitgroup,status)
    if status == "Init" && (self:GetActivity() == ACT_JUMP or self:GetActivity() == ACT_GLIDE or self:GetActivity() == ACT_LAND or self.Zombie_IsClimbing or self.Zombie_Crouching or self.Zombie_Crippled or self:GetSequence() == self:LookupSequence("shoved_forward_heavy") or self:GetSequence() == self:LookupSequence("shoved_backwards_heavy") or self:GetSequence() == self:LookupSequence("shoved_forward1") or self:GetSequence() == self:LookupSequence("shoved_forward2") or self:GetSequence() == self:LookupSequence("shoved_backwards1") or self:GetSequence() == self:LookupSequence("shoved_backwards2") or self:GetSequence() == self:LookupSequence("shoved_backwards3") or dmginfo:IsExplosionDamage()) then self.HasDeathAnimation = false end
    //self.DeathAnimationDecreaseLengthAmount = math.Rand(0,0.325)
    if status == "DeathAnim" then
    if self:IsMoving() then -- Death anims when moving
       self.AnimTbl_Death = {"vjseq_death2013_run_06","vjseq_death2013_run_07","vjseq_death2012_run","vjseq_death2012_run2","vjseq_death2012_run3"}
end
    if dmginfo:GetDamageForce():Length() > 10000 or bit.band(dmginfo:GetDamageType(), DMG_BUCKSHOT) != 0 then -- When killed by shotgun damage
        self.AnimTbl_Death = {"vjseq_death2013_shotgun_backward","vjseq_death2013_shotgun_forward","vjseq_death2013_shotgun_left","vjseq_death2013_shotgun_right"}
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo,hitgroup,corpseEnt)
    VJ_CON_ApplyCorpseEffects(self,corpseEnt)
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FootSteps = {
    [MAT_ANTLION] = {
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_01.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_02.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_03.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_04.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_05.wav"
    },
    [MAT_BLOODYFLESH] = {
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_01.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_02.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_03.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_04.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_05.wav"
    },
    [MAT_CONCRETE] = {
        "vj_contagion/zombies/footsteps/fs_concretenew_02.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_03.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_04.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_05.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_06.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_07.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_08.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_09.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_10.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_11.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_12.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_13.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_14.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_15.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_16.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_17.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_18.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_19.wav",
        "vj_contagion/zombies/footsteps/fs_concretenew_20.wav"
    },
    [MAT_DIRT] = {
        "vj_contagion/zombies/footsteps/footsteps_dirt_01.wav",
        "vj_contagion/zombies/footsteps/footsteps_dirt_02.wav",
        "vj_contagion/zombies/footsteps/footsteps_dirt_03.wav",
        "vj_contagion/zombies/footsteps/footsteps_dirt_04.wav",
        "vj_contagion/zombies/footsteps/footsteps_dirt_05.wav",
        "vj_contagion/zombies/footsteps/footsteps_dirt_06.wav",
        "vj_contagion/zombies/footsteps/footsteps_dirt_07.wav",
        "vj_contagion/zombies/footsteps/footsteps_dirt_08.wav",
        "vj_contagion/zombies/footsteps/footsteps_dirt_09.wav"
    },
    [MAT_FLESH] = {
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_01.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_02.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_03.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_04.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_05.wav"
    },
    [MAT_GRATE] = {
        "vj_contagion/zombies/footsteps/fs_metalgrate_01.wav",
        "vj_contagion/zombies/footsteps/fs_metalgrate_02.wav",
        "vj_contagion/zombies/footsteps/fs_metalgrate_03.wav",
        "vj_contagion/zombies/footsteps/fs_metalgrate_04.wav",
        "vj_contagion/zombies/footsteps/fs_metalgrate_05.wav",
        "vj_contagion/zombies/footsteps/fs_metalgrate_06.wav"
    },
    [MAT_ALIENFLESH] = {
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_01.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_02.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_03.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_04.wav",
        "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_05.wav"
    },
    [74] = { -- Snow
        "vj_contagion/zombies/footsteps/snow1.wav",
        "vj_contagion/zombies/footsteps/snow2.wav",
        "vj_contagion/zombies/footsteps/snow3.wav",
        "vj_contagion/zombies/footsteps/snow4.wav"
    },
    [MAT_PLASTIC] = {
        "vj_contagion/zombies/footsteps/footstep_plastic-01.wav",
        "vj_contagion/zombies/footsteps/footstep_plastic-02.wav",
        "vj_contagion/zombies/footsteps/footstep_plastic-03.wav",
        "vj_contagion/zombies/footsteps/footstep_plastic-04.wav"
    },
    [MAT_METAL] = {
        "vj_contagion/zombies/footsteps/solid_metal_step-01.wav",
        "vj_contagion/zombies/footsteps/solid_metal_step-02.wav",
        "vj_contagion/zombies/footsteps/solid_metal_step-03.wav",
        "vj_contagion/zombies/footsteps/solid_metal_step-04.wav",
        "vj_contagion/zombies/footsteps/solid_metal_step-05.wav",
        "vj_contagion/zombies/footsteps/solid_metal_step-06.wav"
    },
    [MAT_SAND] = {
        "vj_contagion/zombies/footsteps/fs_sand2_01.wav",
        "vj_contagion/zombies/footsteps/fs_sand2_02.wav",
        "vj_contagion/zombies/footsteps/fs_sand2_03.wav",
        "vj_contagion/zombies/footsteps/fs_sand2_04.wav",
        "vj_contagion/zombies/footsteps/fs_sand2_05.wav",
        "vj_contagion/zombies/footsteps/fs_sand2_06.wav"
    },
    [MAT_FOLIAGE] = {
        "vj_contagion/zombies/footsteps/fs_foliage_01.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_02.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_03.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_04.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_05.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_06.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_07.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_08.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_09.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_10.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_11.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_12.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_13.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_14.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_15.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_16.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_17.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_18.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_19.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_20.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_21.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_22.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_23.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_24.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_25.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_26.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_27.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_28.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_29.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_30.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_31.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_32.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_33.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_34.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_35.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_36.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_37.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_38.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_39.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_40.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_41.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_42.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_43.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_44.wav",
        "vj_contagion/zombies/footsteps/fs_foliage_45.wav"
    },
    [MAT_COMPUTER] = {
        "vj_contagion/zombies/footsteps/footstep_plastic-01.wav",
        "vj_contagion/zombies/footsteps/footstep_plastic-02.wav",
        "vj_contagion/zombies/footsteps/footstep_plastic-03.wav",
        "vj_contagion/zombies/footsteps/footstep_plastic-04.wav"
    },
    [MAT_SLOSH] = {
        "vj_contagion/zombies/footsteps/footsteps_wade_01.wav",
        "vj_contagion/zombies/footsteps/footsteps_wade_02.wav",
        "vj_contagion/zombies/footsteps/footsteps_wade_03.wav",
        "vj_contagion/zombies/footsteps/footsteps_wade_04.wav"
    },
    [MAT_TILE] = {
        "vj_contagion/zombies/footsteps/footsteps_ceilingtile_01.wav",
        "vj_contagion/zombies/footsteps/footsteps_ceilingtile_02.wav",
        "vj_contagion/zombies/footsteps/footsteps_ceilingtile_03.wav",
        "vj_contagion/zombies/footsteps/footsteps_ceilingtile_04.wav"
    },
    [85] = { -- Grass
        "vj_contagion/zombies/footsteps/fs_grass_01.wav",
        "vj_contagion/zombies/footsteps/fs_grass_02.wav",
        "vj_contagion/zombies/footsteps/fs_grass_03.wav",
        "vj_contagion/zombies/footsteps/fs_grass_04.wav",
        "vj_contagion/zombies/footsteps/fs_grass_05.wav",
        "vj_contagion/zombies/footsteps/fs_grass_06.wav",
        "vj_contagion/zombies/footsteps/fs_grass_07.wav",
        "vj_contagion/zombies/footsteps/fs_grass_08.wav",
        "vj_contagion/zombies/footsteps/fs_grass_09.wav",
        "vj_contagion/zombies/footsteps/fs_grass_10.wav",
        "vj_contagion/zombies/footsteps/fs_grass_11.wav",
        "vj_contagion/zombies/footsteps/fs_grass_12.wav",
        "vj_contagion/zombies/footsteps/fs_grass_13.wav",
        "vj_contagion/zombies/footsteps/fs_grass_14.wav",
        "vj_contagion/zombies/footsteps/fs_grass_16.wav",
        "vj_contagion/zombies/footsteps/fs_grass_17.wav",
        "vj_contagion/zombies/footsteps/fs_grass_18.wav"
    },
    [MAT_VENT] = {
        "vj_contagion/zombies/footsteps/footstep_metalvent-01.wav",
        "vj_contagion/zombies/footsteps/footstep_metalvent-02.wav",
        "vj_contagion/zombies/footsteps/footstep_metalvent-03.wav",
        "vj_contagion/zombies/footsteps/footstep_metalvent-04.wav"
    },
    [MAT_WOOD] = {
        "vj_contagion/zombies/footsteps/wood_floor_step-02.wav",
        "vj_contagion/zombies/footsteps/wood_floor_step-03.wav",
        "vj_contagion/zombies/footsteps/wood_floor_step-04.wav",
        "vj_contagion/zombies/footsteps/wood_floor_step-05.wav",
        "vj_contagion/zombies/footsteps/wood_floor_step-06.wav"
    },
    [MAT_GLASS] = {
        "vj_contagion/zombies/footsteps/footstep_glasspane-01.wav",
        "vj_contagion/zombies/footsteps/footstep_glasspane-02.wav"
    }
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFootstepSound()
    if !self:IsOnGround() then return end
    local tr = util.TraceLine({
        start = self:GetPos(),
        endpos = self:GetPos() +Vector(0,0,-150),
        filter = {self}
    })
    if tr.Hit && self.FootSteps[tr.MatType] then
        VJ.EmitSound(self,VJ.PICK(self.FootSteps[tr.MatType]),self.FootstepSoundLevel,self:GetSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
    end
    if self:WaterLevel() > 0 && self:WaterLevel() < 3 then
        VJ.EmitSound(self,"vj_contagion/zombies/footsteps/footsteps_wade_0" .. math.random(1,4) .. ".wav",self.FootstepSoundLevel,self:GetSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_2013()
        self.SoundTbl_Idle = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 167 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 168 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 169 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 170 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 171 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 172 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 173 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 174 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 175 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 176 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 177 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 178 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 179 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 180 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 181 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 182 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 183 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 184 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 185 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 186 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 187 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 188 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 189 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 190 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 191 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 192 - Idle.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 193 - Idle.wav"
}
        self.SoundTbl_Investigate = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 1 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 2 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 3 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 4 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 5 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 6 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 7 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 8 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 9 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 10 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 11 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 12 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 13 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 14 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 15 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 16 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 17 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 18 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 19 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 20 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 21 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 22 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 23 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 24 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 25 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 26 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 27 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 28 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 29 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 30 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 31 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 32 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 33 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 34 - Alert.wav"
}
        self.SoundTbl_Alert = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 1 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 2 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 3 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 4 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 5 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 6 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 7 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 8 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 9 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 10 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 11 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 12 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 13 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 14 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 15 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 16 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 17 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 18 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 19 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 20 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 21 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 22 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 23 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 24 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 25 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 26 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 27 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 28 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 29 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 30 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 31 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 32 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 33 - Alert.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 34 - Alert.wav"
}
        self.SoundTbl_CallForHelp = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 161 - Roar.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 162 - Roar.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 163 - Roar.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 164 - Roar.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 165 - Roar.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 166 - Roar.wav"
}
        self.SoundTbl_CombatIdle = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 100 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 101 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 102 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 103 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 104 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 105 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 106 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 107 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 108 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 109 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 110 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 111 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 112 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 113 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 114 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 115 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 116 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 117 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 118 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 119 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 120 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 121 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 122 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 123 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 124 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 125 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 126 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 127 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 128 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 129 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 130 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 131 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 132 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 133 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 134 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 135 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 136 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 137 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 138 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 139 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 140 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 141 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 142 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 143 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 144 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 145 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 146 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 147 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 148 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 149 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 150 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 151 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 152 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 153 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 154 - BecomeEnraged.wav"
}
        self.SoundTbl_BeforeMeleeAttack = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 70 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 71 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 72 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 73 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 74 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 75 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 76 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 77 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 78 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 79 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 80 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 81 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 82 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 83 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 84 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 85 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 86 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 87 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 88 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 89 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 90 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 91 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 92 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 93 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 94 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 95 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 96 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 97 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 98 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 99 - BecomeEnraged.wav"
}
        self.SoundTbl_Grapple = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 70 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 71 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 72 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 73 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 74 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 75 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 76 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 77 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 78 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 79 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 80 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 81 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 82 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 83 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 84 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 85 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 86 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 87 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 88 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 89 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 90 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 91 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 92 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 93 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 94 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 95 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 96 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 97 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 98 - BecomeEnraged.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 99 - BecomeEnraged.wav"
}
        self.SoundTbl_Feast = {
        ""
}
        self.SoundTbl_Jump = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 35 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 36 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 37 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 38 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 39 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 40 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 41 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 42 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 43 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 44 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 45 - Jump.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 46 - Jump.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 47 - Jump.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 48 - Jump.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 49 - Jump.wav"
}
        self.SoundTbl_Pain = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 50 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 51 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 52 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 53 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 54 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 55 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 56 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 57 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 58 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 59 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 60 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 61 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 62 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 63 - Pain.wav"
}
        self.SoundTbl_Burning = {
        ""
}
        self.SoundTbl_Death = {
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 155 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 156 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 157 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 158 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 159 - Pain.wav",
        "vj_contagion/zombies/2013/2013 03 21 VO Zombie - 160 - Pain.wav"
}
     if self.Zombie_Gender == 1 then
        self.IdleSoundPitch = VJ.SET(120, 120)
        self.CombatIdleSoundPitch = VJ.SET(120, 120)
        self.InvestigateSoundPitch = VJ.SET(120, 120)
        self.AlertSoundPitch = VJ.SET(120, 120)
        self.CallForHelpSoundPitch = VJ.SET(120, 120)
        self.BeforeMeleeAttackSoundPitch = VJ.SET(120, 120)
        self.PainSoundPitch = VJ.SET(120, 120)
        self.DeathSoundPitch = VJ.SET(120, 120)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_Scottlam()
        self.SoundTbl_Idle = {
        "vj_contagion/zombies/scottlambright/149 scottlambright_zombie_idle_short_01.wav",
        "vj_contagion/zombies/scottlambright/150 scottlambright_zombie_idle_short_02.wav",
        "vj_contagion/zombies/scottlambright/151 scottlambright_zombie_idle_short_03.wav",
        "vj_contagion/zombies/scottlambright/152 scottlambright_zombie_idle_short_04.wav",
        "vj_contagion/zombies/scottlambright/153 scottlambright_zombie_idle_short_05.wav",
        "vj_contagion/zombies/scottlambright/154 scottlambright_zombie_idle_short_06.wav",
        "vj_contagion/zombies/scottlambright/155 scottlambright_zombie_idle_short_07.wav",
        "vj_contagion/zombies/scottlambright/156 scottlambright_zombie_idle_short_08.wav",
        "vj_contagion/zombies/scottlambright/157 scottlambright_zombie_idle_medium_01.wav",
        "vj_contagion/zombies/scottlambright/158 scottlambright_zombie_idle_medium_02.wav",
        "vj_contagion/zombies/scottlambright/159 scottlambright_zombie_idle_medium_03.wav",
        "vj_contagion/zombies/scottlambright/160 scottlambright_zombie_idle_medium_04.wav",
        "vj_contagion/zombies/scottlambright/161 scottlambright_zombie_idle_medium_05.wav",
        "vj_contagion/zombies/scottlambright/162 scottlambright_zombie_idle_medium_06.wav",
        "vj_contagion/zombies/scottlambright/163 scottlambright_zombie_idle_medium_07.wav",
        "vj_contagion/zombies/scottlambright/164 scottlambright_zombie_idle_medium_08.wav",
        "vj_contagion/zombies/scottlambright/165 scottlambright_zombie_idle_medium_09.wav",
        "vj_contagion/zombies/scottlambright/166 scottlambright_zombie_idle_medium_10.wav",
        "vj_contagion/zombies/scottlambright/167 scottlambright_zombie_idle_medium_11.wav",
        "vj_contagion/zombies/scottlambright/168 scottlambright_zombie_idle_medium_12.wav",
        "vj_contagion/zombies/scottlambright/169 scottlambright_zombie_idle_medium_13.wav",
        "vj_contagion/zombies/scottlambright/170 scottlambright_zombie_idle_long_01.wav",
        "vj_contagion/zombies/scottlambright/171 scottlambright_zombie_idle_long_02.wav",
        "vj_contagion/zombies/scottlambright/172 scottlambright_zombie_idle_long_03.wav",
        "vj_contagion/zombies/scottlambright/173 scottlambright_zombie_idle_long_04.wav",
        "vj_contagion/zombies/scottlambright/174 scottlambright_zombie_idle_long_05.wav"
}
        self.SoundTbl_Investigate = {
        "vj_contagion/zombies/scottlambright/3 scottlambright_zombie_alert_veryshort_01.wav",
        "vj_contagion/zombies/scottlambright/4 scottlambright_zombie_alert_veryshort_02.wav",
        "vj_contagion/zombies/scottlambright/5 scottlambright_zombie_alert_veryshort_03.wav",
        "vj_contagion/zombies/scottlambright/6 scottlambright_zombie_alert_veryshort_04.wav",
        "vj_contagion/zombies/scottlambright/7 scottlambright_zombie_alert_veryshort_05.wav",
        "vj_contagion/zombies/scottlambright/8 scottlambright_zombie_alert_veryshort_06.wav",
        "vj_contagion/zombies/scottlambright/9 scottlambright_zombie_alert_veryshort_07.wav",
        "vj_contagion/zombies/scottlambright/10 scottlambright_zombie_alert_veryshort_08.wav",
        "vj_contagion/zombies/scottlambright/11 scottlambright_zombie_alert_veryshort_09.wav",
        "vj_contagion/zombies/scottlambright/12 scottlambright_zombie_alert_veryshort_10.wav",
        "vj_contagion/zombies/scottlambright/13 scottlambright_zombie_alert_veryshort_11.wav",
        "vj_contagion/zombies/scottlambright/14 scottlambright_zombie_alert_short_01.wav",
        "vj_contagion/zombies/scottlambright/15 scottlambright_zombie_alert_short_02.wav",
        "vj_contagion/zombies/scottlambright/16 scottlambright_zombie_alert_short_03.wav",
        "vj_contagion/zombies/scottlambright/17 scottlambright_zombie_alert_short_04.wav",
        "vj_contagion/zombies/scottlambright/18 scottlambright_zombie_alert_short_05.wav",
        "vj_contagion/zombies/scottlambright/19 scottlambright_zombie_alert_short_06.wav",
        "vj_contagion/zombies/scottlambright/20 scottlambright_zombie_alert_short_07.wav",
        "vj_contagion/zombies/scottlambright/21 scottlambright_zombie_alert_short_08.wav",
        "vj_contagion/zombies/scottlambright/22 scottlambright_zombie_alert_short_09.wav",
        "vj_contagion/zombies/scottlambright/23 scottlambright_zombie_alert_medium_01.wav",
        "vj_contagion/zombies/scottlambright/24 scottlambright_zombie_alert_medium_02.wav",
        "vj_contagion/zombies/scottlambright/25 scottlambright_zombie_alert_medium_03.wav",
        "vj_contagion/zombies/scottlambright/26 scottlambright_zombie_alert_medium_04.wav",
        "vj_contagion/zombies/scottlambright/27 scottlambright_zombie_alert_medium_05.wav",
        "vj_contagion/zombies/scottlambright/28 scottlambright_zombie_alert_medium_06.wav"
}
        self.SoundTbl_Alert = {
        "vj_contagion/zombies/scottlambright/3 scottlambright_zombie_alert_veryshort_01.wav",
        "vj_contagion/zombies/scottlambright/4 scottlambright_zombie_alert_veryshort_02.wav",
        "vj_contagion/zombies/scottlambright/5 scottlambright_zombie_alert_veryshort_03.wav",
        "vj_contagion/zombies/scottlambright/6 scottlambright_zombie_alert_veryshort_04.wav",
        "vj_contagion/zombies/scottlambright/7 scottlambright_zombie_alert_veryshort_05.wav",
        "vj_contagion/zombies/scottlambright/8 scottlambright_zombie_alert_veryshort_06.wav",
        "vj_contagion/zombies/scottlambright/9 scottlambright_zombie_alert_veryshort_07.wav",
        "vj_contagion/zombies/scottlambright/10 scottlambright_zombie_alert_veryshort_08.wav",
        "vj_contagion/zombies/scottlambright/11 scottlambright_zombie_alert_veryshort_09.wav",
        "vj_contagion/zombies/scottlambright/12 scottlambright_zombie_alert_veryshort_10.wav",
        "vj_contagion/zombies/scottlambright/13 scottlambright_zombie_alert_veryshort_11.wav",
        "vj_contagion/zombies/scottlambright/14 scottlambright_zombie_alert_short_01.wav",
        "vj_contagion/zombies/scottlambright/15 scottlambright_zombie_alert_short_02.wav",
        "vj_contagion/zombies/scottlambright/16 scottlambright_zombie_alert_short_03.wav",
        "vj_contagion/zombies/scottlambright/17 scottlambright_zombie_alert_short_04.wav",
        "vj_contagion/zombies/scottlambright/18 scottlambright_zombie_alert_short_05.wav",
        "vj_contagion/zombies/scottlambright/19 scottlambright_zombie_alert_short_06.wav",
        "vj_contagion/zombies/scottlambright/20 scottlambright_zombie_alert_short_07.wav",
        "vj_contagion/zombies/scottlambright/21 scottlambright_zombie_alert_short_08.wav",
        "vj_contagion/zombies/scottlambright/22 scottlambright_zombie_alert_short_09.wav",
        "vj_contagion/zombies/scottlambright/23 scottlambright_zombie_alert_medium_01.wav",
        "vj_contagion/zombies/scottlambright/24 scottlambright_zombie_alert_medium_02.wav",
        "vj_contagion/zombies/scottlambright/25 scottlambright_zombie_alert_medium_03.wav",
        "vj_contagion/zombies/scottlambright/26 scottlambright_zombie_alert_medium_04.wav",
        "vj_contagion/zombies/scottlambright/27 scottlambright_zombie_alert_medium_05.wav",
        "vj_contagion/zombies/scottlambright/28 scottlambright_zombie_alert_medium_06.wav"
}
        self.SoundTbl_CallForHelp = {
        "vj_contagion/zombies/scottlambright/217 scottlambright_zombie_roar_01.wav",
        "vj_contagion/zombies/scottlambright/218 scottlambright_zombie_roar_02.wav",
        "vj_contagion/zombies/scottlambright/219 scottlambright_zombie_roar_03.wav",
        "vj_contagion/zombies/scottlambright/220 scottlambright_zombie_roar_04.wav",
        "vj_contagion/zombies/scottlambright/221 scottlambright_zombie_roar_05.wav",
        "vj_contagion/zombies/scottlambright/222 scottlambright_zombie_roar_06.wav"
}
        self.SoundTbl_CombatIdle = {
        "vj_contagion/zombies/scottlambright/263 scottlambright_zombie_wild_01.wav",
        "vj_contagion/zombies/scottlambright/264 scottlambright_zombie_wild_02.wav",
        "vj_contagion/zombies/scottlambright/265 scottlambright_zombie_wild_03.wav",
        "vj_contagion/zombies/scottlambright/266 scottlambright_zombie_wild_04.wav",
        "vj_contagion/zombies/scottlambright/267 scottlambright_zombie_wild_05.wav",
        "vj_contagion/zombies/scottlambright/268 scottlambright_zombie_wild_06.wav",
        "vj_contagion/zombies/scottlambright/269 scottlambright_zombie_wild_07.wav",
        "vj_contagion/zombies/scottlambright/270 scottlambright_zombie_wild_08.wav",
        "vj_contagion/zombies/scottlambright/271 scottlambright_zombie_wild_09.wav",
        "vj_contagion/zombies/scottlambright/272 scottlambright_zombie_wild_10.wav",
        "vj_contagion/zombies/scottlambright/273 scottlambright_zombie_wild_11.wav",
        "vj_contagion/zombies/scottlambright/274 scottlambright_zombie_wild_12.wav",
        "vj_contagion/zombies/scottlambright/275 scottlambright_zombie_wild_13.wav",
        "vj_contagion/zombies/scottlambright/276 scottlambright_zombie_wild_14.wav",
        "vj_contagion/zombies/scottlambright/277 scottlambright_zombie_wild_15.wav",
        "vj_contagion/zombies/scottlambright/278 scottlambright_zombie_wild_16.wav",
        "vj_contagion/zombies/scottlambright/279 scottlambright_zombie_wild_17.wav",
        "vj_contagion/zombies/scottlambright/280 scottlambright_zombie_wild_18.wav",
        "vj_contagion/zombies/scottlambright/281 scottlambright_zombie_wild_19.wav",
        "vj_contagion/zombies/scottlambright/282 scottlambright_zombie_wild_20.wav",
        "vj_contagion/zombies/scottlambright/283 scottlambright_zombie_wild_21.wav",
        "vj_contagion/zombies/scottlambright/284 scottlambright_zombie_wild_22.wav",
        "vj_contagion/zombies/scottlambright/285 scottlambright_zombie_wild_23.wav",
        "vj_contagion/zombies/scottlambright/286 scottlambright_zombie_wild_24.wav",
        "vj_contagion/zombies/scottlambright/287 scottlambright_zombie_wild_25.wav",
        "vj_contagion/zombies/scottlambright/288 scottlambright_zombie_wild_26.wav",
        "vj_contagion/zombies/scottlambright/289 scottlambright_zombie_wild_27.wav",
        "vj_contagion/zombies/scottlambright/290 scottlambright_zombie_wild_28.wav",
        "vj_contagion/zombies/scottlambright/291 scottlambright_zombie_wild_29.wav",
        "vj_contagion/zombies/scottlambright/292 scottlambright_zombie_wild_30.wav",
        "vj_contagion/zombies/scottlambright/293 scottlambright_zombie_wild_31.wav",
        "vj_contagion/zombies/scottlambright/294 scottlambright_zombie_wild_32.wav",
        "vj_contagion/zombies/scottlambright/295 scottlambright_zombie_wild_33.wav",
        "vj_contagion/zombies/scottlambright/296 scottlambright_zombie_wild_34.wav",
        "vj_contagion/zombies/scottlambright/297 scottlambright_zombie_wild_35.wav",
        "vj_contagion/zombies/scottlambright/298 scottlambright_zombie_wild_36.wav",
        "vj_contagion/zombies/scottlambright/299 scottlambright_zombie_wild_37.wav",
        "vj_contagion/zombies/scottlambright/300 scottlambright_zombie_wild_38.wav",
        "vj_contagion/zombies/scottlambright/301 scottlambright_zombie_wild_39.wav",
        "vj_contagion/zombies/scottlambright/302 scottlambright_zombie_wild_40.wav",
        "vj_contagion/zombies/scottlambright/303 scottlambright_zombie_wild_41.wav",
        "vj_contagion/zombies/scottlambright/304 scottlambright_zombie_wild_42.wav",
        "vj_contagion/zombies/scottlambright/305 scottlambright_zombie_wild_43.wav",
        "vj_contagion/zombies/scottlambright/306 scottlambright_zombie_wild_44.wav",
        "vj_contagion/zombies/scottlambright/307 scottlambright_zombie_wild_45.wav",
        "vj_contagion/zombies/scottlambright/308 scottlambright_zombie_wild_46.wav",
        "vj_contagion/zombies/scottlambright/309 scottlambright_zombie_wild_47.wav",
        "vj_contagion/zombies/scottlambright/310 scottlambright_zombie_wild_48.wav",
        "vj_contagion/zombies/scottlambright/311 scottlambright_zombie_wild_49.wav",
        "vj_contagion/zombies/scottlambright/312 scottlambright_zombie_wild_50.wav",
        "vj_contagion/zombies/scottlambright/313 scottlambright_zombie_wild_51.wav",
        "vj_contagion/zombies/scottlambright/314 scottlambright_zombie_wild_52.wav",
        "vj_contagion/zombies/scottlambright/315 scottlambright_zombie_wild_53.wav",
        "vj_contagion/zombies/scottlambright/316 scottlambright_zombie_wild_54.wav",
        "vj_contagion/zombies/scottlambright/317 scottlambright_zombie_wild_55.wav",
        "vj_contagion/zombies/scottlambright/318 scottlambright_zombie_wild_56.wav",
        "vj_contagion/zombies/scottlambright/319 scottlambright_zombie_wild_57.wav",
        "vj_contagion/zombies/scottlambright/320 scottlambright_zombie_wild_58.wav",
        "vj_contagion/zombies/scottlambright/321 scottlambright_zombie_wild_59.wav",
        "vj_contagion/zombies/scottlambright/322 scottlambright_zombie_wild_60.wav",
        "vj_contagion/zombies/scottlambright/323 scottlambright_zombie_wild_61.wav",
        "vj_contagion/zombies/scottlambright/324 scottlambright_zombie_wild_62.wav",
        "vj_contagion/zombies/scottlambright/325 scottlambright_zombie_wild_63.wav",
        "vj_contagion/zombies/scottlambright/326 scottlambright_zombie_wild_64.wav",
        "vj_contagion/zombies/scottlambright/327 scottlambright_zombie_wild_65.wav",
        "vj_contagion/zombies/scottlambright/328 scottlambright_zombie_wild_66.wav",
        "vj_contagion/zombies/scottlambright/329 scottlambright_zombie_wild_67.wav",
        "vj_contagion/zombies/scottlambright/330 scottlambright_zombie_wild_68.wav",
        "vj_contagion/zombies/scottlambright/331 scottlambright_zombie_wild_69.wav",
        "vj_contagion/zombies/scottlambright/332 scottlambright_zombie_wild_70.wav",
        "vj_contagion/zombies/scottlambright/333 scottlambright_zombie_wild_71.wav",
        "vj_contagion/zombies/scottlambright/334 scottlambright_zombie_wild_72.wav",
        "vj_contagion/zombies/scottlambright/335 scottlambright_zombie_wild_73.wav",
        "vj_contagion/zombies/scottlambright/336 scottlambright_zombie_wild_74.wav",
        "vj_contagion/zombies/scottlambright/337 scottlambright_zombie_wild_75.wav",
        "vj_contagion/zombies/scottlambright/338 scottlambright_zombie_wild_76.wav",
        "vj_contagion/zombies/scottlambright/339 scottlambright_zombie_wild_77.wav",
        "vj_contagion/zombies/scottlambright/340 scottlambright_zombie_wild_78.wav",
        "vj_contagion/zombies/scottlambright/341 scottlambright_zombie_wild_79.wav",
        "vj_contagion/zombies/scottlambright/342 scottlambright_zombie_wild_80.wav",
        "vj_contagion/zombies/scottlambright/343 scottlambright_zombie_wild_81.wav",
        "vj_contagion/zombies/scottlambright/344 scottlambright_zombie_wild_82.wav",
        "vj_contagion/zombies/scottlambright/345 scottlambright_zombie_wild_83.wav",
        "vj_contagion/zombies/scottlambright/346 scottlambright_zombie_wild_84.wav",
        "vj_contagion/zombies/scottlambright/347 scottlambright_zombie_wild_85.wav",
        "vj_contagion/zombies/scottlambright/348 scottlambright_zombie_wild_86.wav",
        "vj_contagion/zombies/scottlambright/349 scottlambright_zombie_wild_87.wav",
        "vj_contagion/zombies/scottlambright/350 scottlambright_zombie_wild_88.wav"
}
        self.SoundTbl_BeforeMeleeAttack = {
        "vj_contagion/zombies/scottlambright/244 scottlambright_zombie_fight_01.wav",
        "vj_contagion/zombies/scottlambright/245 scottlambright_zombie_fight_02.wav",
        "vj_contagion/zombies/scottlambright/246 scottlambright_zombie_fight_03.wav",
        "vj_contagion/zombies/scottlambright/247 scottlambright_zombie_fight_04.wav",
        "vj_contagion/zombies/scottlambright/248 scottlambright_zombie_fight_05.wav",
        "vj_contagion/zombies/scottlambright/249 scottlambright_zombie_fight_06.wav",
        "vj_contagion/zombies/scottlambright/250 scottlambright_zombie_fight_07.wav",
        "vj_contagion/zombies/scottlambright/251 scottlambright_zombie_fight_08.wav",
        "vj_contagion/zombies/scottlambright/252 scottlambright_zombie_fight_09.wav",
        "vj_contagion/zombies/scottlambright/253 scottlambright_zombie_fight_10.wav",
        "vj_contagion/zombies/scottlambright/254 scottlambright_zombie_fight_11.wav",
        "vj_contagion/zombies/scottlambright/255 scottlambright_zombie_fight_12.wav",
        "vj_contagion/zombies/scottlambright/256 scottlambright_zombie_fight_13.wav",
        "vj_contagion/zombies/scottlambright/257 scottlambright_zombie_fight_14.wav",
        "vj_contagion/zombies/scottlambright/258 scottlambright_zombie_fight_15.wav",
        "vj_contagion/zombies/scottlambright/259 scottlambright_zombie_fight_16.wav",
        "vj_contagion/zombies/scottlambright/260 scottlambright_zombie_fight_17.wav",
        "vj_contagion/zombies/scottlambright/261 scottlambright_zombie_fight_18.wav",
        "vj_contagion/zombies/scottlambright/262 scottlambright_zombie_fight_19.wav"
}
        self.SoundTbl_Grapple = {
        "vj_contagion/zombies/scottlambright/137 scottlambright_zombie_grapple_short_01.wav",
        "vj_contagion/zombies/scottlambright/138 scottlambright_zombie_grapple_short_02.wav",
        "vj_contagion/zombies/scottlambright/139 scottlambright_zombie_grapple_short_03.wav",
        "vj_contagion/zombies/scottlambright/140 scottlambright_zombie_grapple_short_04.wav",
        "vj_contagion/zombies/scottlambright/141 scottlambright_zombie_grapple_short_05.wav",
        "vj_contagion/zombies/scottlambright/142 scottlambright_zombie_grapple_short_06.wav",
        "vj_contagion/zombies/scottlambright/143 scottlambright_zombie_grapple_medium_01.wav",
        "vj_contagion/zombies/scottlambright/144 scottlambright_zombie_grapple_medium_02.wav",
        "vj_contagion/zombies/scottlambright/145 scottlambright_zombie_grapple_medium_03.wav",
        "vj_contagion/zombies/scottlambright/146 scottlambright_zombie_grapple_medium_04.wav",
        "vj_contagion/zombies/scottlambright/147 scottlambright_zombie_grapple_medium_05.wav",
        "vj_contagion/zombies/scottlambright/148 scottlambright_zombie_grapple_medium_06.wav"
}
        self.SoundTbl_Feast = {
        "vj_contagion/zombies/scottlambright/223 scottlambright_zombie_feasting_01.wav",
        "vj_contagion/zombies/scottlambright/224 scottlambright_zombie_feasting_02.wav",
        "vj_contagion/zombies/scottlambright/225 scottlambright_zombie_feasting_03.wav",
        "vj_contagion/zombies/scottlambright/226 scottlambright_zombie_feasting_04.wav",
        "vj_contagion/zombies/scottlambright/227 scottlambright_zombie_feasting_05.wav",
        "vj_contagion/zombies/scottlambright/228 scottlambright_zombie_feasting_06.wav",
        "vj_contagion/zombies/scottlambright/229 scottlambright_zombie_feasting_07.wav",
        "vj_contagion/zombies/scottlambright/230 scottlambright_zombie_feasting_08.wav",
        "vj_contagion/zombies/scottlambright/231 scottlambright_zombie_feasting_09.wav",
        "vj_contagion/zombies/scottlambright/232 scottlambright_zombie_feasting_10.wav",
        "vj_contagion/zombies/scottlambright/233 scottlambright_zombie_feasting_11.wav"
}
        self.SoundTbl_Jump = {
        "vj_contagion/zombies/scottlambright/175 scottlambright_zombie_jump_01.wav",
        "vj_contagion/zombies/scottlambright/176 scottlambright_zombie_jump_02.wav",
        "vj_contagion/zombies/scottlambright/177 scottlambright_zombie_jump_03.wav",
        "vj_contagion/zombies/scottlambright/178 scottlambright_zombie_jump_04.wav",
        "vj_contagion/zombies/scottlambright/179 scottlambright_zombie_jump_05.wav",
        "vj_contagion/zombies/scottlambright/180 scottlambright_zombie_jump_06.wav",
        "vj_contagion/zombies/scottlambright/181 scottlambright_zombie_jump_07.wav",
        "vj_contagion/zombies/scottlambright/182 scottlambright_zombie_jump_08.wav",
        "vj_contagion/zombies/scottlambright/183 scottlambright_zombie_jump_09.wav",
        "vj_contagion/zombies/scottlambright/184 scottlambright_zombie_jump_10.wav",
        "vj_contagion/zombies/scottlambright/185 scottlambright_zombie_jump_11.wav",
        "vj_contagion/zombies/scottlambright/186 scottlambright_zombie_jump_12.wav",
        "vj_contagion/zombies/scottlambright/187 scottlambright_zombie_jump_13.wav",
        "vj_contagion/zombies/scottlambright/188 scottlambright_zombie_jump_14.wav",
        "vj_contagion/zombies/scottlambright/189 scottlambright_zombie_jump_15.wav",
        "vj_contagion/zombies/scottlambright/190 scottlambright_zombie_jump_16.wav"
}
        self.SoundTbl_Pain = {
        "vj_contagion/zombies/scottlambright/191 scottlambright_zombie_pain_veryshort_01.wav",
        "vj_contagion/zombies/scottlambright/192 scottlambright_zombie_pain_veryshort_02.wav",
        "vj_contagion/zombies/scottlambright/193 scottlambright_zombie_pain_veryshort_03.wav",
        "vj_contagion/zombies/scottlambright/194 scottlambright_zombie_pain_veryshort_04.wav",
        "vj_contagion/zombies/scottlambright/195 scottlambright_zombie_pain_veryshort_05.wav",
        "vj_contagion/zombies/scottlambright/196 scottlambright_zombie_pain_veryshort_06.wav",
        "vj_contagion/zombies/scottlambright/197 scottlambright_zombie_pain_veryshort_07.wav",
        "vj_contagion/zombies/scottlambright/198 scottlambright_zombie_pain_short_01.wav",
        "vj_contagion/zombies/scottlambright/199 scottlambright_zombie_pain_short_02.wav",
        "vj_contagion/zombies/scottlambright/200 scottlambright_zombie_pain_short_03.wav",
        "vj_contagion/zombies/scottlambright/201 scottlambright_zombie_pain_short_04.wav",
        "vj_contagion/zombies/scottlambright/202 scottlambright_zombie_pain_short_05.wav",
        "vj_contagion/zombies/scottlambright/203 scottlambright_zombie_pain_short_06.wav",
        "vj_contagion/zombies/scottlambright/204 scottlambright_zombie_pain_short_07.wav",
        "vj_contagion/zombies/scottlambright/205 scottlambright_zombie_pain_short_08.wav",
        "vj_contagion/zombies/scottlambright/206 scottlambright_zombie_pain_short_09.wav",
        "vj_contagion/zombies/scottlambright/207 scottlambright_zombie_pain_short_10.wav",
        "vj_contagion/zombies/scottlambright/208 scottlambright_zombie_pain_short_11.wav",
        "vj_contagion/zombies/scottlambright/209 scottlambright_zombie_pain_medium_01.wav",
        "vj_contagion/zombies/scottlambright/210 scottlambright_zombie_pain_medium_02.wav",
        "vj_contagion/zombies/scottlambright/211 scottlambright_zombie_pain_medium_03.wav",
        "vj_contagion/zombies/scottlambright/212 scottlambright_zombie_pain_medium_04.wav",
        "vj_contagion/zombies/scottlambright/213 scottlambright_zombie_pain_medium_05.wav",
        "vj_contagion/zombies/scottlambright/214 scottlambright_zombie_pain_medium_06.wav",
        "vj_contagion/zombies/scottlambright/215 scottlambright_zombie_pain_medium_07.wav",
        "vj_contagion/zombies/scottlambright/216 scottlambright_zombie_pain_medium_08.wav"
}
        self.SoundTbl_Burning = {
        "vj_contagion/zombies/scottlambright/127 scottlambright_zombie_burning_short_01.wav",
        "vj_contagion/zombies/scottlambright/128 scottlambright_zombie_burning_short_02.wav",
        "vj_contagion/zombies/scottlambright/129 scottlambright_zombie_burning_short_03.wav",
        "vj_contagion/zombies/scottlambright/130 scottlambright_zombie_burning_short_04.wav",
        "vj_contagion/zombies/scottlambright/131 scottlambright_zombie_burning_short_05.wav",
        "vj_contagion/zombies/scottlambright/132 scottlambright_zombie_burning_medium_01.wav",
        "vj_contagion/zombies/scottlambright/133 scottlambright_zombie_burning_medium_02.wav",
        "vj_contagion/zombies/scottlambright/134 scottlambright_zombie_burning_medium_03.wav",
        "vj_contagion/zombies/scottlambright/135 scottlambright_zombie_burning_medium_04.wav",
        "vj_contagion/zombies/scottlambright/136 scottlambright_zombie_burning_medium_05.wav"
}
        self.SoundTbl_Death = {
        "vj_contagion/zombies/scottlambright/96 scottlambright_zombie_die_short_01.wav",
        "vj_contagion/zombies/scottlambright/97 scottlambright_zombie_die_short_02.wav",
        "vj_contagion/zombies/scottlambright/98 scottlambright_zombie_die_short_03.wav",
        "vj_contagion/zombies/scottlambright/99 scottlambright_zombie_die_short_04.wav",
        "vj_contagion/zombies/scottlambright/100 scottlambright_zombie_die_short_05.wav",
        "vj_contagion/zombies/scottlambright/101 scottlambright_zombie_die_short_06.wav",
        "vj_contagion/zombies/scottlambright/102 scottlambright_zombie_die_short_07.wav",
        "vj_contagion/zombies/scottlambright/103 scottlambright_zombie_die_short_08.wav",
        "vj_contagion/zombies/scottlambright/104 scottlambright_zombie_die_short_09.wav",
        "vj_contagion/zombies/scottlambright/105 scottlambright_zombie_die_short_10.wav",
        "vj_contagion/zombies/scottlambright/106 scottlambright_zombie_die_short_11.wav",
        "vj_contagion/zombies/scottlambright/107 scottlambright_zombie_die_short_12.wav",
        "vj_contagion/zombies/scottlambright/108 scottlambright_zombie_die_medium_01.wav",
        "vj_contagion/zombies/scottlambright/109 scottlambright_zombie_die_medium_02.wav",
        "vj_contagion/zombies/scottlambright/110 scottlambright_zombie_die_medium_03.wav",
        "vj_contagion/zombies/scottlambright/111 scottlambright_zombie_die_medium_04.wav",
        "vj_contagion/zombies/scottlambright/112 scottlambright_zombie_die_medium_05.wav",
        "vj_contagion/zombies/scottlambright/113 scottlambright_zombie_die_medium_06.wav",
        "vj_contagion/zombies/scottlambright/114 scottlambright_zombie_dieheadshot_veryshort_01.wav",
        "vj_contagion/zombies/scottlambright/115 scottlambright_zombie_dieheadshot_veryshort_02.wav",
        "vj_contagion/zombies/scottlambright/116 scottlambright_zombie_dieheadshot_veryshort_03.wav",
        "vj_contagion/zombies/scottlambright/117 scottlambright_zombie_dieheadshot_veryshort_04.wav",
        "vj_contagion/zombies/scottlambright/118 scottlambright_zombie_dieheadshot_veryshort_05.wav",
        "vj_contagion/zombies/scottlambright/119 scottlambright_zombie_dieheadshot_veryshort_06.wav",
        "vj_contagion/zombies/scottlambright/120 scottlambright_zombie_dieheadshot_veryshort_07.wav",
        "vj_contagion/zombies/scottlambright/121 scottlambright_zombie_dieheadshot_veryshort_08.wav",
        "vj_contagion/zombies/scottlambright/122 scottlambright_zombie_dieheadshot_veryshort_09.wav",
        "vj_contagion/zombies/scottlambright/123 scottlambright_zombie_dieheadshot_veryshort_10.wav",
        "vj_contagion/zombies/scottlambright/124 scottlambright_zombie_dieheadshot_veryshort_11.wav",
        "vj_contagion/zombies/scottlambright/125 scottlambright_zombie_dieheadshot_veryshort_12.wav",
        "vj_contagion/zombies/scottlambright/126 scottlambright_zombie_dieheadshot_veryshort_13.wav",
        "vj_contagion/zombies/scottlambright/85 scottlambright_zombie_die_veryshort_01.wav",
        "vj_contagion/zombies/scottlambright/86 scottlambright_zombie_die_veryshort_02.wav",
        "vj_contagion/zombies/scottlambright/87 scottlambright_zombie_die_veryshort_03.wav",
        "vj_contagion/zombies/scottlambright/88 scottlambright_zombie_die_veryshort_04.wav",
        "vj_contagion/zombies/scottlambright/89 scottlambright_zombie_die_veryshort_05.wav",
        "vj_contagion/zombies/scottlambright/90 scottlambright_zombie_die_veryshort_06.wav",
        "vj_contagion/zombies/scottlambright/91 scottlambright_zombie_die_veryshort_07.wav",
        "vj_contagion/zombies/scottlambright/92 scottlambright_zombie_die_veryshort_08.wav",
        "vj_contagion/zombies/scottlambright/93 scottlambright_zombie_die_veryshort_09.wav",
        "vj_contagion/zombies/scottlambright/94 scottlambright_zombie_die_veryshort_10.wav",
        "vj_contagion/zombies/scottlambright/95 scottlambright_zombie_die_veryshort_11.wav"
}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_Michael()
        self.SoundTbl_Idle = {
        "vj_contagion/zombies/michaelmitchell/731 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/732 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/733 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/734 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/735 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/736 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/737 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/738 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/739 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/740 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/741 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/742 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/743 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/744 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/745 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/746 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/747 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/748 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/749 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/750 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/751 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/752 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/753 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/754 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/755 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/756 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/757 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/758 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/759 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/760 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/761 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/762 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/763 MichaelMitchell_zombie_idle.wav"
}
        self.SoundTbl_Investigate = {
        "vj_contagion/zombies/michaelmitchell/534 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/535 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/536 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/537 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/538 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/539 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/540 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/541 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/542 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/543 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/544 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/545 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/546 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/547 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/548 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/549 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/550 MichaelMitchell_zombie_alert.wav"
}
        self.SoundTbl_Alert = {
        "vj_contagion/zombies/michaelmitchell/534 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/535 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/536 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/537 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/538 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/539 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/540 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/541 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/542 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/543 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/544 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/545 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/546 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/547 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/548 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/549 MichaelMitchell_zombie_alert.wav",
        "vj_contagion/zombies/michaelmitchell/550 MichaelMitchell_zombie_alert.wav"
}
        self.SoundTbl_CallForHelp = {
        "vj_contagion/zombies/michaelmitchell/803 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/805 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/806 MichaelMitchell_zombie_roar.wav",
        "vj_contagion/zombies/michaelmitchell/807 MichaelMitchell_zombie_roar.wav",
        "vj_contagion/zombies/michaelmitchell/808 MichaelMitchell_zombie_roar.wav"
}
        self.SoundTbl_CombatIdle = {
        "vj_contagion/zombies/michaelmitchell/551 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/552 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/553 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/554 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/555 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/556 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/557 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/558 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/559 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/560 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/561 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/562 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/563 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/564 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/565 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/566 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/567 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/568 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/569 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/570 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/571 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/572 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/573 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/574 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/575 MichaelMitchell_zombie_attack.wav",
        "vj_contagion/zombies/michaelmitchell/576 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/577 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/578 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/579 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/580 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/581 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/582 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/583 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/584 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/585 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/586 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/587 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/588 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/589 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/590 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/591 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/592 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/593 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/594 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/595 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/596 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/597 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/598 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/599 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/600 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/601 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/809 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/810 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/811 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/812 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/813 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/814 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/815 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/816 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/817 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/818 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/819 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/820 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/821 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/822 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/823 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/824 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/825 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/826 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/827 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/828 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/829 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/830 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/831 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/832 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/833 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/834 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/835 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/836 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/837 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/838 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/839 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/840 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/841 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/842 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/843 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/844 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/845 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/846 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/847 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/848 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/849 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/850 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/851 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/852 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/853 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/854 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/855 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/856 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/857 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/858 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/859 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/860 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/861 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/862 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/863 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/864 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/865 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/866 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/867 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/868 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/869 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/870 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/871 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/872 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/873 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/874 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/875 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/876 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/877 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/878 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/879 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/880 MichaelMitchell_zombie_attackfast.wav"
}
        self.SoundTbl_BeforeMeleeAttack = {
        "vj_contagion/zombies/michaelmitchell/612 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/614 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/615 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/616 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/617 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/618 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/619 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/620 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/621 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/622 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/623 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/624 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/625 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/626 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/627 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/628 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/629 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/630 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/631 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/632 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/633 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/634 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/635 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/636 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/637 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/638 MichaelMitchell_zombie_attackfast.wav",
        "vj_contagion/zombies/michaelmitchell/668 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/669 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/670 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/671 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/672 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/673 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/674 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/675 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/676 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/677 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/678 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/679 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/680 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/681 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/682 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/683 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/764 MichaelMitchell_zombie_idle.wav",
        "vj_contagion/zombies/michaelmitchell/765 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/766 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/767 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/768 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/769 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/770 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/771 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/772 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/773 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/774 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/775 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/776 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/777 MichaelMitchell_zombie_fight.wav",
        "vj_contagion/zombies/michaelmitchell/778 MichaelMitchell_zombie_fight.wav"
}
        self.SoundTbl_Grapple = {
        "vj_contagion/zombies/michaelmitchell/684 MichaelMitchell_zombie_grapple.wav",
        "vj_contagion/zombies/michaelmitchell/685 MichaelMitchell_zombie_grapple.wav",
        "vj_contagion/zombies/michaelmitchell/686 MichaelMitchell_zombie_grapple.wav",
        "vj_contagion/zombies/michaelmitchell/687 MichaelMitchell_zombie_grapple.wav",
        "vj_contagion/zombies/michaelmitchell/688 MichaelMitchell_zombie_grapple.wav",
        "vj_contagion/zombies/michaelmitchell/689 MichaelMitchell_zombie_grapple.wav"
}
        self.SoundTbl_Feast = {
        "vj_contagion/zombies/michaelmitchell/650 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/651 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/652 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/653 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/654 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/655 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/656 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/657 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/658 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/659 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/660 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/661 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/662 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/663 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/664 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/665 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/666 MichaelMitchell_zombie_feasting.wav",
        "vj_contagion/zombies/michaelmitchell/667 MichaelMitchell_zombie_feasting.wav"
}
        self.SoundTbl_Jump = {
        "vj_contagion/zombies/michaelmitchell/690 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/691 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/692 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/693 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/694 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/695 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/696 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/697 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/698 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/699 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/700 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/701 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/702 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/703 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/704 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/705 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/706 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/707 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/708 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/709 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/710 MichaelMitchell_zombie_jump.wav",
        "vj_contagion/zombies/michaelmitchell/711 MichaelMitchell_zombie_jump.wav"
}
        self.SoundTbl_Pain = {
        "vj_contagion/zombies/michaelmitchell/712 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/713 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/714 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/715 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/716 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/717 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/718 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/719 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/720 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/721 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/722 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/723 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/724 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/725 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/726 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/727 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/728 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/729 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/730 MichaelMitchell_zombie_pain.wav"
}
        self.SoundTbl_Burning = {
        "vj_contagion/zombies/michaelmitchell/602 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/603 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/604 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/605 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/606 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/607 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/608 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/609 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/610 MichaelMitchell_zombie_burning.wav",
        "vj_contagion/zombies/michaelmitchell/611 MichaelMitchell_zombie_burning.wav"
}
        self.SoundTbl_Death = {
        "vj_contagion/zombies/michaelmitchell/641 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/642 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/643 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/644 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/645 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/646 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/647 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/648 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/649 MichaelMitchell_zombie_dieheadshot.wav",
        "vj_contagion/zombies/michaelmitchell/779 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/780 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/781 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/782 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/783 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/784 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/785 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/786 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/787 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/788 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/789 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/790 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/791 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/792 MichaelMitchell_zombie_die.wav",
        "vj_contagion/zombies/michaelmitchell/793 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/794 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/795 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/796 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/797 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/798 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/799 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/800 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/801 MichaelMitchell_zombie_pain.wav",
        "vj_contagion/zombies/michaelmitchell/802 MichaelMitchell_zombie_pain.wav"
}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_Jim()
        self.SoundTbl_Idle = {
        "vj_contagion/zombies/jimcurtis/2001 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2002 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2003 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2004 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2005 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2006 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2007 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2008 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2009 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2010 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2011 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2012 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2013 jimcurtis_zombie_idle.wav",
        "vj_contagion/zombies/jimcurtis/2014 jimcurtis_zombie_idle.wav"
}
        self.SoundTbl_Investigate = {
        "vj_contagion/zombies/jimcurtis/2048 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2049 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2050 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2051 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2052 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2053 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2054 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2055 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2056 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2057 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2058 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2059 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2060 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2061 jimcurtis_zombie_alert.wav"
}
        self.SoundTbl_Alert = {
        "vj_contagion/zombies/jimcurtis/2048 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2049 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2050 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2051 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2052 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2053 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2054 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2055 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2056 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2057 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2058 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2059 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2060 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2061 jimcurtis_zombie_alert.wav"
}
        self.SoundTbl_CallForHelp = {
        "vj_contagion/zombies/jimcurtis/1950 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/1951 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/1952 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/1953 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/1954 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/1955 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/1956 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/1957 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/1958 jimcurtis_zombie_alert.wav"
}
        self.SoundTbl_CombatIdle = {
        "vj_contagion/zombies/jimcurtis/1959 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1960 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1961 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1962 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1963 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1964 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1965 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1966 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1967 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1968 jimcurtis_zombie_attack.wav",
        "vj_contagion/zombies/jimcurtis/1969 jimcurtis_zombie_attack.wav"
}
        self.SoundTbl_BeforeMeleeAttack = {
        "vj_contagion/zombies/jimcurtis/2015 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2016 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2017 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2018 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2019 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2020 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2021 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2022 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2023 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2024 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2025 jimcurtis_zombie_alert.wav"
}
        self.SoundTbl_Grapple = {
        "vj_contagion/zombies/jimcurtis/1997 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/1998 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/1999 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2000 jimcurtis_zombie_grapple.wav"
}
        self.SoundTbl_Feast = {
        "vj_contagion/zombies/jimcurtis/2038 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2039 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2040 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2041 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2042 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2043 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2044 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2045 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2046 jimcurtis_zombie_grapple.wav",
        "vj_contagion/zombies/jimcurtis/2047 jimcurtis_zombie_grapple.wav"
}
        self.SoundTbl_Jump = {
        "vj_contagion/zombies/jimcurtis/2015 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2016 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2017 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2018 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2019 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2020 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2021 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2022 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2023 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2024 jimcurtis_zombie_alert.wav",
        "vj_contagion/zombies/jimcurtis/2025 jimcurtis_zombie_alert.wav"
}
        self.SoundTbl_Pain = {
        "vj_contagion/zombies/jimcurtis/2026 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2027 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2028 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2029 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2030 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2031 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2032 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2033 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2034 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2035 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2036 jimcurtis_zombie_pain.wav",
        "vj_contagion/zombies/jimcurtis/2037 jimcurtis_zombie_pain.wav"
}
        self.SoundTbl_Burning = {
        "vj_contagion/zombies/jimcurtis/1991 jimcurtis_zombie_burning.wav",
        "vj_contagion/zombies/jimcurtis/1992 jimcurtis_zombie_burning.wav",
        "vj_contagion/zombies/jimcurtis/1993 jimcurtis_zombie_burning.wav",
        "vj_contagion/zombies/jimcurtis/1994 jimcurtis_zombie_burning.wav",
        "vj_contagion/zombies/jimcurtis/1995 jimcurtis_zombie_burning.wav",
        "vj_contagion/zombies/jimcurtis/1996 jimcurtis_zombie_burning.wav"
}
        self.SoundTbl_Death = {
        "vj_contagion/zombies/jimcurtis/1970 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1971 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1972 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1973 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1974 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1975 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1976 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1977 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1978 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1979 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1980 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1981 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1982 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1983 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1984 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1985 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1986 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1987 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1988 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1989 jimcurtis_zombie_die.wav",
        "vj_contagion/zombies/jimcurtis/1990 jimcurtis_zombie_die.wav"
}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_Andy()
        self.SoundTbl_Idle = {
        "vj_contagion/zombies/andyfield/1434 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1435 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1436 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1437 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1438 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1439 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1440 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1441 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1442 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1443 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1444 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1445 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1446 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1447 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1448 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1449 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1450 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1451 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1452 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1453 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1454 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1455 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1456 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1457 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1458 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1459 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1460 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1461 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1462 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1463 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1464 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1465 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1466 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1467 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1468 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1469 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1470 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1471 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1472 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1473 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1474 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1475 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1476 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1477 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1478 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1479 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1480 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1481 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1482 andyfield_zombie_idle.wav",
        "vj_contagion/zombies/andyfield/1483 andyfield_zombie_idle.wav"
}
        self.SoundTbl_Investigate = {
        "vj_contagion/zombies/andyfield/1579 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1580 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1581 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1582 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1583 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1584 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1585 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1586 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1587 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1588 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1589 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1590 andyfield_zombie_alert.wav"
}
        self.SoundTbl_Alert = {
        "vj_contagion/zombies/andyfield/1579 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1580 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1581 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1582 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1583 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1584 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1585 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1586 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1587 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1588 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1589 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1590 andyfield_zombie_alert.wav"
}
        self.SoundTbl_CallForHelp = {
        "vj_contagion/zombies/andyfield/1549 andyfield_zombie_roar.wav",
        "vj_contagion/zombies/andyfield/1550 andyfield_zombie_roar.wav",
        "vj_contagion/zombies/andyfield/1551 andyfield_zombie_roar.wav",
        "vj_contagion/zombies/andyfield/1552 andyfield_zombie_roar.wav",
        "vj_contagion/zombies/andyfield/1553 andyfield_zombie_roar.wav",
        "vj_contagion/zombies/andyfield/1554 andyfield_zombie_roar.wav",
        "vj_contagion/zombies/andyfield/1555 andyfield_zombie_roar.wav",
        "vj_contagion/zombies/andyfield/1556 andyfield_zombie_roar.wav",
        "vj_contagion/zombies/andyfield/1557 andyfield_zombie_roar.wav"
}
        self.SoundTbl_CombatIdle = {
        "vj_contagion/zombies/andyfield/1245 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1246 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1247 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1248 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1250 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1251 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1252 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1253 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1254 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1255 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1256 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1257 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1258 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1259 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1260 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1261 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1262 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1263 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1264 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1265 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1266 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1267 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1268 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1269 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1270 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1271 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1272 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1273 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1274 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1275 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1276 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1277 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1278 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1279 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1280 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1281 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1282 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1283 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1284 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1285 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1286 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1287 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1288 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1289 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1290 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1291 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1292 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1293 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1294 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1294 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1295 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1296 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1297 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1298 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1299 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1300 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1301 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1302 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1303 lindsaysheppard_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1304 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1305 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1306 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1306 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1307 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1308 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1309 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1310 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1311 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1312 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1313 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1314 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1315 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1316 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1317 andyfield_zombie_attack.wav",
        "vj_contagion/zombies/andyfield/1318 andyfield_zombie_attack.wav"
}
        self.SoundTbl_BeforeMeleeAttack = {
        "vj_contagion/zombies/andyfield/1591 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1592 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1593 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1594 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1595 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1596 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1597 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1598 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1599 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1600 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1601 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1602 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1603 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1604 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1605 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1606 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1607 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1608 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1609 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1610 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1611 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1612 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1613 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1614 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1615 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1616 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1617 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1618 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1619 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1620 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1621 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1622 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1623 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1624 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1625 andyfield_zombie_fight.wav",
        "vj_contagion/zombies/andyfield/1626 andyfield_zombie_fight.wav"
}
        self.SoundTbl_Grapple = {
        "vj_contagion/zombies/andyfield/1394 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1395 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1396 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1397 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1398 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1399 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1400 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1401 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1402 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1403 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1404 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1405 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1406 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1407 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1408 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1409 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1410 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1411 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1412 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1413 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1414 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1415 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1416 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1417 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1418 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1419 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1420 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1421 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1422 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1423 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1424 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1425 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1426 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1427 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1428 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1429 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1430 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1431 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1432 andyfield_zombie_grapple.wav",
        "vj_contagion/zombies/andyfield/1433 andyfield_zombie_grapple.wav"
}
        self.SoundTbl_Feast = {
        "vj_contagion/zombies/andyfield/1558 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1559 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1560 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1561 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1562 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1563 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1564 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1565 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1566 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1567 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1568 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1569 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1570 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1571 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1572 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1573 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1574 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1575 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1576 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1577 andyfield_zombie_feasting.wav",
        "vj_contagion/zombies/andyfield/1578 andyfield_zombie_feasting.wav"
}
        self.SoundTbl_Jump = {
        "vj_contagion/zombies/andyfield/1484 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1485 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1486 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1487 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1488 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1489 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1490 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1491 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1492 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1493 andyfield_zombie_jump.wav",
        "vj_contagion/zombies/andyfield/1494 andyfield_zombie_jump.wav"
}
        self.SoundTbl_Pain = {
        "vj_contagion/zombies/andyfield/1495 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1496 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1497 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1498 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1499 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1500 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1501 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1502 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1503 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1504 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1505 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1506 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1507 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1508 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1509 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1510 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1511 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1512 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1513 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1514 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1515 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1516 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1517 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1518 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1519 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1520 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1521 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1522 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1523 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1524 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1525 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1526 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1527 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1528 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1528 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1529 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1530 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1531 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1532 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1533 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1534 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1535 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1536 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1537 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1538 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1539 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1540 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1541 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1542 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1543 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1544 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1545 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1546 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1547 andyfield_zombie_pain.wav",
        "vj_contagion/zombies/andyfield/1548 andyfield_zombie_pain.wav"
}
        self.SoundTbl_Burning = {
        "vj_contagion/zombies/andyfield/1371 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1372 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1373 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1374 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1375 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1376 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1377 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1378 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1379 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1380 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1381 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1382 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1383 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1384 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1385 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1386 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1387 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1388 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1389 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1390 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1391 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1392 andyfield_zombie_burning.wav",
        "vj_contagion/zombies/andyfield/1393 andyfield_zombie_burning.wav"
}
        self.SoundTbl_Death = {
        "vj_contagion/zombies/andyfield/1319 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1320 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1321 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1322 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1323 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1324 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1325 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1326 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1327 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1328 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1329 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1330 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1331 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1332 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1333 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1334 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1335 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1336 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1337 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1338 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1339 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1340 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1341 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1342 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1343 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1344 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1345 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1346 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1347 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1348 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1349 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1350 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1351 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1352 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1353 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1354 andyfield_zombie_alert.wav",
        "vj_contagion/zombies/andyfield/1355 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1356 andyfield_zombie_die.wav",
        "vj_contagion/zombies/andyfield/1357 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1358 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1359 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1360 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1361 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1362 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1363 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1364 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1365 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1366 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1367 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1368 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1369 andyfield_zombie_dieheadshot.wav",
        "vj_contagion/zombies/andyfield/1370 andyfield_zombie_dieheadshot.wav"
}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_George()
        self.SoundTbl_Idle = {
        "vj_contagion/zombies/georgeledoux/954 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/955 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/956 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/957 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/958 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/959 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/960 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/961 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/962 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/963 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/964 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/965 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/966 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/967 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/968 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/969 georgeledoux_zombie_idle.wav",
        "vj_contagion/zombies/georgeledoux/970 georgeledoux_zombie_idle.wav"
}
        self.SoundTbl_Investigate = {
        "vj_contagion/zombies/georgeledoux/882 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/883 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/884 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/885 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/886 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/887 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/888 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/889 georgeledoux_zombie_alert.wav"
}
        self.SoundTbl_Alert = {
        "vj_contagion/zombies/georgeledoux/882 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/883 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/884 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/885 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/886 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/887 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/888 georgeledoux_zombie_alert.wav",
        "vj_contagion/zombies/georgeledoux/889 georgeledoux_zombie_alert.wav"
}
        self.SoundTbl_CallForHelp = {
        "vj_contagion/zombies/georgeledoux/997 georgeledoux_zombie_roar.wav",
        "vj_contagion/zombies/georgeledoux/998 georgeledoux_zombie_roar.wav",
        "vj_contagion/zombies/georgeledoux/999 georgeledoux_zombie_roar.wav",
        "vj_contagion/zombies/georgeledoux/1000 georgeledoux_zombie_roar.wav",
        "vj_contagion/zombies/georgeledoux/1001 georgeledoux_zombie_roar.wav"
}
        self.SoundTbl_CombatIdle = {
        "vj_contagion/zombies/georgeledoux/890 georgeledoux_zombie_attack.wav",
        "vj_contagion/zombies/georgeledoux/891 georgeledoux_zombie_attack.wav",
        "vj_contagion/zombies/georgeledoux/892 georgeledoux_zombie_attack.wav",
        "vj_contagion/zombies/georgeledoux/893 georgeledoux_zombie_attack.wav",
        "vj_contagion/zombies/georgeledoux/894 georgeledoux_zombie_attack.wav",
        "vj_contagion/zombies/georgeledoux/895 georgeledoux_zombie_attack.wav",
        "vj_contagion/zombies/georgeledoux/896 georgeledoux_zombie_attack.wav",
        "vj_contagion/zombies/georgeledoux/897 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/898 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/899 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/900 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/901 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/902 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/903 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/904 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/905 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/906 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/907 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/908 georgeledoux_zombie_attackfast.wav"
}
        self.SoundTbl_BeforeMeleeAttack = {
        "vj_contagion/zombies/georgeledoux/1018 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1019 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1020 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1021 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1022 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1023 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1024 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1025 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1026 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1027 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1028 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1029 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1030 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1031 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1032 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1033 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1034 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1035 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1036 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1037 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1038 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1039 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1040 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1041 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1042 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1043 georgeledoux_zombie_attackfast.wav",
        "vj_contagion/zombies/georgeledoux/1044 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1045 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1046 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1047 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1048 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1049 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1050 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1051 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1052 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1053 georgeledoux_zombie_fight.wav",
        "vj_contagion/zombies/georgeledoux/1054 georgeledoux_zombie_fight.wav"
 }
        self.SoundTbl_Grapple = {
        "vj_contagion/zombies/georgeledoux/936 georgeledoux_zombie_grapple.wav",
        "vj_contagion/zombies/georgeledoux/937 georgeledoux_zombie_grapple.wav",
        "vj_contagion/zombies/georgeledoux/938 georgeledoux_zombie_grapple.wav",
        "vj_contagion/zombies/georgeledoux/939 georgeledoux_zombie_grapple.wav",
        "vj_contagion/zombies/georgeledoux/940 georgeledoux_zombie_grapple.wav",
        "vj_contagion/zombies/georgeledoux/941 georgeledoux_zombie_grapple.wav",
        "vj_contagion/zombies/georgeledoux/942 georgeledoux_zombie_grapple.wav",
        "vj_contagion/zombies/georgeledoux/943 georgeledoux_zombie_grapple.wav"
}
        self.SoundTbl_Feast = {
        "vj_contagion/zombies/georgeledoux/1002 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1003 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1004 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1005 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1006 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1007 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1008 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1009 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1010 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1011 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1012 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1013 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1014 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1015 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1016 georgeledoux_zombie_feasting.wav",
        "vj_contagion/zombies/georgeledoux/1017 georgeledoux_zombie_feasting.wav"
}
        self.SoundTbl_Jump = {
        "vj_contagion/zombies/georgeledoux/971 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/972 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/973 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/974 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/975 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/976 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/977 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/978 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/979 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/980 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/981 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/982 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/983 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/984 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/985 georgeledoux_zombie_jump.wav",
        "vj_contagion/zombies/georgeledoux/986 georgeledoux_zombie_jump.wav"
}
        self.SoundTbl_Pain = {
        "vj_contagion/zombies/georgeledoux/987 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/988 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/989 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/990 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/991 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/992 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/993 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/994 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/995 georgeledoux_zombie_pain.wav",
        "vj_contagion/zombies/georgeledoux/996 georgeledoux_zombie_pain.wav"
 }
        self.SoundTbl_Burning = {
        "vj_contagion/zombies/georgeledoux/928 georgeledoux_zombie_burning.wav",
        "vj_contagion/zombies/georgeledoux/929 georgeledoux_zombie_burning.wav",
        "vj_contagion/zombies/georgeledoux/930 georgeledoux_zombie_burning.wav",
        "vj_contagion/zombies/georgeledoux/931 georgeledoux_zombie_burning.wav",
        "vj_contagion/zombies/georgeledoux/932 georgeledoux_zombie_burning.wav",
        "vj_contagion/zombies/georgeledoux/933 georgeledoux_zombie_burning.wav",
        "vj_contagion/zombies/georgeledoux/934 georgeledoux_zombie_burning.wav",
        "vj_contagion/zombies/georgeledoux/935 georgeledoux_zombie_burning.wav"
 }
        self.SoundTbl_Death = {
        "vj_contagion/zombies/georgeledoux/909 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/910 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/911 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/912 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/913 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/914 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/915 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/916 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/917 georgeledoux_zombie_die.wav",
        "vj_contagion/zombies/georgeledoux/918 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/919 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/920 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/921 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/922 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/923 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/924 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/925 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/926 georgeledoux_zombie_dieheadshot.wav",
        "vj_contagion/zombies/georgeledoux/927 georgeledoux_zombie_dieheadshot.wav"
 }
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_Lindsay()
    self.SoundTbl_Idle = {
    "vj_contagion/zombies/lindsaysheppard/1758 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1759 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1760 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1761 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1762 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1763 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1764 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1765 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1766 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1767 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1768 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1769 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1770 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1771 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1772 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1773 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1774 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1775 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1776 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1777 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1778 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1779 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1780 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1781 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1782 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1783 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1784 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1785 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1786 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1787 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1788 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1789 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1790 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1791 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1792 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1793 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1794 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1795 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1796 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1797 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1798 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1799 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1800 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1801 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1802 lindsaysheppard_zombie_idle.wav",
    "vj_contagion/zombies/lindsaysheppard/1803 lindsaysheppard_zombie_idle.wav"
}
    self.SoundTbl_Investigate = {
    "vj_contagion/zombies/lindsaysheppard/1627 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1628 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1629 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1630 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1631 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1632 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1633 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1634 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1635 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1636 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1637 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1638 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1639 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1640 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1641 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1642 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1643 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1644 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1645 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1646 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1647 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1648 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1649 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1650 lindsaysheppard_zombie_alert.wav"
}
    self.SoundTbl_Alert = {
    "vj_contagion/zombies/lindsaysheppard/1627 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1628 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1629 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1630 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1631 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1632 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1633 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1634 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1635 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1636 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1637 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1638 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1639 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1640 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1641 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1642 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1643 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1644 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1645 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1646 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1647 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1648 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1649 lindsaysheppard_zombie_alert.wav",
    "vj_contagion/zombies/lindsaysheppard/1650 lindsaysheppard_zombie_alert.wav"
}
    self.SoundTbl_CallForHelp = {
    "vj_contagion/zombies/lindsaysheppard/1849 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1850 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1851 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1852 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1853 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1854 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1936 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1937 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1938 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1939 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1940 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1941 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1942 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1943 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1944 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1946 lindsaysheppard_zombie_roar.wav",
    "vj_contagion/zombies/lindsaysheppard/1946 lindsaysheppard_zombie_roar.wav"
}
    self.SoundTbl_CombatIdle = {
    "vj_contagion/zombies/lindsaysheppard/1651 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1652 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1653 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1654 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1655 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1656 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1657 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1658 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1659 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1660 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1661 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1662 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1663 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1664 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1665 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1666 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1667 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1668 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1669 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1670 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1671 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1672 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1673 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1674 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1675 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1676 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1677 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1678 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1679 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1680 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1681 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1682 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1683 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1684 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1685 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1686 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1687 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1688 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1689 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1690 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1691 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1692 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1693 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1694 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1695 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1696 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1697 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1698 lindsaysheppard_zombie_attack.wav"
}
    self.SoundTbl_BeforeMeleeAttack = {
    "vj_contagion/zombies/lindsaysheppard/1875 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1876 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1877 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1878 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1879 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1880 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1881 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1882 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1883 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1884 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1885 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1886 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1887 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1888 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1889 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1890 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1891 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1892 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1893 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1894 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1895 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1896 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1897 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1898 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1899 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1900 lindsaysheppard_zombie_fight.wav",
    "vj_contagion/zombies/lindsaysheppard/1901 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1901 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1902 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1903 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1904 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1905 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1906 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1907 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1908 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1909 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1910 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1911 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1912 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1913 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1914 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1915 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1916 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1917 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1918 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1919 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1920 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1921 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1922 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1923 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1924 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1925 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1926 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1927 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1928 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1929 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1930 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1931 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1932 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1933 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1934 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1935 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1947 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1948 lindsaysheppard_zombie_attack.wav",
    "vj_contagion/zombies/lindsaysheppard/1949 lindsaysheppard_zombie_attack.wav"
}
    self.SoundTbl_Grapple = {
    "vj_contagion/zombies/lindsaysheppard/1745 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1746 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1747 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1748 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1749 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1750 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1751 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1752 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1753 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1754 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1755 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1756 lindsaysheppard_zombie_grapple.wav",
    "vj_contagion/zombies/lindsaysheppard/1757 lindsaysheppard_zombie_grapple.wav"
}
    self.SoundTbl_Feast = {
    //"vj_contagion/zombies/lindsaysheppard/1855 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1856 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1857 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1858 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1859 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1860 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1861 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1862 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1863 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1864 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1865 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1866 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1867 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1868 lindsaysheppard_zombie_feasting.wav",
    "vj_contagion/zombies/lindsaysheppard/1869 lindsaysheppard_zombie_feasting.wav"
}
    self.SoundTbl_Jump = {
    "vj_contagion/zombies/lindsaysheppard/1804 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1805 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1806 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1807 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1808 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1809 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1810 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1811 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1812 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1813 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1814 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1815 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1816 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1817 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1818 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1819 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1820 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1821 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1822 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1822 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1823 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1824 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1825 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1826 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1827 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1828 lindsaysheppard_zombie_jump.wav",
    "vj_contagion/zombies/lindsaysheppard/1829 lindsaysheppard_zombie_jump.wav"
}
    self.SoundTbl_Pain = {
    "vj_contagion/zombies/lindsaysheppard/1830 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1831 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1832 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1833 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1834 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1835 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1836 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1837 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1838 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1839 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1840 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1841 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1842 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1843 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1844 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1845 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1846 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1847 lindsaysheppard_zombie_pain.wav",
    "vj_contagion/zombies/lindsaysheppard/1848 lindsaysheppard_zombie_pain.wav"
}
    self.SoundTbl_Burning = {
    "vj_contagion/zombies/lindsaysheppard/1734 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1735 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1736 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1737 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1738 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1739 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1740 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1741 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1742 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1743 lindsaysheppard_zombie_burning.wav",
    "vj_contagion/zombies/lindsaysheppard/1744 lindsaysheppard_zombie_burning.wav"
}
    self.SoundTbl_Death = {
    "vj_contagion/zombies/lindsaysheppard/1699 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1700 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1701 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1702 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1703 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1704 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1705 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1706 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1707 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1708 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1709 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1710 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1711 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1712 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1713 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1714 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1715 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1716 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1717 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1718 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1719 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1720 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1721 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1722 lindsaysheppard_zombie_die.wav",
    "vj_contagion/zombies/lindsaysheppard/1723 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1724 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1725 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1726 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1727 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1728 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1729 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1730 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1731 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1732 lindsaysheppard_zombie_dieheadshot.wav",
    "vj_contagion/zombies/lindsaysheppard/1733 lindsaysheppard_zombie_dieheadshot.wav"
}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_Amisar()
    self.SoundTbl_Idle = {
    "vj_contagion/zombies/amisarfati/1185 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1186 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1187 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1188 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1189 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1190 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1191 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1192 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1193 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1194 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1195 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1196 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1197 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1198 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1199 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1200 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1201 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1202 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1203 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1204 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1205 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1206 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1207 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1208 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1209 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1210 amisarfati_zombie_idle.wav",
    "vj_contagion/zombies/amisarfati/1211 amisarfati_zombie_idle.wav"
}
    self.SoundTbl_Investigate = {
    "vj_contagion/zombies/amisarfati/1055 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1056 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1057 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1058 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1059 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1060 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1061 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1062 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1063 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1064 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1065 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1066 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1067 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1068 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1069 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1070 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1071 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1072 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1073 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1074 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1075 amisarfati_zombie_alert.wav",
}
    self.SoundTbl_Alert = {
    "vj_contagion/zombies/amisarfati/1055 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1056 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1057 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1058 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1059 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1060 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1061 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1062 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1063 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1064 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1065 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1066 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1067 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1068 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1069 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1070 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1071 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1072 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1073 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1074 amisarfati_zombie_alert.wav",
    "vj_contagion/zombies/amisarfati/1075 amisarfati_zombie_alert.wav"
}
    self.SoundTbl_CallForHelp = {
    "vj_contagion/zombies/amisarfati/1241 amisarfati_zombie_roar.wav",
    "vj_contagion/zombies/amisarfati/1242 amisarfati_zombie_roar.wav",
    "vj_contagion/zombies/amisarfati/1243 amisarfati_zombie_roar.wav",
    "vj_contagion/zombies/amisarfati/1244 amisarfati_zombie_roar.wav"
}
    self.SoundTbl_CombatIdle = {
    "vj_contagion/zombies/amisarfati/1076 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1077 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1078 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1079 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1080 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1081 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1082 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1083 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1084 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1085 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1086 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1087 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1088 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1089 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1090 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1091 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1092 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1093 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1094 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1095 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1096 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1097 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1098 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1099 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1100 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1101 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1102 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1103 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1104 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1105 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1106 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1107 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1108 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1109 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1110 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1111 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1112 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1113 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1114 amisarfati_zombie_attack.wav",
    "vj_contagion/zombies/amisarfati/1115 amisarfati_zombie_attack.wav"
}
    self.SoundTbl_BeforeMeleeAttack = {
    "vj_contagion/zombies/amisarfati/1164 amisarfati_zombie_fight.wav",
    "vj_contagion/zombies/amisarfati/1165 amisarfati_zombie_fight.wav",
    "vj_contagion/zombies/amisarfati/1166 amisarfati_zombie_fight.wav",
    "vj_contagion/zombies/amisarfati/1167 amisarfati_zombie_fight.wav",
    "vj_contagion/zombies/amisarfati/1168 amisarfati_zombie_fight.wav",
    "vj_contagion/zombies/amisarfati/1169 amisarfati_zombie_fight.wav",
    "vj_contagion/zombies/amisarfati/1170 amisarfati_zombie_fight.wav",
    "vj_contagion/zombies/amisarfati/1171 amisarfati_zombie_fight.wav",
    "vj_contagion/zombies/amisarfati/1172 amisarfati_zombie_fight.wav"
}
    self.SoundTbl_Grapple = {
    "vj_contagion/zombies/amisarfati/1173 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1174 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1175 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1176 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1177 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1178 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1179 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1180 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1181 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1182 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1183 amisarfati_zombie_grapple.wav",
    "vj_contagion/zombies/amisarfati/1184 amisarfati_zombie_grapple.wav"
}
    self.SoundTbl_Feast = {
    "vj_contagion/zombies/amisarfati/1156 amisarfati_zombie_feasting.wav",
    "vj_contagion/zombies/amisarfati/1157 amisarfati_zombie_feasting.wav",
    "vj_contagion/zombies/amisarfati/1158 amisarfati_zombie_feasting.wav",
    "vj_contagion/zombies/amisarfati/1159 amisarfati_zombie_feasting.wav",
    "vj_contagion/zombies/amisarfati/1160 amisarfati_zombie_feasting.wav",
    "vj_contagion/zombies/amisarfati/1161 amisarfati_zombie_feasting.wav",
    "vj_contagion/zombies/amisarfati/1162 amisarfati_zombie_feasting.wav",
    "vj_contagion/zombies/amisarfati/1163 amisarfati_zombie_feasting.wav"
}
    self.SoundTbl_Jump = {
    "vj_contagion/zombies/amisarfati/1212 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1213 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1214 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1215 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1216 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1217 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1218 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1219 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1220 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1221 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1222 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1223 amisarfati_zombie_jump.wav",
    "vj_contagion/zombies/amisarfati/1224 amisarfati_zombie_jump.wav"

    /*"vj_contagion/zombies/amisarfati/1124 amisarfati_zombie_climbing.wav",
    "vj_contagion/zombies/amisarfati/1125 amisarfati_zombie_climbing.wav",
    "vj_contagion/zombies/amisarfati/1126 amisarfati_zombie_climbing.wav",
    "vj_contagion/zombies/amisarfati/1127 amisarfati_zombie_climbing.wav",*/
}
    self.SoundTbl_Pain = {
    "vj_contagion/zombies/amisarfati/1225 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1226 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1227 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1228 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1229 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1230 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1231 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1232 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1233 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1234 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1235 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1236 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1237 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1238 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1239 amisarfati_zombie_pain.wav",
    "vj_contagion/zombies/amisarfati/1240 amisarfati_zombie_pain.wav"
}
    self.SoundTbl_Burning = {
    "vj_contagion/zombies/amisarfati/1116 amisarfati_zombie_burning.wav",
    "vj_contagion/zombies/amisarfati/1117 amisarfati_zombie_burning.wav",
    "vj_contagion/zombies/amisarfati/1118 amisarfati_zombie_burning.wav",
    "vj_contagion/zombies/amisarfati/1119 amisarfati_zombie_burning.wav",
    "vj_contagion/zombies/amisarfati/1120 amisarfati_zombie_burning.wav",
    "vj_contagion/zombies/amisarfati/1121 amisarfati_zombie_burning.wav",
    "vj_contagion/zombies/amisarfati/1122 amisarfati_zombie_burning.wav",
    "vj_contagion/zombies/amisarfati/1123 amisarfati_zombie_burning.wav"
}
    self.SoundTbl_Death = {
    "vj_contagion/zombies/amisarfati/1128 amisarfati_zombie_dieheadshot.wav",
    "vj_contagion/zombies/amisarfati/1129 amisarfati_zombie_dieheadshot.wav",
    "vj_contagion/zombies/amisarfati/1130 amisarfati_zombie_dieheadshot.wav",
    "vj_contagion/zombies/amisarfati/1131 amisarfati_zombie_dieheadshot.wav",
    "vj_contagion/zombies/amisarfati/1132 amisarfati_zombie_dieheadshot.wav",
    "vj_contagion/zombies/amisarfati/1133 amisarfati_zombie_dieheadshot.wav",
    "vj_contagion/zombies/amisarfati/1134 amisarfati_zombie_dieheadshot.wav",
    "vj_contagion/zombies/amisarfati/1135 amisarfati_zombie_dieheadshot.wav",
    "vj_contagion/zombies/amisarfati/1136 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1137 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1138 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1139 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1140 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1141 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1142 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1143 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1144 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1145 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1146 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1147 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1148 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1149 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1150 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1151 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1152 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1153 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1154 amisarfati_zombie_die.wav",
    "vj_contagion/zombies/amisarfati/1155 amisarfati_zombie_die.wav"
}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice_Christina()
    self.SoundTbl_Idle = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_09.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_10.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_11.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_idle_12.wav"
}
    self.SoundTbl_Investigate = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_09.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_10.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_11.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_12.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_13.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_14.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_15.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_16.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_17.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_18.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_19.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_20.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_21.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_22.wav"
}
    self.SoundTbl_Alert = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_09.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_10.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_11.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_12.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_13.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_14.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_15.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_16.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_17.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_18.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_19.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_20.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_21.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_alert_22.wav"
}
    self.SoundTbl_CallForHelp = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_roar_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_roar_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_roar_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_roar_04.wav"
}
    self.SoundTbl_CombatIdle = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_09.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_10.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_11.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_12.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_13.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_14.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_15.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_16.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_17.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_18.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_19.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_20.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_21.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_22.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_23.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_24.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_25.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_26.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_27.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_28.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_29.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_30.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_31.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_32.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_33.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_34.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_attack_35.wav"
}
    self.SoundTbl_BeforeMeleeAttack = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_09.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_10.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_11.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_12.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_13.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_14.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_15.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_16.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_17.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_18.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_19.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_20.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_21.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_22.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_23.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_24.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_25.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_26.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_fight_27.wav"
}
    self.SoundTbl_Grapple = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_09.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_10.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_11.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_12.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_13.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_14.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_15.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_grapple_16.wav"
}
    self.SoundTbl_Feast = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_09.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_10.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_11.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_12.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_13.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_14.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_15.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_16.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_17.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_18.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_19.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_20.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_21.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_22.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_23.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_24.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_feasting_25.wav"
}
    self.SoundTbl_Jump = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_jump_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_jump_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_jump_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_jump_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_jump_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_jump_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_jump_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_jump_08.wav"
}
    self.SoundTbl_Pain = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_pain_09.wav"
}
    self.SoundTbl_Burning = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_burning_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_burning_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_burning_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_burning_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_burning_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_burning_06.wav"
}
    self.SoundTbl_Death = {
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_08.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_09.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_10.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_die_11.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_dieheadshot_01.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_dieheadshot_02.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_dieheadshot_03.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_dieheadshot_04.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_dieheadshot_05.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_dieheadshot_06.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_dieheadshot_07.wav",
    "vj_contagion/zombies/christinasmith/christinasmith_zombie_dieheadshot_08.wav"
}
end
/*-----------------------------------------------
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/