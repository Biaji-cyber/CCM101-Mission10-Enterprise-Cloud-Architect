CCM101 • CLOUD COMPUTING
MISSION 10
THE ENTERPRISE
CLOUD ARCHITECT
OPERATIONAL MANUAL

PROJECT DETAILS	CONFIGURATION
Application stack	WordPress + MySQL + Docker Compose
Server OS	Ubuntu Server 26.04.1 LTS
Hypervisor	Oracle VirtualBox
Server hostname	mission10-server
Web access	http://127.0.0.1:8080


Prepared by: Sheinne Irish C. Cruz | Melody M. Caleb | Virgilio G. Costales Jr. | Justin Zedric N. Espita | Rafael D. Tacipit
Section: BSIT-4J
Instructor: Jenkielyn C. Torres
Date: October 2026

 Contents
•	1. Purpose of the Manual
•	2. Project Overview
•	3. System Architecture
•	4. Base Infrastructure
•	5. Docker Deployment
•	6. Security Hardening
•	7. Application Operations
•	8. Data Persistence and Recovery
•	9. Backup and Cron Automation
•	10. Maintenance Procedures
•	11. Troubleshooting
•	12. Final Verification Checklist
•	13. GitHub Handover Contents
•	14. Final Reflection

 1. Purpose of the Manual
This manual documents the deployment, security, operation, backup, recovery, and maintenance procedures for the Mission 10 Enterprise Cloud Architect environment. It is intended as a practical handover guide for operating the virtual machine, containerized application, firewall, and backup automation.
2. Project Overview
The project deploys a WordPress website backed by a MySQL database. Ubuntu Server runs as a virtual machine in Oracle VirtualBox. Docker Compose manages the application and database containers, while named volumes provide persistent storage. UFW controls incoming traffic, and a Bash script with Cron automates database backups.
Component	Purpose
Ubuntu Server	Runs the container stack and host-level services.
Docker Compose	Defines and starts the WordPress and MySQL services.
WordPress	Provides the web application accessed through the host browser.
MySQL	Stores WordPress application data.
UFW	Applies a default-deny incoming firewall policy.
Bash + Cron	Creates scheduled timestamped database backups.
Named volumes	Preserve WordPress and MySQL data beyond container restarts.

3. System Architecture
The system path is: Windows Host Browser → VirtualBox NAT Port Forwarding → Ubuntu Server → UFW → Docker Engine / Docker Compose → WordPress Container ↔ MySQL Container.
•	The Ubuntu virtual machine is named CCM101-Mission10-Server and uses the hostname mission10-server.
•	The WordPress container is named mission10-wordpress and maps guest port 8080 to container port 80.
•	The MySQL container is named mission10-mysql and communicates with WordPress through the internal Docker network mission10-network.
•	MySQL port 3306 is not published to the host.
•	The named volumes are mysql_data and wordpress_data.
•	The backup script writes timestamped SQL files under /home/cloudadmin/mission10/backups/.
 4. Base Infrastructure
Item	Configuration
Host platform	Windows host computer
Hypervisor	Oracle VirtualBox
Virtual machine	CCM101-Mission10-Server
Guest OS	Ubuntu Server 26.04.1 LTS
Linux account	cloudadmin
Hostname	mission10-server
Web URL from host	http://127.0.0.1:8080
VirtualBox network	NAT with host port 8080 forwarded to guest port 8080
Docker Compose	WordPress + MySQL

5. Docker Deployment
The docker-compose.yml file describes the services, network, and persistent volumes. The local .env file provides database settings and credentials. The real .env file must remain private and must not be committed to GitHub.
Useful commands
cd ~/mission10
docker compose ps
docker compose up -d
docker compose logs --tail=50
docker compose down
Use `docker compose down` for a normal stop. Avoid `docker compose down -v` unless you intentionally want to delete the named volumes and understand that persistent data may be lost.
6. Security Hardening
UFW is enabled with default-deny incoming traffic and default-allow outgoing traffic. The configured incoming rules allow SSH on port 22 and the WordPress application on port 8080.
sudo ufw status verbose
•	Allow only the ports required for administration and application access.
•	Keep MySQL port 3306 private to the Docker network.
•	Keep the .env file, database passwords, tokens, and SQL backups out of the public repository.
•	Use strong, unique passwords for Ubuntu and WordPress accounts.
The exact firewall rules should be checked against the live VM before submission. Do not claim additional protections unless they are configured and verified.
7. Application Operations
To open the WordPress site, start the VM and visit http://127.0.0.1:8080 in a browser on the Windows host. Use the WordPress account created during the installation wizard; it is separate from the Ubuntu account.
Start and check the application
cd ~/mission10
docker compose up -d
docker compose ps
If the website does not load, check container status, service logs, the VirtualBox NAT port-forwarding rule, and UFW port 8080.
8. Data Persistence and Recovery
The Compose configuration declares named volumes mysql_data and wordpress_data. These volumes are intended to retain database and WordPress files when containers are restarted or recreated, provided the volumes are not removed.
docker volume ls
docker volume inspect mission10_mysql_data
docker volume inspect mission10_wordpress_data
Docker Compose may prefix volume names with the project name. Use `docker volume ls` to confirm the exact names on the VM.
For recovery, first identify a valid SQL backup and verify that the database service is running. Test recovery carefully; a database restore can overwrite current data. Keep a copy of a backup before attempting a restore.
9. Backup and Cron Automation
The executable Bash script automation-script.sh uses mysqldump inside the MySQL container and writes a timestamped SQL backup to the backups directory. Cron is configured to run the script daily at 2:00 AM according to the VM's system time.
~/mission10/automation-script.sh
ls -lh ~/mission10/backups/
crontab -l
sudo systemctl status cron
The configured Cron entry is:
0 2 * * * /home/cloudadmin/mission10/automation-script.sh >> /home/cloudadmin/mission10/backups/cron.log 2>&1
After a manual or scheduled run, check that a new timestamped SQL file exists and inspect cron.log if a run fails. The script sources the local .env file, so keep that file present and private.
10. Maintenance Procedures
•	Confirm that the virtual machine is running and has network connectivity.
•	Check Docker service and container status with `docker compose ps`.
•	Review service logs when diagnosing application or database errors.
•	Check UFW status before making firewall changes.
•	Create and verify a database backup before risky database maintenance.
•	Keep Ubuntu packages and Docker components maintained.
•	Never delete named volumes unless data deletion is intentional and a valid backup exists.
•	Do not commit .env files, credentials, tokens, or SQL backups to GitHub.
11. Troubleshooting
Problem	Checks / Action
Website unavailable	Check VM status, `docker compose ps`, port forwarding to guest 8080, and UFW.
WordPress cannot reach MySQL	Review `docker compose logs database`, service health, network, and .env values.
Containers stopped	Run `docker compose up -d`, then inspect service logs.
Backup script fails	Check script permission, .env values, database health, and cron.log.
No scheduled backup	Check `crontab -l`, `sudo systemctl status cron`, and the log file.
Data appears missing	Check named volumes and avoid `docker compose down -v`.

Do not publish real passwords or paste secret values into troubleshooting reports.
12. Final Verification Checklist
☐  Ubuntu Server VM starts and has network access.
☐  Docker and Docker Compose are operational.
☐  WordPress and MySQL containers are running.
☐  WordPress is accessible at http://127.0.0.1:8080 from the host.
☐  MySQL uses persistent named storage and is not published to the host.
☐  UFW is active with default-deny incoming policy.
☐  Only required SSH and application ports are allowed.
☐  The Bash backup script runs and creates timestamped SQL files.
☐  Cron is active and the daily backup entry is present.
☐  The operational manual and architecture diagram are included in the repository.
☐  No real credentials or database backups are committed to GitHub.
13. GitHub Handover Contents
The Laboratory-10-Enterprise-Cloud-Architect folder should contain:
•	README.md
•	architecture-diagram.png
•	docker-compose.yml
•	automation-script.sh
•	operational-manual.md
•	.gitignore
The repository is the handover package for the assignment. The local .env file, real credentials, and SQL backups must remain outside the public repository.
14. Final Reflection
Mission 10 brought together the cloud computing concepts practiced throughout the course. By creating an Ubuntu Server virtual machine, configuring its network access, deploying WordPress and MySQL with Docker Compose, and protecting access with UFW, I gained practical experience connecting infrastructure, services, and security controls. Named volumes showed why persistent storage matters, while a Bash backup script and Cron schedule demonstrated how routine operations can be automated. The project also emphasized documentation and safe handling of credentials. Overall, the work helped me understand that a reliable cloud-style deployment requires more than getting an application to run: it also needs controlled access, data persistence, backup procedures, troubleshooting steps, and clear documentation.
Appendix: Key Paths
Purpose	Path / URL
Project working directory	/home/cloudadmin/mission10/
Submission folder	/home/cloudadmin/mission10/Laboratory-10-Enterprise-Cloud-Architect/
Backup directory	/home/cloudadmin/mission10/backups/
Host browser URL	http://127.0.0.1:8080

