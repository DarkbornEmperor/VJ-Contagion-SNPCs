AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
     if math.random (1,16) == 1 && self.Stumbled == true then
		 if self.Zombie_NextStumble < CurTime() && self:IsMoving() then
			self:VJ_ACT_PLAYACTIVITY("shoved_forward_heavy",true,3.4,false)
			self.Zombie_NextStumble = CurTime() + 10	
	end
end
     if math.random (1,16) == 1 && self.Stumbled == true then
		 if self.Zombie_NextStumble2 < CurTime() && self:IsMoving() then
			self:VJ_ACT_PLAYACTIVITY("shoved_backwards_heavy",true,3.5,false)
			self.Zombie_NextStumble2 = CurTime() + 10	
	    end
    end		
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup)
	return self:GetSequence() != self:LookupSequence("shoved_forward_heavy","shoved_backwards_heavy") -- If we are stumbling then DO NOT flinch!
end -- Return false to disallow the flinch from playing
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/