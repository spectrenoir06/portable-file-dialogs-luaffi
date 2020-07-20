local ffi = require('ffi')

local pdf_lib = ffi.load('./libpdf.so')
local pdf = {}

pdf.icon = {
	info     = 0,
	warning  = 1,
	error    = 2,
	question = 3
}

pdf.choice = {
	ok = 0,
	ok_cancel = 1,
	yes_no = 2,
	yes_no_cancel = 3,
	retry_cancel = 4,
	abort_retry_ignore = 5,
}

pdf.button = {
	cancel = -1,
	ok = 0,
	yes = 1,
	no = 2,
	abort = 3,
	retry = 4,
	ignore = 5,
}

pdf.opt = {
	none = 0,
	multiselect     = 0x1,
	force_overwrite = 0x2,
	force_path      = 0x4,
}


ffi.cdef[[
	void   notify(const char *title, const char *message, int8_t icon);
	int8_t message(const char *title, const char *text, int8_t choice, int8_t icon);
	char** open_file(const char *title, const char *initial_path, const char **filters, int8_t option, uint8_t filter_size);
	char*  save_file(const char *title, const char *initial_path, const char **filters, int8_t option, uint8_t filter_size);
	char*  select_folder(const char *title, const char *default_path, int8_t option);
]]


local function convert_string_2d(ptr)
	local t = {}
	local i = 0
	while (tostring(ptr[i]) ~= "cdata<char *>: NULL") do
		table.insert(t, ffi.string(ptr[i]))
		i= i + 1
	end
	return t
end

function pdf.notify(title, message, icon)
	icon = icon or pdf.icon.info
	pdf_lib.notify(title, message, icon)
end

function pdf.message(title, text, choice, icon)
	choice = choice or pdf.choice.ok_cancel
	icon = icon or pdf.icon.info
	return pdf_lib.message(title, text, choice, icon)
end

function pdf.open_file(title, initial_path, filter, option)
	initial_path = initial_path or ""
	filter = filter or {"All Files", "*"}
	option = option or pdf.opt.none

	local str_ptr = ffi.new("const char*[?]", #filter + 1, filter)
	local ret = pdf_lib.open_file(title, initial_path, str_ptr, option, #filter)
	return (convert_string_2d(ret))
end

function pdf.save_file(title, initial_path, filter, option)
	initial_path = initial_path or ""
	filter = filter or {"All Files", "*"}
	option = option or pdf.opt.none

	local str_ptr = ffi.new("const char*[?]", #filter + 1, filter)
	local ret = pdf_lib.save_file(title, initial_path, str_ptr, option, #filter)
	return (ffi.string(ret))
end

function pdf.select_folder(title, default_path, option)
	default_path = default_path or ""
	option = option or pdf.opt.none

	local ret = pdf_lib.select_folder(title, default_path, option)
	return (ffi.string(ret))
end

return pdf
