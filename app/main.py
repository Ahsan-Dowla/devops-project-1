from contextlib import asynccontextmanager
from typing import List
from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.config import settings
from app.database import engine, Base, get_db
from app import schemas, crud


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Initialize database tables on startup
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title=settings.APP_NAME,
    lifespan=lifespan,
)


@app.get("/", tags=["Root"])
def read_root():
    return {
        "status": "healthy",
        "message": f"Welcome to {settings.APP_NAME}",
        "environment": settings.APP_ENV,
    }


@app.get("/health", tags=["Health"])
def health_check(db: Session = Depends(get_db)):
    try:
        # Verify database connection by executing a simple SELECT
        db.execute(text("SELECT 1"))
        return {
            "status": "healthy",
            "database": "connected",
        }
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Database unreachable: {str(exc)}",
        )


@app.get("/api/items", response_model=List[schemas.ItemResponse], tags=["Items"])
def list_items(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return crud.get_items(db, skip=skip, limit=limit)


@app.post(
    "/api/items",
    response_model=schemas.ItemResponse,
    status_code=status.HTTP_201_CREATED,
    tags=["Items"],
)
def create_item(item: schemas.ItemCreate, db: Session = Depends(get_db)):
    return crud.create_item(db=db, item=item)
