//
//  PtlUserMsg.cpp
//  Test2
//
//  Created by Lu Jinfei on 2017/3/2.
//  Copyright © 2017年 Lu Jinfei. All rights reserved.
//
#include "PtlBase.hpp"

PtlUserMsg::PtlUserMsg(int ret,Json::Value  buf):PtlBase(ret, buf) {
    printf( "chatroom: PtlUserMsg\n");
    this->type = 1;  // msg

    Json::Value::iterator itc = buf.begin();
    
    
    msg = buf["ct"].asString();
    
    userID = buf["e"]["bb"].asString();
    nickName = buf["e"]["p"].asString();
    user2ID = "";
    nickName2 = "";
    
    fensi = buf["e"]["b3"].asInt();
    caifu = buf["e"]["h"].asInt();
    jueseStr = buf["e"]["a1"].asString();
    gameUid = buf["e"]["a4"].asString();
    
    std::string typeStr = buf["b"].asString();
    int nType = atoi(typeStr.c_str());
    switch (nType)
    {
        case 0:
            this->subType = 0;
            break;
        case 1:
            this->subType = 3;
            break;
        case 2:
            this->subType = 4;
            user2ID = buf["f"]["bb"].asString();
            nickName2 = buf["f"]["p"].asString();
            gameUid2 = buf["f"]["a4"].asString();
            break;
        default:
            break;
    }
}

