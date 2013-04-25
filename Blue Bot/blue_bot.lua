--[[BBVERSION=061
Made by:
 .  ....................................................................................................................
..MMMMMMMM8....,MM~........MMM.....NMM...MMMMMMMMMM........NMM.....MMMO..MMZ..MMMMMMMMM7....MMMMMMMMM...,MMM......MMM...
..MMMMMMMMMM...,MM:........MMM.....NMM...MMMMMMMMMM...  ...NMM...+MMM....MMZ..MMMMMMMMMMM...MMMMMMMMMM?. :MMM...:MMM..  
..MM$.....MM$..,MM:........MMM.....NMM...MMN...............NMM..MMM7.....MMZ..MMM.....7MM...MM8.....MMD...~MMN..MMN.....
..MM8???IMMM. .,MM:   ..  .MMM.  ..NMM...MMM???????.     ..NMM~MMM..   ..MMZ .MMM....?MMM...MMD???IMMM.  ...MMMMMM.     
..MMMMMMMMM8...,MM:   .. ..MMM.  ..NMM...MMMMMMMMMN.     ..NMMMMMMM..  ..MMZ .MMMMMMMMMM....MMMMMMMMMN...  .=MMMM..  .  
..MMZ.....MMM..,MM:   ..  .MMM.   .NMM...MMN........     ..NMMM.,MMM.  ..MMZ .MMM..OMM8.....MM8.....MMM..  ..MMM...     
..MM$.   .DMM..,MM:   ..  .NMM.....MMM...MMN.            ..NMM....MMM....MMZ .MMM...,MMM....MM8.  ..8MM..   .NMM...     
..MMMMMMMMMMM..,MMMMMMMMM..,MMM+..MMM? ..MMMMMMMMMM~.. . ..NMM....~MMM...MMZ .MMM....~MMN...MMMMMMMMMMM..   .NMM.... ...
..MMMMMMMMM:. .,MMMMMMMMM....MMMMMMM:....MMMMMMMMMM~.. ....NMM.....+MMM..MMZ..MMM.... ,MMM..MMMMMMMMM=... ...NMM.... ...
..       ......           .........  .....         .........   ..... . . .  ...   ....  . ..       ............  .......
If you paid for this, you got scammed, kido
I'll be updating this regularly and it's pretty modular so feel free to add onto it
Please don't reupload any shitty variation of the hack you make.

NOTICE: If you take code from this, add credits for Blue Kirby please. THANK YAWWW
Official Blue Bot thread: http://www.mpgh.net/forum/713-garrys-mod-hacks-cheats/654228-blue-bot-lua-hack.html]]

local BB = { };

--This is your prefix you can change it to anything you want
--By default it's random so every time you load the hack it's different
--This is just to make it a little bit more difficult for anti-cheats
--I don't recommend making it blue_bot or anything with bot in the name
--Try using like llama or catpenis just nothing with hack or bot in the name

--Default to nil if you want to use a random prefix
-----------------------
BB.CustomPrefix = "bluebot";
-----------------------

-------------------------------------------------------
--Don't edit below unless you know what you are doing--
-------------------------------------------------------

function BB.RandomString( len, numbers, special )
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"..(numbers == true && "1234567890" or "")..(special == true && "!@#$%^&*(),.-" or ""); --You can change the list if you like
	local result = "";
	
	if (len < 1) then
		len = math.random( 10, 20 );
	end
	
	for i = 1, len do
		result = result..string.char( string.byte( chars, math.random( 1, string.len( chars ) ) ) );
	end
	
	return tostring(result);
end

BB.MetaPlayer = FindMetaTable( "Player" );
BB.MetaConVar = FindMetaTable( "ConVar" );

BB.CreateClientConVar = CreateClientConVar;
function BB.MetaConVar:OnMenu() return false; end

local function CreateClientConVar( name, default, save, onmenu )
	BB.CreateClientConVar( name, default, save, false );
	return {cvar = GetConVar( name ), OnMenu = onmenu};
end

BB.RandomPrefix = BB.CustomPrefix or BB.RandomString( math.random( 5, 8 ), false );
BB.DeadPlayers = { };
BB.Traitors = { };
BB.TWeaponsFound = { };
BB.RandomHooks = { hook = { }, name = { } };
BB.ply = LocalPlayer;
BB.players = player.GetAll;
BB.Target = nil;
BB.ShouldReturn = false;
BB.CVARS = {Bools = { }, Numbers = { }};
BB.CVARS.Bools["Aimbot"] = CreateClientConVar( BB.RandomPrefix.."_aimbot_enabled", "0", true, true );
BB.CVARS.Numbers["Max Angle"] = CreateClientConVar( BB.RandomPrefix.."_aimbot_max_angle", "30", true, true );
BB.CVARS.Bools["Aim at friends"] = CreateClientConVar( BB.RandomPrefix.."_aimbot_friendly_fire", "1", true, true );
BB.CVARS.Bools["ESP"] = CreateClientConVar( BB.RandomPrefix.."_esp_enabled", "1", true, true );
BB.CVARS.Bools["Chams"] = CreateClientConVar( BB.RandomPrefix.."_chams_enabled", "1", true, true );
BB.CVARS.Bools["Crosshair"] = CreateClientConVar( BB.RandomPrefix.."_crosshair_enabled", "1", true, true );
BB.Mat = CreateMaterial( string.lower( BB.RandomString( math.random( 5, 8 ), false, false ) ), "VertexLitGeneric", { ["$basetexture"] = "models/debug/debugwhite", ["$model"] = 1, ["$ignorez"] = 1 } ); --Last minute change
BB.HeadPos = nil;
BB.TraceRes = nil;
BB.Font = nil;
BB.IsTraitor = nil;
BB.IsTTT = false;
BB.PrintEx = MsgC;
BB.LatestVersion = nil;
BB.Version = "0.6.1";
BB.V = 61; --DO NOT EDIT THIS

function BB.Init( )
	--Eww this is ugly
	BB.Font = BB.RandomString( 0, false, false );
	surface.CreateFont( BB.Font, { font = "Arial", size = 14, weight = 750, antialias = false, outline = true } );
	BB.IsTTT = string.find( GAMEMODE.Name , "Terror" );
	
	RunConsoleCommand( "showconsole" );
	Msg( "\n\n\n" );
	BB.Print( true, true, Color( 25, 225, 80 ), "Loaded!", Color( 255, 255, 255 ), "\tv"..BB.Version );
	BB.Print( true, true, Color( 255, 255, 255 ), "Your random prefix is "..BB.RandomPrefix );
	BB.Print( true, true, Color( 255, 255, 255 ), "Checking for updates..." );
	MsgC( Color( 255, 255, 255 ), "Made by: Blue Kirby\n\n\n\n" );
	
	http.Fetch( "http://bluekirbygmod.googlecode.com/svn/trunk/Blue%20Bot/blue_bot.lua", 
		function( HTML ) 
			local findpos = string.find( HTML, "BBVERSION=", 0, false );
			
			if (findpos) then
				local version = tonumber( string.sub( HTML, findpos+10, findpos+13 ) );
				if ( version > BB.V ) then
					BB.Print( true, true, Color( 255, 200, 50 ), "Your version is out of date!" );
					BB.LatestVersion = HTML;
					BB.UpdateMenu();
				else
					BB.Print( true, true, Color( 200, 255, 200 ), "Your version is up to date." );
				end
			end
		end,
		
		function() 
			BB.Error( "Failed checking for updates." );
		end 
	);
	
	if (BB.IsTTT) then
		BB.IsTraitor = BB.MetaPlayer.IsTraitor
		
		function BB.MetaPlayer:IsTraitor()
			if (self == BB.ply()) then return BB.IsTraitor( self ); end
			
			if (!table.HasValue( BB.Traitors, self )) then
				return BB.IsTraitor( self );
			else
				return true;
			end
		end
	end
end

function BB.Print( timestamp, stamp, ... )
	if (timestamp) then
		Msg( "["..os.date("%H:%M:%S").."] " );
	end
	
	if (stamp) then
		MsgC( Color( 50, 100, 255 ), "[Blue Bot] " );
	end
	
	local t = {...};
	
	if (#t == 1) then
		BB.PrintEx( Color(255, 255, 255), t[1] );
	else
		for i = 1, #t, 2 do
			BB.PrintEx( t[i], t[i+1] );
		end
	end
	
	Msg('\n');
end

function BB.PrintChat( ... )
	chat.AddText( Color( 50, 100, 255 ), "[Blue Bot] ", ... );
end

function BB.Error( error )
	Msg( "["..os.date("%H:%M:%S").."] " );
	MsgC( Color( 255, 50, 50 ), "[Blue Bot] ERROR: " );
	MsgC( Color( 255, 255, 255 ), error.."\n" );
end

function BB.IsOnTeam( ply )
	if ( BB.IsTTT ) then
		return ply:IsTraitor() == BB.ply():IsTraitor();
	else
		return ply:Team() == BB.ply():Team();
	end
end

function BB.GetValidPlayers( )
	local players = { };
	
	for _, ply in pairs( BB.players() ) do
		if ( ply != BB.ply && IsValid( ply ) && 
		ply:IsPlayer() && 
		ply:Alive() && 
		ply:Health() >= 1 &&
		( !BB.IsOnTeam( ply ) || BB.CVARS.Bools["Aim at friends"].cvar:GetBool() ) ) then
			table.insert( players, ply );
		end
	end
	
	return players
end

function BB.IsVisible( ply )
	if (!IsValid( ply )) then return false end
	
	local vecPos, _ = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) or 12 );
	local trace = { start = BB.ply():EyePos(), endpos = vecPos, filter = BB.ply(), mask = MASK_SHOT };
	local traceRes = util.TraceLine( trace );
	
	BB.TraceRes = traceRes;
	
	if (traceRes.HitWorld || traceRes.Entity != ply) then return false end;
	
	return true;
end

function BB.ClosestAngle( players )
	local flAngleDifference = nil;
	local newAngle = nil;
	local viewAngles = BB.ply():EyeAngles();
	
	for _, ply in pairs( players ) do
		local vecPos, ang = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) or 12 );
		local oldpos = vecPos;
		vecPos = vecPos - BB.VelocityPrediction( BB.ply() ) + BB.VelocityPrediction( ply )
		local angAngle = ( vecPos - BB.ply():EyePos() ):Angle()
		local flDif = math.abs( math.AngleDifference( angAngle.p, viewAngles.p ) ) + math.abs( math.AngleDifference( angAngle.y, viewAngles.y ) );
		
		if ((flAngleDifference == nil || flDif < flAngleDifference) && (!BB.CVARS.Numbers["Max Angle"].cvar:GetBool() || flDif < BB.CVARS.Numbers["Max Angle"].cvar:GetFloat())) then
			BB.HeadPos = oldpos:ToScreen();
			BB.Target = ply;
			flAngleDifference = flDif;
			newAngle = angAngle;
		end
	end
	
	return newAngle;
end

function BB.VelocityPrediction( ply ) return ply:GetAbsVelocity() * 0.012; end

function BB.Aimbot( )
	BB.HeadPos = nil;
	
	if (!BB.CVARS.Bools["Aimbot"].cvar:GetBool() || BB.ShouldReturn) then return end
	
	local players = {};
	
	for _, ply in pairs( BB.GetValidPlayers() ) do
		if (BB.IsVisible( ply )) then
			table.insert( players, ply );
		end
	end
	
	if (table.Count( players ) == 0) then 
		BB.Target = nil;
		return
	end;
	
	local newAngle = BB.ClosestAngle( players );
	
	if ( newAngle != nil ) then BB.ply():SetEyeAngles( newAngle ) end;
end

function BB.TableSortByDistance( former, latter ) return latter:GetPos():Distance( BB.ply():GetPos() ) > former:GetPos():Distance( BB.ply():GetPos() ) end

function BB.GetPlayersByDistance( )
	local players = BB.players( );
	
	table.sort( players, BB.TableSortByDistance );
	
	return players;
end

function BB.CreateMove( cmd )
	if (BB.IsTTT && BB.ply():Alive() && BB.ply():Health() >= 1 && BB.ply():Team() != TEAM_SPECTATOR) then
		BB.ply().voice_battery = 100; --Infinite voichat time I don't need to check if it's TTT because swag
	end
	
	if (cmd:KeyDown( IN_ATTACK ) && BB.ShouldReturn ) then
		BB.ShouldReturn = false;
		BB.Aimbot( );
	elseif ( !cmd:KeyDown( IN_ATTACK ) && !BB.ShouldReturn ) then
		BB.ShouldReturn = true;
	end
	
	if (IsValid( BB.ply() ) && BB.ply():Alive() && BB.ply():Health() > 0 && IsValid( BB.ply():GetActiveWeapon() )) then
		BB.ply():GetActiveWeapon().Recoil = 0;
		if ( BB.ply():GetActiveWeapon().Primary ) then
			BB.ply():GetActiveWeapon().Primary.Recoil = 0;
		end
	end
end

function BB.NoVisualRecoil( ply, pos, angles, fov )
   if (BB.ply():Health() > 0 && BB.ply():Team() != TEAM_SPECTATOR && BB.ply():Alive()) then
	   return GAMEMODE:CalcView( ply, BB.ply():EyePos(), BB.ply():EyeAngles(), fov, 0.1 );
   end
end

function BB.AddToColor( color, add )
	return color + add <= 255 and color + add or color + add - 255
end

function BB.SubtractFromColor( color, sub )
	return color - sub >= 0 and color - sub or color - sub + 255
end

function BB.ESP( )
	if (!BB.CVARS.Bools["Crosshair"].cvar:GetBool() && !BB.CVARS.Bools["ESP"].cvar:GetBool()) then return end;
	
	if ( BB.CVARS.Bools["Crosshair"].cvar:GetBool() ) then
		surface.SetDrawColor(Color(255, 255, 255))
		surface.DrawLine( ScrW()/2-10, ScrH()/2, ScrW()/2-4, ScrH()/2 );
		surface.DrawLine( ScrW()/2+10, ScrH()/2, ScrW()/2+4, ScrH()/2 );
		surface.DrawLine( ScrW()/2, ScrH()/2-10, ScrW()/2, ScrH()/2-4 );
		surface.DrawLine( ScrW()/2, ScrH()/2+10, ScrW()/2, ScrH()/2+4 );
	end
	
	if ( !BB.CVARS.Bools["ESP"].cvar:GetBool() ) then return end
	
	surface.SetFont( BB.Font );
	
	for _, ply in pairs( BB.players() ) do
		if (ply != BB.ply() && ply:Health() >= 1 && ply:Alive() && ply:Team() != TEAM_SPECTATOR) then
			local min, max = ply:GetRenderBounds();
			local pos = ply:GetPos() + Vector( 0, 0, ( min.z + max.z ) );
			local color = Color( 50, 255, 50, 255 );
			
			if ( ply:Health() <= 10 ) then color = Color( 255, 0, 0, 255 );
			elseif ( ply:Health() <= 20 ) then color = Color( 255, 50, 50, 255 );
			elseif ( ply:Health() <= 40 ) then color = Color( 250, 250, 50, 255 );
			elseif ( ply:Health() <= 60 ) then color = Color( 150, 250, 50, 255 ); 
			elseif ( ply:Health() <= 80 ) then color = Color( 100, 255, 50, 255 ); end
			
			pos = ( pos + Vector( 0, 0, 10 ) ):ToScreen();
			
			local width, height = surface.GetTextSize( tostring( ply:Nick() ) ); -- I have to do tostring because sometimes errors would occur
			draw.DrawText( ply:Nick(), BB.Font, pos.x, pos.y-height/2, ( BB.IsTTT && ply:IsTraitor() ) and Color( 255, 150, 150, 255 ) or Color( 255, 255, 255, 255 ), 1 );
			
			if ( BB.IsTTT && ply:IsTraitor() ) then
				width, height = surface.GetTextSize( "TRAITOR" );
				draw.DrawText( "TRAITOR", BB.Font, pos.x, pos.y-height-3, Color( 255, 0, 0, 255 ), 1 );
			end
			
			pos = ply:GetPos():ToScreen();
			width, height = surface.GetTextSize( "Health: "..tostring( ply:Health() ) );
			draw.DrawText( "Health: "..tostring( ply:Health() ), BB.Font, pos.x, pos.y, color, 1 );
		end
	end
	
	for _, ent in pairs( ents.FindByClass( "ttt_c4" ) ) do
		if (!BB.IsTTT) then break; end
		
		local pos = ent:GetPos():ToScreen();
		
		local width, height = surface.GetTextSize( "C4" );
		draw.DrawText( !ent:GetArmed() and "C4 - Unarmed" or "C4 - "..string.FormattedTime(ent:GetExplodeTime() - CurTime(), "%02i:%02i"), BB.Font, pos.x, pos.y-height/2, Color( 255, 255, 255, 255 ), 1 );
	end
	
	if (BB.IsTTT) then
		for _, ent in pairs( ents.FindByClass( "prop_ragdoll" ) ) do
			local name = CORPSE.GetPlayerNick(ent, false)
			if ( name != false ) then
				local pos = ent:GetPos():ToScreen();
				local width, height = surface.GetTextSize( name );
				
				draw.DrawText( name, BB.Font, pos.x, pos.y-height/2, Color( 255, 255, 255, 255 ), 1 );
				
				if ( !CORPSE.GetFound(ent, false) ) then
					draw.DrawText( "Unidentified", BB.Font, pos.x, pos.y-height/2+12, Color( 200, 200, 0, 255 ), 1 );
				end
			end
		end
	end
	
	if (BB.HeadPos != nil) then
		local width = 5;
		local height = 5;
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) );
		surface.DrawOutlinedRect( BB.HeadPos.x-width/2, BB.HeadPos.y-height/2, width, height );
	end
end

function BB.Chams()
	if (BB.CVARS.Bools["Chams"].cvar:GetBool()) then
		for _, ply in pairs( BB.GetPlayersByDistance( ) ) do
			if (IsValid( ply ) && ply:Alive() && ply:Health() > 0 && ply:Team() != TEAM_SPECTATOR) then
				local color = (BB.IsTTT and ply:IsTraitor( )) and Color( 200, 50, 50 ) or team.GetColor( ply:Team( ) );
				
				cam.Start3D( BB.ply():EyePos(), BB.ply():EyeAngles() );
					render.SuppressEngineLighting( true );

					render.SetColorModulation( color.r/255, color.g/255, color.b/255, 1 );
					render.MaterialOverride( BB.Mat );
					ply:DrawModel();
					
					render.SetColorModulation( BB.AddToColor( color.r, 150 )/255, BB.AddToColor( color.g, 150 )/255, BB.AddToColor( color.b, 150 )/255, 1 );
					if (IsValid( ply:GetActiveWeapon() )) then
						ply:GetActiveWeapon():DrawModel() 
					end
					
					if (BB.IsTTT && ply:IsTraitor()) then
						render.SetColorModulation( 1, 0, 0, 1 );
					else
						render.SetColorModulation( 1, 1, 1, 1 );
					end
					render.MaterialOverride();
					render.SetModelLighting( 4, color.r/255, color.g/255, color.b/255 );
					ply:DrawModel();
					
					render.SuppressEngineLighting( false );
				cam.End3D();
			end
		end
		
		for _, ent in pairs( ents.FindByClass( "ttt_c4" ) ) do
			cam.Start3D( BB.ply():EyePos(), BB.ply():EyeAngles() );
				render.SuppressEngineLighting( true );
				render.SetColorModulation( 1, 0, 0, 1 );
				render.MaterialOverride( BB.Mat );
				ent:DrawModel( );
				
				render.SetColorModulation( 1, 1, 1, 1 );
				render.MaterialOverride();
				render.SetModelLighting( BOX_TOP, 1, 1, 1 )
				ent:DrawModel();
					
				render.SuppressEngineLighting( false );
			cam.End3D();
		end
		
		if (BB.IsTTT) then
			for _, ent in pairs( ents.FindByClass( "prop_ragdoll" ) ) do
				if ( CORPSE.GetPlayerNick(ent, false) != false ) then
					cam.Start3D( BB.ply():EyePos(), BB.ply():EyeAngles() );
						render.SuppressEngineLighting( true );
						render.SetColorModulation( 1, 0.8, 0.5, 1 );
						render.MaterialOverride( BB.Mat );
						ent:DrawModel( );
						
						render.SetColorModulation( 1, 1, 1, 1 );
						render.MaterialOverride();
						render.SetModelLighting( BOX_TOP, 1, 1, 1 )
						ent:DrawModel();
							
						render.SuppressEngineLighting( false );
					cam.End3D();
				end
			end
		end
	end
end

function BB.PlayerDeath( ply )
	BB.PrintChat( Color( 255, 255, 255 ), ply:Nick().." has died!" );
end

timer.Create( BB.RandomString( 0, false, false ), 0.25, 0, function( )
	if (!BB.IsTTT || GetRoundState() != 3) then 
		if ( BB.DeadPlayers != { } ) then
			BB.DeadPlayers = { }
		end
		return;
	end
	
	for _, ply in pairs( BB.players() ) do
		if ((!ply:Alive() || ply:Health() <= 0) && !table.HasValue( BB.DeadPlayers, ply )) then
			table.insert( BB.DeadPlayers, ply );
			BB.PlayerDeath( ply );
		end
	end
end )

function BB.TraitorDetector()
	if (!BB.IsTTT || BB.ply():IsTraitor()) then return end
	
	if (GetRoundState() == 2) then
		for _, wep in pairs(ents.GetAll()) do
			if (wep.CanBuy && wep:IsWeapon() && !table.HasValue(BB.TWeaponsFound, wep:EntIndex())) then
				table.insert( BB.TWeaponsFound, wep:EntIndex() )
			end
		end
	end
	
	if (GetRoundState() != 3 && GetRoundState() != 2) then
		table.Empty( BB.Traitors );
		table.Empty( BB.TWeaponsFound );
		return;
	end
	
	for _, wep in pairs(ents.GetAll()) do
		if (wep:IsWeapon() && wep.CanBuy && IsValid( wep:GetOwner() ) && wep:GetOwner():IsPlayer() && !table.HasValue( BB.TWeaponsFound, wep:EntIndex() )) then
			local ply = wep:GetOwner();
			table.insert( BB.TWeaponsFound, wep:EntIndex() );
			
			if (!ply:IsDetective()) then
				if (!table.HasValue(BB.Traitors, ply)) then
					table.insert(BB.Traitors, ply);
				end
				if (ply != BB.ply() && !BB.ply():IsTraitor()) then
					chat.AddText( Color( 255, 150, 150 ), ply:Nick(), Color( 255, 255, 255 ), " is a ", Color( 255, 50, 50 ), "traitor: ", Color( 200, 120, 50 ), wep:GetPrintName() or wep:GetClass() );
				end
			end
		end
	end
end

function BB.AddHook( hookname, name, func )
	table.insert( BB.RandomHooks.hook, hookname );
	table.insert( BB.RandomHooks.name, name );
	hook.Add( hookname, name, func );
end

function BB.Menu( )
	local Panel = vgui.Create( "DFrame" );
	Panel:SetSize( 500, 300 );
	Panel:SetPos( ScrW()/2-Panel:GetWide()/2, ScrH()/2-Panel:GetTall()/2 );
	Panel:SetTitle( "Blue Bot" );
	Panel:MakePopup();
	
	local Label = vgui.Create( "DLabel", Panel );
	Label:SetPos( 25, 50 );
	Label:SetColor( Color( 255, 255, 255, 255 ) );
	Label:SetText( "Settings" );
	Label:SizeToContents();
	
	local Label = vgui.Create( "DLabel", Panel );
	Label:SetPos( 275, 50 );
	Label:SetColor( Color( 255, 255, 255, 255 ) );
	Label:SetText( "More coming soon" );
	Label:SizeToContents();
	
	local List = vgui.Create( "DPanelList", Panel );
	List:SetPos( 25, 65 );
	List:SetSize( 200, 200 );
	List:SetSpacing( 5 );
	List:EnableHorizontal( false );
	List:EnableVerticalScrollbar( true );
	List:SetPadding(5);
	function List:Paint()
		draw.RoundedBox( 4, 0, 0, List:GetWide(), List:GetTall(), Color( 0, 0, 0, 150 ) );
	end
	
	for name, base in pairs(BB.CVARS.Bools) do
		if (base.OnMenu) then
			local CheckBox = vgui.Create( "DCheckBoxLabel" );
			CheckBox:SetText( name );
			CheckBox:SetConVar( base.cvar:GetName() );
			CheckBox:SetValue( base.cvar:GetBool() );
			CheckBox:SizeToContents();
			List:AddItem( CheckBox );
		end
	end
	
	List = vgui.Create( "DPanelList", Panel );
	List:SetPos( 275, 65 );
	List:SetSize( 200, 200 );
	List:SetSpacing( 5 );
	List:EnableHorizontal( false );
	List:EnableVerticalScrollbar( true );
	List:SetPadding( 5 );
	function List:Paint()
		draw.RoundedBox( 4, 0, 0, List:GetWide(), List:GetTall(), Color( 0, 0, 0, 150 ) );
	end
end

function BB.UpdateMenu()
	local Panel = vgui.Create( "DFrame" );
	Panel:SetSize( 800, 600 );
	Panel:SetPos( ScrW()/2-Panel:GetWide()/2, ScrH()/2-Panel:GetTall()/2 );
	Panel:SetTitle( "Blue Bot - Notice" );
	Panel:MakePopup();
	
	local Label = vgui.Create( "DLabel", Panel );
	Label:SetColor( Color( 255, 255, 255, 255 ) );
	Label:SetFont( "DermaLarge" );
	Label:SetText( "Your version is outdated" );
	Label:SizeToContents();
	Label:SetPos( Label:GetParent():GetWide()/2-Label:GetWide()/2-5, 50 );
	
	local HTML = vgui.Create( "HTML", Panel )
	HTML:OpenURL( "http://bluekirbygmod.googlecode.com/svn/trunk/Blue%20Bot/blue_bot.lua" )
	HTML:SetSize( HTML:GetParent():GetWide() - 50, HTML:GetParent():GetTall() - 160 )
	HTML:SetPos( 25, 100 )
	HTML.Paint = function()
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) );
		surface.DrawRect( 0, 0, HTML:GetWide(), HTML:GetTall() );
	end
	
	local Button = vgui.Create( "DButton", Panel )
	Button:SetText( "Save" )
	Button:SetSize( Button:GetParent():GetWide() - 50, 25 )
	Button:SetPos( 25, Button:GetParent():GetTall() - 30 )
	Button.DoClick = function()
		HTML:SetVisible( false );
		Panel:SetSize( 400, 150 );
		Panel:SetPos( ScrW()/2-Panel:GetWide()/2, ScrH()/2-Panel:GetTall()/2 );
		Label:SetText( "Saved to data/bluebotv"..BB.V..".txt" );
		Label:SizeToContents();
		Label:SetPos( Label:GetParent():GetWide()/2-Label:GetWide()/2-5, 50 );
		file.Write( "bluebotv"..BB.V..".txt", BB.LatestVersion );
	end
end

BB.Init();

BB.AddHook( "RenderScreenspaceEffects" , BB.RandomString( 0, true, true ), BB.Chams );
BB.AddHook( "Think", BB.RandomString( 0, true, true ), BB.Aimbot );
BB.AddHook( "Think", BB.RandomString( 0, true, true ), BB.TraitorDetector );
BB.AddHook( "CreateMove", BB.RandomString( 0, true, true ), BB.CreateMove );
BB.AddHook( "CalcView", BB.RandomString( 0, true, true ), BB.NoVisualRecoil );
BB.AddHook( "HUDPaint", BB.RandomString( 0, true, true ), BB.ESP );

concommand.Add( BB.RandomPrefix.."_unload", function( ply, cmd, args ) 
	for i = 1, #BB.RandomHooks.hook do
		hook.Remove( BB.RandomHooks.hook[i], BB.RandomHooks.name[i] );
		BB.Print( true, true, Color( 255, 255, 255 ), "Unhooked "..BB.RandomHooks.hook[i].." using name "..BB.RandomHooks.name[i] );
	end
	concommand.Remove( BB.RandomPrefix.."_unload" )
	BB.Print( true, true, Color( 255, 255, 255 ), "Unloaded successfully!" );
end );

concommand.Add( BB.RandomPrefix.."_menu", BB.Menu );