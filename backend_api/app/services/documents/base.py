from pathlib import Path
import json
import aiofiles
from app.core.config import settings


class DocumentBaseService:
    def __init__(self):
        self.upload_dir = Path(settings.UPLOAD_DIR)
        self._ensure_upload_dir()
    
    def _ensure_upload_dir(self):
        self.upload_dir.mkdir(parents=True, exist_ok=True)
    
    def _get_user_dir(self, user_id: str) -> Path:
        user_dir = self.upload_dir / user_id
        user_dir.mkdir(parents=True, exist_ok=True)
        return user_dir
    
    def _get_metadata_file(self, user_id: str) -> Path:
        return self._get_user_dir(user_id) / "metadata.json"
    
    async def _load_metadata(self, user_id: str) -> dict:
        metadata_file = self._get_metadata_file(user_id)
        if metadata_file.exists():
            async with aiofiles.open(metadata_file, 'r') as f:
                content = await f.read()
                return json.loads(content)
        return {}
    
    async def _save_metadata(self, user_id: str, metadata: dict):
        metadata_file = self._get_metadata_file(user_id)
        async with aiofiles.open(metadata_file, 'w') as f:
            await f.write(json.dumps(metadata, indent=2, default=str))