
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

		-- Don't forget to include your character's custom assets!
        Asset( "ANIM", "anim/cleric.zip" ),
}
local prefabs = {}

STRINGS.TABS.SPELLS = "Spells"
RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex"}--, icon_atlas = "images/inventoryimages/herotab.xml"}

STRINGS.NAMES.SPELL_DIVINEMIGHT = "Divine Might"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_DIVINEMIGHT = "Divine Might"
STRINGS.RECIPE_DESC.SPELL_DIVINEMIGHT = "Divine Might"

STRINGS.NAMES.SPELL_CALLDIETY = "Call Diety"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_CALLDIETY = "Call Diety"
STRINGS.RECIPE_DESC.SPELL_CALLDIETY = "Call Diety"

STRINGS.NAMES.SPELL_LIGHT = "Banish Darkness"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_LIGHT = "Banish Darkness"
STRINGS.RECIPE_DESC.SPELL_LIGHT = "Banish Darkness"

STRINGS.NAMES.SPELL_HEAL = "Heal"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_HEAL = "Heal"
STRINGS.RECIPE_DESC.SPELL_HEAL = "Heal"



local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	inst.components.sanity.night_drain_mult=1.25
	inst.components.health:SetMaxHealth(200)
	inst.components.sanity:SetMax(300)
	inst.components.hunger:SetMax(125)

    inst:AddComponent("reader")

    local booktab=RECIPETABS.SPELLS
--    inst.components.builder:AddRecipeTab(booktab)
    local r=Recipe("spell_divinemight", {Ingredient("papyrus", 2), Ingredient("nightmarefuel", 2)}, booktab, {SCIENCE = 0, MAGIC = 0, ANCIENT = 0})
    r.image="book_brimstone.tex"
    r=Recipe("spell_calldiety", {Ingredient("papyrus", 2), Ingredient("nightmarefuel", 2)}, booktab,{MAGIC = 2})
    r.image="book_brimstone.tex"
    r=Recipe("spell_light", {Ingredient("papyrus", 2), Ingredient("seeds", 1), Ingredient("poop", 1)}, booktab, {MAGIC = 2})
    r.image="book_gardening.tex"
    r=Recipe("spell_heal", {Ingredient("papyrus", 2), Ingredient("redgem", 1)}, booktab, {MAGIC = 3})
    r.image="book_gardening.tex"

end



return MakePlayerCharacter("cleric", prefabs, assets, fn)
