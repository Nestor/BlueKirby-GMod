
gmsave = {}

if ( SERVER ) then

	include( 'gmsave/entity_filters.lua' )
	include( 'gmsave/player.lua' )
	
end

if ( CLIENT ) then

	include( 'gmsave/uploader.lua' )
	
end

if ( SERVER ) then

	local g_WavSound = 1

	function gmsave.LoadMap( strMapContents, ply )

		if ( !ply ) then ply = Entity(1) end
		
		// TODO: Do this in engine before sending it to this function.
		
		// Strip off any crap before the start char..
		local startchar = string.find( strMapContents, '' )
		if ( startchar != nil ) then
			strMapContents = string.sub( strMapContents, startchar )
		end
		
		// Stip off any crap after the end char..
		strMapContents = strMapContents:reverse()
		local startchar = string.find( strMapContents, '' )
		if ( startchar != nil ) then
			strMapContents = string.sub( strMapContents, startchar )
		end
			strMapContents = strMapContents:reverse()
			
		// END TODO
		
		local tab = glon.decode( strMapContents )

		
		game.CleanUpMap()
		
		ply:SendLua( "hook.Call( \"OnSpawnMenuClose\", GAMEMODE )" );
		
		g_WavSound = g_WavSound + 1
		if ( g_WavSound > 4 ) then g_WavSound = 1; end
		
		ply:SendLua( "surface.PlaySound( \"garrysmod/save_load"..g_WavSound..".wav\" )" )
		gmsave.PlayerLoad( ply, tab.Player ) 
		
		timer.Simple( 0.1, function() 
										if ( !IsValid( ply ) ) then return end
										
										
										DisablePropCreateEffect = true
										ReplaceMapEntities = true
										duplicator.Paste( ply, tab.Entities, tab.Constraints )
										DisablePropCreateEffect = nil
										ReplaceMapEntities = nil
										
										// The player might have 'fell' while we were loading
										// Causes problems if they were standing on a prop
										// which wasn't created then!
										gmsave.PlayerLoad( ply, tab.Player ) 
						end )

	end

	function gmsave.SaveMap( ply )

		local Ents = ents.GetAll()

		for k, v in pairs( Ents ) do

			if ( !gmsave.ShouldSaveEntity( v, v:GetSaveTable() ) || v:IsConstraint()  ) then
				Ents[ k ] = nil
			end

		end

		local E, C = duplicator.CopyEnts( Ents )

		local tab = {}
		tab.Entities = E
		tab.Constraints = C
		tab.Player = gmsave.PlayerSave( ply )

		return glon.encode( tab )
	end

end // if SERVER