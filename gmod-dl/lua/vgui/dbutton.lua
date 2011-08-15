/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DButton
	
	Default Button

*/

PANEL = {}

AccessorFunc( PANEL, "m_bBorder", 			"DrawBorder", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bBackground", 		"DrawBackground", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_bDisabled", 		"Disabled", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSelected", 		"Selected", 		FORCE_BOOL )


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self:SetContentAlignment( 5 )
	
	//
	// These are Lua side commands
	// Defined above using AccessorFunc
	//
	self:SetDrawBorder( true )
	self:SetDrawBackground( true )
	
	//
	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

end

/*---------------------------------------------------------
	IsDown
---------------------------------------------------------*/
function PANEL:IsDown()

	return self.Depressed

end

/*---------------------------------------------------------
	OnMousePressed
---------------------------------------------------------*/
function PANEL:OnMousePressed( mousecode )

	if ( self:GetDisabled() ) then return end

	self:MouseCapture( true )
	self.Depressed = true

end

/*---------------------------------------------------------
	OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnMouseReleased( mousecode )

	if ( self:GetDisabled() ) then return end
	
	self:MouseCapture( false )
	
	if ( !self.Depressed ) then return end
	
	self.Depressed = nil
	
	if ( !self.Hovered ) then return end
	

	if ( mousecode == MOUSE_RIGHT ) then
		PCallError( self.DoRightClick, self )
	end
	
	if ( mousecode == MOUSE_LEFT ) then
		PCallError( self.DoClick, self )
	end

end


/*---------------------------------------------------------
	DoRightClick
---------------------------------------------------------*/
function PANEL:DoRightClick()

end

/*---------------------------------------------------------
	DoClick
---------------------------------------------------------*/
function PANEL:DoClick()

end


/*---------------------------------------------------------
	SetImage
---------------------------------------------------------*/
function PANEL:SetImage( img )

	if ( !img ) then
	
		if ( IsValid( self.m_Image ) ) then
			self.m_Image:Remove()
		end
	
		return
	end

	if ( !IsValid( self.m_Image ) ) then
		self.m_Image = vgui.Create( "DImage", self )
	end
	
	self.m_Image:SetImage( img )
	self.m_Image:SizeToContents()

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	derma.SkinHook( "Paint", "Button", self )
	
	// No need to draw the border in another function when 
	// we can draw it here just fine..
	derma.SkinHook( "PaintOver", "Button", self )
	
	//
	// Draw the button text
	//
	return false

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

	derma.SkinHook( "Scheme", "Button", self )
	
	//
	// If we have an image we have to place the image on the left
	// and make the text align to the left, then set the inset
	// so the text will be to the right of the icon.
	//
	if ( IsValid( self.m_Image ) ) then
	
		self.m_Image:Center()
		self.m_Image:AlignLeft( 4 )
		
		self:SetTextInset( self.m_Image:GetWide() + 8, 0 )
		self:SetContentAlignment( 4 )
		
	end

end

/*---------------------------------------------------------
	DoClick
---------------------------------------------------------*/
function PANEL:SetDisabled( bDisabled )

	self.m_bDisabled = bDisabled	
	self:InvalidateLayout()

end

/*---------------------------------------------------------
   Name: SetConsoleCommand
---------------------------------------------------------*/
function PANEL:SetConsoleCommand( strName, strArgs )

	self.DoClick = function( self, val ) 
						RunConsoleCommand( strName, strArgs ) 
				   end

end

/*---------------------------------------------------------
   Name: GenerateExample
---------------------------------------------------------*/
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetText( "Example Button" )
		ctrl:SetWide( 200 )
	
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end


local PANEL = derma.DefineControl( "DButton", "A standard Button", PANEL, "DLabel" )

PANEL = table.Copy( PANEL )

// No example here!
PANEL.GenerateExample = nil

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetTextInset( 4 )

end

/*---------------------------------------------------------
   Name: SetActionFunction
---------------------------------------------------------*/
function PANEL:SetActionFunction( func )

	self.DoClick = function( self, val ) func( self, "Command", 0, 0 ) end

end

derma.DefineControl( "Button", "Backwards Compatibility", PANEL, "DLabel" )