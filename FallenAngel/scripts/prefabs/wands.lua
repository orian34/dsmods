local assets=
{
    Asset("ANIM", "anim/staffs.zip"),
    Asset("ANIM", "anim/swap_staffs.zip"), 
}

local prefabs = 
{
    "ice_projectile",
    "fire_projectile",
    "staffcastfx",
    "stafflight",
     "impact",
}

local MAGICMISSLE_USES=30
local ACIDARROW_USES=15
local FIREBALL_USES=10
local ICESTORM_USES=10
local SUNBURST_USES=10
local PRISMATICWALL_USES=5
local FIREWALL_USES=10

local FIREBALL_RADIUS=5
local ICESTORM_RADIUS=15
local SUNBURST_RADIUS=15
local FIREWALL_WIDTH=15
local FIREWALL_DEPTH=5
local PRISMATIC_WIDTH=15
local PRISMATIC_DEPTH=5

local MAGICMISSLE_DAMAGE=10
local ACIDARROW_DOT=5
local ACIDARROW_LENGTH=24
local FIREBALL_DAMAGE=100
local ICESTORM_LENGTH=120
local ICESTORM_DAMAGE=3
local SUNBURST_DAMAGE=100


local WAND_RANGE=15

local BOW_USES=20
local BOW_DAMAGE=20
local BOW_RANGE=15


local function onattackacidarrow(inst,attacker,target)
    --no stacking dots
    if(target.acidarrowtask)then
        target.acidarrowtask:Cancel()
    end
    target.acidarrowcounter=ACIDARROW_LENGTH
    target.acidarrowtask=target:DoPeriodicTask(2, function(inst)
        inst.components.combat:GetAttacked(attacker,ACIDARROW_DOT)
        if(inst and inst.acidarrowcounter and inst.acidarrowcounter>2)then
            inst.acidarrowcounter=inst.acidarrowcounter-2
        else
            inst.acidarrowtask:Cancel()
            inst.acidarrowtask=nil
        end 
    end)
    
end

local function onattackfireball(inst, attacker, target)
    --since i cant set weapon to aoe...
    local pos=Vector3(target.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, FIREBALL_RADIUS)
            for k,v in pairs(ents) do
                if  not v:IsInLimbo() then
                    if v.components.burnable and not v.components.fueled then
                     v.components.burnable:Ignite()
                    end

                    if(v.components.combat and not v==target) then
                        v.components.combat:GetAttacked(attacker, FIREBALL_DAMAGE, nil)
                    end
                end
            end
    local explode = SpawnPrefab("explode_small")
    local pos = inst:GetPosition()
    explode.Transform:SetPosition(pos.x, pos.y, pos.z)

    --local explode = PlayFX(pos,"explode", "explode", "small")
    explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    explode.AnimState:SetLightOverride(1)

    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end

local function onattacksunburst(inst,attacker,target)
local pos=Vector3(target.Transform:GetWorldPosition())
    local lightning = SpawnPrefab("lightning")
    lightning.Transform:SetPosition(pos:Get())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, SUNBURST_RADIUS)
            for k,v in pairs(ents) do
                if not v:HasTag("player") and not v:IsInLimbo()  and not v:HasTag("pet") and v.components.combat and not v==target then
                    if(v:HasTag("undead"))then
                       v.components.combat:GetAttacked(attacker, SUNBURST_DAMAGE, nil)
                    end
                end
            end
    local explode = SpawnPrefab("explode_small")
    local pos = inst:GetPosition()
    explode.Transform:SetPosition(pos.x, pos.y, pos.z)

    --local explode = PlayFX(pos,"explode", "explode", "small")
    explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    explode.AnimState:SetLightOverride(1)

    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end


---------COMMON FUNCTIONS---------
local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function commonfn(colour)

    local onequip = function(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", "swap_staffs",colour.."staff")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end

    local onunequip = function(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("staffs")
    anim:SetBuild("staffs")
    anim:PlayAnimation(colour.."staff")
    -------   
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="firestaff"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )


    
    return inst
end


local function magicmissile()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(MAGICMISSLE_DAMAGE)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
--    inst.components.weapon:SetOnAttack(onattack_red)
    inst.components.weapon:SetProjectile("fire_projectile")

    inst.components.finiteuses:SetMaxUses(MAGICMISSLE_USES)
    inst.components.finiteuses:SetUses(MAGICMISSLE_USES)

    return inst
end

local function acidarrow()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(ACIDARROW_DOT)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackacidarrow)
    inst.components.weapon:SetProjectile("fire_projectile")

    inst.components.finiteuses:SetMaxUses(ACIDARROW_USES)
    inst.components.finiteuses:SetUses(ACIDARROW_USES)

    return inst
end

local function fireball()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(FIREBALL_DAMAGE)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackfireball)
    inst.components.weapon:SetProjectile("fire_projectile")

    inst.components.finiteuses:SetMaxUses(FIREBALL_USES)
    inst.components.finiteuses:SetUses(FIREBALL_USES)

    return inst
end

local function icestorm()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(BOW_DAMAGE)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
--    inst.components.weapon:SetOnAttack(onattack_red)
    inst.components.weapon:SetProjectile("fire_projectile")

    inst.components.finiteuses:SetMaxUses(ICESTORM_USES)
    inst.components.finiteuses:SetUses(ICESTORM_USES)
end

local function sunburst()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(BOW_DAMAGE)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattacksunburst)
    inst.components.weapon:SetProjectile("fire_projectile")

    inst.components.finiteuses:SetMaxUses(SUNBURST_USES)
    inst.components.finiteuses:SetUses(SUNBURST_USES)

    return inst
end

local function firewall()
    local inst = commonfn("red")

    inst.components.finiteuses:SetMaxUses(FIREWALL_USES)
    inst.components.finiteuses:SetUses(FIREWALL_USES)

    return inst
end

local function prismaticwall()
    local inst = commonfn("red")

    inst.components.finiteuses:SetMaxUses(PRISMATICWALL_USES)
    inst.components.finiteuses:SetUses(PRISMATICWALL_USES)

    return inst
end 

return Prefab("common/inventory/magicmissilewand", magicmissile, assets, prefabs),
    Prefab("common/inventory/acidarrowwand", acidarrow, assets, prefabs),
    Prefab("common/inventory/fireballwand", fireball, assets, prefabs),
    Prefab("common/inventory/icestormwand", icestorm, assets, prefabs),
    Prefab("common/inventory/firewallwand", firewall, assets, prefabs),
    Prefab("common/inventory/sunburstewand", sunburst, assets, prefabs),
    Prefab("common/inventory/prismaticwand", prismaticwall, assets, prefabs)