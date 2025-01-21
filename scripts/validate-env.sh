#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_var() {
    local var_name="$1"
    local var_value="${!var_name}"
    local optional="$2"

    printf "Checking %s... " "$var_name"
    if [ -z "$var_value" ]; then
        if [ "$optional" = "optional" ]; then
            echo -e "${YELLOW}MISSING (optional)${NC}"
            return 0
        else
            echo -e "${RED}MISSING${NC}"
            return 1
        fi
    else
        echo -e "${GREEN}OK${NC}"
        return 0
    fi
}

check_dir() {
    local dir_name="$1"
    printf "Checking directory %s... " "$dir_name"
    if [ -d "$dir_name" ]; then
        echo -e "${GREEN}OK${NC}"
        return 0
    else
        echo -e "${RED}MISSING${NC}"
        return 1
    fi
}

echo "Validating POPL 2025 environment..."
echo "------------------------------------"

# Required variables
required_vars=(
    "CONF_NAME"
    "CONF_YEAR"
    "CONF_LOCATION"
    "PAPERS_DIR"
    "NOTES_DIR"
    "BIB_FILE"
)

# Optional variables
optional_vars=(
    "DISCORD_WEBHOOK_URL"
    "GITHUB_TOKEN"
    "DOCKER_IMAGE_NAME"
    "EMACS_INIT_FILE"
    "TEXMFHOME"
)

# Required directories
required_dirs=(
    "papers"
    "notes"
    "bib"
    "scripts"
    "templates"
)

errors=0

echo "Checking required variables:"
for var in "${required_vars[@]}"; do
    check_var "$var" || ((errors++))
done

echo -e "\nChecking optional variables:"
for var in "${optional_vars[@]}"; do
    check_var "$var" "optional"
done

echo -e "\nChecking required directories:"
for dir in "${required_dirs[@]}"; do
    check_dir "$dir" || ((errors++))
done

echo -e "\nChecking tools:"
if command -v emacs >/dev/null 2>&1; then
    echo -e "Emacs... ${GREEN}OK${NC}"
else
    echo -e "Emacs... ${RED}MISSING${NC}"
    ((errors++))
fi

if command -v docker >/dev/null 2>&1; then
    echo -e "Docker... ${GREEN}OK${NC}"
else
    echo -e "Docker... ${YELLOW}MISSING (optional)${NC}"
fi

if command -v direnv >/dev/null 2>&1; then
    echo -e "direnv... ${GREEN}OK${NC}"
else
    echo -e "direnv... ${RED}MISSING${NC}"
    ((errors++))
fi

echo -e "\nValidation complete with $errors error(s)"
exit $((errors > 0))
