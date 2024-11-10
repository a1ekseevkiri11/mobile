import os
from pathlib import Path
import shutil
from fastapi import Depends, File, HTTPException, UploadFile, status
from sqlalchemy import select
from sqlalchemy.orm import selectinload


from src.product import schemas as product_schemas
from src.product import models as product_models
from src.database import async_session_maker


class ProductService:
    @classmethod
    async def add(
        self,
        product_data: product_schemas.ProductRequest,
        image: UploadFile | None = None,
    ):
        async with async_session_maker() as session:
            image_url = None
            if image:
                image_dir = os.path.join(
                    "static", "images"
                )
                
                os.makedirs(image_dir, exist_ok=True)
                file_location = os.path.join(image_dir, image.filename)
                with open(file_location, "wb") as buffer:
                    shutil.copyfileobj(image.file, buffer)
                image_url = f"/static/{image.filename}"
                
            product_db = product_models.Product(
                **product_data.model_dump(),
                image_url=image_url,
            )
            
            try:
                session.add(product_db)
                await session.commit()
            except Exception as e:
                await session.rollback()
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail=f"{e}"
                )
        
        
    
    @classmethod
    async def get(
        self,
        id: int,
    ):
        async with async_session_maker() as session:
            stmt = select(
                product_models.Product
            ).filter(
                product_models.Product.id == id
            ).options(
                selectinload(
                    product_models.Product.category
                )
            )
            result = await session.execute(stmt)
            product = result.scalars().first()
            
            
            if product is None:
                raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Product not found",
            )
                
            
            return product_schemas.ProductResponse.model_validate(product)
    
    @classmethod
    async def get_all(self):
        async with async_session_maker() as session:
            stmt = select(
                product_models.Product).options(selectinload(
                    product_models.Product.category
                )
            )
            result = await session.execute(stmt)
            products = result.scalars().all()
                
            array_products = []
            for product in products:
                array_products.append(
                    product_schemas.ProductResponse.model_validate(product)
                )
            
            return array_products
    
    @classmethod
    async def get_by_category(
        self, 
        category_id: int
    ):
        async with async_session_maker() as session:
            stmt = (
                select(product_models.Product)
                .filter(product_models.Product.category_id == category_id)
                .options(selectinload(product_models.Product.category))
            )
            result = await session.execute(stmt)
            products = result.scalars().all()
            
            array_products = []
            for product in products:
                array_products.append(
                    product_schemas.ProductResponse.model_validate(product)
                )
            
            return array_products
    

class CategoryService:
    
    @classmethod
    async def get_all(self):
        async with async_session_maker() as session:
            stmt = select(product_models.Category)
            result = await session.execute(stmt)
            categories = result.scalars().all()
            
            array_categories = []
            
            for category in categories:
                array_categories.append(
                    product_schemas.CategoryResponse.model_validate(category)
                )
            
            return array_categories