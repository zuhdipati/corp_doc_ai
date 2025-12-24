from pydantic_settings import BaseSettings

class Settings(BaseSettings):

    PROJECT_NAME: str = "CorpDocAI"
    API_V1_STR: str = "/api/v1"

    # file storage
    UPLOAD_DIR: str = "./uploads"
    VECTORSTORE_DIR: str = "./vectorstores"
    
    # firebase
    FIREBASE_CREDENTIALS_PATH: str = "./service_account.json"
    
    # document processing
    CHUNK_SIZE: int = 3000
    CHUNK_OVERLAP: int = 200
    
    # embedding model
    EMBEDDING_MODEL: str = "BAAI/bge-m3"
    
    # llm settings
    LLM_MODEL: str = "openai/gpt-oss-20b"
    MODEL_API_KEY: str
    MODEL_BASE_URL: str
    RETRIEVER_K: int = 8         

    class Config:
        env_file = ".env"

settings = Settings()
