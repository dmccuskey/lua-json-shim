# lua-json-shim

try:
	if not gSTARTED: print( gSTARTED )
except:
	MODULE = "lua-json-shim"
	include: "../DMC-Lua-Library/snakemake/Snakefile"

module_config = {
	"name": "lua-json-shim",
	"module": {
		"dir": "dmc_lua",
		"files": [
			"json.lua"
		],
		"requires": [
		]
	},
	"tests": {
		"dir": "spec",
		"files": [
		],
		"requires": [
		]
	}
}

register( "lua-json-shim", module_config )


