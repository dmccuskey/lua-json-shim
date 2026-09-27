# lua-json-shim

Load whichever JSON module is installed, under one name, so the same Lua code runs on any system.

Lua has no built-in JSON, and the modules for it have different names: `dkjson`, `cjson`, `json`. Solar2D (formerly Corona SDK) has its own `json` module. lua-json-shim is a module named `json` that loads the first one it finds, so code written for Solar2D's `require 'json'` also runs in plain Lua, for example in tests under [lua-corovel](https://github.com/dmccuskey/lua-corovel):

```lua
local json = require 'json'  -- dkjson, cjson, or another json module

print( json.encode( { name='Ann', scores={ 10, 20 } } ) )
```

## Features

- One name, `json`, for dkjson, lua-cjson or any other module named `json`
- Fails at load with `json module not found` when none is installed, rather than later at the first call
- Pure Lua 5.1, one file; MIT licensed

It changes only the name: the module you get keeps its own API. See [Known Issues](#known-issues).

## Quick Start

The following steps will get you up and running in about 5 minutes with Lua 5.1 on macOS or Linux. You will install a JSON module, load it through the shim, and encode and decode some data.

Prerequisites: Lua 5.1 (`lua -v` shows `Lua 5.1.x`), LuaRocks and git.

### 1. Get the Code and a JSON Module

In an empty folder:

```sh
git clone https://github.com/dmccuskey/lua-json-shim.git
luarocks install dkjson
```

`lua-json-shim/dmc_lua/json.lua` is the shim. Any of the modules it looks for will do; `luarocks install lua-cjson` is the faster one, written in C.

### 2. Load It as `json`

Create `main.lua` in the same folder:

```lua
package.path = './lua-json-shim/dmc_lua/?.lua;' .. package.path
local json = require 'json'

local text = json.encode( { name='Ann', scores={ 10, 20 } } )
print( text )

local data = json.decode( '{"name":"Bob","scores":[30,40]}' )
print( data.name, data.scores[2] )
```

Run it:

```sh
lua main.lua
```

```text
{"name":"Ann","scores":[10,20]}
Bob	40
```

(The order of the keys in the first line may differ.) If it shows `json module not found`, no JSON module is installed where Lua can find it: check that LuaRocks installs for Lua 5.1 (`luarocks config lua_version`). If it shows `module 'json' not found`, run it from the folder that holds `lua-json-shim/`.

The shim tries `dkjson`, then `cjson`, then `json`, and returns the first one that loads. To prefer another module, or add one, edit the `JSON_LIBS` list at the top of `json.lua`.

To update, pull the repository again (`git -C lua-json-shim pull`), or replace `json.lua` with the newer one.

## In Solar2D

Solar2D has `json` built in, so a Solar2D app uses `require 'json'` directly and doesn't need the shim. The DMC Solar2D libraries do the same. Their `dmc_corona/lib/dmc_lua/` folder carries a copy of the shim, as part of [DMC-Lua-Library](https://github.com/dmccuskey/DMC-Lua-Library), but nothing loads it there: it's only for running the same code in plain Lua.

## Known Issues

- **Only the name is shared, not the behavior.** Code that works with one module can break with another. For example, dkjson's `decode()` (and Solar2D's) returns `nil` and a message for invalid JSON, where lua-cjson's raises an error; the value that stands for JSON `null` is each module's own.
- **`json module not found` hides the real error.** When a module is installed but fails to load (a C module built for another Lua version, say), the shim moves on to the next and reports only that none was found. Run `require 'dkjson'` (or `'cjson'`) directly to see why.
- The version, `0.2.0`, is only in the file: the module returned is the JSON module itself, so there's nowhere to put it.

## Development

Only `dmc_lua/json.lua` is written here. [DMC-Lua-Library](https://github.com/dmccuskey/DMC-Lua-Library) copies it into its `dmc_lua/` with its Snakemake build (the `Snakefile` here registers it; lua-files lists it as a requirement), and the DMC Solar2D libraries copy it from there into `dmc_corona/lib/dmc_lua/`.

The test is `spec/lua_json_spec.lua`, for [busted](https://lunarmodules.github.io/busted/) under Lua 5.1 with a JSON module installed. From the repository's root folder:

```sh
busted spec
```

```text
+
1 success / 0 failures / 0 errors / 0 pending : 0.001581 seconds
```

It checks only that `require 'json'` returns something.

## License

lua-json-shim is released under the [MIT License](LICENSE).
