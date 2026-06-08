#!/bin/bash
DATABASE_PASS='admin123'
sudo dnf update -y
sudo dnf install git zip unzip -y
sudo dnf install mariadb105-server -y
# starting & enabling mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git
#restore the dump file for the application
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DATABASE_PASS'"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"





# #!/bin/bash
# set -e

# # Log output for troubleshooting

# exec > >(tee /var/log/user-data.log)
# exec 2>&1

# DATABASE_PASS="admin123"
# DB_NAME="accounts"
# DB_USER="admin"
# DB_USER_PASS="admin123"

# echo "Starting DB Server Configuration..."

# # Update system

# dnf update -y

# # Install required packages

# dnf install -y git wget zip unzip mariadb105-server

# # Start and enable MariaDB

# systemctl enable mariadb
# systemctl start mariadb

# # Wait for MariaDB

# sleep 10

# # Set root password if not already set

# mysqladmin -u root password "${DATABASE_PASS}" || true

# # Secure MariaDB

# mysql -u root -p"${DATABASE_PASS}" <<EOF
# DELETE FROM mysql.user WHERE User='';
# DELETE FROM mysql.user
# WHERE User='root'
# AND Host NOT IN ('localhost','127.0.0.1','::1');

# DELETE FROM mysql.db
# WHERE Db='test'
# OR Db LIKE 'test%';

# FLUSH PRIVILEGES;
# EOF

# # Clone repository

# cd /tmp
# rm -rf vprofile-project

# git clone -b main https://github.com/hkhcoder/vprofile-project.git

# # Verify SQL dump exists

# if [ ! -f /tmp/vprofile-project/src/main/resources/db_backup.sql ]; then
# echo "ERROR: db_backup.sql not found."
# exit 1
# fi

# # Create database and user

# mysql -u root -p"${DATABASE_PASS}" <<EOF

# CREATE DATABASE IF NOT EXISTS ${DB_NAME};

# CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost'
# IDENTIFIED BY '${DB_USER_PASS}';

# CREATE USER IF NOT EXISTS '${DB_USER}'@'%'
# IDENTIFIED BY '${DB_USER_PASS}';

# GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';

# GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';

# FLUSH PRIVILEGES;
# EOF

# # Import database

# mysql -u root -p"${DATABASE_PASS}" ${DB_NAME} < /tmp/vprofile-project/src/main/resources/db_backup.sql

# # Restart MariaDB

# systemctl restart mariadb

# echo "Database setup completed successfully."
# echo "DB Name: accounts"
# echo "DB User: admin"
# echo "DB Password: admin123"
