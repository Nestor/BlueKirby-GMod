#pragma once

#include "Windows.h"
#include "Interface.h"
#include <stdio.h>

typedef void* (*CreateInterfaceFn)(const char *pName, int *pReturnCode);

//Get vfunc template credits to Casual_Hacker
inline void**& getvtable( void* inst, size_t offset = 0 )
{
	return *reinterpret_cast<void***>( (size_t)inst + offset );
}

inline const void** getvtable( const void* inst, size_t offset = 0 )
{
	return *reinterpret_cast<const void***>( (size_t)inst + offset );
}
template< typename Fn >

inline Fn getvfunc( const void* inst, size_t index, size_t offset = 0 )
{
	return reinterpret_cast<Fn>( getvtable( inst, offset )[ index ] );
}
//======================================================================

class CBaseEntity
{
public:
	bool IsDormant( )
	{
		PVOID pNetworkable = (PVOID)(this + 0x8);
		typedef bool ( __thiscall* OriginalFn )( PVOID );
		return getvfunc<OriginalFn>( pNetworkable, 8 )( pNetworkable );
	}
};

class CEntList
{
public:
	CBaseEntity* GetClientEntity( int entnum )
	{
		typedef CBaseEntity* ( __thiscall* OriginalFn )( PVOID, int );
		return getvfunc<OriginalFn>( this, 3 )( this, entnum );
	}
	CBaseEntity* GetClientEntityFromHandle( int hEnt )
	{
		typedef CBaseEntity* ( __thiscall* OriginalFn )( PVOID, int );
		return getvfunc<OriginalFn>( this, 4 )( this, hEnt );
	}
};

CreateInterfaceFn Sys_GetFactory( const char *pModuleName )
{
	return (CreateInterfaceFn)( GetProcAddress( GetModuleHandle( pModuleName ), "CreateInterface" ) );
}

CEntList* pEntList;