from django.test import TestCase
from .models import Tweet
from django.contrib.auth.models import User

class TweetModelTest(TestCase):
    def setUp(self):
        """Set up a user for testing."""
        self.user = User.objects.create_user(username='testuser', password='password')

    def test_tweet_creation(self):
        """Test that a tweet can be created."""
        tweet = Tweet.objects.create(user=self.user, text="This is a test tweet.")
        self.assertEqual(tweet.text, "This is a test tweet.")
        self.assertEqual(tweet.user.username, 'testuser')
        
class TweetViewTest(TestCase):
    def setUp(self):
        """Set up a user and a tweet for testing."""
        self.user = User.objects.create_user(username='testuser', password='password')
        self.tweet = Tweet.objects.create(user=self.user, text="Another test tweet.")

    def test_homepage_view(self):
        """Test the homepage view."""
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)

    def test_tweet_detail_view(self):
        """Test the tweet detail view."""
        response = self.client.get(f'/tweet/{self.tweet.id}/')
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Another test tweet.")
