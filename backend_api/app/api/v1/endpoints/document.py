from fastapi import APIRouter, UploadFile, File, HTTPException, Depends, BackgroundTasks
import asyncio
import logging

from app.models.document import (
    DocumentResponse,
    DocumentMetadata,
    DocumentListResponse
)

from app.services.documents.document_service import document_service
from app.services.chatbot import chatbot_service
from app.core.firebase_auth import FirebaseUser, get_current_user

router = APIRouter()
logger = logging.getLogger(__name__)


@router.post("/upload", response_model=DocumentResponse)
async def upload_document(
    file: UploadFile = File(...),
    current_user: FirebaseUser = Depends(get_current_user)
):
    try:
        logger.info(f"Saving document for user {current_user.uid}")
        metadata = await document_service.save_document(file, current_user.uid)
        
        logger.info(f"Building knowledge base for user {current_user.uid}")

        # simpan hasil embed ke disk untuk chat feature
        await asyncio.to_thread(
            chatbot_service.build_user_knowledge_base, 
            current_user.uid
        )
        logger.info(f"Knowledge base ready for user {current_user.uid}")
        
        return DocumentResponse(
            document_id=metadata.document_id,
            file_name=metadata.file_name,
            file_type=metadata.file_type,
            size_bytes=metadata.size_bytes,
            uploaded_at=metadata.uploaded_at,
            message="Document uploaded and processed successfully",
        )
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to process document: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to upload document: {str(e)}")


@router.get("", response_model=DocumentListResponse)
async def list_documents(current_user: FirebaseUser = Depends(get_current_user)):
    documents = await document_service.list_documents(current_user.uid)
    return DocumentListResponse(
        documents=documents,
        total_count=len(documents)
    )


@router.get("/{document_id}", response_model=DocumentMetadata)
async def get_document(
    document_id: str,
    current_user: FirebaseUser = Depends(get_current_user)
):
    metadata = await document_service.get_document_metadata(document_id, current_user.uid)
    if not metadata:
        raise HTTPException(status_code=404, detail="Document not found")
    return metadata


@router.delete("/{document_id}")
async def delete_document(
    background_tasks: BackgroundTasks,
    document_id: str,
    current_user: FirebaseUser = Depends(get_current_user)
):
    success = await document_service.delete_document(document_id, current_user.uid)
    if not success:
        raise HTTPException(status_code=404, detail="Document not found")
    
    chatbot_service.delete_user_knowledge_base(current_user.uid)
    
    return {"message": "Document deleted successfully", "document_id": document_id}
