# New Mac

This repository contains a script to automate the setup of a new Mac environment with essential tools, applications, and custom configurations. Designed for developers and power users, this script installs command-line utilities, GUI applications, and applies system preferences to streamline your workflow on macOS.

## Features

- Installs Xcode Command Line Tools
- Installs and updates Homebrew, along with essential CLI tools (e.g., Git, Node, Python)
- Installs development, productivity, and media applications using Homebrew Cask
- Installs select applications from the Mac App Store via `mas`
- Configures macOS Dock and Finder with developer-friendly settings
- Sets the desktop wallpaper to "Solar Gradients"

## Prerequisites

- macOS (compatible with recent macOS versions)
- An active internet connection
- Apple ID (required for Mac App Store installations)

## Usage

Clone the repository:
```bash
git clone https://github.com/tjsheppard/new-mac.git
```
Navigate to the script's Location:
```bash
cd new-mac
```
Grant permission to run the script:
```bash
chmod +x mac-setup.sh
```
Run the script with sudo:
```bash
sudo ./mac-setup.sh
```