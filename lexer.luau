--!strict
local fs = require ("@lune/fs")
local task = require ("@lune/task")

local defs = require ("defs.luau")
local prelexer = require ("prelexer.luau")
local err = require ("err.luau")

local append = table.insert

local lex = {}
      lex.cached_tokens = {} :: {string}
function lex.lex(target_path : string)
      local raw = fs.readFile(target_path):gsub("\r", "")
      local output = prelexer.parse_split_chars(raw):gsub("\n", " ▓\n▓")
            -- output = prelexer.neutralizecomments(output)
            
      local parse_list = {}
      local raw_tokens = output:split(" ")

      local temp_reassembled = ""
      
      local escape_word = ""
      for _, t in raw_tokens do
            local tokens = t:split("▓")
            local ass_str = ""
            for _, token in tokens do
                  if token:match("[█?]+$") then
                        token = t:gsub("[█?]+$", "")
                  end
                  
                  i = #parse_list + 1
                  local lexeme = lex.newLexeme(token, i)
                  
                  local comment_delim = defs["comment_delims"][token]
                  if comment_delim then
                  	escape_word = comment_delim
                  end
                  
                  if escape_word == "" then 
		            local is_kw = lex._is_keyword(lexeme)
		            if is_kw then
		                  lexeme.s = "$" .. defs.keywords[token]
		            end
		            local op = lex._is_op(lexeme)
		            if op then
		                  lexeme.s = "$" .. op
		            end
                  elseif token == escape_word then
                  	escape_word = ""
                  end
                  
	            append(parse_list, lexeme)
                  ass_str ..= token
            end
                  
            temp_reassembled ..= " " .. ass_str
      end
      
      --- successfully tokenizing it then reassembling with whitespace intact :))
      temp_reassembled = temp_reassembled
            :gsub("█", " ")
            :gsub("▓", "")
            :gsub("\n ", "\n")
            :gsub("^ ", "")
      -- return tokens2
      return parse_list
end

function lex.getTokenLine(index : number) : number
      local newlines = 1 -- linecount starts at 1 (of course)
      for ln, token in lex.cached_tokens do
            if ln == index then break end
            if token == "\n" or token:gsub(" ", "") == "\n" then
                  newlines += 1
            end
      end
      return newlines
end


function lex.newLexeme(s, i) : defs.lexeme
      return {
            s = s,
            i = i,
            ln = lex.getTokenLine(i),
      }
end

function lex._is_keyword(x : defs.lexeme, p : boolean?) -- classic 3-value trool
      if not p then
            if defs.keywords[x.s] then
                  return true
            elseif defs.luau_keywords[x.s] then
                  err.ParseListErrors["reserved keyword"](x)
                  return false
            else
                  return false
            end
      else
            for k, v in defs.keywords do
                  if v == x.s then 
                        return true
                  else
                        continue
                  end 
            end
            return false
      end
end
function lex._is_op(x : defs.lexeme, p : boolean?)
      return defs.is_in({"assignment_operators", "comparison_operators", "control_operators", "operators"}, x.s, p or nil)
end
function lex._is_assignment(x : defs.lexeme, p : boolean?)
      return defs.is_in({"assignment_operators"}, x.s, p or nil)
end

--- returns true if the lexeme list is an expression; throws errs if invalid.
function lex.isExpr(lexemes : {defs.lexeme})
      if #lexemes > 2 then
            -- checks if contains illegal operator 
            for i, lexeme in lexemes do
                  if lex._is_assignment(lexeme, true) and lexeme.s ~= "alias assign" then
                        err.syntax(lexeme, 'attempt to assign in expression; did you mean "=="?')
                  elseif defs.is_in({"control_operators"}, lexeme.s, true) then 
                        err.syntax(lexeme, "attempt to evaluate codeblock in expression.")
                  end
            end
            -- check if first or last are operators
            local first_op, last_op = lex._is_op(lexemes[1]), lex._is_op(lexemes[#lexemes])
            if first_op or last_op then 
                  err.syntax(lexemes[1], `found operator {if first_op then '"' .. lexemes[1].s .. '"' else ""} at beginning or end {if last_op then '"' .. lexemes[#lexemes].s .. '"' else ""} of expression.`)
            end
            -- we don't check whether each identifier exists at that's checked by parser/compiler
            return true
      end
      return false
end

return lex