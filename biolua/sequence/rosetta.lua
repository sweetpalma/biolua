-- Part of BioLua by SweetPalma, 2017. All righus reserved.
-- Rosetta translation table for sequences:

-- Standard translation table, used by extensions:
local standard_codons = {

	uuu = 'f',
	uuc = 'f',
	uua = 'l',
	uug = 'l',
	cuu = 'l',
	cuc = 'l',
	cua = 'l',
	cug = 'l',
	auu = 'i',
	auc = 'i',
	aua = 'i',
	aug = 'm',
	guu = 'v',
	guc = 'v',
	gua = 'v',
	gug = 'v',

	ucu = 's',
	ucc = 's',
	uca = 's',
	ucg = 's',
	ccu = 'p',
	ccc = 'p',
	cca = 'p',
	ccg = 'p',
	acu = 'u',
	acc = 'u',
	aca = 'u',
	acg = 'u',
	gcu = 'a',
	gcc = 'a',
	gca = 'a',
	gcg = 'a',

	uau = 'y',
	uac = 'y',
	uaa = '*',
	uag = '*',
	cau = 'h',
	cac = 'h',
	caa = 'q',
	cag = 'q',
	aau = 'n',
	aac = 'n',
	aaa = 'k',
	aag = 'k',
	gau = 'd',
	gac = 'd',
	gaa = 'e',
	gag = 'e',

	ugu = 'c',
	ugc = 'c',
	uga = '*',
	ugg = 'w',
	cgu = 'r',
	cgc = 'r',
	cga = 'r',
	cgg = 'r',
	agu = 's',
	agc = 's',
	aga = 'r',
	agg = 'r',
	ggu = 'g',
	ggc = 'g',
	gga = 'g',
	ggg = 'g',

}


-- Extending standart codon table:
local function extended_codons(args) 
	local copy = {}
	for key, value in pairs(standard_codons) do
		copy[key] = value
	end
	for key, value in pairs(args) do
		copy[key] = value
	end
return copy end


-- Packing:
return {
	
	amino = {

		codons = {

			-- Standard:
			[1] = standard_codons,

			[2] = extended_codons {
				aga = '*',
				agg = '*',
				aua = 'm',
				uga = 'w',
			},

			[3] = extended_codons {
				aua = 'm',
				cuu = 't',
				cuc = 't',
				cua = 't',
				cug = 't',
				uga = 'w',
				cga = '',
				cgc = '',
			},

		},

		names = {

			f = 'Phenylalanine',
			l = 'Leucine',
			i = 'Isoleucine',
			m = 'Methionine',
			v = 'Valine',
			s = 'Serine',
			p = 'Proline',
			t = 'Threonine',
			a = 'Alanine',
			y = 'Tyrosine',
			h = 'Histidine',
			q = 'Glutamine',
			n = 'Asparagine',
			k = 'Lysine',
			d = 'Aspartate',
			e = 'Glutamate',
			c = 'Cysteine',
			w = 'Tryptophan',
			r = 'Arginine',
			g = 'Glycine',

		},

		codes = {

			f = 'Phe',
			l = 'Leu',
			i = 'Ile',
			m = 'Met',
			v = 'Val',
			s = 'Ser',
			p = 'Pro',
			t = 'Thr',
			a = 'Ala',
			y = 'Tyr',
			h = 'His',
			q = 'Gln',
			n = 'Asn',
			k = 'Lys',
			d = 'Asp',
			e = 'Glu',
			c = 'Cys',
			w = 'Trp',
			r = 'Arg',
			g = 'Gly',

		},

		weights = {

			-- Normal aminoacids:
			f = 165.1900,
			l = 131.1736,
			i = 131.1736,
			m = 149.2124,
			v = 117.1469,
			s = 105.0930,
			p = 115.1310,
			t = 119.1197,
			a = 89.0935,
			y = 181.1894,
			h = 155.1552,
			q = 146.1451,
			n = 132.1184,
			k = 146.1882,
			d = 133.1032,
			e = 147.1299,
			c = 121.1590,
			w = 204.2262,
			r = 174.2017,
			g = 75.0669,

			-- Unusual:
			u = 168.07, -- Selenocysteine
			x = 110,    -- Any amino acid

		}

	},

}
