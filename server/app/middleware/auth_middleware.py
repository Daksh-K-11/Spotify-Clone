from fastapi import HTTPException, Header
import jwt
from ..config import settings

SECRET_KEY = settings.secret_key
ALGORITHM = settings.algorithm

def auth_middleware(x_auth_token = Header()):
    try: 
        if not x_auth_token:
            raise HTTPException(status_code=401, detail='No auth token, access denied')
        
        verified_token = jwt.decode(x_auth_token, SECRET_KEY, algorithms=[ALGORITHM] )
        
        if not verified_token:
            raise HTTPException(status_code=401, detail='Token varification failed, authorization denied')
        
        uid = verified_token.get('id')
        return {'uid': uid, 'token': x_auth_token}
    
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail='Invalid token, access denied')