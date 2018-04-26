--script for imgui.lua generation

function strip(cad)
	return cad:gsub("^%s*(.-)%s*$","%1")
end


cdefs = {}

location_re = '^# %d+ "([^"]*)"'
cimpath_re = '^(.*[\\/])(cimgui)%.h$' 
cimpath2_re = '^(.*[\\/])(imgui_structs)%.h$' 
define_re = "^#define%s+([^%s]+)%s+([^%s]+)$"

number_re = "^-?[0-9]+$"
hex_re = "0x[0-9a-fA-F]+$"

local in_cimgui = false
for line in io.lines() do
repeat -- simulate continue with break

	--print(line)
	line = strip(line)
	if #line == 0 then break end
	-- Is this a preprocessor statement?
	if line:sub(1,1) == "#" then
		-- Is this a location pragma?
		local location_match = line:match(location_re)
		if location_match then
			--print("location_match",line)
			-- If we are transitioning to a header we need to parse, set the flag
			local cimpath_match,aaa = location_match:match(cimpath_re)
			local cimpath_match2,aaa = location_match:match(cimpath2_re)
			in_cimgui = (cimpath_match ~= nil) or (cimpath_match2 ~= nil)
			break
		end
		
	
	elseif in_cimgui then
	--[[
		-- Windows likes to add __stdcall__ to everything, but it isn't needed and is actually harmful when using under linux.
		-- However, it is needed for callbacks in windows.
		--if line:find("typedef") >= 0  and line.find(" PFNGL") < 0:
		if line:find("typedef") and not line:find(" PFNGL") then
			--line = line:gsub("__attribute__%(%(__stdcall__%)%) ", 'WINDOWS_STDCALL ')
			line = line:gsub('GL_APIENTRY ' , 'WINDOWS_STDCALL ')
		else
			--line = line:gsub("__attribute__%(%(__stdcall__%)%) ", '')
			line = line:gsub('GL_APIENTRY ', '')
		end
		-- While linux likes to add __attribute__((visibility("default"))) 
		line = line:gsub('__attribute__%(%(visibility%("default"%)%)%) ', '')
		line = line:gsub("__attribute__%(%(__stdcall__%)%) ", '')
		--]]
		table.insert(cdefs,line)
	end

until true
end
-- Output the file
	print("--[[ BEGIN AUTOGENERATED SEGMENT ]]")
	print("local cdecl = [[")
	for i,line in ipairs(cdefs) do
		io.write("\t", line,"\n") --, sep="")
	end
	print("\t]]")

	print("--[[ END AUTOGENERATED SEGMENT ]]")
