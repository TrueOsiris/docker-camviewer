# app.py
import os
from flask import Flask, render_template

app = Flask(__name__)

# Collect stream configurations from environment variables
streams = []
for i in range(1, 10):
    url = os.environ.get(f"STREAM{i}")
    if url:
        streams.append({
            "id": i,
            "url": url,
            "playlist": f"stream{i}/playlist.m3u8"  # relative path under static/
        })

@app.route('/')
def index():
    # Render the main page with all active streams
    return render_template('index.html', streams=streams)
