import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
import cloudinary
import cloudinary.uploader
from ..middleware.auth_middleware import auth_middleware
from ..database import get_db
from ..config import settings

router = APIRouter()

cloudinary.config( 
    cloud_name = "dqtwcntwg", 
    api_key = "636192642438798", 
    api_secret = settings.cloudinary_api_key,
    secure=True
)

@router.post('/upload')
def upload_song(song: UploadFile = File(...),
                thumbnail: UploadFile = File(...), 
                artist: str = Form(...), 
                song_name: str = Form(...), 
                hex_code:  str = Form(...),
                db: Session = Depends(get_db),
                current_user: dict = Depends(auth_middleware)
                ):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}')
    print(song_res)
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}')
    print(thumbnail_res)
    return 'ok'