
# === DOCKER HUB LOGIN ===
docker_hub_login() {
    ascii_header
    echo -e "${CYAN}Docker Hub Login${RESET}"
    echo -e "${BOLD}Enter your Docker Hub credentials:${RESET}"
    read -p "Username: " username
    read -s -p "Password: " password
    echo ""
    echo "$password" | docker login -u "$username" --password-stdin \
        && log_action "Successfully logged into Docker Hub as $username" \
        || error_prompt "Login failed. Check your credentials."
    prompt_continue
}