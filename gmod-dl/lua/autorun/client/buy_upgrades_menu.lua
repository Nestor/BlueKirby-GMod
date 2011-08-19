local function SetPrice(item, price)
	Price:SetText("Price: "..price.." points.")
	Price:SizeToContents()
	Price:SetPos(155 - 2 * string.len("Price: "..price.." points."),220)
	myLabel:SetText("Item: "..item)
	myLabel:SizeToContents()
	myLabel:SetPos(150 - 2 * string.len("Item: "..item),245)
	DermaPanel2:SetTitle("Spend Points - Points: "..LocalPlayer():GetNWInt("points"))
end

local function SetItem(item, price)
	Price2:SetText("Price: "..price.." points.")
	Price2:SizeToContents()
	Price2:SetPos(150 - string.len("Price: "..price.." points."),220)
	myLabel2:SetText("Item: "..item)
	myLabel2:SizeToContents()
	myLabel2:SetPos(150 - string.len("Item: "..item),245)
	DermaPanel2:SetTitle("Spend Points - Points: "..LocalPlayer():GetNWInt("points"))
end

local function ShowUpgradesMenu()
	
	DermaPanel2 = vgui.Create("DFrame")
    DermaPanel2:SetPos((ScrW() / 2) - 180, (ScrH() / 2) - 180)
    DermaPanel2:SetSize(334,334)
    DermaPanel2:SetTitle("Spend Points - Points: "..LocalPlayer():GetNWInt("points"))
    DermaPanel2:MakePopup()
	
	local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( DermaPanel2 )
	PropertySheet:SetPos( 5, 30 )
	PropertySheet:SetSize( 334, 334 )
	 
	local TestingPanel = vgui.Create( "DPanel", DermaPanel2 )
	TestingPanel:SetPos( 2, 22 )
	TestingPanel:SetSize( 332, 301 )
	TestingPanel.Paint = function() -- Paint function
		surface.SetDrawColor( 80, 80, 80, 255 ) -- Set our rect color below us; we do this so you can see items added to this panel
		surface.DrawRect( 0, 0, TestingPanel:GetWide(), TestingPanel:GetTall() ) -- Draw the rect
	end
	
	local Panel2 = vgui.Create( "DPanel", DermaPanel2 )
	Panel2:SetPos( 2, 51 )
	Panel2:SetSize( 334, 300 )
	Panel2.Paint = function() -- Paint function
		surface.SetDrawColor( 120, 120, 120, 255 ) -- Set our rect color below us; we do this so you can see items added to this panel
		surface.DrawRect( 0, 0, TestingPanel:GetWide(), TestingPanel:GetTall() ) -- Draw the rect
	end
	
	local Panel3 = vgui.Create( "DPanel", DermaPanel2 )
	Panel3:SetPos( 2, 51 )
	Panel3:SetSize( 334, 300 )
	Panel3:SetVisible(false)
	Panel3.Paint = function() -- Paint function
		surface.SetDrawColor( 120, 120, 120, 255 ) -- Set our rect color below us; we do this so you can see items added to this panel
		surface.DrawRect( 0, 0, TestingPanel:GetWide(), TestingPanel:GetTall() ) -- Draw the rect
	end
	
	local Panel4 = vgui.Create( "DPanel", DermaPanel2 )
	Panel4:SetPos( 2, 51 )
	Panel4:SetSize( 334, 300 )
	Panel4:SetVisible(false)
	Panel4.Paint = function() -- Paint function
		surface.SetDrawColor( 120, 120, 120, 255 ) -- Set our rect color below us; we do this so you can see items added to this panel
		surface.DrawRect( 0, 0, TestingPanel:GetWide(), TestingPanel:GetTall() ) -- Draw the rect
	end
	 
	local DermaButton = vgui.Create( "DButton", TestingPanel )
	DermaButton:SetText( "Weapons" )
	DermaButton:SetPos( 2, 2 )
	DermaButton:SetSize( 109, 25 )
	DermaButton.DoClick = function ()
		Panel2:SetVisible(true)
		Panel3:SetVisible(false)
		Panel4:SetVisible(false)
	end
	
	local DermaButton = vgui.Create( "DButton", TestingPanel )
	DermaButton:SetText( "Hats/Trails" )
	DermaButton:SetPos( 111, 2 )
	DermaButton:SetSize( 109, 25 )
	DermaButton.DoClick = function ()
		Panel2:SetVisible(false)
		Panel3:SetVisible(true)
		Panel4:SetVisible(false)
	end
	
	local DermaButton = vgui.Create( "DButton", TestingPanel )
	DermaButton:SetText( "My upgrades" )
	DermaButton:SetPos( 220, 2 )
	DermaButton:SetSize( 109, 25 )
	DermaButton.DoClick = function ()
		Panel2:SetVisible(false)
		Panel3:SetVisible(false)
		Panel4:SetVisible(true)
	end
	
	local Weapons = {}
    Weapons[1] = "models/Weapons/W_pistol.mdl"
	Weapons[2] = "models/Weapons/W_crossbow.mdl"
	Weapons[3] = "models/Items/Flare.mdl"
	Weapons[4] = "models/Effects/splode.mdl"
	Weapons[5] = "models/Items/item_item_crate_dynamic.mdl"
	Weapons[6] = "models/Items/hevsuit.mdl"
	Weapons[7] = "models/Items/ammocrate_ar2.mdl"
	Weapons[8] = "models/Weapons/w_crowbar.mdl"
	Weapons[9] = "models/Gibs/AGIBS.mdl"
	
	local Items = {}
 
	local IconList = vgui.Create( "DPanelList", Panel2 ) 
 
 	IconList:EnableVerticalScrollbar( true ) 
 	IconList:EnableHorizontal( true ) 
 	IconList:SetPadding( 4 ) 
	IconList:SetPos(1,2)
	IconList:SetSize(328, 200)
 
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[1] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("Pistol Damage Upgrade", 200) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "pistdmg") end

	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[2] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("Spawn With Crossbow", 350) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "spawn_with_crossbow") end
	
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[3] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("Chance to set enemies on fire", 300) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "firedmg") end
	
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[4] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("Explosion Damage Upgrade", 200) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "explodedmg") end
	
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[5] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("Lower Prices In Shop", 300) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "lower_prices") end
	
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[6] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("Unlock Armor In Shop", 50) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "armorshop") end
	
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[7] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("After each wave receive ammo", 150) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "waveammo") end
	
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[8] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("Increased Crowbar Damage", 200) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "crowbardmg") end
	
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( Weapons[9] )
 	IconList:AddItem( icon )
	icon.OnCursorEntered = function( icon ) SetPrice("Increased overall damage", 1000) end
	icon.DoClick = function( icon ) surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand("buy_upgrade", "alldmg") end
	
	
	local IconList = vgui.Create( "DPanelList", Panel3 ) 
 
 	IconList:EnableVerticalScrollbar( true ) 
 	IconList:EnableHorizontal( true ) 
 	IconList:SetPadding( 4 ) 
	IconList:SetPos(1,2)
	IconList:SetSize(328, 200)
	
	local IconList = vgui.Create( "DPanelList", Panel4 ) 
 
 	IconList:EnableVerticalScrollbar( true ) 
 	IconList:EnableHorizontal( true ) 
 	IconList:SetPadding( 4 ) 
	IconList:SetPos(1,2)
	IconList:SetSize(328, 200)
	
	Price = vgui.Create( "DLabel", Panel2 )
	Price:SetPos(150,220) // Position
	Price:SetColor(Color(255,255,255,255)) // Color
	Price:SetFont("default")
	Price:SetText( "Price:" ) // Text
	Price:SizeToContents()
	
	myLabel = vgui.Create( "DLabel", Panel2 )
	myLabel:SetPos(150,245) // Position
	myLabel:SetColor(Color(255,255,255,255)) // Color
	myLabel:SetFont("default")
	myLabel:SetText("Item: ") // Text
	myLabel:SizeToContents()
	
	Price2 = vgui.Create( "DLabel", Panel3 )
	Price2:SetPos(150,220) // Position
	Price2:SetColor(Color(255,255,255,255)) // Color
	Price2:SetFont("default")
	Price2:SetText("Price: ") // Text
	Price2:SizeToContents()
	
	myLabel2 = vgui.Create( "DLabel", Panel3 )
	myLabel2:SetPos(150,245) // Position
	myLabel2:SetColor(Color(255,255,255,255)) // Color
	myLabel2:SetFont("default")
	myLabel2:SetText("Item: ") // Text
	myLabel2:SizeToContents()
	
	
	
 end

 
concommand.Add( "upgrade_shop_open", ShowUpgradesMenu )
usermessage.Hook( "open_upgrade_shop", ShowUpgradesMenu )