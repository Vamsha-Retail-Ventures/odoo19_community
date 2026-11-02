# Vamsha Community (Odoo v19)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/)

A production-ready Odoo v19 Community architecture tailored for development in **GitHub Codespaces** and deployment with **Docker Compose**.

---

## Architecture Overview

* **Odoo Web Service:** `vamsha-odoo19-community-web` running Odoo 19.0 Community (`odoo:19.0`).
* **Database Service:** `vamsha-odoo19-community-db` running PostgreSQL 16 (`postgres:16`) with automatic healthchecks.
* **Network:** Isolated bridge network `odoo-network`.
* **Addons Paths:** Dual mounting supporting both Codespace root (`/workspace/custom_addons`) and official Odoo standard (`/mnt/extra-addons`).
* **Log Rotation:** Docker JSON log driver with size limits (`10m`, 3 rotated files) to prevent disk exhaustion.

---

## Getting Started inside Codespace

### Option A: Using GitHub Codespaces Secrets (Recommended)
1. Go to your GitHub Repository **Settings** &rarr; **Secrets and variables** &rarr; **Codespaces**.
2. Add `POSTGRES_USER` (or `USER`), `POSTGRES_PASSWORD` (or `PASSWORD`), and `ODOO_ADMIN_PASSWORD`.
3. Launch the Codespace—everything will configure and start automatically.

### Option B: Manual `.env` Setup
1. Launch the Codespace (safe fallback defaults allow the container to boot on first run).
2. Copy `.env.example` to `.env` (or upload your `.env` and `config/odoo.conf` files).
3. Rebuild or restart the containers via `docker compose up -d`.

---

## Accessing Odoo

1. Open the **Ports** tab in VS Code and click the globe icon next to port `8069` (or visit `http://localhost:8069`).
2. Enable **Developer Mode** inside Odoo (**Settings** &rarr; **Activate the developer mode**), then go to **Apps** &rarr; **Update Apps List** to see your custom addons.

---

## Useful Development CLI Commands

* **Scaffold a new module:**
  ```bash
  odoo scaffold my_module /workspace/custom_addons
  ```
* **Upgrade a module from terminal:**
  ```bash
  odoo -d <your_db_name> -u my_module --stop-after-init
  ```
* **Direct container access (from host):**
  ```bash
  docker exec -it vamsha-odoo19-community-web bash
  docker exec -it vamsha-odoo19-community-db psql -U odoo -d postgres
  ```

---

## Database Backup & Restore Utilities

Lightweight helper scripts are available in `./scripts`:

* **Create a database backup:**
  ```bash
  ./scripts/backup.sh [database_name]
  ```
  Saves a gzipped PostgreSQL dump to `./backups/<database_name>_<timestamp>.sql.gz`.

* **Restore a database backup:**
  ```bash
  ./scripts/restore.sh backups/<backup_file>.sql.gz [database_name]
  ```

---

## Multi-Worker Production Scaling

For local development, Odoo runs in single-process hot-reload mode (`--dev=reload,qweb,xml`).

When moving toward production or load testing, you can enable multi-worker processing by updating `config/odoo.conf`:
```ini
; Multi-Worker Production Settings
workers = 2
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
limit_request = 8192
```
And removing `--dev=reload,qweb,xml` from `command:` in `docker-compose.yml`.
