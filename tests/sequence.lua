-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- BioLua OOP system unit tests:
describe('biolua.sequence.sequence', function()

	local Sequence

	it('Successfully imports', function() 
		Sequence = require 'biolua.sequence.sequence'
		assert.type('table', Sequence)
	end)

	it('Successfully creates empty Sequence', function()
		local sq = Sequence()
		assert.equal(sq.sequence, '')
	end)

	it('Successfully creates Sequence using string', function()
		local sq = Sequence('ATGCATCAT')
		assert.equal(sq.sequence, 'atgcatcat')
	end)

	it('Successfully creates Sequence using list', function()
		local sq = Sequence({'a', 't', 'g', 'c', 'a', 't', 'c', 'a', 't'})
		assert.equal(sq.sequence, 'atgcatcat')
	end)

	it('Successfully creates Sequence using other Sequence', function()
		local a = Sequence('atgcatcat')
		local b = Sequence(a)
		assert.equal(b.sequence, 'atgcatcat')
	end)

	it('Fails to create Sequence using any other type', function()
		assert.error(function()
			Sequence(function() end)
		end)
		assert.error(function()
			Sequence(1)
		end)
	end)

	it('Successfully returns length of Sequence using :length()', function()
		local sq = Sequence('ATGCATCAT')
		assert.equal(sq:length(), 9)
	end)

	it('Successfully returns length of Sequence using __len (only for Lua 5.2)', function()
		local sq = Sequence('ATGCATCAT')
		if not jit then -- LutJIT issues.
			assert.equal(#sq, 9)
		end
	end)

	it('Successfully returns sequence using __tostring', function()
		local sq = Sequence('ATGCATCAT')
		assert.equal(tostring(sq), 'atgcatcat')
	end)

	it('Successfully sums with string', function()
		local a = Sequence('ATGCAT') + 'CAT'
		local b = 'ATG' + Sequence('CATCAT')
		assert.equal(a.sequence, 'atgcatcat')
		assert.equal(b.sequence, 'atgcatcat')
	end)

	it('Successfully sums with another Sequence', function()
		local a = Sequence('ATGCAT') + Sequence('CAT')
		local b = Sequence('ATG') + Sequence('CATCAT')
		assert.equal(a.sequence, 'atgcatcat')
		assert.equal(b.sequence, 'atgcatcat')
	end)

	it('Fails to sum with any other type', function()
		assert.error(function()
			local a = Sequence() + 1
		end)
	end)

	it('Successfully multiplies by a number', function()
		local a, b = Sequence('cat'), 5
		assert.equal(tostring(a * b), 'catcatcatcatcat')
		assert.equal(tostring(b * a), 'catcatcatcatcat')
	end)

	it('Fails to multiply by any other type', function()
		assert.error(function()
			local s = Sequence('atgc') * 'k'
		end)
	end)

	it('Successfully compares two Sequences', function()
		assert.equal(Sequence('atgc') == Sequence('atgc'), true)
		assert.equal(Sequence('atgc') ~= Sequence('ataa'), true)
	end)

	it('Successfully indexes Sequence', function()
		assert.equal(Sequence('atgc')[1] == 'a', true)
		assert.equal(Sequence('atgc')[2] == 't', true)
		assert.equal(Sequence('atgc')[3] == 'g', true)
		assert.equal(Sequence('atgc')[4] == 'c', true)
	end)

	it('Fails to modify Sequence (they are immutable)', function()
		local s = Sequence('atgc')
		assert.error(function()
			s[1] = 't'
		end)
	end)

	it('Successfully calls :reverse() for Sequence', function()
		local s = Sequence('atgcatcat')
		assert.equal(tostring(s:reverse()), 'tactacgta')
	end)

	it('Successfully calls :sub() for Sequence', function()
		local s = Sequence('atgcatcat')
		assert.equal(tostring(s:sub(1, 3)), 'atg')
		assert.equal(tostring(s:sub(-3, -1)), 'cat')
		assert.equal(tostring(s:sub(1, 1)), 'a')
	end)

	it('Successfully calls :gsub() for Sequence', function()
		local s = Sequence('atgcatcat')
		assert.equal(tostring(s:gsub('cat', 'tac')), 'atgtactac')
	end)

	it('Successfully calls :count() for Sequence', function()
		local s = Sequence('atgcatcat')
		assert.equal(s:count('a'), 3)
		assert.equal(s:count('cat'), 2)
	end)

	it('Successfully calls :composition() for Sequence', function()
		local c = Sequence('atgcatcat'):composition()
		assert.equal(c['a'], 3)
		assert.equal(c['t'], 3)
		assert.equal(c['g'], 1)
		assert.equal(c['c'], 2)
	end)

end)