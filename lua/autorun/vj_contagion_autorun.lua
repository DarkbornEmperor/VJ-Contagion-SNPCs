------------------ Addon Information ------------------
local AddonName = "Contagion SNPCs"
local AddonType = "NPC"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
    include("autorun/vj_controls.lua")

    VJ.AddCategoryInfo("Contagion", {Icon = "vj_contagion/icons/contagion.png"})

    local spawnCategory = "Contagion"
    VJ.AddNPC("Common Zombie (Male)","npc_vj_con_zmale",spawnCategory)
    VJ.AddNPC("Civilian Zombie","npc_vj_con_zcivi",spawnCategory)
    VJ.AddNPC("Common Zombie (Female)","npc_vj_con_zfemale",spawnCategory)
    VJ.AddNPC("Doctor Zombie","npc_vj_con_zdoc",spawnCategory)
    VJ.AddNPC("Curtis (Zombie)","npc_vj_con_zcurtis",spawnCategory)
    VJ.AddNPC("Diego (Zombie)","npc_vj_con_zdiego",spawnCategory)
    VJ.AddNPC("Inmate Zombie","npc_vj_con_zinmate",spawnCategory)
    VJ.AddNPC("Lawrence (Zombie)","npc_vj_con_zlawrence",spawnCategory)
    VJ.AddNPC("Looter Zombie","npc_vj_con_zlooter",spawnCategory)
    VJ.AddNPC("Officer Zombie","npc_vj_con_zofficer",spawnCategory)
    VJ.AddNPC("Worker Zombie","npc_vj_con_zworker",spawnCategory)
    VJ.AddNPC("Carrier Zombie","npc_vj_con_zcarrier",spawnCategory)
    VJ.AddNPC("Eugene (Zombie)","npc_vj_con_zeugene",spawnCategory)
    VJ.AddNPC("Jessica (Zombie)","npc_vj_con_zjessica",spawnCategory)
    VJ.AddNPC("Manuel (Zombie)","npc_vj_con_zmanuel",spawnCategory)
    VJ.AddNPC("Marcus (Zombie)","npc_vj_con_zmarcus",spawnCategory)
    VJ.AddNPC("Mia (Zombie)","npc_vj_con_zmia",spawnCategory)
    VJ.AddNPC("Mike (Zombie)","npc_vj_con_zmike",spawnCategory)
    VJ.AddNPC("Nick (Zombie)","npc_vj_con_znick",spawnCategory)
    VJ.AddNPC("Nicole (Zombie)","npc_vj_con_znicole",spawnCategory)
    VJ.AddNPC("Riot Zombie","npc_vj_con_zriot",spawnCategory)
    VJ.AddNPC("Charger Zombie","npc_vj_con_zriotbrute",spawnCategory)
    VJ.AddNPC("Riot Soldier Zombie","npc_vj_con_zriotsol",spawnCategory)
    VJ.AddNPC("Ryan (Zombie)","npc_vj_con_zryan",spawnCategory)
    VJ.AddNPC("Tony (Zombie)","npc_vj_con_ztony",spawnCategory)
    VJ.AddNPC("Yumi (Zombie)","npc_vj_con_zyumi",spawnCategory)
    VJ.AddNPC("Screamer Zombie","npc_vj_con_zscreamer",spawnCategory)

    -- Spawners and Random
    VJ.AddNPC("Random Zombie","sent_vj_con_zom",spawnCategory)
    VJ.AddNPC("Random Zombie Spawner","sent_vj_con_sp",spawnCategory)
    VJ.AddNPC("Random Zombie Spawner (Single)","sent_vj_con_sinsp",spawnCategory)
    VJ.AddNPC("Zombie Map Spawner","sent_vj_con_mapspawner",spawnCategory)

    -- Particles --
    VJ.AddParticle("particles/vj_con_blood_impact.pcf", {
    "vj_con_blood_impact_red_01",
})

    -- Decals --
    game.AddDecal("VJ_CON_Blood",{"vj_contagion/decals/blood_splatter/blood_splatter_zombie01","vj_contagion/decals/blood_splatter/blood_splatter_zombie02","vj_contagion/decals/blood_splatter/blood_splatter_zombie03","vj_contagion/decals/blood_splatter/blood_splatter_zombie04","vj_contagion/decals/blood_splatter/blood_splatter_zombie05","vj_contagion/decals/blood_splatter/blood_splatter_zombie06"})

    -- Precache Models --
    util.PrecacheModel("models/vj_contagion/zombies/carrier_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/civillian_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_a_c.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_a_f.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_a_h.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_a_t.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_b_c.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_b_f.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_b_h.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_b_t.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_c_c.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_c_f.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_c_f.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_c_t.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_female_a_t.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_female_b_t.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/common_zombie_female_c_t.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/curtis_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/diego_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/doctor_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/eugene_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/inmate_zombie01.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/jessica_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/lawrence_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/looter_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/manuel_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/marcus_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/mia_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/engineer.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/nick_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/nicole_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/officer_alt.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/officer_alt2.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/officer_alt3.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/officer_alt4.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/officer_armor.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/officer_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/police_shield.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/riot_helmet_gib01.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/riot_helmet_gib02.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/riot_helmet_gib03.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/riot_helmet_gib04.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/riot_brute_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/riot_soldier.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/riot_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/ryan_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/tony_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/worker_visor01_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/worker_visor02_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/worker_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/yumi_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/screamer.mdl")
    /*util.PrecacheModel("models/vj_contagion/zombies/contagion_shared_zombie.mdl")
    util.PrecacheModel("models/vj_contagion/zombies/contagion_shared_zombie_female.mdl")*/

    -- ConVars --
    VJ.AddConVar("VJ_CON_AllowClimbing", 0, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_AllRunners", 0, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_BreakDoors", 0, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_Headshot", 0, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_CorpseEffects", 1, {FCVAR_ARCHIVE})
    VJ.AddClientConVar("VJ_CON_ZombieOverlay", 1, "Screen Overlay When Controlling Zombies")
    VJ.AddClientConVar("VJ_CON_OldOverlay", 0, "Earlier Screen Overlay When Controlling Zombies")

    -- Map Spawner ConVars --
    VJ.AddConVar("VJ_CON_MapSpawner_Enabled", 1, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_MaxZom", 80, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_HordeCount", 35, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_SpawnMax", 2000, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_SpawnMin", 650, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_HordeChance", 100, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_HordeCooldownMin", 120, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_HordeCooldownMax", 180, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_DelayMin", 0.85, {FCVAR_ARCHIVE})
    VJ.AddConVar("VJ_CON_MapSpawner_DelayMax", 3, {FCVAR_ARCHIVE})

      if CLIENT then
         hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_CON", function()
         spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "Contagion (Main)", "Contagion (Main)", "", "", function(Panel)
            local vj_conreset_cs = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
            vj_conreset_cs.Options["#vjbase.menugeneral.default"] = {
                VJ_CON_ZombieOverlay = "1",
                VJ_CON_OldOverlay = "0",
}
                Panel:AddControl("ComboBox", vj_conreset_cs)
                 Panel:AddControl( "Label", {Text = "Client-Side Options:"})
                Panel:AddControl("Checkbox", {Label ="Enable Screen Overlay When Controlling Zombies?", Command ="VJ_CON_ZombieOverlay"})
                Panel:AddControl("Checkbox", {Label ="Enable Old Screen Overlay?", Command ="VJ_CON_OldOverlay"})
            if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
                Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
                Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
    return
end
            Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
            local vj_conreset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
            vj_conreset.Options["#vjbase.menugeneral.default"] = {
                VJ_CON_AllowClimbing = "0",
                VJ_CON_AllRunners = "0",
                VJ_CON_BreakDoors = "1",
                VJ_CON_Headshot = "0",
                VJ_CON_CorpseEffects = "1",
}
            Panel:AddControl("ComboBox", vj_conreset)
            Panel:ControlHelp("Note: Only future spawned SNPCs will be affected.")
            Panel:AddControl("Label", {Text = "Options:"})
            Panel:AddControl("Checkbox", {Label ="Enable Prop Climbing?", Command ="VJ_CON_AllowClimbing"})
            Panel:ControlHelp("Warning: Can cause performance issues.")
            Panel:AddControl("Checkbox", {Label ="Enable Sprinters Only?", Command ="VJ_CON_AllRunners"})
            Panel:AddControl("Checkbox", {Label ="Enable Zombies Breaking Doors?", Command ="VJ_CON_BreakDoors"})
            Panel:AddControl("Checkbox", {Label ="Enable Instant Headshot Death?", Command ="VJ_CON_Headshot"})
            Panel:AddControl("Checkbox", {Label ="Enable Corpse Effects & Decals?", Command ="VJ_CON_CorpseEffects"})
end)
         spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "Contagion (Map Spawner)", "Contagion (Map Spawner)", "", "", function(Panel)
            if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
                Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
                Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
    return
end
            Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
            local vj_conreset_mapspawner = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
            vj_conreset_mapspawner.Options["#vjbase.menugeneral.default"] = {
                VJ_CON_MapSpawner_Enabled = "1",
                VJ_CON_MapSpawner_MaxZom = "80",
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
            Panel:AddControl("Label", {Text = "Options:"})
            Panel:AddControl("Checkbox", {Label = "Enable Map Spawner processing?", Command = "VJ_CON_MapSpawner_Enabled"})
            Panel:AddControl("Label", {Text = "Modifiers:"})
            Panel:AddControl("Slider", {Label = "Max Zombies", Command = "VJ_CON_MapSpawner_MaxZom", Type = "Float", Min = "5", Max = "400"})
            Panel:AddControl("Slider", {Label = "Min Distance they can spawn from players", Command = "VJ_CON_MapSpawner_SpawnMin", Type = "Float", Min = "150", Max = "30000"})
            Panel:AddControl("Slider", {Label = "Max Distance they can spawn from players", Command = "VJ_CON_MapSpawner_SpawnMax", Type = "Float", Min = "150", Max = "30000"})
            Panel:AddControl("Slider", {Label = "Min time between spawns", Command = "VJ_CON_MapSpawner_DelayMin", Type = "Float", Min = "0.1", Max = "15"})
            Panel:AddControl("Slider", {Label = "Max time between spawns", Command = "VJ_CON_MapSpawner_DelayMax", Type = "Float", Min = "0.2", Max = "15"})
            Panel:AddControl("Slider", {Label = "Max Zombie horde", Command = "VJ_CON_MapSpawner_HordeCount", Type = "Float", Min = "5", Max = "400"})
            Panel:AddControl("Slider", {Label = "Chance that a horde will appear", Command = "VJ_CON_MapSpawner_HordeChance", Type = "Float", Min = "1", Max = "500"})
            Panel:AddControl("Slider", {Label = "Min cooldown time for horde spawns", Command = "VJ_CON_MapSpawner_HordeCooldownMin", Type = "Float", Min = "1", Max = "800"})
            Panel:AddControl("Slider", {Label = "Max cooldown time for horde spawns", Command = "VJ_CON_MapSpawner_HordeCooldownMax", Type = "Float", Min = "1", Max = "800"})
        end)
    end)
end
    VJ_CON_NODEPOS = {}
    hook.Add("EntityRemoved","VJ_CON_AddNodes",function(ent)
        if ent:GetClass() == "info_node" then
            table.insert(VJ_CON_NODEPOS,ent:GetPos())
    end
end)

if CLIENT then
    net.Receive("vj_con_zombie_hud",function(len,pl)
        local delete = net.ReadBool()
        local ent = net.ReadEntity()
        if !IsValid(ent) then delete = true end

     if GetConVar("VJ_CON_ZombieOverlay"):GetInt() == 1 then
        hook.Add("RenderScreenspaceEffects","VJ_CON_ZombieHUD_Overlay",function(zom)
            local threshold = 0.30
         if GetConVar("VJ_CON_OldOverlay"):GetInt() == 1 then
            DrawMaterialOverlay("vj_contagion/overlay/zombie_back",threshold)
         else
            DrawMaterialOverlay("vj_contagion/overlay/zombie_background_fix",threshold)
        end
    end)
end
        if delete then hook.Remove("RenderScreenspaceEffects","VJ_CON_ZombieHUD_Overlay") end

        hook.Add("PreDrawHalos","VJ_CON_ZombieHUD_Halo",function(zom)
            if IsValid(ent) then
                //local tbInf = {}
                local tbEne = {}
                local tbFri = {}
                local tbCar = {}
                //local colInf = Color(33,255,0,255)
                local colEne = Color(255,0,0)
                local colFri = Color(0,127,31,255)
                local colCar = Color(255,191,0,255)
                for _,v in pairs(ents.GetAll()) do
                    if (v:IsNPC() && v:GetClass() != "obj_vj_bullseye" or v:IsPlayer()) && !v:IsFlagSet(FL_NOTARGET) then
                        if string.find(v:GetClass(),"npc_vj_con_z") && v:GetClass() != "npc_vj_con_zcarrier" && v:GetClass() != "npc_vj_con_zriotbrute" && v:GetClass() != "npc_vj_con_zscreamer" then
                           table.insert(tbFri,v)
                        elseif v:GetClass() == "npc_vj_con_zcarrier" or v:GetClass() == "npc_vj_con_zriotbrute" or v:GetClass() == "npc_vj_con_zscreamer" then
                           table.insert(tbCar,v)
                        /*elseif v.CON_InfectedVictim then
                           table.insert(tbInf,v)*/
                        else
                           table.insert(tbEne,v)
        end
    end
end
                //halo.Add(tbInf,colInf,4,4,3,true,true)
                halo.Add(tbEne,colEne,4,4,3,true,true)
                halo.Add(tbFri,colFri,4,4,3,true,true)
                halo.Add(tbCar,colCar,4,4,3,true,true)
    end
end)
        if delete then hook.Remove("PreDrawHalos","VJ_CON_ZombieHUD_Halo") end
    end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CON_ApplyCorpseEffects(ent,corpse)
 if GetConVar("VJ_CON_CorpseEffects"):GetInt() == 0 or GetConVar("vj_npc_nobleed"):GetInt() == 1 then return end
    local defPos = Vector(0, 0, 0)
     corpse.CON_Corpse = true
    if ent.HasBloodParticle then corpse.BleedParticle = ent.CustomBlood_Particle or "" end
    corpse.BleedDecal = ent.HasBloodDecal and VJ.PICK(ent.CustomBlood_Decal) or ""
    corpse.CON_Corpse_StartT = CurTime() + 1
    hook.Add("EntityTakeDamage","VJ_CON_CorpseBleed",function(target,dmginfo)
    if target.CON_Corpse && !target.Dead && CurTime() > target.CON_Corpse_StartT && target:GetColor().a > 50 then
            local dmgForce = dmginfo:GetDamageForce()
                //sound.Play("physics/flesh/flesh_impact_bullet"..math.random(1,3)..".wav",dmginfo:GetDamagePosition(),60,100)
                local pos = dmginfo:GetDamagePosition()
            if pos == defPos then pos = target:GetPos() + target:OBBCenter() end
                local part = VJ.PICK(target.BleedParticle)
            if part then
                local particle = ents.Create("info_particle_system")
                particle:SetKeyValue("effect_name",part)
                particle:SetPos(pos)
                particle:Spawn()
                particle:Activate()
                particle:Fire("Start")
                particle:Fire("Kill","",0.1)
end
                local decal = VJ.PICK(target.BleedDecal)
                if decal then
                    local tr = util.TraceLine({start = pos, endpos = pos + dmgForce:GetNormal() * math.Clamp(dmgForce:Length() * 10, 100, 150), filter = target})
                    util.Decal(decal, tr.HitPos + tr.HitNormal + Vector(math.random(-30, 30), math.random(-30, 30), 0), tr.HitPos - tr.HitNormal, target)
            end
        end
    end)
end
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
    AddCSLuaFile(AutorunFile)
    VJ.AddAddonProperty(AddonName,AddonType)
else
    if CLIENT then
        chat.AddText(Color(0, 200, 200), PublicAddonName,
        Color(0, 255, 0), " was unable to install, you are missing ",
        Color(255, 100, 0), "VJ Base!")
    end

    timer.Simple(1, function()
        if not VJBASE_ERROR_MISSING then
            VJBASE_ERROR_MISSING = true
            if CLIENT then
                // Get rid of old error messages from addons running on older code...
                if VJF && type(VJF) == "Panel" then
                    VJF:Close()
                end
                VJF = true

                local frame = vgui.Create("DFrame")
                frame:SetSize(600, 160)
                frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
                frame:SetTitle("Error: VJ Base is missing!")
                frame:SetBackgroundBlur(true)
                frame:MakePopup()

                local labelTitle = vgui.Create("DLabel", frame)
                labelTitle:SetPos(250, 30)
                labelTitle:SetText("VJ BASE IS MISSING!")
                labelTitle:SetTextColor(Color(255,128,128))
                labelTitle:SizeToContents()

                local label1 = vgui.Create("DLabel", frame)
                label1:SetPos(170, 50)
                label1:SetText("Garry's Mod was unable to find VJ Base in your files!")
                label1:SizeToContents()

                local label2 = vgui.Create("DLabel", frame)
                label2:SetPos(10, 70)
                label2:SetText("You have an addon installed that requires VJ Base but VJ Base is missing. To install VJ Base, click on the link below. Once\n                                                   installed, make sure it is enabled and then restart your game.")
                label2:SizeToContents()

                local link = vgui.Create("DLabelURL", frame)
                link:SetSize(300, 20)
                link:SetPos(195, 100)
                link:SetText("VJ_Base_Download_Link_(Steam_Workshop)")
                link:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")

                local buttonClose = vgui.Create("DButton", frame)
                buttonClose:SetText("CLOSE")
                buttonClose:SetPos(260, 120)
                buttonClose:SetSize(80, 35)
                buttonClose.DoClick = function()
                    frame:Close()
                end
            elseif (SERVER) then
                VJF = true
                timer.Remove("VJBASEMissing")
                timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
                    print("VJ Base is missing! Download it from the Steam Workshop! Link: https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
                end)
            end
        end
    end)
end