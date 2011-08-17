
/*---------------------------------------------------------

  This file should contain variables and functions that are 
   the same on both client and server.

  This file will get sent to the client - so don't add 
   anything to this file that you don't want them to be
   able to see.

---------------------------------------------------------*/

include( 'obj_player_extend.lua' )

include( 'gravitygun.lua' )
include( 'player_shd.lua' )
include( 'animations.lua' )

GM.Name 		= "Blue Waves"
GM.Author 		= "Blue Kirby"
GM.Email 		= "bluekirby51@gmail.com"
GM.Website 		= "www.s3g.brainnerd.com"
GM.TeamBased 	= false


/*---------------------------------------------------------
   Name: gamemode:PlayerHurt( )
   Desc: Called when a player is hurt.
---------------------------------------------------------*/
function GM:PlayerHurt( player, attacker, healthleft, healthtaken )
	if attacker:IsPlayer() then
		healthtaken = 0
	end
end


/*---------------------------------------------------------
   Name: gamemode:KeyPress( )
   Desc: Player pressed a key (see IN enums)
---------------------------------------------------------*/
local Attack2 = 0
local Use = 0
local PlayerID = 1
function GM:KeyPress( player, key )
	if key == IN_ATTACK and !player:Alive() then
		PlayerID = PlayerID + 1
		if PlayerID > Players then
			PlayerID = 1
			if PlayerIDS[PlayerID] == player then
				PlayerID = PlayerID + 1
			end
			player:SpectateEntity(PlayerIDS[PlayerID])
		else
			if PlayerIDS[PlayerID] == player then
				PlayerID = PlayerID + 1
				if PlayerID > Players then
					PlayerID = 1
				end
			end
			player:SpectateEntity(PlayerIDS[PlayerID])
		end
	end
	
	if key == IN_ATTACK2 and !player:Alive() then
		PlayerID = PlayerID - 1
		if PlayerID < 1 then
			PlayerID = Players
			if PlayerIDS[PlayerID] == player then
				PlayerID = PlayerID - 1
			end
			player:SpectateEntity(PlayerIDS[PlayerID])
		else
			if PlayerIDS[PlayerID] == player then
				PlayerID = PlayerID - 1
				if PlayerID < 1 then
					PlayerID = Players
				end
			end
			player:SpectateEntity(PlayerIDS[PlayerID])
		end
	end

    if key == IN_RELOAD and player:GetNWBool("FirstPersonSpec") == false and !player:Alive() then 
        player:SetNWBool("FirstPersonSpec", true)
		player:Spectate( OBS_MODE_IN_EYE )		 
    elseif key == IN_RELOAD and player:GetNWBool("FirstPersonSpec") == true and !player:Alive() then 
        player:SetNWBool("FirstPersonSpec", false)
		player:Spectate( OBS_MODE_CHASE )
    end
end


/*---------------------------------------------------------
   Name: gamemode:KeyRelease( )
   Desc: Player released a key (see IN enums)
---------------------------------------------------------*/
function GM:KeyRelease( player, key )
	if key == IN_ATTACK2  then
		Attack2 = 0
	end
	if key == IN_USE  then
		Use = 0
	end
end


/*---------------------------------------------------------
   Name: gamemode:PlayerConnect( )
   Desc: Player has connects to the server (hasn't spawned)
---------------------------------------------------------*/
function GM:PlayerConnect( name, address )
end

/*---------------------------------------------------------
   Name: gamemode:PlayerAuthed( )
   Desc: Player's STEAMID has been authed
---------------------------------------------------------*/
function GM:PlayerAuthed( ply, SteamID, UniqueID )
end



/*---------------------------------------------------------
   Name: gamemode:PropBreak( )
   Desc: Prop has been broken
---------------------------------------------------------*/
function GM:PropBreak( attacker, prop )
end


/*---------------------------------------------------------
   Name: gamemode:PhysgunPickup( )
   Desc: Return true if player can pickup entity
---------------------------------------------------------*/
function GM:PhysgunPickup( ply, ent )

	// Don't pick up players
	if ( ent:GetClass() == "player" ) then return false end

	return true
end


/*---------------------------------------------------------
   Name: gamemode:PhysgunDrop( )
   Desc: Dropped an entity
---------------------------------------------------------*/
function GM:PhysgunDrop( ply, ent )
end


/*---------------------------------------------------------
   Name: gamemode:SetupMove( player, movedata )
   Desc: Allows us to change stuff before the engine 
		  processes the movements
---------------------------------------------------------*/
function GM:SetupMove( ply, move )
end


/*---------------------------------------------------------
   Name: gamemode:FinishMove( player, movedata )
---------------------------------------------------------*/
function GM:FinishMove( ply, move )

end

/*---------------------------------------------------------
   Name: gamemode:Move
   This basically overrides the NOCLIP, PLAYERMOVE movement stuff.
   It's what actually performs the move. 
   Return true to not perform any default movement actions. (completely override)
---------------------------------------------------------*/
function GM:Move( ply, mv )
end

/*---------------------------------------------------------
   Name: gamemode:PlayerShouldTakeDamage
   Return true if this player should take damage from this attacker
---------------------------------------------------------*/
function GM:PlayerShouldTakeDamage( ply, attacker )
	if attacker:IsPlayer() and ply:IsPlayer() then
		return false
	end
	return true
end


/*---------------------------------------------------------
   Name: gamemode:ContextScreenClick(  aimvec, mousecode, pressed, ply )
   'pressed' is true when the button has been pressed, false when it's released
---------------------------------------------------------*/
function GM:ContextScreenClick( aimvec, mousecode, pressed, ply )
	
	// We don't want to do anything by default, just feed it to the weapon
	local wep = ply:GetActiveWeapon()
	if ( ValidEntity( wep ) && wep.ContextScreenClick ) then
		wep:ContextScreenClick( aimvec, mousecode, pressed, ply )
	end
	
end

/*---------------------------------------------------------
   Name: Text to show in the server browser
---------------------------------------------------------*/
function GM:GetGameDescription()
	return self.Name
end


/*---------------------------------------------------------
   Name: Saved
---------------------------------------------------------*/
function GM:Saved()
end


/*---------------------------------------------------------
   Name: Restored
---------------------------------------------------------*/
function GM:Restored()
end


/*---------------------------------------------------------
   Name: EntityRemoved
   Desc: Called right before an entity is removed. Note that this
   isn't going to be totally reliable on the client since the client
   only knows about entities that it has had in its PVS.
---------------------------------------------------------*/
function GM:EntityRemoved( ent )
end


/*---------------------------------------------------------
   Name: Tick
   Desc: Like Think except called every tick on both client and server
---------------------------------------------------------*/
function GM:Tick()
end

/*---------------------------------------------------------
   Name: OnEntityCreated
   Desc: Called right after the Entity has been made visible to Lua
---------------------------------------------------------*/
function GM:OnEntityCreated( Ent )
end

/*---------------------------------------------------------
   Name: gamemode:EntityKeyValue( ent, key, value )
   Desc: Called when an entity has a keyvalue set
	      Returning a string it will override the value
---------------------------------------------------------*/
function GM:EntityKeyValue( ent, key, value )
end

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	// Don't do this if not teambased. But if it is teambased we
	// create a few teams here as an example. If you're making a teambased
	// gamemode you should override this function in your gamemode
	if ( !GAMEMODE.TeamBased ) then return end
	
	TEAM_SURVIVOR = 1
	team.SetUp( TEAM_SURVIVOR, "Survivor Team", Color( 255, 150, 150 ) )
	team.SetSpawnPoint( TEAM_SURVIVOR, "info_player_start" ) // <-- This would be info_terrorist or some entity that is in your map
	
	team.SetSpawnPoint( TEAM_SPECTATOR, "worldspawn" ) 

end


/*---------------------------------------------------------
   Name: gamemode:ShouldCollide( Ent1, Ent2 )
   Desc: This should always return true unless you have 
		  a good reason for it not to.
---------------------------------------------------------*/
function GM:ShouldCollide( Ent1, Ent2 )
	return true
end