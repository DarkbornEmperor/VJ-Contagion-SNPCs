AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.HasItemDropsOnDeath = true 
ENT.ItemDropsOnDeathChance = 1
ENT.ItemDropsOnDeath_EntityList = {"item_ammo_ar2","item_ammo_pistol","item_ammo_357","item_ammo_smg1","item_box_buckshot","item_ammo_crossbow","item_rpg_round","item_ammo_357"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if self:GetClass() == "npc_vj_con_zlooter" then
		self.Model = {
			"models/cpthazama/contagion/zombies/looter_zombie.mdl"
		}
		if math.random(1,10) == 1 then
			self.AdvancedStrain = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CustomOnInitialize()
	self:SetBodygroup(0,math.random(0,4))
	self:SetSkin(math.random(0,5))
	if self.AdvancedStrain then
		self:SetSuperStrain(100)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/