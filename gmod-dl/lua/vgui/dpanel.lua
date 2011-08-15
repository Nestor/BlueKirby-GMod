/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DSlider

*/
local PANEL = {}

AccessorFunc( PANEL, "m_bPaintBackground", 		"PaintBackground" )
AccessorFunc( PANEL, "m_bDisabled", 			"Disabled" )
AccessorFunc( PANEL, "m_bgColor", 		"BackgroundColor" )

Derma_Hook( PANEL, "Paint", "Paint", "Panel" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "Panel" )
Derma_Hook( PANEL, "PerformLayout", "Layout", "Panel" )

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:Init()

	self:SetPaintBackground( true )
	
	// This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:SetDisabled( bDisabled )

	self.m_bDisabled = bDisabled
	
	if ( bDisabled ) then
		self:SetAlpha( 75 )
		self:SetMouseInputEnabled( false )
	else
		self:SetAlpha( 255 )
		self:SetMouseInputEnabled( true )
	end

end


derma.DefineControl( "DPanel", "", PANEL, "Panel" )