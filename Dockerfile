# Use a Python 3 base image (Debian/Ubuntu base for apt packages)
FROM python:3.9-slim-buster

# Install Apache HTTP Server, mod_wsgi for Python3, and FFmpeg
RUN apt-get update && \
    apt-get install -y apache2 apache2-utils libapache2-mod-wsgi-py3 ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable required Apache modules
RUN a2enmod wsgi env

# Set working directory
WORKDIR /app

# Copy application files from app/
COPY app/app.py app/app.wsgi app/requirements.txt ./
COPY app/templates ./templates
COPY app/static ./static
COPY app/apache-flask.conf /etc/apache2/sites-available/000-default.conf

# Install Python requirements
RUN pip install -r requirements.txt

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the web port
EXPOSE 80

# Start script
CMD ["/entrypoint.sh"]
