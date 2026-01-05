import uuid
import aiofiles
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional
from fastapi import UploadFile, HTTPException

from .base import DocumentBaseService
from app.models.document import DocumentMetadata


class DocumentService(DocumentBaseService):
    ALLOWED_EXTENSIONS = {'.pdf', '.json', '.txt'}
    MAX_FILE_SIZE = 10 * 1024 * 1024

    def __init__(self):
        super().__init__()
    
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
        now = datetime.now(timezone.utc)
        metadata = DocumentMetadata(
            document_id=document_id,
            user_id=user_id,
            file_name=file.filename,
            file_type=ext.lstrip('.'),
            size_bytes=len(content),
            uploaded_at=now
        )
        
        # update metadata
        all_metadata = await self._load_metadata(user_id)
        all_metadata[document_id] = {
            "document_id": document_id,
            "user_id": user_id,
            "file_name": file.filename,
            "file_type": ext.lstrip('.'),
            "size_bytes": len(content),
            "uploaded_at": now.isoformat(),
            "stored_filename": safe_filename
        }
        await self._save_metadata(user_id, all_metadata)
        
        return metadata
    
    async def get_document_metadata(self, document_id: str, user_id: str) -> Optional[DocumentMetadata]:
        all_metadata = await self._load_metadata(user_id)
        if document_id not in all_metadata:
            return None
        
        doc_data = all_metadata[document_id]
        return DocumentMetadata(
            document_id=doc_data["document_id"],
            user_id=doc_data["user_id"],
            file_name=doc_data["file_name"],
            file_type=doc_data["file_type"],
            size_bytes=doc_data["size_bytes"],
            uploaded_at=datetime.fromisoformat(doc_data["uploaded_at"])
        )
    
    async def list_documents(self, user_id: str) -> list[DocumentMetadata]:
        all_metadata = await self._load_metadata(user_id)
        documents = []
        
        for doc_data in all_metadata.values():
            documents.append(DocumentMetadata(
                document_id=doc_data["document_id"],
                user_id=doc_data["user_id"],
                file_name=doc_data["file_name"],
                file_type=doc_data["file_type"],
                size_bytes=doc_data["size_bytes"],
                uploaded_at=datetime.fromisoformat(doc_data["uploaded_at"])
            ))
        
        return documents
    
    async def delete_document(self, document_id: str, user_id: str) -> bool:
        all_metadata = await self._load_metadata(user_id)
        
        if document_id not in all_metadata:
            return False
        
        stored_filename = all_metadata[document_id]["stored_filename"]
        user_dir = self._get_user_dir(user_id)
        file_path = user_dir / stored_filename
        
        if file_path.exists():
            file_path.unlink()
        
        del all_metadata[document_id]
        await self._save_metadata(user_id, all_metadata)
        
        return True


document_service = DocumentService()
