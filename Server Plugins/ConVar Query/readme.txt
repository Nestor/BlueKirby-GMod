ConVar Query readme

Credits:
Blue Kirby

Installation:
Place the convar_query.dll along with the convar_query.vdf file in your addons folder.

NOTICE:
To try and remove the dependency on sigs I do not push the player entity as a parameter because
it is just as easy to store the player variable and use it accordingly.


Usage:
--Passes the value of the cvar as the only paramater in the callback
player:QueryConVar( cvar name <string>, callback <function> )

Example scripts:

--Would print "The value of the convar is 0" if sv_cheats is 0 on the client
player.GetByID(1):QueryConVar( "sv_cheats", function( value ) print( "The value of the convar is "..value ) end )

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