-- Neovim Profile Configuration Template
-- Copy this file to config.lua and change the profile value to your preference

return {
  -- Available profiles: 'legacy', 'modern', 'minimal'
  -- Change this value to switch between different configurations
  profile = 'legacy',  -- <-- CHANGE THIS VALUE
  
  -- Profile-specific settings
  profiles = {
    legacy = {
      name = 'Legacy Configuration',
      description = 'Your original Neovim configuration with all customizations'
    },
    modern = {
      name = 'Modern Configuration', 
      description = 'Clean, modern Neovim setup with best practices'
    },
    minimal = {
      name = 'Minimal Configuration',
      description = 'Minimal Neovim setup for quick editing'
    }
  }
}

-- Instructions:
-- 1. Copy this file to config.lua
-- 2. Change the profile value to your preferred configuration
-- 3. Restart Neovim to load the new profile
-- 4. Use ./switch-profile.sh [profile_name] to switch profiles easily
