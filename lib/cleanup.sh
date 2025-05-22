
# === SYSTEM CLEANUP ===
cleanup_menu() {
    while true; do
        ascii_header
        echo -e "${YELLOW}┌────────────── ${BOLD}SYSTEM CLEANUP${RESET}${YELLOW} ───────────────┐"
        echo -e "│  ${BOLD}1.${RESET}  Prune All (Images/Containers/Networks) │"
        echo -e "│  ${BOLD}2.${RESET}  Remove All Stopped Containers          │"
        echo -e "│  ${BOLD}3.${RESET}  Remove All Unused Volumes              │"
        echo -e "│  ${BOLD}4.${RESET}  Back to Main Menu                      │"
        echo -e "└─────────────────────────────────────────────┘${RESET}"
        read -p "Choice [1-4]: " ch
        case $ch in
            1) confirm_action && docker system prune -a ;;
            2) docker container prune ;;
            3) docker volume prune ;;
            4) break ;;
            *) error_prompt "Invalid choice" ;;
        esac
        prompt_continue
    done
}
