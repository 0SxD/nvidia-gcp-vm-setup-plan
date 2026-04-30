# GCP NVIDIA GPU -- Cost and Region Guide

**Date:** 2026-04-30 (verify current pricing via GCP Pricing Calculator before commitment)

## On-Demand Hourly Rates (approximate; us-central1)

| GPU Type | Memory | On-Demand $/hr | Spot $/hr | Notes |
|---|---|---|---|---|
| **L4** | 24 GB GDDR6 | ~$0.35-$0.50 | ~$0.10-$0.15 | Inference, RAG; G2 family |
| **T4** | 16 GB GDDR6 | ~$0.29-$0.40 | ~$0.09-$0.12 | General-purpose; widely available |
| **A100-40GB** | 40 GB HBM2 | ~$1.76-$2.50 | ~$0.53-$0.75 | A2 standard family |
| **A100-80GB** | 80 GB HBM2 | ~$2.65-$3.50 | ~$0.80-$1.05 | A2 ultra family |
| **H100-80GB** | 80 GB HBM3 | ~$2.95-$4.00 | ~$0.89-$1.20 | A3 family |
| **H200-80GB** | 141 GB HBM3e | ~$4.69-$6.50 | ~$1.41-$1.95 | Latest, limited availability |

**Always verify** via [Google Cloud Pricing Calculator](https://cloud.google.com/products/calculator). Pricing varies by region, commitment, and discount level.

**Source:** [Compute Engine GPU pricing](https://cloud.google.com/compute/gpus-pricing)

## Spot vs. On-Demand

- **Spot:** 60-91% cheaper, but can be preempted at any time. Pair with checkpointing logic.
- **On-Demand:** full rate, no preemption. Use for production inference with SLAs.

**Source:** [Spot instances on GCP](https://docs.cloud.google.com/compute/docs/instances/use-spot-instances)

## Regional Availability

| Region | L4 | T4 | A100 | H100 | H200 |
|---|---|---|---|---|---|
| us-central1 | ✓ | ✓ | ✓ | ✓ | Limited |
| us-east4 | ✓ | ✓ | ✓ | ✓ | Limited |
| us-west4 | ✓ | ✓ | -- | ✓ | Limited |
| europe-west4 | ✓ | ✓ | ✓ | ✓ | Limited |
| asia-southeast1 | ✓ | ✓ | -- | -- | -- |
| asia-northeast1 | ✓ | ✓ | ✓ | -- | -- |

H100/H200 availability is limited; check before designing multi-region deployment.

**Source:** [Compute regions and zones](https://docs.cloud.google.com/compute/docs/regions-zones/regions-zones)

## Quota Requirements

You cannot launch a GPU instance without sufficient quota.

1. Open [Cloud Console](https://console.cloud.google.com)
2. Navigate to **IAM & Admin > Quotas & System Limits**
3. Filter by region and resource type (e.g., "NVIDIA L4 GPUs")
4. Click **Edit Quotas**, enter target count, **Submit Request**

Approval typically takes 2-5 business days. H100/H200 requests may take longer.

**Source:** [View and manage quotas](https://docs.cloud.google.com/docs/quotas/view-manage-quotas)

## Cost Optimization

### Stop vs. Delete

- **Stop:** keeps disk; ~$0.10-$0.20/100 GB/month; restart in 2-5 min.
- **Delete:** removes everything; no ongoing cost.

For an L4 instance: stopping costs ~$0.20-$0.50/day in disk vs ~$8-$12/day running.

### Snapshots

Incremental snapshots (~$0.026/GB/month for standard) -- archive trained models, clone instances, recover.

**Source:** [Snapshots](https://docs.cloud.google.com/compute/docs/disks/snapshots)

### Sustained-Use Discounts (auto-applied)

| Uptime | Discount |
|---|---|
| 0-25% | 0% |
| 25-50% | 10% |
| 50-75% | 20% |
| 75-100% | 30% |

GPU SUDs are smaller (~5%); compute is the bigger SUD lever.

### Committed-Use Discounts

- 1-year: typically 20-35% off
- 3-year: typically 50-60% off

Resource-based; tied to region + machine family.

**Source:** [Committed-use discounts](https://docs.cloud.google.com/docs/cuds)

## Budget Alerts

1. Cloud Console -> Billing -> Budgets and Alerts
2. Create Budget; set monthly limit; choose Actual vs. Forecasted
3. Default thresholds: 50%, 90%, 100%
4. Alerts notify only -- they do NOT auto-stop spending. Use [quotas](https://docs.cloud.google.com/docs/quotas/view-manage-quotas) to enforce hard caps.

**Source:** [Budget alerts](https://docs.cloud.google.com/billing/docs/how-to/budgets)

## Worked Example -- 1-Week L4 Dev Sprint

- Instance: `n1-standard-4` + 1× L4
- Region: us-central1
- Usage: 8 hr/day × 5 days = 40 hr
- Disk: 100 GB pd-standard

| Component | Rate | Hours | Cost |
|---|---|---|---|
| n1-standard-4 | $0.19/hr | 40 | $7.60 |
| L4 GPU | $0.35/hr | 40 | $14.00 |
| Disk (100 GB pd-standard) | -- | 1 month | $0.10 |
| **Total** | | | **~$21.70** |

With spot (~70% off GPU): ~$12.00 total.

**Sources:**

- [Compute Engine GPU pricing](https://cloud.google.com/compute/gpus-pricing)
- [GCP Pricing Calculator](https://cloud.google.com/products/calculator)
- [Compute regions and zones](https://docs.cloud.google.com/compute/docs/regions-zones/regions-zones)
- [Spot instances](https://docs.cloud.google.com/compute/docs/instances/use-spot-instances)
- [Quotas](https://docs.cloud.google.com/docs/quotas/view-manage-quotas)
- [Committed-use discounts](https://docs.cloud.google.com/docs/cuds)
- [Budget alerts](https://docs.cloud.google.com/billing/docs/how-to/budgets)
- [Snapshots](https://docs.cloud.google.com/compute/docs/disks/snapshots)
