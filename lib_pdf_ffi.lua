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
	void notify(const char *title, const char *message, int8_t icon);
	int8_t message(const char *title, const char *text, int8_t choice, int8_t icon);
	char** open_file(const char *title, const char *initial_path, const char **filters, int8_t option, uint8_t filter_size);
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
	pdf_lib.notify(title, message, icon)
end

function pdf.message(title, text, choice, icon)
	return pdf_lib.message(title, text, choice, icon)
end

function pdf.open_file(title, initial_path, filter, option)
	local str_ptr = ffi.new("const char*[?]", #filter + 1, filter)
	local ret = pdf_lib.open_file(title, initial_path, str_ptr, option, #filter)
	return (convert_string_2d(ret))
end


-- pdf.notify("test3 🔥", "test2 🔥", 3)
--
-- local t = pdf.message(
-- 	"test3 🔥",
-- 	"test2 🔥",
-- 	pdf.choice.ok,
-- 	pdf.icon.error
-- )
--
-- print("t=", t)
--
-- local filter = {
-- 	"Image Files",
-- 	"*.png *.jpg *.jpeg *.bmp",
-- 	"Audio Files",
-- 	"*.wav *.mp3",
-- 	"All Files",
-- 	"*"
-- }
--
-- local t = pdf.open_file("title", "/", filter, pdf.opt.multiselect)
-- for k,v in ipairs(t) do print(k,v) end



return pdf
