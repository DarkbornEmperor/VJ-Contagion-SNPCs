AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 500 // 1000
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
ENT.MeleeAttackDamage = 30
ENT.TimeUntilMeleeAttackDamage = false
ENT.HasExtraMeleeAttackSounds = true
ENT.MeleeAttackPlayerSpeed = true
ENT.MeleeAttackPlayerSpeedTime = 0.5
ENT.DisableFootStepSoundTimer = true
ENT.HasMeleeAttackPlayerSpeedSounds = false
ENT.CanFlinch = true
//ENT.FlinchChance = 1
ENT.FlinchCooldown = 1
ENT.AnimTbl_Flinch = {"vjges_flinch_01","vjges_flinch_02"}
ENT.HasDeathAnimation = true
ENT.DeathAnimationChance = 1
ENT.AnimTbl_Death = ACT_DIESIMPLE
    -- ====== Controller Data ====== --
ENT.ControllerParams = {
    CameraMode = 2, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(40, 25, -50), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "ValveBiped.Bip01_Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
}
    -- ====== Sound File Paths ====== --
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
ENT.IdleSoundPitch = VJ.SET(120,120)
ENT.CombatIdleSoundPitch = VJ.SET(120,120)
ENT.InvestigateSoundPitch = VJ.SET(120,120)
ENT.AlertSoundPitch = VJ.SET(120,120)
ENT.CallForHelpSoundPitch = VJ.SET(120,120)
ENT.BeforeMeleeAttackSoundPitch = VJ.SET(120,120)
ENT.PainSoundPitch = VJ.SET(120,120)
ENT.DeathSoundPitch = VJ.SET(120,120)
ENT.GeneralSoundPitch1 = 120
-- Custom
ENT.Zombie_Climbing = false
ENT.Zombie_Crouching = false
ENT.Zombie_NextClimb = 0
ENT.Zombie_AllowClimbing = false
ENT.Zombie_NextJumpT = 0
ENT.Zombie_NextCommandT = 0
ENT.Zombie_NextRoarT = 0
ENT.Zombie_NextStumbleT = 0
ENT.Zombie_ControllerAnim = 0
ENT.Zombie_AttackingDoor = false
ENT.Zombie_DoorToBreak = NULL
ENT.Zombie_Gender = 1 -- 0 = Male | 1 = Female
ENT.IsContagionZombie = true

util.AddNetworkString("vj_con_zombie_hud")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key,activator,caller,data)
    if key == "step" then
        self:PlayFootstepSound()
        self:OnFootstepSound()
    elseif key == "melee" then
        self:ExecuteMeleeAttack()
    elseif key == "body_hit" then
        VJ.EmitSound(self, "vj_contagion/zombies/shared/physics_impact_short_flesh_layer01_0"..math.random(1,5)..".wav",75,100)
end
    if key == "break_door" then
        if IsValid(self.Zombie_DoorToBreak) then
        self:PlaySoundSystem("BeforeMeleeAttack", self.SoundTbl_BeforeMeleeAttack)
        VJ.EmitSound(self,{"vj_contagion/zombies/shared/SFX_ZombiePoundDoor_Wood.wav","vj_contagion/zombies/shared/SFX_ZombiePoundDoor_Wood1.wav","vj_contagion/zombies/shared/SFX_ZombiePoundDoor_Wood2.wav","vj_contagion/zombies/shared/SFX_ZombiePoundDoor_Wood3.wav"},75,100)
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
    if self:GetClass() == "npc_vj_con_zscreamer" then
        self.Model = {
        "models/vj_contagion/zombies/screamer.mdl",
        "models/vj_contagion/zombies/screamer_bride.mdl"
}
end
    if GetConVar("VJ_CON_BreakDoors"):GetInt() == 1 then self.CanOpenDoors = false end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_Init()
    self:SetSkin(math.random(0,2))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
    self:Zombie_Init()
    self:ZombieVoices()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoices()
    self:ZombieVoice_Amisar()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSightDirection()
    local att = self:LookupAttachment("eyes") -- Not all models have it, must check for validity
    return att != 0 && self:GetAttachment(att).Ang:Forward() or self:GetForward()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangeActivity(newAct)
 if newAct == ACT_JUMP && !self.VJ_IsBeingControlled then
    self:PlaySoundSystem("Alert",self.SoundTbl_Jump)
end
    return self.BaseClass.OnChangeActivity(self,newAct)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
 if self.VJ_IsBeingControlled or self.Zombie_Crouching then return end
    if math.random(1,3) == 1 && !self:IsBusy() && ent:Visible(self) then
        self:PlayAnim("vjseq_wander_acquire",true,false,true)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCallForHelp(ally)
  if self.VJ_IsBeingControlled or self.Zombie_Crouching then return end
     if math.random(1,3) == 1 && !self:IsBusy() then
        VJ.EmitSound(self,{"vj_contagion/zombies/screamer/Banshee Scream 004.wav","vj_contagion/zombies/screamer/Banshee Scream 007.wav","vj_contagion/zombies/screamer/Banshee Scream 008.wav"})
        self:PlayAnim("vjseq_wander_acquire",true,math.Rand(1.5,3),true)
        if math.random(1,3) == 1 && !ally:IsBusy() then
            ally:PlayAnim("vjseq_zombie_grapple_roar2",true,false,true)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply,controlEnt)
    ply:ChatPrint("DUCK: Crouch")
    //ply:ChatPrint("JUMP: Jump")
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
 if self.Zombie_Crouching then
 if act == ACT_IDLE or act == ACT_TURN_LEFT or act == ACT_TURN_RIGHT then
    return ACT_IDLE_STEALTH
 elseif act == ACT_WALK or act == ACT_RUN then
    return ACT_WALK_STEALTH
end
 elseif act == ACT_IDLE && IsValid(self:GetEnemy()) && !self.Zombie_Crouching then
    return VJ.SequenceToActivity(self, "agitated_02") //ACT_IDLE_ANGRY

 elseif (act == ACT_RUN or act == ACT_WALK) && self:IsOnFire() && !self.Zombie_Crouching then
    return ACT_RUN_ON_FIRE
end
    return self.BaseClass.TranslateActivity(self, act)
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
function ENT:OnThink()
 local curSeq = self:GetSequence()
 if GetConVar("VJ_CON_BreakDoors"):GetInt() == 0 or self.Zombie_Climbing or self.Zombie_Crouching or self.Dead or self.DeathAnimationCodeRan or self.Flinching then self.Zombie_DoorToBreak = NULL return end
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
            //local dist = VJ.GetNearestDistance(self,self.Zombie_DoorToBreak)
            if IsValid(self.Zombie_DoorToBreak) && self.Zombie_AttackingDoor && (self.AttackAnimTime > CurTime() or !self.Zombie_DoorToBreak:Visible(self)) /*or (curAct == ACT_OPEN_DOOR && dist <= 100)*/ then self.Zombie_AttackingDoor = false self.Zombie_DoorToBreak = NULL return end
            if curAct != ACT_OPEN_DOOR && IsValid(self.Zombie_DoorToBreak) then
                //local ang = self:GetAngles()
                //self:SetAngles(Angle(ang.x,(self.Zombie_DoorToBreak:GetPos() -self:GetPos()):Angle().y,ang.z))
                self:SetTurnTarget(self.Zombie_DoorToBreak)
                self:PlayAnim(ACT_OPEN_DOOR,true,false,false)
                self:SetState(VJ_STATE_ONLY_ANIMATION)
    end
end
        if !IsValid(self.Zombie_DoorToBreak) && self.Zombie_AttackingDoor then
            self.Zombie_AttackingDoor = false
            self:PlayAnim(ACT_IDLE,true,0,false)
            self:SetState()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
 if CurTime() > self.Zombie_NextRoarT && !self.Zombie_AttackingDoor && !self:IsBusy("Activities") then
  for _,v in pairs(ents.FindByClass("npc_vj_con_z*")) do
    if !v.IsFollowing && VJ.HasValue(v.VJ_NPC_Class,"CLASS_ZOMBIE") && v:GetPos():Distance(self:GetPos()) <= 500 && self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_RELOAD) && !v.Zombie_AttackingDoor && !v.RiotBrute_Charging && !v:BusyWithActivity() then
        self:PlaySoundSystem("CallForHelp",self.SoundTbl_CallForHelp)
    if !self.Zombie_Crouching then
        self:PlayAnim("vjseq_wander_acquire",true,1.7,false) end
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
  if IsValid(self:GetEnemy()) && self:GetEnemy():IsPlayer() && !self:IsOnFire() && !self.Flinching && !self:IsBusy() then
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
    if self.Zombie_AllowClimbing && !self.Zombie_Crouching && !self.Dead && !self.Zombie_Climbing && CurTime() > self.Zombie_NextClimb then
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
                    anim = VJ.PICK({"vjseq_climb144_03_inplace"})
                    finalpos = tr5.HitPos
end
            elseif IsValid(tr4.Entity) then
                anim = VJ.PICK({"vjseq_climb120_00_inplace"})
                finalpos = tr4.HitPos
            elseif IsValid(tr3.Entity) then
                anim = VJ.PICK({"vjseq_climb96_04a_inplace"})
                finalpos = tr3.HitPos
            elseif IsValid(tr2.Entity) then
                anim = VJ.PICK({"vjseq_climb72_04_inplace"})
                finalpos = tr2.HitPos
            elseif IsValid(tr1.Entity) then
                anim = VJ.PICK({"vjseq_climb48_01_inplace"})
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
                self:PlayAnim(anim,true,false/*VJ.AnimDurationEx(self,anim,false,0.4)*/,true,0,{},function(vsched)
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
function ENT:OnMeleeAttack(status,enemy)
    if status == "Init" then
        self.AnimTbl_MeleeAttack = {
        "vjseq_vjges_MovingMelee_01",
        "vjseq_vjges_MovingMelee_02"
}
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo,hitgroup,status)
    if status == "PostDamage" && !self.Flinching && !self.Zombie_Crouching && self:IsMoving() && self.Zombie_NextStumbleT < CurTime() && math.random(1,14) == 1 && self:GetSequence() != self:LookupSequence("shoved_backward_03") then
        self:PlayAnim("vjseq_shoved_forward_01",true,false,false)
        self.Zombie_NextStumbleT = CurTime() + math.Rand(8,12)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo,hitgroup,status)
 if status == "Init" then
    if (dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_GENERIC)) or (dmginfo:GetDamage() > 30 or dmginfo:GetDamageForce():Length() > 10000 or bit.band(dmginfo:GetDamageType(), DMG_BUCKSHOT) != 0 or dmginfo:IsExplosionDamage()) then
        self.AnimTbl_Flinch = "vjseq_shoved_backward_03"
        self.FlinchCooldown = 5
    else
        self.AnimTbl_Flinch = {"vjges_flinch_01","vjges_flinch_02"}
        self.FlinchCooldown = 1
end
        return self:GetActivity() == ACT_JUMP or self:GetActivity() == ACT_GLIDE or self:GetActivity() == ACT_LAND or self.Zombie_Crouching or self.Zombie_Climbing or self:GetSequence() == self:LookupSequence("shoved_forward_01") -- If we are doing certaina activities then DO NOT flinch!
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo,hitgroup,status)
    if status == "Init" && (self:GetActivity() == ACT_JUMP or self:GetActivity() == ACT_GLIDE or self:GetActivity() == ACT_LAND or self.Zombie_IsClimbing or self.Zombie_Crouching or self:GetSequence() == self:LookupSequence("shoved_forward_01") or self:GetSequence() == self:LookupSequence("shoved_backward_03") or dmginfo:IsExplosionDamage()) then self.HasDeathAnimation = false end
    //self.DeathAnimationDecreaseLengthAmount = math.Rand(0,0.325)
    if status == "DeathAnim" && self:IsMoving() then
        self.AnimTbl_Death = ACT_DIEFORWARD
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
/*-----------------------------------------------
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/