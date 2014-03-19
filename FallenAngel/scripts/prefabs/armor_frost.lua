local assets=
{
	Asset("ANIM", "anim/armor_frost.zip"),
  Asset("ATLAS", "images/inventoryimages/frostarmor.xml"),
  Asset("IMAGE", "images/inventoryimages/frostarmor.tex"),
}

local ARMORFROST_ABSORPTION_T1=0.70
local ARMORFROST_ABSORPTION_T2=0.80
local ARMORFROST_ABSORPTION_T3=0.95
local ARMORFROST_DURABILITY_T1=1000
local ARMORFROST_DURABILITY_T2=1500
local ARMORFROST_DURABILITY_T3=2000
local ARMORFROST_SLOW_T1 = 0.9
local ARMORFROST_SLOW_T2 = 0.93
local ARMORFROST_SLOW_T3 = 0.95
local ARMORFROST_PROC_T1=0.1
local ARMORFROST_PROC_T2=0.2
local ARMORFROST_PROC_T3=0.3
local ARMORFROST_COLDNESS=1

local function OnBlocked(inst,owner,data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
    if(data and data.attacker and math.random()<=inst.procRate)then
        print("reflecting to",data.attacker)
        if  data.attacker.components.burnable and  data.attacker.components.burnable:IsBurning() then
            data.attacker.components.burnable:Extinguish()
        end
        if data.attacker.components.freezable then
            data.attacker.components.freezable:AddColdness(ARMORFROST_COLDNESS)
            data.attacker.components.freezable:SpawnShatterFX()
        end
    end
end

local function onequip(inst, owner) 
--    owner.AnimState:OverrideSymbol("swap_body", "armor_marble", "swap_body")
     inst:ListenForEvent("attacked", function(owner,data) OnBlocked(inst,owner,data) end,owner)
    inst:ListenForEvent("blocked",function(owner,data) OnBlocked(inst,owner,data) end, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "frostarmor.tex" )
    
    inst.AnimState:SetBank("armor_marble")
    inst.AnimState:SetBuild("armor_frost")
    inst.AnimState:PlayAnimation("anim")
    
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
     inst.components.inventoryitem.atlasname = "images/inventoryimages/frostarmor.xml"
    inst.components.inventoryitem.imagename="frostarmor"
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORMARBLE, TUNING.ARMORMARBLE_ABSORPTION)
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
--    inst.components.equippable.walkspeedmult = TUNING.ARMORMARBLE_SLOW
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

local function t1()
    local inst =fn()
    inst:AddTag("tier1")
    inst.procRate=ARMORFROST_PROC_T1
    inst.components.armor:InitCondition(ARMORFROST_DURABILITY_T1, ARMORFROST_ABSORPTION_T1)
    inst.components.equippable.walkspeedmult = ARMORFROST_SLOW_T1
    return inst
end

local function t2()
    local inst =fn()
    inst:AddTag("tier2")
    inst.procRate=ARMORFROST_PROC_T2
    inst.components.armor:InitCondition(ARMORFROST_DURABILITY_T2, ARMORFROST_ABSORPTION_T2)
    inst.components.equippable.walkspeedmult =  ARMORFROST_SLOW_T2
    return inst
end

local function t3()
    local inst =fn()
    inst:AddTag("tier3")
    inst.procRate=ARMORFROST_PROC_T3
    inst.components.armor:InitCondition(ARMORFROST_DURABILITY_T3, ARMORFROST_ABSORPTION_T3)
    inst.components.equippable.walkspeedmult =  ARMORFROST_SLOW_T3
    return inst
end

return Prefab( "common/inventory/armorfrost", t1, assets), 
Prefab( "common/inventory/armorfrost2", t2, assets),
Prefab( "common/inventory/armorfrost3", t3, assets)
