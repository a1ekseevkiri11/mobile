from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, Integer, String


from src.models import (
    Base,
)


class Category(Base):
    __tablename__ = 'categories'

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String, index=True)

    products = relationship("Product", back_populates="category")
    

class Product(Base):
    __tablename__ = 'products'

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String, index=True)
    description: Mapped[str] = mapped_column(String)
    calories: Mapped[int] = mapped_column(Integer)
    ingredients: Mapped[str] = mapped_column(String)
    image_url: Mapped[str] = mapped_column(String, nullable=True)

    category_id: Mapped[int] = mapped_column(Integer, ForeignKey('categories.id'))

    category = relationship("Category", back_populates="products")