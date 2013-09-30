//Get the value of convars from clients without the need for client side lua. 
//Blue Kirby


#undef _UNICODE

#pragma comment(lib,"tier0.lib")
#pragma comment(lib,"tier1.lib")
#pragma comment(lib,"vstdlib.lib")
#pragma comment(linker,"/NODEFAULTLIB:libcmt")


#include <Windows.h>

#include <stdio.h>
#include "interface.h"
#include "engine/iserverplugin.h"
#include "eiface.h"
#include "igameevents.h"
#include <vector>
#include "tier0/memdbgon.h"


#define LUA state->luabase

class ILuaInterface;

struct lua_State
{
	unsigned char	_ignore_this_common_lua_header_[69];
	ILuaInterface*	luabase;
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

typedef struct 
{
	int iCallback;
	int iCookie;
}	callback_t;


class Plugin: public IServerPluginCallbacks, public IGameEventListener
{
public:
	Plugin();
	~Plugin();
	
	//IServerPluginCallbacks methods
	virtual bool			Load(	CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory );
	virtual void			Unload( void );
	virtual void			Pause( void );
	virtual void			UnPause( void );
	virtual const char     *GetPluginDescription( void );      
	virtual void			LevelInit( char const *pMapName );
	virtual void			ServerActivate( edict_t *pEdictList, int edictCount, int clientMax );
	virtual void			GameFrame( bool simulating );
	virtual void			LevelShutdown( void );
	virtual void			ClientActive( edict_t *pEntity );
	virtual void			ClientDisconnect( edict_t *pEntity );
	virtual void			ClientPutInServer( edict_t *pEntity, char const *playername );
	virtual void			SetCommandClient( int index );
	virtual void			ClientSettingsChanged( edict_t *pEdict );
	virtual PLUGIN_RESULT	ClientConnect( bool *bAllowConnect, edict_t *pEntity, const char *pszName, const char *pszAddress, char *reject, int maxrejectlen );
	virtual PLUGIN_RESULT	ClientCommand( edict_t *pEntity, const CCommand &args );
	virtual PLUGIN_RESULT	NetworkIDValidated( const char *pszUserName, const char *pszNetworkID );
	virtual void			OnQueryCvarValueFinished( QueryCvarCookie_t iCookie, edict_t *pPlayerEntity, EQueryCvarValueStatus eStatus, const char *pCvarName, const char *pCvarValue );

	//added with version 3 of the interface.
	virtual void			OnEdictAllocated(edict_t *edict);
	virtual void			OnEdictFreed(const edict_t *edict);	
	
	//IGameEventListener Interface
	virtual void FireGameEvent(KeyValues * event);
	
	virtual int GetCommandIndex() {
		return m_iClientCommandIndex;
	}
private:
	int m_iClientCommandIndex;
};

Plugin g_EmtpyServerPlugin;
EXPOSE_SINGLE_INTERFACE_GLOBALVAR(Plugin, IServerPluginCallbacks, INTERFACEVERSION_ISERVERPLUGINCALLBACKS, g_EmtpyServerPlugin);

Plugin::Plugin() {
	m_iClientCommandIndex = 0;
}
Plugin::~Plugin() {}

std::vector<callback_t> m_vCallbacks; //vector of callbacks

IVEngineServer* 		engine 				= NULL;
IServerPluginHelpers*	helpers 			= NULL;
CLuaShared* 			luashared 			= NULL;
ILuaInterface* 			sv_lua 				= NULL;
IServerGameEnts* 		sv_game_ents 		= NULL;
IPlayerInfoManager*		playerinfomanager	= NULL; // player info manager for getting globals

CGlobalVars *gpGlobals = NULL; // globals for curtime

int StartQueryCvarValue(lua_State* state) {
	LUA->CheckType(1,9); //Player
	LUA->CheckType(2,4); //String
	LUA->CheckType(3,6); //Function/Callback
	
	int iEntIndex = 0;
	
	sv_lua->PushSpecial(2); //Push the registry table onto the stack
		sv_lua->GetField(-1, "Entity"); //Get the entity table
		
		if ( sv_lua->IsType(-1, 5) ) { //Make sure it's a table
			sv_lua->GetField(-1, "EntIndex"); //Get the EntIndex function
			
			if ( sv_lua->IsType(-1, 6) ) { //Make sure it's a table
				sv_lua->Push(1); //Push the entity
				sv_lua->Call(1, 1); //Call the function 
				
				if ( sv_lua->IsType(-1, 3) ) { //Make sure it's a number
					iEntIndex = sv_lua->GetNumber(-1); //Get the entity index
				}
				
				sv_lua->Pop(2); //Pop the function and return value off the stack
			} else {
				sv_lua->Pop(2); //Pop the 2 fields off the stack
			}
		} else {
			sv_lua->Pop(); //Pop the field off the stack
		}
	sv_lua->Pop(); //Pop the reg table off the stack
	
	if (!iEntIndex) { //No entity so we fail
		sv_lua->PushBool(false);
		return 1;
	}
	
	edict_t* pEdict = engine->PEntityOfEntIndex(iEntIndex); //Get the edict
	
	if (pEdict != NULL) { //Make sure it's valid
		callback_t callback; // Make a new callback
		callback.iCookie = helpers->StartQueryCvarValue(pEdict, LUA->GetString(2) ); // Set the cookie to our shit
		
		if (callback.iCookie >= 1) { //Make sure the query has successfully started
			LUA->Push(3); //Push the callback
			
			callback.iCallback = LUA->ReferenceCreate(); //Create a reference to it for later use
			m_vCallbacks.push_back( callback ); //Push it onto our vector of callbacks
			
			LUA->PushBool(true); //Push the return value
		} else {
			LUA->PushBool(false); //Push false if it fails
		}
		
		return 1;
	}
	
	LUA->PushBool(false); //Push false since the entity was invalid
	return 1;
}

void FreeQueries( bool bForce = false )
{
	if (m_vCallbacks.size() == 0 || !sv_lua)
		return;

	for (unsigned int i = 0;i < m_vCallbacks.size();i++)
	{
		if (bForce == true || m_vCallbacks[i].flExpire < gpGlobals->curtime)
		{
			Warning( "Unhandled callback freed and deleted %d\n", m_vCallbacks[i].iCookie );
			sv_lua->ReferenceFree( m_vCallbacks[i].iCallback ); // Free the reference

			m_vCallbacks.erase( m_vCallbacks.begin() + i ); // Remove the callback from the vector
			i = i - 1;
		}
	}
}

void AddLuaFunction() {
	sv_lua = luashared->GetLuaInterface(1); //Get the server lua interface
	
	if (sv_lua) {
		sv_lua->CreateMetaTableType("Player", 9/*TYPE::ENTITY*/);
		int iRef = sv_lua->ReferenceCreate(); //Create a reference to the Player meta table
		
		sv_lua->ReferencePush(iRef); //Push the reference
			sv_lua->PushCFunction(StartQueryCvarValue); //Push our function
			sv_lua->SetField(-2, "StartQueryCvarValue"); //Set the field
		sv_lua->ReferenceFree(iRef); //Free the reference
		
		sv_lua->Pop(); //Pop that shit off the stack
	}
}

bool Plugin::Load(	CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory ) {
	engine = (IVEngineServer*)interfaceFactory(INTERFACEVERSION_VENGINESERVER, NULL);
	helpers = (IServerPluginHelpers*)interfaceFactory(INTERFACEVERSION_ISERVERPLUGINHELPERS, NULL);
	playerinfomanager = (IPlayerInfoManager *)gameServerFactory(INTERFACEVERSION_PLAYERINFOMANAGER,NULL); // Get our playerinfomanager for globals

	if ( playerinfomanager )
	{
		gpGlobals = playerinfomanager->GetGlobalVars();
	}
	
	CreateInterfaceFn LuaFactory = Sys_GetFactory("lua_shared.dll");
	
	luashared = (CLuaShared*)LuaFactory("LUASHARED003", NULL);
	
	if(	!( engine && helpers && luashared && playerinfomanager && gpGlobals ) ) {
		return false; // Make the loading fail
	}
	
	//Try to add our lua function
	AddLuaFunction();
	
	return true;
}

void Plugin::Unload(void) {
	FreeQueries( true );

	//Remove function
	if (sv_lua) {
		sv_lua->CreateMetaTableType("Player", 9/*TYPE::ENTITY*/);
		int iRef = sv_lua->ReferenceCreate(); // Get our meta table reference
		
		sv_lua->ReferencePush(iRef); //Push the reference onto the stack
			sv_lua->PushNil(); //Push nil
			sv_lua->SetField(-2, "StartQueryCvarValue"); //Remove the function
		sv_lua->ReferenceFree(iRef); //Free the ference
		
		sv_lua->Pop(); //Pop shit off the stack
	}
}

void Plugin::OnQueryCvarValueFinished( QueryCvarCookie_t iCookie, edict_t *pPlayerEntity, EQueryCvarValueStatus eStatus, const char *pCvarName, const char *pCvarValue )
{
	for ( unsigned int i = 0; i < m_vCallbacks.size(); i++ ) // Go through all our callbacks
	{
		if (m_vCallbacks[i].iCookie == iCookie) // Check the cookie to see if it matches the one we're looking for
		{
			sv_lua->ReferencePush( m_vCallbacks[i].iCallback ); // Push the reference to the function on the stack
				if (eStatus == eQueryCvarValueStatus_ValueIntact) // If the query succeeded and nothing went wrong, then proceed
					sv_lua->PushString( pCvarValue ); // Push the value of the convar
				else
					sv_lua->PushNumber( eStatus ); // Push the number of the error
				sv_lua->Call( 1, 0 ); // Call the function
			sv_lua->ReferenceFree( m_vCallbacks[i].iCallback ); // Free the reference
			
			m_vCallbacks.erase( m_vCallbacks.begin() + i ); // Remove the callback from the vector

			break;
		}
	}
}

void Plugin::ServerActivate( edict_t *pEdictList, int edictCount, int clientMax ) {
	AddLuaFunction(); //Add our lua function
}

const char *Plugin::GetPluginDescription(void) {
	return "For querying ConVars on clients.";
}

void Plugin::SetCommandClient( int index ) {
	m_iClientCommandIndex = index;
}

PLUGIN_RESULT Plugin::ClientConnect( bool *bAllowConnect, edict_t *pEntity, const char *pszName, const char *pszAddress, char *reject, int maxrejectlen ) {
	return PLUGIN_CONTINUE;
}

PLUGIN_RESULT Plugin::ClientCommand( edict_t *pEntity, const CCommand &args ) {
	return PLUGIN_CONTINUE;
}

PLUGIN_RESULT Plugin::NetworkIDValidated( const char *pszUserName, const char *pszNetworkID ) {
	return PLUGIN_CONTINUE;
}

void Plugin::GameFrame(bool simulating) 
{
	static float flNextCheck = gpGlobals->curtime + 5.0;

	if (flNextCheck > gpGlobals->curtime)
		return;

	FreeQueries();

	flNextCheck = gpGlobals->curtime + 1.0;
}

void Plugin::LevelShutdown(void) 
{
	FreeQueries( true );
}


void Plugin::Pause(void) {}
void Plugin::UnPause(void) {}
void Plugin::LevelInit(char const *pMapName) {}
void Plugin::ClientActive(edict_t *pEntity) {}
void Plugin::ClientDisconnect( edict_t *pEntity ) {}
void Plugin::ClientPutInServer( edict_t *pEntity, char const *playername ) {}
void Plugin::ClientSettingsChanged( edict_t *pEdict ) {}
void Plugin::OnEdictAllocated( edict_t *edict ) {}
void Plugin::OnEdictFreed( const edict_t *edict) {}
void Plugin::FireGameEvent( KeyValues * event ) {}