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

# Step 3: Install Packages with Homebrew
echo "Installing essential packages with Homebrew..."
brew install git node deno python3 wget cmake htop jq tree mas handbrake tailscale get_iplayer

# Verification of essential packages
echo "Verifying essential packages installation..."
echo "Git version: $(git --version)"
echo "Node version: $(node -v)"
echo "Deno version: $(deno --version)"
echo "Python version: $(python3 --version)"
echo "Wget version: $(wget --version | head -n 1)"
echo "CMake version: $(cmake --version | head -n 1)"
echo "HTop version: $(htop --version)"
echo "JQ version: $(jq --version)"
echo "Tree version: $(tree --version)"
echo "HandBrakeCLI version: $(HandBrakeCLI --version | head -n 1)"
echo "Tailscale version: $(tailscale version)"
echo "Get iPlayer version: $(get_iplayer version)"

# Step 4: Install GUI Applications with Homebrew Cask
echo "Installing GUI applications with Homebrew Cask..."

# Browsers
echo "Installing browsers..."
brew install --cask google-chrome microsoft-edge firefox-developer arc

# Development Tools
echo "Installing development tools..."
brew install --cask visual-studio-code docker dbngin tableplus

# Design Tools
echo "Installing design tools..."
brew install --cask affinity-designer affinity-photo affinity-publisher figma

# Work Tools
echo "Installing work tools..."
brew install --cask microsoft-outlook microsoft-word microsoft-powerpoint microsoft-excel microsoft-teams loom

# Miscellaneous Tools
echo "Installing miscellaneous tools..."
brew install --cask 1password chatgpt notion github monitorcontrol whatsapp transmit transmission onyx discord steam warp logi-options+ raycast geekbench geekbench-ai adguard stremio mullvadvpn clipy screen-studio vanilla audacity keyboardcleantool balenaetcher openmtp gog-galaxy

# Media Tools
echo "Installing media tools..."
brew install --cask spotify iina plex sony-ps-remote-play

# Verification of GUI applications installed with Homebrew Cask
echo "Verifying GUI applications installation..."
for app in google-chrome microsoft-edge firefox-developer arc visual-studio-code docker dbngin tableplus \
            affinity-designer affinity-photo affinity-publisher figma microsoft-outlook microsoft-word \
            microsoft-powerpoint microsoft-excel microsoft-teams loom 1password chatgpt notion github \
            monitorcontrol whatsapp transmit transmission onyx discord steam warp logi-options+ raycast \
            geekbench geekbench-ai adguard stremio mullvadvpn clipy screen-studio vanilla spotify iina plex \
            sony-ps-remote-play audacity keyboardcleantool balenaetcher openmtp gog-galaxy; do
    if brew list --cask "$app" &>/dev/null; then
        echo "$app is installed"
    else
        echo "Error: $app did not install successfully"
    fi
done

# Step 5: Install GUI Applications from the Mac App Store using mas
echo "Installing applications from the Mac App Store using mas..."

# Ensure mas is available
if ! command -v mas &> /dev/null; then
    echo "mas CLI tool is not available. Ensure it was installed with Homebrew before continuing."
    exit 1
fi

mas install 497799835   # Xcode
mas install 937984704   # Amphetamine
mas install 928871589   # Contrast
mas install 571213070   # DaVinci Resolve
mas install 880001334   # Reeder
mas install 1246651828  # Crouton
mas install 1289583905  # Pixelmator Pro
mas install 1549538329  # Beat
mas install 1502839586  # Hand Mirror
mas install 1484348796  # Endel
mas install 1136220934  # Infuse
mas install 1497435571  # Simple Comic
mas install 470158793   # Keka

# Verification of Mac App Store applications installed with mas
echo "Verifying Mac App Store applications installation..."
for app in 497799835 937984704 928871589 571213070 880001334 1246651828 1289583905 1549538329 \
           1502839586 1484348796 1136220934 1497435571 470158793; do
    if mas list | grep -q "$app"; then
        echo "App ID $app is installed"
    else
        echo "Error: App ID $app did not install successfully"
    fi
done


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