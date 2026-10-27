# Mission 10: The Enterprise Cloud Architect
## Operational Manual

**Course:** CCM101 – Cloud Computing  
**Server:** Ubuntu Server 26.04.1 LTS  
**Virtual Machine:** CCM101-Mission10-Server  
**Administrator:** cloudadmin

---

## 1. System Overview

This project uses Ubuntu Server running in Oracle VirtualBox. Docker Compose manages two connected containers: WordPress and MySQL. MySQL stores the WordPress database, while Docker volumes preserve application and database data.

## 2. Accessing the Website

1. Start the Ubuntu virtual machine.
2. Log in using the Ubuntu administrator account.
3. Ensure the Docker containers are running.
4. Open a browser on the host computer.
5. Visit **http://127.0.0.1:8080**.

## 3. Managing Docker Containers

Open a terminal and navigate to the project directory:

```bash
cd ~/mission10
```

Check container status:

```bash
docker compose ps
```

Start the services:

```bash
docker compose up -d
```

Stop the services:

```bash
docker compose down
```

## 4. Firewall Configuration

The UFW firewall is enabled with incoming connections denied by default. SSH on port 22 and the WordPress application on port 8080 are allowed.

Check the firewall:

```bash
sudo ufw status verbose
```

## 5. Database Backup

The automated backup script saves MySQL database backups in:

`/home/cloudadmin/mission10/backups/`

Run a backup manually:

```bash
~/mission10/automation-script.sh
```

View existing backups:

```bash
ls -lh ~/mission10/backups/
```

The backup is scheduled to run daily at 2:00 AM using Cron.

Check the scheduled task:

```bash
crontab -l
```

## 6. Troubleshooting

**Website is unavailable**
- Check whether the virtual machine is running.
- Run `docker compose ps`.
- Restart the services using `docker compose up -d`.
- Confirm that VirtualBox port forwarding for port 8080 is configured.

**Database container is unhealthy**
- Run `docker compose logs database`.
- Check the database container status.
- Verify that the `.env` file exists and contains the correct database settings.

**Firewall access problems**
- Run `sudo ufw status verbose`.
- Confirm that the required ports are allowed.

## 7. Security and Maintenance

- Keep Ubuntu and Docker updated.
- Use strong passwords.
- Do not upload the `.env` file or database credentials to GitHub.
- Keep backup files in a secure location.
- Test backups periodically.

## 8. Conclusion

This project demonstrates virtual machine provisioning, Docker containerization, persistent storage, firewall configuration, and automated database backups using Cron.
