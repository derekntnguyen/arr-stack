# --- Configuration ---
# You can keep the token here or set it as a system env var
export BWS_ACCESS_TOKEN := ${BWS_ACCESS_TOKEN}

# System Variables
export TZ := America/Chicago
export PUID := 1000
export PGID := 1000
export NAS_PATH := /mnt/nas

# --- Commands ---

.PHONY: up down restart logs pull healthcheck

# Standard 'up' command wrapped in Bitwarden injection
up:
	bws run -- 'docker compose up -d'

# Stop the stack
down:
	docker compose down

# Pull newest images and restart
update:
	docker compose pull
	bws run -- 'docker compose up -d'

# View logs for the whole stack
logs:
	docker compose logs -f

# Verify secrets are actually loading from Bitwarden
healthcheck:
	@bws run -- 'echo "Verifying Bitwarden Connection..."; \
	if [ -n "$$RADARR_API_KEY" ]; then echo "✅ RADARR_API_KEY: Found"; else echo "❌ RADARR_API_KEY: Missing"; fi; \
	if [ -n "$$SONARR_API_KEY" ]; then echo "✅ SONARR_API_KEY: Found"; else echo "❌ SONARR_API_KEY: Missing"; fi'

# Restart Buildarr specifically (handy for config changes)
sync-config:
	docker restart buildarr
	docker logs -f buildarr
