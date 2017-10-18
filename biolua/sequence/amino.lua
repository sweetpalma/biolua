-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Basic DNA/RNA interface:
local Amino = require 'biolua.sequence.sequence':extend {__name = 'Amino'}
local Rosetta = require 'biolua.sequence.rosetta'


-- Returns molecular weight of current AA sequence:
function Amino:weight()
	local t, result = Rosetta.amino.weights, 0
	for base in self.sequence:gmatch('%a') do
		result = result + (t[base] or 0)
	end
	result = result - 18.015 * (#self.sequence - 1)
return result end


-- Returns list of base codes of current AA sequence:
function Amino:codes()
	local t, result = Rosetta.amino.codes, {}
	local i = 1
	for base in self.sequence:gmatch('%a') do
		result[i] = t[base]
		i = i + 1
	end
return result end


-- Returns list of base names of current AA sequence:
function Amino:names()
	local t, result = Rosetta.amino.names, {}
	local i = 1
	for base in self.sequence:gmatch('%a') do
		result[i] = t[base]
		i = i + 1
	end
return result end


-- Returns list of illegal bases of current AA sequence if found:
function Amino:illegal()
	local bases, result = {}, {}
	local i = 1
	for ibase in self.sequence:gmatch('[^flimvsptayhqnkdecwrg]') do
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


-- Packing:
return Amino
