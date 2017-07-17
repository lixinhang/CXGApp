//
//  ShowRoom.m
//  cxg
//
//  Created by abc on 17/4/24.
//  Copyright © 2017年 changyou. All rights reserved.
//

#import "ShowRoom.h"

const NSString* TARGET_HOST_SHOW = @"http://tllm.cxg.changyou.com/";

@implementation ShowRoom

-(void) Init
{
    [self getRoomDetail];
    [self setLiveInfo];
    //[self getRtmp];
}

-(CHATROOM_INFO) getShowRoomInfo
{
    return m_roominfo;
}

-(NSString*) getRtmp
{
    NSDate* curdate = [NSDate date];
    NSString* timeStamp = [NSString stringWithFormat:@"%ld", (long)[curdate timeIntervalSince1970]];
    m_sStreamName = [NSString stringWithFormat:@"ld",m_nLiveid];
    m_sStreamName = [m_sStreamName stringByAppendingString:timeStamp];
    
    NSString* strUrl = @"http://gslb.";
    strUrl = [strUrl stringByAppendingString:(NSString*)TARGET_HOST_SHOW];
    strUrl = [strUrl stringByAppendingString:@"/show/push?name="];
    strUrl = [strUrl stringByAppendingString:m_sStreamName];
    strUrl = [strUrl stringByAppendingString:@"&t="];
    strUrl = [strUrl stringByAppendingString:timeStamp];
    strUrl = [strUrl stringByAppendingString:@"&optimal=1&type=liveroom&ver=2.0&sip=&y=&n=&btype=1"];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL];
    
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return m_sPushURL; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableContainers error:nil];
    
    NSString* code = [JsonValue objectForKey:@"code"];
    if(![code isEqualToString:@"000000"])
    {
        m_sRetMsg = [JsonValue objectForKey:@"msg"];
        return m_sPushURL;
    }
    
    m_sPushURL = [[JsonValue objectForKey:@"url"] stringValue];
    return m_sPushURL;
}

-(void) getRoomDetail
{
    m_roominfo.rid = 1200004301;
    
    
    NSDate* curdate = [NSDate date];
    NSString* timeStamp = [NSString stringWithFormat:@"%ld", (long)[curdate timeIntervalSince1970]];
    
    NSString* strUrl = (NSString*)TARGET_HOST_SHOW;
    strUrl = [strUrl stringByAppendingString:@"pd_hole.action?roomId="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%lld",m_roominfo.rid]];
    strUrl = [strUrl stringByAppendingString:@"&t="];
    strUrl = [strUrl stringByAppendingString:timeStamp];
    
    NSLog(@"strurl = %@",strUrl);
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest* Request = [NSMutableURLRequest requestWithURL:URL];
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"TLXCSID" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"UW42QTEJ3VVT4LJOYWQRZOH6DTEJDUGQAT57UPDWGNW3V4TYSZQOND4C4FJTYV63" forKey:NSHTTPCookieValue];
    
    [cookieProperties setObject:@"cxg.changyou.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"cxg,changyou.com" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];

    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    
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
        //NSLog(@"mic order dataObj = %@",dataObj);
        NSDictionary* RoomObj = [dataObj objectForKey:@"roomInfo"];
        m_roominfo.uid = [[RoomObj objectForKey:@"masterid"] longLongValue];
    
        NSDictionary* LiveObj = [dataObj objectForKey:@"liveInfo"];
        m_roominfo.cToken = (char*)[[LiveObj objectForKey:@"token"] UTF8String];
        m_nLiveid = [[LiveObj objectForKey:@"liveid"] longValue];
        
        NSDictionary* ChatObj = [dataObj objectForKey:@"chatInfo"];
        m_roominfo.nPort = [[ChatObj objectForKey:@"charNodePort"] intValue];
        m_roominfo.cIp = (char*)[[ChatObj objectForKey:@"chatNodeIp"] UTF8String];
    }
    
    if(!m_roominfo.nPort)
    {
        NSLog(@"get chat port error");
    }
}

-(void) setLiveInfo
{
    NSString* strUrl = (NSString*)TARGET_HOST_SHOW;
    strUrl = [strUrl stringByAppendingString:@"/pls_setRoomType.action?roomId="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%lld",m_roominfo.rid]];
    strUrl = [strUrl stringByAppendingString:@"&roomType=0&hd=0&result=json"];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL];
    
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableContainers error:nil];
    
    NSString* code = [JsonValue objectForKey:@"code"];
    if(![code isEqualToString:@"000000"])
    {
        m_sRetMsg = [JsonValue objectForKey:@"msg"];
        return;
    }
    
    m_nLiveid = [[JsonValue objectForKey:@"obj"] longValue];
    m_sKey = [[JsonValue objectForKey:@"key"] stringValue];
    m_sHid = [[JsonValue objectForKey:@"hid"] stringValue];
    m_nCDNType = [[JsonValue objectForKey:@"cdnType"] intValue];
}

-(bool) StartPushStream
{
    
    return [self DistributeStream];
    //return true;
}

-(bool) StopPushStream
{
    NSString* strUrl = (NSString*)TARGET_HOST_SHOW;
    strUrl = [strUrl stringByAppendingString:@"/pls_close.action?liveId="];
    strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",m_nLiveid]];
    strUrl = [strUrl stringByAppendingString:@"&closeCode=2&isRefresh=0"];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL];
    
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

-(bool) DistributeStream
{
    NSDate* curdate = [NSDate date];
    NSString* timeStamp = [NSString stringWithFormat:@"%ld", (long)[curdate timeIntervalSince1970]];
    NSString* cdnIp = [self getCDNip];
    
    NSString* strUrl = (NSString*)TARGET_HOST_SHOW;
    strUrl = [strUrl stringByAppendingString:@"/pls_open.action?key="];
    strUrl = [strUrl stringByAppendingString:m_sKey];
    strUrl = [strUrl stringByAppendingString:@"&name="];
    strUrl = [strUrl stringByAppendingString:m_sStreamName];
    strUrl = [strUrl stringByAppendingString:@"&rtmp="];
    strUrl = [strUrl stringByAppendingString:m_sPushURL];
    strUrl = [strUrl stringByAppendingString:@"&hid=3&hd=3&v=&terminal=1&isHide=0&cdnIp="];
    strUrl = [strUrl stringByAppendingString:@""]; //此处可以get cdn ip 上报
    strUrl = [strUrl stringByAppendingString:@"&t"];
    strUrl = [strUrl stringByAppendingString:timeStamp];
    
    NSURL* URL = [NSURL URLWithString:strUrl];
    NSURLRequest* Request = [NSURLRequest requestWithURL:URL];
    
    NSData* dataRes = [NSURLConnection sendSynchronousRequest:Request returningResponse:nil error:nil];
    if(dataRes == NULL){ return false; } //这里可以考虑再次发起请求
    NSDictionary* JsonValue = [NSJSONSerialization JSONObjectWithData:dataRes options:NSJSONReadingMutableContainers error:nil];
    
    NSString* code = [JsonValue objectForKey:@"codSe"];
    if(![code isEqualToString:@"000000"])
    {
        m_sRetMsg = [JsonValue objectForKey:@"msg"];
        return false;
    }
    
    return true;
}

-(NSString*) getCDNip
{
    return nil;
}

-(void)SetCookie
{
    NSURL *url = [NSURL URLWithString:@"http://dev.skyfox.org/cookie.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"username" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"my ios cookie" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"dev.skyfox.org" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"dev.skyfox.org" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];//设置失效时间
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieDiscard]; //设置sessionOnly
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

@end
