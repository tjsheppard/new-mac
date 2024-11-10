#!/bin/bash

# Install Mac App Store Apps from mas-apps.txt
echo -e "${BLUE}Installing Mac App Store applications from mas-apps.txt...${NC}"

# Ensure mas is installed
if ! command -v mas &>/dev/null; then
    echo -e "${BLUE}Installing mas (Mac App Store CLI tool)...${NC}"
    brew install mas && echo -e "${CHECK_MARK} mas installed." || echo -e "${CROSS_MARK} Failed to install mas."
fi

# Read each line from mas-apps.txt, skipping comments and empty lines
while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue  # Skip comments and empty lines

    app_id=$(echo "$line" | awk '{print $1}')
    app_name=$(echo "$line" | cut -d' ' -f2-)

    echo -e "Installing ${app_name}..."
    if mas purchase "$app_id" &>/dev/null; then
        echo -e "${CHECK_MARK} ${app_name} installed."
    else
        echo -e "${CROSS_MARK} Failed to install ${app_name}."
    fi
done < mas-apps.txt