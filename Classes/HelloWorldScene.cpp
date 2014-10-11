#include "HelloWorldScene.h"
#include "CCEventListenerTouch.h"
#include "LuaExecuteNode.h"

USING_NS_CC;


Scene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Layer::init() )
    {
        return false;
    }
    // add the sprite as a child to this layer
	LuaExecuteNode* exenode = new LuaExecuteNode;
	this->addChild(exenode);
    return true;
}
