local pdf = require("lib_pdf_ffi")



local t = pdf.message(
	"Title 🔥",
	"Text",
	pdf.choice.ok,
	pdf.icon.error
)

if t == pdf.button.ok then
	print("You press OK")
	pdf.notify("Warning", "You press OK", pdf.icon.warning)
else
	print("You press Cancel")
	pdf.notify("Warning", "You press Cancel", pdf.icon.warning)
end



local filter = {
	"Image Files",
	"*.png *.jpg *.jpeg *.bmp",
	"Audio Files",
	"*.wav *.mp3",
	"All Files",
	"*"
}

local t = pdf.open_file(
	"Open File",
	".",
	filter,
	pdf.opt.multiselect
)



print("\nOpen Files:")
for k,v in ipairs(t) do print(k,v) end



local str = pdf.save_file(
	"Save File",
	".",
	filter,
	pdf.opt.none
)

print("\nSave file:", str)
