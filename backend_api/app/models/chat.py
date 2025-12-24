from typing import Optional, List
from pydantic import BaseModel


class ChatRequest(BaseModel):
    question: str
    chat_history: Optional[List[dict]] = None


class ChatResponse(BaseModel):
    answer: str
    sources: Optional[List[str]] = None