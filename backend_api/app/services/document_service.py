import os
import uuid
import json
import aiofiles
from datetime import datetime
from pathlib import Path
from typing import Optional
from fastapi import UploadFile, HTTPException

from app.core.config import settings
from app.models.document import DocumentMetadata


class DocumentService:
    ALLOWED_EXTENSIONS = {'.pdf', '.json', '.txt'}
    MAX_FILE_SIZE = 10 * 1024 * 1024
    
    def __init__(self):
        self.upload_dir = Path(settings.UPLOAD_DIR)
        self._ensure_upload_dir()
    
    def _ensure_upload_dir(self):
        self.upload_dir.mkdir(parents=True, exist_ok=True)
    
    def _get_user_dir(self, user_id: str) -> Path:
        user_dir = self.upload_dir / user_id
        user_dir.mkdir(parents=True, exist_ok=True)
        return user_dir
    
    def _get_metadata_file(self, user_id: str) -> Path:
        return self._get_user_dir(user_id) / "metadata.json"
    
    def _load_metadata(self, user_id: str) -> dict:
        metadata_file = self._get_metadata_file(user_id)
        if metadata_file.exists():
            with open(metadata_file, 'r') as f:
                return json.load(f)
        return {}
    
    def _save_metadata(self, user_id: str, metadata: dict):
        metadata_file = self._get_metadata_file(user_id)
        with open(metadata_file, 'w') as f:
            json.dump(metadata, f, indent=2, default=str)
    
    def _validate_file(self, file: UploadFile) -> str:
        if not file.filename:
            raise HTTPException(status_code=400, detail="Filename is required")
        
        ext = Path(file.filename).suffix.lower()
        if ext not in self.ALLOWED_EXTENSIONS:
            raise HTTPException(
                status_code=400, 
                detail=f"File type '{ext}' not allowed. Allowed types: {', '.join(self.ALLOWED_EXTENSIONS)}"
            )
        return ext
    
    async def save_document(self, file: UploadFile, user_id: str) -> DocumentMetadata:
        ext = self._validate_file(file)
        
        content = await file.read()
        
        if len(content) > self.MAX_FILE_SIZE:
            raise HTTPException(
                status_code=400, 
                detail=f"File size exceeds maximum limit of {self.MAX_FILE_SIZE // (1024*1024)}MB"
            )
        
        document_id = str(uuid.uuid4())
        
        safe_filename = f"{document_id}{ext}"
        user_dir = self._get_user_dir(user_id)
        file_path = user_dir / safe_filename
        
        async with aiofiles.open(file_path, 'wb') as f:
            await f.write(content)
        
        # create metadata
        now = datetime.utcnow()
        metadata = DocumentMetadata(
            document_id=document_id,
            user_id=user_id,
            filename=file.filename,
            file_type=ext.lstrip('.'),
            size_bytes=len(content),
            uploaded_at=now
        )
        
        # update metadata storage
        all_metadata = self._load_metadata(user_id)
        all_metadata[document_id] = {
            "document_id": document_id,
            "user_id": user_id,
            "filename": file.filename,
            "file_type": ext.lstrip('.'),
            "size_bytes": len(content),
            "uploaded_at": now.isoformat(),
            "stored_filename": safe_filename
        }
        self._save_metadata(user_id, all_metadata)
        
        return metadata
    
    def get_document_metadata(self, document_id: str, user_id: str) -> Optional[DocumentMetadata]:
        all_metadata = self._load_metadata(user_id)
        if document_id not in all_metadata:
            return None
        
        doc_data = all_metadata[document_id]
        return DocumentMetadata(
            document_id=doc_data["document_id"],
            user_id=doc_data["user_id"],
            filename=doc_data["filename"],
            file_type=doc_data["file_type"],
            size_bytes=doc_data["size_bytes"],
            uploaded_at=datetime.fromisoformat(doc_data["uploaded_at"])
        )
    
    def list_documents(self, user_id: str) -> list[DocumentMetadata]:
        all_metadata = self._load_metadata(user_id)
        documents = []
        
        for doc_data in all_metadata.values():
            documents.append(DocumentMetadata(
                document_id=doc_data["document_id"],
                user_id=doc_data["user_id"],
                filename=doc_data["filename"],
                file_type=doc_data["file_type"],
                size_bytes=doc_data["size_bytes"],
                uploaded_at=datetime.fromisoformat(doc_data["uploaded_at"])
            ))
        
        return documents
    
    def delete_document(self, document_id: str, user_id: str) -> bool:
        all_metadata = self._load_metadata(user_id)
        
        if document_id not in all_metadata:
            return False
        
        stored_filename = all_metadata[document_id]["stored_filename"]
        user_dir = self._get_user_dir(user_id)
        file_path = user_dir / stored_filename
        
        if file_path.exists():
            file_path.unlink()
        
        del all_metadata[document_id]
        self._save_metadata(user_id, all_metadata)
        
        return True


document_service = DocumentService()
