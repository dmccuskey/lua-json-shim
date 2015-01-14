### Overview ###

This module is used to load any of the various Lua `json` modules, but standardize the name to `json` so that code is portable across platforms. Currently the file tries to load one of `dkjson`, `cjson` or `json`. (_You can also edit the file to add your favorite json module_)

Of course you will need to install a `json` module for it to work, eg:

```
-- some example json libs
> luarocks install dkjson
> luarocks install lua-cjson
```

### Usage ###

```lua
local json = require 'dmc_lua.json'
```

If you setup your Lua PATH (_preferred_), it would be:

```lua
local json = require 'json'
```
