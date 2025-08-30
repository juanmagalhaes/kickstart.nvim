# Neovim Profile-Based Configuration

This is a modular Neovim configuration that allows you to switch between different setups without losing your existing configuration.

## 🏗️ Structure

```
~/.config/nvim/
├── init.lua              # Main entry point (profile loader)
├── config.lua            # Profile selection configuration (gitignored)
├── config.template.lua   # Template for profile selection
├── profiles/
│   ├── legacy/           # Your original configuration
│   ├── modern/           # Clean, modern setup
│   └── minimal/          # Minimal configuration
└── shared/               # Common utilities (future use)
```

## 🚀 Quick Start

1. **First Time Setup**: Copy the template to create your config:
   ```bash
   cp config.template.lua config.lua
   ```

2. **Switch Profiles**: Edit `config.lua` and change the `profile` value:
   ```lua
   return {
     profile = 'modern',  -- Options: 'legacy', 'modern', 'minimal'
   }
   ```

3. **Restart Neovim**: The new profile will be loaded automatically.

## 🔧 Profile Management

### Creating a New Profile
1. Create a new directory in `profiles/`
2. Add an `init.lua` file
3. Update `config.template.lua` to include your new profile
4. Set `profile = 'your-profile-name'` in your local `config.lua`

### Sharing Code Between Profiles
- Common utilities can be placed in the `shared/` directory
- Import them in your profile's `init.lua`:
  ```lua
  local utils = require('shared.utils')
  ```

## 🎯 Key Features

- **Profile Switching**: Change configurations without losing your setup
- **Fallback Protection**: Automatically falls back to legacy if a profile fails
- **Modular Design**: Each profile is self-contained
- **Plugin Preservation**: All your current plugins are preserved in the legacy profile
- **Easy Migration**: Gradually move features from legacy to modern
- **Git-Friendly**: Profile definitions are tracked, but your selection is ignored

## 🔄 Migration Guide

### From Legacy to Modern
1. Start with the modern profile
2. Identify missing features from your legacy setup
3. Add them to the modern profile or create custom modules
4. Test thoroughly before switching permanently

### Adding New Plugins
- **Legacy Profile**: Add to `profiles/legacy/lua/core/plugins/init.lua`
- **Modern Profile**: Add to `profiles/modern/plugins/init.lua`
- **Shared**: Create in `shared/plugins/` if multiple profiles need it

## 🛠️ Troubleshooting

### Profile Won't Load
- Check the profile name in `config.lua`
- Verify the profile directory exists
- Check for syntax errors in the profile's `init.lua`
- The system will automatically fall back to legacy

### Missing Features
- Compare with the legacy profile
- Check if plugins are properly configured
- Verify keybindings are set up correctly

## 📚 Plugin List

### Core Plugins (Modern Profile)
- **LSP**: nvim-lspconfig, Mason, Mason-lspconfig
- **Completion**: nvim-cmp, LuaSnip
- **File Management**: nvim-tree, Telescope
- **Git**: vim-fugitive, vim-rhubarb
- **UI**: lualine, indent-blankline, onedark theme
- **Development**: nvim-treesitter, Comment.nvim
- **AI**: GitHub Copilot

### Legacy Plugins
All your existing plugins are preserved in the legacy profile.

## 🎨 Customization

### Adding New Keybindings
- **Legacy**: Edit `profiles/legacy/lua/core/keymaps/`
- **Modern**: Edit `profiles/modern/core/keymaps.lua`

### Changing Settings
- **Legacy**: Edit `profiles/legacy/lua/core/settings/`
- **Modern**: Edit `profiles/modern/core/options.lua`

### Adding Plugins
- **Legacy**: Edit `profiles/legacy/lua/core/plugins/init.lua`
- **Modern**: Edit `profiles/modern/plugins/init.lua`

## 🔒 Git Configuration

### What's Tracked
- ✅ Profile definitions and code
- ✅ Configuration templates
- ✅ Utility scripts
- ✅ Documentation

### What's Ignored
- ❌ `config.lua` (your personal profile selection)
- ❌ `lazy-lock.json` (auto-generated plugin locks)
- ❌ Neovim runtime files
- ❌ OS-specific files

### Team Collaboration
- Each developer can have their own `config.lua`
- Profile definitions are shared and version controlled
- Easy to add new profiles for the team
- No conflicts when switching profiles

## 🤝 Contributing

1. Test your changes in a new profile first
2. Keep profiles modular and self-contained
3. Document any new features or changes
4. Follow the existing code style
5. Update `config.template.lua` when adding new profiles

## 📝 License

This configuration is based on [Neovim Kickstart](https://github.com/nvim-lua/kickstart.nvim) and is licensed under the MIT License.

