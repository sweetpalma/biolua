-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- GenBank parser interface:
local Parser = (require 'biolua.parser.parser'):extend {__name = 'Genbank'}


-- Internal: Stripping unwanted spaces:
local function strip(x)
	local x = x or ''
	return x:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n%s+', '\n')
end


-- Reading from file:
function Parser:read(name)
	
	-- Preparing file:
	self.__super.read(self, name)
	local file = self.file

	-- Checking for being empty:
	local first_line = file:read()
	if not first_line then
		error('Error while reading ' .. tostring(name) .. ': File is empty.', 2)
	else
		file:seek('set')
	end

	-- Reading header:
	local keyword
	local insert, buf = table.insert, {}
	for line in file:lines() do

		-- Assigning new keyword:
		local first_word = line:match('^(%w+)')
		if first_word and first_word:upper() == first_word then
			keyword = first_word
			buf[keyword] = buf[keyword] or {}
		end

		-- Validating keyword existence:
		if not keyword then
			error('Invalid GenBank file start.', 2)
		end

		-- Terminating header reader: 
		if keyword == 'ORIGIN' then
			break
		end

		-- Storing content:
		line = line:sub(first_word and (#first_word + 1) or 1)
		insert(buf[keyword], line)

	end

	-- Concatenating buffers:
	for key, value in pairs(buf) do
		buf[key] = table.concat(value, '\n')
	end

	-- Reading origin:
	local reached_end, obuf = false, {}
	for line in file:lines() do

		-- Throwing error for multi-sequence GenBanks:
		if reached_end then
			error('Multi-sequence files are not supported yet.', 2)

		-- Adding note about current origin end:
		elseif line:match('^//') then
			reached_end = true

		-- Reading origin:
		else
			line = line:gsub('[%s%d]', '')
			insert(obuf, line)
		end

	end

	-- Storing origin:
	self.sequence = table.concat(obuf)

	-- Parsing atomic keywords:
	self.locus      = strip(buf['LOCUS'])
	self.definition = strip(buf['DEFINITION'])
	self.accession  = strip(buf['ACCESSION'])
	self.comment    = strip(buf['COMMENT'])
	self.source     = strip(buf['SOURCE'])

	-- Parsing reference:
	if buf['REFERENCE'] then
		local keyword
		local id, rbuf = 0, {}

		-- Parsing line by line:
		for line in buf['REFERENCE']:gmatch('([^\n]+)') do

			-- Changing line:
			local possible_id = tonumber(line:gsub('^%s+', ''):match('^%d+'))
			if possible_id and id + 1 == possible_id then
				id, line = possible_id, nil
				rbuf[id] = {}

			-- Changing keyword:
			else
				local first_word = line:gsub('^%s+', ''):match('(%a+)')
				if first_word and first_word:upper() == first_word then
					keyword = first_word
					rbuf[id][keyword] = {}
					line = line:gsub(keyword, '')
				end
			end

			-- Storing line in buffer:
			if line then

				-- Validating keyword and ID:
				if id == 0 then
					error('Invalid reference ID.', 2)

				-- Validating keyword existence:
				elseif not keyword then
					error('Invalid keyword.', 2)
				end

				-- Pushing line:
				line = line:gsub('^%s+', '')
				insert(rbuf[id][keyword], line)

			end
		end

		-- Storing:
		self.reference = {}
		for id, line in ipairs(rbuf) do
			self.reference[id] = {}
			for keyword, content in pairs(line) do
				content = table.concat(content, ' ')
				self.reference[id][keyword:lower()] = content
			end
		end

	end

return self end


-- Writing to file (NYI):
function Parser:write(name)
	error('GenBank writing is not yet implemented.', 2)
end


-- Packing:
return Parser
