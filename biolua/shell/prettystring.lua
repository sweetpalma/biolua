-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Pretty string output (any) -> (string):
local function prettystring(input)
	if type(input) == 'table' then

		-- Detecting metatable __tostring:
		local mt = getmetatable(input)
		if mt and mt.__tostring then
			return mt:__tostring()
		end

		-- Preparing output:
		local output = '{'

		-- Iterating over:
		for key, value in pairs(input) do

			-- Concatenating number-indexed items:
			if type(key) == 'number' then
				output = output .. prettystring(value)

			-- Concatenating other typed keys:
			else
				output = output.. tostring(key).. ' = ' .. prettystring(value)
			end

			-- Adding trailing comma:
			output = output .. ', '

		end

		-- Cutting trailing comma for the last item and returning:
		if output ~= '{' then 
			output = output:sub(1, -3) 
		end
		return output .. '}'


	-- Wrapping other types:
	elseif type(input) == 'string' then
		if input:find('\n') then
			return '[[' .. '\n' .. input .. ']]'
		else
			return '"' .. input .. '"'
		end
	else return tostring(input) end
end


-- Packing:
return prettystring
