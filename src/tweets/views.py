from django.shortcuts import render, redirect
from django.views import View
from .models import Tweet
from .forms import TweetForm
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic import ListView, DetailView # Add DetailView


class HomeView(View):  
    def get(self, request):
        tweets = Tweet.objects.all().order_by('-created_at')
        form = TweetForm() if request.user.is_authenticated else None
        return render(request, 'tweets/home.html', {'tweets': tweets, 'form': form, 'user': request.user})

    def post(self, request):
        if not request.user.is_authenticated:
            return redirect('login')
            
        tweets = Tweet.objects.all().order_by('-created_at') # You need tweets for the re-render
        form = TweetForm(request.POST, request.FILES)
        
        if form.is_valid():
            tweet = form.save(commit=False)
            tweet.user = request.user
            tweet.save()
            return redirect('home') # Redirect ONLY on success
        
        # If the form is NOT valid, render the page again with the errors
        return render(request, 'tweets/home.html', {'tweets': tweets, 'form': form, 'user': request.user})

class TweetDetailView(DetailView):
    model = Tweet
    template_name = 'tweet_detail.html'
    context_object_name = 'tweet' 
