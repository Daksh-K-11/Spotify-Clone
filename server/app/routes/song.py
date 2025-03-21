import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session, joinedload
import cloudinary
import cloudinary.uploader

from ..models.favorite import Favorite
from ..middleware.auth_middleware import auth_middleware
from ..database import get_db
from ..config import settings
from ..models.song import Song
from ..schemas.favorite_song import FavoriteSong

router = APIRouter()

cloudinary.config( 
    cloud_name = "dqtwcntwg", 
    api_key = "636192642438798", 
    api_secret = settings.cloudinary_api_secret,
    secure=True
)

@router.post('/upload', status_code=201)
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
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}')
    
    new_song = Song(
        id = song_id,
        song_name = song_name,
        artist = artist,
        hex_code = hex_code,
        song_url = song_res['url'],
        thumbnail_url = thumbnail_res['url']
    )
    
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

@router.get('/list')
def list_songs(db: Session=Depends(get_db), auth_details = Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs

@router.post('/favorite', status_code=201)
def favorite_song(song: FavoriteSong, db: Session=Depends(get_db), auth_details = Depends(auth_middleware)):
    
    user_id = auth_details['uid']
    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id, Favorite.user_id == user_id).first()
    
    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message': False, 'fav_song': fav_song}
    else:
        new_favorite = Favorite(
            id = str(uuid.uuid4()),
            song_id = song.song_id,
            user_id = user_id
        )
        
        db.add(new_favorite)
        db.commit()
        db.refresh(new_favorite)
        return {'message': True, 'fav_song': new_favorite}
    
    
@router.get('/list/favorites')
def list_fav_songs(db: Session=Depends(get_db), auth_details = Depends(auth_middleware)):
    user_id = auth_details['uid']
    fav_songs = db.query(Favorite).filter(user_id == Favorite.user_id).options(joinedload(Favorite.song), joinedload(Favorite.user)).all()
    return fav_songs