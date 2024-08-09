include("entities/npc_vj_con_zmale/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 600
ENT.MeleeAttackDamage = 20
ENT.HasMeleeAttackKnockBack = false
ENT.MeleeAttackKnockBack_Forward1 = 60
ENT.MeleeAttackKnockBack_Forward2 = 80
ENT.MeleeAttackKnockBack_Up1 = 100
ENT.MeleeAttackKnockBack_Up2 = 100
ENT.FlinchChance = 50
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
ENT.ChargePercentage = 0.65
ENT.ChargeDistance = 1500
ENT.MinChargeDistance = 200
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
    self:Zombie_CustomOnInitialize()
    self:ZombieVoices()
    self.Zombie_Sprinter = true
    self.ChargeAnim = VJ.SequenceToActivity(self, "brute_charge")
    self.RiotBrute_NextChargeT = CurTime() + math.Rand(15,25)
    self.RiotBrute_StopChargingT = CurTime()
    self.RiotBrute_Charging = false
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
function ENT:Zombie_CustomOnInitialize()
    timer.Simple(0, function()
    local shield = ents.Create("prop_vj_animatable")
    shield:SetModel("models/vj_contagion/zombies/police_shield.mdl")
    shield:SetLocalPos(self:GetPos())
    shield:SetOwner(self)
    shield:SetParent(self)
    shield:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    shield:Spawn()
    shield:Activate()
    //shield:SetSolid(SOLID_NONE)
    shield:AddEffects(EF_BONEMERGE)
    shield.VJTag_IsAttackable = false
    self.Shield = shield
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoices()
    self:ZombieVoice_George()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    ply:ChatPrint("ATTACK2: Charge Attack")
    ply:ChatPrint("JUMP: Jump")
    ply:ChatPrint("DUCK: Crouch")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally)
  if self.VJ_IsBeingControlled or self.RiotBrute_Charging or self.Zombie_Crouching then return end
     if math.random(1,3) == 1 && !self:IsBusy() then
        self:VJ_ACT_PLAYACTIVITY("vjseq_zombie_grapple_roar1",true,false,true)
        if math.random(1,3) == 1 && !ally:IsBusy() then
            ally:VJ_ACT_PLAYACTIVITY("vjseq_zombie_grapple_roar2",true,false,true)
        end
    end
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
function ENT:TranslateActivity(act)
    if act == ACT_IDLE && !self.Zombie_Crouching && !self.RiotBrute_Charging then
        return ACT_IDLE_AGITATED
    elseif act == ACT_WALK then
        return ACT_WALK_AGITATED
    elseif act == ACT_RUN then
        return ACT_WALK_AGITATED
end
    if self.RiotBrute_Charging && !self.Zombie_Crouching then
    if act == ACT_IDLE or act == ACT_WALK or act == ACT_RUN then
        return self.ChargeAnim
end
    elseif self.Zombie_Crouching && !self.RiotBrute_Charging then
    if act == ACT_IDLE or act == ACT_TURN_LEFT or act == ACT_TURN_RIGHT then
        return ACT_IDLE_STEALTH
    elseif act == ACT_WALK or act == ACT_RUN then
        return ACT_WALK_STEALTH
end
    elseif act == ACT_IDLE && IsValid(self:GetEnemy()) && !self.Zombie_Crouching && !self.RiotBrute_Charging then
        return ACT_IDLE_AIM_AGITATED
end
    return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
 if self:IsBusy() or self.RiotBrute_Charging or self.Zombie_Crouching then return end
    if self.VJ_IsBeingControlled then
        self:Jump()
end
 if self.Dead or self.DeathAnimationCodeRan or self.RiotBrute_Charging then self.Zombie_DoorToBreak = NULL return end
    if VJ.AnimExists(self,ACT_OPEN_DOOR) then
        if !IsValid(self.Zombie_DoorToBreak) then
          if ((!self.VJ_IsBeingControlled) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_RELOAD))) then
            for _,v in pairs(ents.FindInSphere(self:GetPos(),25)) do
              if v:GetClass() == "func_door_rotating" && v:Visible(self) then self.Zombie_DoorToBreak = v end
                 if v:GetClass() == "prop_door_rotating" && v:Visible(self) then
                    local anim = string.lower(v:GetSequenceName(v:GetSequence()))
                    if string.find(anim,"idle") or string.find(anim,"open") /*or string.find(anim,"locked")*/ then
                        self.Zombie_DoorToBreak = v
                break
            end
        end
    end
end
        else
            //local dist = self:VJ_GetNearestPointToEntityDistance(self.Zombie_DoorToBreak)
            if self.PlayingAttackAnimation or !self.Zombie_DoorToBreak:Visible(self) /*or (self:GetActivity() == ACT_OPEN_DOOR && dist <= 100)*/ then self.Zombie_DoorToBreak = NULL return end
            if self:GetActivity() != ACT_OPEN_DOOR then
                local ang = self:GetAngles()
                self:SetAngles(Angle(ang.x,(self.Zombie_DoorToBreak:GetPos() -self:GetPos()):Angle().y,ang.z))
                self:VJ_ACT_PLAYACTIVITY(ACT_OPEN_DOOR,true,false,false)
                self:SetState(VJ_STATE_ONLY_ANIMATION)
                self:StopMoving()
        end
    end
end
        if !IsValid(self.Zombie_DoorToBreak) then
            self:SetState()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
  if IsValid(self:GetEnemy()) && self:GetEnemy():IsPlayer() && !self.RiotBrute_Charging then
     if IsValid(self:GetBlockingEntity()) || (self:GetEnemy():GetPos():Distance(self:GetPos()) <= 350 && self:GetEnemy():Crouching()) then
        self:Crouch(true)
        self.Zombie_Crouching = true
    else
        self:Crouch(false)
        self.Zombie_Crouching = false
    end
end
  if self.VJ_IsBeingControlled && !self.RiotBrute_Charging then
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
    if !self.RiotBrute_Charging && !self.Zombie_Crouching && self.Zombie_AllowClimbing && !self.Dead && !self.Zombie_Climbing && CurTime() > self.Zombie_NextClimb && !self.RiotBrute_Charging then
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
                anim = VJ.PICK({"vjseq_zombie_climb_50","vjseq_zombie_climb_60","vjseq_zombie_climb_70","vjseq_zombie_climb_72",""})
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
                self:VJ_ACT_PLAYACTIVITY(anim,true,false/*self:DecideAnimationLength(anim,false,0.4)*/,true,0,{},function(vsched)
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
    if self.Zombie_Crouching or self.Zombie_Climbing then return end
    local ent = self:GetEnemy()
    local hasEnemy = IsValid(ent)
    local controlled = IsValid(self.VJ_TheController)
    if self.RiotBrute_Charging then
        local tPos = hasEnemy && ent:GetPos() or self:GetPos() +self:GetForward() *500
        local setangs = self:GetFaceAngle((tPos -self:GetPos()):Angle())
        self:SetAngles(Angle(setangs.p,self:GetAngles().y,setangs.r))
        self:AutoMovement(self:GetAnimTimeInterval() *self.ChargePercentage) -- For some reason, letting it go at 100% forces the walkframe speed to be doubled, essentially ignoring the walkframes in the animation. Basically, think how NextBots just slide everywhere faster than their animation is supposed to
        self:SetGroundEntity(NULL)
        self:SetTurnTarget("Enemy")
        local tr = util.TraceHull({
            start = self:GetPos() + self:OBBCenter(),
            endpos = self:GetPos() + self:OBBCenter() + self:GetForward()*30,
            mins = Vector(self:OBBMins()),
            maxs = Vector(15, 15, 50),
            filter = {self,self.Shield}
        })
        local hitEnt = NULL
            if IsValid(tr.Entity) && tr.Entity != self && (tr.Entity != self.VJ_TheController && tr.Entity != self.VJ_TheControllerBullseye) then
              if self:Disposition(tr.Entity) != D_LI && tr.Entity:GetClass() != "npc_vj_con_zriotbrute" && IsValid(self.Shield) && tr.Entity != self.Shield then
                    hitEnt = tr.Entity
                    VJ.CreateSound(self,"physics/metal/metal_sheet_impact_hard8.wav",75)
                    local dmginfo = DamageInfo()
                    dmginfo:SetDamage(35)
                    dmginfo:SetDamageType(DMG_CLUB)
                    dmginfo:SetDamagePosition(tr.Entity:GetPos() +tr.Entity:OBBCenter())
                    dmginfo:SetAttacker(self)
                    dmginfo:SetInflictor(self)
                    tr.Entity:TakeDamageInfo(dmginfo,self,self)
                    tr.Entity:SetGroundEntity(NULL)
                    tr.Entity:SetVelocity(self:GetForward() *math.random(self.MeleeAttackKnockBack_Forward1, self.MeleeAttackKnockBack_Forward2) *2 + self:GetUp()*math.random(self.MeleeAttackKnockBack_Up1, self.MeleeAttackKnockBack_Up2) *2)

                if tr.Entity:GetClass() == "prop_physics" then
                local HitProp = tr.Entity:GetPhysicsObject()
                if IsValid(ent) && IsValid(HitProp) then
                    HitProp:EnableMotion(true)
                    HitProp:SetVelocity(((ent:GetPos() + ent:OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal()*400 + self:GetForward()*300 + self:GetUp()*300)
                elseif !IsValid(ent) && IsValid(HitProp) then
                    HitProp:SetVelocity(((self:GetPos() + self:OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal()*400 + self:GetForward()*300 + self:GetUp()*300)
end
                if IsValid(HitProp) && tr.Entity:GetClass() == "prop_physics" && tr.Entity:Health() >= 0 then
                    tr.Entity:TakeDamage(tr.Entity:GetMaxHealth())
    end
end
                if IsValid(tr.Entity) && tr.Entity:GetClass() != "prop_physics" then
                    local chargeattack = self:VJ_ACT_PLAYACTIVITY("vjseq_shoved_backwards_wall1",true,false,false)
        end
    end
end
        if CurTime() > self.RiotBrute_StopChargingT or tr.HitWorld or (IsValid(tr.Entity) && tr.Entity:GetClass() != "prop_physics" && self:Disposition(tr.Entity) != D_LI && tr.Entity:GetClass() != "npc_vj_con_zriotbrute" && IsValid(self.Shield) && tr.Entity != self.Shield) then
            self:StopCharging(tr && tr.HitWorld)
    end
end
    if hasEnemy && !self.Zombie_Crouching && !self.Zombie_Climbing then
    local dist = self:GetPos():Distance(ent:GetPos())
        if ((controlled && self.VJ_TheController:KeyDown(IN_ATTACK2)) or !controlled) && dist <= self.ChargeDistance  && dist > self.MinChargeDistance && !self:BusyWithActivity() && CurTime() > self.RiotBrute_NextChargeT && !self.RiotBrute_Charging && ent:Visible(self) && self:GetSequenceName(self:GetSequence()) != "brute_charge_begin" then
            self:VJ_ACT_PLAYACTIVITY("brute_charge_begin",true,false,true)
            self:PlaySoundSystem("GeneralSpeech",self.SoundTbl_CallForHelp)
            timer.Simple(self:SequenceDuration(self:LookupSequence("brute_charge_begin")),function()
                if IsValid(self) then
                    self.HasMeleeAttack = false
                    self.HasMeleeAttackKnockBack = true
                    self.RiotBrute_StopChargingT = CurTime() +8
                    self.RiotBrute_Charging = true
                    self.TurningSpeed = 1
                    self:SetState(VJ_STATE_ONLY_ANIMATION)
                end
            end)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopCharging(crash)
    self:SetState()
    self.HasMeleeAttack = true
    self.HasMeleeAttackKnockBack = false
    self.RiotBrute_Charging = false
    self.TurningSpeed = 20
    self.RiotBrute_StopChargingT = CurTime()
    self.RiotBrute_NextChargeT = CurTime() +math.Rand(10,15)
    if crash then
        util.ScreenShake(self:GetPos(),16,100,1,150)
        VJ.CreateSound(self,{"physics/metal/metal_sheet_impact_hard2.wav","physics/metal/metal_sheet_impact_hard6.wav","physics/metal/metal_sheet_impact_hard7.wav","physics/metal/metal_sheet_impact_hard8.wav"},75)
        self:VJ_ACT_PLAYACTIVITY(crash && "vjseq_shoved_backwards_heavy",true,false,false)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
 dmginfo:ScaleDamage(0.10)
 if hitgroup == 9 then
    dmginfo:ScaleDamage(0.00)
end
    if dmginfo:IsBulletDamage() && self.HasSounds && self.HasImpactSounds && hitgroup == HITGROUP_HEAD && self.Riot_Helmet && self:GetBodygroup(1) == 0 then
    VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ImpactBullet_Metal_layer01_0"..math.random(1,5)..".wav",70)
    VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ImpactBullet_Metal_layer02_0"..math.random(1,7)..".wav",70)
        self.Bleeds = false
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
        self:SetBodygroup(1,1)
        self:RemoveAllDecals()
        self:BreakHelmet()
    end
end
     if dmginfo:IsBulletDamage() && self.HasSounds && self.HasImpactSounds && (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG) then
    VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ImpactBullet_Metal_layer01_0"..math.random(1,5)..".wav",70)
    VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ImpactBullet_Metal_layer02_0"..math.random(1,7)..".wav",70)
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
        dmginfo:ScaleDamage(0.1)
        end
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BreakHelmet()
    self:CreateGibEntity("prop_physics","models/vj_contagion/zombies/riot_helmet_gib01.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_neck")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/vj_contagion/zombies/riot_helmet_gib02.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_headr")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/vj_contagion/zombies/riot_helmet_gib03.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_headl")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
    self:CreateGibEntity("prop_physics","models/vj_contagion/zombies/riot_helmet_gib04.mdl",{Pos=self:GetAttachment(self:LookupAttachment("forward")).Pos,Ang=self:GetAngles(),Vel_ApplyDmgForce=false,Vel=Vector(0,0,0)})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,corpseEnt)
    VJ_CON_ApplyCorpseEffects(self,corpseEnt)
    self:CreateExtraDeathCorpse("prop_physics","models/vj_contagion/zombies/police_shield.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_larmr")).Pos + self:GetUp()*-40})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
    -- If no corpse spawned, make sure to remove the shield!
    if !IsValid(self.Corpse) && IsValid(self.ShieldModel) then
        SafeRemoveEntity(self.ShieldModel)
    end
end
/*-----------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/