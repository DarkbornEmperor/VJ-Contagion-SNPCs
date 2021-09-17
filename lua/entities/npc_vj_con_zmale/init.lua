AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 175
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} 
ENT.BloodColor = "Red" 
ENT.CustomBlood_Decal = {"VJ_CON_Blood"} 
ENT.HasBloodPool = false
//ENT.TurningSpeed = 5
ENT.PoseParameterLooking_Names = {pitch={"body_pitch"}, yaw={"body_yaw"}, roll={}} 
ENT.HasMeleeAttack = true 
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackAnimationAllowOtherTasks = true 
ENT.TimeUntilMeleeAttackDamage = false 
ENT.HasExtraMeleeAttackSounds = true
ENT.SlowPlayerOnMeleeAttack = true 
ENT.SlowPlayerOnMeleeAttackTime = 0.5 
ENT.DisableFootStepSoundTimer = true 
ENT.HasMeleeAttackSlowPlayerSound = false 
//ENT.MaxJumpLegalDistance = VJ_Set(0,300)
	-- ====== Controller Data ====== --
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(40, 25, -50), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
}
	-- ====== Flinching Code ====== --
//ENT.AnimTbl_Flinch = {}
ENT.CanFlinch = 1 
ENT.FlinchChance = 12
//ENT.NextMoveAfterFlinchTime = false 
ENT.HasHitGroupFlinching = true
ENT.HitGroupFlinching_DefaultWhenNotHit = false 
ENT.HitGroupFlinching_Values = {
{HitGroup = {HITGROUP_HEAD}, Animation = {"vjges_injured_head2020_01","vjges_injured_head2020_02","vjges_injured_head2020_03","vjges_injured_head2020_04"}},
{HitGroup = {HITGROUP_CHEST}, Animation = {"shoved_forward1","shoved_backwards1","shoved_backwards2","shoved_backwards3"}},
{HitGroup = {HITGROUP_STOMACH}, Animation = {"shoved_forward1","shoved_backwards1","shoved_backwards2","shoved_backwards3"}},
{HitGroup = {HITGROUP_RIGHTARM}, Animation = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}},
{HitGroup = {HITGROUP_LEfTARM}, Animation = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}},
{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}},
{HitGroup = {HITGROUP_LEFTLEG}, Animation = {"vjges_injured2013_01","vjges_injured2013_02","vjges_injured2013_03","vjges_injured2013_04","vjges_injured2013_05","vjges_injured2013_06"}}
}
	-- ====== Death Animation Variables ====== --
ENT.HasDeathAnimation = true
ENT.DeathAnimationChance = 2
ENT.AnimTbl_Death = {"vjseq_death2013_01","vjseq_death2013_02","vjseq_death2013_03","vjseq_death2013_04"} 
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_MeleeAttackExtra = {
"vj_contagion/z_hit-01.wav",
"vj_contagion/z_hit-02.wav",
"vj_contagion/z_hit-03.wav",
"vj_contagion/z_hit-04.wav",
"vj_contagion/z_hit-05.wav",
"vj_contagion/z_hit-06.wav"
}
ENT.SoundTbl_MeleeAttackMiss = {
"vj_contagion/z-swipe-1.wav",
"vj_contagion/z-swipe-2.wav",
"vj_contagion/z-swipe-3.wav",
"vj_contagion/z-swipe-4.wav",
"vj_contagion/z-swipe-5.wav",
"vj_contagion/z-swipe-6.wav"
}
ENT.GeneralSoundPitch1 = 100
-- Custom
ENT.Zombie_Climbing = false
ENT.Zombie_NextClimb = 0
ENT.Zombie_AllowClimbing = false
ENT.Zombie_NextStumbleT = 0
ENT.Zombie_CurAnims = -1 -- 0 = Normal | 1 = Blended
ENT.Zombie_ControllerAnim = 0
ENT.Zombie_AdvancedStrain = false
ENT.Zombie_LegHealth = 28
ENT.Zombie_Crippled = false
ENT.Zombie_Gender = 0 -- 0 = Male | 1 = Female
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if self:GetClass() == "npc_vj_con_zmale" then
		self.Model = {
			"models/cpthazama/contagion/zombies/common_zombie_a_c.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_a_f.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_a_h.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_a_t.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_b_c.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_b_f.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_b_h.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_b_t.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_c_c.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_c_f.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_c_h.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_c_t.mdl"
}
	elseif self:GetClass() == "npc_vj_con_zcarrier" then
	    self.Zombie_AdvancedStrain = true
		self.Model = {
			"models/cpthazama/contagion/zombies/carrier_zombie.mdl"	
}
	elseif self:GetClass() == "npc_vj_con_zcivi" then
		self.Model = {
			"models/cpthazama/contagion/zombies/civillian_zombie.mdl"
}
	elseif self:GetClass() == "npc_vj_con_zcurtis" then
		self.Model = {
			"models/cpthazama/contagion/zombies/curtis_zombie.mdl"
}
	elseif self:GetClass() == "npc_vj_con_zdoc" then
		self.Model = {
			"models/cpthazama/contagion/zombies/doctor_zombie.mdl"
}
	elseif self:GetClass() == "npc_vj_con_zeugene" then
		self.Model = {
			"models/cpthazama/contagion/zombies/eugene_zombie.mdl"
}		
	elseif self:GetClass() == "npc_vj_con_zfemale" then
	    self.Zombie_Gender = 1
		self.Model = {
			"models/cpthazama/contagion/zombies/common_zombie_female_a_t.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_female_b_t.mdl",
			"models/cpthazama/contagion/zombies/common_zombie_female_c_t.mdl"				
}		
	elseif self:GetClass() == "npc_vj_con_zinmate" then
		self.Model = {
			"models/cpthazama/contagion/zombies/inmate_zombie01.mdl"
}		
	elseif self:GetClass() == "npc_vj_con_zjessica" then
        self.Zombie_Gender = 1	
		self.Model = {
			"models/cpthazama/contagion/zombies/jessica_zombie.mdl"			
}		
	elseif self:GetClass() == "npc_vj_con_zlooter" then
		self.Model = {
			"models/cpthazama/contagion/zombies/looter_zombie.mdl"
}		
	elseif self:GetClass() == "npc_vj_con_zmanuel" then
		self.Model = {
			"models/cpthazama/contagion/zombies/manuel_zombie.mdl"
}	
	elseif self:GetClass() == "npc_vj_con_zmarcus" then
		self.Model = {
			"models/cpthazama/contagion/zombies/marcus_zombie.mdl"
}
	elseif self:GetClass() == "npc_vj_con_zmia" then
        self.Zombie_Gender = 1	
		self.Model = {
			"models/cpthazama/contagion/zombies/mia_zombie.mdl"				
}
	elseif self:GetClass() == "npc_vj_con_zmike" then
		self.Model = {
			"models/cpthazama/contagion/zombies/mike_zombie.mdl"
}
	elseif self:GetClass() == "npc_vj_con_znick" then
		self.Model = {
			"models/cpthazama/contagion/zombies/nick_zombie.mdl"
}	
	elseif self:GetClass() == "npc_vj_con_zofficer" then
		self.Model = {
			"models/cpthazama/contagion/zombies/officer_alt.mdl",
			"models/cpthazama/contagion/zombies/officer_alt2.mdl",
			"models/cpthazama/contagion/zombies/officer_alt3.mdl",
			"models/cpthazama/contagion/zombies/officer_alt4.mdl",
			"models/cpthazama/contagion/zombies/officer_zombie.mdl",
			"models/cpthazama/contagion/zombies/officer_armor.mdl"
}	
	elseif self:GetClass() == "npc_vj_con_zriot" then
		self.Model = {
			"models/cpthazama/contagion/zombies/riot_zombie.mdl"
}	
	elseif self:GetClass() == "npc_vj_con_zriotbrute" then
		self.Model = {
			"models/cpthazama/contagion/zombies/riot_brute_zombie.mdl"
}	
	elseif self:GetClass() == "npc_vj_con_zriotsol" then
		self.Model = {
			"models/cpthazama/contagion/zombies/riot_soldier.mdl"
}
	elseif self:GetClass() == "npc_vj_con_ztony" then
		self.Model = {
			"models/cpthazama/contagion/zombies/tony_zombie.mdl"
}
	elseif self:GetClass() == "npc_vj_con_zyumi" then
	    self.Zombie_Gender = 1
		self.Model = {
			"models/cpthazama/contagion/zombies/yumi_zombie.mdl"			
}	
end
     if self.Zombie_Gender == 1 then
        self.IdleSoundPitch = VJ_Set(120, 120)
        self.CombatIdleSoundPitch = VJ_Set(120, 120)
        self.AlertSoundPitch = VJ_Set(120, 120)
        self.CallForHelpSoundPitch = VJ_Set(120, 120)
        self.BeforeMeleeAttackSoundPitch = VJ_Set(120, 120)
        self.PainSoundPitch = VJ_Set(120, 120)
        self.DeathSoundPitch = VJ_Set(120, 120)
end		
		if math.random(1,10) == 1 then
			self.Zombie_AdvancedStrain = true
    end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CustomOnInitialize()
	 if self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_a_c.mdl" then
	    self:SetBodygroup(1,math.random(0,2))
		self:SetSkin(math.random(0,7))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_a_f.mdl" then
	    self:SetHealth(200)	 	 
	    self:SetBodygroup(1,math.random(0,2))
		self:SetSkin(math.random(0,7))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_a_h.mdl" or self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_a_t.mdl" then
	    self:SetBodygroup(0,math.random(0,3))
		self:SetBodygroup(1,math.random(0,4))
		self:SetSkin(math.random(0,7))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_b_c.mdl" then
	    self:SetBodygroup(1,math.random(0,2))
		self:SetSkin(math.random(0,9))
		
	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_b_f.mdl" then
	    self:SetHealth(200)	 
	    self:SetBodygroup(1,math.random(0,2))
		self:SetSkin(math.random(0,9))		

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_b_h.mdl" or self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_b_t.mdl" then
	    self:SetBodygroup(0,math.random(0,3))
		self:SetBodygroup(1,math.random(0,4))
		self:SetSkin(math.random(0,9))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_c_c.mdl" then
	    self:SetBodygroup(1,math.random(0,2))
		self:SetSkin(math.random(0,9))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_c_f.mdl" then
	    self:SetHealth(200)
	    self:SetBodygroup(1,math.random(0,2))
		self:SetSkin(math.random(0,9))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_c_h.mdl" then
	    self:SetBodygroup(1,math.random(0,2))
		self:SetSkin(math.random(0,9))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_c_t.mdl" then
	    self:SetBodygroup(0,math.random(0,3))
		self:SetBodygroup(1,math.random(0,4))
		self:SetSkin(math.random(0,9))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_female_a_t.mdl" or self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_female_b_t.mdl" then
	   	self:SetBodygroup(0,math.random(0,1))
	    self:SetBodygroup(1,math.random(0,1))
	    self:SetBodygroup(2,math.random(0,1))
		self:SetSkin(math.random(0,2))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_female_c_t.mdl" then
	   	self:SetBodygroup(0,math.random(0,1))
	    self:SetBodygroup(1,math.random(0,2))
	    self:SetBodygroup(2,math.random(0,1))
		self:SetSkin(math.random(0,2))
		
	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/civillian_zombie.mdl" then
	    self:SetBodygroup(0,math.random(0,1))
	    self:SetSkin(math.random(0,9))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/doctor_zombie.mdl" then
	    self:SetBodygroup(0,math.random(0,1))
	    self:SetSkin(math.random(0,3))
		
	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/inmate_zombie01.mdl" then
	    self:SetBodygroup(0,math.random(0,3))
	    self:SetSkin(math.random(0,3))

	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/looter_zombie.mdl" then
	    self:SetBodygroup(2,math.random(0,4))
	    self:SetSkin(math.random(0,5))
		
	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/officer_alt.mdl" or self:GetModel() == "models/cpthazama/contagion/zombies/officer_alt2.mdl" or self:GetModel() == "models/cpthazama/contagion/zombies/officer_alt3.mdl" or self:GetModel() == "models/cpthazama/contagion/zombies/officer_alt4.mdl" or self:GetModel() == "models/cpthazama/contagion/zombies/officer_zombie.mdl" then
	    self.Riot_Helmet = false
	    self:SetSkin(math.random(0,5))
		
	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/officer_armor.mdl" then
	    self:SetSkin(math.random(0,5))
        self:SetHealth(200)
		
	 elseif self:GetModel() == "models/cpthazama/contagion/zombies/riot_soldier.mdl" then
	    self:SetBodygroup(1,math.random(0,1))		
end
	if self.Zombie_AdvancedStrain && self:GetModel() == "models/cpthazama/contagion/zombies/officer_armor.mdl" then
		self:SetSuperStrain(200)
	elseif self.Zombie_AdvancedStrain && self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_a_f.mdl" then
		self:SetSuperStrain(200)	
    elseif self.Zombie_AdvancedStrain && self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_b_f.mdl" then
		self:SetSuperStrain(200)
    elseif self.Zombie_AdvancedStrain && self:GetModel() == "models/cpthazama/contagion/zombies/common_zombie_c_f.mdl" then
		self:SetSuperStrain(200)		
	elseif self.Zombie_AdvancedStrain && self:GetModel() == "models/cpthazama/contagion/zombies/riot_soldier.mdl" then
	    self:SetSuperStrain(200)
	elseif self.Zombie_AdvancedStrain && self:GetModel() == "models/cpthazama/contagion/zombies/riot_zombie.mdl" then	
	    self:SetSuperStrain(225)
	elseif self:GetModel() == "models/cpthazama/contagion/zombies/riot_brute_zombie.mdl" then	
	    self:SetSuperStrain(300)		
	elseif self.Zombie_AdvancedStrain && self:GetModel() == "models/cpthazama/contagion/zombies/carrier_zombie.mdl" then	
	    self:SetSuperStrain(380)
	elseif self.Zombie_AdvancedStrain then
		self:SetSuperStrain(175)
		
	if GetConVarNumber("VJ_CON_AllowClimbing") == 1 then self.Zombie_AllowClimbing = true end		
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieSounds()
local voice = math.random(1,5)
if voice == 1 then
   self.SoundTbl_Idle = {"vj_contagion/build2695/z_sham/shared/0245.wav","vj_contagion/build2695/z_sham/shared/0244.wav","vj_contagion/Build2695/z_sham/idle/0128.wav","vj_contagion/Build2695/z_sham/idle/0123.wav","vj_contagion/Build2695/z_sham/idle/0122.wav","vj_contagion/Build2695/z_sham/idle/0121.wav","vj_contagion/Build2695/z_sham/idle/0120.wav","vj_contagion/Build2695/z_sham/idle/0119.wav","vj_contagion/Build2695/z_sham/idle/0118.wav","vj_contagion/Build2695/z_sham/idle/0117.wav","vj_contagion/Build2695/z_sham/idle/0116.wav","vj_contagion/Build2695/z_sham/idle/0115.wav","vj_contagion/Build2695/z_sham/idle/0114.wav","vj_contagion/Build2695/z_sham/idle/0113.wav","vj_contagion/Build2695/z_sham/idle/0112.wav","vj_contagion/Build2695/z_sham/idle/0111.wav","vj_contagion/Build2695/z_sham/idle/0110.wav","vj_contagion/Build2695/z_sham/idle/0109.wav","vj_contagion/Build2695/z_sham/idle/0108.wav","vj_contagion/Build2695/z_sham/idle/0107.wav","vj_contagion/Build2695/z_sham/idle/0106.wav","vj_contagion/Build2695/z_sham/idle/0105.wav","vj_contagion/Build2695/z_sham/idle/0104.wav","vj_contagion/Build2695/z_sham/idle/0103.wav","vj_contagion/Build2695/z_sham/idle/0102.wav","vj_contagion/Build2695/z_sham/idle/0101.wav","vj_contagion/Build2695/z_sham/idle/0100.wav","vj_contagion/Build2695/z_sham/idle/0099.wav","vj_contagion/Build2695/z_sham/idle/0098.wav","vj_contagion/Build2695/z_sham/idle/0097.wav","vj_contagion/Build2695/z_sham/idle/0096.wav","vj_contagion/Build2695/z_sham/idle/0095.wav","vj_contagion/Build2695/z_sham/idle/0094.wav","vj_contagion/Build2695/z_sham/idle/0093.wav","vj_contagion/Build2695/z_sham/idle/0092.wav","vj_contagion/Build2695/z_sham/idle/0091.wav","vj_contagion/Build2695/z_sham/idle/0090.wav","vj_contagion/Build2695/z_sham/idle/0089.wav","vj_contagion/Build2695/z_sham/idle/0088.wav","vj_contagion/Build2695/z_sham/idle/0087.wav","vj_contagion/Build2695/z_sham/idle/0086.wav","vj_contagion/Build2695/z_sham/idle/0085.wav","vj_contagion/Build2695/z_sham/idle/0084.wav","vj_contagion/Build2695/z_sham/idle/0083.wav","vj_contagion/Build2695/z_sham/idle/0082.wav","vj_contagion/Build2695/z_sham/idle/0081.wav","vj_contagion/Build2695/z_sham/idle/0080.wav","vj_contagion/Build2695/z_sham/idle/0079.wav","vj_contagion/Build2695/z_sham/idle/0077.wav","vj_contagion/Build2695/z_sham/idle/0076.wav"}
   self.SoundTbl_Alert = {"vj_contagion/Build2695/z_sham/alert/0170.wav","vj_contagion/Build2695/z_sham/alert/0169.wav","vj_contagion/Build2695/z_sham/alert/0168.wav","vj_contagion/Build2695/z_sham/alert/0167.wav","vj_contagion/Build2695/z_sham/alert/0166.wav","vj_contagion/Build2695/z_sham/alert/0165.wav","vj_contagion/Build2695/z_sham/alert/0164.wav","vj_contagion/Build2695/z_sham/alert/0163.wav","vj_contagion/Build2695/z_sham/alert/0162.wav","vj_contagion/Build2695/z_sham/alert/0161.wav","vj_contagion/Build2695/z_sham/alert/0152.wav","vj_contagion/Build2695/z_sham/alert/0061.wav","vj_contagion/Build2695/z_sham/alert/0060.wav","vj_contagion/Build2695/z_sham/alert/0058.wav","vj_contagion/Build2695/z_sham/alert/0056.wav","vj_contagion/Build2695/z_sham/alert/0030.wav","vj_contagion/Build2695/z_sham/alert/0029.wav","vj_contagion/Build2695/z_sham/alert/0028.wav","vj_contagion/Build2695/z_sham/alert/0027.wav","vj_contagion/Build2695/z_sham/alert/0026.wav","vj_contagion/Build2695/z_sham/alert/0025.wav","vj_contagion/Build2695/z_sham/alert/0023.wav","vj_contagion/Build2695/z_sham/alert/0022.wav","vj_contagion/Build2695/z_sham/alert/0021.wav","vj_contagion/Build2695/z_arne/alert/0207.wav"}
   self.SoundTbl_CallForHelp = {"vj_contagion/Build2695/z_sham/roar/0075.wav","vj_contagion/Build2695/z_sham/roar/0074.wav","vj_contagion/Build2695/z_sham/roar/0073.wav","vj_contagion/Build2695/z_sham/roar/0072.wav","vj_contagion/Build2695/z_sham/roar/0071.wav","vj_contagion/Build2695/z_sham/roar/0070.wav"}
   self.SoundTbl_CombatIdle = {"vj_contagion/Build2695/z_sham/spot_player/0178.wav","vj_contagion/Build2695/z_sham/spot_player/0173.wav","vj_contagion/Build2695/z_sham/spot_player/0159.wav","vj_contagion/Build2695/z_sham/spot_player/0158.wav","vj_contagion/Build2695/z_sham/spot_player/0157.wav","vj_contagion/Build2695/z_sham/spot_player/0156.wav","vj_contagion/Build2695/z_sham/spot_player/0155.wav","vj_contagion/Build2695/z_sham/spot_player/0153.wav","vj_contagion/Build2695/z_sham/spot_player/0145.wav","vj_contagion/Build2695/z_sham/spot_player/0134.wav","vj_contagion/Build2695/z_sham/spot_player/0059.wav","vj_contagion/Build2695/z_sham/spot_player/0055.wav","vj_contagion/Build2695/z_sham/spot_player/0054.wav","vj_contagion/Build2695/z_sham/spot_player/0018.wav","vj_contagion/Build2695/z_sham/spot_player/0017.wav","vj_contagion/Build2695/z_sham/spot_player/0016.wav","vj_contagion/Build2695/z_sham/spot_player/0015.wav","vj_contagion/Build2695/z_sham/spot_player/0014.wav","","vj_contagion/Build2695/z_sham/spot_player/0013.wav","vj_contagion/Build2695/z_sham/spot_player/0003.wav","vj_contagion/Build2695/z_sham/spot_player/0002.wav","vj_contagion/Build2695/z_sham/spot_player/0001.wav"}
   self.SoundTbl_BeforeMeleeAttack = {"vj_contagion/Build2695/z_sham/attacking/0053.wav","vj_contagion/Build2695/z_sham/attacking/0052.wav","vj_contagion/Build2695/z_sham/attacking/0051.wav","vj_contagion/Build2695/z_sham/attacking/0050.wav","vj_contagion/Build2695/z_sham/attacking/0049.wav","vj_contagion/Build2695/z_sham/attacking/0048.wav","vj_contagion/Build2695/z_sham/attacking/0047.wav","vj_contagion/Build2695/z_sham/attacking/0045.wav","vj_contagion/Build2695/z_sham/attacking/0044.wav","vj_contagion/Build2695/z_sham/attacking/0043.wav","vj_contagion/Build2695/z_sham/attacking/0042.wav","vj_contagion/Build2695/z_sham/attacking/0041.wav","vj_contagion/Build2695/z_sham/attacking/0040.wav","vj_contagion/Build2695/z_sham/attacking/0039.wav","vj_contagion/Build2695/z_sham/attacking/0038.wav","vj_contagion/Build2695/z_sham/attacking/0037.wav","vj_contagion/Build2695/z_sham/attacking/0036.wav","vj_contagion/Build2695/z_sham/attacking/0034.wav","vj_contagion/Build2695/z_sham/attacking/0033.wav"}
   self.SoundTbl_Pain = {"vj_contagion/build2695/z_sham/shared/0187.wav","vj_contagion/build2695/z_sham/shared/0186.wav","vj_contagion/build2695/z_sham/shared/0185.wav","vj_contagion/build2695/z_sham/shared/0184.wav","vj_contagion/build2695/z_sham/shared/0183.wav","vj_contagion/build2695/z_sham/shared/0182.wav","vj_contagion/build2695/z_sham/shared/0181.wav","vj_contagion/build2695/z_sham/shared/0180.wav","vj_contagion/build2695/z_sham/shared/0179.wav","vj_contagion/build2695/z_sham/shared/0177.wav","vj_contagion/build2695/z_sham/shared/0176.wav","vj_contagion/build2695/z_sham/shared/0175.wav","vj_contagion/build2695/z_sham/shared/0174.wav","vj_contagion/build2695/z_sham/shared/0174.wav"}
   self.SoundTbl_Death = {"vj_contagion/Build2695/z_sham/death/0032.wav"}

elseif voice == 2 then
   self.SoundTbl_Idle = {"vj_contagion/Build2695/z_arne/idle/0219.wav","vj_contagion/Build2695/z_arne/idle/0220.wav","vj_contagion/Build2695/z_arne/idle/0221.wav","vj_contagion/Build2695/z_arne/idle/0243.wav","vj_contagion/Build2695/z_arne/idle/0246.wav","vj_contagion/Build2695/z_arne/idle/0247.wav","vj_contagion/Build2695/z_arne/idle/0248.wav","vj_contagion/Build2695/z_arne/idle/0249.wav","vj_contagion/Build2695/z_arne/idle/0250.wav","vj_contagion/Build2695/z_arne/idle/0251.wav","vj_contagion/Build2695/z_arne/idle/0252.wav","vj_contagion/Build2695/z_arne/idle/0253.wav","vj_contagion/Build2695/z_arne/idle/0254.wav","vj_contagion/Build2695/z_arne/idle/0255.wav"}
   self.SoundTbl_Alert = {"vj_contagion/Build2695/z_arne/alert/0208.wav","vj_contagion/Build2695/z_arne/alert/0209.wav","vj_contagion/Build2695/z_arne/alert/0210.wav","vj_contagion/Build2695/z_arne/alert/0211.wav","vj_contagion/Build2695/z_arne/alert/0212.wav","vj_contagion/Build2695/z_arne/alert/0213.wav","vj_contagion/Build2695/z_arne/alert/0214.wav","vj_contagion/Build2695/z_arne/alert/0215.wav","vj_contagion/Build2695/z_arne/alert/0216.wav","vj_contagion/Build2695/z_arne/alert/0217.wav","vj_contagion/Build2695/z_arne/alert/0218.wav"}
   self.SoundTbl_CallForHelp = {"vj_contagion/Build2695/z_arne/alert/0208.wav","vj_contagion/Build2695/z_arne/alert/0209.wav","vj_contagion/Build2695/z_arne/alert/0210.wav","vj_contagion/Build2695/z_arne/alert/0211.wav","vj_contagion/Build2695/z_arne/alert/0212.wav","vj_contagion/Build2695/z_arne/alert/0213.wav","vj_contagion/Build2695/z_arne/alert/0214.wav","vj_contagion/Build2695/z_arne/alert/0215.wav","vj_contagion/Build2695/z_arne/alert/0216.wav","vj_contagion/Build2695/z_arne/alert/0217.wav","vj_contagion/Build2695/z_arne/alert/0218.wav"}
   self.SoundTbl_BeforeMeleeAttack = {"vj_contagion/Build2695/z_arne/attack/0226.wav","vj_contagion/Build2695/z_arne/attack/0227.wav","vj_contagion/Build2695/z_arne/attack/0229.wav","vj_contagion/Build2695/z_arne/attack/0231.wav","vj_contagion/Build2695/z_arne/attack/0233.wav","vj_contagion/Build2695/z_arne/attack/0234.wav","vj_contagion/Build2695/z_arne/attack/0235.wav","vj_contagion/Build2695/z_arne/attack/0236.wav","vj_contagion/Build2695/z_arne/attack/0238.wav","vj_contagion/Build2695/z_arne/attack/0239.wav","vj_contagion/Build2695/z_arne/attack/0240.wav","vj_contagion/Build2695/z_arne/attack/0241.wav","vj_contagion/Build2695/z_arne/attack/0256.wav"}
   self.SoundTbl_Pain = {"vj_contagion/Build2695/z_sham/pain/0148.wav","vj_contagion/Build2695/z_sham/pain/0149.wav","vj_contagion/Build2695/z_sham/pain/0147.wav","vj_contagion/Build2695/z_sham/pain/0146.wav","vj_contagion/Build2695/z_sham/pain/0143.wav","vj_contagion/Build2695/z_sham/pain/0141.wav","vj_contagion/Build2695/z_sham/pain/0140.wav","vj_contagion/Build2695/z_sham/pain/0139.wav","vj_contagion/Build2695/z_sham/pain/0138.wav","vj_contagion/Build2695/z_sham/pain/0137.wav","vj_contagion/Build2695/z_sham/pain/0136.wav","vj_contagion/Build2695/z_sham/pain/0135.wav","vj_contagion/Build2695/z_sham/pain/0133.wav","vj_contagion/Build2695/z_sham/pain/0132.wav","vj_contagion/Build2695/z_sham/pain/0131.wav","vj_contagion/Build2695/z_sham/pain/0130.wav","vj_contagion/Build2695/z_sham/pain/0129.wav","vj_contagion/Build2695/z_sham/pain/0127.wav","vj_contagion/Build2695/z_sham/pain/0126.wav","vj_contagion/Build2695/z_sham/pain/0125.wav","vj_contagion/Build2695/z_sham/pain/0124.wav","vj_contagion/Build2695/z_sham/pain/0069.wav","vj_contagion/Build2695/z_sham/pain/0066.wav","vj_contagion/Build2695/z_sham/pain/0065.wav","vj_contagion/Build2695/z_sham/pain/0064.wav","vj_contagion/Build2695/z_sham/pain/0063.wav","vj_contagion/Build2695/z_sham/pain/0062.wav"}
   self.SoundTbl_Death = {"vj_contagion/Build2695/z_arne/die/0223.wav","vj_contagion/Build2695/z_arne/die/0224.wav","vj_contagion/Build2695/z_arne/die/0225.wav"}

elseif voice == 3 then
   self.SoundTbl_Idle = {"vj_contagion/contagionvr/growler/zombie_voice_shared-1.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-10.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-12.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-13.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-14.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-2.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-3.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-4.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-5.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-6.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-7.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-8.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-9.wav"}
   self.SoundTbl_Alert = {"vj_contagion/contagionvr/growler/zombie_voice_alert-1.wav","vj_contagion/contagionvr/growler/zombie_voice_alert-2.wav","vj_contagion/contagionvr/growler/zombie_voice_alert-3.wav","vj_contagion/contagionvr/growler/zombie_voice_alert-4.wav"}
   self.SoundTbl_CallForHelp = {"vj_contagion/contagionvr/growler/zombie_voice_alert-1.wav","vj_contagion/contagionvr/growler/zombie_voice_alert-2.wav","vj_contagion/contagionvr/growler/zombie_voice_alert-3.wav","vj_contagion/contagionvr/growler/zombie_voice_alert-4.wav"}
   self.SoundTbl_BeforeMeleeAttack = {"vj_contagion/contagionvr/growler/zombie_voice_shared-1.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-10.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-12.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-13.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-14.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-2.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-3.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-4.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-5.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-6.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-7.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-8.wav","vj_contagion/contagionvr/growler/zombie_voice_shared-9.wav"}
   self.SoundTbl_Pain = {"vj_contagion/Build2695/z_sham/pain/0148.wav","vj_contagion/Build2695/z_sham/pain/0149.wav","vj_contagion/Build2695/z_sham/pain/0147.wav","vj_contagion/Build2695/z_sham/pain/0146.wav","vj_contagion/Build2695/z_sham/pain/0143.wav","vj_contagion/Build2695/z_sham/pain/0141.wav","vj_contagion/Build2695/z_sham/pain/0140.wav","vj_contagion/Build2695/z_sham/pain/0139.wav","vj_contagion/Build2695/z_sham/pain/0138.wav","vj_contagion/Build2695/z_sham/pain/0137.wav","vj_contagion/Build2695/z_sham/pain/0136.wav","vj_contagion/Build2695/z_sham/pain/0135.wav","vj_contagion/Build2695/z_sham/pain/0133.wav","vj_contagion/Build2695/z_sham/pain/0132.wav","vj_contagion/Build2695/z_sham/pain/0131.wav","vj_contagion/Build2695/z_sham/pain/0130.wav","vj_contagion/Build2695/z_sham/pain/0129.wav","vj_contagion/Build2695/z_sham/pain/0127.wav","vj_contagion/Build2695/z_sham/pain/0126.wav","vj_contagion/Build2695/z_sham/pain/0125.wav","vj_contagion/Build2695/z_sham/pain/0124.wav","vj_contagion/Build2695/z_sham/pain/0069.wav","vj_contagion/Build2695/z_sham/pain/0066.wav","vj_contagion/Build2695/z_sham/pain/0065.wav","vj_contagion/Build2695/z_sham/pain/0064.wav","vj_contagion/Build2695/z_sham/pain/0063.wav","vj_contagion/Build2695/z_sham/pain/0062.wav"}
   self.SoundTbl_Death = {"vj_contagion/Build2695/z_arne/die/0223.wav","vj_contagion/Build2695/z_arne/die/0224.wav","vj_contagion/Build2695/z_arne/die/0225.wav"}

elseif voice == 4 then
   self.SoundTbl_Idle = {"vj_contagion/contagionvr/oldman/zombie_voice_shared-1.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-2.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-3.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-4.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-5.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-6.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-7.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-8.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-9.wav"}
   self.SoundTbl_Alert = {"vj_contagion/contagionvr/oldman/zombie_voice_shared-1.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-2.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-3.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-4.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-5.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-6.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-7.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-8.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-9.wav"}
   self.SoundTbl_CallForHelp = {"vj_contagion/contagionvr/oldman/zombie_voice_shared-1.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-2.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-3.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-4.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-5.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-6.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-7.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-8.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-9.wav"}
   self.SoundTbl_BeforeMeleeAttack = {"vj_contagion/contagionvr/oldman/zombie_voice_shared-1.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-2.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-3.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-4.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-5.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-6.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-7.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-8.wav","vj_contagion/contagionvr/oldman/zombie_voice_shared-9.wav"}
   self.SoundTbl_Pain = {"vj_contagion/Build2695/z_sham/pain/0148.wav","vj_contagion/Build2695/z_sham/pain/0149.wav","vj_contagion/Build2695/z_sham/pain/0147.wav","vj_contagion/Build2695/z_sham/pain/0146.wav","vj_contagion/Build2695/z_sham/pain/0143.wav","vj_contagion/Build2695/z_sham/pain/0141.wav","vj_contagion/Build2695/z_sham/pain/0140.wav","vj_contagion/Build2695/z_sham/pain/0139.wav","vj_contagion/Build2695/z_sham/pain/0138.wav","vj_contagion/Build2695/z_sham/pain/0137.wav","vj_contagion/Build2695/z_sham/pain/0136.wav","vj_contagion/Build2695/z_sham/pain/0135.wav","vj_contagion/Build2695/z_sham/pain/0133.wav","vj_contagion/Build2695/z_sham/pain/0132.wav","vj_contagion/Build2695/z_sham/pain/0131.wav","vj_contagion/Build2695/z_sham/pain/0130.wav","vj_contagion/Build2695/z_sham/pain/0129.wav","vj_contagion/Build2695/z_sham/pain/0127.wav","vj_contagion/Build2695/z_sham/pain/0126.wav","vj_contagion/Build2695/z_sham/pain/0125.wav","vj_contagion/Build2695/z_sham/pain/0124.wav","vj_contagion/Build2695/z_sham/pain/0069.wav","vj_contagion/Build2695/z_sham/pain/0066.wav","vj_contagion/Build2695/z_sham/pain/0065.wav","vj_contagion/Build2695/z_sham/pain/0064.wav","vj_contagion/Build2695/z_sham/pain/0063.wav","vj_contagion/Build2695/z_sham/pain/0062.wav"}
   self.SoundTbl_Death = {"vj_contagion/Build2695/z_arne/die/0222.wav","vj_contagion/Build2695/z_arne/die/0223.wav","vj_contagion/Build2695/z_arne/die/0224.wav","vj_contagion/Build2695/z_arne/die/0225.wav"}

elseif voice == 5 then
   self.SoundTbl_Idle = {"vj_contagion/contagionvr/screamer/idle-1.wav","vj_contagion/contagionvr/screamer/idle-1.wav","vj_contagion/contagionvr/screamer/idle-1.wav","vj_contagion/contagionvr/screamer/idle-3.wav","vj_contagion/contagionvr/screamer/idle-3.wav","vj_contagion/contagionvr/screamer/idle-3.wav","vj_contagion/contagionvr/screamer/idle-2.wav"}
   self.SoundTbl_Alert = {"vj_contagion/contagionvr/screamer/alert-1.wav","vj_contagion/contagionvr/screamer/alert-2.wav"}
   self.SoundTbl_CallForHelp = {"vj_contagion/contagionvr/screamer/idle-2.wav"}
   self.SoundTbl_BeforeMeleeAttack = {"vj_contagion/contagionvr/screamer/idle-1.wav","vj_contagion/contagionvr/screamer/idle-1.wav","vj_contagion/contagionvr/screamer/idle-1.wav","vj_contagion/contagionvr/screamer/idle-3.wav","vj_contagion/contagionvr/screamer/idle-3.wav","vj_contagion/contagionvr/screamer/idle-3.wav","vj_contagion/contagionvr/screamer/idle-2.wav"}
   self.SoundTbl_Pain = {"vj_contagion/Build2695/z_sham/pain/0148.wav","vj_contagion/Build2695/z_sham/pain/0149.wav","vj_contagion/Build2695/z_sham/pain/0147.wav","vj_contagion/Build2695/z_sham/pain/0146.wav","vj_contagion/Build2695/z_sham/pain/0143.wav","vj_contagion/Build2695/z_sham/pain/0141.wav","vj_contagion/Build2695/z_sham/pain/0140.wav","vj_contagion/Build2695/z_sham/pain/0139.wav","vj_contagion/Build2695/z_sham/pain/0138.wav","vj_contagion/Build2695/z_sham/pain/0137.wav","vj_contagion/Build2695/z_sham/pain/0136.wav","vj_contagion/Build2695/z_sham/pain/0135.wav","vj_contagion/Build2695/z_sham/pain/0133.wav","vj_contagion/Build2695/z_sham/pain/0132.wav","vj_contagion/Build2695/z_sham/pain/0131.wav","vj_contagion/Build2695/z_sham/pain/0130.wav","vj_contagion/Build2695/z_sham/pain/0129.wav","vj_contagion/Build2695/z_sham/pain/0127.wav","vj_contagion/Build2695/z_sham/pain/0126.wav","vj_contagion/Build2695/z_sham/pain/0125.wav","vj_contagion/Build2695/z_sham/pain/0124.wav","vj_contagion/Build2695/z_sham/pain/0069.wav","vj_contagion/Build2695/z_sham/pain/0066.wav","vj_contagion/Build2695/z_sham/pain/0065.wav","vj_contagion/Build2695/z_sham/pain/0064.wav","vj_contagion/Build2695/z_sham/pain/0063.wav","vj_contagion/Build2695/z_sham/pain/0062.wav"}
   self.SoundTbl_Death = {"vj_contagion/Build2695/z_arne/die/0222.wav","vj_contagion/Build2695/z_arne/die/0223.wav","vj_contagion/Build2695/z_arne/die/0224.wav","vj_contagion/Build2695/z_arne/die/0225.wav"}
    end
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSuperStrain(hp)
	self:SetHealth(hp)
	self:SetMaxHealth(hp)
	self.AnimTbl_IdleStand = {ACT_IDLE_RELAXED}
	self.AnimTbl_Walk = {ACT_WALK_AIM}
	self.AnimTbl_Run = {ACT_RUN_AIM}
	self.MeleeAttackDamage = self.MeleeAttackDamage +11
	//self.MaxJumpLegalDistance = VJ_Set(0,600)
	self.Zombie_LegHealth = hp /2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(14,14,72),Vector(-14,-14,0))
	self:Zombie_CustomOnInitialize()
	self:ZombieSounds()
	self.IdleAnim = self.AnimTbl_IdleStand[1]
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
	if key == "body_hit" then
		VJ_EmitSound(self, "physics/flesh/flesh_impact_hard"..math.random(1,5)..".wav", 70, 100)
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSightDirection()
	return self:GetAttachment(self:LookupAttachment("eyes")).Ang:Forward() 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
    if self.VJ_IsBeingControlled or self.Zombie_Crippled or self.Zombie_AdvancedStrain then return end
	local AlertAnim = math.random(1,2)
    if AlertAnim == 1 && math.random(1,3) == 1 then
	    self:VJ_ACT_PLAYACTIVITY("idle2013_facearound_01",true,math.Rand(1.5,3),true)
    elseif AlertAnim == 2 && math.random(1,3) == 1 then
	    self:VJ_ACT_PLAYACTIVITY("idle2013_facearound_02",true,math.Rand(1.5,3),true)		
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally)
    if self.VJ_IsBeingControlled or self.Zombie_Crippled then return end
	if self.Zombie_AdvancedStrain then
		self:VJ_ACT_PLAYACTIVITY("vjseq_zombie_grapple_roar1",true,false,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
     if self.Zombie_Crippled then return end
     if !self.Zombie_AdvancedStrain && !self:IsMoving() && !self.VJ_IsBeingControlled then 
       self.MeleeAttackDistance = 35
       self.MeleeAttackDamageDistance = 60  	 
       self.AnimTbl_MeleeAttack = {
	   "vjseq_melee_cont_01"
}   
   elseif self.Zombie_AdvancedStrain or self.VJ_IsBeingControlled && self.Zombie_ControllerAnim == 1 then
       self.MeleeAttackDistance = 50
       self.MeleeAttackDamageDistance = 75    
       self.AnimTbl_MeleeAttack = {
	   "vjges_melee2020_player_01",
	   "vjges_melee2020_player_02",
	   "vjges_melee2020_player_03",
}           
    elseif !self.Zombie_AdvancedStrain or self.VJ_IsBeingControlled && self.Zombie_ControllerAnim == 0 then 
       self.MeleeAttackDistance = 50
       self.MeleeAttackDamageDistance = 75    	
       self.AnimTbl_MeleeAttack = {
	   "vjges_Melee2013_01",
	   "vjges_Melee2013_02",
	   "vjges_Melee2013_03",
	   "vjges_Melee2013_04",
	   "vjges_Melee2013_05",
	   "vjges_Melee2013_06",
	   "vjges_Melee2013_07",
	   "vjges_Melee2013_08",
} 	    
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_Miss()
    if self.Zombie_Crippled or self.Zombie_AdvancedStrain then return end 
    if self.MeleeAttacking == true && !self:IsMoving() then
	   self.vACT_StopAttacks = true
	   self.PlayingAttackAnimation = false
	   self:VJ_ACT_PLAYACTIVITY("idle2013_01",true,0.4,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Crouch(bCrouch)
	if bCrouch then
		self:SetHullType(HULL_TINY)
		self:SetCollisionBounds(Vector(14,14,35),Vector(-14,-14,0))
		self.AnimTbl_IdleStand = {VJ_SequenceToActivity(self,"crouch_idle2013")}
		self.AnimTbl_Walk = {VJ_SequenceToActivity(self,"crouch_walk_2013")}
		self.AnimTbl_Run = {VJ_SequenceToActivity(self,"crouch_walk_2013")}
	elseif self.VJ_IsBeingControlled && self.Zombie_CurAnims == 0 && !self:IsOnFire() && self.Zombie_ControllerAnim == 0 then	
		self:SetHullType(HULL_HUMAN)
		self:SetCollisionBounds(Vector(14,14,72),Vector(-14,-14,0))
	    self.AnimTbl_IdleStand = {self.IdleAnim}
		self.AnimTbl_Walk = {self.WalkAnim}
		self.AnimTbl_Run = {self.RunAnim}
	elseif self.VJ_IsBeingControlled && self.Zombie_CurAnims == 1 && self.Zombie_ControllerAnim == 1 or self.Zombie_AdvancedStrain then 
		self:SetHullType(HULL_HUMAN)
		self:SetCollisionBounds(Vector(14,14,72),Vector(-14,-14,0))
		self.AnimTbl_IdleStand = {ACT_IDLE_RELAXED}
		self.AnimTbl_Walk = {ACT_WALK_AIM}
		self.AnimTbl_Run = {ACT_RUN_AIM} 
   else	
 		self:SetHullType(HULL_HUMAN)
		self:SetCollisionBounds(Vector(14,14,72),Vector(-14,-14,0))  
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Jump()
	if self.VJ_IsBeingControlled then
		if self.VJ_TheController:KeyDown(IN_JUMP) then
			if self:IsOnGround() then
				self:SetVelocity(self:GetUp()*200 + self:GetForward()*400)
				self:VJ_ACT_PLAYACTIVITY("jump",true,false,false)
			end	
        end				
	end
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
  if self.Zombie_Crippled then  
	   self.Zombie_ControllerAnim = -1
   else
       self.Zombie_ControllerAnim = 0 
   end	   
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply)
    if self.Zombie_Crippled then return end
      ply:ChatPrint("RELOAD: Toggle Blend")
	  ply:ChatPrint("C: Crouch")	  
      ply:ChatPrint("SPACE: Jump")		
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
    if self.VJ_IsBeingControlled then
	   if VJ_AnimationExists(self,ACT_JUMP) == true then self:CapabilitiesRemove(bit.bor(CAP_MOVE_JUMP)) end
	   if VJ_AnimationExists(self,ACT_CLIMB_UP) == true then self:CapabilitiesRemove(bit.bor(CAP_MOVE_CLIMB)) end
	   self:Jump()
    elseif !self.VJ_IsBeingControlled then
	   if VJ_AnimationExists(self,ACT_JUMP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_JUMP)) end
	   if VJ_AnimationExists(self,ACT_CLIMB_UP) == true then self:CapabilitiesAdd(bit.bor(CAP_MOVE_CLIMB)) end	   
end	
    if self.Zombie_Crippled or self.Zombie_AdvancedStrain then return end
	if self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_RELOAD) then
		if self.Zombie_ControllerAnim == 0 then
			self.Zombie_ControllerAnim = 1
			self.VJ_TheController:ChatPrint("Blend Activated")
		else
			self.Zombie_ControllerAnim = 0
			self.VJ_TheController:ChatPrint("Blend Deactivated")
	end
end
	if self.VJ_IsBeingControlled && self.Zombie_ControllerAnim == 1 then
		if self.Zombie_CurAnims != 1 then
			self.Zombie_CurAnims = 1
			self.AnimTbl_IdleStand = {ACT_IDLE_RELAXED}
			self.AnimTbl_Walk = {ACT_WALK_AIM}
			self.AnimTbl_Run = {ACT_RUN_AIM} 			
    end
end
	if self.VJ_IsBeingControlled && self.Zombie_ControllerAnim == 0 then
		if self.Zombie_CurAnims != 0 then
			self.Zombie_CurAnims = 0
	        self.AnimTbl_IdleStand = {self.IdleAnim}
		    self.AnimTbl_Walk = {self.WalkAnim}
		    self.AnimTbl_Run = {self.RunAnim}
        end 			
    end			
end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	self:SetPoseParameter("move_x", 1)
    self:SetPoseParameter("move_y", 1) 	

    if self.Zombie_Crippled then return end	
		if IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled && !self.Zombie_AdvancedStrain then
			self.AnimTbl_IdleStand = {"idle_unable_to_reach_01","idle_unable_to_reach_02"}
	    elseif !self.VJ_IsBeingControlled && !self.Zombie_AdvancedStrain then
		    self.AnimTbl_IdleStand = {self.IdleAnim}		
end
	if self:IsOnFire() && !self.Zombie_AdvancedStrain && !self.VJ_IsBeingControlled then 
		self.AnimTbl_Walk = {ACT_RUN_AIM}
		self.AnimTbl_Run = {ACT_RUN_AIM}
	elseif !self:IsOnFire() && !self.Zombie_AdvancedStrain && !self.VJ_IsBeingControlled then
		self.AnimTbl_Walk = {self.WalkAnim}
		self.AnimTbl_Run = {self.RunAnim}		
end
		if IsValid(self:GetEnemy()) && self:GetEnemy():IsPlayer() && !self:IsOnFire() then
			if IsValid(self:GetBlockingEntity()) || (self:GetEnemy():GetPos():Distance(self:GetPos()) <= 350 && self:GetEnemy():Crouching()) then
				self:Crouch(true)
			else
				self:Crouch(false)	
	end
end	
	if self.VJ_IsBeingControlled then
	   if self.VJ_TheController:KeyDown(IN_DUCK) then	
				self:Crouch(true)
                self.VJC_Data = {
	            CameraMode = 1, 
	            ThirdP_Offset = Vector(45, 25, -15), 
	            FirstP_Bone = "ValveBiped.Bip01_Head1", 
	            FirstP_Offset = Vector(10, -3, -25), 
} 
	   elseif !self.VJ_TheController:KeyDown(IN_DUCK) then	
				self:Crouch(false)
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Cripple()
	self:SetHullType(HULL_TINY)
	self:SetCollisionBounds(Vector(14,14,20),Vector(-14,-14,0))
	self.AnimTbl_IdleStand = {ACT_IDLE_STIMULATED}
	self.AnimTbl_Walk = {ACT_WALK_STIMULATED}
	self.AnimTbl_Run = {ACT_WALK_STIMULATED}
	self.MeleeAttackDamage = self.MeleeAttackDamage /2
	self.MeleeAttackDistance = 30
	self.MeleeAttackDamageDistance = 60
	self.MaxJumpLegalDistance = VJ_Set(0,0)
	self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
	self.MeleeAttackAnimationAllowOtherTasks = false	
	self.CanFlinch = 0
    self.VJC_Data = {
	CameraMode = 1, 
	ThirdP_Offset = Vector(45, 20, -15), 
	FirstP_Bone = "ValveBiped.Bip01_Head1", 
	FirstP_Offset = Vector(10, 0, -30), 
}
	   if VJ_AnimationExists(self,ACT_JUMP) == true then self:CapabilitiesRemove(bit.bor(CAP_MOVE_JUMP)) end
	   if VJ_AnimationExists(self,ACT_CLIMB_UP) == true then self:CapabilitiesRemove(bit.bor(CAP_MOVE_CLIMB)) end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if dmginfo:IsBulletDamage() && hitgroup == 1 && GetConVarNumber("VJ_CON_Headshot") == 1 && self:GetModel() != "models/cpthazama/contagion/zombies/carrier_zombie.mdl" then
		dmginfo:SetDamage(self:Health())
end
	if self.Zombie_AdvancedStrain then
	   dmginfo:ScaleDamage(0.75)
	elseif self:GetModel() == "models/cpthazama/contagion/zombies/carrier_zombie.mdl" then
	   dmginfo:ScaleDamage(0.05)	   
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if !self.Zombie_Crippled && !self.Flinching or self:GetSequence() != self:LookupSequence("shoved_forward_heavy") then
		local legs = {6,7,10,11}
		if VJ_HasValue(legs,hitgroup) then
			self.Zombie_LegHealth = self.Zombie_LegHealth -dmginfo:GetDamage()
			if self.Zombie_LegHealth <= 0 then
				self.Zombie_Crippled = true
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
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
    if self.Zombie_Crippled then return end
    if !self.Flinching && self:IsMoving() && self.Zombie_NextStumbleT < CurTime() && math.random(1, 16) == 1 then
		self:VJ_ACT_PLAYACTIVITY("shoved_forward_heavy",true,3.4,false)
		self.Zombie_NextStumbleT = CurTime() + 10	
    end
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup)
	return self:GetSequence() != self:LookupSequence("shoved_forward_heavy") -- If we are stumbling then DO NOT flinch!
end -- Return false to disallow the flinch from playing
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	self.DeathAnimationChance = 1
	if self.Zombie_IsClimbing == true or self.Zombie_Crippled or self:GetSequence() == self:LookupSequence("shoved_forward_heavy") or dmginfo:IsExplosionDamage() then self.HasDeathAnimation = false end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup)
	if self.Zombie_Gender == 0 && self:IsMoving() then -- Male death anims when running
	   self.AnimTbl_Death = {"vjseq_death2013_run_06","vjseq_death2013_run_07","vjseq_death2012_run","vjseq_death2012_run2","vjseq_death2012_run3"}	
	   //self.DeathAnimationDecreaseLengthAmount = 0.05
	elseif self.Zombie_Gender == 1 && self:IsMoving() then -- Female death anims when running
	   self.AnimTbl_Death = {"vjseq_death2013_run_01","vjseq_death2013_run_02","vjseq_death2013_run_03"}	
	   //self.DeathAnimationDecreaseLengthAmount = 0.05	   
end
    if dmginfo:GetDamageForce():Length() > 10000 or bit.band(dmginfo:GetDamageType(), DMG_BUCKSHOT) != 0 then -- When killed by shotgun damage
       self.AnimTbl_Death = {"vjseq_death2013_shotgun_backward","vjseq_death2013_shotgun_forward"}	
    end
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
end	
---------------------------------------------------------------------------------------------------------------------------------------------
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
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/