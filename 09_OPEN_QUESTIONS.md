# 09 -- Open Questions

Questions Sage answers BEFORE running anything that costs money.

## A -- Billing & Project

A1. What GCP project ID will host this work? (e.g. `sagex-ai-research-2026`)
A2. Is billing enabled on that project?
A3. Monthly budget cap (USD)? Recommended: start at $200 with budget alert at $100 and $180.
A4. Who is the billing contact?

## B -- Quota & Region

B1. Primary region? Default recommendation: `us-central1`.
B2. Initial GPU count by type to request:
- L4: ___ (recommended start: 1)
- A100-40GB: ___ (recommended start: 0; request when fine-tuning)
- H100-80GB: ___ (recommended start: 0; request when training)
B3. OK with spot/preemptible for non-production workloads? (default YES)

## C -- NGC Account

C1. NGC account email (free): default <contact>?
C2. NGC API key generated and stored in a password manager? (yes/no)
C3. Confirm NGC account "Services Included" includes "NGC Catalog" + "NIM" when generating the key.

## D -- Use case priority

D1. Primary first use case (rank 1-5):
- [ ] Inference of an open-weight LLM via NIM (L4, cheapest)
- [ ] RAG pipeline development (Track B local + L4 NIM)
- [ ] Fine-tune a 7B-13B model with LoRA (Track A A100)
- [ ] Train a foundation model (Track A H100)
- [ ] Robotics simulation (Isaac Sim, Track A)
- [ ] Speech / audio (Riva, Track A)
- [ ] Recommender training (Merlin, Track A)
- [ ] Data science (RAPIDS cuDF/cuML, Track A or local)

D2. Want to start with Track B (free / hosted) before any GPU spend? (default YES)

## E -- Local Track B preferences

E1. Install NVIDIA AI Workbench Desktop on Windows? (yes / skip)
E2. Use Docker Desktop or native podman in WSL2? (default Docker Desktop)
E3. NGC API key for local docker login -- same as cloud key? (default yes)

## F -- Operational

F1. Who has GCP IAM owner on this project?
F2. Any compliance constraints (HIPAA, FedRAMP, etc.) that change region or instance choice? (default no)
F3. Backup snapshot cadence for the GPU VM disk? (default: weekly during active work, off during idle)
F4. Tear-down trigger: stop or delete after how many hours of no activity? (default: stop after 4 hours idle)

## G -- Ongoing maintenance

G1. Who runs the monthly version-audit script (`scripts/audit-gpu-stack.sh`)?
G2. Where does the audit log go (private GitHub repo? Drive? local?)?
G3. Subscribe to NVIDIA security advisories at https://www.nvidia.com/en-us/security/? (default yes)

---

## Default decisions if Sage does not answer by execution time

To avoid blocking forever:

- A1: prompt-engineer-anthropic-os (placeholder; create new GCP project with this name)
- A3: $200 monthly cap with 50%/90% alerts
- B1: `us-central1`
- B2: 1 × L4
- B3: YES spot for dev
- C1: <contact>
- D1: rank 1 = inference via NIM
- D2: YES Track B first
- E1: install Workbench
- E2: Docker Desktop
- F1: 0SxD (only IAM)
- F4: stop after 4 hours idle

These are defaults, not commitments. Sage overrides any of them when ready.
