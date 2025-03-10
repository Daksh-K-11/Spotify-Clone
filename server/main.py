from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary, create_engine
import urllib.parse
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import uuid
import bcrypt

app = FastAPI()

database_password = urllib.parse.quote_plus('Chennai@05')

#DATABASE_URL

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit = False, autoflush=False, bind=engine)

db = SessionLocal()

class UserCreate(BaseModel):
    name: str
    email: str
    password: str

Base = declarative_base()


class User(Base):
    __tablename__ = 'users'
    
    id = Column(TEXT, primary_key=True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(LargeBinary)
    

Base.metadata.create_all(engine)

@app.post('/signup')
def signup_user(user: UserCreate):
    user_db = db.query(User).filter(User.email == user.email).first()
    
    if user_db:
        raise HTTPException(400, 'User with the same email already exists!')
    
    hashed_pwd = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), email=user.email, password=hashed_pwd, name=user.password)
    
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return (user_db)
    
    
    pass