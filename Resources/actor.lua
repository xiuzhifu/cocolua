actorlist = {}
freeActorList = {}
TActor = {}
TActor.__index = TActor;
--TActor.id = 0;
--TActor.x = 0;
--TActor.y = 0;
--TActor.lastx = 0;
--TActor.lasty = 0;
--TActor.offsetx = 0;
--TActor.offsety = 0;
--TActor.dir = 0;
--TActor.action = {};
--TActor.drawstart = 0;
--TActor.effectstart = 0;
--TActor.images = {}
--TActor.startframe = 0;
--TActor.currentframe = 0;
--TActor.maxframe = 0;
--TActor.framecount = 0;
--TActor.frametime = 0;
--TActor.lastframetime = 0;
--TActor.currentaction = 0;
--TActor.movestep = 0;
--TActor.alive = false;
--TActor.effectlist = {};
--TActor.actionlist = {};
function TActor.create(action, image ,drawstart, effectstart)
	local t = {};
	setmetatable(t, TActor)
	t.id = 0;
	t.x = 0;
	t.y = 0;
	t.lastx = 0;
	t.lasty = 0;
	t.offsetx = 0;
	t.offsety = 0;
	t.dir = 0;
	t.action = {};
	t.drawstart = 0;
	t.image = image
	t.startframe = drawstart;
	t.currentframe = 0;
	t.maxframe = 0;
	t.framecount = 0;
	t.frametime = 0;
	t.lastframetime = 0;
	t.currentaction = 0;
	t.movestep = 0;
	t.alive = false;
	t.effectlist = {};
	t.actionlist = {};
	for i1,v1 in pairs(action) do
		t.action[i1] = {}
		for i2,v2 in pairs(v1) do
			t.action[i1][i2] = v2
		end
	end
	if effectstart then
	t.effectstart = effectstart
	else
	t.effectstart = -1
	end
	actorlist[table.maxn(actorlist) + 1] = t;
	return t;
end
function TActor:recalcoffset(step)
	local t = aMapWidth * step / self.framecount;
	self.offsetx = math.floor(t) * (self.currentframe - self.startframe) * dir

	t = aMapHeight * step / self.framecount;
	self.offsety = math.floor(t) * (self.currentframe - self.startframe) * dir	 
end
function TActor:move(step, tick)
	if tick - self.lastframetime > self.frametime then
	self.currentframe = self.currentframe + 1
	self.lastframetime = tick
	if self.currentframe > self.maxframe then currentaction = 0 end
	end
	if step > 0 then recalcoffset(step) end
end
function TActor:draw(x, y)
	if dir == 1 then
	age.draw(x, y, self.image, self.drawstart + self.currentframe, false)
	if self.effectstart >= 0 then
	age.drawmagic(x, y, self.image, self.drawstart + self.currentframe, false)	
	end
	else
	age.draw(x, y, self.image, self.drawstart + self.currentframe, true)
	if self.effectstart >= 0 then
	age.drawmagic(x, y, self.image, self.drawstart + self.currentframe, true)	
	end
	end	
	
end
function TActor:recalcframe()
	local act;
	if self.currentaction == sm_walk then
		act = self.action.walk
		movestep = 2
	elseif self.currentaction == sm_run then
		act = self.action.run
		movestep = 4
	elseif self.currentaction == sm_hit then
		act = self.action.hit
		movestep = 0
	elseif self.currentaction == sm_magic then
		act = self.action.hit
		movestep = 0
	elseif self.currentaction == sm_behit then
		act = self.action.behit
		movestep = 0
	elseif self.currentaction == sm_death then
		act = self.action.death
		movestep = 0
	else
		act = self.action.stand
		movestep = 0
	end
	if act then
		self.currentframe = 0
		self.framecount = act.count
		self.startframe = act.start
		self.maxframe = self.currentframe + act.count - 1
		self.frametime = act.time
	end
end
function TActor:update(tick)
	if self.currentaction == 0 then handleaaction() end
	move(movestep, tick)
end
function TActor:handleaaction()
	local act = self.actionlist[1];
	if act then 
	self.currentaction = act.sign 
	if act.sign == sm_walk then
		self.x = act.x
		self.y = act.y
	end
	table.remove(self.actoinlist,1)
	end
	recalcframe()
end
function TActor:addaaction(action)
	table.insert(self.actionlist,action)
end
TPlayer = {}
setmetatable(TPlayer, TActor)
function TPlayer:new()
	local t = {}
	setmetatable(t, TPlayer);
	return t
end;

function TActor:addaeffect(effect)
	table.insert(self.effectlist, effect)
end

function T()
end

--[[
msg = {id , x, y, mark}
--]]
function createactor(msg)
	if msg.id > 0 and msg.id <= table.maxn(actorConfig)  then
		local actcfg = actorConfig[msg.id];
		local actor  = TActor:create(actcfg.action,  actcfg.images, actcfg.drawstart, actcfg.effectstar)
		actor.x = msg.x
		actor.y = msg.y
		actor.id = msg.mark
	end
end

function actormove(msg)
	for i, v in pairs(actorlist) do
	if v.id == msg.id then
		local act = {sign = sm_move, x = msg.wparaml, y = msg.wparamr}
		v.addaaction(act)
	end
	end	
end
messagehandler.addahandler(sm_walk, actormove)
messagehandler.addahandler(sm_createactor, createactor)
