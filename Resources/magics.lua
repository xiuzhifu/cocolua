effectList = {}
freeEffectList = {}
TEffect = {
--effect = {};
--effectid = 0;
--targetx = -1;
--targety = -1;
--sourcex = -1;
--sourcey = -1;
--count = 1;
--lasttick = 0;
--currentframe = 0;
--maxframe = 0;
--disappear = 0;
--drawx = 0;
--drawy = 0;
}
function TEffect.create(effect)
	if not effect then return nil end
	local index = table.maxn(freeEffectList)
	local t
	if index == 0 then
		t = {}
	else
		t = freeEffectList[index]
		table.remove(freeEffectList,index)
	end
	setmetatable(t, TEffect)
	TEffect.__index = TEffect;
	t.effect = effect
	t.count = t.effect.playCount
	t.lasttick = 0
	t.currentframe = 1
	t.maxframe = t.effect.frameCount
	t.disappear = false
	t.drawx = 0;
	t.drawy = 0;
	return t
end

function TEffect:run(tick)
	if tick - self.lasttick < self.effect.delay then return end 
	if self.currentframe <= self.maxframe then
		self.currentframe = self.currentframe + 1 
	else
		if self.count > 0 then 
			self.count = self.count - 1 
		elseif self.count == 0 then 
			self.disappear = true 
		end
	end
	return not disappear
end
--id = 1;
--images = 1;
--start = 1;
--framecount = 10;
--delay = 100;
--dir = 6;
--drawmode = 0
function TEffect:draw()
	if not disapper then
		age.draw(self.drawx, self.drawy, self.image, self.currentframe, true)
	end
end

TActorEffect = 
{
--actor = nil;
}
setmetatable(TActorEffect, TEffect)
TActorEffect.__index = TActorEffect;


function TActorEffect.create(effect, actor)
	if not actor then return nil end
	local t = TEffect.create(effect)
	setmetatable(t, TActorEffect)
	t.actor = actor
	return t
end
function TActorEffect:Run(tick)
	local x, y = Camera.getActorPos(self.actor)
	self.drawx = x + self.actor.offsetx
	self.drawy = y + self.actor.offsety
	return self:run(tick)
end

TFixEffect = 
{
--targetx
--targety
}
setmetatable(TFixEffect, TEffect)
TFixEffect.__index = TFixEffect;

function TFixEffect.create(effect, targetx, targety)
	local t = TEffect.create(effect)
	setmetatable(t, TFixEffect)
	t.targetx = targetx
	t.targety = targety
	return t
end
function TFixEffect:Run(tick)
	local x, y = Camera.getPos(self.targetx, self.targety)
	self.drawx = x
	self.drawy = y	
	return self:run(tick)
end

TFlyEffect = 
{
--targetx
--targety
}
setmetatable(TFlyEffect, TEffect)
TFlyEffect.__index = TFlyEffect;

function TFlyEffect.create(effect, targetx, targety, sourcex, sourcey, targeteffect, target)
	local t = TEffect.create(effect)
	setmetatable(t, TFlyEffect)
	t.targetx = targetx
	t.targety = targety
	t.sourcex = sourcex
	t.sourcey = sourcey
	t.starttick = gtick
	if targeteffect then t.targeteffect = effectid end
	if target then t.target = target end
	return t
end

function TFlyEffect:Run(tick)
	if target then
		self.targetx = target.x + target.offsetx
		self.targety = target.y + target.offsety
	end
	local srcx, srcy = Camera.getPos(self.sourcex, self.sourcey)
	local tarx, tary = Camera.getPos(self.targetx, self.targety)	
	local lenx = tarx - srcx
	local leny = tary - tary
	if math.abs(lenx) < 10 and math.abs(leny) < 10 then 
		if target then
			TActorEffect.create(self.targeteffect, actor)	
		else
			TFixEffect.create(self.targeteffect, self.targetx, self.targety)
		end
		return false 
	end
	local runx = (tick - starttick) * 0.7
	local runy = disx * leny / lenx
	if lenx > 0 then 
		self.drawx = srcx + runx
	else
		self.drawx = srcx - runx
	end
	if leny > 0 then
		self.drawy = srcy + runy
	else
		self.drawy = srcy - runy
	end
	return self:run(tick)
end
--[[
msg = {id, sourceactor, [target], [targetx, targety]}
]]--
function createMagic(msg)
	local effect
	if msg.id and magicConfig[msg.id] then
		local magic = magicConfig[msg.id]
		if sourceactor and magic.ready then
			sourceactor.addaeffect(magic.ready)
		end
		if magic.fly then
			if magic.exp and target then
				effect = TFlyEffect.create(magic.fly, 0, 0, sourceactor.x, sourceactor.y, magic.exp, target)
			elseif magic.exp then
				effect = TFlyEffect.create(magic.fly, targetx, targety, sourceactor.x, sourceactor.y, magic.exp)
			else
				effect = TFlyEffect.create(magic.fly, targetx, targety, sourceactor.x, sourceactor.y)
			end
		elseif magic.exp then
			if target then
				target.addaeffect(magic.exp)
			else
				effect = TFixEffect.create(magic.exp, targetx, targety)
			end
		end
	end
	if effect then table.insert(effectList,effect) end
end

messagehandler.addahandler(sm_maigc, createMagic)