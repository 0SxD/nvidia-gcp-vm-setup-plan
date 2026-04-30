# 05 -- YouTube Transcript Skill (taught self via open-source repo)

Sage's directive: "if you don't have that skill teach it to yourself via a well-documented opensource github repo and save it."

Done. The skill lives at `skills/youtube-transcript/`. It uses two open-source libraries:

1. **youtube-transcript-api** -- https://github.com/jdepoix/youtube-transcript-api -- MIT license, v1.2.4 (2026-01-29)
2. **yt-dlp** -- https://github.com/yt-dlp/yt-dlp -- The Unlicense, version 2026.03.17

Both work without API keys, work for auto-generated subtitles, and do not require a headless browser.

## Why two libraries

- **`youtube-transcript-api`** is the simpler / faster path when all you need is the spoken text with timestamps. Pure Python, no external binary.
- **`yt-dlp`** is more flexible. Gives you full subtitle file (.vtt or .srt), can handle videos that block the simple API, and also downloads video / audio if needed.

Use `youtube-transcript-api` first; fall back to `yt-dlp` if the simple API fails (rate limit, geofence, etc.).

## Install

The skill ships its own uv venv at `skills/youtube-transcript/.venv` so it does not pollute the global Python.

```bash
cd skills/youtube-transcript
uv venv .venv
uv pip install --python .venv/Scripts/python.exe youtube-transcript-api yt-dlp
```

Verified working 2026-04-30 -- 128-segment transcript fetched successfully on smoke test.

## Quickstart -- python youtube-transcript-api

```python
from youtube_transcript_api import YouTubeTranscriptApi

api = YouTubeTranscriptApi()
fetched = api.fetch("VIDEO_ID")          # YouTube video ID, e.g. "0eKVizvYSUQ"
for snippet in fetched:
    print(f"[{snippet.start:.1f}s] {snippet.text}")
```

Language fallback (priority order):

```python
fetched = api.fetch("VIDEO_ID", languages=["en", "de", "fr"])
```

## Quickstart -- yt-dlp (full .vtt subtitle file)

```bash
.venv/Scripts/yt-dlp \
  --write-auto-subs --skip-download \
  --sub-langs en --sub-format vtt \
  -o "%(id)s.%(ext)s" \
  "https://www.youtube.com/watch?v=VIDEO_ID"
```

Replace `--write-auto-subs` with `--write-subs` if you only want human-uploaded subtitles.

## End-to-end script: fetch + save as Markdown

A ready-to-run script is at `skills/youtube-transcript/fetch_transcript.py`. Usage:

```bash
.venv/Scripts/python.exe fetch_transcript.py VIDEO_ID > transcript.md
```

It produces a Markdown file with timestamp + line for each segment, suitable for direct ingest into NotebookLM or Obsidian.

## When to use which

| Need | Use |
|---|---|
| Just need the text with timestamps | `youtube-transcript-api` |
| Need a .vtt or .srt file for downstream tools | `yt-dlp` |
| Video blocked by simple API (rate limit / geofence) | `yt-dlp` |
| Need video / audio file too | `yt-dlp` |
| Need batch processing (10+ videos) | `youtube-transcript-api` (faster per call) |

## Citations

- [jdepoix/youtube-transcript-api on GitHub](https://github.com/jdepoix/youtube-transcript-api) -- MIT, v1.2.4
- [youtube-transcript-api on PyPI](https://pypi.org/project/youtube-transcript-api/)
- [yt-dlp/yt-dlp on GitHub](https://github.com/yt-dlp/yt-dlp) -- The Unlicense

## Skill artifact

`skills/youtube-transcript/SKILL.md` follows the Anthropic Skills format (frontmatter `name`, `description`) so it can be loaded by Claude Code via the Skill tool when relevant. The skill is project-scoped under `nvidia-gcp-vm-setup-plan` for now. Sage can promote it to global skills if it proves useful elsewhere.

## Update channel

- youtube-transcript-api: watch https://github.com/jdepoix/youtube-transcript-api/releases
- yt-dlp: nightly releases at https://github.com/yt-dlp/yt-dlp/releases (watch for YouTube site changes)

Cadence: monthly check; YouTube changes their internals frequently and yt-dlp ships fixes within hours.
