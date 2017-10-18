-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Main BioLua Shell caller:
local L_loaded, L  = pcall(require, 'linenoise')
local autocomplete = require 'biolua.shell.autocomplete'
local eval         = require 'biolua.shell.eval'


-- Internal: Wrapped line noise:
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


-- Internal: Shell loop:
local function shell(env)

	-- Preparing environment:
	local env = env or setmetatable({
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

	-- Running shell loop:
	shell()

end