/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

*/

local table 			= table
local vgui				= vgui
local concommand		= concommand
local Msg				= Msg
local setmetatable		= setmetatable
local _G				= _G
local hook 				= hook
local gamemode			= gamemode

module("derma")

Controls = {}
SkinList = {}

local derma_skin_name = nil
local DefaultSkin = {}
local SkinMetaTable = {}
local iSkinChangeIndex = 1

SkinMetaTable.__index = function ( self, key ) 
							return DefaultSkin[key]
						end
						
/*---------------------------------------------------------
   DefineControl
---------------------------------------------------------*/
function GetControlList()

	return Controls
	
end

/*---------------------------------------------------------
   DefineControl
---------------------------------------------------------*/
function DefineControl( strName, strDescription, strTable, strBase )

	// Add Derma table to PANEL table.
	strTable.Derma = { ClassName 	= strName, 
						Description = strDescription, 
						BaseClass 	= strBase }

	// Register control with VGUI
	vgui.Register( strName, strTable, strBase )
	
	// Store control
	table.insert( Controls, strTable.Derma )
	
	// Todo: Sort Controls table by name here.
	
	// Store as a global so controls can 'baseclass' easier
	_G[ strName ] = strTable
	
	return strTable
	
end



/*---------------------------------------------------------
   DefineSkin
---------------------------------------------------------*/
function DefineSkin( strName, strDescription, strTable )

	strTable.Name = strName
	strTable.Description = strDescription
	strTable.Base = strBase or "Default"
	
	if ( strName != "Default" ) then
		setmetatable( strTable, SkinMetaTable )
	else
		DefaultSkin = strTable
	end

	SkinList[ strName ] = strTable
	
end

/*---------------------------------------------------------
   GetSkin - Returns current skin for panel
---------------------------------------------------------*/
function GetSkinTable()

	return table.Copy( SkinList )

end

/*---------------------------------------------------------
   Returns 'Default' Skin
---------------------------------------------------------*/
function GetDefaultSkin()

	local skin = nil
	
	// Check gamemode skin preference
	if ( gamemode ) then
		local skinname = gamemode.Call( "ForceDermaSkin" )
		if ( skinname ) then skin = GetNamedSkin( skinname ) end
	end

	// default
	if (!skin) then skin = DefaultSkin end
	
	return skin
end

/*---------------------------------------------------------
   Returns 'Named' Skin
---------------------------------------------------------*/
function GetNamedSkin( name )
	return SkinList[ name ]
end

/*---------------------------------------------------------
   SkinHook( strType, strName, panel )
---------------------------------------------------------*/
function SkinHook( strType, strName, panel )

	local Skin = panel:GetSkin()

	if ( !Skin ) then return end
	local func = Skin[ strType .. strName ]
	if ( !func ) then return end
	
	return func( Skin, panel )
	
end


/*---------------------------------------------------------
   SkinTexture( strName )
---------------------------------------------------------*/
function SkinTexture( strName )

	local Skin = panel:GetSkin()

	if ( !Skin ) then return end
	local Textures = Skin.Textures
	if ( !Textures ) then return end
	
	return Textures[ strName ]
	
end

/*---------------------------------------------------------
   SkinHook( strType, strName, panel )
---------------------------------------------------------*/
function Color( strName, panel, default )

	local Skin = panel:GetSkin()

	if ( !Skin ) then return end
	local color = Skin[ strName ]
	
	if ( !color ) then return default end
	
	return color
	
end

/*---------------------------------------------------------
   SkinChangeIndex
---------------------------------------------------------*/
function SkinChangeIndex()
	return iSkinChangeIndex
end

/*---------------------------------------------------------
   RefreshSkins - clears all cache'd panels (so they will reassess which skin they should be using)
---------------------------------------------------------*/
function RefreshSkins()
	iSkinChangeIndex = iSkinChangeIndex + 1
end