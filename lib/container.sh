
# === CONTAINER MANAGEMENT ===
container_management_menu() {
    while true; do
        ascii_header
        echo -e "${YELLOW}┌─────────── ${BOLD}CONTAINER MANAGEMENT${RESET}${YELLOW} ───────────┐"
        echo -e "│  ${BOLD}1.${RESET}  List Running Containers               │"
        echo -e "│  ${BOLD}2.${RESET}  List All Containers                   │"
        echo -e "│  ${BOLD}3.${RESET}  Start Container                       │"
        echo -e "│  ${BOLD}4.${RESET}  Stop Container                        │"
        echo -e "│  ${BOLD}5.${RESET}  Restart Container                     │"
        echo -e "│  ${BOLD}6.${RESET}  Remove Container                      │"
        echo -e "│  ${BOLD}7.${RESET}  Run New Container                     │"
        echo -e "│  ${BOLD}8.${RESET}  Back to Main Menu                     │"
        echo -e "└────────────────────────────────────────────┘${RESET}"
        read -p "$(echo -e "${BOLD}Enter choice [1-8]: ${RESET}")" ch
        case $ch in
            1) docker ps ;;
        
        2)
    echo -e "${BOLD}List containers:${RESET}"
    echo "1) Running containers only"
    echo "2) All containers (including stopped)"
    read -p "Choose an option [1-2]: " list_choice

    if [[ "$list_choice" == "1" ]]; then
        docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"
    elif [[ "$list_choice" == "2" ]]; then
        docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"
    else
        error_prompt "Invalid choice"
    fi
    ;;


3)
    echo "ID              NAME            IMAGE               STATUS                  IP              HOST PORTS"
    docker ps -a --format "{{.ID}} {{.Names}} {{.Image}} {{.Status}}" | while read -r id name image status; do
        ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$id")
        ports=$(docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}->{{$p}} {{end}}{{end}}' "$id")
        printf "%-15s %-15s %-20s %-22s %-15s %s\n" "$id" "$name" "$image" "$status" "$ip" "$ports"
    done

    echo
    read -p "Enter container ID or name to START: " container_id
    docker start "$container_id" && log_action "Started container $container_id" || error_prompt "Failed to start container"
    ;;







   4)
    # Show containers details first
    echo "ID              NAME            IMAGE               STATUS                  IP              HOST PORTS"
    docker ps -a --format "{{.ID}} {{.Names}} {{.Image}} {{.Status}}" | while read -r id name image status; do
        ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$id")
        ports=$(docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}->{{$p}} {{end}}{{end}}' "$id")
        printf "%-15s %-15s %-20s %-22s %-15s %s\n" "$id" "$name" "$image" "$status" "$ip" "$ports"
    done

    echo
    read -p "Enter container ID or name to STOP: " container_id
    docker stop "$container_id" && log_action "Stopped container $container_id" || error_prompt "Failed to stop container"
    ;;


5)
    # Show containers details first
    echo "ID              NAME            IMAGE               STATUS                  IP              HOST PORTS"
    docker ps -a --format "{{.ID}} {{.Names}} {{.Image}} {{.Status}}" | while read -r id name image status; do
        ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$id")
        ports=$(docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}->{{$p}} {{end}}{{end}}' "$id")
        printf "%-15s %-15s %-20s %-22s %-15s %s\n" "$id" "$name" "$image" "$status" "$ip" "$ports"
    done

    echo
    read -p "Enter container ID or name to RESTART: " container_id
    docker restart "$container_id" && log_action "Restarted container $container_id" || error_prompt "Failed to restart container"
    ;;


            6)
    # Show containers details first
    echo "ID              NAME            IMAGE               STATUS                  IP              HOST PORTS"
    docker ps -a --format "{{.ID}} {{.Names}} {{.Image}} {{.Status}}" | while read -r id name image status; do
        ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$id")
        ports=$(docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}->{{$p}} {{end}}{{end}}' "$id")
        printf "%-15s %-15s %-20s %-22s %-15s %s\n" "$id" "$name" "$image" "$status" "$ip" "$ports"
    done

    echo
    read -p "Enter container ID or name to REMOVE: " container_id
    docker rm "$container_id" && log_action "Removed container $container_id" || error_prompt "Failed to remove container"
    ;;

7)
  read -p "Enter image name: " image_name
  read -p "Enter container name: " container_name
  read -p "Enter host port (e.g., 8080): " host_port
  read -p "Enter container port (e.g., 80): " container_port

  # Volume Mounting
  read -p "Do you want to mount a volume? (y/n): " mount_volume
  if [[ "$mount_volume" == "y" ]]; then
    read -p "Enter host directory path: " host_dir
    read -p "Enter container directory path: " container_dir
    volume_option="-v ${host_dir}:${container_dir}"
  else
    volume_option=""
  fi

  # Environment Variables
  read -p "Do you want to set an environment variable? (y/n): " env_choice
  if [[ "$env_choice" == "y" ]]; then
    read -p "Enter environment variable (e.g., KEY=value): " env_var
    env_option="-e ${env_var}"
  else
    env_option=""
  fi

  # Run container
  docker run -d --name "$container_name" -p "$host_port:$container_port" $volume_option $env_option "$image_name"

  # Show container details
  echo -e "\n🧾 Container Started! Details:"
  docker ps -f name="$container_name"
  ;;

            8) break ;;
            *) error_prompt "Invalid choice" ;;
        esac
        prompt_continue
    done
}
