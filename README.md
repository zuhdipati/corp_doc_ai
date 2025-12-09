# Corp Doc AI

Transform static documents into interactive conversations. Simply upload your files to initialize a context-specific chat session, where the LLM leverages vector embeddings to answer any query based on your unique content.

## Key Features

### Mobile
- Clean Architecture: Strict separation of concerns (Presentation, Domain, Data) ensuring scalability and testability.
- Robust State Management: Powered by BLoC to handle complex states (Loading, Success, Failure, Offline).
- Offline Capability: Implements internet_connection_checker_plus and Hive NoSQL database to cache chat history and documents.
- Dependency Injection: Uses get_it for a decoupled service locator pattern.
- Automated Testing: Comprehensive Unit Tests and Widget Tests ensuring business logic reliability.

### Backend (Python)
- RAG Implementation: Custom pipeline using LangChain to process Documentss and retrieve context.
- Vector Search: Integration with Vector Database (ChromaDB) for semantic search.
- API Performance: Built with FastAPI for high-performance, asynchronous endpoints.
- LLM Integration (OpenRouter) - Leverages OpenAI models through OpenRouter to deliver ultra-low latency and highly natural language generation.
- Containerization: Fully Dockerized for easy deployment.