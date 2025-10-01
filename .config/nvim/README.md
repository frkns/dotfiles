# Modular Neovim Configuration

This configuration has been organized into a modular structure for better maintainability and organization.

## Directory Structure

```
~/.config/nvim/
├── init.lua                  # Main entry point - loads all modules
├── init.lua.backup          # Backup of original monolithic configuration
├── lua/
│   ├── config/              # Core configuration modules
│   │   ├── core.lua         # Core vim options and settings
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── autocmds.lua     # Autocommands and file-type specific settings
│   │   ├── functions.lua    # Custom functions (run_local, run_oj, etc.)
│   │   ├── fold.lua         # Custom folding configuration
│   │   └── lazy.lua         # Lazy.nvim bootstrap
│   └── plugins/             # Plugin configurations
│       ├── themes.lua       # Theme-related plugins
│       ├── lsp.lua          # LSP and completion configuration
│       ├── telescope.lua    # Fuzzy finder configuration
│       ├── debug.lua        # Debugging plugins (DAP)
│       └── utils.lua        # Utility plugins (autopairs, treesitter, etc.)
└── README.md               # This file
```

## Configuration Modules

### Core Configuration (`config/`)

- **`core.lua`**: Basic vim settings, leader key, options, diagnostics
- **`keymaps.lua`**: All key mappings including leader keys and shortcuts
- **`autocmds.lua`**: File type specific behaviors and optimizations
- **`functions.lua`**: Custom functions for code execution and LSP handling
- **`fold.lua`**: Custom folding configuration with dolphin emoji
- **`lazy.lua`**: Lazy.nvim plugin manager bootstrap

### Plugin Configuration (`plugins/`)

- **`themes.lua`**: All colorschemes and theme-related plugins
- **`lsp.lua`**: Language Server Protocol configuration and completion
- **`telescope.lua`**: Fuzzy finder and search functionality
- **`debug.lua`**: Debugging setup with nvim-dap
- **`utils.lua`**: Utility plugins for editing, navigation, and productivity

## Key Features Preserved

All functionality from the original configuration has been preserved:

- ✅ All custom key mappings (`,r`, `,c`, `,f`, `,t`, `,o`, etc.)
- ✅ File type specific compilation and execution
- ✅ Online judge tools integration
- ✅ Custom folding with dolphin emoji
- ✅ Theme switching with Themery
- ✅ LSP configuration for Python
- ✅ Debugging setup for Python
- ✅ Telescope fuzzy finding
- ✅ All plugin configurations
- ✅ Custom diagnostic filtering
- ✅ Large file optimizations
- ✅ Codeium integration
- ✅ Neo-tree file explorer
- ✅ Tmux navigation

## Benefits of Modular Structure

1. **Maintainability**: Each aspect of the configuration is in its own file
2. **Readability**: Easier to find and modify specific functionality
3. **Modularity**: Can easily enable/disable entire feature sets
4. **Scalability**: Easy to add new plugins or configurations
5. **Organization**: Related functionality is grouped together

## Usage

The configuration works exactly the same as before. Simply start Neovim and all functionality will be available. The modular structure is transparent to the user experience.

## Customization

To modify specific aspects:
- Edit `config/core.lua` for basic vim settings
- Edit `config/keymaps.lua` to add/modify key mappings
- Edit plugin files in `plugins/` to configure specific plugins
- Add new plugin files in `plugins/` and they'll be automatically loaded
