-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- 2bit parser interface:
local Parser = (require 'biolua.parser.parser'):extend {__name = 'Twobit'}


-- Internal: Turn list of bytes to int:
function bytes_to_int(b1, b2, b3, b4)
	local n = (b1) + (b2 * 256) + (b3 * 65536) + (b4 * 16777216)
	n = (n > 2147483647) and (n - 4294967296) or n
	return n
end


-- Internal: Reading integer from file pointer:
function read_integer(f)
	local bytes = f:read(4)
	return bytes_to_int(bytes:byte(1, 4))
end


-- Internal: Connecting bitwise operations:
local band, lshift, rshift
if type(jit) == 'table' then
	band, lshift, rshift = bit.band, bit.lshift, bit.rshift
elseif type(bit32) == 'table' then
	band, lshift, rshift = bit32.band, bit32.lshift, bit32.rshift
else
	band = function(a, b)
		local r, m, s = 0, 2^52
		local oper = 4
		repeat
			s, a, b = a + b + m, a % m, b % m
			r, m = r + m * oper % (s - a - b), m / 2
		until m < 1
		return r
	end
	lshift = function(a, b)
		return a * (2 ^ b)
	end
	rshift = function(a, b)
		return math.floor(a / (2 ^ b))
	end
end


-- Reading from file:
function Parser:read(name)
	
	-- Preparing file:
	self.__super.read(self, name, 'rb')
	local file = self.file

	-- Checking signature and version
	if read_integer(file) ~= 0x1A412743 then
		error('Error while reading ' .. name .. ': invalid 2bit signature.', 2)
	end
	if read_integer(file) ~= 0 then
		error('Error while reading ' .. name .. ': unsupported version.', 2)
	end

	-- Reading sequence count and reserved zero:
	local sequence_count = read_integer(file)
	if read_integer(file) ~= 0 then
		error('Error while reading ' .. name .. ': no reserved zero.', 2)
	end

	-- Reading sequences index:
	local index = {}
	for i = 1, sequence_count do
		local name_size = file:read(1):byte(1)
		local name = file:read(name_size)
		local offset = read_integer(file)
		index[name] = offset
	end
	self.index = index

return self end


-- Reading chromosome:
function Parser:chr(name, start, finish)

	-- Validating:
	if not name then
		error('No name stated.', 2)
	end
	if not self.index[name] then
		error('Entry with name ' .. name .. ' is not found.', 2)
	end
	if start and start < 1 then
		error('Invalid start argument - it must be greater than 0.', 2)
	end

	-- Seeking start:
	local file = self.file
	file:seek('set', self.index[name])

	-- Locals for speed-ups:
	local byte = string.byte
	
	-- Reading DNA size:
	local dna_size = read_integer(file)

	-- Reading unknown blocks positions and sizes:
	local n_blocks = read_integer(file)
	local n_blocks_pos, n_blocks_szs = {}, {}
	for i = 1, n_blocks do 
		n_blocks_pos[i] = read_integer(file)
	end
	for i = 1, n_blocks do
		n_blocks_szs[i] = read_integer(file)
	end

	-- Skipping known blocks positions:
	local k_blocks = read_integer(file)
	file:seek('cur', k_blocks * 2 * 4)
	
	-- Validating reserved sequence:
	local start, finish = start or 1, finish or dna_size
	if read_integer(file) ~= 0 then
		error('No reserved zero.')
	end

	-- Validating finish and seeking start:
	if finish > dna_size then
		error('Invalid finish argument - must be less than DNA size: ' .. dna_size, 2)
	end
	if start > dna_size then
		error('Invalid start argument - must be less than DNA size: ' .. dna_size, 2)
	end
	file:seek('cur', math.floor(start / 4) - 1)

	-- Reading bases:
	local t, buf = {[0] = 't', [1] = 'c', [2] = 'a', [3] = 'g'}, {}
	for i = (math.floor(start / 4) - 1) * 4, finish + 3, 4 do
		
		-- Reading package:
		local four_pack = byte(file:read(1))

		-- Extracting:
		for j = 1, 4 do
			if j + i >= start and i + j <= finish then
				local mask = lshift(1, 2) - 1
				local base = band(rshift(four_pack, 8 - (j * 2)), mask)
				buf[i + j - start + 1] = t[base]
			end
		end

	end

	-- Filling in unknown blocks:
	local i = 1
	while n_blocks_pos[i] and n_blocks_pos[i] <= finish do
		for j = n_blocks_pos[i], n_blocks_pos[i] + n_blocks_szs[i] do
			if j >= start and j <= finish then
				buf[j - start + 1] = 'n'
			end
		end
		i = i + 1
	end

	-- Storing:
	self.definition = name
	self.sequence = table.concat(buf)
	self.start = start
	self.finish = finish

return self end


-- Writing to file:
function Parser:write(name)
	error('2bit writing is not yet implemented.', 2)
return self end


-- 2bit has no interface to amino:
function Parser:amino(sequence)
	error('2bit doesn`t have amino acid interface.', 2)
end


-- Packing:
return Parser
