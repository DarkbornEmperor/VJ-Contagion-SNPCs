AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodPool = false
ENT.TurningSpeed = 5
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackDistance = 35
ENT.MeleeAttackDamageDistance = 70
ENT.AnimTbl_MeleeAttack = {
	"vjges_Melee2013_01",
	"vjges_Melee2013_02",
	"vjges_Melee2013_03",
	"vjges_Melee2013_04",
	"vjges_Melee2013_05",
	"vjges_Melee2013_06",
	"vjges_Melee2013_07",
	"vjges_Melee2013_08",
} -- Melee Attack Animations
ENT.MeleeAttackAnimationAllowOtherTasks = true -- If set to true, the animation will not stop other tasks from playing, such as chasing | Useful for gesture attacks!
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttackTime = 0.5 -- How much time until player's Speed resets
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
--ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.HasMeleeAttackSlowPlayerSound = false -- Does it have a sound when it slows down the player?
ENT.MaxJumpLegalDistance = VJ_Set(0,300)
	-- ====== Controller Data ====== --
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(40, 20, -50), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
}
	-- ====== Flinching Code ====== --
//ENT.AnimTbl_Flinch = {"vjges_flinch_01"} -- If it uses normal based animation, use this
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 1.5 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextFlinchTime = 1.5
ENT.NextMoveAfterFlinchTime = "LetBaseDecide" -- How much time until it can move, attack, etc. | Use this for schedules or else the base will set the time 0.6 if it sees it's a schedule!
ENT.HasHitGroupFlinching = true -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_DefaultWhenNotHit = false -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = {
{HitGroup = {HITGROUP_HEAD}, Animation = {"vjges_injured_head2013_01","vjges_injured_head2013_02","vjges_injured_head2013_03","vjges_injured_head2013_04"}},
{HitGroup = {HITGROUP_CHEST}, Animation = {"shoved_backwards1","shoved_backwards2","shoved_backwards3","vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}},
{HitGroup = {HITGROUP_STOMACH}, Animation = {"shoved_backwards1","shoved_backwards2","shoved_backwards3","vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}},
{HitGroup = {HITGROUP_RIGHTARM}, Animation = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}},
{HitGroup = {HITGROUP_LEfTARM}, Animation = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}},
{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}},
{HitGroup = {HITGROUP_LEFTLEG}, Animation = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}}}
	-- ====== Death Animation Variables ====== --
ENT.HasDeathAnimation = true
ENT.DeathAnimationChance = 2
ENT.AnimTbl_Death = {"vjseq_death2013_01","vjseq_death2013_02","vjseq_death2013_03","vjseq_death2013_04"} 
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
ENT.SoundTbl_Idle = {"contagion/female/idle01.mp3","contagion/female/idle02.mp3","contagion/female/idle03.mp3","contagion/female/idle04.mp3","contagion/female/idle05.mp3","contagion/female/idle06.mp3","contagion/female/idle07.mp3","contagion/female/idle08.mp3","contagion/female/idle09.mp3","contagion/female/idle10.mp3"}
ENT.SoundTbl_Alert = {"contagion/female/alert11.wav","contagion/female/alert12.wav","contagion/female/alert13.wav","contagion/female/alert14.wav","contagion/female/alert_10.wav","contagion/female/alert01.mp3","contagion/female/alert02.mp3","contagion/female/alert03.mp3","contagion/female/alert04.mp3","contagion/female/alert05.mp3","contagion/female/alert06.mp3","contagion/female/alert07.mp3","contagion/female/alert08.mp3","contagion/female/alert09.mp3","contagion/female/alert10.mp3"}
ENT.SoundTbl_CombatIdle = {"contagion/female/alert11.wav","contagion/female/alert12.wav","contagion/female/alert13.wav","contagion/female/alert14.wav","contagion/female/alert_10.wav","contagion/female/alert01.mp3","contagion/female/alert02.mp3","contagion/female/alert03.mp3","contagion/female/alert04.mp3","contagion/female/alert05.mp3","contagion/female/alert06.mp3","contagion/female/alert07.mp3","contagion/female/alert08.mp3","contagion/female/alert09.mp3","contagion/female/alert10.mp3"}
ENT.SoundTbl_BeforeMeleeAttack = {"contagion/female/alert11.wav","contagion/female/alert12.wav","contagion/female/alert13.wav","contagion/female/alert14.wav","contagion/female/alert_10.wav","contagion/female/alert01.mp3","contagion/female/alert02.mp3","contagion/female/alert03.mp3","contagion/female/alert04.mp3","contagion/female/alert05.mp3","contagion/female/alert06.mp3","contagion/female/alert07.mp3","contagion/female/alert08.mp3","contagion/female/alert09.mp3","contagion/female/alert10.mp3"}
ENT.SoundTbl_MeleeAttack = {"contagion/claw_strike1.mp3","contagion/claw_strike2.mp3","contagion/claw_strike3.mp3"}
ENT.SoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav","npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"contagion/female/pain01.mp3","contagion/female/pain02.mp3","contagion/female/pain03.mp3","contagion/female/pain04.mp3","contagion/female/pain05.mp3"}
ENT.SoundTbl_Death = {"contagion/female/pain01.mp3","contagion/female/pain02.mp3","contagion/female/pain03.mp3","contagion/female/pain04.mp3","contagion/female/pain05.mp3"}

-- Custom
ENT.Zombie_Climbing = false
ENT.Zombie_NextClimb = 0
--ENT.Zombie_AllowClimbing = true
ENT.Zombie_NextStumble = CurTime()
ENT.AdvancedStrain = false
ENT.LegHealth = 28
ENT.Crippled = false
ENT.Stumbled = true

ENT.FootSteps = {
	[MAT_ANTLION] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_BLOODYFLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_CONCRETE] = {
		"player/footsteps/concrete1.wav",
		"player/footsteps/concrete2.wav",
		"player/footsteps/concrete3.wav",
		"player/footsteps/concrete4.wav",
	},
	[MAT_DIRT] = {
		"player/footsteps/dirt1.wav",
		"player/footsteps/dirt2.wav",
		"player/footsteps/dirt3.wav",
		"player/footsteps/dirt4.wav",
	},
	[MAT_FLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_GRATE] = {
		"player/footsteps/metalgrate1.wav",
		"player/footsteps/metalgrate2.wav",
		"player/footsteps/metalgrate3.wav",
		"player/footsteps/metalgrate4.wav",
	},
	[MAT_ALIENFLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[74] = { -- Snow
		"player/footsteps/sand1.wav",
		"player/footsteps/sand2.wav",
		"player/footsteps/sand3.wav",
		"player/footsteps/sand4.wav",
	},
	[MAT_PLASTIC] = {
		"physics/plaster/drywall_footstep1.wav",
		"physics/plaster/drywall_footstep2.wav",
		"physics/plaster/drywall_footstep3.wav",
		"physics/plaster/drywall_footstep4.wav",
	},
	[MAT_METAL] = {
		"player/footsteps/metal1.wav",
		"player/footsteps/metal2.wav",
		"player/footsteps/metal3.wav",
		"player/footsteps/metal4.wav",
	},
	[MAT_SAND] = {
		"player/footsteps/sand1.wav",
		"player/footsteps/sand2.wav",
		"player/footsteps/sand3.wav",
		"player/footsteps/sand4.wav",
	},
	[MAT_FOLIAGE] = {
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav",
	},
	[MAT_COMPUTER] = {
		"physics/plaster/drywall_footstep1.wav",
		"physics/plaster/drywall_footstep2.wav",
		"physics/plaster/drywall_footstep3.wav",
		"physics/plaster/drywall_footstep4.wav",
	},
	[MAT_SLOSH] = {
		"player/footsteps/slosh1.wav",
		"player/footsteps/slosh2.wav",
		"player/footsteps/slosh3.wav",
		"player/footsteps/slosh4.wav",
	},
	[MAT_TILE] = {
		"player/footsteps/tile1.wav",
		"player/footsteps/tile2.wav",
		"player/footsteps/tile3.wav",
		"player/footsteps/tile4.wav",
	},
	[85] = { -- Grass
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav",
	},
	[MAT_VENT] = {
		"player/footsteps/duct1.wav",
		"player/footsteps/duct2.wav",
		"player/footsteps/duct3.wav",
		"player/footsteps/duct4.wav",
	},
	[MAT_WOOD] = {
		"player/footsteps/wood1.wav",
		"player/footsteps/wood2.wav",
		"player/footsteps/wood3.wav",
		"player/footsteps/wood4.wav",
		"player/footsteps/woodpanel1.wav",
		"player/footsteps/woodpanel2.wav",
		"player/footsteps/woodpanel3.wav",
		"player/footsteps/woodpanel4.wav",
	},
	[MAT_GLASS] = {
		"physics/glass/glass_sheet_step1.wav",
		"physics/glass/glass_sheet_step2.wav",
		"physics/glass/glass_sheet_step3.wav",
		"physics/glass/glass_sheet_step4.wav",
	}
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound()
	if !self:IsOnGround() then return end
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() +Vector(0,0,-150),
		filter = {self}
	})
	if tr.Hit && self.FootSteps[tr.MatType] then
		VJ_EmitSound(self,VJ_PICK(self.FootSteps[tr.MatType]),self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	end
	if self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ_EmitSound(self,"player/footsteps/wade" .. math.random(1,8) .. ".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasFootStepSound == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:GetGroundEntity() != NULL then
		if self.DisableFootStepSoundTimer == true then
			self:CustomOnFootStepSound()
			return
		elseif self:IsMoving() && CurTime() > self.FootStepT then
			self:CustomOnFootStepSound()
			local CurSched = self.CurrentSchedule
			if self.DisableFootStepOnRun == false && ((VJ_HasValue(self.AnimTbl_Run,self:GetMovementActivity())) or (CurSched != nil  && CurSched.IsMovingTask_Run == true)) /*(VJ_HasValue(VJ_RunActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomRunActivites,self:GetMovementActivity()))*/ then
				self:CustomOnFootStepSound_Run()
				self.FootStepT = CurTime() + self.FootStepTimeRun
				return
			elseif self.DisableFootStepOnWalk == false && (VJ_HasValue(self.AnimTbl_Walk,self:GetMovementActivity()) or (CurSched != nil  && CurSched.IsMovingTask_Walk == true)) /*(VJ_HasValue(VJ_WalkActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomWalkActivites,self:GetMovementActivity()))*/ then
				self:CustomOnFootStepSound_Walk()
				self.FootStepT = CurTime() + self.FootStepTimeWalk
				return
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if self:GetClass() == "npc_vj_con_zfemale" then
		self.Model = {
			"models/cpthazama/contagion/zombies/common_zombie_female_a_t.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_female_b_t.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_female_c_t.mdl"
		}
		if math.random(1,10) == 1 then
			self.AdvancedStrain = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CustomOnInitialize()
	self:SetBodygroup(0,math.random(0,1))
	self:SetBodygroup(1,math.random(0,2))
	self:SetBodygroup(2,math.random(0,3))
	self:SetSkin(math.random(0,2))
	if self.AdvancedStrain then
		self:SetSuperStrain(100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSuperStrain(hp)
	self:SetHealth(hp)
	self:SetMaxHealth(hp)
	self.AnimTbl_Walk = {ACT_WALK_AIM}
	self.AnimTbl_Run = {ACT_RUN_AIM}
	self.MeleeAttackDamage = self.MeleeAttackDamage +10
	self.MaxJumpLegalDistance = VJ_Set(0,600)
	self.LegHealth = hp /2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(16,16,70),Vector(-16,-16,0))
	self:Zombie_CustomOnInitialize()
	self.WalkAnim = self.AnimTbl_Walk[1]
	self.RunAnim = self.AnimTbl_Run[1]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Cripple()
	self:SetHullType(HULL_TINY)
	self:SetCollisionBounds(Vector(16,16,20),Vector(-16,-16,0))
	self.AnimTbl_IdleStand = {ACT_IDLE_STIMULATED}
	self.AnimTbl_Walk = {ACT_WALK_STIMULATED}
	self.AnimTbl_Run = {ACT_WALK_STIMULATED}
	self.MeleeAttackDamage = self.MeleeAttackDamage /2
	self.MaxJumpLegalDistance = VJ_Set(0,0)
	self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
	self.MeleeAttackAnimationAllowOtherTasks = false
	self.Stumbled = false
	self.CanFlinch = 0
	self.HasDeathAnimation = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if hitgroup == 1 then
		dmginfo:SetDamage(self:Health())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if !self.Crippled then
		local legs = {6,7,10,11}
		if VJ_HasValue(legs,hitgroup) then
			self.LegHealth = self.LegHealth -dmginfo:GetDamage()
			if self.LegHealth <= 0 then
				self.Crippled = true
				local anim = ACT_FLINCH_CHEST
				if hitgroup == 6 || hitgroup == 10 then
					anim = ACT_FLINCH_LEFTLEG
				elseif hitgroup == 7 || hitgroup == 11 then
					anim = ACT_FLINCH_RIGHTLEG
				end
				if math.random(1,4) == 1 then anim = ACT_FLINCH_CHEST end
				self:VJ_ACT_PLAYACTIVITY(anim,true,false,true)
				self:Cripple()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Crouch(bCrouch)
	if bCrouch then
		self:SetHullType(HULL_TINY)
		self:SetCollisionBounds(Vector(12,12,35),Vector(-16,-16,0))
		self.AnimTbl_IdleStand = {VJ_SequenceToActivity(self,"crouch_idle2013")}
		self.AnimTbl_Walk = {VJ_SequenceToActivity(self,"crouch_walk_2013")}
		self.AnimTbl_Run = {VJ_SequenceToActivity(self,"crouch_walk_2013")}
	else
		self:SetHullType(HULL_HUMAN)
		self:SetCollisionBounds(Vector(16,16,70),Vector(-16,-16,0))
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self.AnimTbl_Walk = {self.WalkAnim}
		self.AnimTbl_Run = {self.RunAnim}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.VJ_IsBeingControlled == true then
		if self.VJ_TheController:KeyDown(IN_JUMP) then
			if self:IsOnGround() then
				self:SetVelocity(self:GetUp()*200 + self:GetForward()*650)
				self:VJ_ACT_PLAYACTIVITY("jump",true,0.7,false)	   
            end			
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIsJumpLegal(startPos,apex,endPos)
	if self.VJ_IsBeingControlled == true then
		return false
	else
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply)
    ply:ChatPrint("C: Jump")
	
if !self.Crippled && self.AdvancedStrain then	
	ply:ChatPrint("C: Crouch")
end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
		if IsValid(self:GetEnemy()) then 	
			self.AnimTbl_IdleStand = {"idle_unable_to_reach_01","idle_unable_to_reach_02"}
end

	if !self.Crippled && self.AdvancedStrain then
		if IsValid(self:GetEnemy()) && self:GetEnemy():IsPlayer() then
			if IsValid(self:GetBlockingEntity()) || (self:GetEnemy():GetPos():Distance(self:GetPos()) <= 350 && self:GetEnemy():Crouching()) then
				self:Crouch(true)
			else
				self:Crouch(false)
			end
		else
			self:Crouch(false)
		end
		
	if self.VJ_IsBeingControlled then
	   if self.VJ_TheController:KeyDown(IN_DUCK) then	
	      if !self.Crippled && self.AdvancedStrain then
				self:Crouch(true)
self.VJC_Data = {
	CameraMode = 1, 
	ThirdP_Offset = Vector(45, 20, -15), 
	FirstP_Bone = "ValveBiped.Bip01_Head1", 
	FirstP_Offset = Vector(10, -3, -25), 
}
			else
				self:Crouch(false)
			end
		else
			self:Crouch(false)
self.VJC_Data = {
	CameraMode = 1, 
	ThirdP_Offset = Vector(40, 20, -50), 
	FirstP_Bone = "ValveBiped.Bip01_Head1",
	FirstP_Offset = Vector(0, 0, 5), 
}			
		end
	end
end

	if self.Zombie_AllowClimbing == true && self.Dead == false && self.Zombie_Climbing == false && CurTime() > self.Zombie_NextClimb then
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
					anim = VJ_PICKRANDOMTABLE({"vjseq_climb144_00_inplace","vjseq_climb144_00a_inplace","vjseq_climb144_01_inplace","vjseq_climb144_03_inplace","vjseq_climb144_03a_inplace","vjseq_climb144_04_inplace"})
					finalpos = tr5.HitPos
				end
			elseif IsValid(tr4.Entity) then
				anim = VJ_PICKRANDOMTABLE({"vjseq_climb120_00_inplace","vjseq_climb120_00a_inplace","vjseq_climb120_01_inplace","vjseq_climb120_03_inplace","vjseq_climb120_03a_inplace","vjseq_climb120_04_inplace"})
				finalpos = tr4.HitPos
			elseif IsValid(tr3.Entity) then
				anim = VJ_PICKRANDOMTABLE({"vjseq_climb96_00_inplace","vjseq_climb96_00a_inplace","vjseq_climb96_03_inplace","vjseq_climb96_03a_inplace","vjseq_climb96_04a_inplace","vjseq_climb96_05_inplace"})
				finalpos = tr3.HitPos
			elseif IsValid(tr2.Entity) then
				anim = VJ_PICKRANDOMTABLE({"vjseq_climb72_03_inplace","vjseq_climb72_04_inplace","vjseq_climb72_05_inplace","vjseq_climb72_06_inplace","vjseq_climb72_07_inplace"})
				finalpos = tr2.HitPos
			elseif IsValid(tr1.Entity) then
				anim = VJ_PICKRANDOMTABLE({"vjseq_climb48_01_inplace","vjseq_climb48_02_inplace","vjseq_climb48_03_inplace","vjseq_climb48_04_inplace"})
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSightDirection()
	return self:GetAttachment(self:LookupAttachment("eyes")).Ang:Forward() -- Attachment example
end
-------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup)
	if self:IsMoving() then -- When moving
	   self.AnimTbl_Death = {"vjseq_death2013_run_01","vjseq_death2013_run_02","vjseq_death2013_run_03"}	
end
    if dmginfo:IsDamageType(DMG_BUCKSHOT) then -- When killed by shotgun damage
       self.AnimTbl_Death = {"vjseq_death2013_shotgun_backward","vjseq_death2013_shotgun_forward"}	
end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/