#!/usr/bin/env bash
set -euo pipefail

# === Load Shared Dependencies ===
source "$(dirname "$0")/../lib/env.sh"
source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../lib/main.sh"

# === Load All Functional Modules ===
for mod in image container logs volume_network compose cleanup login; do
  source "$(dirname "$0")/../lib/${mod}.sh"
done

# === MAIN LOOP ===
main() {
  while true; do
    show_main_menu
    read -rp "$(echo -e "${BOLD}Enter your choice [1-8]: ${RESET}")" choice
    case "$choice" in
      1) image_management_menu ;;
      2) container_management_menu ;;
      3) logs_exec_menu ;;
      4) volume_network_menu ;;
      5) compose_menu ;;
      6) cleanup_menu ;;
      7) docker_hub_login ;;
      8) exit_script ;;
      *) error_prompt "Invalid choice" ;;
    esac
    prompt_continue
  done
}


# === START APP ===
main
