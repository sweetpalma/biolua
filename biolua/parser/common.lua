-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Common parser interface:
local Parser  = (require 'biolua.object'):extend {__name = 'Parser'}
local Nucleic = require 'biolua.sequence.nucleic'
local Amino   = require 'biolua.sequence.amino'


-- Loads file pointer as reader:
function Parser:read(name, mode)

	-- Closing file is present:
	if self.file then
		self.file:close()
	end

	-- Checking name:
	if not name then
		error('No file name stated.', 2)
	end

	-- Storing direct userdata:
	if type(name) == 'userdata' then
		self.file = name

	-- Loading file:
	else
		self.file = io.open(name, mode or 'r')
		if not self.file then
			error('File is not found.', 2)
		end
	end

return self end


-- Loads file pointer as writer:
function Parser:write(name)

	-- Closing file is present:
	if self.file then
		self.file:close()
	end

	-- Checking name:
	if not name then
		error('No file name stated.', 2)
	end

	-- Storing direct userdata:
	if type(name) == 'userdata' then
		self.file = name

	-- Loading file:
	else
		self.file = io.open(name, 'w')
	end
	
return self end


-- Interface for nucleic acids:
function Parser:nucleic(sequence)
	if sequence then
		self.sequence = sequence.sequence
		return self
	else
		return Nucleic(self.sequence)
	end
end


-- Interface for amino acids:
function Parser:amino(sequence)
	if sequence then
		self.sequence = sequence.sequence
		return self
	else
		return Amino(self.sequence)
	end
end


-- Packing:
return Parser
