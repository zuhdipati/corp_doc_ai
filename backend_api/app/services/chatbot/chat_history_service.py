import uuid
from datetime import datetime, timezone
from typing import List, Optional, Tuple
from firebase_admin import firestore
from app.core.firebase_auth import get_firebase_app
from app.models.chat import ChatMessage


class ChatHistoryService:
    
    def __init__(self):
        self._db = None
    
    @property
    def db(self):
        if self._db is None:
            get_firebase_app() 
            self._db = firestore.client()
        return self._db
    
    def _get_messages_collection(self, user_id: str, document_id: str):
        return (self.db
            .collection("chat_history")
            .document(user_id)
            .collection("documents")
            .document(document_id)
            .collection("messages"))
    
    async def save_message(
        self,
        user_id: str,
        document_id: str,
        message: str,
        role: str
    ) -> ChatMessage:
        message_id = str(uuid.uuid4())
        timestamp = datetime.now(timezone.utc).isoformat()
        
        chat_message = ChatMessage(
            id=message_id,
            user_id=user_id,
            document_id=document_id,
            message=message,
            role=role,
            timestamp=timestamp
        )
        
        messages_ref = self._get_messages_collection(user_id, document_id)
        messages_ref.document(message_id).set(chat_message.model_dump())
        
        return chat_message
    
    async def get_history(
        self,
        user_id: str,
        document_id: str,
        limit: int = 20,
        before_id: Optional[str] = None
    ) -> Tuple[List[ChatMessage], bool, Optional[str]]:
      
        messages_ref = self._get_messages_collection(user_id, document_id)
        
        query = messages_ref.order_by("timestamp", direction=firestore.Query.DESCENDING)
        
        if before_id:
            cursor_doc = messages_ref.document(before_id).get()
            if cursor_doc.exists:
                query = query.start_after(cursor_doc)
        
        docs = query.limit(limit + 1).get()
        docs_list = list(docs)
        
        has_more = len(docs_list) > limit
        if has_more:
            docs_list = docs_list[:limit]
        
        messages = []
        for doc in docs_list:
            data = doc.to_dict()
            messages.append(ChatMessage(**data))
        
        next_cursor = messages[-1].id if has_more and messages else None
        
        messages.reverse()
        
        return messages, has_more, next_cursor
    
    async def delete_document_history(self, user_id: str, document_id: str) -> bool:
        try:
            messages_ref = self._get_messages_collection(user_id, document_id)
            docs = messages_ref.stream()
            
            for doc in docs:
                doc.reference.delete()
            
            return True
        except Exception:
            return False


chat_history_service = ChatHistoryService()
