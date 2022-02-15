AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 600
ENT.AnimTbl_IdleStand = {ACT_IDLE_AGITATED}
ENT.AnimTbl_Walk = {ACT_WALK_AGITATED}
ENT.AnimTbl_Run = {ACT_WALK_AGITATED}
ENT.MeleeAttackDamage = 15
ENT.HasMeleeAttackKnockBack = false 
ENT.MeleeAttackKnockBack_Forward1 = 60 
ENT.MeleeAttackKnockBack_Forward2 = 80 
ENT.MeleeAttackKnockBack_Up1 = 100 
ENT.MeleeAttackKnockBack_Up2 = 100 
ENT.HasCallForHelpAnimation = false
ENT.CanFlinch = 0
ENT.IdleSoundPitch = VJ_Set(80, 80)
ENT.CombatIdleSoundPitch = VJ_Set(80, 80)
ENT.AlertSoundPitch = VJ_Set(80, 80)
ENT.CallForHelpSoundPitch = VJ_Set(80, 80)
ENT.BeforeMeleeAttackSoundPitch = VJ_Set(80, 80)
ENT.PainSoundPitch = VJ_Set(80, 80)
ENT.DeathSoundPitch = VJ_Set(80, 80)
-- Custom 
ENT.Riot_Helmet = true
//ENT.Riot_HelmetHP = 200
ENT.ChargePercentage = 0.65
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CustomOnInitialize()		
	    self.ShieldModel = ents.Create("prop_vj_animatable")
	    self.ShieldModel:SetModel("models/cpthazama/contagion/zombies/police_shield.mdl")
	    self.ShieldModel:SetLocalPos(self:GetPos())
	    self.ShieldModel:SetOwner(self)
	    self.ShieldModel:SetParent(self)
	    self.ShieldModel:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	    self.ShieldModel:Spawn()
	    self.ShieldModel:Activate()
	    self.ShieldModel:SetSolid(SOLID_NONE)
	    self.ShieldModel:AddEffects(EF_BONEMERGE)	
		if GetConVarNumber("VJ_CON_AllowClimbing") == 1 then self.Zombie_AllowClimbing = true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()	
	self:SetCollisionBounds(Vector(14,14,72),Vector(-14,-14,0))
	self:Zombie_CustomOnInitialize()
	self:ZombieSounds()
	self.Zombie_AdvancedStrain = true
	self.ChargeAnim = VJ_SequenceToActivity(self, "brute_charge")
	self.RiotBrute_NextChargeT = CurTime() +5
	self.RiotBrute_StopChargingT = CurTime()
	self.RiotBrute_Charging = false	
	self.FlinchAnim = {ACT_SMALL_FLINCH,ACT_BIG_FLINCH,ACT_FLINCH_STOMACH}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply)
      ply:ChatPrint("MOUSE2: Charge Attack")	  
      ply:ChatPrint("JUMP: Jump")
      ply:ChatPrint("DUCK: Crouch")	  
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self:BusyWithActivity() or self.RiotBrute_Charging then return end
	self.RiotBrute_NextChargeT = CurTime() +10
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally)
  if self:BusyWithActivity() or self.RiotBrute_Charging or self.VJ_IsBeingControlled then return end
    if self.VJ_IsBeingControlled or self.Zombie_Crippled then return end
	   self:VJ_ACT_PLAYACTIVITY("vjseq_zombie_grapple_roar1",true,false,true)
	if math.random(1,3) == 1 then	
		   ally:VJ_ACT_PLAYACTIVITY("vjseq_zombie_grapple_roar2",true,false,true)
	end	   
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Crouch(bCrouch)
 if self:BusyWithActivity() or self.RiotBrute_Charging then return end
	if bCrouch then
		self:SetHullType(HULL_TINY)
		self:SetCollisionBounds(Vector(14,14,35),Vector(-14,-14,0))
		self.AnimTbl_IdleStand = {VJ_SequenceToActivity(self,"crouch_idle2013")}
		self.AnimTbl_Walk = {VJ_SequenceToActivity(self,"crouch_walk_2013")}
		self.AnimTbl_Run = {VJ_SequenceToActivity(self,"crouch_walk_2013")}
	elseif self.VJ_IsBeingControlled or self.Zombie_AdvancedStrain then	
		self:SetHullType(HULL_HUMAN)
		self:SetCollisionBounds(Vector(14,14,72),Vector(-14,-14,0))
	    self.AnimTbl_IdleStand = {ACT_IDLE_AGITATED}
		self.AnimTbl_Walk = {ACT_WALK_AGITATED}
		self.AnimTbl_Run = {ACT_WALK_AGITATED} 
   else	
 		self:SetHullType(HULL_HUMAN)
		self:SetCollisionBounds(Vector(14,14,72),Vector(-14,-14,0))  
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
 if self:BusyWithActivity() or self.RiotBrute_Charging or self.Zombie_Crouching then return end
    if self.VJ_IsBeingControlled then
	   self:Jump()	   	 
    end			
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
		if IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled && !self.RiotBrute_Charging && !self.Zombie_Crouching then
			self.AnimTbl_IdleStand = {ACT_IDLE_AIM_AGITATED}
	    elseif !self.VJ_IsBeingControlled && !self.RiotBrute_Charging then
		    self.AnimTbl_IdleStand = {ACT_IDLE_AGITATED}		
end
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
				self.CanFlinch = 0				
                self.VJC_Data = {
	            CameraMode = 1, 
	            ThirdP_Offset = Vector(45, 25, -15), 
	            FirstP_Bone = "ValveBiped.Bip01_Head1", 
	            FirstP_Offset = Vector(10, -3, -25), 
} 
	   elseif !self.VJ_TheController:KeyDown(IN_DUCK) or self.RiotBrute_Charging then	
				self:Crouch(false)
				self.Zombie_Crouching = false
				self.CanFlinch = 1
                self.VJC_Data = {
	            CameraMode = 1, 
	            ThirdP_Offset = Vector(40, 25, -50), 
	            FirstP_Bone = "ValveBiped.Bip01_Head1",
	            FirstP_Offset = Vector(0, 0, 5), 				
}			
    end	
end	
	//print(self:GetBlockingEntity())
	// IsValid(self:GetBlockingEntity()) && !self:GetBlockingEntity():IsNPC() && !self:GetBlockingEntity():IsPlayer()
	if !self.RiotBrute_Charging && !self.Zombie_Crouching && self.Zombie_AllowClimbing == true && self.Dead == false && self.Zombie_Climbing == false && CurTime() > self.Zombie_NextClimb && !self.RiotBrute_Charging then
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
					anim = VJ_PICK({"vjseq_zombie_climb_108","vjseq_zombie_climb_120"})
					finalpos = tr5.HitPos
end
			elseif IsValid(tr4.Entity) then
				anim = VJ_PICK({"vjseq_zombie_climb_84","vjseq_zombie_climb_96"})
				finalpos = tr4.HitPos
			elseif IsValid(tr3.Entity) then
				anim = VJ_PICK({"vjseq_zombie_climb_84","vjseq_zombie_climb_96"})
				finalpos = tr3.HitPos
			elseif IsValid(tr2.Entity) then
				anim = VJ_PICK({"vjseq_zombie_climb_50","vjseq_zombie_climb_60","vjseq_zombie_climb_70","vjseq_zombie_climb_72",""})
				finalpos = tr2.HitPos
			elseif IsValid(tr1.Entity) then
				anim = VJ_PICK({"vjseq_zombie_climb_24","vjseq_zombie_climb_36","vjseq_zombie_climb_38","vjseq_zombie_climb_48","vjseq_zombie_climb_38"})
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
	if self.RiotBrute_Charging && !self.Zombie_Crouching && !self.Zombie_Climbing then
		local tPos = hasEnemy && ent:GetPos() or self:GetPos() +self:GetForward() *500
		local setangs = self:GetFaceAngle((tPos -self:GetPos()):Angle())
		self:SetAngles(Angle(setangs.p,self:GetAngles().y,setangs.r))
		self:AutoMovement(self:GetAnimTimeInterval() *self.ChargePercentage) -- For some reason, letting it go at 100% forces the walkframe speed to be doubled, essentially ignoring the walkframes in the animation. Basically, think how NextBots just slide everywhere faster than their animation is supposed to
		self:SetGroundEntity(NULL)
		local tr = util.TraceHull({
			start = self:GetPos() +self:OBBCenter(),
			endpos = self:GetPos() +self:OBBCenter() +self:GetForward() *50,
			filter = self,
			mins = self:OBBMins() /2,
			maxs = self:OBBMaxs() /2
		})
		local hitEnt = NULL
		for _,v in pairs(ents.FindInSphere(self:GetPos() +self:GetForward(),50)) do
			if IsValid(v) && v != self && (v != self.VJ_TheController && v != self.VJ_TheControllerBullseye) then
				if self:DoRelationshipCheck(v) then
					hitEnt = v
					VJ_CreateSound(self,"physics/metal/metal_sheet_impact_hard8.wav",75)
					local dmginfo = DamageInfo()
					dmginfo:SetDamage(35)
					dmginfo:SetDamageType(DMG_CLUB)
					dmginfo:SetDamagePosition(v:GetPos() +v:OBBCenter())
					dmginfo:SetAttacker(self)
					dmginfo:SetInflictor(self)
					v:TakeDamageInfo(dmginfo,self,self)
					v:SetGroundEntity(NULL)
					v:SetVelocity(self:GetForward() *math.random(self.MeleeAttackKnockBack_Forward1, self.MeleeAttackKnockBack_Forward2) *2 + self:GetUp()*math.random(self.MeleeAttackKnockBack_Up1, self.MeleeAttackKnockBack_Up2) *2 + self:GetRight()*math.random(self.MeleeAttackKnockBack_Right1, self.MeleeAttackKnockBack_Right2) *2)

					local stumble = self:VJ_ACT_PLAYACTIVITY("shoved_backwards_wall1",true,false,false)					
				end
			end
		end
		if CurTime() > self.RiotBrute_StopChargingT or tr.HitWorld == true or IsValid(hitEnt) then
			self:StopCharging(tr && tr.HitWorld)
		end
	end
	if hasEnemy && !self.Zombie_Crouching && !self.Zombie_Climbing then
		if ((controlled && self.VJ_TheController:KeyDown(IN_ATTACK2)) or !controlled) && ent:GetPos():Distance(self:GetPos()) <= 2500 && !self:BusyWithActivity() && CurTime() > self.RiotBrute_NextChargeT && !self.RiotBrute_Charging && ent:Visible(self) && self:GetSequenceName(self:GetSequence()) != "brute_charge_begin" then
			self:VJ_ACT_PLAYACTIVITY("brute_charge_begin",true,false,true,{SequenceInterruptible=false})
			VJ_CreateSound(self,{"vj_contagion/build2695/z_sham/roar/0070.wav","vj_contagion/build2695/z_sham/roar/0071.wav","vj_contagion/build2695/z_sham/roar/0072.wav","vj_contagion/build2695/z_sham/roar/0073.wav","vj_contagion/build2695/z_sham/roar/0074.wav","vj_contagion/build2695/z_sham/roar/0075.wav"},75,80)
			timer.Simple(self:SequenceDuration(self:LookupSequence("brute_charge_begin")),function()
				if IsValid(self) && !self.Zombie_Climbing && !self.Zombie_Crouching then
				    self.HasMeleeAttackKnockBack = true
					self.RiotBrute_StopChargingT = CurTime() +15
					self.RiotBrute_Charging = true
					self.AnimTbl_IdleStand = {self.ChargeAnim}
					self.AnimTbl_Walk = {self.ChargeAnim}
					self.AnimTbl_Run = {self.ChargeAnim}
					self:SetState(VJ_STATE_ONLY_ANIMATION)
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopCharging(crash)
	self:SetState()
	self.HasMeleeAttackKnockBack = false 
	self.RiotBrute_Charging = false
	self.RiotBrute_StopChargingT = CurTime()
	self.RiotBrute_NextChargeT = CurTime() +math.Rand(15,20)
	if crash then
		util.ScreenShake(self:GetPos(),16,100,2,100)
	    VJ_CreateSound(self,{"physics/metal/metal_sheet_impact_hard2.wav","physics/metal/metal_sheet_impact_hard6.wav","physics/metal/metal_sheet_impact_hard7.wav","physics/metal/metal_sheet_impact_hard8.wav"},75)
	    self:VJ_ACT_PLAYACTIVITY(crash && ACT_BIG_FLINCH,true,false,false)		
end	
	self.AnimTbl_IdleStand = {ACT_IDLE_AGITATED}
	self.AnimTbl_Walk = {ACT_WALK_AGITATED}
	self.AnimTbl_Run = {ACT_WALK_AGITATED}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if (dmginfo:IsBulletDamage()) && hitgroup == HITGROUP_HEAD && self.Riot_Helmet or hitgroup == 9 then
		dmginfo:ScaleDamage(0.00)	
end	
	if dmginfo:IsBulletDamage() && self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_HEAD && self.Riot_Helmet && self:GetBodygroup(1) == 0 then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
	    self.Bleeds = false
		dmginfo:ScaleDamage(0.00)
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
    if dmginfo:IsBulletDamage() && math.random(5,80) == 5 && hitgroup == HITGROUP_HEAD && self.Riot_Helmet && self:GetBodygroup(1) == 0 then
           self.Riot_Helmet = false	
		   self.Bleeds = true
           self:SetBodygroup(1,1)	
		   //dmginfo:ScaleDamage(1.0)	
	if IsValid(spark) then spark:Remove() end
           self:BreakHelmet()
    return
end
 	if dmginfo:IsBulletDamage() && self.HasSounds == true && self.HasImpactSounds == true && hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG then
	VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70)
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
	        dmginfo:ScaleDamage(0.10)
        end		
    end		
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
  if !self.RiotBrute_Charging then
    if self:IsMoving() && self.Zombie_NextStumbleT < CurTime() && math.random(1, 50) == 1 then
		self:VJ_ACT_PLAYACTIVITY(self.FlinchAnim,true,false,false)
		self.Zombie_NextStumbleT = CurTime() + 10
     end		
  end
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BreakHelmet()	
	local prop = ents.Create("prop_physics")
	prop:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib01.mdl")
	prop:SetPos(self:GetAttachment(self:LookupAttachment("particle_neck")).Pos)
	prop:SetAngles(self:GetAttachment(self:LookupAttachment("particle_neck")).Ang)
	prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
	prop:Spawn()
	prop:Activate()
	SafeRemoveEntityDelayed(prop,30)
	
	local prop2 = ents.Create("prop_physics")
	prop2:SetPos(self:LocalToWorld(Vector(0,0,-100)))
	prop2:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib02.mdl")
	prop2:SetPos(self:GetAttachment(self:LookupAttachment("particle_headr")).Pos)
	prop2:SetAngles(self:GetAttachment(self:LookupAttachment("particle_headr")).Ang)
	prop2:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
	prop2:Spawn()
	prop2:Activate()
	SafeRemoveEntityDelayed(prop2,30)	
	
	local prop3 = ents.Create("prop_physics")
	prop3:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib03.mdl")
	prop3:SetPos(self:GetAttachment(self:LookupAttachment("particle_headl")).Pos)
	prop3:SetAngles(self:GetAttachment(self:LookupAttachment("particle_headl")).Ang)
	prop3:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
	prop3:Spawn()
	prop3:Activate()
	SafeRemoveEntityDelayed(prop3,30)

	local prop4 = ents.Create("prop_physics")
	prop4:SetModel("models/cpthazama/contagion/zombies/riot_helmet_gib04.mdl")
	prop4:SetPos(self:GetAttachment(self:LookupAttachment("forward")).Pos)
	prop4:SetAngles(self:GetAttachment(self:LookupAttachment("forward")).Ang)
	prop4:SetCollisionGroup(COLLISION_GROUP_WEAPON)	
	prop4:Spawn()
	prop4:Activate()
	SafeRemoveEntityDelayed(prop4,30)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
GetCorpse.BloodEffect = self.CustomBlood_Particle
	local hookName = "VJ_CON_CorpseBlood_" .. GetCorpse:EntIndex()
	hook.Add("EntityTakeDamage",hookName,function(ent,dmginfo)
		if !IsValid(GetCorpse) then
			hook.Remove("EntityTakeDamage",hookName)
end
		if ent == GetCorpse then
			local attacker = dmginfo:GetAttacker()
			if GetCorpse.BloodEffect then
				for _,i in ipairs(GetCorpse.BloodEffect) do
					sound.Play("physics/flesh/flesh_impact_bullet"..math.random(1,3)..".wav",dmginfo:GetDamagePosition(),60,100)
					ParticleEffect(i,dmginfo:GetDamagePosition(),Angle(math.random(0,360),math.random(0,360),math.random(0,360)),nil)
				end
			end
		end
	end)
	self:CreateExtraDeathCorpse("prop_physics","models/cpthazama/contagion/zombies/police_shield.mdl",{Pos=self:GetAttachment(self:LookupAttachment("particle_larmr")).Pos + self:GetUp()*-20})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
    -- If no corpse spawned, make sure to remove the shield!
    if !IsValid(self.Corpse) && IsValid(self.ShieldModel) then
        self.ShieldModel:Remove()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSuperStrain(hp)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Cripple()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/