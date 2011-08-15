
local meta = FindMetaTable( "Entity" )

// Return if there's nothing to add on to
if (!meta) then return end

/*---------------------------------------------------------
   Name: Short cut to add entities to the table
---------------------------------------------------------*/
function meta:GetVar( name, default )

	local Val = self:GetTable()[ name ]
	if ( Val == nil ) then return default end
	
	return Val
	
end

/*---------------------------------------------------------
   Name: Returns true if the entity has constraints attached to it
---------------------------------------------------------*/
function meta:IsConstrained()

	if (CLIENT) then return self:GetNetworkedBool( "IsConstrained" ) end
	
	local c = self:GetTable().Constraints
	local bIsConstrained = false
	
	if ( c ) then
	
		for k,v in pairs( c ) do
			if v:IsValid() then bIsConstrained = true break end
			c[k] = nil
		end
		
	end

	self:SetNetworkedBool( "IsConstrained", bIsConstrained )
	return bIsConstrained
	
end

/*---------------------------------------------------------
   Name: Short cut to set tables on the entity table
---------------------------------------------------------*/
function meta:SetVar( name, value )

	self:GetTable()[ name ] = value
	
end


/*---------------------------------------------------------
   Name: CallOnRemove
   Desc: Call this function when this entity dies.
   Calls the function like Function( <entity>, <optional args> )
---------------------------------------------------------*/
function meta:CallOnRemove( name, func, ... )

	local mytable = self:GetTable()
	mytable.OnDieFunctions = mytable.OnDieFunctions or {}
	
	mytable.OnDieFunctions[ name ] = { Name = name, Function = func, Args = {...} }
	
end

/*---------------------------------------------------------
   Name: RemoveCallOnRemove
   Desc: Removes the named hook
---------------------------------------------------------*/
function meta:RemoveCallOnRemove( name )

	local mytable = self:GetTable()
	mytable.OnDieFunctions = mytable.OnDieFunctions or {}
	mytable.OnDieFunctions[ name ] = nil
	
end


/*---------------------------------------------------------
   Simple mechanism for calling the die functions.
---------------------------------------------------------*/
local function DoDieFunction( ent ) 

	if ( !ent || !ent.OnDieFunctions ) then return end

	for k, v in pairs( ent.OnDieFunctions ) do
	
		// Functions aren't saved - so this could be nil if we loaded a game.
		if ( v && v.Function ) then
		
			local b, e = pcall( v.Function, ent, unpack( v.Args ) )
			if (!b) then
			
				Msg("****************************************************************\n")
				Msg("Error calling die function "..tostring(v.Name).." for entity "..tostring(ent).."\n")
				Msg("ERROR: "..tostring(e).."\n")
				Msg("****************************************************************\n")
			
			end
			
		end
	
	end

end

hook.Add( "EntityRemoved", "DoDieFunction", DoDieFunction )

/*---------------------------------------------------------
   Name: SetColor overload
---------------------------------------------------------*/
local setColor = meta.SetColor
function meta:SetColor( r, g, b, a )
	if ( type( r ) == "table" ) then setColor( self, r.r, r.g, r.b, r.a ) return end
	setColor( self, r, g, b, a )
end

/*---------------------------------------------------------
   Name: PhysWake
---------------------------------------------------------*/
function meta:PhysWake()

	local phys = self:GetPhysicsObject()
	if ( !phys || !phys:IsValid() ) then return end
	
	phys:Wake()
	
end

/*---------------------------------------------------------
---------------------------------------------------------*/
function meta:InstallDataTable()

	self.dt = {}
	local datatable = {}
	local meta = {}

	meta.__index = function ( ent, key )

		local dt = datatable[ key ]
		if ( dt == nil ) then return end	
		
		return dt.GetFunc( self, dt.index, key )
		
	end
	
	meta.__newindex = function( ent, key, value )
				
		local dt = datatable[ key ]
		if ( dt == nil ) then return end
		
		dt.SetFunc( self, dt.index, value )
	
	end	
	
	self.DTVar = function( ent, typename, index, name )
	
		local SetFunc = ent[ "SetDT"..typename ]
		local GetFunc = ent[ "GetDT"..typename ]
		
		if ( !SetFunc || !GetFunc ) then
			MsgN( "Couldn't addvar " , name, " - type ", typename," is invalid!" )
			return
		end
	
		datatable[ name ] = { 
							index = index,
							SetFunc = SetFunc,
							GetFunc = GetFunc,
							}
							
	end
	
	setmetatable( self.dt, meta )
	
end

if ( SERVER ) then

	AccessorFunc( meta, "m_bUnFreezable", "UnFreezable" )

end
