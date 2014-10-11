--map格式  用三层，最底层远处，次底层近处，顶层实现遮挡跟动画
Map = {
farlayer = nil;
nearlayer = nil;
stops = {};
objects = {};
drawobjectspos = {};
}
Map.effectList = {}
Map.freeEffectList = {}
Map.mapHeight = 600
Map.mapWidth = 2000; 

function addStopPoint(x, y)
	Map.stop[x][y] = true 
end

function CanMove(x, y)
	return not Map.stop[x][y]
end

function addObject(id, effectid, targetx, targety)
	if effectConfig[effectid] then 
		Map.objects[id] = TFixEffect.create(effectConfig[effectid], targetx, targety)
	end
end

function addDrawObjectPosition(x, y , id)
	table.insert(Map.drawobjectspos,{x, y, id})
end

function createMapEffect(msg)
	if effectConfig[msg.id] then
		local effect = effectConfig[msg.id]
		effect = TFixEffect.create(effect, msg.targetx, msg.targety) 
		effect.effectid = msg.effectid	
		table.insert(Map.effectList, effect)
	end
end

function DeleteMapEffect(msg)
	for i, v in Map.effectList do
		if v.effectid == msg.effectid then
			table.insert(Map.freeEffectList,v)
			table.remove(Map.effectList,i)
		end
	end
end

