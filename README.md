# ☁️ CloudInfra – AWS Multi-Tier Cloud Infrastructure Project

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=for-the-badge&logo=openjdk&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![Tomcat](https://img.shields.io/badge/tomcat-%23F8DC75.svg?style=for-the-badge&logo=apache-tomcat&logoColor=black)
![RabbitMQ](https://img.shields.io/badge/Rabbitmq-FF6600?style=for-the-badge&logo=rabbitmq&logoColor=white)
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)

## 📖 Project Overview

**CloudInfra** is a production-style AWS infrastructure project that deploys a scalable, highly available, and secure multi-tier application architecture on AWS.

The architecture consists of:
- 🌐 **Users** accessing the application through HTTPS
- ⚖️ **Application Load Balancer (ALB)**
- 🛡️ **Nginx** Reverse Proxy Layer
- ☕ **Apache Tomcat** Application Servers
- 🐇 **RabbitMQ** Message Broker
- ⚡ **Memcached** Caching Layer
- 🗄️ **MySQL** Database
- 📦 **Amazon S3** Artifact Storage
- 🗺️ **Route 53** DNS Management
- 📈 **Auto Scaling** for High Availability
- 🔒 **Security Groups** for Network Isolation

The infrastructure is designed to demonstrate real-world cloud deployment practices including load balancing, scaling, security, caching, messaging, and DNS management.

---

## 🏗️ Architecture Diagram

```text
Users
   │
   ▼
Route53 DNS
   │
   ▼
Application Load Balancer (HTTPS)
   │
   ▼
Nginx Reverse Proxy
   │
   ▼
Tomcat Application Servers
   │
   ├──► RabbitMQ
   │
   ├──► Memcached
   │
   └──► MySQL
           │
           ▼
       Data Storage

S3 Bucket
   │
   ▼
Application Artifacts (.war files)
```

---

## ✨ Features

### 🚀 High Availability
* Multiple application servers
* Load balancing across instances
* Auto Scaling support
* Fault tolerance

### 📈 Scalability
* Scale application instances automatically
* Independent scaling of application layer

### 🔒 Security
* Security Groups
* Private DNS records
* HTTPS using SSL Certificates
* Restricted database access

### ⚡ Performance
* Memcached for faster reads
* RabbitMQ for asynchronous processing
* Nginx reverse proxy optimization

### 🤖 Automation
* User Data Scripts
* Route53 DNS automation
* Artifact deployment automation

---

## 🛠️ AWS Services Used

### 1. 🖥️ Amazon EC2
* **Why Used**: Hosts Nginx Servers, Tomcat Servers, RabbitMQ, Memcached, MySQL.
* **Benefits**: Full server control, easy scaling, flexible instance sizing.

### 2. ⚖️ Application Load Balancer (ALB)
* **Why Used**: Distributes traffic across multiple application servers.
* **Benefits**: High Availability, SSL Termination, Health Checks, Traffic Distribution.

### 3. 🗺️ Amazon Route 53
* **Why Used**: DNS management for infrastructure.
* **Benefits**: Easy service discovery, no need to remember IPs, dynamic DNS updates.

### 4. 🪣 Amazon S3
* **Why Used**: Stores build artifacts.
* **Benefits**: Durable storage, central artifact repository, cost-effective.

### 5. 🛡️ Security Groups
* **Why Used**: Acts as AWS firewall.
* **Benefits**: Network isolation, controlled communication, reduced attack surface.

---

## 🔒 Security Group Design

| Component | Allowed Port | Allowed From |
| :--- | :--- | :--- |
| **Load Balancer** | `80`, `443` | `Internet` |
| **Tomcat** | `8080` | `Load Balancer SG` |
| **RabbitMQ** | `5672` | `Tomcat SG` |
| **Memcached** | `11211` | `Tomcat SG` |
| **MySQL** | `3306` | `Tomcat SG` |

---

## ⚙️ Components Used

* 🟢 **Nginx**: Reverse Proxy. Handles incoming requests and forwards traffic to application servers to improve performance.
* ☕ **Apache Tomcat**: Runs Java Web Application. Used to deploy WAR files, providing Java Enterprise support.
* 🐇 **RabbitMQ**: Message Queue. Decouples services, enables background task processing, and provides reliable messaging.
* ⚡ **Memcached**: In-memory cache. Provides faster database access and reduces MySQL load.
* 🐬 **MySQL**: Persistent Data Storage. Used for structured data, relational database capabilities, and ACID compliance.

---

## 🚀 Deployment Flow

1. **Login** to AWS Account.
2. **Create Key Pair** (Used for SSH access).
3. **Create Security Groups** (for ALB, Tomcat, RabbitMQ, Memcached, MySQL).
4. **Launch EC2 Instances** using User Data Scripts to automate installation.
5. **Update Route53 Records** (Map `db01`, `mc01`, `rmq01` to Private IPs).
6. **Build Application** (`mvn clean install` generates `target/app.war`).
7. **Upload Artifact to S3** (`aws s3 cp target/app.war s3://bucket-name/`).
8. **Deploy to Tomcat** (Download from S3 and deploy).
9. **Configure ALB + HTTPS** (Use ACM Certificate, HTTPS Listener, Target Group).

---

## 📁 Repository Structure

```text
CloudInfra/
│
├── README.md
├── architecture/
│   ├── architecture-diagram.png
│   ├── network-diagram.png
│   └── deployment-flow.png
├── userdata/
│   ├── mysql.sh
│   ├── rabbitmq.sh
│   ├── memcached.sh
│   ├── tomcat.sh
│   └── nginx.sh
├── deployment/
│   ├── build.sh
│   ├── deploy.sh
│   └── upload-to-s3.sh
├── security/
│   ├── security-groups.md
│   └── firewall-rules.md
├── docs/
│   ├── setup-guide.md
│   ├── route53.md
│   ├── alb.md
│   └── troubleshooting.md
└── screenshots/
    ├── alb.png
    ├── route53.png
    ├── ec2.png
    └── architecture.png
```

---

## ⚠️ Precautions & Best Practices

- 🔐 **Security**: Never open MySQL (`3306`) or RabbitMQ management ports to the Internet. Allow SSH only from your IP. Use HTTPS only.
- 🗺️ **Route53**: Use private hosted zones for internal services. Avoid hardcoding private IP addresses.
- 🪣 **S3**: Enable bucket versioning, block public access, use IAM roles instead of access keys.
- 🖥️ **EC2**: Use least-privilege IAM roles, regularly patch instances, enable CloudWatch monitoring.
- ⚖️ **Load Balancer**: Enable health checks, redirect HTTP → HTTPS, use ACM certificates.
- 🗄️ **Database**: Take regular backups, restrict inbound rules, monitor storage utilization.

---

## 🎓 Learning Outcomes

By completing this project, you will gain hands-on experience with:
- AWS EC2, S3, Route 53, Auto Scaling, Application Load Balancer
- Security Groups, SSL/TLS Certificates
- Apache Tomcat, Nginx, RabbitMQ, Memcached, MySQL
- Infrastructure Automation, Multi-Tier Architecture Design

> *This project closely resembles how enterprise Java applications are deployed in production cloud environments.*
