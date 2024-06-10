
local Defs = require("src/defs")
local Err = require("src/err")
local Errors = Err.Errors
local err = Err.err

local Tokenizer = {}

function Tokenizer.parseTokens(raw_text: string): {string}
	local chars = raw_text:split("")
	
	local tokens = {}
	
	local comment_in = false
	local string_in = false
	
	local word = ""
	local last = ""
	local prev = ""
	
	for index, curr in chars do
		
	end
end