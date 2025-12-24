import logging

from .document_loader import document_loader
from .vectorstore_service import vectorstore_service
from .llm_service import llm_service

logger = logging.getLogger(__name__)


class ChatbotService:
    def __init__(self):
        self.loader = document_loader
        self.vectorstore_service = vectorstore_service
        self.llm_service = llm_service
    
    def build_user_knowledge_base(self, user_id: str):
        logger.info(f"Building knowledge base for user {user_id}")
        
        chunks = self.loader.load_and_split(user_id)
        
        if not chunks:
            logger.warning(f"No documents found for user {user_id}")
            return None
        
        db = self.vectorstore_service.build_vectorstore(chunks, user_id)
        logger.info(f"Knowledge base for user {user_id} built successfully")
        return db
    
    async def ask(self, user_id: str, question: str, chat_history: list = None) -> dict:
        logger.info(f"User {user_id} asking: {question[:50]}...")
        
        try:
            db = self.vectorstore_service.load_vectorstore(user_id)
        except ValueError:
            logger.warning(f"No knowledge base found for user {user_id}")
            return {
                "answer": "Anda belum memiliki dokumen. Silakan upload dokumen terlebih dahulu.",
                "source_documents": []
            }
        
        return await self.llm_service.ask(db, question, chat_history)
    
    def delete_user_knowledge_base(self, user_id: str) -> bool:
        return self.vectorstore_service.delete_vectorstore(user_id)


chatbot_service = ChatbotService()
