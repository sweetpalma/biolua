-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Basic sequence interface:
local Object   = require 'biolua.object'
local Sequence = Object:extend {__name = 'Sequence'}


-- Stores sequence during initialization:
function Sequence:__init(sequence)

	-- Storing sequence:
	if not sequence then
		self.sequence = ''
	elseif type(sequence) == 'string' then
		self.sequence = sequence:lower()
	elseif type(sequence) == 'table' then
		if sequence.__proto == self.__proto then
			self.sequence = sequence.sequence
		else
			self.sequence = table.concat(sequence)
		end
	else 
		error('Invalid sequence input: ' .. tostring(sequence), 2) 
	end

end


-- Returns length of current stored sequence:
function Sequence:__len()
	return #self.sequence
end


-- Returns current stored sequence:
function Sequence:__tostring()
	if self.__proto then
		return self.sequence
	else
		return Object.__tostring(self)
	end
end


-- Returns new Sequence made from sum:
function Sequence.__add(one, two)

	-- Concatenating two sequences of same type together:
	if type(one) == 'table' and type(two) == 'table'
		and one.__proto == two.__proto then
			return one.__proto(one.sequence .. two.sequence)

	-- Concatenating with string:
	elseif type(one) == 'string' or type(two) == 'string' then
		if type(one) == 'table' and one.__proto then
			return one.__proto(one.sequence .. two)
		else
			return two.__proto(one .. two.sequence)
		end

	-- Invalid:
	else
		error('Invalid sequence type to couple.', 2)
	end

end


-- Alias to Sequence:__add:
function Sequence.__concat(...)
	return Sequence.__add(...)
end


-- Returns new Sequence, multiplied by N:
function Sequence.__mul(one, two)
	
	if (type(one) == 'table' and type(two) == 'number')
	or (type(two) == 'table' and type(one) == 'number') then

		-- Figuring out the sequence and multiplier:
		local proto, sequence, mul
		if type(one) == 'table' then
			proto, sequence, mul = one.__proto, one.sequence, two
		else
			proto, sequence, mul = two.__proto, two.sequence, one
		end

		-- Done:
		return proto(string.rep(sequence, mul))

	-- Invalid:
	else
		error('Sequence can be multiplied only by integer!', 2)
	end

end


-- Returns result of comparation with another Sequence:
function Sequence.__eq(one, two)
	-- Note: Lua got very odd __eq call condition - read more:
	-- http://lua-users.org/wiki/MetatableEvents
	return one.sequence == two.sequence
end


-- Returns current Sequence item:
function Sequence:__index(key)
	if type(key) == 'number' then
		return self.sequence:sub(key, key)
	end
end


-- Raises error (because sequences are immutable):
function Sequence:__newindex(key, value)
	if type(key) == 'number' then
		error('Sequences are immutable.')
	else
		rawset(self, key, value)
	end
end


-- Returns new Sequence, reverse of current:
function Sequence:reverse()
	return self.__proto(self.sequence:reverse())
end


-- Returns current sequence length:
function Sequence:length()
	return #self.sequence
end


-- Returns new Sequence, subsequence of current:
function Sequence:sub(...)
	return self.__proto(self.sequence:sub(...))
end


-- Returns new Sequence, regulary substituted version of current:
function Sequence:gsub(...)
	return self.__proto(self.sequence:gsub(...))
end


-- Returns result of regular matching:
function Sequence:match(...)
	return self.__proto(self.sequence:match(...))
end


-- Returns regular iterator of current Sequence:
function Sequence:gmatch(...)
	local iter = self.sequence:gmatch(...)
	return function()
		local ns = iter()
		return ns and self.__proto(ns) or nil
	end
end


-- Returns count of some substring in current Sequence:
function Sequence:count(x)
	local n = 0
	for _ in self.sequence:gmatch(x) do
		n = n + 1
	end
return n end


-- Returns base composition of current Sequence:
function Sequence:composition()
	local result = {}
	for base in self.sequence:gmatch('%a') do
		result[base] = (result[base] or 0) + 1
	end
return result end


-- Returns iterator window of defined size and step of current Sequence:
function Sequence:window(size, step)
	if not size then error('No window size is stated!', 2) end
	local step = step or 1
	local i = 1 - step
	return function()
		i = i + step
		local triplet = self:sub(i, i + size - 1)
		if i <= #self.sequence and #triplet == size then
			return triplet
		end
	end
end


-- Returns new Sequence that contains randomized bases of current one:
function Sequence:randomize(seed)

	-- Preparing random generator:
	math.randomseed(seed or os.time())

	-- Preparing keys list:
	local keys, composition = {}, self:composition()
	for key, _ in pairs(composition) do
		table.insert(keys, key)
	end

	-- Randomization:
	local buf = {}
	for i = 1, #self.sequence do
		local base
		repeat
			local random_id = math.random(#keys)
			local key = keys[random_id]
			if composition[key] > 0 then
				composition[key] = composition[key] - 1
				base = key
			end
		until base
		buf[i] = base
	end

	-- Done:
	return self.__proto(table.concat(buf))

end


-- Packing:
return Sequence
