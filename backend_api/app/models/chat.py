from typing import Optional
from pydantic import BaseModel
from typing import List, Optional

class ChatRequest(BaseModel):
    question: str
    chat_history: Optional[List[str]] = []

class ChatResponse(BaseModel):
    answer: str