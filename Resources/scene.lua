package.path = package.path..";d:\\EverBox\\mygame\\luagame\\src\\?.lua";
image = nil;
function load()
image = love.createimage("Background.bmp");
end
function update(tick)
	updateActor(tick)
	updateMagic(tick)
end

function updateMagic(tick)
	for i, effect in pairs(effectList) do
		effect:run(tick)
	end
	local index = table.maxn(effectList)
	if index > 0 then
		local effect = effectList[index]
		table.insert(freeEffectList,effect)
		table.remove(effectList,index)
	end
end

function updateActor(tick)
	for i, actor in pairs(actorList) do
		actor:update(tick)
	end
	local index = table.maxn(actorList)
	if index > 0 then
		local actor = actorList[index]
		table.insert(freeActorList,actor)
		table.remove(actorList,index)
	end
end

function draw()
--	love.drawimage(100, 200, image)
--	love.drawimage(200, 200, image)
	drawMap(); --œ»ª≠¡Ω≤„µÿÕº
	for row = Camera.top, Camera.bottom do
		drawMapObjectInRow(row)
		drawMapEffectInRow(row)
		drawActorInRow(row)
	end
	drawMagic();
end

function drawMagic()
	for i, effect in pairs(effectList) do
		effect:draw()
	end
end
function drawActorInRow(row)
	for i in pairs(actorlist) do
	local actor = actorlist[i]
	if actor.y == row then
		local incamera , x, y
		incamera, x, y = Camera.isActorInCamera(actor)
		if incamera then actor:draw(x, y) end
	end
	end;
end
-- id ,targetx, targety
function drawMapEffectInRow(row)
	for i, v in Map.effectList do
		if v.targety == row and Camera.XInCamera(v.targetx) then
			v:draw()
		end
	end
end

function drawMapObjectInRow(row)
	for i, v in Map.drawobjectspos do
		if v.y == row and Camera.XInCamera(v.x) then Map.objects[v.id]:draw() end
	end
end
function drawMap()


end
