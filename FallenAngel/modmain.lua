local require = GLOBAL.require
require "class"
require "util"

local MergeMaps=GLOBAL.MergeMaps

GLOBAL.FA_DLCACCESS=false
GLOBAL.xpcall(function()
                    GLOBAL.FA_DLCACCESS= GLOBAL.IsDLCEnabled and GLOBAL.REIGN_OF_GIANTS and GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)
                end,
                function()
                    --if the calls crashed im assuming outdated code and dlc is off by default
                    print("dlc crash")
                end
            )
print("dlc status",GLOBAL.FA_DLCACCESS)


local Widget = require "widgets/widget"
local XPBadge= require "widgets/xpbadge"
local TextEdit=require "widgets/textedit"
local ItemTile = require "widgets/itemtile"
local FAWarClock = require "widgets/fawarclock"
require "widgets/text"
require "stategraph"
require "constants"
require "buffutil"
require "fa_mobxptable"
require "fa_strings"
require "fa_electricalfence"
require "fa_levelxptable"
require "fa_stealthdetectiontable"
require "behaviours/panic"
require "fa_constants"
require "fa_inventory_override"
local FA_CharRenameScreen=require "screens/fa_charrenamescreen"
--
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local Action = GLOBAL.Action
local GetPlayer = GLOBAL.GetPlayer
local GetClock=GLOBAL.GetClock
local GetWorld=GLOBAL.GetWorld
local GetSeasonManager=GLOBAL.GetSeasonManager
local SpawnPrefab=GLOBAL.SpawnPrefab

local FA_DAMAGETYPE=GLOBAL.FA_DAMAGETYPE

local StatusDisplays = require "widgets/statusdisplays"
local ImageButton = require "widgets/imagebutton"
local Levels=require("map/levels")

require "repairabledescriptionfix"

PrefabFiles = {
    "fa_fx",
    "fa_bags",
    "fa_rocks",
    "fa_lavarain",
    "fa_fissures",
    "fa_forcefields",
    "fa_fissurefx",
    "fa_fireflies",
    "fa_teleporter",
    "fa_hats",
    "fa_stickheads",
    "fa_dungeon_walls",
    "goblinsignpost",
    "fa_animatedarmor",
    "fa_bonfire",
    "fa_dungeon_entrance",
    "fa_dungeon_exit",
    "fa_surface_portal",
    "cheats",
    "poisonspider",
    "poisonspiderden",
    "poisonspidereggsack",
    "spellprojectiles",
    "natureshealing",
    "skeletonspawn",
    "boomstickprojectile",
    "fizzleboomstick",
    "fizzlearmor",
    "poopbricks",
    "treeguardian",
    "fizzlepet",
    "fizzlemanipulator",
    "rjk1100",
    "dksword",
    "holysword",
    "thieftraps",
    "arrows",
    "bow",
    "fa_key",
    "fa_boots",
    "fa_rings",
    "fa_fireaxe",
    "fa_iceaxe",
    "fa_goodberries",
    "fa_potions",
    "spellbooks",
    "shields",
    "armor_fire",
    "armor_frost",
    "fa_totems",
    "dagger",
    "fa_lightningsword",
    "flamingsword",
    "frostsword",
    "undeadbanesword",
    "vorpalaxe",
    "wands",
    "dryad",
    "satyr",
    "unicorn",
    "fa_orchut",
    "fa_orc",
    "fa_ogre",
    "fa_troll",
    "goblin",
    "wolf",
    "goblinhut",
    "wolfmound",
	"thief",
	"barb",
	"cleric",
    "fairy",
	"druid",
	"darkknight",
    "darkknightpet",
    "monk",
    "necromancer",
    "necropet",
    "wizard",
    "tinkerer",
    "paladin",
    "bard",
    "ranger",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/thief.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/thief.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/barb.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/barb.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/cleric.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/cleric.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/druid.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/druid.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/darkknight.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/darkknight.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/monk.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/monk.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/necromancer.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/necromancer.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/wizard.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wizard.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/tinkerer.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/tinkerer.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/paladin.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/paladin.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/ranger.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/ranger.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/bard.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/bard.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/thief.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/thief.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/barb.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/barb.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/cleric.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/cleric.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/druid.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/druid.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/darkknight.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/darkknight.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/monk.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/monk.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/necromancer.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/necromancer.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/wizard.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wizard.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/tinkerer.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/tinkerer.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/paladin.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/paladin.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/ranger.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ranger.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/bard.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/bard.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/wod_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wod_silho.xml" ),

    Asset( "IMAGE", "bigportraits/thief.tex" ),
    Asset( "ATLAS", "bigportraits/thief.xml" ),
    Asset( "IMAGE", "bigportraits/barb.tex" ),
    Asset( "ATLAS", "bigportraits/barb.xml" ),
    Asset( "IMAGE", "bigportraits/cleric.tex" ),
    Asset( "ATLAS", "bigportraits/cleric.xml" ),
    Asset( "IMAGE", "bigportraits/druid.tex" ),
    Asset( "ATLAS", "bigportraits/druid.xml" ),
    Asset( "IMAGE", "bigportraits/monk.tex" ),
    Asset( "ATLAS", "bigportraits/monk.xml" ),
    Asset( "IMAGE", "bigportraits/necromancer.tex" ),
    Asset( "ATLAS", "bigportraits/necromancer.xml" ),
    Asset( "IMAGE", "bigportraits/wizard.tex" ),
    Asset( "ATLAS", "bigportraits/wizard.xml" ),
    Asset( "IMAGE", "bigportraits/tinkerer.tex" ),
    Asset( "ATLAS", "bigportraits/tinkerer.xml" ),
    Asset( "IMAGE", "bigportraits/paladin.tex" ),
    Asset( "ATLAS", "bigportraits/paladin.xml" ),
    Asset( "IMAGE", "bigportraits/ranger.tex" ),
    Asset( "ATLAS", "bigportraits/ranger.xml" ),
    Asset( "IMAGE", "bigportraits/bard.tex" ),
    Asset( "ATLAS", "bigportraits/bard.xml" ),

    Asset("SOUNDPACKAGE", "sound/fa.fev"),
    Asset("SOUND", "sound/fallenangel.fsb"),

    Asset( "IMAGE", "images/xp_background.tex" ),
    Asset( "ATLAS", "images/xp_background.xml" ),
    Asset( "IMAGE", "images/xp_fill.tex" ),
    Asset( "ATLAS", "images/xp_fill.xml" ),
    Asset( "IMAGE", "images/transparent.tex" ),
    Asset( "ATLAS", "images/transparent.xml" ),

    Asset( "IMAGE", "minimap/boneshield.tex" ),
    Asset( "ATLAS", "minimap/boneshield.xml" ),
    Asset( "IMAGE", "minimap/dagger.tex" ),
    Asset( "ATLAS", "minimap/dagger.xml" ),
    Asset( "IMAGE", "minimap/evilsword.tex" ),
    Asset( "ATLAS", "minimap/evilsword.xml" ),
    Asset( "IMAGE", "minimap/firearmor.tex" ),
    Asset( "ATLAS", "minimap/firearmor.xml" ),
    Asset( "IMAGE", "minimap/flamingsword.tex" ),
    Asset( "ATLAS", "minimap/flamingsword.xml" ),
    Asset( "IMAGE", "minimap/frostarmor.tex" ),
    Asset( "ATLAS", "minimap/frostarmor.xml" ),
    Asset( "IMAGE", "minimap/holysword.tex" ),
    Asset( "ATLAS", "minimap/holysword.xml" ),
    Asset( "IMAGE", "minimap/marbleshield.tex" ),
    Asset( "ATLAS", "minimap/marbleshield.xml" ),
    Asset( "IMAGE", "minimap/reflectshield.tex" ),
    Asset( "ATLAS", "minimap/reflectshield.xml" ),
    Asset( "IMAGE", "minimap/rockshield.tex" ),
    Asset( "ATLAS", "minimap/rockshield.xml" ),
    Asset( "IMAGE", "minimap/undeadbanesword.tex" ),
    Asset( "ATLAS", "minimap/undeadbanesword.xml" ),
    Asset( "IMAGE", "minimap/vorpalaxe.tex" ),
    Asset( "ATLAS", "minimap/vorpalaxe.xml" ),
    Asset( "IMAGE", "minimap/woodbow.tex" ),
    Asset( "ATLAS", "minimap/woodbow.xml" ),
    Asset( "IMAGE", "minimap/woodshield.tex" ),
    Asset( "ATLAS", "minimap/woodshield.xml" ), 
    Asset( "IMAGE", "minimap/goblin.tex" ),
    Asset( "ATLAS", "minimap/goblin.xml" ),  
    Asset( "IMAGE", "minimap/fa_orc.tex" ),
    Asset( "ATLAS", "minimap/fa_orc.xml" ),  
    Asset( "ANIM", "anim/question.zip" ),
    Asset( "ANIM", "anim/fa_shieldpuff.zip" ),

    Asset( "ANIM", "anim/generating_goblin_cave.zip" ),
    Asset( "IMAGE", "images/lava3.tex" ),
    Asset( "IMAGE", "images/lava2.tex" ),
    Asset( "IMAGE", "images/lava1.tex" ),
    Asset( "IMAGE", "images/lava.tex" ),
    Asset( "IMAGE", "colour_cubes/lavacube.tex" ),
    Asset( "IMAGE", "colour_cubes/identity_colourcube.tex" ),
    Asset( "IMAGE", "colour_cubes/summer_dusk_cc.tex" ),


}
--[[
AddSimPostInit(function()
    GLOBAL.GetWorld().components.colourcubemanager:SetOverrideColourCube(
        GLOBAL.resolvefilepath "colour_cubes/identity_colourcube.tex"
    )
end)
]]

AddMinimapAtlas("minimap/boneshield.xml")
AddMinimapAtlas("minimap/dagger.xml")
AddMinimapAtlas("minimap/evilsword.xml")
AddMinimapAtlas("minimap/firearmor.xml")
AddMinimapAtlas("minimap/flamingsword.xml")
AddMinimapAtlas("minimap/frostarmor.xml")
AddMinimapAtlas("minimap/frostsword.xml")
AddMinimapAtlas("minimap/holysword.xml")
AddMinimapAtlas("minimap/marbleshield.xml")
AddMinimapAtlas("minimap/reflectshield.xml")
AddMinimapAtlas("minimap/rockshield.xml")
AddMinimapAtlas("minimap/undeadbanesword.xml")
AddMinimapAtlas("minimap/vorpalaxe.xml")
AddMinimapAtlas("minimap/woodbow.xml")
AddMinimapAtlas("minimap/woodshield.xml")
AddMinimapAtlas("minimap/goblin.xml")
AddMinimapAtlas("minimap/fa_orc.xml")

local EVIL_SANITY_AURA_OVERRIDE={
    robin=-TUNING.SANITYAURA_MED,
    pigman=-TUNING.SANITYAURA_MED,
    crow=-TUNING.SANITYAURA_MED,
    robin_winter=-TUNING.SANITYAURA_MED,
    beefalo=-TUNING.SANITYAURA_MED,
    babybeefalo=-TUNING.SANITYAURA_MED,
    butterfly=-TUNING.SANITYAURA_MED,
    spider_hider=0,
    spider_spitter=0,
    spider_dropper=0,
    flower_evil=TUNING.SANITYAURA_MED,
    ghost=TUNING.SANITYAURA_MED,
    hound=0,
    icehound=0,
    firehound=0,
    houndfire=0,
    nightlight=TUNING.SANITYAURA_MED,--would have to properly code this
    rabbit=-TUNING.SANITYAURA_MED,--and this
    crawlinghorror=0,
    terrorbeak=0,
    shadowtentacle=0,
    shadowwaxwell=0,
    slurper=0,
    spider=0,
    spider_warrior=0,
    tentacle=0,
    tentacle_pillar_arm=0,
    walrus=-TUNING.SANITYAURA_MED,
    little_walrus=-TUNING.SANITYAURA_MED,
    worm=0,
    penguin=-TUNING.SANITYAURA_MED,
    flower=-TUNING.SANITYAURA_MED
}

GLOBAL.FALLENLOOTTABLE={
    tier1={ 

            armorfire=50,
            armorfrost=50,
            dagger=50,
            flamingsword=50,
            frostsword=50,
            undeadbanesword=50,
            vorpalaxe=50,
            fa_lightningsword=50,
            fa_bottle_r=50,
            fa_bottle_y=50,
            fa_bottle_g=50,
            fa_bottle_b=50,
            fa_fireaxe=50,
            fa_iceaxe=50
        
    },
    tier2={
            armorfire2=35,
            armorfrost2=35,
            dagger2=35,
            flamingsword2=35,
            frostsword2=35,
            undeadbanesword2=35,
            vorpalaxe2=35,
            fa_lightningsword=35,
            fa_fireaxe2=35,
            fa_iceaxe2=35
    },
    tier3={
            armorfire3=15,
            armorfrost3=15,
            dagger3=15,
            flamingsword3=15,
            frostsword3=15,
            undeadbanesword3=15,
            vorpalaxe3=15,
            fa_lightningsword=15,
            fa_fireaxe3=15,
            fa_iceaxe3=15,
            fa_redtotem_item=15,
            fa_bluetotem_item=15
    },
    TABLE_WEIGHT=1260,
    TABLE_TIER1_WEIGHT=700,
    TABLE_TIER2_WEIGHT=350,
    TABLE_TIER3_WEIGHT=180
}
GLOBAL.FALLENLOOTTABLEMERGED=MergeMaps(GLOBAL.FALLENLOOTTABLE["tier1"],GLOBAL.FALLENLOOTTABLE["tier2"],GLOBAL.FALLENLOOTTABLE["tier3"])

local FALLENLOOTTABLE=GLOBAL.FALLENLOOTTABLE
local FALLENLOOTTABLEMERGED=GLOBAL.FALLENLOOTTABLEMERGED



-- Let the game know Wod is a male, for proper pronouns during the end-game sequence.
-- Possible genders here are MALE, FEMALE, or ROBOT
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "thief")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "barb")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "cleric")
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "druid")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "darkknight")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "monk")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "necromancer")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "wizard")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "tinkerer")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "paladin")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "ranger")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "bard")

local PetBuff = require "widgets/petbuff"




local isrpghudenabled=false
 for _, moddir in ipairs( GLOBAL.KnownModIndex:GetModsToLoad() ) do
        local its_modinfo = GLOBAL.KnownModIndex:GetModInfo(moddir)
        print("mod",its_modinfo.name,its_modinfo.priority)
        if(its_modinfo.name=="RPG HUD")then
            isrpghudenabled=true
            print("hud version",its_modinfo.description)
        end
    end
--if(isrpghudenabled)then
--HUD
--[[
table.insert(GLOBAL.EQUIPSLOTS, "PACK")
GLOBAL.EQUIPSLOTS.PACK = "pack"
local function inventorypostinit(component,inst)
    inst.components.inventory.maxslots = 55
    inst.components.inventory.numequipslots = 5
end
AddComponentPostInit("inventory", inventorypostinit)
table.insert(GLOBAL.EQUIPSLOTS, "NECK")
GLOBAL.EQUIPSLOTS.NECK = "neck"

    --default equip slots
    self:AddEquipSlot(EQUIPSLOTS.HANDS, "images/equipslots.xml", "equip_slot_hand.tex") --MOD
    self:AddEquipSlot(EQUIPSLOTS.BODY, "images/equipslots.xml", "equip_slot_body.tex")  --MOD
    self:AddEquipSlot(EQUIPSLOTS.HEAD, "images/equipslots.xml", "equip_slot_head.tex")  --MOD
    self:AddEquipSlot(EQUIPSLOTS.NECK, "images/equipslots.xml", "equip_slot_neck.tex")  --MOD
    self:AddEquipSlot(EQUIPSLOTS.PACK, "images/equipslots.xml", "equip_slot_pack.tex")  --MOD
function Inv:AddEquipSlot(slot, atlas, image, sortkey)
    sortkey = sortkey or #self.equipslotinfo
    table.insert(self.equipslotinfo, {slot = slot, atlas = atlas, image = image, sortkey = sortkey})
    table.sort(self.equipslotinfo, function(a,b) return a.sortkey < b.sortkey end)
    self.rebuild_pending = true
end

    for k, v in ipairs(self.equipslotinfo) do
        local slot = EquipSlot(v.slot, v.atlas, v.image, self.owner)
        self.equip[v.slot] = self.toprow:AddChild(slot)
        local x = -total_w/2 + (num_slots)*(W)+num_intersep*(INTERSEP - SEP) + (num_slots-1)*SEP + INTERSEP + W*(k-1) + SEP*(k-1)
        slot:SetPosition(x,0,0)
        table.insert(eslot_order, slot)
        
        local item = self.owner.components.inventory:GetEquippedItem(v.slot)
        if item then
            slot:SetTile(ItemTile(item))
        end

    end    

--RemapSoundEvent("dontstarve/music/music_FE","fa/music/fires")]]


--SaveGameIndex:GetCurrentCaveLevel()



local RELOAD = Action(1, true)
RELOAD.id = "RELOAD"
RELOAD.str = "Reload"
RELOAD.fn = function(act)
    if act.target and act.target.components.reloadable and act.invobject and act.invobject.components.reloading then
        return act.target.components.reloadable:Reload(act.doer, act.invobject)
    end

end
 
AddAction(RELOAD)
GLOBAL.ACTIONS.RELOAD = RELOAD

local action_old=ACTIONS.MURDER.fn

ACTIONS.MURDER.fn = function(act)

    local murdered = act.invobject or act.target
    if murdered and murdered.components.health then
                
        local obj=murdered.components.inventoryitem:RemoveFromOwner(false)

        if murdered.components.health.murdersound then
            act.doer.SoundEmitter:PlaySound(murdered.components.health.murdersound)
        end

        local stacksize = 1
        if murdered.components.stackable then
            stacksize = murdered.components.stackable.stacksize
        end

        if murdered.components.lootdropper then
--            for i = 1, stacksize do
                local loots = murdered.components.lootdropper:GenerateLoot()
                for k, v in pairs(loots) do
                    local loot = SpawnPrefab(v)
                    act.doer.components.inventory:GiveItem(loot)
                end      
--            end
        end

        act.doer:PushEvent("killed", {victim = obj})
        obj:Remove()

        return true
    end
end

local function newControlsInit(class)
    local under_root=class;
    if GetPlayer() and GetPlayer().newControlsInit then
        local xabilitybar = under_root:AddChild(Widget("abilitybar"))
        xabilitybar:SetPosition(0,-65,0)
        xabilitybar:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)
        xabilitybar:SetMaxPropUpscale(1.25)
        xabilitybar:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        xabilitybar:SetVAnchor(GLOBAL.ANCHOR_TOP)
        GetPlayer().newControlsInit(xabilitybar)
    end
    if GetPlayer() and GetPlayer().newStatusDisplaysInit then
        GetPlayer().newStatusDisplaysInit(class)
    end
    if GetPlayer() and GetPlayer().components and GetPlayer().components.xplevel then
--       GetPlayer():ListenForEvent("healthdelta", onhpchange)
        local xpbar = under_root:AddChild(XPBadge(class.owner))
        xpbar:SetPosition(0,-20,0)
        xpbar:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        xpbar:SetVAnchor(GLOBAL.ANCHOR_TOP)
        xpbar:SetLevel(GetPlayer().components.xplevel.level)
        xpbar:SetValue(GetPlayer().components.xplevel.currentxp,GetPlayer().components.xplevel.max)
        xpbar:SetPlayername(GetPlayer().fa_playername or GLOBAL.STRINGS.CHARACTER_TITLES[GetPlayer().prefab])
        GetPlayer():ListenForEvent("fa_playernamechanged", function(inst,data)
            xpbar:SetPlayername(data.playername)
        end,class.owner)
        GetPlayer():ListenForEvent("xpleveldelta", function(inst,data)
            xpbar:SetLevel(data.level)
            xpbar:SetValue(data.new,data.max)
        end,class.owner)

        GetPlayer():ListenForEvent("xplevelup", function(inst,data)
            inst.SoundEmitter:PlaySound("fa/levelup/levelup")
        end,class.owner)

        GetPlayer():ListenForEvent("killed", function(inst,data)
            local victim=data.victim
            local xp=GLOBAL.FA_MOBXP_TABLE[victim.prefab]
--            print("xp for",victim, xp)
            if(xp)then
                local default=xp.default
                if(xp.tagged)then
                    for k,v in pairs(xp.tagged) do
                        if(victim:HasTag(k))then
                            default=v
                            break
                        end
                    end

                end
                inst.components.xplevel:DoDelta(default)
            end
        end)
         GetPlayer():ListenForEvent("unlockrecipe", function(inst,data)
            inst.components.xplevel:DoDelta(GLOBAL.PROTOTYPE_XP)
        end,class.owner)



        if(GetPlayer().fa_playername==nil or GetPlayer().fa_playername=="")then
        GetPlayer():DoTaskInTime(0,function()
            GLOBAL.TheFrontEnd:PushScreen(FA_CharRenameScreen(GLOBAL.STRINGS.CHARACTER_TITLES[GetPlayer().prefab]))
        end)
        end
    end
end
--AddClassPostConstruct("screens/playerhud",newControlsInit)
AddClassPostConstruct("widgets/statusdisplays", newControlsInit)

local newFlowerPicked=function(inst,picker)

    if(picker and picker.components.sanity)then
        local delta=TUNING.SANITY_TINY
        local prefab=inst.prefab
        if(picker:HasTag("evil"))then
            if(prefab=="flower")then
                delta=-TUNING.SANITY_TINY
            elseif (prefab=="flower_evil")then
                delta=TUNING.SANITY_TINY
            end
        else
            if(prefab=="flower")then
                delta=TUNING.SANITY_TINY
            elseif (prefab=="flower_evil")then
                delta=-TUNING.SANITY_TINY
            end
        end
        picker.components.sanity:DoDelta(delta)
    end
    inst:Remove()
end

AddPrefabPostInit("flower", function(inst) inst.components.pickable.onpickedfn=newFlowerPicked end)
AddPrefabPostInit("flower_evil", function(inst) inst.components.pickable.onpickedfn=newFlowerPicked end)

AddPrefabPostInit("gunpowder", function(inst) 
    inst:AddComponent("reloading") 
    inst.components.reloading.ammotype="gunpowder"
    inst.components.reloading.returnuses=1
end)


local doSkeletonSpawn=function(inst)
    local skel=SpawnPrefab("skeletonspawn")
    skel:AddComponent("homeseeker")
    skel.components.homeseeker:SetHome(inst)
    skel.Transform:SetPosition(inst.Transform:GetWorldPosition())
    return skel
end

local startSkeletonSpawnTask=function(inst)
     local rng=math.random()*480*5
         inst:DoTaskInTime(rng, function() 
            inst:AddTag("hasSpawnedSkeleton")
            local skel=doSkeletonSpawn(inst)
            skel:ListenForEvent("death",function(skel) 
                inst:RemoveTag("hasSpawnedSkeleton") 
                startSkeletonSpawnTask(inst)
            end)
        end)
end

local spoiledSkeletonSpawn=function(inst)
    if(math.random()>0.5)then
        doSkeletonSpawn(inst)
    end
end

AddPrefabPostInit("meat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("cookedmeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("meat_dried",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("monstermeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("cookedmonstermeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("monstermeat_dried",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("hambat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)

AddPrefabPostInit("merm",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("orc",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("pigman",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("pigguard",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("bunnyman",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("goblin",function(inst) inst:AddTag("pickpocketable") end)

local mound_digcallback
-- could use new dlc code but that wouldnt work in non dlc version
local mound_reset=function(inst)
    print("in mound reset")
    if(inst.components.spawner)then
        inst.components.spawner:CancelSpawning()
    end
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.AnimState:PlayAnimation("gravedirt")
    inst.fa_digtime=nil
    if(GLOBAL.FA_DLCACCESS)then
        if(inst.components.hole)then
            inst.components.hole.canbury = false
        end
    end
    inst.components.workable:SetOnFinishCallback(mound_digcallback)
end

mound_digcallback=function(inst,worker)
    --                  who thought hardcoding stuff is great idea.... brute force override
--                onfinishcallback(inst,worker)
                
    inst.AnimState:PlayAnimation("dug")
    inst:RemoveComponent("workable")
    if(GLOBAL.FA_DLCACCESS)then
        if(inst.components.hole)then
            inst.components.hole.canbury = true
        end
    end
    if worker then
        if worker.components.sanity then
            worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
        end     
        local roll=math.random()
         print(roll,":",GLOBAL.GHOST_MOUND_SPAWN_CHANCE)
        if roll < GLOBAL.GHOST_MOUND_SPAWN_CHANCE then
                local ghost = SpawnPrefab("ghost")
                local pos = Point(inst.Transform:GetWorldPosition())
                pos.x = pos.x -.3
                pos.z = pos.z -.3
                if ghost then
                    ghost.Transform:SetPosition(pos.x, pos.y, pos.z)
                end
                elseif worker.components.inventory then
                    local item = nil
                    if math.random() < .5 then
                    local loots = 
                    {
                        nightmarefuel = 1,
                        amulet = 1,
                        gears = 1,
                        redgem = 5,
                        bluegem = 5,
                    }
                    item = GLOBAL.weighted_random_choice(loots)
                else
                    item = "trinket_"..tostring(math.random(GLOBAL.NUM_TRINKETS))
                end

                if item then
                    inst.components.lootdropper:SpawnLootPrefab(item)
                end
        end
    end
                inst.fa_digtime=GLOBAL.GetTime()
                inst.fa_digresettask=inst:DoTaskInTime(GLOBAL.MOUND_RESET_PERIOD,function() print("should reset mound") mound_reset(inst) end)
                inst.components.spawner:Configure( "skeletonspawn",GLOBAL.SKELETONSPAWNDELAY,GLOBAL.SKELETONSPAWNDELAY*math.random())
end

AddPrefabPostInit("mound",function(inst)
    inst:AddComponent( "spawner" )
    inst.components.spawner.spawnoffscreen=false
    inst.components.spawner.childname="skeletonspawn"
    inst.components.spawner.delay=GLOBAL.SKELETONSPAWNDELAY

    local oldsave=inst.OnSave
    inst.OnSave = function(inst, data)
        if(oldsave)then
            oldsave(inst,data)
        end
        if not inst.components.workable and inst.fa_digtime then
            data.fa_digtime=inst.fa_digtime
        end
    end        
    local oldload=inst.OnLoad
    inst.OnLoad = function(inst, data)
--    print("mound onload")
        if(oldload)then
            oldload(inst,data)
        end
        if data and data.dug or not inst.components.workable then
--        print("digtime", data.fa_digtime)
            if(data.fa_digtime)then
                inst.fa_digtime=data.fa_digtime
                inst.fa_digresettask=inst:DoTaskInTime(GLOBAL.MOUND_RESET_PERIOD-GLOBAL.GetTime()+inst.fa_digtime,function() mound_reset(inst) end)
            else
                inst.fa_digtime=GLOBAL.GetTime()
                inst.fa_digresettask=inst:DoTaskInTime(GLOBAL.MOUND_RESET_PERIOD,function() mound_reset(inst) end)
            end
        end
    end    

--i dont know if it's dug or not until after load... configure is starting the process... so i have to type same thing 3 times
    inst:DoTaskInTime(0,function()
--[[
        if(inst.components.spawner and inst.components.spawner.nextspawntime)then
--            print("spawner active: ",inst.components.spawner.nextspawntime)
--        return
        end
]]
        if(inst.components.workable )then
            local onfinishcallback=inst.components.workable.onfinish
            inst.components.workable:SetOnFinishCallback(mound_digcallback)      
        else
            local nexttime=inst.components.spawner.nextspawntime or GLOBAL.SKELETONSPAWNDELAY*math.random()
            inst.components.spawner:Configure( "skeletonspawn",GLOBAL.SKELETONSPAWNDELAY,nexttime)
        end
    end)

end)

AddPrefabPostInit("ghost",function(inst)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.lootdropper:AddChanceLoot("nightmarefuel",0.75)
    inst.components.lootdropper:AddChanceLoot("nightmarefuel",0.18) 
    inst:AddTag("undead")
end)

AddClassPostConstruct("brains/ghostbrain",function(class)
    
    local old_onstart=class.OnStart
    function class:OnStart()
        old_onstart(class)
        local newnodes={GLOBAL.WhileNode( function() print("turning?",self.inst.fa_turnundead) return self.inst.fa_turnundead~=nil end, "Turning", GLOBAL.Panic(self.inst))}
        local root=self.bt.root
        newnodes[1].parent=self.bt.root
        local newtable={}
        table.insert(newtable,newnodes[1])
        for k,v in ipairs(self.bt.root.children) do
            table.insert(newtable,v)
        end
        self.bt.root.children=newtable
    end
end)

local Dapperness=require "components/dapperness"
local dapperness_getdapperness_def=Dapperness.GetDapperness
--AddComponentPostInit("dapperness", function(component,inst) 
    function Dapperness:GetDapperness(owner)
        local d=dapperness_getdapperness_def(self,owner)
        if(owner and owner:HasTag("player") and owner.prefab=="cleric" and d<0)then
          --  print("got in dapperness nerf")
            d=d*2
        end
        return d
    end
--end)


local Armor=require "components/armor"
local armor_takedamage_def=Armor.TakeDamage
function Armor:TakeDamage(damage_amount, attacker, weapon,element)
        --dealing with elemental damage ONLY, as of now can't have both phys and ele damage at once, since damage_amount is just one
        local damagetype=element
        if(not damagetype and weapon and weapon.components.weapon and weapon.components.weapon.fa_damagetype) then
            damagetype=weapon.components.weapon.fa_damagetype
        elseif(attacker and attacker.fa_damagetype)then
            damagetype=attacker.fa_damagetype
        end
--        print("take damage from",damagetype)
        if(damagetype)then
            --ele dmg, ignore default behavior altogether
            if(self.fa_resistances and self.fa_resistances[damagetype] and self.fa_resistances[damagetype]~=0)then
                local absorbed = damage_amount * self.fa_resistances[damagetype];
                absorbed = math.floor(math.min(absorbed, self.condition))
                local leftover = damage_amount - absorbed
                --note: absorb % can be negative, in which case you are taking more damage - which is fine, but it shouldnt repair your gear
                --TODO should absorbing elemental damage damage the equipment?
                if(leftover>0)then
                    self:SetCondition(self.condition - absorbed)
                    if self.ontakedamage then
                        self.ontakedamage(self.inst, damage_amount, absorbed, leftover)
                    end
                end
                -- yes >1 will heal you now, it is fully intentional, fire elemental is getting healed by fire etc
                return leftover
            else
                return damage_amount
            end
        else
            --physical damage, goes through as it wouldve been
            return armor_takedamage_def(self,damage_amount,attacker,weapon)
        end
   
    end

--AddComponentPostInit("armor",function(component,inst)
AddClassPostConstruct("components/armor",function(component)
    component.fa_resistances=component.fa_resistances or {}
end)
AddClassPostConstruct("components/health",function(component)
    component.fa_resistances=component.fa_resistances or {}
end)

--TODO there's gotta be a better way... but not everything reads inventory/has armor, dodelta has no info on attack type or even a reason... 
local Combat=require "components/combat"
local combat_getattacked_def=Combat.GetAttacked
function Combat:GetAttacked(attacker, damage, weapon,stimuli,element)
    --print ("ATTACKED", self.inst, attacker, damage)
    local blocked = false
    local player = GetPlayer()
    local init_damage = damage

    self.lastattacker = attacker
    if self.inst.components.health and damage then   

            local damagetype=element
            if(not damagetype and weapon and weapon.components.weapon and weapon.components.weapon.fa_damagetype) then
                damagetype=weapon.components.weapon.fa_damagetype
            elseif(attacker and attacker.fa_damagetype)then
                damagetype=attacker.fa_damagetype
            end
--rog moisture modifiers
        if(damagetype and self.inst.components.moisture)then
            local percent=self.inst.components.moisture:GetMoisturePercent()
            if(percent>0)then
                local mod=GLOBAL.FA_WETTNESS_DAMAGE_MODIFIER[damagetype]
                if(mod)then
                    damage=damage+mod*percent*damage
                end
            end           
        end

        if self.inst.components.inventory then
            damage = self.inst.components.inventory:ApplyDamage(damage, attacker,weapon,damagetype)
        end
        if METRICS_ENABLED and GetPlayer() == self.inst then
            local prefab = (attacker and (attacker.prefab or attacker.inst.prefab)) or "NIL"
            GLOBAL.ProfileStatsAdd("hitsby_"..prefab,math.floor(damage))
            GLOBAL.FightStat_AttackedBy(attacker,damage,init_damage-damage)
        end
         --now i need to deal with health mods
        if(damagetype)then
            local res=self.inst.components.health.fa_resistances[damagetype]
            if(res) then damage=damage*(1-res) end
        end
--            print("damage",damage)
        --why are you so inclined to prevent healing by damage, silly klei?
        if damage~=0 and self.inst.components.health:IsInvincible() == false then

            self.inst.components.health:DoDelta(-damage, nil, attacker and attacker.prefab or "NIL")
            if self.inst.components.health:GetPercent() <= 0 then
                if attacker then
                    attacker:PushEvent("killed", {victim = self.inst})
                end

                if METRICS_ENABLED and attacker and attacker == GetPlayer() then
                    GLOBAL.ProfileStatsAdd("kill_"..self.inst.prefab)
                    GLOBAL.FightStat_AddKill(self.inst,damage,weapon)
                end
                if METRICS_ENABLED and attacker and attacker.components.follower and attacker.components.follower.leader == GetPlayer() then
                    GLOBAL.ProfileStatsAdd("kill_by_minion"..self.inst.prefab)
                    GLOBAL.FightStat_AddKillByFollower(self.inst,damage,weapon)
                end
                if METRICS_ENABLED and attacker and attacker.components.mine then
                    GLOBAL.ProfileStatsAdd("kill_by_trap_"..self.inst.prefab)
                    GLOBAL.FightStat_AddKillByMine(self.inst,damage)
                end
                
                if self.onkilledbyother then
                    self.onkilledbyother(self.inst, attacker)
                end
            end
        else
            blocked = true
        end
    end
    

    if self.inst.SoundEmitter then
        local hitsound = self:GetImpactSound(self.inst, weapon)
        if hitsound then
            self.inst.SoundEmitter:PlaySound(hitsound)
            --print (hitsound)
        end

        if self.hurtsound then
            self.inst.SoundEmitter:PlaySound(self.hurtsound)
        end

    end
    
    if not blocked then
         self.inst:PushEvent("attacked", {attacker = attacker, damage = damage, weapon = weapon, stimuli = stimuli})
    
        if self.onhitfn then
            self.onhitfn(self.inst, attacker, damage)
        end
        
       if attacker then
            attacker:PushEvent("onhitother", {target = self.inst, damage = damage, stimuli = stimuli})
            if attacker.components.combat and attacker.components.combat.onhitotherfn then
                attacker.components.combat.onhitotherfn(attacker, self.inst, damage, stimuli)
            end
        end
    else
        self.inst:PushEvent("blocked", {attacker = attacker})
    end
    
    return not blocked
end

local FIRE_TIMESTART = 1.0
local Health=require "components/health"

function Health:DoFireDamage(amount1, doer)
    if not self.invincible  then
        if not self.takingfiredamage then
            self.takingfiredamage = true
            self.takingfiredamagestarttime = GLOBAL.GetTime()
            self.inst:StartUpdatingComponent(self)
            self.inst:PushEvent("startfiredamage")
            GLOBAL.ProfileStatsAdd("onfire")
        end
        
        local time = GLOBAL.GetTime()
        self.lastfiredamagetime = time
        local amount=amount1

        if(self.fa_resistances[FA_DAMAGETYPE.FIRE])then
            self.fire_damage_scale=self.fa_resistances[FA_DAMAGETYPE.FIRE]
        end
        if(self.inst and self.inst.components and self.inst.components.inventory)then
            amount = self.inst.components.inventory:ApplyDamage(amount, doer,nil,FA_DAMAGETYPE.FIRE)
        end
        
        if time - self.takingfiredamagestarttime > FIRE_TIMESTART and amount ~= 0 then
            self:DoDelta(-amount*self.fire_damage_scale, false, "fire")
            self.inst:PushEvent("firedamage")       
        end
    end
end

local function onFishingCollect(inst,data)
    if(math.random()<=GLOBAL.FISHING_MERM_SPAWN_CHANCE)then
        local merm=SpawnPrefab("merm")
        local spawnPos = GLOBAL.Vector3(inst.Transform:GetWorldPosition() )
        merm.Transform:SetPosition(spawnPos:Get() )
    end
end

AddClassPostConstruct("screens/loadgamescreen", function(self)
    self.MakeSaveTile = (function()
        local MakeSaveTile = self.MakeSaveTile
 
        return function(self, slotnum, ...)
            local tile = MakeSaveTile(self, slotnum, ...)

            local cavelevel=GLOBAL.SaveGameIndex:GetCurrentCaveLevel(slotnum)
            local mode = GLOBAL.SaveGameIndex:GetCurrentMode(slotnum)

            if(mode == "cave")then
                print("cavelevel",cavelevel)
                local data=Levels.cave_levels[cavelevel]
                --second check just to exclude other mods or default caves etc..
                if(data and GLOBAL.FA_LEVELS[data.id])then
                    local day = GLOBAL.SaveGameIndex:GetSlotDay(slotnum)
--                    tile.text:SetString(("%s-%d"):format(data.name, day))
                    tile.text:SetString(("%s"):format(data.name))
                end
            end    
 
            return tile
        end
    end)()
end)
 
AddClassPostConstruct("screens/slotdetailsscreen", function(self)
    self.BuildMenu = (function()
        local BuildMenu = self.BuildMenu
 
        return function(self, ...)
            BuildMenu(self, ...)

            local cavelevel=GLOBAL.SaveGameIndex:GetCurrentCaveLevel(self.saveslot)
            local mode = GLOBAL.SaveGameIndex:GetCurrentMode(self.saveslot)

            if(mode == "cave")then
                print("cavelevel",cavelevel)
                local data=Levels.cave_levels[cavelevel]
                --second check just to exclude other mods or default caves etc..
                if(data and GLOBAL.FA_LEVELS[data.id])then
                    local day = GLOBAL.SaveGameIndex:GetSlotDay(slotnum)
                    self.text:SetString(("%s"):format(data.name))
                end
            end    

        end
    end)()
end)

AddPrefabPostInit("world", function(inst)

--    GLOBAL.assert( GLOBAL.GetPlayer() == nil )
    local player_prefab = GLOBAL.SaveGameIndex:GetSlotCharacter()
 
    -- Unfortunately, we can't add new postinits by now. So we have to do
    -- it the hard way...
 
    GLOBAL.TheSim:LoadPrefabs( {player_prefab} )
    local oldfn = GLOBAL.Prefabs[player_prefab].fn
    GLOBAL.Prefabs[player_prefab].fn = function()
        local inst = oldfn()
 
        local oldsavefn=inst.OnSave
        local oldloadfn=inst.OnLoad

        local onloadfn = function(inst, data)
            if(oldloadfn)then
                oldloadfn(inst,data)
            end
            inst.fa_prevcavelevel=data.fa_prevcavelevel
            print("prevcavelevel",inst.fa_prevcavelevel)
        end

        local onsavefn = function(inst, data)
            if(oldsavefn)then
                oldsavefn(inst,data)
            end
            data.fa_prevcavelevel=inst.fa_prevcavelevel
        end
        inst.OnLoad = onloadfn
        inst.OnSave = onsavefn
        inst.fa_prevcavelevel=0--should really default to current topology or so but meh
 
        return inst
    end
end)

local function UpdateWorldGenScreen(self, profile, cb, world_gen_options)
        print("level",world_gen_options.level_world)
        local data=Levels.cave_levels[world_gen_options.level_world]
        if(data and GLOBAL.FA_LEVELS[data.id])then
             GLOBAL.TheSim:LoadPrefabs {"MOD_"..modname}
            --TODO this crap should really be done differently
            if(data.id=="GOBLIN_CAVE" or data.id=="GOBLIN_CAVE_2" or data.id=="GOBLIN_CAVE_3" or data.id=="GOBLIN_CAVE_BOSSLEVEL")then
                self.bg:SetTint(GLOBAL.BGCOLOURS.RED[1],GLOBAL.BGCOLOURS.RED[2],GLOBAL.BGCOLOURS.RED[3], 1)
                self.worldanim:GetAnimState():SetBank("generating_goblin_cave")
                self.worldanim:GetAnimState():SetBuild("generating_goblin_cave")
                self.worldanim:GetAnimState():PlayAnimation("idle", true)

                self.verbs = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.GOBLIN.VERBS)
                self.nouns = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.GOBLIN.NOUNS)

--separate thread... cant do anything about it atm
--                self:ChangeFlavourText()
    
            elseif(data.id=="ORC_STRONGHOLD")then
                self.bg:SetTint(GLOBAL.BGCOLOURS.RED[1],GLOBAL.BGCOLOURS.RED[2],GLOBAL.BGCOLOURS.RED[3], 1)
                self.worldanim:GetAnimState():SetBank("generating_goblin_cave")
                self.worldanim:GetAnimState():SetBuild("generating_goblin_cave")
                self.worldanim:GetAnimState():PlayAnimation("idle", true)
            end
        end
       

        
end

AddClassPostConstruct("screens/worldgenscreen", UpdateWorldGenScreen)

local function setTopologyType(inst,type)
    local oldLoadPostPass = inst.LoadPostPass
    function inst:LoadPostPass(...)
        self.topology.level_type = type
        if oldLoadPostPass then
            return oldLoadPostPass(self, ...)
        end
    end
end

local function OrcMinesPostInit(inst)
    local waves = inst.entity:AddWaveComponent()

    waves:SetRegionSize( 40, 20 )
    waves:SetRegionNumWaves( 8 )
    waves:SetWaveTexture(GLOBAL.resolvefilepath("images/lava2.tex"))--GLOBAL.resolvefilepath("images/lava.tex")
    waves:SetWaveEffect( "shaders/waves.ksh" ) -- texture.ksh
    waves:SetWaveSize( 2048, 512 )

    GLOBAL.GetWorld().components.colourcubemanager:SetOverrideColourCube(
        GLOBAL.resolvefilepath "colour_cubes/lavacube.tex"
    )
--                setTopologyType(inst,"mines")        

                inst.IsCave=function() return false end

                if(not inst.components.seasonmanager)then
                    inst:AddComponent("SeasonManager")
                end
                inst.components.seasonmanager:AlwaysDry()
                inst.components.seasonmanager.current_season = GLOBAL.SEASONS.SUMMER
                inst.components.seasonmanager:AlwaysSummer()

                local startLavaRain=function()
                    if(not inst.fa_lavarain)then
                        inst.fa_lavarain=SpawnPrefab("fa_lavarain")
                        inst.fa_lavarain.persists=false
                    end
                    inst.fa_lavarain.entity:SetParent( GetPlayer().entity )
                    inst.fa_lavarain.particles_per_tick = 20
                    inst.fa_lavarain.splashes_per_tick = 10
                end

                local old_load=inst.OnLoad
                inst.OnLoad=function(inst,data)
                    if(old_load)then
                        old_load(inst,data)
                    end
                    if(data and data.fa_lavarain)then
                        startLavaRain()
                    end
                end
                local old_save=inst.OnSave
                inst.OnSave=function(inst,data)
                    if(old_save)then
                        old_save(inst,data)
                    end
                    if(inst.fa_lavarain)then
                        data.fa_lavarain=true
                    end
                end
                inst:ListenForEvent("startquake",function()
                    startLavaRain()
                end)
                inst:ListenForEvent("endquake",function()
                    inst.fa_lavarain:Remove()
                    inst.fa_lavarain=nil
                end)   

    inst:AddComponent("fawarzone")
    AddClassPostConstruct("widgets/controls", function(self, owner)
        self.clock:Kill()
        self.clock=self.sidepanel:AddChild(FAWarClock(owner))
    end)
end

AddPrefabPostInit("cave", function(inst)

    local level=GLOBAL.SaveGameIndex:GetCurrentCaveLevel()
    print("in cave postinit",level)
    if(level>3)then
        inst:RemoveComponent("periodicthreat")
        local data=Levels.cave_levels[level]
        if(data and GLOBAL.FA_LEVELS[data.id])then

            if(data.id=="ORC_MINES" or data.id=="DWARF_FORTRESS" or data.id=="ORC_FORTRESS")then
                OrcMinesPostInit(inst)
            end

            local quakerlootoverride=GLOBAL.FA_QUAKER_LOOT_OVERRIDE[data.id]
            if(quakerlootoverride)then
--                local quaker=require("components/quaker")
                local quaker=inst.components.quaker

                function quaker:GetDebris()
                    local rng = math.random()
                    local todrop = nil
                    if rng < 0.75 then
                            todrop = quakerlootoverride.common[math.random(1, #quakerlootoverride.common)]
                    elseif rng >= 0.75 and rng < 0.95 then
                            todrop = quakerlootoverride.rare[math.random(1, #quakerlootoverride.rare)]
                    else
                            todrop = quakerlootoverride.veryrare[math.random(1, #quakerlootoverride.veryrare)]
                    end
                    return todrop
                end
            end


            local threats=GLOBAL.FA_LEVEL_THREATS[data.id]
            local threatlist = require("fa_periodicthreats")
            if(threads)then
            for k,v in pairs(threats) do
                if(not inst.components.periodicthreat)then
                    inst:AddComponent("periodicthreat")
                end
                inst.components.periodicthreat:AddThreat(v,threatlist[v])
            end
            end
        end
    end
end)

AddSimPostInit(function(inst)

    if(inst:HasTag("player"))then
        --why the hell did they even add this...
        if(inst.components.eater.ablefoods)then
            table.insert( inst.components.eater.ablefoods, "FA_POTION" )
        end
        table.insert( inst.components.eater.foodprefs, "FA_POTION" )

        local sg=inst.sg.sg
        local old_onexit=sg.states["amulet_rebirth"].onexit
        sg.states["amulet_rebirth"].onexit=function(inst)
            old_onexit(inst)
            inst.components.health.invincible=true

            local boom = GLOBAL.CreateEntity()
            boom.entity:AddTransform()
            local anim=boom.entity:AddAnimState()
            boom:AddTag("NOCLICK")
            boom:AddTag("FX")
            boom.persists=false
            anim:SetBank("fa_shieldpuff")
            anim:SetBuild("fa_shieldpuff")
            anim:PlayAnimation("idle",false)
            local pos1 =inst:GetPosition()
            boom.Transform:SetPosition(pos1.x, pos1.y, pos1.z)
            boom:ListenForEvent("animover", function()  boom:Remove() end)

            inst:DoTaskInTime(10, function() inst.components.health.invincible=false end)
            return true
        end

        if inst:HasTag("evil") then

                local sanitymod=inst.components.sanity
                function sanitymod:Recalc(dt)
                
                    local total_dapperness = self.dapperness or 0
                    local mitigates_rain = false
                    for k,v in pairs (self.inst.components.inventory.equipslots) do
                        if v.components.dapperness and v.prefab~="nightsword" and v.prefab~="armor_sanity" then
                            total_dapperness = total_dapperness + v.components.dapperness:GetDapperness(self.inst)
                            if v.components.dapperness.mitigates_rain then
                              mitigates_rain = true
                            end
                        end     
                    end
    
                    local dapper_delta = total_dapperness*TUNING.SANITY_DAPPERNESS
    
                    local day = GetClock():IsDay() and not GetWorld():IsCave()
                    local light_delta=0
                    if day then 
                        light_delta = GLOBAL.SANITY_DAY_LOSS
                    end
    
                    local aura_delta = 0
                    local x,y,z = self.inst.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x,y,z, TUNING.SANITY_EFFECT_RANGE, nil, {"FX", "NOCLICK", "DECOR","INLIMBO"} )
                    for k,v in pairs(ents) do 

                        local override=EVIL_SANITY_AURA_OVERRIDE[v.prefab]
                        local aura_val=0
                        if(override~=nil)then
                            aura_val=override
                        elseif v.components.sanityaura and v ~= self.inst then
                            aura_val = v.components.sanityaura:GetAura(self.inst)
                        end
                        if(aura_val~=0)then
                            local distsq = self.inst:GetDistanceSqToInst(v)
                            aura_val = aura_val/math.max(1, distsq)
                            if aura_val < 0 then
                                aura_val = aura_val * self.neg_aura_mult
                            end
                            aura_delta = aura_delta + aura_val
                        end
                    end


                    local rain_delta = 0
                    if GetSeasonManager() and GetSeasonManager():IsRaining() and not mitigates_rain then
                        rain_delta = -TUNING.DAPPERNESS_MED*1.5* GetSeasonManager():GetPrecipitationRate()
                    end

                    self.rate = (dapper_delta + light_delta + aura_delta + rain_delta)  
--    print(self.rate,"light",light_delta)
    
                    if self.custom_rate_fn then
                        self.rate = self.rate + self.custom_rate_fn(self.inst)
                    end

                    self:DoDelta(self.rate*dt, true)
                end


        end
        if (inst.prefab=="darkknight" or inst.prefab=="cleric" or inst.prefab=="paladin") then
            --add shields
            local r=Recipe("woodenshield", {Ingredient("log", 20),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_ONE)
            r.image="woodshield.tex"
            r.atlas = "images/inventoryimages/woodshield.xml"
            local r=Recipe("rockshield", {Ingredient("rocks", 20),Ingredient("rope", 5)}, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_TWO)    
            r.image="rockshield.tex"
            r.atlas = "images/inventoryimages/rockshield.xml"
            local r=Recipe("marbleshield", {Ingredient("marble", 20),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_TWO)
            r.image="marbleshield.tex"
            r.atlas = "images/inventoryimages/marbleshield.xml"
            local r=Recipe("boneshield", {Ingredient("houndstooth", 10),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_ONE)
            r.image="boneshield.tex"
            r.atlas = "images/inventoryimages/boneshield.xml"
        end
        inst:ListenForEvent("fishingcollect",onFishingCollect)

            local leader=inst.components.leader
            for k,v in pairs(leader.followers) do
                if(k.prefab=="frog")then
--why is tag being lost?
--                if k:HasTag("fa_wonderswap") then

                    print("removing frog")
                    k:Remove()
                end
            end
            

        GetPlayer():DoTaskInTime(0,function()
            GLOBAL.FA_ElectricalFence.MakeGrid()
            GLOBAL.FA_ElectricalFence.StartTask()

        end)

    end
end)
--\
function lootdropperPostInit(component)
    local old_generateloot=component.GenerateLoot
    if(not component.fallenLootTables)then
            component.fallenLootTables={}
    end
    function component:AddFallenLootTable(lt,weight,chance)
        table.insert(self.fallenLootTables,{loottable=lt,weight=weight,chance=chance})
    end
    function component:GenerateLoot()
        local loots=old_generateloot(self)
        for ind,tabledata in pairs(self.fallenLootTables) do
            local chance=math.random()
            if(chance<=tabledata.chance)then
                local newloot=nil
                --pick one of...
                local rnd = math.random()*tabledata.weight
                for k,v in pairs(tabledata.loottable) do
                    rnd = rnd - v
                    if rnd <= 0 then
                        newloot=k
                        break
                    end
                end
                table.insert(loots, newloot)
            end
        end
        return loots
    end

    function component:DropLoot(pt)
    local prefabs = self:GenerateLoot()
    local burn=false
    if not self.inst.components.fueled and self.inst.components.burnable and self.inst.components.burnable:IsBurning() then
        burn=true
        for k,v in pairs(prefabs) do
            local cookedAfter = v.."_cooked"
            local cookedBefore = "cooked"..v
            if GLOBAL.PrefabExists(cookedAfter) then
                prefabs[k] = cookedAfter
            elseif GLOBAL.PrefabExists(cookedBefore) then
                prefabs[k] = cookedBefore 
            else   
            --this was burning everything in list regardless of wether it can be actually burned        
--                prefabs[k] = "ash"               
            end
        end
    end
    for k,v in pairs(prefabs) do
        local loot=self:SpawnLootPrefab(v, pt)
        --now i have to check if it should burn instead, is there anything else i should be checking here?
        if(burn and loot and loot.components.burnable)then
            loot.components.burnable:Ignite()
        end
    end
    end

end

local Hounded=require("components/hounded")
Hounded.attack_delays["rare"]=function() return TUNING.TOTAL_DAY_TIME * 9 + math.random() * TUNING.TOTAL_DAY_TIME * 3 end
Hounded.attack_delays["occasional"]=function() return TUNING.TOTAL_DAY_TIME * 9 + math.random() * TUNING.TOTAL_DAY_TIME * 3 end
Hounded.attack_delays["frequent"]=function() return TUNING.TOTAL_DAY_TIME * 9 + math.random() * TUNING.TOTAL_DAY_TIME * 3 end

Hounded.attack_levels=
{
    intro={warnduration= function() return 120 end, numhounds = function() return 2 end},
    light={warnduration= function() return 60 end, numhounds = function() return 2 + math.random(2) end},
    med={warnduration= function() return 60 end, numhounds = function() return 3 + math.random(3) end},
    heavy={warnduration= function() return 60 end, numhounds = function() return 4 + math.random(3) end},
    crazy={warnduration= function() return 60 end, numhounds = function() return 6 + math.random(4) end},
}

--AddComponentPostInit("hounded",function(component)
function Hounded:ReleaseHound(dt)
    local pt = GLOBAL.Vector3(GetPlayer().Transform:GetWorldPosition())
        
    local spawn_pt = self:GetSpawnPoint(pt)
    
    if spawn_pt then
        self.houndstorelease = self.houndstorelease - 1
        if(self.houndstorelease<2)then
            local prefab = "hound"
            local day = GetClock().numcycles
            local special_hound_chance = self:GetSpecialHoundChance()

    print("self.attacksizefn",self.attacksizefn)
    print("houndstorelease",self.houndstorelease)

            if(FA_DLCACCESS)then
                if GetSeasonManager() and GetSeasonManager():IsSummer() then
                    special_hound_chance = special_hound_chance * 1.5
                end
            end

            if math.random() < special_hound_chance then
                if GetSeasonManager():IsWinter() then
                    prefab = "icehound"
                else
                    prefab = "firehound"
                end
            end
        
            local hound = SpawnPrefab(prefab)
            if hound then
                hound.Physics:Teleport(spawn_pt:Get())
                hound:FacePoint(pt)
                hound.components.combat:SuggestTarget(GetPlayer())
            end
        else
            local hound = SpawnPrefab("goblin")
            if hound then
                hound.Physics:Teleport(spawn_pt:Get())
                hound:FacePoint(pt)
                hound.components.combat:SuggestTarget(GetPlayer())
            end
        end
    end
    
end    

AddComponentPostInit("lootdropper",lootdropperPostInit)

function makestackablePrefabPostInit(inst)
    if(not inst.components.stackable)then
    inst:AddComponent("stackable")
        inst.components.stackable.maxsize = 99
    end
end

AddPrefabPostInit("rabbit", makestackablePrefabPostInit)

AddPrefabPostInit("frog", function(inst) 
    if(inst and not inst.components.follower)then
        inst:AddComponent("follower")
    end
end)

function addT1LootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.tier1,FALLENLOOTTABLE.TABLE_TIER1_WEIGHT,chance)
end


function addT1T2LootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLE["tier1"],FALLENLOOTTABLE["tier2"]),FALLENLOOTTABLE.TABLE_TIER1_WEIGHT+FALLENLOOTTABLE.TABLE_TIER2_WEIGHT,chance)
end

function addFullLootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,chance)
end

--this has to be the only non-fx thing that doesn't have one...
AddPrefabPostInit("thulecite_pieces", function(inst) 
    if(not inst.SoundEmitter)then
        inst.entity:AddSoundEmitter() 
    end
end)

AddPrefabPostInit("rabbithole", function(inst) addT1LootPrefabPostInit(inst,0.05) end)

AddPrefabPostInit("merm", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("pigman", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("pigguard", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("bunnyman", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("orc", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("goblin", function(inst) addFullLootPrefabPostInit(inst,0.1) end)

AddPrefabPostInit("mermhouse", function(inst) addFullLootPrefabPostInit(inst,0.2) end)
AddPrefabPostInit("pighouse", function(inst) addFullLootPrefabPostInit(inst,0.2) end)
AddPrefabPostInit("rabbithouse", function(inst) addFullLootPrefabPostInit(inst,0.2) end)
AddPrefabPostInit("goblinhut", function(inst) addFullLootPrefabPostInit(inst,0.2) end)

AddPrefabPostInit("spiderden", function(inst) addT1LootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("poisonspiderden", function(inst) addT1LootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("spiderden_2", function(inst) addT1T2LootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("poisonspiderden_2", function(inst) addT1T2LootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("spiderden_3", function(inst) addFullLootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("poisonspiderden_3", function(inst) addFullLootPrefabPostInit(inst,0.15) end)

--mob resists
AddPrefabPostInit("firehound", function(inst) inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1 end)
AddPrefabPostInit("icehound", function(inst) inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1 end)
AddPrefabPostInit("deerclops", function(inst) inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1 end)
AddPrefabPostInit("lightninggoat", function(inst) inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1 end)

--DLC PATCHUP
if(GLOBAL.FA_DLCACCESS)then

    TUNING.NIGHTSTICK_DAMAGE=(0 or TUNING.NIGHTSTICK_DAMAGE)*1.5
    AddPrefabPostInit("nightstick",function(inst)
        inst.components.weapon.stimuli=nil
        inst.components.weapon.fa_damagetype=FA_DAMAGETYPE.ELECTRIC
    end)
    TUNING.ARMORDRAGONFLY_FIRE_RESIST=0
    AddPrefabPostInit("armordragonfly",function(inst)
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.FIRE]=0.85
    end)
end

AddModCharacter("barb")
AddModCharacter("druid")
AddModCharacter("paladin")

AddModCharacter("thief")
AddModCharacter("cleric")
AddModCharacter("darkknight")
AddModCharacter("monk")
AddModCharacter("necromancer")
AddModCharacter("wizard")
AddModCharacter("tinkerer")
AddModCharacter("ranger")
