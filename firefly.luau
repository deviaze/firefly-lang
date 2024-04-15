--- Language file that handles lexing, compiling, running firefly scripts.
--- extension: '.fi'

-- libs
local process = require ("@lune/process")
local fs = require ("@lune/fs")
-- modules
local src = "./"
local lexer = require ("lexer.luau")
local time = require ("bench.luau")
local err = require ("err.luau")
local defs = require ("defs.luau")
--

local append = table.insert 

local function first_n_terms(n, parse_list)
	local terms = {}
      for i, p in parse_list do
            if i >= n then break end
            append(terms, p)
      end
      return terms
end

for _, path in process.args do
      time()
      err.set_env(path)
      local parse_list = lexer.lex(path) -- lexer.generateParseList(tokens) -- converts tokens from firefly keywords to verbose parse syntax

      -- setup vars
      local identifer_types : {[string] : defs.TypesEnum} = {}
      --
      -- print(first_n_terms(20, parse_list))
      time()
      l2 = {}
      for i, v in parse_list do
      	if v.s:gsub("[%s]+","") ~= "" then
      		append(l2, v.s)
      	end
      end
      print (l2)
end
if #process.args < 1 then
      warn("firefly: called without arguments; do you want to compile files?")
else
      print(tostring(time))
end