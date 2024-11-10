#!/bin/bash

# Install apps
echo "Installing packages from brew-apps.txt..."
while IFS= read -r app || [[ -n "$app" ]]; do
    # Skip comments and empty lines
    [[ "$app" =~ ^#.*$ || -z "$app" ]] && continue

    # Check for Cask apps and install them separately
    if [[ "$app" == cask:* ]]; then
        brew install --cask "${app#cask:}"
    else
        brew install "$app"
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