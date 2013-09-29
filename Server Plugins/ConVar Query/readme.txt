ConVar Query

Made by: Blue Kirby

Place the convar_query.dll file in your addons folder.

In your server startup parameters add +plugin_load addons/convar_query

In your server.cfg add (plugin_load "addons/convar_query") without parentheses.
If you do not have a server.cfg file, make a new text file then rename to server.cfg and add that line.

To use find get a player and run a query like so:

player.GetByID(1):QueryConVar( "sv_cheats", function( value ) print( "The value of the convar is "..value ) end )

Or you can do something a bit more elaborate:

local convars = { ["sv_cheats"] = "0", ["host_timescale"] = "1", ["sv_allowcslua"] = "0" };

for _, ply in pairs( player.GetAll() ) do
	for convar, def_value in pairs( convars ) do
		ply:QueryConVar( convar, function( value )
			if ( value != def_value ) then
				if (IsValid( ply )) then
					ply:Ban( 1337, "Convar "..convar.." did not match." );
				end
			end
		end )
	end
end