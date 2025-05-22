
# === VOLUME & NETWORK ===
volume_network_menu() {
    while true; do
        ascii_header
        echo -e "${YELLOW}┌────── ${BOLD}VOLUME & NETWORK MANAGEMENT${RESET}${YELLOW} ───────────┐"
        echo -e "│  ${BOLD}1.${RESET}  List Volumes                            │"
        echo -e "│  ${BOLD}2.${RESET}  Remove Volume                           │"
        echo -e "│  ${BOLD}3.${RESET}  List Networks                           │"
        echo -e "│  ${BOLD}4.${RESET}  Remove Network                          │"
        echo -e "│  ${BOLD}5.${RESET}  Back to Main Menu                       │"
        echo -e "└──────────────────────────────────────────────┘${RESET}"
        read -p "Choice [1-5]: " ch
        case $ch in
            1) docker volume ls ;;
        

        2)
    echo "Available Docker volumes:"
    mapfile -t volumes < <(docker volume ls --format "{{.Name}}")

    if [[ ${#volumes[@]} -eq 0 ]]; then
        echo "No volumes found."
    else
        for i in "${!volumes[@]}"; do
            printf "  %2d. %s\n" $((i+1)) "${volumes[i]}"
        done

        while true; do
            read -p "Enter the number of the volume to remove: " vnum
            if [[ ! "$vnum" =~ ^[0-9]+$ ]] || (( vnum < 1 || vnum > ${#volumes[@]} )); then
                echo "❌ Invalid selection. Please enter a valid number."
            else
                break
            fi
        done

        selected_volume="${volumes[vnum-1]}"
        echo "You selected: $selected_volume"
        read -p "Are you sure you want to delete this volume? (y/N): " confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            docker volume rm "$selected_volume"
            echo "✅ Volume '$selected_volume' removed."
        else
            echo "❎ Operation canceled."
        fi
    fi
    prompt_continue
    ;;

            3) docker network ls ;;
        
4)
    echo "Available Docker networks (excluding default ones):"
    mapfile -t networks < <(docker network ls --format '{{.Name}}' | grep -vE '^bridge$|^host$|^none$')

    if [[ ${#networks[@]} -eq 0 ]]; then
        echo "No removable networks found."
    else
        for i in "${!networks[@]}"; do
            printf "  %2d. %s\n" $((i+1)) "${networks[i]}"
        done

        while true; do
            read -p "Enter the number of the network to remove: " nnum
            if [[ ! "$nnum" =~ ^[0-9]+$ ]] || (( nnum < 1 || nnum > ${#networks[@]} )); then
                echo "❌ Invalid selection. Please enter a valid number."
            else
                break
            fi
        done

        selected_network="${networks[nnum-1]}"
        echo "You selected: $selected_network"
        read -p "Are you sure you want to delete this network? (y/N): " confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            docker network rm "$selected_network"
            echo "✅ Network '$selected_network' removed."
        else
            echo "❎ Operation canceled."
        fi
    fi
    prompt_continue
    ;;


            5) break ;;
            *) error_prompt "Invalid choice" ;;
        esac
        prompt_continue
    done

}