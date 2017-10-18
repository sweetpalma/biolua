-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Genbank parser unit-tests:
describe('biolua.parser.twobit', function() 

	local Twobit

	it('Successfully imports', function() 
		Twobit = require 'biolua.parser.twobit'
		assert.type('table', Twobit)
	end)

	it('Successfully performs initialization', function() 
		twobit = Twobit()
		assert.type('table', twobit)
	end)

	it('Fails to call :read() without arguments', function()
		assert.error(function()
			twobit:read(nil)
		end)
	end)

	it('Fails to call :read() for invalid Genbank file', function()
		assert.error(function()
			twobit:read('data/input.fasta')
		end)
	end)

	it('Fails to call :read() with nonexistent file', function()
		assert.error(function()
			twobit:read('some_weird_file.gb')
		end)
	end)

	it('Fails to call :read() for empty Genbank file', function()
		local tmp = io.tmpfile()
		assert.error(function()
			twobit:read(tmp)
		end)
	end)

	-- Futher tests are not yet done because I didn't have appropriate small 2bit file yet:
	
	it('Successfully calls :read() for a valid 2bit file')

	it('Successfully calls :chr() for a valid chromosome')

	it('Fails to call :chr() for a non-valid chromosome')

	it('Successfully reads chromosome definition')

	it('Successfully reads chromosome sequence')

	it('Successfully reads chromosome start')

	it('Successfully reads chromosome finish')

	it('Fails to turn sequence into a Amino object')

	it('Successfully turns sequence to a Nucleic object')

end)