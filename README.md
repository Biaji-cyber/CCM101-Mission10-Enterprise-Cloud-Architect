# Mission 10: The Enterprise Cloud Architect

## Project Overview
This project demonstrates an Ubuntu Server virtual machine running in Oracle VirtualBox, with Docker Compose managing WordPress and MySQL.

## Technologies Used
- Ubuntu Server
- Oracle VirtualBox
- Docker and Docker Compose
- WordPress and MySQL
- UFW Firewall
- Bash and Cron

## Features
- WordPress web application accessible through port 8080
- MySQL database with persistent Docker storage
- Firewall rules for necessary incoming connections
- Automated daily database backups at 2:00 AM

## Project Files
- `architecture-diagram.png` — Network and system architecture
- `docker-compose.yml` — Container configuration
- `automation-script.sh` — Database backup script
- `operational-manual.md` — System operation and troubleshooting guide

## Final Reflection
This mission helped me understand how virtual machines, Linux servers, Docker containers, networking, firewall security, and automation work together in a cloud environment. I applied these concepts by deploying WordPress with MySQL, configuring persistent storage, restricting incoming connections, and scheduling database backups. The earlier missions provided the foundation for understanding and completing this enterprise-style setup.

## Security Note
Database credentials are stored in a local `.env` file and must not be uploaded to GitHub.
