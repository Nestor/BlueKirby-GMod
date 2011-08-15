/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DTree
	
	
	
*/
	
local PANEL = {}

AccessorFunc( PANEL, "m_pRoot", 				"Root" )

AccessorFunc( PANEL, "m_pParentNode", 			"ParentNode" )
AccessorFunc( PANEL, "m_cTextColor", 			"TextColor" )

AccessorFunc( PANEL, "m_strFolder", 			"Folder" )
AccessorFunc( PANEL, "m_strWildCard", 			"WildCard" )
AccessorFunc( PANEL, "m_bShowFiles", 			"ShowFiles", 			FORCE_BOOL )

AccessorFunc( PANEL, "m_bDirty", 				"Dirty", 				FORCE_BOOL )
AccessorFunc( PANEL, "m_bNeedsChildSearch",		"NeedsChildSearch", 	FORCE_BOOL )

AccessorFunc( PANEL, "m_bForceShowExpander",	"ForceShowExpander", 	FORCE_BOOL )



/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Label = vgui.Create( "DTree_Node_Button", self )
	self.Label.DoClick = function() self:InternalDoClick() end
	self.Label.DoRightClick = function() self:InternalDoRightClick() end

	self.Expander = vgui.Create( "DTinyButton", self )
	self.Expander:SetText( "+" )
	self.Expander.DoClick = function() self:SetExpanded( !self.m_bExpanded ) end
	self.Expander:SetVisible( false )
	
	self.Icon = vgui.Create( "DImage", self )
	self.Icon:SetImage( "vgui/spawnmenu/folder" )
	self.Icon:SizeToContents()
	
	self:SetTextColor( Color( 0, 0, 0, 255 ) )
	
	self.animSlide = Derma_Anim( "Anim", self, self.AnimSlide )

end

/*---------------------------------------------------------
   Name: DoClick
---------------------------------------------------------*/
function PANEL:InternalDoClick()

	self:GetRoot():SetSelectedItem( self )

	if ( self:DoClick() ) then return end
	if ( self:GetRoot():DoClick( self ) ) then return end
	
	self:SetExpanded( !self.m_bExpanded )
	
end

/*---------------------------------------------------------
   Name: InternalDoRightClick
---------------------------------------------------------*/
function PANEL:InternalDoRightClick()

	if ( self:DoRightClick() ) then return end
	if ( self:GetRoot():DoRightClick( self ) ) then return end

end

/*---------------------------------------------------------
   Name: DoClick
---------------------------------------------------------*/
function PANEL:DoClick()
	return false
end

/*---------------------------------------------------------
   Name: DoRightClick
---------------------------------------------------------*/
function PANEL:DoRightClick()
	return false
end

/*---------------------------------------------------------
   Name: AnimSlide
---------------------------------------------------------*/
function PANEL:AnimSlide( anim, delta, data )
	
	if (!self.ChildNodes) then anim:Stop() return end
	
	if ( anim.Started ) then
		data.To = self:GetTall()
		data.Visible = self.ChildNodes:IsVisible()
	end
	
	if ( anim.Finished ) then
		self:InvalidateLayout()
		self.ChildNodes:SetVisible( data.Visible )
		self:SetTall( data.To )
		self:GetParentNode():ChildExpanded()
	return end

	self.ChildNodes:SetVisible( true )
	
	self:SetTall( Lerp( delta ^ 0.2, data.From, data.To ) )
	
	self:GetParentNode():ChildExpanded()
	
end

/*---------------------------------------------------------
   Name: ShowIcons
---------------------------------------------------------*/
function PANEL:ShowIcons()
	return self:GetParentNode():ShowIcons()
end

/*---------------------------------------------------------
   Name: GetLineHeight
---------------------------------------------------------*/
function PANEL:GetLineHeight()
	return self:GetParentNode():GetLineHeight()
end


/*---------------------------------------------------------
   Name: GetIndentSize
---------------------------------------------------------*/
function PANEL:GetIndentSize()
	return self:GetParentNode():GetIndentSize()
end

/*---------------------------------------------------------
   Name: strSomething
---------------------------------------------------------*/
function PANEL:SetText( strName )

	self.Label:SetText( strName )

end

/*---------------------------------------------------------
   Name: ExpandRecurse
---------------------------------------------------------*/
function PANEL:ExpandRecurse( bExpand )

	self:SetExpanded( bExpand, true )
	
	if ( !self.ChildNodes ) then return end
	
	for k, Child in pairs( self.ChildNodes:GetItems() ) do
		if ( Child.ExpandRecurse ) then
			Child:ExpandRecurse( bExpand )
		end
	end

end

/*---------------------------------------------------------
   Name: ExpandTo
---------------------------------------------------------*/
function PANEL:ExpandTo( bExpand )

	self:SetExpanded( bExpand, true )
	self:GetParentNode():ExpandTo( bExpand )

end


/*---------------------------------------------------------
   Name: SetExpanded
---------------------------------------------------------*/
function PANEL:SetExpanded( bExpand, bSurpressAnimation )

	if ( !self.ChildNodes ) then return end

	local StartTall = self:GetTall()
	self.animSlide:Stop()

	// Populate the child folders..
	if ( bExpand ) then
		if ( self:PopulateChildrenAndSelf( true ) ) then 
		
			// Could really do with a 'loading' thing here
			self.Expander:SetText( "L" ) 
		
			return 
		end
	end
	
	if ( self.ChildNodes ) then
		self.ChildNodes:SetVisible( bExpand )
		if ( bExpand ) then
			self.ChildNodes:InvalidateLayout( true )
		end
	end
	
	if ( bExpand ) then 
		self.Expander:SetText( "-" ) 
	else 
		self.Expander:SetText( "+" ) 
	end
	
	self.m_bExpanded = bExpand
	
	self:InvalidateLayout( true )
	
	// We need to tell our parent about the change, 
	// so they can resize to accomodate us.
	// This has to happen all the way up to the root node.
	self:GetParentNode():ChildExpanded( bExpand )
		
	//
	// Do animation..
	if ( !bSurpressAnimation ) then
		self.animSlide:Start( 0.2, { From = StartTall } )
		self.animSlide:Run()
	end
	
end

/*---------------------------------------------------------
   Name: ChildExpanded
---------------------------------------------------------*/
function PANEL:ChildExpanded( bExpand )

	self.ChildNodes:InvalidateLayout( true )
	self:InvalidateLayout( true )
	self:GetParentNode():ChildExpanded( bExpand )
	
end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()
end

/*---------------------------------------------------------
   Name: HasChildren
---------------------------------------------------------*/
function PANEL:HasChildren()
	
	if ( !self.ChildNodes ) then return false end
	if ( #self.ChildNodes:GetItems() == 0 ) then return false end
	
	return true
	
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	
	if ( self.animSlide:Active() ) then return end
	
	local LineHeight = self:GetLineHeight()
	
	self.Expander:SetSize( 11, 11 )
	self.Expander:SetPos( 2, 3 )
	self.Expander:SetVisible( self:HasChildren() || self:GetForceShowExpander() )
	self.Expander:SetZPos( 10 )
	
	self.Label:StretchToParent( 0, 0, 0, 0 )
	self.Label:SetTall( LineHeight )
	self.Label:SetTextColor( self.m_cTextColor )
	
	if ( self:ShowIcons() ) then
		self.Icon:SetVisible( true )
		self.Icon:SetPos( 0, (LineHeight - self.Icon:GetTall()) * 0.5 )
		self.Icon:MoveRightOf( self.Expander, 4 )
		self.Label:SetTextInset( self.Icon.x + self.Icon:GetWide() + 4 )
	else
		self.Icon:SetVisible( false )
		self.Label:SetTextInset( self.Expander.x + self.Expander:GetWide() + 4 )
	end

	if ( !self.ChildNodes || !self.ChildNodes:IsVisible() ) then 
		self:SetTall( self:GetLineHeight() ) 
	return end

	self.ChildNodes:SizeToContents()
	self:SetTall( LineHeight + self.ChildNodes:GetTall() )
	
	if ( self.ChildNodes ) then
		self.ChildNodes:StretchToParent( LineHeight, LineHeight, 0, 0 )
	end
	
end

/*---------------------------------------------------------
   Name: CreateChildNodes
---------------------------------------------------------*/
function PANEL:CreateChildNodes()

	if ( self.ChildNodes ) then return end

	self.ChildNodes = vgui.Create( "DPanelList", self )
	self.ChildNodes:SetAutoSize( true )
	self.ChildNodes:SetDrawBackground( false )
	self.ChildNodes:EnableHorizontal( false )
	self.ChildNodes:SetVisible( false )
	
	self:InvalidateLayout()

end

/*---------------------------------------------------------
   Name: AddPanel
---------------------------------------------------------*/
function PANEL:AddPanel( pPanel )
	
	self:CreateChildNodes()
	
	self.ChildNodes:AddItem( pPanel )
	self:InvalidateLayout()
	
end


/*---------------------------------------------------------
   Name: AddNode
---------------------------------------------------------*/
function PANEL:AddNode( strName )
	
	self:CreateChildNodes()
	
	local pNode = vgui.Create( "DTree_Node", self )
		pNode:SetText( strName )
		pNode:SetParentNode( self )
		pNode:SetRoot( self:GetRoot() )
	
	self.ChildNodes:AddItem( pNode )
	self:InvalidateLayout()
	
	return pNode
	
end



/*---------------------------------------------------------
   Name: MakeFolder
---------------------------------------------------------*/
function PANEL:MakeFolder( strFolder, bShowFiles, strWildCard, bDontForceExpandable )
	
	self.FileName = strFolder
	
	strWildCard = strWildCard or "*"
	
	// Store the data
	self:SetWildCard( strWildCard )
	self:SetFolder( strFolder )
	self:SetShowFiles( bShowFiles or false )
	
	self:CreateChildNodes()
	self:SetNeedsChildSearch( true )
	
	if ( !bDontForceExpandable ) then
		self:SetForceShowExpander( true )
	end
	
end

/*---------------------------------------------------------
   Name: FilePopulateCallback
---------------------------------------------------------*/
function PANEL:FilePopulateCallback( filename, folders, files, foldername, bAndChildren )

	local showfiles = self:GetShowFiles()

	self.ChildNodes:InvalidateLayout( true )
	
	local FileCount = 0
	
	for k, File in SortedPairsByValue( folders ) do
	
		local Node = self:AddNode( File )
		Node:MakeFolder( foldername .. "/" .. File, showfiles, wildcard, true )
		FileCount = FileCount + 1
	
	end
	
	if ( showfiles ) then
	
		for k, File in SortedPairs( files ) do
		
			local Node = self:AddNode( File )
			FileCount = FileCount + 1
		
		end
		
	end
	
	if ( FileCount == 0 ) then
		
		self.ChildNodes:Remove()
		self.ChildNodes = nil
		
		self:SetFolder( nil )
		self:SetShowFiles( nil )
		self:SetWildCard( nil )
	
		self:InvalidateLayout()
		
		self.Expander:SetText( "-" )
		
	return end
	
	// Populate the children if we've been requested to
	if ( bAndChildren ) then
		self:PopulateChildren()
	end
	
	self:InvalidateLayout()
	
end

/*---------------------------------------------------------
   Name: FilePopulateTopLevel
---------------------------------------------------------*/
function PANEL:FilePopulate( bAndChildren, bExpand )

	local folder = self:GetFolder()
	local wildcard = self:GetWildCard()
	
	if ( !folder || !wildcard ) then return false end
	
	file.TFind( folder .. "/" .. wildcard, function( f, dirs, files ) 
												self:FilePopulateCallback( f, dirs, files, folder, bAndChildren ) 
												if ( bExpand ) then
													self:SetExpanded( true ) 
												end
											end )
	
	self:SetFolder( nil )
	self:SetNeedsChildSearch( false )
	return true

end

/*---------------------------------------------------------
   Name: FilePopulateChildren
---------------------------------------------------------*/
function PANEL:PopulateChildren()

	for k, v in pairs( self.ChildNodes:GetItems() ) do
		v:FilePopulate( false )
	end

end

/*---------------------------------------------------------
   Name: FilePopulateChildren
---------------------------------------------------------*/
function PANEL:PopulateChildrenAndSelf( bExpand )

	// Make sure we're populated
	if ( self:FilePopulate( true, bExpand ) ) then return true end
	
	self:PopulateChildren()

end

/*---------------------------------------------------------
   Name: AddNode
---------------------------------------------------------*/
function PANEL:SetSelected( b )
	
	self.Label:SetSelected( b )
	
end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()

	self.animSlide:Run()

end


derma.DefineControl( "DTree_Node", "Tree Node", PANEL, "Panel" )