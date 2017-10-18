-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Common import tree:
return {
	object = require 'biolua.object',
	test   = require 'biolua.test',
	sequence = {
		Nucleic = require 'biolua.sequence.nucleic',
		Amino   = require 'biolua.sequence.amino'
	},
	parser = {
		Fasta   = require 'biolua.parser.fasta',
		Genbank = require 'biolua.parser.genbank',
		Twobit  = require 'biolua.parser.twobit'
	}
}