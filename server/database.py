from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import urllib.parse


database_password = urllib.parse.quote_plus('Chennai@05')
DATABASE_URL = f"postgresql://postgres:{database_password}@localhost:5432/musicapp"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit = False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()