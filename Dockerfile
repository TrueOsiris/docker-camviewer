# Use a Python 3 base image (Debian/Ubuntu base for apt packages)
FROM python:3.9-slim-buster

# Install Apache HTTP Server, mod_wsgi for Python3, and FFmpeg
RUN apt-get update && \
    apt-get install -y apache2 apache2-utils libapache2-mod-wsgi-py3 ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable the mod_wsgi module (and mod_env for PassEnv if not already enabled)
RUN a2enmod wsgi env

# Set up the application directory
WORKDIR /app
COPY app.py app.wsgi requirements.txt ./  
COPY static/ ./static/             # static folder for HLS segments (initially empty or with placeholder)
COPY templates/ ./templates/       # HTML template(s)
COPY apache_flask.conf /etc/apache2/sites-available/000-default.conf

# Install Python dependencies (Flask)
RUN pip install -r requirements.txt

# Expose port 80 for web service
EXPOSE 80

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Start the entrypoint script (which launches FFmpeg processes and Apache)
CMD ["/entrypoint.sh"]
