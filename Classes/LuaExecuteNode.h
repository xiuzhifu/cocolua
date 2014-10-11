#include "CCLuaStack.h"
#include "CCNode.h"
class LuaExecuteNode: public cocos2d::Node  
{
private:
		cocos2d::LuaStack* pEngine;
public:
	int count;
	int lastTick;
	unsigned int getTickCount();
	void load();
	void draw();
	void update(unsigned int delta);
	void dispatchMessage(int messageId);
	LuaExecuteNode(void);
	~LuaExecuteNode(void);
};

