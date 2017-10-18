-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- Runs demonstration mode:
local clock = os.clock
local function sleep(n)
	local t0 = clock()
	while clock() - t0 <= n do end
end

-- Packing:
return function(eval, env)

	-- Demonstration list settings:
	local char_sleep, cmd_sleep = 0.025, 0.95
	local dlist = {
		{
			'Create new new Nucleic sequence',
			'seq = biolua.sequence.Nucleic "atgcatgcaaaa"',
		},
		{
			'Print text value of Nucleic Sequence',
			'seq'
		},
		{
			'Get Nucleic complement',
			'seq:complement()'
		},
		{
			'Get Nucleic reverse complement',
			'seq:reverse():complement()'
		},
		{
			'Get Nucleic sub-sequence',
			'seq:sub(3, 8)'
		},
		{
			'Get Nucleic GC percent',
			'seq:gc_percent()'
		},
		{
			'Get Nucleic sequence molecular weight',
			'seq:weight()'
		},
		{
			'Get Nucleic composition',
			'seq:composition()'
		},
		{
			'Get Amino translation from Nucleic sequence',
			'seq:translate()'
		},
		{
			'Get Amino translation names',
			'seq:translate():names()'
		},
		{
			'Get Amino translation molecular weight',
			'seq:translate():weight()'
		},
	}

	-- Running demonstration:
	for _, pair in ipairs(dlist) do

		-- Extracting parts:
		local desc, line = '-- ' .. pair[1], 'biolua> ' .. pair[2]

		-- Printing description:
		io.write('\n')
		for i = 1, #desc do
			io.write(desc:sub(i, i))
			sleep(char_sleep)
		end

		-- Printing command:
		io.write('\n')
		for i = 1, #line do
			io.write(line:sub(i, i))
			sleep(char_sleep)
		end

		-- Printing result:
		local result = eval(pair[2], env)
		if result then
			io.write('\n')
			io.write(result)
		end

		-- Waiting for user prompt:
		if io.read() ~= '' then
			break
		end

	end

end