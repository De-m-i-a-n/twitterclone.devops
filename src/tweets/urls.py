from django.urls import path
from .views import HomeView, TweetDetailView

urlpatterns = [
    path('', HomeView.as_view(), name='home'),
    path('tweet/<int:pk>/', TweetDetailView.as_view(), name='tweet_detail'),
]

