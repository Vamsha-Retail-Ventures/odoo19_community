# Vamsha Community (Odoo v19)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/)

## Getting Started inside Codespace

### Option A: Using GitHub Codespaces Secrets (Recommended)
1. Go to your GitHub Repository **Settings** &rarr; **Secrets and variables** &rarr; **Codespaces**.
2. Add `DB_USER`, `DB_PASSWORD`, and `ODOO_ADMIN_PASSWD`.
3. Launch the Codespace—everything will configure and start automatically.

### Option B: Manual `.env` Setup
1. Launch the Codespace (safe fallback defaults allow the container to boot on first run).
2. Copy `.env.example` to `.env` (or upload your `.env` and `config/odoo.conf` files).
3. Rebuild or restart the containers via `docker compose up -d`.

## Accessing Odoo
1. Open the **Ports** tab in VS Code and click the globe icon next to port `8069` (or visit `http://localhost:8069`).
2. Enable **Developer Mode** inside Odoo (**Settings** &rarr; **Activate the developer mode**), then go to **Apps** &rarr; **Update Apps List** to see your custom addons.

## Useful CLI Commands
* **Scaffold a new module:**
  ```bash
  odoo scaffold my_module /workspace/custom_addons
  ```
* **Upgrade a module from terminal:**
  ```bash
  odoo -d <your_db_name> -u my_module --stop-after-init
  ```
