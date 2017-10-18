-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Takes line and env as input, returns autocomplete list (string, table) -> (list):
return function(line, env)
	local result = {}
	for _, container in ipairs({env, getmetatable(env).__index}) do

		-- Trying to match globals:
		local gvalue = line:match(' ([%a%d_]+)$')
		gvalue = gvalue or line:match('^([%a%d_]+)$')
		if gvalue then
			for key, value in pairs(container) do
				if key:lower():match('^' .. gvalue:lower()) then
					result[#result + 1] = line:gsub(gvalue, key)
				end
			end
		end

		-- Trying to match table fields:
		local tvalue = line:match('([%a%d_%.]+[%.:][%a%d_]*)$')
		if tvalue then

			-- Determining last separator (. or :):
			local last_separator = line:reverse():match('([%.:])')
			
			-- Splitting keys by separator:
			local keys = {}
			for key in tvalue:gmatch('([^.:]+)') do
				table.insert(keys, key)
			end

			-- Adding dummy key:
			if tvalue:sub(-1):match('[%.:]') then
				table.insert(keys, '')
			end

			-- Traversing to the last possible layer:
			local t = container[keys[1]]
			if t then
				for i = 2, #keys - 1 do
					if t then
						t = t[keys[i]]
					end
				end
			end

			-- Picking right key:
			local possibilities = {}
			for key, value in pairs(t or {}) do
				if key:lower():match('^' .. keys[#keys]:lower()) then
					if last_separator ~= ':' or type(value) == 'function' then
						table.insert(possibilities, key)
					end
				end
			end

			-- Adding to completion:
			for _, possibility in ipairs(possibilities) do
				local comp = keys[1]
				for i = 2, #keys - 1 do
					comp = comp .. '.' .. keys[i]
				end
				comp = comp .. last_separator .. possibility
				result[#result + 1] = line:gsub(tvalue, comp)
			end

		end
		
	end
return result end