import os
from genequery.utils import here

ALLOWED_HOSTS = ['*']

BASE_DIR = '/genequery/genequery-web/'


DEBUG = True

STATIC_ROOT = here(BASE_DIR, '..', 'static')
STATIC_URL = '/genequery/static/'
STATICFILES_DIRS = (
    here(BASE_DIR, 'static'),
)

MEDIA_ROOT = BASE_DIR + '/media/'
MEDIA_URL  = '/media/'

MEDIA_ARE_LOCAL = False


# Supposed to be used for Bonferroni adjustment
# MUST BE UPDATED ALONG WITH DB VARIABLES
MODULES_COUNT = {
    'hs': 117497,
    'mm': 82371,
    'rt': 13560,
}
BONFERRONI_ADJ_LOG_P_VALUE = {
    'hs': 5.070026778096448,
    'mm': 4.915774338435374,
    'rt': 4.132259689531044,
}


# Database
DATABASES = {}


# REST
REST_HOST = 'localhost'
REST_PORT = '51377'
REST_URI = 'gqrest/fisher/search_sorted'

NEW_REST_HOST = 'localhost'
NEW_REST_PORT = '8423'

LOG_DIR = BASE_DIR
