from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class TagRequest(BaseModel):
    title: str


class TagResponse(BaseModel):
    id: int
    title: str
    
    class Config:
        from_attributes = True


class TagCreateDB(BaseModel):
    title: str
    
    class Config:
        from_attributes = True


class TagUpdateDB(TagCreateDB):
    id: int


class NewsRequest(BaseModel):
    title: str
    description: str
    tag_ids: List[int] = []


class NewsResponse(BaseModel):
    id: int
    title: str
    description: str
    date: datetime
    image_url: Optional[str] = None
    tags: List[TagResponse] = []

    class Config:
        from_attributes = True


class NewsCreateDB(BaseModel):
    title: str
    description: str
    image_url: Optional[str] = None
    
    class Config:
        from_attributes = True


class NewsUpdateDB(NewsCreateDB):
    id: int