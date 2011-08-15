/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DMenuOption

*/

PANEL = {}


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self:SetContentAlignment( 4 )
	self:SetTextInset( 20 )			// Room for icon on left

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetSubMenu( menu )

	self.SubMenu = menu	
	
	if ( !self.SubMenuArrow ) then
	
		self.SubMenuArrow = vgui.Create( "DSysButton", self )
		self.SubMenuArrow:SetType( "right" )
		self.SubMenuArrow:SetDrawBorder( false )
		self.SubMenuArrow:SetDrawBackground( false )
		self.SubMenuArrow:SetTextColor( color_black )
	
	end
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OnCursorEntered()

	if ( IsValid( self.ParentMenu ) ) then
		self.ParentMenu:OpenSubMenu( self, self.SubMenu )	
		return
	end
	
	self.GetParent():OpenSubMenu( self, self.SubMenu )	
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:OnCursorExited()
	
end



/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	derma.SkinHook( "Paint", "MenuOption", self )
	
	//
	// Draw the button text
	//
	return false

end

/*---------------------------------------------------------
	OnMousePressed
---------------------------------------------------------*/
function PANEL:OnMousePressed( mousecode )

	self.m_MenuClicking = true

	DButton.OnMousePressed( self, mousecode )

end

/*---------------------------------------------------------
	OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnMouseReleased( mousecode )

	DButton.OnMouseReleased( self, mousecode )

	if ( self.m_MenuClicking ) then
		
		self.m_MenuClicking = false
		CloseDermaMenus()
		
	end

end


/*---------------------------------------------------------
   Name: ApplySchemeSettings
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

	derma.SkinHook( "Scheme", "MenuOption", self )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	derma.SkinHook( "Layout", "MenuOption", self )
		
end

derma.DefineControl( "DMenuOption", "Menu Option Line", PANEL, "DButton" )