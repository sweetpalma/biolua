-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- BioLua OOP system unit tests:
describe('biolua.sequence.amino', function()

	local Amino

	it('Successfully imports', function() 
		Amino = require 'biolua.sequence.amino'
		assert.type('table', Amino)
	end)

	it('Successfully calculates Amino sequence weight', function() 
		local s = Amino 'FLIMVSPTAYHQNKDECWRG'
		assert.equal(math.floor(s:weight()), 2395)
	end)

	it('Successfully outputs Amino sequence codes', function() 
		local s = Amino 'FLIMVSPTAYHQNKDECWRG'
		local b = {'Phe', 'Leu', 'Ile', 'Met', 'Val', 'Ser', 'Pro', 'Thr', 'Ala', 'Tyr', 'His', 'Gln', 'Asn', 'Lys', 'Asp', 'Glu', 'Cys', 'Trp', 'Arg', 'Gly'}
		for index, value in ipairs(s:codes()) do
			assert.equal(value, b[index])
		end
	end)

	it('Successfully outputs Amino sequence names', function() 

	end)

	it('Successfully outputs Amino sequence illegal bases', function() 

	end)

end)