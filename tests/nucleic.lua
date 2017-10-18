-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- BioLua OOP system unit tests:
describe('biolua.sequence.nucleic', function()

	local Nucleic

	it('Successfully imports', function() 
		Nucleic = require 'biolua.sequence.nucleic'
		assert.type('table', Nucleic)
	end)

	it('Successfully detects RNA/DNA type during initializaiotn', function()
		local dna = Nucleic('atgc')
		local rna = Nucleic('augc')
		assert.equal(dna:is_dna(), true)
		assert.equal(rna:is_dna(), false)
		assert.equal(rna:is_rna(), true)
		assert.equal(dna:is_rna(), false)
	end)

	it('Successfully calls :at_percent()', function()
		local sq = Nucleic('atgcatgcaaaa')
		assert.equal(math.floor(sq:at_percent()), 66)
	end)

	it('Successfully calls :gc_percent()', function()
		local sq = Nucleic('atgcatgcaaaa')
		assert.equal(math.floor(sq:gc_percent()), 33)
	end)

	it('Successfully calls :at_skew()', function()
		local sq = Nucleic('atgcatgcaaaa')
		assert.equal(sq:at_skew(), 0.5)
	end)

	it('Successfully calls :gc_skew()', function()
		local sq = Nucleic('atgcatgcaaaa')
		assert.equal(sq:gc_skew(), 0)
	end)

	it('Successfully calls :weight()', function()
		local sq = Nucleic('atgcatgcaaaa')
		assert.equal(math.floor(sq:weight()), 3662)
	end)

	it('Successfully transcripts using :transcript()', function()

		local a = Nucleic('atgc')
		local b = a:transcript()
		assert.equal(b.sequence, 'augc')
		assert.equal(b:is_rna(), true)
		assert.equal(a:is_dna(), true)

		local c = Nucleic('augc')
		local d = c:transcript()
		assert.equal(d.sequence, 'atgc')
		assert.equal(c:is_rna(), true)
		assert.equal(d:is_dna(), true)

	end)

	it('Successfully transcripts using :to_dna() and :to_rna()', function()
		local a = Nucleic('atgc')
		local b = a:to_rna()
		local c = a:to_dna()
		assert.equal(b.sequence, 'augc')
		assert.equal(a.__id, c.__id)
	end)

	it('Successfully calls :complement()', function()
		local a = Nucleic('atgc')
		local b = a:complement()
		assert.equal(b.sequence, 'tacg')
	end)

	it('Successfully calls :illegal()', function()
		assert.equal(Nucleic('atgcatgc'):illegal(), nil)
		assert.type('table', Nucleic('atgcatgch'):illegal())
		assert.equal(Nucleic('atgcatgch'):illegal()[1], 'h')
	end)

	it('Successfully calls :translate()', function()
		assert.equal(Nucleic('atgcatgcaaaa'):translate().sequence, 'mhak')
		assert.equal(Nucleic('atgcatgcaaaa'):translate(2).sequence, 'cmq')
	end)

end)