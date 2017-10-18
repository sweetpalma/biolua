-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Global BioLua tests.
package.path = package.path .. ';../?.lua'
local test = require 'biolua.test'

-- Printing logo:
print(require 'biolua.shell.logo')

-- OOP test:
test 'oop'

-- Sequences test:
test 'sequence'
test 'nucleic'
test 'amino'

-- Parsers test:
test 'fasta'
test 'genbank'
test 'twobit'
