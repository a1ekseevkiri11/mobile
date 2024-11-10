from typing import List, Optional
from fastapi import (
    APIRouter,
    Depends,
    File,
    HTTPException,
    UploadFile,
    status
)
from fastapi.responses import JSONResponse

from src.product import services as product_services
from src.product import schemas as product_schemas

product_router = APIRouter(tags=["Product"], prefix="")


@product_router.post(
    "/product/",
    status_code=status.HTTP_201_CREATED
)
async def product_add(
    product_data: product_schemas.ProductRequest = Depends(),
    image:  UploadFile | None = None,
):
    return await product_services.ProductService.add(
        product_data=product_data,
        image=image,
    )
        


@product_router.get(
    "/product/",
    response_model=List[product_schemas.ProductResponse]
)
async def product_get_all():
    return await product_services.ProductService.get_all()


@product_router.get(
    "/product/{product_id}/",
    response_model=product_schemas.ProductResponse
)
async def product_get(
    product_id: int
):
    return await product_services.ProductService.get(id=product_id)


@product_router.get(
    "/product/category/{category_id}/",
    response_model=list[product_schemas.ProductResponse]
)
async def get_products_by_category(
    category_id: int
):
    return await product_services.ProductService.get_by_category(category_id)
    


@product_router.get(
    "/category/",
    response_model=List[product_schemas.CategoryResponse]
)
async def category_get_all():
    return await product_services.CategoryService.get_all()