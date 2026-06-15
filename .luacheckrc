-- Luacheck configuration for doprog.
std = "lua54"
max_line_length = 120

-- MacroQuest injects `mq` globally in some contexts; our code requires it, but
-- the definitions and a few in-game globals are read-only.
read_globals = {
    "mq",
    "ImGui",
}

-- The vendored logger and the mq type definitions are not ours to lint.
exclude_files = {
    "lib/lwlogger/",
    ".meta/",
}

-- `_types.lua` files are annotation-only; they declare classes via comments and
-- return an empty table, so unused-arg style checks do not apply.
files["**/_types.lua"] = {
    ignore = { "212", "211", "542" },
}

-- Generated quest files and the generator favour compact, single-line declarative
-- step definitions; line-length is intentionally relaxed there.
files["zones/**/*.lua"] = { max_line_length = false }
files["tools/*.lua"] = { max_line_length = false }

ignore = {
    "212/self", -- method self may be unused in abstract base methods
}
