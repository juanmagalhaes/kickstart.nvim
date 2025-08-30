#!/bin/bash

# Neovim Profile Switcher
# Usage: ./switch-profile.sh [profile_name]

PROFILES=("legacy" "modern" "minimal")
CONFIG_FILE="config.lua"
TEMPLATE_FILE="config.template.lua"

# Function to show available profiles
show_profiles() {
    echo "Available profiles:"
    for profile in "${PROFILES[@]}"; do
        if [ "$profile" = "$CURRENT_PROFILE" ]; then
            echo "  * $profile (current)"
        else
            echo "  - $profile"
        fi
    done
}

# Function to create config.lua from template
create_config() {
    if [ -f "$TEMPLATE_FILE" ]; then
        cp "$TEMPLATE_FILE" "$CONFIG_FILE"
        echo "Created $CONFIG_FILE from template"
    else
        echo "Error: Template file $TEMPLATE_FILE not found"
        exit 1
    fi
}

# Function to switch profile
switch_profile() {
    local new_profile="$1"
    
    # Check if profile exists
    if [ ! -d "profiles/$new_profile" ]; then
        echo "Error: Profile '$new_profile' does not exist"
        exit 1
    fi
    
    # Create config.lua if it doesn't exist
    if [ ! -f "$CONFIG_FILE" ]; then
        create_config
    fi
    
    # Update config.lua
    sed -i.bak "s/profile = '.*'/profile = '$new_profile'/" "$CONFIG_FILE"
    
    # Remove backup file
    rm -f "${CONFIG_FILE}.bak"
    
    echo "Switched to profile: $new_profile"
    echo "Restart Neovim to apply changes"
}

# Check if config.lua exists, create from template if not
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found. Creating from template..."
    create_config
fi

# Get current profile
CURRENT_PROFILE=$(grep "profile = " "$CONFIG_FILE" | sed "s/.*profile = '\([^']*\)'.*/\1/")

# If no argument provided, show current profile and available options
if [ $# -eq 0 ]; then
    echo "Current profile: $CURRENT_PROFILE"
    echo
    show_profiles
    echo
    echo "Usage: $0 [profile_name]"
    echo "Example: $0 modern"
    exit 0
fi

# Switch to specified profile
switch_profile "$1"
