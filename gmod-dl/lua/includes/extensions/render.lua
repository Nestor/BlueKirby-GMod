
// Return if there's nothing to add on to
if (!render) then return end

/*---------------------------------------------------------
  Short aliases for stencil constants
---------------------------------------------------------*/  

STENCIL_NEVER = STENCILCOMPARISONFUNCTION_NEVER
STENCIL_LESS = STENCILCOMPARISONFUNCTION_LESS
STENCIL_EQUAL = STENCILCOMPARISONFUNCTION_EQUAL
STENCIL_LESSEQUAL = STENCILCOMPARISONFUNCTION_LESSEQUAL
STENCIL_GREATER = STENCILCOMPARISONFUNCTION_GREATER
STENCIL_NOTEQUAL = STENCILCOMPARISONFUNCTION_NOTEQUAL
STENCIL_GREATEREQUAL = STENCILCOMPARISONFUNCTION_GREATEREQUAL
STENCIL_ALWAYS = STENCILCOMPARISONFUNCTION_ALWAYS

STENCIL_KEEP = STENCILOPERATION_KEEP
STENCIL_ZERO = STENCILOPERATION_ZERO
STENCIL_REPLACE = STENCILOPERATION_REPLACE
STENCIL_INCRSAT = STENCILOPERATION_INCRSAT
STENCIL_DECRSAT = STENCILOPERATION_DECRSAT
STENCIL_INVERT = STENCILOPERATION_INVERT
STENCIL_INCR = STENCILOPERATION_INCR
STENCIL_DECR = STENCILOPERATION_DECR

/*---------------------------------------------------------
   Name:	ClearRenderTarget
   Params: 	<texture> <color>
   Desc:	Clear a render target
---------------------------------------------------------*/   
function render.ClearRenderTarget( rt, color )

	local OldRT = render.GetRenderTarget();
		render.SetRenderTarget( rt )
		render.Clear( color.r, color.g, color.b, color.a )
	render.SetRenderTarget( OldRT )

end


/*---------------------------------------------------------
   Name:	SupportsHDR
   Params: 	
   Desc:	Return true if the client supports HDR
---------------------------------------------------------*/   
function render.SupportsHDR( )

	if ( render.GetDXLevel() < 80 ) then return false end

	return true
	
end


/*---------------------------------------------------------
   Name:	CopyTexture
   Params: 	<texture from> <texture to>
   Desc:	Copy the contents of one texture to another
---------------------------------------------------------*/   
function render.CopyTexture( from, to )

	local OldRT = render.GetRenderTarget();
		
		render.SetRenderTarget( from )
		render.CopyRenderTargetToTexture( to )
		
	render.SetRenderTarget( OldRT )

end