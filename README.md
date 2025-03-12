# Dockerized Hosting

A Docker-based hosting solution with WordPress, MySQL, Nginx, SSL support, and automated backups.

## Structure
- `wp_instance1/` - First WordPress site (PHP 8.3)
- `wp_instance2/` - Second WordPress site (PHP 8.3)
- `static_site/` - Static site served by Nginx
- `nginx/conf/app.conf` - Nginx configuration (edit with your domains)
- `Backup-scripts/` - Contains daily, weekly, and monthly backup scripts

## Setup
### 1. Clone the repository:
```bash
git clone <repo-url>
cd dockerized-hosting
```

### 2. Configure Environment Variables
Copy `.env.example` to `.env` in `wp_instance1/` and `wp_instance2/` and fill in your values.

### 3. Configure Nginx
Edit `nginx/conf/app.conf` with your domains and SSL paths.

### 4. Start the Services
```bash
docker-compose up -d
```

### 5. SSL Configuration (Optional)
To enable SSL, edit `docker-compose_ssl.yaml` and run:
```bash
docker-compose -f docker-compose_ssl.yaml up -d
```

## Backup Configuration
The backup service automates backups using scripts in `Backup-scripts/`.

- **Daily Backups:** Incremental backups stored in `./backups/Daily/` (kept for 7 days).
- **Weekly Backups:** Full backups + archived daily backups stored in `./backups/Weekly/` (kept for 30 days).
- **Monthly Backups:** Archived weekly backups stored in `./backups/Monthly/` (kept for 365 days).

Backups are saved in the `backups` volume and mapped to `./backups/` on the host.

To customize, edit the scripts in `Backup-scripts/` (e.g., change `target_dir`).

## Testing & Deployment
### 1. Ensure Backup Scripts Are Executable
```bash
chmod +x Backup-scripts/*
```

### 2. Start the Project
```bash
docker-compose up -d
```

### 3. Verify Backups
Check that backups are created in:
- `./backups/Daily/`
- `./backups/Weekly/`
- `./backups/Monthly/`