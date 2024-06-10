local Defs = {
	Braces = "{}[]()",
	Delimiters = {
		String = "'\"`",
		SingleLineComment = "#",
		MultiLineComment = {
			start = "<--",
			["end"] = "-->",
		},
		List = { 
			start = "[",
			["end"] = "]",
		},
		Table = {
			start = "{",
			["end"] = "}",
		},
		LambdaFunction = "|",
	},
	Keywords = {
		Control = {
			["if"] = "if",
			["elseif"] = "elseif",
			["else"] = "else",
			
			["end"] = "end",
			
			["function"] = "function",
			["fn"] = "function",
			["do"] = "do",
			["=>"] = "lambdo",
			["def"] = "method",
			
			["in"] = "in",
			["where"] = "where",
			
			["for"] = "for",
			["while"] = "while",
			["repeat"] = "repeat",
			["until"] = "until",
		}
	},
	Operators = {
		Arithmetic = {
			["+"] = "add",
			["-"] = "subtract",
			["*"] = "multiply",
			["/"] = "divide",
			["//"] = "floordiv",
		},
		Logical = {
			["and"] = "and",
			["or"] = "or",
			["not"] = "not",
		},
		Relational = {
			["=="] = "eq",
			["!="] = "neq",
			[">"] = "gt",
			["<"] = "lt",
			[">="] = "gte",
			["<="] = "lte",
		},
		Assignment = {
			["="] = "assign",
			["?="] = "assignif",
			[":="] = "walrus",
		}
	}
}