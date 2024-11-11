#!/bin/bash

# Step 1: Install Xcode Command Line Tools
echo "Installing Xcode Command Line Tools..."
xcode-select --install
echo "Please complete Xcode Command Line Tools installation prompts, then press Enter to continue."
read -p ""

# Step 2: Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Ensure Homebrew was installed successfully
if ! command -v brew &> /dev/null; then
    echo "Homebrew installation failed. Please check your setup and try again."
    exit 1
fi

echo "Updating Homebrew..."
brew update

# Step 3: Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Step 4: Customize the macOS Dock
echo "Customizing the macOS Dock..."

# Clear all applications from the Dock
defaults write com.apple.dock persistent-apps -array

# Position Dock on the left, set size, disable magnification, and auto-hide
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock autohide -bool true

# Restart the Dock to apply changes
killall Dock
echo "Dock customization complete! 🎉"

# Step 8: Enable Advanced Finder Settings
echo "Configuring advanced Finder settings..."

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Apply Finder settings by restarting Finder
echo "Applying Finder settings..."
killall Finder
echo "Finder customization complete! 🚀"

# Step 5: Set Wallpaper to Solar Gradients
WALLPAPER_PATH="/System/Library/Desktop Pictures/Solar Gradients.madesktop"

# Check if wallpaper file exists
if [[ -f "$WALLPAPER_PATH" ]]; then
    echo "Setting wallpaper to Solar Gradients..."

    # Set wallpaper using AppleScript
    osascript -e "
    tell application \"System Events\"
        set picture of every desktop to \"$WALLPAPER_PATH\"
    end tell
    "

    echo "Wallpaper set to Solar Gradients! 🌅"
else
    echo "Solar Gradients wallpaper not found at $WALLPAPER_PATH."
fi

echo "Setup completed successfully! 🌈"