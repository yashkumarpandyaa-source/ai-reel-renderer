#!/bin/bash
IMG1=$1
IMG2=$2
IMG3=$3
AUDIO_URL=$4
OUTPUT_FILE="final_reel.mp4"

# Fast Download
curl -s -L "$IMG1" -o img1.jpg
curl -s -L "$IMG2" -o img2.jpg
curl -s -L "$IMG3" -o img3.jpg
curl -s -L "$AUDIO_URL" -o audio.mp3

# Render Video with Pan-Zoom Motion
ffmpeg -y \
  -loop 1 -t 5 -i img1.jpg \
  -loop 1 -t 5 -i img2.jpg \
  -loop 1 -t 5 -i img3.jpg \
  -i audio.mp3 \
  -filter_complex \
  "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,zoompan=z='min(zoom+0.0015,1.12)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=125:s=1080x1920[v1]; \
   [1:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,zoompan=z='min(zoom+0.0015,1.12)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=125:s=1080x1920[v2]; \
   [2:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,zoompan=z='min(zoom+0.0015,1.12)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=125:s=1080x1920[v3]; \
   [v1][v2]xfade=transition=fade:duration=0.5:offset=4.5[f1]; \
   [f1][v3]xfade=transition=fade:duration=0.5:offset=8.5[vfinal]" \
  -map "[vfinal]" -map 3:a -c:v libx264 -preset ultrafast -crf 23 -c:a aac -b:a 128k -shortest $OUTPUT_FILE
