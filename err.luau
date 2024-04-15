local defs = require ("defs.luau")
--- firefly error handler

local err = {path = ""}
      tokens = {}

function err.set_env(path : string)
      err.path = path
end

function err.syntax(x : defs.lexeme, message : string)
      error(`Firefly compile failed: {err.path}:{x.ln}: ("{x.s}")\n  Syntax error on line {ln};\n    {message}`)
end
function err.reserved_keyword(x : defs.lexeme, message : string)
      error(`Firefly compile failed: {err.path}:{x.ln}: ("{x.s}")\n  Reserved keyword on line {x.ln};   {message}`)
end
function err.typeerr(x : defs.lexeme, message : string)
      
end


err.ParseListErrors = {
      ["reserved keyword"] = function(x : defs.lexeme)
            err.reserved_keyword(x, `"{x.s}" is a Luau keyword and may not be used in Firefly.`)
      end,
      
}

return err