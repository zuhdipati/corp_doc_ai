from pydantic_settings import BaseSettings

class Settings(BaseSettings):

    PROJECT_NAME: str = "CorpDocAI"
    API_V1_STR: str = "/api/v1"

    MODEL_API_KEY: str 
    MODEL_BASE_URL: str 
    VECTOR_DB_EMBEDDING_MODEL: str = "BAAI/bge-m3"
    VECTOR_DB_PATH: str = "./vector_db"
    MODEL_NAME: str = "openai/gpt-oss-20b"
    CHUNK_SIZE: int = 3000
    CHUNK_OVERLAP: int = 200

    class Config:
        env_file = ".env"

settings = Settings()
