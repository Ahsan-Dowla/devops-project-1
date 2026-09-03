from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    APP_NAME: str = "DevOps Item Service"
    APP_ENV: str = "development"
    DEBUG: bool = True
    PORT: int = 8000
    DATABASE_URL: str = "sqlite:///./devops.db"

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )


settings = Settings()
