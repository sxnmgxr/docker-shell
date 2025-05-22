#!/bin/bash

# ======================================================
# Docker Management Shell v1.3
# Author: Sujan Magar
# 
# Description: An interactive CLI tool for managing Docker
# containers, images, volumes, networks, and more.
#
# Dependencies: Docker, Bash
# ======================================================


# === CONFIGURATION ===
LOG_FILE="docker_task_log.txt"
[ ! -f "$LOG_FILE" ] && touch "$LOG_FILE"

# === ENVIRONMENT SETUP ===
# 1) Pick the right Docker Compose command
if command -v docker-compose &>/dev/null; then
  COMPOSE_CMD="docker-compose"
else
  COMPOSE_CMD="docker compose"
fi

# 2) Trap interrupts to restore terminal colors
trap 'tput sgr0; exit' INT TERM

# === COLORS ===
GREEN='\e[1;32m' RED='\e[1;31m' BLUE='\e[1;34m'
YELLOW='\e[1;33m' MAGENTA='\e[1;35m' CYAN='\e[1;36m'
BOLD='\e[1m' RESET='\e[0m'
# 3) Set terminal colors

# === UTILITY FUNCTIONS ===
log_action() {
    echo -e "${GREEN}✔ $1${RESET}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}
error_prompt() {
    echo -e "${RED}✖ $1${RESET}"
}
prompt_continue() {
    read -p "$(echo -e "${BOLD}Press [Enter] to continue...${RESET}")"
}
confirm_action() {
    read -p "$(echo -e "${YELLOW}⚠ Are you sure? (y/n): ${RESET}")" choice
    [[ "$choice" =~ ^[Yy]$ ]]
}

# === ASCII HEADER ===
ascii_header() {
    clear
    echo -e "${CYAN}"
    echo -e "\e[3mWelcome to Docker Management Shell.\e[0m"
    echo "    ____             __                  _____ __         ____"
    echo "   / __ \____  _____/ /_____  _____     / ___// /_  ___  / / /"
    echo "  / / / / __ \/ ___/ //_/ _ \/ ___/_____\__ \/ __ \/ _ \/ / / "
    echo " / /_/ / /_/ / /__/ ,< /  __/ /  /_____/__/ / / / /  __/ / /  "
    echo "/_____/\____/\___/_/|_|\___/_/        /____/_/ /_/\___/_/_/   "
    echo -e "${RESET}"
    echo -e "${YELLOW}┌──────────────────────────────────────────────────────┐"
    echo -e "│    ${BOLD}${MAGENTA}Docker Container & Service Management Tool${RESET}${YELLOW}        │"
    echo -e "└──────────────────────────────────────────────────────┘${RESET}"
    echo -e "${GREEN}System: $(uname -srm)"
    echo -e  "${GREEN}Date: $(date)${RESET}\n"
}
