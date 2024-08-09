/*--------------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base = "obj_vj_spawner_base"
ENT.Type = "anim"
ENT.PrintName = "Random Zombie"
ENT.Author = "Darkborn"
ENT.Contact = "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose = "Spawn it and fight with it!"
ENT.Instructions = "Click on the spawnicon to spawn it."
ENT.Category = "Contagion"

ENT.Spawnable = false
ENT.AdminSpawnable = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.SingleSpawner = true
local entsList = {
    "npc_vj_con_zmale",
    "npc_vj_con_zcivi:4",
    "npc_vj_con_zfemale",
    "npc_vj_con_zdoc:8",
    "npc_vj_con_zcurtis:6",
    "npc_vj_con_zinmate:8",
    "npc_vj_con_zlooter:10",
    "npc_vj_con_zofficer:8",
    "npc_vj_con_zcarrier:40",
    "npc_vj_con_zeugene:6",
    "npc_vj_con_zjessica:6",
    "npc_vj_con_zmanuel:6",
    "npc_vj_con_zmarcus:6",
    "npc_vj_con_zmia:6",
    "npc_vj_con_znick:6",
    "npc_vj_con_zdiego:6",
    "npc_vj_con_zriot:20",
    "npc_vj_con_ztony:6",
    "npc_vj_con_zyumi:6",
    "npc_vj_con_zmike:6",
    "npc_vj_con_znicole:6",
    "npc_vj_con_zryan:6",
    "npc_vj_con_zlawrence:6",
    "npc_vj_con_zworker:10",
    "npc_vj_con_zriotbrute:40",
    "npc_vj_con_zscreamer:40",
    "npc_vj_con_zriotsol:20"
}
ENT.EntitiesToSpawn = {
    {SpawnPosition = Vector(0, 0, 0), Entities = entsList},
}
/*--------------------------------------------------
    *** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
    No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
    without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/