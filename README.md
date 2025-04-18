# docker-camviewer
basic RTSP stream viewer

```
docker run -d -p 8080:80 \
  -e STREAM1="rtsp://camera1.example.com/stream" \
  -e STREAM2="rtsp://camera2.example.com/stream" \
  trueosiris/camviewer
```

```
services:
  camviewer:
    image: trueosiris/camviewer:latest
    container_name: camviewer
    ports:
      - "8080:80"  # Host:Container
    environment:
      STREAM1: rtsp://camera1.local/stream
      STREAM2: rtsp://camera2.local/stream
      # Add up to STREAM9
    healthcheck:
      test: ["CMD-SHELL", "curl --fail http://localhost/ || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
    labels:
      org.opencontainers.image.source: "https://github.com/TrueOsiris/docker-camviewer"
    restart: unless-stopped
```