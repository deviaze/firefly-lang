--!strict
local prelexer = {}

local defs = require("defs")

local append = function(t, v)
      table.insert(t, v)
end

prelexer.headers = {
      ['lune/fs'] = 'local fs = require("@lune/fs")',
}
prelexer.comment_patterns = {
      "(%-%-%->[%w?%s?%p?]+<%-%-%-)", --- multiline comment
      "(|[%s?][%w?%p? ]+\n)", -- eol or beginning of line comment
      "(%-%-%-[%w?%p? ]+\n)", --- 3 line doc comment
      "(%-%-%-|>[%w?%s?%p?]+<|%-%-%-)", --- code compile comment
}

local function is_string_delim(char : string)
      if defs.string_delims[char] then
            return true
      end
      return false
end

local function get_comment_delim(last_word)
      return defs.is_in({"comment_delims"}, last_word)
end

local function is_comment_delim(current_word)
      if defs.comment_delims[current_word] then
            return true
      end
      return false
end

local function is_brace(last : string)
      local braces = defs.braces:split("")
      for _, br in braces do
            if last == br then
                  return true
            end
      end
      return false
end

local function is_punct(char : string)
	return if char:match("[%.:$;,]") then true else false
end


function prelexer.parse_split_chars(raw : string)
      local output = ""

      local delim = ""
      local escape = ""
      local last_char = ""
      local curr_word = ""
      local not_backslashed = function()
           return if last_char ~= "\\" then true else false
      end
      
      local chars = raw:split("")
      for i, char in chars do
            local output_char = char
            local split_word = false
            if char == " " then
                  if delim ~= "" then
                        output_char = "█" -- join strings into single tokens
                  end
                  split_word = true
            elseif delim ~= "" and escape == char and not_backslashed() then
                  delim = ""
                  escape = ""
            elseif is_string_delim(char) and not_backslashed() then
                  if delim == "" then
                        delim = char
                        escape = char
                  end
                  if is_brace(last_char) then 
                        output_char = "▓" .. char
                  end
            elseif is_brace(char) or is_punct(char) then --and is_string_delim(last_char) then
                  if delim == "" then
                        output_char = "▓" .. char .. "▓" -- tokenizing whitespace
                  end
            elseif delim == "" and char == "|" then
                  -- single comment 
                  delim = char
                  escape = "\n"
            end
            output ..= output_char

            if not split_word then
                  -- curr_word ..= char
                  -- -- need to lookahead for > or |>
                  -- local next1 = chars[i + 1]
                  -- if delim == "" and curr_word == "---" and next1 and next1:match("[>|]") then
                  --       print("expected --> or ---|>")
                  --       -- pass
                  -- elseif delim == "" and is_comment_delim(curr_word) then 
                  --       delim = curr_word
                  --       escape = defs.comment_delims[curr_word]
                  --       -- curr_word = ""
                  -- elseif (curr_word == escape) then
                  --       print(`escaped {curr_word}?`)
                  --       delim = ""
                  --       escape = ""
                  --       -- curr_word = ""
                  -- end
            else
                  curr_word = ""
            end

            last_char = char

            -- --test
            -- if i > 100 and i < 200 then
            --       print(i, char, curr_word, delim)
            -- end

      end
      return output
end

function prelexer.cleanup(raw : string)
      raw = raw:gsub("\n", " \n ")
      return raw
end

return prelexer

