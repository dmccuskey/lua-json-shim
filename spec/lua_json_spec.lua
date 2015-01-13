--====================================================================--
-- spec/lua_json_spec.lua
--
-- Testing for lua-json-shim
--====================================================================--


package.path = './dmc_lua/?.lua;' .. package.path



--====================================================================--
--== Test: Lua JSON Shim
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Setup, Constants


local json



--====================================================================--
--== Testing Setup
--====================================================================--


describe( "Module Test: json.lua", function()

	it( "loads json module", function()
		assert.is_nil( json )
		json = require 'json'
		assert.is.not_nil( json )
	end)

end)
