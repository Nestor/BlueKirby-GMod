/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DForm

*/
local PANEL = {}

AccessorFunc( PANEL, "m_bSizeToContents", 		"AutoSize", 		FORCE_BOOL)
AccessorFunc( PANEL, "m_bBackground", 			"DrawBackground", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_iSpacing", 				"Spacing" )
AccessorFunc( PANEL, "m_Padding", 				"Padding" )

Derma_Hook( PANEL, "Paint", "Paint", "Form" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "Form" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Items = {}
	
	self:SetSpacing( 4 )
	self:SetPadding( 10 )
	
	self:SetDrawBackground( true )
	
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	
	self.Label = vgui.Create( "DLabel", self )

end


/*---------------------------------------------------------
   Name: SetName
---------------------------------------------------------*/
function PANEL:SetName( name )

	self.Label:SetText( name )

end

/*---------------------------------------------------------
   Name: Clear
---------------------------------------------------------*/
function PANEL:Clear()

	for k, v in pairs( self.Items ) do
		if ( v.Left ) then v.Left:Remove() end
		if ( v.Right ) then v.Right:Remove() end
	end

	self.Items = {}
	
end


/*---------------------------------------------------------
   Name: AddItem
---------------------------------------------------------*/
function PANEL:AddItem( left, right )

	table.insert( self.Items, { Left = left, Right = right } )
	
	if ( left ) then left:SetParent( self ) end
	if ( right ) then right:SetParent( self ) end
	
	self:InvalidateLayout()

end


/*---------------------------------------------------------
   Name: TextEntry
---------------------------------------------------------*/
function PANEL:TextEntry( strLabel, strConVar )

	local left = vgui.Create( "DLabel", self )
	left:SetText( strLabel )
	
	local right = vgui.Create( "DTextEntry", self )
	right:SetConVar( strConVar )
	right.Stretch = true
	
	self:AddItem( left, right )
	
	return right, left

end


/*---------------------------------------------------------
   Name: MultiChoice
---------------------------------------------------------*/
function PANEL:MultiChoice( strLabel, strConVar )

	local left = vgui.Create( "DLabel", self )
	left:SetText( strLabel )
	
	local right = vgui.Create( "DMultiChoice", self )
	right:SetConVar( strConVar )
	right.Stretch = true
	
	self:AddItem( left, right )
	
	return right, left

end

/*---------------------------------------------------------
   Name: MultiChoice
---------------------------------------------------------*/
function PANEL:NumberWang( strLabel, strConVar, numMin, numMax, numDecimals )

	local left = vgui.Create( "DLabel", self )
	left:SetText( strLabel )
	
	local right = vgui.Create( "DNumberWang", self )
	right:SetMinMax( numMin, numMax )
	
	if ( numDecimals != nil ) then right:SetDecimals( numDecimals ) end
	
	right:SetConVar( strConVar )
	right:SizeToContents()
	
	self:AddItem( left, right )
	
	return right, left

end

/*---------------------------------------------------------
   Name: MultiChoice
---------------------------------------------------------*/
function PANEL:NumSlider( strLabel, strConVar, numMin, numMax, numDecimals )

	local left = vgui.Create( "DNumSlider", self )
	left:SetText( strLabel )
	left:SetMinMax( numMin, numMax )
	
	if ( numDecimals != nil ) then left:SetDecimals( numDecimals ) end
	
	left:SetConVar( strConVar )
	left:SizeToContents()
	
	self:AddItem( left, nil )
	
	return left

end


/*---------------------------------------------------------
   Name: MultiChoice
---------------------------------------------------------*/
function PANEL:CheckBox( strLabel, strConVar )

	local left = vgui.Create( "DCheckBoxLabel", self )
	left:SetText( strLabel )
	left:SetConVar( strConVar )
	left:SetIndent( 5 )

	self:AddItem( left, nil )
	
	return left

end

/*---------------------------------------------------------
   Name: Help
---------------------------------------------------------*/
function PANEL:Help( strHelp )

	local left = vgui.Create( "DLabel", self )

	left:SetWrap( true )
	left:SetFont( "DefaultSmall" )
	left:SetTextInset( 8 )
	left:SetText( strHelp )
	left:SetContentAlignment( 7 )
	left:SetAutoStretchVertical( true )

	self:AddItem( left, nil )
	
	return left

end

/*---------------------------------------------------------
   Name: Button
		Note: If you're running a console command like "maxplayers 10" you
		need to add the "10" to the arguments, like so
		Button( "LabelName", "maxplayers", "10" )
---------------------------------------------------------*/
function PANEL:Button( strName, strConCommand, ... /* console command args!! */ )

	local left = vgui.Create( "DButton", self )

	if ( strConCommand ) then
		left:SetConsoleCommand( strConCommand, ... )
	end
		
	left:SetText( strName )
	self:AddItem( left, nil )
	
	return left

end

/*---------------------------------------------------------
   Name: PanelSelect
---------------------------------------------------------*/
function PANEL:PanelSelect()

	local left = vgui.Create( "DPanelSelect", self )
	self:AddItem( left, nil )
	return left

end

/*---------------------------------------------------------
   Name: ComboBox
---------------------------------------------------------*/
function PANEL:ComboBox( strLabel )

	if ( strLabel ) then
		local left = vgui.Create( "DLabel", self )
		left:SetText( strLabel )
		self:AddItem( left )
	end
	
	local right = vgui.Create( "DComboBox", self )
	//right:SetConVar( strConVar )
	right.Stretch = true
	
	self:AddItem( right )
	
	return right, left

end

/*---------------------------------------------------------
   Name: Rebuild
---------------------------------------------------------*/
function PANEL:Rebuild()

end

/*---------------------------------------------------------
   Name: Rebuild
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.Label:SetPos( 5, 0 )
	self.Label:SizeToContents()

	local y = self:GetPadding() + 15
	local Col2 = self:GetWide() * 0.3
	
	for k, v in pairs( self.Items ) do
	
		if ( v.Right ) then
		
			v.Left:SizeToContents()
			Col2 = math.max( Col2, v.Left:GetWide() + self:GetPadding() * 2 )
		
		end
	
	end

	for k, v in pairs( self.Items ) do
	
		if ( v.Right ) then
		
			v.Left:SetPos( self:GetPadding(), y )
			v.Right:SetPos( Col2, y )
	
			if ( v.Right.Stretch ) then
			
				v.Right:SetWide( self:GetWide() - Col2 - self:GetPadding() )
				v.Right:InvalidateLayout( true )
			
			end
			
			y = y + math.max( v.Left:GetTall(), v.Right:GetTall() ) + self.m_iSpacing
		
		else

			v.Left:SetPos( self:GetPadding(), y )
			v.Left:SetWide( self:GetWide() - self:GetPadding() * 2 )
			v.Left:InvalidateLayout( true )
			
			y = y + v.Left:GetTall() + self.m_iSpacing
		
		end
	
	end
	
	self:SetTall( y + self:GetPadding() )
	
	self:TellParentAboutSizeChanges()

end

derma.DefineControl( "DForm", "", PANEL, "Panel" )
