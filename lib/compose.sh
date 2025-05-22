
# === COMPOSE ===
compose_menu() {
    while true; do
        ascii_header
        echo -e "${YELLOW}┌───────────── ${BOLD}COMPOSE & AUTOMATION${RESET}${YELLOW} ─────────────┐"
        echo -e "│  ${BOLD}1.${RESET}  Start Compose Services                    │"
        echo -e "│  ${BOLD}2.${RESET}  Stop Compose Services                     │"
        echo -e "│  ${BOLD}3.${RESET}  View Compose Logs                         │"
        echo -e "│  ${BOLD}4.${RESET}  Back to Main Menu                         │"
        echo -e "└────────────────────────────────────────────────┘${RESET}"
        read -p "Choice [1-4]: " ch
        case $ch in
            
            1)
    echo "Checking for docker-compose.yml or compose.yml in current directory..."
    if [[ -f "docker-compose.yml" || -f "compose.yml" ]]; then
        echo "Compose file found."

        read -rp "Do you want to start the compose services? [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            docker compose up -d
            if [[ $? -eq 0 ]]; then
                echo "✅ Compose services started successfully."
                log_action "Compose started"
            else
                echo "❌ Failed to start compose services."
            fi
        else
            echo "Operation cancelled."
        fi
    else
        echo "❌ No compose file found in the current directory."
        echo "Make sure you're in the correct project folder with a docker-compose.yml file."
    fi
    ;;

            2) docker compose down && log_action "Compose stopped" ;;
            3) docker compose logs ;;
            4) break ;;
            *) error_prompt "Invalid choice" ;;
        esac
        prompt_continue
    done
}