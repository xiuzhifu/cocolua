
#include "cocos2d.h"
#include "LuaExecuteNode.h"
#include "CCScriptSupport.h"
//#include "lua.h"
//#include "lualib.h"
USING_NS_CC;
unsigned int LuaExecuteNode::getTickCount()
{
    struct timeval tv;
    if(gettimeofday(&tv, 0))
        return 0;
    return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
}
LuaExecuteNode::LuaExecuteNode(void)
{
	pEngine = LuaStack::create();
	pEngine->retain();
	const std::vector<std::string> paths = cocos2d::FileUtils::getInstance()->getSearchPaths();
	std::string s = paths.at(0);
	s = s + "mygame/luagame/src";
	pEngine->addSearchPath(s.c_str());
    //std::string path = cocos2d::FileUtils::getInstance()->fullPathForFilename("scene.lua");
    int ret = pEngine->executeScriptFile("mygame//luagame//src//scene.lua");
	load();
	dispatchMessage(1);
}

LuaExecuteNode::~LuaExecuteNode(void)
{
}

void LuaExecuteNode::load()
{
	pEngine->executeGlobalFunction("load");
}

void LuaExecuteNode::draw()
{
	update(getTickCount());
	int ret = pEngine->executeGlobalFunction("draw");
	if (ret != 0)
	{
		ret = 1000;
	}
}
void LuaExecuteNode::update(unsigned int delta)
{
	if (delta - lastTick >= 1000)
	{
		lastTick = delta;
		//CCLOG("%d",count);
		count = 0;
		
	}
	count ++;
	if (count == 30)
	{
	dispatchMessage(2);
	}
	pEngine->setGlobalFunction("update");
	pEngine->pushInt(delta);
	int ret = pEngine->executeFunction(1);
	if (ret != 0)
	{
		ret = 1000;
	}
}

void LuaExecuteNode::dispatchMessage(int messageId)
{
	lua_State * luastate = pEngine->getLuaState();
	switch(messageId)
	{
	case 1:
			//取出函数
			lua_getglobal(luastate, "messagehandler");
			lua_pushstring(luastate, "onreveiced");
			lua_gettable(luastate, -2);
			//传参数，
			lua_newtable(luastate);
			lua_pushstring(luastate, "id");
			lua_pushinteger(luastate, 100);
			lua_settable(luastate, -3);	
			lua_pushstring(luastate, "x");
			lua_pushinteger(luastate, 2);
			lua_settable(luastate, -3);	
			lua_pushstring(luastate, "y");
			lua_pushinteger(luastate, 2);
			lua_settable(luastate, -3);	
			lua_pushstring(luastate, "mark");
			lua_pushinteger(luastate, 1);
			lua_settable(luastate, -3);		
			lua_pushstring(luastate, "sign");
			lua_pushinteger(luastate, 1007);
			lua_settable(luastate, -3);	
			
			pEngine->executeFunction(1);
		break;
	case 2:	
			//取出函数
			lua_getglobal(luastate, "messagehandler");
			lua_pushstring(luastate, "onreveiced");
			lua_gettable(luastate, -2);
			//传参数，
			lua_newtable(luastate);
			lua_pushstring(luastate, "id");
			lua_pushinteger(luastate, 100);
			lua_settable(luastate, -3);	
			lua_pushstring(luastate, "dir");
			lua_pushinteger(luastate, 2);
			lua_settable(luastate, -3);	
			lua_pushstring(luastate, "sign");
			lua_pushinteger(luastate, 1008);
			lua_settable(luastate, -3);	
			
			pEngine->executeFunction(1);		
			break;
	default: break;
	}
		

}
