-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Basic DNA/RNA interface:
local Nucleic = require 'biolua.sequence.sequence':extend {__name = 'Nucleic'}
local Rosetta = require 'biolua.sequence.rosetta'
local Amino   = require 'biolua.sequence.amino'


-- Determines the type of NA type during initialization:
function Nucleic:__init(...)
	self.__super.__init(self, ...)
	self.type = self.sequence:find('u') and 'rna' or 'dna'
end


-- RNA typecheck:
function Nucleic:is_rna()
	return self.type == 'rna'
end 


-- DNA typecheck:
function Nucleic:is_dna()
	return self.type == 'dna'
end


-- Returns new RNA based on current NA:
function Nucleic:to_rna()
	if self.type ~= 'rna' then
		return self:transcript()
	else
		return self
	end
end


-- Returns new DNA based on current NA:
function Nucleic:to_dna()
	if self.type ~= 'dna' then
		return self:transcript()
	else
		return self
	end
end


-- Returns AT percent of current NA:
function Nucleic:at_percent()
	local at = self:count('a') + self:count('t')
	return at / #self.sequence * 100
end


-- Returns GC percent of current NA:
function Nucleic:gc_percent()
	local gc = self:count('g') + self:count('c')
	return gc / #self.sequence * 100
end


-- Returns AT skew of current NA:
function Nucleic:at_skew()
	local a, t = self:count('a'), self:count('t')
	return (a - t) / (a + t)
end


-- Returns GC skew of current NA:
function Nucleic:gc_skew()
	local g, c = self:count('g'), self:count('c')
	return (g - c) / (g + c)
end


-- Returns molecular weight of current NA:
function Nucleic:weight()
	local g, c = self:count('g'), self:count('c')
	if self.type == 'dna' then
		local a, t = self:count('a'), self:count('t')
		return 
			(a * 313.21) + (t * 304.2) + (c * 289.18) + (g * 329.21) - 61.96
	else
		local a, u = self:count('a'), self:count('u')
		return 
			(a * 329.21) + (u * 306.17) + (c * 305.18) + (g * 345.21) + 159.0
	end
end


-- Returns new NA with U bases turned to T (or same but backwards):
function Nucleic:transcript()
	if self.type == 'dna' then
		return self.__proto(self.sequence:gsub('t', 'u'))
	else
		return self.__proto(self.sequence:gsub('u', 't'))
	end
end


-- Returns new complementary NA sequence of same type:
function Nucleic:complement(reverse)
	local t, seq
	if self.type == 'dna' then
		t = {a='t', t='a', g='c', c='g'}
	else
		t = {a='u', u='a', g='c', c='g'}
	end
	seq = self.sequence:gsub('%a', t)
	if reverse then seq = seq:reverse() end
return self.__proto(seq) end


-- Returns list of current NA sequence names:
function Nucleic:names()
	local seq, names = self.sequence, {
		a = 'Adenine',
		t = 'Thymine',
		g = 'Guanine',
		c = 'Cytosine'
	}
	local result = {}
	for i = 1, #seq do
		result[i] = names[seq:sub(i, i)]
	end
return result end


-- Returns list of illegal bases of current NA sequence if found:
function Nucleic:illegal()
	local bases, result = {}, {}
	local i = 1
	for ibase in self.sequence:gmatch('[^atgc]') do
		if not bases[ibase] then
			bases[ibase] = true
			result[i] = ibase
			i = i + 1
		end
	end
	if #result > 0 then
		return result
	else
		return nil
	end
end


-- Returns new AA sequence made of current NA sequence:
function Nucleic:translate(frame, translation)
	local frame, codon = frame or 1, Rosetta.amino.codons[translation or 1]
	local t = setmetatable({}, {__index = codon})
	if self.type == 'dna' then
		for key, value in pairs(codon) do
			t[key:gsub('u', 't')] = value
		end
	end
	if frame > 3 then
		frame = frame % 3
	end
	local seq = self.sequence:sub(frame)
	return Amino(seq:gsub('(%a%a%a)', t):sub(1, math.floor(#seq / 3)))
end


-- Visualization:
function Nucleic:visualize(mode)
	
	-- Preparing common values:
	local sequence = self.sequence 
	local complement = self:complement().sequence
	local mode = mode or 'plain'
	
	-- Plain visualisation:
	if mode == 'plain' then
		
		-- Preparing header:
		local result = '\nMain Cmp\n--------\n'

		-- Iterating:
		for i = 1, #sequence do 
			local base_main = sequence:sub(i, i)
			local base_comp = complement:sub(i, i)
			local separator = ' ---- '
			result = result .. base_main .. separator .. base_comp .. '\n'
		end

		-- Drawing:
		return result

	
	-- Invalid mode:
	else
		error('Invalid visualization mode.', 2)
	end

end


-- Packing:
return Nucleic
