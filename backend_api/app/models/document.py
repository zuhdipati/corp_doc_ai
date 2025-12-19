from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class DocumentUploadResponse(BaseModel):
    document_id: str
    filename: str
    file_type: str
    size_bytes: int
    uploaded_at: datetime
    message: str = "Document uploaded successfully"


class DocumentMetadata(BaseModel):
    document_id: str
    user_id: str
    filename: str
    file_type: str
    size_bytes: int
    uploaded_at: datetime


class DocumentListResponse(BaseModel):
    documents: list[DocumentMetadata]
    total_count: int
