/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DLabelURL
*/

PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "Label" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "Label" )
Derma_Hook( PANEL, "PerformLayout", "Layout", "Label" )

AccessorFunc( PANEL, "m_colText", 			"TextColor" )
AccessorFunc( PANEL, "m_colTextHovered", 	"TextColorHovered" )
AccessorFunc( PANEL, "m_bAutoStretchVertical", 	"AutoStretchVertical" )

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetTextColor( Color( 0, 0, 255 ) )
	
	// Nicer default height
	self:SetTall( 20 )
	
	// This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
end

/*---------------------------------------------------------
	SetTextColor
---------------------------------------------------------*/
function PANEL:SetTextColor( col )

	self.m_colText = col
	DLabel.ApplySchemeSettings( self )

end

PANEL.SetColor = PANEL.SetTextColor

/*---------------------------------------------------------
	SetColor
---------------------------------------------------------*/
function PANEL:GetColor()

	return self.m_colText

end


/*---------------------------------------------------------
	Exited
---------------------------------------------------------*/
function PANEL:OnCursorEntered()
	
	if (!self.m_colTextHovered) then return end
	
	DLabel.ApplySchemeSettings( self )
	
end

/*---------------------------------------------------------
	Entered
---------------------------------------------------------*/
function PANEL:OnCursorExited()

	if (!self.m_colTextHovered) then return end

	DLabel.ApplySchemeSettings( self )
	
end

derma.DefineControl( "DLabelURL", "A Label", PANEL, "URLLabel" )
