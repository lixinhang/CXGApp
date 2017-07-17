//
//  LiveRoom.h
//  cxg
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 changyou. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "CXGChat.h"

typedef struct
{
    short   nZoneWorldId;
    short   nVIPLevel;
    
    int     nGUID_H;
    int     nGUID_L;
    int     nNeedSycee;
    
    char*   cAccont;
    char*   cUserName;
    
}USER_INFO;

@interface LiveRoom : NSObject
{
@private
    
    bool m_bRet;
    long m_nLiveId;
    
    long long m_nCid;
    
    NSString* m_sRetMsg;
    NSString* m_sCookies;
    NSString* m_sClientType;
    NSString* m_sCKey;
    NSString* m_sStreamName;
    NSString* m_sRequestTail;
    
    NSMutableDictionary* m_mdCookies;
    
    CHATROOM_INFO m_RoomInfo;
    pthread_mutex_t m_CallMutex;
}

//@property (nonatomic, strong) ChatInterface *chatManager;

-(bool) LoginWithOpt:(NSString*) opt;
-(bool) GetToekn;
-(bool) GetRoomListWithOrder:(int) order andZoneId:(short) zone andPageNo:(int) page;
-(bool) GetMicOrderWithRoomId:(unsigned long long) roomid;
-(bool) EnterLiveRoomWithMasterNo:(unsigned long long) master;

-(void) GetBannerList;
-(void) GetUserList;
-(void) GetUserIcon;
-(void) GetLiveStatusWithRoomId:(unsigned long long) roomid;
-(bool) GetRoomDetailInfoWithRoomId:(unsigned long long) roomid;

-(NSString*) GetStreamAdd;
-(NSString*) GetOptWithUserInfo:(USER_INFO) info;

-(CHATROOM_INFO) GetChatRoomInfo;

-(void) Init;
-(void) SetRequestString;
-(void) SetRoomInfo;

@end
