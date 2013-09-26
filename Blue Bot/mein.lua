include( "vgui.lua" )

local BB = {};

BB.Hooks = {};
BB.JumpReleased = false;
BB.enabled = true;
BB.PrintEx = MsgC;
BB.ViewOffset = nil;
BB.ScrW = ScrW();
BB.ScrH = ScrH();
BB.ScrWHalf = BB.ScrW/2;
BB.ScrHHalf = BB.ScrH/2;
BB.HeadAng = nil;

function BB:GetTarget()
	local players = {};
	
	for _, ply in ipairs(player.GetAll()) do
		if (ply != LocalPlayer() and ply:Alive() and /*ply:Team() != LocalPlayer():Team() and*/ ply:Team() != TEAM_SPECTATOR) then
			players[#players+1] = ply;
		end
	end
	
	local flAngleDifference = nil;
	local newAngle = nil;
	local viewAngles = EyeAngles() + (BB.ViewOffset or Angle());
	
	for _, ply in ipairs( players ) do
		local vecPos, _ = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) or 12 );
		local oldpos = vecPos;
		//vecPos = vecPos - BB.VelocityPrediction( BB.ply() ) + BB.VelocityPrediction( ply )
		local pos = (vecPos - LocalPlayer():EyePos());
		pos:Normalize();
		local angAngle = ( pos ):Angle()
		local flDif = math.abs( math.AngleDifference( angAngle.p, viewAngles.p ) ) + math.abs( math.AngleDifference( angAngle.y, viewAngles.y ) );
		
		if (flAngleDifference == nil || flDif < flAngleDifference) then
			//BB.HeadPos = oldpos:ToScreen();
			//BB.Target = ply;
			flAngleDifference = flDif;
			newAngle = angAngle;
		end
	end
	
	return newAngle;
end

function BB.Hooks.CreateMove( cmd )
	local newang = BB:GetTarget();
	
	cmd:SetViewAngles( newang );
	//print( newang );
	
	if (cmd:KeyDown( IN_JUMP )) then
		if (!BB.JumpReleased) then
			if (!LocalPlayer():OnGround()) then
				cmd:RemoveKey( IN_JUMP );
			end
		else
			BB.JumpReleased = false
		end
	elseif (!BB.JumpReleased) then
		BB.JumpReleased = true;
	end
end

function BB.Hooks.Think()
	/*local ply = LocalPlayer();
	
	local newang = BB:GetTarget();
	
	if (BB.ViewOffset) then
		ply:SetEyeAngles( ply:EyeAngles() + BB.ViewOffset );
	end
	
	BB.ViewOffset = nil;
	
	if (newang) then
		BB.ViewOffset = ply:EyeAngles() - newang;
		ply:SetEyeAngles( newang );
	end
	
	BB.HeadAng = newang;*/
end

function BB.Hooks.HUDPaint()
	surface.SetDrawColor( Color( 255, 255, 255 ) );
	surface.DrawLine( BB.ScrWHalf-10, BB.ScrHHalf, BB.ScrWHalf-4, BB.ScrHHalf );
	surface.DrawLine( BB.ScrWHalf+10, BB.ScrHHalf, BB.ScrWHalf+4, BB.ScrHHalf );
	surface.DrawLine( BB.ScrWHalf, BB.ScrHHalf-10, BB.ScrWHalf, BB.ScrHHalf-4 );
	surface.DrawLine( BB.ScrWHalf, BB.ScrHHalf+10, BB.ScrWHalf, BB.ScrHHalf+4 );
end

function BB.Hooks.CalcView( ply, pos, angles, fov )

	local Weapon 		= ply:GetActiveWeapon();	
	local view 			= {};
	view.origin 		= origin;
	view.angles			= /*BB.HeadAng or*/ ply:EyeAngles();
	view.fov 			= fov;
	view.znear			= znear;
	view.zfar			= zfar;
	view.drawviewer		= false;
	
	if (BB.HeadAng) then
		BB.HeadAng = nil;
	end
	
	player_manager.RunClass( ply, "CalcView", view );
	
	if ( IsValid( Weapon ) ) then
	
		local func = Weapon.GetViewModelPosition
		if ( func ) then
			view.vm_origin,  view.vm_angles = func( Weapon, (origin or Vector())*1, angles*1 );
		end
		
		local func = Weapon.CalcView
		if ( func ) then
			view.origin, view.angles, view.fov = func( Weapon, ply, origin*1, angles*1, fov );
		end
	
	end
	
	if (BB.ViewOffset and view.angles.p + BB.ViewOffset.p > 89) then
		BB.ViewOffset.p = view.angles.p + 89;
	end
	
	view.angles = view.angles //+ (BB.ViewOffset or Angle());
	
	return view;
	
end

function BB:Enable() BB.enabled = true; end
function BB:Disable() BB.enabled = false; end

function BB:Print( timestamp, stamp, ... )
	if (timestamp) then
		Msg( "["..os.date("%H:%M:%S").."] " );
	end
	
	if (stamp) then
		MsgC( Color( 50, 100, 255 ), "[Blue Bot] " );
	end
	
	local t = {...};
	
	if (#t == 1) then
		BB.PrintEx( Color( 255, 255, 255 ), t[1] );
	else
		for i = 1, #t, 2 do
			BB.PrintEx( t[i], t[i+1] );
		end
	end
	
	Msg( '\n' );
end

function BB:TextWindow( success, failure )
	local Panel = vgui.Create( "HFrame" );
	Panel:SetSize( 400, 150 );
	Panel:SetPos( ScrW()/2-Panel:GetWide()/2, ScrH()/2-Panel:GetTall()/2 );
	Panel:SetTitle( "" );
	Panel:SetWindowTitle( "Enter password" );
	Panel:ShowCloseButton( false );
	Panel:SetDraggable( false );
	Panel:Ease();
	Panel.CloseButton.DoClick = function( self ) Panel.Closing = true; end
	Panel.DrawBottom = false;
	Panel:MakePopup();
	
	local close = Panel.Close;
	
	Panel.Close = function( self )
		close( self );
		failure();
	end
	
	local button;
	
	local TextEntry = vgui.Create( "DTextEntry", Panel )
	TextEntry:SetPos( 10, 55 )
	TextEntry:SetSize( 380, 40 )
	TextEntry:SetFont( "HordeHUDFont22" );
	TextEntry.OnChange = function( self )
		if (string.len( TextEntry:GetText() ) < 4) then
			button:SetEnabled( false );
		else
			button:SetEnabled( true );
		end
	end
	
	button = vgui.Create( "HButton", Panel );
	button:SetText( "Cancel" );
	button:SetSize( 200, 40 );
	button:SetPos( 200, 110 );
	button:SetColor( Color( 30, 30, 30, 255 ) );
	button:SetHoverColor( Color( 90, 30, 30, 255 ) );
	button:SetDownColor( Color( 40, 30, 30, 255 ) );
	button:SetFont( "HordeHUDFont22" );
	button.DoClick = function( self ) 
		Panel.Closing = true; 
	end
	
	button = vgui.Create( "HButton", Panel );
	button:SetText( "Enter" );
	button:SetSize( 200, 40 );
	button:SetPos( 0, 110 );
	button:SetColor( Color( 30, 30, 30, 255 ) );
	button:SetHoverColor( Color( 30, 90, 30, 255 ) );
	button:SetDownColor( Color( 30, 40, 30, 255 ) );
	button:SetFont( "HordeHUDFont22" );
	button.Enabled = false;
	button.DoClick = function( self )
		Panel.Closing = true;
		success( TextEntry:GetText() ); 
	end
end

function BB:Menu()
	gui.EnableScreenClicker( true );
	
	local Panel = vgui.Create( "HFrame" );
	Panel:SetSize( 600, 400 );
	Panel:SetPos( ScrW()/2-Panel:GetWide()/2, ScrH()/2-Panel:GetTall()/2 );
	Panel:SetTitle( "" );
	Panel:SetWindowTitle( "Blue Bot" );
	Panel:ShowCloseButton( false );
	Panel:SetDraggable( false );
	Panel:SetColor( Color( 100, 100, 100 ) );
	Panel:Ease();
	
	local ScrollPanel = vgui.Create( "DScrollPanel", Panel );
	ScrollPanel:SetPos( 150, 60 );
	ScrollPanel:SetSize( 450, 270 );

	local Buttons, Panels = {}, {};
	local soffset = 0;
	local createbutton = function( name, offset )
		local button =	vgui.Create( "HButton", Panel );
		
		button:SetText( name );
		button:SetSize( 130, 40 );
		button:SetPos( 10, 60+soffset+(offset or 0) );
		button:SetColor( Color( 30, 30, 30, 255 ) );
		button:SetHoverColor( Color( 30, 30, 80, 255 ) );
		button:SetDownColor( Color( 30, 30, 40, 255 ) );
		button:SetFont( "HordeHUDFont18" );
		button:SetAlignX( false );
		
		button.DoClick = function()
			for _, but in pairs( Buttons ) do
				if (but != button) then 
					but.Selected = false;
					but:SetOriginalColor(  Color( 30, 30, 30, 255 ) );
					but:SetWantedColor(  Color( 30, 30, 30, 255 ) );
					but:SetHoverColor( Color( 30, 30, 80, 255 ) );
					but:SetDownColor( Color( 30, 30, 40, 255 ) );
				end
			end
			
			
			for index, pan in pairs( Panels ) do
				if (index != name) then
					pan:Ease();
				end
			end
			
			if (Panels[name].Easing) then
				Panels[name]:StopEasing();
			end
			
			ScrollPanel.VBar:SetScroll( 0 );
			Panels[name]:SetVisible( true );
			Panels[name]:MoveToBack();
			
			button.Selected = true;
			button:SetWantedColor( Color( 30, 60, 120, 255 ) );
			button:SetOriginalColor( Color( 30, 60, 100, 255 ) );
			button:SetHoverColor( Color( 30, 60, 120, 255 ) );
			button:SetDownColor( Color( 70, 60, 50, 255 ) );
		end
		
		soffset = soffset + 50 + (offset or 0);
		
		return button;
	end
	
	local createpanel = function( color )
		local panel = vgui.Create( "HPanel", ScrollPanel );
		panel:SetPos( 0, 0 );
		panel:SetSize( 435, 270 );
		panel:MoveToBack();
		panel.Paint = function( self, w, h )
			surface.SetDrawColor( color );
			surface.DrawRect( 0, 0, w, h );
		end
		
		return panel;
	end
	
	Panel:Notification( "Blue bot v1.0" );
	Panel:Notification( "Swag" );
	
	Panels = {["Main"]=createpanel( Color( 255, 255, 255 ) ), ["Aimbot"]=createpanel( Color( 255, 0, 0 ) ), ["ESP/Chams"]=createpanel( Color( 0, 255, 0 ) ), ["Misc"]=createpanel( Color( 0, 0, 255 ) ), ["File manager"]=createpanel( Color( 255, 255, 0 ) ), ["Logs"]=createpanel( Color( 0, 255, 255 ) )};
	Buttons = {["Aimbot"]=createbutton( "Aimbot" ), ["ESP/Chams"]=createbutton( "ESP/Chams" ), ["Misc"]=createbutton( "Misc" ), ["File manager"]=createbutton( "File manager", 30 ), ["Logs"]=createbutton( "Logs" )};
	
	local label = vgui.Create( "DLabel", Panels.Main );
	label:SetPos( 10, 10 );
	label:SetColor( Color( 50, 50, 50 ) );
	label:SetText( "Blue Bot - Made by: Blue Kirby" );
	label:SetFont( "HordeHUDFont18" );
	label:SizeToContents();
	
	local Tree = vgui.Create( "DTree", Panels["File manager"] );
	Tree:SetPos( 0, 0 );
	Tree:SetPadding( 5 );
	Tree:SetSize( 435, 270 );
	
	local refreshlist = function() end
	local createmenu = function() end
	
	local RefreshButton = vgui.Create( "DImageButton", Panels["File manager"] )
	RefreshButton:SetPos( 400, 5 );
	RefreshButton:SetImage( "gui/silkicons/arrow_refresh.vtf" );
	RefreshButton:SizeToContents();
	RefreshButton.DoClick = function()
		refreshlist();
		RefreshButton:MoveToFront();
	end
	
	local recursion = function() end
	
	local i = 1;
	
	recursion = function( dir, parent )
		local files, directories = file.Find( dir.."*.*", "GAME" );
		files = files or {};
		directories = directories or {};
		
		for k, v in pairs( directories ) do
			if (v != "/" and (dir != "" or (v == "data" or v == "lua" or v == "addons"))) then
				local folder = parent:AddNode( v );
				
				recursion( dir..v.."/", folder );
			end
		end
		
		for k, v in pairs( files ) do
			if ( string.EndsWith( v, ".txt" ) or string.EndsWith( v, ".lua" ) or string.EndsWith( v, ".bb" ) or !string.find( v, "." ) ) then
				local f = parent:AddNode( v );
				
				f.Icon:SetImage( "gui/silkicons/page" );
				
				f.Label.DoDoubleClick = function()
					RunString( file.Read( dir..v, "GAME" ) );
				end
				
				f.DoRightClick = function()
					local encrypted = (string.sub( file.Read( dir..v, "GAME" ) or "", 1, 8 ) == "ENCBB100");
					local Options = DermaMenu();
					local createhiddenpanel = function()
						local panel = vgui.Create( "DPanel" );
						local x, y = Panel:GetPos();
						
						panel:SetSize( Panel:GetWide(), Panel:GetTall() );
						panel:SetPos( x, y );
						panel.Paint = function( self, w, h )
							
						end
						
						return panel;
					end
					
					if (encrypted == false) then
						Options:AddOption( "Run", function() 
							RunString( file.Read( dir..v, "GAME" ) );
						end );
					else
						Options:AddOption( "Run decrypted", function()
							local panel = createhiddenpanel();
							
							BB:TextWindow( function( password ) 
								local contents = BB:Decrypt( file.Read( dir..v, "GAME" ) or "NOPE", password );
							
								if (contents) then
									RunString( contents );
								end
							end,
								
							function() panel:SetVisible( false ); end );
						end );
					end
					
					if (string.sub( dir, 0, 4 ) == "data" and encrypted == false) then
						Options:AddOption( "Encrypt", function()
							local panel = createhiddenpanel();
							
							BB:TextWindow( function( password )
								local contents = file.Read( dir..v, "GAME" );
								file.Write( string.sub( dir, 6 )..v, BB:Encrypt( contents, password ) );
							end,
							
							function() panel:SetVisible( false ); end );
						end );
					elseif (string.sub( dir, 0, 4 ) == "data" and string.sub( file.Read( dir..v, "GAME" ) or "", 1, 8 ) == "ENCBB100" ) then
						Options:AddOption( "Decrypt", function()
							local panel = createhiddenpanel();
							
							BB:TextWindow( function( password )
								local contents = BB:Decrypt( file.Read( dir..v, "GAME" ) or "NOPE", password );
								
								if (contents) then
									file.Write( string.sub( dir, 6 )..v, contents );
								end
							end,
							
							function() panel:SetVisible( false ); end );
						end );
					end
					
					Options:Open()
				end
			end
		end
	end
	
	recursion( "", Tree );
	
	refreshlist = function() 
		Tree.RootNode:Remove();
		Tree = vgui.Create( "DTree", Panels["File manager"] );
		Tree:SetPos( 0, 0 );
		Tree:SetPadding( 5 );
		Tree:SetSize( 435, 270 );
		Tree.OnMouseReleased = createmenu;
		
		recursion( "", Tree );
	end;
	
	createmenu = function( self, mouse_in )
		if (mouse_in != MOUSE_RIGHT) then return; end
		
		local Options = DermaMenu();
		Options:AddOption( "Refresh", refreshlist );
		Options:Open()
	end
	
	Tree.OnMouseReleased = createmenu;
end

function BB:Load() 
	BB:Print( true, true, Color( 50, 200, 70 ), "loaded\n" );
	
	for name, func in pairs( BB.Hooks ) do
		hook.Add( name, "BB."..name, func );
	end
end

function BB:AddToChar( char, add )
	local result = char + add;
	
	while result > 255 do
		result = result - 255;
	end
	
	return result;
end

function BB:SubFromChar( char, sub )
	local result = char - sub;
	
	while result < 0 do
		result = result + 255;
	end
	
	return result;
end

function BB:Encrypt( str, password )
	if (!password or string.len( password ) < 4) then return str; end
	
	local str = str..password;
	local result = "";
	local index = 1;
	math.randomseed( (string.len( password ) * 377) + string.len( str ) );
	
	for i=1, string.len( str ) do
		result = result..string.char( BB:AddToChar( string.byte( string.sub( str, i, i ) ), string.byte( string.sub( password, index, index ) ) * string.len( password ) * index * math.random( 1, 10000 ) ) );
		
		index = index + 1;
		
		if (index > string.len( password )) then
			 index = 1;
		end
	end
	
	return "ENCBB100"..result;
end

function BB:Decrypt( str, password )
	if (string.sub( str, 1, 8 ) != "ENCBB100" or !password or string.len( password ) < 4) then return; end
	
	local result = "";
	local index = 1;
	math.randomseed( (string.len( password ) * 377) + (string.len( str ) - 8) );
	
	for i=9, string.len( str ) do
		result = result..string.char( BB:SubFromChar( string.byte( string.sub( str, i, i ) ), string.byte( string.sub( password, index, index ) ) * string.len( password ) * index * math.random( 1, 10000 ) ) );
		
		index = index + 1;
		
		if (index > string.len( password )) then
			 index = 1;
		end
	end
	
	if (string.EndsWith( result, password ) != true) then return; end
	
	return string.sub( result, 1, string.len( result ) - string.len( password ) );
end

//BB:Load();
BB:Menu();