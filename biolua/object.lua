-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- OOP system for Lua:
local Object = {__name = 'Object'}


-- Internal: Table copy:
local function copy(t)
	if type(t) == 'table' then
		local clone = {}
		for key, value in pairs(t) do
			clone[key] = value
		end
		return clone
	else return t end
end


-- Internal: Textual ID of table:
local function id(t)
	return string.gsub(tostring(t), 'table: ', '')
end


-- Object: Constructor:
function Object.__call(self, ...)

	-- Building instance:
	local instance = copy(self)
	instance.__id = id(instance)
	instance.__proto = self
	instance.__call = nil
	instance.extend = nil
	setmetatable(instance, instance)

	-- Calling initializer:
	if instance.__init then
		instance.__init(instance, ...)
	end

return instance end


-- Object: Extender:
function Object:extend(args)
	
	-- Making basic copy:
	local prototype = copy(self)
	prototype.__super = self
	prototype.__id = id(prototype)
	setmetatable(prototype, prototype)

	-- Extending:
	if args then
		for key, value in pairs(args) do
			prototype[key] = value
		end
	end

	-- Name reset:
	if not args or not args.__name then
		prototype.__name = 'Unknown'
	end

return prototype end


-- Object: Stringification:
function Object:__tostring()
	local t = self.__proto and 'instance' or 'prototype'
	return self.__name .. ' ' .. t .. ': ' .. self.__id
end


-- Typechecking:
function Object:is(other)
	if type(other) ~= 'table' then
		return false
	end
	return self.__id == other.__id 
		or (self.__proto and self.__proto.__id == other.__id)
		or (self.__super and self.__super:is(other)) 
		or false
end


-- Packing:
Object.__id = id(Object)
setmetatable(Object, Object)
return Object
