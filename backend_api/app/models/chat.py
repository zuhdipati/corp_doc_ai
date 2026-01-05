from typing import Optional, List
from pydantic import BaseModel


class ChatMessage(BaseModel):
    id: str
    user_id: str
    document_id: str
    message: str
    role: str
    timestamp: str


class SendMessageRequest(BaseModel):
    document_id: str
    message: str


class SendMessageResponse(BaseModel):
    id: str
    user_id: str
    document_id: str
    message: str
    role: str = "bot"
    timestamp: str


class ChatHistoryResponse(BaseModel):
    messages: List[ChatMessage]
    has_more: bool
    next_cursor: Optional[str] = None
