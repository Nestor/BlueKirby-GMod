/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DNumberWang

*/

local PANEL = {}

AccessorFunc( PANEL, "m_pWang", 		"Wang" )
AccessorFunc( PANEL, "m_bTop", 			"Top" )

Derma_Hook( PANEL, "Paint", "Paint", "NumberWangIndicator" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "NumberWangIndicator" )
Derma_Hook( PANEL, "PerformLayout", "Layout", "NumberWangIndicator" )

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:Init()

	self:MakePopup()
	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( false )
	
	// Automatically remove this panel when menus are to be closed
	RegisterDermaMenuForClose( self )

end

derma.DefineControl( "DNumberWangIndicator", "", PANEL, "Panel" )

local PANEL = {}

AccessorFunc( PANEL, "m_numMin", 		"Min" )
AccessorFunc( PANEL, "m_numMax", 		"Max" )
AccessorFunc( PANEL, "m_iDecimals", 	"Decimals" )		// The number of decimal places in the output
AccessorFunc( PANEL, "m_fFloatValue", 	"FloatValue" )

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:Init()

	self:SetDecimals( 2 )
	self:SetTall( 20 )
	self:SetMinMax( 0, 100 )
	
	self.TextEntry = vgui.Create( "DTextEntry", self )
	self.TextEntry:SetUpdateOnType( true )
	self.TextEntry:SetNumeric( true )
	
	// Override the SetValue function so that decimals are formatted properly
	self.TextEntry.SetValue = function ( entry, value ) self:SetValue( value ) end
	
	self.Wanger = vgui.Create( "DSysButton", self )
	self.Wanger:SetType( "updown" )
	self.Wanger.OnMousePressed = function( button, mcode ) self:StartWang() end
	
	self:SetValue( 0 )
	

end

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:SetDecimals( num )

	self.m_iDecimals = num
	
	// Make sure we have a TextEntry control before
	// updating the value..
	if ( self.TextEntry ) then
		self:SetValue( self:GetValue() )
	end

end


/*---------------------------------------------------------
	OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnMouseReleased( mousecode )

	if ( self.Dragging ) then
		self:EndWang()
	return end

end

/*---------------------------------------------------------
	SetMinMax
---------------------------------------------------------*/
function PANEL:SetMinMax( min, max )

	self:SetMin( min )
	self:SetMax( max )

end

/*---------------------------------------------------------
	SetMin
---------------------------------------------------------*/
function PANEL:SetMin( min )

	self.m_numMin = tonumber( min )

end

/*---------------------------------------------------------
	SetMax
---------------------------------------------------------*/
function PANEL:SetMax( max )

	self.m_numMax = tonumber( max )

end

/*---------------------------------------------------------
	GetFloatValue
---------------------------------------------------------*/
function PANEL:GetFloatValue( max )

	if ( !self.m_fFloatValue ) then m_fFloatValue = 0 end

	return tonumber( self.m_fFloatValue ) or 0

end

/*---------------------------------------------------------
   Name: SetValue
---------------------------------------------------------*/
function PANEL:SetValue( val )

	if ( val == nil ) then return end
	
	local OldValue = val
	val = tonumber( val )
	val = val or 0
	
	if ( self.m_iDecimals == 0 ) then
	
		val = Format( "%i", val )
	
	elseif ( val != 0 ) then
	
		val = Format( "%."..self.m_iDecimals.."f", val )
			
		// Trim trailing 0's and .'s 0 this gets rid of .00 etc
		val = string.TrimRight( val, "0" )		
		val = string.TrimRight( val, "." )
		
	end
	
	//
	// Don't change the value while we're typing into it!
	// It causes confusion!
	//
	if ( !self.TextEntry:HasFocus() ) then
		self.TextEntry:SetText( val )
		self.TextEntry:ConVarChanged( val )
	end
	
	self:OnValueChanged( val )

end

/*---------------------------------------------------------
   Name: GetValue
---------------------------------------------------------*/
function PANEL:GetValue()

	return tonumber( self.TextEntry:GetValue() ) or 0

end

/*---------------------------------------------------------
   Name: SetConVar
---------------------------------------------------------*/
function PANEL:SetConVar( cvar )

	self.TextEntry:SetConVar( cvar )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.TextEntry:SetSize( self:GetSize() )

	self.Wanger:SetPos( self:GetWide() - 12, 0 )
	self.Wanger:SetSize( 12, self:GetTall() )
	self.Wanger:SetZPos( 1 )

end

/*---------------------------------------------------------
	SizeToContents
---------------------------------------------------------*/
function PANEL:SizeToContents()

	// Size based on the max number and max amount of decimals
	
	local chars = 0
	
	local min = math.Round( self:GetMin(), self:GetDecimals() )
	local max = math.Round( self:GetMax(), self:GetDecimals() )
	
	local minchars = string.len( ""..min.."" )
	local maxchars = string.len( ""..max.."" )
	
	chars = chars + math.max( minchars, maxchars )
	
	if ( self:GetDecimals() && self:GetDecimals() > 0 ) then
	
		chars = chars + 1 // .
		chars = chars + self:GetDecimals()
	
	end
	
	self:InvalidateLayout( true )
	self:SetWide( chars * 6 + self.Wanger:GetWide() + 5 + 5 )
	self:InvalidateLayout()

end


/*---------------------------------------------------------
   Name: OnCursorMoved
---------------------------------------------------------*/
function PANEL:OnCursorMoved( x, y )

	if ( !self.Dragging ) then return end

	local fVal = self:GetFloatValue()
	local y = gui.MouseY()
	local Diff = y - self.HoldPos
	
	// This is going to need some tweaking based in the range of 
	// numbers we're dealing with..		
	local Sensitivity = math.abs(Diff) * 0.025
	Sensitivity = Sensitivity / ( self:GetDecimals() + 1 )
	
	fVal = math.Clamp( fVal + Diff * Sensitivity, self.m_numMin, self.m_numMax )
	
	self:SetFloatValue( fVal )
	
	local x, y = self.Wanger:LocalToScreen( self.Wanger:GetWide() * 0.5, 0 )
	
	input.SetCursorPos( x, self.HoldPos )
	
	self:SetValue( fVal )
	
	if ( ValidPanel( self.IndicatorT ) ) then self.IndicatorT:InvalidateLayout() end
	if ( ValidPanel( self.IndicatorB ) ) then self.IndicatorB:InvalidateLayout() end
	
end

/*---------------------------------------------------------
   Name: StartWang
---------------------------------------------------------*/
function PANEL:StartWang()

	// The text area needs to lose key focus or we won't be able to properly set/get the value
	self.TextEntry:FocusNext()

	self.Wanger:SetCursor( "blank" )

	self:MouseCapture( true )
	self.Dragging = true
	
	self.HoldPos = gui.MouseY()
	
	self:SetFloatValue( tonumber( self.TextEntry:GetValue() ) )	
	
	self.IndicatorB = vgui.Create ( "DNumberWangIndicator" )
	self.IndicatorB:SetWang( self )
	self.IndicatorB:SetTop( false )
	self.IndicatorB:SetDrawOnTop( true )
	
	self.IndicatorT = vgui.Create ( "DNumberWangIndicator" )
	self.IndicatorT:SetWang( self )
	self.IndicatorT:SetTop( true )
	self.IndicatorT:SetDrawOnTop( true )
	
end


/*---------------------------------------------------------
   Name: EndWang
---------------------------------------------------------*/
function PANEL:EndWang()

	self:MouseCapture( false )
	self.Dragging = false
	
	self.HoldPos = nil
	
	self.Wanger:SetCursor( "" )
	
	if ( ValidPanel( self.IndicatorT ) ) then self.IndicatorT:Remove() end
	if ( ValidPanel( self.IndicatorB ) ) then self.IndicatorB:Remove() end

end


/*---------------------------------------------------------
   Name: GetFraction
---------------------------------------------------------*/
function PANEL:GetFraction( val )

	local Value = val or self:GetValue()

	local Fraction = ( Value - self.m_numMin ) / (self.m_numMax - self.m_numMin)
	return Fraction

end

/*---------------------------------------------------------
   Name: SetFraction
---------------------------------------------------------*/
function PANEL:SetFraction( val )

	local Fraction = self.m_numMin + ( (self.m_numMax - self.m_numMin) * val )
	self:SetValue( Fraction )

end


/*---------------------------------------------------------
   Name: OnValueChanged
---------------------------------------------------------*/
function PANEL:OnValueChanged( val )

end

/*---------------------------------------------------------
   Name: GetTextArea
---------------------------------------------------------*/
function PANEL:GetTextArea()

	return self.TextEntry

end

derma.DefineControl( "DNumberWang", "Menu Option Line", PANEL, "Panel" )
