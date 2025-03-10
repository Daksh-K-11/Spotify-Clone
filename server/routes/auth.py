from fastapi import Depends, HTTPException, APIRouter
import uuid
import bcrypt
from models.user import User
from schemas.user_create import UserCreate
from database import get_db
from sqlalchemy.orm import Session

router = APIRouter()

@router.post('/signup')
def signup_user(user: UserCreate, db: Session=Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    
    if user_db:
        raise HTTPException(400, 'User with the same email already exists!')
    
    hashed_pwd = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), email=user.email, password=hashed_pwd, name=user.password)
    
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return (user_db)
    