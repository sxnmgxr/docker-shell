#!/usr/bin/env bash
LOG_FILE="docker_task_log.txt"
[ ! -f "$LOG_FILE" ] && touch "$LOG_FILE"
if command -v docker-compose &>/dev/null; then
  COMPOSE_CMD="docker-compose"
else
  COMPOSE_CMD="docker compose"
fi
trap 'tput sgr0; exit' INT TERM
