# CRM Dev - DevOps CI/CD Pipeline

## Project Overview

This project demonstrates a complete DevOps CI/CD pipeline for a CRM application using industry-standard tools and automation practices.

## Technology Stack

- AWS EC2
- Jenkins
- Git & GitHub
- SonarQube
- Sonar Scanner
- Nexus Repository
- Node.js
- Maven
- PostgreSQL
- Linux (RHEL 9)
- Shell Scripting

## Project Structure

```text
crm-dev/
├── LICENSE
├── README.md
├── .gitignore
├── Jenkinsfile
├── ci-cd/
│   ├── ci/
│   ├── cd/
│   └── jenkins/
├── scripts/
│   ├── install.sh
│   ├── install-java.sh
│   ├── install-git.sh
│   ├── install-jenkins.sh
│   ├── install-postgresql.sh
│   ├── install-sonarqube.sh
│   ├── install-sonar-scanner.sh
│   ├── install-nexus.sh
│   ├── install-nodejs.sh
│   ├── install-maven.sh
│   ├── package.sh
│   ├── deploy.sh
│   └── health-check.sh
└── src/
```

## CI/CD Pipeline

1. Checkout source code
2. Install dependencies
3. Build application
4. Run unit tests
5. Perform SonarQube code analysis
6. Upload build artifact to Nexus
7. Deploy application
8. Perform health check

## Installation

Clone the repository:

```bash
git clone https://github.com/veerankirajesh/crm-dev.git
cd crm-dev
```

Run the installation script:

```bash
chmod +x scripts/*.sh
sudo ./scripts/install.sh
```

## Deployment

Deploy the application:

```bash
chmod +x scripts/deploy.sh
sudo ./scripts/deploy.sh
```

## Health Check

Verify the application:

```bash
chmod +x scripts/health-check.sh
./scripts/health-check.sh
```

## Jenkins Pipeline

The Jenkins pipeline automates:

- Source Code Checkout
- Build
- Test
- SonarQube Analysis
- Artifact Upload to Nexus
- Deployment
- Health Check

## Author

Rajesh Veeranki

## License

This project is licensed under the MIT License.