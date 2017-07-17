//
//  LiveRoom.m
//  cxg
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 changyou. All rights reserved.
//

#import "LiveRoom.h"


const NSString* VERSION = @"0";
const NSString* CLENT_TYPE = @"2";
const NSString* TARGET_HOST = @"http://tllm.cxg.changyou.com";


@implementation LiveRoom

-(void) Init
{
    USER_INFO myinfo;
    
    myinfo.nZoneWorldId = 9031;
    myinfo.nGUID_H = 591856129;
    myinfo.nGUID_L = 311546606;
    myinfo.nVIPLevel = 9;
    myinfo.nNeedSycee = 900;
    myinfo.cUserName = "sun";
    myinfo.cAccont = "ellan@changyou.com";
    
    /*
    myinfo.nZoneWorldId = 40;
    myinfo.nGUID_H = 2621952;
    myinfo.nGUID_L = 401830351;
    myinfo.nVIPLevel = 4;
    myinfo.nNeedSycee = 2092;
    myinfo.cUserName = "sjrzlb01";
    myinfo.cAccont = "rain_sunflower@changyou.com";
    */
    
    [self SetRequestString];
    
    NSString* opt = [self GetOptWithUserInfo:myinfo];
    if(opt != NULL)
    {
        [self LoginWithOpt:opt];
        
        //直播拉流逻辑
        [self GetRoomListWithOrder:3 andZoneId:9015 andPageNo:1];
        [self GetUserIcon];
        [self EnterLiveRoomWithMasterNo:m_RoomInfo.mid];
        [self GetMicOrderWithRoomId:m_RoomInfo.rid];
        [self GetRoomDetailInfoWithRoomId:m_RoomInfo.rid];
    }
}

-(CHATROOM_INFO) GetChatRoomInfo
{
    return m_RoomInfo;
}

-(NSString*) GetOptWithUserInfo:(USER_INFO)info
{
    NSString* strUrl = (NSString*)TARGET_HOST;
    strUrl = [strUrl stringByAppendingString:@"/appMakeOpt.action?a="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%d",info.nZoneWorldId]];
    strUrl = [strUrl stringByAppendingString:@"&b="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%d",info.nGUID_L]];
    strUrl = [strUrl stringByAppendingString:@"&c="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%d",info.nGUID_H]];
    strUrl = [strUrl stringByAppendingString:@"&d="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithUTF8String:info.cAccont]];
    //strUrl = [strUrl stringByAppendingString:@"&e="];
    //strUrl = [strUrl stringByAppendingString:[NSString stringWithUTF8String:info.cUserName]];
    //strUrl = [strUrl stringByAppendingString:@"&f="];
    //strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%d",info.nVIPLevel]];
    //strUrl = [strUrl stringByAppendingString:@"&g="];
    //strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%d",info.nNeedSycee]];
    strUrl = [strUrl stringByAppendingString:@"&h=7100&i=0"];
    strUrl = [strUrl stringByAppendingString:m_sRequestTail];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    NSString* opt = NULL;
    
    if(dataRes == NULL){ return opt; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableLeaves error:nil];
    int code = [[JsonValue objectForKey:@"c"] intValue];
    if(!code)
    {
        opt = [JsonValue objectForKey:@"o"];
    }

    return opt;
}

-(bool) LoginWithOpt:(NSString *)opt
{
    //pthread_mutex_lock(&m_CallMutex);
    
    NSString* strUrl = (NSString*)TARGET_HOST;
    strUrl = [strUrl stringByAppendingString:@"/appLogin.action?o="];
    strUrl = [strUrl stringByAppendingString:opt];
    strUrl = [strUrl stringByAppendingString:m_sRequestTail];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return false; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableLeaves error:nil];

    int code = [[JsonValue objectForKey:@"c"] intValue];
    if(code)
    {
        m_sRetMsg = [JsonValue objectForKey:@"m"];
        return false;
    }
    else
    {
        m_sClientType = [JsonValue objectForKey:@"ct"];
        NSString* cookieValue = [JsonValue objectForKey:@"ts"];
        NSString* cookieKey = [JsonValue objectForKey:@"tcn"];
        
        m_sCookies = cookieKey;
        m_sCookies = [m_sCookies stringByAppendingString:@"="];
        m_sCookies = [m_sCookies stringByAppendingString:cookieValue];
        //m_sCookies = [m_sCookies stringByAppendingString:@""];
    }
    
    return true;
}

-(bool) GetToekn
{
    return true;
}

-(bool) GetRoomListWithOrder:(int)order andZoneId:(short)zone andPageNo:(int)page
{
    NSString* strUrl = (NSString*)TARGET_HOST;
    strUrl = [strUrl stringByAppendingString:@"/appRoomList.action?a=-1&b="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%d",order]];
    strUrl = [strUrl stringByAppendingString:@"&c="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%d",zone]];
    strUrl = [strUrl stringByAppendingString:@"&n="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%d",page]];
    strUrl = [strUrl stringByAppendingString:@"&s=28&ct="];
    strUrl = [strUrl stringByAppendingString:m_sClientType];
    strUrl = [strUrl stringByAppendingString:m_sRequestTail];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    //NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //for (NSHTTPCookie *cookie in [cookieJar cookies])
    //{
    //    NSLog(@"-- cookies = %@ ------------", cookie);
    //}
    
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return false; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableContainers error:nil];
    NSString* code = [JsonValue objectForKey:@"code"];
    if(![code isEqualToString:@"000000"])
    {
        m_sRetMsg = [JsonValue objectForKey:@"msg"];
        return false;
    }
    
    NSArray* dataObj = [JsonValue objectForKey:@"obj"];
    
    NSLog(@"%@", dataObj);
    if(dataObj != NULL)
    {
        //保存到本地的房间序列
        m_RoomInfo.mid = 8114;//[[[dataObj objectAtIndex:0] objectForKey:@"h"] longValue];
        //m_RoomInfo.uid = [[[dataObj objectAtIndex:1] objectForKey:@"f"] longValue];
        //这个uid 是主播的uid 不是观众自己的uid
        m_RoomInfo.rid = 2200013203;//[[[dataObj objectAtIndex:0] objectForKey:@"k"] longLongValue];
        
        NSLog(@"dataRes = %lld",m_RoomInfo.rid);
    }
    return true;
}

-(bool) GetMicOrderWithRoomId:(unsigned long long)roomid
{
    
    NSString* strUrl = (NSString*)TARGET_HOST;
    strUrl = [strUrl stringByAppendingString:@"/appOrderInfo.action?r="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%lld",roomid]];
    strUrl = [strUrl stringByAppendingString:@"&ct="];
    strUrl = [strUrl stringByAppendingString:m_sClientType];
    strUrl = [strUrl stringByAppendingString:m_sRequestTail];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return false; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dataRes = %@",JsonValue);
    
    NSString* code = [JsonValue objectForKey:@"code"];
    if(![code isEqualToString:@"000000"])
    {
        m_sRetMsg = [JsonValue objectForKey:@"msg"];
        return false;
    }

    NSDictionary* dataObj = [JsonValue objectForKey:@"obj"];
    if(dataObj != NULL)
    {
        //NSLog(@"mic order dataObj = %@",dataObj);
        NSDictionary* MicObj = [dataObj objectForKey:@"a"];
        NSDictionary* Obj = [MicObj objectForKey:@"1"];

        m_nCid = [[Obj objectForKey:@"m"] intValue];
        m_sCKey = [Obj objectForKey:@"p"];
        m_sStreamName = [Obj objectForKey:@"i"];
    }
    
    return true;
}

-(bool)EnterLiveRoomWithMasterNo:(unsigned long long)master
{
 
    NSString* strUrl = (NSString*)TARGET_HOST;
    strUrl = [strUrl stringByAppendingString:@"/appFl.action?m="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%lld",master]];
    strUrl = [strUrl stringByAppendingString:@"&ct="];
    strUrl = [strUrl stringByAppendingString:m_sClientType];
    strUrl = [strUrl stringByAppendingString:m_sRequestTail];
    
    NSURL* URL = [NSURL URLWithString:strUrl ];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return false; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableContainers error:nil];
    
    NSString* code = [JsonValue objectForKey:@"code"];
    if(![code isEqualToString:@"000000"])
    {
        m_sRetMsg = [JsonValue objectForKey:@"msg"];
        return false;
    }
    
    return true;
}

-(void) GetUserIcon
{
    NSString* strUrl = (NSString*)TARGET_HOST;
    strUrl = [strUrl stringByAppendingString:@"/appGetUserIcon.action?ct="];
    strUrl = [strUrl stringByAppendingString:m_sClientType];
    strUrl = [strUrl stringByAppendingString:m_sRequestTail];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableContainers error:nil];
    
    NSString* code = [JsonValue objectForKey:@"code"];
    if(![code isEqualToString:@"000000"])
    {
        m_sRetMsg = [JsonValue objectForKey:@"msg"];
        return;
    }
    
    NSDictionary* dataObj = [JsonValue objectForKey:@"obj"];
    if(dataObj != NULL)
    {
        //NSLog(@"room detail dataObj = %@",dataObj);
        m_RoomInfo.uid = [[dataObj objectForKey:@"b"] longValue];
    }
}

-(void) GetUserList
{}

-(void) GetLiveStatusWithRoomId:(unsigned long long)roomid
{}

-(bool) GetRoomDetailInfoWithRoomId:(unsigned long long)roomid
{
     NSLog(@"roomid = %lld",roomid);
    
    NSString* strUrl = (NSString*)TARGET_HOST;
    strUrl = [strUrl stringByAppendingString:@"/appPdHole.action?roomId="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%lld",roomid]];
    strUrl = [strUrl stringByAppendingString:@"&ct="];
    strUrl = [strUrl stringByAppendingString:m_sClientType];
    strUrl = [strUrl stringByAppendingString:m_sRequestTail];

    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return false; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableContainers error:nil];

    NSString* code = [JsonValue objectForKey:@"code"];
    if(![code isEqualToString:@"000000"])
    {
        m_sRetMsg = [JsonValue objectForKey:@"msg"];
        return false;
    }
    
    NSDictionary* dataObj = [JsonValue objectForKey:@"obj"];
    if(dataObj != NULL)
    {
        //NSLog(@"room detail dataObj = %@",dataObj);
        
        NSDictionary* LiveObj = [dataObj objectForKey:@"b"];
        m_nLiveId = [[LiveObj objectForKey:@"a"] intValue];
        m_RoomInfo.cToken = (char*)[[LiveObj objectForKey:@"q"] UTF8String];
        
        NSDictionary* ChatObj = [dataObj objectForKey:@"c"];
        m_RoomInfo.nPort = [[ChatObj objectForKey:@"a"] intValue];
        m_RoomInfo.cIp = (char*)[[ChatObj objectForKey:@"b"] UTF8String];
    }
    
    if(m_RoomInfo.cIp == NULL || !m_RoomInfo.nPort)
    {
        return false;
    }
    
    return true;
}

-(void) GetBannerList
{
}

-(NSString*) GetStreamAdd
{
    return NULL;
}

-(void) SetRoomInfo
{}

-(void) SetRequestString
{
    m_sRequestTail = @"&t=";
    m_sRequestTail = [m_sRequestTail stringByAppendingString: (NSString*)CLENT_TYPE];
    m_sRequestTail = [m_sRequestTail stringByAppendingString: @"&v="];
    m_sRequestTail = [m_sRequestTail stringByAppendingString: (NSString*)VERSION];
    
    //NSLog(@"requesttail = %@",m_sRequestTail);
}


@end
