# Automated Cloud Deployment Platform

<p align="center">

**A production-style DevOps project for automated testing, containerization, CI/CD, cloud deployment, and Infrastructure as Code.**

FastAPI · PostgreSQL · Docker · GitHub Actions · Docker Hub · AWS EC2 · Terraform

</p>

---

> [!IMPORTANT]
> This project focuses primarily on the **DevOps lifecycle of a backend service** rather than application complexity.
>
> **Develop → Test → Containerize → Publish → Deploy → Verify → Operate**

---

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
        API --> PostgreSQL
        PostgreSQL --> Volume
    end

    Developer -->|git push| GitHub
    GitHub -->|Trigger workflow| Actions
    Actions -->|Build & push<br/>SHA-tagged image| DockerHub
    DockerHub -->|docker pull| Compose
```

> [!TIP]
> The deployment path is intentionally simple and reviewable:
>
> **GitHub → GitHub Actions → Docker Hub → AWS EC2 → Docker Compose → FastAPI + PostgreSQL**

---

## What This Project Demonstrates

| Area | Implementation |
|---|---|
| **Application** | FastAPI REST API |
| **Database** | PostgreSQL + SQLAlchemy |
| **Testing** | pytest + httpx |
| **Containerization** | Docker |
| **Orchestration** | Docker Compose |
| **CI/CD** | GitHub Actions |
| **Container Registry** | Docker Hub |
| **Cloud** | AWS EC2 |
| **Infrastructure as Code** | Terraform |
| **Configuration** | Environment variables |
| **Secrets** | GitHub Actions Secrets |
| **Deployment Strategy** | SHA-tagged Docker images |
| **Deployment Verification** | `/health` endpoint |
| **Server** | Ubuntu + Docker |
| **API Documentation** | OpenAPI / Swagger |

---

# Technology Stack

| Category | Technology |
|---|---|
| Backend | FastAPI |
| Language | Python 3.13 |
| Database | PostgreSQL |
| ORM | SQLAlchemy |
| Testing | pytest + httpx |
| Containerization | Docker |
| Orchestration | Docker Compose |
| Container Registry | Docker Hub |
| CI/CD | GitHub Actions |
| Cloud | AWS EC2 |
| Infrastructure as Code | Terraform |
| Server OS | Ubuntu |
| API Documentation | OpenAPI / Swagger |

---

# Application

The application is a lightweight **FastAPI + PostgreSQL Item Service**.

The backend exposes a small REST API while the surrounding project demonstrates the infrastructure and delivery workflow.

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/` | Service status |
| `GET` | `/health` | Application + database health check |
| `GET` | `/api/items` | Retrieve items |
| `POST` | `/api/items` | Create an item |

### Interactive API Documentation

```text
http://localhost:8000/docs
```

### Production API

```text
http://<EC2_PUBLIC_IP>:8000/docs
```

> [!NOTE]
> The production endpoint currently uses the EC2 public address and port `8000`. HTTPS and domain configuration are planned improvements rather than current capabilities.

---

# Repository Structure

The repository is organized into five major areas:

```mermaid
flowchart TB

    Root["devops-project-1/"]

    Root --> App["app/<br/>Application"]
    Root --> Tests["tests/<br/>Automated Testing"]
    Root --> Terraform["terraform/<br/>Infrastructure as Code"]
    Root --> CI[".github/workflows/<br/>CI/CD"]
    Root --> Containers["Docker & Deployment"]
    Root --> Config["Configuration"]
    Root --> Docs["Documentation"]

    subgraph APPLICATION["Application Layer"]
        ConfigPy["config.py<br/>Configuration"]
        DatabasePy["database.py<br/>Database connection"]
        ModelsPy["models.py<br/>ORM models"]
        SchemasPy["schemas.py<br/>Pydantic schemas"]
        CrudPy["crud.py<br/>CRUD operations"]
        MainPy["main.py<br/>FastAPI routes"]

        ConfigPy --> DatabasePy
        DatabasePy --> ModelsPy
        ModelsPy --> CrudPy
        SchemasPy --> MainPy
        CrudPy --> MainPy
        DatabasePy --> MainPy
    end

    subgraph TESTING["Testing Layer"]
        Conftest["conftest.py<br/>Fixtures"]
        TestMain["test_main.py<br/>API tests"]

        Conftest --> TestMain
    end

    subgraph INFRASTRUCTURE["Infrastructure Layer"]
        MainTF["main.tf"]
        VariablesTF["variables.tf"]
        TFVars["terraform.tfvars.example"]
        TFReadme["README.md"]

        VariablesTF --> MainTF
        TFVars --> MainTF
        MainTF --> TFReadme
    end

    subgraph CICD["CI/CD Layer"]
        Workflow["ci.yml<br/>Test → Build → Push → Deploy → Verify"]
    end

    subgraph DOCKER["Container Layer"]
        Dockerfile["Dockerfile<br/>FastAPI image"]
        Compose["docker-compose.yml<br/>API + PostgreSQL"]
    end

    App --> APPLICATION
    Tests --> TESTING
    Terraform --> INFRASTRUCTURE
    CI --> CICD
    Containers --> DOCKER

    Workflow --> Dockerfile
    Workflow --> Compose
    Dockerfile --> MainPy
    Compose --> Dockerfile
    Compose --> DatabasePy
```

<details>
<summary><b>📁 Expand complete repository tree</b></summary>

<br>

```text
devops-project-1/
│
├── app/                              # FastAPI application
│   ├── __init__.py
│   ├── config.py                    # Environment configuration
│   ├── database.py                  # Database engine & sessions
│   ├── models.py                    # SQLAlchemy ORM models
│   ├── schemas.py                   # Pydantic schemas
│   ├── crud.py                      # Database operations
│   └── main.py                      # FastAPI application & routes
│
├── tests/                            # Automated tests
│   ├── __init__.py
│   ├── conftest.py                  # Test fixtures
│   └── test_main.py                 # API endpoint tests
│
├── terraform/                        # AWS Infrastructure as Code
│   ├── main.tf                      # AWS resources
│   ├── variables.tf                 # Terraform variables
│   ├── terraform.tfvars.example     # Example variable values
│   └── README.md                    # Terraform documentation
│
├── .github/
│   └── workflows/
│       └── ci.yml                   # CI/CD pipeline
│
├── Dockerfile                        # FastAPI container image
├── docker-compose.yml                # API + PostgreSQL
├── requirements.txt                 # Python dependencies
├── .env.example                     # Environment template
├── .gitignore                        # Git exclusions
└── README.md                         # Project documentation
```

</details>

---

# CI/CD Pipeline

Every push to the main branch triggers the automated delivery pipeline.

```mermaid
flowchart TD

    Push([git push to main])

    Test[Run Automated Tests<br/>Python 3.13 + PostgreSQL]

    TestsPassed{Tests Pass?}

    Build[Build Docker Image<br/>Docker Buildx]

    Tag[Create Image Tags<br/>latest + Git SHA]

    Registry[(Docker Hub)]

    Deploy[Deploy to AWS EC2<br/>SSH + SCP]

    Pull[Pull SHA-tagged Image]

    Start[Start Docker Compose<br/>--no-build]

    Health[Health Check<br/>GET /health]

    Healthy{Healthy?}

    Success([Deployment Successful])

    Failure([Pipeline Failed])

    Push --> Test
    Test --> TestsPassed

    TestsPassed -->|No| Failure
    TestsPassed -->|Yes| Build

    Build --> Tag
    Tag --> Registry

    Registry --> Deploy
    Deploy --> Pull
    Pull --> Start
    Start --> Health

    Health --> Healthy

    Healthy -->|Yes| Success
    Healthy -->|No| Failure
```

## Pipeline Stages

### 1. Test

GitHub Actions starts PostgreSQL as a service container and runs the automated test suite.

```text
Python 3.13
     +
PostgreSQL
     ↓
pytest
```

If the tests fail, the pipeline stops before the Docker image is published.

### 2. Build

Docker Buildx builds the application image.

### 3. Tag

The image receives:

```text
latest
```

and an immutable Git commit SHA:

```text
<github-sha>
```

This makes every deployment traceable to a specific source revision.

### 4. Push

The image is pushed to Docker Hub using GitHub Actions credentials.

### 5. Deploy

GitHub Actions connects to the EC2 server and executes the deployment workflow.

```bash
docker compose pull api
docker compose up -d --no-build
```

### 6. Verify

The workflow checks:

```bash
curl --fail http://localhost:8000/health
```

The deployment is considered successful only after the service becomes healthy.

> [!IMPORTANT]
> The health check acts as a **deployment gate**.
>
> In simplified form:
>
> $$\text{Deployment Success} =
> \text{Tests Pass} \land
> \text{Image Published} \land
> \text{Service Healthy}$$

---

# Immutable Image Deployment

The pipeline publishes both a floating `latest` tag and a commit-specific image tag.

For example:

```text
myuser/devops-project-1:latest
myuser/devops-project-1:a8f31c2...
```

The EC2 deployment uses the commit SHA rather than depending solely on `latest`.

### Why?

Because:

```diff
- docker compose pull api
+ docker compose pull api
+ # Deploy image identified by the Git commit SHA
```

A SHA-tagged image creates a direct relationship between:

```text
Git Commit
    ↓
Docker Image
    ↓
EC2 Deployment
```

That improves deployment traceability and provides the foundation for future rollback workflows.

---

# GitHub Actions Secrets

The following repository secrets are required:

| Secret | Purpose |
|---|---|
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub Personal Access Token |
| `EC2_HOST` | EC2 public IP / DNS |
| `EC2_USER` | EC2 SSH username |
| `EC2_SSH_KEY` | EC2 private SSH key |
| `POSTGRES_PASSWORD` | Production PostgreSQL password |

> [!CAUTION]
> Never commit production credentials, private SSH keys, `.env` files, or Terraform state to the repository.

Sensitive configuration is supplied through GitHub Actions Secrets and deployment-time environment variables.

---

# Docker & Docker Compose

The application and PostgreSQL database can be run locally as a multi-container environment.

```mermaid
flowchart LR

    Compose[Docker Compose]

    API[FastAPI<br/>Container]

    DB[(PostgreSQL<br/>Container)]

    Volume[(PostgreSQL<br/>Named Volume)]

    Compose --> API
    Compose --> DB
    API --> DB
    DB --> Volume
```

## Start

```bash
docker compose up -d
```

## Check containers

```bash
docker compose ps
```

## View logs

```bash
docker compose logs -f
```

## Health check

```bash
curl http://localhost:8000/health
```

## Stop

```bash
docker compose down
```

> [!NOTE]
> PostgreSQL data is stored in a named Docker volume, allowing database data to survive normal container replacement.

---

# Local Development

<details>
<summary><b>1️⃣ Create the virtual environment</b></summary>

<br>

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

</details>

<details>
<summary><b>2️⃣ Install dependencies</b></summary>

<br>

```bash
pip install -r requirements.txt
```

</details>

<details>
<summary><b>3️⃣ Configure environment variables</b></summary>

<br>

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

The application can fall back to SQLite when PostgreSQL is unavailable for zero-setup local development.

</details>

<details>
<summary><b>4️⃣ Run tests</b></summary>

<br>

```bash
pytest -v
```

</details>

<details>
<summary><b>5️⃣ Start the application</b></summary>

<br>

```bash
uvicorn app.main:app --reload --port 8000
```

Open:

```text
http://localhost:8000/docs
```

</details>

---

# AWS EC2 Deployment

The production-style deployment runs on an AWS EC2 instance.

```mermaid
flowchart TD

    Internet([Internet])

    EC2["AWS EC2"]

    Compose["Docker Compose"]

    API["FastAPI<br/>Port 8000"]

    DB[("PostgreSQL<br/>Internal :5432")]

    Volume[("Persistent<br/>Database Volume")]

    Internet -->|HTTP :8000| EC2
    EC2 --> Compose

    Compose --> API
    Compose --> DB

    API --> DB
    DB --> Volume
```

The server environment consists of:

```text
Ubuntu
  +
Docker
  +
Docker Compose
```

### Network Design

```text
Public
  │
  │ :8000
  ▼
FastAPI
  │
  │ internal Docker network
  ▼
PostgreSQL :5432
```

> [!IMPORTANT]
> PostgreSQL is **not publicly exposed**. Database traffic remains inside the Docker Compose network.

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

Terraform describes the AWS infrastructure in a repeatable and reviewable way.

```mermaid
flowchart TD

    Developer([Developer])

    Terraform[Terraform]

    Plan[terraform plan]

    Review{Review Plan}

    EC2[AWS EC2 Instance]

    SG[Security Group]

    Network[VPC / Subnet]

    State[(Terraform State)]

    Developer --> Terraform
    Terraform --> Plan

    Plan --> Review

    Review -->|Approved| EC2
    Review -->|Approved| SG
    Review -->|Approved| Network

    Terraform --> State
```

The current configuration adopts the existing EC2 infrastructure rather than creating a second server.

Managed infrastructure includes:

- EC2 instance
- Existing security group
- Network configuration
- Instance configuration
- SSH/API access rules

The configuration uses:

```text
prevent_destroy = true
```

to reduce the risk of accidental resource destruction.

---

## Terraform Workflow

<details>
<summary><b>Initialize Terraform</b></summary>

```bash
cd terraform
terraform init
```

</details>

<details>
<summary><b>Format and validate</b></summary>

```bash
terraform fmt -recursive
terraform validate
```

</details>

<details>
<summary><b>Configure variables</b></summary>

```bash
cp terraform.tfvars.example terraform.tfvars
```

Fill in the required infrastructure values before planning.

</details>

<details>
<summary><b>Review infrastructure changes</b></summary>

```bash
terraform plan
```

> [!WARNING]
> Never run `terraform apply` until the plan has been reviewed and confirms that the existing EC2 instance and security group will not be unexpectedly replaced or destroyed.

</details>

<details>
<summary><b>Import existing resources</b></summary>

```bash
terraform import aws_instance.production <INSTANCE_ID>
```

```bash
terraform import aws_security_group.production <SECURITY_GROUP_ID>
```

See [`terraform/README.md`](terraform/README.md) for the complete adoption workflow.

</details>

---

## Security Practices

| Practice | Status |
|---|:---:|
| 🔐 Secrets stored outside source code | 🟢 Implemented |
| 🔑 Production database password supplied through GitHub Actions Secrets | 🟢 Implemented |
| 🗄️ PostgreSQL not publicly exposed | 🟢 Implemented |
| 🏷️ Docker images tagged with Git commit SHA | 🟢 Implemented |
| 📁 Terraform state and variable files excluded from Git | 🟢 Implemented |
| 🔒 EC2 access performed through SSH | 🟢 Implemented |
| 🛡️ Terraform resources protected with `prevent_destroy` | 🟢 Implemented |
| ❤️ Deployment verified with an application health check | 🟢 Implemented |

> [!IMPORTANT]
> Security controls are designed around the project's single-EC2 deployment model, with secrets kept out of source control, the database isolated from public access, and deployments verified before being considered successful.

> [!CAUTION]
> The EC2 SSH key is sensitive infrastructure credentials. Only the required GitHub Actions secret should contain the private key, and the key must never be committed to the repository.

---

# Deployment Lifecycle

```mermaid
flowchart LR

    Code[Write Code]

    Git[Git Commit]

    Test[Automated Tests]

    Build[Docker Build]

    Push[Docker Hub]

    Deploy[AWS EC2]

    Verify[Health Check]

    Operate[Operate]

    Code --> Git
    Git --> Test
    Test --> Build
    Build --> Push
    Push --> Deploy
    Deploy --> Verify
    Verify --> Operate

    Operate -.->|Next Change| Code
```

The project automates the path from source code to a verified cloud deployment:

```text
Developer
   ↓
git push
   ↓
GitHub Actions
   ↓
Automated Tests
   ↓
Docker Build
   ↓
Docker Hub
   ↓
AWS EC2
   ↓
Docker Compose
   ↓
Health Check
   ↓
Application Live
```

---

# Operational Checks

<details>
<summary><b>Container status</b></summary>

```bash
docker compose ps
```

</details>

<details>
<summary><b>Application logs</b></summary>

```bash
docker compose logs --tail 100 api
```

</details>

<details>
<summary><b>Application health</b></summary>

```bash
curl --fail http://localhost:8000/health
```

</details>

<details>
<summary><b>Database status</b></summary>

```bash
docker compose ps postgres
```

</details>

---

# DevOps Skills Demonstrated

```mermaid
flowchart TB

    Git[Git & GitHub]
    Linux[Linux]
    Python[Python / FastAPI]
    DB[PostgreSQL]

    Docker[Docker]
    Compose[Docker Compose]

    CI[GitHub Actions]
    Registry[Docker Hub]

    AWS[AWS EC2]
    Terraform[Terraform]

    Operations[Health Checks<br/>Operations]

    Git --> CI
    Python --> Docker
    DB --> Compose

    Docker --> Compose
    Compose --> CI

    CI --> Registry
    Registry --> AWS

    Terraform --> AWS
    Linux --> AWS

    AWS --> Operations
```

### Core Skills

- Linux server administration
- Git & GitHub
- Python / FastAPI
- PostgreSQL
- Docker
- Docker Compose
- GitHub Actions
- Docker Hub
- AWS EC2
- Terraform
- CI/CD
- Environment configuration
- Secrets management
- Deployment verification
- Health checks

---

# Project Status

| Layer | Status |
|---|:---:|
| 🧩 FastAPI Application | 🟢 Complete |
| 🗄️ PostgreSQL | 🟢 Complete |
| 🧪 Automated Testing | 🟢 Complete |
| 🐳 Docker | 🟢 Complete |
| 🔗 Docker Compose | 🟢 Complete |
| 📦 Docker Hub | 🟢 Complete |
| ⚙️ GitHub Actions CI/CD | 🟢 Complete |
| ☁️ AWS EC2 | 🟢 Complete |
| 🏗️ Terraform | 🟢 Complete |
| 🔐 Secrets Management | 🟢 Complete |
| ❤️ Deployment Health Checks | 🟢 Complete |
| 🔒 HTTPS | 🟡 Planned |
| 🌐 Domain | 🟡 Planned |
| 📊 Prometheus + Grafana | 🟡 Planned |
| 🔄 Automated Rollback | 🟡 Planned |
| 🗃️ Remote Terraform State | 🟡 Planned |
| 📜 Centralized Logging | 🟡 Planned |
| ☁️ CloudWatch | 🟡 Planned |
| 🏗️ Full Infrastructure Provisioning | 🟡 Planned |

> [!TIP]
> The unchecked items are **planned improvements**, not claims about the current implementation.

---

# Future Improvements

The next iterations can extend the platform with:

1. **HTTPS**
   - Reverse proxy
   - Let's Encrypt certificates
   - Secure external access

2. **Observability**
   - Prometheus
   - Grafana
   - Application metrics
   - Infrastructure metrics

3. **Reliability**
   - Automated rollback
   - Deployment recovery
   - Rebuild-from-scratch validation

4. **Terraform Maturity**
   - Remote state
   - State locking
   - More complete infrastructure provisioning

5. **Cloud Operations**
   - AWS CloudWatch
   - Centralized logging
   - Better alerting

6. **Deployment Evolution**
   - Blue/green deployments
   - Rolling deployments
   - Reduced dependency on direct SSH deployment

---

# Cost & Teardown

> [!WARNING]
> Cloud resources can incur charges. Always verify the current AWS billing and Free Tier/credit eligibility for your account before leaving infrastructure running.

When the environment is no longer required:

```text
Application
    ↓
Docker Compose
    ↓
EC2
    ↓
Terraform-managed infrastructure
```

Review the Terraform plan before destroying resources and verify that no required infrastructure is being removed accidentally.

A future iteration will make the teardown/rebuild workflow fully reproducible through Infrastructure as Code.

---

# Engineering Notes

<details>
<summary><b>Why Docker images use Git SHA tags</b></summary>

<br>

Using the Git commit SHA as an image tag creates an explicit mapping:

```text
Git commit
    ↓
Docker image
    ↓
Deployment
```

Instead of asking:

```text
"What version is running?"
```

the deployment can answer:

```text
"This deployment corresponds to commit <SHA>."
```

</details>

<details>
<summary><b>Why PostgreSQL is kept private</b></summary>

<br>

The API communicates with PostgreSQL over the internal Docker Compose network.

```text
Internet
   │
   ▼
FastAPI
   │
   ▼
PostgreSQL
```

There is no requirement for PostgreSQL to accept public internet traffic.

</details>

<details>
<summary><b>Why the health check is part of CI/CD</b></summary>

<br>

A successful Docker deployment does not automatically mean the application is usable.

The pipeline therefore verifies the running application after startup:

```bash
curl --fail http://localhost:8000/health
```

This turns deployment verification into an explicit pipeline stage.

</details>

---

# Project Goal

The goal of this project is **not** to build a complex application.

The goal is to demonstrate the DevOps lifecycle of a backend service:

> **Develop → Test → Containerize → Publish → Deploy → Verify → Operate**

The project serves as a practical demonstration of DevOps engineering skills for internship and entry-level engineering roles.

---

<p align="center">

**Built to learn DevOps by actually deploying it.**

</p>
