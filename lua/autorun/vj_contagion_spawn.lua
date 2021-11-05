/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
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
	VJ.AddNPC("Lawrence (Zombie)","npc_vj_con_zlawrence",vCat)
	VJ.AddNPC("Looter Zombie","npc_vj_con_zlooter",vCat)
	VJ.AddNPC("Officer Zombie","npc_vj_con_zofficer",vCat)
	VJ.AddNPC("Carrier","npc_vj_con_zcarrier",vCat)
	VJ.AddNPC("Eugene (Zombie)","npc_vj_con_zeugene",vCat)
	VJ.AddNPC("Jessica (Zombie)","npc_vj_con_zjessica",vCat)
	VJ.AddNPC("Manuel (Zombie)","npc_vj_con_zmanuel",vCat)
	VJ.AddNPC("Marcus (Zombie)","npc_vj_con_zmarcus",vCat)
	VJ.AddNPC("Mia (Zombie)","npc_vj_con_zmia",vCat)
	VJ.AddNPC("Mike (Zombie)","npc_vj_con_zmike",vCat)
	VJ.AddNPC("Nick (Zombie)","npc_vj_con_znick",vCat)
	VJ.AddNPC("Nicole (Zombie)","npc_vj_con_znicole",vCat)	
	VJ.AddNPC("Riot Zombie","npc_vj_con_zriot",vCat)
	VJ.AddNPC("Riot Brute Zombie","npc_vj_con_zriotbrute",vCat)
	VJ.AddNPC("Riot Soldier Zombie","npc_vj_con_zriotsol",vCat)
	VJ.AddNPC("Ryan (Zombie)","npc_vj_con_zryan",vCat)	
	VJ.AddNPC("Tony (Zombie)","npc_vj_con_ztony",vCat)
	VJ.AddNPC("Yumi (Zombie)","npc_vj_con_zyumi",vCat)
	
    -- Spawners and Random	
	VJ.AddNPC("Random Zombie","sent_vj_con_zom",vCat)
	VJ.AddNPC("Random Zombie Spawner","sent_vj_con_sp",vCat)
	VJ.AddNPC("Random Zombie Spawner (Single)","sent_vj_con_sinsp",vCat)
	VJ.AddNPC("Zombie Map Spawner","sent_vj_con_mapspawner",vCat)

    -- Decals --
    game.AddDecal("VJ_CON_Blood",{"vj_contagion/decals/blood_splatter/blood_splatter_zombie01","vj_contagion/decals/blood_splatter/blood_splatter_zombie02","vj_contagion/decals/blood_splatter/blood_splatter_zombie03","vj_contagion/decals/blood_splatter/blood_splatter_zombie04","vj_contagion/decals/blood_splatter/blood_splatter_zombie05","vj_contagion/decals/blood_splatter/blood_splatter_zombie06"})
	
	-- Precache Models --
	util.PrecacheModel("models/cpthazama/contagion/zombies/carrier_zombie.mdl")
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
	util.PrecacheModel("models/cpthazama/contagion/zombies/lawrence_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/looter_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/manuel_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/marcus_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/mia_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/mike_zombie.mdl")	
	util.PrecacheModel("models/cpthazama/contagion/zombies/nick_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/nicole_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_alt.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_alt2.mdl")	
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_alt3.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_alt4.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_armor.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/officer_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/police_shield.mdl")	
	util.PrecacheModel("models/cpthazama/contagion/zombies/riot_helmet_gib01.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/riot_helmet_gib02.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/riot_helmet_gib03.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/riot_helmet_gib04.mdl")	
	util.PrecacheModel("models/cpthazama/contagion/zombies/riot_brute_zombie.mdl") 
	util.PrecacheModel("models/cpthazama/contagion/zombies/riot_soldier.mdl")	
	util.PrecacheModel("models/cpthazama/contagion/zombies/riot_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/ryan_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/tony_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/yumi_zombie.mdl")	
	util.PrecacheModel("models/cpthazama/contagion/zombies/contagion_shared_zombie.mdl")
	util.PrecacheModel("models/cpthazama/contagion/zombies/contagion_shared_zombie_female.mdl")	
		
	-- ConVars --
	local AddConvars = {}
	AddConvars["VJ_CON_AllowClimbing"] = 0
	AddConvars["VJ_CON_Headshot"] = 1
	
    -- Map Spawner ConVars --
    --AddConvars["VJ_CON_MapSpawner_Music"] = 1
	AddConvars["VJ_CON_MapSpawner_Enabled"] = 1
	AddConvars["VJ_CON_MapSpawner_Boss"] = 0
	AddConvars["VJ_CON_MapSpawner_MaxMon"] = 80
	AddConvars["VJ_CON_MapSpawner_HordeCount"] = 35
	AddConvars["VJ_CON_MapSpawner_SpawnMax"] = 2000
	AddConvars["VJ_CON_MapSpawner_SpawnMin"] = 650
	AddConvars["VJ_CON_MapSpawner_HordeChance"] = 100
	AddConvars["VJ_CON_MapSpawner_HordeCooldownMin"] = 120
	AddConvars["VJ_CON_MapSpawner_HordeCooldownMax"] = 180
	AddConvars["VJ_CON_MapSpawner_DelayMin"] = 0.85
	AddConvars["VJ_CON_MapSpawner_DelayMax"] = 3		
	
		for k, v in pairs(AddConvars) do
		if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_ARCHIVE} ) end
end
	
if (CLIENT) then
local function VJ_CON_MAIN(Panel)
			if !game.SinglePlayer() then
			if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
				Panel:AddControl( "Label", {Text = "You are not an admin!"})
				Panel:ControlHelp("Note: Only admins can change these settings!")
        return
	end
end
			Panel:AddControl( "Label", {Text = "Note: Only admins can change these settings!"})
			local vj_conreset = {Options = {}, CVars = {}, Label = "Reset everything:", MenuButton = "0"}
			vj_conreset.Options["#vjbase.menugeneral.default"] = { 
				VJ_CON_AllowClimbing = "0",
				VJ_CON_Headshot = "1",				
}
            Panel:AddControl("ComboBox", vj_conreset)
            Panel:ControlHelp("NOTE: Only future SNPCs will be affected!")
            Panel:AddControl("Checkbox", {Label ="Enable prop climbing?", Command ="VJ_CON_AllowClimbing"})		
            Panel:ControlHelp("Warning: May cause performance drops.")
            Panel:AddControl("Checkbox", {Label ="Enable instant headshot death?", Command ="VJ_CON_Headshot"})			
            Panel:AddPanel(typebox)

end
	function VJ_ADDTOMENU_CON(Panel)
		spawnmenu.AddToolMenuOption("DrVrej","SNPC Configures","Contagion (Main)","Contagion (Main)","","", VJ_CON_MAIN, {} )
end
		hook.Add("PopulateToolMenu","VJ_ADDTOMENU_CON", VJ_ADDTOMENU_CON )

local function VJ_CON_MAPSPAWNER(Panel)
			if !game.SinglePlayer() then
			if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
				Panel:AddControl( "Label", {Text = "You are not an admin!"})
				Panel:ControlHelp("Note: Only admins can change these settings!")
        return
	end
end
			Panel:AddControl( "Label", {Text = "Note: Only admins can change these settings!"})
			local vj_conreset_mapspawner = {Options = {}, CVars = {}, Label = "Reset everything:", MenuButton = "0"}
			vj_conreset_mapspawner.Options["#vjbase.menugeneral.default"] = { 
			    --VJ_CON_MapSpawner_Music = "1",
				VJ_CON_MapSpawner_Enabled = "1",
				VJ_CON_MapSpawner_Boss = "0",
				VJ_CON_MapSpawner_MaxMon = "80",	
				VJ_CON_MapSpawner_HordeCount = "35",	
				VJ_CON_MapSpawner_SpawnMax = "2000",	
				VJ_CON_MapSpawner_SpawnMin = "650",	
				VJ_CON_MapSpawner_HordeChance = "100",	
				VJ_CON_MapSpawner_HordeCooldownMin = "120",	
				VJ_CON_MapSpawner_HordeCooldownMax = "180",	
				VJ_CON_MapSpawner_DelayMin = "0.85",
                VJ_CON_MapSpawner_DelayMax = "3",						

}
            Panel:AddControl("ComboBox", vj_conreset_mapspawner)
            Panel:ControlHelp("NOTE: Only enable if you have the specific addon installed!")
            Panel:AddControl("Checkbox", {Label = "Enable Map Spawner processing?", Command = "VJ_CON_MapSpawner_Enabled"})			
            Panel:AddControl("Slider", { Label 	= "Max Zombies", Command = "VJ_CON_MapSpawner_MaxMon", Type = "Float", Min = "5", Max = "400"})
            Panel:AddControl("Slider", { Label 	= "Min Distance they can spawn from players", Command = "VJ_CON_MapSpawner_SpawnMin", Type = "Float", Min = "150", Max = "30000"})
            Panel:AddControl("Slider", { Label 	= "Max Distance they can spawn from players", Command = "VJ_CON_MapSpawner_SpawnMax", Type = "Float", Min = "150", Max = "30000"})
            Panel:AddControl("Slider", { Label 	= "Min time between spawns", Command = "VJ_CON_MapSpawner_DelayMin", Type = "Float", Min = "0.1", Max = "15"})
            Panel:AddControl("Slider", { Label 	= "Max time between spawns", Command = "VJ_CON_MapSpawner_DelayMax", Type = "Float", Min = "0.2", Max = "15"})
            Panel:AddControl("Slider", { Label 	= "Max Zombie horde", Command = "VJ_CON_MapSpawner_HordeCount", Type = "Float", Min = "5", Max = "400"})
            Panel:AddControl("Slider", { Label 	= "Chance that a horde will appear", Command = "VJ_CON_MapSpawner_HordeChance", Type = "Float", Min = "1", Max = "500"})
            Panel:AddControl("Slider", { Label 	= "Min cooldown time for horde spawns", Command = "VJ_CON_MapSpawner_HordeCooldownMin", Type = "Float", Min = "1", Max = "800"})
            Panel:AddControl("Slider", { Label 	= "Max cooldown time for horde spawns", Command = "VJ_CON_MapSpawner_HordeCooldownMax", Type = "Float", Min = "1", Max = "800"})
            Panel:AddPanel(typebox)
end
	function VJ_ADDTOMENU_CON_MAPSPAWNER(Panel)
		spawnmenu.AddToolMenuOption("DrVrej","SNPC Configures","Contagion (MapSp)","Contagion (MapSp)","","", VJ_CON_MAPSPAWNER, {} )
end
		hook.Add("PopulateToolMenu","VJ_ADDTOMENU_CON_MAPSPAWNER", VJ_ADDTOMENU_CON_MAPSPAWNER )
end

	VJ_CON_NODEPOS = {}
	hook.Add("EntityRemoved","VJ_CON_AddNodes",function(ent)
		if ent:GetClass() == "info_node" then
			table.insert(VJ_CON_NODEPOS,ent:GetPos())
	end
end)
	
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