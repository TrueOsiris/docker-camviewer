#!/bin/bash
# entrypoint.sh

# Loop through possible stream env vars 1-9 and start FFmpeg for each
for i in $(seq 1 9); do
  var="STREAM${i}"
  url="${!var}"            # indirect expansion to get value of $STREAMi
  if [ -n "$url" ]; then
    echo "Starting HLS stream $i from RTSP source: $url"
    # Create directory for HLS files for this stream
    mkdir -p "/app/static/stream${i}"
    # Launch FFmpeg to produce HLS (playlist.m3u8 and segment .ts files)
    ffmpeg -i "$url" -c:v copy -c:a copy \
           -f hls -hls_time 2 -hls_list_size 5 -hls_flags delete_segments \
           -hls_segment_filename "/app/static/stream${i}/segment%03d.ts" \
           "/app/static/stream${i}/playlist.m3u8" >/dev/null 2>&1 &
    # Note: -c:v copy copies the video stream without re-encoding (if compatible)&#8203;:contentReference[oaicite:15]{index=15}
  fi
done

# After launching all streams, start Apache in the foreground
apache2ctl -D FOREGROUND
