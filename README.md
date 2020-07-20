Portable File Dialogs Lua FFI
=============================

A lib to use [Portable File Dialogs
](https://github.com/samhocevar/portable-file-dialogs) with luaJIT

```lua
local t = pdf.message(
    "Title 🔥",
    "Text",
    pdf.choice.ok,
    pdf.icon.error
)

if t == pdf.button.ok then
    -- do something
end
```

```lua
pdf.notify(
    "Title 🔥",
    "Text",
    pdf.icone.warning
)
```

```lua
local t = pdf.open_file(
    "Title 🔥",
    ".",
    {"Image Files", "*.png *.jpg *.jpeg *.bmp"},
    pdf.opt.multiselect
)

for k,v in ipairs(t) do print(k,v) end
```

```lua
local str = pdf.save_file(
    "Title 🔥",
    ".",
    {"Image Files", "*.png *.jpg *.jpeg *.bmp"},
    pdf.opt.none
)

print("Save file:", str)
```

```lua
local str = pdf.select_folder(
    "Title 🔥",
    ".",
    pdf.opt.none
)

print("Select folder:", str)
```

#### Icons:
- info
- warning
- error
- question

#### Choices:
- ok
- ok_cancel
- yes_no
- yes_no_cancel



#### Buttons:
- cancel
- ok
- yes
- no
- abort
- retry
- ignore

#### Options:
- none
- multiselect
- force_overwrite
- force_path
