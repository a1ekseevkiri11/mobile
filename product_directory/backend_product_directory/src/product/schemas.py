from typing import Optional
from pydantic import (
    AnyUrl,
    BaseModel,
    EmailStr,
    Field,
    HttpUrl,
    field_validator,
)


class CategoryRequest(BaseModel):
    name: str


class CategoryResponse(BaseModel):
    id: int
    name: str
    
    class Config:
        from_attributes = True


class Category(BaseModel):
    id: int
    name: str  


class CategoryCreateDB(BaseModel):
    name: str
    
    
class CategoryUpdateDB(CategoryCreateDB):
    id: int
    

class ProductRequest(BaseModel):
    name: str
    description: str
    calories: int
    category_id: int
    ingredients: str
    
    
class ProductResponse(BaseModel):
    id: int
    name: str
    description: str
    calories: int
    ingredients: str
    image_url: Optional[str] = None 
    category: CategoryResponse
    
    class Config:
        from_attributes = True
    

class Product(BaseModel):
    id: int
    name: str
    description: str
    calories: int
    category_id: int
    ingredients: str
    image_url: Optional[str] = None


class ProductCreateDB(BaseModel):
    name: str
    description: str
    calories: int
    category_id: int
    ingredients: str
    image_url: Optional[str] = None
    
    class Config:
        orm_mode = True
    

class ProductUpdateDB(ProductCreateDB):
    id: int
    
