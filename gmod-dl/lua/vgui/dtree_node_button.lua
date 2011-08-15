/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DTree
	
	
	
*/
	
local PANEL = {}

AccessorFunc( PANEL, "m_bSelected",				"Selected" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetTextInset( 32 )
	self:SetContentAlignment( 4 )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
		
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	derma.SkinHook( "Paint", "TreeNodeButton", self )
	
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
	derma.SkinHook( "Scheme", "TreeNodeButton", self )

end




derma.DefineControl( "DTree_Node_Button", "Tree Node Button", PANEL, "DButton" )