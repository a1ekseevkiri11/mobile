from datetime import datetime
from typing import List, Optional
from fastapi import (
    APIRouter,
    Depends,
    File,
    Form,
    HTTPException,
    Query,
    UploadFile,
    status
)
from fastapi.encoders import jsonable_encoder
from pydantic import BaseModel, ValidationError

from src.news import services as news_services
from src.news import schemas as news_schemas

news_router = APIRouter(tags=["Product"], prefix="")


class Checker:
    def __init__(self, model: BaseModel):
        self.model = model

    def __call__(self, data: str = Form(...)):
        try:
            return self.model.model_validate_json(data)
        except ValidationError as e:
            raise HTTPException(
                detail=jsonable_encoder(e.errors()),
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            )


@news_router.post(
    "/news/",
    status_code=status.HTTP_201_CREATED
)
async def news_add(
    news_data: news_schemas.NewsRequest = Depends(Checker(news_schemas.NewsRequest)),
    image:  UploadFile | None = None,
):
    return await news_services.NewsService.add(
        news_data=news_data,
        image=image,
    )


@news_router.get("/news/", response_model=List[news_schemas.NewsResponse])
async def get_news(
    start_date: Optional[datetime] = Query(None),
    end_date: Optional[datetime] = Query(None),
    tags: Optional[List[str]] = Query(None),
    order_desc: bool = Query(True),
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1),
):
    return await news_services.NewsService.get_news(
        start_date=start_date,
        end_date=end_date,
        tags=tags,
        order_desc=order_desc,
        page=page,
        page_size=page_size,
    )


@news_router.get(
    "/news/{id}/",
    response_model=news_schemas.NewsResponse
)
async def news_get(
    id: int
):
    return await news_services.NewsService.get(id=id)    


@news_router.post(
    "/tags/",
    status_code=status.HTTP_201_CREATED
)
async def tags_add(
    tags_data: news_schemas.TagRequest,
):
    return await news_services.TagsService.add(
        tags_data=tags_data,
    )


@news_router.get(
    "/tags/",
    response_model=List[news_schemas.TagRequest]
)
async def tags_get_all():
    return await news_services.TagsService.get_all()