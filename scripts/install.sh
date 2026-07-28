# #!/bin/bash

# set -e

# LOG_FILE="/tmp/install.log"

# echo "========================================="
# echo " DevOps Tools Installation Started"
# echo "========================================="

# VALIDATE() {
#     if [ $1 -eq 0 ]; then
#         echo "$2 ... SUCCESS"
#     else
#         echo "$2 ... FAILURE"
#         echo "Check log: $LOG_FILE"
#         exit 1
#     fi
# }

# # Root Check
# if [ "$(id -u)" -ne 0 ]; then
#     echo "Please run as root or sudo."
#     exit 1
# fi

# echo "Updating System..."
# dnf update -y &>>$LOG_FILE
# VALIDATE $? "System Update"

# ###################################################
# # Java
# ###################################################

# echo "Installing Java..."
# dnf install -y java-21-openjdk java-21-openjdk-devel &>>$LOG_FILE
# VALIDATE $? "Java Installation"

# ###################################################
# # Git
# ###################################################

# echo "Installing Git..."
# dnf install -y git &>>$LOG_FILE
# VALIDATE $? "Git Installation"

# ###################################################
# # Maven
# ###################################################

# echo "Installing Maven..."
# dnf install -y maven &>>$LOG_FILE
# VALIDATE $? "Maven Installation"

# ###################################################
# # NodeJS
# ###################################################

# echo "Installing NodeJS..."
# curl -fsSL https://rpm.nodesource.com/setup_22.x | bash - &>>$LOG_FILE
# dnf install -y nodejs &>>$LOG_FILE
# VALIDATE $? "NodeJS Installation"

# ###################################################
# # PostgreSQL
# ###################################################

# echo "Installing PostgreSQL..."
# dnf install -y postgresql15-server postgresql15 &>>$LOG_FILE
# VALIDATE $? "PostgreSQL Installation"

# ###################################################
# # Jenkins
# ###################################################

# echo "Installing Jenkins..."

# wget -O /etc/yum.repos.d/jenkins.repo \
# https://pkg.jenkins.io/redhat-stable/jenkins.repo &>>$LOG_FILE

# rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key &>>$LOG_FILE

# dnf install -y jenkins &>>$LOG_FILE
# VALIDATE $? "Jenkins Installation"

# systemctl enable jenkins
# systemctl start jenkins

# ###################################################
# # SonarQube
# ###################################################

# echo "Installing SonarQube..."

# useradd sonar || true

# cd /opt

# wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.7.0.110598.zip -O sonarqube.zip &>>$LOG_FILE

# dnf install -y unzip &>>$LOG_FILE

# unzip -o sonarqube.zip &>>$LOG_FILE

# mv sonarqube-* sonarqube

# chown -R sonar:sonar /opt/sonarqube

# VALIDATE $? "SonarQube Installation"

# ###################################################
# # Sonar Scanner
# ###################################################

# echo "Installing Sonar Scanner..."

# cd /opt

# wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-7.2.0.5079-linux-x64.zip \
# -O sonar-scanner.zip &>>$LOG_FILE

# unzip -o sonar-scanner.zip &>>$LOG_FILE

# mv sonar-scanner-* sonar-scanner

# VALIDATE $? "Sonar Scanner Installation"

# ###################################################
# # Nexus
# ###################################################

# echo "Installing Nexus..."

# useradd nexus || true

# cd /opt

# wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz \
# -O nexus.tar.gz &>>$LOG_FILE

# tar -xzf nexus.tar.gz &>>$LOG_FILE

# mv nexus-* nexus

# chown -R nexus:nexus /opt/nexus

# VALIDATE $? "Nexus Installation"

# ###################################################
# # Versions
# ###################################################

# echo ""
# echo "========================================="
# echo "Installed Versions"
# echo "========================================="

# java -version
# git --version
# mvn -version
# node -v
# npm -v
# psql --version

# echo ""
# echo "========================================="
# echo "Installation Completed Successfully"
# echo "========================================="