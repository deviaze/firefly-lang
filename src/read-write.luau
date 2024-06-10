local fs = require("@lune/fs")

local Err = require("src/err")
local Errors = Err.Errors
local err = Err.err

local read_write = {}

function read_write.readFile(args: {string}, test_path: string)
	if not args or args == 0 then
		file_path = test_path
	else
		if args[1] and typeof(args[1] == "string") then
			local provided_file = args[1]
			if fs.isFile(provided_file) then
				if provided_file:match("%.fi$") then
					file_path = provided_file
				else
					err(Errors.FileError, `File path must be a firefly file!! (filename.fi). Got: {provided_file}`)
				end
			elseif fs.isDir(provided_file) then
				err(Errors.FileError, `Expected firefly file path (string), got directory: "{provided_file}"`)
			else
				err(Errors.FileError, `Provided file doesn't exist: {provided file})`
			end
		else
			err(Errors.FileError, `invalid argument #1 to firefly.luau CLI. Expected string (path to firefly filename.fi), got {args[1]}`)
		end
	end
	print(`Reading: {file_path}`)
	local raw_file = fs.readFile(file_path)
	return raw_file
end

return read_write