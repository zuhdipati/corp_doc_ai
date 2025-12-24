import logging
import shutil
import time
from pathlib import Path
from typing import List

from langchain_huggingface import HuggingFaceEmbeddings
from langchain_chroma import Chroma
from langchain_core.documents import Document

from app.core.config import settings

logger = logging.getLogger(__name__)


class VectorStoreService:
    def __init__(self):
        self.embedding_model = settings.EMBEDDING_MODEL
        self.base_vectorstore_dir = Path(settings.VECTORSTORE_DIR)
        self._embedding = None
    
    @property
    def embedding(self) -> HuggingFaceEmbeddings:
        """Lazy loading of embedding model"""
        if self._embedding is None:
            logger.info(f"Loading embedding model: {self.embedding_model}")
            self._embedding = HuggingFaceEmbeddings(
                model_name=self.embedding_model,
                model_kwargs={"device": "cpu"},
                encode_kwargs={"normalize_embeddings": True}
            )
        return self._embedding
    
    def _get_user_vectorstore_dir(self, user_id: str) -> Path:
        user_dir = self.base_vectorstore_dir / user_id / "chroma"
        user_dir.mkdir(parents=True, exist_ok=True)
        return user_dir
    
    def build_vectorstore(self, chunks: List[Document], user_id: str) -> Chroma:
        logger.info(f"Building vectorstore for user {user_id}...")
        start = time.time()
        
        persist_dir = str(self._get_user_vectorstore_dir(user_id))
        chroma_db_file = Path(persist_dir) / "chroma.sqlite3"
        
        if chroma_db_file.exists():
            logger.info("Loading existing index and adding documents...")
            db = Chroma(
                persist_directory=persist_dir,
                embedding_function=self.embedding
            )
            if chunks:
                db.add_documents(chunks)
        else:
            if Path(persist_dir).exists():
                shutil.rmtree(persist_dir)
                Path(persist_dir).mkdir(parents=True, exist_ok=True)
            
            logger.info("Creating new index...")
            db = Chroma.from_documents(
                documents=chunks,
                embedding=self.embedding,
                persist_directory=persist_dir
            )
        
        elapsed = time.time() - start
        logger.info(f"Vectorstore built in {elapsed:.2f}s")
        return db
    
    def load_vectorstore(self, user_id: str) -> Chroma:
        persist_dir = self._get_user_vectorstore_dir(user_id)
        chroma_db_file = persist_dir / "chroma.sqlite3"
        
        if not chroma_db_file.exists():
            raise ValueError(f"Vectorstore for user {user_id} not found")
        
        logger.debug(f"Loading vectorstore for user {user_id}")
        return Chroma(
            persist_directory=str(persist_dir),
            embedding_function=self.embedding
        )
    
    def delete_vectorstore(self, user_id: str) -> bool:
        persist_dir = self._get_user_vectorstore_dir(user_id)
        if persist_dir.exists():
            shutil.rmtree(persist_dir)
            logger.info(f"Deleted vectorstore for user {user_id}")
            return True
        return False


vectorstore_service = VectorStoreService()
