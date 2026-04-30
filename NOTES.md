# NOTES

## What is good

- **Two-track architecture** -- can develop entirely free on Track B (build.nvidia.com + Workbench) and only spend on Track A when a workload truly needs sustained GPU.
- **Off-shelf-first** per system protocol -- every component is a published NVIDIA repo or official GCP doc. No custom code beyond the wiring scripts.
- **One-command teardown** -- `gcloud compute instances stop` -- so cost discipline is enforceable.
- **The YouTube-transcript skill is built and verified** -- 128-segment fetch worked on smoke test; ready to use across Sage's research workstreams (NotebookLM ingest, content review).
- **Repo inventory is precise** -- every entry has size + recency from `gh api` + clone-depth recommendation. Sage can stage the highest-signal-per-MB repos first.

## What is bad / risk

- **Pricing is approximate** -- the "as of 2026-04" rates in `08_COST_AND_REGION_GUIDE.md` need re-verification against the GCP Pricing Calculator before any commitment. Pricing can swing 20% region-to-region.
- **Two repos in foundation track marked NOASSERTION** (Megatron-LM, NeMo-Guardrails) -- check LICENSE before redistribution. These are widely known to be non-restrictive but are not auto-detected by GitHub.
- **One outdated repo** -- IsaacGymEnvs last pushed 2024-10-26. Likely superseded by IsaacLab (active). Confirm before relying on Isaac Gym.
- **Two extremely large repos** (TensorRT-LLM 1.86 GB, cuda-quantum 1.95 GB). Always sparse-checkout or `--depth 1`.
- **No actual GCP execution** -- everything is plan + scripts. The first time anything runs against billed infra, it must run with a budget alert active and a 4-hour idle timer.
- **Anthropic Explore subagents were used** for the heavy research (02, 03, 04, 07, 08). Sage flagged this as overrun on the CLI subscription. Future refreshes route via or_dispatch (kimi + deepseek) per the standing rule.
- **JD-ID discrepancy** carried over from the application work: GDrive PDF says `5107121008`; resume v3/v4 says `5159669008`. Not blocking for this NVIDIA plan but a flag for Sage's broader application work.

## Risk-mitigation defaults

- Always create the VM with `--maintenance-policy=TERMINATE`
- Always use `--metadata="install-nvidia-driver=True"` so first boot lands ready
- Always set a budget alert at 50% of cap before launching the first instance
- Always start on L4 (cheapest); upgrade to A100 / H100 only after the L4 path proves the workflow

## What Sage decides next morning

- Answer `09_OPEN_QUESTIONS.md`
- Confirm budget cap
- Confirm whether to push the `_publish_working/` snapshots into the repo (they shouldn't go to git; gitignored locally)
- Confirm priority list of NVIDIA tools to wire first (probably NIM Llama 3.1 + NeMo-Guardrails + GenerativeAIExamples)
