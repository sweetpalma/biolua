-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- BioLua Test Suite:
local debug, os = debug, os
local clock, format = os.clock, string.format


-- Description:
local function describe(desc, method)

	-- Checking caller:
	if debug.getinfo(4).func == describe then
		error('Nested descriptions are not supported yet.', 2)
	end

	-- Validating input:
	if not desc then
		error('First argument (description) is missing.', 2)
	elseif not method or type(method) ~= 'function' then
		error('Description should contain test function as second argument.', 2)
	end

	-- Printing header:
	local caption_category = 'Unit: ' .. desc
	print(caption_category)
	print(string.rep('-', #caption_category), '\n')

	-- Running tests:
	local is_ok, result = pcall(method)

	-- Validating result:
	if not is_ok then
		print('- Failed on: \n\t' .. result, '\n\n')
	else print '' end
	
end


-- Suite:
local function it(desc, method)

	-- Checking caller:
	if debug.getinfo(4).func ~= describe then
		error('Tests can be called only from a description wrapper.', 2)
	end

	-- Validating input:
	if not desc then
		error('First argument (description) is missing.', 2)
	elseif not method or type(method) ~= 'function' then
		print('Pending      \t' .. desc)
		return
	end

	-- Testing method:
	local time_start = clock()
	local is_ok, result = pcall(method)
	if is_ok then
		local time_passed = (clock() - time_start) * 1000
		local time_stamp = string.format('(%.3f ms) ', time_passed)
		print('+ ' .. time_stamp .. '\t' .. desc)
	else error(result, 2) end

end


-- Setfenv for Lua 5.2-5.3:
local setfenv = setfenv
if not setfenv then
	setfenv = function(f, env)
		return load(string.dump(f), nil, nil, env)
	end
end


-- Assert:
local apfx   = 'Assertion failed: '
local assert = {}


-- Assert: Equality:
function assert.equal(one, two)
	if one ~= two then
		if type(one) == 'string' then one = '"' .. one .. '"' end
		if type(two) == 'string' then two = '"' .. two .. '"' end
		error(apfx .. 'expected ' .. tostring(one) .. ' to be equal with ' .. tostring(two), 2)
	end
end


-- Assert: Unequality:
function assert.unequal(one, two)
	if one == two then
		if type(one) == 'string' then one = '"' .. one .. '"' end
		if type(two) == 'string' then two = '"' .. two .. '"' end
		error(apfx .. 'expected ' .. tostring(one) .. ' to be unequal with' .. tostring(two), 2)
	end
end


-- Assert: Error:
function assert.error(method)
	if type(method) ~= 'function' then
		error(apfx .. 'argument is not a function!', 2)
	end
	local is_ok, result = pcall(method)
	if is_ok then
		error(apfx .. 'expected error, got none', 2)
	end
end


-- Assert: Typechecks:
function assert.type(t, arg)
	local rt = type(arg)
	if type(arg) == 'string' then arg = '"' .. arg .. '"' end
	if rt ~= t then
		error(apfx .. tostring(arg) .. ' type is ' .. rt .. ', expected ' .. tostring(t), 2)
	end
end


-- Assert: Nil check:
function assert.exists(arg)
	if arg == nil then
		error(apfx .. ' argument is nil', 2)
	end
end


-- Assert: Simple call:
setmetatable(assert, {
	__call = function(_, condition)
		if not condition then
			error(apfx .. ' assertion failed', 2)
		end
	end
})


-- Internal: Loading function as a test unit:
local function test_function(f)

	-- Applying proper environment:
	local f = setfenv(f, 
		setmetatable({
			describe = describe,
			it       = it,
			assert   = assert,
		}, {__index = _G}))

	-- Running and testing:
	local is_ok, result = pcall(f)
	if not is_ok then
		error('Test unit execution error: ' .. tostring(result), 2)
	else return result end

return is_ok end


-- Internal: Loading module as a test unit:
local function test_module(path)

	-- Adding path extension:
	if path:sub(-4, -1) ~= '.lua' then
		path = path .. '.lua'
	end

	-- Testing file existance:
	local file = io.open(path, 'r')
	if not file then
		error('Test unit ' .. path .. ' doesn`t exist.', 2)
	else file:close() end

	-- Loading chunk:
	local chunk, err = loadfile(path)
	if not chunk then
		error('Test unit loading error: ' .. err, 2)
	end

	-- Testing it:
	return test_function(chunk)

end


-- Internal: Loading function or module unit:
local function test(input)
	if type(input) == 'function' then
		return test_function(input)
	elseif type(input) == 'string' then
		return test_module(input)
	else
		error('Invalid input type.', 2)
	end
end


-- Packing into callable meta-table:
return setmetatable({
	describe = describe,
	it       = it,
	assert   = assert,
	unit     = test,
}, {__call = function(self, ...)
	return test(...)
end})
