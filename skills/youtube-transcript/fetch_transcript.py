#!/usr/bin/env python3
"""Fetch a YouTube video transcript and emit Markdown.

Usage:
    python fetch_transcript.py VIDEO_ID [LANG_CODE]

Defaults LANG_CODE to "en". Falls back to any language available if requested
language is missing (uses the YouTubeTranscriptApi `languages` priority list).
"""

from __future__ import annotations
import sys
from youtube_transcript_api import YouTubeTranscriptApi


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2

    video_id = sys.argv[1].strip()
    lang = sys.argv[2].strip() if len(sys.argv) > 2 else "en"

    api = YouTubeTranscriptApi()
    try:
        fetched = api.fetch(video_id, languages=[lang, "en"])
    except Exception as e:
        print(f"# transcript fetch failed: {type(e).__name__}: {e}", file=sys.stderr)
        return 1

    print(f"# Transcript -- video {video_id}")
    print(f"")
    print(f"language: {lang}")
    print(f"")
    for snippet in fetched:
        ts = f"{int(snippet.start // 60)}:{int(snippet.start % 60):02d}"
        print(f"- [{ts}] {snippet.text}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
