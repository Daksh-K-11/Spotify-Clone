from fastapi import Depends, HTTPException, APIRouter, Header
import uuid
import bcrypt

from ..middleware.auth_middleware import auth_middleware
from ..models.user import User
from ..schemas.user_create import UserCreate
from ..schemas.user_login import UserLogin
from ..database import get_db
from sqlalchemy.orm import Session
import jwt
from ..config import settings

router = APIRouter()

SECRET_KEY = settings.secret_key
ALGORITHM = settings.algorithm

@router.post('/signup', status_code=201)
def signup_user(user: UserCreate, db: Session=Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    
    if user_db:
        raise HTTPException(400, 'User with the same email already exists!')
    
    hashed_pwd = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), email=user.email, password=hashed_pwd, name=user.name)
    
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return (user_db)
    

@router.post('/login', status_code=200)
def login_user(user: UserLogin, db: Session=Depends(get_db)):
    
    user_db = db.query(User).filter(User.email == user.email).first()
    
    if not user_db:
        raise HTTPException(400, 'User with this email does not exists!')
    
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)
    
    if not is_match:
        raise HTTPException(401, 'Incorrect password!')
    
    token = jwt.encode({'id': user_db.id}, SECRET_KEY, algorithm=ALGORITHM)
    
    return {'token': token, 'user': user_db}

@router.get('/')
def current_user_data(user_dict = Depends(auth_middleware), db: Session=Depends(get_db)):
    
    user = db.query(User).filter(User.id == user_dict.get('uid')).first()
    
    if not user:
        raise HTTPException(404, 'User not found!')
    
    return user