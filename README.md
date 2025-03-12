# Dockerized Hosting with Automated Backups

A Docker-based hosting solution featuring WordPress sites, a static site, Nginx as a reverse proxy, SSL support via Certbot, and automated backups for all hosted content.

## Overview
This project provides a scalable hosting environment with:
- Two WordPress instances (PHP 8.3) for dynamic sites.
- A static site served directly by Nginx.
- MySQL database with phpMyAdmin for management.
- Nginx for routing and SSL termination.
- Automated daily, weekly, and monthly backups for all site data.

## Directory Structure
```
.
├── Backup-scripts/         # Backup scripts for daily, weekly, and monthly schedules
│   ├── Daily/
│   ├── Weekly/
│   └── Monthly/
├── README.md              # Project documentation
├── certbot/               # SSL certificates and Certbot data (ignored in git)
├── docker-compose.yaml    # Main Docker Compose configuration
├── docker-compose_ssl.yaml # Configuration for obtaining SSL certificates
├── nginx/                 # Nginx configuration and logs
│   ├── conf/
│   │   └── app.conf
│   └── var/log/
├── static_site/           # Static site files
├── wp_instance1/          # First WordPress instance
│   ├── .env (ignored)
│   └── public_html/
├── wp_instance2/          # Second WordPress instance
│   ├── .env (ignored)
│   └── public_html/
├── backups/ (ignored)     # Backup storage (created by Docker)
├── .env.example           # Example environment file
└── .gitignore             # Git ignore rules
```

## Prerequisites
- Docker
- Docker Compose
- SSH client (e.g., OpenSSH) for phpMyAdmin access

## Setup Instructions
### 1. Clone the Repository
```bash
git clone <repo-url>
cd dockerized-hosting
```

### 2. Configure Environment Variables
Copy `.env.example` to `.env` in both `wp_instance1/` and `wp_instance2/`:
```bash
cp .env.example wp_instance1/.env
cp .env.example wp_instance2/.env
```
Edit each `.env` file with your database credentials:
```
WORDPRESS_DB_NAME=your_database_name
WORDPRESS_DB_USER=your_database_user
WORDPRESS_DB_PASSWORD=your_database_password
MYSQL_DATABASE=your_database_name  # Should match WORDPRESS_DB_NAME
MYSQL_USER=your_database_user       # Should match WORDPRESS_DB_USER
MYSQL_PASSWORD=your_database_password # Should match WORDPRESS_DB_PASSWORD
```
> **Note:** Ensure `WORDPRESS_*` and `MYSQL_*` values align for each instance, as they share the same MySQL service.

### 3. Customize Nginx
Edit `nginx/conf/app.conf` to replace example domains (`example-wp1.com`, `example-wp2.com`, `example-static.com`) with your own domains and update SSL certificate paths if needed.

### 4. Start the Services
```bash
docker-compose up -d
```

### 5. Obtain SSL Certificates (Optional)
Edit `docker-compose_ssl.yaml` with your domain and email, then run:
```bash
docker-compose -f docker-compose_ssl.yaml up
```

## Accessing phpMyAdmin
For security, phpMyAdmin is bound to `127.0.0.1:8080` on the server and is not exposed publicly. To access it securely from your local machine, use SSH port forwarding:
```bash
ssh -L 127.0.0.1:8001:127.0.0.1:8080 root@server-ip
```
Then, open your browser and go to `http://localhost:8001`.

> This method ensures that phpMyAdmin is only accessible through an encrypted SSH connection.

## Services
- **mysql**: MySQL 8.3.0 database for WordPress.
- **PMA**: phpMyAdmin for database management (accessible via SSH tunnel).
- **wp_instance1**: First WordPress site (PHP 8.3).
- **wp_instance2**: Second WordPress site (PHP 8.3).
- **nginx**: Reverse proxy and static site server (port 443).
- **backup**: Automated backup service using cron.

## Backup Configuration
The backup service automates backups for `wp_instance1/public_html`, `wp_instance2/public_html`, and `static_site`. Backups are stored in the `backups` volume (mapped to `./backups/` on the host).

### Daily Backups:
- Incremental backups stored in `/Backup/Daily/`.
- Kept for 7 days.
- Script: `Backup-scripts/Daily/daily-*.sh`.

### Weekly Backups:
- Full backups + archived daily backups stored in `/Backup/Weekly/`.
- Kept for 30 days.
- Script: `Backup-scripts/Weekly/weekly-*.sh`.

### Monthly Backups:
- Archived weekly backups stored in `/Backup/Monthly/`.
- Kept for 365 days.
- Script: `Backup-scripts/Monthly/monthly-*.sh`.

## Customization
- To change backup targets, edit the `target_dir` variable in the backup scripts.
- Adjust backup retention by modifying the `find ... -mtime` commands in the scripts.

## Notes
- Ensure backup scripts are executable:
  ```bash
  chmod +x Backup-scripts/*/*
  ```
- SSL certificates and sensitive data (e.g., `.env` files) are excluded from git via `.gitignore`.
- For database backups, consider adding a `mysqldump` script to the backup service (not included by default).

## Contributing
Feel free to fork this repository, submit issues, or send pull requests to improve the project!

## License
This project is open-source and available under the **GNU General Public License v3.0** (LICENSE).