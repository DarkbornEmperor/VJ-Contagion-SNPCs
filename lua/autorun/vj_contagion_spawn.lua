/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Contagion SNPCs"
local AddonName = "Contagion"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_contagion_spawn.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

    VJ.AddCategoryInfo("Contagion", {Icon = "contagion/icons/contagion.png"})

	local vCat = "Contagion"
	VJ.AddNPC("Common Zombie (Male)","npc_vj_con_zmale",vCat)
	VJ.AddNPC("Civilian Zombie","npc_vj_con_zcivi",vCat)
	VJ.AddNPC("Common Zombie (Female)","npc_vj_con_zfemale",vCat)
	VJ.AddNPC("Doctor Zombie","npc_vj_con_zdoc",vCat)
	VJ.AddNPC("Curtis (Zombie)","npc_vj_con_zcurtis",vCat)
	VJ.AddNPC("Inmate Zombie","npc_vj_con_zinmate",vCat)
	VJ.AddNPC("Looter Zombie","npc_vj_con_zlooter",vCat)
	VJ.AddNPC("Officer Zombie","npc_vj_con_zofficer",vCat)
	VJ.AddNPC("Eugene (Zombie)","npc_vj_con_zeugene",vCat)
	VJ.AddNPC("Jessica (Zombie)","npc_vj_con_zjessica",vCat)
	VJ.AddNPC("Manuel (Zombie)","npc_vj_con_zmanuel",vCat)
	VJ.AddNPC("Marcus (Zombie)","npc_vj_con_zmarcus",vCat)
	VJ.AddNPC("Mia (Zombie)","npc_vj_con_zmia",vCat)
	VJ.AddNPC("Nick (Zombie)","npc_vj_con_znick",vCat)
	VJ.AddNPC("Riot Zombie","npc_vj_con_zriot",vCat)
	VJ.AddNPC("Tony (Zombie)","npc_vj_con_ztony",vCat)
	VJ.AddNPC("Yumi (Zombie)","npc_vj_con_zyumi",vCat)
	
-- Spawners and Random	
	VJ.AddNPC("Random Zombie","sent_vj_con_zom",vCat)
	VJ.AddNPC("Random Zombie Spawner","sent_vj_con_sp",vCat)
	VJ.AddNPC("Random Zombie Spawner (Single)","sent_vj_con_sinsp",vCat)
	
	-- Precache Models --
	util.PrecacheModel("models/cpthazama/contagion/zombies/civillian_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_a_c.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_a_f.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_a_h.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_a_t.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_b_c.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_b_f.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_b_h.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_b_t.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_c_c.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_c_f.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_c_f.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_c_t.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_female_a_t.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_female_b_t.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/common_zombie_female_c_t.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/curtis_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/doctor_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/eugene_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/inmate_zombie01.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/jessica_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/looter_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/manuel_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/marcus_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/mia_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/nick_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_alt.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_alt2.mdl")	
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_alt3.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_alt4.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_armor.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/riot_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/tony_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/yumi_zombie.mdl")	
	util.PrecacheModel("models/cpthazama/contagion/zombies/contagion_shared_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/contagion_shared_zombie_female.mdl")	
	
		-- Menu --
	VJ.AddConVar("vj_con_allowclimbing",0,{FCVAR_ARCHIVE})
	VJ.AddConVar("vj_con_headshot",0,{FCVAR_ARCHIVE})
	
	if CLIENT then
		hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_CONTAGION", function()		
			spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "Contagion", "Contagion", "", "", function(Panel)
				if !game.SinglePlayer() then
				if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
					Panel:AddControl( "Label", {Text = "You are not an admin!"})
					Panel:ControlHelp("Notice: Only admins can change this settings")
					return
					end
				end
				Panel:AddControl("Label", {Text = "Notice: Only admins can change this settings."})
				Panel:AddControl( "Label", {Text = "WARNING: Only future spawned SNPCs will be affected!"})
				Panel:AddControl("Button",{Text = "Reset Everything", Command = "vj_con_allowclimbing 0"})
				Panel:AddControl("Checkbox", {Label = "Enable Climbing", Command = "vj_con_allowclimbing"})
				Panel:ControlHelp("WARNING: Enabling climbing will cause heavy performance drops!")
				Panel:AddControl("Checkbox", {Label = "Enable Instant Headshot Death", Command = "vj_con_headshot"})
			end, {})
		end)
	end	
	
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end