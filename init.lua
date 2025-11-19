-- SINGLE FILE NEOVIM CONFIG

vim.o.sidescroll = 0
vim.o.sidescrolloff = 0
vim.opt.clipboard = "unnamedplus" -- clipboard support
vim.o.wrap = true                 -- Enable line wrapping
vim.o.textwidth = 80              -- Optional: Set max text width for formatting
vim.o.termguicolors = true
vim.g.man_horiz = 1          -- force horizontal split
vim.g.man_split_mode = "rightbelow"  -- place it on the right
vim.opt.splitright = true  -- new vertical splits go to the right
vim.g.loaded_nvim_web_devicons = 1

-- require("lazy_jsx_frontend") -- BEST
-- require("lazy_ocaml_first") -- BEST
-- require("lazy_scala_jvm") -- BEST
-- require("lazy_python_dart_fsharp") -- BEST

require("lazy_tailored_cprogramming")
-- require("lazy_goto_definition") -- BEST
-- require("lazy_tpope_stack")
-- require("lazy_sophisticated")
-- require("lazy_alternative")
-- require("lazy_minimalism")

-- require("lazy_ergonomic_new")
-- require("lazy_vimscript")
-- require("lazy_ergonomic1")
-- require("lazy_ergonomic2")
-- require("lazy_readthedocs")
-- require("lazy_massive") -- BEST
-- require("lazy_standout") -- BEST
-- require("lazy_unique") -- BEST
--
-- require("lazy_gitfirst")
-- require("lazy_normal") -- BEST
-- require("lazy_normal_improved") -- BEST
-- require("lazy_research") -- BUG
-- require("lazy_llm_assistant") -- BUG
--
-- require("lazy_legacy") -- OK
-- require("lazy_primary") -- OK
-- require("lazy_with_lsp") -- OK
-- require("lazy_movement") -- OK
-- require("lazy_adventure") -- OK
-- require("lazy_lightweight") -- OK

-- require("lazy_enhanced") -- MEH
-- require("lazy_improved") -- MEH
-- require("lazy_ok") -- MEH
-- require("lazy_secondary") -- MEH
-- require("lazy_innovative") -- MEH
-- require("lazy_experiment") -- MEH

-- require("lazy_special") -- BUG
-- require("lazy_purist") -- BUG
-- require("lazy_modular") -- BUG
-- require("lazy_powerful") -- BUG
-- require("lazy_lowlevel") -- BUG
-- require("lazy_alternative") -- BUG
-- require("lazy_future") -- BUG


require("on_demand_fn.ok_features")
require("on_demand_fn.ok_vue_snippets")
require("on_demand_fn.ok_c99_snippets")

-- require("lib_theme_paperlike_day").setup()
require("lib_theme_paperlike_night").setup()
-- require("lib_keybindings")
-- require("lib_simplenav")
-- require("lib_simplenav").setup()
require("lib_bookmark").setup()
require("lib_disable_tabline")
require("lib_ag_filepicker")
require("lib_todo_search").setup()
-- require("lib_grepnav").setup()
require("lib_grepnav").setup({
  engine_priority = { "rg" },  -- never fall back to plain grep
  root_markers = { ".git", "pyproject.toml", ".root" },
  ignore = { ".git", "node_modules", "venv", "build", "*.min.js" },
  rg_args = "--vimgrep --no-heading --smart-case --type-add 'ts:*.tsx' --type-add 'vue:*.vue'",
  window_height_ratio = 0.5,
  mappings = true,
})


