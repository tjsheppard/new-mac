#!/bin/bash

# Install or update apps
echo "Installing or updating packages from brew-apps.txt..."
while IFS= read -r app || [[ -n "$app" ]]; do
    # Skip comments and empty lines
    [[ "$app" =~ ^#.*$ || -z "$app" ]] && continue

    # Check for Cask apps and install/update them separately
    if [[ "$app" == cask:* ]]; then
        app_name="${app#cask:}"  # Extract the app name without 'cask:'
        
        if brew list --cask "$app_name" &>/dev/null; then
            if brew outdated --cask "$app_name" &>/dev/null; then
                echo "$app_name is up-to-date. Skipping..."
            else
                echo "Updating $app_name..."
                brew upgrade --cask "$app_name"
            fi
        else
            echo "Installing $app_name..."
            brew install --cask "$app_name"
        fi
    else
        # For regular (non-Cask) packages
        if brew list "$app" &>/dev/null; then
            if brew outdated "$app" &>/dev/null; then
                echo "$app is up-to-date. Skipping..."
            else
                echo "Updating $app..."
                brew upgrade "$app"
            fi
        else
            echo "Installing $app..."
            brew install "$app"
        fi
    fi
done < brew-apps.txt

# Clean up Homebrew
echo "Cleaning up Homebrew installations..."
brew cleanup

# Configure Git
echo "Setting up Git configuration..."

GIT_CONFIG_FILE="git-config.txt"

if [[ -f "$GIT_CONFIG_FILE" ]]; then
    # Extract name and email values
    git_name=$(grep -E "^name=" "$GIT_CONFIG_FILE" | cut -d'=' -f2-)
    git_email=$(grep -E "^email=" "$GIT_CONFIG_FILE" | cut -d'=' -f2-)

    # Set up Git user information
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    # Set up Git default editor (optional, change to your preferred editor)
    git config --global core.editor "code --wait"  # Uses Visual Studio Code
    # Or for nano: git config --global core.editor "nano"

    # Enable colored output for better readability
    git config --global color.ui auto

    # Set default branch name to 'main' (optional, change as needed)
    git config --global init.defaultBranch main

    # Enable credential caching for HTTPS (optional)
    git config --global credential.helper osxkeychain

    echo "Git configuration complete!"
else
    echo "Error: Git configuration file '$GIT_CONFIG_FILE' not found."
    echo "Please create '$GIT_CONFIG_FILE' with your name and email in the format:"
    echo "name=Your Name"
    echo "email=your.email@example.com"
fi