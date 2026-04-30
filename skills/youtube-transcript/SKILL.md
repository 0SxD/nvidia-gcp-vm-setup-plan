---
name: youtube-transcript
description: Fetch YouTube video transcripts (auto-generated or manual subtitles) without API keys, using the open-source youtube-transcript-api Python library, with yt-dlp as a fallback for blocked videos. Use when the user asks for a transcript / captions / subtitles of a YouTube video, or when summarizing / quoting a video.
---

# Skill: youtube-transcript

## When to invoke

User mentions:
- "get the transcript of this YouTube video"
- "summarize this YouTube link"
- "what does the speaker say at <timestamp>"
- pastes a `youtube.com/watch?v=...` or `youtu.be/...` URL and asks anything that requires reading what was said

## How to invoke

The skill ships a uv venv at `.venv/`. Run:

```bash
cd <plan-root>/skills/youtube-transcript
.venv/Scripts/python.exe fetch_transcript.py VIDEO_ID
```

Or call from another script:

```python
import sys
sys.path.insert(0, "<plan-root>/skills/youtube-transcript/.venv/Lib/site-packages")
from youtube_transcript_api import YouTubeTranscriptApi
api = YouTubeTranscriptApi()
fetched = api.fetch(video_id, languages=["en"])
for s in fetched:
    print(f"[{s.start:.1f}s] {s.text}")
```

## Fallback to yt-dlp

If `youtube-transcript-api` fails (geofence, rate limit, etc.):

```bash
.venv/Scripts/yt-dlp \
  --write-auto-subs --skip-download \
  --sub-langs en --sub-format vtt \
  -o "%(id)s.%(ext)s" \
  "https://www.youtube.com/watch?v=VIDEO_ID"
```

## Returns

- youtube-transcript-api: list of `FetchedTranscriptSnippet` objects with `.text`, `.start`, `.duration`
- yt-dlp: a `.vtt` file in current directory named after the video ID

## Constraints

- Some videos disable transcripts entirely; both tools will fail. Tell user.
- Auto-generated transcripts are imperfect; flag as "auto-generated" if `is_generated=True` on the transcript object.
- Region-blocked videos may return 403; route through yt-dlp with `--proxy` if needed.

## Citations

- youtube-transcript-api: https://github.com/jdepoix/youtube-transcript-api (MIT)
- yt-dlp: https://github.com/yt-dlp/yt-dlp (Unlicense)

## Verified

Smoke-tested 2026-04-30 against video ID `0eKVizvYSUQ`. Returned 128 segments. Skill works.
