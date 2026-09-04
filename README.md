# Automated Cloud Deployment Platform

A production-style DevOps project that demonstrates how to **containerize, test, build, deploy, and operate a FastAPI backend on AWS EC2 using Infrastructure as Code and CI/CD automation**.

The application is a small FastAPI + PostgreSQL Item Service, but the primary focus of this project is the **DevOps infrastructure and delivery pipeline** surrounding it.

## Architecture

```mermaid
flowchart TD
    Developer([Developer])

    GitHub[GitHub Repository]

    Actions[GitHub Actions<br/>CI/CD]

    DockerHub[(Docker Hub)]

    subgraph AWS["AWS EC2"]
        direction TB

        Compose[Docker Compose]

        API[FastAPI API<br/>:8000]

        PostgreSQL[(PostgreSQL<br/>:5432)]

        Volume[(Persistent<br/>Database Volume)]

        Compose --> API
        Compose --> PostgreSQL
        PostgreSQL --> Volume
        API --> PostgreSQL
    end

    Developer -->|git push| GitHub
    GitHub -->|Trigger workflow| Actions
    Actions -->|Build & push<br/>SHA-tagged image| DockerHub
    DockerHub -->|docker pull| Compose
```
## What This Project Demonstrates

* **CI/CD automation** with GitHub Actions
* **Containerization** with Docker
* **Container orchestration** with Docker Compose
* **Container image management** with Docker Hub
* **Cloud deployment** on AWS EC2
* **Infrastructure as Code** with Terraform
* **Automated testing** with pytest
* **PostgreSQL health checks and persistence**
* **Application health monitoring**
* **Immutable Docker image deployments**
* **Environment-based configuration and secrets management**
* **Linux server administration**
* **SSH-based automated deployment**

---

# Technology Stack

| Category               | Technology        |
| ---------------------- | ----------------- |
| Backend                | FastAPI           |
| Language               | Python 3.13       |
| Database               | PostgreSQL        |
| ORM                    | SQLAlchemy        |
| Testing                | pytest + httpx    |
| Containerization       | Docker            |
| Orchestration          | Docker Compose    |
| Container Registry     | Docker Hub        |
| CI/CD                  | GitHub Actions    |
| Cloud                  | AWS EC2           |
| Infrastructure as Code | Terraform         |
| Server OS              | Ubuntu            |
| API Documentation      | OpenAPI / Swagger |

---

# Application

The backend is a lightweight REST API for managing items.

### API Endpoints

| Method | Endpoint     | Description                         |
| ------ | ------------ | ----------------------------------- |
| `GET`  | `/`          | Service status                      |
| `GET`  | `/health`    | Application + database health check |
| `GET`  | `/api/items` | Retrieve items                      |
| `POST` | `/api/items` | Create an item                      |

Interactive API documentation:

```text
http://localhost:8000/docs
```

Production:

```text
http://<EC2_PUBLIC_IP>:8000/docs
```

---

# Project Structure

The repository is organized into application, testing, infrastructure, CI/CD, and deployment configuration layers.

```mermaid
flowchart TB

    Root["devops-project-1/"]

    Root --> App["app/<br/>Application"]
    Root --> Tests["tests/<br/>Automated Testing"]
    Root --> Terraform["terraform/<br/>Infrastructure as Code"]
    Root --> CI[".github/workflows/<br/>CI/CD"]
    Root --> Docker["Docker & Deployment"]
    Root --> Config["Configuration"]
    Root --> Docs["Documentation"]

    subgraph APPLICATION["Application Layer"]
        ConfigPy["config.py<br/>Environment configuration"]
        DatabasePy["database.py<br/>DB engine & sessions"]
        ModelsPy["models.py<br/>SQLAlchemy models"]
        SchemasPy["schemas.py<br/>Pydantic schemas"]
        CrudPy["crud.py<br/>Database operations"]
        MainPy["main.py<br/>FastAPI routes"]

        ConfigPy --> DatabasePy
        DatabasePy --> ModelsPy
        ModelsPy --> CrudPy
        SchemasPy --> MainPy
        CrudPy --> MainPy
        DatabasePy --> MainPy
    end

    subgraph TESTING["Testing Layer"]
        Conftest["conftest.py<br/>Test fixtures"]
        TestMain["test_main.py<br/>API tests"]

        Conftest --> TestMain
    end

    subgraph INFRASTRUCTURE["Infrastructure Layer"]
        MainTF["main.tf"]
        VariablesTF["variables.tf"]
        TFVars["terraform.tfvars.example"]
        TerraformReadme["README.md<br/>Terraform documentation"]

        VariablesTF --> MainTF
        TFVars --> MainTF
        MainTF --> TerraformReadme
    end

    subgraph CICD["CI/CD Layer"]
        Workflow["ci.yml<br/>Test → Build → Push → Deploy → Verify"]
    end

    subgraph CONTAINERS["Containerization"]
        Dockerfile["Dockerfile<br/>API image"]
        Compose["docker-compose.yml<br/>API + PostgreSQL"]
    end

    subgraph CONFIGURATION["Configuration & Dependencies"]
        Env[".env.example"]
        Requirements["requirements.txt"]
        Gitignore[".gitignore"]
    end

    subgraph DOCUMENTATION["Documentation"]
        Readme["README.md<br/>Project documentation"]
    end

    App --> APPLICATION
    Tests --> TESTING
    Terraform --> INFRASTRUCTURE
    CI --> CICD
    Docker --> CONTAINERS
    Config --> CONFIGURATION
    Docs --> DOCUMENTATION

    Workflow --> Dockerfile
    Workflow --> Compose
    Dockerfile --> MainPy
    Compose --> DatabasePy
    Compose --> Dockerfile
    Env --> ConfigPy
    Requirements --> App
    Terraform --> Root
```

### Repository Layout

```text
devops-project-1/
│
├── app/                         # FastAPI application
│   ├── __init__.py
│   ├── config.py               # Environment configuration
│   ├── database.py             # Database engine & sessions
│   ├── models.py               # SQLAlchemy ORM models
│   ├── schemas.py              # Pydantic schemas
│   ├── crud.py                 # Database operations
│   └── main.py                 # FastAPI application & routes
│
├── tests/                       # Automated tests
│   ├── __init__.py
│   ├── conftest.py             # Test fixtures
│   └── test_main.py            # API endpoint tests
│
├── terraform/                   # AWS Infrastructure as Code
│   ├── main.tf                 # AWS resources
│   ├── variables.tf            # Terraform variables
│   ├── terraform.tfvars.example
│   └── README.md               # Terraform documentation
│
├── .github/
│   └── workflows/
│       └── ci.yml              # CI/CD pipeline
│
├── Dockerfile                   # FastAPI container image
├── docker-compose.yml           # API + PostgreSQL
├── requirements.txt             # Python dependencies
├── .env.example                 # Environment variable template
├── .gitignore                   # Git exclusions
└── README.md                    # Project documentation
```
---

# Local Development

## 1. Create Virtual Environment

```bash
python -m venv .venv
```

### Windows

```bash
.venv\Scripts\activate
```

### Linux / macOS

```bash
source .venv/bin/activate
```

## 2. Install Dependencies

```bash
pip install -r requirements.txt
```

## 3. Configure Environment

```bash
cp .env.example .env
```

Example:

```env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/devops_db
APP_NAME="DevOps Item Service"
APP_ENV=development
DEBUG=True
PORT=8000
```

For zero-setup development, the application can fall back to SQLite when PostgreSQL is unavailable.

## 4. Run Tests

```bash
pytest -v
```

## 5. Start the API

```bash
uvicorn app.main:app --reload --port 8000
```

---

# Docker

The application can be run together with PostgreSQL using Docker Compose.

```bash
docker compose up -d
```

Check containers:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

Test the health endpoint:

```bash
curl http://localhost:8000/health
```

Stop the environment:

```bash
docker compose down
```

PostgreSQL data is stored in a named Docker volume so that container replacement does not automatically remove database data.

---

## CI/CD Pipeline

```mermaid
flowchart TD
    Push([git push to main])

    Test[Run Tests<br/>Python + PostgreSQL]

    TestsPassed{Tests Pass?}

    Build[Build Docker Image]

    Tag[Tag Image<br/>latest + Git SHA]

    DockerHub[(Docker Hub)]

    Deploy[Deploy to AWS EC2]

    Pull[Pull SHA-tagged Image]

    Start[Start Docker Compose]

    Health[Health Check<br/>GET /health]

    Healthy{Healthy?}

    Success([Deployment Successful])

    Failure([Pipeline Failed])

    Push --> Test
    Test --> TestsPassed

    TestsPassed -->|No| Failure
    TestsPassed -->|Yes| Build

    Build --> Tag
    Tag --> DockerHub

    DockerHub --> Deploy
    Deploy --> Pull
    Pull --> Start
    Start --> Health

    Health --> Healthy

    Healthy -->|Yes| Success
    Healthy -->|No| Failure
```
### Pipeline Stages

### 1. Test

GitHub Actions starts a PostgreSQL service container and executes the automated test suite.

```text
Python 3.13
     +
PostgreSQL
     ↓
pytest
```

The deployment pipeline stops if the tests fail.

### 2. Build

Docker Buildx builds the application image.

The image is tagged with:

```text
latest
```

and the immutable Git commit SHA:

```text
<github-sha>
```

### 3. Push

The image is pushed to Docker Hub using GitHub Actions secrets.

### 4. Deploy

The workflow connects to the AWS EC2 instance over SSH and:

```bash
docker compose pull api
docker compose up -d --no-build
```

The deployment uses the commit SHA image rather than relying exclusively on `latest`.

### 5. Verify

After deployment, GitHub Actions repeatedly checks:

```bash
curl --fail http://localhost:8000/health
```

The workflow fails if the application does not become healthy.

---

# GitHub Actions Secrets

The following repository secrets are required:

| Secret               | Purpose                          |
| -------------------- | -------------------------------- |
| `DOCKERHUB_USERNAME` | Docker Hub username              |
| `DOCKERHUB_TOKEN`    | Docker Hub Personal Access Token |
| `EC2_HOST`           | EC2 public IP / DNS              |
| `EC2_USER`           | EC2 SSH user                     |
| `EC2_SSH_KEY`        | EC2 private SSH key              |
| `POSTGRES_PASSWORD`  | Production PostgreSQL password   |

Sensitive values are **not committed to Git**.

The production database password is supplied to the deployment environment through GitHub Actions secrets.

---

# AWS EC2 Deployment

The production application runs on an AWS EC2 instance.

The server runs:

```text
Ubuntu
Docker
Docker Compose
```

The deployed services are:

```text
EC2
│
└── Docker Compose
    │
    ├── FastAPI
    │   └── Port 8000
    │
    └── PostgreSQL
        └── Internal port 5432
```

PostgreSQL is **not publicly exposed**.

Only the API port is intended to be reachable externally.

Useful operational commands:

```bash
docker compose ps
```

```bash
docker compose logs --tail 100 api
```

```bash
curl --fail http://localhost:8000/health
```

---

# Infrastructure as Code

Terraform is used to describe and manage the AWS infrastructure.

The current Terraform configuration safely adopts the existing EC2 infrastructure rather than creating a second server.

Managed resources include:

* EC2 instance
* Existing security group
* Network configuration
* Instance configuration
* SSH/API access rules

The configuration uses:

```text
prevent_destroy = true
```

to reduce the risk of accidentally destroying the existing infrastructure.

## Terraform Workflow

```bash
cd terraform
```

Create the local variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Initialize Terraform:

```bash
terraform init
```

Format:

```bash
terraform fmt -recursive
```

Validate:

```bash
terraform validate
```

Review infrastructure changes:

```bash
terraform plan
```

Existing resources can be imported into Terraform:

```bash
terraform import aws_instance.production <INSTANCE_ID>
```

```bash
terraform import aws_security_group.production <SECURITY_GROUP_ID>
```

**Do not run `terraform apply` until the plan has been carefully reviewed.**

The complete Terraform adoption procedure is documented in [`terraform/README.md`](terraform/README.md).

---

# Security Considerations

This project intentionally follows several production-style practices:

* Secrets are stored in GitHub Actions Secrets.
* Production credentials are not committed to Git.
* PostgreSQL is not publicly exposed.
* Docker images are deployed using immutable commit SHA tags.
* EC2 access is performed through SSH.
* Terraform state and variable files are excluded from Git.
* Infrastructure resources use `prevent_destroy` where appropriate.
* Application health is verified after deployment.

---

# Deployment Flow

The complete developer workflow is:

```text
1. Developer changes code
          ↓
2. git push
          ↓
3. GitHub Actions starts
          ↓
4. Automated tests
          ↓
5. Docker image build
          ↓
6. Push image to Docker Hub
          ↓
7. SSH into AWS EC2
          ↓
8. Pull new image
          ↓
9. Restart Docker Compose
          ↓
10. Health check
          ↓
11. Application live
```

This means a code change can move from **Git commit → tested artifact → cloud deployment → health verification** without manually rebuilding or copying the application onto the server.

---

# DevOps Skills Demonstrated

This project provides hands-on experience with:

```text
Linux
  ↓
Git & GitHub
  ↓
Python / FastAPI
  ↓
PostgreSQL
  ↓
Docker
  ↓
Docker Compose
  ↓
GitHub Actions
  ↓
Docker Hub
  ↓
AWS EC2
  ↓
Terraform
  ↓
CI/CD
  ↓
Health Checks & Operations
```

---

# Future Improvements

Potential next iterations include:

* HTTPS with Nginx and Let's Encrypt
* Domain name configuration
* Centralized logging
* Prometheus + Grafana monitoring
* Application metrics
* Automated rollback
* Blue/green or rolling deployments
* AWS CloudWatch integration
* Remote Terraform state
* AWS IAM least-privilege deployment
* Infrastructure provisioning from scratch instead of adopting an existing EC2 instance

---

## Project Goal

The goal of this project is not to build a complex application.

The goal is to demonstrate the **complete DevOps lifecycle of a backend service**:

> **Develop → Test → Containerize → Publish → Deploy → Verify → Operate**

It serves as a practical foundation for demonstrating DevOps engineering skills in internship and entry-level engineering applications.
