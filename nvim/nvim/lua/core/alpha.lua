-- lua/core/alpha.lua

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
    "    _/_/_/_/_/  _/_/_/_/  _/_/_/      _/_/    _/_/_/_/_/  _/_/_/      _/_/      _/_/_/  _/_/_/_/   ",
    "         _/    _/        _/    _/  _/    _/      _/      _/    _/  _/    _/  _/        _/          ",
    "      _/      _/_/_/    _/_/_/    _/    _/      _/      _/_/_/    _/_/_/_/  _/        _/_/_/       ",
    "   _/        _/        _/    _/  _/    _/      _/      _/    _/  _/    _/  _/        _/            ",
    "_/_/_/_/_/  _/_/_/_/  _/    _/    _/_/        _/      _/    _/  _/    _/    _/_/_/  _/_/_/_/",
    "  \"The only true wisdom is in knowing you know nothing.\"",
    "                                  — Socrates"
}

dashboard.section.footer.val = "ZeroTrace - Nothing Matters"

alpha.setup(dashboard.opts)

