

# === IMAGE MANAGEMENT ===
image_management_menu() {
    while true; do
        ascii_header
        echo -e "${YELLOW}┌────────────── ${BOLD}IMAGE MANAGEMENT${RESET}${YELLOW} ──────────────┐"
        echo -e "│  ${BOLD}1.${RESET}  Pull Image                              │"
        echo -e "│  ${BOLD}2.${RESET}  List Images                             │"
        echo -e "│  ${BOLD}3.${RESET}  Remove Image                            │"
        echo -e "│  ${BOLD}4.${RESET}  Build from Dockerfile                   │"
        echo -e "│  ${BOLD}5.${RESET}  Tag Image                               │"
        echo -e "│  ${BOLD}6.${RESET}  Inspect Image                           │"
        echo -e "│  ${BOLD}7.${RESET}  Push Image to Registry                  │"
        echo -e "│  ${BOLD}8.${RESET}  Run Container from Image                │"
        echo -e "│  ${BOLD}9.${RESET}  Show Image Cache Layers (History)       │"
        echo -e "│ ${BOLD}10.${RESET}  Back to Main Menu                       │"
        echo -e "└──────────────────────────────────────────────┘${RESET}"
        
        read -p "$(echo -e "${BOLD}Enter choice [1-10]: ${RESET}")" choice
        case $choice in
            1) read -p "Image (e.g. ubuntu:latest): " img; docker pull "$img" && log_action "Pulled $img" || error_prompt "Failed" ;;
            2) docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}" ;;
            3) echo -e "${CYAN}Available Images:${RESET}"
                    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
                echo
                     read -p "Enter Image ID or name to remove: " img
                    confirm_action && docker rmi "$img" && log_action "Removed $img"
                    ;;

            4)
                read -p "Dockerfile dir: " dir
                read -p "Image name: " name
                    if [ ! -d "$dir" ]; then
                    error_prompt "Directory $dir does not exist."
                     continue
                     fi
                    if [ ! -f "$dir/Dockerfile" ]; then
                    error_prompt "No Dockerfile found in $dir."
                    continue
                     fi
                    if ! docker info > /dev/null 2>&1; then
                     error_prompt "Docker daemon is not running."
                    continue
                     fi
                    docker build -t "$name" "$dir"
                     if [ $? -eq 0 ]; then
                     log_action "Built $name"
                    else
                    error_prompt "Docker build failed."
                     fi
                     ;;

           5)
                 echo -e "\n${BOLD}Existing images:${RESET}"
                 docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
                 echo
                read -p "Source Image ID/Name: " src
                 read -p "Target tag (repo:tag): " tag
                 if docker tag "$src" "$tag"; then
                  log_action "Tagged $tag"
                 echo -e "\n${GREEN}Tagging successful! New image details:${RESET}"
                 docker images --filter=reference="$tag" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
                 else
                        error_prompt "Tagging failed"
                fi
                ;;


        6)
             echo -e "\n${BOLD}Existing images:${RESET}"
            docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
            echo
            read -p "Image to inspect: " img
             if docker inspect "$img" | less; then
             echo -e "\n${GREEN}Inspection completed for image: $img${RESET}"
            else
             error_prompt "Inspection failed for image: $img"
             fi
            ;;

    7)
    echo -e "${BOLD}Existing local images:${RESET}"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
    echo ""

    read -p "Do you want to tag an image before pushing? (y/n): " tag_choice
    if [[ "$tag_choice" =~ ^[Yy]$ ]]; then
        read -p "Source Image ID/Name: " src
        read -p "Target tag (format: username/repo:tag): " tag
        docker tag "$src" "$tag" && log_action "Tagged $tag" || { error_prompt "Tagging failed"; continue; }
        img="$tag"
    else
        read -p "Enter image to push (format: username/repo:tag): " img
    fi

    echo "Make sure you are logged in to Docker registry."
    read -p "Do you want to login now? (y/n): " login_choice
    if [[ "$login_choice" =~ ^[Yy]$ ]]; then
        docker login || { error_prompt "Login failed"; continue; }
    fi

    docker push "$img" && log_action "Pushed $img" || error_prompt "Push failed"
    ;;

8)
    echo -e "${BOLD}Existing local images:${RESET}"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
    echo ""

    read -p "Enter the image to run (e.g. ubuntu:latest): " img
    read -p "Run container interactively? (y/n): " interactive_choice

    if [[ "$interactive_choice" =~ ^[Yy]$ ]]; then
        docker run -it "$img"
    else
        read -p "Enter any additional options (e.g. -d -p 8080:80): " extra_opts
        docker run $extra_opts "$img"
    fi

    if [ $? -eq 0 ]; then
        log_action "Ran container from $img"
        echo "Container started successfully."
    else
        error_prompt "Failed to start container."
    fi
    ;;

       9)
    echo -e "${BOLD}Existing local images:${RESET}"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
    echo ""

    read -p "Enter the image to view history (e.g. ubuntu:latest): " img
    if docker history "$img"; then
        log_action "Viewed history for $img"
    else
        error_prompt "Failed to retrieve history for $img"
    fi
    ;;

            10) break ;;
            *) error_prompt "Invalid choice" ;;
        esac
        prompt_continue
    done
}

