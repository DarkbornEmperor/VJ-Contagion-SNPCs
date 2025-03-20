include("entities/npc_vj_con_zmale/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 600 // 200
ENT.HasMeleeAttackKnockBack = false
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
function ENT:Init()
    self:Zombie_Init()
    self:ZombieVoices()
    self.Zombie_Sprinter = true
    self.ChargeAnim = VJ.SequenceToActivity(self, "brute_charge")
    self.RiotBrute_NextChargeT = CurTime() + math.Rand(15,25)
    self.RiotBrute_StopChargingT = CurTime()
    self.RiotBrute_Charging = false
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
function ENT:Zombie_Init()
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
    shield.VJ_ID_Attackable = false
    self.Shield = shield
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoices()
    self:ZombieVoice_George()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
  ply:ChatPrint("DUCK: Crouch")
  ply:ChatPrint("JUMP: Jump")
  ply:ChatPrint("RELOAD: Roar")
  ply:ChatPrint("USE: Break Door")
  ply:ChatPrint("ATTACK2: Command")
  ply:ChatPrint("SPEED: Charge")

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
function ENT:Zombie_OnThinkActive()
    if self.Zombie_Crouching or self.Zombie_Climbing then return end
    local ent = self:GetEnemy()
    local hasEnemy = IsValid(ent)
    local controlled = IsValid(self.VJ_TheController)
    if self.RiotBrute_Charging then
        local tPos = hasEnemy && ent:GetPos() or self:GetPos() +self:GetForward() *500
        local setangs = self:GetTurnAngle((tPos -self:GetPos()):Angle())
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
                    tr.Entity:SetVelocity(self:GetForward()*60 *2 + self:GetUp()*100 *2)

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
                    local chargeattack = self:PlayAnim("vjseq_shoved_backwards_wall1",true,false,false)
        end
    end
end
        if CurTime() > self.RiotBrute_StopChargingT or tr.HitWorld or (IsValid(tr.Entity) && tr.Entity:GetClass() != "prop_physics" && self:Disposition(tr.Entity) != D_LI && tr.Entity:GetClass() != "npc_vj_con_zriotbrute" && IsValid(self.Shield) && tr.Entity != self.Shield) then
            self:StopCharging(tr && tr.HitWorld)
    end
end
    if hasEnemy && !self.Zombie_Crouching && !self.Zombie_Climbing then
    local dist = self:GetPos():Distance(ent:GetPos())
        if ((controlled && self.VJ_TheController:KeyDown(IN_SPEED)) or !controlled) && dist <= self.ChargeDistance  && dist > self.MinChargeDistance && !self:IsBusy("Activities") && CurTime() > self.RiotBrute_NextChargeT && !self.RiotBrute_Charging && ent:Visible(self) && self:GetSequenceName(self:GetSequence()) != "brute_charge_begin" then
            self:PlayAnim("brute_charge_begin",true,false,true)
            self:PlaySoundSystem("Alert",self.SoundTbl_CallForHelp)
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
        VJ.EmitSound(self,"vj_contagion/zombies/shared/SFX_ZombiePoundDoor_Metal0"..math.random(1,4)..".wav",75,100)
        self:PlayAnim(crash && "vjseq_shoved_backwards_heavy",true,false,false)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackKnockbackVelocity(ent)
    return self:GetForward()*60 + self:GetUp()*100
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ArmorDamage(dmginfo,hitgroup,status)
    if status == "PreDamage" && dmginfo:IsBulletDamage() && self.HasSounds && self.HasImpactSounds && hitgroup == HITGROUP_HEAD && self.Riot_Helmet && self:GetBodygroup(1) == 0 then
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
    if status == "PreDamage" && dmginfo:IsBulletDamage() && self.HasSounds && self.HasImpactSounds && (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG) then
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo,hitgroup,corpseEnt)
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
    *** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/