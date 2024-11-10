#!/bin/bash

# Ensure script is run with elevated privileges
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run as root or with sudo."
    exit
fi

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

# Step 3: Install Packages from brew-apps.txt
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

# Step 4: Install Mac App Store Apps from mas-apps.txt
echo "Installing Mac App Store applications from mas-apps.txt..."
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

    app_id=$(echo "$line" | awk '{print $1}')
    app_name=$(echo "$line" | cut -d' ' -f2-)
    echo "Installing $app_name..."
    mas install "$app_id"
done < mas-apps.txt

# Step 6: Clean up Homebrew
echo "Cleaning up Homebrew installations..."
brew cleanup

# Step 7: Customize the macOS Dock
echo "Customizing the macOS Dock..."

# Clear all applications from the Dock
defaults write com.apple.dock persistent-apps -array

# Position Dock on the left, set size, enable magnification, and auto-hide
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock mineffect -string "scale"

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

# Set default Finder location to Home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Set Finder to display items in list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable text selection in Quick Look previews
defaults write com.apple.finder QLEnableTextSelection -bool true

# Apply Finder settings by restarting Finder
echo "Applying Finder settings..."
killall Finder
echo "Finder customization complete! 🚀"

# Step 9: Set Wallpaper to Solar Gradients
WALLPAPER_PATH="/System/Library/Desktop\ Pictures/Solar Gradients.madesktop"

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