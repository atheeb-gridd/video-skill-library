#!/bin/bash
# Re-transcribe the two problem files with Hindi forced + anti-drift settings.
set -u
cd "$(dirname "$0")" || exit 1
OUT="$(pwd)/_transcripts"
exec > >(tee "$OUT/rerun.log") 2>&1

MODEL="$HOME/.whisper-models/ggml-large-v3-turbo.bin"
W="$(command -v whisper-cli || command -v whisper-cpp || command -v main)"
[ -z "${W:-}" ] && { echo "!! whisper not found"; exit 1; }
echo "run started: $(date)"
echo ">> whisper: $W"

# -l hi   : force Hindi instead of letting it drift
# -mc 0   : no cross-segment text context -> kills the repetition loops
# -bs 5   : beam search instead of greedy, better on code-mixed speech
# -ml 140 : cap segment length so we stop getting 30-second monoliths
for name in MOTION__editing_kt_3 SFX__sfx_kt_1; do
  w="$OUT/$name.wav"
  [ -f "$w" ] || { echo "!! missing $w"; continue; }
  echo ""
  echo "=== $name"
  "$W" -m "$MODEL" -f "$w" -l hi -mc 0 -bs 5 -ml 140 \
       -osrt -of "$OUT/$name.v2"
  echo ">> exit=$?"
  if [ -f "$OUT/$name.v2.srt" ]; then
    echo ">> OK  cues=$(grep -cE '^[0-9]+$' "$OUT/$name.v2.srt")"
  else
    echo "!! failed"
  fi
done

echo ""
echo "finished: $(date)"
ls -lh "$OUT"/*.v2.srt 2>/dev/null
