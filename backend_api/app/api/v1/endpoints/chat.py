from fastapi import APIRouter, HTTPException, Depends

from app.services.chatbot import chatbot_service
from app.core.firebase_auth import FirebaseUser, get_current_user
from app.models.chat import (
    ChatRequest,
    ChatResponse
)

router = APIRouter()


@router.post("", response_model=ChatResponse)
async def chat(
    req: ChatRequest,
    current_user: FirebaseUser = Depends(get_current_user)
):
    try:
        result = await chatbot_service.ask(
            user_id=current_user.uid,
            question=req.question,
            chat_history=req.chat_history,
        )
        
        sources = []
        for doc in result.get("source_documents", []):
            if hasattr(doc, "metadata"):
                sources.append(doc.metadata.get("source", "Unknown"))
        
        return ChatResponse(
            answer=result["answer"],
            sources=sources if sources else None
        )
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))
