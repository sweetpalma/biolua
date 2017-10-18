-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Fasta parser unit-tests:
describe('biolua.parser.fasta', function() 

	local Fasta, fasta

	it('Successfully imports', function() 
		Fasta = require 'biolua.parser.fasta'
		assert.type('table', Fasta)
	end)

	it('Successfully performs initialization', function() 
		fasta = Fasta()
		assert.type('table', fasta)
	end)

	it('Fails to call :read() without arguments', function()
		assert.error(function()
			fasta:read(nil)
		end)
	end)

	it('Fails to call :read() with nonexistent file', function()
		assert.error(function()
			fasta:read('some_weird_file.fasta')
		end)
	end)

	it('Fails to call :read() for invalid FASTA file', function()
		assert.error(function() 
			fasta:read('data/input.gb')
		end)
	end)

	it('Fails to call :read() for empty FASTA file', function()
		local tmp = io.tmpfile()
		assert.error(function()
			fasta:read(tmp)
		end)
	end)

	it('Successfully calls :read() for a valid FASTA file', function()
		fasta:read('data/input.fasta')
		assert.equal(fasta.definition, 'gi|398365175|ref|NP_009718.3| Cdc28p [Saccharomyces cerevisiae S288c]')
		assert.equal(fasta.sequence, 'msgelanykrlekvgegtygvvykaldlrpgqgqrvvalkkirlesedegvpstaireisllkelkddnivrlydivhsdahklylvfefldldlkrymegipkdqplgadivkkfmmqlckgiaychshrilhrdlkpqnllinkdgnlklgdfglarafgvplraytheivtlwyrapevllggkqystgvdtwsigcifaemcnrkpifsgdseidqifkifrvlgtpneaiwpdivylpdfkpsfpqwrrkdlsqvvpsldprgidlldkllaydpinrisarraaihpyfqes')
	end)

	it('Successfully calls :read() for a file pointer', function()

		-- Preparing TMP file:
		local tmp = io.tmpfile()
		tmp:write('>some file\n')
		tmp:write('atgcatcattac')
		tmp:seek('set', 0)

		-- Reading and asserting:
		fasta:read(tmp)
		assert.equal(fasta.definition, 'some file')
		assert.equal(fasta.sequence, 'atgcatcattac')

	end)

	it('Successfully calls :write() for a file pointer', function()

		-- Writing:
		local tmp = io.tmpfile()
		fasta:write(tmp)

		-- Reading and asserting:
		tmp:seek('set', 0)
		assert.equal(tmp:read(), '>some file')
		assert.equal(tmp:read(), 'ATGCATCATTAC')

	end)

	it('Successfully turns sequence to a Amino object', function()
		local Amino = require 'biolua.sequence.amino'
		local aa = fasta:amino()
		assert.equal(fasta.sequence, aa.sequence)
		assert.equal(aa:is(Amino), true)
		assert.equal(aa:is(Nucleic), false)
	end)

	it('Successfully turns sequence to a Nucleic object', function()
		local Nucleic = require 'biolua.sequence.nucleic'
		local na = fasta:nucleic()
		assert.equal(fasta.sequence, na.sequence)
		assert.equal(na:is(Nucleic), true)
		assert.equal(na:is(Amino), false)
	end)

end)