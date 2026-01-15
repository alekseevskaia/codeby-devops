apt install mysql-server -y
systemctl start mysql
systemctl enable mysql
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''; FLUSH PRIVILEGES;"

mysql <<EOF
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;

CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(100),
    salary DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO departments (name) VALUES ('HR'), ('IT'), ('Finance')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO employees (name, position, salary) VALUES
('Alice', 'HR Manager', 5000.00),
('Bob', 'DevOps Engineer', 7000.00),
('Charlie', 'Accountant', 4500.00)
ON DUPLICATE KEY UPDATE name=name;
EOF

mkdir -p /opt/mysql_backup
chown vagrant:vagrant /opt/mysql_backup
mv /home/vagrant/backup.sh /opt/mysql_backup/backup.sh
chmod +x /opt/mysql_backup/backup.sh

sudo -u vagrant ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -N ""
sudo -u vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.56.11

(crontab -l 2>/dev/null; echo "0 * * * * /opt/mysql_backup/backup.sh >> /var/log/mysql_backup.log 2>&1") | crontab -
