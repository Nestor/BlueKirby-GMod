#pragma once

#define LUA state->luabase

typedef CBaseEntity* (__cdecl* Get_EntityFn) (int, bool);
Get_EntityFn Get_Entity;

inline bool bDataCompare(const BYTE* pData, const BYTE* bMask, const char* szMask)
{
	for( ; *szMask; ++szMask, ++pData, ++bMask )
			if( *szMask == 'x' && *pData != *bMask )
				return false;

	return ( *szMask ) == NULL;
}

DWORD dwFindPattern(DWORD dwAddress,DWORD dwLen,BYTE *bMask,char * szMask)
{
	for( DWORD i = NULL; i < dwLen; i++ )
		if( bDataCompare( (BYTE*) ( dwAddress + i ), bMask, szMask ) )
			return (DWORD)( dwAddress + i );

	return 0;
}

class ILuaInterface;

struct lua_State
{
	unsigned char				_ignore_this_common_lua_header_[69];
	ILuaInterface*				luabase;
};

struct UserData
{
	void*			data;
	unsigned char	type;
};

typedef int (*CFunc) (lua_State *L);

class ILuaInterface
{
public:
	virtual int				Top( void ) = 0;
	virtual void			Push( int iStackPos ) = 0;
	virtual void			Pop( int iAmt = 1 ) = 0;
	virtual void			GetTable( int iStackPos ) = 0;
	virtual void			GetField( int iStackPos, const char* strName ) = 0;
	virtual void			SetField( int iStackPos, const char* strName ) = 0; // 5
	virtual void			CreateTable() = 0;
	virtual void			SetTable( int i ) = 0;
	virtual void			SetMetaTable( int i ) = 0;
	virtual bool			GetMetaTable( int i ) = 0;
	virtual void			Call( int iArgs, int iResults ) = 0; // 10
	virtual int				PCall( int iArgs, int iResults, int iErrorFunc ) = 0;
	virtual int				Equal( int iA, int iB ) = 0;
	virtual int				RawEqual( int iA, int iB ) = 0;
	virtual void			Insert( int iStackPos ) = 0;
	virtual void			Remove( int iStackPos ) = 0; // 15
	virtual int				Next( int iStackPos ) = 0;
	virtual void*			NewUserdata( unsigned int iSize ) = 0;
	virtual void			ThrowError( const char* strError ) = 0;
	virtual void			CheckType( int iStackPos, int iType ) = 0;
	virtual void			ArgError( int iArgNum, const char* strMessage ) = 0; // 20
	virtual void			RawGet( int iStackPos ) = 0;
	virtual void			RawSet( int iStackPos ) = 0;

	virtual const char*		GetString( int iStackPos = -1, unsigned int* iOutLen = NULL ) = 0;
	virtual double			GetNumber( int iStackPos = -1 ) = 0;
	virtual bool			GetBool( int iStackPos = -1 ) = 0; // 25
	virtual CFunc			GetCFunction( int iStackPos = -1 ) = 0;
	virtual void*			GetUserdata( int iStackPos = -1 ) = 0;

	virtual void			PushNil() = 0;
	virtual void			PushString( const char* val, unsigned int iLen = 0 ) = 0; // 29
	virtual void			PushNumber( double val ) = 0;
	virtual void			PushBool( bool val ) = 0;
	virtual void			PushCFunction( CFunc val ) = 0;
	virtual void			PushCClosure( CFunc val, int iVars ) = 0;
	virtual void			PushUserdata( void* ) = 0;

	virtual int				ReferenceCreate() = 0;
	virtual void			ReferenceFree( int i ) = 0;
	virtual void			ReferencePush( int i ) = 0;

	virtual void			PushSpecial( int iType ) = 0;

	virtual bool			IsType( int iStackPos, int iType ) = 0;
	virtual int				GetType( int iStackPos ) = 0;
	virtual const char*		GetTypeName( int iType ) = 0;

	virtual void			CreateMetaTableType( const char* strName, int iType ) = 0;

	virtual const char*		CheckString( int iStackPos = -1 ) = 0;
	virtual double			CheckNumber( int iStackPos = -1 ) = 0;
};

typedef struct 
{
	int iCallback;
	int iCookie;
}	callback_t;

class CLuaShared 
{
public:
	virtual void padding00( void ) = 0;
	virtual void padding01( void ) = 0;
	virtual void padding02( void ) = 0;
	virtual void padding03( void ) = 0;
	virtual void padding04( void ) = 0;
	virtual void padding05( void ) = 0;
	virtual ILuaInterface* GetLuaInterface ( int iLuaState ) = 0;
};