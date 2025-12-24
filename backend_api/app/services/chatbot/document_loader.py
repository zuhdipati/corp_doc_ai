import logging
import time
from pathlib import Path
from typing import List

from langchain_community.document_loaders import JSONLoader, TextLoader, PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_core.documents import Document

from app.core.config import settings

logger = logging.getLogger(__name__)


class DocumentLoader:
    def __init__(self):
        self.chunk_size = settings.CHUNK_SIZE
        self.chunk_overlap = settings.CHUNK_OVERLAP
        self.splitter = RecursiveCharacterTextSplitter(
            chunk_size=self.chunk_size,
            chunk_overlap=self.chunk_overlap
        )
    
    def load_from_json(self, file_path: Path) -> List[Document]:
        loader = JSONLoader(
            file_path=str(file_path),
            jq_schema='if type == "array" then .[] else . end',
            text_content=False
        )
        return loader.load()
    
    def load_user_documents(self, user_id: str) -> List[Document]:
        user_dir = Path(settings.UPLOAD_DIR) / user_id
        documents = []
        
        if not user_dir.exists():
            logger.warning(f"User directory not found: {user_dir}")
            return documents
        
        for file_path in user_dir.glob("*"):
            try:
                if file_path.suffix == ".json" and file_path.name != "metadata.json":
                    documents.extend(self.load_from_json(file_path))
                elif file_path.suffix == ".txt":
                    documents.extend(TextLoader(str(file_path)).load())
                elif file_path.suffix == ".pdf":
                    documents.extend(PyPDFLoader(str(file_path)).load())
            except Exception as e:
                logger.error(f"Error loading {file_path}: {e}")
                continue
        
        return documents
    
    def load_and_split(self, user_id: str) -> List[Document]:
        start = time.time()
        docs = self.load_user_documents(user_id)
        
        if not docs:
            logger.info(f"No documents found for user {user_id}")
            return []
        
        logger.info(f"{len(docs)} documents loaded for user {user_id}")
        chunks = self.splitter.split_documents(docs)
        
        elapsed = time.time() - start
        logger.info(f"Load + split completed in {elapsed:.2f}s, {len(chunks)} chunks ready")
        
        return chunks


document_loader = DocumentLoader()