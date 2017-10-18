-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Genbank parser unit-tests:
describe('biolua.parser.genbank', function() 

	local Genbank, genbank

	it('Successfully imports', function() 
		Genbank = require 'biolua.parser.genbank'
		assert.type('table', Genbank)
	end)

	it('Successfully performs initialization', function() 
		genbank = Genbank()
		assert.type('table', genbank)
	end)

	it('Fails to call :read() without arguments', function()
		assert.error(function()
			genbank:read(nil)
		end)
	end)

	it('Fails to call :read() for invalid Genbank file', function()
		assert.error(function()
			genbank:read('data/input.fasta')
		end)
	end)

	it('Fails to call :read() with nonexistent file', function()
		assert.error(function()
			genbank:read('some_weird_file.gb')
		end)
	end)

	it('Fails to call :read() for empty Genbank file', function()
		local tmp = io.tmpfile()
		assert.error(function()
			genbank:read(tmp)
		end)
	end)

	it('Successfully calls :read() for a valid Genbank file', function()
		genbank:read('data/input.gb')
	end)

	it('Successfully reads SEQUENCE', function()
		assert.equal(genbank.sequence, 'mrtpmllallalatlclagradakpgdaesgkgaafvskqegsevvkrlrryldhwlgapapypdplepkrevcelnpdcdeladhigfqeayrrfygpv')
	end)

	it('Successfully reads LOCUS', function()
		assert.equal(genbank.locus, 'CAA35997                 100 aa            linear   MAM 12-SEP-1993')
	end)

	it('Successfully reads DEFINITION', function()
		assert.equal(genbank.definition, 'unnamed protein product [Bos taurus].')
	end)

	it('Successfully reads ACCESSION', function()
		assert.equal(genbank.accession, 'CAA35997')
	end)

	it('Successfully reads COMMENT', function()
		local c = [[See <X15699> for Human sequence.
Data kindly reviewed (08-MAY-1990) by Kiefer M.C.]]
		assert.equal(genbank.comment, c)
	end)

	it('Successfully reads REFERENCE list', function()
		local b = {
			{
				authors = 'Kiefer,M.C., Saphire,A.C.S., Bauer,D.M. and Barr,P.J.',
				journal = 'Unpublished'
			},
			{
				authors = 'Kiefer,M.C.',
				journal = 'Submitted (30-JAN-1990) Kiefer M.C., Chiron Corporation, 4560 Hortom St, Emeryville CA 94608-2916, U S A'
			}
		}
		for index, value in ipairs(genbank.reference) do
			assert.equal(value.authors, b[index].authors)
			assert.equal(value.journal, b[index].journal)
		end
	end)

	it('Successfully turns sequence to a Amino object', function()
		local Amino = require 'biolua.sequence.amino'
		local aa = genbank:amino()
		assert.equal(genbank.sequence, aa.sequence)
		assert.equal(aa:is(Amino), true)
		assert.equal(aa:is(Nucleic), false)
	end)

	it('Successfully turns sequence to a Nucleic object', function()
		local Nucleic = require 'biolua.sequence.nucleic'
		local na = genbank:nucleic()
		assert.equal(genbank.sequence, na.sequence)
		assert.equal(na:is(Nucleic), true)
		assert.equal(na:is(Amino), false)
	end)

end)