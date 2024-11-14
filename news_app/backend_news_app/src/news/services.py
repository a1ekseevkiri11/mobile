from datetime import datetime
import os
from pathlib import Path
import shutil
from typing import List, Optional
from fastapi import Depends, File, HTTPException, UploadFile, status
from sqlalchemy import desc, func, select
from sqlalchemy.orm import selectinload, joinedload


from src.news import schemas as news_schemas
from src.news import models as news_models
from src.database import async_session_maker


class NewsService:
    @classmethod
    async def add(
        self,
        news_data: news_schemas.TagRequest,
        image:  UploadFile | None = None,
    ) -> None:
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
                
            data_news_db = news_schemas.NewsCreateDB(
                **news_data.model_dump(),
                image_url=image_url,
            )
            news_db = news_models.News(
                **data_news_db.model_dump(),
            )
            session.add(news_db)
            await session.commit()
            await session.refresh(news_db) 
            if len(news_data.tag_ids) > 0:
                for tag_id in news_data.tag_ids:
                    result = await session.execute(select(news_models.Tags).filter(news_models.Tags.id == tag_id))
                    tag = result.scalars().first()
                    
                    if tag:
                        news_and_tag = news_models.NewsAndTags(news_id=news_db.id, tags_id=tag.id)
                        session.add(news_and_tag)
                
                await session.commit()
        
    @classmethod
    async def get(
        self,
        id: int,
    ):
        async with async_session_maker() as session:
            stmt = (
                select(news_models.News)
                .filter(news_models.News.id == id)
            )

            result = await session.execute(stmt)
            news = result.scalars().one_or_none()
            if news is None:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="News not found",
                )
                    
            return news
        
    @classmethod
    async def get_news(
        cls,
        start_date: Optional[datetime] = None,
        end_date: Optional[datetime] = None,
        tags: Optional[List[str]] = None,
        order_desc: bool = True,
        page: int = 1,
        page_size: int = 10,
    ):
        async with async_session_maker() as session:
            stmt = select(news_models.News).options(selectinload(news_models.News.tags))

            if start_date:
                stmt = stmt.filter(news_models.News.date >= start_date)
            if end_date:
                stmt = stmt.filter(news_models.News.date <= end_date)

            if tags:
                stmt = stmt.join(news_models.NewsAndTags).join(news_models.Tags).filter(news_models.Tags.title.in_(tags))
                stmt = stmt.group_by(news_models.News.id).having(func.count(news_models.Tags.id) == len(tags))

            stmt = stmt.order_by(desc(news_models.News.date) if order_desc else news_models.News.date)

            stmt = stmt.limit(page_size).offset((page - 1) * page_size)

            result = await session.execute(stmt)
            news = result.scalars().all()

            if not news:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="No news found for the given filters",
                )

            return news
    

class TagsService:
    @classmethod
    async def add(
        self,
        tags_data: news_schemas.TagRequest
    ) -> None:
        async with async_session_maker() as session:
            tags_data_db = news_schemas.TagCreateDB(
                **tags_data.model_dump(),
            )
            tags_db = news_models.Tags(
                **tags_data_db.model_dump(),
            )
            session.add(tags_db)
            await session.commit()
    
    @classmethod
    async def get_all(self):
        async with async_session_maker() as session:
            stmt = select(news_models.Tags)
            result = await session.execute(stmt)
            tags = result.scalars().all()
            
            tags_array = []
            
            for tag in tags:
                tags_array.append(
                    news_schemas.TagResponse.model_validate(tag)
                )
            
            return tags_array