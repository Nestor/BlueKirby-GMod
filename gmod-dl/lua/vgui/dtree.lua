/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DTree
	
*/
	
local PANEL = {}

AccessorFunc( PANEL, "m_bShowIcons", 			"ShowIcons" )
AccessorFunc( PANEL, "m_iIndentSize", 			"IndentSize" )
AccessorFunc( PANEL, "m_iLineHeight", 			"LineHeight" )
AccessorFunc( PANEL, "m_pSelectedItem",			"SelectedItem" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:EnableVerticalScrollbar()
	
	self:SetShowIcons( true )
	self:SetIndentSize( 14 )
	
	self:SetLineHeight( 16 )

end

/*---------------------------------------------------------
   Name: AddNode
---------------------------------------------------------*/
function PANEL:AddNode( strName )

	local pNode = vgui.Create( "DTree_Node", self )

		pNode:SetText( strName )
		pNode:SetParentNode( self )
		pNode:SetRoot( self )
	
	self:AddItem( pNode )
	
	return pNode
	
end

/*---------------------------------------------------------
   Name: GetTopNode
---------------------------------------------------------*/
function PANEL:GetTopNode( id )

	return self.Lines[ id ]
	
end

/*---------------------------------------------------------
   Name: ChildExpanded
---------------------------------------------------------*/
function PANEL:ChildExpanded( bExpand )

	self:InvalidateLayout()
	
end

/*---------------------------------------------------------
   Name: ShowIcons
---------------------------------------------------------*/
function PANEL:ShowIcons()

	return self.m_bShowIcons

end

/*---------------------------------------------------------
   Name: ExpandTo
---------------------------------------------------------*/
function PANEL:ExpandTo( bExpand )

end

/*---------------------------------------------------------
   Name: SetExpanded
---------------------------------------------------------*/
function PANEL:SetExpanded( bExpand )

	// The top most node shouldn't react to this.

end

/*---------------------------------------------------------
   Name: Clear
---------------------------------------------------------*/
function PANEL:Clear()

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()
	
	derma.SkinHook( "Paint", "Tree", self )
	return true
	
end

/*---------------------------------------------------------
   Name: DoClick
---------------------------------------------------------*/
function PANEL:DoClick( node )
	return false
end

/*---------------------------------------------------------
   Name: DoRightClick
---------------------------------------------------------*/
function PANEL:DoRightClick( node )
	return false
end

/*---------------------------------------------------------
   Name: SetSelectedItem
---------------------------------------------------------*/
function PANEL:SetSelectedItem( node )
	
	if ( self.m_pSelectedItem ) then
		self.m_pSelectedItem:SetSelected( false )
	end
	
	if ( node ) then
		node:SetSelected( true )
	end
	
	self.m_pSelectedItem = node
	
end

/*---------------------------------------------------------
   Name: GenerateExample
---------------------------------------------------------*/
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetPadding( 5 )
		ctrl:SetSize( 300, 300 )
		
		local node = ctrl:AddNode( "Node One" )
		local node = ctrl:AddNode( "Node Two" )
			local cnode = node:AddNode( "Node 2.1" )
			local cnode = node:AddNode( "Node 2.2" )
			local cnode = node:AddNode( "Node 2.3" )
			local cnode = node:AddNode( "Node 2.4" )
			local cnode = node:AddNode( "Node 2.5" )
			local gcnode = cnode:AddNode( "Node 2.5" )
			local cnode = node:AddNode( "Node 2.6" )
		local node = ctrl:AddNode( "Node Three ( Maps Folder )" )
			node:MakeFolder( "maps", true )
		local node = ctrl:AddNode( "Node Four" )
		
	
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end


derma.DefineControl( "DTree", "Tree View", PANEL, "DPanelList" )

