# CloudInfra – AWS Multi-Tier Cloud Infrastructure Project

## Project Overview

CloudInfra is a production-style AWS infrastructure project that deploys a scalable, highly available, and secure multi-tier application architecture on AWS.

The architecture consists of:

* Users accessing the application through HTTPS
* Application Load Balancer (ALB)
* Nginx Reverse Proxy Layer
* Apache Tomcat Application Servers
* RabbitMQ Message Broker
* Memcached Caching Layer
* MySQL Database
* Amazon S3 Artifact Storage
* Route 53 DNS Management
* Auto Scaling for High Availability
* Security Groups for Network Isolation

The infrastructure is designed to demonstrate real-world cloud deployment practices including load balancing, scaling, security, caching, messaging, and DNS management.

---

# Architecture Diagram

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

# Features

### High Availability

* Multiple application servers
* Load balancing across instances
* Auto Scaling support
* Fault tolerance

### Scalability

* Scale application instances automatically
* Independent scaling of application layer

### Security

* Security Groups
* Private DNS records
* HTTPS using SSL Certificates
* Restricted database access

### Performance

* Memcached for faster reads
* RabbitMQ for asynchronous processing
* Nginx reverse proxy optimization

### Automation

* User Data Scripts
* Route53 DNS automation
* Artifact deployment automation

---

# AWS Services Used

## 1. Amazon EC2

### Why Used

Hosts:

* Nginx Servers
* Tomcat Servers
* RabbitMQ
* Memcached
* MySQL

### Benefits

* Full server control
* Easy scaling
* Flexible instance sizing

---

## 2. Application Load Balancer (ALB)

### Why Used

Distributes traffic across multiple application servers.

### Benefits

* High Availability
* SSL Termination
* Health Checks
* Traffic Distribution

### Traffic Flow

```text
Users
   │
 HTTPS
   │
   ▼
ALB
   │
HTTP:8080
   ▼
Tomcat Instances
```

---

## 3. Amazon Route 53

### Why Used

DNS management for infrastructure.

### Public Records

```text
app.example.com
        │
        ▼
ALB DNS Name
```

### Private Records

```text
db01.example.internal
mc01.example.internal
rmq01.example.internal
```

### Benefits

* Easy service discovery
* No need to remember IPs
* Dynamic DNS updates

---

## 4. Amazon S3

### Why Used

Stores build artifacts.

### Example

```text
Application Build
      │
      ▼
sample.war
      │
      ▼
S3 Bucket
      │
      ▼
Tomcat Servers Download
```

### Benefits

* Durable storage
* Central artifact repository
* Cost effective

---

## 5. Security Groups

### Why Used

Acts as AWS firewall.

### Benefits

* Network isolation
* Controlled communication
* Reduced attack surface

---

# Security Group Design

## Load Balancer SG

Allowed:

```text
80
443
```

From:

```text
Internet
```

---

## Tomcat SG

Allowed:

```text
8080
```

From:

```text
Load Balancer SG
```

---

## RabbitMQ SG

Allowed:

```text
5672
```

From:

```text
Tomcat SG
```

---

## Memcached SG

Allowed:

```text
11211
```

From:

```text
Tomcat SG
```

---

## MySQL SG

Allowed:

```text
3306
```

From:

```text
Tomcat SG
```

---

# Components Used

## Nginx

### Purpose

Reverse Proxy

### Why Used

* Handles incoming requests
* Forwards traffic to application servers
* Improves performance

---

## Apache Tomcat

### Purpose

Runs Java Web Application

### Why Used

* Deploy WAR files
* Java Enterprise support
* Production ready

---

## RabbitMQ

### Purpose

Message Queue

### Why Used

* Decouple services
* Background task processing
* Reliable messaging

### Example

```text
User uploads image
       │
       ▼
RabbitMQ Queue
       │
       ▼
Background Worker
```

---

## Memcached

### Purpose

In-memory cache

### Why Used

* Faster database access
* Reduced MySQL load

### Example

```text
Request
   │
   ▼
Memcached
   │
   ├─ Found → Return Data
   │
   └─ Not Found
           │
           ▼
         MySQL
```

---

## MySQL

### Purpose

Persistent Data Storage

### Why Used

* Structured data
* Relational database
* ACID compliance

---

# Deployment Flow

## Step 1

Login to AWS Account

---

## Step 2

Create Key Pair

Used for SSH access.

---

## Step 3

Create Security Groups

Create SGs for:

* ALB
* Tomcat
* RabbitMQ
* Memcached
* MySQL

---

## Step 4

Launch EC2 Instances

Using:

```bash
User Data Scripts
```

to automate installation.

---

## Step 5

Update Route53 Records

Map:

```text
db01 -> Private IP
mc01 -> Private IP
rmq01 -> Private IP
```

---

## Step 6

Build Application

```bash
mvn clean install
```

Generates:

```text
target/app.war
```

---

## Step 7

Upload Artifact to S3

```bash
aws s3 cp app.war s3://bucket-name/
```

---

## Step 8

Deploy to Tomcat

```bash
aws s3 cp s3://bucket/app.war .
```

Deploy WAR file.

---

## Step 9

Configure ALB + HTTPS

Use:

* ACM Certificate
* HTTPS Listener
* Target Group

---

# Repository Structure

```text
CloudInfra/
│
├── README.md
│
├── architecture/
│   ├── architecture-diagram.png
│   ├── network-diagram.png
│   └── deployment-flow.png
│
├── userdata/
│   ├── mysql.sh
│   ├── rabbitmq.sh
│   ├── memcached.sh
│   ├── tomcat.sh
│   └── nginx.sh
│
├── deployment/
│   ├── build.sh
│   ├── deploy.sh
│   └── upload-to-s3.sh
│
├── security/
│   ├── security-groups.md
│   └── firewall-rules.md
│
├── docs/
│   ├── setup-guide.md
│   ├── route53.md
│   ├── alb.md
│   └── troubleshooting.md
│
└── screenshots/
    ├── alb.png
    ├── route53.png
    ├── ec2.png
    └── architecture.png
```

---

# Precautions & Best Practices

### Security

* Never open MySQL (3306) to the Internet.
* Never open RabbitMQ management ports publicly.
* Allow SSH only from your IP.
* Use HTTPS only.

### Route53

* Use private hosted zones for internal services.
* Avoid hardcoding private IP addresses.

### S3

* Enable bucket versioning.
* Block public access.
* Use IAM roles instead of access keys.

### EC2

* Use least-privilege IAM roles.
* Regularly patch instances.
* Enable CloudWatch monitoring.

### Load Balancer

* Enable health checks.
* Redirect HTTP → HTTPS.
* Use ACM certificates.

### Database

* Take regular backups.
* Restrict inbound rules.
* Monitor storage utilization.

---

# Learning Outcomes

By completing this project, you will gain hands-on experience with:

* AWS EC2
* Security Groups
* Route 53
* Application Load Balancer
* SSL/TLS Certificates
* Apache Tomcat
* Nginx
* RabbitMQ
* Memcached
* MySQL
* Amazon S3
* Auto Scaling
* Infrastructure Automation
* Multi-Tier Architecture Design

This project closely resembles how enterprise Java applications are deployed in production cloud environments.

