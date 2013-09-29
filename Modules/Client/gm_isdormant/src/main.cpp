#include "main.h"

int IsDormant( lua_State* state )
{
	LUA->CheckType( 1, GarrysMod::Lua::Type::ENTITY );

	GarrysMod::Lua::UserData* Userdata = (GarrysMod::Lua::UserData*) LUA->GetUserdata( 1 );
	CBaseEntity* pEnt = pEntList->GetClientEntityFromHandle( *(int*)Userdata->data );

	if (pEnt)
	{
		LUA->PushBool( pEnt->IsDormant() );
	}
	else
		LUA->PushBool( true );

	return 1;
}

GMOD_MODULE_OPEN()
{
	CreateInterfaceFn ClientFactory = Sys_GetFactory( "client.dll" );
	pEntList = (CEntList*) ClientFactory( "VClientEntityList003", NULL );

	if (pEntList == NULL)
		LUA->ThrowError( "Couldn't get the ClientEntityList interface!" );

	LUA->CreateMetaTableType( "Player", GarrysMod::Lua::Type::ENTITY );
	int iRef = LUA->ReferenceCreate();

	LUA->ReferencePush( iRef );
		LUA->PushCFunction( IsDormant );
		LUA->SetField( -2, "IsDormant" );
	LUA->ReferenceFree( iRef );

	LUA->Pop();

	LUA->CreateMetaTableType( "Entity", GarrysMod::Lua::Type::ENTITY );
	iRef = LUA->ReferenceCreate();

	LUA->ReferencePush( iRef );
		LUA->PushCFunction( IsDormant );
		LUA->SetField( -2, "IsDormant" );
	LUA->ReferenceFree( iRef );

	LUA->Pop();

	return 0;
}

GMOD_MODULE_CLOSE()
{
	LUA->CreateMetaTableType( "Player", GarrysMod::Lua::Type::ENTITY );
	int iRef = LUA->ReferenceCreate();

	LUA->ReferencePush( iRef );
		LUA->PushNil();
		LUA->SetField( -2, "IsDormant" );
	LUA->ReferenceFree( iRef );

	LUA->Pop();

	LUA->CreateMetaTableType( "Entity", GarrysMod::Lua::Type::ENTITY );
	iRef = LUA->ReferenceCreate();

	LUA->ReferencePush( iRef );
		LUA->PushNil();
		LUA->SetField( -2, "IsDormant" );
	LUA->ReferenceFree( iRef );

	LUA->Pop();

	return 0;
}