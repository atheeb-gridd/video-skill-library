#!/bin/bash
# Transcribe the pre-extracted WAVs in _transcripts/ . No ffmpeg needed.
set -u
cd "$(dirname "$0")" || exit 1
OUT="$(pwd)/_transcripts"
exec > >(tee "$OUT/whisper.log") 2>&1

echo "run started: $(date)"
MODEL="$HOME/.whisper-models/ggml-large-v3-turbo.bin"
W="$(command -v whisper-cli || command -v whisper-cpp || command -v main)"
[ -z "${W:-}" ] && { echo "!! whisper binary not found"; exit 1; }
echo ">> whisper: $W"
echo ">> model  : $MODEL"
[ -f "$MODEL" ] || { echo "!! model missing"; exit 1; }

shopt -s nullglob
WAVS=( "$OUT"/*.wav )
echo ">> ${#WAVS[@]} wav file(s) to process"
[ ${#WAVS[@]} -eq 0 ] && { echo "!! no wavs found in $OUT"; exit 1; }

for w in "${WAVS[@]}"; do
  stem="${w%.wav}"
  name="$(basename "$stem")"
  [ -f "$stem.srt" ] && { echo ">> skip (done): $name"; continue; }

  echo ""
  echo "=== $name  ($(du -h "$w" | cut -f1))"
  "$W" -m "$MODEL" -f "$w" -l auto -osrt -of "$stem"
  rc=$?
  echo ">> exit=$rc"

  # fall back to long-form flags if this build doesn't like the short ones
  if [ ! -f "$stem.srt" ]; then
    echo ">> retrying with long-form flags..."
    "$W" --model "$MODEL" --file "$w" --language auto \
         --output-srt --output-file "$stem"
    echo ">> retry exit=$?"
  fi

  if [ -f "$stem.srt" ]; then
    echo ">> OK -> $name.srt  ($(wc -l < "$stem.srt") lines)"
  else
    echo "!! FAILED on $name"
  fi
done

echo ""
echo "finished: $(date)"
ls -lh "$OUT"/*.srt 2>/dev/null || echo "(no srt files produced)"
