# Use the official Python image from the Docker Hub
FROM python:3.13

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /workspace/{{ project_name}}

# Copy project
COPY . /workspace/{{ project_name }}/
RUN pip install -r requirements/prod.txt

# Expose port 80
EXPOSE 8000

# Start Gunicorn, Nginx, and Memcached
CMD ["sh", "-c", "gunicorn web_django.wsgi:application --bind 0.0.0.0:8000"]