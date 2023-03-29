#!/bin/bash

# Set default output file name
output_file="outputWithAudio.mp4"

# Function to display help message
function display_help {
    echo "Usage: add_silent_audio.sh -i input_file [-o output_file]"
    echo ""
    echo "Options:"
    echo "-i input_file     Input file path."
    echo "-o output_file    Output file path. Default: outputWithAudio.mp4"
    echo "-h                Display this help message."
}

# Parse command-line arguments
while getopts "hi:o:" opt; do
  case $opt in
    i)
      input_file=$OPTARG
      ;;
    o)
      output_file=$OPTARG
      ;;
    h)
      display_help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check if input file is set
if [ -z "$input_file" ]; then
  echo "Please specify an input file using the -i option."
  exit 1
fi

# Get input file duration
duration=$(ffmpeg -i "$input_file" -hide_banner 2>&1 | grep Duration | awk '{print $2}' | tr -d ,)

# Combine video and audio files
ffmpeg -i "$input_file" -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -t "$duration" -shortest -c:v copy -c:a aac "$output_file"

# Print success message
echo "Successfully added silent audio to $input_file and saved as $output_file!"

