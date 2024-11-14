from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import DateTime, ForeignKey, Integer, String, func


from src.models import (
    Base,
)


class Tags(Base):
    __tablename__ = 'tags'

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(String, index=True)

    news: Mapped[list["News"]] = relationship(
        "News",
        secondary="news_and_tags",
        back_populates="tags",
        lazy="selectin"
    )


class News(Base):
    __tablename__ = 'news'

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(String, index=True)
    description: Mapped[str] = mapped_column(String)
    date: Mapped[DateTime] = mapped_column(DateTime, default=func.now())
    image_url: Mapped[str] = mapped_column(String, nullable=True)

    tags: Mapped[list["Tags"]] = relationship(
        "Tags",
        secondary="news_and_tags",
        back_populates="news",
        lazy="selectin"
    )


class NewsAndTags(Base):
    __tablename__ = 'news_and_tags'

    tags_id: Mapped[int] = mapped_column(ForeignKey("tags.id"), primary_key=True)
    news_id: Mapped[int] = mapped_column(ForeignKey("news.id"), primary_key=True)