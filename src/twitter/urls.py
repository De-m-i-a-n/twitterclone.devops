from django.contrib import admin
from django.urls import path, include  # <-- Step 1: Add 'include' to the import
from tweets import views as tweets_views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', tweets_views.HomeView.as_view(), name='home'),

    # Step 2: Adding this line to include Django's default auth URLs
    # This will create URL patterns for '/accounts/login/', '/accounts/logout/', etc.
    path('accounts/', include('django.contrib.auth.urls')),
]

# Serve media files during development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
