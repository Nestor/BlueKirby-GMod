/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DTinyButton
	
	Tiny Button

*/

PANEL = {}


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	derma.SkinHook( "Paint", "TinyButton", self )
	
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
	derma.SkinHook( "Scheme", "TinyButton", self )

end

derma.DefineControl( "DTinyButton", "A standard Button", PANEL, "DButton" )
