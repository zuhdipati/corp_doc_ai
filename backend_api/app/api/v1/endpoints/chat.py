import traceback
from typing import Optional
from fastapi import APIRouter, HTTPException, Depends, Query

from app.services.chatbot import chatbot_service
from app.services.chatbot.chat_history_service import chat_history_service
from app.core.firebase_auth import FirebaseUser, get_current_user
from app.models.chat import (
    SendMessageRequest,
    SendMessageResponse,
    ChatHistoryResponse,
)

router = APIRouter()


@router.post("/send", response_model=SendMessageResponse)
async def send_message(
    req: SendMessageRequest,
    current_user: FirebaseUser = Depends(get_current_user)
):
    try:
        await chat_history_service.save_message(
            user_id=current_user.uid,
            document_id=req.document_id,
            message=req.message,
            role="user"
        )
        
        history, _, _ = await chat_history_service.get_history(
            user_id=current_user.uid,
            document_id=req.document_id,
            limit=10
        )
        
        chat_history = [
            {"role": msg.role, "content": msg.message}
            for msg in history
        ]
        
        result = await chatbot_service.ask(
            user_id=current_user.uid,
            question=req.message,
            chat_history=chat_history,
        )
        
        bot_message = await chat_history_service.save_message(
            user_id=current_user.uid,
            document_id=req.document_id,
            message=result["answer"],
            role="bot"
        )
        
        return SendMessageResponse(
            id=bot_message.id,
            user_id=bot_message.user_id,
            document_id=bot_message.document_id,
            message=bot_message.message,
            role=bot_message.role,
            timestamp=bot_message.timestamp
        )
        
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/history", response_model=ChatHistoryResponse)
async def get_history(
    document_id: str = Query(..., description="Document ID to get chat history for"),
    limit: int = Query(default=20, ge=1, le=100, description="Number of messages to retrieve"),
    before_id: Optional[str] = Query(default=None, description="Cursor for pagination"),
    current_user: FirebaseUser = Depends(get_current_user)
):
    try:
        messages, has_more, next_cursor = await chat_history_service.get_history(
            user_id=current_user.uid,
            document_id=document_id,
            limit=limit,
            before_id=before_id
        )
        
        return ChatHistoryResponse(
            messages=messages,
            has_more=has_more,
            next_cursor=next_cursor
        )
        
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))
