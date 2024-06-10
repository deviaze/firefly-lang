local err = {}

err.file_path = ""

err.Errors = {
	FileError = "FileError",
}

function err.err(error_type, message: string, ln: number?)
	local file_ln_message = if ln then `{err.file_path}:{ln}` else ""
	error(`firefly: {file_ln_message}\n{err.Errors[error_type]} {ln}: {message}`)
end
return err