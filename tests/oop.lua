-- Part of BioLua by SweetPalma, 2017. All rights reserved.
-- BioLua OOP system unit tests:
describe('biolua.object', function()

	local Object, Vector, vector

	it('Successfully imports', function()
		Object = require 'biolua.object'
		assert.type('table', Object)
	end)

	it('Successfully extends using :extend', function()
		Vector = Object:extend {__name = 'Vector'}
		assert.equal(Vector.__super, Object)
		assert.equal(Vector.__name, 'Vector')
		assert.type('function', Vector.__call)
		assert.type('string',   Vector.__id)
	end)

	it('Successfully extends using .assign', function()
		
		function Vector:__init(x, y)
			self.x = x
			self.y = y
		end

		function Vector:__index(key)
			if key == 1 then
				return self.x
			elseif key == 2 then
				return self.y
			else 
				return rawget(self, key)
			end
		end

		function Vector:__newindex(key, value)
			if key == 1 then
				self.x = value
			elseif key == 2 then
				self.y = value
			else 
				return rawset(self, key, value)
			end
		end

		function Vector:__tostring()
			return 'Vector(' .. self.x .. ', ' .. self.y .. ')'
		end

		function Vector:__unm()
			return Vector(-self.x, -self.y)
		end

		function Vector.__add(one, two)
			if type(one) == 'table' and type(two) == 'table' 
			 and one.x and one.y and two.x and two.y then
				return Vector(one.x + two.x, one.y + two.y)
			end
		end

		function Vector.__sub(one, two)
			if type(one) == 'table' and type(two) == 'table' 
			 and one.x and one.y and two.x and two.y then
				return Vector(one.x - two.x, one.y - two.y)
			end
		end

		function Vector.__eq(one, two)
			if type(one) == 'table' and type(two) == 'table' 
			 and one.x and one.y and two.x and two.y then
				return one.x == two.x and one.y == two.y
			else
				return false
			end
		end

		function Vector.__lt(one, two)
			if type(one) == 'table' and type(two) == 'table' 
			 and one.x and one.y and two.x and two.y then
				return one:magnitude() < two:magnitude()
			end
		end

		function Vector.__le(one, two)
			return Vector.__lt(one, two) or Vector.__eq(one, two)
		end

		function Vector:magnitude()
			return math.sqrt(self.x ^ 2 + self.y ^ 2)
		end

	end)

	it('Successfully performs initialization', function()
		vector = Vector(15, 10)
		assert.equal(vector.__proto, Vector)
		assert.equal(vector.__super, Object)
		assert.type('string', Vector.__id)
		assert.equal(vector.extend,  nil)
		assert.equal(vector.__call,  nil)
	end)

	it('Successfully calls __init', function()
		assert.equal(vector.x, 15)
		assert.equal(vector.y, 10)
	end)

	it('Successfully calls instance method', function()
		assert.equal(math.floor(vector:magnitude()), 18)
	end)

	it('Successfully calls metamethods', function()
		local a, b = Vector(10, 5), Vector(5, 5)

		assert.equal(a.x, a[1])
		assert.equal(a.y, a[2])
		assert.equal(tostring(a), 'Vector(10, 5)')

		local unm = -a
		assert.equal(unm.x, -a.x)
		assert.equal(unm.y, -a.y)
		
		local sum = a + b
		assert.equal(sum.x, 15)
		assert.equal(sum.y, 10)

		local dif = a - b
		assert.equal(dif.x, a.x - b.x)
		assert.equal(dif.y, a.y - b.y)

		assert.equal(a == b, false)
		assert.equal(b == a, false)
		assert.equal(a == Vector(10, 5), true)
		assert.equal(Vector(10, 5) == a, true)
		assert.equal(a >= b, true)
		assert.equal(b <= a, true)
		assert.equal(a <= b, false)
		assert.equal(b >= a, false)

		-- There is no need to test all metamethods.

	end)

	it('Successfully performs typechecks', function()
		local a = Vector(10, 10)
		assert.equal(a:is(a), true)
		assert.equal(a:is(Vector), true)
		assert.equal(a:is(Object), true)
		assert.equal(a:is(Vector(5, 5)),   false)
		assert.equal(a:is(Vector(10, 10)), false)
		-- It compares __id, avoiding using __eq. 
	end)

end)