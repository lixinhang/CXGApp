// ChatRoom.cpp
//

#include "ChatRoom.h"

#pragma warning(disable: 4996)

/*
long hex2dec(char * s)
{
	int L = (int)strlen(s);
	char c;
	long re = 0;
	while ((c = s++[0]))
	{
		if (c >= '0' && c <= '9')
		{
			c -= 48;
		}		
		else
		{
			c = c>'Z' ? c - 32 : c;
			c -= 'A' - 10;
		}
		re += c*pow(16.0, --L);
	}

	return re;
}

std::string unescape(char* str)
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	const int nMultiByte = 2;
#else
	int nByte = 0;
	const int nMultiByte = 3;
#endif

	char* re = (char*)calloc(strlen(str) + 1, 1);
	char* _str;
	char* _re = re;
	char code[5] = { 0 };
	wchar_t wc;
	int n;

	while (str)
	{
		_str = strchr(str, '%');
		if (!_str)
		{
			break;
		}

		if ((n = _str - str))
		{
			memcpy(_re, str, n);
			_re += n;
		}

		memset(code, 0, sizeof(code));
		if (_str[1] == 'u')
		{
			memcpy(code, _str + 2, 4);
			str = _str + 6;
			wc = hex2dec(code);
			memset(code, 0, 5);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
			WideCharToMultiByte(CP_OEMCP, NULL, &wc, -1, (char*)code, nMultiByte, NULL, FALSE);
			memcpy(_re, code, nMultiByte);
			_re += nMultiByte;
#else
			wcstombs(code, &wc, nMultiByte);
			nByte = (int)strlen(code);
			memcpy(_re, code, nByte);
			_re += nByte;
#endif
		}
		else
		{
			memcpy(code, _str + 1, 2);
			str = _str + 3;
			_re[0] = hex2dec(code);
			_re++;
		}
	}

	strcpy(_re, str);
	std::string rt(re);
	free(re);
	re = NULL;

	return rt;
}
*/

CChatRoom::CChatRoom(IChatRoomObserver* pObserver)
{
	m_pObserver = pObserver;
	m_pLink = NULL;

	m_bEnter = false;
	m_bConnect = false;
	m_nKeepLiveTimer = 0;
	m_nMasterId = "";
	m_nMasterNo = "";
	m_nRoomId = "";
	m_nRoomPort = 0;

	m_strToken.clear();
	m_strChatMsg = "";
	m_eMsgType = CR_MSG;

	m_SynchMutex = PTHREAD_MUTEX_INITIALIZER;

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	m_hEnter = CreateEvent(NULL, TRUE, FALSE, NULL);
#endif
}

CChatRoom::~CChatRoom()
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    StopTimer(m_nKeepLiveTimer);
#else
    pthread_detach(m_HeartBeat);
#endif
	
	if (m_pLink)
	{
		m_pLink->Close();
		m_pLink->Release();
	}

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	CloseHandle(m_hEnter);
#endif
}

void CChatRoom::SetToken(std::string strToken)
{
	m_strToken = strToken;
}


void CChatRoom::SetChatRoomInfo(ChatRoomInfo RoomInfo)
{
	m_nRoomId	= RoomInfo.nRoomId;
	m_nRoomPort = RoomInfo.nPort;
	m_nMasterId = RoomInfo.nMasterId;
	m_nMasterNo = RoomInfo.nMasterNo;

	for (int i = 0; i < MAX_CHAT_NODE; i++)
	{
		m_strRoomIp[i] = RoomInfo.strIp[i];
	}
}

void CChatRoom::OpenTCPLink(int nNodeNum)
{
	if (m_pLink)
	{
		m_pLink->Close();
		m_pLink->Release();
		m_pLink = NULL;
	}

	int nTry = 0;
	m_bConnect = false;
	while (nTry++ < 3)
	{
		m_pLink = new CRawLink();
		if (g_pLink != m_pLink){ g_pLink = m_pLink; }
		m_pLink->AttachSink(this);

		bool bRet = m_pLink->Open(m_strRoomIp[nNodeNum].c_str(), m_nRoomPort);
		if (bRet)
		{
			m_bConnect = true;
			break;
		}

		if (m_pLink)
		{
			m_pLink->Close();
			m_pLink->Release();
			m_pLink = NULL;
		}
	}
}

long CChatRoom::EnterChatRoom()
{
	if (m_bEnter)
	{
		return 0;
	}

	int nNodeNum = 0;
	{
		pthread_mutex_lock(&m_SynchMutex);

		while (nNodeNum < MAX_CHAT_NODE)
		{
			OpenTCPLink(nNodeNum);
			if (!m_bConnect){ nNodeNum++; }
			else{ break; }
		}

		if (!m_bConnect)
		{
			m_strChatMsg = ERR_CONNECT_FAILD;
			m_eMsgType = CR_ERROR;
			m_pObserver->OnError(m_eMsgType, m_strChatMsg);
			ExitChatRoom();
			return 0;
		}

		std::string jsonEnter = "{\"_method_\":\"Enter\",\"type\":\"0\",\"rid\":\"";
		jsonEnter += m_nRoomId;
		jsonEnter += "\",\"uid\":\"";
        //jsonEnter += m_nMasterId;
		jsonEnter += "\",\"uname\":\"hehe\",\"token\":\"";
		jsonEnter += m_strToken;
        jsonEnter += "\",\"md5\":\"RTYUI\",\"majorType\":\"0\",\"terminal\":\"2\",\"v\":\"0\"}";

		CPacket* pPacket = CPacket::CreateFromPayload((char*)jsonEnter.c_str(), (int)jsonEnter.length());
        pPacket->SetPacketAction(ENTER);
		pPacket->SetPacketType(0);
		m_pLink->SendPacket(pPacket);

		pthread_mutex_unlock(&m_SynchMutex);
	}

#if(CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)

	unsigned long dwCode = ::WaitForSingleObject(m_hEnter, MAX_WAIT_TIME * MULTIPLENUM);
	if (dwCode != WAIT_OBJECT_0)
	{
		m_strChatMsg = ERR_ENTER_FAILD;
		m_eMsgType = CR_ERROR;
		m_pObserver->OnChatRoom(m_eMsgType, m_strChatMsg);
		return 0;
	}

	m_nKeepLiveTimer = StartTimer(true, KEEPLIVE_INTERVAL * MULTIPLENUM, 50);
#else

    time_t curtime = time(NULL);
    if(!IsEnterChatRoom(curtime))
    {
        m_strChatMsg = ERR_ENTER_FAILD;
        m_eMsgType = CR_ERROR;
        //m_pObserver->OnChatRoom(m_eMsgType,"");
    }
	KeepLive();
#endif
	return nNodeNum;
}

void CChatRoom::UserList() {
    pthread_mutex_lock(&m_SynchMutex);
    std::string jsonUserList = "{\"pno\":\"1\",\"rpp\":\"40\",\"v\":\"0\"}";
    
    CPacket* pPacket = CPacket::CreateFromPayload((char*)jsonUserList.c_str(), (int)jsonUserList.length());
    pPacket->SetPacketAction(0);
    pPacket->SetPacketType(6);
    m_pLink->SendPacket(pPacket);
    pthread_mutex_unlock(&m_SynchMutex);
}

long CChatRoom::ReentryChatRoom(int nNodeNum)
{
	if (m_bEnter){ return nNodeNum; }

	{
		pthread_mutex_lock(&m_SynchMutex);

		OpenTCPLink(nNodeNum);
		if (!m_bConnect){ return EnterChatRoom(); }

		std::string jsonEnter = "{\"_method_\":\"Enter\",\"type\":\"0\",\"rid\":\"";
        jsonEnter += m_nRoomId;
		jsonEnter += "\",\"uid\":\"";
		jsonEnter += m_nMasterId;
		jsonEnter += "\",\"uname\":\"hehe\",\"token\":\"";
		jsonEnter += m_strToken;
        jsonEnter += "\",\"md5\":\"RTYUI\",\"majorType\":\"0\",\"terminal\":\"2\",\"v\":\"0\"}";

		CPacket* pPacket = CPacket::CreateFromPayload((char*)jsonEnter.c_str(), (int)jsonEnter.length());
        pPacket->SetPacketAction(ENTER);
		pPacket->SetPacketType(0);
		m_pLink->SendPacket(pPacket);

		pthread_mutex_unlock(&m_SynchMutex);
	}

#if(CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)

	unsigned long dwCode = ::WaitForSingleObject(m_hEnter, MAX_WAIT_TIME * MULTIPLENUM);
	if (dwCode != WAIT_OBJECT_0)
	{
		m_strChatMsg = ERR_REENTRY_FAILD;
		m_pObserver->OnChatRoom(CR_ERROR, m_strChatMsg);
		return nNodeNum;
	}

	m_nKeepLiveTimer = StartTimer(true, KEEPLIVE_INTERVAL * MULTIPLENUM, 50);
#else

    time_t curtime = time(NULL);
    if(!IsEnterChatRoom(curtime))
    {
        m_strChatMsg = ERR_ENTER_FAILD;
        m_eMsgType = CR_ERROR;
        m_pObserver->OnError(m_eMsgType, m_strChatMsg);
    }

	KeepLive();
#endif

	return nNodeNum;
}

void CChatRoom::ExitChatRoom()
{
	if (!m_bEnter)
	{
		return;
	}

	m_bEnter = false;

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	StopTimer(m_nKeepLiveTimer);
#else
	pthread_detach(m_HeartBeat);
#endif

	if (m_pLink != NULL)
	{
		m_pLink->Close();
		m_pLink->Release();
		m_pLink = NULL;
	}
}

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)

bool CChatRoom::OnTimer(int nTimeID)
{
	if (nTimeID == m_nKeepLiveTimer)
	{
		pthread_mutex_lock(&m_SynchMutex);

		time_t tStamp = time(NULL);

		std::string HreatBeat = "{\"randomNumber\":\"";
		HreatBeat += std::to_string(tStamp);
		HreatBeat += "\",\"v\":\"0\"}";

		CPacket* pPacket = CPacket::CreateFromPayload((char*)HreatBeat.c_str(), HreatBeat.length());
		pPacket->SetPacketType(KEEPLIVE);
		if (m_pLink)
		{
			m_pLink->SendPacket(pPacket);
		}

		pthread_mutex_unlock(&m_SynchMutex);
	}
	return true;
}

#else

void CChatRoom::KeepLive()
{
	if (m_bEnter)
	{
		pthread_attr_t attr;
		pthread_attr_init(&attr);
		pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

		time(&m_tLastTime);
		pthread_create(&m_HeartBeat, &attr, CChatRoom::SendHeartBeat, this);
	}
}

bool CChatRoom::IsEnterChatRoom(time_t current)
{
	time_t tstamp = time(NULL);
	while (tstamp - current <= MAX_WAIT_TIME)
	{
		if (m_bEnter){ break; }
		usleep(500000);
		time(&tstamp);
	}

	return m_bEnter;
}

void* CChatRoom::SendHeartBeat(void *arg)
{
	CChatRoom* pCt = (CChatRoom*)arg;
	time_t tStamp;
	while (pCt->m_bEnter)
	{
		time(&tStamp);
		if (tStamp - pCt->m_tLastTime >= KEEPLIVE_INTERVAL)
		{
            std::string HreatBeat = "{\"randomNumber\":\"";
            HreatBeat += std::to_string(tStamp);
            HreatBeat += "\",\"v\":\"0\"}";

			CPacket* pPacket = CPacket::CreateFromPayload((char*)HreatBeat.c_str(), (int)HreatBeat.length());
            pPacket->SetPacketAction(KEEPLIVE);
			pPacket->SetPacketType(0);
			if (pCt->m_pLink)
				pCt->m_pLink->SendPacket(pPacket);
			pCt->m_tLastTime = tStamp;
		}
		sleep(TICKER_TIME);
	}

	return 0;
}
#endif

void CChatRoom::SendChatMsg(std::string strMsg,std::string strMasterid, bool bPrivate)
{
   	pthread_mutex_lock(&m_SynchMutex);
    
    std::string jsonChatMsg = "{\"_method_\":\"";
    if(strMasterid.empty())
        jsonChatMsg += "SendPubMsg\",\"toMasterId\":\"";
    else
    {
        jsonChatMsg += "SendPrvMsg\",\"toMasterId\":\"";
        jsonChatMsg += strMasterid;
    }

    jsonChatMsg += "\",\"toMasterNick\":\"\",\"ct\":\"";
    jsonChatMsg += strMsg;
    jsonChatMsg += "\",\"pub\":\"";
    
    if(strMasterid.empty())
        jsonChatMsg += "1";
    else
        jsonChatMsg += "0";
    
    jsonChatMsg += "\",\"key\":\"\",\"code\":\"\",\"checksum\":\"0\",\"v\":\"0\"}";
    
    CPacket* pPacket = CPacket::CreateFromPayload((char*)jsonChatMsg.c_str(), (int)jsonChatMsg.length());
    pPacket->SetPacketType(2);
    
    if(strMasterid.empty())
        pPacket->SetPacketAction(SENDMSG);
    else
    {
        if(bPrivate)
            pPacket->SetPacketAction(SENDMSG_PRI);
        else
            pPacket->SetPacketAction(SENDMSG_PUB);
    }
    
    if (m_pLink)
        m_pLink->SendPacket(pPacket);
    
    pthread_mutex_unlock(&m_SynchMutex);
}

void CChatRoom::RequestUserInfo(std::string strUid, long nVersion)
{
    pthread_mutex_lock(&m_SynchMutex);
    
    std::string jsonRequest = "{\"bb\":\"";
    jsonRequest += strUid;
    jsonRequest += "\",\"v\":\"";
    jsonRequest += std::to_string(nVersion);
    jsonRequest += "\"}";
    
    CPacket* pPacket = CPacket::CreateFromPayload((char*)jsonRequest.c_str(), (int)jsonRequest.length());
    pPacket->SetPacketType(2);
    pPacket->SetPacketAction(4);
    
    if (m_pLink)
        m_pLink->SendPacket(pPacket);
    
    pthread_mutex_unlock(&m_SynchMutex);
}

void CChatRoom::RequestUserList(long nPageNo, long nMax, long nVersion)
{
    pthread_mutex_lock(&m_SynchMutex);
    
    std::string jsonRequest = "{\"pno\":\"";
    jsonRequest += std::to_string(nPageNo);
    jsonRequest += "\",\"rpp\":\"";
    jsonRequest += std::to_string(nMax);
    jsonRequest += "\",\"v:\":";
    jsonRequest += std::to_string(nVersion);
    jsonRequest += "\"}";
    
    CPacket* pPacket = CPacket::CreateFromPayload((char*)jsonRequest.c_str(), (int)jsonRequest.length());
    pPacket->SetPacketType(6);
    pPacket->SetPacketAction(0);
    
    if (m_pLink)
        m_pLink->SendPacket(pPacket);
    
    pthread_mutex_unlock(&m_SynchMutex);
}

void CChatRoom::OnLinkErr(CRawLink* pLink)
{
	if (pLink != m_pLink)
	{
		return;
	}

	pthread_mutex_lock(&m_SynchMutex);

	m_bEnter = false;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	StopTimer(m_nKeepLiveTimer);
#else
    pthread_detach(m_HeartBeat);
#endif

	if (m_pLink != NULL)
	{
		m_pLink->Close();
		m_pLink->Release();
		m_pLink = NULL;
	}

	m_strChatMsg = MSG_RECONNECT_CHAT;
	m_eMsgType = CR_RECONNECT;
	//m_pObserver->OnError(m_eMsgType,m_strChatMsg);

	pthread_mutex_unlock(&m_SynchMutex);
}

void CChatRoom::OnLinkPacket(CRawLink* pLink, CPacket* pPacket)
{
	if (pPacket == NULL)
	{
		return;
	}

	if (pPacket->GetPacketType() == ((3<<16) + 0))
	{
		return;
	}

	uLongf dlen = sizeof(char)* (MAX_BUF_SIZE);
	char* dbuf = (char*)malloc(dlen);
	memset(dbuf, 0, dlen);
	int nRet = uncompress((Bytef*)dbuf, &dlen, (Bytef*)pPacket->GetPayload(), pPacket->GetPacketSize());
	while (nRet != Z_OK)
	{
		if (dlen / MAX_BUF_SIZE > 10)
		{
			break;
		}

		dlen *= 2;
		free(dbuf);
		dbuf = (char*)malloc(dlen);
		memset(dbuf, 0, dlen);
		nRet = uncompress((Bytef*)dbuf, &dlen, (Bytef*)pPacket->GetPayload(), pPacket->GetPacketSize());
	}
    
    Json::Reader reader;
    Json::Value object;
    
    try
    {
        if (!reader.parse(dbuf, object))
        {
            if (dbuf){ free(dbuf); }
            return;
        }
    }
    catch (std::exception& e)
    {
        if (dbuf){ free(dbuf); }
        return;
    }
    
    std::string retcode = object["retcode"].asString();
    if(retcode != "000000")
    {
        int ncode = atoi(retcode.c_str());
        switch (ncode)
        {
            case 401005:
                m_pObserver->OnError(401005, (char*)ERR_ROOMID_INVALID);
                break;
            case 409004:
                m_pObserver->OnError(401005, (char*)ERR_REPETITION_LOGIN);
                break;
            case 409007:
                m_pObserver->OnError(401005, (char*)ERR_TERMINAl_MUTEX);
                break;
            case 402011:
                m_pObserver->OnError(402011, (char*)ERR_TERMINAl_MUTEX);
                break;
                
            default:
                break;
        }
        if (dbuf){ free(dbuf); }
        return;
    }
    
    
    Json::Value msgObj = object["msg"];
    if(msgObj.empty() || msgObj.size() <= 0)
    {
        if (dbuf){ free(dbuf); }
        return;
    }
    
    Json::Value::iterator itc = msgObj.begin();
    std::string action = "";
    std::string msgtype = "";
    int nMsgType = -1;
    int nAction = -1;
    while(itc != msgObj.end())
    {
        action = (*itc)["b"].asString();
        msgtype = (*itc)["c"].asString();
        nMsgType = atoi(msgtype.c_str());
        nAction = atoi(action.c_str());
        
        std::cout << "action = " << nAction << ", msgtype = " << nMsgType << std::endl;
        if (!m_bEnter && !nMsgType && !nAction)
        {
            Json::Value ctObj = (*itc)["ct"];
            if(!ctObj.empty())
            {
                std::string strMasterId = ctObj["bb"].asString();
                if(strMasterId == m_nMasterId)
                    m_bEnter = true;
            }
        }

        PtlBase* protocol = PtlBase::getProtocol( (nAction << 16 ) + nMsgType , itc);
        if(protocol)
            m_pObserver->OnMsg(protocol);
        ++itc;
    }

    if (dbuf){ free(dbuf); }
    return;
}
    /*
    switch(protocol->getRetCode()){
        case 0: // ok
//            printf("****** ok \n");
            if(protocol->isMsg()) {
                m_pObserver->OnMsg(protocol);
            }
            break;
        case 1: // error
            break;
        case 2:
            break;
        case 401001:
            break;
        case 401002:
            break;
        case 401005:  // invalid roomid
            m_pObserver->OnError(401005, ERR_REPETITION_LOGIN);
            break;
        case 401007:
            break;
        case 401011:
            break;
        case 401014:
            break;
        case 402001:
            break;
        case 402003:
            break;
        case 402004:
            break;
        case 402005:
            break;
        case 402007:
            break;
        case 402008:
            break;
        case 402009:
            break;
        case 402010:
            break;
        case 402012:
            break;
        case 402013:
            break;
        case 402014:
            break;
        case 402015:
            break;
        case 402016:
            break;
        case 402017:
            break;
        case 403001:
            break;
        case 403002:
            break;
        case 404001:
            break;
        case 404002:
            break;
        case 409004:
            if (m_pObserver)
            {
                m_eMsgType = CR_ERROR;
                m_strChatMsg = ERR_REPETITION_LOGIN;
                m_pObserver->OnError(1,"");
                ExitChatRoom();
            }
            return;
        case 409005:
            break;
            
    }
     */

long CChatRoom::AddRef()
{
	return CRefCount::AddRef();
}

long CChatRoom::Release()
{
	return CRefCount::Release();
}

std::string CChatRoom::GetErrMsg()
{
	return m_strChatMsg;
}

bool CChatRoom::IsEntered()
{
	return m_bEnter;
}

bool CChatRoom::IsConnect()
{
	return m_bConnect;
}

#define STACK_ARRAY(TYPE, LEN) static_cast<TYPE*>(::alloca((LEN)*sizeof(TYPE)))
std::string CChatRoom::Utf_8ToANSI(const std::string& strUtf8)
{
	int nLen = (int)strUtf8.size() * 4;
	char* pANSI = STACK_ARRAY(char, nLen);
	Utf_8ToANSI(strUtf8.c_str(), (int)strUtf8.size(), pANSI, &nLen);
	std::string strANSI = pANSI;
	strANSI.assign(pANSI, nLen);
	return strANSI;
}

std::string CChatRoom::ANSIToUtf_8(const std::string& strANSI)
{
	int nLen = (int)strANSI.size() * 4;
	char* pUtf_8 = STACK_ARRAY(char, nLen);
	ANSIToUtf_8(strANSI.c_str(), (int)strANSI.size(), pUtf_8, &nLen);
	std::string strUtf_8;
	strUtf_8.assign(pUtf_8, nLen);
	return strUtf_8;
}

bool CChatRoom::Utf_8ToANSI(const char* pUtf8, int nUtf_8Len, char* pANSI, int* ANSILen)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	int nUnicodeLen = MultiByteToWideChar(CP_UTF8, 0, pUtf8, nUtf_8Len, NULL, 0);
	wchar_t* pUnicode = new wchar_t[nUnicodeLen + 1];
	memset(pUnicode, 0, nUnicodeLen * 2 + 2);
	MultiByteToWideChar(CP_UTF8, 0, pUtf8, nUtf_8Len, pUnicode, nUnicodeLen);

	int nLen = WideCharToMultiByte(CP_ACP, 0, pUnicode, nUnicodeLen, NULL, 0, NULL, NULL);
	if (*ANSILen < nLen)
	{
		return false;
	}

	memset(pANSI, 0, *ANSILen);
	WideCharToMultiByte(CP_ACP, 0, pUnicode, nUnicodeLen, pANSI, nLen, NULL, NULL);
	*ANSILen = nLen;

	delete[] pUnicode;

#else
	size_t nUnicodeLen = mbstowcs(nullptr, pUtf8, 0);
	wchar_t* pUnicode = new wchar_t[nUnicodeLen + 1];
	memset(pUnicode, 0, nUnicodeLen * 2 + 2);
	mbstowcs(pUnicode, pUtf8, nUtf_8Len);

	size_t nLen = wcstombs(nullptr, pUnicode, 0);
	if (*ANSILen < nLen)
	{
		return false;
	}

	memset(pANSI, 0, *ANSILen);
	wcstombs(pANSI, pUnicode, nLen);

	delete[] pUnicode;

#endif
	return true;
}

bool CChatRoom::ANSIToUtf_8(const char* pANSI, int nANSILen, char* pUtf_8, int* Utf_8Len)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	int nUnicodeLen = MultiByteToWideChar(CP_ACP, 0, pANSI, nANSILen, NULL, 0);
	wchar_t* pUnicode = new wchar_t[nUnicodeLen + 1];
	memset(pUnicode, 0, nUnicodeLen * 2 + 2);
	MultiByteToWideChar(CP_ACP, 0, pANSI, nANSILen, pUnicode, nUnicodeLen);

	int nLen = WideCharToMultiByte(CP_UTF8, 0, pUnicode, nUnicodeLen, NULL, 0, NULL, NULL);
	if (*Utf_8Len < nLen)
	{
		return false;
	}

	memset(pUtf_8, 0, *Utf_8Len);
	WideCharToMultiByte(CP_UTF8, 0, pUnicode, nUnicodeLen, pUtf_8, nLen, NULL, NULL);
	*Utf_8Len = nLen;

	delete[] pUnicode;
#endif

	return true;
}

std::string CChatRoom::EscapeCode(std::string& str)
{
	EscapeCode(str, "&amp;", "&");
	EscapeCode(str, "&nbsp;", " ");
	EscapeCode(str, "&middot;", "");
	EscapeCode(str, "&rsquo;", "'");
	EscapeCode(str, "&lsquo;", "'");
	EscapeCode(str, "&ldquo;", "\"");
	EscapeCode(str, "&rdquo;", "\"");
	EscapeCode(str, "&quot;", "\"");
	EscapeCode(str, "&mdash;", "");
	EscapeCode(str, "&hellip;", "");
	EscapeCode(str, "&lt;", "<");
	EscapeCode(str, "&rarr;", "");
	EscapeCode(str, "&cap;", "");

	return str;
}

bool CChatRoom::EscapeCode(std::string& str, std::string oldchar, std::string newchar)
{
	std::string::size_type pos = str.find(oldchar);
	while (pos != std::string::npos)
	{
		str.replace(pos, oldchar.size(), newchar);
		pos = str.find(oldchar);
	}

	return true;
}
