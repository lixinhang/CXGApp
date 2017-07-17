//
//  ShowRoom.h
//  cxg
//
//  Created by abc on 17/4/24.
//  Copyright © 2017年 changyou. All rights reserved.
//

#import "LiveRoom.h"

@interface ShowRoom : NSObject
{
@private
    
    //unsigned long long m_nMasterid;
    //unsigned long long m_nRoomid;
    long m_nLiveid;
    int  m_nCDNType;
    
    NSString* m_sPushURL;
    NSString* m_sRetMsg;
    
    //NSString* m_sToken;
    NSString* m_sStreamName;
    
    NSString* m_sKey;
    NSString* m_sHid;
    
    CHATROOM_INFO m_roominfo;
}

-(NSString*) getRtmp;
-(NSString*) getCDNip;

-(bool) StartPushStream;
-(bool) DistributeStream;
-(bool) StopPushStream;

-(void) setLiveInfo;
-(void) getRoomDetail;
-(CHATROOM_INFO) getShowRoomInfo;

-(void) Init;

@end
