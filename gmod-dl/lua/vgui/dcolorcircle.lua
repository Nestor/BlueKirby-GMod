/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DColorCircle
	
*/

local PANEL = {}

AccessorFunc( PANEL, "m_Hue", 				"Hue" )
AccessorFunc( PANEL, "m_Saturation", 		"Saturation" )
AccessorFunc( PANEL, "m_RGB", 				"RGB" )

Derma_Install_Convar_Functions( PANEL )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.BGImage = vgui.Create( "DImage", self )
	self.BGImage:SetImage( "vgui/hsv" )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.BGImage:StretchToParent(0,0,0,0)
	self.BGImage:SetZPos( -1 )

	DSlider.PerformLayout( self )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:TranslateValues( x, y )

	x = x - 0.5
	y = y - 0.5
	
	local angle = math.atan2( x, y )
	
	local length = math.sqrt( x*x + y*y )
	length = math.Clamp( length, 0, 0.5 )
	
	x = 0.5 + math.sin( angle ) * length
	y = 0.5 + math.cos( angle ) * length
	
	self:SetHue( math.Rad2Deg( angle ) + 270 )
	self:SetSaturation( length * 2 )
	
	self:SetRGB( HSVToColor( self:GetHue(), self:GetSaturation(), 1 ) )
	
	return x, y

end

/*---------------------------------------------------------
	Think
---------------------------------------------------------*/
function PANEL:Think()

	self:ConVarNumberThink()

end

/*---------------------------------------------------------
   Name: SetValue (For ConVar)
---------------------------------------------------------*/
function PANEL:SetValue( iNumValue )

	self:SetSelected( iNumValue )

end

/*---------------------------------------------------------
   Name: GetValue
---------------------------------------------------------*/
function PANEL:GetValue()

	return self:GetSelectedNumber()

end

/*---------------------------------------------------------
   Name: GenerateExample
---------------------------------------------------------*/
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetSize( 300, 300 )
		
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

vgui.Register( "DColorCircle", PANEL, "DSlider" )