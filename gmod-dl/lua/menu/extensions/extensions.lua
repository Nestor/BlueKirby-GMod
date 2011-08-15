//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2010
//										 
//=============================================================================//


local Extensions = nil

local pnlContent 	= vgui.RegisterFile( "content.lua" )
local pnlAddons 	= vgui.RegisterFile( "addons.lua" )

local PANEL = {}

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	self:SetSizable( true );
	
	self:SetDeleteOnClose( false )
	self:SetTitle( Localize( "Extensions", "Extensions" ) )
	
	self.PropertySheet = vgui.Create( "DColumnSheet", self )
	
	self.PropertySheet:AddSheet( Localize( "Addons" ), vgui.CreateFromTable( pnlAddons ), "gui/silkicons/box" )
	self.PropertySheet:AddSheet( Localize( "Game Content" ), vgui.CreateFromTable( pnlContent ), "gui/silkicons/box" )
	self.PropertySheet:Dock( FILL )
	
	self:SetMinWidth( 770 );
	self:SetMinHeight( 580 );
	
	self:SetSize( 770, 580 );
	
end

local tSettingsPanel = vgui.RegisterTable( PANEL, "DFrame" )


local function command_function()

	if ( !IsValid( Extensions ) ) then
		Extensions = vgui.CreateFromTable( tSettingsPanel )
	end

	Extensions:SetVisible( true )
	Extensions:Center()
	Extensions:MakePopup()

end

concommand.Add( "menu_extensions", command_function )

// development
//RunConsoleCommand( "menu_extensions" )
