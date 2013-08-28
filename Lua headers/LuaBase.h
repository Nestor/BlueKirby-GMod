
#ifndef GARRYSMOD_LUA_LUABASE_H
#define GARRYSMOD_LUA_LUABASE_H

#include <stddef.h>

struct lua_State;

namespace GarrysMod 
{
	namespace Lua
	{
		typedef int (*CFunc) (lua_State *L);

		//
		// Access to raw Lua function calls
		//
		class ILuaBase
		{
			public:

				virtual int			Top( void ) = 0;
				virtual void		Push( int iStackPos ) = 0;
				virtual void		Pop( int iAmt = 1 ) = 0;
				virtual void		GetTable( int iStackPos ) = 0;
				virtual void		GetField( int iStackPos, const char* strName ) = 0;
				virtual void		SetField( int iStackPos, const char* strName ) = 0;
				virtual void		CreateTable() = 0;
				virtual void		SetTable( int i ) = 0;
				virtual void		SetMetaTable( int i ) = 0;
				virtual bool		GetMetaTable( int i ) = 0;
				virtual void		Call( int iArgs, int iResults ) = 0;
				virtual int			PCall( int iArgs, int iResults, int iErrorFunc ) = 0;
				virtual int			Equal( int iA, int iB ) = 0;
				virtual int			RawEqual( int iA, int iB ) = 0;
				virtual void		Insert( int iStackPos ) = 0;
				virtual void		Remove( int iStackPos ) = 0;
				virtual int			Next( int iStackPos ) = 0;
				virtual void*		NewUserdata( unsigned int iSize ) = 0;
				virtual void		ThrowError( const char* strError ) = 0;
				virtual void		CheckType( int iStackPos, int iType ) = 0;
				virtual void		ArgError( int iArgNum, const char* strMessage ) = 0;
				virtual void		RawGet( int iStackPos ) = 0;
				virtual void		RawSet( int iStackPos ) = 0;

				virtual const char*		GetString( int iStackPos = -1, unsigned int* iOutLen = NULL ) = 0;
				virtual double			GetNumber( int iStackPos = -1 ) = 0;
				virtual bool			GetBool( int iStackPos = -1 ) = 0;
				virtual CFunc			GetCFunction( int iStackPos = -1 ) = 0;
				virtual void*			GetUserdata( int iStackPos = -1 ) = 0;

				virtual void		PushNil() = 0;
				virtual void		PushString( const char* val, unsigned int iLen = 0 ) = 0;
				virtual void		PushNumber( double val ) = 0;
				virtual void		PushBool( bool val ) = 0;
				virtual void		PushCFunction( CFunc val ) = 0;
				virtual void		PushCClosure( CFunc val, int iVars ) = 0;
				virtual void		PushUserdata( void* ) = 0;

				//
				// If you create a reference - don't forget to free it!
				//
				virtual int			ReferenceCreate() = 0;
				virtual void		ReferenceFree( int i ) = 0;
				virtual void		ReferencePush( int i ) = 0;

				//
				// Push a special value onto the top of the stack ( see below )
				//
				virtual void		PushSpecial( int iType ) = 0;

				//
				// For type enums see Types.h 
				//
				virtual bool			IsType( int iStackPos, int iType ) = 0;
				virtual int				GetType( int iStackPos ) = 0;
				virtual const char*		GetTypeName( int iType ) = 0;

				//
				// Creates a new meta table of string and type and leaves it on the stack.
				// Will return the old meta table of this name if it already exists.
				//
				virtual void			CreateMetaTableType( const char* strName, int iType ) = 0;

				//
				// Like Get* but throws errors and returns if they're not of the expected type
				//
				virtual const char*		CheckString( int iStackPos = -1 ) = 0;
				virtual double			CheckNumber( int iStackPos = -1 ) = 0; //44

				// Ugly, deal with it
				// cough getvfunc cough
				virtual void			unk45( void ) = 0;
				virtual void			unk46( void ) = 0;
				virtual void			unk47( void ) = 0;
				virtual void			unk48( void ) = 0;
				virtual void			unk49( void ) = 0;
				virtual void			unk50( void ) = 0;
				virtual void			unk51( void ) = 0;
				virtual void			unk52( void ) = 0;
				virtual void			unk53( void ) = 0;
				virtual void			unk54( void ) = 0;
				virtual void			unk55( void ) = 0;
				virtual void			unk56( void ) = 0;
				virtual void			unk57( void ) = 0;
				virtual void			unk58( void ) = 0;
				virtual void			unk59( void ) = 0;
				virtual void			unk60( void ) = 0;
				virtual void			unk61( void ) = 0;
				virtual void			unk62( void ) = 0;
				virtual void			unk63( void ) = 0;
				virtual void			unk64( void ) = 0;
				virtual void			unk65( void ) = 0;
				virtual void			unk66( void ) = 0;
				virtual void			unk67( void ) = 0;
				virtual void			unk68( void ) = 0;
				virtual void			unk69( void ) = 0;
				virtual void			unk70( void ) = 0;
				virtual void			unk71( void ) = 0;
				virtual void			unk72( void ) = 0;
				virtual void			unk73( void ) = 0;
				virtual void			unk74( void ) = 0;
				virtual void			unk75( void ) = 0;
				virtual void			unk76( void ) = 0;
				virtual void			unk77( void ) = 0;
				virtual void			unk78( void ) = 0;
				virtual void			unk79( void ) = 0;
				virtual void			unk80( void ) = 0;
				virtual void			unk81( void ) = 0;
				virtual void			unk82( void ) = 0;
				virtual void			unk83( void ) = 0;
				virtual void			unk84( void ) = 0;
				virtual void			unk85( void ) = 0;
				virtual void			unk86( void ) = 0;
				virtual void			unk87( void ) = 0;
										// Filename is a inique identifier for your script.
										// Path can be left blank as it is just used as a path to the lua file if there is an error
										// Run should ALWAYS be true
										// ShowErrors I recommend you leave on
				virtual bool			RunString( const char* pszFilename, const char* pszPath, const char* pszStringToRun, bool bRun = true, bool bShowErrors = true ) = 0;
				virtual void			unk89( void ) = 0;
				virtual void			unk90( void ) = 0;
				virtual void			unk91( void ) = 0;
				virtual void			unk92( void ) = 0;
										// Path is just the path to it from the lua folder
										// Run should always be true
										// Show errors I recommend you leave on
										// Type basically tells Garry's Mod how to handle the script. Just leave it at !CLIENT
				virtual bool			FindAndRunScript( const char* path, bool bRun = true, bool bShowErrors = true, const char* pszType = "!CLIENT" ) = 0;
		};

		enum 
		{
			SPECIAL_GLOB,		// Global table
			SPECIAL_ENV,		// Environment table
			SPECIAL_REG,		// Registry table
		};
	}
}

#endif 

