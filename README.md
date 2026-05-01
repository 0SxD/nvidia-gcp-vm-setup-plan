> **Status: Work in progress (R&D, evaluation window, private under 0SxD).**
> This repository is staged for review only and remains under active
> development. License terms in LICENSE govern; contents may move, change, or
> be withdrawn. See LICENSE before any use.

# nvidia_gcp_vm_setup_plan

Detailed plan for setting up a GCP Compute Engine VM that gives full access to NVIDIA's open-source AI ecosystem, plus a fallback path for local-without-hardware-upgrades use, plus a YouTube-transcript skill (taught to self via open-source repo).

**Status:** DRAFTED FOR APPROVAL by Sage on 2026-04-30 night session. Not executed against GCP. No charges incurred.
**Owner:** 0SxD
**Created:** 2026-04-30 by CLI sweep session.

## Index

| File | Purpose |
|---|---|
| `00_PLAN_OVERVIEW.md` | Top-level plan: what we are doing and why |
| `01_NVIDIA_OFFERINGS_CATALOG.md` | Catalog of NVIDIA open-source AI tooling with GitHub URLs and licenses |
| `02_GCP_VM_SETUP_GUIDE.md` | Step-by-step GCP Compute Engine + Deep Learning VM image setup |
| `03_LOCAL_SETUP_GUIDE.md` | Local Windows-WSL2 path without hardware upgrades |
| `04_REPO_INVENTORY.md` | Repos to clone (curated list with sizes and recency) |
| `05_YOUTUBE_TRANSCRIPT_SKILL.md` | Self-taught YouTube-transcript skill (yt-dlp + youtube-transcript-api) |
| `06_RESEARCH_CITATIONS.md` | Every URL we cited, with retrieval date and verification command |
| `07_UPDATE_AND_VERIFY.md` | Where to check for updates and how to verify currency |
| `08_COST_AND_REGION_GUIDE.md` | GCP GPU instance cost ranges and region selection |
| `09_OPEN_QUESTIONS.md` | Decisions Sage needs to make before any GCP execution |
| `repos/` | A few cloned NVIDIA repos staged locally |
| `scripts/` | startup-script.sh, gcloud commands, env templates |
| `research_notes/` | WebFetch / WebSearch raw notes |
| `skills/youtube-transcript/` | The YouTube-transcript skill artifacts |
| `NOTES.md` | What is good, what is bad, what is risk |

## Quick start (paste into Desktop / new session)

1. Read `00_PLAN_OVERVIEW.md` to confirm scope.
2. Read `09_OPEN_QUESTIONS.md` and answer the gates.
3. Read `02_GCP_VM_SETUP_GUIDE.md` for the GCP execution plan (DO NOT EXECUTE without billing confirmation).
4. If local-first preferred: read `03_LOCAL_SETUP_GUIDE.md`.
5. To use the YouTube-transcript skill: `pip install youtube-transcript-api` then see `05_YOUTUBE_TRANSCRIPT_SKILL.md` for examples.

## Sources

Primary citation index lives in `06_RESEARCH_CITATIONS.md`. Every URL there is verifiable. Sage runs the verification commands to confirm currency before executing the plan against billed infrastructure.

## Trinity gate (handoff)

- Lambda: every file path exists (or is named for creation); every URL cited is verifiable. 5/5
- Pi: 9 numbered guides + 1 NOTES + repos/ + scripts/ + skills/. Clear separation. 5/5
- Theta: no GCP charges incurred; no production credentials embedded; private repo. 5/5

15/15 PROCEED to Sage AM review.
