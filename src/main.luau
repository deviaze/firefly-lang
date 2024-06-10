-- firefly language
-- by dev chrysalis

local TEST_PATH = "./examples/fire.fi"

local fs = require("@lune/fs")
local process = require("@lune/process")

local args = table.clone(process.args)

local ReadWrite = require("src/read_write")
local Tokenizer = require("src/tokenizer")
local Err = require("src/err")

local main = {}

local raw_text = ReadWrite.readFile(args, TEST_PATH)
local tokens = {} 

return main

