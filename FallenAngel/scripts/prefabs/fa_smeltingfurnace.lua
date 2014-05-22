local assets =
{
}

local slotpos = {}

for y = 0, 3 do
	table.insert(slotpos, Vector3(0, -y*75 + 114 ,0))
	table.insert(slotpos, Vector3(0 +75, -y*75 + 114 ,0))
end

local widgetbuttoninfo = {
	text = "Smelt",
	position = Vector3(0, -165, 0),
	fn = function(inst)
		inst.components.fafurnace:StartCooking()	
	end,
	
	validfn = function(inst)
		return inst.components.fafurnace:CanCook()
	end,
}


local function onhammered(inst, worker)
	if inst.components.fafurnace.product and inst.components.fafurnace.done then
		inst.components.lootdropper:AddChanceLoot(inst.components.fafurnace.product, 1)
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	
	inst.AnimState:PlayAnimation("hit_empty")
	
	if inst.components.fafurnace.cooking then
		inst.AnimState:PushAnimation("cooking_loop")
	elseif inst.components.fafurnace.done then
		inst.AnimState:PushAnimation("idle_full")
	else
		inst.AnimState:PushAnimation("idle_empty")
	end
	
end

local function itemtest(inst, item, slot)
	--to bother or not to bother? should prob add some tag
--	if cooking.IsCookingIngredient(item.prefab) then
		return true
--	end
end

--anim and sound callbacks

local function startcookfn(inst)
	inst.AnimState:PlayAnimation("cooking_loop", true)
	--play a looping sound
	inst.SoundEmitter:KillSound("snd")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
	inst.Light:Enable(true)
end


local function onopen(inst)
	inst.AnimState:PlayAnimation("cooking_pre_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", "open")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
	if not inst.components.stewer.cooking then
		inst.AnimState:PlayAnimation("idle_empty")
		inst.SoundEmitter:KillSound("snd")
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close", "close")
end

local function donecookfn(inst)
	inst.AnimState:PlayAnimation("cooking_pst")
	inst.AnimState:PushAnimation("idle_full")
	inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.fafurnace.product)
	
	inst.SoundEmitter:KillSound("snd")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish", "snd")
	inst.Light:Enable(false)
	--play a one-off sound
end

local function continuedonefn(inst)
	inst.AnimState:PlayAnimation("idle_full")
	inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.fafurnace.product)
end

local function continuecookfn(inst)
	inst.AnimState:PlayAnimation("cooking_loop", true)
	--play a looping sound
	inst.Light:Enable(true)

	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function harvestfn(inst)
	inst.AnimState:PlayAnimation("idle_empty")
end

local function getstatus(inst)
	if inst.components.fafurnace.cooking and inst.components.fafurnace:GetTimeToCook() > 15 then
		return "COOKING_LONG"
	elseif inst.components.fafurnace.cooking then
		return "COOKING_SHORT"
	elseif inst.components.fafurnace.done then
		return "DONE"
	else
		return "EMPTY"
	end
end

local function onfar(inst)
	inst.components.container:Close()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_empty")
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "cookpot.png" )
	
    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)
    
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .5)
    
    inst.AnimState:SetBank("cook_pot")
    inst.AnimState:SetBuild("cook_pot")
    inst.AnimState:PlayAnimation("idle_empty")

    inst:AddComponent("FAFurnace")
    inst.components.fafurnace.onstartcooking = startcookfn
    inst.components.fafurnace.oncontinuecooking = continuecookfn
    inst.components.fafurnace.oncontinuedone = continuedonefn
    inst.components.fafurnace.ondonecooking = donecookfn
    inst.components.fafurnace.onharvest = harvestfn
    
    
    
    inst:AddComponent("container")
    inst.components.container.itemtestfn = itemtest
    inst.components.container:SetNumSlots(4)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_backpack_2x4"
    inst.components.container.widgetanimbuild =  "ui_backpack_2x4"
    inst.components.container.widgetpos = Vector3(200,0,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.widgetbuttoninfo = widgetbuttoninfo
    inst.components.container.acceptsstacks = false
    inst.components.container.type = "cooker"

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose


    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus


    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerFar(onfar)


    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	MakeSnowCovered(inst, .01)    
	inst:ListenForEvent( "onbuilt", onbuilt)
    return inst
end


return Prefab( "common/fa_smeltingfurnace", fn, assets)