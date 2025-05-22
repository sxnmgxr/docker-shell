#!/usr/bin/env bash

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

# === MAIN MENU ===
show_main_menu() {
    ascii_header
    echo -e "${YELLOW}┌──────────────────────────────────────────────┐"
    echo -e "│               ${BOLD}DOCKER MANAGEMENT${RESET}${YELLOW}              │"
    echo -e "├──────────────────────────────────────────────┤"
    echo -e "│  ${BOLD}1.${RESET}  Image Management                        │"
    echo -e "│  ${BOLD}2.${RESET}  Container Management                    │"
    echo -e "│  ${BOLD}3.${RESET}  Logs & Execution                        │"
    echo -e "│  ${BOLD}4.${RESET}  Volume & Network Management             │"
    echo -e "│  ${BOLD}5.${RESET}  Compose & Automation                    │"
    echo -e "│  ${BOLD}6.${RESET}  System Cleanup                          │"
    echo -e "│  ${BOLD}7.${RESET}  Docker Hub Login                        │"
    echo -e "│  ${BOLD}8.${RESET}  Exit                                    │"
    echo -e "└──────────────────────────────────────────────┘${RESET}"
}
