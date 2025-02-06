# scan/urls.py

from django.urls import path
from . import views
from django.urls import re_path

app_name = 'scan'

urlpatterns = [
    path('', views.index, name='index'),
    path('new/', views.scan_url, name='scan_url'),
    path('<int:scan_id>/', views.scan_detail, name='scan_detail'),
    path('extract_exif/', views.extract_exif, name='extract_exif'),   
    
]

