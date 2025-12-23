from fastapi import APIRouter, UploadFile, File, HTTPException, Depends

from app.models.document import (
    DocumentResponse,
    DocumentMetadata,
    DocumentListResponse
)
from app.services.document_service import document_service
from app.core.firebase_auth import FirebaseUser, get_current_user

router = APIRouter()


@router.post("/upload", response_model=DocumentResponse)
async def upload_document(
    file: UploadFile = File(...),
    current_user: FirebaseUser = Depends(get_current_user)
):
    try:
        metadata = await document_service.save_document(file, current_user.uid)
        return DocumentResponse(
            document_id=metadata.document_id,
            file_name=metadata.file_name,
            file_type=metadata.file_type,
            size_bytes=metadata.size_bytes,
            uploaded_at=metadata.uploaded_at
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to upload document: {str(e)}")


@router.get("", response_model=DocumentListResponse)
async def list_documents(current_user: FirebaseUser = Depends(get_current_user)):
    documents = document_service.list_documents(current_user.uid)
    return DocumentListResponse(
        documents=documents,
        total_count=len(documents)
    )


@router.get("/{document_id}", response_model=DocumentMetadata)
async def get_document(
    document_id: str,
    current_user: FirebaseUser = Depends(get_current_user)
):
    metadata = document_service.get_document_metadata(document_id, current_user.uid)
    if not metadata:
        raise HTTPException(status_code=404, detail="Document not found")
    return metadata


@router.delete("/{document_id}")
async def delete_document(
    document_id: str,
    current_user: FirebaseUser = Depends(get_current_user)
):
    success = document_service.delete_document(document_id, current_user.uid)
    if not success:
        raise HTTPException(status_code=404, detail="Document not found")
    return {"message": "Document deleted successfully", "document_id": document_id}
