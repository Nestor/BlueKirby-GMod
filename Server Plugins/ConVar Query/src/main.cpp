//===== Copyright © 1996-2008, Valve Corporation, All rights reserved. ======//
//
// Purpose: Get the value of convars from clients without the need for
// client side lua. 
//
// Credits: Blue Kirby
//
// $NoKeywords: $
//
//===========================================================================//

#include <Windows.h>

#include <stdio.h>
#include "interface.h"
#include "filesystem.h"
#include "engine/iserverplugin.h"
#include "eiface.h"
#include "igameevents.h"
#include "convar.h"
#include "Color.h"
#include "vstdlib/random.h"
#include "engine/IEngineTrace.h"
#include "tier2/tier2.h"
#include "game/server/iplayerinfo.h"
#include "sdk.h"
#include "xorstr.h"
#include <vector>

#include "tier0/memdbgon.h"

// Interfaces from the engine
IVEngineServer	*engine = NULL; // helper functions (messaging clients, loading content, making entities, running commands, etc)
IServerPluginHelpers *helpers = NULL; // special 3rd party plugin helpers from the engine
CLuaShared* luashared = NULL; // lua shared interface to get the ILuaInterface
ILuaInterface* sv_lua = NULL; // iluainterface for lua stack manipulation
IServerGameEnts* sv_game_ents = NULL; // for converting the entity into an edict

std::vector<callback_t> m_vCallbacks; // vector of callbacks

int QueryConVar( lua_State* state )
{
	LUA->CheckType( 1, 9 ); // Player
	LUA->CheckType( 2, 4 ); // String
	LUA->CheckType( 3, 6 ); // Function/Callback

	int iEntIndex = 0;

	sv_lua->PushSpecial( 2 ); // Push the registry table onto the stack
		sv_lua->GetField( -1, "Entity" ); // Get the entity table
		if (sv_lua->IsType( -1, 5 )) // Make sure it's a table
		{
			sv_lua->GetField( -1, "EntIndex" ); // Get the EntIndex function
			if (sv_lua->IsType( -1, 6 )) // Make sure it's a table
			{
				sv_lua->Push( 1 ); // Push the entity
				sv_lua->Call( 1, 1 ); // Call the function 

				if (sv_lua->IsType( -1, 3 )) //Make sure it's a number
					iEntIndex = sv_lua->GetNumber( -1 ); // Get the entity index

				sv_lua->Pop( 2 ); // Pop the function and return value off the stack
			}
			else
				sv_lua->Pop( 2 ); // Pop the 2 fields off the stack
		}
		else
			sv_lua->Pop(); // Pop the field off the stack
	sv_lua->Pop(); // Pop the reg table off the stack

	if (!iEntIndex) // No entity so we fail
	{
		sv_lua->PushBool( false );
		return 1;
	}

	edict_t* pEdict = engine->PEntityOfEntIndex( iEntIndex ); // Get the edict

	if (pEdict != NULL) // Make sure it's valid
	{
		callback_t callback; // Make a new callback

		callback.iCookie = helpers->StartQueryCvarValue( pEdict, LUA->GetString( 2 ) ); // Set the cookie to our shit

			if (callback.iCookie >= 1) // Make sure the query has successfully started
			{
				LUA->Push( 3 ); // Push the callback
				callback.iCallback = LUA->ReferenceCreate(); // Create a reference to it for later use

				m_vCallbacks.push_back( callback ); // Push it onto our vector of callbacks

				LUA->PushBool( true ); // Push the return value
		}
			else
			LUA->PushBool( false ); // Push false if it fails

		return 1;
	}

	LUA->PushBool( false ); // Push false since the entity was invalid*/

	return 1;
}

void AddLuaFunction()
{
	sv_lua = luashared->GetLuaInterface( 1 ); // Get the server lua interface

	if (sv_lua)
	{
		sv_lua->CreateMetaTableType( "Player", 9/*TYPE::ENTITY*/ );
		int iRef = sv_lua->ReferenceCreate(); // Create a reference to the Player meta table

		sv_lua->ReferencePush( iRef ); // Push the reference
			sv_lua->PushCFunction( QueryConVar ); // Push our function
			sv_lua->SetField( -2, "QueryConVar" ); // Set the field
		sv_lua->ReferenceFree( iRef ); // Free the reference

		sv_lua->Pop(); // Pop that shit off the stack
	}
}

// useful helper func
inline bool FStrEq(const char *sz1, const char *sz2)
{
	return(Q_stricmp(sz1, sz2) == 0);
}
//---------------------------------------------------------------------------------
// Purpose: a sample 3rd party plugin class
//---------------------------------------------------------------------------------
class CEmptyServerPlugin: public IServerPluginCallbacks, public IGameEventListener
{
public:
	CEmptyServerPlugin();
	~CEmptyServerPlugin();

	// IServerPluginCallbacks methods
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

	// added with version 3 of the interface.
	virtual void			OnEdictAllocated( edict_t *edict );
	virtual void			OnEdictFreed( const edict_t *edict  );	

	// IGameEventListener Interface
	virtual void FireGameEvent( KeyValues * event );

	virtual int GetCommandIndex() { return m_iClientCommandIndex; }
private:
	int m_iClientCommandIndex;
};


// 
// The plugin is a static singleton that is exported as an interface
//
CEmptyServerPlugin g_EmtpyServerPlugin;
EXPOSE_SINGLE_INTERFACE_GLOBALVAR(CEmptyServerPlugin, IServerPluginCallbacks, INTERFACEVERSION_ISERVERPLUGINCALLBACKS, g_EmtpyServerPlugin );

//---------------------------------------------------------------------------------
// Purpose: constructor/destructor
//---------------------------------------------------------------------------------
CEmptyServerPlugin::CEmptyServerPlugin()
{
	m_iClientCommandIndex = 0;
}

CEmptyServerPlugin::~CEmptyServerPlugin()
{
}

//---------------------------------------------------------------------------------
// Purpose: called when the plugin is loaded, load the interface we need from the engine
//---------------------------------------------------------------------------------
bool CEmptyServerPlugin::Load(	CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory )
{
	ConnectTier1Libraries( &interfaceFactory, 1 ); // Connect some shit
	ConnectTier2Libraries( &interfaceFactory, 1 ); // Here, connect some more

	engine = (IVEngineServer*)interfaceFactory(INTERFACEVERSION_VENGINESERVER, NULL); // Get our server engine interface
	helpers = (IServerPluginHelpers*)interfaceFactory(INTERFACEVERSION_ISERVERPLUGINHELPERS, NULL); // Get our helper interface (we can't call queries using the engine interface)

	CreateInterfaceFn LuaFactory = Sys_GetFactory( "lua_shared.dll" ); // Get the CreateInterface from lua_shared so we can get the CLuaShared interface

	luashared = (CLuaShared*)LuaFactory( "LUASHARED003", NULL ); // Get the CLuaShared interface
	
	if(	! ( engine && helpers && luashared ) ) // Make sure we have all of our interfaces and functions
	{
		return false; // Make the loading fail
	}

	AddLuaFunction(); // Try to add our lua function

	Msg( "[ConVar Query loaded!]\n" ); // Tell the server we loaded

	MathLib_Init( 2.2f, 2.2f, 0.0f, 2.0f ); // Initialize our math library even though it's unused
	ConVar_Register( 0 );
	return true;
}

//---------------------------------------------------------------------------------
// Purpose: called when the plugin is unloaded (turned off)
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::Unload( void )
{
	if ( sv_lua )
	{
		sv_lua->CreateMetaTableType( "Player", 9/*TYPE::ENTITY*/ );
		int iRef = sv_lua->ReferenceCreate(); // Get our meta table reference

		sv_lua->ReferencePush( iRef ); // Push the reference onto the stack
			sv_lua->PushNil(); // Push nil
			sv_lua->SetField( -2, "QueryConVar" ); // Remove  the function
		sv_lua->ReferenceFree( iRef ); // Free the ference

		sv_lua->Pop(); // Pop shit off the stack
	}

	ConVar_Unregister( );
	DisconnectTier2Libraries( );
	DisconnectTier1Libraries( );
}

//---------------------------------------------------------------------------------
// Purpose: called when the plugin is paused (i.e should stop running but isn't unloaded)
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::Pause( void )
{
}

//---------------------------------------------------------------------------------
// Purpose: called when the plugin is unpaused (i.e should start executing again)
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::UnPause( void )
{
}

//---------------------------------------------------------------------------------
// Purpose: the name of this plugin, returned in "plugin_print" command
//---------------------------------------------------------------------------------
const char *CEmptyServerPlugin::GetPluginDescription( void )
{
	return "For querying ConVars on clients.";
}

//---------------------------------------------------------------------------------
// Purpose: called on level start
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::LevelInit( char const *pMapName )
{

}

//---------------------------------------------------------------------------------
// Purpose: called on level start, when the server is ready to accept client connections
//		edictCount is the number of entities in the level, clientMax is the max client count
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::ServerActivate( edict_t *pEdictList, int edictCount, int clientMax )
{
	AddLuaFunction(); // Add our lua function
}

//---------------------------------------------------------------------------------
// Purpose: called once per server frame, do recurring work here (like checking for timeouts)
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::GameFrame( bool simulating )
{
	
}

//---------------------------------------------------------------------------------
// Purpose: called on level end (as the server is shutting down or going to a new map)
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::LevelShutdown( void ) // !!!!this can get called multiple times per map change
{
	
}

//---------------------------------------------------------------------------------
// Purpose: called when a client spawns into a server (i.e as they begin to play)
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::ClientActive( edict_t *pEntity )
{
}

//---------------------------------------------------------------------------------
// Purpose: called when a client leaves a server (or is timed out)
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::ClientDisconnect( edict_t *pEntity )
{
}

//---------------------------------------------------------------------------------
// Purpose: called on 
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::ClientPutInServer( edict_t *pEntity, char const *playername )
{
	
}

//---------------------------------------------------------------------------------
// Purpose: called on level start
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::SetCommandClient( int index )
{
	m_iClientCommandIndex = index;
}

void ClientPrint( edict_t *pEdict, char *format, ... )
{
	va_list		argptr;
	static char		string[1024];
	
	va_start (argptr, format);
	Q_vsnprintf(string, sizeof(string), format,argptr);
	va_end (argptr);

	engine->ClientPrintf( pEdict, string );
}
//---------------------------------------------------------------------------------
// Purpose: called on level start
//---------------------------------------------------------------------------------
void CEmptyServerPlugin::ClientSettingsChanged( edict_t *pEdict )
{
	
}

//---------------------------------------------------------------------------------
// Purpose: called when a client joins a server
//---------------------------------------------------------------------------------
PLUGIN_RESULT CEmptyServerPlugin::ClientConnect( bool *bAllowConnect, edict_t *pEntity, const char *pszName, const char *pszAddress, char *reject, int maxrejectlen )
{
	return PLUGIN_CONTINUE;
}

//---------------------------------------------------------------------------------
// Purpose: called when a client types in a command (only a subset of commands however, not CON_COMMAND's)
//---------------------------------------------------------------------------------
PLUGIN_RESULT CEmptyServerPlugin::ClientCommand( edict_t *pEntity, const CCommand &args )
{
	return PLUGIN_CONTINUE;
}

PLUGIN_RESULT CEmptyServerPlugin::NetworkIDValidated( const char *pszUserName, const char *pszNetworkID )
{
	return PLUGIN_CONTINUE;
}

void CEmptyServerPlugin::OnQueryCvarValueFinished( QueryCvarCookie_t iCookie, edict_t *pPlayerEntity, EQueryCvarValueStatus eStatus, const char *pCvarName, const char *pCvarValue )
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

void CEmptyServerPlugin::OnEdictAllocated( edict_t *edict )
{
}

void CEmptyServerPlugin::OnEdictFreed( const edict_t *edict  )
{
}

void CEmptyServerPlugin::FireGameEvent( KeyValues * event )
{
}

static ConVar convar_query( "convar_query", "1.0.0", 0, "Version of convar query you're using." );