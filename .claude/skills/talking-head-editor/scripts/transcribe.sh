#!/usr/bin/env bash
# Transcribe audio to SRT with whisper.cpp.
#
# Supersedes the vault's old run-whisper.sh / rerun-hindi.sh, which broke when
# the vault was restructured (they assumed ./_transcripts next to themselves).
#
# The --hinglish flags are not cosmetic. On this project's code-mixed Hindi-
# English sources, the default pass produced 30-second monolith cues, repetition
# loops, and language drift. Re-running with these four flags recovered ~12% more
# speech and lifted one file's timeline coverage from 80% to 86%.
#
#   transcribe.sh <audio-or-dir> [outdir] [--hinglish]
set -uo pipefail

die(){ printf 'error: %s\n' "$1" >&2; exit 1; }
[ $# -ge 1 ] || die "usage: transcribe.sh <audio-or-dir> [outdir] [--hinglish]"

SRC="$1"; shift
OUT=""; HINGLISH=0
for a in "$@"; do
  case "$a" in
    --hinglish) HINGLISH=1 ;;
    *) OUT="$a" ;;
  esac
done
[ -e "$SRC" ] || die "no such path: $SRC"
[ -n "$OUT" ] || OUT="$([ -d "$SRC" ] && echo "$SRC" || dirname "$SRC")"
mkdir -p "$OUT"

W="$(command -v whisper-cli || command -v whisper-cpp || command -v main || true)"
[ -n "$W" ] || die "whisper binary not found (whisper-cli / whisper-cpp / main). brew install whisper-cpp"
MODEL="${WHISPER_MODEL:-$HOME/.whisper-models/ggml-large-v3-turbo.bin}"
[ -f "$MODEL" ] || die "model missing: $MODEL  (set WHISPER_MODEL to override)"

echo ">> whisper : $W"
echo ">> model   : $MODEL"
echo ">> mode    : $([ $HINGLISH -eq 1 ] && echo 'hinglish (forced hi, anti-drift)' || echo 'auto-detect')"

# whisper.cpp needs 16kHz mono PCM. Convert anything else first.
prepare() {
  local in="$1" tmp
  local rate ch codec
  read -r rate ch codec < <(ffprobe -v error -select_streams a:0 \
    -show_entries stream=sample_rate,channels,codec_name -of default=nw=1:nk=1 "$in" 2>/dev/null | paste -sd' ')
  if [ "${rate:-0}" = "16000" ] && [ "${ch:-0}" = "1" ] && [ "${codec:-}" = "pcm_s16le" ]; then
    printf '%s' "$in"; return
  fi
  tmp="${TMPDIR:-/tmp}/wh-$(basename "${in%.*}")-16k.wav"
  ffmpeg -hide_banner -loglevel error -y -i "$in" -vn -ac 1 -ar 16000 -c:a pcm_s16le "$tmp" >&2 \
    || { echo "!! could not convert $in" >&2; return 1; }
  printf '%s' "$tmp"
}

shopt -s nullglob
if [ -d "$SRC" ]; then
  FILES=( "$SRC"/*.wav "$SRC"/*.mp3 "$SRC"/*.m4a "$SRC"/*.mp4 "$SRC"/*.mov )
else
  FILES=( "$SRC" )
fi
[ ${#FILES[@]} -gt 0 ] || die "no audio found in $SRC"
echo ">> ${#FILES[@]} file(s)"

for f in "${FILES[@]}"; do
  name="$(basename "${f%.*}")"
  suffix="$([ $HINGLISH -eq 1 ] && echo '.hi' || echo '')"
  target="$OUT/$name$suffix"
  [ -f "$target.srt" ] && { echo ">> skip (exists): $name$suffix.srt"; continue; }

  echo; echo "=== $name"
  wav="$(prepare "$f")" || continue

  if [ $HINGLISH -eq 1 ]; then
    # -l hi  force the language; auto-detect drifts mid-file on code-mixed speech
    # -mc 0  no cross-segment text context; this is what kills repetition loops
    # -bs 5  beam search over greedy; measurably better on code-mixed audio
    # -ml 140 cap segment length; without it you get 30-second monolith cues
    "$W" -m "$MODEL" -f "$wav" -l hi -mc 0 -bs 5 -ml 140 -osrt -of "$target"
  else
    "$W" -m "$MODEL" -f "$wav" -l auto -ml 140 -osrt -of "$target"
  fi

  [ "$wav" != "$f" ] && rm -f "$wav"

  if [ -f "$target.srt" ]; then
    echo ">> OK  $name$suffix.srt  cues=$(grep -cE '^[0-9]+$' "$target.srt")"
  else
    echo "!! FAILED on $name"
  fi
done

echo
echo ">> NOTE: these are CUE-level timings, not word-level. Caption modes and"
echo ">> emphasis placement need word timings — force-align before the subtitle"
echo ">> pass. See references/subtitle-spec.md."
