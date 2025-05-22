

# === LOGS & EXEC ===
logs_exec_menu() {
    while true; do
        ascii_header
        echo -e "${YELLOW}┌──────────── ${BOLD}LOGS & EXECUTION${RESET}${YELLOW} ─────────────┐"
        echo -e "│  ${BOLD}1.${RESET}  View Container Logs                  │"
        echo -e "│  ${BOLD}2.${RESET}  Exec Command in Container            │"
        echo -e "│  ${BOLD}3.${RESET}  Attach to Container                  │"
        echo -e "│  ${BOLD}4.${RESET}  Back to Main Menu                    │"
        echo -e "└───────────────────────────────────────────┘${RESET}"
        read -p "Choice [1-4]: " choice
        case $choice in
            
         #   2) read -p "Container: " cid; read -p "Command: " cmd; docker exec -it "$cid" $cmd ;;
2)
  clear
  echo "=== Exec command inside running container ==="

  # Fetch container details (ID, Name, Image, Status)
  mapfile -t containers < <(docker ps --format "{{.ID}}|{{.Names}}|{{.Image}}|{{.Status}}")

  if [[ ${#containers[@]} -eq 0 ]]; then
    echo "No running containers found."
    read -rp "Press Enter to return to menu..."
  else
    # Print header
    printf "%-4s %-15s %-25s %-20s %s\n" "No." "CONTAINER ID" "NAME" "IMAGE" "STATUS"
    echo "------------------------------------------------------------------------------------"

    # Print container info line by line with numbering
    for i in "${!containers[@]}"; do
      IFS='|' read -r cid cname cimage cstatus <<< "${containers[i]}"
      printf "%-4s %-15s %-25s %-20s %s\n" $((i+1)) "$cid" "$cname" "$cimage" "$cstatus"
    done

    # Ask user to select container number with validation loop
    while true; do
      read -rp "Enter the number of the container to exec in (opens interactive shell): " num
      if [[ ! "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#containers[@]} )); then
        echo "Invalid selection. Please enter a number between 1 and ${#containers[@]}."
      else
        break
      fi
    done

    # Parse the selected container info
    IFS='|' read -r cid cname cimage cstatus <<< "${containers[num-1]}"

    echo "Opening interactive shell inside container '$cname' ($cid)..."

    # Check if bash exists, else fallback to sh
    if docker exec "$cid" which bash &>/dev/null; then
      shell="/bin/bash"
    else
      shell="/bin/sh"
    fi

    # Open interactive shell inside the container
    docker exec -it "$cid" "$shell"
    exec_status=$?

    if [[ $exec_status -ne 0 ]]; then
      echo "Failed to open shell with exit code $exec_status"
    fi

    read -rp "Press Enter to return to menu..."
  fi
  ;;


3)
  clear
  echo "=== Attach to a running container ==="

  # Fetch running containers into an array with details
  mapfile -t containers < <(docker ps --format "{{.ID}} {{.Names}} {{.Image}} {{.Status}}")

  if [[ ${#containers[@]} -eq 0 ]]; then
    echo "No running containers found."
    read -rp "Press Enter to return to menu..."
  else
    # Print header row with aligned columns
    printf "%-4s %-12s %-20s %-25s %-20s\n" "No." "CONTAINER ID" "NAME" "IMAGE" "STATUS"

    # Print each container info aligned in columns
    for i in "${!containers[@]}"; do
      cid=$(awk '{print $1}' <<< "${containers[i]}")
      cname=$(awk '{print $2}' <<< "${containers[i]}")
      cimage=$(awk '{print $3}' <<< "${containers[i]}")
      cstatus=$(awk '{$1=$2=$3=""; print substr($0,4)}' <<< "${containers[i]}")

      printf "%-4s %-12s %-20s %-25s %-20s\n" "$((i+1))." "$cid" "$cname" "$cimage" "$cstatus"
    done

    # Prompt for user selection with validation
    while true; do
      read -rp "Enter the number of the container to attach to: " num
      if [[ ! "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > ${#containers[@]} )); then
        echo "Invalid selection. Please enter a number between 1 and ${#containers[@]}."
      else
        break
      fi
    done

    selected="${containers[num-1]}"

    # Extract container details
    cid=$(awk '{print $1}' <<< "$selected")
    cname=$(awk '{print $2}' <<< "$selected")
    cimage=$(awk '{print $3}' <<< "$selected")
    cstatus=$(awk '{$1=$2=$3=""; print substr($0,4)}' <<< "$selected")

    echo
    echo "Selected container details:"
    echo "  Name:   $cname"
    echo "  ID:     $cid"
    echo "  Image:  $cimage"
    echo "  Status: $cstatus"
    echo
    echo "Attaching to container '$cname' ($cid)..."
    echo "To detach safely, press Ctrl+P followed by Ctrl+Q"
    echo

    # Attach to the container
    docker attach "$cid"
    attach_status=$?

    if [[ $attach_status -ne 0 ]]; then
      echo "docker attach exited with status $attach_status"
    else
      echo "Detached from container."
    fi

    read -rp "Press Enter to return to menu..."
  fi
;;

            4) break ;;
            *) error_prompt "Invalid choice" ;;
        esac
        prompt_continue
    done
}
