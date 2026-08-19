#!/bin/bash
# Install FFmpeg & curl
sudo apt-get update && sudo apt-get install -y ffmpeg curl

VID1=$1
VID2=$2
VID3=$3
AUDIO_URL=$4
OUTPUT_FILE="final_reel.mp4"

# Download Video Clips & Audio
curl -s -L "$VID1" -o vid1.mp4
curl -s -L "$VID2" -o vid2.mp4
curl -s -L "$VID3" -o vid3.mp4
curl -s -L "$AUDIO_URL" -o audio.mp3

# Merge 3 Motion Clips with Audio & Apply Seamless Crossfade
ffmpeg -y \
  -i vid1.mp4 \
  -i vid2.mp4 \
  -i vid3.mp4 \
  -i audio.mp3 \
  -filter_complex \
  "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1[v1]; \
   [1:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1[v2]; \
   [2:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1[v3]; \
   [v1][v2]xfade=transition=fade:duration=0.5:offset=4.5[f1]; \
   [f1][v3]xfade=transition=fade:duration=0.5:offset=8.5[vfinal]" \
  -map "[vfinal]" -map 3:a -c:v libx264 -preset fast -crf 22 -c:a aac -b:a 128k -shortest $OUTPUT_FILE
