# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Update package lists and install netcat for the wait script
RUN apt-get update && apt-get install -y netcat-openbsd

# Set work directory
WORKDIR /app

# Install Gunicorn and other dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy your project source code
# This assumes your Django project is in a local directory named 'src'
COPY ./src /app/

# EXPOSE port 8000 to tell Docker the container listens on this port
EXPOSE 8000

# The command to run the application
# IMPORTANT: Replace 'twitter.wsgi' if your Django project folder has a different name
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "twitter.wsgi:application"]
