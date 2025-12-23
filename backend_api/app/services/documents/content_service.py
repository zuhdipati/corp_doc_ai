import json
import aiofiles
from pathlib import Path
from typing import Optional

from .base import DocumentBaseService


class DocumentContentService(DocumentBaseService):
    def __init__(self):
        super().__init__()
    
    async def get_document_path(self, document_id: str, user_id: str) -> Optional[Path]:
        metadata = await self._load_metadata(user_id)
        if document_id not in metadata:
            return None 
        
        stored_filename = metadata[document_id]["stored_filename"]
        file_path = self._get_user_dir(user_id) / stored_filename
        
        if file_path.exists():
            return file_path
        return None
    
    async def read_document_content(self, document_id: str, user_id: str) -> Optional[str]:
        file_path = await self.get_document_path(document_id, user_id)
        if not file_path:
            return None
        
        metadata = await self._load_metadata(user_id)
        file_type = metadata[document_id]["file_type"]
        
        try:
            if file_type == "txt":
                async with aiofiles.open(file_path, 'r', encoding='utf-8') as f:
                    return await f.read()
            
            elif file_type == "json":
                async with aiofiles.open(file_path, 'r', encoding='utf-8') as f:
                    content = await f.read()
                    data = json.loads(content)
                    return json.dumps(data, indent=2, ensure_ascii=False)
            
            elif file_type == "pdf":
                try:
                    from pypdf import PdfReader
                    reader = PdfReader(str(file_path))
                    text_parts = []
                    for page in reader.pages:
                        text = page.extract_text()
                        if text:
                            text_parts.append(text)
                    return "\n\n".join(text_parts)
                except ImportError:
                    return f"[PDF content from {metadata[document_id]['file_name']} - install pypdf for text extraction]"
            
            else:
                return None
                
        except Exception as e:
            print(f"Error reading document: {e}")
            return None
    
    async def document_exists(self, document_id: str, user_id: str) -> bool:
        path = await self.get_document_path(document_id, user_id)
        return path is not None


document_content_service = DocumentContentService()
