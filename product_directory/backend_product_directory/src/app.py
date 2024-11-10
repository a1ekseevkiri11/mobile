from fastapi import FastAPI
from contextlib import asynccontextmanager

from fastapi.staticfiles import StaticFiles


from src.settings import settings
from src.product.routers import product_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield


app = FastAPI(
    title="бэк для лабы",
    description="",
    debug=settings.debug,
)

app.mount("/static", StaticFiles(directory="static/images"), name="static")

app.include_router(router=product_router, prefix="")
