# DevOps Backend Item Service

A minimal, production-ready FastAPI + PostgreSQL backend designed as a DevOps portfolio foundation.

## Features
- **FastAPI**: Modern, fast web framework with automatic OpenAPI documentation (`/docs` and `/redoc`).
- **PostgreSQL / SQLAlchemy**: ORM-based schema modeling and database connectivity with connection health verification.
- **Environment Driven**: 12-factor application design configured via environment variables and `pydantic-settings`.
- **Automated Testing**: Complete test suite using `pytest` and `httpx` with isolated in-memory test database fixtures.

## Project Structure
```text
devops-project-1/
├── app/
│   ├── __init__.py
│   ├── config.py         # Environment & app configuration
│   ├── database.py       # Engine, sessionmaker, and get_db dependency
│   ├── models.py         # SQLAlchemy ORM models (Item)
│   ├── schemas.py        # Pydantic schemas (ItemCreate, ItemResponse)
│   ├── crud.py           # Database CRUD helpers
│   └── main.py           # FastAPI application and route handlers
├── tests/
│   ├── __init__.py
│   ├── conftest.py       # Pytest fixtures and TestClient setup
│   └── test_main.py      # Automated tests for all endpoints
├── .env.example          # Sample environment variables
├── .gitignore            # Git ignore configuration
├── requirements.txt      # Python dependencies
└── README.md             # Project documentation
```

## API Endpoints
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/` | Root service status and greeting |
| `GET` | `/health` | Health check endpoint verifying DB connectivity |
| `GET` | `/api/items` | Retrieve list of items |
| `POST` | `/api/items` | Create a new item |

Interactive API documentation is available at `http://localhost:8000/docs`.

## Local Setup

### 1. Create and Activate Virtual Environment
```bash
python -m venv .venv

# On Windows:
.venv\Scripts\activate

# On Linux/macOS:
source .venv/bin/activate
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Configure Environment Variables
Copy `.env.example` to `.env` and adjust database credentials if needed:
```bash
cp .env.example .env
```
Default configuration:
```env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/devops_db
APP_NAME="DevOps Item Service"
APP_ENV=development
DEBUG=True
PORT=8000
```
*(Note: If no PostgreSQL database is available, the app falls back to SQLite `sqlite:///./devops.db` for zero-setup local runs).*

### 4. Run Tests
```bash
pytest -v
```

### 5. Start Application Locally
```bash
uvicorn app.main:app --reload --port 8000
```

---

## Docker & Docker Compose Setup

Run the application and PostgreSQL together in isolated containers with persistence and health checking.

### 1. Build Containers
```bash
docker compose build
```

### 2. Start Services
```bash
docker compose up -d
```

### 3. Check Status and Logs
```bash
docker compose ps
docker compose logs -f
```

### 4. Health Check
```bash
curl http://localhost:8000/health
```

### 5. Stop Containers
```bash
docker compose down
```

---

## Automated CI/CD Pipeline (GitHub Actions to AWS EC2)

The repository includes a 3-stage automated CI/CD pipeline defined in [`.github/workflows/ci.yml`](.github/workflows/ci.yml):

```text
git push (main)
  │
  ▼
1. Run Automated Tests
   ├── Real PostgreSQL service container with pg_isready healthcheck
   ├── Python 3.13 setup with pip caching
   └── pytest test suite (100% pass required)
  │
  ▼
2. Build & Push Docker Image
   ├── Docker Buildx setup
   ├── Docker Hub authentication (via GitHub Secrets)
   └── Build & push image tagged with latest and ${{ github.sha }}
  │
  ▼
3. Deploy to AWS EC2
   ├── Copy docker-compose.yml to EC2 via SCP (~/app)
   ├── Securely write ~/app/.env with DOCKER_IMAGE and DB credentials
   ├── Pull updated application container image: `docker compose pull api`
   ├── Start containers without building: `docker compose up -d --no-build`
   └── Run automated HTTP health check retry loop against http://localhost:8000/health
```

### Required GitHub Secrets
To enable automated container build, push, and remote EC2 deployment, configure the following secrets in your GitHub repository (**Settings > Secrets and variables > Actions**):

| Secret Name | Description | Example / Format |
|---|---|---|
| `DOCKERHUB_USERNAME` | Your Docker Hub account username | `johndoe` |
| `DOCKERHUB_TOKEN` | Docker Hub Personal Access Token (PAT) with Read & Write permissions | `dckr_pat_xxxxxx` |
| `EC2_HOST` | Public IPv4 address or public DNS of your AWS EC2 instance | `54.210.xx.xx` or `ec2-xx.compute-1.amazonaws.com` |
| `EC2_USER` | SSH username for your EC2 Linux distribution | `ubuntu` (for Ubuntu) or `ec2-user` (for Amazon Linux) |
| `EC2_SSH_KEY` | Raw PEM private key contents used to connect to your EC2 instance | `-----BEGIN RSA PRIVATE KEY----- ... -----END RSA PRIVATE KEY-----` |
| `POSTGRES_PASSWORD` | Secure production database password for PostgreSQL | `my_strong_db_password_123` |
