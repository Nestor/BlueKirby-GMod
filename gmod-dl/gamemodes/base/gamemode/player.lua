/*---------------------------------------------------------
   Name: gamemode:OnPhysgunFreeze( weapon, phys, ent, player )
   Desc: The physgun wants to freeze a prop
---------------------------------------------------------*/
InWave = 0

function GM:OnPhysgunFreeze( weapon, phys, ent, ply )
	
	// Object is already frozen (!?)
	if ( !phys:IsMoveable() ) then return false end
	if ( ent:GetUnFreezable() ) then return false end
	
	phys:EnableMotion( false )
	
	// With the jeep we need to pause all of its physics objects
	// to stop it spazzing out and killing the server.
	if (ent:GetClass() == "prop_vehicle_jeep") then
	
		local objects = ent:GetPhysicsObjectCount()
		
		for i=0, objects-1 do
		
			local physobject = ent:GetPhysicsObjectNum( i )
			physobject:EnableMotion( false )
			
		end
	
	end
	
	// Add it to the player's frozen props
	ply:AddFrozenPhysicsObject( ent, phys )
	
	return true
	
end


/*---------------------------------------------------------
   Name: gamemode:OnPhysgunReload( weapon, player )
   Desc: The physgun wants to freeze a prop
---------------------------------------------------------*/
function GM:OnPhysgunReload( weapon, ply )

	ply:PhysgunUnfreeze( weapon )

end

/*---------------------------------------------------------
   Name: gamemode:PlayerCanPickupWeapon( )
   Desc: Called when a player tries to pickup a weapon.
		  return true to allow the pickup.
---------------------------------------------------------*/
function GM:PlayerCanPickupWeapon( player, entity )
	return true
end

/*---------------------------------------------------------
   Name: gamemode:PlayerCanPickupItem( )
   Desc: Called when a player tries to pickup an item.
		  return true to allow the pickup.
---------------------------------------------------------*/
function GM:PlayerCanPickupItem( player, entity )
	return true
end



/*---------------------------------------------------------
   Name: gamemode:CanPlayerUnfreeze( )
   Desc: Can the player unfreeze this entity & physobject
---------------------------------------------------------*/
function GM:CanPlayerUnfreeze( ply, entity, physobject )
	return true
end



/*---------------------------------------------------------
   Name: gamemode:PlayerDisconnected( )
   Desc: Player has disconnected from the server.
---------------------------------------------------------*/
function GM:PlayerDisconnected( ply )
	PrintMessage( HUD_PRINTTALK, "Player, "..ply:GetName().." has left. <"..ply:SteamID()..">")
	ply:ConCommand("pp_colormod 0")
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSay( )
   Desc: A player (or server) has used say. Return a string
		 for the player to say. Return an empty string if the
		 player should say nothing.
---------------------------------------------------------*/
function GM:PlayerSay( player, text, teamonly )
	return text
end


/*---------------------------------------------------------
   Name: gamemode:PlayerDeathThink( player )
   Desc: Called when the player is waiting to respawn
---------------------------------------------------------*/
function GM:PlayerDeathThink( pl )
	if InWave == 1 then 
	pl:Spectate( OBS_MODE_CHASE ) 
	for _,v in pairs ( player.GetAll() ) do
		if v:Alive() then
			pl:SpectateEntity( v )
			return
		end
	end
	return 
	end
	pl:Spawn()
end

/*---------------------------------------------------------
	Name: gamemode:PlayerUse( player, entity )
	Desc: A player has attempted to use a specific entity
		Return true if the player can use it
//--------------------------------------------------------*/
function GM:PlayerUse( pl, entity )
	return true
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSilentDeath( )
   Desc: Called when a player dies silently
---------------------------------------------------------*/
function GM:PlayerSilentDeath( Victim )

	Victim.NextSpawnTime = CurTime() + 2
	Victim.DeathTime = CurTime()

end

/*---------------------------------------------------------
   Name: gamemode:PlayerDeath( )
   Desc: Called when a player dies.
---------------------------------------------------------*/
function GM:PlayerDeath( Victim, Inflictor, Attacker )

	// Don't spawn for at least 2 seconds
	Victim.NextSpawnTime = CurTime() + 2
	Victim.DeathTime = CurTime()
	
	Victim:Spectate( OBS_MODE_CHASE ) 
	for _,v in pairs ( player.GetAll() ) do
		if v:Alive() then
			Victim:SpectateEntity( v )
		end
		end

	// Convert the inflictor to the weapon that they're holding if we can.
	// This can be right or wrong with NPCs since combine can be holding a 
	// pistol but kill you by hitting you with their arm.
	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsNPC()) ) then
	
		Inflictor = Inflictor:GetActiveWeapon()
		if ( !Inflictor || Inflictor == NULL ) then Inflictor = Attacker end
	
	end
	
	if (Attacker == Victim) then
	
		umsg.Start( "PlayerKilledSelf" )
			umsg.Entity( Victim )
		umsg.End()
		
		MsgAll( Attacker:Nick() .. " suicided!\n" )
		
	return end

	if ( Attacker:IsPlayer() ) then
	
		umsg.Start( "PlayerKilledByPlayer" )
		
			umsg.Entity( Victim )
			umsg.String( Inflictor:GetClass() )
			umsg.Entity( Attacker )
		
		umsg.End()
		
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. Inflictor:GetClass() .. "\n" )
		
	return end
	
	umsg.Start( "PlayerKilled" )
	
		umsg.Entity( Victim )
		umsg.String( Inflictor:GetClass() )
		umsg.String( Attacker:GetClass() )

	umsg.End()
	
	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. "\n" )
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerInitialSpawn( )
   Desc: Called just before the player's first spawn
---------------------------------------------------------*/
ModelList = {
	"models/player/Police.mdl",
	"models/player/Combine_Soldier.mdl",
	"models/player/Combine_Soldier_PrisonGuard.mdl",
	"models/Combine_Super_Soldier.mdl",
	"models/player/Group01/Male_01.mdl",
	"models/player/Group01/Male_02.mdl",
	"models/player/Group01/Male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/Male_06.mdl",
	"models/player/Group01/Male_07.mdl",
	"models/player/Group01/Male_08.mdl",
	"models/player/Group01/Male_09.mdl",
	"models/player/Group01/Female_01.mdl",
	"models/player/Group01/Female_02.mdl",
	"models/player/Group01/Female_03.mdl",
	"models/player/Group01/Female_04.mdl",
	"models/player/Group01/Female_06.mdl",
	"models/player/Group01/Female_07.mdl",
	"models/player/Group03/Male_01.mdl",
	"models/player/Group03/Male_02.mdl",
	"models/player/Group03/Male_03.mdl",
	"models/player/Group03/Male_04.mdl",
	"models/player/Group03/Male_05.mdl",
	"models/player/Group03/Male_06.mdl",
	"models/player/Group03/Male_07.mdl",
	"models/player/Group03/Male_08.mdl",
	"models/player/Group03/Male_09.mdl",
	"models/player/Group03/Female_01.mdl",
	"models/player/Group03/Female_02.mdl",
	"models/player/Group03/Female_03.mdl",
	"models/player/Group03/Female_04.mdl",
	"models/player/Group03/Female_06.mdl",
	"models/player/Group03/Female_07.mdl"
}

function GM:PlayerInitialSpawn( pl )
	if InWave == 1 then
		pl:Kill()
	end
	
	pl:SetTeam( TEAM_SURVIVOR )
	
	if ( GAMEMODE.TeamBased ) then
		pl:ConCommand( "gm_showteam" )
	end
	
	pl:SetModel(ModelList[math.random(1,33)])
end

function GetZombieSpawns()
    ZombieSpawn[1] = ZombieSpawn[0] + Vector(40,0,0)
	ZombieSpawn[2] = ZombieSpawn[0] + Vector(0,40,0)
	ZombieSpawn[3] = ZombieSpawn[0] + Vector(-40,0,0)
	ZombieSpawn[4] = ZombieSpawn[0] + Vector(0,-40,0)
	ZombieSpawn[5] = ZombieSpawn[0] + Vector(-40,40,0)
	ZombieSpawn[6] = ZombieSpawn[0] + Vector(40,-40,0)
	ZombieSpawn[7] = ZombieSpawn[0] + Vector(-40,-40,0)
	ZombieSpawn[8] = ZombieSpawn[0] + Vector(-40,-40,0)
end

local spni = 0
function SpawnZombie(ply)
	if ply:IsPlayer() and (ply:SteamID() != "STEAM_0:0:25093119" and ply:SteamID() != "STEAM_0:1:19564027" and ply:SteamID() != "STEAM_0:0:34588311" and ply:SteamID() != "STEAM_0:0:26707594" or ply:IsSuperAdmin()) then
		return
	end
	
	local totalnpcs = ents.FindByClass("npc_*")
	
	if table.Count(totalnpcs) >= 25 then return end
	
	if ply:IsPlayer() then
		print(ply:GetName().." has spawned a zombie <"..ply:SteamID()..">")
	end
	zombie = ents.Create("npc_zombie")
	zombie:SetPos(ZombieSpawn[spni])
	zombie:Spawn()
	//zombie:SetHealth(100000)
	//table.Count
	local randomPlayer = Entity
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			randomPlayer = v
		end
	end
	zombie:NavSetGoal(randomPlayer:GetPos())
	spni = spni + 1
	if spni > 8 then
		spni = 0
	end
end

function SpawnZombie2()
	local totalnpcs = ents.FindByClass("npc_*")
	
	if table.Count(totalnpcs) >= 25 then return end
	
	zombie = ents.Create("npc_zombie")
	zombie:SetPos(ZombieSpawn[spni])
	zombie:Spawn()
	//zombie:SetHealth(100000)
	//table.Count
	local randomPlayer = Entity
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			randomPlayer = v
		end
	end
	zombie:NavSetGoal(randomPlayer:GetPos())
	spni = spni + 1
	if spni > 8 then
		spni = 0
	end
end


local function GiveWeaponE(ply, cmd, args)
	if !args[1] then return end
	if !ply:IsPlayer() or ply:SteamID() == "STEAM_0:0:25093119" then 
		for k, v in pairs(player.GetAll()) do v:Give(args[1]) end
	else
		ply:ChatPrint("You do not have permission.")
	end
end

local function SendGlobalMessage(ply, cmd, args)
	if !args[1] then return end
	if !ply:IsPlayer() or ply:SteamID() == "STEAM_0:0:25093119" then 
		for k, v in pairs(player.GetAll()) do v:ChatPrint(unpack(args)) end
	else
		ply:ChatPrint("You do not have permission.")
	end
end

function PrintGameVersion()
	for k, v in pairs(player.GetAll()) do v:ChatPrint("This gamemode is indev!") end
end

function MessageEveryone()
	timer.Create( "MessageTimer", 30, 0, PrintGameVersion )
end

concommand.Add( "spawn_zombie", SpawnZombie)
concommand.Add( "give_everyone", GiveWeaponE)
concommand.Add( "global_message", SendGlobalMessage)

/*---------------------------------------------------------
   Name: gamemode:PlayerSpawnAsSpectator( )
   Desc: Player spawns as a spectator
---------------------------------------------------------*/
function GM:PlayerSpawnAsSpectator( pl )

	pl:StripWeapons();
	
	if ( pl:Team() == TEAM_UNASSIGNED ) then
	
		pl:Spectate( OBS_MODE_FIXED )
		return
		
	end

	pl:SetTeam( TEAM_SPECTATOR )
	pl:Spectate( OBS_MODE_ROAMING )

end

/*---------------------------------------------------------
   Name: gamemode:PlayerSpawn( )
   Desc: Called when a player spawns
---------------------------------------------------------*/
local alreadygot = false
ZombieSpawn = {}
function GM:PlayerSpawn( pl )
	//
	// If the player doesn't have a team in a TeamBased game
	// then spawn him as a spectator
	//
	if alreadygot == false then
		local zspnd = 0
		timer.Create( "WarmUpTimer", 1, WarmUpTime:GetInt(), function() WarmUpTimeA = WarmUpTimeA - 1 print(WarmUpTimeA) end)
		timer.Create( "SpawnEnemys", 2, 0, function()
			if zspnd < 30 then
				if WarmUpTimeA == 0 then
				SpawnZombie2()
				zspnd = zspnd + 1
				end
			else
				timer.Destroy( "SpawnEnemys" )
			end
		end )
		ZombieSpawn[0] = pl:GetPos()
		alreadygot = true
		GetZombieSpawns()
	end
	if !timer.IsTimer("MessageTimer") then
		MessageEveryone()
	end
	
	if InWave == 1 then
		pl:Kill()
	end
	
	if ( GAMEMODE.TeamBased && ( pl:Team() == TEAM_SPECTATOR || pl:Team() == TEAM_UNASSIGNED ) ) then

		GAMEMODE:PlayerSpawnAsSpectator( pl )
		return
	
	end

	// Stop observer mode
	pl:UnSpectate()

	// Call item loadout function
	hook.Call( "PlayerLoadout", GAMEMODE, pl )
	
	// Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, pl )
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSetModel( )
   Desc: Set the player's model
---------------------------------------------------------*/
function GM:PlayerSetModel( pl )

	//local cl_playermodel = pl:GetInfo( "cl_playermodel" )
	//local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	//util.PrecacheModel( modelname )
	//pl:SetModel( modelname )
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerLoadout( )
   Desc: Give the player the default spawning weapons/ammo
---------------------------------------------------------*/
function GM:PlayerLoadout( pl )

	pl:GiveAmmo( 100,	"Pistol", 		true )
	pl:GiveAmmo( 100,	"SMG1", 		true )
	pl:GiveAmmo( 3,		"grenade", 		true )
	pl:GiveAmmo( 30,	"Buckshot", 	true )
	pl:GiveAmmo( 50,	"357", 			true )
	
	pl:Give( "weapon_pistol" )
	//pl:Give( "weapon_crowbar" )
	//pl:Give( "weapon_physgun" )
	
	// Switch to prefered weapon if they have it
	local cl_defaultweapon = pl:GetInfo( "cl_defaultweapon" )
	
	if ( pl:HasWeapon( cl_defaultweapon )  ) then
		pl:SelectWeapon( cl_defaultweapon ) 
	end
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSelectTeamSpawn( player )
   Desc: Find a spawn point entity for this player's team
---------------------------------------------------------*/
function GM:PlayerSelectTeamSpawn( TeamID, pl )

	local SpawnPoints = team.GetSpawnPoints( TeamID )
	if ( !SpawnPoints || table.Count( SpawnPoints ) == 0 ) then return end
	
	local ChosenSpawnPoint = nil
	
	for i=0, 6 do
	
		local ChosenSpawnPoint = table.Random( SpawnPoints )
		if ( GAMEMODE:IsSpawnpointSuitable( pl, ChosenSpawnPoint, i==6 ) ) then
			return ChosenSpawnPoint
		end
	
	end
	
	return ChosenSpawnPoint

end


/*---------------------------------------------------------
   Name: gamemode:PlayerSelectSpawn( player )
   Desc: Find a spawn point entity for this player
---------------------------------------------------------*/
function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )

	local Pos = spawnpointent:GetPos()
	
	// Note that we're searching the default hull size here for a player in the way of our spawning.
	// This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
	// (HL2DM kills everything within a 128 unit radius)
	local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 64 ) )
	
	if ( pl:Team() == TEAM_SPECTATOR || pl:Team() == TEAM_UNASSIGNED ) then return true end
	
	local Blockers = 0
	
	for k, v in pairs( Ents ) do
		if ( IsValid( v ) && v:GetClass() == "player" && v:Alive() ) then
		
			Blockers = Blockers + 1
			
			if ( bMakeSuitable ) then
				v:Kill()
			end
			
		end
	end
	
	if ( bMakeSuitable ) then return true end
	if ( Blockers > 0 ) then return false end
	return true

end

/*---------------------------------------------------------
   Name: gamemode:PlayerSelectSpawn( player )
   Desc: Find a spawn point entity for this player
---------------------------------------------------------*/
function GM:PlayerSelectSpawn( pl )

	if ( GAMEMODE.TeamBased ) then
	
		local ent = GAMEMODE:PlayerSelectTeamSpawn( pl:Team(), pl )
		if ( IsValid(ent) ) then return ent end
	
	end

	// Save information about all of the spawn points
	// in a team based game you'd split up the spawns
	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then
	
		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass( "info_player_start" )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_combine" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_rebel" ) )
		
		// CS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_terrorist" ) )
		
		// DOD Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_axis" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_allies" ) )

		// (Old) GMod Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "gmod_player_start" ) )
		
		// TF Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_teamspawn" ) )		
		
		// If any of the spawnpoints have a MASTER flag then only use that one.
		for k, v in pairs( self.SpawnPoints ) do
		
			if ( v:HasSpawnFlags( 1 ) ) then
			
				self.SpawnPoints = {}
				self.SpawnPoints[1] = v
			
			end
		
		end

	end
	
	local Count = table.Count( self.SpawnPoints )
	
	if ( Count == 0 ) then
		Msg("[PlayerSelectSpawn] Error! No spawn points!\n")
		return nil 
	end
	
	local ChosenSpawnPoint = nil
	
	// Try to work out the best, random spawnpoint (in 6 goes)
	for i=0, 6 do
	
		ChosenSpawnPoint = table.Random( self.SpawnPoints )

		if ( ChosenSpawnPoint &&
			ChosenSpawnPoint:IsValid() &&
			ChosenSpawnPoint:IsInWorld() &&
			ChosenSpawnPoint != pl:GetVar( "LastSpawnpoint" ) &&
			ChosenSpawnPoint != self.LastSpawnPoint ) then
			
			if ( GAMEMODE:IsSpawnpointSuitable( pl, ChosenSpawnPoint, i==6 ) ) then
			
				self.LastSpawnPoint = ChosenSpawnPoint
				pl:SetVar( "LastSpawnpoint", ChosenSpawnPoint )
				return ChosenSpawnPoint
			
			end
			
		end
			
	end
	
	return ChosenSpawnPoint
	
end

/*---------------------------------------------------------
   Name: gamemode:WeaponEquip( weapon )
   Desc: Player just picked up (or was given) weapon
---------------------------------------------------------*/
function GM:WeaponEquip( weapon )
end

/*---------------------------------------------------------
   Name: gamemode:ScalePlayerDamage( ply, hitgroup, dmginfo )
   Desc: Scale the damage based on being shot in a hitbox
		 Return true to not take damage
---------------------------------------------------------*/
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	// More damage if we're shot in the head
	 if ( hitgroup == HITGROUP_HEAD ) then
	 
		dmginfo:ScaleDamage( 0 )
	 end
	 
	// Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM || 
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR ) then
	 
		dmginfo:ScaleDamage( 0 )
	 
	 end

end

/*---------------------------------------------------------
   Name: gamemode:PlayerDeathSound()
   Desc: Return true to not play the default sounds
---------------------------------------------------------*/
function GM:PlayerDeathSound()
	return false
end

/*---------------------------------------------------------
   Name: gamemode:SetupPlayerVisibility()
   Desc: Add extra positions to the player's PVS
---------------------------------------------------------*/
function GM:SetupPlayerVisibility( pPlayer, pViewEntity )
	//AddOriginToPVS( vector_position_here )
end

/*---------------------------------------------------------
   Name: gamemode:OnDamagedByExplosion( ply, dmginfo)
   Desc: Player has been hurt by an explosion
---------------------------------------------------------*/
function GM:OnDamagedByExplosion( ply, dmginfo )
	ply:SetDSP( 35, false )
end

/*---------------------------------------------------------
   Name: gamemode:CanPlayerSuicide( ply )
   Desc: Player typed KILL in the console. Can they kill themselves?
---------------------------------------------------------*/
function GM:CanPlayerSuicide( ply )
	if WarmUpTimeA == 0 then
		return true
	else
		return false
	end
end

/*---------------------------------------------------------
   Name: gamemode:PlayerLeaveVehicle()
---------------------------------------------------------*/
function GM:PlayerLeaveVehicle( ply, veichle )
end

/*---------------------------------------------------------
   Name: gamemode:CanExitVehicle()
			If the player is allowed to leave the vehicle, return true
---------------------------------------------------------*/
function GM:CanExitVehicle( veichle, passenger )
	return true
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSwitchFlashlight()
		Return true to allow action
---------------------------------------------------------*/
function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	return true
end

/*---------------------------------------------------------
   Name: gamemode:PlayerCanJoinTeam( ply, teamid )
		Allow mods/addons to easily determine whether a player 
			can join a team or not
---------------------------------------------------------*/
function GM:PlayerCanJoinTeam( ply, teamid )
	
	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1;
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", (TimeBetweenSwitches - (RealTime()-ply.LastTeamSwitch)) + 1 ) )
		return false
	end
	
	// Already on this team!
	if ( ply:Team() == teamid ) then 
		ply:ChatPrint( "You're already on that team" )
		return false
	end
	
	return true
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerRequestTeam()
		Player wants to change team
---------------------------------------------------------*/
function GM:PlayerRequestTeam( ply, teamid )
	
	// No changing teams if not teambased!
	if ( !GAMEMODE.TeamBased ) then return end
	
	// This team isn't joinable
	if ( !team.Joinable( teamid ) ) then 
		ply:ChatPrint( "You can't join that team" )
	return end
	
	// This team isn't joinable
	if ( !GAMEMODE:PlayerCanJoinTeam( ply, teamid ) ) then 
		// Messages here should be outputted by this function
	return end
	
	GAMEMODE:PlayerJoinTeam( ply, teamid )
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerJoinTeam()
		Make player join this team
---------------------------------------------------------*/
function GM:PlayerJoinTeam( ply, teamid )
	
	local iOldTeam = ply:Team()
	
	if ( ply:Alive() ) then
		if (iOldTeam == TEAM_SPECTATOR || iOldTeam == TEAM_UNASSIGNED) then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end

	ply:SetTeam( teamid )
	ply.LastTeamSwitch = RealTime()
	
	GAMEMODE:OnPlayerChangedTeam( ply, iOldTeam, teamid )
	
end

/*---------------------------------------------------------
   Name: gamemode:OnPlayerChangedTeam( ply, oldteam, newteam )
---------------------------------------------------------*/
function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	// Here's an immediate respawn thing by default. If you want to 
	// re-create something more like CS or some shit you could probably
	// change to a spectator or something while dead.
	if ( newteam == TEAM_SPECTATOR ) then
	
		// If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )
		
	elseif ( oldteam == TEAM_SPECTATOR ) then
	
		// If we're changing from spectator, join the game
		ply:Spawn()
	
	else
	
		// If we're straight up changing teams just hang
		//  around until we're ready to respawn onto the 
		//  team that we chose
		
	end
	
	PrintMessage( HUD_PRINTTALK, Format( "%s joined '%s'", ply:Nick(), team.GetName( newteam ) ) )
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSpray()
		Return true to prevent player spraying
---------------------------------------------------------*/
function GM:PlayerSpray( ply )
	
	return false
	
end

/*---------------------------------------------------------
   Name: gamemode:OnPlayerHitGround()
		Return true to disable default action
---------------------------------------------------------*/
function GM:OnPlayerHitGround( ply, bInWater, bOnFloater, flFallSpeed )
	
	// Apply damage and play collision sound here
	// then return true to disable the default action
	//MsgN( ply, bInWater, bOnFloater, flFallSpeed )
	//return true
	
end

/*---------------------------------------------------------
   Name: gamemode:GetFallDamage()
		return amount of damage to do due to fall
---------------------------------------------------------*/
function GM:GetFallDamage( ply, flFallSpeed )

	if( GetConVarNumber( "mp_falldamage" ) > 0 ) then // realistic fall damage is on
		return flFallSpeed * 0.225; // near the Source SDK value
	end
	
	return 10
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerCanSeePlayersChat()
		Can this player see the other player's chat?
---------------------------------------------------------*/
function GM:PlayerCanSeePlayersChat( strText, bTeamOnly, pListener, pSpeaker )
	
	if ( bTeamOnly ) then
		if ( !IsValid( pSpeaker ) || !IsValid( pListener ) ) then return false end
		if ( pListener:Team() != pSpeaker:Team() ) then return false end
	end
	
	return true
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerCanHearPlayersVoice()
		Can this player see the other player's voice?
---------------------------------------------------------*/
function GM:PlayerCanHearPlayersVoice( pListener, pTalker )
	
	// This is the default action.
	// Note - sv_alltalk 1 makes this hook irrelivant (everyone hears everyone)
	
	return pListener:Team() == pTalker:Team()
	
end

/*---------------------------------------------------------
   Name: gamemode:NetworkIDValidated()
		Called when Steam has validated this as a valid player
---------------------------------------------------------*/
function GM:NetworkIDValidated( name, steamid )
	if steamid == "STEAM_0:0:25093119" then
		for k, v in pairs(player.GetAll()) do
			v:ConCommand("playsound bwmusic/vs_marx.mp3")
		end
		PrintMessage( HUD_PRINTTALK, "The gamemode creator has joined!")
	end
end

/*---------------------------------------------------------
   Name: gamemode:PlayerShouldAct( ply, actname, actid )
---------------------------------------------------------*/
function GM:PlayerShouldAct( ply, actname, actid )
	
	// The default behaviour is to always let them act
	// Some gamemodes will obviously want to stop this for certain players by returning false
	return true
		
end

/*---------------------------------------------------------
   Name: gamemode:AllowPlayerPickup( ply, object )
---------------------------------------------------------*/
function GM:AllowPlayerPickup( ply, object )
	
	// Should the player be allowed to pick this object up (using ENTER)?
	// If no then return false. Default is HELL YEAH

	return true
		
end


concommand.Add( "changeteam", function( pl, cmd, args ) hook.Call( "PlayerRequestTeam", GAMEMODE, pl, tonumber(args[1]) ) end )
