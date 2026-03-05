-- Main init.lua - Loads all configuration modules

-- Load core settings first
require("config.core")

-- Setup lazy.nvim and load plugins
require("config.lazy")

-- Load configuration modules
require("config.keymaps")
require("config.functions")
require("config.fold")
require("config.autocmds")
