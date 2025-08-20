from django.test import TestCase
    from django.contrib.auth.models import User
    from .models import Tweet

    class TweetModelTest(TestCase):

        def setUp(self):
            self.user = User.objects.create_user(username='testuser', password='password')

        def test_create_text_tweet(self):
            tweet = Tweet.objects.create(user=self.user, text='This is a test tweet.')
            self.assertEqual(tweet.user.username, 'testuser')
            self.assertEqual(tweet.text, 'This is a test tweet.')
            self.assertIsNone(tweet.image.name)

    class HomeViewTest(TestCase):

        def setUp(self):
            self.user = User.objects.create_user(username='testuser', password='password')
            self.client.login(username='testuser', password='password')

        def test_home_view_get(self):
            response = self.client.get('/')
            self.assertEqual(response.status_code, 200)
            self.assertTemplateUsed(response, 'tweets/home.html')

        def test_create_tweet_post(self):
            response = self.client.post('/', {'text': 'A new tweet from a test.'})
            self.assertEqual(response.status_code, 302) # Should redirect
            self.assertTrue(Tweet.objects.filter(text='A new tweet from a test.').exists())
