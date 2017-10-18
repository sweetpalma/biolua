-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Takes line and env as input, returns evaluation (string, table) -> (string or nil):
local prettystring = require 'biolua.shell.prettystring'
local demo = require 'biolua.shell.demo'
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
return eval
