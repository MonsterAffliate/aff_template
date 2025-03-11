from .base import *

ALLOWED_HOSTS = ['yourdomain.com']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('DB_NAME', '{{ project_name }}'),
        'USER': os.getenv('DB_USER', '{{ project_name }}'),
        'PASSWORD': os.getenv('DB_PASSWORD'),
        'HOST': 'postgres',
        'PORT': '5432',
    }
}