-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Main BioLua Shell caller:
local L_loaded, L  = pcall(require, 'linenoise')
local demo = require 'biolua.shell.demo'


-- Internal: Read line (using wrapped Linenoise or default IO) and return result:
local function readline(prompt)

	-- Fallback to standard io.read():
	if not L_loaded then
		io.write(prompt)
		return io.read()

	-- Using Linenoise:
	else
		local line = L.linenoise(prompt) or ''
		line = line:gsub('^%s+', ''):gsub('%s+$', '')
		if #line > 0 then
			L.historyadd(line)
		end
		return line
	end

end


-- Internal: Turn tables into human-readable string, then return:
local function prettystring(input)
	if type(input) == 'table' then

		-- Honoring metatable __tostring:
		local mt = getmetatable(input)
		if mt and mt.__tostring then
			return mt:__tostring()
		end

		-- Preparing output string:
		local output = '{'

		-- Iterating over:
		for key, value in pairs(input) do

			-- Concatenating number-indexed items:
			if type(key) == 'number' then
				output = output .. prettystring(value)

			-- Concatenating non-number-indexed items:
			else
				output = output.. tostring(key).. ' = ' .. prettystring(value)
			end

			-- Adding trailing comma:
			output = output .. ', '

		end

		-- Cutting trailing comma from the last item and returning:
		if output ~= '{' then 
			output = output:sub(1, -3) 
		end
		return output .. '}'


	-- Wrapping other types:
	elseif type(input) == 'string' then

		-- Multi-line strings:
		if input:find('\n') then
			return '[[' .. '\n' .. input .. ']]'

		-- Single-line strings:
		else
			return '"' .. input .. '"'
		end

	else return tostring(input) end
end


-- Internal: Take uncomplete line, try to autocomplete it and return:
local function autocomplete(line, env)
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


-- Internal: Evaluate line, return textual result (error or value):
local function eval(line, env)

	-- Stripping unwanted spaces:
	line = line:gsub('^%s+', ''):gsub('%s+$', '')

	-- Executing OS command:
	if line:sub(1, 1) == '$' then
		os.execute(line:sub(2))

	-- Exiting:
	elseif line == 'exit' then
		os.exit()

	-- Short help:
	elseif line == 'help' then
		return '\nFull documentation is available at:\n' ..
			'https://sweetpalma.github.io/biolua'

	-- Running demo:
	elseif line == 'demo' then
		demo(eval, env)

	-- Executing Lua code:
	else

		-- Trying to execute it as a return expression:
		local chunk, err = load('return ' .. line, 'shell', nil, env)
		local is_rexp = true

		-- If not return expression - load it normally:
		if not chunk then
			chunk, err = load(line, 'shell', nil, env)
			is_rexp = false
			if not chunk then
				return err
			end
		end

		-- Executing code:
		local is_ok, result = pcall(chunk)
		if (is_rexp and line ~= '') or result then
			if is_ok then
				result = prettystring(result)
			end
			return result
		end

	end
	
end


-- Packing:
return function()

	-- Cleaning screen:
	if L_loaded then L.clearscreen() end

	-- Printing logo:
	print(require 'biolua.shell.logo')

	-- Notyfying about Linenoise:
	if not L_loaded then
		print('Linenoise is not found, autocomplete and history not available.')
		print('You can intall it using "luarocks install linenoise".')
		print()
	end

	-- Preparing environment:
	local env = setmetatable({
		biolua = require 'biolua.init'
	}, {__index = _G})

	-- Preparing autocompletion:
	if L_loaded then 
		L.setcompletion(function(c, line)
			local result = autocomplete(line, env)
			for i = 1, #result do
				L.addcompletion(c, result[i])
			end
		end) 
	end

	-- Disabling buffer:
	io.stdout:setvbuf('no')

	-- Running loop:
	local running = true
	while running do

		-- Reading line and interpreting it:
		local line = readline('biolua> ')
		local result = eval(line, env)

		-- Output:
		if result then print(result) end
		pcall(print)

	end

end