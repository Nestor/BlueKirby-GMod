
/*---------------------------------------------------------
   Name: string.ToTable( string )
---------------------------------------------------------*/
function string.ToTable ( str )
	local tbl = {}
	
	for i = 1, string.len( str ) do
		tbl[i] = string.sub( str, i, i )
	end
	
	return tbl
end

/*---------------------------------------------------------
   Name: explode(seperator ,string)
   Desc: Takes a string and turns it into a table
   Usage: string.explode( " ", "Seperate this string")
---------------------------------------------------------*/
local totable = string.ToTable
local string_sub = string.sub
local string_gsub = string.gsub
local string_gmatch = string.gmatch
function string.Explode(separator, str, withpattern)
    if (separator == "") then return totable( str ) end
     
    local ret = {}
    local index,lastPosition = 1,1
     
    -- Escape all magic characters in separator
    if not withpattern then separator = string_gsub( separator, "[%-%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1" ) end
     
    -- Find the parts
    for startPosition,endPosition in string_gmatch( str, "()" .. separator.."()" ) do
        ret[index] = string_sub( str, lastPosition, startPosition-1)
        index = index + 1
         
        -- Keep track of the position
        lastPosition = endPosition
    end
     
    -- Add last part by using the position we stored
    ret[index] = string_sub( str, lastPosition)
    return ret
end

function string.Split( str, delimiter )
	return string.Explode( delimiter, str )
end

/*---------------------------------------------------------
   Name: implode(seperator ,Table)
   Desc: Takes a table and turns it into a string
   Usage: string.implode( " ", {"This", "Is", "A", "Table"})
---------------------------------------------------------*/
function string.Implode(seperator,Table) return 
	table.concat(Table,seperator) 
end


/*---------------------------------------------------------
   Name: GetExtensionFromFilename(path)
   Desc: Returns extension from path
   Usage: string.GetExtensionFromFilename("garrysmod/lua/modules/string.lua")
---------------------------------------------------------*/
function string.GetExtensionFromFilename( path )
	return path:match( "%.([^%.]+)$" )
end

/*---------------------------------------------------------
   Name: GetPathFromFilename(path)
   Desc: Returns path from filepath
   Usage: string.GetPathFromFilename("garrysmod/lua/modules/string.lua")
---------------------------------------------------------*/
function string.GetPathFromFilename(path)
	return path:match( "^(.*[/\\])[^/\\]-$" ) or ""
end
/*---------------------------------------------------------
   Name: GetFileFromFilename(path)
   Desc: Returns file with extension from path
   Usage: string.GetFileFromFilename("garrysmod/lua/modules/string.lua")
---------------------------------------------------------*/
function string.GetFileFromFilename(path)
	return path:match( "[\\/]([^/\\]+)$" ) or ""
end

/*-----------------------------------------------------------------
   Name: FormattedTime( TimeInSeconds, Format )
   Desc: Given a time in seconds, returns formatted time
         If 'Format' is not specified the function returns a table 
         conatining values for hours, mins, secs, ms

   Examples: string.FormattedTime( 123.456, "%02i:%02i:%02i")  ==> "02:03:45"
             string.FormattedTime( 123.456, "%02i:%02i")       ==> "02:03"
             string.FormattedTime( 123.456, "%2i:%02i")        ==> " 2:03"
             string.FormattedTime( 123.456 )        		==> {h = 0, m = 2, s = 3, ms = 45}
-----------------------------------------------------------------*/

function string.FormattedTime( TimeInSeconds, Format )
	if not TimeInSeconds then TimeInSeconds = 0 end

	local i = math.floor( TimeInSeconds )
	local h,m,s,ms	=	( i/3600 ),
				( i/60 )-( math.floor( i/3600 )*3600 ),
				TimeInSeconds-( math.floor( i/60 )*60 ),
				( TimeInSeconds-i )*100

	if Format then
		return string.format( Format, m, s, ms )
	else
		return { h=h, m=m, s=s, ms=ms }
	end
end

/*---------------------------------------------------------
   Name: Old time functions
---------------------------------------------------------*/

function string.ToMinutesSecondsMilliseconds( TimeInSeconds )	return string.FormattedTime( TimeInSeconds, "%02i:%02i:%02i")	end
function string.ToMinutesSeconds( TimeInSeconds )		return string.FormattedTime( TimeInSeconds, "%02i:%02i")	end



function string.Left(str, num)
	return string.sub(str, 1, num)
end

function string.Right(str, num)
	return string.sub(str, -num)
end


function string.Replace( str, tofind, toreplace )
	tofind = tofind:gsub( "[%-%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1" )
	toreplace = toreplace:gsub( "%%", "%%%1" )
	return ( str:gsub( tofind, toreplace ) )
end

/*---------------------------------------------------------
   Name: Trim(s)
   Desc: Removes leading and trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
---------------------------------------------------------*/
function string.Trim( s, char )
	if ( !char ) then char = "%s" end
	return ( s:gsub( "^" .. char .. "*(.-)" .. char .. "*$", "%1" ) )
end

/*---------------------------------------------------------
   Name: TrimRight(s)
   Desc: Removes trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
---------------------------------------------------------*/
function string.TrimRight( s, char )
	if ( !char ) then char = " " end
	
	if ( string.sub( s, -1 ) == char ) then
		s = string.sub( s, 0, -2 )
		s = string.TrimRight( s, char )
	end
	
	return s
end

/*---------------------------------------------------------
   Name: TrimLeft(s)
   Desc: Removes leading spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
---------------------------------------------------------*/
function string.TrimLeft( s, char )
	if ( !char ) then char = " " end
	
	if ( string.sub( s, 1 ) == char ) then
		s = string.sub( s, 1 )
		s = string.TrimLeft( s, char )
	end
	
	return s
end

function string.NiceSize( size )
	
	if ( size < 1024 ) then return size .. " Bytes" end
	if ( size < 1024 * 1024 ) then return math.Round( size / 1024, 2 ) .. " KB" end
	if ( size < 1024 * 1024 * 1024 ) then return math.Round( size / (1024*1024), 2 ) .. " MB" end
	
	return math.Round( size / (1024*1024*1024), 2 ) .. " GB"

end

local meta = getmetatable( "" )

function meta:__index( key )
	if ( string[key] ) then
		return string[key]
	elseif ( tonumber( key ) ) then
		return self:sub( key, key )
	else
		error( "bad key to string index (number expected, got " .. type( key ) .. ")", 2 )
	end
end