import logging

from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
from langchain_classic.chains.combine_documents import create_stuff_documents_chain
from langchain_classic.chains.retrieval import create_retrieval_chain
from langchain_chroma import Chroma

from app.core.config import settings

logger = logging.getLogger(__name__)


PROMPT_TEMPLATE = """Anda adalah asisten AI yang membantu menjawab pertanyaan berdasarkan dokumen yang diberikan.

Konteks dari dokumen:
{context}

Riwayat percakapan:
{chat_history}

Pertanyaan: {input}

Berikan jawaban yang informatif dan akurat berdasarkan konteks di atas dengan friendly. 
Jika informasi tidak tersedia dalam dokumen, katakan bahwa Anda tidak menemukan informasi tersebut.
"""


class LLMService:
    def __init__(self):
        self._llm = None
        self.prompt = ChatPromptTemplate.from_template(PROMPT_TEMPLATE)
    
    @property
    def llm(self) -> ChatOpenAI:
        if self._llm is None:
            logger.info(f"Initializing LLM: {settings.LLM_MODEL}")
            self._llm = ChatOpenAI(
                model=settings.LLM_MODEL,
                base_url=settings.MODEL_BASE_URL,
                api_key=settings.MODEL_API_KEY,
                temperature=0.2,
            )
        return self._llm
    
    def build_chain(self, vectorstore: Chroma):
        retriever = vectorstore.as_retriever(search_kwargs={"k": settings.RETRIEVER_K})
        combine_docs_chain = create_stuff_documents_chain(
            llm=self.llm, 
            prompt=self.prompt
        )
        retrieval_chain = create_retrieval_chain(
            retriever=retriever, 
            combine_docs_chain=combine_docs_chain
        )
        return retrieval_chain
    
    async def ask(self, vectorstore: Chroma, question: str, chat_history: list = None) -> dict:
        logger.debug(f"Processing question: {question[:50]}...")
        
        chain = self.build_chain(vectorstore)
        response = await chain.ainvoke({
            "input": question,
            "chat_history": chat_history or []
        })
        
        logger.debug("Response generated successfully")
        return {
            "answer": response.get("answer", ""),
            "source_documents": response.get("context", [])
        }


llm_service = LLMService()
