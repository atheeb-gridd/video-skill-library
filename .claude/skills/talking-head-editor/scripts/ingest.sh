#!/usr/bin/env bash
# Stage B — ingest a talking-head project.
# Probes footage, extracts audio if absent, and reports what is missing.
# Reads fps PER FILE and never assumes it: measuring a 60fps source as 30fps
# halves every duration you observe. See references/timebase.md.
set -uo pipefail

die(){ printf 'error: %s\n' "$1" >&2; exit 1; }
[ $# -ge 1 ] || die "usage: ingest.sh <project-dir> [source-video]"

PROJ="${1%/}"; SRC="${2:-}"
[ -d "$PROJ" ] || die "no such project dir: $PROJ"
command -v ffprobe >/dev/null || die "ffprobe not found"
mkdir -p "$PROJ/design" "$PROJ/footage" "$PROJ/audio"

# Locate the source if not given.
if [ -z "$SRC" ]; then
  SRC=$(find "$PROJ/footage" -maxdepth 1 -type f \
        \( -iname '*.mp4' -o -iname '*.mov' -o -iname '*.mkv' -o -iname '*.m4v' \) \
        | sort | head -1)
  [ -n "$SRC" ] || die "no video found in $PROJ/footage — pass one explicitly"
fi
[ -f "$SRC" ] || die "no such file: $SRC"

echo "=== source ==="
printf '  %s\n' "$SRC"

# --- probe -------------------------------------------------------------
read -r W H RFR NBF < <(ffprobe -v error -select_streams v:0 \
  -show_entries stream=width,height,r_frame_rate,nb_frames \
  -of default=nw=1:nk=1 "$SRC" | paste -sd' ')
DUR=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$SRC")
FPS=$(awk -v r="$RFR" 'BEGIN{split(r,a,"/"); printf "%.6f", a[1]/(a[2]?a[2]:1)}')
ACH=$(ffprobe -v error -select_streams a:0 -show_entries stream=channels,sample_rate,codec_name \
      -of default=nw=1:nk=1 "$SRC" 2>/dev/null | paste -sd'/' ) || true

printf '  %sx%s  fps=%s (%s)  dur=%ss  frames=%s\n' "$W" "$H" "$FPS" "$RFR" "$DUR" "$NBF"
[ -n "$ACH" ] && printf '  audio: %s\n' "$ACH" || printf '  audio: NONE IN CONTAINER\n'

case "$W:$H" in
  1080:1920) echo "  ✓ 9:16 vertical, delivery-native" ;;
  *) awk -v w="$W" -v h="$H" 'BEGIN{ if (h>w) print "  ~ vertical but not 1080x1920 — confirm the delivery spec";
                                     else print "  ! LANDSCAPE source for a vertical deliverable — reframing is a design decision, not a default" }' ;;
esac
awk -v f="$FPS" 'BEGIN{ if (f<29 || f>31) printf "  ! fps is %.3f, NOT ~30 — every frame count in the design docs must be stated at this rate\n", f }'

# --- audio -------------------------------------------------------------
WAV="$PROJ/audio/dialogue.wav"
if [ -n "$ACH" ]; then
  if [ -f "$WAV" ]; then
    echo "=== audio ===";  echo "  ✓ already extracted: $WAV"
  else
    echo "=== audio ==="
    ffmpeg -hide_banner -loglevel error -y -i "$SRC" -vn -ac 1 -ar 16000 -c:a pcm_s16le "$WAV" \
      && echo "  ✓ extracted 16k mono for alignment: $WAV"
    ffmpeg -hide_banner -loglevel error -y -i "$SRC" -vn -ac 2 -ar 48000 -c:a pcm_s24le "$PROJ/audio/dialogue-48k.wav" \
      && echo "  ✓ extracted 48k stereo for the mix: $PROJ/audio/dialogue-48k.wav"
  fi
  echo "  loudness of source dialogue:"
  ffmpeg -hide_banner -nostats -i "$SRC" -map a:0 -af ebur128=peak=true -f null - 2>&1 \
    | awk '/^\[Parsed_ebur128/,0' | tail -12 | sed -n 's/^/    /p' | tail -6
else
  echo "  ! no audio stream — a separate audio file is required"
fi

# --- transcript --------------------------------------------------------
echo "=== transcript ==="
TR=$(find "$PROJ" -maxdepth 2 -type f \( -iname '*.srt' -o -iname '*.vtt' -o -iname '*transcript*' \) | head -3)
if [ -n "$TR" ]; then printf '  found:\n'; printf '    %s\n' $TR
  echo "  → check for WORD-LEVEL timings. Phrase-level is not enough for caption"
  echo "    modes or emphasis placement; force-align if only phrase timings exist."
else
  echo "  ! none found — generate one, then force-align for word-level timings"
fi

# --- silence (the subtractive first pass) ------------------------------
if [ -n "$ACH" ]; then
  echo "=== dead air (candidates for the subtractive pass) ==="
  echo "  NOTE: silencedetect logs at info level. Do NOT use -v error here or this"
  echo "  returns nothing with no error at all."
  ffmpeg -hide_banner -nostats -i "$SRC" -map a:0 \
    -af silencedetect=noise=-32dB:d=0.30,ametadata=print:key=lavfi.silence_duration:file=- \
    -f null - 2>/dev/null \
    | awk -F= '/silence_duration/{n++; s+=$2} END{ if(n) printf "  %d pauses >0.30s, %.2fs total (%.0f%% of runtime)\n", n, s, 100*s/'"$DUR"'; else print "  none over 0.30s" }'
fi

echo
echo "=== next ==="
echo "  1. Write $PROJ/design/design-cuts.md from _templates/design-cuts.md"
echo "     Record KEPT SOURCE RANGES, not just cut points — the timebase map"
echo "     cannot be built from cut points alone. See references/timebase.md."
echo "  2. Lock cuts, build the timebase map, re-stamp the transcript to OUTPUT time."
echo "  3. Then motion → sound → subtitles. Then the approval gate."
